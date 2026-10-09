import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// A short vibration (Android browsers; ignored where unsupported).
void vibrate(int ms) {
  try {
    final nav = globalContext['navigator'] as JSObject?;
    if (nav != null && nav['vibrate'] != null) nav.callMethod('vibrate'.toJS, ms.toJS);
  } catch (_) {}
}

JSObject? _ctx;

/// Browsers only allow sound after a user gesture: call this from a tap so
/// later chimes can play.
void unlockAudio() {
  try {
    if (_ctx == null) {
      final ctor = (globalContext['AudioContext'] ?? globalContext['webkitAudioContext']) as JSFunction?;
      if (ctor == null) return;
      _ctx = ctor.callAsConstructor<JSObject>();
    }
    final state = (_ctx!['state'] as JSString?)?.toDart;
    if (state == 'suspended') _ctx!.callMethod('resume'.toJS);
  } catch (_) {}
}

/// A soft two-note bell (≈1.5 s), synthesised — no audio file.
void playChime() {
  try {
    unlockAudio();
    final ctx = _ctx;
    if (ctx == null) return;
    final now = (ctx['currentTime'] as JSNumber).toDartDouble;
    final dest = ctx['destination'] as JSObject;
    for (final (freq, start) in const [(880.0, 0.0), (659.25, 0.45)]) {
      final osc = ctx.callMethod<JSObject>('createOscillator'.toJS);
      final gain = ctx.callMethod<JSObject>('createGain'.toJS);
      osc['type'] = 'sine'.toJS;
      (osc['frequency'] as JSObject)['value'] = freq.toJS;
      final g = gain['gain'] as JSObject;
      g.callMethod('setValueAtTime'.toJS, 0.0001.toJS, (now + start).toJS);
      g.callMethod('exponentialRampToValueAtTime'.toJS, 0.25.toJS, (now + start + 0.03).toJS);
      g.callMethod('exponentialRampToValueAtTime'.toJS, 0.0001.toJS, (now + start + 1.1).toJS);
      osc.callMethod('connect'.toJS, gain);
      gain.callMethod('connect'.toJS, dest);
      osc.callMethod('start'.toJS, (now + start).toJS);
      osc.callMethod('stop'.toJS, (now + start + 1.2).toJS);
    }
  } catch (_) {}
}
