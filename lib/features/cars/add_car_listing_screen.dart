import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/auth/auth_service.dart';
import '../../core/cars/car_service.dart';
import '../../core/reports/report_service.dart' show reportGovernorates;
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'cars_market_screen.dart' show BrandPickerField;

/// Post a car / motorcycle / tuktuk for sale or rent, or parts. The form
/// adapts to the offer type (parts hide year, km, gearbox…). Pops `true`
/// once the listing is posted.
class AddCarListingScreen extends StatefulWidget {
  const AddCarListingScreen({super.key});

  @override
  State<AddCarListingScreen> createState() => _AddCarListingScreenState();
}

class _AddCarListingScreenState extends State<AddCarListingScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _model = TextEditingController();
  final _km = TextEditingController();
  final _color = TextEditingController();
  final _price = TextEditingController();
  final _area = TextEditingController();
  final _description = TextEditingController();

  String _offerType = 'sale';
  String _vehicleType = 'car';
  String? _brand;
  int? _year;
  String? _transmission;
  String? _fuel;
  String? _bodyType;
  String _condition = 'used';
  bool _withDriver = false;
  bool _negotiable = false;
  String _payment = 'cash';
  String? _governorate;
  List<String> _images = [];
  bool _saving = false;

  bool get _parts => _offerType == 'parts';
  bool get _rental => _offerType == 'rent_daily' || _offerType == 'rent_monthly';

  @override
  void dispose() {
    for (final c in [_title, _model, _km, _color, _price, _area, _description]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _trimOrNull(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (!_parts && _brand == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختار الماركة')));
      return;
    }
    setState(() => _saving = true);
    try {
      await CarService.create({
        'offer_type': _offerType,
        'vehicle_type': _vehicleType,
        'brand': _brand,
        'model': _trimOrNull(_model),
        if (!_parts) ...{
          'year': _year,
          'km': int.tryParse(_km.text.trim().replaceAll(',', '')),
          'transmission': _transmission,
          'fuel': _fuel,
          'body_type': _vehicleType == 'car' ? _bodyType : null,
          'color': _trimOrNull(_color),
        },
        'condition': _condition,
        if (_rental) 'with_driver': _withDriver,
        'title': _title.text.trim(),
        'description': _trimOrNull(_description),
        'price': num.parse(_price.text.trim().replaceAll(',', '')),
        'negotiable': _negotiable,
        'payment': _rental ? 'cash' : _payment,
        'governorate': _governorate,
        'area': _trimOrNull(_area),
        'images': _images,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('إعلانك اتنشر')));
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر نشر الإعلان، راجع البيانات وجرّب تاني')));
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

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('أضف إعلان سيارة')),
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
    final years = [for (var y = DateTime.now().year + 1; y >= 1960; y--) y];
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('أضف إعلان سيارة')),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 40),
          children: [
            const Text('عايز تعمل إيه؟', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in carOfferTypes.entries)
                ChoiceChip(
                  label: Text(e.value),
                  selected: _offerType == e.key,
                  showCheckmark: false,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: _offerType == e.key ? Colors.white : AppColors.ink, fontWeight: FontWeight.w700),
                  onSelected: (_) => setState(() => _offerType = e.key),
                ),
            ]),
            _section('الصور'),
            MultiPhotoPicker(purpose: 'cars', maxPhotos: 20, onChanged: (urls) => _images = List.of(urls)),
            _section(_parts ? 'القطعة' : 'المركبة'),
            _dropdown<String>(_parts ? 'تناسب أنهي مركبة' : 'نوع المركبة', _vehicleType, carVehicleTypes,
                (v) => setState(() => _vehicleType = v ?? 'car'), optional: false),
            const SizedBox(height: 10),
            BrandPickerField(
              value: _brand,
              allowAny: _parts,
              label: _parts ? 'الماركة (اختياري)' : 'الماركة',
              onChanged: (v) => setState(() => _brand = v),
            ),
            const SizedBox(height: 10),
            TextFormField(controller: _model, decoration: _dec(_parts ? 'الموديل (اختياري)' : 'الموديل', hint: 'مثلاً: كورولا، إلنترا، 7')),
            if (!_parts) ...[
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _dropdown<int>('سنة الصنع', _year, {for (final y in years) y: '$y'}, (v) => setState(() => _year = v))),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _km,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _dec('العداد', suffix: 'كم'),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _dropdown<String>('ناقل الحركة', _transmission, carTransmissions, (v) => setState(() => _transmission = v))),
                const SizedBox(width: 10),
                Expanded(child: _dropdown<String>('الوقود', _fuel, carFuels, (v) => setState(() => _fuel = v))),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                if (_vehicleType == 'car') ...[
                  Expanded(child: _dropdown<String>('شكل العربية', _bodyType, carBodyTypes, (v) => setState(() => _bodyType = v))),
                  const SizedBox(width: 10),
                ],
                Expanded(child: TextFormField(controller: _color, decoration: _dec('اللون'))),
              ]),
            ],
            const SizedBox(height: 10),
            _dropdown<String>('الحالة', _condition, carConditions, (v) => setState(() => _condition = v ?? 'used'), optional: false),
            if (_rental)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _withDriver,
                onChanged: (v) => setState(() => _withDriver = v),
                title: const Text('بسواق'),
              ),
            _section('الإعلان والسعر'),
            TextFormField(
              controller: _title,
              maxLength: 120,
              decoration: _dec('عنوان الإعلان', hint: _parts ? 'مثلاً: كاوتش ميشلان 16 بوصة' : 'مثلاً: تويوتا كورولا 2019 فابريكا'),
              validator: (v) => (v ?? '').trim().length < 3 ? 'اكتب عنوان واضح (3 حروف على الأقل)' : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _dec('السعر', suffix: 'ج.م${carPriceSuffix(_offerType)}'),
              validator: (v) => (num.tryParse((v ?? '').trim()) ?? 0) <= 0 ? 'اكتب السعر' : null,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: _negotiable,
              onChanged: (v) => setState(() => _negotiable = v ?? false),
              title: const Text('قابل للتفاوض'),
            ),
            if (!_rental)
              _dropdown<String>('طريقة الدفع', _payment, carPayments, (v) => setState(() => _payment = v ?? 'cash'), optional: false),
            const SizedBox(height: 10),
            TextFormField(
              controller: _description,
              maxLines: 5,
              maxLength: 3000,
              decoration: _dec('التفاصيل', hint: 'الحالة، الصيانات، الرخصة، أي ملاحظات'),
            ),
            _section('المكان'),
            _dropdown<String>('المحافظة', _governorate, {for (final g in reportGovernorates) g: g}, (v) => setState(() => _governorate = v)),
            const SizedBox(height: 10),
            TextFormField(controller: _area, decoration: _dec('المنطقة', hint: 'مثلاً: مدينة نصر')),
            const SizedBox(height: 22),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.teal),
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_rounded),
                label: const Text('انشر الإعلان'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
