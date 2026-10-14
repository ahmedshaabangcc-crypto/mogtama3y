# Business directory (Overture Maps)

~300k places in Egypt from Overture Maps (licences CDLA-Permissive-2.0 /
Apache-2.0 / CC0 — attribution "© Overture Maps Foundation").

Outside Egypt there is no bulk import (owner decision, 0094): the app adds
places from OpenStreetMap when someone opens them, users add shops
(«ضيف محل») and merchants' shops list themselves. The scripts take a
country anyway, for a possible future import of one of the 22 states:

1. `DIR_COUNTRY=EG duckdb eg.db -c ".read 1_extract_overture.sql"` — reads the
   country's slice of the Overture release straight from S3 (bounding box
   from the table inside; update the release date inside) → `places.parquet`.
2. `DIR_COUNTRY=EG duckdb eg.db -c ".read 2_clean.sql"` — drops nameless /
   natural features, maps the categories to Arabic groups, normalises
   WhatsApp numbers of any of the 22 states (01… for Egypt, E.164 elsewhere),
   sets `country`.
3. `./load.sh duckdb eg.db` — replaces that country's Overture rows in
   `public.directory_places` (migrations 0058 + 0094); OSM / user / merchant /
   claimed places are kept. Needs `backend/supabase-db.secret.txt` (git-ignored).

Use one folder / database per country (`places.parquet` and `directory.csv`
are written to the working directory). `DIR_COUNTRY` defaults to EG.
