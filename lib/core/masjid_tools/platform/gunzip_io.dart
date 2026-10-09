import 'dart:convert';
import 'dart:io' show gzip;
import 'dart:typed_data';

/// UTF-8 text of a gzip blob (or of plain bytes when a server already
/// decoded it — the gzip magic number tells).
Future<String> gunzipUtf8(Uint8List bytes) async {
  if (bytes.length > 2 && bytes[0] == 0x1f && bytes[1] == 0x8b) return utf8.decode(gzip.decode(bytes));
  return utf8.decode(bytes);
}
