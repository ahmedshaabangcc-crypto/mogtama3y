import 'package:flutter/material.dart';

import '../../core/jobs/jobs_service.dart';
import '../../core/theme/app_colors.dart';
import '../promote/promote_listing_screen.dart';

/// Post a new job listing (step 1 of 2) — matches
/// design/screens/32_post_job_form.png.
class PostJobFormScreen extends StatefulWidget {
  const PostJobFormScreen({super.key});

  @override
  State<PostJobFormScreen> createState() => _PostJobFormScreenState();
}

class _PostJobFormScreenState extends State<PostJobFormScreen> {
  int _scheduleType = 1;
  bool _negotiable = true;
  bool _receiveCvDirect = true;
  bool _hideEmployerPhone = true;
  bool _submitting = false;
  String? _error;

  final _titleCtrl = TextEditingController(text: 'مسؤول مبيعات وكاشير متجر');
  final _categoryCtrl = TextEditingController(text: 'سوبر ماركت ومتاجر التجزئة');
  final _minSalaryCtrl = TextEditingController(text: '5000');
  final _maxSalaryCtrl = TextEditingController(text: '6500');
  final _requirementsCtrl = TextEditingController(
    text: 'مؤهل عالٍ أو متوسط مناسب مع إجادة التعامل مع نقاط البيع.\n'
        'خبرة سابقة لا تقل عن سنة في مجال مبيعات السوبرماركت أو التجزئة.\n'
        'الأولوية لسكان المعادي والمناطق المجاورة لسرعة الالتحاق.',
  );

  static const _schedules = ['دوام جزئي (Part-time)', 'دوام كامل (Full-time)', 'عمل حر / بالقطعة', 'ورديات مرنة'];
  static const _scheduleValues = ['part_time', 'full_time', 'freelance', 'shift'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    _minSalaryCtrl.dispose();
    _maxSalaryCtrl.dispose();
    _requirementsCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = 'أدخل المسمى الوظيفي أولاً.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final id = await JobsService.postJob(
        title: _titleCtrl.text.trim(),
        category: _categoryCtrl.text.trim(),
        employmentType: _scheduleValues[_scheduleType],
        salaryMin: double.tryParse(_minSalaryCtrl.text.trim()),
        salaryMax: double.tryParse(_maxSalaryCtrl.text.trim()),
        salaryNegotiable: _negotiable,
        requirements: _requirementsCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PromoteListingScreen(listingTable: 'job_postings', listingId: id, listingTitle: _titleCtrl.text.trim())),
      );
    } catch (_) {
      setState(() => _error = 'تعذر نشر الإعلان، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إضافة إعلان وظيفة جديدة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(100)),
              child: const Text('الخطوة 1 من 2', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 10),
          const Text('طرح فرصة عمل وتحديد شروط التقديم', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.4)),
          const SizedBox(height: 6),
          const Text('سجل متطلبات الوظيفة واجذب أفضل الكفاءات الموثوقة من أبناء الحي والمنطقة.', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(value: 0.5, minHeight: 6, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.badge_outlined, color: AppColors.teal, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('توظيف آمن ومحلي', style: TextStyle(color: AppColors.tealLight, fontSize: 10, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('وظّف من جيرانك مباشرة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('أولوية الترشيح لجيرانك في نفس الحي مع التحقق من الهوية والسكن لضمان راحة البال.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('المسمى الوظيفي *'),
          const SizedBox(height: 6),
          _EditableBox(controller: _titleCtrl),
          const SizedBox(height: 6),
          const Row(children: [
            Icon(Icons.lightbulb_outline_rounded, size: 13, color: AppColors.inkMuted),
            SizedBox(width: 5),
            Expanded(child: Text('العناوين الواضحة تحصل على معدل تقديم أسرع بـ 3 أضعاف', style: TextStyle(fontSize: 10, color: AppColors.inkMuted))),
          ]),
          const SizedBox(height: 16),
          const _FieldLabel('التصنيف والنشاط التجاري *'),
          const SizedBox(height: 6),
          _EditableBox(controller: _categoryCtrl),
          const SizedBox(height: 16),
          const _FieldLabel('طبيعة العمل ونوع الدوام *'),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _schedules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.4),
            itemBuilder: (context, i) {
              final selected = _scheduleType == i;
              return InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => setState(() => _scheduleType = i),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.teal : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? AppColors.teal : AppColors.border),
                  ),
                  child: Text(_schedules[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSecondary)),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('نطاق الراتب الشهري المتوقع', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('بالجنيه المصري', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الحد الأدنى', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                    const SizedBox(height: 4),
                    _EditableBox(controller: _minSalaryCtrl, keyboardType: TextInputType.number),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الحد الأقصى', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                    const SizedBox(height: 4),
                    _EditableBox(controller: _maxSalaryCtrl, keyboardType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ToggleRow(
            title: 'الراتب قابل للتفاوض حسب الخبرة',
            subtitle: 'يوضح للمتقدمين مرونة الراتب أثناء المقابلة',
            value: _negotiable,
            onChanged: (v) => setState(() => _negotiable = v),
          ),
          const SizedBox(height: 18),
          const _FieldLabel('متطلبات وشروط الوظيفة *'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: TextField(
              controller: _requirementsCtrl,
              maxLines: 6,
              minLines: 3,
              style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.9),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            ),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('خيارات الخصوصية واستلام الطلبات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('تحكم كامل', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const Text('تحكّم كامل في ظهور بياناتك وطرق تواصل المتقدمين', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          _ToggleRow(
            title: 'استلام السيرة الذاتية (CV) ورقم هاتف المتقدم مباشرة',
            subtitle: 'الملفات بصيغة PDF وصلت مباشرة إلى صندوق طلبات التوظيف بحسابك',
            value: _receiveCvDirect,
            onChanged: (v) => setState(() => _receiveCvDirect = v),
          ),
          const SizedBox(height: 10),
          _ToggleRow(
            title: 'إخفاء رقم هاتف صاحب العمل',
            subtitle: 'استقبال استفسارات المرشحين عبر محادثات تطبيق مُجتمعي المشفرة فقط للحفاظ على خصوصيتك',
            value: _hideEmployerPhone,
            onChanged: (v) => setState(() => _hideEmployerPhone = v),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.near_me_outlined, size: 18, color: AppColors.inkSecondary),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('نطاق النشر الجغرافي الذكي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                    Text('يظهر الإعلان أولاً لجيرانك الأقرب جغرافياً', style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.5)),
                  ],
                ),
              ),
            ]),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                  : const Icon(Icons.campaign_rounded, size: 18),
              label: const Text('نشر إعلان الوظيفة الآن', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('الإعلان يراجع فورياً ويوثق بسجل وظائف الحي التجاري', textAlign: TextAlign.center, style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
        ],
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

class _EditableBox extends StatelessWidget {
  const _EditableBox({required this.controller, this.keyboardType});
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 9)),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.title, required this.subtitle, required this.value, required this.onChanged});
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.5)),
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
