import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'tutor_types.dart';

/// Web side of «المحفّظ»: a thin bridge to web/quran_tutor/tutor.js, which
/// is imported (and the worker / CDN / model touched) only on first use.
class TutorEngine {
  TutorEngine._();
  static final instance = TutorEngine._();

  JSObject? _module;
  Future<JSObject>? _importing;
  bool _ready = false;

  Future<JSObject> _js() {
    if (_module != null) return Future.value(_module);
    return _importing ??= () async {
      try {
        final base = (globalContext['document'] as JSObject)['baseURI'] as JSString;
        final url = Uri.parse(base.toDart).resolve('quran_tutor/tutor.js?v=2').toString();
        final m = await importModule(url.toJS).toDart;
        _module = m;
        return m;
      } catch (e) {
        _importing = null;
        throw TutorError('network', '$e');
      }
    }();
  }

  static TutorError _error(Object e) {
    if (e is TutorError) return e;
    try {
      final o = e as JSObject;
      final code = o['code'];
      final message = o['message'];
      return TutorError(code == null ? 'failed' : (code as JSString).toDart, message == null ? '' : (message as JSString).toDart);
    } catch (_) {
      return TutorError('failed', '$e');
    }
  }

  Future<T> _guard<T>(Future<T> Function() f) async {
    try {
      return await f();
    } catch (e) {
      throw _error(e);
    }
  }

  bool _bool(JSObject o, String k) => (o[k] as JSBoolean?)?.toDart ?? false;

  Future<TutorSupport> support() async {
    try {
      final o = (await _js()).callMethod<JSObject>('support'.toJS);
      return TutorSupport(
        worker: _bool(o, 'worker'),
        wasm: _bool(o, 'wasm'),
        mic: _bool(o, 'mic'),
        audio: _bool(o, 'audio'),
        webgpu: _bool(o, 'webgpu'),
        secure: _bool(o, 'secure'),
        ios: _bool(o, 'ios'),
        memoryGb: (o['memory'] as JSNumber?)?.toDartDouble ?? 0,
        isolated: _bool(o, 'isolated'),
        cores: (o['cores'] as JSNumber?)?.toDartDouble.round() ?? 0,
      );
    } catch (_) {
      return const TutorSupport();
    }
  }

  bool get modelReady => _ready;

  Future<bool> modelCached() async {
    try {
      final r = await (await _js()).callMethod<JSPromise<JSBoolean>>('isCached'.toJS).toDart;
      return r.toDart;
    } catch (_) {
      return false;
    }
  }

  Future<({int quota, int usage})?> storage() async {
    try {
      final r = await (await _js()).callMethod<JSPromise<JSObject?>>('storage'.toJS).toDart;
      if (r == null) return null;
      return (quota: (r['quota'] as JSNumber).toDartDouble.round(), usage: (r['usage'] as JSNumber).toDartDouble.round());
    } catch (_) {
      return null;
    }
  }

  void persistStorage() {
    _js().then((m) => m.callMethod('persist'.toJS)).ignore();
  }

  int _int(JSObject o, String k) => (o[k] as JSNumber?)?.toDartDouble.round() ?? 0;

  Future<TutorModelInfo> loadModel({void Function(int loaded, int total)? onProgress, String prefer = 'auto', int threads = 0}) => _guard(() async {
        final m = await _js();
        final cb = ((JSNumber loaded, JSNumber total) {
          onProgress?.call(loaded.toDartDouble.round(), total.toDartDouble.round());
        }).toJS;
        final r = await m.callMethod<JSPromise<JSObject>>('loadModel'.toJS, cb, prefer.toJS, threads.toJS).toDart;
        _ready = true;
        return TutorModelInfo(
          (r['device'] as JSString?)?.toDart ?? '',
          (r['dtype'] as JSString?)?.toDart ?? '',
          _int(r, 'ms'),
          _bool(r, 'cached'),
          backend: (r['backend'] as JSString?)?.toDart ?? '',
          threads: _int(r, 'threads'),
          isolated: _bool(r, 'isolated'),
          warmMs: _int(r, 'warmMs'),
        );
      });

