// Supabase Edge Function: `livekit-token` — «دروس أونلاين» (migration 0085)
//
// The live-lesson page (web/live/) calls this with the user's Supabase
// session. Every decision is the database's: we call the 0085 RPCs AS the
// user (masjid_live_join_check / _hand / _set_speaker / _remove / _start /
// _end / _host_room), then talk to LiveKit Cloud with the API secret,
// which never leaves the server.
//
// POST { action, session, ... }       Authorization: Bearer <Supabase JWT>
//   join   (default) → { token, url, role, identity, name, can_speak, session }
//                       403 { error, reason, session? } when refused
//   start            → the host starts a scheduled lesson (then joins)
//   end              → the host ends it; the LiveKit room is closed
//   hand   { raise } → a listener raises / lowers a hand (verified phone)
//   hands            → host: raised hands + speakers
//   speaker { participant, speaker } → host promotes / demotes (LiveKit
//                       UpdateParticipant: canPublish on / off)
//   remove { participant } → host removes someone (RemoveParticipant)
//   mute   { participant, track_sid } → host mutes one published track
//
// Secrets (Edge Functions → Secrets): LIVEKIT_URL (wss://<project>.livekit.cloud),
// LIVEKIT_API_KEY, LIVEKIT_API_SECRET. SUPABASE_URL / SUPABASE_ANON_KEY /
// SUPABASE_SERVICE_ROLE_KEY are provided by Supabase.
// Deploy with JWT verification OFF (the function checks the user itself).
// Zero dependencies besides supabase-js: the LiveKit token is an HS256
// JWT signed with Web Crypto (see the block between the jwt markers —
// backend/tests/run.js tests that exact code in Node, phase «mlive»).

import { createClient } from 'npm:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
const LIVEKIT_URL = Deno.env.get('LIVEKIT_URL') ?? '';
const LIVEKIT_API_KEY = Deno.env.get('LIVEKIT_API_KEY') ?? '';
const LIVEKIT_API_SECRET = Deno.env.get('LIVEKIT_API_SECRET') ?? '';

const TOKEN_TTL_SECONDS = 2 * 60 * 60;

// ----------------------------------------------------------------- jwt:begin
// Valid JavaScript AND TypeScript (types come from the default values), so
// Node runs this exact block in the tests.

function b64url(bytes = new Uint8Array(0)) {
  let s = '';
  for (let i = 0; i < bytes.length; i++) s += String.fromCharCode(bytes[i]);
  return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

function b64urlJson(obj = {}) {
  return b64url(new TextEncoder().encode(JSON.stringify(obj)));
}

// HS256 JWT over { alg, typ } + payload, signed with Web Crypto.
async function signJwtHs256(payload = {}, secret = '') {
  const data = b64urlJson({ alg: 'HS256', typ: 'JWT' }) + '.' + b64urlJson(payload);
  const key = await crypto.subtle.importKey('raw', new TextEncoder().encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const sig = new Uint8Array(await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(data)));
  return data + '.' + b64url(sig);
}

// LiveKit video grant for a role in a lesson. Only hosts and speakers
// publish; audio lessons publish the microphone only. Everyone may send
// data (chat, hand raise) and subscribe; hosts are room admins.
function liveKitGrant(role = 'listener', mode = 'audio', room = '') {
  const publisher = role === 'host' || role === 'speaker';
  return {
    room: room,
    roomJoin: true,
    canSubscribe: true,
    canPublish: publisher,
    canPublishData: true,
    canUpdateOwnMetadata: false,
    canPublishSources: publisher ? (mode === 'video' ? ['camera', 'microphone', 'screen_share', 'screen_share_audio'] : ['microphone']) : undefined,
    roomAdmin: role === 'host' ? true : undefined,
  };
}

// A LiveKit access token (https://docs.livekit.io/home/get-started/authentication/):
// iss = API key, sub = identity, video = grant, HS256 with the API secret.
async function liveKitToken(apiKey = '', apiSecret = '', identity = '', name = '', grant = {}, ttl = 7200, metadata = '', nowMs = 0) {
  const now = Math.floor((nowMs || Date.now()) / 1000);
  return signJwtHs256({
    iss: apiKey,
    sub: identity,
    jti: identity + '-' + now,
    nbf: now - 10,
    iat: now,
    exp: now + ttl,
    name: name,
    metadata: metadata || undefined,
    video: grant,
  }, apiSecret);
}
// ------------------------------------------------------------------- jwt:end

const ALLOWED_ORIGINS = new Set([
  'https://mogtama3y.com',
  'https://www.mogtama3y.com',
  'https://masjidi.mogtama3y.com',
]);

function corsFor(req: Request): Record<string, string> {
  const origin = req.headers.get('Origin') ?? '';
  const ok = ALLOWED_ORIGINS.has(origin) || /^http:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin);
  return {
    'Access-Control-Allow-Origin': ok ? origin : 'https://masjidi.mogtama3y.com',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Vary': 'Origin',
  };
}

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

