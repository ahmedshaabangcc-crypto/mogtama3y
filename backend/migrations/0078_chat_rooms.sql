-- =====================================================================
-- 0078 — Public chat rooms («غرف الدردشة»), مُجتمعي only.
--
-- Old-school public rooms (one per governorate / big district + topic
-- rooms). Fixed: only the platform super admin creates, edits or
-- archives them.
--
--   * Identity: people write under a room nickname (chat_profiles), shown
--     with a «موثّق ✓» badge. Messages carry an opaque author id
--     (chat_profiles.public_id), never the account id, so nothing a
--     client can read links a message to a profile. Only the super admin
--     sees nickname → real name / email (admin_* RPCs).
--   * Reading: everyone, guests included (RLS select on visible messages
--     + Realtime publication). Writing: signed-in, phone-verified
--     (profiles.phone_verified_at, 0074), with a nickname, through
--     send_room_message only.
--   * Anti-spam in send_room_message: 1–500 chars, 1 message / 3 s and
--     20 / minute, same text twice in a minute refused, links only for
--     accounts older than 7 days with ≥ 20 room messages, banned words
--     (chat_banned_words, admin-extendable) refused, muted/banned refused.
--   * Reports: one per user per message; 3 distinct phone-verified
--     reporters hide the message until the admin reviews it.
--   * Moderators per room (assigned by the super admin) hide messages and
--     mute people in their room only; the super admin also restores,
--     deletes, mutes everywhere and bans. Every action is logged
--     (chat_mod_log).
--   * Presence: room_heartbeat every ~30 s; online = seen within 90 s.
--   * Retention: purge_old_room_messages() drops messages older than
--     30 days — scheduled nightly with pg_cron when the extension exists,
--     otherwise from the admin button «امسح الرسايل الأقدم من 30 يوم».
--   * Notifications: only a reply to your message, at most one per room
--     per 10 minutes.
--
-- Run after 0077. Safe to re-run.
-- =====================================================================

