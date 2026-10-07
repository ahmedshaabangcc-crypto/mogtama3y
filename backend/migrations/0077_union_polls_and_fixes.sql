-- =====================================================================
-- Migration 0077 — resident polls (تصويت السكان), official announcements
-- with a notification, and the "إظهار اسم العائلة فقط" privacy option.
--
--   1. Building polls: the president/board ask a question with 2–6
--      options and an end time. Every verified member may vote, but each
--      apartment (unit) has exactly ONE vote: the first household member
--      to vote casts it, the others see «شقتكم صوّتت». Votes are never
--      readable row by row — results come from list_building_polls as
--      counts per option plus turnout (units voted / units in the
--      building with a verified member). Opening a poll notifies members.
--   2. «إعلان رسمي»: posts already allowed board members to insert an
--      'official', pinned post (0038) but nothing told the residents.
--      publish_official_announcement posts it AND notifies every
--      verified member; set_post_pinned lets the board unpin old ones.
--   3. union_members.show_family_name_only existed since schema.sql but
--      the join form never sent it. set_my_name_privacy stores it, and
--      member_display_name / building_member_names return «عائلة <last
--      word of the name>» to other residents when it is on. The member
--      themselves, the building's president/board and the platform admin
--      still see the full name. fetch_building_posts now uses it.
--
-- Run after 0076, in order, in the Supabase SQL editor.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Display names that respect "family name only"
-- ---------------------------------------------------------------------
create or replace function public.member_display_name(p_building_id uuid, p_user_id uuid) returns text
language sql
security definer
stable
set search_path = public
as $$
  select case
    when p_user_id = auth.uid()
      or public.is_super_admin()
      or not coalesce((select m.show_family_name_only from public.union_members m
                        where m.building_id = p_building_id and m.user_id = p_user_id), false)
      or exists (select 1 from public.union_members b
                  where b.building_id = p_building_id and b.user_id = auth.uid()
                    and b.status = 'verified' and b.role in ('president', 'board_member'))
    then p.full_name
    else 'عائلة ' || coalesce(nullif(regexp_replace(btrim(p.full_name), '^.*\s', ''), ''), p.full_name)
  end
  from public.profiles p
  where p.id = p_user_id;
$$;

revoke execute on function public.member_display_name(uuid, uuid) from public, anon;
grant execute on function public.member_display_name(uuid, uuid) to authenticated;

-- Names of a building's members as the caller may see them (chat,
-- comments, candidates…). Empty unless the caller is a verified member.
create or replace function public.building_member_names(p_building_id uuid)
returns table (user_id uuid, display_name text)
language sql
security definer
stable
set search_path = public
as $$
  select m.user_id, public.member_display_name(p_building_id, m.user_id)
    from public.union_members m
   where m.building_id = p_building_id
     and m.status = 'verified'
     and public.is_verified_member_of(p_building_id);
$$;

revoke execute on function public.building_member_names(uuid) from public, anon;
grant execute on function public.building_member_names(uuid) to authenticated;

-- The join form's switch. Works on a pending request too, so it can be
-- sent right after join_building_with_code. Without a building it
-- applies to every membership of the caller.
create or replace function public.set_my_name_privacy(p_family_only boolean, p_building_id uuid default null) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  update public.union_members
     set show_family_name_only = coalesce(p_family_only, false)
   where user_id = auth.uid()
     and (p_building_id is null or building_id = p_building_id);
  if not found then
    raise exception 'إنت مش عضو في العمارة دي';
  end if;
end;
$$;

revoke execute on function public.set_my_name_privacy(boolean, uuid) from public, anon;
grant execute on function public.set_my_name_privacy(boolean, uuid) to authenticated;

-- The union feed shows the masked name too.
create or replace function public.fetch_building_posts(p_building_id uuid)
returns table (
  id uuid, author_id uuid, author_name text, type text, body text,
  images text[], is_pinned boolean, created_at timestamptz,
  comment_count bigint, reaction_count bigint
)
language sql
stable
security invoker
set search_path = public
as $$
  select
    p.id, p.author_id, public.member_display_name(p.building_id, p.author_id), p.type::text, p.body, p.images, p.is_pinned, p.created_at,
    (select count(*) from public.post_comments c where c.post_id = p.id),
    (select count(*) from public.post_reactions r where r.post_id = p.id)
  from public.posts p
  where p.building_id = p_building_id
  order by p.is_pinned desc, p.created_at desc;
$$;

grant execute on function public.fetch_building_posts(uuid) to authenticated;


