import 'quran_meta.dart';

/// «المحفّظ» — what the user has memorised, kept on the device (and, when
/// signed in, mirrored to `quran_tutor_progress`, migration 0084).
enum AyahStatus { none, learning, memorized }

class AyahProgress {
  const AyahProgress(this.status, this.perfectCount, this.updatedAt);
  static final empty = AyahProgress(AyahStatus.none, 0, DateTime.fromMillisecondsSinceEpoch(0, isUtc: true));

  final AyahStatus status;

  /// Perfect recitations in a row.
  final int perfectCount;
  final DateTime updatedAt;
}

AyahStatus _statusFrom(Object? s) => switch (s) {
      'memorized' => AyahStatus.memorized,
      'learning' => AyahStatus.learning,
      _ => AyahStatus.none,
    };

bool validAyah(int surah, int ayah) => surah >= 1 && surah <= 114 && ayah >= 1 && ayah <= surahData[surah - 1].$2;

class TutorProgress {
  TutorProgress();

  final _rows = <int, AyahProgress>{};
  final _dirty = <int>{};
  String? _lastDay;
  int streak = 0;
  int bestStreak = 0;

  static int _key(int s, int a) => s * 1000 + a;

  AyahProgress of(int surah, int ayah) => _rows[_key(surah, ayah)] ?? AyahProgress.empty;

  static String _day(DateTime t) {
    final l = t.toLocal();
    return '${l.year.toString().padLeft(4, '0')}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')}';
  }

  static String _prevDay(String day) {
    final p = day.split('-').map(int.parse).toList();
    return _day(DateTime(p[0], p[1], p[2] - 1, 12));
  }

  void _practised(DateTime now) {
    final today = _day(now);
    if (_lastDay == today) return;
    streak = _lastDay != null && _lastDay == _prevDay(today) ? streak + 1 : 1;
    if (streak > bestStreak) bestStreak = streak;
    _lastDay = today;
  }

  /// Streak as of [now]: 0 if neither today nor yesterday was practised.
  int currentStreak([DateTime? now]) {
    final today = _day(now ?? DateTime.now());
    return _lastDay == today || _lastDay == _prevDay(today) ? streak : 0;
  }

  bool practisedToday([DateTime? now]) => _lastDay == _day(now ?? DateTime.now());

  /// Records one recitation of [surah]:[ayah]. [needed] perfect ones in a
  /// row mark it memorised; a mistake on a memorised ayah sends it back to
  /// «محتاجة مراجعة» (learning).
  AyahProgress record(int surah, int ayah, {required bool perfect, required int needed, DateTime? now}) {
    final t = now ?? DateTime.now();
    final old = of(surah, ayah);
    final count = perfect ? (old.perfectCount + 1).clamp(0, 100) : 0;
    final status = perfect && count >= needed ? AyahStatus.memorized : AyahStatus.learning;
    final p = AyahProgress(status, count, t.toUtc());
    _rows[_key(surah, ayah)] = p;
    _dirty.add(_key(surah, ayah));
    _practised(t);
    return p;
  }

  int memorizedIn(int surah) {
    var n = 0;
    for (var a = 1; a <= surahData[surah - 1].$2; a++) {
      if (of(surah, a).status == AyahStatus.memorized) n++;
    }
    return n;
  }

  int learningIn(int surah) {
    var n = 0;
    for (var a = 1; a <= surahData[surah - 1].$2; a++) {
      if (of(surah, a).status == AyahStatus.learning) n++;
    }
    return n;
  }

  double percent(int surah) => memorizedIn(surah) / surahData[surah - 1].$2;

  int get memorizedTotal => _rows.values.where((p) => p.status == AyahStatus.memorized).length;

  /// Surahs with any progress, in mushaf order.
  List<int> get startedSurahs => (_rows.keys.map((k) => k ~/ 1000).toSet().toList()..sort());

  bool get isEmpty => _rows.isEmpty;

  // ----------------------------------------------------------- persistence
  Map<String, dynamic> toJson() => {
        'v': 1,
        'rows': {
          for (final e in _rows.entries) '${e.key}': [e.value.status.index, e.value.perfectCount, e.value.updatedAt.millisecondsSinceEpoch]
        },
        'dirty': _dirty.toList(),
        'last': _lastDay,
        'streak': streak,
        'best': bestStreak,
      };

  factory TutorProgress.fromJson(Map<String, dynamic> j) {
    final p = TutorProgress();
    final rows = j['rows'];
    if (rows is Map) {
      for (final e in rows.entries) {
        final k = int.tryParse('${e.key}');
        final v = e.value;
        if (k == null || v is! List || v.length < 3 || !validAyah(k ~/ 1000, k % 1000)) continue;
        final si = (v[0] as num).toInt();
        if (si < 0 || si >= AyahStatus.values.length) continue;
        p._rows[k] = AyahProgress(AyahStatus.values[si], (v[1] as num).toInt(), DateTime.fromMillisecondsSinceEpoch((v[2] as num).toInt(), isUtc: true));
      }
    }
    final dirty = j['dirty'];
    if (dirty is List) p._dirty.addAll(dirty.whereType<num>().map((n) => n.toInt()).where(p._rows.containsKey));
    p._lastDay = j['last'] as String?;
    p.streak = (j['streak'] as num?)?.toInt() ?? 0;
    p.bestStreak = (j['best'] as num?)?.toInt() ?? p.streak;
    return p;
  }

  // ------------------------------------------------------------------ sync
  /// Rows changed here and not yet uploaded, as the RPC expects them.
  List<Map<String, dynamic>> dirtyRows({int max = 300}) => [
        for (final k in _dirty.take(max))
          {
            'surah': k ~/ 1000,
            'ayah': k % 1000,
            'status': of(k ~/ 1000, k % 1000).status == AyahStatus.memorized ? 'memorized' : 'learning',
            'perfect_count': of(k ~/ 1000, k % 1000).perfectCount,
            'updated_at': of(k ~/ 1000, k % 1000).updatedAt.toIso8601String(),
          }
      ];

  void markUploaded(List<Map<String, dynamic>> rows) {
    for (final r in rows) {
      final k = _key(r['surah'] as int, r['ayah'] as int);
      // Only if it hasn't changed again meanwhile.
      if (of(k ~/ 1000, k % 1000).updatedAt.toIso8601String() == r['updated_at']) _dirty.remove(k);
    }
  }

  /// Takes the server's rows where they are newer. Returns whether anything
  /// changed here.
  bool mergeRemote(List<dynamic> rows) {
    var changed = false;
    for (final r in rows) {
      if (r is! Map) continue;
      final s = (r['surah'] as num?)?.toInt(), a = (r['ayah'] as num?)?.toInt();
      final at = DateTime.tryParse('${r['updated_at']}');
      if (s == null || a == null || at == null || !validAyah(s, a)) continue;
      final status = _statusFrom(r['status']);
      if (status == AyahStatus.none) continue;
      final local = _rows[_key(s, a)];
      if (local != null && !at.isAfter(local.updatedAt)) continue;
      _rows[_key(s, a)] = AyahProgress(status, ((r['perfect_count'] as num?)?.toInt() ?? 0).clamp(0, 100), at.toUtc());
      _dirty.remove(_key(s, a));
      changed = true;
    }
    return changed;
  }
}

