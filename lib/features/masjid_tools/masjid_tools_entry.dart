import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';

/// «أدوات يومية» — the small, always-loaded part of the tools: the
/// deferred-page wrapper the router uses and the strip of tool buttons
/// that the masjid screens embed. Every tool screen itself is a deferred
/// library (loaded on first open), so none of it — nor the Quran text —
/// weighs on the app's first load.
class DeferredPage extends StatefulWidget {
  const DeferredPage({super.key, required this.load, required this.builder, required this.title});
  final Future<void> Function() load;
  final Widget Function() builder;
  final String title;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  static final _loaded = <Object>{};
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _start();
  }

  Future<void> _start() async {
    if (_loaded.contains(widget.title)) return;
    await widget.load();
    _loaded.add(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    if (_loaded.contains(widget.title)) return widget.builder();
    return FutureBuilder<void>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done && !snap.hasError) return widget.builder();
        return Scaffold(
          backgroundColor: AppColors.night,
          appBar: AppBar(
            backgroundColor: AppColors.night,
            foregroundColor: Colors.white,
            titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(color: Colors.white),
            title: Text(widget.title),
          ),
          body: Center(
            child: snap.hasError
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('معرفناش نفتح الصفحة — اتأكد من النت وجرّب تاني', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),
                    FilledButton(onPressed: () => setState(() => _future = _start()), child: const Text('جرّب تاني')),
                  ])
                : const CircularProgressIndicator(color: AppColors.gold),
          ),
        );
      },
    );
  }
}

class MasjidTool {
  const MasjidTool(this.route, this.icon, this.title, this.subtitle);
  final String route;
  final IconData icon;
  final String title;
  final String subtitle;
}

const masjidTools = [
  MasjidTool(AppRoutes.masjidToolsQuran, Icons.menu_book_rounded, 'المصحف', 'اقرا وكمّل من مكانك'),
  MasjidTool(AppRoutes.masjidToolsListen, Icons.headphones_rounded, 'استماع', 'القرآن كامل بصوت قرّاء كتير'),
  MasjidTool(AppRoutes.masjidToolsTutor, Icons.record_voice_over_rounded, 'المحفّظ', 'سمّع والمحفّظ يصحّحلك'),
  MasjidTool(AppRoutes.masjidToolsAdhkar, Icons.auto_awesome_rounded, 'الأذكار', 'الصباح والمساء والسبحة'),
  MasjidTool(AppRoutes.masjidToolsQibla, Icons.explore_rounded, 'القبلة', 'اتجاه القبلة من مكانك'),
  MasjidTool(AppRoutes.masjidToolsHijri, Icons.calendar_month_rounded, 'التقويم الهجري', 'رمضان والعيد فاضل كام يوم'),
  MasjidTool(AppRoutes.masjidToolsReminders, Icons.alarm_rounded, 'تنبيه الصلاة', 'نبّهني قبل الأذان'),
];

/// «أدوات يومية»: a row of tool buttons (dark / night style by default).
class DailyToolsStrip extends StatelessWidget {
  const DailyToolsStrip({super.key, this.dark = true, this.title = 'أدوات يومية'});
  final bool dark;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.ink;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (title != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 14, 2, 8),
          child: Text(title!, style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 16)),
        ),
      SizedBox(
        height: 92,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: masjidTools.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final t = masjidTools[i];
            return InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push(t.route),
              child: Container(
                width: 92,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                decoration: BoxDecoration(
                  color: dark ? Colors.white.withValues(alpha: 0.07) : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: dark ? AppColors.glassBorder : AppColors.border),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(t.icon, color: AppColors.gold, size: 28),
                  const SizedBox(height: 6),
                  Text(t.title, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12)),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
