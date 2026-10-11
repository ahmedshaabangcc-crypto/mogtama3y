import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/masjid_tools/hijri.dart' show toArabicDigits;
import '../../core/masjid_tools/platform/kv_store.dart';
import '../../core/masjid_tools/quran_meta.dart';
import '../../core/masjid_tools/quran_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'tools_ui.dart';

// ------------------------------------------------------------------ state
/// «آخر قراءة» and the reading font size, kept on this device.
class QuranPrefs {
  QuranPrefs._();

  static const _lastKey = 'mt.quran.last';
  static const _fontKey = 'mt.quran.font';

  static Future<(int surah, int ayah)?> lastRead() async {
    try {
      final raw = await kvGet(_lastKey);
      if (raw == null) return null;
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final s = (j['s'] as num).toInt(), a = (j['a'] as num).toInt();
      if (s < 1 || s > 114 || a < 1 || a > surahData[s - 1].$2) return null;
      return (s, a);
    } catch (_) {
      return null;
    }
  }

  static Future<void> setLastRead(int surah, int ayah) async {
    try {
      await kvSet(_lastKey, jsonEncode({'s': surah, 'a': ayah, 't': DateTime.now().toIso8601String()}));
    } catch (_) {}
  }

  static Future<double> fontSize() async {
    try {
      return (double.tryParse(await kvGet(_fontKey) ?? '') ?? 26).clamp(18, 44).toDouble();
    } catch (_) {
      return 26;
    }
  }

  static Future<void> setFontSize(double v) async {
    try {
      await kvSet(_fontKey, v.toStringAsFixed(1));
    } catch (_) {}
  }
}

/// Amiri Quran (SIL OFL 1.1), bundled as an asset and loaded only when the
/// reader opens; until then (or if it fails) the app font is used.
class QuranFont {
  QuranFont._();
  static const family = 'AmiriQuranMT';
  static Future<bool>? _loading;
  static bool ready = false;

  static Future<bool> ensure() => _loading ??= () async {
        try {
          final loader = FontLoader(family)..addFont(rootBundle.load('assets/quran/AmiriQuran-Regular.ttf'));
          await loader.load();
          ready = true;
          return true;
        } catch (_) {
          return false;
        }
      }();
}

String surahTitle(int s) => 'سورة ${surahData[s - 1].$1}';

// ------------------------------------------------------------------ index
class QuranHomeScreen extends StatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  State<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends State<QuranHomeScreen> {
  final _search = TextEditingController();
  (int, int)? _last;
  bool _juz = false;

  @override
  void initState() {
    super.initState();
    // Start fetching the text and font now, so the first surah opens fast.
    QuranText.load().ignore();
    QuranFont.ensure().ignore();
    _loadLast();
  }

