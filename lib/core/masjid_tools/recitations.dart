/// «استماع»: reciters and their recorded mushafs from mp3quran.net's public
/// API v3 (https://www.mp3quran.net/api/v3/reciters — CORS-open, free to use:
/// «جميع الحقوق متاحة للجميع ويحق لأي زائر أو مطور استخدام أي مادة أو رابط
/// من الموقع»). Pure Dart — parsing, grouping, search and URLs — so it is
/// unit-tested off the browser.
library;

const recitationsApi = 'https://www.mp3quran.net/api/v3/reciters?language=ar';

/// Recording style of a mushaf.
enum RecitationKind {
  murattal('مرتل'),
  mujawwad('مجود'),
  muallim('معلم');

  const RecitationKind(this.label);
  final String label;
}

/// One recorded mushaf of a reciter (a riwayah in one style).
class Moshaf {
  const Moshaf({
    required this.id,
    required this.name,
    required this.riwayah,
    required this.kind,
    required this.server,
    required this.surahs,
    this.note,
  });

  final int id;

  /// The API's full label, e.g. «حفص عن عاصم - مرتل».
  final String name;

  /// Normalised riwayah, e.g. «حفص عن عاصم» (the API's «المصحف المجود» /
  /// «المصحف المعلم» are Hafs recordings).
  final String riwayah;
  final RecitationKind kind;

  /// Base URL ending with «/».
  final String server;

  /// Available surahs, ascending.
  final List<int> surahs;

  /// Extra label beyond riwayah + kind (e.g. «تلاوة مميزة», «تسجيل عام 1387 هـ»).
  final String? note;

  bool get complete => surahs.length == 114;

  bool has(int surah) => _bsearch(surahs, surah);

  /// «حفص عن عاصم — مرتل (تلاوة مميزة)».
  String get title => '$riwayah — ${kind.label}${note == null ? '' : ' ($note)'}';

  String url(int surah) => surahUrl(server, surah);

  factory Moshaf.fromJson(Map<String, dynamic> j) {
    final name = (j['name'] as String? ?? '').replaceAll(RegExp(r'\s+'), ' ').trim();
    final (riwayah, kind, note) = parseMoshafName(name);
    return Moshaf(
      id: (j['id'] as num?)?.toInt() ?? 0,
      name: name,
      riwayah: riwayah,
      kind: kind,
      server: normaliseServer(j['server'] as String? ?? ''),
      surahs: parseSurahList(j['surah_list']),
      note: note,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'server': server,
        'surah_list': compactSurahList(surahs),
      };
}

class Reciter {
  const Reciter({required this.id, required this.name, required this.moshafs});
  final int id;
  final String name;
  final List<Moshaf> moshafs;

  Set<String> get riwayat => {for (final m in moshafs) m.riwayah};
  Set<RecitationKind> get kinds => {for (final m in moshafs) m.kind};

  Moshaf? moshaf(int id) {
    for (final m in moshafs) {
      if (m.id == id) return m;
    }
    return null;
  }

