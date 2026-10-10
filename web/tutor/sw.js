// «المحفّظ» — cross-origin isolation for the tutor only (scope /tutor/).
//
// Multithreaded speech recognition (onnxruntime-web with threads) needs
// SharedArrayBuffer, i.e. a crossOriginIsolated page: COOP + COEP response
// headers, which GitHub Pages can't send. This worker serves the app's own
// index.html for navigations under /tutor/ with those headers added, so
// /tutor/#/masjid/tools/tutor is the same Flutter app, isolated. Nothing
// outside /tutor/ is controlled by it: Google sign-in popups, YouTube
// embeds etc. elsewhere on the site are untouched. Inside the isolated
// page, leaving the tutor route reloads the normal (non-isolated) app — see
// GUARD below.
//
// COEP is `credentialless` (Chrome/Edge 96+, Firefox 119+): cross-origin
// files load without cookies and need no CORP header; everything the tutor
// uses (jsDelivr, Hugging Face, everyayah, Google Fonts/CanvasKit, Supabase)
// is fetched with CORS anyway. Safari has no `credentialless`; the app
// doesn't send Safari/iOS here (it runs single-threaded there).

// Browsers re-install the worker when this file changes (bump to force it).
// eslint-disable-next-line no-unused-vars
const VERSION = 1;

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil(self.clients.claim()));

const SCOPE = new URL(self.registration.scope);
const ROOT = new URL('../', SCOPE); // the site root (where index.html is)

function isolate(headers) {
  headers.set('Cross-Origin-Opener-Policy', 'same-origin');
  headers.set('Cross-Origin-Embedder-Policy', 'credentialless');
  return headers;
}

// Runs first in the isolated page: marks it, and sends any route other than
// the tutor back to the normal app with a full load.
const GUARD = `<script>
window.mogtama3yTutorIsolated = true;
try { sessionStorage.removeItem('mt.tutor.boot'); localStorage.removeItem('mt.tutor.noiso'); } catch (e) {}
(function () {
  var root = ${JSON.stringify(ROOT.pathname)};
  var gone = false;
  function keep() { return /^#\\/masjid\\/tools\\/tutor(?:[/?]|$)/.test(location.hash); }
  function leave() {
    if (gone || keep()) return;
    gone = true;
    location.replace(root + location.hash);
  }
  ['pushState', 'replaceState'].forEach(function (n) {
    var f = history[n];
    history[n] = function () { var r = f.apply(this, arguments); leave(); return r; };
  });
  addEventListener('popstate', leave);
  addEventListener('hashchange', leave);
})();
</script>`;

async function page() {
  const res = await fetch(new URL('index.html', ROOT), { cache: 'no-cache', credentials: 'same-origin' });
  if (!res.ok) throw new Error('index ' + res.status);
  const html = (await res.text()).replace(/<head[^>]*>/i, (m) => m + GUARD);
  const headers = isolate(new Headers({ 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-cache' }));
  return new Response(html, { status: 200, headers });
}

self.addEventListener('fetch', (event) => {
  const req = event.request;
  const url = new URL(req.url);
  if (url.origin !== self.location.origin) return;
  if (req.mode === 'navigate') {
    if (!url.pathname.startsWith(SCOPE.pathname) || url.pathname.endsWith('.js')) return;
    // A standalone .html page under /tutor/ (e.g. a local benchmark) is
    // served as is, isolated; everything else is the app.
    if (/\.html$/.test(url.pathname) && !/\/index\.html$/.test(url.pathname)) {
      event.respondWith(fetch(req).then((res) => new Response(res.body, { status: res.status, headers: isolate(new Headers(res.headers)) })));
      return;
    }
    event.respondWith(page().catch(() => fetch(req)));
  }
  // Everything else goes to the network untouched.
});