  Future<void> _loadLast() async {
    final l = await QuranPrefs.lastRead();
    if (mounted) setState(() => _last = l);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _open(int surah, [int ayah = 1]) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => SurahReaderScreen(surah: surah, ayah: ayah)));
    _loadLast();
  }

  @override
  Widget build(BuildContext context) {
    final results = searchSurahs(_search.text);
    final side = ToolScaffold.side(context);
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        iconTheme: AppTheme.nightBarIcons,
        actionsIconTheme: AppTheme.nightBarIcons,
        titleTextStyle: nightTitleStyle(context),
        title: const Text('المصحف'),
        actions: [
          IconButton(
            tooltip: 'مصدر النص والخط',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ToolsCreditsScreen())),
          ),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(side, 8, side, 0),
          sliver: SliverList.list(children: [
            if (_last != null)
              GlassCard(
                highlight: true,
                onTap: () => _open(_last!.$1, _last!.$2),
                child: Row(children: [
                  const Icon(Icons.bookmark_rounded, color: AppColors.gold),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('كمّل من آخر قراءة', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('${surahTitle(_last!.$1)} — آية ${toArabicDigits(_last!.$2)}', style: toolTitleStyle),
                      Text('الجزء ${toArabicDigits(juzOf(_last!.$1, _last!.$2))}', style: toolMutedStyle),
                    ]),
                  ),
                  const Icon(Icons.chevron_left_rounded, color: Colors.white70),
                ]),
              ),
            TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'دوّر على سورة بالاسم أو الرقم…',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 10),
            if (_search.text.trim().isEmpty)
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: false, label: Text('السور'), icon: Icon(Icons.list_rounded)),
                  ButtonSegment(value: true, label: Text('الأجزاء'), icon: Icon(Icons.layers_rounded)),
                ],
                selected: {_juz},
                onSelectionChanged: (s) => setState(() => _juz = s.first),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.night : Colors.white),
                  backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.gold : Colors.transparent),
                ),
              ),
            const SizedBox(height: 8),
          ]),
        ),
        if (_juz && _search.text.trim().isEmpty)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(side, 0, side, 40),
            sliver: SliverList.builder(
              itemCount: 30,
              itemBuilder: (context, i) {
                final (s, a) = juzStarts[i];
                return _row(
                  number: i + 1,
                  title: 'الجزء ${toArabicDigits(i + 1)}',
                  subtitle: 'يبدأ من ${surahTitle(s)} — آية ${toArabicDigits(a)}',
                  onTap: () => _open(s, a),
                );
              },
            ),
          )
        else if (results.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(padding: EdgeInsets.all(24), child: Text('مفيش سورة بالاسم ده', textAlign: TextAlign.center, style: toolMutedStyle)),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(side, 0, side, 40),
            sliver: SliverList.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                final s = results[i];
                final d = surahData[s - 1];
                return _row(
                  number: s,
                  title: surahTitle(s),
                  subtitle: '${d.$3 ? 'مكية' : 'مدنية'} • ${toArabicDigits(d.$2)} آية',
                  onTap: () => _open(s),
                );
              },
            ),
          ),
      ]),
    );
  }

  Widget _row({required int number, required String title, required String subtitle, required VoidCallback onTap}) => GlassCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        onTap: onTap,
        child: Row(children: [
          AyahMarker(number: number, size: 38, color: AppColors.gold, textColor: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: toolTitleStyle),
              Text(subtitle, style: toolMutedStyle),
            ]),
          ),
          const Icon(Icons.chevron_left_rounded, color: Colors.white54),
        ]),
      );
}

// ------------------------------------------------------------------ marker
/// The ornamental end-of-ayah marker: an eight-pointed star with the number.
class AyahMarker extends StatelessWidget {
  const AyahMarker({super.key, required this.number, this.size = 30, this.color = const Color(0xFFB8862B), this.textColor = const Color(0xFF5A3E0B), this.highlighted = false});
  final int number;
  final double size;
  final Color color;
  final Color textColor;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final digits = toArabicDigits(number);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StarPainter(color, highlighted ? color.withValues(alpha: 0.35) : null),
        child: Center(
          child: Text(
            digits,
            textScaler: TextScaler.noScaling,
            style: TextStyle(color: textColor, fontSize: size * (digits.length > 2 ? 0.30 : 0.36), fontWeight: FontWeight.w700, height: 1),
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.color, this.fill);
  final Color color;
  final Color? fill;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 1;
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final rr = i.isEven ? r : r * 0.82;
      final a = i * math.pi / 8 - math.pi / 2;
      final p = c + Offset(math.cos(a) * rr, math.sin(a) * rr);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    if (fill != null) canvas.drawPath(path, Paint()..color = fill!);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1, size.shortestSide / 22);
    canvas.drawPath(path, stroke);
    canvas.drawCircle(c, r * 0.62, stroke..strokeWidth = math.max(0.8, size.shortestSide / 34));
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color || old.fill != fill;
}

// ------------------------------------------------------------------ reader
class SurahReaderScreen extends StatefulWidget {
  const SurahReaderScreen({super.key, required this.surah, this.ayah = 1});
  final int surah;
  final int ayah;

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  static const _paper = Color(0xFFFBF6EA);
  static const _ink = Color(0xFF1E1A12);
  static const _chunk = 6;

