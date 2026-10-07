import 'dart:js_interop';

import '../demo/demo_mode.dart';

@JS('mogtama3yPushState')
external JSString? _pushState();

@JS('mogtama3yEnablePush')
external JSPromise<JSString>? _enablePush(JSString vapidPublicKey);

/// 'unsupported' | 'default' | 'granted' | 'denied'.
String get pushState {
  if (kDemo) return 'unsupported'; // demo build: no web push at all
  try {
    return _pushState()?.toDart ?? 'unsupported';
  } catch (_) {
    return 'unsupported';
  }
}

/// Asks permission and subscribes this browser; returns the subscription
/// JSON, or '' when refused or unsupported.
Future<String> subscribeDeviceForPush(String vapidPublicKey) async {
  if (kDemo) return '';
  try {
    final p = _enablePush(vapidPublicKey.toJS);
    if (p == null) return '';
    return (await p.toDart).toDart;
  } catch (_) {
    return '';
  }
}
