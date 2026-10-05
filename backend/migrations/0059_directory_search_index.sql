-- =====================================================================
-- 0059 — Fast name search in the business directory.
--
-- search_directory() matches '%word%' anywhere in the name, which scanned
-- all ~300k rows and hit the 3s guest statement timeout. A trigram index
-- lets Postgres answer those ILIKE patterns from the index.
-- (Skipped quietly where pg_trgm isn't available, e.g. the test harness.)
-- =====================================================================

do $$
begin
  create extension if not exists pg_trgm with schema extensions;
  execute 'create index if not exists directory_places_name_trgm on public.directory_places using gin (name extensions.gin_trgm_ops)';
exception when others then
  raise notice 'pg_trgm not available, directory name search stays unindexed: %', sqlerrm;
end;
$$;
