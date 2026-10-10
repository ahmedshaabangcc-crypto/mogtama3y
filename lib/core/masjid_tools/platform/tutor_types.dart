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
  });

  final bool worker, wasm, mic, audio, webgpu, secure, ios;
  final double memoryGb;

  /// Can run the model at all.
  bool get canRun => worker && wasm;

  /// Can record.
  bool get canRecord => mic && audio && secure;
}

class TutorModelInfo {
  const TutorModelInfo(this.device, this.dtype, this.loadMs, this.cached);
  final String device;
  final String dtype;
  final int loadMs;
  final bool cached;
}

class TutorTranscript {
  const TutorTranscript(this.text, this.inferMs, this.seconds);
  final String text;
  final int inferMs;
  final double seconds;
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