-- ---------------------------------------------------------------- tables
create table if not exists public.chat_rooms (
  id uuid primary key default gen_random_uuid(),
  name text not null check (length(trim(name)) between 2 and 40),
  description text check (description is null or length(description) <= 200),
  kind text not null default 'topic' check (kind in ('area', 'topic')),
  governorate text,
  area text,
  icon text check (icon is null or length(icon) <= 8),
  sort_order int not null default 100,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create unique index if not exists chat_rooms_name on public.chat_rooms (name);

create table if not exists public.chat_profiles (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  public_id uuid not null unique default gen_random_uuid(),
  nickname text not null,
  nickname_changed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.chat_room_messages (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references public.chat_rooms(id) on delete cascade,
  author_pid uuid not null references public.chat_profiles(public_id) on delete cascade,
  nickname text not null,
  body text not null check (length(trim(body)) between 1 and 500),
  reply_to uuid references public.chat_room_messages(id) on delete set null,
  is_hidden boolean not null default false,
  hidden_reason text,
  hidden_by uuid references public.profiles(id) on delete set null,
  hidden_at timestamptz,
  reports_count int not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists chat_room_messages_room on public.chat_room_messages (room_id, created_at desc);
create index if not exists chat_room_messages_author on public.chat_room_messages (author_pid, created_at desc);
create index if not exists chat_room_messages_reported on public.chat_room_messages (created_at desc) where reports_count > 0 or is_hidden;

create table if not exists public.chat_room_reports (
  message_id uuid not null references public.chat_room_messages(id) on delete cascade,
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null default 'إساءة' check (length(trim(reason)) between 2 and 300),
  created_at timestamptz not null default now(),
  primary key (message_id, reporter_id)
);

create table if not exists public.chat_room_presence (
  room_id uuid not null references public.chat_rooms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  last_seen timestamptz not null default now(),
  primary key (room_id, user_id)
);
create index if not exists chat_room_presence_seen on public.chat_room_presence (room_id, last_seen desc);

create table if not exists public.chat_ignores (
  user_id uuid not null references public.profiles(id) on delete cascade,
  ignored_pid uuid not null references public.chat_profiles(public_id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, ignored_pid)
);

create table if not exists public.chat_room_moderators (
  room_id uuid not null references public.chat_rooms(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  added_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (room_id, user_id)
);

-- Mutes and bans. room_id null = every room. until null = permanent.
create table if not exists public.chat_sanctions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  room_id uuid references public.chat_rooms(id) on delete cascade,
  kind text not null check (kind in ('mute', 'ban')),
  until timestamptz,
  reason text,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  lifted_at timestamptz,
  lifted_by uuid references public.profiles(id) on delete set null
);
create index if not exists chat_sanctions_user on public.chat_sanctions (user_id) where lifted_at is null;

create table if not exists public.chat_banned_words (
  word text primary key,
  created_at timestamptz not null default now()
);

create table if not exists public.chat_mod_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  room_id uuid,
  message_id uuid,
  target_user uuid references public.profiles(id) on delete set null,
  detail jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create index if not exists chat_mod_log_created on public.chat_mod_log (created_at desc);

-- A friend request sent from a room shows the room nickname (not the real
-- name) in the sender's own list until it is accepted.
alter table public.friendships add column if not exists via_room_nickname text;

alter table public.chat_rooms enable row level security;
alter table public.chat_profiles enable row level security;
alter table public.chat_room_messages enable row level security;
alter table public.chat_room_reports enable row level security;
alter table public.chat_room_presence enable row level security;
alter table public.chat_ignores enable row level security;
alter table public.chat_room_moderators enable row level security;
alter table public.chat_sanctions enable row level security;
alter table public.chat_banned_words enable row level security;
alter table public.chat_mod_log enable row level security;
revoke all on public.chat_rooms, public.chat_profiles, public.chat_room_messages, public.chat_room_reports,
  public.chat_room_presence, public.chat_ignores, public.chat_room_moderators, public.chat_sanctions,
  public.chat_banned_words, public.chat_mod_log from anon, authenticated;

-- Rooms and visible messages are public (guests read too, and Realtime
-- needs a SELECT policy). Only identity-free columns are granted.
drop policy if exists chat_rooms_public_read on public.chat_rooms;
create policy chat_rooms_public_read on public.chat_rooms for select to anon, authenticated using (is_active);
grant select (id, name, description, kind, governorate, area, icon, sort_order, is_active) on public.chat_rooms to anon, authenticated;

drop policy if exists chat_room_messages_public_read on public.chat_room_messages;
create policy chat_room_messages_public_read on public.chat_room_messages for select to anon, authenticated
  using (not is_hidden and exists (select 1 from public.chat_rooms r where r.id = room_id and r.is_active));
grant select (id, room_id, author_pid, nickname, body, reply_to, is_hidden, created_at) on public.chat_room_messages to anon, authenticated;

do $$
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    raise notice 'supabase_realtime publication not found — skipping (not a Supabase database)';
    return;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'chat_room_messages'
  ) then
    alter publication supabase_realtime add table public.chat_room_messages;
  end if;
end;
$$;

-- ---------------------------------------------------------------- helpers
-- Lower-case, no diacritics/tatweel, one alef/ya/ha: «أحمـد» = «احمد».
create or replace function public.chat_normalize(p text) returns text
language sql immutable as $$
  select translate(regexp_replace(lower(coalesce(p, '')), '[\u064B-\u0652\u0640]', '', 'g'), 'أإآٱةىؤئ', 'ااااهيوي');
$$;
create unique index if not exists chat_profiles_nickname on public.chat_profiles (public.chat_normalize(nickname));

create or replace function public.chat_has_banned_word(p_text text) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1
    from unnest(regexp_split_to_array(public.chat_normalize(p_text), '[^a-z0-9\u0621-\u064A]+')) t(tok)
    join public.chat_banned_words w on w.word = t.tok
    where t.tok <> ''
  );
$$;

create or replace function public.chat_is_room_moderator(p_user uuid, p_room uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.chat_room_moderators where user_id = p_user and room_id = p_room);
$$;

-- The active ban (first) or mute that stops p_user writing in p_room.
create or replace function public.chat_active_sanction(p_user uuid, p_room uuid)
returns table (kind text, until timestamptz)
language sql stable security definer set search_path = public as $$
  select s.kind, s.until from public.chat_sanctions s
  where s.user_id = p_user and s.lifted_at is null
    and (s.room_id is null or s.room_id = p_room)
    and (s.until is null or s.until > now())
  order by (s.kind = 'ban') desc, s.until desc nulls first
  limit 1;
$$;

create or replace function public.chat_log(p_action text, p_room uuid, p_message uuid, p_target uuid, p_detail jsonb default '{}'::jsonb)
returns void
language sql security definer set search_path = public as $$
  insert into public.chat_mod_log (actor_id, action, room_id, message_id, target_user, detail)
  values (auth.uid(), p_action, p_room, p_message, p_target, coalesce(p_detail, '{}'::jsonb));
$$;

-- Account behind a message (server-side only).
create or replace function public.chat_message_author(p_message uuid) returns uuid
language sql stable security definer set search_path = public as $$
  select cp.user_id from public.chat_room_messages m join public.chat_profiles cp on cp.public_id = m.author_pid where m.id = p_message;
$$;

revoke execute on function public.chat_has_banned_word(text) from public, anon, authenticated;
revoke execute on function public.chat_is_room_moderator(uuid, uuid) from public, anon, authenticated;
revoke execute on function public.chat_active_sanction(uuid, uuid) from public, anon, authenticated;
revoke execute on function public.chat_log(text, uuid, uuid, uuid, jsonb) from public, anon, authenticated;
revoke execute on function public.chat_message_author(uuid) from public, anon, authenticated;

-- ---------------------------------------------------------------- seed
insert into public.chat_rooms (name, description, kind, governorate, area, icon, sort_order) values
  ('دردشة عامة', 'اتكلم في أي حاجة مع ناس من كل مصر', 'topic', null, null, '💬', 1),
  ('القاهرة', 'غرفة أهل القاهرة', 'area', 'القاهرة', null, '🏙️', 10),
  ('الجيزة', 'غرفة أهل الجيزة', 'area', 'الجيزة', null, '🏙️', 11),
  ('الإسكندرية', 'غرفة أهل إسكندرية', 'area', 'الإسكندرية', null, '🌊', 12),
  ('القليوبية', 'غرفة أهل القليوبية', 'area', 'القليوبية', null, '📍', 13),
  ('الدقهلية', 'غرفة أهل الدقهلية', 'area', 'الدقهلية', null, '📍', 14),
  ('الشرقية', 'غرفة أهل الشرقية', 'area', 'الشرقية', null, '📍', 15),
  ('الغربية', 'غرفة أهل الغربية', 'area', 'الغربية', null, '📍', 16),
  ('المنوفية', 'غرفة أهل المنوفية', 'area', 'المنوفية', null, '📍', 17),
  ('البحيرة', 'غرفة أهل البحيرة', 'area', 'البحيرة', null, '📍', 18),
  ('أسيوط', 'غرفة أهل أسيوط', 'area', 'أسيوط', null, '📍', 19),
  ('سوهاج', 'غرفة أهل سوهاج', 'area', 'سوهاج', null, '📍', 20),
  ('المنيا', 'غرفة أهل المنيا', 'area', 'المنيا', null, '📍', 21),
  ('الإسماعيلية', 'غرفة أهل الإسماعيلية', 'area', 'الإسماعيلية', null, '📍', 22),
  ('بورسعيد', 'غرفة أهل بورسعيد', 'area', 'بورسعيد', null, '⚓', 23),
  ('السويس', 'غرفة أهل السويس', 'area', 'السويس', null, '⚓', 24),
  ('دمياط', 'غرفة أهل دمياط', 'area', 'دمياط', null, '📍', 25),
  ('مدينة نصر', 'جيران مدينة نصر', 'area', 'القاهرة', 'مدينة نصر', '🏘️', 30),
  ('المعادي', 'جيران المعادي', 'area', 'القاهرة', 'المعادي', '🏘️', 31),
  ('مصر الجديدة', 'جيران مصر الجديدة', 'area', 'القاهرة', 'مصر الجديدة', '🏘️', 32),
  ('المهندسين', 'جيران المهندسين', 'area', 'الجيزة', 'المهندسين', '🏘️', 33),
  ('سموحة', 'جيران سموحة', 'area', 'الإسكندرية', 'سموحة', '🏘️', 34),
  ('6 أكتوبر', 'جيران 6 أكتوبر', 'area', 'الجيزة', 'أكتوبر', '🏘️', 35),
  ('كورة', 'ماتشات وأهداف ونقاش كورة', 'topic', null, null, '⚽', 50),
  ('مطبخ وأكل', 'وصفات وأكلات ومطاعم', 'topic', null, null, '🍲', 51),
  ('عربيات', 'عربيات وصيانة وأسعار', 'topic', null, null, '🚗', 52),
  ('تعليم وأولاد', 'مدارس ودروس وتربية', 'topic', null, null, '📚', 53),
  ('شغل ووظائف', 'فرص شغل ونصايح', 'topic', null, null, '💼', 54),
  ('عقارات', 'شقق وإيجارات وأسعار', 'topic', null, null, '🏠', 55),
  ('تكنولوجيا وموبايلات', 'موبايلات وكمبيوتر وإنترنت', 'topic', null, null, '📱', 56)
on conflict (name) do nothing;

-- A starter list; the admin adds more from «غرف الدردشة» in the panel.
insert into public.chat_banned_words (word)
select public.chat_normalize(w) from unnest(array[
  'fuck', 'fucking', 'fucker', 'motherfucker', 'shit', 'bitch', 'asshole', 'dick', 'pussy', 'whore', 'slut', 'bastard', 'cunt',
  'كس', 'كسم', 'كسمك', 'كسختك', 'شرموط', 'شرموطة', 'متناك', 'متناكة', 'منيوك', 'منيوكة', 'خول', 'عرص', 'معرص',
  'لبوة', 'زب', 'زبي', 'طيز', 'نيك', 'انيك', 'هنيكك', 'وسخة', 'قحبة', 'منايك'
]) w
on conflict (word) do nothing;

-- ---------------------------------------------------------------- rooms
-- Every active room, most active first, with live counts. near: 1 = your
-- district/city room, 2 = your governorate room (from your digital
-- addresses or «ناس حواليك» area), 0 otherwise.
create or replace function public.list_chat_rooms() returns table (
  id uuid, name text, description text, kind text, governorate text, area text, icon text, sort_order int,
  online_count int, recent_count int, last_message_at timestamptz, near int
)
language sql stable security definer set search_path = public as $$
  with mine as (
    select public.chat_normalize(coalesce(a.district, '') || ' ' || coalesce(a.city, '')) as place,
           public.chat_normalize(a.governorate) as gov
    from public.e_addresses a where auth.uid() is not null and a.owner_id = auth.uid() and a.is_active
    union all
    select public.chat_normalize(pp.area), null from public.people_presence pp
    where auth.uid() is not null and pp.user_id = auth.uid() and pp.discoverable and pp.area is not null
  )
  select r.id, r.name, r.description, r.kind, r.governorate, r.area, r.icon, r.sort_order,
         (select count(*)::int from public.chat_room_presence p where p.room_id = r.id and p.last_seen > now() - interval '90 seconds'),
         (select count(*)::int from public.chat_room_messages m where m.room_id = r.id and not m.is_hidden and m.created_at > now() - interval '1 hour'),
         (select max(m.created_at) from public.chat_room_messages m where m.room_id = r.id and not m.is_hidden),
         case
           when r.kind = 'area' and r.area is not null and exists (
             select 1 from mine where position(public.chat_normalize(r.area) in mine.place) > 0) then 1
           when r.kind = 'area' and r.area is null and r.governorate is not null and exists (
             select 1 from mine where mine.gov = public.chat_normalize(r.governorate)
                                   or position(public.chat_normalize(r.governorate) in mine.place) > 0) then 2
           else 0
         end
  from public.chat_rooms r
  where r.is_active
  order by 9 desc, 10 desc, r.sort_order, r.name;
$$;

-- One room plus what the caller may do in it.
create or replace function public.get_chat_room(p_room uuid) returns jsonb
language plpgsql stable security definer set search_path = public as $$
declare
  r public.chat_rooms;
  v_verified boolean := false;
  v_cp public.chat_profiles;
  v_kind text;
  v_until timestamptz;
  v_reason text;
  v_admin boolean := false;
begin
  select * into r from public.chat_rooms where id = p_room;
  if r.id is null or (not r.is_active and not public.is_super_admin()) then return null; end if;
  if auth.uid() is not null then
    select p.phone_verified_at is not null into v_verified from public.profiles p where p.id = auth.uid();
    select * into v_cp from public.chat_profiles where user_id = auth.uid();
    select s.kind, s.until into v_kind, v_until from public.chat_active_sanction(auth.uid(), p_room) s;
    v_admin := public.is_super_admin();
  end if;
  v_reason := case
    when auth.uid() is null then 'guest'
    when not coalesce(v_verified, false) then 'no_phone'
    when v_cp.user_id is null then 'no_nickname'
    when v_kind = 'ban' then 'banned'
    when v_kind = 'mute' then 'muted'
    when not r.is_active then 'archived'
  end;
  return jsonb_build_object(
    'id', r.id, 'name', r.name, 'description', r.description, 'kind', r.kind,
    'governorate', r.governorate, 'area', r.area, 'icon', r.icon, 'is_active', r.is_active,
    'online_count', (select count(*) from public.chat_room_presence p where p.room_id = r.id and p.last_seen > now() - interval '90 seconds'),
    'signed_in', auth.uid() is not null,
    'phone_verified', coalesce(v_verified, false),
    'nickname', v_cp.nickname,
    'public_id', v_cp.public_id,
    'can_write', v_reason is null,
    'blocked_reason', v_reason,
    'sanction_until', v_until,
    'is_admin', v_admin,
    'can_moderate', v_admin or (auth.uid() is not null and public.chat_is_room_moderator(auth.uid(), r.id))
  );
end;
$$;

-- Visible messages of a room, oldest first: the newest p_limit (or before
-- p_before), or everything after p_after. Hidden messages, people the
-- caller ignores and blocked people are left out. No account ids.
create or replace function public.room_messages(
  p_room uuid, p_after timestamptz default null, p_before timestamptz default null, p_limit int default 60
) returns table (
  id uuid, author uuid, nickname text, verified boolean, body text,
  reply_to uuid, reply_nickname text, reply_body text, created_at timestamptz, mine boolean
)
language sql stable security definer set search_path = public as $$
  select x.id, x.author, x.nickname, x.verified, x.body, x.reply_to, x.reply_nickname, x.reply_body, x.created_at, x.mine
  from (
    select m.id, m.author_pid as author, m.nickname, (p.phone_verified_at is not null) as verified, m.body,
           m.reply_to, rm.nickname as reply_nickname, left(rm.body, 140) as reply_body, m.created_at,
           (auth.uid() is not null and cp.user_id = auth.uid()) as mine
    from public.chat_room_messages m
    join public.chat_rooms r on r.id = m.room_id and r.is_active
    join public.chat_profiles cp on cp.public_id = m.author_pid
    join public.profiles p on p.id = cp.user_id
    left join public.chat_room_messages rm on rm.id = m.reply_to and not rm.is_hidden
    where m.room_id = p_room
      and not m.is_hidden
      and (p_after is null or m.created_at > p_after)
      and (p_before is null or m.created_at < p_before)
      and (auth.uid() is null or (
            not exists (select 1 from public.chat_ignores i where i.user_id = auth.uid() and i.ignored_pid = m.author_pid)
            and not public.is_blocked_between(auth.uid(), cp.user_id)))
    order by case when p_after is null then m.created_at end desc, m.created_at asc
    limit least(greatest(coalesce(p_limit, 60), 1), 200)
  ) x
  order by x.created_at;
$$;

-- Who is in the room now (seen within 90 s) and has a nickname.
create or replace function public.room_online(p_room uuid) returns table (author uuid, nickname text, verified boolean, is_me boolean)
language sql stable security definer set search_path = public as $$
  select cp.public_id, cp.nickname, pr.phone_verified_at is not null, cp.user_id = auth.uid()
  from public.chat_room_presence p
  join public.chat_profiles cp on cp.user_id = p.user_id
  join public.profiles pr on pr.id = p.user_id
  where p.room_id = p_room and p.last_seen > now() - interval '90 seconds'
    and (auth.uid() is null or not public.is_blocked_between(auth.uid(), p.user_id))
  order by cp.nickname
  limit 200;
$$;

-- "I'm here" — call every ~30 s while the room is open. Returns the online count.
create or replace function public.room_heartbeat(p_room uuid) returns int
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if not exists (select 1 from public.chat_rooms where id = p_room and is_active) then raise exception 'الغرفة مش موجودة'; end if;
  insert into public.chat_room_presence (room_id, user_id, last_seen) values (p_room, auth.uid(), now())
  on conflict (room_id, user_id) do update set last_seen = now();
  return (select count(*)::int from public.chat_room_presence where room_id = p_room and last_seen > now() - interval '90 seconds');
end;
$$;

create or replace function public.room_leave(p_room uuid) returns void
language sql security definer set search_path = public as $$
  delete from public.chat_room_presence where room_id = p_room and user_id = auth.uid();
$$;

-- ---------------------------------------------------------------- nickname
create or replace function public.my_chat_profile() returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'signed_in', auth.uid() is not null,
    'phone_verified', coalesce((select phone_verified_at is not null from public.profiles where id = auth.uid()), false),
    'nickname', cp.nickname,
    'public_id', cp.public_id,
    'can_change_at', case when cp.user_id is not null then cp.nickname_changed_at + interval '7 days' end
  )
  from (select 1) one
  left join public.chat_profiles cp on cp.user_id = auth.uid();
