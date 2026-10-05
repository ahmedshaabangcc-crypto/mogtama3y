-- Load the cleaned directory (table "clean" in egypt.db, from 2_clean.sql)
-- into Supabase's public.directory_places (migration 0058 must be applied).
-- Run through load.sh, which attaches the database as "pg" using the URL
-- in backend/supabase-db.secret.txt (git-ignored) without printing it.
DELETE FROM pg.public.directory_places WHERE claimed_shop_id IS NULL;
INSERT INTO pg.public.directory_places (id, name, category, kind, phone, whatsapp, website, social, address, lat, lng, confidence, claimed_shop_id, created_at)
SELECT id, name, category, kind, phone, whatsapp, website, social, address, lat, lng, confidence, NULL::UUID, now() FROM clean
ON CONFLICT (id) DO NOTHING;
SELECT count(*) AS loaded FROM pg.public.directory_places;
