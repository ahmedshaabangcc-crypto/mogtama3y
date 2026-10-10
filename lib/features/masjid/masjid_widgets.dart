import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/masjid/masjid_community.dart' show formatMeters;
import '../../core/masjid/masjid_service.dart';
import '../../core/masjid/osm_mosques.dart';
import '../../core/masjid/prayer_prefs.dart';
import '../../core/masjid/prayer_times.dart';
import '../../core/masjid/world_time.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';

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
/// Times are on [tz]'s clock (the device's when null) with the method of
/// [country] (from the coordinates when null) unless the user chose one.
class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key, required this.lat, required this.lng, this.tz, this.country, this.title, this.iqama, this.khutba, this.khatib, this.dark = true});
  final double lat;
  final double lng;
  final String? tz;
  final String? country;
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
    PrayerPrefs.load();
    PrayerPrefs.current.addListener(_onPrefs);
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  void _onPrefs() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    PrayerPrefs.current.removeListener(_onPrefs);
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tz = resolveTimeZone(widget.tz ?? deviceTimeZone, lng: widget.lng);
    final country = widget.country ?? countryAt(widget.lat, widget.lng) ?? countryOfTimeZone(tz);
    final prefs = PrayerPrefs.current.value;
    final calc = prefs.calculatorFor(country);
    final today = todayIn(tz, _now);
    final day = calc.compute(today.year, today.month, today.day, widget.lat, widget.lng, tz: tz);
    final next = nextPrayer(widget.lat, widget.lng, now: _now, calc: calc, tz: tz);
    final friday = today.weekday == DateTime.friday;
    final fg = widget.dark ? Colors.white : AppColors.ink;
    final muted = widget.dark ? Colors.white60 : AppColors.inkMuted;
    final otherClock = differsFromDevice(tz, at: _now);

    Widget row(Prayer p) {
      final isNext = p == next.prayer && wallClockIn(next.at, tz).day == today.day;
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
          IconButton(
            tooltip: 'طريقة الحساب',
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.tune_rounded, color: muted, size: 20),
            onPressed: () => showPrayerSettingsSheet(context, country: country, lat: widget.lat),
          ),
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
        Text('حساب ${calc.method.nameAr}${prefs.asr == 2 ? ' — العصر حنفي' : ''} — ${tzLabelAr(tz, at: _now)}',
            style: TextStyle(color: muted, fontSize: 10.5)),
        if (otherClock)
          Text('المواعيد بتوقيت المكان (${utcOffsetLabel(tzOffsetMinutes(tz, _now.toUtc()))}) — مختلف عن ساعة جهازك',
              style: TextStyle(color: widget.dark ? AppColors.gold : AppColors.inkMuted, fontSize: 10.5, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

/// «طريقة الحساب»: method (auto by country / a fixed one), Asr, high latitudes.
Future<void> showPrayerSettingsSheet(BuildContext context, {String? country, double? lat}) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => ValueListenableBuilder<PrayerPrefs>(
        valueListenable: PrayerPrefs.current,
        builder: (ctx, p, _) {
          final auto = methodForCountry(country);
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
                const Text('طريقة حساب مواقيت الصلاة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  key: ValueKey('m${p.method}'),
                  initialValue: p.isAuto ? 'auto' : p.method,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'الطريقة'),
                  items: [
                    DropdownMenuItem(value: 'auto', child: Text('تلقائي حسب البلد — ${auto.nameAr}', overflow: TextOverflow.ellipsis)),
                    for (final m in prayerMethods) DropdownMenuItem(value: m.id, child: Text(m.nameAr, overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (v) => PrayerPrefs.save(p.copyWith(method: v ?? 'auto')),
                ),
                const SizedBox(height: 14),
                const Text('العصر', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('الجمهور (شافعي)')),
                    ButtonSegment(value: 2, label: Text('حنفي')),
                  ],
                  selected: {p.asr},
                  onSelectionChanged: (s) => PrayerPrefs.save(p.copyWith(asr: s.first)),
                ),
                const SizedBox(height: 14),
                const Text('البلاد البعيدة عن خط الاستواء (فوق خط عرض 48)', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                DropdownButtonFormField<HighLatRule>(
                  key: ValueKey('h${p.highLat.name}'),
                  initialValue: p.highLat,
                  isExpanded: true,
                  items: [for (final r in HighLatRule.values) DropdownMenuItem(value: r, child: Text(highLatNames[r]!))],
                  onChanged: (v) => PrayerPrefs.save(p.copyWith(highLat: v ?? HighLatRule.angle)),
                ),
                const SizedBox(height: 8),
                Text(
                  lat != null && lat.abs() > 48
                      ? 'مكانك بعيد عن خط الاستواء: في الصيف الشمس مش بتنزل كفاية، فالفجر والعشاء بيتحسبوا بالقاعدة دي.'
                      : 'القاعدة دي بتفرق بس في البلاد الشمالية (زي إنجلترا وألمانيا) في الصيف.',
                  style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted, height: 1.6),
                ),
              ]),
            ),
          );
        },
      ),
    );

