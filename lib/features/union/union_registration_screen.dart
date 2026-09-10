import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'verified_neighbor_welcome_screen.dart';

/// Union registration step 2: unit verification + union head approval —
/// matches design/screens/08_union_registration_step2.png.
class UnionRegistrationScreen extends StatefulWidget {
  const UnionRegistrationScreen({super.key, this.buildingName = 'برج الياسمين الفاخر'});
  final String buildingName;

  @override
  State<UnionRegistrationScreen> createState() => _UnionRegistrationScreenState();
}

class _UnionRegistrationScreenState extends State<UnionRegistrationScreen> {
  int _residency = 0;
  bool _showFamilyNameOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تسجيل وتوثيق الشقة بكود الدعوة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const _StepHeader(),
          const SizedBox(height: 20),
          const _SectionTitle('تحديد مكان العقار', badge: 'الخطوة الجغرافية'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('المحافظة'),
                    const SizedBox(height: 6),
                    _Box(text: 'القاهرة'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('الحي والمجاورة'),
                    const SizedBox(height: 6),
                    _Box(text: 'المعادي - دجلة'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _FieldLabel('البحث عن العمارة أو البرج المسجل'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                Expanded(child: Text(widget.buildingName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                const Icon(Icons.search_rounded, size: 18, color: AppColors.inkMuted),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('رقم الدور'),
                    const SizedBox(height: 6),
                    _Box(text: 'الدور الرابع'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('رقم الشقة'),
                    const SizedBox(height: 6),
                    _Box(text: 'شقة 4B'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _FieldLabel('صفة الإقامة بالوحدة'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ChoiceTile(
                  icon: Icons.home_work_rounded,
                  label: 'مالك الوحدة',
                  selected: _residency == 0,
                  onTap: () => setState(() => _residency = 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ChoiceTile(
                  icon: Icons.verified_user_outlined,
                  label: 'مستأجر موثق',
                  selected: _residency == 1,
                  onTap: () => setState(() => _residency = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(child: Text(widget.buildingName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                          child: const Text('مشهر رسمي', style: TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 3),
                      const Text('شارع 30 مترفرع من ميدان دجلة، المعادي', style: TextStyle(color: Colors.white70, fontSize: 10.5)),
                      const SizedBox(height: 4),
                      const Text('43 شقة مسجلة  •  اتحاد ملاك مشهر', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 22),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: TextButton(onPressed: () {}, child: const Text('تسجيل عقار جديد غير مدرج؟', style: TextStyle(fontSize: 11.5))),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('كود الدعوة المعتمد من رئيس الاتحاد', badge: 'توثيق فوري بدون أوراق'),
          const SizedBox(height: 8),
          const Text(
            'أدخل كود الدعوة المكوّن من رمز العقار المرسل لك مباشرة من رئيس اتحاد الملاك لتوثيق ملكية الشقة فوراً أو إحضار شنطة وثائق دون الحاجة لرفع مستندات.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                  child: const Text('مثال: YSM-9482', style: TextStyle(fontSize: 13, color: AppColors.inkMuted)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('تحقق من الكود', style: TextStyle(fontSize: 12.5)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(children: [
            Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.teal),
            SizedBox(width: 6),
            Expanded(child: Text('يتم تفعيل عضويتك فور مطابقة الكود مع سجل اتحاد الملاك', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
          ]),
          const SizedBox(height: 20),
          const _SectionTitle('موافقة واعتماد رئيس اتحاد الملاك', badge: 'خطوة إلزامية'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.rule_folder_outlined, size: 20, color: AppColors.inkSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('آلية الانضمام والتحقق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                      const SizedBox(height: 4),
                      const Text(
                        'بعد إدخال كود الدعوة، يُحال طلبك إلى رئيس اتحاد الملاك للموافقة والاعتماد النهائي قبل انضمامك لمجتمع العمارة.',
                        style: TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7),
                      ),
                      const SizedBox(height: 6),
                      const Row(children: [
                        Icon(Icons.shield_outlined, size: 13, color: AppColors.inkMuted),
                        SizedBox(width: 5),
                        Expanded(child: Text('حماية وتدقيق مجتمعي لضمان خصوصية وأمان سكان البرج', style: TextStyle(fontSize: 10, color: AppColors.inkMuted))),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('خيارات الخصوصية داخل العمارة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.visibility_off_outlined, size: 20, color: AppColors.inkSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('إظهار اسم العائلة فقط لجيران العمارة', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      const Text('سيظهر اسمك في دليل سكان العمارة كـ «عائلة الأحمدي» بدلاً من اسمك الكامل',
                          style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.5)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(value: _showFamilyNameOnly, onChanged: (v) => setState(() => _showFamilyNameOnly = v), activeThumbColor: AppColors.teal),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('المجلس التنسيقي المشرف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('م. أحمد شريف', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                      Text('المسؤول الإداري ورئيس الاتحاد', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                  child: const Text('استجابة سريعة < 3 ساعات', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VerifiedNeighborWelcomeScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('إرسال طلب الانضمام والتوثيق للاتحاد', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('سيتم إشعارك فور اعتماد رئيس الاتحاد لانضمامك',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(100)),
                child: const Text('خطوة 2 من 3', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('توثيق الوحدة السكنية والانضمام لاتحاد الملاك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(value: 2 / 3, minHeight: 6, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _StepDot(label: 'الهوية الشخصية', done: true),
              _StepDot(label: 'كود الدعوة المعتمد', done: false, active: true),
              _StepDot(label: 'اعتماد رئيس الاتحاد', done: false),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.label, required this.done, this.active = false});
  final String label;
  final bool done, active;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.teal : (active ? AppColors.navy : AppColors.inkMuted);
    return Column(
      children: [
        Icon(done ? Icons.check_circle_rounded : Icons.circle, size: 8, color: color),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {required this.badge});
  final String title, badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
          child: Text(badge, style: const TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary));
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
        ],
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.navy : AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: selected ? Colors.white : AppColors.inkSecondary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSecondary)),
          ],
        ),
      ),
    );
  }
}
