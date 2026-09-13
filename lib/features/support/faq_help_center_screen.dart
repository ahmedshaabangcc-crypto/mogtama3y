import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'support_contact_screen.dart';

class _Faq {
  const _Faq({required this.question, this.answer, this.icon = Icons.help_outline_rounded});
  final String question;
  final String? answer;
  final IconData icon;
}

const _faqs = [
  _Faq(
    question: 'كيف يحمي نظام الضمان (Escrow) أموالي عند طلب صيانة؟',
    answer:
        'عند طلبك لأي فني معتمد عبر التطبيق، يتم حجز قيمة الخدمة مؤقتاً داخل محفظة الضمان المشترك (Escrow) الآمنة. لا يتم تحويل مليم واحد لحساب الفني إلا بعد قيامك بمعاينة العمل بالكامل وإدخال رمز المصافحة والتأكيد (Handshake OTP) الذي يظهر لك فقط بعد إتمام الصيانة بنجاح وبأعلى معايير الرضا.',
    icon: Icons.shield_outlined,
  ),
  _Faq(question: 'كيف يتم توثيق شقتي في اتحاد الملاك المعتمد؟', icon: Icons.apartment_rounded),
  _Faq(question: 'هل يمكنني إخفاء رقم هاتفي الشخصي عند بيع أغراض مستعملة؟', icon: Icons.phone_disabled_rounded),
  _Faq(question: 'كيف يستفيد صندوق صيانة العمارة من أرباح بيع البيكيا والخردة؟', icon: Icons.savings_outlined),
  _Faq(question: 'ماذا أفعل في حالات الطوارئ ونداء الجيران SOS؟', icon: Icons.warning_amber_rounded),
];

/// FAQ & help center — matches design/screens/25_faq_help_center.png.
class FaqHelpCenterScreen extends StatefulWidget {
  const FaqHelpCenterScreen({super.key});

  @override
  State<FaqHelpCenterScreen> createState() => _FaqHelpCenterScreenState();
}

class _FaqHelpCenterScreenState extends State<FaqHelpCenterScreen> {
  int _expanded = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إجابات واضحة لجميع خدمات مُجتمعي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('إرشادات الأمان المالي، اتحاد الملاك، وخدمات الجيرة المتكاملة', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
          const SizedBox(height: 12),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Row(children: [
              Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
              SizedBox(width: 8),
              Text('ابحث عن سؤالك أو مشكلتك...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 12),
          const _FilterChips(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Text('ميثاق أمان الجيرة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                          child: const Text('حماية 100%', style: TextStyle(fontSize: 9, color: AppColors.tealLight, fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      const Text(
                        'دفعات الصيانة تُحجز بضمان مالي حقيقي في محفظتك ولا تُصرف للفني إلا بعد تأكيدك، وقرارات اتحاد الملاك محفوظة وموثقة داخل التطبيق.',
                        style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < _faqs.length; i++) ...[
            _FaqCard(
              faq: _faqs[i],
              expanded: _expanded == i,
              onTap: () => setState(() => _expanded = _expanded == i ? -1 : i),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Icon(Icons.menu_book_outlined, color: AppColors.inkSecondary),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('دليل اللائحة الداخلية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text('حقوق وواجبات الجيران وقواعد المرافق المشتركة', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.support_agent_rounded, color: AppColors.inkMuted)),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('محتاج مساعدة إضافية؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    SizedBox(height: 3),
                    Text('افتح تذكرة دعم وهيتواصل معاك فريقنا لمساعدتك في أي نزاع أو استفسار.',
                        style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                Row(children: const [
                  Icon(Icons.support_agent_rounded, color: AppColors.teal),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('لم تجد إجابة لسؤالك؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.teal)),
                        Text('افتح تذكرة دعم وهيتواصل معاك فريقنا في أقرب وقت', style: TextStyle(fontSize: 10, color: AppColors.teal)),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportContactScreen())),
                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.teal, side: const BorderSide(color: AppColors.teal), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15),
                          label: const Text('تواصل مع الدعم', style: TextStyle(fontSize: 11.5)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportContactScreen())),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          icon: const Icon(Icons.confirmation_number_outlined, size: 15),
                          label: const Text('فتح تذكرة دعم', style: TextStyle(fontSize: 11.5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل', 'منظومة اتحاد الملاك', 'محفظة الضمان والصيانة'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faq, required this.expanded, required this.onTap});
  final _Faq faq;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: expanded ? AppColors.teal : AppColors.border, width: expanded ? 1.5 : 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(faq.icon, size: 18, color: AppColors.teal),
              const SizedBox(width: 10),
              Expanded(child: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5, height: 1.4))),
              Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: AppColors.inkMuted),
            ]),
            if (expanded && faq.answer != null) ...[
              const SizedBox(height: 10),
              Text(faq.answer!, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.8)),
            ],
          ],
        ),
      ),
    );
  }
}
