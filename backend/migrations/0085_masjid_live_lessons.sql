-- =====================================================================
-- Migration 0085 — «مسجدي»: «دروس أونلاين» — live audio / video lessons
-- from a mosque, on LiveKit Cloud. The lesson is live and NOT recorded:
-- nothing of the audio, video or the in-room chat is stored here.
--
--   * mosque_live_sessions: title, sheikh, audience (رجال / سيدات /
--     أطفال / الكل — informational), scheduled_at, duration, mode
--     ('audio' = very low bandwidth, or 'video'), visibility ('members' =
--     the mosque's members only, or 'public' = any signed-in user),
--     status scheduled → live → ended (or cancelled), a unique LiveKit
--     room name and max_participants (enforced by LiveKit — the
--     livekit-token Edge Function creates the room with it).
--   * Only the admins of a VERIFIED mosque with the 'lessons' permission
--     (masjid_can) create / edit / cancel / start / end, and they are the
--     lesson's hosts. At most one live lesson per mosque at a time.
--   * masjid_live_join_check(session) — called by the Edge Function AS
--     the user before it mints a LiveKit token: host / speaker / listener,
--     or a denial with a reason. Listeners only need to be signed in
--     (members-only lessons: a member). It records the participant and
--     returns an opaque per-lesson participant id that is used as the
--     LiveKit identity (never the account id — 0083's nicknames stay
--     unlinkable) and the display name (the per-mosque chat nickname,
--     else the profile name; hosts: their real name).
--   * Hands: a listener raises a hand (needs a VERIFIED phone, 0074 /
--     0083 rule for speaking); a host promotes to speaker / demotes /
--     removes (removed = can't re-join that lesson). Max 6 speakers.
--   * Notifications to the mosque's followers (members follow too): when
--     a lesson is scheduled (0080's regular limits — 2 h apart, 4 / day)
--     and when it goes live (0080's urgent limit — 10 min apart — plus
--     once per lesson and at most 3 live notifications per mosque a day).
--   * Lists: per mosque (upcoming + live; past too for its managers) and
--     «دروس أونلاين دلوقتي» — live now and the next 7 days from mosques
--     near the caller and the ones they joined / follow / manage, only
--     those the caller can join.
--   * Stale lessons: a live lesson 3 h past its end, or a scheduled one
--     never started 1 h past its end, is hidden everywhere and closed by
--     masjid_live_expire() (pg_cron every 15 min when available).
--
-- Tables have RLS on and no grants: only the RPCs below touch them.
-- Run after 0084. Safe to re-run.
-- =====================================================================

-- ------------------------------------------------------------- tables
create table if not exists public.mosque_live_sessions (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 2 and 120),
  sheikh text check (sheikh is null or char_length(sheikh) <= 80),
  description text check (description is null or char_length(description) <= 500),
  audience text not null default 'all' check (audience in ('men', 'women', 'kids', 'all')),
  scheduled_at timestamptz not null,
  duration_minutes smallint not null default 60 check (duration_minutes between 10 and 240),
  status text not null default 'scheduled' check (status in ('scheduled', 'live', 'ended', 'cancelled')),
  mode text not null default 'audio' check (mode in ('audio', 'video')),
  visibility text not null default 'members' check (visibility in ('members', 'public')),
  max_participants int not null default 300 check (max_participants between 2 and 1000),
  room_name text not null unique check (room_name ~ '^mlive_[a-z0-9]{16,40}$'),
  created_by uuid references public.profiles(id) on delete set null,
  started_at timestamptz,
  ended_at timestamptz,
  live_notified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists mosque_live_sessions_mosque on public.mosque_live_sessions (mosque_id, scheduled_at);
create index if not exists mosque_live_sessions_open on public.mosque_live_sessions (status, scheduled_at) where status in ('scheduled', 'live');
create unique index if not exists mosque_live_sessions_one_live on public.mosque_live_sessions (mosque_id) where status = 'live';

-- Who joined a lesson, raised a hand, was made a speaker or removed.
-- id = the LiveKit identity (opaque, per lesson).
create table if not exists public.mosque_live_participants (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.mosque_live_sessions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  is_host boolean not null default false,
  hand_raised_at timestamptz,
  hand_count int not null default 0,
  is_speaker boolean not null default false,
  removed_at timestamptz,
  removed_by uuid references public.profiles(id) on delete set null,
  joined_at timestamptz not null default now(),
  last_join_at timestamptz not null default now(),
  unique (session_id, user_id)
);
create index if not exists mosque_live_participants_hands on public.mosque_live_participants (session_id) where hand_raised_at is not null or is_speaker;

alter table public.mosque_live_sessions enable row level security;
alter table public.mosque_live_participants enable row level security;
revoke all on public.mosque_live_sessions, public.mosque_live_participants from public, anon, authenticated;

-- ------------------------------------------------------------ helpers
-- Past its end and never closed (see the header).
create or replace function public._masjid_live_stale(s public.mosque_live_sessions) returns boolean
language sql stable as $$
  select case
    when s.status = 'live' then coalesce(s.started_at, s.scheduled_at) + make_interval(mins => s.duration_minutes) + interval '3 hours' < now()
    when s.status = 'scheduled' then s.scheduled_at + make_interval(mins => s.duration_minutes) + interval '1 hour' < now()
    else false end;
$$;

-- The session as the app shows it (no room name).
create or replace function public._masjid_live_json(s public.mosque_live_sessions, p_mosque_name text) returns jsonb
language sql stable as $$
  select jsonb_build_object(
    'id', s.id, 'mosque_id', s.mosque_id, 'mosque_name', p_mosque_name, 'title', s.title, 'sheikh', s.sheikh,
    'description', s.description, 'audience', s.audience, 'scheduled_at', s.scheduled_at,
    'duration_minutes', s.duration_minutes, 'status', s.status, 'mode', s.mode, 'visibility', s.visibility,
    'max_participants', s.max_participants, 'started_at', s.started_at, 'ended_at', s.ended_at);
$$;

-- Can the caller (signed in) join this lesson as a listener at least?
create or replace function public._masjid_live_can_view(s public.mosque_live_sessions) returns boolean
language sql stable security definer set search_path = public as $$
  select auth.uid() is not null and (
    s.visibility = 'public'
    or public.masjid_is_member(s.mosque_id)
    or public.masjid_can(s.mosque_id, 'lessons'));
$$;

-- Validated fields from the app's jsonb (create / update).
create or replace function public._masjid_live_fields(p jsonb, p_creating boolean)
returns table (title text, sheikh text, description text, audience text, scheduled_at timestamptz,
               duration_minutes smallint, mode text, visibility text, max_participants int)
language plpgsql stable set search_path = public as $$
declare
  v_title text := btrim(coalesce(p->>'title', ''));
  v_at timestamptz;
  v_dur int := coalesce(nullif(p->>'duration_minutes', '')::int, 60);
  v_max int := coalesce(nullif(p->>'max_participants', '')::int, 300);
begin
  if char_length(v_title) < 2 or char_length(v_title) > 120 then
    raise exception 'اكتب عنوان الدرس (من 2 لـ 120 حرف)';
  end if;
  begin
    v_at := coalesce(nullif(p->>'scheduled_at', '')::timestamptz, now());
  exception when others then
    raise exception 'ميعاد الدرس مش مظبوط';
  end;
  if v_at < now() - interval '10 minutes' then
    raise exception 'ميعاد الدرس فات — اختار ميعاد جاي';
  end if;
  if v_at > now() + interval '60 days' then
    raise exception 'تقدر تحدد ميعاد لحد شهرين قدام بس';
  end if;
  if v_dur < 10 or v_dur > 240 then
    raise exception 'مدة الدرس من 10 دقايق لـ 4 ساعات';
  end if;
  if v_max < 2 or v_max > 1000 then
    raise exception 'أقصى عدد من 2 لـ 1000';
  end if;
  if coalesce(p->>'audience', 'all') not in ('men', 'women', 'kids', 'all') then
    raise exception 'اختار الدرس لمين';
  end if;
  if coalesce(p->>'mode', 'audio') not in ('audio', 'video') then
    raise exception 'اختار صوت بس أو صوت وصورة';
  end if;
  if coalesce(p->>'visibility', 'members') not in ('members', 'public') then
    raise exception 'اختار مين يقدر يحضر';
  end if;
  if char_length(coalesce(p->>'sheikh', '')) > 80 or char_length(coalesce(p->>'description', '')) > 500 then
    raise exception 'الكلام طويل — اختصر شوية';
  end if;
  return query select v_title, nullif(btrim(coalesce(p->>'sheikh', '')), ''), nullif(btrim(coalesce(p->>'description', '')), ''),
    coalesce(p->>'audience', 'all'), v_at, v_dur::smallint, coalesce(p->>'mode', 'audio'),
    coalesce(p->>'visibility', 'members'), v_max;
end;
$$;

-- Lock a session the caller may manage (lessons permission on its mosque).
create or replace function public._masjid_live_manage(p_session uuid) returns public.mosque_live_sessions
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into s from public.mosque_live_sessions where id = p_session for update;
  if s.id is null then
    raise exception 'الدرس مش موجود';
  end if;
  if not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  return s;
end;
$$;

-- «بدأ الآن»: once per lesson, ≤ 3 per mosque a day, 0080's urgent spacing.
create or replace function public._masjid_live_notify_live(s public.mosque_live_sessions) returns int
language plpgsql security definer set search_path = public as $$
declare
  v_name text;
  n int;
begin
  if s.live_notified_at is not null then
    return 0;
  end if;
  if (select count(*) from public.mosque_live_sessions x
      where x.mosque_id = s.mosque_id and x.live_notified_at > now() - interval '24 hours') >= 3 then
    return 0;
  end if;
  select name into v_name from public.mosques where id = s.mosque_id;
  n := public._masjid_notify_followers(s.mosque_id, true, 'درس مباشر دلوقتي — ' || v_name,
         s.title || coalesce(' مع ' || s.sheikh, '') || ' — ادخل واسمع من موبايلك');
  update public.mosque_live_sessions set live_notified_at = now() where id = s.id;
  return n;
end;
$$;

revoke execute on function public._masjid_live_stale(public.mosque_live_sessions) from public, anon, authenticated;
revoke execute on function public._masjid_live_json(public.mosque_live_sessions, text) from public, anon, authenticated;
revoke execute on function public._masjid_live_can_view(public.mosque_live_sessions) from public, anon, authenticated;
revoke execute on function public._masjid_live_fields(jsonb, boolean) from public, anon, authenticated;
revoke execute on function public._masjid_live_manage(uuid) from public, anon, authenticated;
revoke execute on function public._masjid_live_notify_live(public.mosque_live_sessions) from public, anon, authenticated;

-- ===================================================== manage (admins)

create or replace function public.masjid_live_create(p_mosque uuid, p jsonb) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  f record;
  v_id uuid;
  v_name text;
begin
  if not public.masjid_can(p_mosque, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  select * into f from public._masjid_live_fields(coalesce(p, '{}'::jsonb), true);
  if (select count(*) from public.mosque_live_sessions
      where mosque_id = p_mosque and created_at > now() - interval '24 hours') >= 10 then
    raise exception 'ضفت دروس كتير النهارده، كمّل بكرة';
  end if;
  if (select count(*) from public.mosque_live_sessions
      where mosque_id = p_mosque and status in ('scheduled', 'live')) >= 20 then
    raise exception 'عندك 20 درس جاي — استنى لما يخلصوا أو الغي حاجة';
  end if;
  insert into public.mosque_live_sessions (mosque_id, title, sheikh, description, audience, scheduled_at, duration_minutes,
                                           mode, visibility, max_participants, room_name, created_by)
  values (p_mosque, f.title, f.sheikh, f.description, f.audience, f.scheduled_at, f.duration_minutes,
          f.mode, f.visibility, f.max_participants, 'mlive_' || replace(gen_random_uuid()::text, '-', ''), auth.uid())
  returning id into v_id;
  -- Followers hear about it (0080's regular limits) — unless it starts
  -- right away: «بدأ الآن» comes with the start.
  if f.scheduled_at > now() + interval '15 minutes' then
    select name into v_name from public.mosques where id = p_mosque;
    perform public._masjid_notify_followers(p_mosque, false, 'درس أونلاين جديد — ' || v_name,
      f.title || coalesce(' مع ' || f.sheikh, '') || ' — ' ||
      to_char(f.scheduled_at at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI'));
  end if;
  return v_id;
end;
$$;

create or replace function public.masjid_live_update(p_session uuid, p jsonb) returns void
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  f record;
begin
  s := public._masjid_live_manage(p_session);
  if s.status <> 'scheduled' then
    raise exception 'الدرس بدأ أو خلص — مينفعش يتعدّل';
  end if;
  select * into f from public._masjid_live_fields(coalesce(p, '{}'::jsonb), false);
  update public.mosque_live_sessions set
    title = f.title, sheikh = f.sheikh, description = f.description, audience = f.audience,
    scheduled_at = f.scheduled_at, duration_minutes = f.duration_minutes, mode = f.mode,
    visibility = f.visibility, max_participants = f.max_participants, updated_at = now()
  where id = p_session;
end;
$$;

create or replace function public.masjid_live_cancel(p_session uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
begin
  s := public._masjid_live_manage(p_session);
  if s.status <> 'scheduled' then
    raise exception 'الدرس بدأ أو خلص — لو شغال اضغط «إنهاء الدرس»';
  end if;
  update public.mosque_live_sessions set status = 'cancelled', ended_at = now(), updated_at = now() where id = p_session;
end;
$$;

-- scheduled → live (any time before its end). Returns the session json.
create or replace function public.masjid_live_start(p_session uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
begin
  s := public._masjid_live_manage(p_session);
  if s.status = 'live' then
    return public._masjid_live_json(s, null);
  end if;
  if s.status <> 'scheduled' or public._masjid_live_stale(s) then
    raise exception 'الدرس ده خلص أو اتلغى';
  end if;
  if s.scheduled_at > now() + interval '1 hour' then
    raise exception 'تقدر تبدأ الدرس قبل ميعاده بساعة بالكتير — عدّل الميعاد لو عايز تبدأ دلوقتي';
  end if;
  -- One live lesson per mosque: a forgotten (stale) one is closed first.
  update public.mosque_live_sessions x set status = 'ended', ended_at = now(), updated_at = now()
   where x.mosque_id = s.mosque_id and x.status = 'live' and x.id <> s.id and public._masjid_live_stale(x);
  if exists (select 1 from public.mosque_live_sessions x where x.mosque_id = s.mosque_id and x.status = 'live' and x.id <> s.id) then
    raise exception 'فيه درس تاني شغال دلوقتي في المسجد — أنهيه الأول';
  end if;
  update public.mosque_live_sessions set status = 'live', started_at = now(), updated_at = now()
   where id = p_session returning * into s;
  perform public._masjid_live_notify_live(s);
  return public._masjid_live_json(s, null);
end;
$$;

create or replace function public.masjid_live_end(p_session uuid) returns text
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
begin
  s := public._masjid_live_manage(p_session);
  if s.status = 'scheduled' then
    raise exception 'الدرس لسه مابدأش — تقدر تلغيه';
  end if;
  if s.status = 'live' then
    update public.mosque_live_sessions set status = 'ended', ended_at = now(), updated_at = now() where id = p_session;
  end if;
  update public.mosque_live_participants set hand_raised_at = null, is_speaker = false where session_id = p_session;
  return s.room_name;
end;
$$;

-- Close what was forgotten (cron / service / super admin).
create or replace function public.masjid_live_expire() returns int
language plpgsql security definer set search_path = public as $$
declare
  n int;
begin
  if auth.uid() is not null and not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  update public.mosque_live_sessions s
     set status = case when s.status = 'live' then 'ended' else 'cancelled' end, ended_at = now(), updated_at = now()
   where s.status in ('scheduled', 'live') and public._masjid_live_stale(s);
  get diagnostics n = row_count;
  return n;
end;
$$;

-- ============================================================ browse

-- A mosque's lessons: upcoming + live; with p_include_past its managers
-- also get the last 30 days' ended / cancelled ones.
create or replace function public.masjid_live_sessions(p_mosque uuid, p_include_past boolean default false)
returns setof jsonb
language plpgsql stable security definer set search_path = public as $$
declare
  v_manage boolean := public.masjid_can(p_mosque, 'lessons');
  v_name text;
begin
  select name into v_name from public.mosques where id = p_mosque;
  return query
  select public._masjid_live_json(s, v_name) || jsonb_build_object(
           'can_join', public._masjid_live_can_view(s),
           'is_host', v_manage,
           'stale', public._masjid_live_stale(s))
  from public.mosque_live_sessions s
  where s.mosque_id = p_mosque
    and ((s.status in ('scheduled', 'live') and not public._masjid_live_stale(s))
         or (v_manage and coalesce(p_include_past, false) and s.created_at > now() - interval '30 days'))
  order by (s.status = 'live' and not public._masjid_live_stale(s)) desc,
           (s.status = 'scheduled' and not public._masjid_live_stale(s)) desc,
           case when s.status in ('scheduled', 'live') then s.scheduled_at end asc,
           s.scheduled_at desc
  limit 60;
end;
$$;

-- «دروس أونلاين دلوقتي»: live now + the next 7 days, from mosques within
-- p_km of the caller and the ones they joined / follow / manage — only
-- lessons the caller can join (guests: public ones, to sign in for).
create or replace function public.masjid_live_feed(
  p_lat double precision default null, p_lng double precision default null, p_km double precision default 10, p_limit int default 20
) returns setof jsonb
language sql stable security definer set search_path = public as $$
  with box as (
    select least(greatest(coalesce(p_km, 10), 0.5), 50) as km
  ), ms as (
    select m.id, m.name,
           case when p_lat is not null and p_lng is not null
                then 111.195 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) end as dist,
           auth.uid() is not null and (
             exists (select 1 from public.mosque_members x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_follows x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_admins x where x.mosque_id = m.id and x.user_id = auth.uid())) as mine
    from public.mosques m, box
    where m.id in (select s.mosque_id from public.mosque_live_sessions s where s.status in ('scheduled', 'live'))
      and ((p_lat is not null and p_lng is not null
            and m.lat between p_lat - box.km / 111.0 and p_lat + box.km / 111.0
            and m.lng between p_lng - box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2))
                          and p_lng + box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2)))
           or (auth.uid() is not null and (
             exists (select 1 from public.mosque_members x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_follows x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_admins x where x.mosque_id = m.id and x.user_id = auth.uid()))))
  )
  select public._masjid_live_json(s, ms.name) || jsonb_build_object(
           'distance_km', ms.dist, 'my_mosque', ms.mine,
           'can_join', auth.uid() is not null,
           'is_host', public.masjid_can(s.mosque_id, 'lessons'))
  from public.mosque_live_sessions s
  join ms on ms.id = s.mosque_id
  where s.status in ('scheduled', 'live')
    and not public._masjid_live_stale(s)
    and (s.status = 'live' or s.scheduled_at < now() + interval '7 days')
    and (s.visibility = 'public'
         or (auth.uid() is not null and (public.masjid_is_member(s.mosque_id) or public.masjid_can(s.mosque_id, 'lessons'))))
  order by (s.status = 'live') desc, ms.mine desc, s.scheduled_at, ms.dist nulls last
  limit least(greatest(coalesce(p_limit, 20), 1), 50);
$$;

-- ======================================================== in the room

-- Called by the livekit-token Edge Function as the user. Returns
--   { ok: true, role: host|speaker|listener, identity, name, room,
--     can_speak, session: {…} }
-- or { ok: false, reason, message, session? }.
create or replace function public.masjid_live_join_check(p_session uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_mosque text;
  v_host boolean;
  v_p public.mosque_live_participants;
  v_name text;
  v_verified boolean;
  v_role text;
  v_info jsonb;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null then
    return jsonb_build_object('ok', false, 'reason', 'not_found', 'message', 'الدرس ده مش موجود');
  end if;
  select name into v_mosque from public.mosques where id = s.mosque_id;
  v_info := public._masjid_live_json(s, v_mosque);
  if auth.uid() is null then
    return jsonb_build_object('ok', false, 'reason', 'sign_in', 'message', 'سجّل دخول الأول عشان تحضر الدرس', 'session', v_info);
  end if;
  v_host := public.masjid_can(s.mosque_id, 'lessons');
  if s.status = 'cancelled' then
    return jsonb_build_object('ok', false, 'reason', 'cancelled', 'message', 'الدرس ده اتلغى', 'session', v_info);
  end if;
  if s.status = 'ended' or public._masjid_live_stale(s) then
    return jsonb_build_object('ok', false, 'reason', 'ended', 'message', 'الدرس خلص — الدروس المباشرة مش بتتسجّل', 'session', v_info);
  end if;
  if not v_host and s.visibility = 'members' and not public.masjid_is_member(s.mosque_id) then
    return jsonb_build_object('ok', false, 'reason', 'members_only', 'message', 'الدرس ده لأعضاء المسجد بس — انضم للمسجد الأول', 'session', v_info);
  end if;
  if s.status = 'scheduled' then
    return jsonb_build_object('ok', false, 'reason', 'not_live',
      'message', case when v_host then 'الدرس لسه مابدأش — اضغط «ابدأ الدرس»' else 'الدرس لسه مابدأش' end,
      'is_host', v_host, 'session', v_info);
  end if;

  select * into v_p from public.mosque_live_participants where session_id = s.id and user_id = auth.uid();
  if v_p.removed_at is not null and not v_host then
    return jsonb_build_object('ok', false, 'reason', 'removed', 'message', 'إدارة المسجد طلّعتك من الدرس ده', 'session', v_info);
  end if;
  if v_p.id is null then
    if not v_host and (select count(*) from public.mosque_live_participants
                       where user_id = auth.uid() and joined_at > now() - interval '1 hour') >= 30 then
      return jsonb_build_object('ok', false, 'reason', 'rate', 'message', 'دخلت دروس كتير في وقت قليل، استنى شوية', 'session', v_info);
    end if;
    insert into public.mosque_live_participants (session_id, user_id, is_host)
    values (s.id, auth.uid(), v_host)
    on conflict (session_id, user_id) do update set last_join_at = now()
    returning * into v_p;
  else
    update public.mosque_live_participants set last_join_at = now(), is_host = v_host,
           removed_at = case when v_host then null else removed_at end
     where id = v_p.id returning * into v_p;
  end if;

  select (p.phone_verified_at is not null or public.is_super_admin()),
         case when v_host then coalesce(nullif(btrim(p.full_name), ''), 'إدارة المسجد')
              else coalesce(n.nickname, nullif(btrim(p.full_name), ''), 'مستمع') end
    into v_verified, v_name
  from public.profiles p
  left join public.mosque_chat_nicknames n on n.mosque_id = s.mosque_id and n.user_id = p.id
  where p.id = auth.uid();

  v_role := case when v_host then 'host' when v_p.is_speaker and v_verified then 'speaker' else 'listener' end;
  return jsonb_build_object(
    'ok', true, 'role', v_role, 'identity', v_p.id::text, 'name', left(coalesce(v_name, 'مستمع'), 60),
    'room', s.room_name, 'can_speak', v_verified, 'hand_raised', v_p.hand_raised_at is not null,
    'session', v_info);
end;
$$;

-- Raise / lower the caller's hand. Raising needs a verified phone.
create or replace function public.masjid_live_hand(p_session uuid, p_raise boolean) returns boolean
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_p public.mosque_live_participants;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or s.status <> 'live' or public._masjid_live_stale(s) then
    raise exception 'الدرس مش شغال دلوقتي';
  end if;
  select * into v_p from public.mosque_live_participants where session_id = p_session and user_id = auth.uid() for update;
  if v_p.id is null or v_p.removed_at is not null then
    raise exception 'ادخل الدرس الأول';
  end if;
  if not coalesce(p_raise, false) then
    update public.mosque_live_participants set hand_raised_at = null where id = v_p.id;
    return false;
  end if;
  if not public.is_super_admin()
     and (select phone_verified_at from public.profiles where id = auth.uid()) is null then
    raise exception 'لازم توثّق رقم موبايلك عشان ترفع إيدك وتتكلم' using hint = 'phone_unverified';
  end if;
  if v_p.is_speaker then
    return true;
  end if;
  if v_p.hand_count >= 20 then
    raise exception 'رفعت إيدك كتير في الدرس ده';
  end if;
  update public.mosque_live_participants
     set hand_raised_at = coalesce(hand_raised_at, now()), hand_count = hand_count + 1
   where id = v_p.id;
  return true;
end;
$$;

-- Hosts: the raised hands and the speakers (live).
create or replace function public.masjid_live_hands(p_session uuid)
returns table (participant_id uuid, name text, hand_raised_at timestamptz, is_speaker boolean, can_speak boolean)
language plpgsql stable security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  return query
  select x.id, coalesce(n.nickname, nullif(btrim(p.full_name), ''), 'مستمع'), x.hand_raised_at, x.is_speaker,
         p.phone_verified_at is not null
  from public.mosque_live_participants x
  join public.profiles p on p.id = x.user_id
  left join public.mosque_chat_nicknames n on n.mosque_id = s.mosque_id and n.user_id = x.user_id
  where x.session_id = p_session and x.removed_at is null and not x.is_host
    and (x.hand_raised_at is not null or x.is_speaker)
  order by x.is_speaker desc, x.hand_raised_at
  limit 200;
end;
$$;

-- Hosts: make a participant a speaker / back to listener. Returns
-- { room, identity, speaker, mode } for the Edge Function's LiveKit call.
create or replace function public.masjid_live_set_speaker(p_session uuid, p_participant uuid, p_speaker boolean) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_p public.mosque_live_participants;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  if s.status <> 'live' then
    raise exception 'الدرس مش شغال دلوقتي';
  end if;
  select * into v_p from public.mosque_live_participants where id = p_participant and session_id = p_session for update;
  if v_p.id is null or v_p.removed_at is not null then
    raise exception 'الشخص ده مش في الدرس';
  end if;
  if v_p.is_host then
    raise exception 'ده من إدارة المسجد بالفعل';
  end if;
  if coalesce(p_speaker, false) then
    if (select phone_verified_at from public.profiles where id = v_p.user_id) is null then
      raise exception 'الشخص ده لسه ماوثّقش رقم موبايله — مينفعش يتكلم';
    end if;
    if not v_p.is_speaker and (select count(*) from public.mosque_live_participants
                               where session_id = p_session and is_speaker and removed_at is null) >= 6 then
      raise exception 'فيه 6 متكلمين — رجّع حد منهم مستمع الأول';
    end if;
  end if;
  update public.mosque_live_participants set is_speaker = coalesce(p_speaker, false), hand_raised_at = null where id = v_p.id;
  return jsonb_build_object('room', s.room_name, 'identity', v_p.id::text, 'speaker', coalesce(p_speaker, false), 'mode', s.mode);
end;
$$;

-- Hosts: take someone out of the lesson (can't re-join it).
create or replace function public.masjid_live_remove(p_session uuid, p_participant uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_p public.mosque_live_participants;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  select * into v_p from public.mosque_live_participants where id = p_participant and session_id = p_session for update;
  if v_p.id is null then
    raise exception 'الشخص ده مش في الدرس';
  end if;
  if v_p.is_host or v_p.user_id = auth.uid()
     or exists (select 1 from public.mosque_admins a where a.mosque_id = s.mosque_id and a.user_id = v_p.user_id) then
    raise exception 'مينفعش تطلّع حد من إدارة المسجد';
  end if;
  update public.mosque_live_participants
     set removed_at = now(), removed_by = auth.uid(), is_speaker = false, hand_raised_at = null
   where id = v_p.id;
  return jsonb_build_object('room', s.room_name, 'identity', v_p.id::text);
end;
$$;

-- Hosts: the room name, for the Edge Function's admin calls (mute).
create or replace function public.masjid_live_host_room(p_session uuid) returns text
language plpgsql stable security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  return s.room_name;
end;
$$;

-- ----------------------------------------------------------- pg_cron
do $$
begin
  create extension if not exists pg_cron;
exception when others then
  raise notice 'pg_cron not available — the super admin can call masjid_live_expire(): %', sqlerrm;
end;
$$;

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    return;
  end if;
  execute $sql$select cron.schedule('masjid-live-expire', '*/15 * * * *', 'select public.masjid_live_expire()')$sql$;
exception when others then
  raise notice 'could not schedule masjid_live_expire: %', sqlerrm;
end;
$$;

-- -------------------------------------------------------------- grants
do $$
declare f text;
begin
  -- Guests may browse (lists say can_join = false until they sign in).
  foreach f in array array[
    'masjid_live_sessions(uuid, boolean)',
    'masjid_live_feed(double precision, double precision, double precision, int)'
  ] loop
    execute format('revoke execute on function public.%s from public', f);
    execute format('grant execute on function public.%s to anon, authenticated', f);
  end loop;
  foreach f in array array[
    'masjid_live_create(uuid, jsonb)', 'masjid_live_update(uuid, jsonb)', 'masjid_live_cancel(uuid)',
    'masjid_live_start(uuid)', 'masjid_live_end(uuid)', 'masjid_live_expire()',
    'masjid_live_join_check(uuid)', 'masjid_live_hand(uuid, boolean)', 'masjid_live_hands(uuid)',
    'masjid_live_set_speaker(uuid, uuid, boolean)', 'masjid_live_remove(uuid, uuid)', 'masjid_live_host_room(uuid)'
  ] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end;
$$;