  late final int _surah = widget.surah;
  late final int _target = widget.ayah;
  QuranText? _text;
  Object? _error;
  double _font = 26;
  bool _fontReady = QuranFont.ready;
  (int, int)? _bookmark;
  final _centerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final results = await Future.wait([QuranText.load(), QuranPrefs.fontSize(), QuranFont.ensure(), QuranPrefs.lastRead()]);
      if (!mounted) return;
      setState(() {
        _text = results[0] as QuranText;
        _font = results[1] as double;
        _fontReady = results[2] as bool;
        _bookmark = results[3] as (int, int)?;
      });
      // Opening a surah counts as the last place read, unless the user
      // marked an ayah in this same surah.
      if (_bookmark?.$1 != _surah) {
        await QuranPrefs.setLastRead(_surah, _target);
        if (mounted) setState(() => _bookmark = (_surah, _target));
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _goSurah(int s) {
    if (s < 1 || s > 114) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SurahReaderScreen(surah: s)));
  }

  Future<void> _fontSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('حجم الخط', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              Slider(
                value: _font,
                min: 18,
                max: 44,
                divisions: 13,
                label: toArabicDigits(_font.round()),
                onChanged: (v) {
                  setSheet(() {});
                  setState(() => _font = v);
                },
                onChangeEnd: QuranPrefs.setFontSize,
              ),
              Text('بِسْمِ ٱللَّهِ', style: TextStyle(fontFamily: _fontReady ? QuranFont.family : null, fontSize: _font)),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _ayahSheet(int ayah) async {
    final text = _text!.ayah(_surah, ayah);
    final marked = _bookmark == (_surah, ayah);
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            title: Text('${surahTitle(_surah)} — آية ${toArabicDigits(ayah)}', style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text('الجزء ${toArabicDigits(juzOf(_surah, ayah))}${sajdaAyahs.contains((_surah, ayah)) ? ' • موضع سجدة' : ''}'),
          ),
          ListTile(
            leading: Icon(marked ? Icons.bookmark_rounded : Icons.bookmark_add_outlined, color: AppColors.crystal),
            title: Text(marked ? 'دي آخر قراءة ليك' : 'علّم هنا (آخر قراءة)'),
            onTap: () async {
              Navigator.pop(ctx);
              await QuranPrefs.setLastRead(_surah, ayah);
              if (!mounted) return;
              setState(() => _bookmark = (_surah, ayah));
              toolToast(context, 'اتحفظ مكانك: آية ${toArabicDigits(ayah)}');
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy_rounded, color: AppColors.crystal),
            title: const Text('انسخ الآية'),
            onTap: () async {
              Navigator.pop(ctx);
              await Clipboard.setData(ClipboardData(text: '$text\n[${surahTitle(_surah)}: ${toArabicDigits(ayah)}]'));
              if (mounted) toolToast(context, 'اتنسخت الآية');
            },
          ),
        ]),
      ),
    );
  }

  TextStyle get _quranStyle => TextStyle(
        fontFamily: _fontReady ? QuranFont.family : null,
        fontSize: _font,
        height: _fontReady ? 2.1 : 1.9,
        color: _ink,
      );

  /// «استماع القرآن» for this surah (choose the reciter there).
  void _listen() => context.push('/masjid/tools/listen?surah=$_surah');

  Widget _header() {
    final d = surahData[_surah - 1];
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB8862B), width: 1.4),
          color: const Color(0xFFF3E7C9),
        ),
        child: Column(children: [
          Text(surahTitle(_surah), style: TextStyle(fontFamily: _fontReady ? QuranFont.family : null, fontSize: 24, color: _ink, fontWeight: FontWeight.w700)),
          Text('${d.$3 ? 'مكية' : 'مدنية'} • ${toArabicDigits(d.$2)} آية', style: const TextStyle(color: Color(0xFF6B5A35), fontSize: 12)),
          TextButton.icon(
            onPressed: _listen,
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF8A6417), visualDensity: VisualDensity.compact),
            icon: const Icon(Icons.headphones_rounded, size: 18),
            label: const Text('استمع للسورة', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
      if (_surah != 1 && _surah != 9)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(splitBasmala(_surah, 1, _text!.ayah(_surah, 1)).basmala ?? basmalaUthmani, textAlign: TextAlign.center, style: _quranStyle.copyWith(fontSize: _font * 0.95)),
        ),
    ]);
  }

  Widget _chunkWidget(int chunk) {
    final count = _text!.ayahCount(_surah);
    final from = chunk * _chunk + 1;
    final to = math.min(count, from + _chunk - 1);
    final spans = <InlineSpan>[];
    for (var a = from; a <= to; a++) {
      final split = splitBasmala(_surah, a, _text!.ayah(_surah, a));
      final marked = _bookmark == (_surah, a);
      spans.add(TextSpan(
        text: '${split.text} ',
        style: marked ? const TextStyle(backgroundColor: Color(0x33E0B24F)) : (a == _target && _target != 1 ? const TextStyle(backgroundColor: Color(0x1A1B3A6E)) : null),
      ));
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: () => _ayahSheet(a),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AyahMarker(number: a, size: (_font * 1.15).clamp(24, 46), highlighted: marked),
          ),
        ),
      ));
      spans.add(const TextSpan(text: ' '));
    }
    final last = to == count;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ToolScaffold.side(context)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (chunk == 0) _header(),
        Text.rich(TextSpan(children: spans), textAlign: TextAlign.justify, textDirection: TextDirection.rtl, style: _quranStyle),
        if (last) _footer(),
      ]),
    );
  }

  Widget _footer() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 24, 0, 40),
        child: Row(children: [
          if (_surah > 1)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _goSurah(_surah - 1),
                icon: const Icon(Icons.chevron_right_rounded),
                label: Text(surahTitle(_surah - 1), overflow: TextOverflow.ellipsis),
              ),
            ),
          if (_surah > 1 && _surah < 114) const SizedBox(width: 10),
          if (_surah < 114)
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _goSurah(_surah + 1),
                icon: const Icon(Icons.chevron_left_rounded),
                label: Text(surahTitle(_surah + 1), overflow: TextOverflow.ellipsis),
              ),
            ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final t = _text;
    Widget body;
    if (_error != null) {
      body = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('معرفناش نحمّل المصحف — اتأكد من النت وجرّب تاني', style: TextStyle(color: _ink)),
          const SizedBox(height: 10),
          FilledButton(onPressed: _load, child: const Text('جرّب تاني')),
        ]),
      );
    } else if (t == null) {
      body = const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text('بنجهّز المصحف…', style: TextStyle(color: _ink)),
        ]),
      );
    } else {
      final count = t.ayahCount(_surah);
      final chunks = (count + _chunk - 1) ~/ _chunk;
      final start = ((_target - 1) ~/ _chunk).clamp(0, chunks - 1);
      body = CustomScrollView(
        center: _centerKey,
        slivers: [
          SliverList.builder(itemCount: start, itemBuilder: (_, i) => _chunkWidget(start - 1 - i)),
          SliverPadding(
            key: _centerKey,
            padding: const EdgeInsets.only(top: 8),
            sliver: SliverList.builder(itemCount: chunks - start, itemBuilder: (_, i) => _chunkWidget(start + i)),
          ),
        ],
      );
    }
    return Scaffold(
      backgroundColor: _paper,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E7C9),
        foregroundColor: _ink,
        title: Text(surahTitle(_surah)),
        actions: [
          IconButton(tooltip: 'استمع للسورة', icon: const Icon(Icons.headphones_rounded), onPressed: _listen),
          IconButton(tooltip: 'حجم الخط', icon: const Icon(Icons.format_size_rounded), onPressed: _fontSheet),
        ],
      ),
      body: body,
    );
  }
}

