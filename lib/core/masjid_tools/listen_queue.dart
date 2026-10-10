/// «استماع» play-order logic — what plays after a surah ends, next /
/// previous, and the sleep timer — pure Dart so it is unit-tested.
library;

/// What happens when a surah finishes.
enum PlayMode {
  /// Next available surah, stop after the last one (default — «كمّل المصحف»).
  continuous('كمّل المصحف', 'بعد السورة تشتغل اللي بعدها'),

  /// Loop the same surah.
  repeatOne('كرّر السورة', 'نفس السورة تتعاد'),

  /// Next surah and back to the first after the last.
  repeatAll('كرّر المصحف كله', 'لما يخلص يبدأ من الأول'),

  /// Stop after this surah.
  once('السورة دي بس', 'يقف لما السورة تخلص');

  const PlayMode(this.label, this.hint);
  final String label;
  final String hint;
}

class ListenQueue {
  ListenQueue(List<int> surahs, this.current) : surahs = List.unmodifiable(surahs) {
    assert(surahs.isNotEmpty);
  }

  /// Surahs available in the mushaf, ascending.
  final List<int> surahs;
  int current;

  int get _index {
    final i = surahs.indexOf(current);
    if (i >= 0) return i;
    // Not in the list (shouldn't happen): the position it would take.
    final after = surahs.indexWhere((s) => s > current);
    return after < 0 ? surahs.length : after - 1;
  }

  bool get hasNext => surahs.any((s) => s > current);
  bool get hasPrevious => surahs.any((s) => s < current);

  /// The next available surah (manual «التالية»), or null at the end.
  int? next({bool wrap = false}) {
    for (final s in surahs) {
      if (s > current) return s;
    }
    return wrap ? surahs.first : null;
  }

  /// The previous available surah (manual «السابقة»), or null at the start.
  int? previous() {
    for (final s in surahs.reversed) {
      if (s < current) return s;
    }
    return null;
  }

  /// What plays when [current] ends under [mode]; null = stop.
  int? afterEnd(PlayMode mode) => switch (mode) {
        PlayMode.continuous => next(),
        PlayMode.repeatOne => current,
        PlayMode.repeatAll => next(wrap: true),
        PlayMode.once => null,
      };

  /// «السابقة» like music players: if more than [restartAfter] seconds have
  /// played, restart this surah (returns current); otherwise go back.
  int? previousOrRestart(double positionSeconds, {double restartAfter = 5}) =>
      positionSeconds > restartAfter ? current : previous();

  int get position => _index;
}

/// Sleep timer choices; [endOfSurah] stops when the current surah ends.
enum SleepTimer {
  off(null, 'من غير'),
  m15(15, '١٥ دقيقة'),
  m30(30, '٣٠ دقيقة'),
  m60(60, 'ساعة'),
  endOfSurah(null, 'آخر السورة');

  const SleepTimer(this.minutes, this.label);
  final int? minutes;
  final String label;
}

/// Allowed playback speeds.
const playbackSpeeds = <double>[0.75, 1.0, 1.25, 1.5];

/// Resume position worth keeping: not the first few seconds and not the very
/// end (then the surah starts over).
double? resumePoint(double position, double duration) {
  if (position < 10) return null;
  if (duration > 0 && duration - position < 15) return null;
  return position;
}

/// «٣:٠٥» / «١:٠٢:٠٣».
String formatClock(double seconds) {
  if (seconds.isNaN || seconds.isInfinite || seconds < 0) seconds = 0;
  final t = seconds.floor();
  final h = t ~/ 3600, m = (t % 3600) ~/ 60, s = t % 60;
  String two(int v) => v.toString().padLeft(2, '0');
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '$m:${two(s)}';
}
