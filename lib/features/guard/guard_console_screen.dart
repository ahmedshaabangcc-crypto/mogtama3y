import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class _ScanLog {
  const _ScanLog({required this.visitorName, required this.unit, required this.time, required this.type});
  final String visitorName, unit, time, type;
}

const _recentScans = [
  _ScanLog(visitorName: 'م/ حسام علام (مهندس ديكور)', unit: 'شقة 4B', time: 'منذ 12 دقيقة', type: 'في صيانة'),
  _ScanLog(visitorName: 'مندوب فوري ماركت', unit: 'شقة 205', time: 'منذ 40 دقيقة', type: 'دليفري طلبات'),
  _ScanLog(visitorName: 'أ. سارة محمود (ضيفة)', unit: 'شقة 402', time: 'منذ ساعة', type: 'ضيف عائلي'),
];

const _custodyItems = [
  ('ميدالية مفاتيح سيارة تويوتا حديثة', 'مفاتيح وسيارات • عمارة 16 - مدخل رئيسي'),
  ('محفظة جلدية رجالية بنية مع مستندات', 'محافظ وبطاقات • حديقة عمارة دجلة'),
];

/// The building guard's daily console — visitor QR scanning, lost &
/// found custody, and delivery log. Appointed by the union president.
class GuardConsoleScreen extends StatelessWidget {
  const GuardConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة تحكم حارس العقار')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(Icons.security_rounded, color: Colors.white, size: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('عم رجب - حارس عمارة 16', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                      child: const Text('معيّن رسمياً من رئيس الاتحاد م. أحمد شريف', style: TextStyle(fontSize: 8.5, color: AppColors.tealLight, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Row(children: const [
            Expanded(child: _StatTile(icon: Icons.qr_code_scanner_rounded, value: '9', label: 'زوار تم التحقق منهم')),
            SizedBox(width: 8),
            Expanded(child: _StatTile(icon: Icons.inventory_2_outlined, value: '3', label: 'طرود مستلمة اليوم')),
            SizedBox(width: 8),
            Expanded(child: _StatTile(icon: Icons.key_outlined, value: '2', label: 'أمانات تحت العهدة')),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              icon: const Icon(Icons.qr_code_scanner_rounded, size: 22),
              label: const Text('مسح تصريح دخول زائر (QR)', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 22),
          const Text('آخر عمليات المسح والتحقق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          for (final s in _recentScans) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.check_circle_outline_rounded, color: AppColors.teal, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.visitorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                      Text('${s.unit} • ${s.type}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
                Text(s.time, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
              ]),
            ),
          ],
          const SizedBox(height: 12),
          Row(children: [
            const Expanded(child: Text('الأمانات والمفقودات تحت عهدتك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('2 أمانة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          for (final item in _custodyItems) ...[
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.inventory_outlined, color: AppColors.gold, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(item.$2, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('تسليم', style: TextStyle(fontSize: 11))),
              ]),
            ),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.shield_outlined, size: 16, color: AppColors.inkSecondary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'صلاحياتك كحارس معتمد تخضع لتعيين ومراجعة رئيس اتحاد الملاك، ويمكن سحبها في أي وقت من لوحة إدارة الاتحاد.',
                  style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          Text(label, style: const TextStyle(fontSize: 8.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
