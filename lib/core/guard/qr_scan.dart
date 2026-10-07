// Camera QR scanning for the guard console. Web only (web/qr-scan.js);
// elsewhere the guard types the pass code.
export 'qr_scan_stub.dart' if (dart.library.js_interop) 'qr_scan_web.dart';
