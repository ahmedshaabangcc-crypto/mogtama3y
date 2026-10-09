import 'package:flutter/material.dart';

import '../../core/real_estate/real_estate_service.dart';
import '../../core/reports/report_service.dart';
import '../../core/storage/multi_photo_picker.dart';
import '../../core/theme/app_colors.dart';
import '../promote/promote_listing_screen.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

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
  String _offerType = 'sale';
  String _propertyType = 'apartment';
  String? _finishing;
  String? _payment;
  String? _governorate;
  final _floorCtrl = TextEditingController();
  final _areaNameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _bedroomsCtrl = TextEditingController();
  final _bathroomsCtrl = TextEditingController();
  // Building-level hiding belongs to the owners'-union app, not مُجتمعي.
  static const _hideFromBuilding = false;
  bool _submitting = false;
  String? _error;
  List<String> _images = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _floorCtrl.dispose();
    _areaNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _areaCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathroomsCtrl.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final title = _titleCtrl.text.trim();
    final price = looseDouble(_priceCtrl.text.trim());
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
      final id = await RealEstateService.createListing(
        offerType: _offerType,
        propertyType: _propertyType,
        floor: realEstateHasRooms(_propertyType) ? looseInt(_floorCtrl.text.trim()) : null,
        finishing: _finishing,
        payment: _offerType == 'sale' ? _payment : null,
        governorate: _governorate,
        areaName: _areaNameCtrl.text.trim().isEmpty ? null : _areaNameCtrl.text.trim(),
        title: title,
        description: _descriptionCtrl.text.trim(),
        price: price,
        areaSqm: looseDouble(_areaCtrl.text.trim()),
        bedrooms: realEstateHasRooms(_propertyType) ? looseInt(_bedroomsCtrl.text.trim()) : null,
        bathrooms: realEstateHasRooms(_propertyType) ? looseInt(_bathroomsCtrl.text.trim()) : null,
        hideFromOwnBuilding: _hideFromBuilding,
        images: _images,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PromoteListingScreen(listingTable: 'real_estate_listings', listingId: id, listingTitle: title)),
        result: true,
      );
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
      appBar: AppBar(title: const Text('أضف عقار')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const Text('صور العقار', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          const SizedBox(height: 8),
          MultiPhotoPicker(purpose: 'real-estate', onChanged: (urls) => setState(() => _images = urls)),
          const SizedBox(height: 16),
          const Text('نوع العرض', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final e in realEstateOfferTypes.entries)
              _DealTypeChip(label: e.value, selected: _offerType == e.key, onTap: () => setState(() => _offerType = e.key)),
          ]),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _propertyType,
            decoration: _decoration('نوع العقار'),
            items: [
              for (final g in realEstateGroups)
                for (final e in realEstatePropertyTypes.entries.where((e) => e.value.$2 == g))
                  DropdownMenuItem(value: e.key, child: Text('${e.value.$1}  —  $g')),
            ],
            onChanged: (v) => setState(() => _propertyType = v ?? _propertyType),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _governorate,
                isExpanded: true,
                decoration: _decoration('المحافظة'),
                items: [for (final g in reportGovernorates) DropdownMenuItem(value: g, child: Text(g))],
                onChanged: (v) => setState(() => _governorate = v),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: _areaNameCtrl, decoration: _decoration('المنطقة / الحي'))),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _titleCtrl, decoration: _decoration('عنوان الإعلان')),
          const SizedBox(height: 12),
          TextField(controller: _descriptionCtrl, maxLines: 3, decoration: _decoration('الوصف')),
          const SizedBox(height: 12),
          TextField(controller: _priceCtrl, keyboardType: TextInputType.number, decoration: _decoration(_offerType == 'sale' ? 'السعر (ج.م)' : (_offerType == 'rent_daily' ? 'الإيجار في الليلة (ج.م)' : 'الإيجار الشهري (ج.م)'))),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _areaCtrl, keyboardType: TextInputType.number, decoration: _decoration('المساحة (م²)'))),
            if (realEstateHasRooms(_propertyType)) ...[
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _bedroomsCtrl, keyboardType: TextInputType.number, decoration: _decoration('الغرف'))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _bathroomsCtrl, keyboardType: TextInputType.number, decoration: _decoration('الحمامات'))),
            ],
          ]),
          if (realEstateHasRooms(_propertyType)) ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: _floorCtrl, keyboardType: TextInputType.number, decoration: _decoration('الدور'))),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _finishing,
                  isExpanded: true,
                  decoration: _decoration('التشطيب'),
                  items: [for (final e in realEstateFinishing.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                  onChanged: (v) => setState(() => _finishing = v),
                ),
              ),
            ]),
          ],
          if (_offerType == 'sale') ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _payment,
              decoration: _decoration('طريقة الدفع'),
              items: [for (final e in realEstatePayment.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
              onChanged: (v) => setState(() => _payment = v),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(color: selected ? AppColors.navy : AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? AppColors.navy : AppColors.border)),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}
