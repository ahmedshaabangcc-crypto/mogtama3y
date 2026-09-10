import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _clauses = [
  (
    number: 1,
    section: 'الحوكمة السكنية والمالية',
    tag: 'إلزامي',
    icon: Icons.account_balance_rounded,
    title: 'ضوابط منصة اتحاد الملاك واشتراكات الصيانة',
    points: [
      'الالتزام الصارم بسداد مصاريف الصيانة والخدمات الدورية في مواعيدها لضمان استمرار تشغيل المرافق العامة والمصاعد.',
      'إيداع كافة الاشتراكات حصراً في الحساب البنكي المعتمد لاتحاد الملاك واستخدام السند الإلكتروني المشفر للفواتير المعتمد بالمنصة.',
    ],
  ),
  (
    number: 2,
    section: 'السلوك والمجتمع',
    tag: 'أخلاقي',
    icon: Icons.forum_outlined,
    title: 'ميثاق حسن الجوار ومنع الإزعاج بالجريبات التفاعلية',
    points: [
      'الالتزام بساعات الهدوء العام من الساعة 11 مساءً حتى 8 صباحاً، ومنع أي أعمال صيانة مسببة لضوضاء خارج الإجازات الرسمية.',
      'حظر نشر المحتويات الإعلانية غير المصرح بها أو الرسائل المزعجة في غرفة درشة العمارة المعتمدة واحترام الخصوصية التامة للعائلات والمداخل المشتركة.',
    ],
  ),
  (
    number: 3,
    section: 'التبادل التجاري الآمن',
    tag: 'شفافية',
    icon: Icons.calendar_month_rounded,
    title: 'معاملات سوق المستعمل وتسليم الأمانات وحظر الوساطة',
    points: [
      'الوصف الصادق لحالة السلع المستعملة والإفصاح عن العيوب، مع تنظيم إجراءات تسليم الأمانات والطرود عبر نقاط الاستلام المعتمدة بالمبنى.',
      'حظر ممارسة أي وساطة تجارية خارجية غير مصرح بها أو السمسرة العقارية غير القانونية بين سكان العقار أو بالجيربات.',
    ],
  ),
  (
    number: 4,
    section: 'التحكيم والضمان',
    tag: 'ملزم Escrow',
    icon: Icons.balance_rounded,
    title: 'فض النزاعات وحماية أموال الضمان وإلزامية القرار',
    points: [
      'تحتجز أموال خدمات الصيانة والبيع في محفظة الضمان (Escrow) ولا تُصرف إلا بعد تحقق المستفيد برمز المصافحة الآمنة أو المعاينة الفعلية.',
      'في حال الخلاف يلتزم الطرفان بقرارات لجنة التحكيم المعتمدة باتحاد الملاك أو إدارة المنصة نهائياً وملزم لتسوية المبالغ المحتجزة.',
    ],
  ),
];

/// Terms & neighbor charter — matches
/// design/screens/27_terms_conditions.png.
class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('الشروط والأحكام وميثاق الجيران')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('قواعد التعايش السكني المنظم وحوكمة المعاملات المعتمدة', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
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
                    child: const Text('ميثاق مُجتمعي معتمد', style: TextStyle(fontSize: 9, color: AppColors.tealLight, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  const Text('تحديث نوفمبر 2025 • ملزم لكافة السكان', style: TextStyle(color: Colors.white54, fontSize: 8.5)),
                ]),
                const SizedBox(height: 10),
                const Text('ميثاق حسن الجوار وقواعد مجتمع عمارتنا الموثق', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, height: 1.4)),
                const SizedBox(height: 8),
                const Text(
                  'انضمامك لمنصة مُجتمعي ينشئ التزاماً أخلاقياً وتنظيمياً بحماية حقوق الجيران وخصوصيتهم، وتأمين التعاملات السكنية والمالية وفق أعلى معايير الشفافية والمسؤولية المشتركة.',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.8),
                ),
                const SizedBox(height: 10),
                Row(children: const [
                  Icon(Icons.shield_outlined, size: 13, color: AppColors.tealLight),
                  SizedBox(width: 6),
                  Text('حماية أموال الضمان Escrow', style: TextStyle(color: AppColors.tealLight, fontSize: 10, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          for (final c in _clauses) ...[
            _ClauseCard(number: c.number, section: c.section, tag: c.tag, icon: c.icon, title: c.title, points: c.points),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.fact_check_outlined, color: AppColors.inkSecondary),
                  SizedBox(width: 8),
                  Text('الموافقة والإقرار الإلكتروني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Spacer(),
                  Text('آخر تحديث: 15 نوفمبر 2025', style: TextStyle(fontSize: 8.5, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(_agreed ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: _agreed ? AppColors.teal : AppColors.inkMuted),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'قرأت وتعهدت بالالتزام بميثاق الجيران وقواعد منصة مُجتمعي المعتمدة، يشكل هذا الإقرار الإلكتروني التزاماً تعاقدياً مقدياً وقانونياً موثقاً بسجل العمارة.',
                          style: TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7),
                        ),
                      ),
                    ],
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
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.ink, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.handshake_outlined, size: 18),
              label: const Text('تأكيد الالتزام بالميثاق السكني', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClauseCard extends StatelessWidget {
  const _ClauseCard({required this.number, required this.section, required this.tag, required this.icon, required this.title, required this.points});
  final int number;
  final String section, tag, title;
  final IconData icon;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('البند ${_ordinal(number)}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted, fontWeight: FontWeight.w600)),
            const Text(' • ', style: TextStyle(color: AppColors.inkMuted)),
            Expanded(child: Text(section, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted, fontWeight: FontWeight.w600))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: Text(tag, style: const TextStyle(fontSize: 8.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.teal, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.4))),
            ],
          ),
          const SizedBox(height: 10),
          for (final p in points)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 3), child: Icon(Icons.circle, size: 5, color: AppColors.inkMuted)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(p, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static String _ordinal(int n) => const ['', 'الأول', 'الثاني', 'الثالث', 'الرابع', 'الخامس'][n];
}
