// Supabase Edge Function: `payments-checkout` — «ادفع أونلاين» (migrations 0100 / 0101)
//
// متجري storefront → the customer placed an order (place_store_order) and
// chose to pay online. Fawaterak (فواتيرك) for now: the shop's OWN
// account (its OAuth client, read with the service role through
// gateway_credentials()), so the money goes straight to the merchant.
// No account needed: the order code + the order's mobile prove it is the
// customer (payment_begin / payment_lookup, 20 tries an hour per order).
//
// POST { action: 'pay', code, phone }
//   → { redirect_to } — Fawaterak's hosted checkout (cards, wallets, Fawry,
//     Aman… — the customer picks there); the order becomes «أونلاين —
//     مستني الدفع» | { paid: true }
// POST { action: 'status', code, phone }
//   → { payment_status } — re-reads the transaction from Fawaterak
//     (getTransactionData) and settles the order (the return page calls it;
//     the webhook too).
// Errors: { error } with a message to show as is.
//
// Fawaterak API v3: staging.fawaterk.com (test) / app.fawaterk.com (live).
// POST /oauth/token (client_credentials) → Bearer → /api/v3/createTransaction
// (no payment_method_id = hosted checkout → data.url, data.intent_key).
// Every transaction carries webhookUrl = payments-webhook?shop=…&provider=fawaterak.
//
// SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY are provided by Supabase. Deploy
// with JWT verification OFF or ON (the app sends the publishable key; the
// code + phone are the real check). The block between the fw markers is
// plain JavaScript; backend/tests/run.js (phase «tfaw») runs it in Node.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

// ------------------------------------------------------------------ fw:begin

function fawaterakHost(mode = 'test') {
  return mode === 'live' ? 'https://app.fawaterk.com' : 'https://staging.fawaterk.com';
}

const TRACK_URL = 'https://mogtama3y.com/#/o/';

// createTransaction body for an order (payment_begin output). One cart line
// for the whole order: the order's total already has shipping and
// discounts in it. No payment_method_id → hosted checkout.
function transactionBody(order = Object(), webhookUrl = '') {
  const name = String(order.customer_name || 'عميل').trim().split(/\s+/);
  const total = Number(order.total);
  return {
    cartTotal: total,
    currency: String(order.currency || 'EGP'),
    tr_number: String(order.code),
    customer: {
      first_name: name[0] || 'عميل',
      last_name: name.slice(1).join(' ') || name[0] || 'عميل',
      phone: String(order.customer_phone || ''),
    },
    cartItems: [{ name: 'طلب ' + order.code + ' — ' + String(order.shop_name || 'متجري').slice(0, 60), price: total, quantity: 1 }],
    pay_load: { order_code: String(order.code), shop_id: String(order.shop_id) },
    redirectionUrls: {
      successUrl: TRACK_URL + order.code,
      failUrl: TRACK_URL + order.code,
      pendingUrl: TRACK_URL + order.code,
      backUrl: TRACK_URL + order.code,
      webhookUrl,
    },
    sendEmail: false,
    sendSMS: false,
    lang: 'ar',
  };
}

// The error text of a Fawaterak answer (a string, or Laravel's {field: [msg]}).
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

