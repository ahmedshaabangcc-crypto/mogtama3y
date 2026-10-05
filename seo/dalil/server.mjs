// دليل مُجتمعي — dalil.mogtama3y.com
//
// Plain server-rendered HTML pages for the Egypt business directory
// (public.directory_places, ~300k places from Overture Maps) so search
// engines can index them: one page per place, category × city hubs, and
// sitemaps. Every page links into the app (mogtama3y.com/#/d/<id>) where
// the visitor can order. Reads only public data through Supabase's REST
// API with the publishable key — no secrets on this server.
//
// No dependencies: node server.mjs (Node 20+). Env: SUPABASE_URL,
// SUPABASE_KEY, PORT (default 8080), SITE (default https://dalil.mogtama3y.com).

import http from 'node:http';

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://pxiabifybakbsqlycffc.supabase.co';
const SUPABASE_KEY = process.env.SUPABASE_KEY || '';
const SITE = (process.env.SITE || 'https://dalil.mogtama3y.com').replace(/\/$/, '');
const APP = 'https://mogtama3y.com';
const TAJER = 'https://tajer.mogtama3y.com';
const PORT = Number(process.env.PORT || 8080);

const CATEGORIES = [
  'سوبر ماركت وبقالة', 'صيدليات', 'مطاعم', 'كافيهات', 'حلويات ومخبوزات', 'صحة وعيادات', 'ملابس وأزياء',
  'إلكترونيات وموبايلات', 'أدوات منزلية وأثاث', 'تجميل وعناية', 'صيانة وخدمات منزلية', 'سيارات',
  'هدايا ومكتبات', 'رياضة', 'تعليم', 'عقارات', 'سفر وفنادق', 'مناسبات وتصوير', 'خدمات وشركات',
  'مصانع وموردين', 'بنوك وصرافات', 'محلات متنوعة',
];

// City centres used for hub pages and to name the area of a place.
const CITIES = [
  ['القاهرة', 30.0444, 31.2357], ['الجيزة', 30.0131, 31.2089], ['الإسكندرية', 31.2001, 29.9187],
  ['مدينة نصر', 30.0566, 31.3301], ['مصر الجديدة', 30.091, 31.322], ['المعادي', 29.9602, 31.2569],
  ['التجمع الخامس', 30.0074, 31.4913], ['الشيخ زايد', 30.0383, 30.984], ['6 أكتوبر', 29.9285, 30.9188],
  ['شبرا الخيمة', 30.1286, 31.2422], ['حلوان', 29.8414, 31.3008], ['العاشر من رمضان', 30.2964, 31.7433],
  ['المنصورة', 31.0409, 31.3785], ['طنطا', 30.7865, 31.0004], ['المحلة الكبرى', 30.9697, 31.1681],
  ['الزقازيق', 30.5877, 31.502], ['بنها', 30.4659, 31.1848], ['شبين الكوم', 30.5536, 31.0094],
  ['دمنهور', 31.0341, 30.4682], ['كفر الشيخ', 31.1107, 30.9388], ['دمياط', 31.4165, 31.8133],
  ['بورسعيد', 31.2653, 32.3019], ['الإسماعيلية', 30.5965, 32.2715], ['السويس', 29.9668, 32.5498],
  ['الفيوم', 29.3084, 30.8428], ['بني سويف', 29.0661, 31.0994], ['المنيا', 28.1099, 30.7503],
  ['أسيوط', 27.1809, 31.1837], ['سوهاج', 26.5591, 31.6957], ['قنا', 26.1551, 32.716],
  ['الأقصر', 25.6872, 32.6396], ['أسوان', 24.0889, 32.8998], ['الغردقة', 27.2579, 33.8116],
  ['شرم الشيخ', 27.9158, 34.33], ['مرسى مطروح', 31.3543, 27.2373], ['العريش', 31.1316, 33.7984],
];

// ---------------------------------------------------------------- helpers

const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const slug = (s) => String(s).trim().replace(/\s+/g, '-');
const unslug = (s) => decodeURIComponent(s).replace(/-/g, ' ');

function cityOf(lat, lng) {
  let best = null;
  let bestKm = 25;
  for (const [name, la, ln] of CITIES) {
    const km = 111 * Math.hypot(lat - la, (lng - ln) * Math.cos((la * Math.PI) / 180));
    if (km < bestKm) [best, bestKm] = [name, km];
  }
  return best;
}

