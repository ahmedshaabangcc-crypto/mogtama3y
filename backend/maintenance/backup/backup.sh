#!/bin/sh
# Nightly backup of the مُجتمعي Supabase database (Supabase's free plan has
# no downloadable backups). Runs on the VPS from root's crontab:
#   0 1 * * * /docker/mogtama3y-backup/backup.sh
#
# * A throwaway postgres:17 container runs pg_dump (custom format,
#   compressed) — capped at 256 MB RAM / half a CPU so nothing else on the
#   server notices.
# * Schemas: public (all app data), auth (accounts), storage (file index;
#   the photos themselves stay in Supabase Storage).
# * Keeps the last 14 nights in /docker/mogtama3y-backup/dumps.
# * The connection string lives in db.env (chmod 600, never in git).
#
# Restore (into an empty database):
#   pg_restore --no-owner --no-privileges -d "$TARGET_URL" mogtama3y-YYYY-MM-DD.dump
set -eu
DIR=/docker/mogtama3y-backup
DAY=$(date -u +%F)
OUT="mogtama3y-$DAY.dump"

docker run --rm --memory 256m --cpus 0.5 --env-file "$DIR/db.env" -v "$DIR/dumps:/dumps" postgres:17-alpine \
  sh -c "pg_dump \"\$PGURL\" --format=custom --compress=6 --no-owner --no-privileges \
           --schema=public --schema=auth --schema=storage --file=/dumps/$OUT.part \
         && mv /dumps/$OUT.part /dumps/$OUT"

find "$DIR/dumps" -name 'mogtama3y-*.dump' -mtime +14 -delete
find "$DIR/dumps" -name '*.part' -mtime +1 -delete
echo "$(date -u +%FT%TZ) ok $OUT $(du -h "$DIR/dumps/$OUT" | cut -f1)" >> "$DIR/backup.log"
