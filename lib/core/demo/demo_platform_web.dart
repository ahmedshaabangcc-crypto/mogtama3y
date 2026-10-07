import 'dart:js_interop';
import 'dart:typed_data';

extension type _Storage(JSObject _) implements JSObject {
  external JSString? getItem(JSString key);
  external void setItem(JSString key, JSString value);
  external void removeItem(JSString key);
}

extension type _Location(JSObject _) implements JSObject {
  external void replace(JSString url);
}

extension type _BlobOptions._(JSObject _) implements JSObject {
  external factory _BlobOptions({JSString type});
}

@JS('Blob')
extension type _Blob._(JSObject _) implements JSObject {
  external factory _Blob(JSArray<JSAny> parts, _BlobOptions options);
}

@JS('sessionStorage')
external _Storage get _session;

@JS('location')
external _Location get _location;

@JS('URL.createObjectURL')
external JSString _createObjectUrl(JSObject blob);

String? demoSessionGet(String key) {
  try {
    return _session.getItem(key.toJS)?.toDart;
  } catch (_) {
    return null;
  }
}

void demoSessionSet(String key, String value) {
  try {
    _session.setItem(key.toJS, value.toJS);
  } catch (_) {}
}

void demoSessionRemove(String key) {
  try {
    _session.removeItem(key.toJS);
  } catch (_) {}
}

void demoNavigate(String url) => _location.replace(url.toJS);

String demoBlobUrl(Uint8List bytes, String mime) => _createObjectUrl(_Blob(<JSAny>[bytes.toJS].toJS, _BlobOptions(type: mime.toJS))).toDart;
