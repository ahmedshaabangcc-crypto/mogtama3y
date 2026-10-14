-- =====================================================================
-- Migration 0090 — phone notifications that actually arrive, and the
-- adhan as the prayer notification.
--
-- Why pushes said {"sent":0}: this project has "Automatically expose new
-- tables" OFF (backend/supabase-project.md, 0007), so no API role gets
-- table privileges unless a migration grants them — and none ever granted
-- service_role anything on notifications / push_subscriptions. The
-- send-push Edge Function reads both through PostgREST with the service
-- role key: "permission denied" (42501) → no row → {"sent":0}, silently.
-- (RLS bypass doesn't help: GRANTs are checked before RLS.)
--
--   * service_role may read notifications and read/delete push devices.
--   * The trigger now hands send-push the notification itself and the
--     user's devices, so the function no longer depends on reading the
--     tables at all (it only deletes devices the browser says are gone).
--   * «تنبيه الصلاة»: per prayer the user picks the notification style —
--     'quiet' (a normal notification), 'full' (the whole adhan) or
--     'takbir' (the opening takbir only) — and a muezzin voice. At adhan
--     time the notification links to /#/masjid/tools/reminders?adhan=<prayer>
--     &style=…&voice=…; tapping it opens the app, which plays that adhan.
--     (The old link '/masjid/tools/reminders' had no '#', so on GitHub
--     Pages a tapped reminder opened a 404 page instead of the app.)
--     (Web Push can't play a custom sound while the app is closed — the
--     phone plays its own notification sound.)
--
-- Run after 0088 (and 0089 if present). Safe to re-run.
-- =====================================================================

-- --------------------------------------------------------- privileges
grant usage on schema public to service_role;
grant select on public.notifications to service_role;
grant select, delete on public.push_subscriptions to service_role;

-- ----------------------------------------- push: payload in the request
create or replace function public.notify_push() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  s record;
  v_subs jsonb;
begin
  select jsonb_agg(jsonb_build_object('id', p.id, 'endpoint', p.endpoint, 'p256dh', p.p256dh, 'auth', p.auth, 'app', p.app))
    into v_subs
    from public.push_subscriptions p where p.user_id = new.user_id;
  if v_subs is null then
    return new;
  end if;
  if not exists (select 1 from pg_namespace where nspname = 'net') then
    return new;
  end if;
  select * into s from private.push_settings where id;
  if not found then
    return new;
  end if;
  execute 'select net.http_post(url := $1, body := $2, headers := $3, timeout_milliseconds := 15000)'
    using s.function_url,
          jsonb_build_object(
            'notification_id', new.id,
            'notification', jsonb_build_object('user_id', new.user_id, 'title', new.title, 'body', new.body, 'deep_link', new.deep_link),
            'subscriptions', v_subs),
          jsonb_build_object('Content-Type', 'application/json', 'x-push-secret', s.secret);
  return new;
exception when others then
  return new; -- a push problem must never block the notification itself
end;
$$;
revoke execute on function public.notify_push() from public, anon, authenticated;

-- ------------------------------------------- adhan style & muezzin voice
alter table public.prayer_reminder_prefs add column if not exists styles jsonb not null default '{}'::jsonb;
alter table public.prayer_reminder_prefs add column if not exists voice text not null default 'madinah';
alter table public.prayer_reminder_prefs drop constraint if exists prayer_reminder_prefs_voice_ok;
alter table public.prayer_reminder_prefs add constraint prayer_reminder_prefs_voice_ok
  check (voice in ('madinah', 'calm', 'short'));

-- {"fajr":"full","asr":"takbir"} (missing prayers → 'quiet') + a voice.
create or replace function public.set_prayer_reminder_style(p_styles jsonb, p_voice text default 'madinah')
returns void
language plpgsql security definer set search_path = public as $$
declare
  v_clean jsonb;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_styles is null or jsonb_typeof(p_styles) <> 'object' or coalesce(p_voice, '') not in ('madinah', 'calm', 'short') then
    raise exception 'إعدادات صوت الأذان غير صحيحة';
  end if;
  select coalesce(jsonb_object_agg(key, value), '{}'::jsonb) into v_clean
    from jsonb_each_text(p_styles)
   where key in ('fajr', 'dhuhr', 'asr', 'maghrib', 'isha') and value in ('quiet', 'full', 'takbir');
  if (select count(*) from jsonb_object_keys(v_clean)) <> (select count(*) from jsonb_object_keys(p_styles)) then
    raise exception 'إعدادات صوت الأذان غير صحيحة';
  end if;
  update public.prayer_reminder_prefs set styles = v_clean, voice = p_voice, updated_at = now()
   where user_id = auth.uid();
end;
$$;
revoke execute on function public.set_prayer_reminder_style(jsonb, text) from public, anon;
grant execute on function public.set_prayer_reminder_style(jsonb, text) to authenticated;

-- The 0087 sender, with the adhan link (and 🕌) at adhan time.
create or replace function private.prayer_reminders_tick(p_now timestamptz default now())
returns int
language plpgsql security definer set search_path = public as $$
declare
  q record;
  pr record;
  v_n int := 0;
begin
  perform private.prayer_reminders_fill(null, p_now);

  for q in
    select * from public.prayer_reminder_queue
    where sent_at is null and due_at <= p_now
    order by due_at
    limit 5000
    for update skip locked
  loop
    update public.prayer_reminder_queue set sent_at = p_now
     where user_id = q.user_id and day = q.day and prayer = q.prayer;
    if q.due_at > p_now - interval '10 minutes'
       and exists (select 1 from public.push_subscriptions s where s.user_id = q.user_id) then
      select p.tz, p.styles, p.voice into pr from public.prayer_reminder_prefs p where p.user_id = q.user_id;
      insert into public.notifications (user_id, title, body, deep_link)
      values (
        q.user_id,
        case when q.minutes_before = 0 then 'حان الآن موعد أذان ' || private.prayer_name_ar(q.prayer) || ' 🕌'
             else private.prayer_name_ar(q.prayer) || ' بعد ' || q.minutes_before || case when q.minutes_before <= 10 then ' دقايق' else ' دقيقة' end end,
        'أذان ' || private.prayer_name_ar(q.prayer) || ' ' || private.mt_time12(q.adhan_at, coalesce(pr.tz, 'Africa/Cairo')),
        case when q.minutes_before = 0
             then '/#/masjid/tools/reminders?adhan=' || q.prayer
                  || '&style=' || coalesce(pr.styles ->> q.prayer, 'quiet')
                  || '&voice=' || coalesce(pr.voice, 'madinah')
             else '/#/masjid/tools/reminders' end
      );
      v_n := v_n + 1;
    end if;
  end loop;

  delete from public.prayer_reminder_queue where day < (p_now at time zone 'UTC')::date - 2;
  delete from public.notifications
   where (deep_link like '/masjid/tools/reminders%' or deep_link like '/#/masjid/tools/reminders%')
     and created_at < p_now - interval '12 hours';
  return v_n;
end;
$$;
revoke execute on function private.prayer_reminders_tick(timestamptz) from public, anon, authenticated;
