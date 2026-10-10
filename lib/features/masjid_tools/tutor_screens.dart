import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/masjid_tools/hijri.dart' show toArabicDigits;
import '../../core/masjid_tools/platform/kv_store.dart';
import '../../core/masjid_tools/platform/tutor_engine.dart';
import '../../core/masjid_tools/quran_meta.dart';
import '../../core/masjid_tools/quran_text.dart';
import '../../core/masjid_tools/recitation_align.dart';
import '../../core/masjid_tools/tutor_progress.dart';
import '../../core/theme/app_colors.dart';
import 'quran_screens.dart' show QuranFont, surahTitle;
import 'tools_ui.dart';

// =================================================================== store
enum ModelState { idle, loading, ready, failed }

/// «المحفّظ» state shared by its screens: settings, progress (device +
/// server copy), and the speech model's loading state.
class TutorStore extends ChangeNotifier {
  TutorStore._();
  static final instance = TutorStore._();

  static const _settingsKey = 'mt.tutor.settings';
  static const _progressKey = 'mt.tutor.progress';
  static const _lastKey = 'mt.tutor.last';

  final engine = TutorEngine.instance;
  TutorSettings settings = const TutorSettings();
  TutorProgress progress = TutorProgress();
  TutorSupport? support;
  bool loaded = false;

  ModelState model = ModelState.idle;
  int bytesLoaded = 0, bytesTotal = 0;
  TutorModelInfo? modelInfo;
  TutorError? modelError;

  (int surah, int from, int to)? last;

  Future<void>? _init;
  Timer? _syncTimer;
  bool _syncing = false;

  static bool get debug => kDebugMode || Uri.base.queryParameters['debug'] == '1';

  Future<void> init() => _init ??= () async {
        try {
          final s = await kvGet(_settingsKey);
          if (s != null) settings = TutorSettings.fromJson(jsonDecode(s) as Map<String, dynamic>);
        } catch (_) {}
        try {
          final p = await kvGet(_progressKey);
          if (p != null) progress = TutorProgress.fromJson(jsonDecode(p) as Map<String, dynamic>);
        } catch (_) {}
        try {
          final l = await kvGet(_lastKey);
          if (l != null) {
            final j = jsonDecode(l) as Map<String, dynamic>;
            final s = (j['s'] as num).toInt(), f = (j['f'] as num).toInt(), t = (j['t'] as num).toInt();
            if (validAyah(s, f) && validAyah(s, t) && f <= t) last = (s, f, t);
          }
        } catch (_) {}
        support = await engine.support();
        loaded = true;
        notifyListeners();
        if (settings.optedIn) loadModel();
        sync();
      }();

  Future<void> saveSettings(TutorSettings s) async {
    settings = s;
    notifyListeners();
    await kvSet(_settingsKey, jsonEncode(s.toJson()));
  }

  Future<void> saveProgress() async {
    notifyListeners();
    await kvSet(_progressKey, jsonEncode(progress.toJson()));
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 4), sync);
  }

  Future<void> setLast(int surah, int from, int to) async {
    last = (surah, from, to);
    await kvSet(_lastKey, jsonEncode({'s': surah, 'f': from, 't': to}));
  }

  /// Starts (or retries) loading the speech model.
  Future<void> loadModel() async {
    if (model == ModelState.loading || model == ModelState.ready) return;
    model = ModelState.loading;
    modelError = null;
    notifyListeners();
    try {
      modelInfo = await engine.loadModel(onProgress: (l, t) {
        bytesLoaded = l;
        bytesTotal = t;
        notifyListeners();
      }, prefer: Uri.base.queryParameters['tutor_device'] ?? 'auto');
      model = ModelState.ready;
      if (debug) debugPrint('[tutor] model ready: ${modelInfo!.device} ${modelInfo!.dtype} in ${modelInfo!.loadMs} ms (cached before: ${modelInfo!.cached})');
    } on TutorError catch (e) {
      model = ModelState.failed;
      modelError = e;
      if (debug) debugPrint('[tutor] model failed: $e');
    }
    notifyListeners();
  }

  /// Two-way sync with quran_tutor_progress (0084) when signed in.
  Future<void> sync() async {
    if (_syncing) return;
    bool signedIn;
    try {
      signedIn = AuthService.isSignedIn;
    } catch (_) {
      return;
    }
    if (!signedIn) return;
    _syncing = true;
    try {
      final db = Supabase.instance.client;
      final remote = await db.from('quran_tutor_progress').select('surah, ayah, status, perfect_count, updated_at');
      final changed = progress.mergeRemote(remote);
      for (var round = 0; round < 25; round++) {
        final rows = progress.dirtyRows();
        if (rows.isEmpty) break;
        await db.rpc('quran_tutor_save', params: {'p_rows': rows});
        progress.markUploaded(rows);
      }
      await kvSet(_progressKey, jsonEncode(progress.toJson()));
      if (changed) notifyListeners();
    } catch (_) {
      // Offline or not migrated yet — the device copy stays the source.
    } finally {
      _syncing = false;
    }
  }

  Future<void> resetSurah(int surah) async {
    final fresh = TutorProgress.fromJson(progress.toJson());
    final j = fresh.toJson();
    (j['rows'] as Map).removeWhere((k, _) => int.parse('$k') ~/ 1000 == surah);
    progress = TutorProgress.fromJson(j);
    await saveProgress();
    try {
      if (AuthService.isSignedIn) await Supabase.instance.client.rpc('quran_tutor_reset', params: {'p_surah': surah});
    } catch (_) {}
  }
}

String _mb(int bytes) => toArabicDigits((bytes / 1e6).round());

/// The ayah's text as recited: the basmala Tanzil prefixes to ayah 1 (all
/// surahs but 1 and 9) is not part of the ayah.
String tutorAyahText(QuranText q, int surah, int ayah) => splitBasmala(surah, ayah, q.ayah(surah, ayah)).text;

const _quranStyle = TextStyle(fontFamily: QuranFont.family, color: Colors.white, fontSize: 27, height: 2.0);

const _okColor = Color(0xFF34D399);
const _nearColor = Color(0xFFFBBF24);
const _wrongColor = Color(0xFFF87171);

// ==================================================================== home
class QuranTutorScreen extends StatefulWidget {
  const QuranTutorScreen({super.key});

  @override
  State<QuranTutorScreen> createState() => _QuranTutorScreenState();
}

