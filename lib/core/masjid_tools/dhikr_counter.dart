/// Tap-to-count state for a list of adhkar, and the standalone سبحة.
/// Pure logic — the screens persist / render it.
library;

class DhikrCounter {
  DhikrCounter(List<int> targets) : targets = List.unmodifiable(targets.map((t) => t < 1 ? 1 : t)), _counts = List.filled(targets.length, 0);

  /// How many times each dhikr is said (≥ 1).
  final List<int> targets;
  final List<int> _counts;

  int count(int i) => _counts[i];
  bool isDone(int i) => _counts[i] >= targets[i];
  double progress(int i) => _counts[i] / targets[i];

  /// One tap on dhikr [i]. Returns true when this tap completed it.
  /// Taps on a completed dhikr do nothing.
  bool tap(int i) {
    if (isDone(i)) return false;
    _counts[i]++;
    return isDone(i);
  }

  void resetOne(int i) => _counts[i] = 0;

  void resetAll() {
    for (var i = 0; i < _counts.length; i++) {
      _counts[i] = 0;
    }
  }

  int get doneCount => [for (var i = 0; i < targets.length; i++) if (isDone(i)) i].length;
  bool get allDone => doneCount == targets.length;

  /// Share of all repetitions done (0..1), for the overall bar.
  double get overallProgress {
    final total = targets.fold<int>(0, (a, b) => a + b);
    final done = [for (var i = 0; i < targets.length; i++) _counts[i].clamp(0, targets[i])].fold<int>(0, (a, b) => a + b);
    return total == 0 ? 0 : done / total;
  }

  /// The first dhikr not yet done (to scroll to), or null.
  int? get nextPending {
    for (var i = 0; i < targets.length; i++) {
      if (!isDone(i)) return i;
    }
    return null;
  }

  List<int> toJson() => List.of(_counts);

  /// Restores saved counts (ignored when the list changed length).
  void restore(List<dynamic>? saved) {
    if (saved == null || saved.length != _counts.length) return;
    for (var i = 0; i < _counts.length; i++) {
      final v = saved[i];
      _counts[i] = v is num ? v.toInt().clamp(0, targets[i]) : 0;
    }
  }
}

/// السبحة: counts up; every [target] taps is one round («دورة»).
class Tasbeeh {
  Tasbeeh({this.target = 33, this.count = 0, this.total = 0});

  static const targets = [33, 100];

  int target;

  /// Taps in the current round (0..target-1 after wrapping).
  int count;

  /// All taps ever (until reset).
  int total;

  int get rounds => target <= 0 ? 0 : total ~/ target;
  double get progress => target <= 0 ? 0 : count / target;

  /// Returns true when this tap completed a round.
  bool tap() {
    count++;
    total++;
    if (count >= target) {
      count = 0;
      return true;
    }
    return false;
  }

  void reset() {
    count = 0;
    total = 0;
  }

  void setTarget(int t) {
    if (t < 1) return;
    target = t;
    count = total % t;
  }

  Map<String, int> toJson() => {'target': target, 'count': count, 'total': total};

  factory Tasbeeh.fromJson(Map<String, dynamic>? j) {
    if (j == null) return Tasbeeh();
    final t = (j['target'] as num?)?.toInt() ?? 33;
    final total = ((j['total'] as num?)?.toInt() ?? 0).clamp(0, 1 << 30);
    final target = t < 1 ? 33 : t;
    return Tasbeeh(target: target, total: total, count: ((j['count'] as num?)?.toInt() ?? 0).clamp(0, target - 1));
  }
}
