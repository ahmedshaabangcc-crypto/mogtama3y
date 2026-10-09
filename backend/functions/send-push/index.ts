// Supabase Edge Function: `send-push`
//
// Called by the database (trigger notifications_push → pg_net, migration
// 0055) for every new in-app notification: sends it as a Web Push to all
// of that user's registered devices, and forgets devices the browser says
// are gone (404/410).
//
// POST body: { notification_id }, header x-push-secret: PUSH_SECRET.
// Secrets: VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY, PUSH_SECRET.
// Deploy with JWT verification OFF (the shared secret authenticates).

import { createClient } from 'npm:@supabase/supabase-js@2';
import webpush from 'npm:web-push@3.6.7';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
const PUSH_SECRET = Deno.env.get('PUSH_SECRET') ?? '';
const VAPID_PUBLIC = Deno.env.get('VAPID_PUBLIC_KEY') ?? '';
const VAPID_PRIVATE = Deno.env.get('VAPID_PRIVATE_KEY') ?? '';

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

// Where tapping the notification opens, per app the device registered from.
const APP_URL: Record<string, string> = {
  tajer: 'https://tajer.mogtama3y.com/',
  ittihad: 'https://ittihad.mogtama3y.com/',
  masjid: 'https://masjidi.mogtama3y.com/',
  mogtama3y: 'https://mogtama3y.com/',
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}

Deno.serve(async (req) => {
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  if (!PUSH_SECRET || req.headers.get('x-push-secret') !== PUSH_SECRET) return json({ error: 'forbidden' }, 403);
  if (!VAPID_PUBLIC || !VAPID_PRIVATE) return json({ error: 'VAPID keys are not configured' }, 500);

  let id: string | undefined;
  try {
    id = (await req.json())?.notification_id;
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }
  if (!id) return json({ error: 'notification_id required' }, 400);

  const { data: n } = await admin.from('notifications').select('user_id, title, body, deep_link').eq('id', id).maybeSingle();
  if (!n) return json({ sent: 0 });

  const { data: subs } = await admin.from('push_subscriptions').select('id, endpoint, p256dh, auth, app').eq('user_id', n.user_id);
  if (!subs?.length) return json({ sent: 0 });

  webpush.setVapidDetails('mailto:no-reply@mogtama3y.com', VAPID_PUBLIC, VAPID_PRIVATE);

  let sent = 0;
  const gone: string[] = [];
  await Promise.all(subs.map(async (s) => {
    const url = APP_URL[s.app ?? ''] ?? APP_URL.mogtama3y;
    const payload = JSON.stringify({
      title: n.title,
      body: n.body ?? '',
      url: n.deep_link ? new URL(n.deep_link, url).toString() : url,
    });
    try {
      await webpush.sendNotification({ endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } }, payload, { TTL: 86400, urgency: 'high' });
      sent++;
    } catch (e: any) {
      if (e?.statusCode === 404 || e?.statusCode === 410) gone.push(s.id);
      else console.error('push failed', e?.statusCode, e?.body);
    }
  }));
  if (gone.length) await admin.from('push_subscriptions').delete().in('id', gone);
  return json({ sent, removed: gone.length });
});
