import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import 'union_dashboard_screen.dart';

const _egyptGovernorates = [
  'القاهرة', 'الجيزة', 'الإسكندرية', 'الدقهلية', 'البحر الأحمر', 'البحيرة', 'الفيوم',
  'الغربية', 'الإسماعيلية', 'المنوفية', 'المنيا', 'القليوبية', 'الوادي الجديد', 'السويس',
  'أسوان', 'أسيوط', 'بني سويف', 'بورسعيد', 'دمياط', 'الشرقية', 'جنوب سيناء', 'كفر الشيخ',
  'مطروح', 'الأقصر', 'قنا', 'شمال سيناء', 'سوهاج',
];

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
  final _districtCtrl = TextEditingController();
  String _governorate = 'القاهرة';
  final _unitCtrl = TextEditingController();
  final _floorCtrl = TextEditingController();
  bool _asPresident = true;
  bool _submitting = false;
  bool _searching = false;
  String? _error;
  String? _generatedCode;
  bool _joinedExisting = false;
  List<Map<String, dynamic>> _searchResults = [];
  String? _selectedPlaceId;
  double? _selectedLat;
  double? _selectedLng;
  String? _selectedBuildingId;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _districtCtrl.dispose();
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
      final results = await Future.wait([
        PlacesService.searchPlaces(query),
        UnionService.searchLocalBuildings(query),
      ]);
      if (!mounted) return;
      final googleResults = results[0].map((p) => {...p, 'source': 'google'}).toList();
      final localResults = results[1].map((b) => {
            'source': 'local',
            'building_id': b['id'],
            'name': b['name'],
            'address': [b['district'], b['city']].where((s) => s != null && (s as String).isNotEmpty).join(' - '),
          }).toList();
      // buildings already on مُجتمعي first — that's the match a resident
      // should actually pick to avoid creating a duplicate.
      setState(() => _searchResults = [...localResults, ...googleResults]);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'تعذر البحث حالياً، جرّب إدخال بيانات العمارة يدوياً بالأسفل.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _pickResult(Map<String, dynamic> place) {
    final isLocal = place['source'] == 'local';
    setState(() {
      _nameCtrl.text = place['name'] as String? ?? '';
      if (!isLocal) {
        _districtCtrl.text = place['address'] as String? ?? _districtCtrl.text;
      }
      _selectedPlaceId = isLocal ? null : place['place_id'] as String?;
      _selectedLat = isLocal ? null : (place['lat'] as num?)?.toDouble();
      _selectedLng = isLocal ? null : (place['lng'] as num?)?.toDouble();
      _selectedBuildingId = isLocal ? place['building_id'] as String? : null;
      _searchResults = [];
      _searchCtrl.clear();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPlaceId = null;
      _selectedLat = null;
      _selectedLng = null;
      _selectedBuildingId = null;
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
        city: _governorate,
        governorate: _governorate,
        unitNumber: _unitCtrl.text.trim(),
        floorLabel: _floorCtrl.text.trim(),
        googlePlaceId: _selectedPlaceId,
        lat: _selectedLat,
        lng: _selectedLng,
        asPresident: _asPresident,
        existingBuildingId: _selectedBuildingId,
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
              Text(
                _asPresident
                    ? 'تهانينا! أصبحت رئيس اتحاد ملاك ${_nameCtrl.text.trim()}'
                    : 'تم تسجيل ${_nameCtrl.text.trim()} بنجاح',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.5),
              ),
              const SizedBox(height: 8),
              Text(
                _asPresident
                    ? 'شارك كود الدعوة التالي مع جيرانك لينضموا للعمارة'
                    : 'انضممت كعضو مجلس مؤقت — شارك كود الدعوة مع جيرانك، ولما توصلوا للنصاب القانوني تقدروا تفتحوا انتخابات لرئيس فعلي من لوحة الاتحاد',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted, height: 1.6),
              ),
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
              'كن أنت المبادر الأول! سجّل بيانات عمارتك ووحدتك، وهتاخد كود دعوة فوري لدعوة باقي الجيران — اختار تحت لو عايز تبقى رئيس الاتحاد مؤقتاً ولا تفضّل تسيبها لانتخاب حقيقي بعدين.',
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
            ..._searchResults.map((place) {
              final isLocal = place['source'] == 'local';
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _pickResult(place),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLocal ? AppColors.teal.withValues(alpha: 0.06) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isLocal ? AppColors.teal.withValues(alpha: 0.4) : AppColors.border),
                  ),
                  child: Row(children: [
                    Icon(isLocal ? Icons.verified_rounded : Icons.apartment_rounded, color: AppColors.teal, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Flexible(child: Text(place['name'] as String? ?? '', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                          if (isLocal) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
                              child: const Text('مسجلة على مُجتمعي', style: TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 2),
                        Text(place['address'] as String? ?? '', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                      ]),
                    ),
                  ]),
                ),
              );
            }),
          ],
          if (_selectedPlaceId != null || _selectedBuildingId != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedBuildingId != null ? 'هتنضم لعمارة مسجلة بالفعل على مُجتمعي' : 'تم تحديد مكان حقيقي من خرائط Google',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.teal, fontWeight: FontWeight.w600),
                  ),
                ),
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
                      const _FieldLabel('الدولة'),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                        child: const Text('مصر', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkMuted)),
                      ),
                    ]),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const _FieldLabel('المحافظة'),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _governorate,
                            isExpanded: true,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink),
                            items: _egyptGovernorates.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                            onChanged: (v) => setState(() => _governorate = v ?? _governorate),
                          ),
                        ),
                      ),
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
                const SizedBox(height: 20),
                const _FieldLabel('دورك في الاتحاد بعد التسجيل'),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: _RoleChoiceTile(
                      icon: Icons.military_tech_rounded,
                      label: 'أنا رئيس الاتحاد',
                      selected: _asPresident,
                      onTap: () => setState(() => _asPresident = true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _RoleChoiceTile(
                      icon: Icons.groups_rounded,
                      label: 'أنا ساكن بس، ننتخب رئيس بعدين',
                      selected: !_asPresident,
                      onTap: () => setState(() => _asPresident = false),
                    ),
                  ),
                ]),
                if (!_asPresident) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'هتنضم كعضو مجلس مؤقت — تقدر توافق على انضمام الجيران وتفتح انتخابات رئيس حقيقي لما توصلوا للنصاب القانوني، من غير ما تكون رئيس دائم بنفسك.',
                    style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.6),
                  ),
                ],
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

class _RoleChoiceTile extends StatelessWidget {
  const _RoleChoiceTile({required this.icon, required this.label, required this.selected, required this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppColors.navy : AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : AppColors.inkSecondary),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: selected ? Colors.white : AppColors.inkSecondary)),
          ],
        ),
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
