// Supabase Edge Function: `tokens-checkout` — «اشحن أونلاين» for ad tokens (migration 0102)
//
// The platform's OWN Fawaterak account (API v3) takes the money: the user
// buys ad tokens (0026) online instead of a manual transfer + admin review.
//
// POST { action: 'pay', tokens }   Authorization: Bearer <Supabase JWT>
//   → { id, redirect_to } — Fawaterak's hosted checkout (card, wallet,
//     Fawry…). The price comes from ad_token_settings (token_payment_begin),
//     never from the app.
// POST { action: 'status', id }
//   → { status } — re-reads the transaction (getTransactionData) and
//     credits the tokens when it is paid (the token wallet calls it on
//     return; payments-webhook?provider=fawaterak&target=tokens too).
// Errors: { error } with a message to show as is.
//
// Secrets (Edge Functions → Secrets): FAWATERAK_CLIENT_ID,
// FAWATERAK_CLIENT_SECRET, FAWATERAK_API_KEY (signs the webhooks; used by
// payments-webhook), FAWATERAK_MODE = test | live. Plus the
// Supabase-provided SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY.
// JWT verification may stay ON (the app sends the user's session).
// The block between the fw markers is plain JavaScript; backend/tests/run.js
// (phase «ttok») runs it in Node.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
const PLATFORM = {
  mode: Deno.env.get('FAWATERAK_MODE') === 'live' ? 'live' : 'test',
  public: { client_id: Deno.env.get('FAWATERAK_CLIENT_ID') ?? '' },
  secret: { client_secret: Deno.env.get('FAWATERAK_CLIENT_SECRET') ?? '' },
};

// ------------------------------------------------------------------ fw:begin

function fawaterakHost(mode = 'test') {
  return mode === 'live' ? 'https://app.fawaterk.com' : 'https://staging.fawaterk.com';
}

const RETURN_URL = 'https://mogtama3y.com/#/tokens';

// createTransaction body for a top-up (token_payment_begin output). No
// payment_method_id → hosted checkout.
function topupBody(r = Object(), webhookUrl = '') {
  const amount = Number(r.amount);
  return {
    cartTotal: amount,
    currency: 'EGP',
    tr_number: 'TK-' + String(r.id).slice(0, 8),
    customer: {
      first_name: String(r.first_name || 'مستخدم'),
      last_name: String(r.last_name || r.first_name || 'مستخدم'),
      phone: String(r.phone || ''),
    },
    cartItems: [{ name: r.tokens + ' توكن إعلانات مُجتمعي', price: amount, quantity: 1 }],
    pay_load: { kind: 'tokens', request_id: String(r.id) },
    redirectionUrls: { successUrl: RETURN_URL, failUrl: RETURN_URL, pendingUrl: RETURN_URL, backUrl: RETURN_URL, webhookUrl },
    sendEmail: false,
    sendSMS: false,
    lang: 'ar',
  };
}

function fawaterakMessage(j = Object()) {
  const m = j && (j.message ?? j.error_description ?? j.error);
  if (!m) return '';
  if (typeof m === 'string') return m.slice(0, 200);
  try {
    return Object.values(m).flat().join(' — ').slice(0, 200);
  } catch (_e) {
    return '';
  }
}

// createTransaction answer → { intent_key, redirect_to } | { error }
function readTransaction(j = Object()) {
  const d = j && j.status === 'success' ? Object(j.data) : null;
  const url = d && typeof d.url === 'string' && /^https:\/\//.test(d.url) ? d.url : null;
  if (!d || !d.intent_key || !url) {
    const msg = fawaterakMessage(j);
    return { error: 'فواتيرك رفضت إنشاء عملية الدفع' + (msg ? ' — ' + msg : '') };
  }
  return { intent_key: String(d.intent_key), redirect_to: url };
}

// getTransactionData answer → { paid, amount, currency, method } | null
function readTransactionData(j = Object()) {
  const d = j && j.status === 'success' ? Object(j.data) : null;
  if (!d) return null;
  const cur = d.currency != null ? String(d.currency).toUpperCase() : null;
  return {
    paid: d.paid === 1 || d.paid === '1' || d.paid === true || d.status_text === 'paid',
    amount: d.total != null ? Number(d.total) : null,
    currency: cur === 'SR' ? 'SAR' : cur,
    method: d.payment_method != null ? String(d.payment_method) : null,
  };
}

