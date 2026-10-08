#!/usr/bin/env bash
# Local-only DEMO build of the merchant app (متجري, APP_FLAVOR=tajer): no
# login, no backend — every request is answered from an in-memory fake
# store (the fictional «محل بيت الشاي — تجريبي»), WhatsApp / Google Maps /
# Gemini are never called, and the build refuses to run anywhere but
# localhost. For recording tutorial videos. NEVER deploy this folder (the
# deploy workflow fails if it sees the demo marker in a build).
#
#   bash tool/build_tajer_demo.sh
#   npx -y http-server build/web_tajer_demo -p 8739 -c-1   (or the
#   `web-tajer-demo` launch config) → http://localhost:8739/?role=merchant
#   roles: merchant | new | customer   (&panel=0 hides the role switcher)
set -euo pipefail
cd "$(dirname "$0")/.."

# OUT=… builds into another folder (e.g. while someone records from the live one).
out="${OUT:-build/web_tajer_demo}"

MSYS_NO_PATHCONV=1 flutter build web --release --base-href / \
  --dart-define=APP_FLAVOR=tajer --dart-define=DEMO=true -o "$out"

f="$out/index.html"
# The instant store page (store-lite.js) reads the real backend for #/s/
# links — it has no place in a local demo.
sed -i '/store-lite.js/d' "$f"
rm -f "$out/store-lite.js"
# The HTML landing / ?home=1 page is the merchant one on localhost too.
sed -i "s|^\( *\)var flavor = .*$|\1var flavor = 'tajer';|" "$f"
# Same look as the deployed tajer site (deploy.yml), plus a demo title.
sed -i 's|<title>[^<]*</title>|<title>متجري — نسخة تجريبية</title>|' "$f"
sed -i 's|<div class="name">[^<]*</div>|<div class="name">متجري — تجريبي</div>|' "$f"
sed -i -E 's#(<meta (name="(description|twitter:description)"|property="og:description") content=")[^"]*#\1متجر باسم محلك، ومنتجاتك بالصور والأسعار، والطلبات توصلك على واتساب — ببلاش ومن غير عمولة.#; s#(<meta (name="twitter:title"|property="og:title") content=")[^"]*#\1متجري — نسخة تجريبية#; s#(<meta name="apple-mobile-web-app-title" content=")[^"]*#\1متجري#' "$f"
sed -i 's|"name": *"[^"]*"|"name": "متجري — تجريبي"|; s|"short_name": *"[^"]*"|"short_name": "متجري"|; s|"description": *"[^"]*"|"description": "لوحة التاجر: متجرك أونلاين، منتجاتك وطلباتك."|' "$out/manifest.json"
cp "$out/tajer_icons/favicon.png" "$out/favicon.png"
cp "$out"/tajer_icons/Icon-*.png "$out/icons/"

grep -q MOGTAMA3Y_DEMO_BUILD "$out/main.dart.js" || { echo "demo marker missing — not a demo build?" >&2; exit 1; }
grep -q "var flavor = 'tajer';" "$f" || { echo "index.html flavor patch failed" >&2; exit 1; }
if grep -q "store-lite" "$f"; then echo "store-lite.js still referenced" >&2; exit 1; fi
echo "Demo build ready in $out — serve it on port 8739 and open http://localhost:8739/?role=merchant"
