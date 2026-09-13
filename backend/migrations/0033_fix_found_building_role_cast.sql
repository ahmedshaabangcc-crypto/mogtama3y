-- =====================================================================
-- Migration 0033 — fixes a real bug introduced by 0032: the
-- `case when p_as_president then 'president' else 'board_member' end`
-- expression has no explicit type, so Postgres resolves it as `text`
-- rather than the `union_role` enum the union_members.role column
-- actually needs — the insert fails with a type-mismatch error
-- ("column "role" is of type union_role but expression is of type
-- text") for BOTH founding paths, president and resident alike. This
-- broke found_building() entirely from the moment 0032 was run.
-- Run this immediately after 0032 (or right away if 0032 already
-- broke founding for you, as it did for Ahmed on first real test).
-- =====================================================================

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
  p_as_president boolean default true
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

  if p_google_place_id is not null then
    select id into v_building_id from public.buildings where google_place_id = p_google_place_id;
  end if;

  if v_building_id is not null then
    select id into v_unit_id from public.units
      where building_id = v_building_id and unit_number = p_unit_number;
    if v_unit_id is null then
      insert into public.units (building_id, unit_number, floor_label)
      values (v_building_id, p_unit_number, p_floor_label)
      returning id into v_unit_id;
    end if;

    insert into public.unit_residents (unit_id, user_id, residency_type, is_primary)
    values (v_unit_id, auth.uid(), 'owner', true)
    on conflict (unit_id, user_id) do nothing;

    insert into public.union_members (building_id, user_id, unit_id, role, status)
    values (v_building_id, auth.uid(), v_unit_id, 'resident', 'pending')
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
