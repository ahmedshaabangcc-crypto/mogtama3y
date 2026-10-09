-- =====================================================================
-- Migration 0082 — «أدوات يومية»: prayer reminders as phone notifications.
--
-- The masjid tools (Quran, adhkar, qibla, Hijri calendar) are all on the
-- device. Only «تنبيه الصلاة» needs the server, so the reminder reaches
-- the phone while the app is closed:
--
--   * prayer_reminder_prefs: one row per user — where (lat/lng in Egypt)
--     and which prayers, how many minutes before the adhan (0/5/10/15).
--     Written only through set_prayer_reminders / clear_prayer_reminders.
--   * private.egypt_prayer_times(): the app's Egyptian-survey method
--     (lib/core/masjid/prayer_times.dart) ported to SQL — Fajr 19.5°,
--     Isha 17.5°, Asr shadow factor 1, Dhuhr +1 min, Egypt's clock with
--     summer time (backend tests compare it to the Dart results).
--   * prayer_reminder_queue: today's and tomorrow's due reminders, at most
--     one per prayer per user per day (the primary key) — only for users
--     with a registered push device.
--   * private.prayer_reminders_tick(): every minute (pg_cron) inserts a
--     notification for each due reminder; the 0055 trigger hands it to
--     the send-push Edge Function. Reminders more than 10 minutes late
--     are dropped, and reminder notifications are removed after 12 hours
--     so they don't pile up in the in-app list.
--
-- Without pg_cron nothing is scheduled and the app's in-app reminder keeps
-- working. Run after 0081. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ---------------------------------------------------------------- tables
create table if not exists public.prayer_reminder_prefs (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  lat double precision not null,
  lng double precision not null,
  offsets jsonb not null default '{}'::jsonb,
  label text check (label is null or length(label) <= 80),
  updated_at timestamptz not null default now(),
  constraint prayer_reminder_prefs_in_egypt check (lat between 21.5 and 32 and lng between 24.5 and 37.5)
);
alter table public.prayer_reminder_prefs enable row level security;
revoke all on public.prayer_reminder_prefs from anon, authenticated;
grant select on public.prayer_reminder_prefs to authenticated;
drop policy if exists "prayer_reminder_prefs: owner reads own" on public.prayer_reminder_prefs;
create policy "prayer_reminder_prefs: owner reads own" on public.prayer_reminder_prefs
  for select to authenticated using (user_id = auth.uid());

create table if not exists public.prayer_reminder_queue (
  user_id uuid not null references public.profiles(id) on delete cascade,
  day date not null,
  prayer text not null check (prayer in ('fajr', 'dhuhr', 'asr', 'maghrib', 'isha')),
  adhan_at timestamptz not null,
  due_at timestamptz not null,
  minutes_before int not null check (minutes_before in (0, 5, 10, 15)),
  sent_at timestamptz,
  primary key (user_id, day, prayer)
);
create index if not exists prayer_reminder_queue_due on public.prayer_reminder_queue (due_at) where sent_at is null;
alter table public.prayer_reminder_queue enable row level security;
revoke all on public.prayer_reminder_queue from anon, authenticated;

-- ------------------------------------------------------------ Egypt clock
-- Last <isodow> of a month (Friday = 5, Thursday = 4).
create or replace function private.mt_last_weekday(p_year int, p_month int, p_isodow int) returns date
language sql immutable as $$
  select d - (((extract(isodow from d)::int - p_isodow) % 7 + 7) % 7)
  from (select (make_date(p_year, p_month, 1) + interval '1 month' - interval '1 day')::date as d) x
$$;

-- Egyptian summer time on this Cairo calendar date: last Friday of April
-- to last Thursday of October, since 2023.
create or replace function private.egypt_dst_on(p_day date) returns boolean
language sql immutable as $$
  select case
    when extract(year from p_day) < 2023 then false
    when extract(month from p_day) < 4 or extract(month from p_day) > 10 then false
    when extract(month from p_day) between 5 and 9 then true
    when extract(month from p_day) = 4 then p_day >= private.mt_last_weekday(extract(year from p_day)::int, 4, 5)
    else p_day <= private.mt_last_weekday(extract(year from p_day)::int, 10, 4)
  end
