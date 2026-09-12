-- =====================================================================
-- Migration 0023 — real peer-to-peer real estate listings. No table
-- for this existed anywhere in schema.sql (unlike most other verticals
-- this session, which had unused tables sitting there since day one) —
-- real_estate_marketplace_screen.dart was 100% fabricated with two
-- hardcoded ads and every action a no-op. Run after 0002-0022, in
-- order, in the Supabase SQL editor.
--
-- Modeled directly on the already-shipped `marketplace_listings`
-- (public read of active rows, owner manages own, a hide_from_own_
-- building flag) — same trust model, same "peer between real
-- neighbors, no intermediary" framing. One thing done better here:
-- while auditing this, `add_listing_screen.dart` (marketplace) turned
-- out to insert with building_id always null despite having the hide
-- toggle, and the browse screen never filters on it either — that flag
-- has silently done nothing since it shipped. Not fixed here (separate,
-- pre-existing bug, flagged in memory for its own pass) — but this
-- table's client code actually resolves and sets building_id, and the
-- browse screen actually filters on it, so the same flag isn't shipped
-- broken a second time.
-- =====================================================================

create type real_estate_deal_type as enum ('sale', 'rent');

create table public.real_estate_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id),
  building_id uuid references public.buildings(id),
  unit_id uuid references public.units(id),
  deal_type real_estate_deal_type not null,
  title text not null,
  description text,
  price numeric(12,2) not null,
  area_sqm numeric(8,2),
  bedrooms int,
  bathrooms int,
  images text[] default '{}',
  status listing_status not null default 'active',
  hide_from_own_building boolean not null default false,
  created_at timestamptz not null default now()
);

grant select, insert, update on public.real_estate_listings to authenticated;

create policy "real_estate_listings: public read active" on public.real_estate_listings
  for select using (status = 'active');

create policy "real_estate_listings: owner manages own" on public.real_estate_listings
  for all using (auth.uid() = owner_id);

-- ---- express_interest_in_listing(): notify the owner, no in-app chat needed ----

create or replace function public.express_interest_in_listing(p_listing_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_listing record;
  v_requester_name text;
  v_requester_phone text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_listing from public.real_estate_listings where id = p_listing_id;
  if not found then
    raise exception 'الإعلان غير موجود';
  end if;
  if v_listing.owner_id = auth.uid() then
    raise exception 'هذا إعلانك أنت';
  end if;

  select full_name, phone into v_requester_name, v_requester_phone from public.profiles where id = auth.uid();

  insert into public.notifications (user_id, title, body)
  values (
    v_listing.owner_id,
    'جار مهتم بعقارك',
    v_requester_name || ' مهتم بعقارك "' || v_listing.title || '"، تواصل معه على ' || coalesce(v_requester_phone, '(رقم غير متاح)')
  );
end;
$$;

grant execute on function public.express_interest_in_listing(uuid) to authenticated;
