import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import 'union_dashboard_screen.dart';

/// Real "found your building" flow: creates the building + the founder's
/// own unit, makes them its verified president, and generates a share-able
/// invite code for the rest of the neighbors — see
/// backend/migrations/0003_union_building_flow.sql.
///
/// The building name field is backed by a real Google Places search (see
/// backend/migrations/0017_buildings_registry.sql) so two neighbors typing
/// the same real building differently don't fragment it into two separate
/// digital groups — picking the same real place a second time turns this
/// into a join request on the existing building instead of a new one.
class FoundBuildingScreen extends StatefulWidget {
  const FoundBuildingScreen({super.key});

  @override
  State<FoundBuildingScreen> createState() => _FoundBuildingScreenState();
}

class _FoundBuildingScreenState extends State<FoundBuildingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _districtCtrl = TextEditingController(text: 'المعادي - دجلة');
  final _cityCtrl = TextEditingController(text: 'القاهرة');
  final _governorateCtrl = TextEditingController(text: 'القاهرة');
  final _unitCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  bool _submitting = false;
  bool _searching = false;
  String? _error;
  String? _generatedCode;
  bool _joinedExisting = false;
  List<Map<String, dynamic>> _searchResults = [];
  String? _selectedPlaceId;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _districtCtrl.dispose();
    _cityCtrl.dispose();
    _governorateCtrl.dispose();
    _unitCtrl.dispose();
    _floorCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchCtrl.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final results = await PlacesService.searchPlaces(query);
      if (!mounted) return;
      setState(() => _searchResults = results);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'تعذر البحث حالياً، جرّب إدخال بيانات العمارة يدوياً بالأسفل.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _pickResult(Map<String, dynamic> place) {
    setState(() {
      _nameCtrl.text = place['name'] as String? ?? '';
      _districtCtrl.text = place['address'] as String? ?? _districtCtrl.text;
      _selectedPlaceId = place['place_id'] as String?;
      _selectedLat = (place['lat'] as num?)?.toDouble();
      _selectedLng = (place['lng'] as num?)?.toDouble();
      _searchResults = [];
      _searchCtrl.clear();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPlaceId = null;
      _selectedLat = null;
      _selectedLng = null;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final code = await UnionService.foundBuilding(
        name: _nameCtrl.text.trim(),
        district: _districtCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        governorate: _governorateCtrl.text.trim(),
        unitNumber: _unitCtrl.text.trim(),
        floorLabel: _floorCtrl.text.trim(),
        googlePlaceId: _selectedPlaceId,
        lat: _selectedLat,
        lng: _selectedLng,
      );
      if (!mounted) return;
      if (code == 'PENDING_EXISTING') {
        setState(() {
          _joinedExisting = true;
          _generatedCode = code;
        });
      } else {
        setState(() => _generatedCode = code);
      }
    } catch (_) {
      setState(() => _error = 'تعذر تأسيس العمارة، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }

    if (_generatedCode != null) {
      if (_joinedExisting) {
        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(title: const Text('تم إرسال طلبك')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.mark_email_read_outlined, color: AppColors.teal, size: 34),
                ),
                const SizedBox(height: 18),
                Text('${_nameCtrl.text.trim()} مسجّلة بالفعل على مُجتمعي',
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.5)),
                const SizedBox(height: 8),
                const Text('تم إرسال طلب انضمامك لرئيس اتحاد الملاك الحالي للمراجعة، هتوصلك إشعار فور الموافقة',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted, height: 1.7)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('حسناً', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('تم تأسيس العمارة')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.military_tech_rounded, color: AppColors.teal, size: 34),
              ),
              const SizedBox(height: 18),
              Text('تهانينا! أصبحت رئيس اتحاد ملاك ${_nameCtrl.text.trim()}',
                  textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.5)),
              const SizedBox(height: 8),
              const Text('شارك كود الدعوة التالي مع جيرانك لينضموا للعمارة',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
                alignment: Alignment.center,
                child: Text(_generatedCode!,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: 2)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const UnionDashboardScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.dashboard_customize_outlined, size: 18),
                  label: const Text('الدخول إلى لوحة تحكم اتحاد الملاك', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تأسيس اتحاد ملاك جديد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              'كن أنت المبادر الأول! سجّل بيانات عمارتك ووحدتك، وستصبح رئيساً مؤقتاً لاتحاد الملاك مع كود دعوة فوري لدعوة باقي الجيران.',
              style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.8),
            ),
          ),
          const SizedBox(height: 20),
          const _FieldLabel('ابحث عن عمارتك الحقيقية أولاً (يمنع تكرار نفس العمارة)'),
          const SizedBox(height: 6),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'مثال: برج الياسمين، شارع 9، المعادي',
                  hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _searching ? null : _search,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _searching
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.search_rounded, size: 18),
              ),
            ),
          ]),
          if (_searchResults.isNotEmpty) ...[
            const SizedBox(height: 10),
            ..._searchResults.map((place) => InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _pickResult(place),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Row(children: [
                      const Icon(Icons.apartment_rounded, color: AppColors.teal, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(place['name'] as String? ?? '', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(place['address'] as String? ?? '', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                        ]),
                      ),
                    ]),
                  ),
                )),
          ],
          if (_selectedPlaceId != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 16),
                const SizedBox(width: 8),
                const Expanded(child: Text('تم تحديد مكان حقيقي من خرائط Google', style: TextStyle(fontSize: 11.5, color: AppColors.teal, fontWeight: FontWeight.w600))),
                InkWell(onTap: _clearSelection, child: const Text('إلغاء', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FieldLabel('اسم العمارة / البرج *'),
                const SizedBox(height: 6),
                _Field(controller: _nameCtrl, hint: 'مثال: عمارة 14 - شارع دجلة'),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('المحافظة'),
                      const SizedBox(height: 6),
                      _Field(controller: _governorateCtrl, hint: 'القاهرة'),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('المدينة'),
                      const SizedBox(height: 6),
                      _Field(controller: _cityCtrl, hint: 'القاهرة'),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                const _FieldLabel('الحي / المنطقة *'),
                const SizedBox(height: 6),
                _Field(controller: _districtCtrl, hint: 'المعادي - دجلة'),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('رقم شقتك *'),
                      const SizedBox(height: 6),
                      _Field(controller: _unitCtrl, hint: 'شقة 4B'),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('الدور *'),
                      const SizedBox(height: 6),
                      _Field(controller: _floorCtrl, hint: 'الدور الرابع'),
                    ]),
                  ),
                ]),
              ],
            ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _submitting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                  : const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('تأسيس العمارة والحصول على كود الدعوة', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
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

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
      ),
    );
  }
}
