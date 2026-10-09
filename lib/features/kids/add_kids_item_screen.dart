import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/auth/auth_service.dart';
import '../../core/kids/kids_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// Post a kids-gear listing, or edit one when [initial] is given (from
/// "إعلاناتي"). Pops `true` once saved.
class AddKidsItemScreen extends StatefulWidget {
  const AddKidsItemScreen({super.key, this.initial});

  /// The listing being edited; null to post a new one.
  final Map<String, dynamic>? initial;

  @override
  State<AddKidsItemScreen> createState() => _AddKidsItemScreenState();
}

class _AddKidsItemScreenState extends State<AddKidsItemScreen> {
  static const _maxPhotos = 10;

  final _form = GlobalKey<FormState>();
  late final Map<String, dynamic> _i = widget.initial ?? const {};
  late final _title = TextEditingController(text: _i['title'] as String? ?? '');
  late final _brand = TextEditingController(text: _i['brand'] as String? ?? '');
  late final _size = TextEditingController(text: _i['clothes_size'] as String? ?? '');
  late final _price = TextEditingController(text: (_i['price'] as num?)?.toStringAsFixed(0) ?? '');
  late final _area = TextEditingController(text: _i['area'] as String? ?? '');
  late final _description = TextEditingController(text: _i['description'] as String? ?? '');
  late final _phone = TextEditingController(text: _i['phone'] as String? ?? '');

  late String _category = _i['category'] as String? ?? 'stroller';
  late String _condition = _i['condition'] as String? ?? 'good';
  late String? _age = _i['age_range'] as String?;
  late String _gender = _i['gender'] as String? ?? 'any';
  late bool _free = _i['is_free'] == true;
  late bool _swap = _i['swap_allowed'] == true;
  late bool _whatsapp = _i['phone_on_whatsapp'] != false;
  late String? _governorate = _i['governorate'] as String?;

