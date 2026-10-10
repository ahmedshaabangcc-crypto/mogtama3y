import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/location/where.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'add_mosque_screen.dart';
import 'join_mosque_screen.dart';
import '../../core/masjid/masjid_live.dart';
import 'masjid_community_widgets.dart';
import 'masjid_live_widgets.dart';
import 'masjid_widgets.dart';

/// «المساجد» — the masjid app's home and the mosques section of مُجتمعي.
/// Top to bottom: «انضم لمسجدك» (until the user belongs to a mosque; then
/// their mosques with the chat shortcut + unread badge and a smaller «انضم
/// لمسجد تاني»), the «أدوات يومية» row, today's prayer times, «قريب منك»
/// (lessons, needs, competitions, janaza near you), then search, the
/// mosques they manage / follow and the nearest mosques.
class MasjidHomeScreen extends StatefulWidget {
  const MasjidHomeScreen({super.key});

  @override
  State<MasjidHomeScreen> createState() => _MasjidHomeScreenState();
}

class _MasjidHomeScreenState extends State<MasjidHomeScreen> {
  // Cairo (Tahrir) until the device gives a location.
  static const _cairo = (30.0444, 31.2357);

  double _lat = _cairo.$1;
  double _lng = _cairo.$2;
  bool _located = false;
  bool _locating = true;

