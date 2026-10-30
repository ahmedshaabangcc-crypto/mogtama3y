-- =====================================================================
-- Migration 0104 — fast «nearby, same category» in the directory.
--
-- Supabase warned (2026-10-30) the project is depleting its Disk IO
-- budget. pg_stat_statements: nearby_directory() ran ~529k times (mostly
-- the dalil server's place pages, crawled by Google: «أماكن قريبة» of the
-- same category, 1.5 km) and touched ~890M blocks. With a category the
-- planner can't use the KNN index: it bitmap-ANDs every place in the
-- radius with the whole category, then sorts (~400 ms, 330+ blocks per
-- call; 2 400 blocks at 10 km). Without a category the same call takes
-- 1–4 ms on the KNN index. Measured after: 9 ms, 214 blocks.
--
-- A GiST index on (category, location) — btree_gist gives GiST the text
-- equality — lets KNN walk only that category's nearest places. Skipped
-- where PostGIS / btree_gist aren't available (the local test database).
-- Run after 0103. Safe to re-run.
-- =====================================================================

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'postgis')
     or not exists (select 1 from pg_available_extensions where name = 'btree_gist') then
    return;
  end if;
  execute 'create extension if not exists btree_gist with schema extensions';
  execute $sql$
    create index if not exists directory_places_cat_geog on public.directory_places
      using gist (category, ((extensions.st_setsrid(extensions.st_makepoint(lng, lat), 4326))::extensions.geography))
      where not hidden
  $sql$;
  execute 'analyze public.directory_places';
end;
$$;
