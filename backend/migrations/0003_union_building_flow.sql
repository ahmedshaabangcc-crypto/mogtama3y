-- =====================================================================
-- Migration 0003 — real "found a building" / "join with invite code"
-- flow. backend/schema.sql left buildings, units, union_invite_codes,
-- and union_members with RLS enabled but NO policies (default deny),
-- so nothing on this vertical works from the Flutter app until this
-- migration runs. Run this once in the Supabase SQL editor.
--
-- Design notes:
--  * Founding and joining are done through SECURITY DEFINER functions
--    (not raw table policies) so a joining user never needs direct
--    INSERT/UPDATE rights on union_invite_codes or on other people's
--    union_members rows — the function validates the invite code,
--    increments its use count, and creates the membership atomically.
--  * union_invite_codes has no client-facing SELECT policy at all —
--    it's only ever touched through join_building_with_code(), so a
--    code can't be enumerated/browsed by other users.
-- =====================================================================

-- ---- SELECT policies (read-only, low-sensitivity data) ----

create policy "buildings: public read" on public.buildings
  for select using (true);

create policy "units: public read" on public.units
  for select using (true);

create policy "union_members: user can view own" on public.union_members
  for select using (auth.uid() = user_id);

create policy "union_members: building members can view roster" on public.union_members
  for select using (
    exists (
      select 1 from public.union_members m2
      where m2.building_id = union_members.building_id
        and m2.user_id = auth.uid()
        and m2.status = 'verified'
    )
  );

create policy "unit_residents: user can view own" on public.unit_residents
  for select using (auth.uid() = user_id);

-- ---- found_building(): create a building + your own unit + become its president ----

create or replace function public.found_building(
  p_name text,
  p_district text,
  p_city text,
  p_governorate text,
  p_unit_number text,
  p_floor_label text
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

  insert into public.buildings (name, district, city, governorate, total_units, registered_units, is_officially_registered)
  values (p_name, p_district, p_city, p_governorate, 1, 1, false)
  returning id into v_building_id;

  insert into public.units (building_id, unit_number, floor_label)
  values (v_building_id, p_unit_number, p_floor_label)
  returning id into v_unit_id;

  insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
  values (v_unit_id, auth.uid(), 'owner', true);

  insert into public.union_members (building_id, user_id, unit_id, role, status, verified_by, verified_at)
  values (v_building_id, auth.uid(), v_unit_id, 'president', 'verified', auth.uid(), now());

  v_code := 'BLD-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));

  insert into public.union_invite_codes (building_id, code, issued_by, max_uses, used_count)
  values (v_building_id, v_code, auth.uid(), 9999, 0);

  return v_code;
end;
$$;

grant execute on function public.found_building(text, text, text, text, text, text) to authenticated;

-- ---- join_building_with_code(): validate a code and create a pending membership ----

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
  v_building_id uuid;
  v_unit_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
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

  v_building_id := v_invite.building_id;

  select id into v_unit_id from public.units
    where building_id = v_building_id and unit_number = p_unit_number;
  if v_unit_id is null then
    insert into public.units (building_id, unit_number, floor_label)
    values (v_building_id, p_unit_number, p_floor_label)
    returning id into v_unit_id;
  end if;

  insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
  values (v_unit_id, auth.uid(), p_residency_type::residency_type, true)
  on conflict (unit_id, user_id) do nothing;

  insert into public.union_members (building_id, user_id, unit_id, role, status, invite_code_id)
  values (v_building_id, auth.uid(), v_unit_id, 'resident', 'pending', v_invite.id)
  on conflict (building_id, user_id) do nothing;

  update public.union_invite_codes set used_count = used_count + 1 where id = v_invite.id;
end;
$$;

grant execute on function public.join_building_with_code(text, text, text, text) to authenticated;
