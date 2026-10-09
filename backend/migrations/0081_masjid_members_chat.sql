-- =====================================================================
-- Migration 0081 — «مسجدي»: members, the mosque chat, and «قريب منك».
--
-- Every mosque is open NOW, before any imam/admin claims it, so the
-- neighbourhood can start gathering around it.
--
--   * mosque_members («انضم للمسجد»): any signed-in user joins / leaves.
--     Joining also follows the mosque (notifications on); leaving
--     unfollows. A user may belong to up to 20 mosques and mark one as
--     «مسجدي الأساسي» (the first one joined becomes it automatically).
--     Member counts are public (get_mosque, lists, join candidates).
--     Adding a missing mosque (masjid_add_mosque) joins its creator.
--   * mosque_chat_messages («شات المسجد»): one group chat per mosque.
--     Members read and write (moderators read too); guests and
--     non-members only see a message count. Realtime: the table is in
--     the supabase_realtime publication and RLS lets exactly the readers
--     SELECT. Writing only through masjid_chat_send:
--       1–1000 chars, 1 message / 3 s and 60 / hour per user per mosque,
--       same text twice in a minute refused, banned words (0078 list)
--       refused, links only for accounts older than 7 days with ≥ 20
--       messages in that chat, phone numbers refused (moderators exempt
--       from links/phones), banned/muted refused (mosque sanction or a
--       platform-wide chat-room ban from 0078).
--   * Moderation: report (reason) → hidden after 3 distinct reporters;
--     the author deletes their own message; the mosque's owner and
--     helpers with the new «chat» permission (verified mosques only —
--     masjid_can) hide messages and mute / ban members of THAT mosque;
--     the super admin moderates every mosque (that's who moderates while
--     a mosque has no verified admin) and reviews reported messages in
--     the panel. A newly verified owner gets all of it automatically —
--     nothing is stored per moderator.
--   * No push per message: my_mosques() returns an unread count per
--     mosque (mosque_members.last_read_at, masjid_chat_mark_read).
--   * masjid_join_candidates: mosques within 500 m (distance in metres)
--     or, when there are none, the nearest few beyond.
--   * masjid_nearby_feed («قريب منك»): lessons today/tomorrow, open
--     needs, competitions open for registration, recent urgent/janaza
--     posts — from mosques within ~3 km and the ones the user joined.
--   * nearby_mosques / search_mosques now also return member_count.
--
-- Members, messages, reports, sanctions and the log have no table grants
-- except SELECT on visible messages for readers (Realtime needs it).
-- Run after 0080. Safe to re-run.
-- =====================================================================

-- ------------------------------------------------- «chat» permission
alter table public.mosque_admins drop constraint if exists mosque_admins_permissions_check;
alter table public.mosque_admins add constraint mosque_admins_permissions_check
  check (permissions <@ array['posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings', 'chat']::text[]);

-- ------------------------------------------------------------- tables
create table if not exists public.mosque_members (
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  is_primary boolean not null default false,
  last_read_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  primary key (mosque_id, user_id)
);
create index if not exists mosque_members_user on public.mosque_members (user_id);
create unique index if not exists mosque_members_one_primary on public.mosque_members (user_id) where is_primary;
alter table public.mosque_members enable row level security;
revoke all on public.mosque_members from public, anon, authenticated;

create table if not exists public.mosque_chat_messages (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(btrim(body)) between 1 and 1000),
  reply_to uuid references public.mosque_chat_messages(id) on delete set null,
  is_hidden boolean not null default false,
  hidden_reason text,
  hidden_by uuid references public.profiles(id) on delete set null,
  hidden_at timestamptz,
  reports_count int not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists mosque_chat_messages_mosque on public.mosque_chat_messages (mosque_id, created_at desc);
create index if not exists mosque_chat_messages_user on public.mosque_chat_messages (user_id, mosque_id, created_at desc);
create index if not exists mosque_chat_messages_reported on public.mosque_chat_messages (created_at desc) where reports_count > 0 or is_hidden;

create table if not exists public.mosque_chat_reports (
  message_id uuid not null references public.mosque_chat_messages(id) on delete cascade,
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null default 'إساءة' check (char_length(btrim(reason)) between 2 and 300),
  created_at timestamptz not null default now(),
  primary key (message_id, reporter_id)
);

-- Mutes and bans in one mosque's chat. until null = permanent.
create table if not exists public.mosque_chat_sanctions (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  kind text not null check (kind in ('mute', 'ban')),
  until timestamptz,
  reason text check (reason is null or char_length(reason) <= 300),
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  lifted_at timestamptz,
  lifted_by uuid references public.profiles(id) on delete set null
);
create index if not exists mosque_chat_sanctions_user on public.mosque_chat_sanctions (mosque_id, user_id) where lifted_at is null;

