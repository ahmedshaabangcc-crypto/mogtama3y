-- =====================================================================
-- Migration 0048 — "عنوانك الإلكتروني" (digital address).
--
-- A user saves an address once (governorate → apartment, a landmark and
-- the exact GPS pin) and gets a short unguessable code, e.g. K7P2X9QM,
-- shown as MG-K7P2-X9QM. The code becomes a link + QR
-- (mogtama3y.com/#/a/K7P2X9QM) that anyone can open — no account — to
-- read the address and navigate to it on Google Maps.
--
--   * Owners manage their addresses only through save_my_e_address /
--     regenerate_e_address_code (the code and scan counter are server
--     controlled); they can read and delete their own rows directly.
--   * The public reads one address only by its exact code through
--     get_e_address(); the table itself is never readable by others.
--     The owner's name / phone are included only if they opted in.
--   * Regenerating the code kills the old link and QR.
-- =====================================================================

create table if not exists public.e_addresses (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  code text not null unique,
  label text not null default 'البيت',
  governorate text not null,
  city text not null,
  district text,
  street text,
  building text,
  floor text,
  apartment text,
  landmark text,
  notes text,
  lat double precision,
  lng double precision,
  show_name boolean not null default true,
  show_phone boolean not null default false,
  is_active boolean not null default true,
  scan_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists e_addresses_owner_idx on public.e_addresses (owner_id);

alter table public.e_addresses enable row level security;
revoke all on public.e_addresses from anon, authenticated;
grant select, delete on public.e_addresses to authenticated;

create policy "e_addresses: owner reads own" on public.e_addresses
  for select to authenticated using (owner_id = auth.uid());
create policy "e_addresses: owner deletes own" on public.e_addresses
  for delete to authenticated using (owner_id = auth.uid());

-- 8 characters from a 32-letter alphabet without look-alikes (no 0/O/1/I),
-- taken from the random bytes of a v4 UUID (bytes 6 and 8 carry fixed
-- version/variant bits, so they are skipped). 32^8 ≈ 10^12 codes.
create or replace function public._new_e_address_code() returns text
language plpgsql
volatile
set search_path = public
as $$
declare
  v_alphabet constant text := '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  v_bytes bytea;
  v_code text;
  v_idx int;
begin
  loop
    v_bytes := uuid_send(gen_random_uuid());
    v_code := '';
    foreach v_idx in array array[0, 1, 2, 3, 4, 5, 10, 11] loop
      v_code := v_code || substr(v_alphabet, (get_byte(v_bytes, v_idx) % 32) + 1, 1);
    end loop;
    exit when not exists (select 1 from public.e_addresses where code = v_code);
  end loop;
  return v_code;
end;
$$;

-- Create (p_id null) or update one of the caller's addresses. Returns the code.
create or replace function public.save_my_e_address(p_id uuid, p jsonb) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lat double precision := nullif(p->>'lat', '')::double precision;
  v_lng double precision := nullif(p->>'lng', '')::double precision;
  v_code text;
  -- trimmed text field, null when blank, capped in length
  f_label text := left(nullif(trim(coalesce(p->>'label', '')), ''), 40);
  f_gov text := left(nullif(trim(coalesce(p->>'governorate', '')), ''), 60);
  f_city text := left(nullif(trim(coalesce(p->>'city', '')), ''), 80);
  f_district text := left(nullif(trim(coalesce(p->>'district', '')), ''), 120);
  f_street text := left(nullif(trim(coalesce(p->>'street', '')), ''), 160);
  f_building text := left(nullif(trim(coalesce(p->>'building', '')), ''), 40);
  f_floor text := left(nullif(trim(coalesce(p->>'floor', '')), ''), 20);
  f_apartment text := left(nullif(trim(coalesce(p->>'apartment', '')), ''), 20);
  f_landmark text := left(nullif(trim(coalesce(p->>'landmark', '')), ''), 200);
  f_notes text := left(nullif(trim(coalesce(p->>'notes', '')), ''), 500);
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if f_gov is null or f_city is null then
    raise exception 'اختار المحافظة واكتب المدينة أو الحي';
  end if;
  if f_building is null and f_landmark is null then
    raise exception 'اكتب رقم العمارة أو علامة مميزة جنب العنوان';
  end if;
  if (v_lat is null) <> (v_lng is null)
     or (v_lat is not null and (v_lat not between 21.5 and 32 or v_lng not between 24.5 and 37)) then
    raise exception 'الموقع على الخريطة لازم يكون جوه مصر';
  end if;

  if p_id is null then
    if (select count(*) from public.e_addresses where owner_id = auth.uid()) >= 5 then
      raise exception 'وصلت للحد الأقصى (5 عناوين لكل حساب)';
    end if;
    v_code := public._new_e_address_code();
    insert into public.e_addresses (owner_id, code, label, governorate, city, district, street, building, floor,
                                    apartment, landmark, notes, lat, lng, show_name, show_phone)
    values (auth.uid(), v_code, coalesce(f_label, 'البيت'), f_gov, f_city, f_district, f_street, f_building, f_floor,
            f_apartment, f_landmark, f_notes, v_lat, v_lng,
            coalesce((p->>'show_name')::boolean, true), coalesce((p->>'show_phone')::boolean, false));
    return v_code;
  end if;

  update public.e_addresses set
    label = coalesce(f_label, label),
    governorate = f_gov, city = f_city, district = f_district, street = f_street, building = f_building,
    floor = f_floor, apartment = f_apartment, landmark = f_landmark, notes = f_notes,
    lat = v_lat, lng = v_lng,
    show_name = coalesce((p->>'show_name')::boolean, show_name),
    show_phone = coalesce((p->>'show_phone')::boolean, show_phone),
    is_active = coalesce((p->>'is_active')::boolean, is_active),
    updated_at = now()
  where id = p_id and owner_id = auth.uid()
  returning code into v_code;
  if v_code is null then
    raise exception 'العنوان ده مش موجود';
  end if;
  return v_code;
end;
$$;

-- New code for one of the caller's addresses; the old link / QR stop working.
create or replace function public.regenerate_e_address_code(p_id uuid) returns text
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
  update public.e_addresses
     set code = public._new_e_address_code(), scan_count = 0, updated_at = now()
   where id = p_id and owner_id = auth.uid()
  returning code into v_code;
  if v_code is null then
    raise exception 'العنوان ده مش موجود';
  end if;
  return v_code;
end;
$$;

-- Public lookup by exact code (guests allowed). Counts the visit.
create or replace function public.get_e_address(p_code text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text := upper(regexp_replace(coalesce(p_code, ''), '[^A-Za-z0-9]', '', 'g'));
  r public.e_addresses;
  v_name text;
  v_phone text;
begin
  -- Accept "MG-K7P2-X9QM" as well as the bare code.
  if v_code like 'MG%' and length(v_code) = 10 then
    v_code := substr(v_code, 3);
  end if;
  if length(v_code) <> 8 then
    return null;
  end if;

  update public.e_addresses set scan_count = scan_count + 1
   where code = v_code and is_active
  returning * into r;
  if r.id is null then
    return null;
  end if;

  select full_name, phone into v_name, v_phone from public.profiles where id = r.owner_id;
  return jsonb_build_object(
    'code', r.code,
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

revoke execute on function public._new_e_address_code() from public, anon, authenticated;
revoke execute on function public.save_my_e_address(uuid, jsonb) from public, anon;
revoke execute on function public.regenerate_e_address_code(uuid) from public, anon;
revoke execute on function public.get_e_address(text) from public;
grant execute on function public.save_my_e_address(uuid, jsonb) to authenticated;
grant execute on function public.regenerate_e_address_code(uuid) to authenticated;
grant execute on function public.get_e_address(text) to anon, authenticated;
