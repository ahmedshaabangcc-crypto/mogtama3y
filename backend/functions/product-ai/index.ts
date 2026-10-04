// Supabase Edge Function: `product-ai`
//
// The merchant's AI copywriter: looks at the product photos (and whatever
// the merchant typed) and suggests a product name, a professional
// description and short selling points, in Egyptian Arabic.
//
// POST body: { image_urls?: string[] (max 3, our public storage only),
//              name?: string, category?: string, notes?: string }
// → { name, description, highlights: string[] }
//
// Signed-in shop owners only; 30 suggestions per user per day — checked by
// bump_my_ai_usage() (migration 0056) running as the merchant, so no
// service-role key is needed. The Gemini key
// lives only in the GEMINI_API_KEY secret.
//
// Deploy with JWT verification OFF (the function checks the user itself).

import { createClient } from 'npm:@supabase/supabase-js@2';

const GEMINI_KEY = Deno.env.get('GEMINI_API_KEY') ?? '';
const GEMINI_MODEL = Deno.env.get('GEMINI_MODEL') ?? 'gemini-3.6-flash';
const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const DAILY_LIMIT = 30;

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
}

// A client acting as the merchant (their own session token).
function userClient(req: Request) {
  const token = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  if (token.split('.').length !== 3) return null;
  return createClient(SUPABASE_URL, ANON_KEY, {
    auth: { persistSession: false },
    global: { headers: { Authorization: `Bearer ${token}` } },
  });
}

const clip = (v: unknown, n: number) => (typeof v === 'string' ? v.trim().slice(0, n) : '');

// Only photos already uploaded to this project's public storage.
function isOurImage(url: string): boolean {
  return url.startsWith(`${SUPABASE_URL}/storage/v1/object/public/`);
}

function toBase64(bytes: Uint8Array): string {
  let s = '';
  for (let i = 0; i < bytes.length; i += 0x8000) s += String.fromCharCode(...bytes.subarray(i, i + 0x8000));
  return btoa(s);
}

const PROMPT = `إنت كاتب محتوى محترف لمتاجر أونلاين في مصر.
اكتب لمنتج في متجر محل صغير على منصة "مُجتمعي". بص على صور المنتج (لو موجودة) وعلى بيانات التاجر.
القواعد:
- بالعربي المصري البسيط المحترم، من غير مبالغة أو ادعاءات مش ظاهرة في الصور أو البيانات.
- ماتخترعش ماركة أو مقاس أو خامة أو سعر مش واضحين. لو مش متأكد سيبها عامة.
- name: اسم قصير واضح للمنتج (2 لـ 6 كلمات).
- description: وصف من 2 لـ 4 جمل يشجع على الشراء ويوضح الاستخدام.
- highlights: من 3 لـ 5 مميزات قصيرة جداً (كل واحدة 2 لـ 5 كلمات).
رجّع JSON بس بالشكل: {"name": "...", "description": "...", "highlights": ["...", "..."]}`;

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  if (!GEMINI_KEY) return json({ error: 'GEMINI_API_KEY is not configured' }, 500);

  let payload: any;
  try {
    payload = await req.json();
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }

  try {
    const db = userClient(req);
    if (!db) return json({ error: 'يجب تسجيل الدخول أولاً' }, 401);

    const { data: gate, error: gErr } = await db.rpc('bump_my_ai_usage');
    if (gErr) {
      console.error('bump_my_ai_usage', gErr);
      const expired = /jwt/i.test(gErr.message);
      return json({ error: expired ? 'سجّل دخول تاني وجرّب' : 'حصلت مشكلة، جرّب تاني' }, expired ? 401 : 500);
    }
    if (gate === 'signed_out') return json({ error: 'يجب تسجيل الدخول أولاً' }, 401);
    if (gate === 'no_shop') return json({ error: 'الخدمة دي للتجار اللي مسجلين محل' }, 403);
    if (gate !== 'ok') return json({ error: `خلصت اقتراحات النهارده (${DAILY_LIMIT} اقتراح)، جرّب بكرة` }, 429);

    const parts: any[] = [];
    const urls: string[] = Array.isArray(payload.image_urls) ? payload.image_urls.filter((u: unknown) => typeof u === 'string').slice(0, 3) : [];
    for (const url of urls) {
      if (!isOurImage(url)) continue;
      const res = await fetch(url);
      if (!res.ok) continue;
      const type = res.headers.get('content-type') ?? 'image/jpeg';
      const bytes = new Uint8Array(await res.arrayBuffer());
      if (!type.startsWith('image/') || bytes.length > 6_000_000) continue;
      parts.push({ inline_data: { mime_type: type, data: toBase64(bytes) } });
    }

    const facts = [
      clip(payload.name, 120) && `الاسم اللي كتبه التاجر: ${clip(payload.name, 120)}`,
      clip(payload.category, 60) && `نشاط المحل: ${clip(payload.category, 60)}`,
      clip(payload.notes, 600) && `ملاحظات التاجر: ${clip(payload.notes, 600)}`,
    ].filter(Boolean).join('\n');
    if (parts.length === 0 && !facts) return json({ error: 'صوّر المنتج أو اكتب اسمه الأول' }, 400);

    parts.push({ text: `${PROMPT}\n\n${facts || 'مفيش بيانات غير الصور.'}` });

    const gem = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_KEY}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ role: 'user', parts }],
        generationConfig: { temperature: 0.5, maxOutputTokens: 700, responseMimeType: 'application/json' },
      }),
    });
    if (!gem.ok) {
      console.error('gemini', gem.status, await gem.text());
      return json({ error: 'الذكاء الاصطناعي مش متاح دلوقتي، جرّب كمان شوية' }, 502);
    }
    const out = await gem.json();
    const text: string = out?.candidates?.[0]?.content?.parts?.map((p: any) => p.text ?? '').join('') ?? '';
    let parsed: any;
    try {
      parsed = JSON.parse(text.replace(/^```(json)?|```$/g, '').trim());
    } catch {
      return json({ error: 'معرفناش نطلع اقتراح، جرّب تاني' }, 502);
    }
    return json({
      name: clip(parsed.name, 80),
      description: clip(parsed.description, 1200),
      highlights: (Array.isArray(parsed.highlights) ? parsed.highlights : []).map((h: unknown) => clip(h, 50)).filter(Boolean).slice(0, 5),
    });
  } catch (e) {
    console.error(e);
    return json({ error: 'حصلت مشكلة، جرّب تاني' }, 500);
  }
});