  // ------------------------------------------------------------ isolation
  // Multithreaded recognition needs a cross-origin isolated page; GitHub
  // Pages can't send the headers, so the tutor runs at /tutor/ where a
  // service worker adds them (web/tutor/). See shouldIsolate().
  static const _isoKey = 'mt.tutor.iso';

  JSObject? get _session {
    try {
      return globalContext['sessionStorage'] as JSObject?;
    } catch (_) {
      return null;
    }
  }

  /// This page is the isolated /tutor/ copy of the app.
  bool get inIsolatedPage => (globalContext['mogtama3yTutorIsolated'] as JSBoolean?)?.toDart ?? false;

  /// Should the tutor move to /tutor/? Only where it helps and works:
  /// not isolated yet, service workers available, a Chromium/Firefox
  /// browser (Safari has no COEP credentialless; on iOS every browser is
  /// Safari underneath) with several cores, and no attempt in the last
  /// 30 s (an attempt that came back here didn't work this time).
  bool shouldIsolate() {
    try {
      if ((globalContext['crossOriginIsolated'] as JSBoolean?)?.toDart ?? false) return false;
      if (inIsolatedPage) return false;
      if (!((globalContext['isSecureContext'] as JSBoolean?)?.toDart ?? false)) return false;
      final nav = globalContext['navigator'] as JSObject;
      if (!nav.has('serviceWorker')) return false;
      final ua = (nav['userAgent'] as JSString).toDart;
      final maxTouch = (nav['maxTouchPoints'] as JSNumber?)?.toDartDouble ?? 0;
      final platform = (nav['platform'] as JSString?)?.toDart ?? '';
      final ios = RegExp(r'iPad|iPhone|iPod').hasMatch(ua) || (platform == 'MacIntel' && maxTouch > 1);
      final chromiumOrFirefox = RegExp(r'Chrome/|Chromium/|Firefox/|Edg/').hasMatch(ua);
      if (ios || !chromiumOrFirefox) return false;
      final cores = (nav['hardwareConcurrency'] as JSNumber?)?.toDartDouble ?? 0;
      if (cores > 0 && cores < 3) return false;
      final now = DateTime.now().millisecondsSinceEpoch;
      final last = int.tryParse((_session?.callMethod<JSString?>('getItem'.toJS, _isoKey.toJS))?.toDart ?? '');
      if (last != null && now - last < 30000) return false;
      // /tutor/ couldn't install its service worker on this browser lately.
      final local = globalContext['localStorage'] as JSObject?;
      final failed = int.tryParse((local?.callMethod<JSString?>('getItem'.toJS, 'mt.tutor.noiso'.toJS))?.toDart ?? '');
      if (failed != null && now - failed < const Duration(days: 3).inMilliseconds) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Reloads the tutor at /tutor/ (same route, isolated). Replaces the
  /// history entry, so «back» returns to where the tutor was opened from.
  void enterIsolation() {
    try {
      _session?.callMethod('setItem'.toJS, _isoKey.toJS, '${DateTime.now().millisecondsSinceEpoch}'.toJS);
    } catch (_) {}
    final loc = globalContext['location'] as JSObject;
    final hash = (loc['hash'] as JSString).toDart;
    final search = (loc['search'] as JSString).toDart; // e.g. ?debug=1
    final base = (globalContext['document'] as JSObject)['baseURI'] as JSString;
    final url = Uri.parse(base.toDart).resolve('tutor/').toString();
    loc.callMethod('replace'.toJS, '$url$search${hash.isEmpty ? '#/masjid/tools/tutor' : hash}'.toJS);
  }

  /// Leaves the isolated page for the normal app (a full load).
  void leaveIsolation() {
    final history = globalContext['history'] as JSObject;
    final n = (history['length'] as JSNumber?)?.toDartDouble ?? 0;
    if (n > 1) {
      history.callMethod('back'.toJS);
    } else {
      final base = (globalContext['document'] as JSObject)['baseURI'] as JSString;
      (globalContext['location'] as JSObject).callMethod('replace'.toJS, '${Uri.parse(base.toDart).resolve('./')}#/'.toJS);
    }
  }

  /// Must be called straight from a tap (iOS).
  Future<void> startRecording({
    Duration max = const Duration(seconds: 25),
    Duration min = Duration.zero,
    bool autoStop = true,
    void Function(double level)? onLevel,
    void Function(String reason)? onAutoStop,
  }) =>
      _guard(() async {
        final m = _module ?? await _js();
        final opts = JSObject();
        opts['maxMs'] = max.inMilliseconds.toJS;
        opts['autoStop'] = autoStop.toJS;
        opts['minMs'] = min.inMilliseconds.toJS;
        if (onLevel != null) opts['onLevel'] = ((JSNumber l) => onLevel(l.toDartDouble)).toJS;
        if (onAutoStop != null) opts['onAutoStop'] = ((JSString r) => onAutoStop(r.toDart)).toJS;
        await m.callMethod<JSPromise<JSAny?>>('startRecording'.toJS, opts).toDart;
      });

  Future<TutorRecording> stopRecording() => _guard(() async {
        // Synchronous call (no await before it), so a recording started right
        // after this in the same tap doesn't cancel this one.
        final m = _module ?? await _js();
        final r = await m.callMethod<JSPromise<JSObject>>('stopRecording'.toJS).toDart;
        return TutorRecording(r, (r['seconds'] as JSNumber).toDartDouble);
      });

  void cancelRecording() {
    _module?.callMethod('cancelRecording'.toJS);
  }

  TutorTranscript _transcript(JSObject r) => TutorTranscript(
        (r['text'] as JSString?)?.toDart ?? '',
        _int(r, 'ms'),
        (r['seconds'] as JSNumber?)?.toDartDouble ?? 0,
        frames: _int(r, 'frames'),
        tokens: _int(r, 'tokens'),
        retried: _bool(r, 'retried'),
        encMs: _int(r, 'encMs'),
        decMs: _int(r, 'decMs'),
        featMs: _int(r, 'featMs'),
      );

  JSObject _opts(int words) {
    final o = JSObject();
    o['words'] = words.toJS;
    return o;
  }

  /// [words]: the ayah's word count — bounds the decoder.
  Future<TutorTranscript> transcribe(TutorRecording rec, {int words = 0}) => _guard(() async {
        final h = rec.handle as JSObject;
        final r = await (await _js()).callMethod<JSPromise<JSObject>>('transcribe'.toJS, h['audio'], h['rate'], _opts(words)).toDart;
        return _transcript(r);
      });

  /// Debug: transcribe an mp3 from a URL (e.g. the Husary clip of the ayah).
  Future<TutorTranscript> transcribeUrl(String url, {int words = 0}) => _guard(() async {
        final r = await (await _js()).callMethod<JSPromise<JSObject>>('transcribeUrl'.toJS, url.toJS, _opts(words)).toDart;
        return _transcript(r);
      });

  /// Plays the reciter; true when it played to the end.
  Future<bool> play(List<String> urls, {int repeat = 1}) async {
    try {
      final m = _module ?? await _js();
      final r = await m.callMethod<JSPromise<JSBoolean>>('play'.toJS, urls.map((u) => u.toJS).toList().toJS, repeat.toJS).toDart;
      return r.toDart;
    } catch (_) {
      return false;
    }
  }

  void stopPlayback() {
    _module?.callMethod('stopPlayback'.toJS);
  }

  void prefetch(String url) {
    _module?.callMethod('prefetch'.toJS, url.toJS);
  }
}
