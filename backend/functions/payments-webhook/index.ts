// Supabase Edge Function: `payments-webhook` — gateway callbacks (migration 0097, STUB)
//
// Each merchant pastes this URL in THEIR gateway dashboard
// (shown in متجري → «طرق الدفع» → the gateway's card):
//
//   https://<project>.supabase.co/functions/v1/payments-webhook?shop=<shop id>&provider=<paymob|kashier|tap|moyasar>
//
// The function checks the gateway's signature with the merchant's own
// secret (read with the service role through gateway_credentials()) and
// stores the event in shop_payment_events (record_shop_payment_event,
// duplicates ignored). It does NOT change orders yet — marking an order
// paid is Phase 4 (online checkout). Bad / missing signatures → 401 and
// nothing is stored.
//
//   Paymob  — "Transaction processed callback": ?hmac=… = HMAC-SHA512 (hex) of
//             the obj fields below, concatenated in this order, keyed with
//             the HMAC secret.
//   Kashier — header x-kashier-signature = HMAC-SHA256 (hex) of
//             "k1=v1&k2=v2…" over data.signatureKeys sorted, values
//             URL-encoded, keyed with the Payment API key.
//   Tap     — header hashstring = HMAC-SHA256 (hex) of
//             x_id…x_amount…x_currency…x_gateway_reference…x_payment_reference…x_status…x_created…
//             keyed with the secret key (amount with the currency's decimals).
//   Moyasar — the JSON body's secret_token = the token we show the merchant
//             (shop_payment_gateways.webhook_token) to paste when adding the webhook.
//   Fawaterak (0100 / 0101, API v3) — transactionHashKey in the body (see
//             verifyWebhook). Every transaction sends this URL itself
//             (redirectionUrls.webhookUrl); a paid one settles its order
//             (payment_settle) after re-reading it from Fawaterak.
//
// Deploy with JWT verification OFF (the gateways don't send a Supabase
// JWT; the signature is the check). The block between the sig markers is
// plain JavaScript; backend/tests/run.js (phase «tint») runs it in Node.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

// ----------------------------------------------------------------- sig:begin

async function hmacHex(algo = 'SHA-256', key = '', message = '') {
  const k = await crypto.subtle.importKey('raw', new TextEncoder().encode(key), { name: 'HMAC', hash: algo }, false, ['sign']);
  const sig = new Uint8Array(await crypto.subtle.sign('HMAC', k, new TextEncoder().encode(message)));
  let out = '';
  for (let i = 0; i < sig.length; i++) out += sig[i].toString(16).padStart(2, '0');
  return out;
}

// Constant-time compare of two strings.
function sameText(a = '', b = '') {
  if (typeof a !== 'string' || typeof b !== 'string' || a.length !== b.length || a.length === 0) return false;
  let d = 0;
  for (let i = 0; i < a.length; i++) d |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return d === 0;
}

function pick(obj = Object(), path = '') {
  let v = obj;
  for (const part of path.split('.')) v = v == null ? undefined : v[part];
  return v;
}

const PAYMOB_FIELDS = ['amount_cents', 'created_at', 'currency', 'error_occured', 'has_parent_transaction', 'id',
  'integration_id', 'is_3d_secure', 'is_auth', 'is_capture', 'is_refunded', 'is_standalone_payment', 'is_voided',
  'order.id', 'owner', 'pending', 'source_data.pan', 'source_data.sub_type', 'source_data.type', 'success'];

function paymobString(obj = Object()) {
  return PAYMOB_FIELDS.map((f) => {
    const v = pick(obj, f);
    return v === undefined || v === null ? '' : String(v);
  }).join('');
}

