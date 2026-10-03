-- =====================================================================
-- Migration 0052 — who opened my address? (delivery transparency)
--
-- Shops and delivery riders open a customer's address with the name,
-- mobile number or code the customer gave them — giving it IS the
-- consent, exactly like sharing the link. Every opening is now logged,
-- and the owner sees the list (the signed-in viewer's name and shop, or
-- a guest) on their address card. Nothing is sold or listed: no address
-- can be found without its exact name / number / code.
-- =====================================================================

create table if not exists public.e_address_views (
  id bigint generated always as identity primary key,
  address_id uuid not null references public.e_addresses(id) on delete cascade,
  viewer_id uuid references public.profiles(id) on delete set null,
  viewed_at timestamptz not null default now()
);
create index if not exists e_address_views_address_idx on public.e_address_views (address_id, viewed_at desc);
alter table public.e_address_views enable row level security;
revoke all on public.e_address_views from anon, authenticated;

-- Same lookup as 0049, plus the view log.
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

-- The owner's view log for one of their addresses (latest 50).
create or replace function public.my_e_address_views(p_address_id uuid) returns table (
  viewed_at timestamptz, viewer_name text, shop_name text
)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not exists (select 1 from public.e_addresses where id = p_address_id and owner_id = auth.uid()) then
    raise exception 'العنوان ده مش موجود';
  end if;
  return query
    select v.viewed_at, p.full_name,
           (select s.name from public.shops s where s.owner_id = v.viewer_id order by s.created_at limit 1)
      from public.e_address_views v
      left join public.profiles p on p.id = v.viewer_id
     where v.address_id = p_address_id
     order by v.viewed_at desc
     limit 50;
end;
$$;

revoke execute on function public.get_e_address(text) from public;
grant execute on function public.get_e_address(text) to anon, authenticated;
revoke execute on function public.my_e_address_views(uuid) from public, anon;
grant execute on function public.my_e_address_views(uuid) to authenticated;
