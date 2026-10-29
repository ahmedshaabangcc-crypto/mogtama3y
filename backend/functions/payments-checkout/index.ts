// Supabase Edge Function: `payments-checkout` — «ادفع أونلاين» (migration 0100)
//
// متجري storefront → the customer placed an order (place_store_order) and
// chose to pay online. Fawaterak (فواتيرك) for now: the shop's OWN
// account (its API key, read with the service role through
// gateway_credentials()), so the money goes straight to the merchant.
// No account needed: the order code + the order's mobile prove it is the
// customer (payment_begin / payment_lookup, 20 tries an hour per order).
//
// POST { action: 'methods', code, phone }
//   → { order: {code, total, currency, shop_name}, methods: [{id, name_ar, name_en, logo, redirect}] }
//     (the order becomes «أونلاين — مستني الدفع»)
// POST { action: 'pay', code, phone, method_id }
//   → { redirect_to } (cards, wallets…: send the customer there)
//   | { codes: {fawryCode | amanCode | masaryCode | meezaReference …}, expire_date }
// POST { action: 'status', code, phone }
//   → { payment_status } — re-reads the invoice from Fawaterak (getInvoiceData)
//     and settles the order (the return page calls it; the webhook too).
// Errors: { error } with a message to show as is.
//
// Fawaterak API v2: staging.fawaterk.com (test) / app.fawaterk.com (live),
// Authorization: Bearer <api key>. Every invoice carries webhookUrl =
// payments-webhook?shop=…&provider=fawaterak, so the merchant pastes
// nothing in their dashboard.
//
// SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY are provided by Supabase. Deploy
// with JWT verification OFF (guests pay; the code + phone are the check).
// The block between the fw markers is plain JavaScript; backend/tests/run.js
// (phase «tfaw») runs it in Node with a fake fetch.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

// ------------------------------------------------------------------ fw:begin

function fawaterakBase(mode = 'test') {
  return mode === 'live' ? 'https://app.fawaterk.com/api/v2' : 'https://staging.fawaterk.com/api/v2';
}

const TRACK_URL = 'https://mogtama3y.com/#/o/';

// invoiceInitPay body for an order (payment_begin output). One cart line
// for the whole order: Fawaterak checks the lines add up to cartTotal, and
// the order's total already has shipping and discounts in it.
function invoiceBody(order = Object(), methodId = 0, webhookUrl = '') {
  const name = String(order.customer_name || 'عميل').trim().split(/\s+/);
  const total = Number(order.total);
  return {
    payment_method_id: Number(methodId),
    cartTotal: total,
    currency: String(order.currency || 'EGP'),
    invoice_number: String(order.code),
    customer: {
      first_name: name[0] || 'عميل',
      last_name: name.slice(1).join(' ') || name[0] || 'عميل',
      phone: String(order.customer_phone || ''),
    },
    cartItems: [{ name: 'طلب ' + order.code + ' — ' + String(order.shop_name || 'متجري').slice(0, 60), price: total, quantity: 1 }],
    redirectionUrls: {
      successUrl: TRACK_URL + order.code,
      failUrl: TRACK_URL + order.code,
      pendingUrl: TRACK_URL + order.code,
      webhookUrl,
    },
    payLoad: { order_code: String(order.code), shop_id: String(order.shop_id) },
    lang: 'ar',
  };
}

// The codes a non-redirect method gives the customer to pay with.
const CODE_KEYS = ['fawryCode', 'amanCode', 'masaryCode', 'meezaReference'];

// invoiceInitPay answer → { invoice_id, invoice_key, redirect_to, codes, expire_date, data } | { error }
function readInitPay(j = Object()) {
  const d = j && j.status === 'success' ? Object(j.data) : null;
  if (!d || d.invoice_id == null) {
    const msg = j && (typeof j.message === 'string' ? j.message : j.message && JSON.stringify(j.message));
    return { error: 'فواتيرك رفضت إنشاء الفاتورة' + (msg ? ' — ' + String(msg).slice(0, 200) : '') };
  }
  const pd = Object(d.payment_data);
  const codes = {};
  for (const k of CODE_KEYS) if (pd[k] != null && pd[k] !== '') codes[k] = String(pd[k]);
  const redirect = typeof pd.redirectTo === 'string' && /^https:\/\//.test(pd.redirectTo) ? pd.redirectTo : null;
  return {
    invoice_id: String(d.invoice_id),
    invoice_key: d.invoice_key != null ? String(d.invoice_key) : null,
    redirect_to: redirect,
    codes,
    expire_date: pd.expireDate != null ? String(pd.expireDate) : null,
    data: Object.keys(codes).length ? { ...codes, expire_date: pd.expireDate ?? null } : null,
  };
}

