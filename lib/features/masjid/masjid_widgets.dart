import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/masjid/masjid_service.dart';
import '../../core/masjid/prayer_times.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';

const weekdayNames = {1: 'الإثنين', 2: 'الثلاثاء', 3: 'الأربعاء', 4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الأحد'};

/// "16:30:00" → "4:30 م".
String? timeOfDayText(String? hhmmss) {
  if (hhmmss == null || hhmmss.isEmpty) return null;
  final p = hhmmss.split(':');
  final h = int.tryParse(p[0]);
  final m = p.length > 1 ? int.tryParse(p[1]) : 0;
  if (h == null || m == null) return null;
  return format12(DateTime.utc(2000, 1, 1, h, m));
}

/// «كل سبت وإثنين — بعد العصر» for a lesson row.
String lessonWhen(Map<String, dynamic> l) {
  final days = ((l['weekdays'] as List?) ?? const []).map((e) => (e as num).toInt()).toList()..sort((a, b) => ((a + 1) % 7).compareTo((b + 1) % 7));
  final dayText = days.isEmpty ? '' : (days.length == 7 ? 'كل يوم' : 'كل ${days.map((d) => weekdayNames[d]).join(' و')}');
  final after = l['after_prayer'] as String?;
  final at = timeOfDayText(l['start_time'] as String?);
  final timeText = after != null ? 'بعد ${prayerNames[Prayer.values.byName(after)]}' : (at ?? '');
  return [dayText, timeText].where((s) => s.isNotEmpty).join(' — ');
}

/// Today's prayer times for [lat]/[lng], the next prayer and a live
/// countdown. With [iqama] (minutes after the adhan, per prayer name) each
/// row also shows the iqama time; [khutba] replaces Dhuhr on Fridays.
class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key, required this.lat, required this.lng, this.title, this.iqama, this.khutba, this.khatib, this.dark = true});
  final double lat;
  final double lng;
  final String? title;
  final Map<String, dynamic>? iqama;
  final String? khutba;
  final String? khatib;
  final bool dark;

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard> {
  Timer? _tick;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = egyptToday(_now);
    final day = PrayerCalculator.egypt.compute(today.year, today.month, today.day, widget.lat, widget.lng);
    final next = nextPrayer(widget.lat, widget.lng, now: _now);
    final friday = today.weekday == DateTime.friday;
    final fg = widget.dark ? Colors.white : AppColors.ink;
    final muted = widget.dark ? Colors.white60 : AppColors.inkMuted;

    Widget row(Prayer p) {
      final isNext = p == next.prayer && egyptWallClock(next.at).day == today.day;
      final offset = (widget.iqama?[p.name] as num?)?.toInt();
      final label = p == Prayer.dhuhr && friday ? 'الجمعة' : prayerNames[p]!;
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isNext ? AppColors.gold.withValues(alpha: 0.22) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(color: fg, fontWeight: isNext ? FontWeight.w800 : FontWeight.w600, fontSize: 13.5))),
          if (offset != null && p != Prayer.sunrise)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Text('الإقامة ${format12(day.wall(p).add(Duration(minutes: offset)))}', style: TextStyle(color: muted, fontSize: 11)),
            ),
          Text(format12(day.wall(p)), style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 14)),
        ]),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: widget.dark ? AppColors.nightGradient : null,
        color: widget.dark ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: widget.dark ? AppColors.glassBorder : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const Icon(Icons.mosque_rounded, color: AppColors.gold, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(widget.title ?? 'مواقيت الصلاة النهارده', style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 15))),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('الصلاة الجاية: ${next.prayer == Prayer.dhuhr && friday ? 'الجمعة' : prayerNames[next.prayer]}',
                    style: const TextStyle(color: AppColors.night, fontWeight: FontWeight.w800, fontSize: 14)),
                Text(formatCountdown(next.left), style: const TextStyle(color: AppColors.night, fontSize: 12)),
              ]),
            ),
            Text(formatClock(next.left),
                style: const TextStyle(color: AppColors.night, fontWeight: FontWeight.w900, fontSize: 20, fontFeatures: [FontFeature.tabularFigures()])),
          ]),
        ),
        const SizedBox(height: 10),
        for (final p in Prayer.values) row(p),
        if (friday && (widget.khutba != null || widget.khatib != null))
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              ['خطبة الجمعة', if (timeOfDayText(widget.khutba) != null) timeOfDayText(widget.khutba)!, if (widget.khatib != null) 'مع ${widget.khatib}'].join(' — '),
              style: TextStyle(color: fg, fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ),
        const SizedBox(height: 4),
        Text('حساب الهيئة المصرية العامة للمساحة — بتوقيت مصر', style: TextStyle(color: muted, fontSize: 10.5)),
      ]),
    );
  }
}

