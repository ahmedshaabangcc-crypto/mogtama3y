-- =====================================================================
-- 0071 — Pets ("الحيوانات الأليفة").
--
-- Listings for pets for sale, free adoption, mating, lost pets, found
-- pets, and pet supplies (new or used). Guests browse the active
-- listings; signed-in users post and manage their own.
--
-- Access:
--   * public (anon + authenticated) read of ACTIVE rows; owners also see
--     their own inactive rows (for "إعلاناتي");
--   * the contact phone is NOT readable through the table (column grants
--     leave it out, so the list can't be scraped for numbers): a signed-in
--     user gets it per listing through pet_listing_phone();
--   * owners insert/update/delete only their own rows (owner_id = auth.uid());
--   * a super admin can moderate (edit / hide / delete) any listing;
--   * express_interest_in_pet() tells the owner "أنا مهتم" (or, on a lost
--     pet, "عندي معلومة") through a notification.
-- =====================================================================

create table if not exists public.pet_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  kind text not null check (kind in ('sale', 'adoption', 'mating', 'lost', 'found', 'supplies')),
  animal text not null default 'cat' check (animal in ('cat', 'dog', 'bird', 'fish', 'rabbit', 'turtle', 'hamster', 'other')),
  breed text check (breed is null or length(breed) <= 80),
  age_text text check (age_text is null or length(age_text) <= 40),
  gender text not null default 'unknown' check (gender in ('male', 'female', 'unknown')),
  vaccinated boolean not null default false,
  -- Supplies only: new or used.
  condition text check (condition in ('new', 'used')),
  title text not null check (length(trim(title)) between 3 and 120),
  description text check (description is null or length(description) <= 3000),
  price numeric(12,2) check (price is null or price >= 0),
  negotiable boolean not null default false,
  governorate text,
  area text check (area is null or length(area) <= 80),
  -- Lost / found only: when and where the pet was last seen.
  last_seen_date date,
  last_seen_area text check (last_seen_area is null or length(last_seen_area) <= 120),
  phone text not null check (phone ~ '^01[0125][0-9]{8}$'),
  has_whatsapp boolean not null default true,
  images text[] not null default '{}' check (cardinality(images) <= 10),
  is_active boolean not null default true,
  -- Quick close from "إعلاناتي": the lost pet was found, the adoption
  -- pet found a home, or the item / pet was sold.
  outcome text check (outcome in ('reunited', 'adopted', 'sold')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- Adoption, lost and found are never paid: no price (or 0).
  constraint pet_listings_free_kinds check (
    kind not in ('adoption', 'lost', 'found') or coalesce(price, 0) = 0),
  -- A sale or supplies listing needs a real price.
  constraint pet_listings_price_required check (
    kind not in ('sale', 'supplies') or coalesce(price, 0) > 0),
  -- A lost / found report needs the day the pet was last seen (not ahead).
  constraint pet_listings_last_seen check (
    kind not in ('lost', 'found')
    or (last_seen_date is not null and last_seen_date <= current_date + 1))
);

create index if not exists pet_listings_browse
  on public.pet_listings (kind, animal, created_at desc) where is_active;
create index if not exists pet_listings_created
  on public.pet_listings (created_at desc) where is_active;
create index if not exists pet_listings_owner
  on public.pet_listings (owner_id, created_at desc);

alter table public.pet_listings enable row level security;
revoke all on public.pet_listings from anon, authenticated;
-- Every column except phone (see pet_listing_phone below).
grant select (id, owner_id, kind, animal, breed, age_text, gender, vaccinated, condition, title,
              description, price, negotiable, governorate, area, last_seen_date, last_seen_area,
              has_whatsapp, images, is_active, outcome, created_at, updated_at)
  on public.pet_listings to anon, authenticated;
grant insert, update, delete on public.pet_listings to authenticated;

drop policy if exists "pet_listings: public reads active" on public.pet_listings;
create policy "pet_listings: public reads active" on public.pet_listings
  for select to anon, authenticated using (is_active);

drop policy if exists "pet_listings: owner reads own" on public.pet_listings;
create policy "pet_listings: owner reads own" on public.pet_listings
  for select to authenticated using (owner_id = auth.uid());

drop policy if exists "pet_listings: owner inserts" on public.pet_listings;
create policy "pet_listings: owner inserts" on public.pet_listings
  for insert to authenticated with check (owner_id = auth.uid());

drop policy if exists "pet_listings: owner updates" on public.pet_listings;
create policy "pet_listings: owner updates" on public.pet_listings
  for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "pet_listings: owner deletes" on public.pet_listings;
create policy "pet_listings: owner deletes" on public.pet_listings
  for delete to authenticated using (owner_id = auth.uid());

drop policy if exists "pet_listings: super_admin manages all" on public.pet_listings;
create policy "pet_listings: super_admin manages all" on public.pet_listings
  for all to authenticated using (public.is_super_admin()) with check (public.is_super_admin());

-- Keep updated_at fresh; closing with an outcome also takes it off the list.
create or replace function public.pet_listing_touch() returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  if new.outcome is not null then
    new.is_active := false;
  end if;
  return new;
end;
$$;

drop trigger if exists pet_listing_touch on public.pet_listings;
create trigger pet_listing_touch
  before insert or update on public.pet_listings
  for each row execute function public.pet_listing_touch();

-- ---------------------------------------------------------------- phone
-- The poster's phone for one listing: signed-in users only, active
-- listings only (the owner and a super admin always).
create or replace function public.pet_listing_phone(p_listing_id uuid) returns text
language sql stable security definer set search_path = public as $$
  select l.phone from public.pet_listings l
  where l.id = p_listing_id
    and auth.uid() is not null
    and (l.is_active or l.owner_id = auth.uid() or public.is_super_admin());
$$;

revoke execute on function public.pet_listing_phone(uuid) from public, anon;
grant execute on function public.pet_listing_phone(uuid) to authenticated;

-- ---------------------------------------------------------------- interest
-- "أنا مهتم" / "عندي معلومة": notify the owner with the user's name.
create or replace function public.express_interest_in_pet(p_listing_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_owner uuid;
  v_title text;
  v_kind text;
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select owner_id, title, kind into v_owner, v_title, v_kind
  from public.pet_listings where id = p_listing_id and is_active;
  if v_owner is null then raise exception 'الإعلان مش موجود'; end if;
  if v_owner = auth.uid() then raise exception 'ده إعلانك'; end if;
  select coalesce(nullif(trim(full_name), ''), 'حد') into v_name from public.profiles where id = auth.uid();
  v_name := coalesce(v_name, 'حد') || case v_kind
    when 'lost' then ' عنده معلومة عن «' || v_title || '»'
    when 'found' then ' بيقول إن «' || v_title || '» بتاعه'
    else ' مهتم بـ «' || v_title || '»'
  end;
  -- Tapping twice in a row doesn't spam the owner.
  if exists (select 1 from public.notifications
             where user_id = v_owner and deep_link = '/#/pets/' || p_listing_id
               and body = v_name and created_at > now() - interval '1 day') then
    return;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (v_owner,
          case when v_kind in ('lost', 'found') then 'في حد اتواصل بخصوص إعلانك' else 'في حد مهتم بإعلانك' end,
          v_name, '/#/pets/' || p_listing_id);
end;
$$;

revoke execute on function public.express_interest_in_pet(uuid) from public, anon;
grant execute on function public.express_interest_in_pet(uuid) to authenticated;
