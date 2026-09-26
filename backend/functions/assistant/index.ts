// Supabase Edge Function: `assistant`
//
// The app's AI assistant goes through here instead of calling n8n
// directly, so the n8n webhook is never exposed and usage is capped.
//
// POST { action: 'chat', message, session_id }        ← from the app
//   → checks the user (guests allowed), applies a daily quota, adds the
//     user's name / phone / building as context, forwards to the n8n
//     "مُجتمعي – AI Assistant" workflow, returns { reply }.
//
// POST { action: 'ticket', user_id, summary }         ← from n8n only
//   (header X-Mogtama3y-Secret) → opens a support ticket for that user so
//   the owner can answer from the admin panel (reply arrives as an
//   in-app notification — migration 0040).
//
// Secrets: ASSISTANT_SHARED_SECRET (same value as the n8n webhook's
// header-auth credential). Deploy with JWT verification OFF.

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
const SHARED_SECRET = Deno.env.get('ASSISTANT_SHARED_SECRET') ?? '';
const N8N_URL = Deno.env.get('N8N_ASSISTANT_URL') ?? 'https://n8n.srv1967321.hstgr.cloud/webhook/mogtama3y-assistant';

const USER_DAILY_LIMIT = 60;
const GUEST_DAILY_LIMIT = 15;

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-mogtama3y-secret',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
}

async function currentUserId(req: Request): Promise<string | null> {
  const token = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  if (token.split('.').length !== 3) return null; // publishable key = guest
  const { data, error } = await admin.auth.getUser(token);
  return error ? null : data.user?.id ?? null;
}

async function withinQuota(bucket: string, limit: number): Promise<boolean> {
  const { data, error } = await admin.rpc('bump_places_usage', { p_bucket: bucket, p_limit: limit });
  if (error) throw new Error('quota check failed');
  return data === true;
}

// Name, phone and building of a signed-in user, for the agent's context
// and so a support hand-off tells the owner who to call back.
async function userContext(userId: string) {
  const { data: profile } = await admin.from('profiles').select('full_name, phone').eq('id', userId).maybeSingle();
  const { data: member } = await admin
    .from('union_members')
    .select('status, role, building:buildings(name, district)')
    .eq('user_id', userId)
    .eq('status', 'verified')
    .limit(1)
    .maybeSingle();
  const building = (member as any)?.building;
  return {
    name: profile?.full_name ?? '',
    phone: profile?.phone ?? '',
    building: building ? [building.name, building.district].filter(Boolean).join(' - ') : '',
    membership: member ? `${member.status}/${member.role}` : 'none',
  };
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  if (!SHARED_SECRET) return json({ error: 'ASSISTANT_SHARED_SECRET is not configured' }, 500);

  let payload: any;
  try {
    payload = await req.json();
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }

  try {
    // ---- called back by n8n: open a support ticket ----
    if (payload?.action === 'ticket') {
      if (req.headers.get('x-mogtama3y-secret') !== SHARED_SECRET) return json({ error: 'forbidden' }, 403);
      const userId = String(payload.user_id ?? '');
      const summary = String(payload.summary ?? '').trim().slice(0, 2000);
      if (!/^[0-9a-f-]{36}$/i.test(userId)) {
        return json({ ok: false, error: 'guest — ask them to sign in or use the contact number' });
      }
      const { error } = await admin.from('support_tickets').insert({
        user_id: userId,
        category: 'other',
        subject: 'طلب تواصل مع الدعم (من المساعد الذكي)',
        body: summary || 'المستخدم طلب التحدث مع أحد من فريق الدعم.',
      });
      if (error) throw new Error(error.message);
      return json({ ok: true });
    }

    // ---- from the app: chat ----
    const message = String(payload?.message ?? '').trim().slice(0, 1000);
    if (!message) return json({ error: 'empty message' }, 400);

    const userId = await currentUserId(req);
    const ip = (req.headers.get('x-forwarded-for') ?? '').split(',')[0].trim() || 'unknown';
    const allowed = userId
      ? await withinQuota(`assistant-user:${userId}`, USER_DAILY_LIMIT)
      : await withinQuota(`assistant-ip:${ip}`, GUEST_DAILY_LIMIT);
    if (!allowed) {
      return json({ reply: 'وصلت للحد اليومي للأسئلة. جرّب تاني بكرة، أو تواصل مع الدعم من «المزيد ← الدعم والمساعدة».' });
    }

    const context = userId ? await userContext(userId) : null;
    const sessionId = userId ?? `guest:${String(payload?.session_id ?? ip).slice(0, 64)}`;

    const res = await fetch(N8N_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'X-Mogtama3y-Secret': SHARED_SECRET },
      body: JSON.stringify({
        message,
        session_id: sessionId,
        user_id: userId,
        is_guest: !userId,
        user_name: context?.name ?? '',
        user_phone: context?.phone ?? '',
        user_building: context?.building ?? '',
        user_membership: context?.membership ?? 'none',
      }),
    });
    const body = await res.json().catch(() => null);
    const reply = typeof body?.reply === 'string' && body.reply.trim() ? body.reply.trim() : null;
    if (!res.ok || !reply) {
      return json({ reply: 'المساعد مش متاح دلوقتي، جرّب تاني بعد شوية.' }, 200);
    }
    return json({ reply });
  } catch (e) {
    return json({ reply: 'حصلت مشكلة، جرّب تاني بعد شوية.', error: e instanceof Error ? e.message : 'unexpected' }, 200);
  }
});
