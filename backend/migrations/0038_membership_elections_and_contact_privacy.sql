-- =====================================================================
-- Migration 0038 — close the building-takeover chain, harden elections,
-- announcements, visitor passes and SOS, and stop leaking phone numbers.
--
-- Before this:
--   * found_building(p_existing_building_id) and join_building_with_code
--     inserted unit_residents(owner, is_primary = true) immediately, on a
--     still-PENDING request. Anyone could become "primary owner" of a
--     neighbour's flat, then mint verified tenant accounts with
--     invite_tenant_for_unit (no president review), issue visitor passes,
--     and fire SOS alerts — those two policies only checked that a
--     membership row existed, not that it was verified.
--   * Elections: the creator chose the quorum (could be 0), finalize
--     ignored closes_at, a 0-vote/tied candidate could "win", and every
--     verified account (including owner-minted tenants) voted.
--   * Any signed-in user could insert an 'official', pinned post into any
--     building.
--   * Visitor passes: the issuer could flip a used pass back to active
--     and extend valid_until indefinitely; the client picked qr_code.
--   * profiles.phone was readable by every building co-member and in
--     every embed, whatever the user or listing said.
--
-- Decisions (confirmed with the project owner):
--   * Only a unit's verified primary owner votes — one vote per unit.
--   * Fixed 50% quorum, not chosen by whoever creates the election.
--
-- Run after 0037, in order, in the Supabase SQL editor. Deploy the
-- matching app build (contact phones via get_contact_phones, explicit
-- profile columns) AFTER this has run.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Residency is granted on approval, never on request
-- ---------------------------------------------------------------------

-- What the applicant asked to be (owner/tenant), kept on the pending
-- request until the president/board approves it.
alter table public.union_members add column if not exists requested_residency residency_type;

update public.union_members m
set requested_residency = ur.residency_type
from public.unit_residents ur
where m.requested_residency is null
  and m.status = 'pending'
  and ur.user_id = m.user_id
  and ur.unit_id = m.unit_id;

-- Remove residency rows that were created for requests that were never
-- approved (pending or rejected). Kept in a backup table first so any
-- row can be restored by hand. Pending applicants get their row back
-- automatically when approved (see review_union_member below).
create table if not exists public.unit_residents_removed_0038 as
  select ur.*, now() as removed_at from public.unit_residents ur where false;
revoke all on public.unit_residents_removed_0038 from anon, authenticated;

insert into public.unit_residents_removed_0038
select ur.*, now()
from public.unit_residents ur
where not exists (
  select 1 from public.union_members m
  where m.user_id = ur.user_id and m.unit_id = ur.unit_id and m.status = 'verified'
);

delete from public.unit_residents ur
where not exists (
  select 1 from public.union_members m
  where m.user_id = ur.user_id and m.unit_id = ur.unit_id and m.status = 'verified'
);

-- One primary owner per unit. Where several exist, keep the earliest
-- (the original owner) and demote the rest to co-owners.
update public.unit_residents
set is_primary = false
where id in (
  select id from (
    select id, row_number() over (partition by unit_id order by created_at, id) as rn
    from public.unit_residents
    where residency_type = 'owner' and is_primary
  ) ranked
  where rn > 1
);

create unique index if not exists unit_residents_one_primary_owner
  on public.unit_residents (unit_id)
  where residency_type = 'owner' and is_primary;

-- Primary owner = owner row AND a verified membership on that unit.
create or replace function public.is_primary_owner_of(p_unit_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1
    from public.unit_residents ur
    join public.union_members m
      on m.user_id = ur.user_id and m.unit_id = ur.unit_id and m.status = 'verified'
    where ur.unit_id = p_unit_id and ur.user_id = auth.uid()
      and ur.residency_type = 'owner' and ur.is_primary
  );
$$;

