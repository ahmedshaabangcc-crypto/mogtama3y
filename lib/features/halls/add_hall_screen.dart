import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/auth/auth_service.dart';
import '../../core/halls/hall_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// List an event hall, or edit one when [existing] is given. Pops `true`
/// once saved.
class AddHallScreen extends StatefulWidget {
  const AddHallScreen({super.key, this.existing});

  /// The owner's hall row to edit; null to add a new one.
  final Map<String, dynamic>? existing;

  @override
  State<AddHallScreen> createState() => _AddHallScreenState();
}

class _AddHallScreenState extends State<AddHallScreen> {
  final _form = GlobalKey<FormState>();
  late final Map<String, dynamic> _e = widget.existing ?? const {};
  late final _name = TextEditingController(text: _e['name'] as String? ?? '');
  late final _capMin = TextEditingController(text: _e['capacity_min']?.toString() ?? '');
  late final _capMax = TextEditingController(text: _e['capacity_max']?.toString() ?? '');
  late final _price = TextEditingController(text: (_e['price_from'] as num?)?.toStringAsFixed(0) ?? '');
  late final _area = TextEditingController(text: _e['area'] as String? ?? '');
  late final _address = TextEditingController(text: _e['address'] as String? ?? '');
  late final _phone = TextEditingController(text: _e['phone'] as String? ?? '');
  late final _whatsapp = TextEditingController(text: _e['whatsapp'] as String? ?? '');
  late final _description = TextEditingController(text: _e['description'] as String? ?? '');

  late String _hallType = _e['hall_type'] as String? ?? 'wedding';
  late final Set<String> _occasions = {...((_e['occasions'] as List?)?.cast<String>() ?? const [])};
  late final Set<String> _included = {...((_e['included'] as List?)?.cast<String>() ?? const [])};
  late bool _perPerson = _e['price_per_person'] == true;
  late String? _governorate = _e['governorate'] as String?;
  late List<String> _images = List.of((_e['images'] as List?)?.cast<String>() ?? const []);
  bool _saving = false;

