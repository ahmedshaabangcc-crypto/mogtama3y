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

/// Within this many degrees the phone counts as facing the qibla.
const qiblaTolerance = 5.0;

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
  final _smoother = HeadingSmoother(factor: 0.2);
  final _recent = <double>[]; // last raw headings, for the jitter check
  StreamSubscription<CompassReading>? _sub;
  double? _heading;
  double? _accuracy;
  bool _tilted = false;
  bool _jumpy = false;
  bool _waited = false;
  bool _permissionNeeded = false;
  bool _aligned = false;
  Timer? _waitTimer;
  Timer? _paintTimer;
  DateTime _lastPaint = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _permissionNeeded = _compass.needsPermission;
    // Listen right away — on iOS, if permission was already granted this
    // session, readings flow and the button disappears by itself.
    _sub = _compass.readings.listen(_onReading);
    _compass.start();
    _waitTimer = Timer(const Duration(seconds: 3), () {
      // Only a fallback while nothing has arrived; never once data flowed.
      if (mounted && _heading == null) setState(() => _waited = true);
    });
    _locate();
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    _paintTimer?.cancel();
    _sub?.cancel();
    _compass.dispose();
    super.dispose();
  }

  void _onReading(CompassReading r) {
    if (!mounted) return;
    _recent.add(r.heading);
    if (_recent.length > 15) _recent.removeAt(0);
    final h = _smoother.add(r.heading);
    final aligned = turnToQibla(qiblaBearing(_lat, _lng), h).abs() <= qiblaTolerance;
    if (aligned && !_aligned) vibrate(80);
    final first = _heading == null;
    _heading = h;
    _aligned = aligned;
    _accuracy = r.accuracy;
    _tilted = isTilted(r.beta, r.gamma);
    _jumpy = _recent.length >= 10 && circularSpread(_recent) > 12;
    _permissionNeeded = false;
    _waited = false;
    // Sensors fire ~60×/s; repaint at most ~30×/s.
    final now = DateTime.now();
    if (first || now.difference(_lastPaint) > const Duration(milliseconds: 33)) {
      _lastPaint = now;
      _paintTimer?.cancel();
      _paintTimer = null;
      setState(() {});
    } else {
      // Make sure the latest reading still shows if the events stop here.
      _paintTimer ??= Timer(const Duration(milliseconds: 40), () {
        _paintTimer = null;
        _lastPaint = DateTime.now();
        if (mounted) setState(() {});
      });
    }
  }

  Future<void> _askPermission() async {
    final ok = await _compass.requestPermission();
    if (!mounted) return;
    if (ok) {
      setState(() => _permissionNeeded = false);
      _compass.start();
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

  String _deg(double d) => '${toArabicDigits(normalizeDegrees(d).round() % 360)}°';

  @override
  Widget build(BuildContext context) {
    final qibla = qiblaBearing(_lat, _lng);
    final heading = _heading;
    final live = heading != null;
    final turn = live ? turnToQibla(qibla, heading) : 0.0;
    final aligned = live && _aligned;
    final poorAccuracy = isPoorAccuracy(_accuracy);

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
          // Rose turns by −heading so «ش» points north; the arrow turns by
          // qibla − heading relative to the top of the phone.
          child: _Dial(heading: heading ?? 0, arrow: live ? turn : qibla, aligned: aligned),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'القبلة على ${_deg(qibla)} من الشمال',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
      ),
      Text(
        'ناحية ${compassPointAr(qibla)} • المسافة للكعبة حوالي ${toArabicDigits(distanceToKaabaKm(_lat, _lng).round())} كم',
        textAlign: TextAlign.center,
        style: toolMutedStyle,
      ),
      if (live)
        Text(
          'اتجاه موبايلك دلوقتي ${_deg(heading)}'
          '${_accuracy != null && _accuracy! >= 0 ? ' • دقة البوصلة ±${toArabicDigits(_accuracy!.round())}°' : ''}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.8),
        ),
      const SizedBox(height: 14),
      if (_permissionNeeded && !live) ...[
        FilledButton.icon(
          onPressed: _askPermission,
          icon: const Icon(Icons.explore_rounded),
          label: const Text('شغّل البوصلة'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.night),
        ),
        const SizedBox(height: 10),
      ],
      if (live)
        Semantics(
          label: aligned ? 'aligned' : 'turn ${turn.round()}',
          child: GlassCard(
            highlight: aligned,
            child: Text(
              aligned
                  ? 'تمام! إنت دلوقتي متوجّه للقبلة ✓'
                  : (turn > 0 ? 'لفّ يمين ${toArabicDigits(turn.abs().round())}°' : 'لفّ شمال ${toArabicDigits(turn.abs().round())}°'),
              textAlign: TextAlign.center,
              style: TextStyle(color: aligned ? _green : Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        )
      else if (_waited && !_permissionNeeded)
        const GlassCard(
          child: Text(
            'البوصلة مش متاحة على الجهاز أو المتصفح ده. حط الموبايل مسطّح ووجّه حرف «ش» (الشمال) ناحية الشمال '
            '— تقدر تعرفه من تطبيق الخرائط أو البوصلة — والسهم الدهبي هيبقى اتجاه القبلة.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.7),
          ),
        )
      else if (!_permissionNeeded)
        const Center(child: Text('بندوّر على البوصلة…', style: toolMutedStyle)),
      if (live && _tilted) const _Hint(icon: Icons.screen_rotation_alt_rounded, text: 'امسك الموبايل مفرود (مسطّح زي الصينية) عشان الاتجاه يبقى مظبوط'),
      if (live && (poorAccuracy || _jumpy))
        const _Hint(icon: Icons.all_inclusive_rounded, text: 'البوصلة محتاجة معايرة: حرّك الموبايل على شكل 8 في الهوا كام مرة'),
      const SizedBox(height: 10),
      const Text(
        'نصيحة: امسك الموبايل مسطّح وبعيد عن الحديد والمغناطيس وجراب المغناطيس. لو الاتجاه مش ثابت حرّك الموبايل في شكل رقم 8 كام مرة عشان البوصلة تتظبط.',
        style: toolMutedStyle,
        textAlign: TextAlign.center,
      ),
    ]);
  }
}

const _green = Color(0xFF34D399);

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(children: [
        Icon(icon, color: AppColors.gold, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.6))),
      ]),
    );
  }
}

