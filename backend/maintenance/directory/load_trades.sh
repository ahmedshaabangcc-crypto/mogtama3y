#!/usr/bin/env bash
# Usage: ./load_trades.sh path/to/duckdb path/to/egypt.db  (run from the folder with egypt_places.parquet)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
url="$(tr -d '\r\n' < "$here/../../supabase-db.secret.txt")"
{ echo "INSTALL postgres; LOAD postgres;"
  echo "ATTACH '$url' AS pg (TYPE postgres);"
  cat "$here/4_trades.sql"; } | "$1" "$2"
