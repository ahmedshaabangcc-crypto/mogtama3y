import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Item details screen — matches design/screens/05_item_details.png.
class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('تفاصيل السلعة'),
        actions: const [
          Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.storefront_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Row(
            children: const [
              Icon(Icons.favorite_border_rounded, size: 20),
              SizedBox(width: 16),
              Icon(Icons.share_outlined, size: 20),
              Spacer(),
              Text('سوق الحي المستعمل • تفاصيل القطعة', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Icon(Icons.coffee_maker_outlined, size: 56, color: AppColors.inkMuted)),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(100)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: AppColors.teal, size: 13),
                      SizedBox(width: 4),
                      Text('فحص الجودة معتمد', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)),
                  child: const Text('استخدام شخصي خفيف (3 أشهر)', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('ماكينة قهوة إسبريسو نصف أوتوماتيك مع مطحنة مدمجة',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.5)),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: AppColors.inkMuted),
              SizedBox(width: 4),
              Text('نُشرت اليوم، منذ ساعتين', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
              Spacer(),
              Text('رمز القطعة: #MKT-8842', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('3,400', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.teal)),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('جنيه مصري', style: TextStyle(fontSize: 13, color: AppColors.inkMuted)),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('4,500 جنيه', style: TextStyle(fontSize: 12, color: AppColors.inkMuted, decoration: TextDecoration.lineThrough)),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                    child: const Text('توفير 23%', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _EscrowNotice(),
          const SizedBox(height: 16),
          _SellerCard(),
          const SizedBox(height: 20),
          const _SectionTitle(icon: Icons.description_outlined, title: 'وصف السلعة وحالتها'),
          const SizedBox(height: 8),
          const Text(
            'الماكينة بحالة ممتازة كالجديدة، تم شراؤها منذ 3 أشهر واستُعملت مرات محدودة لتجربة حبوب القهوة فقط. لا يوجد بها أي خدوش أو عيوب تشغيلية. تشمل جميع الملحقات الأصلية كاملة (مكبس احترافي، بشتر تبخير الحليب سعة 350 مل، ومرشحات مفردة ومزدوجة). سبب البيع هو السفر والانتقال إلى وحدة أخرى أصغر مساحة.',
            style: TextStyle(fontSize: 13, height: 1.9, color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 16),
          _SpecsTable(),
          const SizedBox(height: 20),
          const _SectionTitle(icon: Icons.handshake_outlined, title: 'ميثاق حسن الجوار للبيع والشراء'),
          const SizedBox(height: 8),
          const _CharterLine(text: 'يحق للمشتري معاينة وفحص القطعة وتشغيلها للتأكد قبل تحويل المبلغ أو سداده.'),
          const _CharterLine(text: 'الحجز الآمن يضمن حجب السلعة عن باقي الأعضاء لمدة 24 ساعة للتسليم المباشر.'),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
                    label: const Text('محادثة آمنة مع الجار'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                    icon: const Icon(Icons.lock_outline_rounded, size: 17),
                    label: const Text('حجز بالضمان (24س)'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EscrowNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text('حماية مُجتمعي الموثوقة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    SizedBox(width: 6),
                    Text('آمن 100%', style: TextStyle(color: AppColors.teal, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'التسليم يتم يدًا بيد داخل المجمع السكني مع إيداع الأمانة عبر بوابة مُجتمعي الرئيسية، بدون شركات شحن وبدون أي تحويلات خارجية مجهولة.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('المهندس هاني زهران', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                        SizedBox(width: 4),
                        Icon(Icons.verified_rounded, color: AppColors.teal, size: 14),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text('جار موثّق • برج الياسمين (شقة 6-3)', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.star_rounded, color: AppColors.gold, size: 16),
                  Text(' 4.9', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _SellerStat(label: 'عضوية النخبة', value: 'منذ سنتين')),
              const SizedBox(width: 8),
              Expanded(child: _SellerStat(label: 'عمليات ناجحة', value: '14 عملية بحي')),
              const SizedBox(width: 8),
              Expanded(child: _SellerStat(label: 'سرعة الرد', value: 'خلال 10 دقائق')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SellerStat extends StatelessWidget {
  const _SellerStat({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.ink),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
      ],
    );
  }
}

class _SpecsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const rows = [
      ('De\'Longhi Dedica EC685', 'العلامة التجارية والموديل'),
      ('15 بار', 'ضغط المضخة الإيطالية'),
      ('9 أشهر سارية بالفاتورة', 'فترة الضمان المتبقية'),
      ('لوبي برج الياسمين أو بوابة 2', 'نقطة المعاينة والتسليم'),
    ];
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          for (final (value, label) in rows)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                  Text(label, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CharterLine extends StatelessWidget {
  const _CharterLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6))),
        ],
      ),
    );
  }
}