/// Progress of a need, from CONFIRMED amounts only.
class NeedProgress extends StatelessWidget {
  const NeedProgress({super.key, required this.need, this.currency});
  final Map<String, dynamic> need;

  /// ISO code; else need['currency'] (feed rows), else EGP.
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final target = (need['target_amount'] as num?)?.toDouble() ?? 0;
    final confirmed = (need['confirmed_amount'] as num?)?.toDouble() ?? 0;
    final pledged = (need['pledged_amount'] as num?)?.toDouble() ?? 0;
    final ratio = target <= 0 ? 0.0 : (confirmed / target).clamp(0.0, 1.0);
    final cur = currency ?? need['currency'] as String?;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(value: ratio, minHeight: 10, backgroundColor: AppColors.surfaceAlt, color: AppColors.success),
      ),
      const SizedBox(height: 6),
      Text(needProgressText(confirmed, target, cur), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
      if (pledged > 0)
        Text('وفيه تعهدات بـ ${masjidAmount(pledged, cur)} لسه ماوصلتش', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
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
  const ComingSoonTile({super.key, required this.icon, required this.title, required this.subtitle, this.badge = 'قريباً', this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;

  /// Set once the feature is live — the tile then opens it.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
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
            child: Text(badge, style: const TextStyle(color: AppColors.night, fontSize: 10.5, fontWeight: FontWeight.w800)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.5)),
      ]),
    );
    if (onTap == null) return tile;
    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: BorderRadius.circular(16), onTap: onTap, child: tile),
    );
  }
}

/// Shows a Postgres error message (Arabic, raised by the RPCs) or a fallback.
String masjidError(Object e, [String fallback = 'حصلت مشكلة، جرّب تاني']) => e is PostgrestException ? e.message : fallback;


// ------------------------------------------------- OpenStreetMap (0087)

/// Opens (or, with [join], joins) a mosque found on OpenStreetMap: it is
/// added to our directory once (masjid_import_osm), then its page opens.
/// Signed-in users only (guests are asked to sign in first).
Future<String?> openOsmMosque(BuildContext context, OsmMosque m, {bool join = false}) async {
  if (!AuthService.isSignedIn) {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    if (!AuthService.isSignedIn) return null;
  }
  try {
    final id = await MasjidService.importOsm(osmType: m.type, osmId: m.id, name: m.name, lat: m.lat, lng: m.lng, join: join);
    if (!join && context.mounted) context.push(AppRoutes.mosque(id));
    return id;
  } catch (e) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(masjidError(e))));
    return null;
  }
}

/// A mosque from OpenStreetMap (not in our directory yet).
class OsmMosqueTile extends StatelessWidget {
  const OsmMosqueTile({super.key, required this.mosque, this.trailing});
  final OsmMosque mosque;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: AppColors.night, child: Icon(Icons.mosque_rounded, color: AppColors.gold, size: 20)),
          title: Text(mosque.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${formatMeters(mosque.distanceM)} • من خريطة OpenStreetMap', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5)),
          trailing: trailing ?? const Icon(Icons.chevron_left_rounded),
          onTap: () => openOsmMosque(context, mosque),
        ),
      );
}

/// «© OpenStreetMap contributors» (ODbL) under OSM results.
class OsmAttribution extends StatelessWidget {
  const OsmAttribution({super.key, this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => launchUrl(Uri.parse(OsmMosques.copyrightUrl), mode: LaunchMode.externalApplication),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text('بيانات الخريطة ${OsmMosques.attribution} — ODbL',
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 10.5, color: dark ? Colors.white54 : AppColors.inkMuted, decoration: TextDecoration.underline)),
        ),
      );
}
