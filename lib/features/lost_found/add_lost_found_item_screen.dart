import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/guard/guard_service.dart';
import '../../core/lost_found/lost_found_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';

const _categories = ['مفاتيح', 'محافظ وبطاقات', 'إلكترونية', 'حيوانات أليفة', 'أخرى'];

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
  int _category = 0;
  bool _blurTags = true;
  bool _submitting = false;
  String? _error;
  String? _imageUrl;
  bool _uploadingPhoto = false;
  String? _guardName;

  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _secretMarkCtrl = TextEditingController();
  final _rewardCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGuard();
  }

  Future<void> _loadGuard() async {
    final membership = await UnionService.fetchMyMembership();
    final buildingId = membership?['building_id'] as String?;
    if (buildingId == null) return;
    final guards = await GuardService.fetchGuardsFor(buildingId);
    if (!mounted) return;
    if (guards.isEmpty) {
      setState(() => _custody = 1);
      return;
    }
    final profile = guards.first['profile'] as Map<String, dynamic>?;
    setState(() => _guardName = profile?['full_name'] as String?);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _secretMarkCtrl.dispose();
    _rewardCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await UploadService.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => _uploadingPhoto = true);
    try {
      final url = await UploadService.uploadPublicPhoto(purpose: 'lost-found', file: file);
      if (!mounted) return;
      setState(() => _imageUrl = url);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع الصورة، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty || _locationCtrl.text.trim().isEmpty) {
      setState(() => _error = 'يرجى إدخال عنوان البلاغ ومكان العثور عليه.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      var locationNote = _locationCtrl.text.trim();
      if (_mode == 1) {
        final custodyNote = _custody == 0 && _guardName != null
            ? 'الأمانة مودعة لدى حارس العمارة الموثق ($_guardName)'
            : 'الأمانة مع المُبلّغ شخصياً، التواصل عبر محادثة التطبيق';
        locationNote = '$locationNote — $custodyNote';
      }
      await LostFoundService.reportItem(
        type: _mode == 0 ? 'lost' : 'found',
        category: _categories[_category],
        title: _titleCtrl.text.trim(),
        locationNote: locationNote,
        secretMark: _secretMarkCtrl.text.trim().isEmpty ? null : _secretMarkCtrl.text.trim(),
        rewardAmount: _mode == 0 && _rewardCtrl.text.trim().isNotEmpty ? double.tryParse(_rewardCtrl.text.trim()) : null,
        imageUrl: _imageUrl,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

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
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _uploadingPhoto ? null : _pickPhoto,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: _imageUrl != null ? AppColors.teal : AppColors.border, width: _imageUrl != null ? 1.5 : 1)),
              child: _imageUrl != null
                  ? Column(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_imageUrl!, height: 120, width: 120, fit: BoxFit.cover)),
                        const SizedBox(height: 8),
                        const Text('تم إرفاق الصورة، اضغط لتغييرها', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5, color: AppColors.teal)),
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                          child: _uploadingPhoto
                              ? const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.add_a_photo_outlined, color: AppColors.inkSecondary, size: 24),
                        ),
                        const SizedBox(height: 10),
                        const Text('اضغط لإرفاق صورة (اختياري)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                        const SizedBox(height: 4),
                        const Text('JPG, PNG فقط، حد أقصى 10 ميجا', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ],
                    ),
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
          _EditableField(controller: _titleCtrl, hint: 'مثال: ميدالية مفاتيح، محفظة، هاتف، سماعات'),
          const SizedBox(height: 14),
          const _FieldLabel('التصنيف العام *'),
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
          const SizedBox(height: 14),
          const _FieldLabel('مكان العثور عليه بدقة *'),
          const SizedBox(height: 6),
          _EditableField(controller: _locationCtrl, hint: 'اسم الشارع، العمارة، مدخل المبنى، المصعد'),
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
          if (_mode == 1) ...[
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
            if (_guardName != null) ...[
              _CustodyOption(
                title: 'تم إيداع الأمانة طرف حارس العمارة الموثق ($_guardName)',
                selected: _custody == 0,
                onTap: () => setState(() => _custody = 0),
                expanded: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: const Text('الحارس معتمد من مجلس إدارة اتحاد عمارتك، ويتحمل مسؤولية الاستلام والتسليم الميداني.',
                      style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                ),
              ),
              const SizedBox(height: 8),
            ],
            _CustodyOption(
              title: 'الأمانة معي شخصياً والتواصل عبر محادثة التطبيق فقط',
              selected: _custody == 1 || _guardName == null,
              onTap: () => setState(() => _custody = 1),
            ),
          ],
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: TextField(
              controller: _secretMarkCtrl,
              maxLines: 2,
              minLines: 1,
              style: const TextStyle(fontSize: 12.5),
              decoration: const InputDecoration(
                hintText: 'أدخل علامة سرية يعرفها المالك الحقيقي فقط لمطابقتها عند التسليم...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (_mode == 0) ...[
            const SizedBox(height: 14),
            const _FieldLabel('مكافأة مالية (اختياري)'),
            const SizedBox(height: 6),
            _EditableField(controller: _rewardCtrl, hint: 'مثال: 200', keyboardType: TextInputType.number),
          ],
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
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                  : const Icon(Icons.campaign_rounded, size: 18),
              label: const Text('نشر البلاغ وتنبيه جيران الحي الآن', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('سيظهر البلاغ لجيران عمارتك الموثقين فقط.',
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

class _EditableField extends StatelessWidget {
  const _EditableField({required this.controller, required this.hint, this.keyboardType});
  final TextEditingController controller;
  final String hint;
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