  /// Photos already on the listing (edit mode) that the owner keeps.
  late final List<String> _kept = List.of((_i['images'] as List?)?.cast<String>() ?? const <String>[]);
  List<String> _added = [];
  bool _saving = false;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    if (!_editing) _prefillPhone();
  }

  Future<void> _prefillPhone() async {
    try {
      final p = await AuthService.fetchCurrentProfile();
      final phone = p?['phone'] as String?;
      if (!mounted || phone == null || _phone.text.isNotEmpty) return;
      _phone.text = phone;
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in [_title, _brand, _size, _price, _area, _description, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final data = {
      'category': _category,
      'title': _title.text.trim(),
      'condition': _condition,
      'age_range': _age,
      'gender': _gender,
      'clothes_size': _category == 'clothes' ? _trimOrNull(_size) : null,
      'brand': _trimOrNull(_brand),
      'is_free': _free,
      'price': _free ? null : num.parse(_price.text.trim()),
      'swap_allowed': _swap,
      'governorate': _governorate,
      'area': _trimOrNull(_area),
      'description': _trimOrNull(_description),
      'images': [..._kept, ..._added],
      'phone': _phone.text.trim(),
      'phone_on_whatsapp': _whatsapp,
    };
    try {
      if (_editing) {
        await KidsService.update(_i['id'] as String, data);
      } else {
        await KidsService.create(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_editing ? 'اتحفظت التعديلات' : 'إعلانك اتنشر')));
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر الحفظ، راجع البيانات وجرّب تاني')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _dec(String label, {String? hint, String? suffix}) => InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        isDense: true,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  Widget _dropdown<T>(String label, T? value, Map<T, String> options, ValueChanged<T?> onChanged, {bool optional = true}) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: _dec(label),
      items: [
        if (optional) DropdownMenuItem<T>(value: null, child: const Text('—')),
        for (final e in options.entries) DropdownMenuItem<T>(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)),
      ],
      onChanged: onChanged,
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
      );

  Widget _keptPhotos() => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _kept.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) => Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(_kept[i], width: 84, height: 84, cacheWidth: 240, fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox(width: 84, height: 84, child: ColoredBox(color: AppColors.surfaceAlt))),
              ),
              PositionedDirectional(
                top: 2,
                end: 2,
                child: InkWell(
                  onTap: () => setState(() => _kept.removeAt(i)),
                  child: const CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: Icon(Icons.close_rounded, size: 15, color: Colors.white)),
                ),
              ),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = _editing ? 'تعديل الإعلان' : 'أضف مستلزمات أطفال';
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: Text(title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.lock_outline_rounded, size: 40, color: AppColors.inkMuted),
              const SizedBox(height: 10),
              const Text('سجّل دخول الأول عشان تنشر إعلان', style: TextStyle(color: AppColors.inkSecondary)),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
                  if (mounted) setState(() {});
                },
                child: const Text('تسجيل الدخول'),
              ),
            ]),
          ),
        ),
      );
    }
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 12.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 40),
          children: [
            const Text('القسم', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in kidsCategories.entries)
                ChoiceChip(
                  avatar: Icon(kidsCategoryIcons[e.key], size: 16, color: _category == e.key ? Colors.white : AppColors.teal),
                  label: Text(e.value),
                  selected: _category == e.key,
                  showCheckmark: false,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: _category == e.key ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                  onSelected: (_) => setState(() => _category = e.key),
                ),
            ]),
            if (kidsSafetyCategories.contains(_category)) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFFFF4E5), borderRadius: BorderRadius.circular(10)),
                child: const Text('اكتب بأمانة لو الكرسي أو السرير عدّى عليه حادثة أو فيه أي كسر — سلامة الأطفال أهم حاجة.',
                    style: TextStyle(fontSize: 12, height: 1.6, color: Color(0xFF6D3A00))),
              ),
            ],
            _section('الصور'),
            if (_kept.isNotEmpty) _keptPhotos(),
            if (_kept.length < _maxPhotos)
              MultiPhotoPicker(
                purpose: 'kids',
                maxPhotos: _maxPhotos - _kept.length,
                onChanged: (urls) => _added = List.of(urls),
              ),
            _section('الحاجة'),
            TextFormField(
              controller: _title,
              maxLength: 120,
              decoration: _dec('عنوان الإعلان', hint: 'مثلاً: عربية أطفال شيكو بحالة ممتازة'),
              validator: (v) => (v ?? '').trim().length < 3 ? 'اكتب عنوان واضح (3 حروف على الأقل)' : null,
            ),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(child: _dropdown<String>('الحالة', _condition, kidsConditions, (v) => setState(() => _condition = v ?? 'good'), optional: false)),
              const SizedBox(width: 10),
              Expanded(child: _dropdown<String>('السن', _age, kidsAgeRanges, (v) => setState(() => _age = v))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _dropdown<String>('لـ', _gender, kidsGenders, (v) => setState(() => _gender = v ?? 'any'), optional: false)),
              const SizedBox(width: 10),
              Expanded(child: TextFormField(controller: _brand, maxLength: 60, decoration: _dec('الماركة (اختياري)', hint: 'Chicco، Graco…'))),
            ]),
            if (_category == 'clothes') ...[
              const SizedBox(height: 4),
              TextFormField(
                controller: _size,
                maxLength: 30,
                decoration: _dec('المقاس', hint: 'مثلاً: 4 سنين، XL، نمرة 28'),
                validator: (v) => (v ?? '').trim().isEmpty ? 'اكتب المقاس' : null,
              ),
            ],
            _section('السعر'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _free,
              onChanged: (v) => setState(() => _free = v),
              title: const Text('ببلاش لأي حد محتاج'),
              subtitle: const Text('هتديها هدية من غير فلوس'),
            ),
            if (!_free)
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _dec('السعر', suffix: 'ج.م'),
                validator: (v) => (looseNum((v ?? '').trim()) ?? 0) <= 0 ? 'اكتب السعر' : null,
              ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _swap,
              onChanged: (v) => setState(() => _swap = v ?? false),
              title: const Text('ممكن أبدّل'),
              subtitle: const Text('مستعد تبدّلها بحاجة تانية تناسب ولادك'),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _description,
              maxLines: 5,
              maxLength: 3000,
              decoration: _dec('التفاصيل', hint: 'استخدمتها قد إيه، فيها أي عيب، ناقصها حاجة؟'),
            ),
            _section('المكان والتواصل'),
            _dropdown<String>('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
            const SizedBox(height: 10),
            TextFormField(controller: _area, maxLength: 80, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر')),
            const SizedBox(height: 4),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
              decoration: _dec('رقم الموبايل', hint: '01xxxxxxxxx'),
              validator: (v) => RegExp(r'^01[0125][0-9]{8}$').hasMatch((v ?? '').trim()) ? null : 'اكتب رقم موبايل مصري صحيح',
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _whatsapp,
              onChanged: (v) => setState(() => _whatsapp = v ?? true),
              title: const Text('الرقم ده عليه واتساب'),
            ),
            const SizedBox(height: 4),
            const Text('رقمك بيظهر للناس المسجلين بس.', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            const SizedBox(height: 22),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded),
                label: Text(_editing ? 'احفظ التعديلات' : 'انشر الإعلان'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
