import '../qibla.dart';

/// No compass off the web (tests, desktop).
class CompassSource {
  bool get supported => false;
  bool get needsPermission => false;
  bool get hasAbsolute => false;
  String? get lastError => null;
  Future<bool> requestPermission() async => false;
  Stream<CompassReading> get readings => const Stream.empty();
  void start() {}
  void dispose() {}
}