/// The tutor's settings (on this device).
class TutorSettings {
  const TutorSettings({this.perfectNeeded = 2, this.repeat = 1, this.autoStop = true, this.hideText = false, this.optedIn = false});

  final int perfectNeeded;
  final int repeat;
  final bool autoStop;
  final bool hideText;
  final bool optedIn;

  TutorSettings copyWith({int? perfectNeeded, int? repeat, bool? autoStop, bool? hideText, bool? optedIn}) => TutorSettings(
        perfectNeeded: perfectNeeded ?? this.perfectNeeded,
        repeat: repeat ?? this.repeat,
        autoStop: autoStop ?? this.autoStop,
        hideText: hideText ?? this.hideText,
        optedIn: optedIn ?? this.optedIn,
      );

  Map<String, dynamic> toJson() => {'n': perfectNeeded, 'r': repeat, 'auto': autoStop, 'hide': hideText, 'in': optedIn};

  factory TutorSettings.fromJson(Map<String, dynamic> j) => TutorSettings(
        perfectNeeded: ((j['n'] as num?)?.toInt() ?? 2).clamp(1, 5),
        repeat: const [1, 3, 5].contains(j['r']) ? j['r'] as int : 1,
        autoStop: j['auto'] as bool? ?? true,
        hideText: j['hide'] as bool? ?? false,
        optedIn: j['in'] as bool? ?? false,
      );
}

/// everyayah.com — Mahmoud Khalil al-Husary, «المصحف المعلم» (teaching
/// recitation, each ayah slowly and clearly).
String husaryMuallimUrl(int surah, int ayah) =>
    'https://everyayah.com/data/Husary_Muallim_128kbps/${surah.toString().padLeft(3, '0')}${ayah.toString().padLeft(3, '0')}.mp3';