async function rest(path, init = {}) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    ...init,
    headers: { apikey: SUPABASE_KEY, 'Content-Type': 'application/json', ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`supabase ${res.status}`);
  return res.json();
}
const rpc = (fn, params) => rest(`rpc/${fn}`, { method: 'POST', body: JSON.stringify(params) });

// Small LRU-ish cache for rendered pages.
const cache = new Map();
function cached(key, ttlMs, make) {
  const hit = cache.get(key);
  if (hit && hit.until > Date.now()) return hit.value;
  const value = make();
  cache.set(key, { until: Date.now() + ttlMs, value });
  if (cache.size > 20000) cache.delete(cache.keys().next().value);
  value.catch(() => cache.delete(key));
  return value;
}

// ---------------------------------------------------------------- layout

function page({ title, description, canonical, body, jsonLd }) {
  return `<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
<link rel="canonical" href="${esc(canonical)}">
<meta property="og:title" content="${esc(title)}">
<meta property="og:description" content="${esc(description)}">
<meta property="og:url" content="${esc(canonical)}">
<meta property="og:site_name" content="دليل مُجتمعي">
<meta property="og:locale" content="ar_EG">
<link rel="icon" href="${APP}/favicon.png">
${jsonLd ? `<script type="application/ld+json">${JSON.stringify(jsonLd).replace(/</g, '\\u003c')}</script>` : ''}
<style>
:root{--night:#0B1530;--mid:#16264d;--gold:#F2B661;--ink:#1d2433;--muted:#6b7280;--line:#e5e7eb;--bg:#f6f7fb}
*{box-sizing:border-box}body{margin:0;font-family:system-ui,-apple-system,"Segoe UI",Tahoma,sans-serif;background:var(--bg);color:var(--ink);line-height:1.7}
a{color:inherit}header{background:linear-gradient(135deg,#243F7A,var(--night));color:#fff;padding:14px 16px}
header .in,main{max-width:860px;margin:0 auto}header a{text-decoration:none;font-weight:800;font-size:18px}header span{color:var(--gold)}
main{padding:16px}h1{font-size:24px;margin:8px 0 4px;line-height:1.4}.muted{color:var(--muted)}
.card{background:#fff;border:1px solid var(--line);border-radius:16px;padding:16px;margin:12px 0}
.btn{display:inline-block;padding:12px 18px;border-radius:999px;text-decoration:none;font-weight:800;margin:4px 0 4px 8px}
.btn.wa{background:#1FA855;color:#fff}.btn.gold{background:var(--gold);color:var(--night)}.btn.line{border:1px solid var(--line);background:#fff}
ul.list{list-style:none;padding:0;margin:0}ul.list li{border-bottom:1px solid var(--line);padding:10px 2px}ul.list li:last-child{border:0}
ul.list a{text-decoration:none;font-weight:700}.chips a{display:inline-block;margin:4px 0 4px 6px;padding:6px 12px;border:1px solid var(--line);border-radius:999px;background:#fff;text-decoration:none;font-size:14px}
form{display:flex;gap:8px}input{flex:1;padding:12px;border:1px solid var(--line);border-radius:12px;font-size:16px}button{padding:12px 16px;border:0;border-radius:12px;background:var(--night);color:#fff;font-weight:800}
footer{max-width:860px;margin:24px auto;padding:0 16px 32px;color:var(--muted);font-size:13px}
</style>
</head>
<body>
<header><div class="in"><a href="${SITE}/">دليل <span>مُجتمعي</span></a> <small style="opacity:.75">— كل محلات مصر، واطلب منها أونلاين</small></div></header>
<main>${body}</main>
<footer>
<p><a href="${APP}">مُجتمعي</a> — كل حيّك في تطبيق واحد. عندك محل؟ <a href="${TAJER}">افتح متجرك أونلاين ببلاش</a>.</p>
<p>بيانات الأماكن: © Overture Maps Foundation (CDLA-Permissive-2.0). تصميم وتنفيذ <a href="https://getapex.tech">Get Apex</a>.</p>
</footer>
</body>
</html>`;
}

