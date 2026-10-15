#!/usr/bin/env bash
# Renders the مُجتمعي mark (tool/brand/mogtama3y_mark.html) with headless
# Chrome into the home-screen icons, favicon, og image and the 1024 logo.
#   bash tool/make_mogtama3y_icons.sh
set -euo pipefail
cd "$(dirname "$0")/.."
CHROME="${CHROME:-/c/Program Files/Google/Chrome/Application/chrome.exe}"
ROOT="$(cygpath -m "$PWD" 2>/dev/null || pwd)"
PAGE="file:///${ROOT// /%20}/tool/brand/mogtama3y_mark.html"
TMPD="${TEMP:-/tmp}/mogtama3y-icons"
mkdir -p "$TMPD"

shot() { # out w h query — a fresh profile per shot (a shared one can be locked)
  local prof="$TMPD/p$RANDOM$RANDOM"
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files \
    --default-background-color=00000000 --window-size="$2,$3" --virtual-time-budget=1500 \
    --user-data-dir="$prof" --screenshot="$1" "$PAGE?$4" 2>/dev/null
  rm -rf "$prof"
  [ -s "$1" ] || { echo "render failed: $1" >&2; exit 1; }
}
scale() { ffmpeg -y -loglevel error -i "$1" -vf "scale=$3:$3:flags=lanczos" "$2"; }

shot "$TMPD/tile.png" 1024 1024 "size=1024&mode=tile"
shot "$TMPD/mask.png" 1024 1024 "size=1024&mode=maskable"
scale "$TMPD/tile.png" web/icons/Icon-512.png 512
scale "$TMPD/tile.png" web/icons/Icon-192.png 192
scale "$TMPD/tile.png" web/favicon.png 64
scale "$TMPD/mask.png" web/icons/Icon-maskable-512.png 512
scale "$TMPD/mask.png" web/icons/Icon-maskable-192.png 192
shot "$ROOT/brand/mogtama3y-logo-1024.png" 1024 1024 "mode=logo"
shot "$TMPD/og.png" 1200 630 "mode=og"
ffmpeg -y -loglevel error -i "$TMPD/og.png" -q:v 3 web/og.jpg
rm -rf "$TMPD"
echo "icons written"
