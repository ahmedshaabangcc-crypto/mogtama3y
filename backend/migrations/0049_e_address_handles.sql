-- =====================================================================
-- Migration 0049 — easy-to-remember digital addresses.
--
-- The random code (0048) stays the base of every address. On top of it
-- the owner may add, both optional:
--   * handle — a unique name they choose, e.g. ahmed-maadi, so the link
--     is mogtama3y.com/#/a/ahmed-maadi. Never reused by anyone else.
--     Single-word names (ahmed, mona, cairo, king…) are PREMIUM: reserved
--     for the platform to sell later. Users must pick at least two words
--     joined by a hyphen (ahmed-maadi); only a super admin can assign a
--     single-word name (admin_assign_e_address_handle).
--   * phone_lookup — "open my address by my mobile number". At most one
--     address per person; anyone who knows the number can open it, which
--     is why it is off by default.
--
-- Lookup order in get_e_address(): mobile number → random code → handle.
-- Codes win over handles, and a handle may never equal an existing code
-- (and vice versa), so nobody can register a name that hijacks someone
-- else's printed QR.
-- =====================================================================

alter table public.e_addresses add column if not exists handle text;
alter table public.e_addresses add column if not exists phone_lookup boolean not null default false;
create unique index if not exists e_addresses_handle_key on public.e_addresses (handle);
create unique index if not exists e_addresses_one_phone_lookup on public.e_addresses (owner_id) where phone_lookup;

-- Normalised handle, or raises with a user-facing reason.
create or replace function public._clean_e_address_handle(p text, p_self uuid, p_admin boolean default false) returns text
language plpgsql
stable
set search_path = public
as $$
declare
  v text := lower(trim(coalesce(p, '')));
begin
  if v = '' then
    return null;
  end if;
  if v !~ '^[a-z][a-z0-9]*(-[a-z0-9]+)*$' or length(v) not between 4 and 30 then
    raise exception 'الاسم لازم يكون بالإنجليزي، يبدأ بحرف، من 4 لـ 30 حرف (حروف وأرقام وشرطة -)';
  end if;
  -- Premium single-word names: only the platform assigns them. An owner
  -- re-saving the premium name they already hold keeps it.
  if position('-' in v) = 0 and not p_admin
     and not exists (select 1 from public.e_addresses where id = p_self and handle = v) then
    raise exception 'الأسماء اللي من كلمة واحدة (زي ahmed أو mona) أسماء مميزة محجوزة. ضيف كلمة تانية بشرطة، زي ahmed-maadi';
  end if;
  if not p_admin and v in ('admin', 'support', 'mogtama3y', 'mogtamay', 'help', 'test', 'login', 'merchant', 'ittihad',
           'nearby', 'police', 'official', 'system', 'null', 'undefined') then
    raise exception 'الاسم ده محجوز، اختار اسم تاني';
  end if;
  if exists (select 1 from public.e_addresses where handle = v and id is distinct from p_self)
     or exists (select 1 from public.e_addresses where code = upper(v)) then
    raise exception 'الاسم ده متاخد، جرّب اسم تاني';
  end if;
  return v;
end;
$$;

-- A super admin assigns a premium (single-word) name to an address — the
-- way reserved names are sold.
create or replace function public.admin_assign_e_address_handle(p_address_id uuid, p_handle text) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  update public.e_addresses
     set handle = public._clean_e_address_handle(p_handle, p_address_id, true), updated_at = now()
   where id = p_address_id;
  if not found then
    raise exception 'العنوان ده مش موجود';
  end if;
end;
$$;

-- Live availability check for the form (true = free to take).
create or replace function public.e_address_handle_available(p_handle text, p_self uuid default null) returns boolean
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  perform public._clean_e_address_handle(p_handle, p_self);
  return true;
exception when others then
  return false;
end;
$$;

-- Codes must also never collide with a handle (handles are stored lowercase).
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
    exit when not exists (select 1 from public.e_addresses where code = v_code or handle = lower(v_code));
  end loop;
  return v_code;
end;
$$;

create or replace function public.save_my_e_address(p_id uuid, p jsonb) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lat double precision := nullif(p->>'lat', '')::double precision;
  v_lng double precision := nullif(p->>'lng', '')::double precision;
  v_code text;
  v_handle text;
  v_phone_lookup boolean := coalesce((p->>'phone_lookup')::boolean, false);
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
  if p_id is not null and not exists (select 1 from public.e_addresses where id = p_id and owner_id = auth.uid()) then
    raise exception 'العنوان ده مش موجود';
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
  v_handle := public._clean_e_address_handle(p->>'handle', p_id);
  if v_phone_lookup and coalesce((select phone from public.profiles where id = auth.uid()), '') = '' then
    raise exception 'ضيف رقم موبايلك في حسابك الأول عشان تفتح العنوان بيه';
  end if;

  if p_id is null then
    if (select count(*) from public.e_addresses where owner_id = auth.uid()) >= 5 then
      raise exception 'وصلت للحد الأقصى (5 عناوين لكل حساب)';
    end if;
    if v_phone_lookup then
      update public.e_addresses set phone_lookup = false where owner_id = auth.uid() and phone_lookup;
    end if;
    v_code := public._new_e_address_code();
    insert into public.e_addresses (owner_id, code, handle, phone_lookup, label, governorate, city, district, street,
                                    building, floor, apartment, landmark, notes, lat, lng, show_name, show_phone)
    values (auth.uid(), v_code, v_handle, v_phone_lookup, coalesce(f_label, 'البيت'), f_gov, f_city, f_district, f_street,
            f_building, f_floor, f_apartment, f_landmark, f_notes, v_lat, v_lng,
            coalesce((p->>'show_name')::boolean, true), coalesce((p->>'show_phone')::boolean, false));
    return v_code;
  end if;

  if v_phone_lookup then
    update public.e_addresses set phone_lookup = false where owner_id = auth.uid() and phone_lookup and id <> p_id;
  end if;
  update public.e_addresses set
    label = coalesce(f_label, label),
    handle = v_handle,
    phone_lookup = v_phone_lookup,
    governorate = f_gov, city = f_city, district = f_district, street = f_street, building = f_building,
    floor = f_floor, apartment = f_apartment, landmark = f_landmark, notes = f_notes,
    lat = v_lat, lng = v_lng,
    show_name = coalesce((p->>'show_name')::boolean, show_name),
    show_phone = coalesce((p->>'show_phone')::boolean, show_phone),
    is_active = coalesce((p->>'is_active')::boolean, is_active),
    updated_at = now()
  where id = p_id and owner_id = auth.uid()
  returning code into v_code;
  return v_code;
end;
$$;

-- Public lookup by mobile number, random code or handle (guests allowed).
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
       where pr.phone = v_digits and a.phone_lookup and a.is_active;
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

revoke execute on function public._clean_e_address_handle(text, uuid, boolean) from public, anon, authenticated;
revoke execute on function public.admin_assign_e_address_handle(uuid, text) from public, anon;
grant execute on function public.admin_assign_e_address_handle(uuid, text) to authenticated;
revoke execute on function public._new_e_address_code() from public, anon, authenticated;
revoke execute on function public.e_address_handle_available(text, uuid) from public, anon;
grant execute on function public.e_address_handle_available(text, uuid) to authenticated;
revoke execute on function public.save_my_e_address(uuid, jsonb) from public, anon;
grant execute on function public.save_my_e_address(uuid, jsonb) to authenticated;
revoke execute on function public.get_e_address(text) from public;
grant execute on function public.get_e_address(text) to anon, authenticated;