async function currentUserId(token: string): Promise<string | null> {
  if (token.split('.').length !== 3) return null;
  const { data, error } = await admin.auth.getUser(token);
  return error ? null : data.user?.id ?? null;
}

// LiveKit server API (Twirp, JSON) with a short-lived admin token.
async function roomService(method: string, room: string, body: Record<string, unknown>, extraGrant: Record<string, unknown> = {}) {
  const token = await liveKitToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET, 'mogtama3y-server', 'server',
    { room, roomAdmin: true, ...extraGrant }, 120);
  const host = LIVEKIT_URL.replace(/^wss:/, 'https:').replace(/^ws:/, 'http:').replace(/\/+$/, '');
  const res = await fetch(`${host}/twirp/livekit.RoomService/${method}`, {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error(`livekit ${method} ${res.status}: ${(await res.text()).slice(0, 200)}`);
  return res.json().catch(() => ({}));
}

function publisherPermission(speaker: boolean, mode: string) {
  return {
    canSubscribe: true,
    canPublish: speaker,
    canPublishData: true,
    canPublishSources: speaker ? (mode === 'video' ? ['CAMERA', 'MICROPHONE', 'SCREEN_SHARE', 'SCREEN_SHARE_AUDIO'] : ['MICROPHONE']) : [],
  };
}

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

Deno.serve(async (req) => {
  const cors = corsFor(req);
  const json = (body: unknown, status = 200) =>
    new Response(JSON.stringify(body), { status, headers: { ...cors, 'Content-Type': 'application/json' } });

  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  if (!LIVEKIT_URL || !LIVEKIT_API_KEY || !LIVEKIT_API_SECRET) {
    return json({ error: 'الدروس الأونلاين لسه مش متفعّلة', reason: 'not_configured' }, 503);
  }

  const jwt = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  const userId = await currentUserId(jwt);
  if (!userId) return json({ error: 'سجّل دخول الأول', reason: 'sign_in' }, 401);

  let body: Record<string, unknown>;
  try {
    body = (await req.json()) ?? {};
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }
  const action = String(body.action ?? 'join');
  const session = String(body.session ?? '');
  if (!UUID.test(session)) return json({ error: 'الدرس مش موجود', reason: 'not_found' }, 400);

  // The user's own client: auth.uid() in the RPCs is this user.
  const asUser = createClient(SUPABASE_URL, ANON_KEY, {
    auth: { persistSession: false },
    global: { headers: { Authorization: `Bearer ${jwt}` } },
  });
  const rpc = async (fn: string, params: Record<string, unknown>) => {
    const { data, error } = await asUser.rpc(fn, params);
    if (error) throw Object.assign(new Error(error.message), { hint: error.hint, db: true });
    return data;
  };

  try {
    switch (action) {
      case 'join': {
        const check = await rpc('masjid_live_join_check', { p_session: session });
        if (!check?.ok) return json({ error: check?.message ?? 'مينفعش تدخل الدرس', reason: check?.reason, is_host: check?.is_host === true, session: check?.session }, 403);
        const s = check.session;
        if (check.role === 'host') {
          // Create the room with the lesson's limit (it may already exist).
          try {
            await roomService('CreateRoom', check.room, {
              name: check.room,
              max_participants: s.max_participants,
              empty_timeout: 600,
              departure_timeout: 120,
            }, { roomCreate: true });
          } catch (e) {
            console.error('CreateRoom', String(e));
          }
        }
        const token = await liveKitToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET, check.identity, check.name,
          liveKitGrant(check.role, s.mode, check.room), TOKEN_TTL_SECONDS, JSON.stringify({ role: check.role }));
        return json({
          token,
          url: LIVEKIT_URL,
          role: check.role,
          identity: check.identity,
          name: check.name,
          can_speak: check.can_speak === true,
          hand_raised: check.hand_raised === true,
          session: s,
        });
      }
      case 'start':
        return json({ ok: true, session: await rpc('masjid_live_start', { p_session: session }) });
      case 'end': {
        const room = await rpc('masjid_live_end', { p_session: session });
        try {
          await roomService('DeleteRoom', room, { room }, { roomCreate: true });
        } catch (e) {
          console.error('DeleteRoom', String(e));
        }
        return json({ ok: true });
      }
      case 'hand':
        return json({ ok: true, raised: await rpc('masjid_live_hand', { p_session: session, p_raise: body.raise === true }) });
      case 'hands':
        return json({ ok: true, hands: await rpc('masjid_live_hands', { p_session: session }) });
      case 'speaker': {
        const participant = String(body.participant ?? '');
        if (!UUID.test(participant)) return json({ error: 'مين؟' }, 400);
        const r = await rpc('masjid_live_set_speaker', { p_session: session, p_participant: participant, p_speaker: body.speaker === true });
        try {
          await roomService('UpdateParticipant', r.room, {
            room: r.room,
            identity: r.identity,
            permission: publisherPermission(r.speaker === true, r.mode),
            metadata: JSON.stringify({ role: r.speaker ? 'speaker' : 'listener' }),
          });
        } catch (e) {
          // Not in the room right now: their next join gets the new role.
          console.error('UpdateParticipant', String(e));
        }
        return json({ ok: true, speaker: r.speaker === true });
      }
      case 'remove': {
        const participant = String(body.participant ?? '');
        if (!UUID.test(participant)) return json({ error: 'مين؟' }, 400);
        const r = await rpc('masjid_live_remove', { p_session: session, p_participant: participant });
        try {
          await roomService('RemoveParticipant', r.room, { room: r.room, identity: r.identity });
        } catch (e) {
          console.error('RemoveParticipant', String(e));
        }
        return json({ ok: true });
      }
      case 'mute': {
        const participant = String(body.participant ?? '');
        const trackSid = String(body.track_sid ?? '');
        if (!UUID.test(participant) || !/^TR_[A-Za-z0-9]{4,40}$/.test(trackSid)) return json({ error: 'مين؟' }, 400);
        const room = await rpc('masjid_live_host_room', { p_session: session });
        await roomService('MutePublishedTrack', room, { room, identity: participant, track_sid: trackSid, muted: true });
        return json({ ok: true });
      }
      default:
        return json({ error: 'unknown action' }, 400);
    }
  } catch (e) {
    const err = e as { message?: string; hint?: string; db?: boolean };
    if (err.db) return json({ error: err.message ?? 'حصلت مشكلة', hint: err.hint ?? null }, 400);
    console.error(action, String(e));
    return json({ error: 'حصلت مشكلة في الاتصال بالبث، جرّب تاني' }, 502);
  }
});