const searchForm = (q = '') =>
  `<form action="${SITE}/search" method="get"><input name="q" value="${esc(q)}" placeholder="دوّر على محل، صيدلية، مطعم…" aria-label="بحث"><button>بحث</button></form>`;

function placeItem(p) {
  const city = cityOf(p.lat, p.lng);
  return `<li><a href="${SITE}/p/${esc(p.id)}">${esc(p.name)}</a><br><span class="muted">${esc(p.category)}${city ? ' — ' + esc(city) : ''}${p.distance_km != null && p.distance_km < 50 ? ' · ' + (p.distance_km < 1 ? Math.round(p.distance_km * 1000) + ' م' : p.distance_km.toFixed(1) + ' كم') : ''}</span></li>`;
}

// ---------------------------------------------------------------- pages

async function homePage() {
  const cities = CITIES.map(([c]) => `<a href="${SITE}/city/${encodeURIComponent(slug(c))}">${esc(c)}</a>`).join('');
  const cats = CATEGORIES.map((c) => `<a href="${SITE}/c/${encodeURIComponent(slug(c))}/${encodeURIComponent(slug('القاهرة'))}">${esc(c)}</a>`).join('');
  return page({
    title: 'دليل مُجتمعي — محلات وصيدليات ومطاعم مصر وأرقامها',
    description: 'دليل محلات مصر: سوبر ماركت وصيدليات ومطاعم وعيادات ومحلات ملابس وموبايلات في كل مدينة، بالعنوان والتليفون، واطلب منها أونلاين على مُجتمعي.',
    canonical: `${SITE}/`,
    body: `<h1>كل محلات مصر في مكان واحد</h1><p class="muted">ابحث عن أي محل أو صيدلية أو مطعم، واعرف عنوانه ورقمه، واطلب منه على واتساب.</p>
<div class="card">${searchForm()}</div>
<div class="card"><h2>المدن</h2><div class="chips">${cities}</div></div>
<div class="card"><h2>الأنشطة في القاهرة</h2><div class="chips">${cats}</div></div>`,
  });
}

async function placePage(id) {
  const rows = await rest(`directory_places?id=eq.${encodeURIComponent(id)}&select=*`);
  const p = rows[0];
  if (!p) return null;
  const city = cityOf(p.lat, p.lng);
  const near = await rpc('nearby_directory', { p_lat: p.lat, p_lng: p.lng, p_km: 1.5, p_category: p.category, p_limit: 11 }).catch(() => []);
  const where = city ? ` في ${city}` : '';
  const title = `${p.name} — ${p.category}${where} | دليل مُجتمعي`;
  const description = `${p.name}: ${p.category}${where}${p.address ? '، ' + p.address : ''}. العنوان على الخريطة${p.phone ? ' ورقم التليفون' : ''}، واطلب منه أونلاين على مُجتمعي.`;
  const order = `${APP}/#/d/${encodeURIComponent(p.id)}`;
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'LocalBusiness',
    name: p.name,
    url: `${SITE}/p/${p.id}`,
    ...(p.phone ? { telephone: p.phone } : {}),
    geo: { '@type': 'GeoCoordinates', latitude: p.lat, longitude: p.lng },
    address: { '@type': 'PostalAddress', addressCountry: 'EG', ...(city ? { addressLocality: city } : {}), ...(p.address ? { streetAddress: p.address } : {}) },
  };
  const others = near.filter((x) => x.id !== p.id).slice(0, 10);
  return page({
    title,
    description,
    canonical: `${SITE}/p/${p.id}`,
    jsonLd,
    body: `<p class="muted"><a href="${SITE}/">الدليل</a>${city ? ` › <a href="${SITE}/c/${encodeURIComponent(slug(p.category))}/${encodeURIComponent(slug(city))}">${esc(p.category)} في ${esc(city)}</a>` : ''}</p>
<div class="card">
<h1>${esc(p.name)}</h1>
<p class="muted">${esc(p.category)}${esc(where)}</p>
${p.address ? `<p>📍 ${esc(p.address)}</p>` : ''}
${p.phone ? `<p>📞 <a href="tel:${esc(p.phone.replace(/\s/g, ''))}" dir="ltr">${esc(p.phone)}</a></p>` : ''}
<p>
<a class="btn wa" href="${order}">اطلب منه على مُجتمعي</a>
<a class="btn line" href="https://www.google.com/maps/dir/?api=1&destination=${p.lat},${p.lng}" rel="nofollow">الاتجاهات</a>
</p>
<p class="muted" style="font-size:13px">ده محلك؟ <a href="${TAJER}">افتح متجرك واستقبل الطلبات أونلاين ببلاش</a>.</p>
</div>
${others.length ? `<div class="card"><h2>${esc(p.category)} قريبة</h2><ul class="list">${others.map(placeItem).join('')}</ul></div>` : ''}`,
  });
}

