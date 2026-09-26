# Supabase Edge Functions

## `places` — Google Places / Geocoding proxy

Keeps the Google Maps API key on the server. The app calls
`supabase.functions.invoke('places', body: {...})` (see
`lib/core/places/places_service.dart`); the function calls Google with the
key from its secret, enforces a daily quota (migration 0041), and imports
shops into `shops` itself with the service role.

### Deploy (dashboard, no CLI needed)

1. Run `backend/migrations/0041_places_proxy_and_shop_guards.sql` in the SQL editor.
2. Google Cloud Console → APIs & Services → Credentials → **Create credentials → API key**.
   - API restrictions: **Places API (New)** and **Geocoding API** only.
   - Application restrictions: **None** (it is only ever used server-side now).
   - Then **delete the old key** (`AIzaSyDW7…`) — it was public in the web bundle and git history.
3. Supabase dashboard → **Edge Functions → Secrets** → add `GOOGLE_MAPS_API_KEY` = the new key.
4. Supabase dashboard → **Edge Functions → Deploy a new function → Via editor**:
   - Name: `places`
   - Paste the contents of `places/index.ts`, deploy.
   - In the function's **Details / Settings**, turn **"Enforce JWT verification" OFF**
     (the app's publishable key is not a JWT; the function verifies the user itself).

### Deploy (CLI alternative)

```bash
supabase functions deploy places --no-verify-jwt --project-ref pxiabifybakbsqlycffc
supabase secrets set GOOGLE_MAPS_API_KEY=... --project-ref pxiabifybakbsqlycffc
```
