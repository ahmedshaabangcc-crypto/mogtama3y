-- Load the cleaned directory (table "clean" from 2_clean.sql, one country)
-- into Supabase's public.directory_places (migrations 0058 + 0094).
-- Run through load.sh, which attaches the database as "pg" using the URL
-- in backend/supabase-db.secret.txt (git-ignored) without printing it.
-- Only that country's Overture rows are replaced: places imported from
-- OpenStreetMap, added by users or by merchants (0094) and claimed ones stay.
DELETE FROM pg.public.directory_places
WHERE claimed_shop_id IS NULL AND source = 'overture' AND country = (SELECT any_value(country) FROM clean);
INSERT INTO pg.public.directory_places (id, name, category, kind, phone, whatsapp, website, social, address, lat, lng, confidence, claimed_shop_id, created_at, country, source)
SELECT id, name, category, kind, phone, whatsapp, website, social, address, lat, lng, confidence, NULL::UUID, now(), country, 'overture' FROM clean
ON CONFLICT (id) DO NOTHING;
SELECT country, count(*) AS loaded FROM pg.public.directory_places GROUP BY 1 ORDER BY 2 DESC;
