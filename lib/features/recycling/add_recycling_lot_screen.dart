import 'package:flutter/material.dart';

import '../../core/recycling/recycling_service.dart';
import '../../core/theme/app_colors.dart';

const _categories = ['معادن', 'بلاستيك', 'إلكترونيات', 'أثاث', 'ورق وكرتون', 'أخرى'];
const _categoryValues = ['metal', 'plastic', 'electronics', 'furniture', 'paper_cardboard', 'other'];
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
  int _category = 0;
  int _duration = 1;
  bool _submitting = false;
  String? _error;

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _weightCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty || _locationCtrl.text.trim().isEmpty) {
      setState(() => _error = 'يرجى إدخال عنوان اللوط ومكانه.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await RecyclingService.createLot(
        category: _categoryValues[_category],
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        estimatedWeightKg: double.tryParse(_weightCtrl.text.trim()),
        locationNote: _locationCtrl.text.trim(),
        auctionDuration: _durationValues[_duration],
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
          const _FieldLabel('التصنيف *'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _categories.length; i++)
                ChoiceChip(
                  label: Text(_categories[i], style: const TextStyle(fontSize: 11.5)),
                  selected: _category == i,
                  selectedColor: AppColors.teal,
                  labelStyle: TextStyle(color: _category == i ? Colors.white : AppColors.inkSecondary),
                  onSelected: (_) => setState(() => _category = i),
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
          const _FieldLabel('الموقع *'),
          const SizedBox(height: 6),
          _EditableBox(controller: _locationCtrl, hint: 'مثال: بدروم برج الياسمين'),
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
