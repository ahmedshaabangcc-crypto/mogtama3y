import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Report a lost or found item — matches
/// design/screens/41_add_lost_found_item.png.
class AddLostFoundItemScreen extends StatefulWidget {
  const AddLostFoundItemScreen({super.key});

  @override
  State<AddLostFoundItemScreen> createState() => _AddLostFoundItemScreenState();
}

class _AddLostFoundItemScreenState extends State<AddLostFoundItemScreen> {
  int _mode = 1;
  int _custody = 0;
  bool _blurTags = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إضافة بلاغ مفقود أو معثور عليه')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text(
            'المساهمة في حفظ الأمانات وحقوق الجيران من خلال منظومة التحقق المشترك الموثقة.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ModeChoice(icon: Icons.search_off_rounded, label: 'فقدت غرضاً', selected: _mode == 0, onTap: () => setState(() => _mode = 0)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeChoice(icon: Icons.inventory_2_outlined, label: 'عثرت على شيء (أمانة)', selected: _mode == 1, onTap: () => setState(() => _mode = 1)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('صورة الأمانة التوثيقية', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                  child: const Icon(Icons.add_a_photo_outlined, color: AppColors.inkSecondary, size: 24),
                ),
                const SizedBox(height: 10),
                const Text('اضغط لالتقاط أو إرفاق صورة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                const SizedBox(height: 4),
                const Text('JPG, PNG فقط، حد أقصى 10 ميجا', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: const Text('نشط: الذكاء الاصطناعي يعالج الصورة تلقائياً', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.blur_circular_rounded, size: 20, color: AppColors.inkSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('طمس وتعتيم العلامات الفارقة الذاتي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(height: 3),
                      const Text('يقوم النظام تلقائياً بتشويش أي أرقام مميزة أو نقوش دقيقة لإجبار المدعي على ذكرها قبل الاستلام.',
                          style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(value: _blurTags, onChanged: (v) => setState(() => _blurTags = v), activeThumbColor: AppColors.teal),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('عنوان البلاغ *'),
          const SizedBox(height: 6),
          _InputField(hint: 'مثال: ميدالية مفاتيح، محفظة، هاتف، سماعات'),
          const SizedBox(height: 14),
          const _FieldLabel('التصنيف العام *'),
          const SizedBox(height: 6),
          _DropdownBox(text: 'اختر تصنيف الغرض...'),
          const SizedBox(height: 14),
          const _FieldLabel('مكان العثور عليه بدقة *'),
          const SizedBox(height: 6),
          _InputField(hint: 'اسم الشارع، العمارة، مدخل المبنى، المصعد'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _QuickChip('مدخل التمارة الرئيسي'),
              _QuickChip('حديقة المجمع'),
              _QuickChip('كابينة المصعد'),
              _QuickChip('مواقف سيارات B1'),
            ],
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('مكان إيداع الأمانة والتحريز', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('إلزامي للأمانات', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          _CustodyOption(
            title: 'تم إيداع الأمانة طرف حارس عمارة موثق (عم رجب - حارس عمارة 16)',
            selected: _custody == 0,
            onTap: () => setState(() => _custody = 0),
            expanded: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('الحارس معتمد ومفيد في سجل اتحاد الملاك، ويتحمل مسؤولية الاستلام والتسليم الميداني.',
                      style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                  const SizedBox(height: 8),
                  _DropdownBox(text: 'عمارة 16 - الحارس: عمّ رجب (موثق ومسجل)'),
                  const SizedBox(height: 6),
                  Row(children: const [
                    Icon(Icons.check_circle_rounded, size: 13, color: AppColors.teal),
                    SizedBox(width: 4),
                    Text('الهاتف الموثق: 3910****010', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _CustodyOption(
            title: 'الأمانة معي شخصياً والتواصل عبر محادثة التطبيق فقط',
            selected: _custody == 1,
            onTap: () => setState(() => _custody = 1),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('العلامة السرية للتحقق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('مخفي عن العامة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 6),
          const Text(
            'اكتب تفصيلاً لا يعرفه سوى المالك الحقيقي للتحقق منه فقط عند الاستلام (مثال: محتويات المحفظة الداخلية، خلفية شاشة الهاتف، أو خدش محدد).',
            style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Text('أدخل علامة سرية يعرفها المالك الحقيقي فقط لمطابقتها عند التسليم...', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.verified_user_outlined, size: 16, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تنبيه أمان المجتمع السكني: الاستلام والتسليم يتم يداً بيد مع الحارس دون أي دليفري أو وسيط مجهول لحفظ الحقوق وسلامة الجميع.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.7),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.campaign_rounded, size: 18),
              label: const Text('نشر البلاغ وتنبيه جيران الحي الآن', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('سيتم بث تنبيه لـ 14 عمارة مجاورة على رادار العمارة.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _ModeChoice extends StatelessWidget {
  const _ModeChoice({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.navy : AppColors.border),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: selected ? Colors.white : AppColors.inkSecondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSecondary)),
        ]),
      ),
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

class _InputField extends StatelessWidget {
  const _InputField({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Text(hint, style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
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
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5), overflow: TextOverflow.ellipsis)),
        const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
      ]),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary)),
    );
  }
}

class _CustodyOption extends StatelessWidget {
  const _CustodyOption({required this.title, required this.selected, required this.onTap, this.expanded});
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? expanded;

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
              children: [
                Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, size: 18, color: selected ? AppColors.teal : AppColors.inkMuted),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.5))),
              ],
            ),
            if (selected && expanded != null) expanded!,
          ],
        ),
      ),
    );
  }
}
