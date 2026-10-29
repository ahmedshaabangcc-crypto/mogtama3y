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
//   Fawaterak (0100) — hashKey in the body (see verifyWebhook). Every invoice
//             sends this URL itself (redirectionUrls.webhookUrl); a paid
//             invoice settles its order (payment_settle).
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
      // Paid: hashKey = HMAC-SHA256(api key, "InvoiceId=…&InvoiceKey=…&PaymentMethod=…").
      // Cancelled (an expired Fawry / Aman code): "referenceId=…&PaymentMethod=…".
      // Failed / refund callbacks carry no hashKey → refused (nothing to do for them).
      if (!s.api_key || !body.hashKey) return { ok: false };
      const paid = body.invoice_id != null;
      const msg = paid
        ? 'InvoiceId=' + body.invoice_id + '&InvoiceKey=' + (body.invoice_key ?? '') + '&PaymentMethod=' + (body.payment_method ?? '')
        : 'referenceId=' + (body.referenceId ?? '') + '&PaymentMethod=' + (body.paymentMethod ?? '');
      const mine = await hmacHex('SHA-256', s.api_key, msg);
      return {
        ok: sameText(mine, String(body.hashKey).toLowerCase()),
        event_type: paid ? 'invoice:' + String(body.invoice_status || '') : 'cancel:' + String(body.status || ''),
        external_id: paid ? String(body.invoice_id) : (body.referenceId != null ? String(body.referenceId) : null),
      };
    }
    default:
      return { ok: false };
  }
}
// ------------------------------------------------------------------- sig:end

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

// Re-reads the invoice from Fawaterak and settles its order (payment_settle
// checks the amount and currency against the order). → its status, or a reason.
async function settleFawaterak(shop: string, creds: Record<string, any>, invoiceId: string): Promise<string> {
  try {
    const base = creds.mode === 'live' ? 'https://app.fawaterk.com' : 'https://staging.fawaterk.com';
    const r = await fetch(base + '/api/v2/getInvoiceData/' + encodeURIComponent(invoiceId), {
      headers: { 'Authorization': 'Bearer ' + creds.secret?.api_key, 'Accept': 'application/json' },
    });
    const j = await r.json().catch(() => null);
    const d = j?.status === 'success' ? j.data : null;
    if (!d) return 'invoice_unreadable';
    let pl = d.pay_load;
    if (typeof pl === 'string') {
      try { pl = JSON.parse(pl); } catch { pl = null; }
    }
    const paid = d.paid === 1 || d.paid === '1' || d.paid === true;
    const { data, error } = await admin.rpc('payment_settle', {
      p_shop: shop, p_provider: 'fawaterak', p_invoice_id: invoiceId, p_paid: paid,
      p_amount: d.total != null ? Number(d.total) : null, p_currency: d.currency ?? null,
      p_method: d.payment_method ?? null, p_code: pl?.order_code ?? null,
    });
    if (error) {
      console.error('payment_settle', error.message);
      return 'not_settled';
    }
    return data?.status ?? data?.reason ?? 'ok';
  } catch (e) {
    console.error('settleFawaterak', String(e));
    return 'unreachable';
  }
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

Deno.serve(async (req) => {
  const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  const url = new URL(req.url);
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
  if (provider === 'fawaterak' && body.invoice_id != null) {
    const s = await settleFawaterak(shop, creds, String(body.invoice_id));
    return json({ received: true, settled: s });
  }
  // Other gateways: marking orders paid comes with their checkout.
  return json({ received: true });
});
