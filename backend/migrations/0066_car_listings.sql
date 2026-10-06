-- =====================================================================
-- 0066 — Cars marketplace ("سيارات").
--
-- Anyone can list a car, motorcycle, tuktuk, microbus or truck for sale,
-- for daily / monthly rent, or sell parts & accessories. Guests browse
-- the active listings; signed-in users post and manage their own.
--
-- Access:
--   * public (anon + authenticated) read of ACTIVE rows; owners also see
--     their own sold/removed rows (for "إعلاناتي");
--   * owners insert/update/delete only their own rows (owner_id = auth.uid());
--   * is_featured is set by the مُجتمعي team only — a trigger keeps it
--     unchanged for everyone except a super admin;
--   * express_interest_in_car() lets a signed-in user tell the owner
--     "أنا مهتم" through a notification (no phone numbers leak).
-- =====================================================================

create table if not exists public.car_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  offer_type text not null check (offer_type in ('sale', 'rent_daily', 'rent_monthly', 'parts')),
  vehicle_type text not null default 'car' check (vehicle_type in ('car', 'motorcycle', 'tuktuk', 'microbus', 'truck')),
  brand text,
  model text,
  year int check (year between 1960 and extract(year from now())::int + 1),
  km int check (km >= 0),
  transmission text check (transmission in ('manual', 'automatic')),
  fuel text check (fuel in ('benzine', 'diesel', 'natural_gas', 'hybrid', 'electric')),
  body_type text check (body_type in ('sedan', 'hatchback', 'suv', 'crossover', 'coupe', 'convertible', 'pickup', 'van')),
  color text,
  condition text not null default 'used' check (condition in ('new', 'used')),
  with_driver boolean,
  title text not null check (length(trim(title)) between 3 and 120),
  description text check (description is null or length(description) <= 3000),
  price numeric(12,2) not null check (price > 0),
  negotiable boolean not null default false,
  payment text not null default 'cash' check (payment in ('cash', 'installments', 'both')),
  governorate text,
  area text,
  images text[] not null default '{}' check (cardinality(images) <= 20),
  status text not null default 'active' check (status in ('active', 'sold', 'removed')),
  is_featured boolean not null default false,
  created_at timestamptz not null default now(),
  -- A brand is required for every vehicle offer; parts may be generic.
  constraint car_listings_brand_required check (
    offer_type = 'parts' or length(trim(coalesce(brand, ''))) > 0)
);

create index if not exists car_listings_browse
  on public.car_listings (status, offer_type, is_featured desc, created_at desc);
create index if not exists car_listings_brand
  on public.car_listings (brand, created_at desc) where status = 'active';
create index if not exists car_listings_created
  on public.car_listings (created_at desc);
create index if not exists car_listings_owner
  on public.car_listings (owner_id, created_at desc);

alter table public.car_listings enable row level security;
revoke all on public.car_listings from anon, authenticated;
grant select on public.car_listings to anon, authenticated;
grant insert, update, delete on public.car_listings to authenticated;

drop policy if exists "car_listings: public reads active" on public.car_listings;
create policy "car_listings: public reads active" on public.car_listings
  for select to anon, authenticated using (status = 'active');

drop policy if exists "car_listings: owner reads own" on public.car_listings;
create policy "car_listings: owner reads own" on public.car_listings
  for select to authenticated using (owner_id = auth.uid());

drop policy if exists "car_listings: owner inserts" on public.car_listings;
create policy "car_listings: owner inserts" on public.car_listings
  for insert to authenticated with check (owner_id = auth.uid());

drop policy if exists "car_listings: owner updates" on public.car_listings;
create policy "car_listings: owner updates" on public.car_listings
  for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "car_listings: owner deletes" on public.car_listings;
create policy "car_listings: owner deletes" on public.car_listings
  for delete to authenticated using (owner_id = auth.uid());

drop policy if exists "car_listings: super_admin manages all" on public.car_listings;
create policy "car_listings: super_admin manages all" on public.car_listings
  for all to authenticated using (public.is_super_admin()) with check (public.is_super_admin());

-- Featured placement is decided by the team, never by the seller: keep
-- is_featured as it was (false on insert) unless a super admin sets it.
create or replace function public.guard_car_listing_featured() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user = 'anon'
     or (current_user = 'authenticated' and not public.is_super_admin()) then
    if tg_op = 'INSERT' then
      new.is_featured := false;
    else
      new.is_featured := old.is_featured;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_car_listing_featured on public.car_listings;
create trigger guard_car_listing_featured
  before insert or update on public.car_listings
  for each row execute function public.guard_car_listing_featured();

-- ---------------------------------------------------------------- interest
-- "أنا مهتم": notify the owner with the interested user's name.
create or replace function public.express_interest_in_car(p_listing_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_owner uuid;
  v_title text;
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select owner_id, title into v_owner, v_title
  from public.car_listings where id = p_listing_id and status = 'active';
  if v_owner is null then raise exception 'الإعلان مش موجود'; end if;
  if v_owner = auth.uid() then raise exception 'ده إعلانك'; end if;
  select coalesce(nullif(trim(full_name), ''), 'حد') into v_name from public.profiles where id = auth.uid();
  v_name := coalesce(v_name, 'حد') || ' مهتم بـ «' || v_title || '»';
  -- Tapping twice in a row doesn't spam the owner.
  if exists (select 1 from public.notifications
             where user_id = v_owner and deep_link = '/#/cars/' || p_listing_id
               and body = v_name and created_at > now() - interval '1 day') then
    return;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (v_owner, 'في حد مهتم بإعلانك', v_name, '/#/cars/' || p_listing_id);
end;
$$;

revoke execute on function public.express_interest_in_car(uuid) from public, anon;
grant execute on function public.express_interest_in_car(uuid) to authenticated;
