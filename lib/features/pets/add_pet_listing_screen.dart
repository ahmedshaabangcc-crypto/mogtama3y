import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/pets/pet_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// Post (or, with [initial], edit) a pet listing. The form adapts to the
/// kind: adoption / lost / found have no price, lost / found ask when and
/// where the pet was last seen, supplies ask new or used. Pops `true` once
/// saved.
class AddPetListingScreen extends StatefulWidget {
  const AddPetListingScreen({super.key, this.initial, this.initialKind});

  /// The listing being edited (null for a new one).
  final Map<String, dynamic>? initial;

  /// Pre-selected kind for a new listing (the tab the user was on).
  final String? initialKind;

  @override
  State<AddPetListingScreen> createState() => _AddPetListingScreenState();
}

class _AddPetListingScreenState extends State<AddPetListingScreen> {
  final _form = GlobalKey<FormState>();
  late final Map<String, dynamic>? _i = widget.initial;
  late final _title = TextEditingController(text: _i?['title'] as String? ?? '');
  late final _breed = TextEditingController(text: _i?['breed'] as String? ?? '');
  late final _age = TextEditingController(text: _i?['age_text'] as String? ?? '');
  late final _price = TextEditingController(text: (_i?['price'] as num?)?.toStringAsFixed(0) ?? '');
  late final _area = TextEditingController(text: _i?['area'] as String? ?? '');
  late final _lastSeenArea = TextEditingController(text: _i?['last_seen_area'] as String? ?? '');
  late final _description = TextEditingController(text: _i?['description'] as String? ?? '');
  final _phone = TextEditingController();

  late String _kind = _i?['kind'] as String? ?? widget.initialKind ?? 'sale';
  late String _animal = _i?['animal'] as String? ?? 'cat';
  late String _gender = _i?['gender'] as String? ?? 'unknown';
  late bool _vaccinated = _i?['vaccinated'] == true;
  late String _condition = _i?['condition'] as String? ?? 'used';
  late bool _negotiable = _i?['negotiable'] == true;
  late bool _hasWhatsapp = _i?['has_whatsapp'] as bool? ?? true;
  late String? _governorate = _i?['governorate'] as String?;
  late DateTime? _lastSeen = DateTime.tryParse(_i?['last_seen_date'] as String? ?? '');
  late List<String> _images = ((_i?['images'] as List?)?.cast<String>() ?? const []).toList();
  bool _saving = false;

  bool get _editing => _i != null;
  bool get _free => petKindIsFree(_kind);
  bool get _lostFound => petKindIsLostFound(_kind);
  bool get _supplies => _kind == 'supplies';

  @override
  void initState() {
    super.initState();
    _prefillPhone();
  }

