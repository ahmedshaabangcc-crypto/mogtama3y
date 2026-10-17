import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Sends a command to web/shop-pixels.js; until it has loaded, queues it in
/// `window.__mgPixelsQ` and adds the script once (it drains the queue).
void pixelsCommand(String name, String json) {
  try {
    final api = globalContext['mogtama3yShopPixels'];
    if (api != null && api.isA<JSObject>()) {
      (api as JSObject).callMethod('cmd'.toJS, name.toJS, json.toJS);
      return;
    }
    var q = globalContext['__mgPixelsQ'];
    if (q == null || !q.isA<JSObject>()) {
      q = <JSAny?>[].toJS;
      globalContext['__mgPixelsQ'] = q;
    }
    (q as JSObject).callMethod('push'.toJS, <JSAny?>[name.toJS, json.toJS].toJS);
    final doc = globalContext['document'] as JSObject;
    if (doc.callMethod('getElementById'.toJS, 'mg-shop-pixels'.toJS) == null) {
      final s = doc.callMethod('createElement'.toJS, 'script'.toJS) as JSObject;
      s['id'] = 'mg-shop-pixels'.toJS;
      s['async'] = true.toJS;
      s['src'] = 'shop-pixels.js'.toJS;
      (doc['head'] as JSObject).callMethod('appendChild'.toJS, s);
    }
  } catch (_) {
    // A pixel must never break the store.
  }
}