  bool get _editing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (!_editing) _prefillPhone();
  }

  Future<void> _prefillPhone() async {
    try {
      final phone = (await AuthService.fetchCurrentProfile())?['phone'] as String?;
      if (!mounted || phone == null || _phone.text.isNotEmpty) return;
      _phone.text = phone;
      if (RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone) && _whatsapp.text.isEmpty) _whatsapp.text = phone;
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in [_name, _capMin, _capMax, _price, _area, _address, _phone, _whatsapp, _description]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_occasions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختار المناسبات اللي القاعة تنفع لها')));
      return;
    }
    setState(() => _saving = true);
    final data = {
      'name': _name.text.trim(),
      'hall_type': _hallType,
      'occasions': _occasions.toList(),
      'capacity_min': looseInt(_capMin.text.trim()),
      'capacity_max': int.parse(_capMax.text.trim()),
      'price_from': looseNum(_price.text.trim()),
      'price_per_person': _perPerson,
      'included': _included.toList(),
      'description': _trimOrNull(_description),
      'governorate': _governorate,
      'area': _trimOrNull(_area),
      'address': _trimOrNull(_address),
      'phone': _phone.text.trim(),
      'whatsapp': _trimOrNull(_whatsapp),
      'images': _images,
    };
    try {
      if (_editing) {
        await HallService.update(_e['id'] as String, data);
      } else {
        await HallService.create(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_editing ? 'اتحفظت التعديلات' : 'قاعتك اتنشرت')));
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

  Widget _section(String title, {String? hint}) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
          if (hint != null) Text(hint, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
        ]),
      );

  Widget _multiChips(Map<String, String> options, Set<String> selected) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final e in options.entries)
          FilterChip(
            label: Text(e.value),
            selected: selected.contains(e.key),
            selectedColor: AppColors.tealLight,
            checkmarkColor: AppColors.teal,
            onSelected: (on) => setState(() => on ? selected.add(e.key) : selected.remove(e.key)),
          ),
      ]);

  @override
  Widget build(BuildContext context) {
    final title = _editing ? 'تعديل القاعة' : 'أضف قاعتك';
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
              const Text('سجّل دخول الأول عشان تعلن عن قاعتك', style: TextStyle(color: AppColors.inkSecondary)),
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
    final digits = [FilteringTextInputFormatter.digitsOnly];
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 40),
          children: [
            const Text('نوع المكان', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in hallTypes.entries)
                ChoiceChip(
                  label: Text(e.value),
                  selected: _hallType == e.key,
                  showCheckmark: false,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: _hallType == e.key ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                  onSelected: (_) => setState(() => _hallType = e.key),
                ),
            ]),
            _section('الصور', hint: 'صور القاعة من جوه وبرّه، والكوشة والترابيزات'),
            MultiPhotoPicker(purpose: 'halls', maxPhotos: 20, initial: _images, onChanged: (urls) => _images = List.of(urls)),
            _section('القاعة'),
            TextFormField(
              controller: _name,
              maxLength: 120,
              decoration: _dec('اسم القاعة', hint: 'مثلاً: قاعة الياسمين للأفراح'),
              validator: (v) => (v ?? '').trim().length < 3 ? 'اكتب اسم واضح (3 حروف على الأقل)' : null,
            ),
            _section('تنفع لأنهي مناسبات؟'),
            _multiChips(hallOccasions, _occasions),
            _section('السعة'),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: TextFormField(
                  controller: _capMin,
                  keyboardType: TextInputType.number,
                  inputFormatters: digits,
                  decoration: _dec('أقل عدد (اختياري)', suffix: 'فرد'),
                  validator: (v) {
                    final min = looseInt((v ?? '').trim());
                    final max = looseInt(_capMax.text.trim());
                    if (min != null && min < 1) return 'رقم غلط';
                    if (min != null && max != null && min > max) return 'أكبر من أقصى عدد';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _capMax,
                  keyboardType: TextInputType.number,
                  inputFormatters: digits,
                  decoration: _dec('أقصى عدد', suffix: 'فرد'),
                  validator: (v) {
                    final max = looseInt((v ?? '').trim());
                    if (max == null || max < 1) return 'اكتب أقصى عدد';
                    if (max > 20000) return 'الرقم كبير قوي';
                    return null;
                  },
                ),
              ),
            ]),
            _section('السعر'),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.number,
              inputFormatters: digits,
              decoration: _dec('السعر يبدأ من (اختياري)', suffix: _perPerson ? 'ج.م للفرد' : 'ج.م', hint: 'سيبه فاضي لو بالاتفاق'),
              validator: (v) => (v ?? '').trim().isNotEmpty && (looseNum(v!.trim()) ?? 0) <= 0 ? 'سعر غلط' : null,
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('للحفلة كلها')),
                ButtonSegment(value: true, label: Text('للفرد')),
              ],
              selected: {_perPerson},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _perPerson = s.first),
            ),
            _section('متضمن إيه؟'),
            _multiChips(hallIncluded, _included),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              maxLines: 5,
              maxLength: 3000,
              decoration: _dec('التفاصيل', hint: 'الباكدجات، المواعيد المتاحة، الممنوعات، أي ملاحظات'),
            ),
            _section('المكان'),
            DropdownButtonFormField<String>(
              initialValue: _governorate,
              isExpanded: true,
              decoration: _dec('المحافظة'),
              items: [for (final g in reportGovernorates) DropdownMenuItem(value: g, child: Text(g))],
              onChanged: (v) => setState(() => _governorate = v),
              validator: (v) => v == null ? 'اختار المحافظة' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(controller: _area, maxLength: 80, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر')),
            const SizedBox(height: 4),
            TextFormField(controller: _address, maxLength: 300, decoration: _dec('العنوان بالتفصيل', hint: 'الشارع وأقرب علامة مميزة')),
            _section('التواصل'),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: digits,
              decoration: _dec('رقم التليفون', hint: '01xxxxxxxxx'),
              validator: (v) => RegExp(r'^0[0-9]{7,10}$').hasMatch((v ?? '').trim()) ? null : 'اكتب رقم صحيح يبدأ بـ 0',
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _whatsapp,
              keyboardType: TextInputType.phone,
              inputFormatters: digits,
              decoration: _dec('رقم الواتساب (اختياري)', hint: '01xxxxxxxxx'),
              validator: (v) {
                final t = (v ?? '').trim();
                return t.isEmpty || RegExp(r'^01[0125][0-9]{8}$').hasMatch(t) ? null : 'رقم موبايل مصري من 11 رقم';
              },
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded),
                label: Text(_editing ? 'احفظ التعديلات' : 'انشر القاعة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
