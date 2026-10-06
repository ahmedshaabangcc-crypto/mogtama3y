// Supabase Edge Function: `verify-phone`
//
// Marks the signed-in user's mobile number as verified (migration 0074).
// The app proves the number with Firebase Phone Auth (Firebase sends and
// checks the SMS code) and sends us the resulting Firebase ID token. We
// check that token's signature against Google's public keys — no secret
// needed — and take the number from it, never from the request body.
//
// POST body: { id_token }      Authorization: the user's Supabase session
// Returns:   { ok: true, phone: '01XXXXXXXXX' }
//
// Deploy with JWT verification OFF (the function checks the user itself).

import { createClient } from 'npm:@supabase/supabase-js@2';
import { createRemoteJWKSet, jwtVerify } from 'npm:jose@5';

const FIREBASE_PROJECT_ID = 'mogtama3y-dad8d';
const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

const googleKeys = createRemoteJWKSet(
  new URL('https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com'),
);

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
}

async function currentUserId(req: Request): Promise<string | null> {
  const token = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  if (token.split('.').length !== 3) return null;
  const { data, error } = await admin.auth.getUser(token);
  return error ? null : data.user?.id ?? null;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);

  const userId = await currentUserId(req);
  if (!userId) return json({ error: 'سجّل دخول الأول' }, 401);

  let idToken = '';
  try {
    idToken = String((await req.json())?.id_token ?? '');
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }
  if (idToken.split('.').length !== 3) return json({ error: 'كود التأكيد ناقص' }, 400);

  let phoneE164: string;
  try {
    const { payload } = await jwtVerify(idToken, googleKeys, {
      issuer: `https://securetoken.google.com/${FIREBASE_PROJECT_ID}`,
      audience: FIREBASE_PROJECT_ID,
    });
    // Only a fresh sign-in counts (the code was just typed).
    const authTime = Number(payload.auth_time ?? 0);
    if (!authTime || Date.now() / 1000 - authTime > 15 * 60) return json({ error: 'التأكيد قديم، ابعت كود جديد' }, 400);
    phoneE164 = String(payload.phone_number ?? '');
  } catch {
    return json({ error: 'كود التأكيد مش صحيح' }, 400);
  }

  const m = phoneE164.match(/^\+20(1[0125]\d{8})$/);
  if (!m) return json({ error: 'الرقم لازم يكون موبايل مصري' }, 400);
  const phone = '0' + m[1];

  const { error } = await admin.rpc('confirm_phone_verified', { p_user: userId, p_phone: phone });
  if (error) return json({ error: 'تعذر حفظ التأكيد، جرّب تاني' }, 500);
  return json({ ok: true, phone });
});