  // The listing's own phone when editing, else the profile's.
  Future<void> _prefillPhone() async {
    try {
      final p = _editing
          ? await PetService.phone(_i!['id'] as String)
          : (await AuthService.fetchCurrentProfile())?['phone'] as String?;
      if (!mounted || p == null || _phone.text.isNotEmpty) return;
      setState(() => _phone.text = p);
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in [_title, _breed, _age, _price, _area, _lastSeenArea, _description, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickLastSeen() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _lastSeen ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (d != null) setState(() => _lastSeen = d);
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_lostFound && _lastSeen == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_kind == 'lost' ? 'اختار آخر يوم شفته فيه' : 'اختار اليوم اللي لقيته فيه')));
      return;
    }
    setState(() => _saving = true);
    final price = looseNum(_price.text.trim().replaceAll(',', ''));
    final data = <String, dynamic>{
      'kind': _kind,
      'animal': _animal,
      'breed': _supplies ? null : _trimOrNull(_breed),
      'age_text': _supplies ? null : _trimOrNull(_age),
      'gender': _supplies ? 'unknown' : _gender,
      'vaccinated': !_supplies && _vaccinated,
      'condition': _supplies ? _condition : null,
      'title': _title.text.trim(),
      'description': _trimOrNull(_description),
      'price': _free || price == null || price <= 0 ? null : price,
      'negotiable': !_free && _negotiable,
      'governorate': _governorate,
      'area': _trimOrNull(_area),
      'last_seen_date': _lostFound && _lastSeen != null ? DateFormat('yyyy-MM-dd').format(_lastSeen!) : null,
      'last_seen_area': _lostFound ? _trimOrNull(_lastSeenArea) : null,
      'phone': _phone.text.trim(),
      'has_whatsapp': _hasWhatsapp,
      'images': _images,
    };
    try {
      if (_editing) {
        await PetService.update(_i!['id'] as String, data);
      } else {
        await PetService.create(data);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_editing ? 'اتحفظت التعديلات' : 'إعلانك اتنشر')));
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر حفظ الإعلان، راجع البيانات وجرّب تاني')));
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

  String get _titleHint => switch (_kind) {
        'adoption' => 'مثلاً: قطة بلدي هادية محتاجة بيت',
        'mating' => 'مثلاً: جيرمن شيبرد ذكر للتزاوج',
        'lost' => 'مثلاً: قطة شيرازي رمادي ضايعة',
        'found' => 'مثلاً: لقيت كلب صغير بني',
        'supplies' => 'مثلاً: قفص قطط كبير بحالة ممتازة',
        _ => 'مثلاً: قطط شيرازي 3 شهور',
      };

  @override
  Widget build(BuildContext context) {
    final screenTitle = _editing ? 'عدّل الإعلان' : 'أضف إعلان حيوان أليف';
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: Text(screenTitle)),
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
      appBar: AppBar(title: Text(screenTitle)),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 40),
          children: [
            const Text('عايز تعمل إيه؟', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in petKinds.entries)
                ChoiceChip(
                  label: Text(e.value),
                  selected: _kind == e.key,
                  showCheckmark: false,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: _kind == e.key ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                  onSelected: (_) => setState(() => _kind = e.key),
                ),
            ]),
            _section('الصور'),
            MultiPhotoPicker(purpose: 'pets', maxPhotos: 10, initial: _images, onChanged: (urls) => _images = List.of(urls)),
            _section(_supplies ? 'المستلزمات' : 'الحيوان'),
            _dropdown<String>(_supplies ? 'لأنهي حيوان' : 'الحيوان', _animal, petAnimals, (v) => setState(() => _animal = v ?? 'cat'), optional: false),
            if (_supplies) ...[
              const SizedBox(height: 10),
              _dropdown<String>('الحالة', _condition, petConditions, (v) => setState(() => _condition = v ?? 'used'), optional: false),
            ] else ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: TextFormField(controller: _breed, maxLength: 80, decoration: _dec('السلالة', hint: 'شيرازي، جولدن، بلدي…'))),
                const SizedBox(width: 10),
                Expanded(child: TextFormField(controller: _age, maxLength: 40, decoration: _dec('السن', hint: 'مثلاً: 3 شهور'))),
              ]),
              _dropdown<String>('النوع', _gender, petGenders, (v) => setState(() => _gender = v ?? 'unknown'), optional: false),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _vaccinated,
                onChanged: (v) => setState(() => _vaccinated = v),
                title: const Text('متطعّم'),
              ),
            ],
            if (_lostFound) ...[
              _section(_kind == 'lost' ? 'آخر مرة اتشاف' : 'لقيته فين وإمتى'),
              InkWell(
                onTap: _pickLastSeen,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _dec(_kind == 'lost' ? 'آخر يوم شفته فيه' : 'اليوم اللي لقيته فيه').copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
                  child: Text(_lastSeen == null ? 'اختار اليوم' : DateFormat('d/M/yyyy').format(_lastSeen!),
                      style: TextStyle(color: _lastSeen == null ? AppColors.inkMuted : AppColors.ink)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastSeenArea,
                maxLength: 120,
                decoration: _dec('المكان بالظبط', hint: 'مثلاً: جنب جامع النور، شارع مكرم عبيد'),
              ),
            ],
            _section(_free ? 'الإعلان' : 'الإعلان والسعر'),
            TextFormField(
              controller: _title,
              maxLength: 120,
              decoration: _dec('عنوان الإعلان', hint: _titleHint),
              validator: (v) => (v ?? '').trim().length < 3 ? 'اكتب عنوان واضح (3 حروف على الأقل)' : null,
            ),
            if (!_free) ...[
              const SizedBox(height: 4),
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _dec(_kind == 'mating' ? 'السعر (اختياري)' : 'السعر', suffix: 'ج.م'),
                validator: (v) => _kind != 'mating' && (looseNum((v ?? '').trim()) ?? 0) <= 0 ? 'اكتب السعر' : null,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _negotiable,
                onChanged: (v) => setState(() => _negotiable = v ?? false),
                title: const Text('قابل للتفاوض'),
              ),
            ] else if (_kind == 'adoption')
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('التبني ببلاش — ماينفعش تحط سعر.', style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
              ),
            TextFormField(
              controller: _description,
              maxLines: 5,
              maxLength: 3000,
              decoration: _dec('التفاصيل', hint: _lostFound ? 'علامات مميزة، لون الطوق، طباعه…' : 'الصحة، الأكل، الطباع، أي ملاحظات'),
            ),
            _section('المكان والتواصل'),
            _dropdown<String>('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
            const SizedBox(height: 10),
            TextFormField(controller: _area, maxLength: 80, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر')),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
              decoration: _dec('رقم الموبايل', hint: '01xxxxxxxxx'),
              validator: (v) => RegExp(r'^01[0125][0-9]{8}$').hasMatch((v ?? '').trim()) ? null : 'اكتب رقم موبايل مصري صحيح',
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _hasWhatsapp,
              onChanged: (v) => setState(() => _hasWhatsapp = v),
              title: const Text('عليه واتساب'),
              subtitle: const Text('الرقم بيظهر بس للي عامل حساب، مش للزوار', style: TextStyle(fontSize: 11.5)),
            ),
            const SizedBox(height: 16),
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
