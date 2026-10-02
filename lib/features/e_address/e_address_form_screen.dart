import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/e_address/e_address_service.dart';
import '../../core/theme/app_colors.dart';

/// Create or edit a digital address. Pops with the saved address (incl.
/// its code) on success.
class EAddressFormScreen extends StatefulWidget {
  const EAddressFormScreen({super.key, this.existing});
  final Map<String, dynamic>? existing;

  @override
  State<EAddressFormScreen> createState() => _EAddressFormScreenState();
}

class _EAddressFormScreenState extends State<EAddressFormScreen> {
  static const _labels = ['البيت', 'الشغل', 'بيت العيلة', 'المحل'];
  static const _fields = ['city', 'district', 'street', 'building', 'floor', 'apartment', 'landmark', 'notes'];

  late final Map<String, TextEditingController> _c = {
    for (final f in _fields) f: TextEditingController(text: widget.existing?[f] as String? ?? ''),
  };
  late String _label = widget.existing?['label'] as String? ?? 'البيت';
  late String? _governorate = widget.existing?['governorate'] as String?;
  late double? _lat = (widget.existing?['lat'] as num?)?.toDouble();
  late double? _lng = (widget.existing?['lng'] as num?)?.toDouble();
  late bool _showName = widget.existing?['show_name'] as bool? ?? true;
  late bool _showPhone = widget.existing?['show_phone'] as bool? ?? false;
  bool _locating = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() {
      _locating = true;
      _error = null;
    });
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw 'شغّل الـ GPS (الموقع) في الموبايل وجرّب تاني';
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw 'محتاجين إذن الموقع عشان نحدد مكانك على الخريطة';
      }
      final p = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      setState(() {
        _lat = p.latitude;
        _lng = p.longitude;
      });
    } catch (e) {
      setState(() => _error = e is String ? e : 'معرفناش نحدد موقعك، جرّب تاني');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final fields = {
      'label': _label,
      'governorate': _governorate,
      for (final f in _fields) f: _c[f]!.text.trim(),
      'lat': _lat,
      'lng': _lng,
      'show_name': _showName,
      'show_phone': _showPhone,
    };
    try {
      final code = await EAddressService.save(id: widget.existing?['id'] as String?, fields: fields);
      if (!mounted) return;
      Navigator.of(context).pop({...?widget.existing, ...fields, 'code': code});
    } catch (e) {
      setState(() => _error = e is PostgrestException ? e.message : 'حصلت مشكلة في الحفظ، جرّب تاني');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _field(String key, String label, {String? hint, TextInputType? type, int maxLines = 1}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: _c[key],
          keyboardType: type,
          maxLines: maxLines,
          decoration: InputDecoration(labelText: label, hintText: hint),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'عنوان جديد' : 'تعديل العنوان')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const Text('اسم العنوان', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final l in _labels)
              ChoiceChip(label: Text(l), selected: _label == l, onSelected: (_) => setState(() => _label = l)),
          ]),
          const SizedBox(height: 18),
          DropdownButtonFormField<String>(
            initialValue: _governorate,
            decoration: const InputDecoration(labelText: 'المحافظة *'),
            items: [for (final g in EAddressService.governorates) DropdownMenuItem(value: g, child: Text(g))],
            onChanged: (v) => setState(() => _governorate = v),
          ),
          const SizedBox(height: 12),
          _field('city', 'المدينة أو الحي *', hint: 'مثال: المعادي'),
          _field('district', 'المنطقة / الكمبوند', hint: 'مثال: دجلة، أو كمبوند الربوة'),
          _field('street', 'الشارع', hint: 'مثال: شارع 9'),
          Row(children: [
            Expanded(child: _field('building', 'رقم العمارة')),
            const SizedBox(width: 10),
            Expanded(child: _field('floor', 'الدور', type: TextInputType.number)),
            const SizedBox(width: 10),
            Expanded(child: _field('apartment', 'الشقة')),
          ]),
          _field('landmark', 'علامة مميزة', hint: 'مثال: قدام صيدلية نور، جنب الجامع'),
          _field('notes', 'ملاحظات للي جايلك', hint: 'مثال: البوابة الخلفية، اسأل البواب', maxLines: 2),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                Icon(_lat == null ? Icons.location_searching_rounded : Icons.check_circle_rounded,
                    color: _lat == null ? AppColors.inkMuted : AppColors.success, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_lat == null ? 'الموقع على الخريطة (مهم عشان يوصلولك بالظبط)' : 'تم تحديد الموقع على الخريطة',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 4),
              const Text('اعمل الخطوة دي وإنت في العنوان نفسه.', style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _locating ? null : _locate,
                    icon: _locating
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location_rounded, size: 18),
                    label: Text(_lat == null ? 'حدّد موقعي دلوقتي' : 'حدّده تاني'),
                  ),
                ),
                if (_lat != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=$_lat,$_lng'), mode: LaunchMode.externalApplication),
                    child: const Text('اتأكد على الخريطة'),
                  ),
                ],
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _showName,
            onChanged: (v) => setState(() => _showName = v),
            title: const Text('اظهر اسمي مع العنوان', style: TextStyle(fontSize: 13.5)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _showPhone,
            onChanged: (v) => setState(() => _showPhone = v),
            title: const Text('اظهر رقم موبايلي عشان يكلموني', style: TextStyle(fontSize: 13.5)),
            subtitle: const Text('أي حد معاه اللينك هيشوف الرقم', style: TextStyle(fontSize: 11.5)),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12.5)),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.qr_code_2_rounded),
            label: Text(widget.existing == null ? 'احفظ واعمل الكود' : 'احفظ التعديل'),
          ),
        ],
      ),
    );
  }
}
