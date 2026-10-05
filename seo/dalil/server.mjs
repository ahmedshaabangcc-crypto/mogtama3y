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
  if (p.claimed_shop_id) {
    // Claimed by its owner: the real online store page replaces this one.
    const shop = (await rest(`shops?id=eq.${p.claimed_shop_id}&select=slug`))[0];
    if (shop?.slug) return { redirect: `${SITE}/s/${shop.slug}` };
  }
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

// ------------------------------------------------------- community reports

const REPORT_STATUS = { new: 'جديد', reviewing: 'قيد المراجعة', routed: 'اتبعت للجهة المختصة', resolved: 'اتحلّ', rejected: 'مرفوض' };

// Share target for a report: rich preview (photo, title) for TikTok,
// Facebook and WhatsApp, then straight into the app's report page.
async function reportPage(id) {
  const r = await rpc('get_report', { p_id: id });
  if (!r) return null;
  const where = [r.district, r.governorate].filter(Boolean).join('، ');
  const appUrl = `${APP}/#/r/${r.id}`;
  const title = `بلاغ: ${r.category}${where ? ' — ' + where : ''} | مُجتمعي`;
  const description = `${r.description} · ${REPORT_STATUS[r.status] || ''} · ${r.votes_count} ساكن معاه. ادخل واضغط «وأنا كمان».`;
  const image = (r.photos && r.photos[0]) || `${APP}/icons/Icon-512.png`;
  return `<!doctype html>
<html lang="ar" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
<meta name="robots" content="noindex">
<meta property="og:type" content="article"><meta property="og:site_name" content="مُجتمعي">
<meta property="og:title" content="${esc(title)}"><meta property="og:description" content="${esc(description)}">
<meta property="og:image" content="${esc(image)}"><meta property="og:url" content="${SITE}/r/${esc(r.id)}">
<meta name="twitter:card" content="summary_large_image"><meta name="twitter:image" content="${esc(image)}">
<meta http-equiv="refresh" content="0; url=${esc(appUrl)}">
<style>body{font-family:system-ui,Tahoma,sans-serif;background:#0B1530;color:#fff;display:grid;place-items:center;min-height:100vh;margin:0;text-align:center}a{color:#F2B661}</style>
</head><body><div><p>بنفتحلك البلاغ على مُجتمعي…</p><p><a href="${esc(appUrl)}">لو الصفحة ماتفتحتش اضغط هنا</a></p></div>
<script>location.replace(${JSON.stringify(appUrl)})</script></body></html>`;
}

// ------------------------------------------------- registered online stores

const egp = (n) => `${Number(n).toLocaleString('en-US', { maximumFractionDigits: 2 })} ج.م`;
const imagesOf = (p) => (Array.isArray(p.images) && p.images.length ? p.images : p.image_url ? [p.image_url] : []);
const SHOP_COLS = 'id,name,category,description,address,lat,lng,slug,logo_url,cover_image_url,delivery_fee,free_delivery_over';
const PRODUCT_COLS = 'id,name,description,category,price,old_price,images,image_url,stock';

async function storeData(slugName) {
  const shops = await rest(`shops?slug=eq.${encodeURIComponent(slugName.toLowerCase())}&select=${SHOP_COLS}`);
  const shop = shops[0];
  if (!shop) return null;
  const products = await rest(`shop_products?shop_id=eq.${shop.id}&is_available=eq.true&price=gt.0&select=${PRODUCT_COLS}&order=created_at.desc&limit=500`);
  return { shop, products };
}

function offerOf(p, url) {
  return {
    '@type': 'Offer',
    price: Number(p.price),
    priceCurrency: 'EGP',
    url,
    availability: typeof p.stock === 'number' && p.stock <= 0 ? 'https://schema.org/OutOfStock' : 'https://schema.org/InStock',
  };
}