class _QuranTutorScreenState extends State<QuranTutorScreen> {
  final store = TutorStore.instance;
  final _search = TextEditingController();
  bool _all = false;
  ({int quota, int usage})? _storage;
  QuranText? _quran;

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
    store.init().then((_) async {
      final st = await store.engine.storage();
      if (mounted) setState(() => _storage = st);
    });
    QuranText.load().then((q) {
      if (mounted) setState(() => _quran = q);
    }).catchError((_) {});
    QuranFont.ensure().ignore();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    _search.dispose();
    super.dispose();
  }

  Future<void> _optIn() async {
    await store.saveSettings(store.settings.copyWith(optedIn: true));
    store.engine.persistStorage();
    store.loadModel();
  }

  Future<void> _open(int surah, [int? from, int? to]) async {
    if (_quran == null) {
      toolToast(context, 'لحظة… بنجهّز نص المصحف');
      return;
    }
    final range = (from != null && to != null) ? (from, to) : await pickTutorRange(context, surah);
    if (range == null || !mounted) return;
    await store.setLast(surah, range.$1, range.$2);
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TutorSessionScreen(surah: surah, from: range.$1, to: range.$2, quran: _quran!)));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final s = store.settings;
    return ToolScaffold(
      title: 'المحفّظ',
      actions: [
        if (s.optedIn)
          IconButton(
            tooltip: 'تقدّمي',
            icon: const Icon(Icons.insights_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TutorProgressScreen())),
          ),
        IconButton(tooltip: 'إعدادات المحفّظ', icon: const Icon(Icons.tune_rounded), onPressed: () => showTutorSettings(context)),
      ],
      children: !store.loaded
          ? const [Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator(color: AppColors.gold)))]
          : (s.optedIn ? _home() : _intro()),
    );
  }

  // --------------------------------------------------------------- intro
  List<Widget> _intro() {
    final sup = store.support ?? const TutorSupport();
    final free = _storage == null ? null : _storage!.quota - _storage!.usage;
    String? blocker;
    if (!sup.canRun) {
      blocker = 'المتصفح ده مش بيدعم تشغيل المحفّظ. جرّب أحدث نسخة من Chrome (أندرويد) أو Safari (آيفون).';
    } else if (!sup.secure) {
      blocker = 'المحفّظ محتاج الموقع يفتح على https عشان يستخدم المايك.';
    } else if (!sup.mic || !sup.audio) {
      blocker = 'المتصفح ده مش بيسمح بالتسجيل من المايك.';
    }
    return [
      GlassCard(
        highlight: true,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.record_voice_over_rounded, color: AppColors.gold, size: 30),
            SizedBox(width: 10),
            Expanded(child: Text('سمّع، والمحفّظ يقولك صح ولا غلط', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17))),
          ]),
          const SizedBox(height: 12),
          for (final (icon, text) in const [
            (Icons.headphones_rounded, 'اسمع الآية بصوت الشيخ الحصري (المصحف المعلّم) مرة أو ٣ أو ٥ مرات.'),
            (Icons.mic_rounded, 'سمّعها من حفظك — والمحفّظ يلوّنلك كل كلمة: أخضر صح، أصفر راجعها، أحمر غلط.'),
            (Icons.verified_rounded, 'الآية تتحسب محفوظة لما تسمّعها صح مرتين ورا بعض (تقدر تغيّرها من الإعدادات).'),
            (Icons.lock_rounded, 'كل ده بيحصل على موبايلك — صوتك مش بيترفع على أي سيرفر.'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(icon, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.6))),
              ]),
            ),
        ]),
      ),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('أول مرة بس: تحميل المحفّظ', style: toolTitleStyle),
          const SizedBox(height: 6),
          Text(
            'هنحمّل ملف المحفّظ مرة واحدة (حوالي ${toArabicDigits(105)} ميجا) ويتحفظ على الجهاز، وبعد كده بيفتح من غير تحميل. '
            'يُفضّل تكون على Wi-Fi.',
            style: toolMutedStyle,
          ),
          if (free != null) ...[
            const SizedBox(height: 6),
            Text(
              free < 300e6 ? 'المساحة المتاحة للمتصفح قليلة (${_mb(free)} ميجا) — فضّي شوية مساحة الأول.' : 'المساحة المتاحة: كفاية ✓',
              style: TextStyle(color: free < 300e6 ? _nearColor : Colors.white60, fontSize: 12),
            ),
          ],
          if (sup.memoryGb > 0 && sup.memoryGb < 3) ...[
            const SizedBox(height: 6),
            const Text('الجهاز ده ذاكرته قليلة — المحفّظ ممكن يكون بطيء عليه.', style: TextStyle(color: _nearColor, fontSize: 12)),
          ],
        ]),
      ),
      const _Disclaimer(),
      const SizedBox(height: 6),
      if (blocker != null)
        GlassCard(child: Text(blocker, style: const TextStyle(color: _nearColor, fontSize: 13, height: 1.6)))
      else
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, minimumSize: const Size.fromHeight(52)),
          onPressed: _optIn,
          icon: const Icon(Icons.download_rounded),
          label: const Text('حمّل المحفّظ وابدأ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      const SizedBox(height: 14),
      const TutorCredits(),
    ];
  }

  // ---------------------------------------------------------------- home
  List<Widget> _home() {
    final p = store.progress;
    final q = _search.text.trim();
    final results = q.isEmpty ? const <int>[] : searchSurahs(q);
    final last = store.last;
    return [
      ModelStatusCard(store: store),
      Row(children: [
        Expanded(child: _stat(Icons.verified_rounded, '${toArabicDigits(p.memorizedTotal)} آية', 'حفظتها')),
        const SizedBox(width: 8),
        Expanded(
          child: _stat(Icons.local_fire_department_rounded, '${toArabicDigits(p.currentStreak())} يوم', p.practisedToday() ? 'ورا بعض — كمّل!' : 'سمّع النهارده عشان تكمّل'),
        ),
      ]),
      const SizedBox(height: 10),
      if (last != null)
        GlassCard(
          highlight: true,
          onTap: () => _open(last.$1, last.$2, last.$3),
          child: Row(children: [
            const Icon(Icons.play_circle_fill_rounded, color: AppColors.gold, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('كمّل من آخر مرة', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text('${surahTitle(last.$1)} — ${_rangeLabel(last.$2, last.$3)}', style: toolTitleStyle),
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
          hintText: 'عايز تحفظ سورة إيه؟',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.08),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 10),
      if (q.isNotEmpty) ...[
        if (results.isEmpty) const Text('مفيش سورة بالاسم ده', style: toolMutedStyle),
        for (final s in results) _surahTile(s),
      ] else ...[
        const Padding(
          padding: EdgeInsets.fromLTRB(2, 6, 2, 4),
          child: Text('ابدأ من هنا — الفاتحة وجزء عمّ', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 14)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 8),
          child: Text('السور القصيرة الأول، من الناس لحد النبأ.', style: toolMutedStyle),
        ),
        _surahTile(1),
        for (var s = 114; s >= 78; s--) _surahTile(s),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: () => setState(() => _all = !_all),
          icon: Icon(_all ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: Colors.white70),
          label: Text(_all ? 'اخفي باقي السور' : 'باقي السور (البقرة لحد المرسلات)', style: const TextStyle(color: Colors.white70)),
        ),
        if (_all)
          for (var s = 2; s <= 77; s++) _surahTile(s),
      ],
      const SizedBox(height: 12),
      const _Disclaimer(compact: true),
    ];
  }

  String _rangeLabel(int from, int to) => from == to ? 'آية ${toArabicDigits(from)}' : 'الآيات ${toArabicDigits(from)}–${toArabicDigits(to)}';

  Widget _stat(IconData icon, String value, String label) => GlassCard(
        margin: EdgeInsets.zero,
        child: Row(children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: toolTitleStyle),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white60, fontSize: 11)),
            ]),
          ),
        ]),
      );

  Widget _surahTile(int s) {
    final p = store.progress;
    final n = surahData[s - 1].$2;
    final done = p.memorizedIn(s);
    final pct = done / n;
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: () => _open(s),
      child: Row(children: [
        SizedBox(
          width: 36,
          height: 36,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: pct, strokeWidth: 3, color: _okColor, backgroundColor: Colors.white12),
            Text(toArabicDigits(s), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(surahTitle(s), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.5)),
            Text(
              done == 0 ? '${toArabicDigits(n)} آية' : (done == n ? 'محفوظة كلها ✓' : 'حفظت ${toArabicDigits(done)} من ${toArabicDigits(n)}'),
              style: TextStyle(color: done == n ? _okColor : Colors.white60, fontSize: 11.5),
            ),
          ]),
        ),
        if (pct > 0 && pct < 1) Text('${toArabicDigits((pct * 100).round())}٪', style: const TextStyle(color: _okColor, fontSize: 12, fontWeight: FontWeight.w700)),
        const Icon(Icons.chevron_left_rounded, color: Colors.white38),
      ]),
    );
  }
}

