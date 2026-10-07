// Area pages for mogtama3y.com (seo/SEO-PAGES-BRIEF.md, item 3), e.g.
// /cairo/nasr-city/ — built from real data so they aren't doorway pages:
// how many places of each kind the directory has within ~1.5 km of the
// area's centre, the nearest ones (linking to their directory pages), and
// any community reports there. Run after changing areas or to refresh:
//
//   node tool/seo_areas.mjs        (then: node tool/seo_pages.mjs for the sitemap)
//
// Writes web/<city>/<area>/index.html and web/areas.json (read by
// tool/seo_pages.mjs for the sitemap and the area links).
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const WEB = join(ROOT, 'web');
const SITE = 'https://mogtama3y.com';
const DALIL = 'https://dalil.mogtama3y.com';
const SUPABASE = 'https://pxiabifybakbsqlycffc.supabase.co';
// The app's publishable (public) key, from the Flutter config.
const KEY = readFileSync(join(ROOT, 'lib/core/supabase/supabase_config.dart'), 'utf8').match(/sb_publishable_[A-Za-z0-9_-]+/)[0];

const AREAS = [
  { city: 'cairo', cityAr: 'القاهرة', slug: 'nasr-city', name: 'مدينة نصر', lat: 30.0561, lng: 31.3301,
    about: 'مدينة نصر من أكبر أحياء شرق القاهرة، فيها مناطق سكنية كتير وشوارع تجارية زي عباس العقاد ومكرم عبيد ومصطفى النحاس.' },
  { city: 'cairo', cityAr: 'القاهرة', slug: 'maadi', name: 'المعادي', lat: 29.9602, lng: 31.2569,
    about: 'المعادي حي في جنوب القاهرة على النيل، معروف بشوارعه الهادية ومنطقة شارع 9 التجارية.' },
  { city: 'cairo', cityAr: 'القاهرة', slug: 'heliopolis', name: 'مصر الجديدة', lat: 30.0911, lng: 31.3225,
    about: 'مصر الجديدة حي عريق في شمال شرق القاهرة، فيه مناطق زي الكوربة وروكسي وميدان الحجاز.' },
  { city: 'giza', cityAr: 'الجيزة', slug: 'mohandessin', name: 'المهندسين', lat: 30.0566, lng: 31.2015,
    about: 'المهندسين حي في الجيزة غرب النيل، من أنشط المناطق التجارية بشوارع زي جامعة الدول العربية وشهاب.' },
  { city: 'alexandria', cityAr: 'الإسكندرية', slug: 'smouha', name: 'سموحة', lat: 31.2156, lng: 29.9417,
    about: 'سموحة حي في شرق الإسكندرية، فيه مناطق سكنية حديثة ونادي سموحة وشارع فوزي معاذ.' },
];

const CATEGORIES = [
  'سوبر ماركت وبقالة', 'صيدليات', 'مطاعم', 'كافيهات', 'حلويات ومخبوزات', 'صحة وعيادات', 'ملابس وأزياء',
  'إلكترونيات وموبايلات', 'أدوات منزلية وأثاث', 'تجميل وعناية', 'صيانة وخدمات منزلية', 'سيارات',
  'هدايا ومكتبات', 'رياضة', 'تعليم', 'عقارات', 'سفر وفنادق', 'مناسبات وتصوير', 'خدمات وشركات',
  'مصانع وموردين', 'بنوك وصرافات', 'محلات متنوعة',
];
const RADIUS_KM = 1.5;