async function storePage(slugName) {
  const data = await storeData(slugName);
  if (!data) return null;
  const { shop, products } = data;
  const city = shop.lat != null ? cityOf(shop.lat, shop.lng) : null;
  const where = city ? ` في ${city}` : '';
  const appUrl = `${APP}/#/s/${shop.slug}`;
  const canonical = `${SITE}/s/${shop.slug}`;
  const delivery = shop.delivery_fee > 0 ? `توصيل ${egp(shop.delivery_fee)}${shop.free_delivery_over ? ` — مجاني فوق ${egp(shop.free_delivery_over)}` : ''}` : 'توصيل مجاني';
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Store',
    name: shop.name,
    url: canonical,
    ...(shop.logo_url ? { image: shop.logo_url } : {}),
    ...(shop.description ? { description: shop.description } : {}),
    ...(shop.lat != null ? { geo: { '@type': 'GeoCoordinates', latitude: shop.lat, longitude: shop.lng } } : {}),
    address: { '@type': 'PostalAddress', addressCountry: 'EG', ...(city ? { addressLocality: city } : {}), ...(shop.address ? { streetAddress: shop.address } : {}) },
    hasOfferCatalog: {
      '@type': 'OfferCatalog',
      name: `منتجات ${shop.name}`,
      itemListElement: products.slice(0, 100).map((p) => ({
        '@type': 'Offer',
        ...offerOf(p, `${canonical}/p/${p.id}`),
        itemOffered: { '@type': 'Product', name: p.name, ...(imagesOf(p)[0] ? { image: imagesOf(p)[0] } : {}) },
      })),
    },
  };
  const items = products
    .map((p) => {
      const img = imagesOf(p)[0];
      const off = p.old_price && Number(p.old_price) > Number(p.price) ? ` <s class="muted">${egp(p.old_price)}</s>` : '';
      return `<li style="display:flex;gap:12px;align-items:center">${img ? `<img src="${esc(img)}" alt="${esc(p.name)}" width="64" height="64" loading="lazy" style="border-radius:12px;object-fit:cover">` : ''}<div><a href="${SITE}/s/${esc(shop.slug)}/p/${esc(p.id)}">${esc(p.name)}</a><br><b style="color:#b7791f">${egp(p.price)}</b>${off}</div></li>`;
    })
    .join('');
  return page({
    title: `${shop.name} — ${shop.category || 'متجر'}${where} | اطلب أونلاين على مُجتمعي`,
    description: `${shop.name}${where}: ${products.length} منتج بالأسعار${shop.description ? ' — ' + shop.description.slice(0, 120) : ''}. اطلب أونلاين والدفع عند الاستلام.`,
    canonical,
    jsonLd,
    body: `<p class="muted"><a href="${SITE}/">الدليل</a>${city ? ` › <a href="${SITE}/city/${encodeURIComponent(slug(city))}">${esc(city)}</a>` : ''}</p>
<div class="card">
${shop.cover_image_url ? `<img src="${esc(shop.cover_image_url)}" alt="" style="width:100%;max-height:220px;object-fit:cover;border-radius:12px">` : ''}
<h1>${shop.logo_url ? `<img src="${esc(shop.logo_url)}" alt="" width="44" height="44" style="border-radius:12px;vertical-align:middle;margin-left:8px">` : ''}${esc(shop.name)}</h1>
<p class="muted">${esc(shop.category || '')}${esc(where)} · ${esc(delivery)} · الدفع عند الاستلام</p>
${shop.description ? `<p>${esc(shop.description)}</p>` : ''}
${shop.address ? `<p>📍 ${esc(shop.address)}</p>` : ''}
<a class="btn wa" href="${appUrl}">اطلب من المتجر</a>
</div>
<div class="card"><h2>المنتجات والأسعار</h2><ul class="list">${items || '<li class="muted">المتجر بيضيف منتجاته.</li>'}</ul></div>`,
  });
}

