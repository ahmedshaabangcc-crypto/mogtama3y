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

## `livekit-token` — «دروس أونلاين» live lessons on LiveKit Cloud (migration 0085)

The live-lesson page `web/live/` (served at `/live/?s=<lesson id>` on every
domain) calls this function with the user's Supabase session. The function
asks the database (as that user) whether they may join and in which role —
`masjid_live_join_check` — and mints a LiveKit access token (HS256 JWT,
signed with Web Crypto, no dependencies): hosts (the mosque's verified
admins with the «الدروس» permission) publish and are room admins, speakers
(listeners a host promoted; verified phone required) publish, listeners
only subscribe. Everyone may send data messages (the in-room chat and ✋,
never stored). Identity = an opaque per-lesson participant id (not the
account id). The same function lets the host start / end the lesson,
promote / demote speakers (LiveKit `UpdateParticipant`), remove someone
(`RemoveParticipant`) and mute a track (`MutePublishedTrack`).

Deploy (dashboard, no CLI needed):

1. Run `backend/migrations/0085_masjid_live_lessons.sql` in the SQL editor.
2. LiveKit Cloud → your project → **Settings → Keys** → copy the WebSocket URL
   (`wss://<project>.livekit.cloud`), the API key and the API secret.
3. Supabase → **Edge Functions → Secrets** → add:
   - `LIVEKIT_URL` = `wss://<project>.livekit.cloud`
   - `LIVEKIT_API_KEY` = the API key
   - `LIVEKIT_API_SECRET` = the API secret
4. Supabase → **Edge Functions → Deploy a new function → Via editor**:
   - Name: `livekit-token` — paste the whole of `livekit-token/index.ts`, deploy.
   - Turn **Enforce JWT verification OFF** (the function checks the session itself).
   - Check the **slug** the dashboard gave it (in the function's URL,
     `…/functions/v1/<slug>`). The page calls `livekit-token`; if the slug
     differs (like `hyper-api` / `smooth-action` above), change
     `FUNCTION_SLUG` at the top of `web/live/live.js` to it and redeploy the site.
5. Test: schedule a lesson from «إدارة المسجد → أونلاين», press «ابدأ»,
   then open it on a second phone as a member.

CLI alternative:

```bash
supabase functions deploy livekit-token --no-verify-jwt --project-ref pxiabifybakbsqlycffc
supabase secrets set LIVEKIT_URL=wss://... LIVEKIT_API_KEY=... LIVEKIT_API_SECRET=... --project-ref pxiabifybakbsqlycffc
```

Without the secrets the function answers 503 «الدروس الأونلاين لسه مش
متفعّلة» and the page shows that message. CORS allows mogtama3y.com,
www.mogtama3y.com, masjidi.mogtama3y.com and http://localhost / 127.0.0.1.
The token signer is the block between `jwt:begin` / `jwt:end`; Node runs
that exact code in `backend/tests/run.js` (phase «mlive») against a known
HS256 vector.

## `send-push` — phone notifications (Web Push, migrations 0055 / 0090)

The `notifications_push` trigger posts every new notification — with the
user's devices (0090) — to this function through pg_net; the function sends
it with the VAPID keys and drops devices the push service says are gone.

- Secrets: `VAPID_PUBLIC_KEY` (same as `lib/core/pwa/push.dart`),
  `VAPID_PRIVATE_KEY`, `PUSH_SECRET` (= `private.push_settings.secret`).
- `private.push_settings.function_url` = this function's URL
  (`https://pxiabifybakbsqlycffc.supabase.co/functions/v1/<slug>` — check the
  slug the dashboard gave it).
- Deploy: dashboard → Edge Functions → the push function → paste
  `send-push/index.ts` → Deploy. **Enforce JWT verification OFF.**
- Every answer says why. Last calls:
  ```sql
  select created, status_code, content::text from net._http_response order by created desc limit 20;
  ```
  `{"sent":1,"total":1,"failures":[],"removed":0}` = delivered to Apple/Google.
  `reason`: `no_subscriptions` (device not registered), `no_notification`,
  `db_error` (+`error`: e.g. permission denied → run 0090), `all_failed`
  (+`failures[].status/body`: 403 = VAPID key pair mismatch, 410 = device gone).

## متجري «الربط والتكاملات» — `payments-connect`, `payments-webhook`, `domains-verify` (migration 0097)

Owner decision (Shopify model): every merchant connects THEIR OWN payment
gateway; the money goes straight to the merchant, the platform never holds
funds. Secrets are write-only: `set_shop_gateway()` stores them in
`private.shop_gateway_secrets` (no client role can read the private
schema); the app only ever gets `has_secret` + «…abcd». Only these
functions read them, with the service role, through `gateway_credentials()`.
No new secrets to set — they use the Supabase-provided `SUPABASE_URL`,
`SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`.

