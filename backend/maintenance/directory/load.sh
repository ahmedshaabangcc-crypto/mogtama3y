#!/usr/bin/env bash
# Usage: ./load.sh path/to/duckdb path/to/egypt.db
# Attaches Supabase (URL from backend/supabase-db.secret.txt, fed on stdin so
# it never shows in the process list or output) and runs 3_load.sql.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
url="$(tr -d '\r\n' < "$here/../../supabase-db.secret.txt")"
{ echo "INSTALL postgres; LOAD postgres;"
  echo "ATTACH '$url' AS pg (TYPE postgres);"
  cat "$here/3_load.sql"; } | "$1" "$2"
