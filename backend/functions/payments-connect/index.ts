// Supabase Edge Function: `payments-connect` — «اختبر الاتصال» (migration 0097)
//
// متجري → «الربط والتكاملات» → «طرق الدفع»: each merchant connects THEIR
// OWN gateway (Paymob / Kashier / Tap / Moyasar); the money goes straight
// to the merchant, the platform never holds funds. The app saves the keys
// with set_shop_gateway() (secrets are write-only: the client never reads
// them back). This function checks them server-side:
//
// POST { action: 'test', shop, provider }   Authorization: Bearer <Supabase JWT>
//   → { ok, status: 'connected' | 'error', message, checked: 'api' | 'format' }
//
//   1. integration_rate_hit(shop, 'gateway_test') AS the user — proves the
//      user owns the shop and limits tests to 20 an hour.
//   2. gateway_credentials() with the service role (the only way to read
//      the secrets), then one harmless call to the gateway:
//        Paymob  — POST <region>/api/auth/tokens {api_key} (issues a token, no money moves)
//        Tap     — POST https://api.tap.company/v2/charges/list {limit: 1} (read-only list)
//        Moyasar — GET  https://api.moyasar.com/v1/payments?limit=1 (read-only list)
//        Kashier — no public read-only "who am I" endpoint we could confirm in
//                  the docs: FORMAT CHECK ONLY (checked: 'format'); the first
//                  real test payment (Phase 4) is the true check.
//   3. gateway_record_check() stores «مربوط» / «فيه مشكلة».
//
// SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SERVICE_ROLE_KEY are provided
// by Supabase. Deploy with JWT verification OFF (the function checks the
// user itself). No dependencies besides supabase-js. The block between the
// gw markers is plain JavaScript; backend/tests/run.js (phase «tint») runs
// it in Node with a fake fetch.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

// ------------------------------------------------------------------ gw:begin

// Paymob has one API host per region (by the shop's country).
function paymobBase(country = 'EG') {
  return ({ SA: 'https://ksa.paymob.com', AE: 'https://uae.paymob.com', OM: 'https://oman.paymob.com' })[country] || 'https://accept.paymob.com';
}

function basicAuth(user = '') {
  return 'Basic ' + btoa(user + ':');
}

// One harmless call per gateway. `creds` = gateway_credentials() output,
// `fetchFn` = fetch (injected so the tests can fake the network).
// → { ok, message, checked: 'api' | 'format' }
async function testGateway(creds = Object(), fetchFn = fetch) {
  const p = Object(creds.public);
  const s = Object(creds.secret);
  const bad = (message = '') => ({ ok: false, message, checked: 'api' });
  const verdict = (status = 0, okMsg = '') => {
    if (status >= 200 && status < 300) return { ok: true, message: okMsg, checked: 'api' };
    if (status === 401 || status === 403) return bad('البوابة رفضت المفاتيح — اتأكد إنك نسختها صح وإنها لنفس الوضع (تجريبي/حقيقي)');
    return bad('البوابة ردّت برد غير متوقع (' + status + ') — جرّب تاني بعد شوية');
  };
  try {
    switch (creds.provider) {
      case 'paymob': {
        if (!s.api_key) return bad('الـ API key ناقص');
        const r = await fetchFn(paymobBase(creds.country) + '/api/auth/tokens', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ api_key: s.api_key }),
        });
        if (r.status >= 200 && r.status < 300) {
          const j = await r.json().catch(() => ({}));
          if (!j || !j.token) return bad('Paymob ردّ من غير توكن — راجع الـ API key');
          return { ok: true, message: 'Paymob قبل المفتاح ✓', checked: 'api' };
        }
        return verdict(r.status, '');
      }
      case 'tap': {
        if (!s.secret_key) return bad('الـ Secret key ناقص');
        const r = await fetchFn('https://api.tap.company/v2/charges/list', {
          method: 'POST',
          headers: { 'Authorization': 'Bearer ' + s.secret_key, 'Content-Type': 'application/json', 'Accept': 'application/json' },
          body: JSON.stringify({ limit: 1 }),
        });
        return verdict(r.status, 'Tap قبل المفتاح ✓');
      }
      case 'moyasar': {
        if (!s.secret_key) return bad('الـ Secret key ناقص');
        const r = await fetchFn('https://api.moyasar.com/v1/payments?limit=1', {
          method: 'GET',
          headers: { 'Authorization': basicAuth(s.secret_key), 'Accept': 'application/json' },
        });
        return verdict(r.status, 'Moyasar قبل المفتاح ✓');
      }
      case 'kashier': {
        const okMid = /^MID-[0-9]{1,10}-[0-9]{1,10}$/.test(p.merchant_id || '');
        if (!okMid || !s.api_key || !s.secret_key) return { ok: false, message: 'بيانات Kashier ناقصة', checked: 'format' };
        return { ok: true, message: 'شكل البيانات سليم — أول عملية دفع تجريبية هتأكد الربط', checked: 'format' };
      }
      default:
        return bad('بوابة غير معروفة');
    }
  } catch (_e) {
    return bad('مقدرناش نوصل للبوابة دلوقتي — جرّب تاني بعد شوية');
  }
}
// -------------------------------------------------------------------- gw:end

