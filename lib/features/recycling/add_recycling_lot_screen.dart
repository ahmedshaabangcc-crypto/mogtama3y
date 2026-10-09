import 'package:flutter/material.dart';

import '../../core/recycling/recycling_service.dart';
import '../../core/recycling/scrap_dealer_service.dart';
import '../../core/reports/report_service.dart' show governorateOf, reportGovernorates;
import '../../core/theme/app_colors.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

const _durations = ['4 ساعات', '12 ساعة', 'يوم كامل'];
const _durationValues = [Duration(hours: 4), Duration(hours: 12), Duration(hours: 24)];

/// Add a new recycling/بيكيا lot to auction — no design reference (the
/// original Stitch set only had the browse + bidding screens).
class AddRecyclingLotScreen extends StatefulWidget {
  const AddRecyclingLotScreen({super.key});

  @override
  State<AddRecyclingLotScreen> createState() => _AddRecyclingLotScreenState();
}

class _AddRecyclingLotScreenState extends State<AddRecyclingLotScreen> {
  String _material = 'iron';
  int _duration = 1;
  bool _submitting = false;
  bool _locating = false;
  String? _error;
  String? _governorate;
  double? _lat;
  double? _lng;

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _weightCtrl.dispose();
    _locationCtrl.dispose();
    _areaCtrl.dispose();
    super.dispose();
  }

  /// "حدد موقعي": saves the point (dealers within N km get notified) and
  /// fills the governorate if it's still empty.
  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      final p = await scrapMyPosition();
      if (!mounted) return;
      setState(() {
        _lat = p.latitude;
        _lng = p.longitude;
        _governorate ??= governorateOf(p.latitude, p.longitude);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e is String ? e : 'تعذر تحديد موقعك، جرّب تاني')));
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = 'يرجى إدخال عنوان اللوط.');
      return;
    }
    if (_governorate == null && _locationCtrl.text.trim().isEmpty) {
      setState(() => _error = 'اختار المحافظة أو اكتب مكان اللوط عشان التجار القريبين يوصلهم.');
      return;
    }
    final area = _areaCtrl.text.trim();
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await RecyclingService.createLot(
        material: _material,
        category: scrapMaterialCategory[_material] ?? 'other',
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        estimatedWeightKg: looseDouble(_weightCtrl.text.trim()),
        locationNote: _locationCtrl.text.trim(),
        auctionDuration: _durationValues[_duration],
        governorate: _governorate,
        area: area.isEmpty ? null : area,
        lat: _lat,
        lng: _lng,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      setState(() => _error = 'تعذر إضافة اللوط، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إضافة خردة أو بيكيا للمزاد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const _FieldLabel('عنوان اللوط *'),
          const SizedBox(height: 6),
          _EditableBox(controller: _titleCtrl, hint: 'مثال: خردة تكييف سبليت + مواسير نحاس'),
          const SizedBox(height: 14),
          const _FieldLabel('نوع الخردة *'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in scrapMaterials.entries)
                ChoiceChip(
                  label: Text(e.value, style: const TextStyle(fontSize: 11.5)),
                  selected: _material == e.key,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: _material == e.key ? Colors.white : AppColors.inkSecondary),
                  onSelected: (_) => setState(() => _material = e.key),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const _FieldLabel('الوصف التفصيلي'),
          const SizedBox(height: 6),
          _EditableBox(controller: _descriptionCtrl, hint: 'اكتب تفاصيل الحالة والكمية...', maxLines: 3),
          const SizedBox(height: 14),
          const _FieldLabel('الوزن التقديري (كجم)'),
          const SizedBox(height: 6),
          _EditableBox(controller: _weightCtrl, hint: 'مثال: 48', keyboardType: TextInputType.number),
          const SizedBox(height: 14),
          const _FieldLabel('المكان *'),
          const SizedBox(height: 4),
          const Text('تجار الخردة في منطقتك بيوصلهم إشعار بالمزاد أول ما تنزّله.', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _governorate,
            key: ValueKey(_governorate),
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'المحافظة',
              isDense: true,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            items: [for (final g in reportGovernorates) DropdownMenuItem(value: g, child: Text(g))],
            onChanged: (v) => setState(() => _governorate = v),
          ),
          const SizedBox(height: 8),
          _EditableBox(controller: _areaCtrl, hint: 'المنطقة / الحي — مثال: مدينة نصر'),
          const SizedBox(height: 8),
          _EditableBox(controller: _locationCtrl, hint: 'تفاصيل المكان — مثال: بدروم برج الياسمين'),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: _locating ? null : _locate,
              icon: _locating
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(_lat != null ? Icons.check_circle_rounded : Icons.my_location_rounded, size: 18, color: AppColors.teal),
              label: Text(_lat != null ? 'اتحدد موقعك ✓' : 'حدد موقعي', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 14),
          const _FieldLabel('مدة المزاد'),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < _durations.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => setState(() => _duration = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _duration == i ? AppColors.navy : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _duration == i ? AppColors.navy : AppColors.border),
                      ),
                      child: Text(_durations[i], style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: _duration == i ? Colors.white : AppColors.inkSecondary)),
                    ),
                  ),
                ),
              ],
            ],
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
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                  : const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('إضافة اللوط للمزاد', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
            ),
          ),
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
  const _EditableBox({required this.controller, required this.hint, this.keyboardType, this.maxLines = 1});
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: maxLines > 1 ? 10 : 4),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.inkMuted, fontWeight: FontWeight.w400, fontSize: 12),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: maxLines > 1 ? 0 : 9),
        ),
      ),
    );
  }
}
