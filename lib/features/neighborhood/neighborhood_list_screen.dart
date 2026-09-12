import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/neighborhood/neighborhood_service.dart';
import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'neighborhood_detail_screen.dart';

/// "جروب الحي" — a real district-wide group above the building union.
/// Joining is self-declared with no verification, per Ahmed's explicit
/// instruction. See backend/migrations/0028_neighborhood_groups.sql.
class NeighborhoodListScreen extends StatefulWidget {
  const NeighborhoodListScreen({super.key});

  @override
  State<NeighborhoodListScreen> createState() => _NeighborhoodListScreenState();
}

class _NeighborhoodListScreenState extends State<NeighborhoodListScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _myNeighborhoods = [];
  final _searchCtrl = TextEditingController();
  bool _searching = false;
  bool _joining = false;
  String? _error;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await NeighborhoodService.fetchMyNeighborhoods();
    if (!mounted) return;
    setState(() {
      _myNeighborhoods = rows;
      _loading = false;
    });
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'تعذر البحث حالياً، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _join(Map<String, dynamic> place) async {
    setState(() => _joining = true);
    try {
      await NeighborhoodService.joinOrCreate(
        name: place['name'] as String? ?? _searchCtrl.text.trim(),
        googlePlaceId: place['place_id'] as String?,
        lat: (place['lat'] as num?)?.toDouble(),
        lng: (place['lng'] as num?)?.toDouble(),
      );
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _searchCtrl.clear();
      });
      _load();
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'تعذر الانضمام، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('جروب الحي')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
              child: const Text(
                'انضم لجروب حيّك عشان تتابع بوستات ودردشة جيرانك في المنطقة كلها، مش بس عمارتك.',
                style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.8),
              ),
            ),
            const SizedBox(height: 16),
            const Text('ابحث عن اسم حيّك أو منطقتك', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  onSubmitted: (_) => _search(),
                  decoration: InputDecoration(
                    hintText: 'مثال: المعادي، دجلة، التجمع الخامس',
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
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: _searching
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.search_rounded, size: 18),
                ),
              ),
            ]),
            if (_searchResults.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (final place in _searchResults) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    const Icon(Icons.location_city_rounded, color: AppColors.teal, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(place['name'] as String? ?? '', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(place['address'] as String? ?? '', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                      ]),
                    ),
                    TextButton(onPressed: _joining ? null : () => _join(place), child: const Text('انضمام')),
                  ]),
                ),
              ],
            ],
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ],
            const SizedBox(height: 24),
            const Text('جروبات الحي بتاعتي', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
            else if (_myNeighborhoods.isEmpty)
              const Text('لسه منضمش لأي جروب حي', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final row in _myNeighborhoods) ...[
                Builder(builder: (context) {
                  final n = row['neighborhood'] as Map<String, dynamic>;
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NeighborhoodDetailScreen(neighborhoodId: n['id'] as String, neighborhoodName: n['name'] as String))),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(color: AppColors.categoryUnion.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.location_city_rounded, color: AppColors.categoryUnion, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(n['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
                        const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
                      ]),
                    ),
                  );
                }),
              ],
          ],
        ),
      ),
    );
  }
}