// ------------------------------------------------------------------ credits
const tanzilNoticeFallback = '''Tanzil Quran Text (Uthmani, Version 1.1)
Copyright (C) 2007-2026 Tanzil Project
License: Creative Commons Attribution 3.0''';

/// Sources and licences of everything in «أدوات يومية».
class ToolsCreditsScreen extends StatefulWidget {
  const ToolsCreditsScreen({super.key});

  @override
  State<ToolsCreditsScreen> createState() => _ToolsCreditsScreenState();
}

class _ToolsCreditsScreenState extends State<ToolsCreditsScreen> {
  String? _notice;

  @override
  void initState() {
    super.initState();
    QuranText.load().then((t) {
      if (mounted) setState(() => _notice = t.notice);
    }).catchError((_) {});
  }

  Widget _link(String label, String url) => TextButton.icon(
        onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        icon: const Icon(Icons.open_in_new_rounded, size: 16, color: AppColors.gold),
        label: Text(label, style: const TextStyle(color: AppColors.gold)),
      );

  @override
  Widget build(BuildContext context) {
    return ToolScaffold(title: 'المصادر والتراخيص', children: [
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('نص القرآن الكريم', style: toolTitleStyle),
          const SizedBox(height: 6),
          const Text(
            'نص المصحف (الرسم العثماني) من مشروع تنزيل Tanzil، منقول حرفياً من غير أي تعديل، '
            'بترخيص المشاع الإبداعي (CC BY 3.0). بيانات السور والأجزاء من تنزيل كمان.',
            style: toolMutedStyle,
          ),
          _link('tanzil.net', 'https://tanzil.net'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
            child: SelectableText(
              _notice ?? tanzilNoticeFallback,
              textDirection: TextDirection.ltr,
              style: const TextStyle(color: Colors.white70, fontSize: 10.5, fontFamily: 'monospace', height: 1.4),
            ),
          ),
        ]),
      ),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('خط المصحف', style: toolTitleStyle),
          const SizedBox(height: 6),
          const Text('خط «أميري قرآن» Amiri Quran — Copyright 2010-2022 The Amiri Quran Project Authors، '
              'بترخيص SIL Open Font License 1.1.', style: toolMutedStyle),
          _link('github.com/aliftype/amiri', 'https://github.com/aliftype/amiri'),
          _link('openfontlicense.org', 'https://openfontlicense.org'),
        ]),
      ),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('التلاوات (استماع)', style: toolTitleStyle),
          const SizedBox(height: 6),
          const Text('التلاوات من موقع mp3quran.net — بيتيح استخدام مواده وروابطه للجميع. الصوت بيتشغّل مباشرة من سيرفراتهم.', style: toolMutedStyle),
          _link('mp3quran.net', 'https://www.mp3quran.net/ar'),
        ]),
      ),
      const GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('الأذكار', style: toolTitleStyle),
          SizedBox(height: 6),
          Text('من كتاب «حصن المسلم» للشيخ سعيد بن علي بن وهف القحطاني، مع ذكر مصدر كل حديث باختصار. '
              'الآيات من نص تنزيل.', style: toolMutedStyle),
        ]),
      ),
      const GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('التقويم والمواقيت والقبلة', style: toolTitleStyle),
          SizedBox(height: 6),
          Text('التاريخ الهجري بتقويم أم القرى (حساب فلكي) وقد يختلف يوم عن رؤية الهلال المعلنة في بلدك (زي دار الإفتاء المصرية). '
              'مواقيت الصلاة بطريقة الجهة الرسمية في كل بلد (الهيئة المصرية العامة للمساحة في مصر، أم القرى في السعودية، أوقاف الإمارات…، ورابطة العالم الإسلامي لغيرها) وتقدر تغيّرها من «طريقة الحساب». '
              'اتجاه القبلة محسوب بأقصر مسار على الكرة الأرضية للكعبة المشرفة.',
              style: toolMutedStyle),
        ]),
      ),
    ]);
  }
}