/// A compass rose turned so «ش» points north, and the qibla arrow turned by
/// [arrow] degrees from the top of the phone.
class _Dial extends StatelessWidget {
  const _Dial({required this.heading, required this.arrow, required this.aligned});
  final double heading;
  final double arrow;
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final color = aligned ? _green : AppColors.gold;
    return Stack(alignment: Alignment.center, children: [
      Transform.rotate(
        angle: -heading * math.pi / 180,
        child: CustomPaint(size: const Size(290, 290), painter: _RosePainter()),
      ),
      Semantics(
        label: 'qibla-arrow ${arrow.round()}',
        child: Transform.rotate(
          angle: arrow * math.pi / 180,
          child: CustomPaint(size: const Size(290, 290), painter: _ArrowPainter(color)),
        ),
      ),
      // The phone's "forward" mark.
      const Positioned(top: 0, child: Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 34)),
      Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(shape: BoxShape.circle, color: aligned ? color : AppColors.nightMid, border: Border.all(color: color, width: 2)),
        child: Icon(Icons.mosque_rounded, color: aligned ? AppColors.night : AppColors.gold),
      ),
    ]);
  }
}

class _RosePainter extends CustomPainter {
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
  }

  @override
  bool shouldRepaint(_RosePainter old) => false;
}

/// The qibla arrow pointing straight up; the parent rotates it.
class _ArrowPainter extends CustomPainter {
  _ArrowPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 18;
    const dir = Offset(0, -1);
    const normal = Offset(1, 0);
    final tip = c + dir * (r + 12);
    final paint = Paint()..color = color;
    canvas.drawLine(c + dir * 34, c + dir * (r - 6), Paint()
      ..color = color
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round);
    final neck = c + dir * (r - 14);
    final head = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo((neck + normal * 11).dx, (neck + normal * 11).dy)
      ..lineTo((neck - normal * 11).dx, (neck - normal * 11).dy)
      ..close();
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}