/// Progress of a need, from CONFIRMED amounts only.
class NeedProgress extends StatelessWidget {
  const NeedProgress({super.key, required this.need});
  final Map<String, dynamic> need;

  @override
  Widget build(BuildContext context) {
    final target = (need['target_amount'] as num?)?.toDouble() ?? 0;
    final confirmed = (need['confirmed_amount'] as num?)?.toDouble() ?? 0;
    final pledged = (need['pledged_amount'] as num?)?.toDouble() ?? 0;
    final ratio = target <= 0 ? 0.0 : (confirmed / target).clamp(0.0, 1.0);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(value: ratio, minHeight: 10, backgroundColor: AppColors.surfaceAlt, color: AppColors.success),
      ),
      const SizedBox(height: 6),
      Text(needProgressText(confirmed, target), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
      if (pledged > 0)
        Text('وفيه تعهدات بـ ${masjidMoney(pledged)} ج.م لسه ماوصلتش', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
    ]);
  }
}

/// One mosque in a list → its page.
class MosqueTile extends StatelessWidget {
  const MosqueTile({super.key, required this.mosque, this.trailing});
  final Map<String, dynamic> mosque;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final km = (mosque['distance_km'] as num?)?.toDouble();
    final sub = [
      if (mosque['area'] != null) mosque['area'],
      if (mosque['address'] != null) mosque['address'],
      if (km != null) km < 1 ? '${(km * 1000).round()} متر' : '${km.toStringAsFixed(1)} كم',
    ].join(' • ');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: AppColors.night, child: Icon(Icons.mosque_rounded, color: AppColors.gold, size: 20)),
        title: Row(children: [
          Flexible(child: Text(mosque['name'] as String? ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))),
          if (mosque['verified'] == true) const Padding(padding: EdgeInsetsDirectional.only(start: 4), child: Icon(Icons.verified_rounded, color: AppColors.teal, size: 16)),
        ]),
        subtitle: sub.isEmpty ? null : Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5)),
        trailing: trailing ?? const Icon(Icons.chevron_left_rounded),
        onTap: () => context.push(AppRoutes.mosque(mosque['id'] as String)),
      ),
    );
  }
}

/// «التطبيق مابيستلمش فلوس» — said wherever money is mentioned.
class NoMoneyNote extends StatelessWidget {
  const NoMoneyNote({super.key, this.extra});
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.inkSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'التطبيق مابيستلمش فلوس. الدفع بيكون للمسجد مباشرة، وإدارة المسجد بتأكد اللي وصلها.${extra == null ? '' : ' $extra'}',
            style: const TextStyle(fontSize: 11.5, height: 1.6, color: AppColors.inkSecondary),
          ),
        ),
      ]),
    );
  }
}

/// «قريباً» tile for phase 2/3 features.
class ComingSoonTile extends StatelessWidget {
  const ComingSoonTile({super.key, required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(999)),
            child: const Text('قريباً', style: TextStyle(color: AppColors.night, fontSize: 10.5, fontWeight: FontWeight.w800)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.5)),
      ]),
    );
  }
}

/// Shows a Postgres error message (Arabic, raised by the RPCs) or a fallback.
String masjidError(Object e, [String fallback = 'حصلت مشكلة، جرّب تاني']) => e is PostgrestException ? e.message : fallback;
