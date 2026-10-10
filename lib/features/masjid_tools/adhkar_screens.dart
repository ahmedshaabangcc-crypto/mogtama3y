import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/masjid/world_time.dart' show deviceToday;
import '../../core/masjid_tools/dhikr_counter.dart';
import '../../core/masjid_tools/hijri.dart' show toArabicDigits;
import '../../core/masjid_tools/platform/feedback.dart';
import '../../core/masjid_tools/platform/kv_store.dart';
import '../../core/theme/app_colors.dart';
import 'adhkar_data.dart';
import 'tools_ui.dart';

void _tapFeedback({bool done = false}) {
  HapticFeedback.selectionClick();
  vibrate(done ? 60 : 12);
}

class AdhkarHomeScreen extends StatelessWidget {
  const AdhkarHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final suggested = hour >= 4 && hour < 12 ? 'morning' : (hour >= 15 && hour < 20 ? 'evening' : (hour >= 21 || hour < 3 ? 'sleep' : null));
    return ToolScaffold(title: 'الأذكار', children: [
      GlassCard(
        highlight: true,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TasbeehScreen())),
        child: const Row(children: [
          Icon(Icons.fingerprint_rounded, color: AppColors.gold, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('السبحة', style: toolTitleStyle),
              Text('عدّاد تسبيح بهدف ٣٣ أو ١٠٠ — بيتحفظ على موبايلك', style: toolMutedStyle),
            ]),
          ),
          Icon(Icons.chevron_left_rounded, color: Colors.white70),
        ]),
      ),
      for (final c in adhkarCategories)
        GlassCard(
          highlight: c.id == suggested,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdhkarListScreen(category: c))),
          child: Row(children: [
            Icon(
              switch (c.id) {
                'morning' => Icons.wb_sunny_rounded,
                'evening' => Icons.nights_stay_rounded,
                'prayer' => Icons.mosque_rounded,
                'sleep' => Icons.bedtime_rounded,
                _ => Icons.alarm_on_rounded,
              },
              color: AppColors.gold,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.title, style: toolTitleStyle),
                Text('${c.subtitle} • ${toArabicDigits(c.items.length)} ذكر', style: toolMutedStyle),
              ]),
            ),
            if (c.id == suggested) const Text('وقتها دلوقتي', style: TextStyle(color: AppColors.gold, fontSize: 11, fontWeight: FontWeight.w700)),
            const Icon(Icons.chevron_left_rounded, color: Colors.white70),
          ]),
        ),
      const Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text('المصدر: «حصن المسلم» للشيخ سعيد بن وهف القحطاني.', style: toolMutedStyle, textAlign: TextAlign.center),
      ),
    ]);
  }
}

class AdhkarListScreen extends StatefulWidget {
  const AdhkarListScreen({super.key, required this.category});
  final AdhkarCategory category;

  @override
  State<AdhkarListScreen> createState() => _AdhkarListScreenState();
}

class _AdhkarListScreenState extends State<AdhkarListScreen> {
  late final DhikrCounter _counter = DhikrCounter([for (final d in widget.category.items) d.count]);
  late final _keys = List.generate(widget.category.items.length, (_) => GlobalKey());

