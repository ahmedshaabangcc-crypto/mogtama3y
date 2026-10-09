import 'dart:js_interop';
import 'dart:js_interop_unsafe';

JSObject? get _storage {
  try {
    return globalContext['localStorage'] as JSObject?;
  } catch (_) {
    return null; // blocked storage (private mode, iframes…)
  }
}

Future<String?> kvGet(String key) async {
  try {
    return (_storage?.callMethod<JSString?>('getItem'.toJS, key.toJS))?.toDart;
  } catch (_) {
    return null;
  }
}

Future<void> kvSet(String key, String value) async {
  try {
    _storage?.callMethod('setItem'.toJS, key.toJS, value.toJS);
  } catch (_) {}
}