/// Download / readiness of the speech model.
class ModelStatusCard extends StatelessWidget {
  const ModelStatusCard({super.key, required this.store, this.compact = false});
  final TutorStore store;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    switch (store.model) {
      case ModelState.ready:
        if (compact) return const SizedBox.shrink();
        return const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Icon(Icons.check_circle_rounded, color: _okColor, size: 18),
            SizedBox(width: 6),
            Text('المحفّظ جاهز يسمعك', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
          ]),
        );
      case ModelState.failed:
        return GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(store.modelError?.message ?? 'معرفناش نشغّل المحفّظ', style: const TextStyle(color: _wrongColor, fontSize: 13, height: 1.6)),
            const SizedBox(height: 6),
            FilledButton.tonal(onPressed: store.loadModel, child: const Text('جرّب تاني')),
          ]),
        );
      case ModelState.idle:
      case ModelState.loading:
        final t = store.bytesTotal, l = store.bytesLoaded;
        final v = t > 0 ? (l / t).clamp(0.0, 1.0) : null;
        final downloading = t > 0 && l < t;
        return GlassCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              downloading ? 'بنحمّل المحفّظ… ${_mb(l)} من ${_mb(t)} ميجا' : 'بنجهّز المحفّظ…',
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: downloading ? v : null, minHeight: 7, color: AppColors.gold, backgroundColor: Colors.white12),
            ),
            if (!compact) ...[
              const SizedBox(height: 6),
              const Text('ممكن تسمع الآيات من دلوقتي لحد ما يخلص.', style: toolMutedStyle),
            ],
          ]),
        );
    }
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _nearColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _nearColor.withValues(alpha: 0.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline_rounded, color: _nearColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            compact
                ? 'مساعد للمراجعة مش بديل عن المحفّظ — ممكن يغلط، ومش بيحكم على التجويد.'
                : 'مساعد للمراجعة مش بديل عن المحفّظ — الذكاء الاصطناعي ممكن يغلط، ومش بيحكم على أحكام التجويد. '
                    'اقرا على شيخ أو محفّظ في مسجدك كمان.',
            style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.6),
          ),
        ),
      ]),
    );
  }
}

// ============================================================ range picker
Future<(int, int)?> pickTutorRange(BuildContext context, int surah) {
  final n = surahData[surah - 1].$2;
  final p = TutorStore.instance.progress;
  var firstOpen = 1;
  while (firstOpen <= n && p.of(surah, firstOpen).status == AyahStatus.memorized) {
    firstOpen++;
  }
  if (firstOpen > n) firstOpen = 1;
  var from = n <= 10 ? 1 : firstOpen;
  var to = n <= 10 ? n : (from + 4).clamp(1, n);
  return showModalBottomSheet<(int, int)>(
    context: context,
    backgroundColor: AppColors.nightMid,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setSheet) {
        Widget dropdown(String label, int value, void Function(int) onChanged) => Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                DropdownButton<int>(
                  value: value,
                  isExpanded: true,
                  dropdownColor: AppColors.nightMid,
                  menuMaxHeight: 320,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  items: [for (var a = 1; a <= n; a++) DropdownMenuItem(value: a, child: Text('آية ${toArabicDigits(a)}'))],
                  onChanged: (v) => v == null ? null : setSheet(() => onChanged(v)),
                ),
              ]),
            );
        Widget chip(String label, int f, int t) => ActionChip(
              label: Text(label),
              onPressed: () => setSheet(() {
                from = f;
                to = t;
              }),
            );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(surahTitle(surah), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('هتسمّع أنهي آيات؟ (${toArabicDigits(n)} آية)', style: toolMutedStyle),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 6, children: [
                if (n <= 30) chip('السورة كلها', 1, n),
                chip('أول ${toArabicDigits(n < 5 ? n : 5)} آيات', 1, n < 5 ? n : 5),
                if (firstOpen > 1) chip('كمّل من آية ${toArabicDigits(firstOpen)}', firstOpen, (firstOpen + 4).clamp(1, n)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                dropdown('من', from, (v) {
                  from = v;
                  if (to < from) to = from;
                }),
                const SizedBox(width: 16),
                dropdown('لحد', to, (v) {
                  to = v;
                  if (from > to) from = to;
                }),
              ]),
              if (to - from >= 10)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text('نصيحة: احفظ ٣–٥ آيات في المرة أسهل.', style: TextStyle(color: _nearColor, fontSize: 12)),
                ),
              const SizedBox(height: 14),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, minimumSize: const Size.fromHeight(48)),
                onPressed: () => Navigator.of(context).pop((from, to)),
                child: const Text('يلا نبدأ', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ]),
          ),
        );
      },
    ),
  );
}

// ================================================================ session
enum _Phase { idle, playing, recording, thinking, result }

class TutorSessionScreen extends StatefulWidget {
  const TutorSessionScreen({super.key, required this.surah, required this.from, required this.to, required this.quran});
  final int surah, from, to;
  final QuranText quran;