$$;

create or replace function public.set_chat_nickname(p_nickname text) returns text
language plpgsql security definer set search_path = public as $$
declare
  v_nick text := trim(coalesce(p_nickname, ''));
  v_norm text;
  v_cp public.chat_profiles;
  v_reserved text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if v_nick !~ '^[A-Za-z0-9_\u0621-\u063A\u0641-\u064A\u0660-\u0669]{3,20}$' then
    raise exception 'الاسم لازم يكون من 3 لـ 20 حرف: حروف عربي أو إنجليزي أو أرقام أو _ بس';
  end if;
  v_norm := public.chat_normalize(v_nick);
  foreach v_reserved in array array['admin', 'moderator', 'mogtama3y', 'mogtamaay', 'support', 'system', 'official', 'owner',
                                    'مجتمعي', 'ادمن', 'مشرف', 'اداره', 'الدعم', 'رسمي', 'مدير', 'الاداره'] loop
    if position(public.chat_normalize(v_reserved) in v_norm) > 0 then
      raise exception 'الاسم ده محجوز، اختار اسم تاني';
    end if;
  end loop;
  if public.chat_has_banned_word(replace(v_nick, '_', ' ')) then raise exception 'الاسم فيه كلمة مش لطيفة، اختار اسم تاني'; end if;

  select * into v_cp from public.chat_profiles where user_id = auth.uid();
  if v_cp.user_id is not null and v_cp.nickname = v_nick then return v_nick; end if;
  if exists (select 1 from public.chat_profiles where public.chat_normalize(nickname) = v_norm and user_id <> auth.uid()) then
    raise exception 'الاسم ده واخده حد تاني، جرّب اسم تاني';
  end if;
  if v_cp.user_id is null then
    insert into public.chat_profiles (user_id, nickname) values (auth.uid(), v_nick);
  else
    if v_cp.nickname_changed_at > now() - interval '7 days' then
      raise exception 'تقدر تغيّر اسمك في الغرف مرة كل 7 أيام';
    end if;
    update public.chat_profiles set nickname = v_nick, nickname_changed_at = now(), updated_at = now() where user_id = auth.uid();
  end if;
  return v_nick;
