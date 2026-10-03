-- =====================================================================
-- Migration 0051 — nobody becomes union president on their own.
--
-- Before: whoever registered a building became its president (or board
-- member) instantly, with full powers. Now a president is made in one of
-- two ways only:
--   1. The platform admin (super_admin) approves a president request.
--      Registering a building files that request; the founder is a
--      verified owner of their unit meanwhile, with no board powers.
--   2. The owners elect one. While a building has no approved president,
--      any verified primary owner may open a presidential election and,
--      once voting closes, close it; the winner becomes president at once
--      (finalize_election already promotes the winner).
-- Join requests of a building without a board can be reviewed by the
-- platform admin. Existing self-appointed presidents/board members are
-- demoted to owners with a pending request, so the admin reviews them.
-- =====================================================================

create table if not exists public.president_requests (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected', 'superseded')),
  created_at timestamptz not null default now(),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz
);
create unique index if not exists president_requests_one_pending
  on public.president_requests (building_id, user_id) where status = 'pending';

alter table public.president_requests enable row level security;
revoke all on public.president_requests from anon, authenticated;
grant select on public.president_requests to authenticated;
create policy "president_requests: own or admin" on public.president_requests
  for select to authenticated using (user_id = auth.uid() or public.is_super_admin());

-- Does the building have an approved president or board?
create or replace function public._building_has_board(p_building_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (select 1 from public.union_members
                  where building_id = p_building_id and status = 'verified' and role in ('president', 'board_member'));
$$;

-- ---------------------------------------------------------------------
-- 1. Founding a building: owner + pending president request
-- ---------------------------------------------------------------------
create or replace function public.found_building(
  p_name text,
  p_district text,
  p_city text,
  p_governorate text,
  p_unit_number text,
  p_floor_label text,
  p_google_place_id text default null,
  p_lat numeric default null,
  p_lng numeric default null,
  p_as_president boolean default true,
  p_existing_building_id uuid default null
) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_unit_id uuid;
  v_code text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  if p_existing_building_id is not null then
    v_building_id := p_existing_building_id;
  elsif p_google_place_id is not null then
    select id into v_building_id from public.buildings where google_place_id = p_google_place_id;
  end if;

  if v_building_id is not null then
    if not exists (select 1 from public.buildings where id = v_building_id) then
      raise exception 'العمارة المحددة غير موجودة';
    end if;

    select id into v_unit_id from public.units
      where building_id = v_building_id and unit_number = p_unit_number;
    if v_unit_id is null then
      insert into public.units (building_id, unit_number, floor_label)
      values (v_building_id, p_unit_number, p_floor_label)
      returning id into v_unit_id;
    end if;

    -- No unit_residents row here: residency is granted only when the
    -- president/board (or the platform admin) approves the request.
    insert into public.union_members (building_id, user_id, unit_id, role, status, requested_residency)
    values (v_building_id, auth.uid(), v_unit_id, 'resident', 'pending', 'owner')
    on conflict (building_id, user_id) do nothing;

    return 'PENDING_EXISTING';
  end if;

  insert into public.buildings (name, district, city, governorate, total_units, registered_units, is_officially_registered, google_place_id, lat, lng)
  values (p_name, p_district, p_city, p_governorate, 1, 1, false, p_google_place_id, p_lat, p_lng)
  returning id into v_building_id;

  insert into public.units (building_id, unit_number, floor_label)
  values (v_building_id, p_unit_number, p_floor_label)
  returning id into v_unit_id;

  insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
  values (v_unit_id, auth.uid(), 'owner', true);

  -- The founder is an owner, not president: the presidency is requested.
  insert into public.union_members (building_id, user_id, unit_id, role, status, verified_by, verified_at)
  values (v_building_id, auth.uid(), v_unit_id, 'resident', 'verified', auth.uid(), now());

  -- "اطلب رئاسة الاتحاد" files a request; otherwise the owners elect one.
  if p_as_president then
    insert into public.president_requests (building_id, user_id) values (v_building_id, auth.uid());
    insert into public.notifications (user_id, title, body)
    select p.id, '🏢 طلب رئاسة اتحاد جديد', 'طلب رئاسة لعمارة «' || p_name || '» محتاج مراجعتك.'
      from public.profiles p where p.role = 'super_admin';
  end if;

  v_code := 'BLD-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));

  insert into public.union_invite_codes (building_id, code, issued_by, max_uses, used_count)
  values (v_building_id, v_code, auth.uid(), 9999, 0);

  return v_code;
end;
$$;

-- ---------------------------------------------------------------------
-- 2. Platform admin reviews president requests
-- ---------------------------------------------------------------------
create or replace function public.admin_list_president_requests() returns table (
  id uuid, building_id uuid, building_name text, district text, city text,
  user_id uuid, full_name text, phone text, created_at timestamptz, members int
)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  return query
    select r.id, b.id, b.name, b.district, b.city, p.id, p.full_name, p.phone, r.created_at,
           (select count(*)::int from public.union_members m where m.building_id = b.id and m.status = 'verified')
      from public.president_requests r
      join public.buildings b on b.id = r.building_id
      join public.profiles p on p.id = r.user_id
     where r.status = 'pending'
     order by r.created_at;
end;
$$;

create or replace function public.review_president_request(p_request_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  r public.president_requests;
  v_name text;
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  select * into r from public.president_requests where id = p_request_id for update;
  if not found or r.status <> 'pending' then
    raise exception 'الطلب ده مش موجود أو اتراجع قبل كده';
  end if;
  if p_approve then
    if exists (select 1 from public.union_members where building_id = r.building_id and status = 'verified' and role = 'president') then
      raise exception 'العمارة دي ليها رئيس بالفعل';
    end if;
    if not exists (select 1 from public.union_members where building_id = r.building_id and user_id = r.user_id and status = 'verified') then
      raise exception 'صاحب الطلب مش عضو موثّق في العمارة';
    end if;
    update public.union_members set role = 'president'
     where building_id = r.building_id and user_id = r.user_id;
  end if;
  update public.president_requests
     set status = case when p_approve then 'approved' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
   where id = p_request_id;
  -- Other pending requests for the same building are settled too.
  if p_approve then
    update public.president_requests set status = 'superseded', reviewed_by = auth.uid(), reviewed_at = now()
     where building_id = r.building_id and status = 'pending';
  end if;

  select name into v_name from public.buildings where id = r.building_id;
  insert into public.notifications (user_id, title, body)
  values (r.user_id,
    case when p_approve then 'تمت الموافقة على رئاستك للاتحاد 🎉' else 'تم رفض طلب رئاسة الاتحاد' end,
    case when p_approve then 'بقيت رئيس اتحاد «' || v_name || '» وتقدر تدير العمارة دلوقتي.'
         else 'تقدر تطلب من ملاك «' || v_name || '» يعملوا انتخابات للرئاسة من التطبيق.' end);
end;
$$;

-- ---------------------------------------------------------------------
-- 3. Join requests: the board — or the platform admin
-- ---------------------------------------------------------------------
create or replace function public.review_union_member(
  p_member_id uuid,
  p_approve boolean
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member record;
  v_residency residency_type;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_member from public.union_members where id = p_member_id for update;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;

  if not public.is_super_admin() and not exists (
    select 1 from public.union_members m
    where m.building_id = v_member.building_id
      and m.user_id = auth.uid()
      and m.status = 'verified'
      and m.role in ('president', 'board_member')
  ) then
    raise exception 'غير مصرح لك بمراجعة طلبات الانضمام لهذه العمارة';
  end if;

  if v_member.status <> 'pending' then
    raise exception 'تمت مراجعة هذا الطلب بالفعل';
  end if;

  update public.union_members
  set status = case when p_approve then 'verified'::union_member_status else 'rejected'::union_member_status end,
      verified_by = auth.uid(),
      verified_at = now()
  where id = p_member_id;

  if p_approve and v_member.unit_id is not null then
    v_residency := coalesce(v_member.requested_residency, 'owner');
    insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
    values (
      v_member.unit_id, v_member.user_id, v_residency,
      v_residency = 'owner' and not exists (
        select 1 from public.unit_residents ur
        where ur.unit_id = v_member.unit_id and ur.residency_type = 'owner' and ur.is_primary
      )
    )
    on conflict (unit_id, user_id) do nothing;
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_member.user_id,
    case when p_approve then 'تم قبول طلب انضمامك' else 'تم رفض طلب انضمامك' end,
    case when p_approve then 'تهانينا! تمت الموافقة على طلب انضمامك لاتحاد الملاك.'
         else 'للأسف تم رفض طلب انضمامك لاتحاد الملاك، تواصل مع رئيس الاتحاد لمزيد من التفاصيل.' end
  );
end;
$$;

-- Pending join requests of buildings that have no board yet (admin queue).
create or replace function public.admin_list_boardless_join_requests() returns table (
  member_id uuid, building_name text, full_name text, phone text, unit_number text, requested_residency text, created_at timestamptz
)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  return query
    select m.id, b.name, p.full_name, p.phone, u.unit_number, m.requested_residency::text, m.created_at
      from public.union_members m
      join public.buildings b on b.id = m.building_id
      join public.profiles p on p.id = m.user_id
      left join public.units u on u.id = m.unit_id
     where m.status = 'pending' and not public._building_has_board(m.building_id)
     order by m.created_at;
end;
$$;

-- ---------------------------------------------------------------------
-- 4. Owners elect a president when the building has no board
-- ---------------------------------------------------------------------
create or replace function public.create_election(
  p_title text,
  p_closes_at timestamptz,
  p_legal_quorum_pct numeric default 50.00,
  p_building_id uuid default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_ids uuid[];
  v_eligible int;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_closes_at is null or p_closes_at < now() + interval '23 hours' then
    raise exception 'مدة التصويت يجب ألا تقل عن يوم واحد';
  end if;
  if p_closes_at > now() + interval '60 days' then
    raise exception 'مدة التصويت يجب ألا تزيد عن 60 يوماً';
  end if;

  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null then
    -- No board role: a verified primary owner may call a presidential
    -- election in their building while it has no approved board.
    select array_agg(m.building_id) into v_ids
      from public.union_members m
     where m.user_id = auth.uid() and m.status = 'verified'
       and public.is_election_voter(m.building_id, auth.uid())
       and not public._building_has_board(m.building_id)
       and (p_building_id is null or m.building_id = p_building_id);
    if v_ids is null then
      raise exception 'غير مصرح لك بإنشاء انتخابات لهذه العمارة';
    end if;
    if array_length(v_ids, 1) > 1 then
      raise exception 'إنت مالك في أكتر من عمارة — حدّد العمارة الأول';
    end if;
    v_building_id := v_ids[1];
  end if;

  if exists (select 1 from public.union_elections where building_id = v_building_id and not is_finalized) then
    raise exception 'توجد انتخابات مفتوحة بالفعل لهذه العمارة';
  end if;

  select count(*) into v_eligible
  from public.union_members m
  join public.unit_residents ur
    on ur.user_id = m.user_id and ur.unit_id = m.unit_id
   and ur.residency_type = 'owner' and ur.is_primary
  where m.building_id = v_building_id and m.status = 'verified';

  insert into public.union_elections (building_id, title, legal_quorum_pct, eligible_voters, closes_at)
  values (v_building_id, p_title, 50.00, v_eligible, p_closes_at)
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function public.finalize_election(p_election_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_eligible int;
  v_total_votes int;
  v_top_votes int;
  v_top_count int;
  v_winner_user_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id for update;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized then
    raise exception 'تم إغلاق هذه الانتخابات بالفعل';
  end if;

  -- The board closes elections; in a building without a board any
  -- eligible owner can (it still cannot close before the deadline unless
  -- everyone has voted).
  if not exists (
    select 1 from public.union_members m
    where m.building_id = v_election.building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
  ) and not (
    not public._building_has_board(v_election.building_id)
    and public.is_election_voter(v_election.building_id, auth.uid())
  ) then
    raise exception 'غير مصرح لك بإغلاق هذه الانتخابات';
  end if;

  v_eligible := v_election.eligible_voters;

  select count(*) into v_total_votes
  from public.union_votes v
  where v.election_id = p_election_id
    and v.candidate_id is not null
    and public.is_election_voter(v_election.building_id, v.voter_id);

  if now() < v_election.closes_at and v_total_votes < v_eligible then
    raise exception 'لا يمكن إغلاق الانتخابات قبل موعد انتهاء التصويت';
  end if;

  update public.union_elections set
    is_finalized = true,
    result_pct = case when v_eligible > 0 then round(v_total_votes::numeric / v_eligible * 100, 2) else 0 end
  where id = p_election_id;

  if v_eligible = 0 or (v_total_votes::numeric / v_eligible * 100) < 50 then
    return;
  end if;

  with tally as (
    select v.candidate_id, count(*) as votes
    from public.union_votes v
    where v.election_id = p_election_id
      and v.candidate_id is not null
      and public.is_election_voter(v_election.building_id, v.voter_id)
    group by v.candidate_id
  )
  select max(votes), count(*) filter (where votes = (select max(votes) from tally))
    into v_top_votes, v_top_count
  from tally;

  if coalesce(v_top_votes, 0) = 0 or v_top_count <> 1 then
    return;
  end if;

  select c.user_id into v_winner_user_id
  from public.union_candidates c
  where c.election_id = p_election_id
    and c.id = (
      select v.candidate_id
      from public.union_votes v
      where v.election_id = p_election_id
        and v.candidate_id is not null
        and public.is_election_voter(v_election.building_id, v.voter_id)
      group by v.candidate_id
      order by count(*) desc
      limit 1
    );

  if v_winner_user_id is null then
    return;
  end if;

  update public.union_members set role = 'board_member'
    where building_id = v_election.building_id and role = 'president' and user_id <> v_winner_user_id;

  update public.union_members set role = 'president'
    where building_id = v_election.building_id and user_id = v_winner_user_id;

  -- The owners decided: pending admin requests for this building are moot.
  update public.president_requests set status = 'superseded', reviewed_at = now()
   where building_id = v_election.building_id and status = 'pending';
end;
$$;

-- ---------------------------------------------------------------------
-- 5. Existing self-appointed presidents / board members go to review
-- ---------------------------------------------------------------------
insert into public.president_requests (building_id, user_id)
select m.building_id, m.user_id
  from public.union_members m
 where m.role in ('president', 'board_member') and m.status = 'verified' and m.verified_by = m.user_id
on conflict do nothing;

update public.union_members set role = 'resident'
 where role in ('president', 'board_member') and status = 'verified' and verified_by = user_id;

revoke execute on function public._building_has_board(uuid) from public, anon, authenticated;
revoke execute on function public.admin_list_president_requests() from public, anon;
revoke execute on function public.review_president_request(uuid, boolean) from public, anon;
revoke execute on function public.admin_list_boardless_join_requests() from public, anon;
grant execute on function public.admin_list_president_requests() to authenticated;
grant execute on function public.review_president_request(uuid, boolean) to authenticated;
grant execute on function public.admin_list_boardless_join_requests() to authenticated;
revoke execute on function public.found_building(text, text, text, text, text, text, text, numeric, numeric, boolean, uuid) from public, anon;
grant execute on function public.found_building(text, text, text, text, text, text, text, numeric, numeric, boolean, uuid) to authenticated;
revoke execute on function public.review_union_member(uuid, boolean) from public, anon;
grant execute on function public.review_union_member(uuid, boolean) to authenticated;
revoke execute on function public.create_election(text, timestamptz, numeric, uuid) from public, anon;
grant execute on function public.create_election(text, timestamptz, numeric, uuid) to authenticated;
revoke execute on function public.finalize_election(uuid) from public, anon;
grant execute on function public.finalize_election(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 6. Admin: find an address to assign (sell) a premium single-word name
-- ---------------------------------------------------------------------
-- By the owner's mobile number, the address code or its current name.
create or replace function public.admin_find_e_addresses(p_query text) returns table (
  id uuid, code text, handle text, label text, city text, owner_name text, owner_phone text
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_q text := trim(coalesce(p_query, ''));
  v_digits text := regexp_replace(v_q, '[^0-9]', '', 'g');
  v_code text := upper(regexp_replace(v_q, '[^A-Za-z0-9]', '', 'g'));
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  if v_digits ~ '^201[0125][0-9]{8}$' then
    v_digits := substr(v_digits, 2);
  end if;
  if v_code like 'MG%' and length(v_code) = 10 then
    v_code := substr(v_code, 3);
  end if;
  return query
    select a.id, a.code, a.handle, a.label, a.city, p.full_name, p.phone
      from public.e_addresses a join public.profiles p on p.id = a.owner_id
     where (v_digits ~ '^01[0125][0-9]{8}$' and p.phone = v_digits)
        or a.code = v_code
        or a.handle = lower(v_q)
     order by a.created_at
     limit 20;
end;
$$;

revoke execute on function public.admin_find_e_addresses(text) from public, anon;
grant execute on function public.admin_find_e_addresses(text) to authenticated;
