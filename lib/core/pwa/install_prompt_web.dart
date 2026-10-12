import 'dart:js_interop';

@JS('mogtama3yCanInstall')
external JSBoolean? _canInstall();

@JS('mogtama3yInstall')
external JSBoolean? _install();

@JS('mogtama3yIsStandalone')
external JSBoolean? _isStandalone();

@JS('mogtama3yIsIOS')
external JSBoolean? _isIOS();

@JS('__m3Installed')
external JSBoolean? get _justInstalled;

@JS('navigator.maxTouchPoints')
external JSNumber? get _maxTouchPoints;

@JS('navigator.platform')
external JSString? get _platform;

@JS('localStorage')
external _Storage? get _local;

@JS('sessionStorage')
external _Storage? get _session;

@JS('location')
external _Location get _location;

@JS('navigator.clipboard')
external _Clipboard? get _clipboard;

extension type _Storage(JSObject _) implements JSObject {
  external JSString? getItem(JSString key);
  external void setItem(JSString key, JSString value);
}

extension type _Location(JSObject _) implements JSObject {
  external JSString get href;
  external JSString get host;
  external JSString get pathname;
  external JSString get search;
  external JSString get hash;
  external void assign(JSString url);
}

extension type _Clipboard(JSObject _) implements JSObject {
  external JSPromise<JSAny?> writeText(JSString text);
}

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
bool get appJustInstalled => _safe(() => _justInstalled);

bool get isIPadDesktopMode {
  try {
    return _platform?.toDart == 'MacIntel' && (_maxTouchPoints?.toDartDouble ?? 0) > 1;
  } catch (_) {
    return false;
  }
}

String? storageGet(String key, {bool session = false}) {
  try {
    return (session ? _session : _local)?.getItem(key.toJS)?.toDart;
  } catch (_) {
    return null; // storage blocked (private mode, cookies off)
  }
}

void storageSet(String key, String value, {bool session = false}) {
  try {
    (session ? _session : _local)?.setItem(key.toJS, value.toJS);
  } catch (_) {}
}

Future<bool> copyPageLink() async {
  try {
    final c = _clipboard;
    if (c == null) return false;
    await c.writeText(_location.href).toDart;
    return true;
  } catch (_) {
    return false;
  }
}

void openPageInChrome() {
  try {
    final l = _location;
    // Android's Intent.parseUri splits at the LAST '#', so a hash route
    // (#/s/…) before «#Intent;» survives.
    final rest = '${l.host.toDart}${l.pathname.toDart}${l.search.toDart}${l.hash.toDart}';
    l.assign('intent://$rest#Intent;scheme=https;package=com.android.chrome;end'.toJS);
  } catch (_) {}
}