  @override
  State<TutorSessionScreen> createState() => _TutorSessionScreenState();
}

/// Longest recording for an ayah: 25 s, more for long ayahs.
Duration recordLimit(int words) => Duration(seconds: (6 + words * 1.2).round().clamp(25, 90));

class _TutorSessionScreenState extends State<TutorSessionScreen> {
  final store = TutorStore.instance;
  late int _ayah = widget.from;
  _Phase _phase = _Phase.idle;
  RecitationResult? _result;
  AyahProgress? _after;
  bool _peek = false;
  double _level = 0;
  DateTime? _recStart;
  Timer? _ticker;
  String? _error;
  String? _debugNote;
  int _thinkingSince = 0;

  TutorEngine get engine => store.engine;

  String get _text => tutorAyahText(widget.quran, widget.surah, _ayah);

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
    store.init();
    engine.prefetch(husaryMuallimUrl(widget.surah, _ayah));
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    _ticker?.cancel();
    engine.stopPlayback();
    engine.cancelRecording();
    super.dispose();
  }

  void _goto(int ayah) {
    if (_phase == _Phase.recording) engine.cancelRecording();
    engine.stopPlayback();
    _ticker?.cancel();
    setState(() {
      _ayah = ayah;
      _phase = _Phase.idle;
      _result = null;
      _after = null;
      _peek = false;
      _error = null;
      _debugNote = null;
    });
    engine.prefetch(husaryMuallimUrl(widget.surah, ayah));
    if (ayah < widget.to) engine.prefetch(husaryMuallimUrl(widget.surah, ayah + 1));
  }

  Future<void> _listen({int? times}) async {
    if (_phase == _Phase.playing) {
      engine.stopPlayback();
      setState(() => _phase = _result != null ? _Phase.result : _Phase.idle);
      return;
    }
    final back = _result != null ? _Phase.result : _Phase.idle;
    setState(() {
      _phase = _Phase.playing;
      _error = null;
    });
    final ok = await engine.play([husaryMuallimUrl(widget.surah, _ayah)], repeat: times ?? store.settings.repeat);
    if (!mounted || _phase != _Phase.playing) return;
    setState(() {
      _phase = back;
      if (!ok && _error == null) _error = null;
    });
  }

  Future<void> _record() async {
    if (store.model != ModelState.ready) return;
    engine.stopPlayback();
    final words = recitationWords(_text).length;
    setState(() {
      _phase = _Phase.recording;
      _error = null;
      _level = 0;
      _recStart = DateTime.now();
      _debugNote = null;
    });
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted) setState(() {});
    });
    try {
      await engine.startRecording(
        max: recordLimit(words),
        autoStop: store.settings.autoStop,
        onLevel: (l) => _level = l,
        onAutoStop: (_) => _stop(),
      );
    } on TutorError catch (e) {
      _ticker?.cancel();
      if (mounted) {
        setState(() {
          _phase = _result != null ? _Phase.result : _Phase.idle;
          _error = e.message;
        });
      }
    }
  }

  Future<void> _stop() async {
    if (_phase != _Phase.recording) return;
    _ticker?.cancel();
    setState(() {
      _phase = _Phase.thinking;
      _thinkingSince = DateTime.now().millisecondsSinceEpoch;
    });
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() {});
    });
    try {
      final rec = await engine.stopRecording();
      if (rec.seconds < 0.8) {
        _fail('التسجيل قصير أوي — دوس «سمّع» واقرا الآية كلها، وبعدين دوس «خلصت».');
        return;
      }
      final t = await engine.transcribe(rec);
      if (TutorStore.debug) debugPrint('[tutor] ${widget.surah}:$_ayah audio=${rec.seconds.toStringAsFixed(1)}s infer=${t.inferMs}ms text=${t.text}');
      _grade(t.text);
    } on TutorError catch (e) {
      _fail(e.message);
    }
  }

  void _fail(String message) {
    _ticker?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _result != null ? _Phase.result : _Phase.idle;
      _error = message;
    });
  }

  void _grade(String transcript) {
    _ticker?.cancel();
    if (!mounted) return;
    final r = alignRecitation(_text, transcript);
    AyahProgress? after;
    if (!r.empty) {
      after = store.progress.record(widget.surah, _ayah, perfect: r.perfect, needed: store.settings.perfectNeeded);
      store.saveProgress();
    }
    setState(() {
      _result = r;
      _after = after;
      _phase = _Phase.result;
      _peek = false;
    });
  }

  Future<void> _debugHusary() async {
    if (store.model != ModelState.ready) return;
    setState(() {
      _phase = _Phase.thinking;
      _thinkingSince = DateTime.now().millisecondsSinceEpoch;
      _error = null;
    });
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() {});
    });
    final sw = Stopwatch()..start();
    try {
      final t = await engine.transcribeUrl(husaryMuallimUrl(widget.surah, _ayah));
      final note = 'تلاوة الحصري ${t.seconds.toStringAsFixed(1)} ث — التعرّف ${(t.inferMs / 1000).toStringAsFixed(2)} ث (الكل ${(sw.elapsedMilliseconds / 1000).toStringAsFixed(2)} ث)\n${t.text}';
      debugPrint('[tutor-debug] ${widget.surah}:$_ayah audio=${t.seconds.toStringAsFixed(1)}s infer=${t.inferMs}ms total=${sw.elapsedMilliseconds}ms text=${t.text}');
      _grade(t.text);
      final r = _result;
      if (r != null) debugPrint('[tutor-debug] perfect=${r.perfect} ops=${r.ops.where((o) => o.status != WordStatus.ok).toList()}');
      setState(() => _debugNote = note);
    } on TutorError catch (e) {
      debugPrint('[tutor-debug] failed: $e');
      _fail(e.message);
    }
  }

  bool get _rangeMemorized {
    for (var a = widget.from; a <= widget.to; a++) {
      if (store.progress.of(widget.surah, a).status != AyahStatus.memorized) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final p = store.progress.of(widget.surah, _ayah);
    final needed = store.settings.perfectNeeded;
    final hide = store.settings.hideText && !_peek && _phase != _Phase.result;
    return ToolScaffold(
      title: surahTitle(widget.surah),
      actions: [IconButton(tooltip: 'إعدادات المحفّظ', icon: const Icon(Icons.tune_rounded), onPressed: () => showTutorSettings(context))],
      children: [
        ModelStatusCard(store: store, compact: true),
        _dots(),
        const SizedBox(height: 8),
        GlassCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Text('آية ${toArabicDigits(_ayah)}', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Text('(${toArabicDigits(_ayah - widget.from + 1)} من ${toArabicDigits(widget.to - widget.from + 1)})', style: toolMutedStyle),
              const Spacer(),
              _perfectMeter(p, needed),
            ]),
            const SizedBox(height: 10),
            if (hide)
              _hiddenText()
            else if (_result != null && _phase != _Phase.recording && _phase != _Phase.thinking)
              _coloured(_result!)
            else
              Text('$_text ﴿${toArabicDigits(_ayah)}﴾', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: _quranStyle),
          ]),
        ),
        if (_result != null && _phase == _Phase.result) _verdict(_result!),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(_error!, style: const TextStyle(color: _wrongColor, fontSize: 13, height: 1.6)),
          ),
        _controls(),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: store.settings.hideText,
          onChanged: (v) => store.saveSettings(store.settings.copyWith(hideText: v)),
          title: const Text('اختبر نفسك', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          subtitle: const Text('خبّي نص الآية وسمّع من حفظك', style: toolMutedStyle),
          activeThumbColor: AppColors.gold,
        ),
        if (widget.to > widget.from)
          GlassCard(
            highlight: _rangeMemorized,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TutorReviewScreen(surah: widget.surah, from: widget.from, to: widget.to, quran: widget.quran),
            )),
            child: Row(children: [
              const Icon(Icons.playlist_play_rounded, color: AppColors.gold, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('سمّع الآيات كلها مع بعض', style: toolTitleStyle),
                  Text(_rangeMemorized ? 'حفظت الآيات دي — سمّعها ورا بعض من غير ما تشوفها' : 'لما تخلّص الآيات واحدة واحدة، سمّعها كلها ورا بعض',
                      style: toolMutedStyle),
                ]),
              ),
              const Icon(Icons.chevron_left_rounded, color: Colors.white70),
            ]),
          ),
        if (TutorStore.debug) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: store.model == ModelState.ready && _phase != _Phase.thinking ? _debugHusary : null,
            icon: const Icon(Icons.bug_report_rounded),
            label: const Text('جرّب على تلاوة الحصري (للتجربة)'),
          ),
          if (_debugNote != null) Padding(padding: const EdgeInsets.only(top: 6), child: SelectableText(_debugNote!, style: toolMutedStyle)),
          if (store.modelInfo != null)
            Text('model: ${store.modelInfo!.device} ${store.modelInfo!.dtype}, load ${store.modelInfo!.loadMs} ms', style: toolMutedStyle),
        ],
        const SizedBox(height: 8),
        const _Disclaimer(compact: true),
      ],
    );
  }

  Widget _dots() {
    final n = widget.to - widget.from + 1;
    if (n == 1) return const SizedBox.shrink();
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: n,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final a = widget.from + i;
          final st = store.progress.of(widget.surah, a).status;
          final color = switch (st) { AyahStatus.memorized => _okColor, AyahStatus.learning => _nearColor, AyahStatus.none => Colors.white24 };
          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _phase == _Phase.thinking ? null : () => _goto(a),
            child: Container(
              width: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.25),
                border: Border.all(color: a == _ayah ? Colors.white : color, width: a == _ayah ? 2 : 1),
              ),
              child: Text(toArabicDigits(a), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          );
        },
      ),
    );
  }

  Widget _perfectMeter(AyahProgress p, int needed) {
    if (p.status == AyahStatus.memorized) {
      return const Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified_rounded, color: _okColor, size: 18),
        SizedBox(width: 4),
        Text('محفوظة', style: TextStyle(color: _okColor, fontSize: 12, fontWeight: FontWeight.w700)),
      ]);
    }
    return Tooltip(
      message: 'تسميع مظبوط ورا بعض: ${toArabicDigits(p.perfectCount)} من ${toArabicDigits(needed)}',
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (var i = 0; i < needed; i++)
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Icon(i < p.perfectCount ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 16, color: i < p.perfectCount ? _okColor : Colors.white38),
          ),
      ]),
    );
  }

  Widget _hiddenText() => InkWell(
        onTap: () => setState(() => _peek = true),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 26),
          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
          child: const Column(children: [
            Icon(Icons.visibility_off_rounded, color: Colors.white54),
            SizedBox(height: 6),
            Text('النص مخفي — سمّع من حفظك', style: TextStyle(color: Colors.white70)),
            Text('(دوس هنا لو عايز تبص)', style: TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
        ),
      );

  Widget _coloured(RecitationResult r) {
    final spans = <InlineSpan>[];
    for (var i = 0; i < r.words.length; i++) {
      final st = r.statuses[i];
      final style = switch (st) {
        WordStatus.ok => _quranStyle.copyWith(color: _okColor),
        WordStatus.near => _quranStyle.copyWith(color: _nearColor, decoration: TextDecoration.underline, decorationColor: _nearColor),
        WordStatus.wrong => _quranStyle.copyWith(color: _wrongColor, decoration: TextDecoration.underline, decorationColor: _wrongColor),
        _ => _quranStyle.copyWith(color: Colors.white38, decoration: TextDecoration.lineThrough, decorationColor: Colors.white54),
      };
      spans.add(TextSpan(text: r.words[i].display, style: style));
      spans.add(const TextSpan(text: ' '));
    }
    spans.add(TextSpan(text: '﴿${toArabicDigits(_ayah)}﴾', style: _quranStyle.copyWith(color: Colors.white70)));
    return Text.rich(TextSpan(children: spans), textAlign: TextAlign.center, textDirection: TextDirection.rtl);
  }

  Widget _verdict(RecitationResult r) {
    final after = _after;
    if (r.empty) {
      return const _Banner(
        color: _nearColor,
        icon: Icons.hearing_disabled_rounded,
        title: 'مسمعناش حاجة واضحة',
        body: 'قرّب الموبايل منك واقرا بصوت واضح في مكان هادي، وجرّب تاني.',
      );
    }
    if (r.perfect) {
      final memorizedNow = after?.status == AyahStatus.memorized && after!.perfectCount == store.settings.perfectNeeded;
      return _Banner(
        color: _okColor,
        icon: Icons.check_circle_rounded,
        title: 'ما شاء الله ✓',
        body: memorizedNow
            ? 'الآية دي اتحفظت! كمّل على اللي بعدها.'
            : (after != null && after.status != AyahStatus.memorized
                ? 'تسميع مظبوط. سمّعها كمان ${toArabicDigits(store.settings.perfectNeeded - after.perfectCount)} مرة عشان تتحسب محفوظة.'
                : 'تسميع مظبوط.'),
      );
    }
    final near = r.statuses.where((s) => s == WordStatus.near).length;
    final wrong = r.statuses.where((s) => s == WordStatus.wrong).length;
    final missing = r.statuses.where((s) => s == WordStatus.missing).length;
    final parts = [
      if (wrong > 0) '${toArabicDigits(wrong)} غلط',
      if (near > 0) '${toArabicDigits(near)} راجعها',
      if (missing > 0) '${toArabicDigits(missing)} ناقصة',
      if (r.extras.isNotEmpty) '${toArabicDigits(r.extras.length)} زيادة',
    ];
    return _Banner(
      color: wrong + missing > 0 ? _wrongColor : _nearColor,
      icon: Icons.replay_rounded,
      title: 'قربت! راجع الكلمات الملوّنة',
      body: '${parts.join(' • ')}\n'
          'الأصفر: راجع الكلمة دي — الأحمر: غلط — الرمادي المشطوب: نسيتها.'
          '${r.extras.isNotEmpty ? '\nزيادة: ${r.extras.join('، ')}' : ''}',
    );
  }

  Widget _controls() {
    final ready = store.model == ModelState.ready;
    switch (_phase) {
      case _Phase.recording:
        final elapsed = _recStart == null ? 0 : DateTime.now().difference(_recStart!).inSeconds;
        final limit = recordLimit(recitationWords(_text).length).inSeconds;
        return Column(children: [
          GestureDetector(
            onTap: _stop,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 96 + 26 * _level,
              height: 96 + 26 * _level,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _wrongColor.withValues(alpha: 0.25)),
              alignment: Alignment.center,
              child: Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: _wrongColor),
                child: const Icon(Icons.stop_rounded, color: Colors.white, size: 44),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('بنسجّل… ${_clock(elapsed)} / ${_clock(limit)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          Text(store.settings.autoStop ? 'لما تخلص اسكت ثانيتين أو دوس «خلصت»' : 'دوس «خلصت» لما تخلص', style: toolMutedStyle),
          TextButton(onPressed: _stop, child: const Text('خلصت', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800))),
        ]);
      case _Phase.thinking:
        final secs = ((DateTime.now().millisecondsSinceEpoch - _thinkingSince) / 1000).floor();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(children: [
            const CircularProgressIndicator(color: AppColors.gold),
            const SizedBox(height: 12),
            const Text('بنسمع تسميعك…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            Text(secs < 8 ? 'ثواني ونقولك' : 'لسه شغالين — الآيات الطويلة بتاخد وقت أكتر (${toArabicDigits(secs)} ث)', style: toolMutedStyle),
          ]),
        );
      default:
        final playing = _phase == _Phase.playing;
        final r = _result;
        final perfect = r != null && r.perfect;
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: () => _listen(times: r != null && !perfect ? 1 : null),
                icon: Icon(playing ? Icons.stop_rounded : Icons.volume_up_rounded),
                label: Text(playing ? 'وقّف' : (r != null && !perfect ? 'اسمع الصح' : 'اسمع')),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
            ),
            const SizedBox(width: 8),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [for (final n in const [1, 3, 5]) ButtonSegment(value: n, label: Text('×${toArabicDigits(n)}'))],
              selected: {store.settings.repeat},
              onSelectionChanged: (s) => store.saveSettings(store.settings.copyWith(repeat: s.first)),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.night : Colors.white),
                backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.gold : Colors.transparent),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: ready && !playing ? _record : null,
            icon: Icon(r == null ? Icons.mic_rounded : Icons.replay_rounded),
            label: Text(
              ready ? (r == null ? 'سمّع' : 'سمّع تاني') : 'المحفّظ لسه بيتحمّل…',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: perfect ? Colors.white24 : AppColors.gold,
              foregroundColor: perfect ? Colors.white : AppColors.night,
              minimumSize: const Size.fromHeight(54),
            ),
          ),
          if (r != null && _ayah < widget.to) ...[
            const SizedBox(height: 8),
            perfect
                ? FilledButton.icon(
                    onPressed: () => _goto(_ayah + 1),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('الآية الجاية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    style: FilledButton.styleFrom(backgroundColor: _okColor, foregroundColor: AppColors.night, minimumSize: const Size.fromHeight(54)),
                  )
                : TextButton(onPressed: () => _goto(_ayah + 1), child: const Text('عدّي للآية الجاية', style: TextStyle(color: Colors.white70))),
          ],
          if (r != null && _ayah == widget.to && perfect && widget.to > widget.from)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_rangeMemorized ? 'خلّصت الآيات دي — جرّب «سمّع الآيات كلها مع بعض» تحت.' : 'خلصت آخر آية — ارجع للآيات اللي لسه (النقط الصفرا فوق).',
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
            ),
        ]);
    }
  }
}

