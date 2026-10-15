import 'package:flutter/material.dart';

/// The مُجتمعي mark: the Arabic letter م with a network of neighbours on two
/// rings around it, gold on the night tile. tool/brand/mogtama3y_mark.html
/// (rendered by tool/make_mogtama3y_icons.sh) draws the same mark for the
/// home-screen icons, favicon and og image — keep the two in step.
class MogtamayLogo extends StatelessWidget {
  const MogtamayLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF243F7A), Color(0xFF0B1530)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: size / 72),
      ),
      padding: EdgeInsets.all(size * 0.10),
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

/// Slogan shown with the logo.
const mogtamayLogoSlogan = 'لإنشاء مجتمع عربي متقدم';

class _LogoPainter extends CustomPainter {
  static const _goldTop = Color(0xFFF8CB7E);
  static const _goldBottom = Color(0xFFE8A245);
  static const _cream = Color(0xFFFFF4DC);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    Offset p(double x, double y) => Offset(x * s, y * s);
    final c = p(100, 100);

    // Outer ring + dashed inner ring.
    canvas.drawCircle(c, 84 * s, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..color = _goldTop.withValues(alpha: 0.35));
    final dash = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..color = _goldTop.withValues(alpha: 0.25);
    const dashes = 44;
    for (var i = 0; i < dashes; i++) {
      final a = i * 2 * 3.141592653589793 / dashes;
      canvas.drawArc(Rect.fromCircle(center: c, radius: 62 * s), a, 0.03, false, dash);
    }

    // Network: an octagon linking the outer and inner nodes.
    final outer = [p(100, 16), p(184, 100), p(100, 184), p(16, 100)];
    final inner = [p(144, 56), p(144, 144), p(56, 144), p(56, 56)];
    final link = Paint()
      ..strokeWidth = 2 * s
      ..color = _goldTop.withValues(alpha: 0.45);
    for (var i = 0; i < 4; i++) {
      canvas.drawLine(outer[i], inner[i], link);
      canvas.drawLine(inner[i], outer[(i + 1) % 4], link);
    }

    // The letter م: round head + tail sweeping down-left.
    final mim = Path()
      ..moveTo(118 * s, 92 * s)
      ..cubicTo(140 * s, 92 * s, 150 * s, 76 * s, 146 * s, 62 * s)
      ..cubicTo(142 * s, 46 * s, 124 * s, 42 * s, 112 * s, 50 * s)
      ..cubicTo(100 * s, 58 * s, 100 * s, 78 * s, 112 * s, 86 * s)
      ..cubicTo(96 * s, 98 * s, 80 * s, 112 * s, 74 * s, 140 * s)
      ..cubicTo(70 * s, 160 * s, 74 * s, 172 * s, 80 * s, 180 * s);
    canvas.drawPath(
      mim,
      Paint()
        ..shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_goldTop, _goldBottom])
            .createShader(Offset.zero & size)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Nodes (neighbours).
    final cream = Paint()..color = _cream;
    final gold = Paint()..color = _goldTop;
    for (final o in outer) {
      canvas.drawCircle(o, 8 * s, cream);
    }
    for (final o in inner) {
      canvas.drawCircle(o, 6 * s, gold);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