// The platform's Bearer token. → { token } | { error }
async function fawaterakToken(creds = Object(), fetchFn = fetch) {
  const p = Object(creds.public);
  const s = Object(creds.secret);
  if (!p.client_id || !s.client_secret) return { error: 'missing_credentials' };
  const r = await fetchFn(fawaterakHost(creds.mode) + '/oauth/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: JSON.stringify({ grant_type: 'client_credentials', client_id: p.client_id, client_secret: s.client_secret }),
  });
  const j = await r.json().catch(() => null);
  return j && j.access_token ? { token: String(j.access_token) } : { error: fawaterakMessage(j) || 'token_refused' };
}

async function fawaterakCall(mode = 'test', token = '', path = '', body = null, fetchFn = fetch) {
  const r = await fetchFn(fawaterakHost(mode) + path, {
    method: body == null ? 'GET' : 'POST',
    headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: body == null ? undefined : JSON.stringify(body),
  });
  const j = await r.json().catch(() => null);
  return { status: r.status, json: j };
}
// -------------------------------------------------------------------- fw:end

const ALLOWED_ORIGINS = new Set(['https://mogtama3y.com', 'https://www.mogtama3y.com', 'https://tajer.mogtama3y.com']);

function corsFor(req: Request): Record<string, string> {
  const origin = req.headers.get('Origin') ?? '';
  const ok = ALLOWED_ORIGINS.has(origin) || /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);
  return {
    'Access-Control-Allow-Origin': ok ? origin : 'https://mogtama3y.com',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Vary': 'Origin',
  };
}

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

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
  const userId = u.user.id;

  let body: Record<string, unknown>;
  try {
    body = (await req.json()) ?? {};
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }

  try {
    if (body.action === 'pay') {
      const tokens = Number(body.tokens);
      if (!Number.isInteger(tokens)) return json({ error: 'اختار عدد التوكن' }, 400);
      const { data: r, error } = await admin.rpc('token_payment_begin', { p_user: userId, p_tokens: tokens });
      if (error) return json({ error: 'تعذر بدء الشحن، جرّب تاني' }, 500);
      if (r?.error) return json({ error: r.error }, 400);
      const t = await fawaterakToken(PLATFORM);
      if ('error' in t) {
        console.error('fawaterak token', t.error);
        return json({ error: 'الشحن الأونلاين مش متاح دلوقتي — استخدم التحويل أو جرّب بعد شوية' }, 502);
      }
      const hook = `${SUPABASE_URL}/functions/v1/payments-webhook?provider=fawaterak&target=tokens`;
      const res = await fawaterakCall(PLATFORM.mode, t.token, '/api/v3/createTransaction', topupBody(r, hook));
      const tr = readTransaction(res.json);
      if ('error' in tr) {
        console.error('createTransaction', res.status, JSON.stringify(res.json).slice(0, 500));
        return json({ error: tr.error }, 502);
      }
      const att = await admin.rpc('token_payment_attach', { p_id: r.id, p_intent: tr.intent_key, p_url: tr.redirect_to });
      if (att.error) console.error('token_payment_attach', att.error.message);
      return json({ id: r.id, redirect_to: tr.redirect_to });
    }

    if (body.action === 'status') {
      const id = String(body.id ?? '');
      if (!UUID.test(id)) return json({ error: 'بيانات ناقصة' }, 400);
      const { data: r, error } = await admin.rpc('token_payment_lookup', { p_user: userId, p_id: id });
      if (error) return json({ error: 'تعذر قراءة الطلب' }, 500);
      if (!r) return json({ error: 'الطلب ده مش موجود' }, 404);
      if (r.status === 'approved' || !r.intent_key) return json({ status: r.status });
      const t = await fawaterakToken(PLATFORM);
      if ('error' in t) return json({ status: r.status });
      const res = await fawaterakCall(PLATFORM.mode, t.token, '/api/v3/getTransactionData', { intent_key: r.intent_key });
      const tx = readTransactionData(res.json);
      if (!tx || !tx.paid) return json({ status: r.status });
      const s = await admin.rpc('token_payment_settle', {
        p_intent: r.intent_key, p_paid: true, p_amount: tx.amount, p_currency: tx.currency, p_method: tx.method,
      });
      if (s.error) return json({ error: 'تعذر تحديث الرصيد' }, 500);
      return json({ status: s.data?.status ?? r.status });
    }

    return json({ error: 'unknown action' }, 400);
  } catch (e) {
    console.error('tokens-checkout', String(e));
    return json({ error: 'مقدرناش نوصل لفواتيرك دلوقتي — جرّب تاني بعد شوية' }, 502);
  }
});
