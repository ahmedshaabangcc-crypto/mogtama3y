/// «المحفّظ» — compares what the speech model heard with the ayah.
///
/// The reference is the Tanzil Uthmani text the app ships; the model
/// (Tarteel's whisper-base-ar-quran) writes standard (imla'i) spelling with
/// tashkeel. Both are reduced to bare letters ([normalizeRecitation]) and a
/// looser [recitationSkeleton] that ignores alef / hamza spelling (الرحمان ≈
/// الرحمن, الصلوة ≈ الصلاة, يـٔوده ≈ يئوده). Words are then aligned with a
/// weighted edit distance (substitution cost = 1 − similarity, plus 2:1 and
/// 1:2 merges for words the two spellings split differently, e.g.
/// يَـٰٓأَيُّهَا ↔ يا أيها).
///
/// A word is `ok` only on an exact or skeleton match; similarity ≥ [nearAt]
/// is `near` («راجع الكلمة دي»), anything lower `wrong`.
library;

enum WordStatus { ok, near, wrong, missing, extra }

/// One word of the ayah as displayed (Uthmani, waqf marks attached) and its
/// normalised form.
class RefWord {
  const RefWord(this.display, this.norm);
  final String display;
  final String norm;
}

class AlignedWord {
  const AlignedWord({this.refIndex, this.ref, this.hyp, required this.status});

  /// Index into [RecitationResult.words] (null for an extra word).
  final int? refIndex;
  final String? ref;
  final String? hyp;
  final WordStatus status;

  @override
  String toString() => '${status.name}:${ref ?? ''}->${hyp ?? ''}';
}

class RecitationResult {
  RecitationResult(this.words, this.ops, this.heard);

  final List<RefWord> words;
  final List<AlignedWord> ops;

  /// The model's transcript, normalised.
  final String heard;

  /// Status of each ayah word (by index into [words]).
  late final List<WordStatus> statuses = () {
    final s = List.filled(words.length, WordStatus.missing);
    for (final o in ops) {
      if (o.refIndex != null) s[o.refIndex!] = o.status;
    }
    return s;
  }();

  List<String> get extras => [for (final o in ops) if (o.status == WordStatus.extra && o.hyp != null) o.hyp!];

  int get okCount => statuses.where((s) => s == WordStatus.ok).length;

  /// Every word right and nothing added.
  bool get perfect => words.isNotEmpty && okCount == words.length && extras.isEmpty;

  /// Nothing recognisable was heard.
  bool get empty => heard.trim().isEmpty;

  double get score => words.isEmpty ? 0 : okCount / words.length;
}

const nearAt = 0.6;

final _tatweelDagger = RegExp('ـ[ً-ْ]*ٰ');
final _tatweelSmallYeh = RegExp('ـ[ً-ْ]*[ۦۧ]');
final _wawDagger = RegExp('وٰ');
final _seatHamza = RegExp('[ويى][ً-ْ]*[ٔ]');
final _alefHamza = RegExp('ا[ٕٔ]');
final _looseHamza = RegExp('[ٕٔ]');
final _alefs = RegExp('[آأإٱٲٳ]');
final _carriedHamza = RegExp('[ؤئ]');
final _marks = RegExp('[ً-ٰٟۖ-ۭ࣓-ࣿـ]');
final _signs = RegExp('[۝۞٠-٩۰-۹0-9]');
final _nonLetters = RegExp('[^ء-ي\\s]');
final _spaces = RegExp(r'\s+');

/// Bare letters: no tashkeel, Quranic marks or digits; alef forms → ا,
/// ى → ي, ة → ه, every hamza on a seat (ؤ ئ, Uthmani ـٔ) → ء; Uthmani
/// dagger alef after tatweel → ا, after waw (الصلوٰة) → ا, else dropped;
/// small yeh after tatweel (إبرٰهـۧم) → ي.
String normalizeRecitation(String s) {
  var t = s
      .replaceAll(_tatweelDagger, 'ا')
      .replaceAll(_tatweelSmallYeh, 'ي')
      .replaceAll(_wawDagger, 'ا')
      .replaceAll(_alefHamza, 'ا')
      .replaceAll(_seatHamza, 'ء')
      .replaceAll(_looseHamza, 'ء')
      .replaceAll(_alefs, 'ا')
      .replaceAll(_carriedHamza, 'ء')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll(_marks, '')
      .replaceAll(_signs, ' ')
      .replaceAll(_nonLetters, ' ')
      .replaceAll(_spaces, ' ');
  return t.trim();
}

/// Looser key: also ignores alef and hamza (spelling, not pronunciation).
String recitationSkeleton(String w) => w.replaceAll(RegExp('[اء]'), '');

int _lev(String a, String b) {
  final m = a.length, n = b.length;
  if (m == 0) return n;
  if (n == 0) return m;
  var prev = List<int>.generate(n + 1, (j) => j);
  var cur = List<int>.filled(n + 1, 0);
  for (var i = 1; i <= m; i++) {
    cur[0] = i;
    for (var j = 1; j <= n; j++) {
      final c = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
      final x = prev[j] + 1, y = cur[j - 1] + 1, z = prev[j - 1] + c;
      cur[j] = x < y ? (x < z ? x : z) : (y < z ? y : z);
    }
    final tmp = prev;
    prev = cur;
    cur = tmp;
  }
  return prev[n];
}

/// 1 for an exact or skeleton match, else 1 − (edit distance / longer length).
double wordSimilarity(String r, String h) {
  if (r == h) return 1;
  final sr = recitationSkeleton(r), sh = recitationSkeleton(h);
  if (sr.isNotEmpty && sr == sh) return 1;
  final l = r.length > h.length ? r.length : h.length;
  if (l == 0) return 1;
  final d = 1 - _lev(r, h) / l;
  return d >= 1 ? 0.99 : d; // only exact/skeleton matches count as 1
}

