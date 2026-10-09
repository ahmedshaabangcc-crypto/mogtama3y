import 'package:flutter/services.dart' show rootBundle;

import 'platform/gunzip.dart';
import 'quran_meta.dart';

/// The Tanzil Uthmani text (assets/quran/quran-uthmani.txt.gz, CC BY 3.0,
/// kept verbatim with its copyright block). Fetched and decompressed only
/// when the Quran screen opens, then kept in memory.
class QuranText {
  QuranText._(this._ayahs, this.notice);

  /// [surah-1][ayah-1] → text.
  final List<List<String>> _ayahs;

  /// Tanzil's copyright block, exactly as shipped in the file.
  final String notice;

  static const asset = 'assets/quran/quran-uthmani.txt.gz';

  static Future<QuranText>? _loading;

  static Future<QuranText> load() {
    return _loading ??= () async {
      try {
        final data = await rootBundle.load(asset);
        final text = await gunzipUtf8(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
        return parse(text);
      } catch (_) {
        _loading = null; // let the user retry
        rethrow;
      }
    }();
  }

  /// Parses Tanzil's "sura|aya|text" format.
  static QuranText parse(String raw) {
    final ayahs = List.generate(114, (i) => List.filled(surahData[i].$2, ''));
    final notice = StringBuffer();
    for (final line in raw.split('\n')) {
      final l = line.endsWith('\r') ? line.substring(0, line.length - 1) : line;
      if (l.isEmpty) continue;
      if (l.startsWith('#')) {
        notice.writeln(l);
        continue;
      }
      final a = l.indexOf('|');
      final b = a < 0 ? -1 : l.indexOf('|', a + 1);
      if (b < 0) continue;
      final s = int.tryParse(l.substring(0, a));
      final v = int.tryParse(l.substring(a + 1, b));
      if (s == null || v == null || s < 1 || s > 114 || v < 1 || v > ayahs[s - 1].length) continue;
      ayahs[s - 1][v - 1] = l.substring(b + 1);
    }
    return QuranText._(ayahs, notice.toString().trimRight());
  }

  String ayah(int surah, int ayah) => _ayahs[surah - 1][ayah - 1];

  int ayahCount(int surah) => _ayahs[surah - 1].length;

  bool get complete => _ayahs.every((s) => s.every((a) => a.isNotEmpty));
}

/// Tanzil prefixes the first ayah of every surah but 1 and 9 with the
/// basmala; the reader shows it as the surah's header line instead.
const basmalaUthmani = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';

final _basmalaPlain = normalizeArabic(basmalaUthmani);

({String? basmala, String text}) splitBasmala(int surah, int ayah, String text) {
  if (surah == 1 || surah == 9 || ayah != 1) return (basmala: null, text: text);
  // Some surahs (95, 97) carry a marked variant («بِّسْمِ»), so compare the
  // first four words without diacritics and keep the text's own spelling.
  final words = text.split(' ');
  if (words.length > 4) {
    final head = words.take(4).join(' ');
    if (normalizeArabic(head) == _basmalaPlain) return (basmala: head, text: words.skip(4).join(' '));
  }
  return (basmala: null, text: text);
}

/// Strips tashkeel / Quranic marks and unifies letter variants for search.
String normalizeArabic(String s) {
  final b = StringBuffer();
  for (final r in s.runes) {
    if ((r >= 0x064B && r <= 0x065F) || r == 0x0670 || (r >= 0x06D6 && r <= 0x06ED) || r == 0x0640) continue;
    switch (r) {
      case 0x0622 || 0x0623 || 0x0625 || 0x0671:
        b.writeCharCode(0x0627); // ا
      case 0x0629:
        b.writeCharCode(0x0647); // ة → ه
      case 0x0649:
        b.writeCharCode(0x064A); // ى → ي
      default:
        b.writeCharCode(r);
    }
  }
  return b.toString().trim().toLowerCase();
}

/// Surah numbers matching [query] (Arabic name with or without «سورة»,
/// transliteration, or the number).
List<int> searchSurahs(String query) {
  var q = normalizeArabic(_westernDigits(query));
  q = q.replaceFirst(RegExp(r'^سوره\s*'), '').trim();
  final all = [for (var i = 1; i <= 114; i++) i];
  if (q.isEmpty) return all;
  final n = int.tryParse(q);
  if (n != null) return n >= 1 && n <= 114 ? [n] : const [];
  final qLatin = q.replaceAll(RegExp(r"[\s'\-]"), '');
  return all.where((i) {
    final name = normalizeArabic(surahData[i - 1].$1);
    if (name.contains(q) || name.replaceFirst(RegExp('^ال'), '').contains(q)) return true;
    return surahData[i - 1].$4.toLowerCase().replaceAll(RegExp(r"[\s'\-]"), '').contains(qLatin);
  }).toList();
}

String _westernDigits(String s) => s.replaceAllMapped(RegExp('[٠-٩]'), (m) => '${m[0]!.codeUnitAt(0) - 0x0660}');

/// The juz (1..30) that contains [surah]:[ayah].
int juzOf(int surah, int ayah) {
  var j = 1;
  for (var i = 0; i < juzStarts.length; i++) {
    final (s, a) = juzStarts[i];
    if (s < surah || (s == surah && a <= ayah)) j = i + 1;
  }
  return j;
}