// getInvoiceData answer → { paid, amount, currency, method, code } | null
function readInvoice(j = Object()) {
  const d = j && j.status === 'success' ? Object(j.data) : null;
  if (!d) return null;
  let pl = d.pay_load;
  if (typeof pl === 'string') {
    try { pl = JSON.parse(pl); } catch (_e) { pl = null; }
  }
  return {
    paid: d.paid === 1 || d.paid === '1' || d.paid === true,
    amount: d.total != null ? Number(d.total) : null,
    currency: d.currency != null ? String(d.currency).toUpperCase() : null,
    method: d.payment_method != null ? String(d.payment_method) : null,
    code: pl && pl.order_code ? String(pl.order_code) : null,
  };
}

async function fawaterakCall(mode = 'test', apiKey = '', path = '', body = null, fetchFn = fetch) {
  const r = await fetchFn(fawaterakBase(mode) + path, {
    method: body == null ? 'GET' : 'POST',
    headers: { 'Authorization': 'Bearer ' + apiKey, 'Content-Type': 'application/json', 'Accept': 'application/json' },
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
    if (error || !data || !data.secret?.api_key) return null;
    return data as { mode: string; secret: { api_key: string } };
  };

  try {
    if (action === 'methods' || action === 'pay') {
      const { data: order, error } = await admin.rpc('payment_begin', { p_code: code, p_phone: phone, p_provider: PROVIDER });
      if (error) return json({ error: 'تعذر فتح الطلب، جرّب تاني' }, 500);
      if (order?.error) return json({ error: order.error }, 400);
      if (order?.payment_status === 'paid') return json({ paid: true, payment_status: 'paid' });
      const creds = await credsOf(order.shop_id);
      if (!creds) return json({ error: 'المحل ده مش مفعّل الدفع الأونلاين دلوقتي' }, 400);

      if (action === 'methods') {
        const r = await fawaterakCall(creds.mode, creds.secret.api_key, '/getPaymentmethods');
        const list = r.json?.status === 'success' && Array.isArray(r.json.data) ? r.json.data : null;
        if (!list) return json({ error: 'مقدرناش نجيب طرق الدفع من فواتيرك دلوقتي — جرّب كمان شوية' }, 502);
        return json({
          order: { code: order.code, total: order.total, currency: order.currency, shop_name: order.shop_name },
          methods: list.map((m: Record<string, unknown>) => ({
            id: Number(m.paymentId), name_ar: m.name_ar ?? m.name_en, name_en: m.name_en ?? m.name_ar,
            logo: typeof m.logo === 'string' && /^https:\/\//.test(m.logo) ? m.logo : null,
            redirect: String(m.redirect) === 'true',
          })).filter((m: { id: number }) => Number.isFinite(m.id) && m.id > 0),
        });
      }

      const methodId = Number(body.method_id);
      if (!Number.isInteger(methodId) || methodId <= 0) return json({ error: 'اختار طريقة الدفع' }, 400);
      const hook = `${SUPABASE_URL}/functions/v1/payments-webhook?shop=${order.shop_id}&provider=${PROVIDER}`;
      const r = await fawaterakCall(creds.mode, creds.secret.api_key, '/invoiceInitPay', invoiceBody(order, methodId, hook));
      const inv = readInitPay(r.json);
      if ('error' in inv) {
        console.error('invoiceInitPay', r.status, JSON.stringify(r.json).slice(0, 500));
        return json({ error: inv.error }, 502);
      }
      const att = await admin.rpc('payment_attach', {
        p_order: order.order_id, p_provider: PROVIDER, p_invoice_id: inv.invoice_id,
        p_invoice_key: inv.invoice_key, p_url: inv.redirect_to, p_data: inv.data,
      });
      if (att.error) console.error('payment_attach', att.error.message);
      return json({ redirect_to: inv.redirect_to, codes: inv.codes, expire_date: inv.expire_date });
    }

    if (action === 'status') {
      const { data: o, error } = await admin.rpc('payment_lookup', { p_code: code, p_phone: phone });
      if (error) return json({ error: 'تعذر قراءة الطلب' }, 500);
      if (!o) return json({ error: 'مفيش طلب بالرقم ده والموبايل ده' }, 404);
      if (o.payment_status === 'paid' || !o.invoice_id || o.provider !== PROVIDER) return json({ payment_status: o.payment_status });
      const creds = await credsOf(o.shop_id);
      if (!creds) return json({ payment_status: o.payment_status });
      const r = await fawaterakCall(creds.mode, creds.secret.api_key, '/getInvoiceData/' + encodeURIComponent(o.invoice_id));
      const inv = readInvoice(r.json);
      if (!inv || !inv.paid) return json({ payment_status: o.payment_status });
      const s = await admin.rpc('payment_settle', {
        p_shop: o.shop_id, p_provider: PROVIDER, p_invoice_id: o.invoice_id, p_paid: true,
        p_amount: inv.amount, p_currency: inv.currency, p_method: inv.method, p_code: o.code,
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
