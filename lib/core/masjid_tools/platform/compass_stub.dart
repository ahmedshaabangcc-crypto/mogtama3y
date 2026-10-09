/// No compass off the web (tests, desktop).
class CompassSource {
  bool get supported => false;
  bool get needsPermission => false;
  Future<bool> requestPermission() async => false;
  Stream<double> get headings => const Stream.empty();
  void dispose() {}
}