$$;

-- Cairo wall clock of an instant.
create or replace function private.egypt_wall(p_at timestamptz) returns timestamp
language sql immutable as $$
  select case when private.egypt_dst_on((u + interval '2 hours')::date) and private.egypt_dst_on((u + interval '3 hours')::date)
              then u + interval '3 hours' else u + interval '2 hours' end
  from (select p_at at time zone 'UTC' as u) x
$$;

create or replace function private.egypt_today(p_at timestamptz) returns date
language sql immutable as $$ select private.egypt_wall(p_at)::date $$;

-- ------------------------------------------------------ prayer times (SQL)
create or replace function private.mt_fix(a double precision, b double precision) returns double precision
language sql immutable as $$
  select case when r < 0 then r + b else r end from (select a - b * floor(a / b) as r) x
$$;

-- Sun declination and equation of time (degrees / hours) at Julian date jd.
create or replace function private.mt_sun(jd double precision, out decl double precision, out eqt double precision)
language plpgsql immutable as $$
declare
  d double precision := jd - 2451545.0;
  g double precision := private.mt_fix(357.529 + 0.98560028 * d, 360);
  q double precision := private.mt_fix(280.459 + 0.98564736 * d, 360);
  l double precision := private.mt_fix(q + 1.915 * sind(g) + 0.020 * sind(2 * g), 360);
  e double precision := 23.439 - 0.00000036 * d;
  ra double precision := private.mt_fix(atan2d(cosd(e) * sind(l), cosd(l)) / 15, 24);
begin
  eqt := q / 15 - ra;
  decl := asind(sind(e) * sind(l));
end;
$$;

create or replace function private.mt_midday(jdate double precision, t double precision) returns double precision
language sql immutable as $$ select private.mt_fix(12 - (private.mt_sun(jdate + t)).eqt, 24) $$;

create or replace function private.mt_angle_time(jdate double precision, lat double precision, angle double precision, t double precision, ccw boolean)
returns double precision
language plpgsql immutable as $$
declare
  decl double precision := (private.mt_sun(jdate + t)).decl;
  noon double precision := private.mt_midday(jdate, t);
  cos_t double precision := (-sind(angle) - sind(decl) * sind(lat)) / (cosd(decl) * cosd(lat));
  tt double precision := acosd(greatest(-1.0, least(1.0, cos_t))) / 15;
begin
  return case when ccw then noon - tt else noon + tt end;
end;
$$;

create or replace function private.mt_asr(jdate double precision, lat double precision, t double precision) returns double precision
language plpgsql immutable as $$
declare
  decl double precision := (private.mt_sun(jdate + t)).decl;
begin
  return private.mt_angle_time(jdate, lat, -atand(1 / (1 + tand(abs(lat - decl)))), t, false);
end;
$$;