  String get _prefsKey => 'mt.adhkar.${widget.category.id}';
  String get _today => deviceToday().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    try {
      final raw = await kvGet(_prefsKey);
      if (raw == null) return;
      final j = jsonDecode(raw) as Map<String, dynamic>;
      // Progress is kept for the day only (after-prayer adhkar: 2 hours).
      final fresh = widget.category.id == 'prayer'
          ? DateTime.now().difference(DateTime.tryParse(j['at'] as String? ?? '') ?? DateTime(2000)).inMinutes < 120
          : j['day'] == _today;
      if (fresh && mounted) setState(() => _counter.restore(j['counts'] as List?));
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      await kvSet(_prefsKey, jsonEncode({'day': _today, 'at': DateTime.now().toIso8601String(), 'counts': _counter.toJson()}));
    } catch (_) {}
  }

  void _tap(int i) {
    if (_counter.isDone(i)) return;
    final done = _counter.tap(i);
    _tapFeedback(done: done);
    setState(() {});
    _save();
    if (done) {
      final next = _counter.nextPending;
      if (next != null && next > i) {
        Future.delayed(const Duration(milliseconds: 250), () {
          final ctx = _keys[next].currentContext;
          if (ctx != null && ctx.mounted) Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 400), alignment: 0.1);
        });
      } else if (_counter.allDone) {
        toolToast(context, 'تقبّل الله منك 🤍 خلّصت ${widget.category.title}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.category;
    final side = ToolScaffold.side(context);
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        titleTextStyle: nightTitleStyle(context),
        title: Text(c.title),
        actions: [
          IconButton(
            tooltip: 'ابدأ من الأول',
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: () {
              setState(_counter.resetAll);
              _save();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Padding(
            padding: EdgeInsets.fromLTRB(side, 0, side, 10),
            child: Row(children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _counter.overallProgress,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('${toArabicDigits(_counter.doneCount)} / ${toArabicDigits(c.items.length)}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(side, 10, side, 60),
        itemCount: c.items.length,
        itemBuilder: (context, i) => _DhikrCard(
          key: _keys[i],
          dhikr: c.items[i],
          count: _counter.count(i),
          done: _counter.isDone(i),
          progress: _counter.progress(i),
          onTap: () => _tap(i),
          onReset: () {
            setState(() => _counter.resetOne(i));
            _save();
          },
        ),
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({super.key, required this.dhikr, required this.count, required this.done, required this.progress, required this.onTap, required this.onReset});
  final Dhikr dhikr;
  final int count;
  final bool done;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: done ? 0.55 : 1,
      child: GlassCard(
        highlight: done,
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (dhikr.note != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(dhikr.note!, style: const TextStyle(color: AppColors.gold, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          Text(dhikr.text, style: const TextStyle(color: Colors.white, fontSize: 17, height: 2.0)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: Text(dhikr.source, style: const TextStyle(color: Colors.white54, fontSize: 11.5))),
            if (count > 0 && !done)
              IconButton(
                tooltip: 'صفّر العداد',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white54, size: 18),
                onPressed: onReset,
              ),
            _CountBadge(count: count, target: dhikr.count, progress: progress, done: done),
          ]),
        ]),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.target, required this.progress, required this.done});
  final int count;
  final int target;
  final double progress;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(alignment: Alignment.center, children: [
        TweenAnimationBuilder<double>(
          tween: Tween(end: progress),
          duration: const Duration(milliseconds: 200),
          builder: (_, v, _) => CircularProgressIndicator(value: v, strokeWidth: 4, backgroundColor: Colors.white12, color: AppColors.gold),
        ),
        done
            ? const Icon(Icons.check_rounded, color: AppColors.gold)
            : Text(target == 1 ? 'مرة' : '${toArabicDigits(count)}/${toArabicDigits(target)}',
                textScaler: TextScaler.noScaling, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

// ------------------------------------------------------------------ سبحة
class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  static const _key = 'mt.tasbeeh';
  Tasbeeh _t = Tasbeeh();

  @override
  void initState() {
    super.initState();
    () async {
      try {
        final raw = await kvGet(_key);
        if (raw != null && mounted) setState(() => _t = Tasbeeh.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {}
    }();
  }

  Future<void> _save() async {
    try {
      await kvSet(_key, jsonEncode(_t.toJson()));
    } catch (_) {}
  }

  void _tap() {
    final round = _t.tap();
    _tapFeedback(done: round);
    setState(() {});
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        titleTextStyle: nightTitleStyle(context),
        title: const Text('السبحة'),
        actions: [
          IconButton(
            tooltip: 'صفّر',
            icon: const Icon(Icons.restart_alt_rounded),
            onPressed: () {
              setState(_t.reset);
              _save();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          const SizedBox(height: 12),
          SegmentedButton<int>(
            segments: [for (final v in Tasbeeh.targets) ButtonSegment(value: v, label: Text('الهدف ${toArabicDigits(v)}'))],
            selected: {_t.target},
            onSelectionChanged: (s) {
              setState(() => _t.setTarget(s.first));
              _save();
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.night : Colors.white),
              backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.gold : Colors.transparent),
            ),
          ),
          Expanded(
            child: Center(
              child: Semantics(
                button: true,
                label: 'سبّح',
                child: GestureDetector(
                  onTap: _tap,
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(alignment: Alignment.center, children: [
                      SizedBox.expand(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(end: _t.progress),
                          duration: const Duration(milliseconds: 150),
                          builder: (_, v, _) => CircularProgressIndicator(value: v, strokeWidth: 10, backgroundColor: Colors.white12, color: AppColors.gold),
                        ),
                      ),
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.06), border: Border.all(color: AppColors.glassBorder)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(toArabicDigits(_t.count), style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w800)),
                          Text('من ${toArabicDigits(_t.target)}', style: const TextStyle(color: Colors.white60)),
                          const SizedBox(height: 6),
                          const Text('دوس هنا', style: TextStyle(color: AppColors.gold, fontSize: 12)),
                        ]),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Text('الدورات: ${toArabicDigits(_t.rounds)} • الإجمالي: ${toArabicDigits(_t.total)}', style: const TextStyle(color: Colors.white70)),
          ),
        ]),
      ),
    );
  }
}