async function productPage(slugName, productId) {
  const data = await storeData(slugName);
  const p = data?.products.find((x) => x.id === productId);
  if (!p) return null;
  const { shop } = data;
  const city = shop.lat != null ? cityOf(shop.lat, shop.lng) : null;
  const canonical = `${SITE}/s/${shop.slug}/p/${p.id}`;
  const imgs = imagesOf(p);
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: p.name,
    ...(imgs.length ? { image: imgs } : {}),
    ...(p.description ? { description: p.description } : {}),
    brand: { '@type': 'Brand', name: shop.name },
    offers: { ...offerOf(p, canonical), seller: { '@type': 'Organization', name: shop.name } },
  };
  return page({
    title: `${p.name} بسعر ${egp(p.price)} — ${shop.name}${city ? ' ' + city : ''} | مُجتمعي`,
    description: `${p.name} بـ ${egp(p.price)} من ${shop.name}${city ? ' في ' + city : ''}. ${p.description ? p.description.slice(0, 120) + ' ' : ''}اطلب أونلاين والدفع عند الاستلام.`,
    canonical,
    jsonLd,
    body: `<p class="muted"><a href="${SITE}/">الدليل</a> › <a href="${SITE}/s/${esc(shop.slug)}">${esc(shop.name)}</a></p>
<div class="card">
${imgs[0] ? `<img src="${esc(imgs[0])}" alt="${esc(p.name)}" style="width:100%;max-height:420px;object-fit:contain;border-radius:12px;background:#fff">` : ''}
<h1>${esc(p.name)}</h1>
<p style="font-size:22px"><b style="color:#b7791f">${egp(p.price)}</b>${p.old_price && Number(p.old_price) > Number(p.price) ? ` <s class="muted">${egp(p.old_price)}</s>` : ''}</p>
${p.description ? `<p>${esc(p.description)}</p>` : ''}
<a class="btn wa" href="${APP}/#/s/${encodeURIComponent(shop.slug)}/p/${encodeURIComponent(p.id)}">اطلب دلوقتي</a>
<a class="btn line" href="${SITE}/s/${esc(shop.slug)}">كل منتجات ${esc(shop.name)}</a>
</div>`,
  });
}