Deploy (dashboard, each the same way): run `0097_tajer_integrations.sql`
first, then **Edge Functions → Deploy a new function → Via editor**, name
it as below, paste the file, deploy, and turn **Enforce JWT verification
OFF** (the first two check the user's session themselves; the webhook is
called by the gateways and checks only their signature). Check the slug
the dashboard gave each one (`…/functions/v1/<slug>`); if it differs,
change `IntegrationSlugs` in
`lib/features/merchant/integrations/integrations_service.dart` and redeploy
the merchant app.

| name | file | what |
| --- | --- | --- |
| `payments-connect` | `payments-connect/index.ts` | «اختبر الاتصال»: owner check + 20 tests/hour (`integration_rate_hit`), one harmless call — Paymob `POST <region>/api/auth/tokens`, Tap `POST /v2/charges/list {limit:1}`, Moyasar `GET /v1/payments?limit=1`; **Kashier: format check only** (no read-only endpoint confirmed in its docs — the first test payment in Phase 4 is the real check); then `gateway_record_check` (مربوط / فيه مشكلة). |
| `payments-webhook` | `payments-webhook/index.ts` | **Stub for Phase 4.** Verifies the gateway's signature (Paymob HMAC-SHA512 `?hmac=`, Kashier `x-kashier-signature`, Tap `hashstring`, Moyasar `secret_token` = our `webhook_token`) and stores the event in `shop_payment_events`. Does not change orders yet. |
| `domains-verify` | `domains-verify/index.ts` | «تحقق دلوقتي»: owner check + 12/hour, `Deno.resolveDns` (1.1.1.1) for `TXT _mogtama3y-verify.<host>` and (subdomains) `CNAME <host> → stores.mogtama3y.com`, then `domain_record_check` → `verified`. Serving the store on the domain is Phase 5 (Cloudflare for SaaS) → `active`. |

The webhook URL each merchant pastes in their gateway dashboard (the app
shows it, with a copy button, on the gateway's card):

```
https://pxiabifybakbsqlycffc.supabase.co/functions/v1/payments-webhook?shop=<shop id>&provider=<paymob|kashier|tap|moyasar>
```

The pure blocks (`gw`, `sig`, `dns` markers) run in Node in
`backend/tests/run.js`, phase «tint», with a fake fetch and known HMACs.

Phase 5 (domains), owner side: a `stores.mogtama3y.com` hostname as the
CNAME target, Cloudflare for SaaS custom hostnames for `verified` domains,
then `shop_domains.status = 'active'`, and the
`facebook-domain-verification` meta tag from
`shops.tracking->>'fb_domain_verification'` on that domain.

## متجري «ادفع أونلاين» — `payments-checkout` + Fawaterak (migration 0100)

Owner decision (2026-10-30): the first online gateway is **Fawaterak
(فواتيرك)**, each merchant with THEIR OWN account (API key in «طرق الدفع»).

Deploy: run `0100_fawaterak.sql`, deploy a new function named
**`payments-checkout`** (`payments-checkout/index.ts`, **Enforce JWT
verification OFF** — guests pay; the order code + its mobile are the check),
and redeploy `payments-connect` and `payments-webhook` (both gained
Fawaterak). No new secrets.

| step | who | what |
| --- | --- | --- |
| `methods` | storefront | `payment_begin` (code + phone; the order becomes online / «مستني الدفع») → Fawaterak `GET getPaymentmethods` |
| `pay` | storefront | `POST invoiceInitPay` (the order's total from the DB, one cart line, `payLoad.order_code`, `webhookUrl` = `payments-webhook?shop=…&provider=fawaterak`) → `redirect_to` (cards / wallets) or a Fawry / Aman code |
| webhook | Fawaterak | `hashKey` = HMAC-SHA256(API key, `InvoiceId=…&InvoiceKey=…&PaymentMethod=…`) checked, then the invoice is **re-read** with `GET getInvoiceData/<id>` and `payment_settle` marks the order paid only for the order's exact amount and currency |
| `status` | tracking page | the same re-read, when the customer comes back from Fawaterak's page |

Hosts: `staging.fawaterk.com/api/v2` for «تجريبي», `app.fawaterk.com/api/v2`
for «حقيقي». The merchant pastes nothing in their Fawaterak dashboard (each
invoice carries its webhook URL). Tests: phase «tfaw» in `backend/tests/run.js`.