end;
$$;

-- ---------------------------------------------------------------- send
create or replace function public.send_room_message(p_room uuid, p_body text, p_reply_to uuid default null) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_body text := trim(coalesce(p_body, ''));
  v_room public.chat_rooms;
  v_cp public.chat_profiles;
  v_prof public.profiles;
  v_kind text;
  v_until timestamptz;
  v_last timestamptz;
  v_id uuid;
  v_reply public.chat_room_messages;
  v_target uuid;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول عشان تكتب في الغرف'; end if;
  select * into v_room from public.chat_rooms where id = p_room;
  if v_room.id is null or not v_room.is_active then raise exception 'الغرفة دي مش متاحة'; end if;
  select * into v_prof from public.profiles where id = auth.uid();
  if v_prof.phone_verified_at is null then raise exception 'أكّد رقمك عشان تكتب في الغرف'; end if;
  select * into v_cp from public.chat_profiles where user_id = auth.uid();
  if v_cp.user_id is null then raise exception 'اختار اسمك في الغرف الأول'; end if;

  select s.kind, s.until into v_kind, v_until from public.chat_active_sanction(auth.uid(), p_room) s;
  if v_kind = 'ban' then
    raise exception '%', case when v_until is null then 'إنت ممنوع من الكتابة في الغرف'
                              else 'إنت ممنوع من الكتابة في الغرف لحد ' || to_char(v_until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI') end;
  end if;
  if v_kind = 'mute' then
    raise exception 'إنت مكتوم مؤقتاً لحد %', to_char(v_until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI');
  end if;

  if length(v_body) < 1 then raise exception 'اكتب رسالة الأول'; end if;
  if length(v_body) > 500 then raise exception 'الرسالة طويلة، الحد 500 حرف'; end if;

  select max(created_at) into v_last from public.chat_room_messages where author_pid = v_cp.public_id;
  if v_last is not null and v_last > now() - interval '3 seconds' then
    raise exception 'استنى ثانيتين قبل الرسالة الجاية';
  end if;
  if (select count(*) from public.chat_room_messages where author_pid = v_cp.public_id and created_at > now() - interval '1 minute') >= 20 then
    raise exception 'بتكتب بسرعة، استنى دقيقة';
  end if;
  if exists (select 1 from public.chat_room_messages where author_pid = v_cp.public_id and room_id = p_room
             and body = v_body and created_at > now() - interval '1 minute') then
    raise exception 'إنت لسه باعت نفس الرسالة';
  end if;

  if public.chat_has_banned_word(v_body) then
    raise exception 'الرسالة فيها كلام مش لطيف، عدّلها وابعت تاني';
  end if;

  if lower(v_body) ~ '(https?://|www\.|t\.me/|wa\.me/|bit\.ly|[a-z0-9-]+\.(com|net|org|eg|io|me|ly|co|info|xyz|link|app|site|online|store|shop|tk|biz)([^a-z0-9]|$))' then
    if v_prof.created_at > now() - interval '7 days'
       or (select count(*) from public.chat_room_messages where author_pid = v_cp.public_id) < 20 then
      raise exception 'اللينكات مسموحة بعد ما يعدّي على حسابك أسبوع وتكتب 20 رسالة في الغرف';
    end if;
  end if;

  if p_reply_to is not null then
    select * into v_reply from public.chat_room_messages where id = p_reply_to;
    if v_reply.id is null or v_reply.room_id <> p_room or v_reply.is_hidden then
      raise exception 'الرسالة اللي بترد عليها مش موجودة';
    end if;
  end if;

  insert into public.chat_room_messages (room_id, author_pid, nickname, body, reply_to)
  values (p_room, v_cp.public_id, v_cp.nickname, v_body, p_reply_to)
  returning id into v_id;

  -- Only a reply notifies, and at most once per room per 10 minutes.
  if v_reply.id is not null then
    select cp.user_id into v_target from public.chat_profiles cp where cp.public_id = v_reply.author_pid;
    if v_target is not null and v_target <> auth.uid()
       and not public.is_blocked_between(auth.uid(), v_target)
       and not exists (select 1 from public.chat_ignores i where i.user_id = v_target and i.ignored_pid = v_cp.public_id)
       and not exists (select 1 from public.notifications n where n.user_id = v_target
                        and n.deep_link = '/#/rooms/' || p_room and n.created_at > now() - interval '10 minutes') then
      insert into public.notifications (user_id, title, body, deep_link)
      values (v_target, v_cp.nickname || ' ردّ عليك في غرفة ' || v_room.name, left(v_body, 120), '/#/rooms/' || p_room);
    end if;
  end if;
  return v_id;
end;
$$;

-- ---------------------------------------------------------------- report / ignore / friend
-- Returns true when the message is now hidden (3 distinct verified reporters).
create or replace function public.report_room_message(p_message uuid, p_reason text default null) returns boolean
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.chat_room_messages;
  v_count int;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select * into v_msg from public.chat_room_messages where id = p_message;
  if v_msg.id is null then raise exception 'الرسالة مش موجودة'; end if;
  if public.chat_message_author(p_message) = auth.uid() then raise exception 'مينفعش تبلّغ عن رسالتك'; end if;
  if exists (select 1 from public.chat_room_reports where message_id = p_message and reporter_id = auth.uid()) then
    raise exception 'بلّغت عن الرسالة دي قبل كده';
  end if;
  if (select count(*) from public.chat_room_reports where reporter_id = auth.uid() and created_at > now() - interval '1 day') >= 30 then
    raise exception 'بلّغت كتير النهارده';
  end if;
  insert into public.chat_room_reports (message_id, reporter_id, reason)
  values (p_message, auth.uid(), coalesce(nullif(trim(coalesce(p_reason, '')), ''), 'إساءة'));
  -- Only phone-verified reporters count toward hiding (one person with
  -- throwaway accounts can't silence someone).
  select count(*) into v_count from public.chat_room_reports rr join public.profiles p on p.id = rr.reporter_id
  where rr.message_id = p_message and p.phone_verified_at is not null;
  update public.chat_room_messages set reports_count = (select count(*) from public.chat_room_reports where message_id = p_message)
  where id = p_message;
  if v_count >= 3 and not v_msg.is_hidden then
    update public.chat_room_messages set is_hidden = true, hidden_reason = 'auto_reports', hidden_at = now() where id = p_message;
    insert into public.chat_mod_log (actor_id, action, room_id, message_id, target_user, detail)
    values (null, 'auto_hide', v_msg.room_id, p_message, public.chat_message_author(p_message), jsonb_build_object('reports', v_count));
    return true;
  end if;
  return v_msg.is_hidden;
end;
$$;

create or replace function public.room_ignore(p_author uuid, p_on boolean default true) returns void
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if not exists (select 1 from public.chat_profiles where public_id = p_author) then raise exception 'الشخص ده مش موجود'; end if;
  if exists (select 1 from public.chat_profiles where public_id = p_author and user_id = auth.uid()) then raise exception 'مينفعش تتجاهل نفسك'; end if;
  if coalesce(p_on, true) then
    insert into public.chat_ignores (user_id, ignored_pid) values (auth.uid(), p_author) on conflict do nothing;
  else
    delete from public.chat_ignores where user_id = auth.uid() and ignored_pid = p_author;
  end if;
end;
$$;

create or replace function public.my_room_ignores() returns table (author uuid, nickname text)
language sql stable security definer set search_path = public as $$
  select cp.public_id, cp.nickname from public.chat_ignores i join public.chat_profiles cp on cp.public_id = i.ignored_pid
  where i.user_id = auth.uid() order by i.created_at desc;
$$;

-- «كلّمه خاص»: a normal friend request (private chat stays friends-only).
-- The sender's list shows the nickname until they become friends.
create or replace function public.room_friend_request(p_author uuid) returns text
language plpgsql security definer set search_path = public as $$
declare
  v_cp public.chat_profiles;
  v_state text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select * into v_cp from public.chat_profiles where public_id = p_author;
  if v_cp.user_id is null then raise exception 'الشخص ده مش موجود'; end if;
  if v_cp.user_id = auth.uid() then raise exception 'مينفعش تضيف نفسك'; end if;
  v_state := public.send_friend_request(v_cp.user_id);
  if v_state = 'sent' then
    update public.friendships set via_room_nickname = v_cp.nickname
    where requester_id = auth.uid() and addressee_id = v_cp.user_id and status = 'pending';
  end if;
  return v_state;
end;
$$;

-- Same as 0062, except a pending request sent from a room shows the
-- room nickname instead of the real name/photo.
create or replace function public.my_friends() returns table (
  user_id uuid, full_name text, avatar_url text, is_verified boolean, state text,
  last_message text, last_message_at timestamptz, unread int
)
language sql stable security definer set search_path = public as $$
  select p.id,
         case when f.status = 'pending' and f.requester_id = auth.uid() and f.via_room_nickname is not null
              then f.via_room_nickname || ' (من الغرف)' else p.full_name end,
         case when f.status = 'pending' and f.requester_id = auth.uid() and f.via_room_nickname is not null
              then null else p.avatar_url end,
         p.is_verified,
         case when f.status = 'accepted' then 'friends' when f.requester_id = auth.uid() then 'sent' else 'received' end,
         lm.body, lm.created_at,
         (select count(*)::int from public.direct_messages m where m.sender_id = p.id and m.recipient_id = auth.uid() and m.read_at is null)
  from public.friendships f
  join public.profiles p on p.id = case when f.requester_id = auth.uid() then f.addressee_id else f.requester_id end
  left join lateral (
    select m.body, m.created_at from public.direct_messages m
    where least(m.sender_id, m.recipient_id) = least(auth.uid(), p.id) and greatest(m.sender_id, m.recipient_id) = greatest(auth.uid(), p.id)
    order by m.created_at desc limit 1
  ) lm on true
  where auth.uid() in (f.requester_id, f.addressee_id)
  order by (f.status = 'pending' and f.addressee_id = auth.uid()) desc, coalesce(lm.created_at, f.created_at) desc;
$$;

-- ---------------------------------------------------------------- moderation (moderators + admin)
create or replace function public.mod_hide_room_message(p_message uuid, p_reason text default null) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.chat_room_messages;
begin
  select * into v_msg from public.chat_room_messages where id = p_message;
  if v_msg.id is null then raise exception 'الرسالة مش موجودة'; end if;
  if auth.uid() is null or not (public.is_super_admin() or public.chat_is_room_moderator(auth.uid(), v_msg.room_id)) then
    raise exception 'غير مسموح';
  end if;
  update public.chat_room_messages
  set is_hidden = true, hidden_reason = coalesce(nullif(trim(coalesce(p_reason, '')), ''), 'moderator'), hidden_by = auth.uid(), hidden_at = now()
  where id = p_message;
  perform public.chat_log('hide', v_msg.room_id, p_message, public.chat_message_author(p_message), jsonb_build_object('reason', p_reason));
end;
$$;

-- Mute the author of a message. A room moderator mutes in that room only
-- (up to 7 days); the super admin mutes in every room (up to 30 days).
create or replace function public.mod_mute_room_user(p_message uuid, p_minutes int, p_reason text default null) returns timestamptz
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.chat_room_messages;
  v_user uuid;
  v_admin boolean := public.is_super_admin();
  v_until timestamptz;
begin
  select * into v_msg from public.chat_room_messages where id = p_message;
  if v_msg.id is null then raise exception 'الرسالة مش موجودة'; end if;
  if auth.uid() is null or not (v_admin or public.chat_is_room_moderator(auth.uid(), v_msg.room_id)) then
    raise exception 'غير مسموح';
  end if;
  if p_minutes is null or p_minutes < 1 or p_minutes > (case when v_admin then 43200 else 10080 end) then
    raise exception 'مدة الكتم مش مظبوطة';
  end if;
  v_user := public.chat_message_author(p_message);
  if v_user = auth.uid() then raise exception 'مينفعش تكتم نفسك'; end if;
  if not v_admin and (public.chat_is_room_moderator(v_user, v_msg.room_id)
                      or exists (select 1 from public.profiles where id = v_user and role = 'super_admin')) then
    raise exception 'مينفعش تكتم مشرف';
  end if;
  v_until := now() + make_interval(mins => p_minutes);
  insert into public.chat_sanctions (user_id, room_id, kind, until, reason, created_by)
  values (v_user, case when v_admin then null else v_msg.room_id end, 'mute', v_until, nullif(trim(coalesce(p_reason, '')), ''), auth.uid());
  perform public.chat_log('mute', v_msg.room_id, p_message, v_user,
    jsonb_build_object('minutes', p_minutes, 'all_rooms', v_admin, 'reason', p_reason));
  return v_until;
end;
$$;

-- ---------------------------------------------------------------- super admin
create or replace function public.admin_list_chat_rooms() returns setof public.chat_rooms
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query select * from public.chat_rooms order by is_active desc, sort_order, name;
end;
$$;

create or replace function public.admin_save_chat_room(
  p_id uuid, p_name text, p_description text, p_kind text, p_governorate text default null, p_area text default null,
  p_icon text default null, p_sort_order int default 100, p_is_active boolean default true
) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  if p_kind not in ('area', 'topic') then raise exception 'نوع الغرفة لازم يكون منطقة أو موضوع'; end if;
  if p_id is null then
    insert into public.chat_rooms (name, description, kind, governorate, area, icon, sort_order, is_active)
    values (trim(p_name), nullif(trim(coalesce(p_description, '')), ''), p_kind,
            nullif(trim(coalesce(p_governorate, '')), ''), nullif(trim(coalesce(p_area, '')), ''),
            nullif(trim(coalesce(p_icon, '')), ''), coalesce(p_sort_order, 100), coalesce(p_is_active, true))
    returning id into v_id;
    perform public.chat_log('room_create', v_id, null, null, jsonb_build_object('name', p_name));
  else
    update public.chat_rooms set name = trim(p_name), description = nullif(trim(coalesce(p_description, '')), ''), kind = p_kind,
      governorate = nullif(trim(coalesce(p_governorate, '')), ''), area = nullif(trim(coalesce(p_area, '')), ''),
      icon = nullif(trim(coalesce(p_icon, '')), ''), sort_order = coalesce(p_sort_order, 100),
      is_active = coalesce(p_is_active, true), updated_at = now()
    where id = p_id returning id into v_id;
    if v_id is null then raise exception 'الغرفة مش موجودة'; end if;
    perform public.chat_log('room_update', v_id, null, null, jsonb_build_object('name', p_name, 'is_active', p_is_active));
  end if;
  return v_id;
end;
$$;

-- Assign / remove a room moderator by their room nickname.
create or replace function public.admin_set_room_moderator(p_room uuid, p_nickname text, p_on boolean default true) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_user uuid;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  select user_id into v_user from public.chat_profiles where public.chat_normalize(nickname) = public.chat_normalize(trim(p_nickname));
  if v_user is null then raise exception 'مفيش حد بالاسم ده في الغرف'; end if;
  if not exists (select 1 from public.chat_rooms where id = p_room) then raise exception 'الغرفة مش موجودة'; end if;
  if coalesce(p_on, true) then
    insert into public.chat_room_moderators (room_id, user_id, added_by) values (p_room, v_user, auth.uid()) on conflict do nothing;
  else
    delete from public.chat_room_moderators where room_id = p_room and user_id = v_user;
  end if;
  perform public.chat_log(case when coalesce(p_on, true) then 'moderator_add' else 'moderator_remove' end, p_room, null, v_user, '{}'::jsonb);
end;
$$;

create or replace function public.admin_list_room_moderators(p_room uuid) returns table (
  user_id uuid, nickname text, full_name text, email text, created_at timestamptz
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select m.user_id, cp.nickname, p.full_name, u.email::text, m.created_at
    from public.chat_room_moderators m
    join public.profiles p on p.id = m.user_id
    left join public.chat_profiles cp on cp.user_id = m.user_id
    left join auth.users u on u.id = m.user_id
    where m.room_id = p_room order by m.created_at;
end;
$$;

-- Reported or hidden messages, with the real account behind each.
create or replace function public.admin_room_reports() returns table (
  id uuid, room_id uuid, room_name text, nickname text, body text, created_at timestamptz,
  is_hidden boolean, hidden_reason text, reports_count int, reasons text[],
  user_id uuid, full_name text, email text, phone text, active_sanction text
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select m.id, m.room_id, r.name, m.nickname, m.body, m.created_at, m.is_hidden, m.hidden_reason, m.reports_count,
           array(select rr.reason from public.chat_room_reports rr where rr.message_id = m.id order by rr.created_at),
           cp.user_id, p.full_name, u.email::text, p.phone,
           (select s.kind || coalesce(' ' || to_char(s.until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI'), ' دائم')
              from public.chat_active_sanction(cp.user_id, m.room_id) s)
    from public.chat_room_messages m
    join public.chat_rooms r on r.id = m.room_id
    join public.chat_profiles cp on cp.public_id = m.author_pid
    join public.profiles p on p.id = cp.user_id
    left join auth.users u on u.id = cp.user_id
    where m.reports_count > 0 or m.is_hidden
    order by m.is_hidden desc, m.created_at desc
    limit 300;
end;
$$;

-- The admin's view of a room: nickname → real account.
create or replace function public.admin_room_messages(p_room uuid, p_limit int default 100) returns table (
  id uuid, nickname text, body text, created_at timestamptz, is_hidden boolean, reports_count int,
  user_id uuid, full_name text, email text
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select m.id, m.nickname, m.body, m.created_at, m.is_hidden, m.reports_count, cp.user_id, p.full_name, u.email::text
    from public.chat_room_messages m
    join public.chat_profiles cp on cp.public_id = m.author_pid
    join public.profiles p on p.id = cp.user_id
    left join auth.users u on u.id = cp.user_id
    where m.room_id = p_room
    order by m.created_at desc
    limit least(greatest(coalesce(p_limit, 100), 1), 500);
end;
$$;

create or replace function public.admin_restore_room_message(p_message uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_room uuid;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  update public.chat_room_messages set is_hidden = false, hidden_reason = null, hidden_by = null, hidden_at = null, reports_count = 0
  where id = p_message returning room_id into v_room;
  if v_room is null then raise exception 'الرسالة مش موجودة'; end if;
  delete from public.chat_room_reports where message_id = p_message;
  perform public.chat_log('restore', v_room, p_message, public.chat_message_author(p_message), '{}'::jsonb);
end;
$$;

create or replace function public.admin_delete_room_message(p_message uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.chat_room_messages;
  v_user uuid;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  select * into v_msg from public.chat_room_messages where id = p_message;
  if v_msg.id is null then raise exception 'الرسالة مش موجودة'; end if;
  v_user := public.chat_message_author(p_message);
  delete from public.chat_room_messages where id = p_message;
  perform public.chat_log('delete', v_msg.room_id, p_message, v_user, jsonb_build_object('nickname', v_msg.nickname, 'body', left(v_msg.body, 500)));
end;
$$;

-- Ban the author of a message from every room: p_hours null = permanent.
create or replace function public.admin_ban_chat_user(p_message uuid, p_hours int default null, p_reason text default null) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.chat_room_messages;
  v_user uuid;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  select * into v_msg from public.chat_room_messages where id = p_message;
  if v_msg.id is null then raise exception 'الرسالة مش موجودة'; end if;
  if p_hours is not null and p_hours < 1 then raise exception 'مدة الحظر مش مظبوطة'; end if;
  v_user := public.chat_message_author(p_message);
  insert into public.chat_sanctions (user_id, room_id, kind, until, reason, created_by)
  values (v_user, null, 'ban', case when p_hours is not null then now() + make_interval(hours => p_hours) end,
          nullif(trim(coalesce(p_reason, '')), ''), auth.uid());
  perform public.chat_log('ban', v_msg.room_id, p_message, v_user, jsonb_build_object('hours', p_hours, 'reason', p_reason));
end;
$$;

create or replace function public.admin_list_chat_sanctions() returns table (
  id uuid, kind text, room_name text, until timestamptz, reason text, created_at timestamptz,
  nickname text, full_name text, email text
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select s.id, s.kind, r.name, s.until, s.reason, s.created_at, cp.nickname, p.full_name, u.email::text
    from public.chat_sanctions s
    join public.profiles p on p.id = s.user_id
    left join public.chat_profiles cp on cp.user_id = s.user_id
    left join public.chat_rooms r on r.id = s.room_id
    left join auth.users u on u.id = s.user_id
    where s.lifted_at is null and (s.until is null or s.until > now())
    order by s.created_at desc;
end;
$$;

create or replace function public.admin_lift_chat_sanction(p_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_user uuid;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  update public.chat_sanctions set lifted_at = now(), lifted_by = auth.uid() where id = p_id and lifted_at is null returning user_id into v_user;
  if v_user is null then raise exception 'العقوبة مش موجودة'; end if;
  perform public.chat_log('lift', null, null, v_user, jsonb_build_object('sanction', p_id));
end;
$$;

create or replace function public.admin_list_banned_words() returns setof text
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query select word from public.chat_banned_words order by word;
end;
$$;

create or replace function public.admin_set_banned_word(p_word text, p_on boolean default true) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_word text := public.chat_normalize(trim(coalesce(p_word, '')));
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  if v_word !~ '^[a-z0-9\u0621-\u064A]{2,40}$' then raise exception 'اكتب كلمة واحدة (من غير مسافات)'; end if;
  if coalesce(p_on, true) then
    insert into public.chat_banned_words (word) values (v_word) on conflict do nothing;
  else
    delete from public.chat_banned_words where word = v_word;
  end if;
  perform public.chat_log(case when coalesce(p_on, true) then 'word_add' else 'word_remove' end, null, null, null, jsonb_build_object('word', v_word));
end;
$$;

create or replace function public.admin_chat_mod_log(p_limit int default 200) returns table (
  id uuid, action text, created_at timestamptz, actor text, room_name text, target_nickname text, target_name text, detail jsonb
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select l.id, l.action, l.created_at, ap.full_name, r.name, cp.nickname, tp.full_name, l.detail
    from public.chat_mod_log l
    left join public.profiles ap on ap.id = l.actor_id
    left join public.chat_rooms r on r.id = l.room_id
    left join public.chat_profiles cp on cp.user_id = l.target_user
    left join public.profiles tp on tp.id = l.target_user
    order by l.created_at desc
    limit least(greatest(coalesce(p_limit, 200), 1), 1000);
end;
$$;

-- ---------------------------------------------------------------- retention
-- Deletes room messages older than 30 days (and stale presence rows).
-- Run nightly by pg_cron when available, or from the admin button.
create or replace function public.purge_old_room_messages() returns int
language plpgsql security definer set search_path = public as $$
declare
  v_n int;
begin
  if auth.uid() is not null and not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  delete from public.chat_room_messages where created_at < now() - interval '30 days';
  get diagnostics v_n = row_count;
  delete from public.chat_room_presence where last_seen < now() - interval '1 day';
  if auth.uid() is not null then perform public.chat_log('purge', null, null, null, jsonb_build_object('deleted', v_n)); end if;
  return v_n;
end;
$$;

do $$
begin
  create extension if not exists pg_cron;
exception when others then
  raise notice 'pg_cron not available — call purge_old_room_messages() from the admin panel or the nightly backup job: %', sqlerrm;
end;
$$;

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    return;
  end if;
  execute $sql$select cron.schedule('purge-old-room-messages', '30 1 * * *', 'select public.purge_old_room_messages()')$sql$;
exception when others then
  raise notice 'could not schedule purge_old_room_messages: %', sqlerrm;
end;
$$;

-- ---------------------------------------------------------------- grants
do $$
declare f text;
begin
  -- Readable by guests too.
  foreach f in array array[
    'list_chat_rooms()', 'get_chat_room(uuid)', 'room_messages(uuid, timestamptz, timestamptz, int)', 'room_online(uuid)'
  ] loop
    execute format('revoke execute on function public.%s from public', f);
    execute format('grant execute on function public.%s to anon, authenticated', f);
  end loop;
  foreach f in array array[
    'room_heartbeat(uuid)', 'room_leave(uuid)', 'my_chat_profile()', 'set_chat_nickname(text)',
    'send_room_message(uuid, text, uuid)', 'report_room_message(uuid, text)', 'room_ignore(uuid, boolean)',
    'my_room_ignores()', 'room_friend_request(uuid)', 'my_friends()',
    'mod_hide_room_message(uuid, text)', 'mod_mute_room_user(uuid, int, text)',
    'admin_list_chat_rooms()', 'admin_save_chat_room(uuid, text, text, text, text, text, text, int, boolean)',
    'admin_set_room_moderator(uuid, text, boolean)', 'admin_list_room_moderators(uuid)', 'admin_room_reports()',
    'admin_room_messages(uuid, int)', 'admin_restore_room_message(uuid)', 'admin_delete_room_message(uuid)',
    'admin_ban_chat_user(uuid, int, text)', 'admin_list_chat_sanctions()', 'admin_lift_chat_sanction(uuid)',
    'admin_list_banned_words()', 'admin_set_banned_word(text, boolean)', 'admin_chat_mod_log(int)',
    'purge_old_room_messages()'
  ] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end;
$$;
