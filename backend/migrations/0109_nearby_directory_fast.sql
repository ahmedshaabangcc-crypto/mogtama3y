-- 0109 — nearby_directory: one query per case instead of
-- «(p_category is null or d.category = p_category)».
--
-- The OR kept the generic plan off directory_places_cat_geog (category +
-- geography), so a city × category hub of the dalil server (10 km, 200 rows)
-- walked ~9 500 buffers (~0.9 s warm) and, read from disk, ran past the
-- anon role's 3 s statement_timeout: 1 098 «supabase 500» hub pages in the
-- week to 2026-11-06. Split in plpgsql, the category case uses that index
-- (~850 buffers, ~0.14 s). Same signature, columns, order and grants.
-- Production only (PostGIS); the test harness keeps its box scan.

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'postgis') then
    return;
  end if;

  execute $sql$
    create or replace function public.nearby_directory(
      p_lat double precision, p_lng double precision, p_km double precision default 3,
      p_category text default null, p_limit int default 50
    ) returns table (
      id text, name text, category text, phone text, whatsapp text, website text, social text,
      address text, lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
    )
    language plpgsql stable set search_path = public, extensions as $f$
    declare
      here extensions.geography := extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography;
      radius double precision := least(greatest(coalesce(p_km, 3), 0.2), 30) * 1000;
      n int := least(greatest(coalesce(p_limit, 50), 1), 200);
    begin
      if p_category is null then
        return query
          select d.id, d.name, d.category, d.phone, d.whatsapp, d.website, d.social, d.address, d.lat, d.lng, d.claimed_shop_id,
                 extensions.st_distance(extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography, here) / 1000.0
          from public.directory_places d
          where not d.hidden
            and extensions.st_dwithin(extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography, here, radius)
          order by extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography operator(extensions.<->) here
          limit n;
      else
        return query
          select d.id, d.name, d.category, d.phone, d.whatsapp, d.website, d.social, d.address, d.lat, d.lng, d.claimed_shop_id,
                 extensions.st_distance(extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography, here) / 1000.0
          from public.directory_places d
          where d.category = p_category
            and not d.hidden
            and extensions.st_dwithin(extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography, here, radius)
          order by extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography operator(extensions.<->) here
          limit n;
      end if;
    end;
    $f$
  $sql$;
end;
$$;

grant execute on function public.nearby_directory(double precision, double precision, double precision, text, int) to anon, authenticated;