-- ---------------------------------------------------------------------
-- 2. Official announcements (إعلان رسمي)
-- ---------------------------------------------------------------------
create or replace function public.publish_official_announcement(p_body text, p_building_id uuid default null) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_body text := btrim(coalesce(p_body, ''));
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null then
    raise exception 'الإعلان الرسمي لرئيس الاتحاد وأعضاء المجلس بس';
  end if;
  if char_length(v_body) < 3 then
    raise exception 'اكتب نص الإعلان';
  end if;
  if char_length(v_body) > 2000 then
    raise exception 'الإعلان طويل أوي (الحد 2000 حرف)';
  end if;

  insert into public.posts (building_id, author_id, type, body, is_pinned)
  values (v_building_id, auth.uid(), 'official', v_body, true)
  returning id into v_id;

  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, '📢 إعلان رسمي من اتحاد العمارة',
         case when char_length(v_body) > 140 then left(v_body, 140) || '…' else v_body end,
         '/#/feed'
    from public.union_members m
   where m.building_id = v_building_id and m.status = 'verified' and m.user_id <> auth.uid();

  return v_id;
end;
$$;

-- Board members unpin (or re-pin) a post of their building.
create or replace function public.set_post_pinned(p_post_id uuid, p_pinned boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
begin
  select building_id into v_building_id from public.posts where id = p_post_id;
  if v_building_id is null then
    raise exception 'المنشور مش موجود';
  end if;
  if public._board_building_for(v_building_id) is null then
    raise exception 'التثبيت لرئيس الاتحاد وأعضاء المجلس بس';
  end if;
  update public.posts set is_pinned = coalesce(p_pinned, false) where id = p_post_id;
end;
$$;

revoke execute on function public.publish_official_announcement(text, uuid) from public, anon;
grant execute on function public.publish_official_announcement(text, uuid) to authenticated;
revoke execute on function public.set_post_pinned(uuid, boolean) from public, anon;
grant execute on function public.set_post_pinned(uuid, boolean) to authenticated;


-- ---------------------------------------------------------------------
-- 3. Resident polls (تصويت السكان) — one vote per apartment
-- ---------------------------------------------------------------------
create table if not exists public.union_polls (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  created_by uuid not null references public.profiles(id),
  question text not null check (char_length(question) between 3 and 300),
  options text[] not null check (array_length(options, 1) between 2 and 6),
  ends_at timestamptz not null,
  closed_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists union_polls_building on public.union_polls (building_id, created_at desc);

-- The primary key IS the rule: one row per (poll, apartment).
create table if not exists public.union_poll_votes (
  poll_id uuid not null references public.union_polls(id) on delete cascade,
  unit_id uuid not null references public.units(id) on delete cascade,
  voter_id uuid not null references public.profiles(id) on delete cascade,
  option_index smallint not null,
  created_at timestamptz not null default now(),
  primary key (poll_id, unit_id)
);

alter table public.union_polls enable row level security;
alter table public.union_poll_votes enable row level security;
revoke all on public.union_polls from anon, authenticated;
revoke all on public.union_poll_votes from anon, authenticated;
-- Members may read their building's polls; everything else (creating,
-- voting, results) goes through the functions below. Individual votes
-- are not readable at all.
grant select on public.union_polls to authenticated;
create policy "union_polls: building members read" on public.union_polls
  for select to authenticated using (public.is_verified_member_of(building_id));

create or replace function public.create_building_poll(
  p_question text,
  p_options text[],
  p_ends_at timestamptz,
  p_building_id uuid default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_question text := btrim(coalesce(p_question, ''));
  v_options text[];
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null then
    raise exception 'رئيس الاتحاد وأعضاء المجلس بس يقدروا يعملوا تصويت';
  end if;
  if char_length(v_question) < 3 or char_length(v_question) > 300 then
    raise exception 'اكتب سؤال التصويت (من 3 لـ 300 حرف)';
  end if;

  select array_agg(o order by n) into v_options
    from (select btrim(x) as o, n from unnest(coalesce(p_options, '{}')) with ordinality as t(x, n)) s
   where o <> '';
  if coalesce(array_length(v_options, 1), 0) < 2 or array_length(v_options, 1) > 6 then
    raise exception 'التصويت محتاج من 2 لـ 6 اختيارات';
  end if;
  if (select count(distinct lower(o)) from unnest(v_options) o) <> array_length(v_options, 1) then
    raise exception 'فيه اختيارين متكررين';
  end if;
  if exists (select 1 from unnest(v_options) o where char_length(o) > 100) then
    raise exception 'الاختيار الواحد ميزيدش عن 100 حرف';
  end if;
  if p_ends_at is null or p_ends_at < now() + interval '1 hour' then
    raise exception 'التصويت لازم يفضل مفتوح ساعة على الأقل';
  end if;
  if p_ends_at > now() + interval '30 days' then
    raise exception 'مدة التصويت متزيدش عن 30 يوم';
  end if;
  if (select count(*) from public.union_polls
       where building_id = v_building_id and closed_at is null and ends_at > now()) >= 10 then
    raise exception 'فيه 10 تصويتات مفتوحة بالفعل — اقفل واحد الأول';
  end if;

  insert into public.union_polls (building_id, created_by, question, options, ends_at)
  values (v_building_id, auth.uid(), v_question, v_options, p_ends_at)
  returning id into v_id;

  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, '🗳️ تصويت جديد في العمارة',
         v_question || ' — صوّت باسم شقتك قبل ما التصويت يقفل.',
         '/#/polls'
    from public.union_members m
   where m.building_id = v_building_id and m.status = 'verified' and m.user_id <> auth.uid();

  return v_id;
end;
$$;

create or replace function public.cast_poll_vote(p_poll_id uuid, p_option integer) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_poll public.union_polls;
  v_unit_id uuid;
  v_rows int;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into v_poll from public.union_polls where id = p_poll_id;
  if not found then
    raise exception 'التصويت مش موجود';
  end if;
  if not exists (select 1 from public.union_members m
                  where m.building_id = v_poll.building_id and m.user_id = auth.uid() and m.status = 'verified') then
    raise exception 'التصويت لسكان العمارة الموثّقين بس';
  end if;
  if v_poll.closed_at is not null or now() >= v_poll.ends_at then
    raise exception 'التصويت ده خلص';
  end if;
  select m.unit_id into v_unit_id from public.union_members m
   where m.building_id = v_poll.building_id and m.user_id = auth.uid() and m.status = 'verified';
  if v_unit_id is null then
    raise exception 'حسابك مش مربوط بشقة في العمارة';
  end if;
  if p_option is null or p_option < 0 or p_option >= array_length(v_poll.options, 1) then
    raise exception 'اختيار غير صحيح';
  end if;

  insert into public.union_poll_votes (poll_id, unit_id, voter_id, option_index)
  values (p_poll_id, v_unit_id, auth.uid(), p_option)
  on conflict (poll_id, unit_id) do nothing;
  get diagnostics v_rows = row_count;
  if v_rows = 0 then
    raise exception 'شقتكم صوّتت بالفعل في التصويت ده';
  end if;
end;
$$;

-- The board ends a poll early.
create or replace function public.close_building_poll(p_poll_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_poll public.union_polls;
begin
  select * into v_poll from public.union_polls where id = p_poll_id for update;
  if not found then
    raise exception 'التصويت مش موجود';
  end if;
  if public._board_building_for(v_poll.building_id) is null then
    raise exception 'قفل التصويت لرئيس الاتحاد وأعضاء المجلس بس';
  end if;
  if v_poll.closed_at is not null or now() >= v_poll.ends_at then
    raise exception 'التصويت ده مقفول بالفعل';
  end if;
  update public.union_polls set closed_at = now() where id = p_poll_id;
end;
$$;

-- Polls of a building with their results, as the caller may see them.
-- total_units = apartments with at least one verified member right now.
create or replace function public.list_building_polls(p_building_id uuid)
returns table (
  id uuid, question text, options text[], ends_at timestamptz, closed_at timestamptz,
  created_at timestamptz, created_by_name text, is_open boolean, counts integer[],
  units_voted integer, total_units integer, my_unit_choice integer, voted_by_me boolean
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_unit_id uuid;
  v_total int;
begin
  if not public.is_verified_member_of(p_building_id) then
    return;
  end if;
  select m.unit_id into v_unit_id from public.union_members m
   where m.building_id = p_building_id and m.user_id = auth.uid() and m.status = 'verified';
  select count(distinct m.unit_id) into v_total from public.union_members m
   where m.building_id = p_building_id and m.status = 'verified' and m.unit_id is not null;

  return query
    select p.id, p.question, p.options, p.ends_at, p.closed_at, p.created_at,
           public.member_display_name(p.building_id, p.created_by),
           (p.closed_at is null and now() < p.ends_at),
           array(select count(v.unit_id)::int
                   from generate_series(0, array_length(p.options, 1) - 1) as g(i)
                   left join public.union_poll_votes v on v.poll_id = p.id and v.option_index = g.i
                  group by g.i order by g.i),
           (select count(*)::int from public.union_poll_votes v where v.poll_id = p.id),
           greatest(v_total, (select count(*)::int from public.union_poll_votes v where v.poll_id = p.id)),
           (select v.option_index::int from public.union_poll_votes v where v.poll_id = p.id and v.unit_id = v_unit_id),
           exists (select 1 from public.union_poll_votes v where v.poll_id = p.id and v.voter_id = auth.uid())
      from public.union_polls p
     where p.building_id = p_building_id
     order by (p.closed_at is null and now() < p.ends_at) desc, p.created_at desc
     limit 50;
end;
$$;

revoke execute on function public.create_building_poll(text, text[], timestamptz, uuid) from public, anon;
grant execute on function public.create_building_poll(text, text[], timestamptz, uuid) to authenticated;
revoke execute on function public.cast_poll_vote(uuid, integer) from public, anon;
grant execute on function public.cast_poll_vote(uuid, integer) to authenticated;
revoke execute on function public.close_building_poll(uuid) from public, anon;
grant execute on function public.close_building_poll(uuid) to authenticated;
revoke execute on function public.list_building_polls(uuid) from public, anon;
grant execute on function public.list_building_polls(uuid) to authenticated;