// /oauth/token answer → the access token, or null.
function readToken(j = Object()) {
  return j && typeof j.access_token === 'string' && j.access_token ? j.access_token : null;
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

// getTransactionData answer → { paid, amount, currency, method, code } | null
function readTransactionData(j = Object()) {
  const d = j && j.status === 'success' ? Object(j.data) : null;
  if (!d) return null;
  let pl = d.pay_load;
  if (typeof pl === 'string') {
    try { pl = JSON.parse(pl); } catch (_e) { pl = null; }
  }
  const cur = d.currency != null ? String(d.currency).toUpperCase() : null;
  return {
    paid: d.paid === 1 || d.paid === '1' || d.paid === true || d.status_text === 'paid',
    amount: d.total != null ? Number(d.total) : null,
    currency: cur === 'SR' ? 'SAR' : cur,
    method: d.payment_method != null ? String(d.payment_method) : null,
    code: pl && pl.order_code ? String(pl.order_code) : null,
  };
}

// The shop's Bearer token (client credentials). → token | { error }
async function fawaterakToken(creds = Object(), fetchFn = fetch) {
  const p = Object(creds.public);
  const s = Object(creds.secret);
  if (!p.client_id || !s.client_secret) return { error: 'بيانات فواتيرك ناقصة (Client ID / Client Secret)' };
  const r = await fetchFn(fawaterakHost(creds.mode) + '/oauth/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: JSON.stringify({ grant_type: 'client_credentials', client_id: p.client_id, client_secret: s.client_secret }),
  });
  const j = await r.json().catch(() => null);
  const t = readToken(j);
  return t ? { token: t } : { error: 'فواتيرك رفضت الـ Client ID / Secret' + (fawaterakMessage(j) ? ' — ' + fawaterakMessage(j) : '') };
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

const ALLOWED_ORIGINS = new Set([
  'https://tajer.mogtama3y.com',
  'https://mogtama3y.com',
  'https://www.mogtama3y.com',
]);

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
const PROVIDER = 'fawaterak';

Deno.serve(async (req) => {
  const cors = corsFor(req);
  const json = (body: unknown, status = 200) =>
    new Response(JSON.stringify(body), { status, headers: { ...cors, 'Content-Type': 'application/json' } });
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);

  let body: Record<string, unknown>;
  try {
    body = (await req.json()) ?? {};
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }
  const action = String(body.action ?? '');
  const code = String(body.code ?? '').trim().toUpperCase();
  const phone = String(body.phone ?? '').trim();
  if (!/^T[0-9A-Z]{7}$/.test(code) || phone.length < 8) return json({ error: 'بيانات ناقصة' }, 400);

  const credsOf = async (shop: string) => {
    const { data, error } = await admin.rpc('gateway_credentials', { p_shop: shop, p_provider: PROVIDER });
    if (error || !data) return null;
    return data as { mode: string; public: Record<string, string>; secret: Record<string, string> };
  };

  try {
    if (action === 'pay') {
      const { data: order, error } = await admin.rpc('payment_begin', { p_code: code, p_phone: phone, p_provider: PROVIDER });
      if (error) return json({ error: 'تعذر فتح الطلب، جرّب تاني' }, 500);
      if (order?.error) return json({ error: order.error }, 400);
      if (order?.payment_status === 'paid') return json({ paid: true, payment_status: 'paid' });
      const creds = await credsOf(order.shop_id);
      if (!creds) return json({ error: 'المحل ده مش مفعّل الدفع الأونلاين دلوقتي' }, 400);
      const t = await fawaterakToken(creds);
      if ('error' in t) {
        console.error('fawaterak token', t.error);
        return json({ error: 'الدفع الأونلاين عند المحل ده فيه مشكلة دلوقتي — اختار الدفع عند الاستلام أو كلّم المحل' }, 502);
      }
      const hook = `${SUPABASE_URL}/functions/v1/payments-webhook?shop=${order.shop_id}&provider=${PROVIDER}`;
      const r = await fawaterakCall(creds.mode, t.token, '/api/v3/createTransaction', transactionBody(order, hook));
      const tr = readTransaction(r.json);
      if ('error' in tr) {
        console.error('createTransaction', r.status, JSON.stringify(r.json).slice(0, 500));
        return json({ error: tr.error }, 502);
      }
      const att = await admin.rpc('payment_attach', {
        p_order: order.order_id, p_provider: PROVIDER, p_invoice_id: tr.intent_key,
        p_invoice_key: null, p_url: tr.redirect_to, p_data: null,
      });
      if (att.error) console.error('payment_attach', att.error.message);
      return json({ redirect_to: tr.redirect_to });
    }

    if (action === 'status') {
      const { data: o, error } = await admin.rpc('payment_lookup', { p_code: code, p_phone: phone });
      if (error) return json({ error: 'تعذر قراءة الطلب' }, 500);
      if (!o) return json({ error: 'مفيش طلب بالرقم ده والموبايل ده' }, 404);
      if (o.payment_status === 'paid' || !o.invoice_id || o.provider !== PROVIDER) return json({ payment_status: o.payment_status });
      const creds = await credsOf(o.shop_id);
      if (!creds) return json({ payment_status: o.payment_status });
      const t = await fawaterakToken(creds);
      if ('error' in t) return json({ payment_status: o.payment_status });
      const r = await fawaterakCall(creds.mode, t.token, '/api/v3/getTransactionData', { intent_key: o.invoice_id });
      const tx = readTransactionData(r.json);
      if (!tx || !tx.paid) return json({ payment_status: o.payment_status });
      const s = await admin.rpc('payment_settle', {
        p_shop: o.shop_id, p_provider: PROVIDER, p_invoice_id: o.invoice_id, p_paid: true,
        p_amount: tx.amount, p_currency: tx.currency, p_method: tx.method, p_code: o.code,
      });
      if (s.error) return json({ error: 'تعذر تحديث الطلب' }, 500);
      return json({ payment_status: s.data?.status ?? o.payment_status });
    }

    return json({ error: 'unknown action' }, 400);
  } catch (e) {
    console.error('payments-checkout', String(e));
    return json({ error: 'مقدرناش نوصل لفواتيرك دلوقتي — جرّب تاني بعد شوية' }, 502);
  }
});
