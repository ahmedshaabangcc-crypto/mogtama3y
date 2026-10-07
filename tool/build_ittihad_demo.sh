#!/usr/bin/env bash
# Local-only DEMO build of the owners'-union app (اتحاد الملاك): no login,
# no backend — every request is answered from an in-memory fake store, and
# the build refuses to run anywhere but localhost. For recording tutorial
# videos. NEVER deploy this folder (the deploy workflow fails if it sees
# the demo marker in a build).
#
#   bash tool/build_ittihad_demo.sh
#   npx -y http-server build/web_ittihad_demo -p 8737 -c-1   (or the
#   `web-ittihad-demo` launch config) → http://localhost:8737/?role=president
set -euo pipefail
cd "$(dirname "$0")/.."

MSYS_NO_PATHCONV=1 flutter build web --release --base-href / \
  --dart-define=APP_FLAVOR=ittihad --dart-define=DEMO=true -o "${OUT:-build/web_ittihad_demo}"

# OUT=… builds into another folder (e.g. while someone records from the live one).
out="${OUT:-build/web_ittihad_demo}"
# Same trim as the deployed union site: the merchant store-lite overlay
# (it reads the real backend for #/s/ links) has no place here.
sed -i '/store-lite.js/d' "$out/index.html"
rm -f "$out/store-lite.js"
sed -i 's|<title>[^<]*</title>|<title>اتحاد الملاك — نسخة تجريبية</title>|' "$out/index.html"
sed -i 's|<div class="name">[^<]*</div>|<div class="name">اتحاد الملاك — تجريبي</div>|' "$out/index.html"

grep -q MOGTAMA3Y_DEMO_BUILD "$out/main.dart.js" || { echo "demo marker missing — not a demo build?" >&2; exit 1; }
echo "Demo build ready in $out — serve it on port 8737 and open http://localhost:8737/?role=president"
