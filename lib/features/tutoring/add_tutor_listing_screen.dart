import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/auth/auth_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/tutoring/tutoring_service.dart';
import '../auth/auth_landing_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// Post a tutoring listing, or edit one when [existing] is given. The name
/// shown is the poster's profile name. Pops `true` once saved.
class AddTutorListingScreen extends StatefulWidget {
  const AddTutorListingScreen({super.key, this.existing});

  /// The listing row being edited (null for a new one).
  final Map<String, dynamic>? existing;

  @override
  State<AddTutorListingScreen> createState() => _AddTutorListingScreenState();
}

class _AddTutorListingScreenState extends State<AddTutorListingScreen> {
  final _form = GlobalKey<FormState>();
  late final Map<String, dynamic>? _e = widget.existing;
  late final _price = TextEditingController(text: (_e?['price'] as num?)?.toStringAsFixed(0) ?? '');
  late final _years = TextEditingController(text: _e?['experience_years']?.toString() ?? '');
  late final _area = TextEditingController(text: _e?['area'] as String? ?? '');
  late final _bio = TextEditingController(text: _e?['bio'] as String? ?? '');
  late final _phone = TextEditingController(text: _e?['phone'] as String? ?? '');
  late final _whatsapp = TextEditingController(text: _e?['whatsapp'] as String? ?? '');

  late final Set<String> _subjects = _codes('subjects');
  late final Set<String> _stages = _codes('stages');
  late final Set<String> _curricula = _codes('curricula');
  late final Set<String> _modes = _codes('modes');
  late String _priceUnit = _e?['price_unit'] as String? ?? 'session';
  late String? _governorate = _e?['governorate'] as String?;
  late List<String> _images = ((_e?['images'] as List?)?.cast<String>() ?? const []).toList();
  bool _saving = false;

  bool get _editing => _e != null;

  Set<String> _codes(String key) => ((_e?[key] as List?)?.cast<String>() ?? const <String>[]).toSet();

  @override
  void initState() {
    super.initState();
    if (!_editing) _prefillPhone();
  }

  Future<void> _prefillPhone() async {
    try {
      final phone = await TutoringService.myPhone();
      if (!mounted || phone == null || normaliseTutorPhone(phone) == null) return;
      if (_whatsapp.text.isEmpty) _whatsapp.text = normaliseTutorPhone(phone)!;
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in [_price, _years, _area, _bio, _phone, _whatsapp]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  String? _phoneError(String? v) {
    final t = (v ?? '').trim();
    if (t.isEmpty) return null;
    return normaliseTutorPhone(t) == null ? 'رقم الموبايل لازم يكون 11 رقم ويبدأ بـ 010 أو 011 أو 012 أو 015' : null;
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_subjects.isEmpty) return _toast('اختار مادة واحدة على الأقل');
    if (_stages.isEmpty) return _toast('اختار المرحلة');
    if (_modes.isEmpty) return _toast('اختار فين بتدّي الدرس');
    final phone = normaliseTutorPhone(_phone.text);
    final whatsapp = normaliseTutorPhone(_whatsapp.text);
    if (phone == null && whatsapp == null) return _toast('اكتب رقم واتساب أو موبايل عشان الطلبة يكلموك');
    setState(() => _saving = true);
    final data = <String, dynamic>{
      'subjects': [for (final k in tutorSubjects.keys) if (_subjects.contains(k)) k],
      'stages': [for (final k in tutorStages.keys) if (_stages.contains(k)) k],
      'curricula': [for (final k in tutorCurricula.keys) if (_curricula.contains(k)) k],
      'modes': [for (final k in tutorModes.keys) if (_modes.contains(k)) k],
      'price': num.parse(_price.text.trim().replaceAll(',', '')),
      'price_unit': _priceUnit,
      'experience_years': looseInt(_years.text.trim()),
      'bio': _trimOrNull(_bio),
      'governorate': _governorate,
      'area': _trimOrNull(_area),
      'phone': phone,
      'whatsapp': whatsapp,
      'images': _images,
    };
    try {
      if (_editing) {
        await TutoringService.update(_e!['id'] as String, data);
      } else {
        await TutoringService.create(data);
      }
      if (!mounted) return;
      _toast(_editing ? 'اتحفظت التعديلات' : 'إعلانك اتنشر — الطلبة يقدروا يكلموك دلوقتي');
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) _toast('تعذر الحفظ، راجع البيانات وجرّب تاني');
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

  Widget _multi(Map<String, String> options, Set<String> selected) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final e in options.entries)
          FilterChip(
            label: Text(e.value),
            selected: selected.contains(e.key),
            showCheckmark: false,
            selectedColor: AppColors.teal,
            labelStyle: TextStyle(color: selected.contains(e.key) ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
            onSelected: (on) => setState(() => on ? selected.add(e.key) : selected.remove(e.key)),
          ),
      ]);