String _clock(int s) => '${toArabicDigits(s ~/ 60)}:${toArabicDigits(s % 60).padLeft(2, '٠')}';

class _Banner extends StatelessWidget {
  const _Banner({required this.color, required this.icon, required this.title, required this.body});
  final Color color;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.5))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 2),
              Text(body, style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.6)),
            ]),
          ),
        ]),
      );
}

// ================================================================= review
/// «سمّع الآيات كلها مع بعض»: the range from memory, one recording per ayah
/// (each ≤ its limit), checked in the background while the next is recited.
class TutorReviewScreen extends StatefulWidget {
  const TutorReviewScreen({super.key, required this.surah, required this.from, required this.to, required this.quran});
  final int surah, from, to;
  final QuranText quran;

  @override
  State<TutorReviewScreen> createState() => _TutorReviewScreenState();
}

class _TutorReviewScreenState extends State<TutorReviewScreen> {
  final store = TutorStore.instance;
  int? _current; // ayah being recorded
  final _results = <int, RecitationResult>{};
  final _checking = <int>{};
  final _errors = <int, String>{};
  double _level = 0;
  Timer? _ticker;
  DateTime? _recStart;
  String? _error;
  Future<void> _queue = Future.value();

  TutorEngine get engine => store.engine;

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    _ticker?.cancel();
    engine.cancelRecording();
    super.dispose();
  }

  String _text(int a) => tutorAyahText(widget.quran, widget.surah, a);

  Future<void> _start(int ayah) async {
    setState(() {
      _current = ayah;
      _error = null;
      _level = 0;
      _recStart = DateTime.now();
    });
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted) setState(() {});
    });
    try {
      await engine.startRecording(
        max: recordLimit(recitationWords(_text(ayah)).length),
        autoStop: store.settings.autoStop,
        onLevel: (l) => _level = l,
        onAutoStop: (_) => _finish(ayah, next: false),
      );
    } on TutorError catch (e) {
      _ticker?.cancel();
      if (mounted) {
        setState(() {
          _current = null;
          _error = e.message;
        });
      }
    }
  }

  /// Stops the ayah being recorded, queues it for checking, and (from a tap)
  /// starts the next one straight away.
  Future<void> _finish(int ayah, {required bool next}) async {
    if (_current != ayah) return;
    _ticker?.cancel();
    setState(() {
      _current = null;
      _checking.add(ayah);
    });
    final nextAyah = ayah < widget.to ? ayah + 1 : null;
    // The stop releases the mic synchronously; the next recording starts
    // right away, still inside this tap (iOS).
    final stopping = engine.stopRecording();
    if (next && nextAyah != null) _start(nextAyah);
    TutorRecording? rec;
    try {
      rec = await stopping;
    } on TutorError catch (e) {
      setState(() {
        _checking.remove(ayah);
        _errors[ayah] = e.message;
      });
    }
    if (rec != null) {
      final r = rec;
      _queue = _queue.then((_) async {
        try {
          final t = await engine.transcribe(r);
          final res = alignRecitation(_text(ayah), t.text);
          if (!res.empty) store.progress.record(widget.surah, ayah, perfect: res.perfect, needed: store.settings.perfectNeeded);
          store.saveProgress();
          if (mounted) setState(() => _results[ayah] = res);
        } on TutorError catch (e) {
          if (mounted) setState(() => _errors[ayah] = e.message);
        } finally {
          if (mounted) setState(() => _checking.remove(ayah));
        }
      });
    }
  }

  int? get _nextToRecord {
    for (var a = widget.from; a <= widget.to; a++) {
      if (!_results.containsKey(a) && !_checking.contains(a) && !_errors.containsKey(a) && a != _current) return a;
    }
    return null;
  }

  void _restart() {
    setState(() {
      _results.clear();
      _errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = store.model == ModelState.ready;
    final cur = _current;
    final nextA = _nextToRecord;
    final done = _results.length + _errors.length == widget.to - widget.from + 1 && _checking.isEmpty && cur == null;
    final perfect = _results.values.where((r) => r.perfect).length;
    return ToolScaffold(
      title: 'سمّع ${surahTitle(widget.surah)}',
      children: [
        ModelStatusCard(store: store, compact: true),
        Text(
          'سمّع الآيات من ${toArabicDigits(widget.from)} لحد ${toArabicDigits(widget.to)} من حفظك، آية آية: بعد كل آية دوس «الآية الجاية» '
          'وكمّل على طول — هنصحّح وإنت بتقرا.',
          style: toolMutedStyle,
        ),
        const SizedBox(height: 10),
        for (var a = widget.from; a <= widget.to; a++) _row(a),
        const SizedBox(height: 8),
        if (_error != null) Text(_error!, style: const TextStyle(color: _wrongColor, fontSize: 13, height: 1.6)),
        if (cur != null) ...[
          Text('بنسجّل آية ${toArabicDigits(cur)}… ${_clock(_recStart == null ? 0 : DateTime.now().difference(_recStart!).inSeconds)}',
              textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: _level, minHeight: 6, color: _wrongColor, backgroundColor: Colors.white12),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () => _finish(cur, next: true),
            icon: Icon(cur < widget.to ? Icons.skip_previous_rounded : Icons.stop_rounded),
            label: Text(cur < widget.to ? 'الآية الجاية' : 'خلصت', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, minimumSize: const Size.fromHeight(54)),
          ),
        ] else if (nextA != null)
          FilledButton.icon(
            onPressed: ready ? () => _start(nextA) : null,
            icon: const Icon(Icons.mic_rounded),
            label: Text(
              !ready ? 'المحفّظ لسه بيتحمّل…' : (nextA == widget.from ? 'ابدأ التسميع' : 'كمّل من آية ${toArabicDigits(nextA)}'),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night, minimumSize: const Size.fromHeight(54)),
          ),
        if (_checking.isNotEmpty && cur == null)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold)),
              SizedBox(width: 8),
              Text('بنسمع تسميعك…', style: TextStyle(color: Colors.white70)),
            ]),
          ),
        if (done) ...[
          _Banner(
            color: perfect == widget.to - widget.from + 1 ? _okColor : _nearColor,
            icon: perfect == widget.to - widget.from + 1 ? Icons.emoji_events_rounded : Icons.replay_rounded,
            title: perfect == widget.to - widget.from + 1 ? 'ما شاء الله ✓ سمّعتهم كلهم صح' : '${toArabicDigits(perfect)} من ${toArabicDigits(widget.to - widget.from + 1)} آيات مظبوطة',
            body: perfect == widget.to - widget.from + 1 ? 'ربنا يثبّتها في قلبك.' : 'ارجع للآيات اللي فيها ألوان وراجعها، وبعدين سمّع تاني.',
          ),
          OutlinedButton.icon(onPressed: _restart, icon: const Icon(Icons.replay_rounded), label: const Text('سمّعهم تاني')),
        ],
        const SizedBox(height: 10),
        const _Disclaimer(compact: true),
      ],
    );
  }

  Widget _row(int a) {
    final r = _results[a];
    final err = _errors[a];
    Widget trailing;
    if (_current == a) {
      trailing = const Icon(Icons.mic_rounded, color: _wrongColor);
    } else if (_checking.contains(a)) {
      trailing = const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold));
    } else if (err != null) {
      trailing = const Icon(Icons.error_outline_rounded, color: _wrongColor);
    } else if (r != null) {
      trailing = Icon(r.perfect ? Icons.check_circle_rounded : Icons.error_rounded, color: r.perfect ? _okColor : _nearColor);
    } else {
      trailing = const Icon(Icons.more_horiz_rounded, color: Colors.white24);
    }
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Text('آية ${toArabicDigits(a)}', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
          const Spacer(),
          trailing,
        ]),
        if (err != null) Text(err, style: const TextStyle(color: _wrongColor, fontSize: 12)),
        if (r != null && !r.perfect) ...[
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(children: [
              for (var i = 0; i < r.words.length; i++) ...[
                TextSpan(
                  text: r.words[i].display,
                  style: _quranStyle.copyWith(
                    fontSize: 22,
                    color: switch (r.statuses[i]) {
                      WordStatus.ok => _okColor,
                      WordStatus.near => _nearColor,
                      WordStatus.wrong => _wrongColor,
                      _ => Colors.white38,
                    },
                    decoration: r.statuses[i] == WordStatus.missing ? TextDecoration.lineThrough : null,
                  ),
                ),
                const TextSpan(text: ' '),
              ],
            ]),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          if (r.empty) const Text('مسمعناش حاجة واضحة', style: TextStyle(color: _nearColor, fontSize: 12)),
        ],
      ]),
    );
  }
}