async function storeUrls() {
  const shops = await rest('shops?slug=not.is.null&select=id,slug&limit=10000');
  const urls = shops.map((s) => `${SITE}/s/${encodeURIComponent(s.slug)}`);
  const bySlug = new Map(shops.map((s) => [s.id, s.slug]));
  const prods = await rest('shop_products?is_available=eq.true&price=gt.0&select=id,shop_id&limit=50000');
  for (const p of prods) if (bySlug.has(p.shop_id)) urls.push(`${SITE}/s/${encodeURIComponent(bySlug.get(p.shop_id))}/p/${p.id}`);
  return urls;
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
  const maps = [`${SITE}/sitemap-hubs.xml`, `${SITE}/sitemap-stores.xml`, ...Array.from({ length: n }, (_, i) => `${SITE}/sitemap-${i + 1}.xml`)];
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

// ------------------------------------------------- report videos (uploads)
//
// Short report videos live on this VPS (Supabase's free tier can't carry
// video): POST /media/upload with the user's Supabase access token as a
// Bearer token and the raw video as the body (≤ 25 MB, 10 a day per user).
// Files are served from /media/v/<user id>/<file> with Range support.

import fs from 'node:fs';
import fsp from 'node:fs/promises';
import nodePath from 'node:path';
import crypto from 'node:crypto';

const MEDIA_DIR = process.env.MEDIA_DIR || '/app/media';
const MAX_VIDEO_BYTES = 25 * 1024 * 1024;
const VIDEOS_PER_DAY = 10;
const VIDEO_TYPES = { 'video/mp4': 'mp4', 'video/webm': 'webm', 'video/quicktime': 'mov', 'video/3gpp': '3gp' };
const MIME = { mp4: 'video/mp4', webm: 'video/webm', mov: 'video/quicktime', '3gp': 'video/3gpp' };
const ALLOWED_ORIGINS = new Set(['https://mogtama3y.com', 'https://www.mogtama3y.com', 'https://tajer.mogtama3y.com', 'https://ittihad.mogtama3y.com']);

function cors(req, res) {
  const origin = req.headers.origin || '';
  if (ALLOWED_ORIGINS.has(origin) || /^http:\/\/localhost:\d+$/.test(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
    res.setHeader('Vary', 'Origin');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Authorization, Content-Type');
    res.setHeader('Access-Control-Max-Age', '86400');
  }
}

async function userFromToken(req) {
  const token = (req.headers.authorization || '').replace(/^Bearer\s+/i, '');
  if (!token) return null;
  const r = await fetch(`${SUPABASE_URL}/auth/v1/user`, { headers: { apikey: SUPABASE_KEY, Authorization: `Bearer ${token}` } });
  if (!r.ok) return null;
  const u = await r.json();
  return /^[0-9a-f-]{36}$/.test(u?.id || '') ? u.id : null;
}

function json(res, status, body) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' });
  res.end(JSON.stringify(body));
}

async function handleUpload(req, res) {
  const userId = await userFromToken(req);
  if (!userId) return json(res, 401, { error: 'سجّل دخول الأول' });
  const ext = VIDEO_TYPES[(req.headers['content-type'] || '').split(';')[0].trim().toLowerCase()];
  if (!ext) return json(res, 415, { error: 'نوع الفيديو مش مدعوم (mp4 / webm / mov)' });
  const declared = Number(req.headers['content-length'] || 0);
  if (declared > MAX_VIDEO_BYTES) return json(res, 413, { error: 'الفيديو أكبر من 25 ميجا — قصّره شوية' });

  const dir = nodePath.join(MEDIA_DIR, 'v', userId);
  await fsp.mkdir(dir, { recursive: true });
  const dayAgo = Date.now() - 24 * 3600e3;
  const today = (await Promise.all((await fsp.readdir(dir)).map((f) => fsp.stat(nodePath.join(dir, f))))).filter((s) => s.mtimeMs > dayAgo).length;
  if (today >= VIDEOS_PER_DAY) return json(res, 429, { error: 'وصلت لحد الفيديوهات النهارده' });

  const name = `${Date.now().toString(36)}${crypto.randomBytes(6).toString('hex')}.${ext}`;
  const file = nodePath.join(dir, name);
  const out = fs.createWriteStream(file);
  let size = 0;
  let tooBig = false;
  await new Promise((resolve, reject) => {
    req.on('data', (chunk) => {
      size += chunk.length;
      if (size > MAX_VIDEO_BYTES && !tooBig) {
        tooBig = true;
        req.unpipe(out);
        out.destroy();
        req.resume();
      }
    });
    req.pipe(out);
    req.on('end', resolve);
    req.on('error', reject);
    out.on('error', (e) => (tooBig ? resolve() : reject(e)));
  });
  if (tooBig || size === 0) {
    await fsp.rm(file, { force: true });
    return json(res, tooBig ? 413 : 400, { error: tooBig ? 'الفيديو أكبر من 25 ميجا — قصّره شوية' : 'الفيديو فاضي' });
  }
  await new Promise((r) => (out.writableFinished ? r() : out.on('finish', r)));
  return json(res, 200, { url: `${SITE}/media/v/${userId}/${name}` });
}

async function serveVideo(req, res, userId, name) {
  const file = nodePath.join(MEDIA_DIR, 'v', userId, name);
  let stat;
  try {
    stat = await fsp.stat(file);
  } catch {
    return send(res, 404, 'not found', 'text/plain', 60);
  }
  const type = MIME[name.split('.').pop()] || 'application/octet-stream';
  const range = /^bytes=(\d*)-(\d*)$/.exec(req.headers.range || '');
  const headers = { 'Content-Type': type, 'Accept-Ranges': 'bytes', 'Cache-Control': 'public, max-age=31536000, immutable', 'X-Content-Type-Options': 'nosniff' };
  if (range) {
    const start = range[1] ? Number(range[1]) : Math.max(stat.size - Number(range[2] || 0), 0);
    const end = range[1] && range[2] ? Math.min(Number(range[2]), stat.size - 1) : stat.size - 1;
    if (start > end || start >= stat.size) {
      res.writeHead(416, { 'Content-Range': `bytes */${stat.size}` });
      return res.end();
    }
    res.writeHead(206, { ...headers, 'Content-Range': `bytes ${start}-${end}/${stat.size}`, 'Content-Length': end - start + 1 });
    return fs.createReadStream(file, { start, end }).pipe(res);
  }
  res.writeHead(200, { ...headers, 'Content-Length': stat.size });
  fs.createReadStream(file).pipe(res);
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
    if (path.startsWith('/media/')) {
      cors(req, res);
      if (req.method === 'OPTIONS') {
        res.writeHead(204);
        return res.end();
      }
      if (path === '/media/upload' && req.method === 'POST') return await handleUpload(req, res);
      if ((m = path.match(/^\/media\/v\/([0-9a-f-]{36})\/([a-z0-9]{8,40}\.(?:mp4|webm|mov|3gp))$/))) return await serveVideo(req, res, m[1], m[2]);
      return send(res, 404, 'not found', 'text/plain', 60);
    }
    if (path === '/') return send(res, 200, await cached('home', 3600e3, homePage));
    if (path === '/robots.txt') return send(res, 200, `User-agent: *\nAllow: /\nDisallow: /search\nSitemap: ${SITE}/sitemap.xml\n`, 'text/plain; charset=utf-8', 86400);
    if (path === '/healthz') return send(res, 200, 'ok', 'text/plain', 0);
    if (path === '/sitemap.xml') return send(res, 200, await sitemapIndex(), 'application/xml; charset=utf-8', 86400);
    if (path === '/sitemap-hubs.xml') return send(res, 200, sitemapHubs(), 'application/xml; charset=utf-8', 86400);
    if (path === '/sitemap-stores.xml') return send(res, 200, urlset(await cached('stores-urls', 3600e3, storeUrls)), 'application/xml; charset=utf-8', 3600);
    if ((m = path.match(/^\/s\/([a-z0-9-]{3,40})\/p\/([0-9a-f-]{36})$/i))) {
      const html = await cached(`sp:${m[1]}:${m[2]}`, 600e3, () => productPage(m[1], m[2]));
      return html ? send(res, 200, html, 'text/html; charset=utf-8', 600) : send(res, 404, await cached('home', 3600e3, homePage));
    }
    if ((m = path.match(/^\/r\/([0-9a-f-]{36})$/i))) {
      const html = await cached('r:' + m[1], 120e3, () => reportPage(m[1]));
      return html ? send(res, 200, html, 'text/html; charset=utf-8', 120) : send(res, 404, await cached('home', 3600e3, homePage));
    }
    if ((m = path.match(/^\/s\/([a-z0-9-]{3,40})$/i))) {
      const html = await cached('s:' + m[1], 600e3, () => storePage(m[1]));
      return html ? send(res, 200, html, 'text/html; charset=utf-8', 600) : send(res, 404, await cached('home', 3600e3, homePage));
    }
    if ((m = path.match(/^\/sitemap-(\d+)\.xml$/))) {
      const xml = await sitemapPart(Number(m[1]));
      return xml ? send(res, 200, xml, 'application/xml; charset=utf-8', 86400) : send(res, 404, 'not found', 'text/plain');
    }
    if ((m = path.match(/^\/p\/([0-9a-zA-Z-]{8,64})$/))) {
      const html = await cached('p:' + m[1], 6 * 3600e3, () => placePage(m[1]));
      if (html?.redirect) {
        res.writeHead(301, { Location: html.redirect });
        return res.end();
      }
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