  @override
  Widget build(BuildContext context) {
    final title = _editing ? 'تعديل إعلان الدروس' : 'أعلن عن دروسك';
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(12)),
              child: const Text('اسمك وصورتك في الإعلان بيتاخدوا من بروفايلك.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
            ),
            _section('بتدّي إيه؟', hint: 'اختار مادة أو أكتر'),
            _multi(tutorSubjects, _subjects),
            _section('لأنهي مرحلة؟'),
            _multi(tutorStages, _stages),
            _section('المنهج (اختياري)'),
            _multi(tutorCurricula, _curricula),
            _section('الدرس بيكون فين؟'),
            _multi(tutorModes, _modes),
            _section('السعر والخبرة'),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _dec('السعر', suffix: 'ج.م'),
                  validator: (v) {
                    final n = looseNum((v ?? '').trim()) ?? 0;
                    if (n <= 0) return 'اكتب السعر';
                    if (n > 100000) return 'السعر كبير أوي';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _priceUnit,
                  isExpanded: true,
                  decoration: _dec('السعر لـ'),
                  items: [for (final e in tutorPriceUnits.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                  onChanged: (v) => setState(() => _priceUnit = v ?? 'session'),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            TextFormField(
              controller: _years,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
              decoration: _dec('سنين الخبرة (اختياري)', suffix: 'سنة'),
              validator: (v) => (looseInt((v ?? '').trim()) ?? 0) > 60 ? 'اكتب رقم مظبوط' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _bio,
              maxLines: 5,
              maxLength: 1500,
              decoration: _dec('نبذة عنك', hint: 'مؤهلك، المدارس اللي اشتغلت فيها، طريقتك في الشرح، نتايج طلبتك'),
            ),
            _section('صور (اختياري)', hint: 'صورة ليك أو للسنتر أو لشهاداتك'),
            MultiPhotoPicker(purpose: 'tutoring', maxPhotos: 6, initial: _images, onChanged: (urls) => _images = List.of(urls)),
            _section('المكان'),
            DropdownButtonFormField<String>(
              initialValue: reportGovernorates.contains(_governorate) ? _governorate : null,
              isExpanded: true,
              decoration: _dec('المحافظة'),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('—')),
                for (final g in reportGovernorates) DropdownMenuItem(value: g, child: Text(g)),
              ],
              onChanged: (v) => setState(() => _governorate = v),
            ),
            const SizedBox(height: 10),
            TextFormField(controller: _area, maxLength: 80, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر، سموحة')),
            _section('إزاي الطلبة يكلموك؟', hint: 'رقم واحد على الأقل'),
            TextFormField(
              controller: _whatsapp,
              keyboardType: TextInputType.phone,
              decoration: _dec('رقم الواتساب', hint: '01xxxxxxxxx'),
              validator: _phoneError,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: _dec('رقم للاتصال (لو مختلف)', hint: '01xxxxxxxxx'),
              validator: _phoneError,
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
                label: Text(_editing ? 'احفظ التعديلات' : 'انشر الإعلان'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
