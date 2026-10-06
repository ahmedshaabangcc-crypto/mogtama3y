-- =====================================================================
-- 0074 — Verified mobile numbers.
--
-- profiles.phone was whatever the user typed. Anyone could type someone
-- else's number — and "open my address by my mobile number" (0049) then
-- answered with the impostor's address. Now a number is *verified* when the
-- user proves it with an SMS code (Firebase Phone Auth): the verify-phone
-- Edge Function checks Firebase's signed token and calls
-- confirm_phone_verified() with the service role.
--
--   * profiles.phone_verified_at — set only by confirm_phone_verified();
--     clients can't write it (no column grant) and editing the phone
--     clears it.
--   * one owner per number: proving a number takes it from any other
--     account that only typed it (or verified it earlier).
--   * mobile-number address lookup only matches verified numbers.
-- Safe to re-run.
-- =====================================================================

alter table public.profiles add column if not exists phone_verified_at timestamptz;
grant select (phone_verified_at) on public.profiles to authenticated;

-- Editing the number from the app drops the verification. The confirm
-- function sets phone and phone_verified_at together, so it passes.
create or replace function public.profiles_phone_unverify() returns trigger
language plpgsql set search_path = public as $$
begin
  if new.phone is distinct from old.phone and new.phone_verified_at is not distinct from old.phone_verified_at then
    new.phone_verified_at := null;
  end if;
  return new;
end;
$$;
drop trigger if exists profiles_phone_unverify on public.profiles;
create trigger profiles_phone_unverify before update of phone on public.profiles
  for each row execute function public.profiles_phone_unverify();

-- Called by the verify-phone Edge Function (service role) after it has
-- checked the Firebase ID token. p_phone is 01XXXXXXXXX.
create or replace function public.confirm_phone_verified(p_user uuid, p_phone text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if p_phone !~ '^01[0125][0-9]{8}$' then
    raise exception 'رقم موبايل مش صحيح';
  end if;
  -- Whoever proves the number gets it; an account that only typed it loses it
  -- (profiles.phone is unique, so it must be freed first).
  update public.profiles set phone = null, phone_verified_at = null
   where phone = p_phone and id <> p_user;
  update public.profiles set phone = p_phone, phone_verified_at = now(), updated_at = now()
   where id = p_user;
  if not found then
    raise exception 'الحساب مش موجود';
  end if;
end;
$$;
revoke execute on function public.confirm_phone_verified(uuid, text) from public, anon, authenticated;
grant execute on function public.confirm_phone_verified(uuid, text) to service_role;

-- Same as 0052, except a mobile number only finds a *verified* owner.
create or replace function public.get_e_address(p_code text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_raw text := trim(coalesce(p_code, ''));
  v_digits text := regexp_replace(v_raw, '[^0-9]', '', 'g');
  v_code text := upper(regexp_replace(v_raw, '[^A-Za-z0-9]', '', 'g'));
  v_id uuid;
  r public.e_addresses;
  v_name text;
  v_phone text;
begin
  -- 1) Mobile number: 01XXXXXXXXX, 2001XXXXXXXXX or +20 1XXXXXXXXX.
  if v_raw ~ '^[+0-9 -]+$' then
    if v_digits ~ '^201[0125][0-9]{8}$' then
      v_digits := substr(v_digits, 2);
    end if;
    if v_digits ~ '^01[0125][0-9]{8}$' then
      select a.id into v_id
        from public.e_addresses a join public.profiles pr on pr.id = a.owner_id
       where pr.phone = v_digits and pr.phone_verified_at is not null and a.phone_lookup and a.is_active;
    end if;
  end if;

  -- 2) Random code, with or without the MG- prefix.
  if v_id is null then
    if v_code like 'MG%' and length(v_code) = 10 then
      v_code := substr(v_code, 3);
    end if;
    if length(v_code) = 8 then
      select id into v_id from public.e_addresses where code = v_code and is_active;
    end if;
  end if;

  -- 3) Handle.
  if v_id is null then
    select id into v_id from public.e_addresses where handle = lower(v_raw) and is_active;
  end if;

  if v_id is null then
    return null;
  end if;

  update public.e_addresses set scan_count = scan_count + 1 where id = v_id returning * into r;
  -- Every opening is logged so the owner can see who opened the address.
  insert into public.e_address_views (address_id, viewer_id) values (v_id, auth.uid());

  select full_name, phone into v_name, v_phone from public.profiles where id = r.owner_id;
  return jsonb_build_object(
    'code', r.code,
    'handle', r.handle,
    'label', r.label,
    'governorate', r.governorate,
    'city', r.city,
    'district', r.district,
    'street', r.street,
    'building', r.building,
    'floor', r.floor,
    'apartment', r.apartment,
    'landmark', r.landmark,
    'notes', r.notes,
    'lat', r.lat,
    'lng', r.lng,
    'owner_name', case when r.show_name then v_name end,
    'owner_phone', case when r.show_phone then v_phone end
  );
end;
$$;
grant execute on function public.get_e_address(text) to anon, authenticated;