async function hubPage(category, city) {
  const c = CITIES.find(([n]) => n === city);
  if (!c || !CATEGORIES.includes(category)) return null;
  const places = await rpc('nearby_directory', { p_lat: c[1], p_lng: c[2], p_km: 10, p_category: category, p_limit: 200 });
  const otherCats = CATEGORIES.filter((x) => x !== category).map((x) => `<a href="${SITE}/c/${encodeURIComponent(slug(x))}/${encodeURIComponent(slug(city))}">${esc(x)}</a>`).join('');
  return page({
    title: `${category} في ${city} — العناوين والتليفونات | دليل مُجتمعي`,
    description: `${places.length} من ${category} في ${city} بالعنوان على الخريطة ورقم التليفون، واطلب أونلاين على مُجتمعي.`,
    canonical: `${SITE}/c/${slug(category)}/${slug(city)}`,
    body: `<p class="muted"><a href="${SITE}/">الدليل</a> › <a href="${SITE}/city/${encodeURIComponent(slug(city))}">${esc(city)}</a></p>
<h1>${esc(category)} في ${esc(city)}</h1>
<div class="card"><ul class="list">${places.map(placeItem).join('') || '<li class="muted">مفيش أماكن متسجلة هنا لسه.</li>'}</ul></div>
<div class="card"><h2>أنشطة تانية في ${esc(city)}</h2><div class="chips">${otherCats}</div></div>`,
  });
}

async function cityPage(city) {
  if (!CITIES.some(([n]) => n === city)) return null;
  const cats = CATEGORIES.map((x) => `<a href="${SITE}/c/${encodeURIComponent(slug(x))}/${encodeURIComponent(slug(city))}">${esc(x)}</a>`).join('');
  return page({
    title: `محلات ${city} — صيدليات ومطاعم وسوبر ماركت | دليل مُجتمعي`,
    description: `دليل محلات ${city}: صيدليات ومطاعم وسوبر ماركت وعيادات ومحلات بالعنوان والتليفون.`,
    canonical: `${SITE}/city/${slug(city)}`,
    body: `<p class="muted"><a href="${SITE}/">الدليل</a></p><h1>محلات ${esc(city)}</h1><div class="card"><div class="chips">${cats}</div></div>`,
  });
}

async function searchPage(q) {
  const results = q.trim().length >= 2 ? await rpc('search_directory', { p_query: q, p_limit: 60 }) : [];
  return page({
    title: `${q ? q + ' — ' : ''}بحث في دليل مُجتمعي`,
    description: 'ابحث عن أي محل في مصر.',
    canonical: `${SITE}/search`,
    body: `<div class="card">${searchForm(q)}</div><div class="card"><ul class="list">${results.map(placeItem).join('') || '<li class="muted">اكتب اسم المحل.</li>'}</ul></div>`,
  });
}

// ---------------------------------------------------------------- sitemaps

const PER_SITEMAP = 40000;
let ids = { list: [], until: 0, loading: null };

async function loadIds() {
  const list = [];
  let last = '';
  for (;;) {
    const page = await rest(`directory_places?select=id&order=id.asc&limit=1000${last ? `&id=gt.${encodeURIComponent(last)}` : ''}`);
    for (const r of page) list.push(r.id);
    if (page.length < 1000) break;
    last = page[page.length - 1].id;
  }
  ids = { list, until: Date.now() + 24 * 3600e3, loading: null };
  console.log(`sitemap: ${list.length} places`);
}
async function allIds() {
  if (ids.until > Date.now()) return ids.list;
  if (!ids.loading) ids.loading = loadIds().catch((e) => { ids.loading = null; throw e; });
  if (ids.list.length) return ids.list; // serve the old list while refreshing
  await ids.loading;
  return ids.list;
}