WordStatus _statusOf(double sim) => sim >= 1 ? WordStatus.ok : (sim >= nearAt ? WordStatus.near : WordStatus.wrong);

/// The ayah's words for display. Tanzil writes waqf marks (ۚ ۖ ۗ …) as
/// separate tokens; they are attached to the word before them.
List<RefWord> recitationWords(String uthmani) {
  final out = <RefWord>[];
  for (final token in uthmani.split(_spaces)) {
    if (token.isEmpty) continue;
    final norm = normalizeRecitation(token).replaceAll(' ', '');
    if (norm.isEmpty) {
      if (out.isNotEmpty) {
        final last = out.removeLast();
        out.add(RefWord('${last.display} $token', last.norm));
      }
      continue;
    }
    out.add(RefWord(token, norm));
  }
  return out;
}

const _basmala = ['بسم', 'الله', 'الرحمن', 'الرحيم'];
const _istiadha = ['اعوذ', 'بالله', 'من', 'الشيطان', 'الرجيم'];

/// Drops an opening isti'adha / basmala the reciter added when the ayah
/// itself doesn't start with it.
List<String> _dropOpening(List<String> hyp, List<RefWord> ref) {
  var h = hyp;
  bool starts(List<String> words, List<String> phrase) {
    if (words.length < phrase.length) return false;
    for (var i = 0; i < phrase.length; i++) {
      if (wordSimilarity(phrase[i], words[i]) < 0.75) return false;
    }
    return true;
  }

  final refHead = [for (final w in ref.take(5)) w.norm];
  if (!starts(refHead, _istiadha) && starts(h, _istiadha)) h = h.sublist(_istiadha.length);
  if (!starts(refHead, _basmala) && starts(h, _basmala)) h = h.sublist(_basmala.length);
  return h;
}

/// Aligns [hypothesis] (the model's transcript) with the Uthmani ayah.
RecitationResult alignRecitation(String uthmani, String hypothesis) {
  final words = recitationWords(uthmani);
  final heard = normalizeRecitation(hypothesis);
  final hyp = _dropOpening(heard.split(' ').where((w) => w.isNotEmpty).toList(), words);
  return RecitationResult(words, _align(words, hyp), heard);
}

List<AlignedWord> _align(List<RefWord> words, List<String> h) {
  final r = [for (final w in words) w.norm];
  final m = r.length, n = h.length;
  final w = n + 1;
  final d = List<double>.filled((m + 1) * w, 0);
  final b = List<int>.filled((m + 1) * w, 0);
  final sims = List<double>.filled(m * (n == 0 ? 1 : n), 0);
  for (var i = 0; i < m; i++) {
    for (var j = 0; j < n; j++) {
      sims[i * n + j] = wordSimilarity(r[i], h[j]);
    }
  }
  for (var i = 1; i <= m; i++) {
    d[i * w] = i.toDouble();
    b[i * w] = 1;
  }
  for (var j = 1; j <= n; j++) {
    d[j] = j.toDouble();
    b[j] = 2;
  }
  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      var best = d[(i - 1) * w + j - 1] + (1 - sims[(i - 1) * n + j - 1]);
      var op = 0;
      final del = d[(i - 1) * w + j] + 1;
      if (del < best) {
        best = del;
        op = 1;
      }
      final ins = d[i * w + j - 1] + 1;
      if (ins < best) {
        best = ins;
        op = 2;
      }
      // One ayah word spoken/written as two (يَـٰٓأَيُّهَا ↔ يا أيها).
      if (j >= 2 && d[(i - 1) * w + j - 2] < best && wordSimilarity(r[i - 1], h[j - 2] + h[j - 1]) >= 1) {
        best = d[(i - 1) * w + j - 2];
        op = 3;
      }
      // Two ayah words written as one by the model.
      if (i >= 2 && d[(i - 2) * w + j - 1] < best && wordSimilarity(r[i - 2] + r[i - 1], h[j - 1]) >= 1) {
        best = d[(i - 2) * w + j - 1];
        op = 4;
      }
      d[i * w + j] = best;
      b[i * w + j] = op;
    }
  }
  final out = <AlignedWord>[];
  var i = m, j = n;
  while (i > 0 || j > 0) {
    final op = (i > 0 && j > 0) ? b[i * w + j] : (i > 0 ? 1 : 2);
    switch (op) {
      case 0:
        final sim = sims[(i - 1) * n + j - 1];
        out.add(AlignedWord(refIndex: i - 1, ref: r[i - 1], hyp: h[j - 1], status: _statusOf(sim)));
        i--;
        j--;
      case 1:
        out.add(AlignedWord(refIndex: i - 1, ref: r[i - 1], status: WordStatus.missing));
        i--;
      case 2:
        out.add(AlignedWord(hyp: h[j - 1], status: WordStatus.extra));
        j--;
      case 3:
        out.add(AlignedWord(refIndex: i - 1, ref: r[i - 1], hyp: '${h[j - 2]} ${h[j - 1]}', status: WordStatus.ok));
        i--;
        j -= 2;
      default:
        out.add(AlignedWord(refIndex: i - 1, ref: r[i - 1], hyp: h[j - 1], status: WordStatus.ok));
        out.add(AlignedWord(refIndex: i - 2, ref: r[i - 2], hyp: h[j - 1], status: WordStatus.ok));
        i -= 2;
        j--;
    }
  }
  return out.reversed.toList();
}