// =============================================================== progress
class TutorProgressScreen extends StatefulWidget {
  const TutorProgressScreen({super.key});

  @override
  State<TutorProgressScreen> createState() => _TutorProgressScreenState();
}

class _TutorProgressScreenState extends State<TutorProgressScreen> {
  final store = TutorStore.instance;

  @override
  void initState() {
    super.initState();
    store.addListener(_changed);
    store.init();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    store.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = store.progress;
    final surahs = p.startedSurahs;
    final juzAmma = [for (var s = 78; s <= 114; s++) s];
    final ammaDone = juzAmma.fold<int>(0, (a, s) => a + p.memorizedIn(s));
    final ammaTotal = juzAmma.fold<int>(0, (a, s) => a + surahData[s - 1].$2);
    return ToolScaffold(title: 'تقدّمي في الحفظ', children: [
      Row(children: [
        Expanded(child: _big(toArabicDigits(p.memorizedTotal), 'آية محفوظة')),
        const SizedBox(width: 8),
        Expanded(child: _big(toArabicDigits(p.currentStreak()), 'يوم ورا بعض')),
        const SizedBox(width: 8),
        Expanded(child: _big(toArabicDigits(p.bestStreak), 'أطول سلسلة')),
      ]),
      const SizedBox(height: 10),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('جزء عمّ: ${toArabicDigits((ammaDone * 100 / ammaTotal).round())}٪', style: toolTitleStyle),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: ammaDone / ammaTotal, minHeight: 8, color: _okColor, backgroundColor: Colors.white12),
          ),
          const SizedBox(height: 4),
          Text('${toArabicDigits(ammaDone)} من ${toArabicDigits(ammaTotal)} آية', style: toolMutedStyle),
        ]),
      ),
      if (surahs.isEmpty)
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text('لسه مسمّعتش أي آية — ابدأ بسورة قصيرة من جزء عمّ.', textAlign: TextAlign.center, style: toolMutedStyle),
        ),
      for (final s in surahs) _surah(s),
      const SizedBox(height: 8),
      Text(
        AuthService.isSignedIn ? 'تقدّمك محفوظ على حسابك ويظهر على أي جهاز تدخل منه.' : 'تقدّمك محفوظ على الجهاز ده. سجّل دخول عشان يتحفظ على حسابك.',
        style: toolMutedStyle,
      ),
    ]);
  }

  Widget _big(String value, String label) => GlassCard(
        margin: EdgeInsets.zero,
        child: Column(children: [
          Text(value, style: const TextStyle(color: AppColors.gold, fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
        ]),
      );

  Widget _surah(int s) {
    final p = store.progress;
    final n = surahData[s - 1].$2;
    final done = p.memorizedIn(s);
    final learning = p.learningIn(s);
    return GlassCard(
      onTap: () => _detail(s),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(surahTitle(s), style: toolTitleStyle)),
          Text('${toArabicDigits((done * 100 / n).round())}٪', style: const TextStyle(color: _okColor, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: done / n, minHeight: 7, color: _okColor, backgroundColor: Colors.white12),
        ),
        const SizedBox(height: 4),
        Text('محفوظ ${toArabicDigits(done)} من ${toArabicDigits(n)}${learning > 0 ? ' • بتراجع ${toArabicDigits(learning)}' : ''}', style: toolMutedStyle),
      ]),
    );
  }

  Future<void> _detail(int s) async {
    final n = surahData[s - 1].$2;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.nightMid,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(surahTitle(s), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('أخضر: محفوظة — أصفر: بتراجعها — رمادي: لسه', style: toolMutedStyle),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: SingleChildScrollView(
                child: Wrap(spacing: 6, runSpacing: 6, children: [
                  for (var a = 1; a <= n; a++)
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: switch (store.progress.of(s, a).status) {
                          AyahStatus.memorized => _okColor.withValues(alpha: 0.35),
                          AyahStatus.learning => _nearColor.withValues(alpha: 0.35),
                          AyahStatus.none => Colors.white10,
                        },
                      ),
                      child: Text(toArabicDigits(a), style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('تمسح تقدّم السورة دي؟'),
                    content: Text('هتبدأ ${surahTitle(s)} من الأول.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('لأ')),
                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('امسح')),
                    ],
                  ),
                );
                if (ok == true) {
                  await store.resetSurah(s);
                  if (context.mounted) Navigator.of(context).pop();
                }
              },
              child: const Text('ابدأ السورة من الأول', style: TextStyle(color: _wrongColor)),
            ),
          ]),
        ),
      ),
    );
  }
}