// query-string's strict encoding (what Kashier's sample uses).
function strictEncode(v = '') {
  return encodeURIComponent(v).replace(/[!'()*]/g, (c) => '%' + c.charCodeAt(0).toString(16).toUpperCase());
}

function kashierString(data = Object()) {
  const keys = Array.isArray(data.signatureKeys) ? [...data.signatureKeys].sort() : [];
  return keys.filter((k) => data[k] !== undefined).map((k) => strictEncode(k) + '=' + strictEncode(String(data[k]))).join('&');
}

const THREE_DECIMALS = new Set(['KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'LYD', 'TND']);
function tapString(o = Object()) {
  const cur = String(o.currency || '');
  const amount = Number(o.amount || 0).toFixed(THREE_DECIMALS.has(cur.toUpperCase()) ? 3 : 2);
  const ref = o.reference || {};
  const created = (o.transaction && o.transaction.created) || '';
  return 'x_id' + (o.id || '') + 'x_amount' + amount + 'x_currency' + cur + 'x_gateway_reference' + (ref.gateway || '') +
    'x_payment_reference' + (ref.payment || '') + 'x_status' + (o.status || '') + 'x_created' + created;
}

// → { ok, event_type, external_id }   (ok = the signature is valid)
async function verifyWebhook(provider = '', creds = Object(), body = Object(), headers = Object(), query = Object()) {
  const s = Object(creds.secret);
  switch (provider) {
    case 'paymob': {
      const obj = body.obj || {};
      if (!s.hmac_secret || !query.hmac) return { ok: false };
      const mine = await hmacHex('SHA-512', s.hmac_secret, paymobString(obj));
      return { ok: sameText(mine, String(query.hmac).toLowerCase()), event_type: String(body.type || 'TRANSACTION') + ':' + (obj.success ? 'success' : 'failed'), external_id: obj.id != null ? String(obj.id) : null };
    }
    case 'kashier': {
      const data = body.data || {};
      const sig = headers['x-kashier-signature'];
      if (!s.api_key || !sig) return { ok: false };
      const mine = await hmacHex('SHA-256', s.api_key, kashierString(data));
      return { ok: sameText(mine, String(sig).toLowerCase()), event_type: String(body.event || 'event') + ':' + String(data.status || ''), external_id: data.transactionId || data.merchantOrderId || null };
    }
    case 'tap': {
      const sig = headers['hashstring'];
      if (!s.secret_key || !sig) return { ok: false };
      const mine = await hmacHex('SHA-256', s.secret_key, tapString(body));
      return { ok: sameText(mine, String(sig).toLowerCase()), event_type: String(body.object || 'charge') + ':' + String(body.status || ''), external_id: body.id || null };
    }
    case 'moyasar': {
      return { ok: sameText(String(body.secret_token || ''), String(creds.webhook_token || '')), event_type: String(body.type || 'event'), external_id: body.id || (body.data && body.data.id) || null };
    }
    case 'fawaterak': {
      // Signed with the vendor API key, HMAC-SHA256 (hex):
      //   v3 paid / pending / failed — transactionHashKey (or hashKey) over
      //     "TransactionId=…&TransactionKey=…&PaymentMethod=…";
      //   cancelled (an expired Fawry / Aman code) — hashKey over "referenceId=…&PaymentMethod=…";
      //   legacy v2 invoices — hashKey over "InvoiceId=…&InvoiceKey=…&PaymentMethod=…".
      const sig = body.transactionHashKey || body.hashKey;
      if (!s.api_key || !sig) return { ok: false };
      let msg, event_type, external_id;
      if (body.transaction_key != null) {
        msg = 'TransactionId=' + (body.transaction_id ?? '') + '&TransactionKey=' + body.transaction_key + '&PaymentMethod=' + (body.payment_method ?? '');
        event_type = 'transaction:' + String(body.status || (body.errorMessage ? 'failed' : ''));
        external_id = String(body.transaction_key);
      } else if (body.invoice_id != null) {
        msg = 'InvoiceId=' + body.invoice_id + '&InvoiceKey=' + (body.invoice_key ?? '') + '&PaymentMethod=' + (body.payment_method ?? '');
        event_type = 'invoice:' + String(body.invoice_status || '');
        external_id = String(body.invoice_id);
      } else {
        msg = 'referenceId=' + (body.referenceId ?? '') + '&PaymentMethod=' + (body.paymentMethod ?? '');
        event_type = 'cancel:' + String(body.status || '');
        external_id = body.referenceId != null ? String(body.referenceId) : null;
      }
      const mine = await hmacHex('SHA-256', s.api_key, msg);
      return { ok: sameText(mine, String(sig).toLowerCase()), event_type, external_id };
    }
    default:
      return { ok: false };
  }
}
// ------------------------------------------------------------------- sig:end

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

// Re-reads the transaction from Fawaterak (API v3: OAuth token, then
// getTransactionData) and, when it is paid, settles its order
// (payment_settle checks the amount and currency against the order).
// A «pending» callback (a Fawry code was issued) changes nothing.
// → its status, or a reason.
async function settleFawaterak(shop: string, creds: Record<string, any>, intentKey: string, provider = 'fawaterak'): Promise<string> {
  try {
    const host = creds.mode === 'live' ? 'https://app.fawaterk.com' : 'https://staging.fawaterk.com';
    const tr = await fetch(host + '/oauth/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({ grant_type: 'client_credentials', client_id: creds.public?.client_id, client_secret: creds.secret?.client_secret }),
    });
    const token = (await tr.json().catch(() => null))?.access_token;
    if (!token) return 'token_refused';
    const r = await fetch(host + '/api/v3/getTransactionData', {
      method: 'POST',
      headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({ intent_key: intentKey }),
    });
    const j = await r.json().catch(() => null);
    const d = j?.status === 'success' ? j.data : null;
    if (!d) return 'transaction_unreadable';
    let pl = d.pay_load;
    if (typeof pl === 'string') {
      try { pl = JSON.parse(pl); } catch { pl = null; }
    }
    const paid = d.paid === 1 || d.paid === '1' || d.paid === true || d.status_text === 'paid';
    if (!paid) return 'not_paid';
    const cur = d.currency != null ? String(d.currency).toUpperCase() : null;
    const { data, error } = await admin.rpc('payment_settle', {
      p_shop: shop, p_provider: provider, p_invoice_id: intentKey, p_paid: true,
      p_amount: d.total != null ? Number(d.total) : null, p_currency: cur === 'SR' ? 'SAR' : cur,
      p_method: d.payment_method ?? null, p_code: pl?.order_code ?? null,
    });
    if (error) {
      console.error('payment_settle', error.message);
      return 'not_settled';
    }
    const fee = d.commission != null ? Number(d.commission) : d.financial_breakdown?.fees != null ? Number(d.financial_breakdown.fees) : null;
    if (fee != null && data?.status === 'paid') {
      await admin.rpc('payment_record_fee', { p_shop: shop, p_provider: provider, p_invoice_id: intentKey, p_fee: fee });
    }
    return data?.status ?? data?.reason ?? 'ok';
  } catch (e) {
    console.error('settleFawaterak', String(e));
    return 'unreachable';
  }
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// 0102 — ad tokens bought with the PLATFORM's Fawaterak account
// (?provider=fawaterak&target=tokens): signed with FAWATERAK_API_KEY, then
// the transaction is re-read with the platform's OAuth client and
// token_payment_settle credits the tokens.
const PLATFORM_FW = {
  mode: Deno.env.get('FAWATERAK_MODE') === 'live' ? 'live' : 'test',
  public: { client_id: Deno.env.get('FAWATERAK_CLIENT_ID') ?? '' },
  secret: { client_secret: Deno.env.get('FAWATERAK_CLIENT_SECRET') ?? '', api_key: Deno.env.get('FAWATERAK_API_KEY') ?? '' },
};

async function settlePlatformTokens(intentKey: string): Promise<string> {
  try {
    const c = PLATFORM_FW;
    const host = c.mode === 'live' ? 'https://app.fawaterk.com' : 'https://staging.fawaterk.com';
    const tr = await fetch(host + '/oauth/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({ grant_type: 'client_credentials', client_id: c.public.client_id, client_secret: c.secret.client_secret }),
    });
    const token = (await tr.json().catch(() => null))?.access_token;
    if (!token) return 'token_refused';
    const r = await fetch(host + '/api/v3/getTransactionData', {
      method: 'POST',
      headers: { 'Authorization': 'Bearer ' + token, 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify({ intent_key: intentKey }),
    });
    const d = (await r.json().catch(() => null))?.data;
    if (!d) return 'transaction_unreadable';
    const paid = d.paid === 1 || d.paid === '1' || d.paid === true || d.status_text === 'paid';
    if (!paid) return 'not_paid';
    const { data, error } = await admin.rpc('token_payment_settle', {
      p_intent: intentKey, p_paid: true, p_amount: d.total != null ? Number(d.total) : null,
      p_currency: d.currency ?? null, p_method: d.payment_method ?? null,
    });
    if (error) {
      console.error('token_payment_settle', error.message);
      return 'not_settled';
    }
    return data?.status ?? data?.reason ?? 'ok';
  } catch (e) {
    console.error('settlePlatformTokens', String(e));
    return 'unreachable';
  }
}

Deno.serve(async (req) => {
  const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  const url = new URL(req.url);

  // 0108 — a store order paid through the platform's account («اربط مع مُجتمعي»).
  if (url.searchParams.get('target') === 'platform_orders' && url.searchParams.get('provider') === 'fawaterak') {
    const shopId = url.searchParams.get('shop') ?? '';
    if (!UUID.test(shopId)) return json({ error: 'bad url' }, 400);
    const raw = await req.text();
    if (raw.length > 100_000) return json({ error: 'too large' }, 413);
    let b: Record<string, unknown>;
    try {
      b = JSON.parse(raw);
    } catch {
      return json({ error: 'invalid JSON' }, 400);
    }
    const v = await verifyWebhook('fawaterak', PLATFORM_FW, b, {}, {});
    if (!v.ok) return json({ error: 'bad signature' }, 401);
    if (b.transaction_key == null) return json({ received: true });
    return json({ received: true, settled: await settleFawaterak(shopId, PLATFORM_FW, String(b.transaction_key), 'mogtama3y') });
  }

  if (url.searchParams.get('target') === 'tokens' && url.searchParams.get('provider') === 'fawaterak') {
    const raw = await req.text();
    if (raw.length > 100_000) return json({ error: 'too large' }, 413);
    let b: Record<string, unknown>;
    try {
      b = JSON.parse(raw);
    } catch {
      return json({ error: 'invalid JSON' }, 400);
    }
    const v = await verifyWebhook('fawaterak', PLATFORM_FW, b, {}, {});
    if (!v.ok) return json({ error: 'bad signature' }, 401);
    if (b.transaction_key == null) return json({ received: true });
    return json({ received: true, settled: await settlePlatformTokens(String(b.transaction_key)) });
  }

  const shop = url.searchParams.get('shop') ?? '';
  const provider = url.searchParams.get('provider') ?? '';
  if (!UUID.test(shop) || !['paymob', 'kashier', 'tap', 'moyasar', 'fawaterak'].includes(provider)) return json({ error: 'bad url' }, 400);

  const raw = await req.text();
  if (raw.length > 100_000) return json({ error: 'too large' }, 413);
  let body: Record<string, unknown>;
  try {
    body = JSON.parse(raw);
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }

  const { data: creds, error } = await admin.rpc('gateway_credentials', { p_shop: shop, p_provider: provider });
  if (error) return json({ error: 'unavailable' }, 500);
  if (!creds) return json({ error: 'not connected' }, 404);

  const headers: Record<string, string> = {};
  req.headers.forEach((v, k) => { headers[k.toLowerCase()] = v; });
  const query = Object.fromEntries(url.searchParams.entries());
  const v = await verifyWebhook(provider, creds, body, headers, query);
  if (!v.ok) return json({ error: 'bad signature' }, 401);

  const rec = await admin.rpc('record_shop_payment_event', {
    p_shop: shop, p_provider: provider, p_event_type: v.event_type ?? null,
    p_external_id: v.external_id ?? null, p_signature_ok: true, p_payload: body,
  });
  if (rec.error) {
    console.error('record_shop_payment_event', rec.error.message);
    return json({ error: 'not stored' }, 500);
  }
  // Phase 4 (0100), Fawaterak: the order is settled from Fawaterak's own
  // copy of the invoice (getInvoiceData), never from the callback body.
  if (provider === 'fawaterak' && body.transaction_key != null) {
    const s = await settleFawaterak(shop, creds, String(body.transaction_key));
    return json({ received: true, settled: s });
  }
  // Other gateways: marking orders paid comes with their checkout.
  return json({ received: true });
});
