import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _pillars = [
  (
    icon: Icons.phonelink_lock_rounded,
    tag: 'تلقائي',
    title: 'حماية الهوية وحجب أرقام الهواتف الشخصية',
    body: 'يتم حجب وإخفاء رقم هاتفك الشخصي تلقائياً في الإعلانات المعروضة والوظائف وسوق الجيران. يتم التواصل حصراً عبر القنوات المشفرة للتطبيق ما لم تختر إظهاره صراحة.',
    detail: 'الرقم المُظهر للجيران: 05XXXX9821',
  ),
  (
    icon: Icons.verified_user_outlined,
    tag: 'حراسة مشفرة',
    title: 'سرية عقود الإقامة ومستندات التوثيق السكني',
    body: 'تُحفظ مستندات الملكية وعقود الإقامة في خزينة سحابية معزولة ومشفرة، ولا يمكن الاطلاع عليها أو مشاركتها نهائياً إلا مع رئيس اتحاد الملاك المعتمد بغرض إثبات وتوثيق العضوية فقط.',
    detail: 'اطّلاع مقيد حصراً برئيس الاتحاد المعتمد برقم نفاذ وطني',
  ),
  (
    icon: Icons.my_location_rounded,
    tag: 'نطاق آمن',
    title: 'بيانات الموقع الجغرافي ونطاق الخرائط',
    body: 'يُعرض موقعك للجيران والمتاجر المحلية في نطاق محدد بـ 500 متر تقريبي فقط، دون كشف موقع شقتك أو رقم وحدتك السكنية وطابقك في الخرائط التفاعلية إطلاقاً.',
    detail: 'محيط الأمان التلقائي: نطاق 500م تقريبي',
  ),
  (
    icon: Icons.account_balance_rounded,
    tag: 'معتمد PCI-DSS',
    title: 'تشفير المعاملات وحساب الضمان Escrow',
    body: 'تتم جميع الرسوم الدورية ومستحقات الصيانة والمشتريات عبر بوابات مصرفية مشفرة بحساب الضمان الذي تطبق مُجتمعي، ولا يخزن أية بيانات بنكية سرية إطلاقاً.',
    detail: 'حساب ضمان Escrow مخصص ومحمي بنكياً لكل مبنى سكني',
  ),
  (
    icon: Icons.tune_rounded,
    tag: 'تحكم كامل',
    title: 'حقوق المستخدم والتحكم في البيانات',
    body: 'أنت المالك الوحيد لبياناتك. يحق لك التطبيق في أي وقت طلب تصدير نسختك الرقمية، أو تعديل صلاحيات المشاركة، أو حذف الحساب وجميع السجلات غير المالية وفق اللوائح النظامية.',
    detail: 'تصدير بياناتي',
  ),
];

/// Privacy policy — matches design/screens/26_privacy_policy.png.
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سياسة الخصوصية وحماية البيانات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            const Icon(Icons.update_rounded, size: 13, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            const Text('آخر تحديث: أكتوبر 2025', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          ]),
          const SizedBox(height: 4),
          const Text('منظومة الأمان والشفافية لتطبيق مُجتمعي', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
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
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                    child: const Text('معايير بنكية وخوادم محلية آمنة', style: TextStyle(fontSize: 9, color: AppColors.tealLight, fontWeight: FontWeight.w700)),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'بياناتك ومستنداتك مشفرة ومحمية بأعلى معايير الأمان المصري (AES-256)',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13.5, height: 1.5),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'نلتزم بأعلى مقاييس الشفافية وحماية البيانات الشخصية وفق الضوابط النظامية لحظك خصوصيتك واستقرار سكنك داخل المجمع.',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.7),
                ),
                const SizedBox(height: 14),
                Row(children: const [
                  Expanded(child: _StandardChip(title: 'خوادم محلية', subtitle: 'امتثال PDPL')),
                  SizedBox(width: 8),
                  Expanded(child: _StandardChip(title: 'TLS 1.3', subtitle: 'نقل مشفر')),
                  SizedBox(width: 8),
                  Expanded(child: _StandardChip(title: 'AES-256', subtitle: 'تشفير تام')),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(children: [
            Container(width: 4, height: 18, decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100))),
            const SizedBox(width: 8),
            const Text('ركائز الخصوصية الأساسية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ]),
          const SizedBox(height: 4),
          const Text('شفافية كاملة وموثوقة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 12),
          for (final p in _pillars) ...[
            _PillarCard(icon: p.icon, tag: p.tag, title: p.title, body: p.body, detail: p.detail),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.gavel_rounded, color: AppColors.inkSecondary),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الالتزام القانوني والأخلاقي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    SizedBox(height: 4),
                    Text(
                      'تخضع كافة معالجات البيانات في منصة مُجتمعي لنظام حماية البيانات الشخصية المصري الملكي، ويتم تدقيق كافة إجراءات الأمان سنوياً بواسطة هيئات أمن سيبراني مستقلة ومعتمدة.',
                      style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.7),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => setState(() => _agreed = !_agreed),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_agreed ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: _agreed ? AppColors.teal : AppColors.inkMuted),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'قرأت وأوافق على كافة الشروط الواردة في سياسة الخصوصية وحماية البيانات، ومنحت الصلاحيات المحددة أعلاه لخدمة عقاري وسكني.',
                    style: TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _agreed ? () => Navigator.of(context).pop() : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
              label: const Text('أوافق على سياسة الخصوصية وحماية البيانات', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StandardChip extends StatelessWidget {
  const _StandardChip({required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11.5)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 8.5)),
        ],
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({required this.icon, required this.tag, required this.title, required this.body, required this.detail});
  final IconData icon;
  final String tag, title, body, detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.teal, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                      child: Text(tag, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.8)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: Text(detail, style: const TextStyle(fontSize: 10, color: AppColors.inkSecondary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
