import 'dart:js_interop';

@JS('mogtama3yCanScanQr')
external JSBoolean? _canScan();

@JS('mogtama3yQrScan')
external JSPromise<JSString> _scan(JSString hint, JSString cancelLabel);

/// Whether this browser can open the camera (secure page + getUserMedia).
bool get canScanQr {
  try {
    return _canScan()?.toDart ?? false;
  } catch (_) {
    return false; // helper missing (e.g. an old cached index.html)
  }
}

/// The scanned text, '' if cancelled, or `ERR:<reason>`.
Future<String> scanQrCode({required String hint, required String cancelLabel}) async {
  try {
    return (await _scan(hint.toJS, cancelLabel.toJS).toDart).toDart;
  } catch (_) {
    return 'ERR:unavailable';
  }
}
