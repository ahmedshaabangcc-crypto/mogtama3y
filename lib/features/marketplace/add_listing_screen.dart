import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Add a new used-item listing — matches design/screens/04_add_used_item_listing.png.
class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  int _condition = 2;
  bool _negotiable = true;
  bool _hideFromBuilding = false;
  bool _hidePhone = true;

  static const _conditions = ['بحالة متوسطة', 'استعمال خفيف', 'شبه جديد (كالجديد)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إضافة إعلان مستعمل جديد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const _SectionLabel('صور السلعة', trailing: 'تم رفع 2 من 6'),
          const SizedBox(height: 10),
          const _PhotosRow(),
          const SizedBox(height: 6),
          const Text('الصور الواضحة مع إضاءة جيدة تزيد من سرعة بيع السلعة بنسبة 60%',
              style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          const SizedBox(height: 20),
          const _FieldLabel('عنوان الإعلان *'),
          const SizedBox(height: 6),
          const _InputBox(text: 'ماكينة قهوة ديلونجي ديديكا بحالة ممتازة'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('القسم الرئيسي'),
                    const SizedBox(height: 6),
                    _DropdownBox(text: 'أجهزة منزلية'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('القسم الفرعي'),
                    const SizedBox(height: 6),
                    _DropdownBox(text: 'ماكينات قهوة ومشروبات'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _FieldLabel('السعر المحدد'),
          const SizedBox(height: 6),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _negotiable = !_negotiable),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_negotiable ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                          size: 18, color: _negotiable ? AppColors.teal : AppColors.inkMuted),
                      const SizedBox(width: 6),
                      const Text('قابل للتفاوض', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text('3850', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      ),
                      Text('ج.م', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _FieldLabel('حالة السلعة'),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < _conditions.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _condition = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _condition == i ? AppColors.navy : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _condition == i ? AppColors.navy : AppColors.border),
                      ),
                      child: Text(_conditions[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: _condition == i ? Colors.white : AppColors.inkSecondary,
                          )),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const _FieldLabel('وصف السلعة وحالتها بالتفصيل'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'استعمال شخصي راقٍ لمدة 4 أشهر فقط، تم عمل دورة إزالة ترسبات بانتظام. تأتي مع كافة الملحقات الأصلية (البورتافلتر)، باكستك سنجل ودبل، وتمام احترافي إضافي لماكينة تقدير التركيزية لسبب البيع.',
              style: TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.inkSecondary),
            ),
          ),
          const SizedBox(height: 24),
          const Text('خصوصية الإعلان الذكية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const Text('حماية بياناتك وأمان تعاملاتك أولوية مجتمعي', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          const SizedBox(height: 12),
          _ToggleRow(
            icon: Icons.apartment_rounded,
            title: 'حجب الإعلان عن سكان عمارتي',
            subtitle: 'لن يظهر الإعلان لجيرانك في نفس العقار وسيظهر تلقائياً لباقي المستخدمين حسب الأقرب لموقعهم',
            value: _hideFromBuilding,
            onChanged: (v) => setState(() => _hideFromBuilding = v),
          ),
          const SizedBox(height: 10),
          const _InfoBanner(
            icon: Icons.auto_awesome_rounded,
            text: 'ظهور ذكي تلقائي: تُعرض السلع لجميع المشترين في مصر ويتم ترتيبها تلقائياً حسب الأقرب جغرافياً للمستخدم.',
          ),
          const SizedBox(height: 10),
          _ToggleRow(
            icon: Icons.phone_iphone_rounded,
            title: 'حجب رقم هاتفي الشخصي',
            subtitle: 'استقبال الاستفسارات حصرياً عبر محادثة التطبيق الآمنة لمنع الإزعاج',
            value: _hidePhone,
            onChanged: (v) => setState(() => _hidePhone = v),
          ),
          const SizedBox(height: 10),
          const _InfoBanner(
            icon: Icons.verified_rounded,
            tone: _BannerTone.success,
            text: 'حسابك موثّق كمالك مقيم؛ إعلانك سيحصل على شارة "بائع موثوق" تلقائياً.',
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('نشر الإعلان فوراً', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'بالنشر، أنت توافق على ميثاق الجيرة وسياسة مجتمعي للسلع المسموح بتداولها.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.trailing});
  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
        if (trailing != null) ...[
          const Spacer(),
          Text(trailing!, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
        ],
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary));
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  const _DropdownBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
        ],
      ),
    );
  }
}

class _PhotosRow extends StatelessWidget {
  const _PhotosRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 90,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline_rounded, color: AppColors.inkMuted),
                SizedBox(height: 4),
                Text('أضف صورة', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const _PhotoThumb(isMain: false),
          const SizedBox(width: 10),
          const _PhotoThumb(isMain: true),
        ],
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({required this.isMain});
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
          child: const Center(child: Icon(Icons.coffee_maker_rounded, color: AppColors.inkMuted, size: 28)),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
            child: const Icon(Icons.close_rounded, size: 13, color: Colors.white),
          ),
        ),
        if (isMain)
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(6)),
              child: const Text('الرئيسية', style: TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});
  final IconData icon;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.inkSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.teal),
        ],
      ),
    );
  }
}

enum _BannerTone { info, success }

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.icon, required this.text, this.tone = _BannerTone.info});
  final IconData icon;
  final String text;
  final _BannerTone tone;

  @override
  Widget build(BuildContext context) {
    final color = tone == _BannerTone.success ? AppColors.teal : AppColors.gold;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 11, height: 1.6, color: color, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
