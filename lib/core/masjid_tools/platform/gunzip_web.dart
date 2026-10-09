import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import '../inflate.dart';

/// UTF-8 text of a gzip blob (or of plain bytes when the server already
/// decoded it — the gzip magic number tells).
Future<String> gunzipUtf8(Uint8List bytes) async {
  if (bytes.length < 2 || bytes[0] != 0x1f || bytes[1] != 0x8b) return utf8.decode(bytes);
  try {
    final ds = globalContext['DecompressionStream'];
    final response = globalContext['Response'];
    if (ds != null && response != null) {
      final stream = (ds as JSFunction).callAsConstructor<JSObject>('gzip'.toJS);
      final input = (response as JSFunction).callAsConstructor<JSObject>(bytes.toJS);
      final body = input['body'] as JSObject;
      final piped = body.callMethod<JSObject>('pipeThrough'.toJS, stream);
      final out = response.callAsConstructor<JSObject>(piped);
      final text = await out.callMethod<JSPromise<JSString>>('text'.toJS).toDart;
      return text.toDart;
    }
  } catch (_) {
    // Fall through to the Dart decoder.
  }
  return utf8.decode(gunzipBytes(bytes));
}
