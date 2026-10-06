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
//            { action: 'nearby', lat, lng, category } — "اكتشف حواليك" list
//            { action: 'details', place_id }        — one business's page
//            { action: 'ensure_shop', place_id }    — create the shop row so
//                                                     its owner can claim it
//
// Auth: 'search', 'import_shops' and 'ensure_shop' need a signed-in user;
// 'geocode', 'nearby' and 'details' also work for guests. Nearby/details
// results are shown live and never stored (Google Maps terms), except the
// one shop row an owner explicitly asks to claim.
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
// All guests together, per day. The per-IP bucket reads X-Forwarded-For,
// whose first entry the caller can set, so this is the cap that holds.
const ALL_GUESTS_DAILY_LIMIT = 300;
const GUEST_ACTIONS = new Set(['geocode', 'nearby', 'details']);

// "اكتشف حواليك" categories → Places (New) primary types.
const NEARBY_TYPES: Record<string, string[]> = {
  pharmacy: ['pharmacy', 'drugstore'],
  clinic: ['doctor', 'dentist', 'medical_lab', 'physiotherapist'],
  hospital: ['hospital'],
  restaurant: ['restaurant', 'fast_food_restaurant'],
  cafe: ['cafe', 'coffee_shop'],
  supermarket: ['supermarket', 'grocery_store', 'convenience_store'],
  bakery: ['bakery'],
  clothing: ['clothing_store', 'shoe_store'],
  electronics: ['electronics_store', 'cell_phone_store'],
  bank: ['bank', 'atm'],
  fuel: ['gas_station'],
  beauty: ['beauty_salon', 'hair_salon', 'barber_shop'],
  gym: ['gym', 'fitness_center'],
  laundry: ['laundry'],
};

const NEARBY_FIELDS = 'places.id,places.displayName,places.formattedAddress,places.location,places.rating,places.userRatingCount,places.currentOpeningHours.openNow,places.primaryTypeDisplayName,places.websiteUri';
const DETAIL_FIELDS = 'id,displayName,formattedAddress,location,rating,userRatingCount,types,primaryTypeDisplayName,nationalPhoneNumber,websiteUri,googleMapsUri,regularOpeningHours.weekdayDescriptions,currentOpeningHours.openNow,photos';

async function nearby(lat: number, lng: number, types: string[]) {
  const res = await fetch('https://places.googleapis.com/v1/places:searchNearby', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'X-Goog-Api-Key': GOOGLE_KEY, 'X-Goog-FieldMask': NEARBY_FIELDS },
    body: JSON.stringify({
      includedTypes: types,
      maxResultCount: 20,
      rankPreference: 'DISTANCE',
      languageCode: 'ar',
      regionCode: 'EG',
      locationRestriction: { circle: { center: { latitude: lat, longitude: lng }, radius: 3000 } },
    }),
  });
  const body = await res.json();
  if (!res.ok) throw new Error(body?.error?.message ?? `Google Places error ${res.status}`);
  return (body.places ?? []) as any[];
}

async function placeDetails(placeId: string) {
  const res = await fetch(`https://places.googleapis.com/v1/places/${placeId}?languageCode=ar&regionCode=EG`, {
    headers: { 'X-Goog-Api-Key': GOOGLE_KEY, 'X-Goog-FieldMask': DETAIL_FIELDS },
  });
  const body = await res.json();
  if (!res.ok) throw new Error(body?.error?.message ?? `Google Places error ${res.status}`);
  return body;
}

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
    if (!userId && !GUEST_ACTIONS.has(action)) return json({ error: 'يجب تسجيل الدخول أولاً' }, 401);

    const ip = (req.headers.get('x-forwarded-for') ?? '').split(',')[0].trim() || 'unknown';
    const allowed = userId
      ? await withinQuota(`user:${userId}`, USER_DAILY_LIMIT)
      : (await withinQuota(`ip:${ip}`, GUEST_DAILY_LIMIT)) &&
        (await withinQuota(`ip:all-guests`, ALL_GUESTS_DAILY_LIMIT));
    if (!allowed) return json({ error: 'تجاوزت الحد اليومي للبحث في الخرائط، حاول غداً' }, 429);

    if (action === 'geocode') {
      const lat = Number(payload.lat);
      const lng = Number(payload.lng);
      if (!Number.isFinite(lat) || !Number.isFinite(lng)) return json({ error: 'invalid coordinates' }, 400);
      return json({ area: await geocode(lat, lng) });
    }

    if (action === 'nearby') {
      const lat = Number(payload.lat);
      const lng = Number(payload.lng);
      const types = NEARBY_TYPES[String(payload.category ?? '')];
      if (!Number.isFinite(lat) || !Number.isFinite(lng)) return json({ error: 'invalid coordinates' }, 400);
      if (!types) return json({ error: 'unknown category' }, 400);
      const places = await nearby(lat, lng, types);
      // Our own stores for these places (claimed shops with a /#/s/ link).
      const ids = places.map((p) => p.id);
      const { data: ours } = ids.length
        ? await admin.from('shops').select('google_place_id, slug').in('google_place_id', ids).not('slug', 'is', null)
        : { data: [] as any[] };
      const slugFor = new Map((ours ?? []).map((r: any) => [r.google_place_id, r.slug]));
      return json({
        places: places.map((p) => ({
          place_id: p.id,
          name: p.displayName?.text ?? '',
          type: p.primaryTypeDisplayName?.text ?? '',
          address: p.formattedAddress ?? '',
          lat: p.location?.latitude ?? null,
          lng: p.location?.longitude ?? null,
          rating: p.rating ?? null,
          rating_count: p.userRatingCount ?? 0,
          open_now: p.currentOpeningHours?.openNow ?? null,
          has_website: !!p.websiteUri,
          store_slug: slugFor.get(p.id) ?? null,
        })),
      });
    }

    if (action === 'details' || action === 'ensure_shop') {
      const placeId = String(payload?.place_id ?? '');
      if (!/^[A-Za-z0-9_-]{10,300}$/.test(placeId)) return json({ error: 'invalid place id' }, 400);

      if (action === 'ensure_shop') {
        const { data: existing } = await admin.from('shops').select('*').eq('google_place_id', placeId).maybeSingle();
        if (existing) return json({ shop: existing });
        const p = await placeDetails(placeId);
        const photoName = p.photos?.[0]?.name as string | undefined;
        const { data: shop, error } = await admin.from('shops').insert({
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
        }).select('*').single();
        if (error) throw new Error(error.message);
        return json({ shop });
      }

      const p = await placeDetails(placeId);
      const photos: string[] = [];
      for (const ph of (p.photos ?? []).slice(0, 3)) {
        const uri = await photoUri(ph.name);
        if (uri) photos.push(uri);
      }
      const { data: ours } = await admin.from('shops').select('slug, is_claimed').eq('google_place_id', placeId).maybeSingle();
      return json({
        place: {
          place_id: p.id,
          name: p.displayName?.text ?? '',
          type: p.primaryTypeDisplayName?.text ?? '',
          address: p.formattedAddress ?? '',
          lat: p.location?.latitude ?? null,
          lng: p.location?.longitude ?? null,
          rating: p.rating ?? null,
          rating_count: p.userRatingCount ?? 0,
          phone: p.nationalPhoneNumber ?? null,
          website: p.websiteUri ?? null,
          maps_url: p.googleMapsUri ?? null,
          open_now: p.currentOpeningHours?.openNow ?? null,
          hours: p.regularOpeningHours?.weekdayDescriptions ?? [],
          photos,
          store_slug: ours?.slug ?? null,
          is_claimed: ours?.is_claimed ?? false,
        },
      });
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
