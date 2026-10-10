import 'tutor_types.dart';

/// Off the web (tests, desktop): nothing runs.
class TutorEngine {
  TutorEngine._();
  static final instance = TutorEngine._();

  Future<TutorSupport> support() async => const TutorSupport();
  bool get modelReady => false;
  Future<bool> modelCached() async => false;
  Future<({int quota, int usage})?> storage() async => null;
  Future<TutorModelInfo> loadModel({void Function(int loaded, int total)? onProgress, String prefer = 'auto'}) async =>
      throw const TutorError('unsupported');
  Future<void> startRecording({Duration max = const Duration(seconds: 25), bool autoStop = true, void Function(double level)? onLevel, void Function(String reason)? onAutoStop}) async =>
      throw const TutorError('unsupported');
  Future<TutorRecording> stopRecording() async => throw const TutorError('unsupported');
  void cancelRecording() {}
  Future<TutorTranscript> transcribe(TutorRecording r) async => throw const TutorError('unsupported');
  Future<TutorTranscript> transcribeUrl(String url) async => throw const TutorError('unsupported');
  Future<bool> play(List<String> urls, {int repeat = 1}) async => false;
  void stopPlayback() {}
  void prefetch(String url) {}
  void persistStorage() {}
}
