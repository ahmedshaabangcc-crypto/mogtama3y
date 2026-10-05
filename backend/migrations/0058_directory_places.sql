-- =====================================================================
-- 0058 — Egypt business directory (Overture Maps places).
--
-- ~300k shops, restaurants, pharmacies, clinics… across Egypt, imported
-- from Overture Maps (CDLA-Permissive-2.0 / Apache-2.0 / CC0 — storing and
-- commercial use allowed with attribution "© Overture Maps Foundation").
-- Loaded by backend/maintenance/load_directory.sql, not by the app.
--
-- Public read (business listings), no writes from the app. A place an
-- owner claims gets claimed_shop_id → the real shops row they manage.
-- Plain lat/lng + btree (no PostGIS): a bounding-box filter is plenty for
-- "near me" at this size.
-- =====================================================================

create table if not exists public.directory_places (
  id text primary key,                 -- Overture place id
  name text not null,
  category text not null,              -- Arabic group, e.g. 'صيدليات'
  kind text,                           -- Overture basic_category
  phone text,                          -- as published, e.g. +2012…
  whatsapp text,                       -- Egyptian mobile 01xxxxxxxxx, when the phone is one
  website text,
  social text,
  address text,
  lat double precision not null,
  lng double precision not null,
  confidence real,
  claimed_shop_id uuid references public.shops(id) on delete set null,
  created_at timestamptz not null default now()
);

create index if not exists directory_places_lat_lng on public.directory_places (lat, lng);
create index if not exists directory_places_category on public.directory_places (category);

alter table public.directory_places enable row level security;
drop policy if exists "directory_places: public read" on public.directory_places;
create policy "directory_places: public read" on public.directory_places for select using (true);
revoke all on public.directory_places from anon, authenticated;
grant select on public.directory_places to anon, authenticated;

-- Places around a point, nearest first. p_km is the box half-size.
create or replace function public.nearby_directory(
  p_lat double precision,
  p_lng double precision,
  p_km double precision default 3,
  p_category text default null,
  p_limit int default 50
) returns table (
  id text, name text, category text, phone text, whatsapp text, website text, social text,
  address text, lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  with box as (
    select least(greatest(coalesce(p_km, 3), 0.2), 30) / 111.0 as dlat,
           least(greatest(coalesce(p_km, 3), 0.2), 30) / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng
  )
  select d.id, d.name, d.category, d.phone, d.whatsapp, d.website, d.social, d.address, d.lat, d.lng, d.claimed_shop_id,
         111.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) as distance_km
  from public.directory_places d, box
  where d.lat between p_lat - box.dlat and p_lat + box.dlat
    and d.lng between p_lng - box.dlng and p_lng + box.dlng
    and (p_category is null or d.category = p_category)
  order by distance_km, d.confidence desc nulls last
  limit least(greatest(coalesce(p_limit, 50), 1), 200);
$$;

-- Name search, optionally ranked by distance from a point.
create or replace function public.search_directory(
  p_query text,
  p_lat double precision default null,
  p_lng double precision default null,
  p_limit int default 30
) returns table (
  id text, name text, category text, phone text, whatsapp text, address text,
  lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  select d.id, d.name, d.category, d.phone, d.whatsapp, d.address, d.lat, d.lng, d.claimed_shop_id,
         case when p_lat is null or p_lng is null then null
              else 111.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) end as distance_km
  from public.directory_places d
  where length(trim(coalesce(p_query, ''))) >= 2
    and d.name ilike '%' || replace(replace(trim(p_query), '%', ''), '_', '') || '%'
  order by distance_km nulls last, d.confidence desc nulls last
  limit least(greatest(coalesce(p_limit, 30), 1), 100);
$$;

grant execute on function public.nearby_directory(double precision, double precision, double precision, text, int) to anon, authenticated;
grant execute on function public.search_directory(text, double precision, double precision, int) to anon, authenticated;
