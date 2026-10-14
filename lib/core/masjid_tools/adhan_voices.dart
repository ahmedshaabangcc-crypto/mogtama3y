/// «تنبيه الصلاة»: how the prayer is announced, and the muezzin recordings.
///
/// The recordings are bundled in web/adhan/ (MP3, 64 kbps mono, loudness-
/// normalised; fetched only when played). Only freely licensed files from
/// Wikimedia Commons — see web/adhan/CREDITS.txt. None of them has the
/// Fajr phrase «الصلاة خير من النوم», so Fajr plays the same adhan.
library;

enum AdhanStyle {
  /// A normal notification (and the soft chime in the app).
  quiet,

  /// The whole adhan.
  full,

  /// The opening takbir only (~15 s).
  takbir;

  String get labelAr => switch (this) {
        AdhanStyle.quiet => 'إشعار هادي',
        AdhanStyle.full => 'الأذان كامل',
        AdhanStyle.takbir => 'تكبيرة بس',
      };

  bool get playsAdhan => this != AdhanStyle.quiet;

  static AdhanStyle? tryParse(Object? v) {
    for (final s in AdhanStyle.values) {
      if (s.name == v) return s;
    }
    return null;
  }
}

class AdhanVoice {
  const AdhanVoice({required this.id, required this.nameAr, required this.credit, required this.license, required this.source});
  final String id;
  final String nameAr;

  /// Who recorded it (shown under «حقوق الأصوات»).
  final String credit;
  final String license;

  /// The original file page on Wikimedia Commons.
  final String source;

  /// Relative to the app's base href ('/').
  String url(AdhanStyle style) => style == AdhanStyle.takbir ? 'adhan/$id-takbir.mp3' : 'adhan/$id.mp3';
}

const adhanVoices = <AdhanVoice>[
  AdhanVoice(
    id: 'madinah',
    nameAr: 'من المسجد النبوي (تسجيل من الساحة)',
    credit: 'ejaz215 (Freesound) — Wikimedia Commons',
    license: 'CC BY 3.0',
    source: 'https://commons.wikimedia.org/wiki/File:33937_ejaz215_call-to-prayer-from-the-prophet-s-mo.ogg',
  ),
  AdhanVoice(
    id: 'calm',
    nameAr: 'أذان بصوت هادي',
    credit: 'Adam-synagda — Wikimedia Commons',
    license: 'CC0 (ملكية عامة)',
    source: 'https://commons.wikimedia.org/wiki/File:Beautiful_adhan.ogg',
  ),
  AdhanVoice(
    id: 'short',
    nameAr: 'أذان قصير',
    credit: 'Aishatu98 — Wikimedia Commons',
    license: 'CC0 (ملكية عامة)',
    source: 'https://commons.wikimedia.org/wiki/File:Adhan.ogg',
  ),
];

const defaultAdhanVoice = 'madinah';

AdhanVoice adhanVoice(String? id) => adhanVoices.firstWhere((v) => v.id == id, orElse: () => adhanVoices.first);
