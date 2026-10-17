// Supabase Edge Function: `domains-verify` — «تحقق دلوقتي» (migration 0097)
//
// متجري → «الربط والتكاملات» → «الدومين»: the merchant adds their domain
// (add_shop_domain) and creates two DNS records at their registrar:
//   TXT   _mogtama3y-verify.<host>  =  <verify_token>         (always)
//   CNAME <host> → stores.mogtama3y.com                       (subdomains, e.g. shop.example.com)
//   (a root domain like example.com can't have a CNAME: A/ALIAS records
//    come with Phase 5 — we recommend www.example.com instead)
//
// POST { shop }    Authorization: Bearer <Supabase JWT>
//   → { status, txt_ok, cname_ok, message, domain }
//
// integration_rate_hit(shop, 'domain_verify') AS the user (ownership + 12
// checks an hour), the domain row AS the user (RLS: owner only), DNS with
// Deno.resolveDns, then domain_record_check() with the service role.
// «verified» means ownership is proven; SERVING the store on the domain is
// turned on by the platform in Phase 5 (Cloudflare for SaaS) → «active».
//
// Deploy with JWT verification OFF (the function checks the user itself).
// The block between the dns markers is plain JavaScript; backend/tests/run.js
// (phase «tint») runs it in Node.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

// ----------------------------------------------------------------- dns:begin
const CNAME_TARGET = 'stores.mogtama3y.com';

function bareHost(h = '') {
  return String(h).trim().toLowerCase().replace(/\.+$/, '');
}

// txt: string[][] (chunks per record) or null; cname: string[] or null.
// → { txtOk, cnameOk, message }
function evaluateDns(domain = Object(), txt = Object([]), cname = Object([])) {
  const records = (txt || []).map((chunks) => (Array.isArray(chunks) ? chunks.join('') : String(chunks)).trim());
  const txtOk = records.some((r) => r === domain.verify_token || r === '"' + domain.verify_token + '"');
  const cnameOk = (cname || []).some((c) => bareHost(c) === CNAME_TARGET);
  let message;
  if (txtOk && (domain.is_apex || cnameOk)) {
    message = 'اتأكدنا إن الدومين بتاعك ✓ — تشغيل المتجر عليه هيتفعّل قريباً';
  } else if (!txtOk && !domain.is_apex && !cnameOk) {
    message = 'لسه مش لاقيين سجل الـ TXT ولا الـ CNAME — لو لسه ضايفهم استنى من 10 دقايق لساعة وجرّب تاني';
  } else if (!txtOk) {
    message = 'لسه مش لاقيين سجل الـ TXT (_mogtama3y-verify) بالقيمة الصح';
  } else {
    message = (cname && cname.length)
      ? 'الـ TXT تمام ✓ بس الـ CNAME بيشاور على ' + bareHost(cname[0]) + ' — لازم يشاور على ' + CNAME_TARGET
      : 'الـ TXT تمام ✓ فاضل سجل الـ CNAME → ' + CNAME_TARGET;
  }
  return { txtOk, cnameOk, message };
}
// ------------------------------------------------------------------- dns:end

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

async function resolve(name: string, type: 'TXT' | 'CNAME'): Promise<unknown[] | null> {
  try {
    // deno-lint-ignore no-explicit-any
    return await (Deno.resolveDns as any)(name, type, { nameServer: { ipAddr: '1.1.1.1', port: 53 } });
  } catch {
    return null; // NXDOMAIN / no such record / timeout
  }
}

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
  if (!UUID.test(shop)) return json({ error: 'بيانات ناقصة' }, 400);

  const asUser = createClient(SUPABASE_URL, ANON_KEY, {
    auth: { persistSession: false },
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });
  const hit = await asUser.rpc('integration_rate_hit', { p_shop: shop, p_kind: 'domain_verify' });
  if (hit.error) return json({ error: hit.error.message }, hit.error.code === '42501' ? 403 : 429);

  const { data: domain } = await asUser.from('shop_domains').select('hostname, is_apex, verify_token, status').eq('shop_id', shop).maybeSingle();
  if (!domain) return json({ error: 'ضيف الدومين الأول' }, 404);

  const txt = (await resolve(`_mogtama3y-verify.${domain.hostname}`, 'TXT')) as string[][] | null;
  const cname = domain.is_apex ? null : ((await resolve(domain.hostname, 'CNAME')) as string[] | null);
  const r = evaluateDns(domain, txt, cname);

  const { data: row, error } = await admin.rpc('domain_record_check', {
    p_shop: shop, p_txt_ok: r.txtOk, p_cname_ok: r.cnameOk, p_error: r.txtOk && (domain.is_apex || r.cnameOk) ? null : r.message,
  });
  if (error) return json({ error: 'تعذر حفظ النتيجة' }, 500);
  return json({ status: row?.status, txt_ok: r.txtOk, cname_ok: r.cnameOk, message: r.message, domain: row });
});
