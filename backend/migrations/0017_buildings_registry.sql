-- =====================================================================
-- Migration 0017 — real buildings registry via Google Places, so two
-- neighbors founding "the same" real building don't end up fragmented
-- into two separate digital groups. Run after 0002-0016, in order, in
-- the Supabase SQL editor.
--
-- Design: the client resolves the building the user typed to a real
-- Google Place (place_id + lat/lng) before submitting. found_building()
-- now takes that place_id optionally:
--   * no place_id (manual entry, e.g. a building Places doesn't know) ->
--     behaves exactly as before, creates a brand new building.
--   * place_id given, no existing building has it -> creates a new
--     building same as before, but stores the place_id so the *next*
--     neighbor who picks the same real place is matched to it.
--   * place_id given, a building already has it -> does NOT create a
--     duplicate building. Instead it adds the caller as a *pending*
--     union_members row on the existing building (same shape as
--     joining with an invite code), which the existing president/board
--     already review in the pending-members screen. Returns the
--     sentinel 'PENDING_EXISTING' instead of an invite code so the
--     client can show "your request was sent" instead of a new code.
-- =====================================================================

alter table public.buildings add column if not exists google_place_id text unique;

-- Postgres identifies functions by name + parameter types, so adding
-- new defaulted params to found_building() would create a SECOND
-- overload rather than replacing the old one, and a 6-arg call from
-- the (not-yet-redeployed) app would then be ambiguous between the
-- two. Drop the old 6-arg signature explicitly first.
drop function if exists public.found_building(text, text, text, text, text, text);

create or replace function public.found_building(
  p_name text,
  p_district text,
  p_city text,
  p_governorate text,
  p_unit_number text,
  p_floor_label text,
  p_google_place_id text default null,
  p_lat numeric default null,
  p_lng numeric default null
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
    -- real building already registered by someone else — request to join it
    -- instead of creating a duplicate.
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
  values (v_building_id, auth.uid(), v_unit_id, 'president', 'verified', auth.uid(), now());

  v_code := 'BLD-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));

  insert into public.union_invite_codes (building_id, code, issued_by, max_uses, used_count)
  values (v_building_id, v_code, auth.uid(), 9999, 0);

  return v_code;
end;
$$;

grant execute on function public.found_building(text, text, text, text, text, text, text, numeric, numeric) to authenticated;
