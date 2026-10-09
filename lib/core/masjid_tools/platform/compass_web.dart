import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import '../qibla.dart';

/// Compass heading from the browser: iOS Safari's `webkitCompassHeading`,
/// otherwise `deviceorientationabsolute` (Chrome/Android) or an absolute
/// `deviceorientation` event. Headings are degrees clockwise from north.
class CompassSource {
  CompassSource() {
    _controller = StreamController<double>.broadcast(onListen: _start, onCancel: _stop);
  }

  late final StreamController<double> _controller;
  JSFunction? _handler;

  JSObject? get _deviceOrientationEvent => globalContext['DeviceOrientationEvent'] as JSObject?;

  bool get supported => _deviceOrientationEvent != null;

  /// iOS 13+: needs DeviceOrientationEvent.requestPermission() from a tap.
  bool get needsPermission {
    final e = _deviceOrientationEvent;
    return e != null && e['requestPermission'] != null;
  }

  Future<bool> requestPermission() async {
    try {
      final e = _deviceOrientationEvent;
      if (e == null || e['requestPermission'] == null) return supported;
      final r = await e.callMethod<JSPromise<JSString>>('requestPermission'.toJS).toDart;
      return r.toDart == 'granted';
    } catch (_) {
      return false;
    }
  }

  Stream<double> get headings => _controller.stream;

  double _screenAngle() {
    try {
      final screen = globalContext['screen'] as JSObject?;
      final o = screen?['orientation'] as JSObject?;
      final a = o?['angle'];
      if (a != null) return (a as JSNumber).toDartDouble;
      final w = globalContext['orientation'];
      return w == null ? 0 : (w as JSNumber).toDartDouble;
    } catch (_) {
      return 0;
    }
  }

  void _onEvent(JSObject e) {
    try {
      final ios = e['webkitCompassHeading'];
      if (ios != null) {
        _controller.add(normalizeDegrees((ios as JSNumber).toDartDouble + _screenAngle()));
        return;
      }
      final alpha = e['alpha'];
      if (alpha == null) return;
      final type = (e['type'] as JSString?)?.toDart;
      final absolute = (e['absolute'] as JSBoolean?)?.toDart ?? false;
      if (type == 'deviceorientationabsolute' || absolute) {
        _controller.add(headingFromAlpha((alpha as JSNumber).toDartDouble, screenAngle: _screenAngle()));
      }
    } catch (_) {}
  }

  void _start() {
    if (_handler != null) return;
    final h = ((JSObject e) => _onEvent(e)).toJS;
    _handler = h;
    globalContext.callMethod('addEventListener'.toJS, 'deviceorientationabsolute'.toJS, h);
    globalContext.callMethod('addEventListener'.toJS, 'deviceorientation'.toJS, h);
  }

  void _stop() {
    final h = _handler;
    if (h == null) return;
    globalContext.callMethod('removeEventListener'.toJS, 'deviceorientationabsolute'.toJS, h);
    globalContext.callMethod('removeEventListener'.toJS, 'deviceorientation'.toJS, h);
    _handler = null;
  }

  void dispose() {
    _stop();
    _controller.close();
  }
}
