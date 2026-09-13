import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../union/find_building_screen.dart';

const _pillars = [
  (
    icon: Icons.account_balance_rounded,
    title: 'حوكمة اتحاد الملاك والشفافية المالية',
    body: 'حوكمة كاملة لجمعيات واتحادات الملاك مع تقارير محاسبية فورية وإشراف حي على الصناديق والمصروفات بكل شفافية.',
  ),
  (
    icon: Icons.shield_outlined,
    title: 'الأمان والضمان المالي (Escrow)',
    body: 'حماية مدفوعات الصيانة بنظام الحجز المشفر المعتمد، ولا يُصرف للفني إلا بعد تأكيد الساكن وإتمام العمل برضا تام.',
  ),
  (
    icon: Icons.storefront_outlined,
    title: 'تنمية الاقتصاد المحلي وتوصيل الـ500م',
    body: 'دعم محلات البقالة والمتاجر التابعة للمناطق السكنية المجاورة مع توصيل سريع وتدوير البيكيا لاستدامة الحي.',
  ),
  (
    icon: Icons.privacy_tip_outlined,
    title: 'بيئة سكنية آمنة تحمي الخصوصية',
    body: 'تواصل وتفاعل سكني ذكي ومترابط يحجب رقم الهاتف الشخصي ويحمي خصوصية كل أسرة داخل المجمع السكني.',
  ),
];

/// About the platform / marketing page — matches
/// design/screens/28_about_platform.png.
class AboutPlatformScreen extends StatelessWidget {
  const AboutPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('عن منصة مُجتمعي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Text('موثّق رسمياً', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 4),
          const Text('من نحن وعن منصة مُجتمعي', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 4),
          const Text('الرؤية، الرسالة، وركائز السكن الذكي التشاركي', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                    child: const Text('الريادة السكنية', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.hub_rounded, color: Colors.white, size: 18),
                  ),
                ]),
                const SizedBox(height: 10),
                const Text('مُجتمعي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                const Text('Mogtama3y Smart Living', style: TextStyle(color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 10),
                const Text(
                  'منصة سكنية ومجتمعية ذكية تربط الجيران وتحوكم أعمال اتحاد الملاك بشفافية تامة، وتوفر خدمات صيانة منزلية بضمان مالي وتجارة محلية آمنة بدون أي وساطة معقدة.',
                  style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.8),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    image: const DecorationImage(image: AssetImage('assets/images/building_header.png'), fit: BoxFit.cover, opacity: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Row(children: const [
                  Icon(Icons.verified_rounded, size: 13, color: AppColors.tealLight),
                  SizedBox(width: 6),
                  Text('حوكمة رقمية متكاملة لعمارتك', style: TextStyle(color: AppColors.tealLight, fontSize: 10.5, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('أثر منصة مُجتمعي بالأرقام', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            const Text('تحديث حي ومباشر', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 10),
          Row(children: const [
            Expanded(child: _StatCircle(emoji: '😊', value: '98%', label: 'نسبة رضا')),
            SizedBox(width: 8),
            Expanded(child: _StatCircle(emoji: '🏘️', value: '4,500+', label: 'جار موثق')),
            SizedBox(width: 8),
            Expanded(child: _StatCircle(emoji: '📅', value: '180+', label: 'عمارة مفعّلة')),
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.show_chart_rounded, size: 15, color: AppColors.teal),
                  SizedBox(width: 6),
                  Text('مؤشر التوافق وسداد المستحقات السكنية', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Spacer(),
                  Text('+18.4% نمو هذا العام', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 10),
                SizedBox(height: 50, child: CustomPaint(painter: _TrendPainter(), size: const Size(double.infinity, 50))),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('ركائز مُجتمعي الأربعة الأساسية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const Text('الأسس التقنية والاجتماعية التي تُبنى عليها منصتنا', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 12),
          for (var i = 0; i < _pillars.length; i++) ...[
            _PillarRow(index: i + 1, icon: _pillars[i].icon, title: _pillars[i].title, body: _pillars[i].body),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const Icon(Icons.workspace_premium_rounded, color: AppColors.teal, size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اعتماد وموثوقية رسمية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.teal)),
                    SizedBox(height: 4),
                    Text(
                      'مرخّص كمنصة تكنولوجيا عقارية ومجتمعية ذكية وفق أحدث تشريعات تنظيم اتحادات الشاغلين وإدارة المرافق السكنية.',
                      style: TextStyle(fontSize: 10, color: AppColors.teal, height: 1.7),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FindBuildingScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.groups_2_outlined, size: 18),
              label: const Text('انضم إلى مجتمعاتنا السكنية', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('انضمام عمارة جديدة يستغرق أقل من 3 دقائق مع فريق التوثيق الميداني.', textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _StatCircle extends StatelessWidget {
  const _StatCircle({required this.emoji, required this.value, required this.label});
  final String emoji, value, label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _PillarRow extends StatelessWidget {
  const _PillarRow({required this.index, required this.icon, required this.title, required this.body});
  final int index;
  final IconData icon;
  final String title, body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.teal, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, shape: BoxShape.circle),
                    child: Text('$index', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.4))),
                ]),
                const SizedBox(height: 6),
                Text(body, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.7)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [0.7, 0.6, 0.5, 0.55, 0.4, 0.35, 0.2, 0.15, 0.05];
    final path = Path();
    final fillPath = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, Paint()..color = AppColors.teal.withValues(alpha: 0.12));
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    final lastX = size.width;
    final lastY = size.height * points.last;
    canvas.drawCircle(Offset(lastX, lastY), 4, Paint()..color = AppColors.teal);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
