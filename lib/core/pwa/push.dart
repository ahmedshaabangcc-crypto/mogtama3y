// Phone notifications (Web Push) — see migration 0055 and the send-push
// Edge Function. Web only; everything is a no-op elsewhere.
export 'push_stub.dart' if (dart.library.js_interop) 'push_web.dart';

/// VAPID public key (public by design; the private half is a Supabase secret).
const vapidPublicKey = 'BMv95L_Krfg0AJc-WTYEGn1QDDw4DknApUpuLLQgBxKV1oICL4y1_YTswXwOwoNJ7TvN5x7qX9TnEWuAjknHC2E';
