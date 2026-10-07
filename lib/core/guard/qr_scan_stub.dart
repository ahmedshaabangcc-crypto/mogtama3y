/// Non-web builds: no camera scanner — the guard types the code.
bool get canScanQr => false;

/// The scanned text, '' if cancelled, or `ERR:<reason>`.
Future<String> scanQrCode({required String hint, required String cancelLabel}) async => 'ERR:unsupported';