  factory Reciter.fromJson(Map<String, dynamic> j) {
    final list = [
      for (final m in (j['moshaf'] as List? ?? const []))
        if (m is Map) Moshaf.fromJson(Map<String, dynamic>.from(m)),
    ]..removeWhere((m) => m.server.isEmpty || m.surahs.isEmpty);
    // Hafs first, then murattal before mujawwad before muallim, then fuller.
    list.sort((a, b) {
      final h = (a.riwayah == hafs ? 0 : 1).compareTo(b.riwayah == hafs ? 0 : 1);
      if (h != 0) return h;
      final r = a.riwayah.compareTo(b.riwayah);
      if (r != 0) return r;
      final k = a.kind.index.compareTo(b.kind.index);
      if (k != 0) return k;
      final n = (a.note == null ? 0 : 1).compareTo(b.note == null ? 0 : 1);
      if (n != 0) return n;
      return b.surahs.length.compareTo(a.surahs.length);
    });
    return Reciter(id: (j['id'] as num?)?.toInt() ?? 0, name: (j['name'] as String? ?? '').trim(), moshafs: list);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'moshaf': [for (final m in moshafs) m.toJson()],
      };
}

const hafs = 'حفص عن عاصم';

/// Splits «حفص عن عاصم - مرتل» / «المصحف المجود - المصحف المجود» /
/// «حفص عن عاصم - تسجيل عام 1387 هـ - 1967م» into (riwayah, kind, note).
(String, RecitationKind, String?) parseMoshafName(String name) {
  final parts = name.split(RegExp(r'\s+-\s+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  if (parts.isEmpty) return (hafs, RecitationKind.murattal, null);
  var riwayah = parts.first;
  final rest = parts.skip(1).toList();
  RecitationKind kind = RecitationKind.murattal;
  bool isKind(String s, String w) => s.contains(w);
  if (parts.any((p) => isKind(p, 'المعلم'))) {
    kind = RecitationKind.muallim;
  } else if (parts.any((p) => isKind(p, 'المجود') || isKind(p, 'مجود'))) {
    kind = RecitationKind.mujawwad;
  }
  if (riwayah.startsWith('المصحف')) riwayah = hafs;
  final notes = [
    for (final p in rest)
      if (p != 'مرتل' && !p.startsWith('المصحف')) p,
  ];
  return (riwayah, kind, notes.isEmpty ? null : notes.join(' - '));
}

/// «1,2,3» (or a list) → sorted unique surah numbers in 1..114.
List<int> parseSurahList(Object? raw) {
  final Iterable<Object?> items = raw is List ? raw : '${raw ?? ''}'.split(',');
  final out = <int>{};
  for (final i in items) {
    final s = '$i'.trim();
    final range = RegExp(r'^(\d+)-(\d+)$').firstMatch(s);
    if (range != null) {
      // «1-114»: our compact cache form.
      final a = int.parse(range[1]!), b = int.parse(range[2]!);
      for (var n = a < 1 ? 1 : a; n <= (b > 114 ? 114 : b); n++) {
        out.add(n);
      }
      continue;
    }
    final n = i is num ? i.toInt() : int.tryParse(s);
    if (n != null && n >= 1 && n <= 114) out.add(n);
  }
  return out.toList()..sort();
}

/// [1,2,3,5,7,8] → «1-3,5,7-8» (the local cache form; parsed back by
/// [parseSurahList]).
String compactSurahList(List<int> surahs) {
  final parts = <String>[];
  var i = 0;
  while (i < surahs.length) {
    var j = i;
    while (j + 1 < surahs.length && surahs[j + 1] == surahs[j] + 1) {
      j++;
    }
    parts.add(j == i ? '${surahs[i]}' : '${surahs[i]}-${surahs[j]}');
    i = j + 1;
  }
  return parts.join(',');
}

/// Forces https and a trailing «/».
String normaliseServer(String s) {
  var v = s.trim();
  if (v.isEmpty) return v;
  if (v.startsWith('http://')) v = 'https://${v.substring(7)}';
  return v.endsWith('/') ? v : '$v/';
}

/// server + «001».mp3.
String surahUrl(String server, int surah) => '${normaliseServer(server)}${surah.toString().padLeft(3, '0')}.mp3';

bool _bsearch(List<int> l, int v) {
  var lo = 0, hi = l.length - 1;
  while (lo <= hi) {
    final mid = (lo + hi) >> 1;
    if (l[mid] == v) return true;
    if (l[mid] < v) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return false;
}

/// Parses the API body (`{"reciters": [...]}`) — reciters without a usable
/// mushaf are dropped.
List<Reciter> parseReciters(Object? body) {
  final list = body is Map ? body['reciters'] : body;
  if (list is! List) return const [];
  return [
    for (final r in list)
      if (r is Map) Reciter.fromJson(Map<String, dynamic>.from(r)),
  ]..removeWhere((r) => r.moshafs.isEmpty || r.name.isEmpty);
}

// ------------------------------------------------------------------ search
/// Folds Arabic spelling variants (أ إ آ ٱ → ا، ة → ه، ى → ي, tashkeel,
/// tatweel, spaces) so «عبد الباسط» finds «عبدالباسط».
String foldArabic(String s) => s
    .replaceAll(RegExp('[ً-ٰٟـ]'), '')
    .replaceAll(RegExp('[أإآٱ]'), 'ا')
    .replaceAll('ة', 'ه')
    .replaceAll('ى', 'ي')
    .replaceAll('ؤ', 'و')
    .replaceAll('ئ', 'ي')
    .replaceAll(RegExp(r'\s+'), '')
    .toLowerCase();

/// The riwayah filter chips: label → the key its riwayah names contain.
const riwayahFilters = <String>['حفص', 'ورش', 'قالون', 'الدوري', 'السوسي', 'شعبة', 'البزي', 'قنبل', 'خلف', 'ابن ذكوان', 'هشام', 'يعقوب', 'ابن جماز'];

bool riwayahMatches(String riwayah, String filter) => foldArabic(riwayah).contains(foldArabic(filter));

/// Well-known reciters pinned first, in this order (matched on folded name).
const popularReciters = <String>[
  'محمود خليل الحصري',
  'محمد صديق المنشاوي',
  'عبدالباسط عبدالصمد',
  'مشاري العفاسي',
  'عبدالرحمن السديس',
  'سعود الشريم',
  'ماهر المعيقلي',
  'سعد الغامدي',
  'ياسر الدوسري',
  'محمد أيوب',
  'محمد الطبلاوي',
  'محمود علي البنا',
  'أحمد بن علي العجمي',
  'علي بن عبدالرحمن الحذيفي',
  'ناصر القطامي',
  'إدريس أبكر',
  'فارس عباد',
  'أبو بكر الشاطري',
];

int popularRank(String name) {
  final f = foldArabic(name);
  for (var i = 0; i < popularReciters.length; i++) {
    if (f.contains(foldArabic(popularReciters[i]))) return i;
  }
  return 1 << 20;
}

/// Popular first (in [popularReciters] order), then alphabetical.
List<Reciter> sortReciters(Iterable<Reciter> list) {
  final ranked = [for (final r in list) (popularRank(r.name), r)];
  ranked.sort((a, b) {
    final c = a.$1.compareTo(b.$1);
    return c != 0 ? c : a.$2.name.compareTo(b.$2.name);
  });
  return [for (final e in ranked) e.$2];
}

/// Search + riwayah + kind filter (all optional).
List<Reciter> filterReciters(List<Reciter> list, {String query = '', String? riwayah, RecitationKind? kind, Set<int>? onlyIds}) {
  final q = foldArabic(query);
  return [
    for (final r in list)
      if ((q.isEmpty || foldArabic(r.name).contains(q)) &&
          (onlyIds == null || onlyIds.contains(r.id)) &&
          r.moshafs.any((m) => (riwayah == null || riwayahMatches(m.riwayah, riwayah)) && (kind == null || m.kind == kind)))
        r,
  ];
}

/// The mushafs of [r] that pass the filters (all when none apply).
List<Moshaf> matchingMoshafs(Reciter r, {String? riwayah, RecitationKind? kind}) => [
      for (final m in r.moshafs)
        if ((riwayah == null || riwayahMatches(m.riwayah, riwayah)) && (kind == null || m.kind == kind)) m,
    ];

/// «12.3 ميجا» / «850 كيلو».
String formatBytes(int bytes) {
  if (bytes >= 1024 * 1024) {
    final mb = bytes / (1024 * 1024);
    return '${mb >= 10 ? mb.round() : mb.toStringAsFixed(1)} ميجا';
  }
  return '${(bytes / 1024).round()} كيلو';
}
