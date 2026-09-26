// Supabase Edge Function: `places`
//
// Server-side proxy for Google Places (New) + Geocoding, so the Google
// API key never reaches the browser. The key lives only in the
// function's GOOGLE_MAPS_API_KEY secret.
//
// POST body: { action: 'geocode', lat, lng }
//            { action: 'search', query }            — building lookup
//            { action: 'import_shops', query }      — search + upsert into shops
//
// Auth: 'search' and 'import_shops' need a signed-in user; 'geocode'
// also works for guests (the home screen's "explore your area" box).
// Every call counts against a daily quota per user (or per IP for
// guests) — see bump_places_usage() in migration 0041.
//
// Deploy with JWT verification OFF (the app's publishable key is not a
// JWT); the function checks the user itself. See ../README.md.

import { createClient } from 'npm:@supabase/supabase-js@2';

const GOOGLE_KEY = Deno.env.get('GOOGLE_MAPS_API_KEY') ?? '';
const SUPABASE_URL = Deno.env.get('SUPABASE_URL') ?? '';
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

const USER_DAILY_LIMIT = 100;
const GUEST_DAILY_LIMIT = 20;

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, { auth: { persistSession: false } });

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...corsHeaders, 'Content-Type': 'application/json' } });
}

const TYPE_LABELS: Record<string, string> = {
  supermarket: 'سوبر ماركت',
  grocery_store: 'بقالة',
  pharmacy: 'صيدلية',
  bakery: 'مخبز',
  restaurant: 'مطعم',
  cafe: 'كافيه',
  convenience_store: 'محل تجاري',
  hardware_store: 'أدوات منزلية',
  clothing_store: 'ملابس',
  laundry: 'مغسلة',
};

function categoryFor(types?: string[]): string {
  for (const t of types ?? []) {
    if (TYPE_LABELS[t]) return TYPE_LABELS[t];
  }
  return 'محل تجاري';
}

async function currentUserId(req: Request): Promise<string | null> {
  const token = (req.headers.get('Authorization') ?? '').replace(/^Bearer\s+/i, '');
  // The publishable key is sent as the bearer token for guests — only a
  // real session JWT (three dot-separated parts) identifies a user.
  if (token.split('.').length !== 3) return null;
  const { data, error } = await admin.auth.getUser(token);
  return error ? null : data.user?.id ?? null;
}

async function withinQuota(bucket: string, limit: number): Promise<boolean> {
  const { data, error } = await admin.rpc('bump_places_usage', { p_bucket: bucket, p_limit: limit });
  if (error) throw new Error('quota check failed');
  return data === true;
}

async function searchText(query: string, fieldMask: string, regionCode?: string) {
  const res = await fetch('https://places.googleapis.com/v1/places:searchText', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Goog-Api-Key': GOOGLE_KEY, 'X-Goog-FieldMask': fieldMask },
    body: JSON.stringify({ textQuery: query, languageCode: 'ar', ...(regionCode ? { regionCode } : {}) }),
  });
  const body = await res.json();
  if (!res.ok) throw new Error(body?.error?.message ?? `Google Places error ${res.status}`);
  return (body.places ?? []) as any[];
}

// Resolves a photo resource name to Google's key-less, directly loadable
// image URL (skipHttpRedirect returns it as JSON instead of redirecting).
async function photoUri(photoName: string): Promise<string | null> {
  const url = `https://places.googleapis.com/v1/${photoName}/media?maxWidthPx=640&skipHttpRedirect=true&key=${GOOGLE_KEY}`;
  const res = await fetch(url);
  if (!res.ok) return null;
  const body = await res.json();
  return typeof body.photoUri === 'string' ? body.photoUri : null;
}

async function geocode(lat: number, lng: number): Promise<string | null> {
  const url = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&language=ar&key=${GOOGLE_KEY}`;
  const res = await fetch(url);
  if (!res.ok) return null;
  const body = await res.json();
  if (body.status !== 'OK') return null;
  const preferred = ['sublocality_level_1', 'sublocality', 'locality', 'administrative_area_level_2'];
  for (const result of body.results ?? []) {
    for (const wanted of preferred) {
      for (const component of result.address_components ?? []) {
        if ((component.types ?? []).includes(wanted)) return component.long_name ?? null;
      }
    }
  }
  return null;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);
  if (!GOOGLE_KEY) return json({ error: 'GOOGLE_MAPS_API_KEY is not configured' }, 500);

  let payload: any;
  try {
    payload = await req.json();
  } catch {
    return json({ error: 'invalid JSON' }, 400);
  }
  const action = payload?.action;

  try {
    const userId = await currentUserId(req);
    if (!userId && action !== 'geocode') return json({ error: 'يجب تسجيل الدخول أولاً' }, 401);

    const ip = (req.headers.get('x-forwarded-for') ?? '').split(',')[0].trim() || 'unknown';
    const allowed = userId
      ? await withinQuota(`user:${userId}`, USER_DAILY_LIMIT)
      : await withinQuota(`ip:${ip}`, GUEST_DAILY_LIMIT);
    if (!allowed) return json({ error: 'تجاوزت الحد اليومي للبحث في الخرائط، حاول غداً' }, 429);

    if (action === 'geocode') {
      const lat = Number(payload.lat);
      const lng = Number(payload.lng);
      if (!Number.isFinite(lat) || !Number.isFinite(lng)) return json({ error: 'invalid coordinates' }, 400);
      return json({ area: await geocode(lat, lng) });
    }

    const query = String(payload?.query ?? '').trim().slice(0, 120);
    if (!query) return json({ error: 'اكتب ما تبحث عنه' }, 400);

    if (action === 'search') {
      const places = await searchText(query, 'places.id,places.displayName,places.formattedAddress,places.location', 'EG');
      return json({
        places: places.map((p) => ({
          place_id: p.id,
          name: p.displayName?.text ?? '',
          address: p.formattedAddress ?? '',
          lat: p.location?.latitude ?? null,
          lng: p.location?.longitude ?? null,
        })),
      });
    }

    if (action === 'import_shops') {
      const places = await searchText(
        query,
        'places.id,places.displayName,places.formattedAddress,places.location,places.rating,places.userRatingCount,places.types,places.photos',
      );
      const rows = [];
      for (const p of places) {
        const photoName = p.photos?.[0]?.name as string | undefined;
        rows.push({
          source: 'google_imported',
          google_place_id: p.id,
          name: p.displayName?.text,
          category: categoryFor(p.types),
          address: p.formattedAddress,
          lat: p.location?.latitude,
          lng: p.location?.longitude,
          rating: p.rating,
          rating_count: p.userRatingCount ?? 0,
          cover_image_url: photoName ? await photoUri(photoName) : null,
        });
      }
      if (rows.length) {
        const { error } = await admin.from('shops').upsert(rows, { onConflict: 'google_place_id', ignoreDuplicates: true });
        if (error) throw new Error(error.message);
      }
      return json({ imported: rows.length });
    }

    return json({ error: 'unknown action' }, 400);
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : 'unexpected error' }, 502);
  }
});
