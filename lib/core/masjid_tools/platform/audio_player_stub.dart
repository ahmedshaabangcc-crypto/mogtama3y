/// Off the web there is no player (the tools ship on the web only).
class WebAudio {
  WebAudio(this.onEvent);

  /// Called with the media event name (timeupdate, ended, error, playing…).
  final void Function(String type) onEvent;

  bool get supported => false;
  double get position => 0;
  double get duration => 0;
  double get buffered => 0;
  bool get paused => true;

  void setSource(String url) {}
  Future<String?> play() async => 'unsupported';
  void pause() {}
  void seek(double seconds) {}
  void setRate(double rate) {}
  void stop() {}
}

/// Lock-screen controls: metadata + action handlers.
void setMediaSession({
  required String title,
  required String artist,
  required String album,
  required String artwork,
  required Map<String, void Function(double? seekTime)> handlers,
}) {}

void setMediaPlaybackState(bool playing) {}

void setMediaPositionState(double duration, double position, double rate) {}

/// Absolute URL of an app asset (artwork for the lock screen).
String absoluteUrl(String path) => path;
