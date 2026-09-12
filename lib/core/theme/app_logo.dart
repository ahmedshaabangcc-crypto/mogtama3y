import 'package:flutter/material.dart';

/// The real مُجتمعي logo (house + three neighbors) — extracted from
/// guest_home_screen.dart so auth_landing_screen.dart (and anywhere
/// else that needs real branding instead of a generic icon) can reuse
/// the exact same mark.
class MogtamayLogo extends StatelessWidget {
  const MogtamayLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    final stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * s
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(100 * s, 42 * s)
      ..lineTo(150 * s, 84 * s)
      ..lineTo(150 * s, 152 * s)
      ..lineTo(50 * s, 152 * s)
      ..lineTo(50 * s, 84 * s)
      ..close();
    canvas.drawPath(path, stroke);

    void person(double cx, Color color, double headR, double top, double bottom) {
      final fill = Paint()..color = color;
      canvas.drawCircle(Offset(cx * s, top * s), headR * s, fill);
      final body = Path()
        ..moveTo((cx - headR) * s, bottom * s)
        ..lineTo((cx - headR) * s, (top + headR + 6) * s)
        ..quadraticBezierTo(cx * s, (top + headR - 5) * s, (cx + headR) * s, (top + headR + 6) * s)
        ..lineTo((cx + headR) * s, bottom * s)
        ..close();
      canvas.drawPath(body, fill);
    }

    person(76, const Color(0xFF2E7FD6), 9, 112, 142);
    person(100, const Color(0xFF189E6C), 11, 100, 145);
    person(124, const Color(0xFFE8912B), 9, 112, 142);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
