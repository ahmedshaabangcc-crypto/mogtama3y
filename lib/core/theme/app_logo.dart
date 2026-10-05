import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The مُجتمعي mark: a gold roof over three neighbours on the night-crystal
/// tile used across the app. tool/make_brand_icons.ps1 draws the same mark
/// for the favicon and the home-screen icons — keep the two in step.
class MogtamayLogo extends StatelessWidget {
  const MogtamayLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF243F7A), Color(0xFF0B1530)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18), width: size / 72),
      ),
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  static const _goldTop = Color(0xFFF8CB7E);
  static const _goldBottom = Color(0xFFE8A245);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    final gold = Paint()
      ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_goldTop, _goldBottom])
          .createShader(Offset.zero & size);

    // Roof.
    final roof = Path()
      ..moveTo(42 * s, 96 * s)
      ..lineTo(100 * s, 46 * s)
      ..lineTo(158 * s, 96 * s);
    canvas.drawPath(
      roof,
      Paint()
        ..shader = gold.shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Three neighbours: head + shoulders, the middle one in gold.
    void person(double cx, double headY, double r, Paint paint) {
      canvas.drawCircle(Offset(cx * s, headY * s), r * s, paint);
      final top = headY + r + 5;
      final w = r * 3.6;
      canvas.drawArc(Rect.fromLTWH((cx - w / 2) * s, top * s, w * s, r * 3.4 * s), math.pi, math.pi, true, paint);
    }

    final white = Paint()..color = Colors.white.withValues(alpha: 0.88);
    person(66, 118, 10.5, white);
    person(134, 118, 10.5, white);
    person(100, 108, 13.5, gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
