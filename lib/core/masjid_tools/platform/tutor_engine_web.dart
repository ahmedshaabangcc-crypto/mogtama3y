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
        final url = Uri.parse(base.toDart).resolve('quran_tutor/tutor.js?v=1').toString();
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

  Future<TutorModelInfo> loadModel({void Function(int loaded, int total)? onProgress, String prefer = 'auto'}) => _guard(() async {
        final m = await _js();
        final cb = ((JSNumber loaded, JSNumber total) {
          onProgress?.call(loaded.toDartDouble.round(), total.toDartDouble.round());
        }).toJS;
        final r = await m.callMethod<JSPromise<JSObject>>('loadModel'.toJS, cb, prefer.toJS).toDart;
        _ready = true;
        return TutorModelInfo(
          (r['device'] as JSString?)?.toDart ?? '',
          (r['dtype'] as JSString?)?.toDart ?? '',
          (r['ms'] as JSNumber?)?.toDartDouble.round() ?? 0,
          (r['cached'] as JSBoolean?)?.toDart ?? false,
        );
      });

  /// Must be called straight from a tap (iOS).
  Future<void> startRecording({
    Duration max = const Duration(seconds: 25),
    bool autoStop = true,
    void Function(double level)? onLevel,
    void Function(String reason)? onAutoStop,
  }) =>
      _guard(() async {
        final m = _module ?? await _js();
        final opts = JSObject();
        opts['maxMs'] = max.inMilliseconds.toJS;
        opts['autoStop'] = autoStop.toJS;
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
        (r['ms'] as JSNumber?)?.toDartDouble.round() ?? 0,
        (r['seconds'] as JSNumber?)?.toDartDouble ?? 0,
      );

  Future<TutorTranscript> transcribe(TutorRecording rec) => _guard(() async {
        final h = rec.handle as JSObject;
        final r = await (await _js()).callMethod<JSPromise<JSObject>>('transcribe'.toJS, h['audio'], h['rate']).toDart;
        return _transcript(r);
      });

  /// Debug: transcribe an mp3 from a URL (e.g. the Husary clip of the ayah).
  Future<TutorTranscript> transcribeUrl(String url) => _guard(() async {
        final r = await (await _js()).callMethod<JSPromise<JSObject>>('transcribeUrl'.toJS, url.toJS).toDart;
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
