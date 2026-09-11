import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'store_manager_panel_screen.dart';

/// Claim & verify a Google-imported business listing — matches
/// design/screens/42_claim_business_hub.png.
class ClaimBusinessHubScreen extends StatefulWidget {
  const ClaimBusinessHubScreen({super.key});

  @override
  State<ClaimBusinessHubScreen> createState() => _ClaimBusinessHubScreenState();
}

class _ClaimBusinessHubScreenState extends State<ClaimBusinessHubScreen> {
  int _method = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('مطالبة وتملك النشاط التجاري')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text(
            'فعّل محلك التجاري المستورد تلقائياً من خرائط جوجل وابدأ تقديم خدماتك وتوصيل لـ 500م لسكان العمارات المجاورة.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 12),
          Container(
            height: 130,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.map_rounded, size: 30, color: AppColors.inkMuted)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: const Text('مستورد من خرائط Google', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
                    child: const Text('نطاق 500 متر نشط', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.local_pharmacy_rounded, color: AppColors.categorySos),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('صيدلية الأمل الحديثة - دجلة المعادي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Row(children: const [
                      Icon(Icons.location_on_outlined, size: 11, color: AppColors.inkMuted),
                      SizedBox(width: 3),
                      Expanded(child: Text('شارع 206 متفرع من دجلة الرئيسي - المعادي', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                    ]),
                    Row(children: const [
                      Icon(Icons.star_rounded, size: 12, color: AppColors.gold),
                      SizedBox(width: 2),
                      Text('4.8 (142 مراجعة على جوجل)', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 6),
          const Text('تصنيف نشاط تجاري من خرائط جوجل', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.help_outline_rounded, color: AppColors.teal),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تنبيه التحقق من الملكية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.teal)),
                    Text('هذا النشاط التجاري مدرج تلقائياً من خرائط جوجل لخدمة سكان الحي. هل أنت المالك أو المدير الفعلي؟',
                        style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('طريقة إثبات الملكية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('3 خيارات موثقة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          _ProofOption(
            selected: _method == 0,
            onTap: () => setState(() => _method = 0),
            badge: 'أسرع طريقة - فورية',
            badgeColor: AppColors.teal,
            title: 'إرسال كود OTP عبر هاتف المحل الأرضي / المسجل في جوجل فوراً',
            body: 'إرسال رمز تحقق آني (OTP) إلى هاتف المتجر الثابت/المسجل في جوجل فوراً للتأكيد الآلي المباشر.',
            note: 'اتصال آلي بصوت عربي واضح لقراءة رمز التفعيل المكون من 6 أرقام',
          ),
          const SizedBox(height: 10),
          _ProofOption(
            selected: _method == 1,
            onTap: () => setState(() => _method = 1),
            badge: 'مراجعة سريعة',
            badgeColor: AppColors.gold,
            title: 'رفع صورة السجل التجاري أو البطاقة الضريبية للمنشأة',
            body: 'رفع مستند رسمي بإدارة أو ملكية الصيدلية لتوثيق الحساب التجاري رسمياً.',
          ),
          const SizedBox(height: 10),
          _ProofOption(
            selected: _method == 2,
            onTap: () => setState(() => _method = 2),
            badge: 'ضمان الجيرة',
            badgeColor: AppColors.categoryUnion,
            title: 'تزكية وتأكيد رئيس اتحاد ملاك العمارة الكائن بها المحل (عمارة 14)',
            body: 'تزكية وتأكيد رقمي مباشر من رئيس اتحاد ملاك عمارة 14 عبر حسابه بتطبيق مُجتمعي.',
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('مزايا الشريك التجاري بعد التوثيق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('حصري لمجتمع البرج', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          const _BenefitTile(
            icon: Icons.local_shipping_outlined,
            title: 'توصيل سريع حصري (500م)',
            body: 'وصول سريع لشقق السكان خلال 10-15 دقيقة مع بوابة الدخول الرقمي المخصص لمندوب محلك دون توقيف أمني.',
          ),
          const SizedBox(height: 10),
          const _BenefitTile(
            icon: Icons.loyalty_outlined,
            title: 'خصومات بطاقة الساكن الموثقة (10%)',
            body: 'ظهور محلك في صدارة قائمة التسوق اليومي لسكان أكثر من 240 شقة مع تقديم كوبونات تلقائية.',
          ),
          const SizedBox(height: 10),
          const _BenefitTile(
            icon: Icons.dashboard_customize_outlined,
            title: 'لوحة تحكم فورية ذكية',
            body: 'تعديل فوري لقائمة المنتجات، استلام الطلبات صوتياً عبر التطبيق، وتحويل أسبوعي لمستحقات المبيعات عبر إنستاباي.',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.verified_user_outlined, color: AppColors.inkSecondary),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ضمان حماية الملكية التجارية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    Text('يتم تدقيق كافة بيانات النشاط ومطابقتها قانونياً تحت إشراف اتحاد الملاك المرخص.', style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const StoreManagerPanelScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.verified_rounded, size: 18),
              label: const Text('بدء توثيق ملكية المحل وتفعيل التوصيل', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('عملية تدقيق آمنة ولا يتم خصم أي عمولة في أول 60 يوماً', textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _ProofOption extends StatelessWidget {
  const _ProofOption({required this.selected, required this.onTap, required this.badge, required this.badgeColor, required this.title, required this.body, this.note});
  final bool selected;
  final VoidCallback onTap;
  final String badge, title, body;
  final String? note;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 18, color: selected ? AppColors.teal : AppColors.inkMuted),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, height: 1.5))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
                  child: Text(badge, style: TextStyle(fontSize: 8, color: badgeColor, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Padding(padding: const EdgeInsets.only(right: 26), child: Text(body, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.6))),
            if (selected && note != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 26),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    const Icon(Icons.phone_in_talk_outlined, size: 12, color: AppColors.teal),
                    const SizedBox(width: 6),
                    Expanded(child: Text(note!, style: const TextStyle(fontSize: 9.5, color: AppColors.teal))),
                  ]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title, body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.gold, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                const SizedBox(height: 3),
                Text(body, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