const urlset = (urls) =>
  `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${urls.map((u) => `<url><loc>${esc(u)}</loc></url>`).join('\n')}\n</urlset>`;

async function sitemapIndex() {
  const n = Math.ceil((await allIds()).length / PER_SITEMAP);
  const maps = [`${SITE}/sitemap-hubs.xml`, ...Array.from({ length: n }, (_, i) => `${SITE}/sitemap-${i + 1}.xml`)];
  return `<?xml version="1.0" encoding="UTF-8"?>\n<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${maps.map((m) => `<sitemap><loc>${m}</loc></sitemap>`).join('\n')}\n</sitemapindex>`;
}
function sitemapHubs() {
  const urls = [`${SITE}/`];
  for (const [city] of CITIES) {
    urls.push(`${SITE}/city/${encodeURIComponent(slug(city))}`);
    for (const c of CATEGORIES) urls.push(`${SITE}/c/${encodeURIComponent(slug(c))}/${encodeURIComponent(slug(city))}`);
  }
  return urlset(urls);
}
async function sitemapPart(n) {
  const list = await allIds();
  const part = list.slice((n - 1) * PER_SITEMAP, n * PER_SITEMAP);
  return part.length ? urlset(part.map((id) => `${SITE}/p/${encodeURIComponent(id)}`)) : null;
}

// ---------------------------------------------------------------- server

function send(res, status, body, type = 'text/html; charset=utf-8', maxAge = 3600) {
  res.writeHead(status, { 'Content-Type': type, 'Cache-Control': `public, max-age=${maxAge}`, 'X-Content-Type-Options': 'nosniff' });
  res.end(body);
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, SITE);
    const path = url.pathname;
    let m;
    if (path === '/') return send(res, 200, await cached('home', 3600e3, homePage));
    if (path === '/robots.txt') return send(res, 200, `User-agent: *\nAllow: /\nDisallow: /search\nSitemap: ${SITE}/sitemap.xml\n`, 'text/plain; charset=utf-8', 86400);
    if (path === '/healthz') return send(res, 200, 'ok', 'text/plain', 0);
    if (path === '/sitemap.xml') return send(res, 200, await sitemapIndex(), 'application/xml; charset=utf-8', 86400);
    if (path === '/sitemap-hubs.xml') return send(res, 200, sitemapHubs(), 'application/xml; charset=utf-8', 86400);
    if ((m = path.match(/^\/sitemap-(\d+)\.xml$/))) {
      const xml = await sitemapPart(Number(m[1]));
      return xml ? send(res, 200, xml, 'application/xml; charset=utf-8', 86400) : send(res, 404, 'not found', 'text/plain');
    }
    if ((m = path.match(/^\/p\/([0-9a-zA-Z-]{8,64})$/))) {
      const html = await cached('p:' + m[1], 6 * 3600e3, () => placePage(m[1]));
      return html ? send(res, 200, html) : send(res, 404, await cached('home', 3600e3, homePage));
    }
    if ((m = path.match(/^\/c\/([^/]+)\/([^/]+)$/))) {
      const cat = unslug(m[1]);
      const city = unslug(m[2]);
      const html = await cached(`c:${cat}:${city}`, 6 * 3600e3, () => hubPage(cat, city));
      return html ? send(res, 200, html) : send(res, 404, await cached('home', 3600e3, homePage));
    }
    if ((m = path.match(/^\/city\/([^/]+)$/))) {
      const html = await cached('city:' + unslug(m[1]), 24 * 3600e3, () => cityPage(unslug(m[1])));
      return html ? send(res, 200, html) : send(res, 404, await cached('home', 3600e3, homePage));
    }
    if (path === '/search') return send(res, 200, await searchPage(url.searchParams.get('q') || ''), 'text/html; charset=utf-8', 300);
    return send(res, 404, await cached('home', 3600e3, homePage));
  } catch (e) {
    console.error(req.url, e.message);
    send(res, 503, 'الخدمة مش متاحة دلوقتي، جرّب كمان شوية.', 'text/plain; charset=utf-8', 0);
  }
});

server.listen(PORT, () => {
  console.log(`dalil listening on ${PORT}`);
  allIds().catch((e) => console.error('sitemap preload failed', e.message));
});
