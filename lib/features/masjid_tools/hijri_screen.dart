import 'package:flutter/material.dart';

import '../../core/masjid/world_time.dart' show deviceToday;
import '../../core/masjid_tools/hijri.dart';
import '../../core/masjid_tools/platform/kv_store.dart';
import '../../core/theme/app_colors.dart';
import 'tools_ui.dart';

const _astroNote = 'حسب الحساب الفلكي (تقويم أم القرى) وقد يختلف يوم عن رؤية دار الإفتاء.';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  static const _adjustKey = 'mt.hijri.adjust';
  int _adjust = 0;
  late DateTime _today = deviceToday();
  late HijriDate _month = toHijri(_today);
  DateTime? _convertG;
  HijriDate? _convertH;

  @override
  void initState() {
    super.initState();
    () async {
      try {
        final v = int.tryParse(await kvGet(_adjustKey) ?? '') ?? 0;
        if (mounted) {
          setState(() {
            _adjust = v.clamp(-2, 2);
            _month = toHijri(_today, adjustDays: _adjust);
          });
        }
      } catch (_) {}
    }();
  }

  Future<void> _setAdjust(int v) async {
    setState(() {
      _adjust = v;
      _today = deviceToday();
      _month = toHijri(_today, adjustDays: v);
    });
    try {
      await kvSet(_adjustKey, '$v');
    } catch (_) {}
  }

  void _shiftMonth(int d) {
    var y = _month.year, m = _month.month + d;
    if (m > 12) {
      m = 1;
      y++;
    } else if (m < 1) {
      m = 12;
      y--;
    }
    setState(() => _month = HijriDate(y, m, 1));
  }

  @override
  Widget build(BuildContext context) {
    final h = toHijri(_today, adjustDays: _adjust);
    return ToolScaffold(title: 'التقويم الهجري', children: [
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Text('النهارده ${weekdayNamesAr[_today.weekday]}', style: const TextStyle(color: AppColors.night, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(formatHijri(h), style: const TextStyle(color: AppColors.night, fontSize: 26, fontWeight: FontWeight.w800)),
          Text('${formatGregorian(_today)} م', style: const TextStyle(color: AppColors.night, fontSize: 14)),
        ]),
      ),
      GlassCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('تصحيح التاريخ', style: toolTitleStyle),
          const Text('لو دار الإفتاء أعلنت بداية الشهر بيوم مختلف، ظبّطه من هنا.', style: toolMutedStyle),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: [
              for (final v in const [-2, -1, 0, 1, 2])
                ButtonSegment(value: v, label: Text(v == 0 ? 'بدون' : '${v > 0 ? '+' : '−'}${toArabicDigits(v.abs())}', textDirection: TextDirection.ltr)),
            ],
            selected: {_adjust},
            showSelectedIcon: false,
            onSelectionChanged: (s) => _setAdjust(s.first),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.night : Colors.white),
              backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.gold : Colors.transparent),
            ),
          ),
        ]),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(2, 10, 2, 8), child: Text('مناسبات جاية', style: toolTitleStyle)),
      for (final o in hijriOccasions) _occasion(o),
      const Padding(padding: EdgeInsets.only(bottom: 6), child: Text(_astroNote, style: toolMutedStyle)),
      const Padding(padding: EdgeInsets.fromLTRB(2, 10, 2, 8), child: Text('الشهر', style: toolTitleStyle)),
      _monthView(),
      const Padding(padding: EdgeInsets.fromLTRB(2, 14, 2, 8), child: Text('حوّل تاريخ', style: toolTitleStyle)),
      _converter(),
    ]);
  }

  Widget _occasion(HijriOccasion o) {
    final n = nextOccasion(o, _today, adjustDays: _adjust);
    return GlassCard(
      highlight: n.daysLeft <= 1,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(o.name, style: toolTitleStyle),
            Text('${formatHijri(n.hijri)} • ${weekdayNamesAr[n.date.weekday]} ${formatGregorian(n.date)}', style: toolMutedStyle),
          ]),
        ),
        Text(daysLeftText(n.daysLeft), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _monthView() {
    final first = toGregorian(_month.year, _month.month, 1, adjustDays: _adjust);
    final len = hijriMonthLength(_month.year, _month.month);
    final last = first.add(Duration(days: len - 1));
    final lead = (first.weekday + 1) % 7; // Saturday first
    final gMonths = first.month == last.month
        ? '${gregorianMonthNames[first.month - 1]} ${toArabicDigits(first.year)}'
        : '${gregorianMonthNames[first.month - 1]} – ${gregorianMonthNames[last.month - 1]} ${toArabicDigits(last.year)}';
    const dayHeads = ['سبت', 'حد', 'اتنين', 'تلات', 'أربع', 'خميس', 'جمعة'];
    final cells = <Widget>[
      for (final d in dayHeads) Center(child: Text(d, style: const TextStyle(color: Colors.white54, fontSize: 11))),
      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
      for (var d = 1; d <= len; d++)
        Builder(builder: (_) {
          final g = first.add(Duration(days: d - 1));
          final isToday = g == _today;
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday ? AppColors.gold : (g.weekday == DateTime.friday ? Colors.white.withValues(alpha: 0.08) : null),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(toArabicDigits(d), style: TextStyle(color: isToday ? AppColors.night : Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              Text(toArabicDigits(g.day), style: TextStyle(color: isToday ? AppColors.night : Colors.white54, fontSize: 10)),
            ]),
          );
        }),
    ];
    return GlassCard(
      child: Column(children: [
        Row(children: [
          IconButton(onPressed: () => _shiftMonth(-1), icon: const Icon(Icons.chevron_right_rounded, color: Colors.white)),
          Expanded(
            child: Column(children: [
              Text('${hijriMonthNames[_month.month - 1]} ${toArabicDigits(_month.year)} هـ', style: toolTitleStyle),
              Text(gMonths, style: toolMutedStyle),
            ]),
          ),
          IconButton(onPressed: () => _shiftMonth(1), icon: const Icon(Icons.chevron_left_rounded, color: Colors.white)),
        ]),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.95,
          children: cells,
        ),
        TextButton(
          onPressed: () => setState(() => _month = toHijri(_today, adjustDays: _adjust)),
          child: const Text('ارجع للشهر الحالي', style: TextStyle(color: AppColors.gold)),
        ),
      ]),
    );
  }

  static DateTime _clampDay(int y, int m, int d) {
    final len = DateTime.utc(y, m + 1, 0).day;
    return DateTime.utc(y, m, d > len ? len : d);
  }

  Widget _converter() {
    final hNow = toHijri(_today, adjustDays: _adjust);
    final hSel = _convertH ?? hNow;
    final len = hijriMonthLength(hSel.year, hSel.month);
    final day = hSel.day > len ? len : hSel.day;
    final gOfH = toGregorian(hSel.year, hSel.month, day, adjustDays: _adjust);
    final dropStyle = const TextStyle(color: Colors.white);
    final gSel = _convertG ?? _today;
    final gLen = DateTime.utc(gSel.year, gSel.month + 1, 0).day;
    final gDay = gSel.day > gLen ? gLen : gSel.day;
    return GlassCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('من ميلادي لهجري', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
        Row(children: [
          DropdownButton<int>(
            value: gDay,
            dropdownColor: AppColors.nightMid,
            style: dropStyle,
            items: [for (var d = 1; d <= gLen; d++) DropdownMenuItem(value: d, child: Text(toArabicDigits(d)))],
            onChanged: (v) => setState(() => _convertG = DateTime.utc(gSel.year, gSel.month, v ?? 1)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<int>(
              value: gSel.month,
              isExpanded: true,
              dropdownColor: AppColors.nightMid,
              style: dropStyle,
              items: [for (var m = 1; m <= 12; m++) DropdownMenuItem(value: m, child: Text(gregorianMonthNames[m - 1]))],
              onChanged: (v) => setState(() => _convertG = _clampDay(gSel.year, v ?? 1, gDay)),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: gSel.year,
            dropdownColor: AppColors.nightMid,
            style: dropStyle,
            items: [for (var y = _today.year - 30; y <= _today.year + 30; y++) DropdownMenuItem(value: y, child: Text(toArabicDigits(y)))],
            onChanged: (v) => setState(() => _convertG = _clampDay(v ?? _today.year, gSel.month, gDay)),
          ),
        ]),
        Text('= ${weekdayNamesAr[gSel.weekday]} ${formatHijri(toHijri(gSel, adjustDays: _adjust))}',
            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 15)),
        const Divider(color: Colors.white24),
        const Text('من هجري لميلادي', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
        Row(children: [
          DropdownButton<int>(
            value: day,
            dropdownColor: AppColors.nightMid,
            style: dropStyle,
            items: [for (var d = 1; d <= len; d++) DropdownMenuItem(value: d, child: Text(toArabicDigits(d)))],
            onChanged: (v) => setState(() => _convertH = HijriDate(hSel.year, hSel.month, v ?? 1)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<int>(
              value: hSel.month,
              isExpanded: true,
              dropdownColor: AppColors.nightMid,
              style: dropStyle,
              items: [for (var m = 1; m <= 12; m++) DropdownMenuItem(value: m, child: Text(hijriMonthNames[m - 1]))],
              onChanged: (v) => setState(() => _convertH = HijriDate(hSel.year, v ?? 1, day)),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: hSel.year,
            dropdownColor: AppColors.nightMid,
            style: dropStyle,
            items: [for (var y = hNow.year - 30; y <= hNow.year + 30; y++) DropdownMenuItem(value: y, child: Text(toArabicDigits(y)))],
            onChanged: (v) => setState(() => _convertH = HijriDate(v ?? hNow.year, hSel.month, day)),
          ),
        ]),
        Text('= ${weekdayNamesAr[gOfH.weekday]} ${formatGregorian(gOfH)} م', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w800, fontSize: 15)),
      ]),
    );
  }
}
