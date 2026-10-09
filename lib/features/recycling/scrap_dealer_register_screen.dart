import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/auth/auth_service.dart';
import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/reports/report_service.dart' show governorateOf, reportGovernorates;
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import 'scrap_widgets.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// Register (or edit) as a scrap dealer ("تاجر خردة"): business name,
/// WhatsApp, the materials you buy and where you work — a governorate and
/// its districts, and/or everything within N km of your location — plus an
/// optional commercial-register / shop photo. A new registration is
/// reviewed by the platform; a new business name or document sends a
/// verified dealer back to review (materials / areas don't). Pops `true`
/// once saved. Migration 0075.
class ScrapDealerRegisterScreen extends StatefulWidget {
  const ScrapDealerRegisterScreen({super.key, this.existing});

  /// The current scrap_dealers row when editing.
  final Map<String, dynamic>? existing;

  @override
  State<ScrapDealerRegisterScreen> createState() => _ScrapDealerRegisterScreenState();
}

class _ScrapDealerRegisterScreenState extends State<ScrapDealerRegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _whatsapp = TextEditingController();
  final _areaInput = TextEditingController();
  final _radius = TextEditingController();

  final Set<String> _materials = {};
  final List<String> _areas = [];
  String? _governorate;
  bool _useRadius = false;
  double? _baseLat;
  double? _baseLng;
  String? _docPath;
  bool _uploadingDoc = false;
  bool _locating = false;
  bool _saving = false;

  Map<String, dynamic>? get _existing => widget.existing;

  @override
  void initState() {
    super.initState();
    final e = _existing;
    if (e != null) {
      _name.text = e['business_name'] as String? ?? '';
      _whatsapp.text = e['whatsapp'] as String? ?? '';
      _materials.addAll(((e['materials'] as List?) ?? const []).cast<String>());
      _areas.addAll(((e['areas'] as List?) ?? const []).cast<String>());
      _governorate = e['governorate'] as String?;
      final radius = (e['radius_km'] as num?)?.toDouble();
      if (radius != null) {
        _useRadius = true;
        _radius.text = radius == radius.roundToDouble() ? radius.toStringAsFixed(0) : radius.toString();
        _baseLat = (e['base_lat'] as num?)?.toDouble();
        _baseLng = (e['base_lng'] as num?)?.toDouble();
      }
      _docPath = e['doc_path'] as String?;
    } else {
      _radius.text = '10';
      _prefillWhatsapp();
    }
  }

  Future<void> _prefillWhatsapp() async {
    try {
      final profile = await AuthService.fetchCurrentProfile();
      final phone = normalizeEgyptMobile(profile?['phone'] as String?);
      if (!mounted || phone == null || _whatsapp.text.isNotEmpty) return;
      setState(() => _whatsapp.text = phone);
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in [_name, _whatsapp, _areaInput, _radius]) {
      c.dispose();
    }
    super.dispose();
  }

  void _addArea() {
    final v = _areaInput.text.trim();
    if (v.isEmpty) return;
    if (!_areas.contains(v) && _areas.length < 30) setState(() => _areas.add(v));
    _areaInput.clear();
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      final p = await scrapMyPosition();
      if (!mounted) return;
      setState(() {
        _baseLat = p.latitude;
        _baseLng = p.longitude;
        _governorate ??= governorateOf(p.latitude, p.longitude);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is String ? e : 'تعذر تحديد موقعك، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _pickDoc() async {
    final file = await UploadService.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => _uploadingDoc = true);
    try {
      final path = await UploadService.uploadPrivateDocument(purpose: 'scrap-dealer', file: file);
      if (!mounted) return;
      setState(() => _docPath = path);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر رفع الصورة، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _uploadingDoc = false);
    }
  }

  Future<void> _submit() async {
    _addArea();
    if (!_form.currentState!.validate()) return;
    String? problem;
    double? radius;
    if (_materials.isEmpty) {
      problem = 'اختار نوع خردة واحد على الأقل';
    } else if (_useRadius) {
      radius = looseDouble(_radius.text.trim());
      if (radius == null || radius <= 0 || radius > 200) {
        problem = 'اكتب المسافة بالكيلو (من 1 لـ 200)';
      } else if (_baseLat == null) {
        problem = 'دوس «حدد موقعي» عشان نحسب المسافة من مكانك';
      }
    }
    if (problem == null && _governorate == null && !_useRadius) {
      problem = 'اختار المحافظة اللي بتشتغل فيها أو حدد نطاق بالكيلو من موقعك';
    }
    if (problem != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(problem)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ScrapDealerService.save(
        isNew: _existing == null,
        businessName: _name.text.trim(),
        whatsapp: normalizeEgyptMobile(_whatsapp.text) ?? _whatsapp.text.trim(),
        materials: _materials.toList(),
        governorate: _governorate,
        areas: _areas,
        radiusKm: _useRadius ? radius : null,
        baseLat: _useRadius ? _baseLat : null,
        baseLng: _useRadius ? _baseLng : null,
        docPath: _docPath,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_existing == null ? 'تم التسجيل — طلبك قيد المراجعة، وهتوصلك إشعارات المزادات اللي تناسبك من دلوقتي' : 'اتحفظت التعديلات'),
      ));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e is PostgrestException && e.message.contains('مستند') ? e.message : 'تعذر الحفظ، راجع البيانات وجرّب تاني'),
      ));
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

  Widget _section(String title, [String? hint]) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.ink)),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(hint, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          ],
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final status = _existing?['status'] as String?;
    final note = _existing?['review_note'] as String?;
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(_existing == null ? 'سجّل كتاجر خردة' : 'بيانات تاجر الخردة')),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 32),
          children: [
            if (status != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Text('حالة الحساب: ', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ScrapDealerStatusBadge(status: status),
                  ]),
                  if (status == 'rejected' && note != null && note.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('سبب الرفض: $note', style: const TextStyle(fontSize: 11.5, color: Color(0xFFC62828))),
                  ],
                  const SizedBox(height: 6),
                  const Text('تغيير اسم النشاط أو المستند بيرجّع الحساب للمراجعة. تغيير الخامات والمناطق لأ.',
                      style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ]),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                child: const Text(
                  'سجّل كتاجر خردة وهيوصلك إشعار بكل مزاد خردة جديد في منطقتك وفي الخامات اللي بتشتريها. بعد المراجعة بتاخد علامة «تاجر موثّق ✓» تظهر للبائع جنب عروضك.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.teal, height: 1.7),
                ),
              ),
            _section('بيانات النشاط'),
            TextFormField(
              controller: _name,
              decoration: _dec('اسم النشاط / المخزن *', hint: 'مثال: مخزن الأمانة للخردة'),
              validator: (v) => (v == null || v.trim().length < 2) ? 'اكتب اسم النشاط' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _whatsapp,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              decoration: _dec('رقم الواتساب *', hint: '01xxxxxxxxx'),
              validator: (v) => scrapWhatsappPattern.hasMatch(normalizeEgyptMobile(v) ?? v?.trim() ?? '') ? null : 'رقم موبايل مصري صحيح (11 رقم يبدأ بـ 01)',
            ),
            const SizedBox(height: 4),
            const Text('رقمك مش بيظهر لحد — بيوصل للبائع بس لو قبل عرضك.', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            _section('بتشتري إيه؟ *'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in scrapMaterials.entries)
                FilterChip(
                  label: Text(e.value, style: const TextStyle(fontSize: 11.5)),
                  selected: _materials.contains(e.key),
                  selectedColor: AppColors.teal.withValues(alpha: 0.18),
                  checkmarkColor: AppColors.teal,
                  onSelected: (v) => setState(() => v ? _materials.add(e.key) : _materials.remove(e.key)),
                ),
            ]),
            _section('بتشتغل فين؟', 'اختار المحافظة والمناطق — لو مكتبتش مناطق هيوصلك كل مزادات المحافظة.'),
            DropdownButtonFormField<String>(
              key: ValueKey(_governorate),
              initialValue: _governorate,
              isExpanded: true,
              decoration: _dec('المحافظة'),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('—')),
                for (final g in reportGovernorates) DropdownMenuItem(value: g, child: Text(g)),
              ],
              onChanged: (v) => setState(() => _governorate = v),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _areaInput,
                  decoration: _dec('المناطق / الأحياء', hint: 'مثال: مدينة نصر'),
                  onSubmitted: (_) => _addArea(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(onPressed: _addArea, icon: const Icon(Icons.add_rounded), tooltip: 'إضافة منطقة'),
            ]),
            if (_areas.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final a in _areas)
                  InputChip(
                    label: Text(a, style: const TextStyle(fontSize: 11.5)),
                    onDeleted: () => setState(() => _areas.remove(a)),
                  ),
              ]),
            ],
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _useRadius,
              onChanged: (v) => setState(() => _useRadius = v),
              title: const Text('وكمان أي مزاد في نطاق مسافة من موقعي', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              subtitle: const Text('مفيد لو بتلف على أكتر من منطقة', style: TextStyle(fontSize: 10.5)),
            ),
            if (_useRadius)
              Row(children: [
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _radius,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: _dec('المسافة', suffix: 'كم'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _locating ? null : _locate,
                    icon: _locating
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(_baseLat != null ? Icons.check_circle_rounded : Icons.my_location_rounded, size: 18, color: AppColors.teal),
                    label: Text(_baseLat != null ? 'اتحدد موقعك ✓' : 'حدد موقعي', style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ]),
            _section('مستند (اختياري)', 'صورة السجل التجاري أو صورة المحل — بتسرّع التوثيق، ومحدش بيشوفها غير فريق المراجعة.'),
            OutlinedButton.icon(
              onPressed: _uploadingDoc ? null : _pickDoc,
              icon: _uploadingDoc
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_docPath != null ? Icons.check_circle_rounded : Icons.upload_file_rounded, size: 18, color: AppColors.teal),
              label: Text(_docPath != null ? 'الصورة اترفعت ✓ (اضغط للتغيير)' : 'ارفع صورة'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                    : const Icon(Icons.check_rounded, size: 18),
                label: Text(_existing == null ? 'سجّلني كتاجر خردة' : 'حفظ التعديلات', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