const esc = (s) => String(s ?? '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const slugAr = (s) => s.trim().replace(/\s+/g, '-');

async function rpc(fn, body) {
  const r = await fetch(`${SUPABASE}/rest/v1/rpc/${fn}`, {
    method: 'POST',
    headers: { apikey: KEY, Authorization: `Bearer ${KEY}`, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  if (!r.ok) throw new Error(`${fn} ${r.status}: ${(await r.text()).slice(0, 120)}`);
  return r.json();
}

// The page shell is shared with tool/seo_pages.mjs.
const { page } = await import('./seo_pages.mjs');

const built = [];
for (const a of AREAS) {
  const counts = [];
  let nearest = [];
  for (const c of CATEGORIES) {
    const rows = await rpc('nearby_directory', { p_lat: a.lat, p_lng: a.lng, p_km: RADIUS_KM, p_category: c, p_limit: 200 });
    if (rows.length) counts.push([c, rows.length]);
    nearest.push(...rows.slice(0, 4));
  }
  nearest = nearest.sort((x, y) => x.distance_km - y.distance_km).slice(0, 30);
  const reports = await rpc('list_reports', { p_lat: a.lat, p_lng: a.lng, p_km: 3, p_limit: 20 }).catch(() => []);
  const visibleReports = (reports || []).filter((r) => r && r.status !== 'rejected');
  const total = counts.reduce((n, [, k]) => n + k, 0);
  counts.sort((x, y) => y[1] - x[1]);
  if (total < 30) {
    console.log(`skip ${a.name}: only ${total} places — too thin for a page`);
    continue;
  }
  const capped = (n) => (n >= 200 ? 'أكتر من 200' : String(n));
  const path = `/${a.city}/${a.slug}/`;
  const top3 = counts.slice(0, 3).map(([c]) => c).join(' و');
  const body = `
<p>${esc(a.about)}</p>
<p>في دليل مُجتمعي لقينا ${counts.some(([, n]) => n >= 200) ? 'أكتر من ' + total : total} مكان في نطاق ${RADIUS_KM} كيلو من قلب ${esc(a.name)}، أكترهم ${esc(top3)}. القايمة تحت محسوبة من بيانات الدليل، وبتتحدّث كل ما نحدّث الصفحة.</p>
<h2>المحلات والخدمات في ${esc(a.name)}</h2>
<ul>${counts.map(([c, n]) => `<li><a href="${DALIL}/c/${encodeURIComponent(slugAr(c))}/${encodeURIComponent(slugAr(a.cityAr))}">${esc(c)}</a>: ${capped(n)} مكان</li>`).join('')}</ul>
<h2>أقرب الأماكن لقلب ${esc(a.name)}</h2>
<ul>${nearest.map((p) => `<li><a href="${DALIL}/p/${encodeURIComponent(p.id)}">${esc(p.name)}</a> — ${esc(p.category)}${p.address && !/^-?d+.d+s*,s*-?d+.d+$/.test(p.address.trim()) ? ` · ${esc(p.address)}` : ''}</li>`).join('')}</ul>
<p>عايز الأقرب ليك انت بالظبط؟ افتح <a href="/#/nearby">اكتشف حواليك</a> على مُجتمعي واسمح بالموقع، أو دوّر بالاسم في <a href="${DALIL}">دليل المحلات</a>.</p>
<h2>بلاغات ${esc(a.name)}</h2>
${visibleReports.length
    ? `<ul>${visibleReports.map((r) => `<li><a href="${DALIL}/r/${r.id}">${esc(r.category)}</a> — ${esc((r.description || '').slice(0, 90))}</li>`).join('')}</ul>`
    : `<p>لسه مفيش بلاغات منشورة من ${esc(a.name)}. لو شايف مشكلة في شارعك — قمامة أو حفرة أو كسر مياه أو إنارة — <a href="/balagh/">بلّغ عنها</a> وخلّي جيرانك يأكدوها.</p>`}
<h2>مُجتمعي في ${esc(a.name)}</h2>
<ul>
<li>عندك محل في ${esc(a.name)}؟ اعمله <a href="/tajer/">متجر أونلاين ببلاش</a> واستقبل طلبات من جيرانك على واتساب.</li>
<li>ساكن في عمارة؟ نظّموا اتحاد الملاك والمستحقات والقرارات من <a href="/ittihad/">اتحاد الملاك أونلاين</a>.</li>
<li>بيع واشتري مستعمل من جيرانك، ودوّر على فنيين وشغل وعقارات من <a href="/">مُجتمعي</a>.</li>
</ul>
<a class="cta" href="/#/nearby">اكتشف ${esc(a.name)} على مُجتمعي</a>`;
  const html = page({
    path,
    title: `محلات وخدمات ${a.name} — ${a.cityAr} | مُجتمعي`,
    description: `دليل ${a.name} في ${a.cityAr}: ${counts.slice(0, 4).map(([c]) => c).join('، ')} وأكتر، بالعنوان والتليفون، وبلاغات الحي، ومتاجر أونلاين — على مُجتمعي.`,
    h1: `محلات وخدمات ${a.name}`,
    lead: `${a.cityAr} — كل اللي حواليك في ${a.name} في مكان واحد.`,
    body,
    schema: [{
      '@type': 'Place',
      name: a.name,
      address: { '@type': 'PostalAddress', addressLocality: a.name, addressRegion: a.cityAr, addressCountry: 'EG' },
      geo: { '@type': 'GeoCoordinates', latitude: a.lat, longitude: a.lng },
    }],
  });
  mkdirSync(join(WEB, a.city, a.slug), { recursive: true });
  writeFileSync(join(WEB, a.city, a.slug, 'index.html'), html);
  const words = body.replace(/<[^>]+>/g, ' ').split(/\s+/).filter((w) => /[؀-ۿ]/.test(w)).length;
  console.log(`${path}  ${counts.length} categories, ${total} places (capped), ${nearest.length} nearest, ${visibleReports.length} reports, ~${words} words`);
  built.push({ path, name: a.name, city: a.cityAr });
}
writeFileSync(join(WEB, 'areas.json'), JSON.stringify(built, null, 1));
