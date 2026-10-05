# Egypt business directory (Overture Maps)

~300k places in Egypt from Overture Maps (licences CDLA-Permissive-2.0 /
Apache-2.0 / CC0 — attribution "© Overture Maps Foundation").

1. `duckdb egypt.db -c ".read 1_extract_overture.sql"` — reads the Egypt slice of
   the Overture release straight from S3 (update the release date inside).
2. `duckdb egypt.db -c ".read 2_clean.sql"` — drops nameless/natural features,
   maps the categories to Arabic groups, normalises WhatsApp numbers.
3. `./load.sh duckdb egypt.db` — loads into `public.directory_places`
   (migration 0058). Needs `backend/supabase-db.secret.txt` (git-ignored).