  List<Map<String, dynamic>> _nearby = [];
  List<Map<String, dynamic>> _followed = [];
  List<Map<String, dynamic>> _managed = [];
  List<Map<String, dynamic>> _mine = [];
  bool _mineLoaded = false;
  List<Map<String, dynamic>> _feed = [];
  bool _feedLoading = true;
  List<Map<String, dynamic>> _live = [];
  List<Map<String, dynamic>>? _results;
  bool _loadingNearby = true;
  bool _nearbyError = false;

  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _locate();
    _loadMine();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      final Position p = await Where.current();
      if (!mounted) return;
      setState(() {
        _lat = p.latitude;
        _lng = p.longitude;
        _located = true;
      });
    } catch (_) {
      // Keep Cairo; the card says so.
    } finally {
      if (mounted) setState(() => _locating = false);
    }
    _loadNearby();
    _loadFeed();
    _loadLive();
  }

  /// «دروس أونلاين» (0085): live now + this week, near you and in your mosques.
  Future<void> _loadLive() async {
    try {
      final rows = await MasjidService.liveFeed(lat: _located ? _lat : null, lng: _located ? _lng : null);
      if (mounted) setState(() => _live = rows..sort(compareLive));
    } catch (_) {
      // The section just stays hidden.
    }
  }

  void _openLiveList() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LiveLessonsScreen(lat: _located ? _lat : null, lng: _located ? _lng : null)));

  Future<void> _loadFeed() async {
    setState(() => _feedLoading = true);
    try {
      final rows = await MasjidService.nearbyFeed(lat: _located ? _lat : null, lng: _located ? _lng : null);
      if (mounted) setState(() => _feed = rows);
    } catch (_) {
      // The section just stays empty.
    } finally {
      if (mounted) setState(() => _feedLoading = false);
    }
  }

  Future<void> _loadNearby() async {
    setState(() {
      _loadingNearby = true;
      _nearbyError = false;
    });
    try {
      var rows = await MasjidService.nearby(_lat, _lng, km: 3);
      if (rows.length < 5) rows = await MasjidService.nearby(_lat, _lng, km: 15);
      if (!mounted) return;
      setState(() => _nearby = rows);
    } catch (_) {
      if (mounted) setState(() => _nearbyError = true);
    } finally {
      if (mounted) setState(() => _loadingNearby = false);
    }
  }

  Future<void> _loadMine() async {
    if (!AuthService.isSignedIn) {
      if (mounted) setState(() => _mineLoaded = true);
      return;
    }
    try {
      final results = await Future.wait([MasjidService.myMosques(), MasjidService.followed(), MasjidService.managed()]);
      if (!mounted) return;
      setState(() {
        _mine = results[0];
        _followed = results[1];
        _managed = results[2];
      });
    } catch (_) {
      // Keep what we had.
    } finally {
      if (mounted) setState(() => _mineLoaded = true);
    }
  }

  Future<void> _openJoin() async {
    await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const JoinMosqueScreen()));
    if (!mounted) return;
    await _loadMine();
    _loadFeed();
    _loadLive();
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
        final rows = await MasjidService.search(text, lat: _located ? _lat : null, lng: _located ? _lng : null);
        if (mounted && _search.text.trim() == text) setState(() => _results = rows);
      } catch (_) {
        if (mounted) setState(() => _results = const []);
      }
    });
  }

  Future<void> _addMosque() async {
    if (!AuthService.isSignedIn) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
      if (!AuthService.isSignedIn || !mounted) return;
    }
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddMosqueScreen(lat: _located ? _lat : null, lng: _located ? _lng : null)));
    _loadNearby();
    _loadMine();
  }

  Widget _header(String text, {Widget? trailing}) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 18, 2, 8),
        child: Row(children: [
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16))),
          ?trailing,
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final side = width > 760 ? (width - 720) / 2 : 16.0;
    return Scaffold(
      backgroundColor: AppColors.night,
      appBar: AppBar(
        backgroundColor: AppColors.night,
        foregroundColor: Colors.white,
        title: Text(isMasjidApp ? 'مسجدي — كل مساجد حيّك' : 'المساجد'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _locate();
          await _loadMine();
        },
        child: ListView(
          padding: EdgeInsets.fromLTRB(side, 8, side, 100),
          children: [
            // 1. «انضم لمسجدك» / my mosques — always first.
            if (_mineLoaded && _mine.isEmpty)
              JoinMosqueCta(onTap: _openJoin)
            else if (_mine.isNotEmpty) ...[
              _header(_mine.length == 1 ? 'مسجدي' : 'مساجدي'),
              for (final m in _mine) MyMosqueCard(mosque: m, onChanged: _loadMine),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: _openJoin,
                  icon: const Icon(Icons.add_rounded, color: AppColors.gold, size: 18),
                  label: const Text('انضم لمسجد تاني', style: TextStyle(color: AppColors.gold, fontSize: 12.5)),
                ),
              ),
            ],
            // 2. «أدوات يومية» — slot for the daily tools (lib/features/masjid_tools/).
            const SizedBox(height: 12),
            const DailyToolsRow(),
            const SizedBox(height: 8),
            // 3. Prayer times.
            PrayerTimesCard(
              lat: _lat,
              lng: _lng,
              title: _located ? 'مواقيت الصلاة في مكانك النهارده' : 'مواقيت الصلاة (القاهرة) النهارده',
            ),
            if (!_located && !_locating)
              TextButton.icon(
                onPressed: _locate,
                icon: const Icon(Icons.my_location_rounded, color: AppColors.gold, size: 18),
                label: const Text('فعّل الموقع لمواقيت منطقتك وأقرب مسجد', style: TextStyle(color: AppColors.gold)),
              ),
            // 4. «دروس أونلاين» — live now / this week.
            if (_live.isNotEmpty) ...[
              _header(_live.any((s) => liveIsLive(s, DateTime.now())) ? 'دروس أونلاين دلوقتي' : 'دروس أونلاين جاية',
                  trailing: _live.length > 3
                      ? TextButton(onPressed: _openLiveList, child: Text('الكل (${_live.length})', style: const TextStyle(color: AppColors.gold, fontSize: 12)))
                      : null),
              for (final s in _live.take(3)) LiveLessonCard(session: s),
            ],
            // 5. «قريب منك».
            _header('قريب منك'),
            if (_feedLoading)
              const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
            else if (_feed.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.glassBorder)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const Text('لسه مفيش دروس أو احتياجات أو مسابقات منشورة في المساجد اللي حواليك.',
                      style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.6)),
                  const SizedBox(height: 4),
                  const Text('انضم لمسجدك وادعو جيرانك وإمام المسجد — أول ما الإدارة تتوثق هتلاقي كل جديد هنا.',
                      style: TextStyle(color: Colors.white54, fontSize: 11.5, height: 1.6)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    if (_mine.isEmpty)
                      OutlinedButton(onPressed: _openJoin, child: const Text('انضم لمسجدك', style: TextStyle(color: AppColors.gold)))
                    else ...[
                      OutlinedButton(
                        onPressed: () => inviteNeighbours(_mine.first['id'] as String, _mine.first['name'] as String? ?? ''),
                        child: const Text('ادعو جيرانك', style: TextStyle(color: AppColors.gold)),
                      ),
                      if (_mine.first['verified'] != true)
                        OutlinedButton(
                          onPressed: () => inviteImam(_mine.first['id'] as String, _mine.first['name'] as String? ?? ''),
                          child: const Text('ادعو إمام مسجدك', style: TextStyle(color: AppColors.gold)),
                        ),
                    ],
                  ]),
                ]),
              )
            else
              for (final item in _feed) NearbyFeedCard(item: item),
            const SizedBox(height: 14),
            TextField(
              controller: _search,
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'دوّر على مسجد بالاسم أو المنطقة…',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.08),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            if (_results != null) ...[
              _header('نتايج البحث'),
              if (_results!.isEmpty)
                const Text('مفيش مسجد بالاسم ده. جرّب اسم تاني أو ضيف المسجد.', style: TextStyle(color: Colors.white60, fontSize: 12.5)),
              for (final m in _results!) MosqueTile(mosque: m),
            ],
            if (_managed.isNotEmpty) ...[
              _header('مساجد بتديرها'),
              for (final m in _managed)
                MosqueTile(
                  mosque: m,
                  trailing: Text(m['verified'] == true ? (m['role'] == 'owner' ? 'مسؤول' : 'مساعد') : 'مستني التوثيق',
                      style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary)),
                ),
            ],
            if (_followed.isNotEmpty) ...[
              _header('مساجد بتتابعها'),
              for (final m in _followed) MosqueTile(mosque: m),
            ],
            _header(_located ? 'أقرب مساجد ليك' : 'مساجد قريبة',
                trailing: TextButton(onPressed: _addMosque, child: const Text('مسجدك مش موجود؟', style: TextStyle(color: AppColors.gold, fontSize: 12)))),
            if (_loadingNearby)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
            else if (_nearbyError)
              TextButton(onPressed: _loadNearby, child: const Text('تعذر التحميل — جرّب تاني', style: TextStyle(color: Colors.white70)))
            else if (_nearby.isEmpty)
              const Text('مفيش مساجد مسجلة قريب منك لسه — ضيف مسجدك.', style: TextStyle(color: Colors.white60, fontSize: 12.5))
            else
              for (final m in _nearby.take(15)) MosqueTile(mosque: m),
            _header('جديد وجاي قريب'),
            IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(
                  child: ComingSoonTile(
                    icon: Icons.record_voice_over_rounded,
                    title: 'المحفّظ',
                    subtitle: 'سمّع القرآن من حفظك والمحفّظ يقولك كل كلمة صح ولا غلط',
                    badge: 'جديد',
                    onTap: () => context.push(AppRoutes.masjidToolsTutor),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ComingSoonTile(
                    icon: Icons.live_tv_rounded,
                    title: 'دروس أونلاين',
                    subtitle: _live.any((s) => liveIsLive(s, DateTime.now()))
                        ? 'فيه درس مباشر دلوقتي — ادخل واسمع'
                        : 'دروس المسجد مباشرة من موبايلك — صوت بس أو صوت وصورة',
                    badge: 'جديد',
                    onTap: _openLiveList,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            const Text(
              'إمام أو خطيب أو أمين مسجد؟ افتح صفحة مسجدك واضغط «أنا مسؤول عن المسجد ده» عشان تنشر المواعيد والإعلانات والاحتياجات.',
              style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
