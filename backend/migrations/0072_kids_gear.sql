-- =====================================================================
-- 0072 — Kids & baby gear ("مستلزمات الأطفال").
--
-- Parents sell, swap or give away strollers, car seats, cribs, toys,
-- clothes, school bags, books… new or used. Guests browse the active
-- listings; signed-in users post and manage their own ("إعلاناتي").
--
-- Access:
--   * public (anon + authenticated) read of ACTIVE rows; owners also see
--     their own inactive rows;
--   * the poster's phone is readable by signed-in users only (column
--     grants) so guests can't scrape numbers — they sign in to call;
--   * owners insert/update/delete only their own rows (owner_id = auth.uid());
--   * a super admin moderates everything;
--   * a giveaway ("ببلاش لأي حد محتاج") has no price, a sale must have one;
--   * express_interest_in_kids_item() tells the owner "أنا مهتم" through
--     a notification, like cars (0066).
-- =====================================================================

create table if not exists public.kids_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  category text not null check (category in (
    'stroller', 'car_seat', 'crib', 'high_chair', 'toys', 'clothes',
    'school', 'books', 'feeding', 'furniture', 'bikes', 'other')),
  title text not null check (length(trim(title)) between 3 and 120),
  condition text not null default 'good' check (condition in ('new', 'like_new', 'good', 'needs_repair')),
  age_range text check (age_range in ('0_6m', '6_12m', '1_3y', '3_6y', '6_12y', '12_plus')),
  gender text not null default 'any' check (gender in ('boy', 'girl', 'any')),
  -- Clothes only: "مقاس 4 سنين", "XL", "نمرة 28"…
  clothes_size text check (clothes_size is null or length(trim(clothes_size)) between 1 and 30),
  brand text check (brand is null or length(brand) <= 60),
  price numeric(10,2) check (price is null or price > 0),
  is_free boolean not null default false,
  swap_allowed boolean not null default false,
  governorate text,
  area text check (area is null or length(area) <= 80),
  description text check (description is null or length(description) <= 3000),
  images text[] not null default '{}' check (cardinality(images) <= 10),
  phone text not null check (phone ~ '^01[0125][0-9]{8}$'),
  phone_on_whatsapp boolean not null default true,
  is_active boolean not null default true,
  is_sold boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- "ببلاش" means no price at all; anything else needs one.
  constraint kids_listings_price_or_free check (
    (is_free and price is null) or (not is_free and price is not null))
);

create index if not exists kids_listings_browse
  on public.kids_listings (category, created_at desc) where is_active and not is_sold;
create index if not exists kids_listings_created
  on public.kids_listings (created_at desc) where is_active and not is_sold;
create index if not exists kids_listings_owner
  on public.kids_listings (owner_id, created_at desc);

alter table public.kids_listings enable row level security;
revoke all on public.kids_listings from anon, authenticated;
-- Guests read everything except the phone number.
grant select (id, owner_id, category, title, condition, age_range, gender, clothes_size, brand,
              price, is_free, swap_allowed, governorate, area, description, images,
              phone_on_whatsapp, is_active, is_sold, created_at, updated_at)
  on public.kids_listings to anon;
grant select, insert, update, delete on public.kids_listings to authenticated;

drop policy if exists "kids_listings: public reads active" on public.kids_listings;
create policy "kids_listings: public reads active" on public.kids_listings
  for select to anon, authenticated using (is_active);

drop policy if exists "kids_listings: owner reads own" on public.kids_listings;
create policy "kids_listings: owner reads own" on public.kids_listings
  for select to authenticated using (owner_id = auth.uid());

drop policy if exists "kids_listings: owner inserts" on public.kids_listings;
create policy "kids_listings: owner inserts" on public.kids_listings
  for insert to authenticated with check (owner_id = auth.uid());

drop policy if exists "kids_listings: owner updates" on public.kids_listings;
create policy "kids_listings: owner updates" on public.kids_listings
  for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "kids_listings: owner deletes" on public.kids_listings;
create policy "kids_listings: owner deletes" on public.kids_listings
  for delete to authenticated using (owner_id = auth.uid());

drop policy if exists "kids_listings: super_admin manages all" on public.kids_listings;
create policy "kids_listings: super_admin manages all" on public.kids_listings
  for all to authenticated using (public.is_super_admin()) with check (public.is_super_admin());

create or replace function public.touch_kids_listing() returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists touch_kids_listing on public.kids_listings;
create trigger touch_kids_listing
  before update on public.kids_listings
  for each row execute function public.touch_kids_listing();

-- ---------------------------------------------------------------- interest
-- "أنا مهتم": notify the owner with the interested user's name.
create or replace function public.express_interest_in_kids_item(p_listing_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_owner uuid;
  v_title text;
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select owner_id, title into v_owner, v_title
  from public.kids_listings where id = p_listing_id and is_active and not is_sold;
  if v_owner is null then raise exception 'الإعلان مش موجود'; end if;
  if v_owner = auth.uid() then raise exception 'ده إعلانك'; end if;
  select coalesce(nullif(trim(full_name), ''), 'حد') into v_name from public.profiles where id = auth.uid();
  v_name := coalesce(v_name, 'حد') || ' مهتم بـ «' || v_title || '»';
  -- Tapping twice in a row doesn't spam the owner.
  if exists (select 1 from public.notifications
             where user_id = v_owner and deep_link = '/#/kids/' || p_listing_id
               and body = v_name and created_at > now() - interval '1 day') then
    return;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (v_owner, 'في حد مهتم بإعلانك', v_name, '/#/kids/' || p_listing_id);
end;
$$;

revoke execute on function public.express_interest_in_kids_item(uuid) from public, anon;
grant execute on function public.express_interest_in_kids_item(uuid) to authenticated;
