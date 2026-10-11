import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import '../qibla.dart';

/// Compass readings from the browser:
/// * iOS Safari — `deviceorientation` with `webkitCompassHeading` (already
///   clockwise from north) after `DeviceOrientationEvent.requestPermission()`.
/// * Android Chrome — `deviceorientationabsolute`; heading = 360 − alpha.
///   A plain `deviceorientation` alpha on Android is relative to wherever the
///   phone pointed when the page started, so it is ignored unless the event
///   says `absolute: true`.
///
/// The listener lives from [start] until [dispose] (screen exit) — it is not
/// tied to stream listeners, so rebuilds can't detach it. It re-attaches when
/// the page becomes visible again and when events stall.
class CompassSource {
  final _controller = StreamController<CompassReading>.broadcast();
  JSFunction? _handler; // strong reference: keeps the JS callback alive
  JSFunction? _visibilityHandler;
  Timer? _watchdog;
  bool _started = false;
  bool _disposed = false;
  bool _sawAbsolute = false;
  DateTime? _lastEvent;
  String? lastError;

  JSObject? get _deviceOrientationEvent => globalContext['DeviceOrientationEvent'] as JSObject?;

  bool get supported => _deviceOrientationEvent != null;

  /// iOS 13+: needs DeviceOrientationEvent.requestPermission() from a tap.
  bool get needsPermission {
    final e = _deviceOrientationEvent;
    return e != null && e['requestPermission'] != null;
  }

  /// Call from a user tap (iOS).
  Future<bool> requestPermission() async {
    try {
      final e = _deviceOrientationEvent;
      if (e == null || e['requestPermission'] == null) return supported;
      final r = await e.callMethod<JSPromise<JSString>>('requestPermission'.toJS).toDart;
      final ok = r.toDart == 'granted';
      if (ok) _attach(); // fresh listener now that events are allowed
      return ok;
    } catch (e) {
      lastError = '$e';
      return false;
    }
  }

  Stream<CompassReading> get readings => _controller.stream;

  /// Absolute events seen: plain relative ones are being ignored.
  bool get hasAbsolute => _sawAbsolute;

  static double? _num(JSAny? v) {
    if (v == null) return null;
    try {
      final d = (v as JSNumber).toDartDouble;
      return d.isNaN ? null : d;
    } catch (_) {
      return null;
    }
  }

  double _screenAngle() {
    try {
      final screen = globalContext['screen'] as JSObject?;
      final o = screen?['orientation'] as JSObject?;
      final a = _num(o?['angle']);
      if (a != null) return a;
      return _num(globalContext['orientation']) ?? 0; // old iOS: window.orientation
    } catch (_) {
      return 0;
    }
  }

  void _onEvent(JSObject e) {
    if (_disposed) return;
    try {
      final beta = _num(e['beta']);
      final gamma = _num(e['gamma']);
      final ios = _num(e['webkitCompassHeading']);
      if (ios != null) {
        _lastEvent = DateTime.now();
        _controller.add(CompassReading(
          heading: headingFromWebkit(ios, screenAngle: _screenAngle()),
          accuracy: _num(e['webkitCompassAccuracy']),
          beta: beta,
          gamma: gamma,
          ios: true,
        ));
        return;
      }
      final alpha = _num(e['alpha']);
      if (alpha == null) return;
      final type = (e['type'] as JSString?)?.toDart;
      final absolute = type == 'deviceorientationabsolute' || ((e['absolute'] as JSBoolean?)?.toDart ?? false);
      if (!absolute) return; // relative alpha = wrong direction
      // Chrome fires both events; once the absolute one flows, use only it.
      if (type == 'deviceorientationabsolute') {
        _sawAbsolute = true;
      } else if (_sawAbsolute) {
        return;
      }
      _lastEvent = DateTime.now();
      _controller.add(CompassReading(heading: headingFromAlpha(alpha, screenAngle: _screenAngle()), beta: beta, gamma: gamma));
    } catch (_) {}
  }

  /// Starts listening (idempotent). Runs until [dispose].
  void start() {
    if (_started || _disposed) return;
    _started = true;
    _attach();
    final v = (() {
      if (_disposed) return;
      final state = ((globalContext['document'] as JSObject?)?['visibilityState'] as JSString?)?.toDart;
      if (state == 'visible') _attach();
    }).toJS;
    _visibilityHandler = v;
    (globalContext['document'] as JSObject?)?.callMethod('addEventListener'.toJS, 'visibilitychange'.toJS, v);
    globalContext.callMethod('addEventListener'.toJS, 'pageshow'.toJS, v);
    // Some phones silently stop delivering events (sensor sleep, tab switch):
    // if they stall after having flowed, re-attach.
    _watchdog = Timer.periodic(const Duration(seconds: 2), (_) {
      final last = _lastEvent;
      if (last != null && DateTime.now().difference(last) > const Duration(seconds: 3)) {
        _lastEvent = DateTime.now(); // don't thrash; try again in 3 s
        _attach();
      }
    });
  }

  void _attach() {
    if (_disposed) return;
    _detach();
    final h = ((JSObject e) => _onEvent(e)).toJS;
    _handler = h;
    if (globalContext.has('ondeviceorientationabsolute')) {
      globalContext.callMethod('addEventListener'.toJS, 'deviceorientationabsolute'.toJS, h);
    }
    globalContext.callMethod('addEventListener'.toJS, 'deviceorientation'.toJS, h);
  }

  void _detach() {
    final h = _handler;
    if (h == null) return;
    globalContext.callMethod('removeEventListener'.toJS, 'deviceorientationabsolute'.toJS, h);
    globalContext.callMethod('removeEventListener'.toJS, 'deviceorientation'.toJS, h);
    _handler = null;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _watchdog?.cancel();
    _detach();
    final v = _visibilityHandler;
    if (v != null) {
      (globalContext['document'] as JSObject?)?.callMethod('removeEventListener'.toJS, 'visibilitychange'.toJS, v);
      globalContext.callMethod('removeEventListener'.toJS, 'pageshow'.toJS, v);
    }
    _controller.close();
  }
}
