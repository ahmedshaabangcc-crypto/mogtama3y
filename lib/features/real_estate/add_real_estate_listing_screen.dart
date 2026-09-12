import 'package:flutter/material.dart';

import '../../core/real_estate/real_estate_service.dart';
import '../../core/theme/app_colors.dart';

/// Publishes a real real_estate_listings row — see
/// backend/migrations/0023_real_estate.sql. Requires the caller to
/// already be a verified union member (their unit/building is resolved
/// server-side-equivalent here, not typed in by hand), so the "جار
/// موثق" badge shown on the browse screen is actually true.
class AddRealEstateListingScreen extends StatefulWidget {
  const AddRealEstateListingScreen({super.key});

  @override
  State<AddRealEstateListingScreen> createState() => _AddRealEstateListingScreenState();
}

class _AddRealEstateListingScreenState extends State<AddRealEstateListingScreen> {
  String _dealType = 'sale';
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _bedroomsCtrl = TextEditingController();
  final _bathroomsCtrl = TextEditingController();
  bool _hideFromBuilding = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _areaCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathroomsCtrl.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final title = _titleCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim());
    if (title.isEmpty) {
      setState(() => _error = 'أدخل عنوان الإعلان');
      return;
    }
    if (price == null || price <= 0) {
      setState(() => _error = 'أدخل سعراً صحيحاً');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await RealEstateService.createListing(
        dealType: _dealType,
        title: title,
        description: _descriptionCtrl.text.trim(),
        price: price,
        areaSqm: double.tryParse(_areaCtrl.text.trim()),
        bedrooms: int.tryParse(_bedroomsCtrl.text.trim()),
        bathrooms: int.tryParse(_bathroomsCtrl.text.trim()),
        hideFromOwnBuilding: _hideFromBuilding,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString().contains('توثيق') ? e.toString().replaceFirst('Exception: ', '') : 'تعذر نشر الإعلان، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إضافة عقار للبيع أو الإيجار')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Row(children: [
            Expanded(
              child: _DealTypeChip(label: 'للبيع', selected: _dealType == 'sale', onTap: () => setState(() => _dealType = 'sale')),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _DealTypeChip(label: 'للإيجار', selected: _dealType == 'rent', onTap: () => setState(() => _dealType = 'rent')),
            ),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _titleCtrl, decoration: _decoration('عنوان الإعلان')),
          const SizedBox(height: 12),
          TextField(controller: _descriptionCtrl, maxLines: 3, decoration: _decoration('الوصف')),
          const SizedBox(height: 12),
          TextField(controller: _priceCtrl, keyboardType: TextInputType.number, decoration: _decoration(_dealType == 'sale' ? 'السعر (ج.م)' : 'الإيجار الشهري (ج.م)')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _areaCtrl, keyboardType: TextInputType.number, decoration: _decoration('المساحة (م²)'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _bedroomsCtrl, keyboardType: TextInputType.number, decoration: _decoration('غرف النوم'))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _bathroomsCtrl, keyboardType: TextInputType.number, decoration: _decoration('الحمامات'))),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const Expanded(child: Text('إخفاء العقار عن سكان عمارتي الحالية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
              Switch(value: _hideFromBuilding, onChanged: (v) => setState(() => _hideFromBuilding = v), activeThumbColor: AppColors.teal),
            ]),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _submitting ? null : _publish,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _submitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white)) : const Text('نشر الإعلان'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
      );
}

class _DealTypeChip extends StatelessWidget {
  const _DealTypeChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: selected ? AppColors.navy : AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? AppColors.navy : AppColors.border)),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}
