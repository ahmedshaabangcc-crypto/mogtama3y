import 'dart:js_interop';

@JS('mogtama3yCanInstall')
external JSBoolean? _canInstall();

@JS('mogtama3yInstall')
external JSBoolean? _install();

@JS('mogtama3yIsStandalone')
external JSBoolean? _isStandalone();

@JS('mogtama3yIsIOS')
external JSBoolean? _isIOS();

bool _safe(JSBoolean? Function() f) {
  try {
    return f()?.toDart ?? false;
  } catch (_) {
    return false; // helper missing (e.g. an old cached index.html)
  }
}

bool get canInstallApp => _safe(() => _canInstall());
bool get isInstalledApp => _safe(() => _isStandalone());
bool get isIOSBrowser => _safe(() => _isIOS());
bool promptInstallApp() => _safe(() => _install());