create table if not exists public.mosque_chat_mod_log (
  id bigint generated always as identity primary key,
  mosque_id uuid references public.mosques(id) on delete cascade,
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  message_id uuid,
  target_user uuid references public.profiles(id) on delete set null,
  detail jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create index if not exists mosque_chat_mod_log_mosque on public.mosque_chat_mod_log (mosque_id, created_at desc);

alter table public.mosque_chat_messages enable row level security;
alter table public.mosque_chat_reports enable row level security;
alter table public.mosque_chat_sanctions enable row level security;
alter table public.mosque_chat_mod_log enable row level security;
revoke all on public.mosque_chat_messages, public.mosque_chat_reports, public.mosque_chat_sanctions, public.mosque_chat_mod_log
  from public, anon, authenticated;

-- ------------------------------------------------------------ helpers
create or replace function public.masjid_is_member(p_mosque uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select auth.uid() is not null and exists (
    select 1 from public.mosque_members where mosque_id = p_mosque and user_id = auth.uid());
$$;

-- The mosque's chat moderators: its verified owner / helpers with «chat»,
-- and the platform super admin (always — and the only one while the
-- mosque has no verified admin).
create or replace function public.masjid_chat_can_moderate(p_mosque uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select auth.uid() is not null and (public.is_super_admin() or public.masjid_can(p_mosque, 'chat'));
$$;

create or replace function public.masjid_chat_can_read(p_mosque uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.masjid_is_member(p_mosque) or public.masjid_chat_can_moderate(p_mosque);
$$;

-- The active ban (first) or mute stopping p_user writing in p_mosque's
-- chat. A platform-wide chat-room ban (0078, room_id null) counts too.
create or replace function public.masjid_chat_active_sanction(p_user uuid, p_mosque uuid)
returns table (kind text, until timestamptz)
language sql stable security definer set search_path = public as $$
  select x.kind, x.until from (
    select s.kind, s.until from public.mosque_chat_sanctions s
    where s.user_id = p_user and s.mosque_id = p_mosque and s.lifted_at is null and (s.until is null or s.until > now())
    union all
    select s.kind, s.until from public.chat_sanctions s
    where s.user_id = p_user and s.room_id is null and s.kind = 'ban' and s.lifted_at is null and (s.until is null or s.until > now())
  ) x
  order by (x.kind = 'ban') desc, x.until desc nulls first
  limit 1;
$$;

create or replace function public._masjid_chat_log(p_mosque uuid, p_action text, p_message uuid, p_target uuid, p_detail jsonb default '{}'::jsonb)
returns void
language sql security definer set search_path = public as $$
  insert into public.mosque_chat_mod_log (mosque_id, actor_id, action, message_id, target_user, detail)
  values (p_mosque, auth.uid(), p_action, p_message, p_target, coalesce(p_detail, '{}'::jsonb));
$$;

-- «٠١٢…» → «012…»
create or replace function public._masjid_ascii_digits(p text) returns text
language sql immutable as $$
  select translate(coalesce(p, ''), '٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹', '01234567890123456789');
$$;

revoke execute on function public.masjid_chat_active_sanction(uuid, uuid) from public, anon, authenticated;
revoke execute on function public._masjid_chat_log(uuid, text, uuid, uuid, jsonb) from public, anon, authenticated;
revoke execute on function public._masjid_ascii_digits(text) from public, anon, authenticated;
-- Used by the RLS policy below (they only ever answer about the caller).
revoke execute on function public.masjid_is_member(uuid) from public, anon;
revoke execute on function public.masjid_chat_can_moderate(uuid) from public, anon;
revoke execute on function public.masjid_chat_can_read(uuid) from public, anon;
grant execute on function public.masjid_is_member(uuid) to authenticated;
grant execute on function public.masjid_chat_can_moderate(uuid) to authenticated;
grant execute on function public.masjid_chat_can_read(uuid) to authenticated;

-- Readers (members + moderators) may SELECT visible messages — that's
-- what Realtime delivers. No author id column is granted.
drop policy if exists mosque_chat_messages_readers on public.mosque_chat_messages;
create policy mosque_chat_messages_readers on public.mosque_chat_messages for select to authenticated
  using (not is_hidden and public.masjid_chat_can_read(mosque_id));
grant select (id, mosque_id, body, reply_to, is_hidden, created_at) on public.mosque_chat_messages to authenticated;

do $$
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    raise notice 'supabase_realtime publication not found — skipping (not a Supabase database)';
    return;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'mosque_chat_messages'
  ) then
    alter publication supabase_realtime add table public.mosque_chat_messages;
  end if;
end;
$$;

-- ========================================================= membership

create or replace function public.masjid_join(p_mosque uuid, p_primary boolean default null) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_primary boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not exists (select 1 from public.mosques where id = p_mosque) then
    raise exception 'المسجد مش موجود';
  end if;
  if not exists (select 1 from public.mosque_members where mosque_id = p_mosque and user_id = auth.uid()) then
    if (select count(*) from public.mosque_members where user_id = auth.uid()) >= 20 then
      raise exception 'إنت عضو في 20 مسجد — اخرج من مسجد الأول';
    end if;
    -- The first mosque you join becomes «مسجدي الأساسي».
    v_primary := coalesce(p_primary, false)
      or not exists (select 1 from public.mosque_members where user_id = auth.uid() and is_primary);
    if v_primary then
      update public.mosque_members set is_primary = false where user_id = auth.uid() and is_primary;
    end if;
    insert into public.mosque_members (mosque_id, user_id, is_primary) values (p_mosque, auth.uid(), v_primary);
  elsif p_primary then
    update public.mosque_members set is_primary = false where user_id = auth.uid() and is_primary and mosque_id <> p_mosque;
    update public.mosque_members set is_primary = true where user_id = auth.uid() and mosque_id = p_mosque;
  end if;
  -- Joining follows the mosque, notifications on.
  insert into public.mosque_follows (mosque_id, user_id, notify) values (p_mosque, auth.uid(), true)
  on conflict (mosque_id, user_id) do update set notify = true;
end;
$$;

create or replace function public.masjid_leave(p_mosque uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_was_primary boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  delete from public.mosque_members where mosque_id = p_mosque and user_id = auth.uid()
  returning is_primary into v_was_primary;
  delete from public.mosque_follows where mosque_id = p_mosque and user_id = auth.uid();
  -- Another of your mosques takes over as the primary one.
  if coalesce(v_was_primary, false) then
    update public.mosque_members set is_primary = true
     where user_id = auth.uid() and mosque_id = (
       select mosque_id from public.mosque_members where user_id = auth.uid() order by created_at limit 1);
  end if;
end;
$$;

create or replace function public.masjid_set_primary(p_mosque uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.masjid_is_member(p_mosque) then
    raise exception 'انضم للمسجد الأول';
  end if;
  update public.mosque_members set is_primary = false where user_id = auth.uid() and is_primary and mosque_id <> p_mosque;
  update public.mosque_members set is_primary = true where user_id = auth.uid() and mosque_id = p_mosque;
end;
$$;

-- The caller's mosques with chat activity (unread = others' visible
-- messages since they last opened the chat, capped at 99).
create or replace function public.my_mosques()
returns table (id uuid, name text, address text, area text, lat double precision, lng double precision, verified boolean,
               is_primary boolean, member_count int, unread int, last_message_at timestamptz, joined_at timestamptz)
language sql stable security definer set search_path = public as $$
  select m.id, m.name, m.address, m.area, m.lat, m.lng, m.verified, mm.is_primary,
         (select count(*)::int from public.mosque_members x where x.mosque_id = m.id),
         (select count(*)::int from (
            select 1 from public.mosque_chat_messages c
            where c.mosque_id = m.id and not c.is_hidden and c.created_at > mm.last_read_at and c.user_id <> auth.uid()
            limit 99) u),
         (select max(c.created_at) from public.mosque_chat_messages c where c.mosque_id = m.id and not c.is_hidden),
         mm.created_at
  from public.mosque_members mm
  join public.mosques m on m.id = mm.mosque_id
  where mm.user_id = auth.uid()
  order by mm.is_primary desc, mm.created_at;
$$;

-- Moderators see who's in the mosque and any active sanction.
create or replace function public.masjid_members(p_mosque uuid)
returns table (user_id uuid, full_name text, joined_at timestamptz, is_admin boolean, messages int,
               sanction text, sanction_until timestamptz)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.masjid_chat_can_moderate(p_mosque) then
    raise exception 'غير مصرح';
  end if;
  return query
  select mm.user_id, p.full_name, mm.created_at,
         exists (select 1 from public.mosque_admins a where a.mosque_id = p_mosque and a.user_id = mm.user_id),
         (select count(*)::int from public.mosque_chat_messages c where c.mosque_id = p_mosque and c.user_id = mm.user_id),
         s.kind, s.until
  from public.mosque_members mm
  join public.profiles p on p.id = mm.user_id
  left join lateral public.masjid_chat_active_sanction(mm.user_id, p_mosque) s on true
  where mm.mosque_id = p_mosque
  order by mm.created_at desc
  limit 1000;
end;
$$;

-- ============================================================ the chat

create or replace function public.masjid_chat_messages(
  p_mosque uuid, p_after timestamptz default null, p_before timestamptz default null, p_limit int default 60
) returns table (
  id uuid, author_id uuid, author_name text, author_is_admin boolean, body text,
  reply_to uuid, reply_name text, reply_body text, created_at timestamptz, mine boolean
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.masjid_chat_can_read(p_mosque) then
    raise exception 'انضم للمسجد عشان تشوف الشات وتشارك';
  end if;
  return query
  select x.id, x.author_id, x.author_name, x.author_is_admin, x.body, x.reply_to, x.reply_name, x.reply_body, x.created_at, x.mine
  from (
    select c.id, c.user_id as author_id, coalesce(p.full_name, 'عضو') as author_name,
           exists (select 1 from public.mosque_admins a join public.mosques mq on mq.id = a.mosque_id
                   where a.mosque_id = c.mosque_id and a.user_id = c.user_id and mq.verified) as author_is_admin,
           c.body, c.reply_to, rp.full_name as reply_name, left(r.body, 140) as reply_body, c.created_at,
           c.user_id = auth.uid() as mine
    from public.mosque_chat_messages c
    join public.profiles p on p.id = c.user_id
    left join public.mosque_chat_messages r on r.id = c.reply_to and not r.is_hidden
    left join public.profiles rp on rp.id = r.user_id
    where c.mosque_id = p_mosque
      and not c.is_hidden
      and (p_after is null or c.created_at > p_after)
      and (p_before is null or c.created_at < p_before)
      and not public.is_blocked_between(auth.uid(), c.user_id)
    order by case when p_after is null then c.created_at end desc, c.created_at asc
    limit least(greatest(coalesce(p_limit, 60), 1), 200)
  ) x
  order by x.created_at;
end;
$$;

create or replace function public.masjid_chat_send(p_mosque uuid, p_body text, p_reply_to uuid default null) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_body text := btrim(coalesce(p_body, ''));
  v_flat text;
  v_mod boolean;
  v_kind text;
  v_until timestamptz;
  v_last timestamptz;
  v_reply public.mosque_chat_messages;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  if not exists (select 1 from public.mosques where id = p_mosque) then
    raise exception 'المسجد مش موجود';
  end if;
  v_mod := public.masjid_chat_can_moderate(p_mosque);
  if not public.masjid_is_member(p_mosque) and not public.masjid_can(p_mosque, 'chat') then
    raise exception 'انضم للمسجد عشان تشارك في الشات';
  end if;

  select s.kind, s.until into v_kind, v_until from public.masjid_chat_active_sanction(auth.uid(), p_mosque) s;
  if v_kind = 'ban' then
    raise exception '%', case when v_until is null then 'إنت ممنوع من الكتابة في شات المسجد ده'
                              else 'إنت ممنوع من الكتابة في شات المسجد لحد ' || to_char(v_until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI') end;
  end if;
  if v_kind = 'mute' then
    raise exception 'إنت مكتوم مؤقتاً في شات المسجد لحد %', to_char(v_until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI');
  end if;

  if char_length(v_body) < 1 then
    raise exception 'اكتب رسالة الأول';
  end if;
  if char_length(v_body) > 1000 then
    raise exception 'الرسالة طويلة، الحد 1000 حرف';
  end if;

  select max(created_at) into v_last from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque;
  if v_last is not null and v_last > now() - interval '3 seconds' then
    raise exception 'استنى ثانيتين قبل الرسالة الجاية';
  end if;
  if (select count(*) from public.mosque_chat_messages
      where user_id = auth.uid() and mosque_id = p_mosque and created_at > now() - interval '1 hour') >= 60 then
    raise exception 'كتبت رسايل كتير الساعة دي، استنى شوية';
  end if;
  if exists (select 1 from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque
             and body = v_body and created_at > now() - interval '1 minute') then
    raise exception 'إنت لسه باعت نفس الرسالة';
  end if;

  if public.chat_has_banned_word(v_body) then
    raise exception 'الرسالة فيها كلام مش لطيف، عدّلها وابعت تاني';
  end if;

  if not v_mod then
    v_flat := regexp_replace(public._masjid_ascii_digits(v_body), '[\s\-\.()]', '', 'g');
    if v_flat ~ '(\+?20|0)1[0125][0-9]{8}' then
      raise exception 'ممنوع أرقام الموبايل في شات المسجد — اتواصلوا خاص';
    end if;
    if lower(v_body) ~ '(https?://|www\.|t\.me/|wa\.me/|bit\.ly|[a-z0-9-]+\.(com|net|org|eg|io|me|ly|co|info|xyz|link|app|site|online|store|shop|tk|biz)([^a-z0-9]|$))' then
      if (select created_at from public.profiles where id = auth.uid()) > now() - interval '7 days'
         or (select count(*) from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque) < 20 then
        raise exception 'اللينكات مسموحة بعد ما يعدّي على حسابك أسبوع وتكتب 20 رسالة في شات المسجد';
      end if;
    end if;
  end if;

  if p_reply_to is not null then
    select * into v_reply from public.mosque_chat_messages where id = p_reply_to;
    if v_reply.id is null or v_reply.mosque_id <> p_mosque or v_reply.is_hidden then
      raise exception 'الرسالة اللي بترد عليها مش موجودة';
    end if;
  end if;

  insert into public.mosque_chat_messages (mosque_id, user_id, body, reply_to)
  values (p_mosque, auth.uid(), v_body, p_reply_to)
  returning id into v_id;
  -- Your own message means you've read the chat up to here.
  update public.mosque_members set last_read_at = now() where mosque_id = p_mosque and user_id = auth.uid();
  return v_id;
end;
$$;

create or replace function public.masjid_chat_mark_read(p_mosque uuid) returns void
language sql security definer set search_path = public as $$
  update public.mosque_members set last_read_at = now() where mosque_id = p_mosque and user_id = auth.uid();
$$;

-- Returns true when the message is now hidden (3 distinct reporters).
create or replace function public.masjid_chat_report(p_message uuid, p_reason text default null) returns boolean
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.mosque_chat_messages;
  v_count int;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into v_msg from public.mosque_chat_messages where id = p_message;
  if v_msg.id is null or not public.masjid_chat_can_read(v_msg.mosque_id) then
    raise exception 'الرسالة مش موجودة';
  end if;
  if v_msg.user_id = auth.uid() then
    raise exception 'مينفعش تبلّغ عن رسالتك';
  end if;
  if exists (select 1 from public.mosque_chat_reports where message_id = p_message and reporter_id = auth.uid()) then
    raise exception 'بلّغت عن الرسالة دي قبل كده';
  end if;
  if (select count(*) from public.mosque_chat_reports where reporter_id = auth.uid() and created_at > now() - interval '1 day') >= 30 then
    raise exception 'بلّغت كتير النهارده';
  end if;
  insert into public.mosque_chat_reports (message_id, reporter_id, reason)
  values (p_message, auth.uid(), left(coalesce(nullif(btrim(coalesce(p_reason, '')), ''), 'إساءة'), 300));
  select count(*) into v_count from public.mosque_chat_reports where message_id = p_message;
  update public.mosque_chat_messages set reports_count = v_count where id = p_message;
  if v_count >= 3 and not v_msg.is_hidden then
    update public.mosque_chat_messages set is_hidden = true, hidden_reason = 'auto_reports', hidden_at = now() where id = p_message;
    insert into public.mosque_chat_mod_log (mosque_id, actor_id, action, message_id, target_user, detail)
    values (v_msg.mosque_id, null, 'auto_hide', p_message, v_msg.user_id, jsonb_build_object('reports', v_count));
    return true;
  end if;
  return v_msg.is_hidden;
end;
$$;

-- The author deletes their own message (gone for good); a moderator
-- removes someone else's (hidden, kept for the review/log).
create or replace function public.masjid_chat_delete(p_message uuid, p_reason text default null) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.mosque_chat_messages;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into v_msg from public.mosque_chat_messages where id = p_message;
  if v_msg.id is null then
    raise exception 'الرسالة مش موجودة';
  end if;
  if v_msg.user_id = auth.uid() then
    delete from public.mosque_chat_messages where id = p_message;
    return;
  end if;
  if not public.masjid_chat_can_moderate(v_msg.mosque_id) then
    raise exception 'غير مصرح';
  end if;
  update public.mosque_chat_messages
     set is_hidden = true, hidden_reason = coalesce(left(nullif(btrim(coalesce(p_reason, '')), ''), 100), 'moderator'),
         hidden_by = auth.uid(), hidden_at = now()
   where id = p_message;
  perform public._masjid_chat_log(v_msg.mosque_id, 'hide', p_message, v_msg.user_id, jsonb_build_object('reason', p_reason));
end;
$$;

-- Mute (p_minutes, ≤ 30 days) or ban (p_minutes null = permanent) a
-- person from ONE mosque's chat. The mosque's own admins can only be
-- sanctioned by the super admin.
create or replace function public.masjid_chat_sanction(p_mosque uuid, p_user uuid, p_kind text, p_minutes int default null, p_reason text default null)
returns timestamptz
language plpgsql security definer set search_path = public as $$
declare
  v_until timestamptz;
begin
  if not public.masjid_chat_can_moderate(p_mosque) then
    raise exception 'غير مصرح';
  end if;
  if p_kind not in ('mute', 'ban') then
    raise exception 'نوع العقوبة غير صحيح';
  end if;
  if p_user is null or p_user = auth.uid() then
    raise exception 'مينفعش تعاقب نفسك';
  end if;
  if not public.is_super_admin() and (
       exists (select 1 from public.mosque_admins where mosque_id = p_mosque and user_id = p_user)
       or exists (select 1 from public.profiles where id = p_user and role = 'super_admin')) then
    raise exception 'مينفعش تعاقب حد من إدارة المسجد';
  end if;
  if p_kind = 'mute' and (p_minutes is null or p_minutes < 1 or p_minutes > 43200) then
    raise exception 'مدة الكتم مش مظبوطة';
  end if;
  if p_kind = 'ban' and p_minutes is not null and p_minutes < 1 then
    raise exception 'مدة الحظر مش مظبوطة';
  end if;
  v_until := case when p_minutes is not null then now() + make_interval(mins => p_minutes) end;
  insert into public.mosque_chat_sanctions (mosque_id, user_id, kind, until, reason, created_by)
  values (p_mosque, p_user, p_kind, v_until, left(nullif(btrim(coalesce(p_reason, '')), ''), 300), auth.uid());
  perform public._masjid_chat_log(p_mosque, p_kind, null, p_user, jsonb_build_object('minutes', p_minutes, 'reason', p_reason));
  return v_until;
end;
$$;

create or replace function public.masjid_chat_lift(p_mosque uuid, p_user uuid) returns int
language plpgsql security definer set search_path = public as $$
declare
  n int;
begin
  if not public.masjid_chat_can_moderate(p_mosque) then
    raise exception 'غير مصرح';
  end if;
  update public.mosque_chat_sanctions set lifted_at = now(), lifted_by = auth.uid()
   where mosque_id = p_mosque and user_id = p_user and lifted_at is null;
  get diagnostics n = row_count;
  perform public._masjid_chat_log(p_mosque, 'lift', null, p_user, '{}'::jsonb);
  return n;
end;
$$;

-- ---------------------------------------------------- super admin
-- Reported or hidden mosque-chat messages, unverified mosques first
-- (nobody else moderates those).
create or replace function public.admin_mosque_chat_reports()
returns table (id uuid, mosque_id uuid, mosque_name text, mosque_verified boolean, body text, created_at timestamptz,
               is_hidden boolean, hidden_reason text, reports_count int, reasons text[],
               user_id uuid, full_name text, phone text, sanction text)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  return query
  select c.id, m.id, m.name, m.verified, c.body, c.created_at, c.is_hidden, c.hidden_reason, c.reports_count,
         array(select r.reason from public.mosque_chat_reports r where r.message_id = c.id order by r.created_at),
         c.user_id, p.full_name, p.phone,
         (select s.kind || coalesce(' ' || to_char(s.until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI'), ' دائم')
            from public.masjid_chat_active_sanction(c.user_id, c.mosque_id) s)
  from public.mosque_chat_messages c
  join public.mosques m on m.id = c.mosque_id
  join public.profiles p on p.id = c.user_id
  where c.reports_count > 0 or (c.is_hidden and c.hidden_reason = 'auto_reports')
  order by m.verified, c.is_hidden desc, c.created_at desc
  limit 300;
end;
$$;

-- Restore a hidden message / dismiss its reports.
create or replace function public.admin_restore_mosque_chat_message(p_message uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_mosque uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  update public.mosque_chat_messages set is_hidden = false, hidden_reason = null, hidden_by = null, hidden_at = null, reports_count = 0
   where id = p_message returning mosque_id into v_mosque;
  if v_mosque is null then
    raise exception 'الرسالة مش موجودة';
  end if;
  delete from public.mosque_chat_reports where message_id = p_message;
  perform public._masjid_chat_log(v_mosque, 'restore', p_message, null, '{}'::jsonb);
end;
$$;

-- =========================================================== discovery

-- «انضم لمسجدك»: mosques within p_radius_m (default 500 m) of the user,
-- nearest first. When there is none, the nearest p_fallback beyond it
-- (within ~20 km), flagged within = false.
create or replace function public.masjid_join_candidates(
  p_lat double precision, p_lng double precision, p_radius_m int default 500, p_fallback int default 5
) returns table (
  id uuid, name text, address text, area text, governorate text, lat double precision, lng double precision,
  verified boolean, member_count int, distance_m int, within boolean, is_member boolean
)
language sql stable security definer set search_path = public as $$
  with box as (
    select 20.0 / 111.0 as dlat, 20.0 / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng,
           least(greatest(coalesce(p_radius_m, 500), 50), 5000) as radius
  ), d as (
    select m.*, (111195.0 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2))) as dist
    from public.mosques m, box
    where p_lat is not null and p_lng is not null
      and m.lat between p_lat - box.dlat and p_lat + box.dlat
      and m.lng between p_lng - box.dlng and p_lng + box.dlng
  ), near as (
    select d.* from d, box where d.dist <= box.radius order by d.dist limit 50
  ), far as (
    select d.* from d, box where d.dist > box.radius and not exists (select 1 from near)
    order by d.dist limit least(greatest(coalesce(p_fallback, 5), 1), 20)
  )
  select x.id, x.name, x.address, x.area, x.governorate, x.lat, x.lng, x.verified,
         (select count(*)::int from public.mosque_members mm where mm.mosque_id = x.id),
         round(x.dist)::int, x.dist <= (select radius from box),
         auth.uid() is not null and exists (select 1 from public.mosque_members mm where mm.mosque_id = x.id and mm.user_id = auth.uid())
  from (select * from near union all select * from far) x
  order by x.dist;
$$;

-- «قريب منك»: what's happening at mosques within p_km (and the ones the
-- caller joined): lessons/circles today or tomorrow, open needs with
-- confirmed progress, competitions open for registration, urgent/janaza
-- posts from the last 2 days. Public data only.
create or replace function public.masjid_nearby_feed(
  p_lat double precision default null, p_lng double precision default null, p_km double precision default 3, p_limit int default 30
) returns table (
  kind text, item_id uuid, mosque_id uuid, mosque_name text, distance_km double precision,
  title text, subtitle text, extra jsonb, at timestamptz
)
language sql stable security definer set search_path = public as $$
  with box as (
    select least(greatest(coalesce(p_km, 3), 0.5), 15) as km
  ), ms as (
    select m.id, m.name,
           case when p_lat is not null and p_lng is not null
                then 111.195 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) end as dist
    from public.mosques m, box
    where (p_lat is not null and p_lng is not null
           and m.lat between p_lat - box.km / 111.0 and p_lat + box.km / 111.0
           and m.lng between p_lng - box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2))
                         and p_lng + box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2)))
       or (auth.uid() is not null and exists (select 1 from public.mosque_members mm where mm.mosque_id = m.id and mm.user_id = auth.uid()))
  ), today as (
    select extract(isodow from (now() at time zone 'Africa/Cairo'))::smallint as d,
           (now() at time zone 'Africa/Cairo')::date as day
  ), items as (
    (select 'urgent'::text as kind, p.id, ms.id as mosque_id, ms.name, ms.dist, p.title, p.body as subtitle,
            jsonb_build_object('post_kind', p.kind) as extra, p.created_at as at, 0 as prio
     from public.mosque_posts p join ms on ms.id = p.mosque_id
     where p.kind in ('urgent', 'janaza') and p.created_at > now() - interval '2 days'
     order by p.created_at desc limit 6)
    union all
    (select 'lesson', l.id, ms.id, ms.name, ms.dist, l.title, l.sheikh,
            jsonb_build_object('lesson_kind', l.kind, 'weekdays', to_jsonb(l.weekdays), 'after_prayer', l.after_prayer,
                               'start_time', l.start_time, 'audience', l.audience,
                               'today', (select d from today) = any(l.weekdays)),
            null::timestamptz, 1
     from public.mosque_lessons l join ms on ms.id = l.mosque_id
     where l.active and (cardinality(l.weekdays) = 0
                         or (select d from today) = any(l.weekdays)
                         or ((select d from today) % 7 + 1)::smallint = any(l.weekdays))
     order by ((select d from today) = any(l.weekdays)) desc, ms.dist nulls last limit 10)
    union all
    (select 'need', n.id, ms.id, ms.name, ms.dist, n.title, n.description,
            jsonb_build_object('target_amount', n.target_amount,
                               'confirmed_amount', coalesce((select sum(c.amount) from public.mosque_need_contributions c
                                                             where c.need_id = n.id and c.status = 'confirmed'), 0)),
            n.created_at, 2
     from public.mosque_needs n join ms on ms.id = n.mosque_id
     where n.status = 'open'
     order by ms.dist nulls last, n.created_at desc limit 8)
    union all
    (select 'competition', c.id, ms.id, ms.name, ms.dist, c.title, c.description,
            jsonb_build_object('registration_deadline', c.registration_deadline, 'starts_on', c.starts_on),
            c.created_at, 3
     from public.mosque_competitions c join ms on ms.id = c.mosque_id
     where c.status = 'open' and (c.registration_deadline is null or c.registration_deadline >= (select day from today))
     order by ms.dist nulls last, c.created_at desc limit 6)
  )
  select i.kind, i.id, i.mosque_id, i.name, i.dist, i.title, left(i.subtitle, 200), i.extra, i.at
  from items i
  order by i.prio, i.dist nulls last, i.at desc nulls last
  limit least(greatest(coalesce(p_limit, 30), 1), 60);
$$;

-- nearby_mosques / search_mosques gain member_count (return type changes,
-- so they are dropped and recreated with the same arguments).
drop function if exists public.nearby_mosques(double precision, double precision, double precision, int);
create function public.nearby_mosques(
  p_lat double precision, p_lng double precision, p_km double precision default 5, p_limit int default 40
) returns table (
  id uuid, name text, address text, area text, governorate text,
  lat double precision, lng double precision, verified boolean, distance_km double precision, member_count int
)
language sql
stable
security definer
set search_path = public
as $$
  with box as (
    select least(greatest(coalesce(p_km, 5), 0.3), 50) / 111.0 as dlat,
           least(greatest(coalesce(p_km, 5), 0.3), 50) / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng
  )
  select m.id, m.name, m.address, m.area, m.governorate, m.lat, m.lng, m.verified,
         111.0 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) as distance_km,
         (select count(*)::int from public.mosque_members mm where mm.mosque_id = m.id)
  from public.mosques m, box
  where m.lat between p_lat - box.dlat and p_lat + box.dlat
    and m.lng between p_lng - box.dlng and p_lng + box.dlng
  order by distance_km
  limit least(greatest(coalesce(p_limit, 40), 1), 100);
$$;

drop function if exists public.search_mosques(text, double precision, double precision, int);
create function public.search_mosques(
  p_query text, p_lat double precision default null, p_lng double precision default null, p_limit int default 30
) returns table (
  id uuid, name text, address text, area text, governorate text,
  lat double precision, lng double precision, verified boolean, distance_km double precision, member_count int
)
language sql
stable
security definer
set search_path = public
as $$
  with q as (
    select '%' || replace(replace(replace(btrim(coalesce(p_query, '')), '\', '\\'), '%', '\%'), '_', '\_') || '%' as pat
  )
  select m.id, m.name, m.address, m.area, m.governorate, m.lat, m.lng, m.verified,
         case when p_lat is not null and p_lng is not null
              then 111.0 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) end as distance_km,
         (select count(*)::int from public.mosque_members mm where mm.mosque_id = m.id)
  from public.mosques m, q
  where char_length(btrim(coalesce(p_query, ''))) >= 2
    and (m.name ilike q.pat or m.area ilike q.pat or m.governorate ilike q.pat or m.address ilike q.pat)
  order by (m.name ilike q.pat) desc, m.verified desc, distance_km nulls last, m.name
  limit least(greatest(coalesce(p_limit, 30), 1), 60);
$$;

-- ============================================= 0080 functions, updated

-- get_mosque: + members, membership, chat counts, chat moderation and
-- «chat» in the owner's permissions.
create or replace function public.get_mosque(p_id uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  m public.mosques;
  a public.mosque_admins;
  f public.mosque_follows;
  mm public.mosque_members;
  v_perms text[];
begin
  select * into m from public.mosques where id = p_id;
  if not found then
    return null;
  end if;
  if auth.uid() is not null then
    select * into a from public.mosque_admins where mosque_id = p_id and user_id = auth.uid();
    select * into f from public.mosque_follows where mosque_id = p_id and user_id = auth.uid();
    select * into mm from public.mosque_members where mosque_id = p_id and user_id = auth.uid();
  end if;
  v_perms := case
    when a.user_id is null or not m.verified then '{}'::text[]
    when a.role = 'owner' then array['posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings', 'chat', 'team']
    else a.permissions end;
  return jsonb_build_object(
    'id', m.id, 'name', m.name, 'lat', m.lat, 'lng', m.lng, 'address', m.address,
    'governorate', m.governorate, 'area', m.area, 'verified', m.verified,
    'contact_phone', m.contact_phone, 'contact_whatsapp', m.contact_whatsapp, 'payment_note', m.payment_note,
    'friday_khutba_time', m.friday_khutba_time, 'khatib', m.khatib,
    'iqama', jsonb_build_object('fajr', m.iqama_fajr, 'dhuhr', m.iqama_dhuhr, 'asr', m.iqama_asr,
                                'maghrib', m.iqama_maghrib, 'isha', m.iqama_isha),
    'followers', (select count(*) from public.mosque_follows x where x.mosque_id = m.id),
    'members', (select count(*) from public.mosque_members x where x.mosque_id = m.id),
    'is_member', mm.user_id is not null,
    'is_primary', coalesce(mm.is_primary, false),
    'chat_messages', (select count(*) from public.mosque_chat_messages c where c.mosque_id = m.id and not c.is_hidden),
    'chat_today', (select count(*) from public.mosque_chat_messages c
                   where c.mosque_id = m.id and not c.is_hidden and c.created_at > now() - interval '24 hours'),
    'can_moderate_chat', auth.uid() is not null and public.masjid_chat_can_moderate(m.id),
    'is_following', f.user_id is not null,
    'notify', coalesce(f.notify, false),
    'my_role', a.role,
    'my_permissions', to_jsonb(v_perms),
    'my_pending_claim', auth.uid() is not null and exists (
      select 1 from public.mosque_claims c where c.mosque_id = m.id and c.user_id = auth.uid() and c.status = 'pending'));
end;
$$;
grant execute on function public.get_mosque(uuid) to anon, authenticated;

-- masjid_add_mosque: the creator joins the mosque they added (or found).
create or replace function public.masjid_add_mosque(
  p_name text, p_lat double precision, p_lng double precision,
  p_address text default null, p_area text default null, p_governorate text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_name text := btrim(coalesce(p_name, ''));
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if char_length(v_name) < 3 then
    raise exception 'اكتب اسم المسجد';
  end if;
  if p_lat is null or p_lng is null or p_lat not between 21 and 32.5 or p_lng not between 24 and 37.5 then
    raise exception 'حدد مكان المسجد على الخريطة (جوه مصر)';
  end if;
  select id into v_id from public.mosques
  where name = v_name and abs(lat - p_lat) < 0.002 and abs(lng - p_lng) < 0.002 limit 1;
  if v_id is null then
    if (select count(*) from public.mosques where added_by = auth.uid() and created_at > now() - interval '1 day') >= 3 then
      raise exception 'ضفت مساجد كتير النهارده، جرّب بكرة';
    end if;
    insert into public.mosques (name, lat, lng, address, area, governorate, added_by)
    values (left(v_name, 120), p_lat, p_lng, left(nullif(btrim(p_address), ''), 300),
            left(nullif(btrim(p_area), ''), 80), left(nullif(btrim(p_governorate), ''), 60), auth.uid())
    returning id into v_id;
  end if;
  -- Best effort: someone already in 20 mosques still gets the mosque added.
  begin
    perform public.masjid_join(v_id);
  exception when others then
    null;
  end;
  return v_id;
end;
$$;
revoke execute on function public.masjid_add_mosque(text, double precision, double precision, text, text, text) from public, anon;
grant execute on function public.masjid_add_mosque(text, double precision, double precision, text, text, text) to authenticated;

-- masjid_add_helper: «chat» is a grantable permission now.
create or replace function public.masjid_add_helper(p_mosque uuid, p_phone text, p_permissions text[], p_title text default null)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_phone text := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
  v_user uuid;
  v_name text;
  v_perms text[];
begin
  if not public.masjid_can(p_mosque, 'team') then
    raise exception 'غير مصرح';
  end if;
  if v_phone ~ '^20' and char_length(v_phone) = 12 then
    v_phone := '0' || substr(v_phone, 3);
  end if;
  select id, full_name into v_user, v_name from public.profiles where phone = v_phone;
  if v_user is null then
    raise exception 'مفيش حساب على مُجتمعي بالرقم ده — خلّيه يعمل حساب الأول';
  end if;
  if v_user = auth.uid() then
    raise exception 'إنت بالفعل مسؤول';
  end if;
  select coalesce(array_agg(distinct p), '{}') into v_perms
  from unnest(coalesce(p_permissions, '{}')) p
  where p in ('posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings', 'chat');
  if cardinality(v_perms) = 0 then
    raise exception 'اختار صلاحية واحدة على الأقل';
  end if;
  if exists (select 1 from public.mosque_admins where mosque_id = p_mosque and user_id = v_user and role = 'owner') then
    raise exception 'الشخص ده مسؤول أساسي بالفعل';
  end if;
  if (select count(*) from public.mosque_admins where mosque_id = p_mosque) >= 30 then
    raise exception 'وصلت لأقصى عدد مساعدين';
  end if;
  insert into public.mosque_admins (mosque_id, user_id, role, title, permissions, added_by)
  values (p_mosque, v_user, 'helper', left(nullif(btrim(p_title), ''), 40), v_perms, auth.uid())
  on conflict (mosque_id, user_id) do update set permissions = excluded.permissions, title = excluded.title;
  insert into public.notifications (user_id, title, body, deep_link)
  select v_user, 'بقيت من فريق «' || m.name || '»', 'تقدر تساعد في إدارة صفحة المسجد على مسجدي.', '/#/masjid/' || m.id
  from public.mosques m where m.id = p_mosque;
  return v_name;
end;
$$;
revoke execute on function public.masjid_add_helper(uuid, text, text[], text) from public, anon;
grant execute on function public.masjid_add_helper(uuid, text, text[], text) to authenticated;

-- -------------------------------------------------------------- grants
do $$
declare f text;
begin
  -- Readable by guests too.
  foreach f in array array[
    'masjid_join_candidates(double precision, double precision, int, int)',
    'masjid_nearby_feed(double precision, double precision, double precision, int)',
    'nearby_mosques(double precision, double precision, double precision, int)',
    'search_mosques(text, double precision, double precision, int)'
  ] loop
    execute format('revoke execute on function public.%s from public', f);
    execute format('grant execute on function public.%s to anon, authenticated', f);
  end loop;
  foreach f in array array[
    'masjid_join(uuid, boolean)', 'masjid_leave(uuid)', 'masjid_set_primary(uuid)', 'my_mosques()',
    'masjid_members(uuid)', 'masjid_chat_messages(uuid, timestamptz, timestamptz, int)',
    'masjid_chat_send(uuid, text, uuid)', 'masjid_chat_mark_read(uuid)', 'masjid_chat_report(uuid, text)',
    'masjid_chat_delete(uuid, text)', 'masjid_chat_sanction(uuid, uuid, text, int, text)', 'masjid_chat_lift(uuid, uuid)',
    'admin_mosque_chat_reports()', 'admin_restore_mosque_chat_message(uuid)'
  ] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end;
$$;