// =============================================================== settings
Future<void> showTutorSettings(BuildContext context) {
  final store = TutorStore.instance;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.nightMid,
    isScrollControlled: true,
    builder: (context) => ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final s = store.settings;
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('إعدادات المحفّظ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text('الآية تتحسب محفوظة بعد كام تسميع صح ورا بعض؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              SegmentedButton<int>(
                showSelectedIcon: false,
                segments: [for (var n = 1; n <= 5; n++) ButtonSegment(value: n, label: Text(toArabicDigits(n)))],
                selected: {s.perfectNeeded},
                onSelectionChanged: (v) => store.saveSettings(s.copyWith(perfectNeeded: v.first)),
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected) ? AppColors.night : Colors.white),
                  backgroundColor: WidgetStateProperty.resolveWith((st) => st.contains(WidgetState.selected) ? AppColors.gold : Colors.transparent),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: s.autoStop,
                onChanged: (v) => store.saveSettings(s.copyWith(autoStop: v)),
                activeThumbColor: AppColors.gold,
                title: const Text('وقّف التسجيل لوحده لما أسكت', style: TextStyle(color: Colors.white)),
                subtitle: const Text('بعد حوالي ثانيتين سكوت', style: toolMutedStyle),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: s.hideText,
                onChanged: (v) => store.saveSettings(s.copyWith(hideText: v)),
                activeThumbColor: AppColors.gold,
                title: const Text('اختبر نفسك (خبّي النص)', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              const TutorCredits(),
            ]),
          ),
        );
      },
    ),
  );
}

