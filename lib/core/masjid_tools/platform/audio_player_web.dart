import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// A single reused <audio> element: reusing it lets iOS keep playing the next
/// surah after one ends (the element stays «unlocked» by the first tap).
class WebAudio {
  WebAudio(this.onEvent) {
    try {
      final ctor = globalContext['Audio'] as JSFunction?;
      final el = ctor?.callAsConstructor<JSObject>();
      if (el == null) return;
      el['preload'] = 'metadata'.toJS;
      for (final t in const ['timeupdate', 'ended', 'error', 'playing', 'pause', 'waiting', 'loadedmetadata', 'canplay', 'durationchange', 'stalled']) {
        el.callMethod('addEventListener'.toJS, t.toJS, ((JSAny? _) => onEvent(t)).toJS);
      }
      _el = el;
      // Handy for debugging / verification in the browser console.
      globalContext['__masjidListenAudio'] = el;
    } catch (_) {
      _el = null;
    }
  }

  final void Function(String type) onEvent;
  JSObject? _el;

  bool get supported => _el != null;

  double _num(String k) {
    try {
      final v = (_el?[k] as JSNumber?)?.toDartDouble ?? 0;
      return v.isFinite ? v : 0;
    } catch (_) {
      return 0;
    }
  }

  double get position => _num('currentTime');
  double get duration => _num('duration');
  bool get paused => (_el?['paused'] as JSBoolean?)?.toDart ?? true;

  /// End of the buffered range that contains the playhead (seconds).
  double get buffered {
    try {
      final b = _el?['buffered'] as JSObject?;
      final n = (b?['length'] as JSNumber?)?.toDartInt ?? 0;
      final pos = position;
      for (var i = 0; i < n; i++) {
        final s = (b!.callMethod<JSNumber>('start'.toJS, i.toJS)).toDartDouble;
        final e = (b.callMethod<JSNumber>('end'.toJS, i.toJS)).toDartDouble;
        if (pos >= s - 0.5 && pos <= e + 0.5) return e;
      }
    } catch (_) {}
    return 0;
  }

  void setSource(String url) {
    try {
      _el?['src'] = url.toJS;
      _el?.callMethod('load'.toJS);
    } catch (_) {}
  }

  /// Starts playback; returns null on success or the error name
  /// (NotAllowedError = needs a tap, NotSupportedError = bad file…).
  Future<String?> play() async {
    final el = _el;
    if (el == null) return 'unsupported';
    try {
      final p = el.callMethod<JSAny?>('play'.toJS);
      if (p != null && p.isA<JSPromise>()) await (p as JSPromise).toDart;
      return null;
    } catch (e) {
      try {
        final name = ((e as JSObject)['name'] as JSString?)?.toDart;
        if (name != null) return name;
      } catch (_) {}
      return 'error';
    }
  }

  void pause() {
    try {
      _el?.callMethod('pause'.toJS);
    } catch (_) {}
  }

  void seek(double seconds) {
    try {
      final d = duration;
      final v = seconds < 0 ? 0.0 : (d > 0 && seconds > d - 0.25 ? d - 0.25 : seconds);
      _el?['currentTime'] = v.toJS;
    } catch (_) {}
  }

  void setRate(double rate) {
    try {
      _el?['playbackRate'] = rate.toJS;
      _el?['defaultPlaybackRate'] = rate.toJS;
    } catch (_) {}
  }

  /// Stops and drops the file (frees the connection).
  void stop() {
    try {
      _el?.callMethod('pause'.toJS);
      _el?.callMethod('removeAttribute'.toJS, 'src'.toJS);
      _el?.callMethod('load'.toJS);
    } catch (_) {}
  }
}

JSObject? get _session {
  try {
    final nav = globalContext['navigator'] as JSObject?;
    return nav?['mediaSession'] as JSObject?;
  } catch (_) {
    return null;
  }
}

/// Lock-screen / notification controls: metadata + action handlers
/// (play, pause, previoustrack, nexttrack, seekbackward, seekforward, seekto, stop).
void setMediaSession({
  required String title,
  required String artist,
  required String album,
  required String artwork,
  required Map<String, void Function(double? seekTime)> handlers,
}) {
  final s = _session;
  if (s == null) return;
  try {
    final ctor = globalContext['MediaMetadata'] as JSFunction?;
    if (ctor != null) {
      final art = JSObject()
        ..['src'] = artwork.toJS
        ..['sizes'] = '512x512'.toJS
        ..['type'] = 'image/png'.toJS;
      final init = JSObject()
        ..['title'] = title.toJS
        ..['artist'] = artist.toJS
        ..['album'] = album.toJS
        ..['artwork'] = [art].toJS;
      s['metadata'] = ctor.callAsConstructor<JSObject>(init);
    }
  } catch (_) {}
  for (final e in handlers.entries) {
    try {
      s.callMethod(
        'setActionHandler'.toJS,
        e.key.toJS,
        ((JSObject? details) {
          double? t;
          try {
            t = (details?['seekTime'] as JSNumber?)?.toDartDouble;
          } catch (_) {}
          e.value(t);
        }).toJS,
      );
    } catch (_) {} // action not supported by this browser
  }
}

void setMediaPlaybackState(bool playing) {
  try {
    _session?['playbackState'] = (playing ? 'playing' : 'paused').toJS;
  } catch (_) {}
}

void setMediaPositionState(double duration, double position, double rate) {
  final s = _session;
  if (s == null || !(duration > 0) || !duration.isFinite) return;
  try {
    final st = JSObject()
      ..['duration'] = duration.toJS
      ..['position'] = position.clamp(0, duration).toDouble().toJS
      ..['playbackRate'] = rate.toJS;
    s.callMethod('setPositionState'.toJS, st);
  } catch (_) {}
}

/// Absolute URL of an app asset, resolved against the page's base href.
String absoluteUrl(String path) {
  try {
    final doc = globalContext['document'] as JSObject;
    final base = (doc['baseURI'] as JSString).toDart;
    return Uri.parse(base).resolve(path).toString();
  } catch (_) {
    return path;
  }
}
