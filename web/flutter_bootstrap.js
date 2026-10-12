{{flutter_js}}
{{flutter_build_config}}

// No serviceWorkerSettings: Flutter's own (deprecated) service worker is a
// self-unregistering stub registered at scope "/" — the same scope as
// push-sw.js (Web Push + the Android install prompt), so registering it on
// every start replaced push-sw.js and then unregistered the whole scope,
// dropping push subscriptions with it.
_flutter.loader.load();
