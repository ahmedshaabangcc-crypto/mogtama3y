import 'package:flutter/foundation.dart';

import '../masjid/prayer_times.dart';
import 'adhan_voices.dart';
import 'platform/audio_player.dart';

/// What the adhan banner shows.
class AdhanNow {
  const AdhanNow({required this.prayer, required this.style, required this.voice, this.playing = false, this.blocked = false, this.failed = false});
  final Prayer prayer;
  final AdhanStyle style;
  final String voice;
  final bool playing;

  /// The browser refused to start the sound without a tap → show the big
  /// «▶︎ شغّل الأذان» button.
  final bool blocked;

  /// The file couldn't load (offline…).
  final bool failed;

  AdhanNow copy({bool? playing, bool? blocked, bool? failed}) =>
      AdhanNow(prayer: prayer, style: style, voice: voice, playing: playing ?? this.playing, blocked: blocked ?? this.blocked, failed: failed ?? this.failed);
}

/// Plays the chosen adhan in the open app (at prayer time, or after the
/// user tapped the prayer notification). One shared <audio> element.
class AdhanPlayer {
  AdhanPlayer._();
  static final instance = AdhanPlayer._();

  final now = ValueNotifier<AdhanNow?>(null);
  WebAudio? _audio;

  WebAudio get _a => _audio ??= WebAudio(_onEvent);

  void _onEvent(String type) {
    final n = now.value;
    if (n == null) return;
    switch (type) {
      case 'playing':
        now.value = n.copy(playing: true, blocked: false, failed: false);
      case 'ended':
        now.value = null;
      case 'error':
        now.value = n.copy(playing: false, failed: true);
      case 'pause':
        now.value = n.copy(playing: false);
    }
  }

  /// Shows the banner and tries to play (may come back [AdhanNow.blocked]).
  Future<void> start(Prayer prayer, AdhanStyle style, String voice) async {
    if (!style.playsAdhan) return;
    now.value = AdhanNow(prayer: prayer, style: style, voice: voice);
    _a.setSource(adhanVoice(voice).url(style));
    await play();
  }

  /// Also the «▶︎ شغّل الأذان» button (a tap, so the browser allows it).
  Future<void> play() async {
    final n = now.value;
    if (n == null) return;
    final err = await _a.play();
    if (now.value == null) return;
    if (err == null) {
      now.value = n.copy(playing: true, blocked: false, failed: false);
    } else if (err == 'NotAllowedError') {
      now.value = n.copy(playing: false, blocked: true);
    } else if (err == 'unsupported') {
      now.value = null;
    } else {
      now.value = n.copy(playing: false, failed: true);
    }
  }

  /// A short sample in the settings screen.
  Future<String?> preview(String voice) async {
    now.value = null;
    _a.setSource(adhanVoice(voice).url(AdhanStyle.takbir));
    return _a.play();
  }

  void stop() {
    _audio?.stop();
    now.value = null;
  }
}