-- found_building: joining an existing building only files a pending
-- request; the new-building path is unchanged.
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
    -- president/board approves the request (review_union_member).
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

  insert into public.union_members (building_id, user_id, unit_id, role, status, verified_by, verified_at)
  values (
    v_building_id, auth.uid(), v_unit_id,
    (case when p_as_president then 'president' else 'board_member' end)::union_role,
    'verified', auth.uid(), now()
  );

  v_code := 'BLD-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));

  insert into public.union_invite_codes (building_id, code, issued_by, max_uses, used_count)
  values (v_building_id, v_code, auth.uid(), 9999, 0);

  return v_code;
end;
$$;

create or replace function public.join_building_with_code(
  p_code text,
  p_unit_number text,
  p_floor_label text,
  p_residency_type text
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_invite record;
  v_unit_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_residency_type not in ('owner', 'tenant') then
    raise exception 'نوع السكن غير صحيح';
  end if;

  select * into v_invite from public.union_invite_codes where code = p_code for update;
  if not found then
    raise exception 'كود الدعوة غير صحيح';
  end if;
  if v_invite.used_count >= v_invite.max_uses then
    raise exception 'تم استخدام كود الدعوة بالكامل';
  end if;
  if v_invite.expires_at is not null and v_invite.expires_at < now() then
    raise exception 'انتهت صلاحية كود الدعوة';
  end if;

  select id into v_unit_id from public.units
    where building_id = v_invite.building_id and unit_number = p_unit_number;
  if v_unit_id is null then
    insert into public.units (building_id, unit_number, floor_label)
    values (v_invite.building_id, p_unit_number, p_floor_label)
    returning id into v_unit_id;
  end if;

  insert into public.union_members (building_id, user_id, unit_id, role, status, invite_code_id, requested_residency)
  values (v_invite.building_id, auth.uid(), v_unit_id, 'resident', 'pending', v_invite.id, p_residency_type::residency_type)
  on conflict (building_id, user_id) do nothing;

  update public.union_invite_codes set used_count = used_count + 1 where id = v_invite.id;
end;
$$;

-- review_union_member: only pending requests (a board member could
-- previously "reject" the president or any verified neighbour), and
-- approval is what grants residency. A second owner of a unit that
-- already has a primary owner becomes a co-owner, not primary.
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

  if not exists (
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


-- ---------------------------------------------------------------------
-- 2. Tenant invites: verified owner only, expiring, capped per unit
-- ---------------------------------------------------------------------

create or replace function public.invite_tenant_for_unit(p_unit_id uuid) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  if not public.is_primary_owner_of(p_unit_id) then
    raise exception 'غير مصرح لك بدعوة مستأجر لهذه الوحدة';
  end if;

  if (select count(*) from public.unit_residents where unit_id = p_unit_id and residency_type = 'tenant') >= 5 then
    raise exception 'وصلت للحد الأقصى لعدد المستأجرين في هذه الوحدة (5)';
  end if;

  v_code := 'TEN-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));

  insert into public.tenant_invite_codes (unit_id, code, issued_by, expires_at)
  values (p_unit_id, v_code, auth.uid(), now() + interval '7 days');

  return v_code;
end;
$$;

create or replace function public.join_as_tenant_with_code(p_code text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_invite record;
  v_building_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_invite from public.tenant_invite_codes where code = p_code for update;
  if not found then
    raise exception 'كود الدعوة غير صحيح';
  end if;
  if v_invite.used_count >= v_invite.max_uses then
    raise exception 'تم استخدام كود الدعوة بالكامل';
  end if;
  if v_invite.expires_at is not null and v_invite.expires_at < now() then
    raise exception 'انتهت صلاحية كود الدعوة';
  end if;

  select building_id into v_building_id from public.units where id = v_invite.unit_id;

  -- The code only counts if whoever issued it is STILL the unit's
  -- verified primary owner.
  if not exists (
    select 1
    from public.unit_residents ur
    join public.union_members m
      on m.user_id = ur.user_id and m.unit_id = ur.unit_id and m.status = 'verified'
    where ur.unit_id = v_invite.unit_id and ur.user_id = v_invite.issued_by
      and ur.residency_type = 'owner' and ur.is_primary
  ) then
    raise exception 'كود الدعوة لم يعد صالحاً';
  end if;

  if v_invite.issued_by = auth.uid() then
    raise exception 'أنت بالفعل مالك هذه الوحدة';
  end if;

  if (select count(*) from public.unit_residents where unit_id = v_invite.unit_id and residency_type = 'tenant') >= 5 then
    raise exception 'وصلت هذه الوحدة للحد الأقصى لعدد المستأجرين';
  end if;

  -- Never downgrade an existing owner row to tenant.
  if exists (
    select 1 from public.unit_residents
    where unit_id = v_invite.unit_id and user_id = auth.uid() and residency_type = 'owner'
  ) then
    raise exception 'أنت مسجل بالفعل كمالك في هذه الوحدة';
  end if;

  insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
  values (v_invite.unit_id, auth.uid(), 'tenant', false)
  on conflict (unit_id, user_id) do nothing;

  insert into public.union_members (building_id, user_id, unit_id, role, status, verified_by, verified_at, requested_residency)
  values (v_building_id, auth.uid(), v_invite.unit_id, 'resident', 'verified', v_invite.issued_by, now(), 'tenant')
  on conflict (building_id, user_id) do update
    set status = 'verified', unit_id = v_invite.unit_id, verified_by = v_invite.issued_by,
        verified_at = now(), requested_residency = 'tenant'
    -- never touch an existing president/board membership
    where union_members.role = 'resident';

  update public.tenant_invite_codes set used_count = used_count + 1 where id = v_invite.id;
end;
$$;


-- ---------------------------------------------------------------------
-- 3. Verified membership required for SOS, visitor passes and dues
-- ---------------------------------------------------------------------

drop policy if exists "sos_alerts: member triggers for own unit" on public.sos_alerts;
create policy "sos_alerts: member triggers for own unit" on public.sos_alerts
  for insert with check (
    auth.uid() = triggered_by
    and exists (
      select 1 from public.union_members m
      where m.user_id = auth.uid() and m.unit_id = sos_alerts.unit_id and m.status = 'verified'
    )
  );

drop policy if exists "visitor_passes: member issues for own unit" on public.visitor_passes;
create policy "visitor_passes: member issues for own unit" on public.visitor_passes
  for insert with check (
    auth.uid() = issued_by
    and exists (
      select 1 from public.union_members m
      where m.user_id = auth.uid() and m.unit_id = visitor_passes.unit_id and m.status = 'verified'
    )
  );

drop policy if exists "union_dues: unit resident views own" on public.union_dues;
create policy "union_dues: unit resident views own" on public.union_dues
  for select using (
    exists (
      select 1 from public.union_members m
      where m.unit_id = union_dues.unit_id and m.user_id = auth.uid() and m.status = 'verified'
    )
  );

-- Visitor passes: the server picks the code and caps validity; after
-- issuing, the only change a resident can make is active -> revoked.
create or replace function public.guard_visitor_pass_write() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user not in ('authenticated', 'anon') then
    return new;
  end if;

  if tg_op = 'INSERT' then
    new.qr_code := 'PASS-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 10));
    new.status := 'active';
    new.valid_from := now();
    if new.valid_until is null or new.valid_until <= now() then
      raise exception 'مدة التصريح غير صحيحة';
    end if;
    new.valid_until := least(new.valid_until, now() + interval '48 hours');
    return new;
  end if;

  if old.status = 'active' and new.status = 'revoked'
     and new.id = old.id and new.unit_id = old.unit_id and new.issued_by = old.issued_by
     and new.visitor_name = old.visitor_name and new.pass_type = old.pass_type
     and new.qr_code = old.qr_code and new.valid_from = old.valid_from
     and new.valid_until = old.valid_until and new.created_at = old.created_at then
    return new;
  end if;

  raise exception 'يمكن فقط إلغاء التصريح الفعّال' using errcode = '42501';
end;
$$;

drop trigger if exists guard_visitor_pass_write on public.visitor_passes;
create trigger guard_visitor_pass_write
  before insert or update on public.visitor_passes
  for each row execute function public.guard_visitor_pass_write();

-- SOS: the triggerer may only cancel their own alert, nothing else.
create or replace function public.guard_sos_alert_update() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if old.status <> 'active'
       or new.status <> 'false_alarm'
       or new.unit_id is distinct from old.unit_id
       or new.triggered_by is distinct from old.triggered_by
       or new.type is distinct from old.type
       or new.responded_by is distinct from old.responded_by
       or new.resolved_at is distinct from old.resolved_at
       or new.created_at is distinct from old.created_at then
      raise exception 'يمكن فقط إلغاء الاستغاثة' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_sos_alert_update on public.sos_alerts;
create trigger guard_sos_alert_update
  before update on public.sos_alerts
  for each row execute function public.guard_sos_alert_update();


-- ---------------------------------------------------------------------
-- 4. Announcements: verified members post; official/pinned is board-only
-- ---------------------------------------------------------------------

drop policy if exists "posts: author writes own" on public.posts;
create policy "posts: author writes own" on public.posts
  for insert with check (
    auth.uid() = author_id
    and public.is_verified_member_of(building_id)
    and (
      (type <> 'official' and not is_pinned)
      or exists (
        select 1 from public.union_members m
        where m.building_id = posts.building_id and m.user_id = auth.uid()
          and m.status = 'verified' and m.role in ('president', 'board_member')
      )
    )
  );


-- ---------------------------------------------------------------------
-- 5. Elections: owners only, one vote per unit, fixed 50% quorum
-- ---------------------------------------------------------------------

-- Eligible voter = verified member who is their unit's primary owner.
-- Since a unit has at most one primary owner and a user one membership
-- per building, this is exactly one vote per unit.
create or replace function public.is_election_voter(p_building_id uuid, p_user_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1
    from public.union_members m
    join public.unit_residents ur
      on ur.user_id = m.user_id and ur.unit_id = m.unit_id
     and ur.residency_type = 'owner' and ur.is_primary
    where m.building_id = p_building_id and m.user_id = p_user_id and m.status = 'verified'
  );
$$;

revoke execute on function public.is_election_voter(uuid, uuid) from public, anon;
grant execute on function public.is_election_voter(uuid, uuid) to authenticated;

-- Already-open elections switch to the fixed quorum and the owner-only
-- eligible count.
update public.union_elections e
set legal_quorum_pct = 50.00,
    eligible_voters = (
      select count(*) from public.union_members m
      join public.unit_residents ur
        on ur.user_id = m.user_id and ur.unit_id = m.unit_id
       and ur.residency_type = 'owner' and ur.is_primary
      where m.building_id = e.building_id and m.status = 'verified'
    )
where not e.is_finalized;

alter table public.union_elections alter column legal_quorum_pct set default 50.00;

-- p_legal_quorum_pct is kept only so older app builds keep working; it
-- is ignored.
create or replace function public.create_election(
  p_title text,
  p_closes_at timestamptz,
  p_legal_quorum_pct numeric default 50.00
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
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

  select building_id into v_building_id from public.union_members
    where user_id = auth.uid() and status = 'verified' and role in ('president', 'board_member')
    order by created_at
    limit 1;
  if v_building_id is null then
    raise exception 'غير مصرح لك بإنشاء انتخابات لهذه العمارة';
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

-- Candidates must be owners (any owner of a unit, with verified membership).
create or replace function public.nominate_self(p_election_id uuid, p_pledge text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized or v_election.closes_at < now() then
    raise exception 'انتهت فترة الترشح لهذه الانتخابات';
  end if;
  if not exists (
    select 1
    from public.union_members m
    join public.unit_residents ur
      on ur.user_id = m.user_id and ur.unit_id = m.unit_id and ur.residency_type = 'owner'
    where m.building_id = v_election.building_id and m.user_id = auth.uid() and m.status = 'verified'
  ) then
    raise exception 'الترشح متاح لملاك الوحدات فقط';
  end if;

  insert into public.union_candidates (election_id, user_id, pledge)
  values (p_election_id, auth.uid(), p_pledge)
  on conflict (election_id, user_id) do update set pledge = excluded.pledge
  returning id into v_id;

  return v_id;
end;
$$;

create or replace function public.cast_election_vote(p_election_id uuid, p_candidate_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_previous_candidate_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id for update;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized or v_election.closes_at < now() then
    raise exception 'انتهت فترة التصويت لهذه الانتخابات';
  end if;
  if not public.is_election_voter(v_election.building_id, auth.uid()) then
    raise exception 'التصويت متاح للمالك الأساسي لكل وحدة فقط (صوت واحد لكل شقة)';
  end if;
  if not exists (select 1 from public.union_candidates c where c.id = p_candidate_id and c.election_id = p_election_id) then
    raise exception 'المرشح غير موجود في هذه الانتخابات';
  end if;

  select candidate_id into v_previous_candidate_id from public.union_votes
    where election_id = p_election_id and voter_id = auth.uid();

  if v_previous_candidate_id is not null and v_previous_candidate_id = p_candidate_id then
    return;
  end if;

  insert into public.union_votes (election_id, candidate_id, voter_id)
  values (p_election_id, p_candidate_id, auth.uid())
  on conflict (election_id, voter_id) do update set candidate_id = excluded.candidate_id, cast_at = now();

  if v_previous_candidate_id is not null then
    update public.union_candidates set vote_count = greatest(vote_count - 1, 0) where id = v_previous_candidate_id;
  end if;
  update public.union_candidates set vote_count = vote_count + 1 where id = p_candidate_id;
end;
$$;

-- Finalize only after voting closes (or once every eligible unit has
-- voted). Votes are recounted from the ballots, counting only voters who
-- are still eligible, so earlier ineligible ballots can't decide it. A
-- tie or a 0-vote leader changes nothing.
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

  if not exists (
    select 1 from public.union_members m
    where m.building_id = v_election.building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
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
end;
$$;


-- ---------------------------------------------------------------------
-- 6. Phone numbers: not selectable directly any more
-- ---------------------------------------------------------------------

-- Every column except phone stays readable (row visibility is still
-- decided by the existing RLS policies).
revoke select on public.profiles from authenticated, anon;
grant select (id, full_name, phone_hidden, avatar_url, is_verified, role, wallet_id, created_at, updated_at, ad_token_balance)
  on public.profiles to authenticated;

-- Returns the phones the caller is allowed to see among p_user_ids:
--   * their own;
--   * super_admin: everyone;
--   * president/board: anyone with a membership row (any status) in
--     their building — needed to review join requests and appoint guards;
--   * a unit's verified primary owner: that unit's tenants;
--   * anyone: a seller with an active listing that does NOT hide the
--     phone number.
create or replace function public.get_contact_phones(p_user_ids uuid[])
returns table (user_id uuid, phone text)
language sql
security definer
stable
set search_path = public
as $$
  select p.id, p.phone
  from public.profiles p
  where p.id = any(p_user_ids)
    and p.phone is not null
    and auth.uid() is not null
    and (
      p.id = auth.uid()
      or public.is_super_admin()
      or exists (
        select 1
        from public.union_members target
        join public.union_members me
          on me.building_id = target.building_id
         and me.user_id = auth.uid()
         and me.status = 'verified'
         and me.role in ('president', 'board_member')
        where target.user_id = p.id
      )
      or exists (
        select 1 from public.unit_residents ur
        where ur.user_id = p.id and ur.residency_type = 'tenant'
          and public.is_primary_owner_of(ur.unit_id)
      )
      or exists (
        select 1 from public.marketplace_listings l
        where l.seller_id = p.id and l.status = 'active' and not l.hide_phone_number
      )
    );
$$;

revoke execute on function public.get_contact_phones(uuid[]) from public, anon;
grant execute on function public.get_contact_phones(uuid[]) to authenticated;

-- express_interest_in_listing() and fetch_pending_technician_verifications()
-- are SECURITY DEFINER and keep reading profiles.phone as before.
