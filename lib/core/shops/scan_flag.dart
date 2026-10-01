// Whether web/store-lite.js (the instant store page shown before Flutter
// loads) already counted this visit — so the Flutter store page doesn't
// count it a second time. Always false off the web.
export 'scan_flag_stub.dart' if (dart.library.js_interop) 'scan_flag_web.dart';
