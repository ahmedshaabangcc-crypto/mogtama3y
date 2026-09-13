import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/support/support_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'faq_help_center_screen.dart';

const _categories = ['مشكلة تقنية بالتطبيق', 'استفسار مالي', 'شكوى', 'اقتراح', 'أخرى'];
const _categoryValues = ['technical', 'billing', 'complaint', 'suggestion', 'other'];

/// Support & help-desk contact screen — matches
/// design/screens/29_support_contact_ticket.png.
class SupportContactScreen extends StatefulWidget {
  const SupportContactScreen({super.key});

  @override
  State<SupportContactScreen> createState() => _SupportContactScreenState();
}

class _SupportContactScreenState extends State<SupportContactScreen> {
  int _category = 0;
  bool _submitting = false;
  bool _submitted = false;
  String? _error;
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!AuthService.isSignedIn) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      return;
    }
    if (_subjectCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) {
      setState(() => _error = 'يرجى إدخال عنوان الرسالة وتفاصيل البلاغ.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await SupportService.submitTicket(
        category: _categoryValues[_category],
        subject: _subjectCtrl.text.trim(),
        body: _bodyCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (_) {
      setState(() => _error = 'تعذر إرسال البلاغ، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تواصل معنا والدعم الفني السكني')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text('ابعتلنا مشكلتك أو استفسارك وهيوصل لفريق الدعم مباشرة', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('فتح تذكرة دعم جديدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('طلب رسمي مسجل', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          if (_submitted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.teal),
                const SizedBox(width: 10),
                const Expanded(child: Text('تم إرسال بلاغك بنجاح، سيتواصل معك فريق الدعم قريباً.', style: TextStyle(color: AppColors.teal, fontWeight: FontWeight.w600, fontSize: 12.5))),
              ]),
            )
          else ...[
            const _FieldLabel('تصنيف المشكلة أو البلاغ'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _categories.length; i++)
                  ChoiceChip(
                    label: Text(_categories[i], style: const TextStyle(fontSize: 11.5)),
                    selected: _category == i,
                    selectedColor: AppColors.navy,
                    labelStyle: TextStyle(color: _category == i ? Colors.white : AppColors.inkSecondary),
                    onSelected: (_) => setState(() => _category = i),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const _FieldLabel('عنوان الرسالة'),
            const SizedBox(height: 6),
            _EditableBox(controller: _subjectCtrl, hint: 'ملخص المشكلة في عبارة واضحة'),
            const SizedBox(height: 12),
            const _FieldLabel('نص الرسالة أو تفاصيل البلاغ'),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: TextField(
                controller: _bodyCtrl,
                maxLines: 4,
                minLines: 3,
                style: const TextStyle(fontSize: 12),
                decoration: const InputDecoration(hintText: 'اكتب تفاصيل الاستفسار أو البلاغ بدقة...', hintStyle: TextStyle(fontSize: 12, color: AppColors.inkMuted), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
              child: Row(children: const [
                Icon(Icons.attach_file_rounded, size: 16, color: AppColors.inkMuted),
                SizedBox(width: 8),
                Expanded(child: Text('إرفاق الصور والمستندات قريباً', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted))),
              ]),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: _submitting
                    ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                    : const Icon(Icons.send_rounded, size: 17),
                label: const Text('إرسال الاستفسار / البلاغ المباشر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(child: Text('أسئلة شائعة قد تفيدك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqHelpCenterScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: const Text('مركز المساعدة', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          _FaqTile(
            question: 'كيف يتم توثيق صفة مالك الشقة؟',
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqHelpCenterScreen())),
          ),
          const SizedBox(height: 8),
          const _FaqTile(question: 'ما هي آلية تسوية اشتراكات الصيانة المعلقة؟'),
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
    return Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.inkSecondary));
  }
}

class _EditableBox extends StatelessWidget {
  const _EditableBox({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 12.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, this.onTap});
  final String question;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Expanded(child: Text(question, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
        ]),
      ),
    );
  }
}
