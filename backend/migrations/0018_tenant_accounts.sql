-- =====================================================================
-- Migration 0018 — owner-controlled tenant sub-accounts. Run after
-- 0002-0017, in order, in the Supabase SQL editor.
--
-- Design: a unit's owner (unit_residents.is_primary = true AND
-- residency_type = 'owner') generates a single-use invite code scoped
-- to their OWN unit. Whoever redeems it becomes a verified tenant on
-- that unit immediately — no separate president/board review, because
-- the owner personally handing over the code IS the vetting step. This
-- is deliberately a different, narrower path from
-- join_building_with_code() (public building-wide code, always lands
-- pending for president review) — a tenant is the owner's
-- responsibility, not the building's.
--
-- Once verified, a tenant's dues/posts access already works for free
-- through the existing unit_id/user_id-scoped policies in
-- 0014_union_dues.sql and schema.sql's posts policies — nothing there
-- is role- or residency_type-aware, so no changes needed there. Tenants
-- simply never get 'board_member'/'president' role, so every existing
-- governance RPC (create_union_due, review_union_member, etc.) already
-- excludes them.
--
-- Also fixes a real bug found while building this: profiles only ever
-- had a "view own" SELECT policy, so pending_members_screen.dart's
-- `profile:profiles(full_name, phone)` embed was silently coming back
-- null for every applicant except the reviewer themself. Added a
-- building-co-member policy so neighbors (and now owners reviewing
-- their tenants) can actually see who they're approving.
-- =====================================================================

create table public.tenant_invite_codes (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id) on delete cascade,
  code text not null unique,
  issued_by uuid not null references public.profiles(id),
  max_uses int not null default 1,
  used_count int not null default 0,
  expires_at timestamptz,
  created_at timestamptz not null default now()
);

-- no client-facing select policy: only ever touched via the RPCs below,
-- same reasoning as union_invite_codes.
grant select on public.tenant_invite_codes to authenticated;

-- ---- profiles: let building co-members see each other (fixes the
-- pending-members name/phone bug and lets owners see their tenants) ----

create policy "profiles: building co-members can view" on public.profiles
  for select using (
    exists (
      select 1 from public.union_members m1
      join public.union_members m2 on m1.building_id = m2.building_id
      where m1.user_id = auth.uid() and m1.status = 'verified'
        and m2.user_id = profiles.id
    )
  );

-- ---- unit_residents: owner can see who else lives in their own unit ----

create or replace function public.is_primary_owner_of(p_unit_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.unit_residents
    where unit_id = p_unit_id and user_id = auth.uid()
      and residency_type = 'owner' and is_primary = true
  );
$$;

create policy "unit_residents: owner views own unit" on public.unit_residents
  for select using (public.is_primary_owner_of(unit_id));

create policy "union_members: owner views own unit" on public.union_members
  for select using (public.is_primary_owner_of(unit_id));

-- ---- invite_tenant_for_unit(): owner generates a code for their unit ----

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

  v_code := 'TEN-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));

  insert into public.tenant_invite_codes (unit_id, code, issued_by)
  values (p_unit_id, v_code, auth.uid());

  return v_code;
end;
$$;

grant execute on function public.invite_tenant_for_unit(uuid) to authenticated;

-- ---- join_as_tenant_with_code(): redeem a tenant code, verified instantly ----

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

  if public.is_primary_owner_of(v_invite.unit_id) then
    raise exception 'أنت بالفعل مالك هذه الوحدة';
  end if;

  select building_id into v_building_id from public.units where id = v_invite.unit_id;

  insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
  values (v_invite.unit_id, auth.uid(), 'tenant', false)
  on conflict (unit_id, user_id) do update set residency_type = 'tenant';

  insert into public.union_members (building_id, user_id, unit_id, role, status, verified_by, verified_at)
  values (v_building_id, auth.uid(), v_invite.unit_id, 'resident', 'verified', v_invite.issued_by, now())
  on conflict (building_id, user_id) do update set status = 'verified', unit_id = v_invite.unit_id, verified_by = v_invite.issued_by, verified_at = now();

  update public.tenant_invite_codes set used_count = used_count + 1 where id = v_invite.id;
end;
$$;

grant execute on function public.join_as_tenant_with_code(text) to authenticated;

-- ---- revoke_tenant(): owner removes a tenant's access to their unit ----

create or replace function public.revoke_tenant(p_unit_id uuid, p_tenant_user_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  if not public.is_primary_owner_of(p_unit_id) then
    raise exception 'غير مصرح لك بإدارة مستأجري هذه الوحدة';
  end if;

  select building_id into v_building_id from public.units where id = p_unit_id;

  delete from public.unit_residents
    where unit_id = p_unit_id and user_id = p_tenant_user_id and residency_type = 'tenant';

  update public.union_members set status = 'rejected'
    where building_id = v_building_id and user_id = p_tenant_user_id and unit_id = p_unit_id;
end;
$$;

grant execute on function public.revoke_tenant(uuid, uuid) to authenticated;
