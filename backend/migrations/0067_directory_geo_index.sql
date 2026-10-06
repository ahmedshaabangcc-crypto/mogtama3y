-- =====================================================================
-- 0067 — Fast "near me" over the whole directory (PostGIS KNN).
--
-- nearby_directory / nearby_services filtered a lat/lng box and then
-- sorted every row in it by computed distance. A 30 km box around Cairo
-- holds ~145k rows, so that sort hit the 3 s statement timeout (500).
--
-- A GiST index on the point *expression* (no new column, no table
-- rewrite — the table is 154 MB of a 500 MB plan) lets
-- `order by <point> <-> me` walk outward from the user and stop after
-- `limit` rows. The functions spell the expression exactly as the index
-- does so the planner can use it.
--
-- Where PostGIS isn't available (the PGlite test harness) this migration
-- leaves the 0058/0064 functions in place, so behaviour there is unchanged.
-- Safe to re-run.
-- =====================================================================

do $$
begin
  create extension if not exists postgis with schema extensions;
exception when others then
  raise notice 'postgis not available, directory keeps the box-scan functions: %', sqlerrm;
end;
$$;

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'postgis') then
    return;
  end if;


  execute $sql$
    create index if not exists directory_places_geog on public.directory_places
      using gist ((extensions.st_setsrid(extensions.st_makepoint(lng, lat), 4326)::extensions.geography))
  $sql$;
  execute $sql$
    create index if not exists directory_places_geog_trade on public.directory_places
      using gist ((extensions.st_setsrid(extensions.st_makepoint(lng, lat), 4326)::extensions.geography))
      where trade is not null
  $sql$;

  -- Same signatures and column lists as 0058 / 0064, so the app needs no change.
  execute $sql$
    create or replace function public.nearby_directory(
      p_lat double precision, p_lng double precision, p_km double precision default 3,
      p_category text default null, p_limit int default 50
    ) returns table (
      id text, name text, category text, phone text, whatsapp text, website text, social text,
      address text, lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
    )
    language sql stable set search_path = public, extensions as $f$
      select d.id, d.name, d.category, d.phone, d.whatsapp, d.website, d.social, d.address, d.lat, d.lng, d.claimed_shop_id,
             extensions.st_distance(
               extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
               extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
             ) / 1000.0 as distance_km
      from public.directory_places d
      where (p_category is null or d.category = p_category)
        and extensions.st_dwithin(
              extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
              extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography,
              least(greatest(coalesce(p_km, 3), 0.2), 30) * 1000)
      order by extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography
           operator(extensions.<->) extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
      limit least(greatest(coalesce(p_limit, 50), 1), 200);
    $f$
  $sql$;

  execute $sql$
    create or replace function public.nearby_services(
      p_lat double precision, p_lng double precision, p_trade text default null,
      p_km double precision default 10, p_limit int default 60
    ) returns table (
      id text, name text, trade text, phone text, whatsapp text, address text,
      lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
    )
    language sql stable set search_path = public, extensions as $f$
      with near as (
        select d.id, d.name, d.trade, d.phone, d.whatsapp, d.address, d.lat, d.lng, d.claimed_shop_id,
               extensions.st_distance(
                 extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
                 extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
               ) / 1000.0 as distance_km
        from public.directory_places d
        where d.trade is not null
          and (p_trade is null or d.trade = p_trade)
          and extensions.st_dwithin(
                extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
                extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography,
                least(greatest(coalesce(p_km, 10), 1), 60) * 1000)
        order by extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography
             operator(extensions.<->) extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
        limit least(greatest(coalesce(p_limit, 60), 1), 150) * 3
      )
      -- WhatsApp-reachable first, within the nearest few hundred.
      select * from near order by (whatsapp is not null) desc, distance_km
      limit least(greatest(coalesce(p_limit, 60), 1), 150);
    $f$
  $sql$;
end;
$$;

-- Grants are unchanged (same signatures), but restate them for clarity.
grant execute on function public.nearby_directory(double precision, double precision, double precision, text, int) to anon, authenticated;
grant execute on function public.nearby_services(double precision, double precision, text, double precision, int) to anon, authenticated;
