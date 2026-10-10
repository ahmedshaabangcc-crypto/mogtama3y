import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_service.dart';
import '../../core/location/where.dart';
import '../../core/masjid/masjid_community.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/masjid/osm_mosques.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'add_mosque_screen.dart';
import 'masjid_widgets.dart';

/// «انضم لمسجدك» (0081): (a) mosques within 500 m of where you are,
/// nearest first with the distance in metres (or, when there's none, the
/// nearest few beyond), (b) search by name / area, (c) «مسجدك مش موجود؟
/// سجّله» → add it (the creator joins it). Guests browse freely; tapping
/// «انضم» signs them in first and then joins. Pops `true` after a join.
/// Outside Egypt our directory is thin, so when fewer than 3 are within
/// reach the nearby mosques on OpenStreetMap are listed too (0087).
class JoinMosqueScreen extends StatefulWidget {
  const JoinMosqueScreen({super.key});

  @override
  State<JoinMosqueScreen> createState() => _JoinMosqueScreenState();
}

class _JoinMosqueScreenState extends State<JoinMosqueScreen> {
  double? _lat;
  double? _lng;
  bool _locating = false;
  bool _locationFailed = false;
  bool _loading = false;
  bool _error = false;
  List<Map<String, dynamic>> _within = [];
  List<Map<String, dynamic>> _beyond = [];
  List<Map<String, dynamic>>? _results;
  final Set<String> _joined = {};
  final Set<String> _busy = {};
  bool _joinedAny = false;
  List<OsmMosque> _osm = [];
  bool _osmLoading = false;
  final Set<String> _osmBusy = {};
  final Set<String> _osmJoined = {};
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _locate();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() {
      _locating = true;
      _locationFailed = false;
    });
    try {
      final p = await Where.current();
      if (!mounted) return;
      setState(() {
        _lat = p.latitude;
        _lng = p.longitude;
      });
      await _loadCandidates();
    } catch (_) {
      if (mounted) setState(() => _locationFailed = true);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _loadCandidates() async {
    if (_lat == null || _lng == null) return;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final rows = await MasjidService.joinCandidates(_lat!, _lng!, radiusM: joinRadiusMeters);
      final split = splitJoinCandidates(rows);
      if (!mounted) return;
      setState(() {
        _within = split.within;
        _beyond = split.beyond;
        for (final r in rows) {
          if (r['is_member'] == true) _joined.add(r['id'] as String);
        }
      });
      if (split.within.length < 3) _loadOsm(rows);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadOsm(List<Map<String, dynamic>> ours) async {
    if (_lat == null || _lng == null) return;
    setState(() => _osmLoading = true);
    final all = await OsmMosques.near(_lat!, _lng!, radiusM: 1500);
    if (!mounted) return;
    setState(() {
      _osm = osmNotInOurs(all, ours, _lat!, _lng!).take(15).toList();
      _osmLoading = false;
    });
  }

  Future<void> _joinOsm(OsmMosque o) async {
    if (!await _ensureSignedIn() || !mounted) return;
    final key = '${o.type}/${o.id}';
    setState(() => _osmBusy.add(key));
    final id = await openOsmMosque(context, o, join: true);
    if (!mounted) return;
    setState(() {
      _osmBusy.remove(key);
      if (id != null) {
        _osmJoined.add(key);
        _joinedAny = true;
      }
    });
    if (id != null) _toast('بقيت عضو في «${o.name}» — تقدر تدخل شات المسجد دلوقتي 🤍');
  }

  Widget _osmTile(OsmMosque o) {
    final key = '${o.type}/${o.id}';
    return OsmMosqueTile(
      mosque: o,
      trailing: _osmJoined.contains(key)
          ? const Text('عضو ✓', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w800))
          : _osmBusy.contains(key)
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
              : FilledButton(onPressed: () => _joinOsm(o), child: const Text('انضم')),
    );
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final text = q.trim();
      if (text.length < 2) {
        if (mounted) setState(() => _results = null);
        return;
      }
      try {
        final rows = await MasjidService.search(text, lat: _lat, lng: _lng);
        if (mounted && _search.text.trim() == text) setState(() => _results = rows);
      } catch (_) {
        if (mounted) setState(() => _results = const []);
      }
    });
  }

  Future<bool> _ensureSignedIn() async {
    if (AuthService.isSignedIn) return true;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    return AuthService.isSignedIn;
  }

  void _toast(String m) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _join(Map<String, dynamic> m) async {
    if (!await _ensureSignedIn() || !mounted) return;
    final id = m['id'] as String;
    setState(() => _busy.add(id));
    try {
      await MasjidService.join(id);
      if (!mounted) return;
      setState(() {
        _joined.add(id);
        _joinedAny = true;
      });
      _toast('بقيت عضو في «${m['name']}» — تقدر تدخل شات المسجد دلوقتي 🤍');
    } catch (e) {
      _toast(masjidError(e));
    } finally {
      if (mounted) setState(() => _busy.remove(id));
    }
  }

  Future<void> _addMosque() async {
    if (!await _ensureSignedIn() || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddMosqueScreen(lat: _lat, lng: _lng)));
    // The creator is joined server-side.
    _joinedAny = true;
    _loadCandidates();
  }

  Widget _tile(Map<String, dynamic> m) {
    final id = m['id'] as String;
    final joined = _joined.contains(id) || m['is_member'] == true;
    final dist = (m['distance_m'] as num?) ?? (((m['distance_km'] as num?)?.toDouble() ?? -1) * 1000);
    final sub = [
      if (dist >= 0) formatMeters(dist),
      membersLabel(m['member_count'] as num?),
      if (m['area'] != null) m['area'],
    ].join(' • ');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: AppColors.night, child: Icon(Icons.mosque_rounded, color: AppColors.gold, size: 20)),
        title: Row(children: [
          Flexible(child: Text(m['name'] as String? ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))),
          if (m['verified'] == true) const Padding(padding: EdgeInsetsDirectional.only(start: 4), child: Icon(Icons.verified_rounded, color: AppColors.teal, size: 16)),
        ]),
        subtitle: Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5)),
        onTap: () => context.push(AppRoutes.mosque(id)),
        trailing: joined
            ? const Text('عضو ✓', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w800))
            : _busy.contains(id)
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : FilledButton(onPressed: () => _join(m), child: const Text('انضم')),
      ),
    );
  }

  Widget _header(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 16, 2, 8),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_joinedAny);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('انضم لمسجدك')),
        body: ListView(
          padding: EdgeInsets.fromLTRB(side, 12, side, 40),
          children: [
            const Text('انضم لمسجد حيّك وتابع مواعيده ودروسه، واتكلم مع جيرانك في شات المسجد.',
                style: TextStyle(color: AppColors.inkSecondary, fontSize: 12.5, height: 1.6)),
            const SizedBox(height: 12),
            TextField(
              controller: _search,
              onChanged: _onSearch,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'دوّر بالاسم أو المنطقة…'),
            ),
            if (_results != null) ...[
              _header('نتايج البحث'),
              if (_results!.isEmpty) const Text('مفيش مسجد بالاسم ده.', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
              for (final m in _results!) _tile(m),
            ],
            _header('مساجد في حدود $joinRadiusMeters متر منك'),
            if (_locating || _loading)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
            else if (_lat == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text(_locationFailed ? 'معرفناش نحدد مكانك — اسمح للموقع وجرّب تاني، أو دوّر بالاسم فوق.' : 'محتاجين مكانك عشان نوريك أقرب مساجد ليك.',
                        style: const TextStyle(fontSize: 12.5)),
                    const SizedBox(height: 8),
                    FilledButton.icon(onPressed: _locate, icon: const Icon(Icons.my_location_rounded), label: const Text('حدّد مكاني')),
                  ]),
                ),
              )
            else if (_error)
              TextButton(onPressed: _loadCandidates, child: const Text('تعذر التحميل — جرّب تاني'))
            else ...[
              if (_within.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    _beyond.isEmpty
                        ? 'مفيش مساجد مسجّلة قريب منك لسه — سجّل مسجدك تحت.'
                        : 'مفيش مسجد مسجّل في حدود $joinRadiusMeters متر منك. دي أقرب مساجد بعد كده:',
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ),
              for (final m in _within) _tile(m),
              for (final m in _beyond) _tile(m),
              if (_osmLoading) const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: LinearProgressIndicator()),
              if (_osm.isNotEmpty) ...[
                _header('مساجد قريبة على خريطة OpenStreetMap'),
                for (final o in _osm) _osmTile(o),
                const OsmAttribution(),
              ],
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _addMosque,
              icon: const Icon(Icons.add_location_alt_rounded),
              label: const Text('مسجدك مش موجود؟ سجّله'),
            ),
          ],
        ),
      ),
    );
  }
}
