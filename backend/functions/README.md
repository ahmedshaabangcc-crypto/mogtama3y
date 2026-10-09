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

## `assistant` — AI assistant (n8n + Gemini)

The app → `assistant` Edge Function (auth, daily quota: 60/user, 15/guest IP;
adds the user's building/membership as context) → n8n workflow
"مُجتمعي – AI Assistant" (`https://n8n.srv1967321.hstgr.cloud/webhook/mogtama3y-assistant`,
header-auth `X-Mogtama3y-Secret`) → Gemini agent with window memory and the
platform guide in `assistant/system_prompt.md`. When a user asks for a human,
the agent messages the owner on Telegram and (for signed-in users) calls back
this function with `action: 'ticket'` to open a support ticket, answered from
the admin panel.

- Rebuild/redeploy the n8n workflow after editing the prompt:
  `node backend/functions/assistant/build_n8n_workflow.js`
  (needs git-ignored `.n8n-api-key` and `.assistant-secret` in the repo root).
- Supabase secrets: `ASSISTANT_SHARED_SECRET` = contents of `.assistant-secret`.
- Deployed from `assistant/index.ts` as the function with slug **`hyper-api`** (display name
  "assistant"; the dashboard editor fixed the slug at creation), **JWT verification OFF**.
  The app and the n8n ticket tool call `/functions/v1/hyper-api`.
- Gemini free tier is ~5 requests/minute (shared with the Apex agent); the
  workflow retries, but enable billing on the Gemini key before launch.

## `verify-phone` — SMS-verified mobile numbers (migration 0074)

The app proves a number with **Firebase Phone Auth** (Firebase project
`mogtama3y-dad8d`; `web/phone-verify.js` loads the Firebase SDK only on the
"أكّد رقمك" screen). Firebase sends and checks the SMS code and hands the app
an ID token; this function verifies that token's signature against Google's
public keys (no secret), takes the number from it, and calls
`confirm_phone_verified()` with the service role.

Deploy: dashboard → Edge Functions → Deploy a new function → Via editor →
name `verify-phone`, paste `verify-phone/index.ts` (the dashboard gave it the slug
**`smooth-action`**, which the app calls), and turn **Enforce JWT
verification OFF** (the function checks the Supabase session itself).

Firebase console: Authentication → Phone enabled; Authorized domains
mogtama3y.com, tajer.mogtama3y.com, ittihad.mogtama3y.com, masjidi.mogtama3y.com; SMS region policy
Allow → Egypt only. New projects can send 10 SMS/day until a billing account
is linked (Blaze).
