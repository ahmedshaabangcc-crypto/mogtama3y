// Supabase Edge Function: `send-push`
//
// Called by the database (trigger notifications_push → pg_net, migrations
// 0055 / 0090) for every new in-app notification: sends it as a Web Push
// to all of that user's registered devices, and forgets devices the push
// service says are gone (404/410).
//
// POST body (0090): { notification_id, notification: {user_id, title, body,
// deep_link}, subscriptions: [{id, endpoint, p256dh, auth, app}] } — the
// trigger sends everything, so no table read is needed. Older triggers
// (0055) send only { notification_id }; then the function reads the rows
// with the service role (needs the 0090 grants).
// Header x-push-secret: PUSH_SECRET.
// Secrets: VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY, PUSH_SECRET.
// Deploy with JWT verification OFF (the shared secret authenticates).
//
// Every answer says why — read it in SQL:
//   select created, status_code, content from net._http_response order by created desc limit 20;
//   {sent, total, reason?, failures: [{status, app, host, body}], removed, error?}
// reason: 'no_notification' | 'no_subscriptions' | 'db_error' | 'all_failed'.

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

type Note = { user_id: string; title: string; body?: string | null; deep_link?: string | null };
type Sub = { id: string; endpoint: string; p256dh: string; auth: string; app?: string | null };

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}

function host(endpoint: string) {
  try {
    return new URL(endpoint).host;
  } catch {
    return '?';
  }
}

Deno.serve(async (req) => {
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  if (!PUSH_SECRET || req.headers.get('x-push-secret') !== PUSH_SECRET) return json({ sent: 0, reason: 'forbidden' }, 403);
  if (!VAPID_PUBLIC || !VAPID_PRIVATE) return json({ sent: 0, reason: 'no_vapid_keys' }, 500);

  let input: { notification_id?: string; notification?: Note; subscriptions?: Sub[] };
  try {
    input = (await req.json()) ?? {};
  } catch {
    return json({ sent: 0, reason: 'invalid_json' }, 400);
  }

  let n: Note | null = input.notification?.user_id && input.notification?.title ? input.notification : null;
  let subs: Sub[] | null = Array.isArray(input.subscriptions) ? input.subscriptions : null;

  if (!n) {
    if (!input.notification_id) return json({ sent: 0, reason: 'notification_id_required' }, 400);
    const { data, error } = await admin.from('notifications').select('user_id, title, body, deep_link')
      .eq('id', input.notification_id).maybeSingle();
    if (error) {
      console.error('send-push: reading the notification failed', error.code, error.message);
      return json({ sent: 0, reason: 'db_error', error: `notifications: ${error.code ?? ''} ${error.message}` });
    }
    if (!data) return json({ sent: 0, reason: 'no_notification' });
    n = data as Note;
  }
  if (!subs) {
    const { data, error } = await admin.from('push_subscriptions').select('id, endpoint, p256dh, auth, app').eq('user_id', n.user_id);
    if (error) {
      console.error('send-push: reading the devices failed', error.code, error.message);
      return json({ sent: 0, reason: 'db_error', error: `push_subscriptions: ${error.code ?? ''} ${error.message}` });
    }
    subs = (data ?? []) as Sub[];
  }
  if (!subs.length) return json({ sent: 0, total: 0, reason: 'no_subscriptions' });

  webpush.setVapidDetails('mailto:no-reply@mogtama3y.com', VAPID_PUBLIC, VAPID_PRIVATE);

  // A prayer reminder is useless hours late; anything else may wait a day.
  const ttl = (n.deep_link ?? '').includes('/masjid/tools/reminders') ? 1800 : 86400;
  let sent = 0;
  const gone: string[] = [];
  const failures: { status: number | null; app: string | null; host: string; body: string }[] = [];
  await Promise.all(subs.map(async (s) => {
    const base = APP_URL[s.app ?? ''] ?? APP_URL.mogtama3y;
    const url = n!.deep_link ? new URL(n!.deep_link, base).toString() : base;
    const payload = JSON.stringify({ title: n!.title, body: n!.body ?? '', url });
    try {
      await webpush.sendNotification({ endpoint: s.endpoint, keys: { p256dh: s.p256dh, auth: s.auth } }, payload, { TTL: ttl, urgency: 'high' });
      sent++;
    } catch (e: any) {
      const status = typeof e?.statusCode === 'number' ? e.statusCode : null;
      if (status === 404 || status === 410) gone.push(s.id);
      const body = String(e?.body ?? e?.message ?? e).slice(0, 300);
      failures.push({ status, app: s.app ?? null, host: host(s.endpoint), body });
      console.error('send-push: push failed', status, s.app, host(s.endpoint), body);
    }
  }));

  let cleanupError: string | undefined;
  if (gone.length) {
    const { error } = await admin.from('push_subscriptions').delete().in('id', gone);
    if (error) {
      cleanupError = `${error.code ?? ''} ${error.message}`;
      console.error('send-push: removing gone devices failed', cleanupError);
    }
  }
  return json({
    sent,
    total: subs.length,
    ...(sent === 0 ? { reason: 'all_failed' } : {}),
    failures,
    removed: cleanupError ? 0 : gone.length,
    ...(cleanupError ? { cleanup_error: cleanupError } : {}),
  });
});