-- The Egyptian General Authority of Survey times for a Cairo calendar day
-- (same algorithm and rounding as lib/core/masjid/prayer_times.dart).
create or replace function private.egypt_prayer_times(p_day date, p_lat double precision, p_lng double precision)
returns table (prayer text, prayer_at timestamptz)
language plpgsql immutable as $$
declare
  y int := extract(year from p_day);
  m int := extract(month from p_day);
  dd int := extract(day from p_day);
  a int;
  b int;
  jdate double precision;
  t double precision[] := array[5, 6, 12, 13, 18, 18];
  p double precision[];
  names text[] := array['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];
  v double precision;
  base timestamptz := p_day::timestamp at time zone 'UTC';
begin
  if m <= 2 then
    y := y - 1;
    m := m + 12;
  end if;
  a := floor(y / 100.0);
  b := 2 - a + floor(a / 4.0);
  jdate := floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + dd + b - 1524.5 - p_lng / (15 * 24);
  for i in 1..2 loop
    p := array[t[1] / 24, t[2] / 24, t[3] / 24, t[4] / 24, t[5] / 24, t[6] / 24];
    t := array[
      private.mt_angle_time(jdate, p_lat, 19.5, p[1], true),
      private.mt_angle_time(jdate, p_lat, 0.833, p[2], true),
      private.mt_midday(jdate, p[3]),
      private.mt_asr(jdate, p_lat, p[4]),
      private.mt_angle_time(jdate, p_lat, 0.833, p[5], false),
      private.mt_angle_time(jdate, p_lat, 17.5, p[6], false)
    ];
  end loop;
  for k in 1..6 loop
    v := t[k] - p_lng / 15;
    if k = 3 then
      v := v + 1.0 / 60;
    end if;
    prayer := names[k];
    prayer_at := base + make_interval(mins => round((v * 60)::numeric)::int);
    return next;
  end loop;
end;
$$;

-- "4:08 ص" for an instant, on Egypt's clock.
create or replace function private.egypt_time12(p_at timestamptz) returns text
language sql immutable as $$
  select (case when extract(hour from w)::int % 12 = 0 then 12 else extract(hour from w)::int % 12 end)::text
         || ':' || lpad(extract(minute from w)::int::text, 2, '0')
         || case when extract(hour from w) < 12 then ' ص' else ' م' end
  from (select private.egypt_wall(p_at) as w) x
$$;

create or replace function private.prayer_name_ar(p text) returns text
language sql immutable as $$
  select case p when 'fajr' then 'الفجر' when 'dhuhr' then 'الظهر' when 'asr' then 'العصر'
                when 'maghrib' then 'المغرب' when 'isha' then 'العشاء' else p end
$$;

-- ------------------------------------------------------------- the queue
-- Queues today's and tomorrow's reminders (Cairo dates) for [p_user], or
-- for every subscribed user who has nothing queued for tomorrow yet.
create or replace function private.prayer_reminders_fill(p_user uuid default null, p_now timestamptz default now())
returns int
language plpgsql security definer set search_path = public as $$
declare
  r record;
  t record;
  v_today date := private.egypt_today(p_now);
  v_day date;
  v_n int := 0;
begin
  for r in
    select pr.* from public.prayer_reminder_prefs pr
    where (p_user is null or pr.user_id = p_user)
      and pr.offsets <> '{}'::jsonb
      and exists (select 1 from public.push_subscriptions s where s.user_id = pr.user_id)
      and (p_user is not null or not exists (
        select 1 from public.prayer_reminder_queue q where q.user_id = pr.user_id and q.day = v_today + 1))
  loop
    for g in 0..1 loop
      v_day := v_today + g;
      for t in select * from private.egypt_prayer_times(v_day, r.lat, r.lng) e where r.offsets ? e.prayer loop
        insert into public.prayer_reminder_queue (user_id, day, prayer, adhan_at, due_at, minutes_before)
        values (r.user_id, v_day, t.prayer, t.prayer_at, t.prayer_at - make_interval(mins => (r.offsets ->> t.prayer)::int), (r.offsets ->> t.prayer)::int)
        on conflict (user_id, day, prayer) do update
          set adhan_at = excluded.adhan_at, due_at = excluded.due_at, minutes_before = excluded.minutes_before
          where public.prayer_reminder_queue.sent_at is null;
        v_n := v_n + 1;
      end loop;
    end loop;
  end loop;
  return v_n;
end;
$$;

-- Every minute: send what's due (as notifications → Web Push), drop what's
-- stale, keep the queue and the notification list tidy.
create or replace function private.prayer_reminders_tick(p_now timestamptz default now())
returns int
language plpgsql security definer set search_path = public as $$
declare
  q record;
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
      insert into public.notifications (user_id, title, body, deep_link)
      values (
        q.user_id,
        case when q.minutes_before = 0 then 'حان الآن موعد أذان ' || private.prayer_name_ar(q.prayer)
             else private.prayer_name_ar(q.prayer) || ' بعد ' || q.minutes_before || case when q.minutes_before <= 10 then ' دقايق' else ' دقيقة' end end,
        'أذان ' || private.prayer_name_ar(q.prayer) || ' ' || private.egypt_time12(q.adhan_at),
        '/masjid/tools/reminders'
      );
      v_n := v_n + 1;
    end if;
  end loop;

  delete from public.prayer_reminder_queue where day < private.egypt_today(p_now) - 1;
  delete from public.notifications where deep_link = '/masjid/tools/reminders' and created_at < p_now - interval '12 hours';
  return v_n;
end;
$$;

-- ------------------------------------------------------------------ RPCs
create or replace function public.set_prayer_reminders(p_lat double precision, p_lng double precision, p_offsets jsonb, p_label text default null)
returns void
language plpgsql security definer set search_path = public as $$
declare
  v_clean jsonb;
  v_keys int;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_lat is null or p_lng is null or p_lat not between 21.5 and 32 or p_lng not between 24.5 and 37.5 then
    raise exception 'تنبيه الصلاة متاح للأماكن داخل مصر بس';
  end if;
  if p_offsets is null or jsonb_typeof(p_offsets) <> 'object' then
    raise exception 'إعدادات التنبيه غير صحيحة';
  end if;
  select count(*) into v_keys from jsonb_object_keys(p_offsets);
  select coalesce(jsonb_object_agg(key, value::int), '{}'::jsonb) into v_clean
    from jsonb_each_text(p_offsets)
   where key in ('fajr', 'dhuhr', 'asr', 'maghrib', 'isha') and value in ('0', '5', '10', '15');
  if (select count(*) from jsonb_object_keys(v_clean)) <> v_keys then
    raise exception 'إعدادات التنبيه غير صحيحة';
  end if;

  delete from public.prayer_reminder_queue where user_id = auth.uid() and sent_at is null;
  if v_clean = '{}'::jsonb then
    delete from public.prayer_reminder_prefs where user_id = auth.uid();
    return;
  end if;
  insert into public.prayer_reminder_prefs (user_id, lat, lng, offsets, label, updated_at)
  values (auth.uid(), p_lat, p_lng, v_clean, left(nullif(trim(p_label), ''), 80), now())
  on conflict (user_id) do update
    set lat = excluded.lat, lng = excluded.lng, offsets = excluded.offsets, label = excluded.label, updated_at = now();
  perform private.prayer_reminders_fill(auth.uid());
end;
$$;

create or replace function public.clear_prayer_reminders() returns void
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  delete from public.prayer_reminder_queue where user_id = auth.uid() and sent_at is null;
  delete from public.prayer_reminder_prefs where user_id = auth.uid();
end;
$$;

create or replace function public.my_prayer_reminders()
returns table (lat double precision, lng double precision, offsets jsonb, label text, updated_at timestamptz)
language sql stable security definer set search_path = public as $$
  select lat, lng, offsets, label, updated_at from public.prayer_reminder_prefs where user_id = auth.uid()
$$;

-- ---------------------------------------------------------------- grants
do $$
declare f text;
begin
  foreach f in array array[
    'private.mt_last_weekday(int, int, int)', 'private.egypt_dst_on(date)', 'private.egypt_wall(timestamptz)',
    'private.egypt_today(timestamptz)', 'private.mt_fix(double precision, double precision)', 'private.mt_sun(double precision)',
    'private.mt_midday(double precision, double precision)',
    'private.mt_angle_time(double precision, double precision, double precision, double precision, boolean)',
    'private.mt_asr(double precision, double precision, double precision)',
    'private.egypt_prayer_times(date, double precision, double precision)', 'private.egypt_time12(timestamptz)',
    'private.prayer_name_ar(text)', 'private.prayer_reminders_fill(uuid, timestamptz)', 'private.prayer_reminders_tick(timestamptz)'
  ] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
  end loop;
  foreach f in array array[
    'public.set_prayer_reminders(double precision, double precision, jsonb, text)',
    'public.clear_prayer_reminders()', 'public.my_prayer_reminders()'
  ] loop
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end;
$$;

-- -------------------------------------------------------------- schedule
do $$
begin
  create extension if not exists pg_cron;
exception when others then
  raise notice 'pg_cron not available — prayer reminders stay in-app only: %', sqlerrm;
end;
$$;

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    return;
  end if;
  execute $sql$select cron.schedule('prayer-reminders', '* * * * *', 'select private.prayer_reminders_tick()')$sql$;
exception when others then
  raise notice 'could not schedule prayer_reminders_tick: %', sqlerrm;
end;
$$;