const ALLOWED_ORIGINS = new Set([
  'https://tajer.mogtama3y.com',
  'https://mogtama3y.com',
  'https://www.mogtama3y.com',
]);

function corsFor(req: Request): Record<string, string> {
  const origin = req.headers.get('Origin') ?? '';
  const ok = ALLOWED_ORIGINS.has(origin) || /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);
  return {
    'Access-Control-Allow-Origin': ok ? origin : 'https://tajer.mogtama3y.com',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Vary': 'Origin',
  };
}

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
const PROVIDERS = new Set(['paymob', 'kashier', 'tap', 'moyasar']);

Deno.serve(async (req) => {
  const cors = corsFor(req);
  const json = (body: unknown, status = 200) =>
    new Response(JSON.stringify(body), { status, headers: { ...cors, 'Content-Type': 'application/json' } });
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);

  const jwt = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  if (jwt.split('.').length !== 3) return json({ error: 'سجّل دخول الأول' }, 401);
  const { data: u, error: ue } = await admin.auth.getUser(jwt);
  if (ue || !u.user) return json({ error: 'سجّل دخول الأول' }, 401);

  let body: Record<string, unknown>;
  try {
    body = (await req.json()) ?? {};
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }
  const shop = String(body.shop ?? '');
  const provider = String(body.provider ?? '');
  if (String(body.action ?? 'test') !== 'test') return json({ error: 'unknown action' }, 400);
  if (!UUID.test(shop) || !PROVIDERS.has(provider)) return json({ error: 'بيانات ناقصة' }, 400);

  // As the user: ownership + 20 tests an hour.
  const asUser = createClient(SUPABASE_URL, ANON_KEY, {
    auth: { persistSession: false },
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });
  const hit = await asUser.rpc('integration_rate_hit', { p_shop: shop, p_kind: 'gateway_test' });
  if (hit.error) return json({ error: hit.error.message }, hit.error.code === '42501' ? 403 : 429);

  const { data: creds, error: ce } = await admin.rpc('gateway_credentials', { p_shop: shop, p_provider: provider });
  if (ce) return json({ error: 'تعذر قراءة البيانات' }, 500);
  if (!creds) return json({ error: 'اربط البوابة الأول' }, 404);

  const result = await testGateway(creds, fetch);
  const rec = await admin.rpc('gateway_record_check', { p_shop: shop, p_provider: provider, p_ok: result.ok, p_error: result.ok ? null : result.message });
  if (rec.error) console.error('gateway_record_check', rec.error.message);
  return json({ ok: result.ok, status: result.ok ? 'connected' : 'error', message: result.message, checked: result.checked });
});
