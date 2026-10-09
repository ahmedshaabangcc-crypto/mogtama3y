// Decompresses the bundled gzip assets (the Quran text). On the web it uses
// the browser's native DecompressionStream, falling back to the pure-Dart
// decoder; elsewhere dart:io's gzip.
export 'gunzip_io.dart' if (dart.library.js_interop) 'gunzip_web.dart';