/// Attribution of everything the tutor uses.
class TutorCredits extends StatelessWidget {
  const TutorCredits({super.key});

  Widget _link(String label, String url) => TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        child: Text(label, style: const TextStyle(color: AppColors.gold, fontSize: 12)),
      );

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('المصادر', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('• نموذج التعرّف على التلاوة: whisper-base-ar-quran من Tarteel (ترخيص Apache-2.0)، بصيغة ONNX من مشروع Basira، '
            'وبيشتغل جوّه المتصفح بمكتبة Transformers.js.', style: toolMutedStyle),
        Wrap(spacing: 12, children: [
          _link('tarteel-ai/whisper-base-ar-quran', 'https://huggingface.co/tarteel-ai/whisper-base-ar-quran'),
          _link('iqbalaesthetic/Basira', 'https://huggingface.co/iqbalaesthetic/Basira'),
        ]),
        const Text('• نص المصحف: مشروع تنزيل Tanzil (ترخيص CC BY 3.0).', style: toolMutedStyle),
        _link('tanzil.net', 'https://tanzil.net'),
        const Text('• التلاوة: الشيخ محمود خليل الحصري — المصحف المعلّم، من everyayah.com.', style: toolMutedStyle),
        _link('everyayah.com', 'https://everyayah.com'),
      ]),
    );
  }
}
