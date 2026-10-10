/// Shared types of the «المحفّظ» engine (speech worker, mic, reciter audio).
library;

class TutorSupport {
  const TutorSupport({
    this.worker = false,
    this.wasm = false,
    this.mic = false,
    this.audio = false,
    this.webgpu = false,
    this.secure = false,
    this.ios = false,
    this.memoryGb = 0,
    this.isolated = false,
    this.cores = 0,
  });

  final bool worker, wasm, mic, audio, webgpu, secure, ios;
  final double memoryGb;

  /// The page is cross-origin isolated (multithreaded recognition).
  final bool isolated;
  final int cores;

  /// Can run the model at all.
  bool get canRun => worker && wasm;

  /// Can record.
  bool get canRecord => mic && audio && secure;
}

class TutorModelInfo {
  const TutorModelInfo(this.device, this.dtype, this.loadMs, this.cached,
      {this.backend = '', this.threads = 1, this.isolated = false, this.warmMs = 0});

  /// 'wasm', 'webgpu+wasm' (encoder on the GPU) or 'webgpu'.
  final String device;
  final String dtype;
  final int loadMs;
  final bool cached;
  final String backend;

  /// WASM threads (1 unless the page is cross-origin isolated; 0 = no WASM).
  final int threads;
  final bool isolated;
  final int warmMs;

  bool get gpu => device.contains('webgpu');

  /// For the settings sheet: «WebGPU + CPU ×4», «CPU ×1».
  String get label {
    final cpu = threads > 0 ? 'CPU ×$threads' : '';
    if (device == 'webgpu') return 'WebGPU';
    if (gpu) return 'WebGPU + $cpu';
    return cpu.isEmpty ? device : cpu;
  }
}

class TutorTranscript {
  const TutorTranscript(this.text, this.inferMs, this.seconds,
      {this.frames = 0, this.tokens = 0, this.retried = false, this.encMs = 0, this.decMs = 0, this.featMs = 0});
  final String text;
  final int inferMs;
  final double seconds;

  /// Mel window used (100 per second; 3000 = the classic 30 s window).
  final int frames;
  final int tokens;

  /// The short window looped and the ayah was re-run on 30 s.
  final bool retried;
  final int encMs, decMs, featMs;

  String get debugLine => 'window ${(frames / 100).toStringAsFixed(0)} s, $tokens tokens${retried ? ' (retried on 30 s)' : ''}, '
      'mel $featMs ms, encoder $encMs ms, decoder $decMs ms';
}

/// A finished recording (opaque — stays a JS Float32Array on the web).
class TutorRecording {
  const TutorRecording(this.handle, this.seconds);
  final Object handle;
  final double seconds;
}

/// Errors with a stable [code]: unsupported, insecure, mic_denied, no_mic,
/// mic_busy, mic_failed, network, memory, decode, failed.
class TutorError implements Exception {
  const TutorError(this.code, [this.detail = '']);
  final String code;
  final String detail;

  /// What to tell the user (Egyptian Arabic).
  String get message => switch (code) {
        'mic_denied' => 'المتصفح مش سامح للمحفّظ يستخدم المايك. افتح إعدادات الموقع (علامة القفل جنب العنوان) واسمح بالميكروفون، وبعدين جرّب تاني.',
        'no_mic' => 'مش لاقيين مايك على الجهاز ده.',
        'mic_busy' => 'المايك مشغول في تطبيق تاني (مكالمة أو تسجيل) — اقفله وجرّب تاني.',
        'insecure' => 'التسجيل محتاج الموقع يفتح على https.',
        'unsupported' => 'المتصفح ده مش بيدعم التسجيل أو تشغيل المحفّظ. جرّب أحدث نسخة من Chrome أو Safari.',
        'network' => 'معرفناش نحمّل المحفّظ — اتأكد من النت وجرّب تاني.',
        'memory' => 'ذاكرة الجهاز مش مكفية للمحفّظ. اقفل التابات والتطبيقات التانية وجرّب تاني.',
        'decode' => 'معرفناش نقرا التسجيل — جرّب تسجّل تاني.',
        _ => 'حصلت مشكلة في المحفّظ — جرّب تاني.',
      };

  @override
  String toString() => 'TutorError($code: $detail)';
}
