import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/location/where.dart';
import '../../core/masjid/world_time.dart' show defaultPlace;
import '../../core/masjid_tools/hijri.dart' show toArabicDigits;
import '../../core/masjid_tools/platform/compass.dart';
import '../../core/masjid_tools/platform/feedback.dart';
import '../../core/masjid_tools/qibla.dart';
import '../../core/theme/app_colors.dart';
import 'city_picker.dart';
import 'tools_ui.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  // The main city of the device's time zone until the location comes.
  static final _start = defaultPlace();
  double _lat = _start.$2;
  double _lng = _start.$3;
  String _place = '${_start.$1} (تقريبي)';
  bool _locating = false;

  final _compass = CompassSource();
  StreamSubscription<double>? _sub;
  double? _heading;
  bool _waited = false;
  bool _permissionNeeded = false;
  bool _aligned = false;
  Timer? _waitTimer;

  @override
  void initState() {
    super.initState();
    _permissionNeeded = _compass.needsPermission;
    if (!_permissionNeeded) _listen();
    _locate();
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    _sub?.cancel();
    _compass.dispose();
    super.dispose();
  }

  void _listen() {
    _sub?.cancel();
    _sub = _compass.headings.listen((h) {
      if (!mounted) return;
      // Smooth across the 0/360 seam.
      final prev = _heading;
      final next = prev == null ? h : normalizeDegrees(prev + turnToQibla(h, prev) * 0.35);
      final aligned = turnToQibla(qiblaBearing(_lat, _lng), next).abs() < 4;
      if (aligned && !_aligned) vibrate(80);
      setState(() {
        _heading = next;
        _aligned = aligned;
      });
    });
    _waitTimer?.cancel();
    _waitTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _waited = true);
    });
  }

  Future<void> _askPermission() async {
    final ok = await _compass.requestPermission();
    if (!mounted) return;
    setState(() => _permissionNeeded = false);
    if (ok) {
      _listen();
    } else {
      setState(() => _waited = true);
      toolToast(context, 'من غير إذن البوصلة هنوريك الاتجاه بالدرجات بس');
    }
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      final p = await Where.current();
      if (!mounted) return;
      setState(() {
        _lat = p.latitude;
        _lng = p.longitude;
        _place = 'مكانك الحالي';
      });
    } catch (_) {
      if (mounted) toolToast(context, 'مقدرناش نحدد مكانك — اختار مدينتك من القائمة');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickCity() async {
    final c = await pickCity(context);
    if (c == null || !mounted) return;
    setState(() {
      _lat = c.lat;
      _lng = c.lng;
      _place = c.label;
    });
  }

  @override
  Widget build(BuildContext context) {
    final qibla = qiblaBearing(_lat, _lng);
    final heading = _heading;
    final live = heading != null;
    final turn = live ? turnToQibla(qibla, heading) : 0.0;

    return ToolScaffold(title: 'اتجاه القبلة', children: [
      GlassCard(
        child: Row(children: [
          const Icon(Icons.place_rounded, color: AppColors.gold),
          const SizedBox(width: 8),
          Expanded(child: Text(_place, style: toolTitleStyle)),
          if (_locating)
            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
          else
            IconButton(tooltip: 'حدّد مكاني', onPressed: _locate, icon: const Icon(Icons.my_location_rounded, color: Colors.white70)),
          TextButton(onPressed: _pickCity, child: const Text('مدينة تانية', style: TextStyle(color: AppColors.gold))),
        ]),
      ),
      const SizedBox(height: 6),
      Center(
        child: SizedBox(
          width: 290,
          height: 290,
          child: _Dial(rotation: live ? -heading : 0, qibla: qibla, aligned: _aligned && live),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'القبلة على ${toArabicDigits(qibla.toStringAsFixed(0))}° من الشمال',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
      ),
      Text(
        'ناحية ${compassPointAr(qibla)} • المسافة للكعبة حوالي ${toArabicDigits(distanceToKaabaKm(_lat, _lng).round())} كم',
        textAlign: TextAlign.center,
        style: toolMutedStyle,
      ),
      const SizedBox(height: 14),
      if (_permissionNeeded)
        FilledButton.icon(
          onPressed: _askPermission,
          icon: const Icon(Icons.explore_rounded),
          label: const Text('شغّل البوصلة'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
        )
      else if (live)
        GlassCard(
          highlight: _aligned,
          child: Text(
            _aligned
                ? 'تمام! إنت دلوقتي متوجّه للقبلة ✓'
                : (turn > 0 ? 'لفّ يمين ${toArabicDigits(turn.abs().round())}°' : 'لفّ شمال ${toArabicDigits(turn.abs().round())}°'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        )
      else if (_waited)
        const GlassCard(
          child: Text(
            'البوصلة مش متاحة على الجهاز أو المتصفح ده. حط الموبايل مسطّح ووجّه حرف «ش» (الشمال) ناحية الشمال '
            '— تقدر تعرفه من تطبيق الخرائط أو البوصلة — والسهم الدهبي هيبقى اتجاه القبلة.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.7),
          ),
        )
      else
        const Center(child: Text('بندوّر على البوصلة…', style: toolMutedStyle)),
      const SizedBox(height: 10),
      const Text(
        'نصيحة: امسك الموبايل مسطّح وبعيد عن الحديد والمغناطيس. لو الاتجاه مش ثابت حرّك الموبايل في شكل رقم 8 كام مرة عشان البوصلة تتظبط.',
        style: toolMutedStyle,
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

/// A compass rose rotated so north points north; the gold arrow is the qibla.
class _Dial extends StatelessWidget {
  const _Dial({required this.rotation, required this.qibla, required this.aligned});
  final double rotation;
  final double qibla;
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Transform.rotate(
        angle: rotation * math.pi / 180,
        child: CustomPaint(size: const Size(290, 290), painter: _RosePainter(qibla, aligned)),
      ),
      // The phone's "forward" mark.
      const Positioned(top: 0, child: Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 34)),
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(shape: BoxShape.circle, color: aligned ? AppColors.gold : AppColors.nightMid, border: Border.all(color: AppColors.gold, width: 2)),
        child: Icon(Icons.mosque_rounded, color: aligned ? AppColors.night : AppColors.gold),
      ),
    ]);
  }
}

class _RosePainter extends CustomPainter {
  _RosePainter(this.qibla, this.aligned);
  final double qibla;
  final bool aligned;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 18;
    canvas.drawCircle(c, r, Paint()..color = Colors.white.withValues(alpha: 0.06));
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white24
        ..strokeWidth = 2,
    );
    for (var d = 0; d < 360; d += 10) {
      final a = (d - 90) * math.pi / 180;
      final major = d % 90 == 0;
      final p1 = c + Offset(math.cos(a), math.sin(a)) * r;
      final p2 = c + Offset(math.cos(a), math.sin(a)) * (r - (major ? 14 : 7));
      canvas.drawLine(p1, p2, Paint()
        ..color = major ? Colors.white : Colors.white38
        ..strokeWidth = major ? 2.5 : 1.2);
    }
    const labels = {0: 'ش', 90: 'ق', 180: 'ج', 270: 'غ'};
    for (final e in labels.entries) {
      final a = (e.key - 90) * math.pi / 180;
      final tp = TextPainter(
        text: TextSpan(text: e.value, style: TextStyle(color: e.key == 0 ? const Color(0xFFFF6B6B) : Colors.white70, fontSize: 16, fontWeight: FontWeight.w800)),
        textDirection: TextDirection.rtl,
      )..layout();
      final p = c + Offset(math.cos(a), math.sin(a)) * (r - 28);
      tp.paint(canvas, p - Offset(tp.width / 2, tp.height / 2));
    }
    // Qibla arrow.
    final a = (qibla - 90) * math.pi / 180;
    final dir = Offset(math.cos(a), math.sin(a));
    final normal = Offset(-dir.dy, dir.dx);
    final tip = c + dir * (r + 12);
    final base = c + dir * 34;
    final paint = Paint()..color = aligned ? AppColors.gold : AppColors.gold.withValues(alpha: 0.9);
    canvas.drawLine(base, c + dir * (r - 6), Paint()
      ..color = paint.color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round);
    final head = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((c + dir * (r - 14) + normal * 11).dx, (c + dir * (r - 14) + normal * 11).dy)
      ..lineTo((c + dir * (r - 14) - normal * 11).dx, (c + dir * (r - 14) - normal * 11).dy)
      ..close();
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(_RosePainter old) => old.qibla != qibla || old.aligned != aligned;
}
