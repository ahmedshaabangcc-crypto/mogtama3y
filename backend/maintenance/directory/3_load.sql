-- Load the cleaned directory (2_clean.sql → table "clean" in egypt.db) into
-- Supabase's public.directory_places (migration 0058 must be applied).
-- Run with DuckDB from the folder holding egypt.db:
--   duckdb egypt.db -c ".read 3_load.sql"
-- The Postgres URL is read from backend/supabase-db.secret.txt (git-ignored):
-- Dashboard → Connect → Session pooler URI, with the real password.
INSTALL postgres; LOAD postgres;
SET VARIABLE pg_url = trim(content) FROM read_text('../../supabase-db.secret.txt');
ATTACH getvariable('pg_url') AS pg (TYPE postgres);
DELETE FROM pg.public.directory_places WHERE claimed_shop_id IS NULL;
INSERT INTO pg.public.directory_places (id, name, category, kind, phone, whatsapp, website, social, address, lat, lng, confidence)
SELECT id, name, category, kind, phone, whatsapp, website, social, address, lat, lng, confidence FROM clean
ON CONFLICT (id) DO NOTHING;
SELECT count(*) AS loaded FROM pg.public.directory_places;
