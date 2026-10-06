import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/people/people_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/places/places_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/location/where.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'people_widgets.dart';

/// "ناس حواليك" — the people tab of the Discover screen. Visibility is
/// opt-in: others only ever see name, photo, area and a rough distance.
class NearbyPeopleTab extends StatefulWidget {
  const NearbyPeopleTab({super.key});

  @override
  State<NearbyPeopleTab> createState() => _NearbyPeopleTabState();
}

class _NearbyPeopleTabState extends State<NearbyPeopleTab> {
  bool _loading = true;
  bool _loadError = false;
  String? _locationError;
  bool _discoverable = false;
  bool _toggling = false;
  Position? _position;
  List<Map<String, dynamic>> _people = [];
  final Set<String> _busy = {};
  late final StreamSubscription<AuthState> _authSub;
  bool _signedIn = AuthService.isSignedIn;

  @override
  void initState() {
    super.initState();
    if (_signedIn) _start();
    // Coming back from the login screen: start the tab.
    _authSub = AuthService.authStateChanges.listen((_) {
      if (!mounted || AuthService.isSignedIn == _signedIn) return;
      setState(() => _signedIn = AuthService.isSignedIn);
      if (_signedIn) _start();
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  Future<Position> _getPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'شغّل خدمة الموقع (GPS) عشان نعرض الناس اللي حواليك';
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw 'محتاجين إذن الموقع عشان نعرض الناس القريبين منك';
    }
    return Where.current();
  }

  Future<String?> _area(Position p) async {
    try {
      return await PlacesService.resolveAreaLabel(lat: p.latitude, lng: p.longitude);
    } catch (_) {
      return null;
    }
  }

  Future<void> _start() async {
    setState(() {
      _loading = true;
      _loadError = false;
      _locationError = null;
    });
    try {
      final presence = await PeopleService.myPresence();
      if (!mounted) return;
      _discoverable = presence['discoverable'] == true;
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
      return;
    }
    try {
      _position = await _getPosition();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _locationError = e is String ? e : 'تعذر تحديد موقعك';
      });
      return;
    }
    // Keep my rough position fresh while I'm visible.
    final p = _position!;
    if (_discoverable) {
      try {
        await PeopleService.setDiscoverable(true, lat: p.latitude, lng: p.longitude, area: await _area(p));
      } catch (_) {}
    }
    await _load();
  }

  Future<void> _load() async {
    final p = _position;
    if (p == null) return;
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final people = await PeopleService.nearby(lat: p.latitude, lng: p.longitude);
      if (!mounted) return;
      setState(() {
        _people = people;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  Future<void> _toggle(bool on) async {
    setState(() => _toggling = true);
    try {
      if (on) {
        final p = _position ?? await _getPosition();
        _position = p;
        await PeopleService.setDiscoverable(true, lat: p.latitude, lng: p.longitude, area: await _area(p));
      } else {
        await PeopleService.setDiscoverable(false);
      }
      if (!mounted) return;
      setState(() {
        _discoverable = on;
        _toggling = false;
        _locationError = null;
      });
      if (on) showPeopleSnack(context, 'إنت ظاهر دلوقتي للناس اللي حواليك');
      if (on && _people.isEmpty) await _load();
    } catch (e) {
      if (!mounted) return;
      setState(() => _toggling = false);
      showPeopleSnack(context, e is String ? e : peopleError(e));
    }
  }

  void _setState(String userId, String state) {
    setState(() {
      for (final p in _people) {
        if (p['user_id'] == userId) p['state'] = state;
      }
    });
  }

  Future<void> _act(String userId, Future<void> Function() action) async {
    setState(() => _busy.add(userId));
    try {
      await action();
    } catch (e) {
      if (mounted) showPeopleSnack(context, peopleError(e));
    } finally {
      if (mounted) setState(() => _busy.remove(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_signedIn) return _signInPrompt();
    return RefreshIndicator(
      onRefresh: _position == null ? _start : _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 24),
        children: [
          _visibilityCard(),
          const SizedBox(height: 12),
          ..._list(),
        ],
      ),
    );
  }

  Widget _signInPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.people_alt_rounded, size: 40, color: AppColors.inkMuted),
          const SizedBox(height: 10),
          const Text('سجّل دخولك عشان تشوف الناس اللي حواليك وتضيف أصحاب',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary, height: 1.6)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
            child: const Text('تسجيل الدخول'),
          ),
        ]),
      ),
    );
  }

  Widget _visibilityCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.visibility_rounded, color: AppColors.teal, size: 20),
          const SizedBox(width: 8),
          const Expanded(child: Text('اظهر للناس اللي حواليك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
          if (_toggling)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            Switch(value: _discoverable, onChanged: _toggle),
        ]),
        const Text('بيظهر اسمك وصورتك ومنطقتك ومسافة تقريبية بس — موقعك بالظبط عمره ما بيظهر لحد.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted, height: 1.5)),
      ]),
    );
  }

  List<Widget> _list() {
    if (_locationError != null) {
      return [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Icon(Icons.location_off_rounded, size: 40, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            Text(_locationError!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSecondary, height: 1.6)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _start, child: const Text('حاول تاني')),
          ]),
        ),
      ];
    }
    if (_loading) return const [Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))];
    if (_loadError) return [LoadErrorView(onRetry: _start, message: 'تعذر تحميل الناس اللي حواليك')];
    if (_people.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(32),
          child: Text('مفيش حد ظاهر حواليك لسه — فعّل الظهور وادعي جيرانك',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6)),
        ),
      ];
    }
    return [
      for (final p in _people) ...[_personCard(p), const SizedBox(height: 10)],
    ];
  }

  Widget _personCard(Map<String, dynamic> p) {
    final id = p['user_id'] as String;
    final name = p['full_name'] as String? ?? 'جار';
    final meta = [p['area'], p['distance_label']].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        PersonAvatar(name: name, url: p['avatar_url'] as String?),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PersonName(name: name, verified: p['is_verified'] == true),
            if (meta.isNotEmpty) Text(meta, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
          ]),
        ),
        _actionButton(id, p['state'] as String? ?? 'none'),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: AppColors.inkMuted),
          onSelected: (v) async {
            if (v == 'block') {
              if (await confirmAndBlock(context, id, name) && mounted) {
                setState(() => _people.removeWhere((x) => x['user_id'] == id));
              }
            } else if (v == 'report') {
              await reportPerson(context, id, name);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'block', child: Text('حظر')),
            PopupMenuItem(value: 'report', child: Text('إبلاغ')),
          ],
        ),
      ]),
    );
  }

  Widget _actionButton(String id, String state) {
    if (_busy.contains(id)) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    const small = VisualDensity.compact;
    switch (state) {
      case 'sent':
        return Row(mainAxisSize: MainAxisSize.min, children: [
          const OutlinedButton(onPressed: null, style: ButtonStyle(visualDensity: small), child: Text('اتبعت الطلب', style: TextStyle(fontSize: 11.5))),
          IconButton(
            tooltip: 'إلغاء الطلب',
            visualDensity: small,
            icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.inkMuted),
            onPressed: () => _act(id, () async {
              await PeopleService.remove(id);
              _setState(id, 'none');
            }),
          ),
        ]);
      case 'received':
        return FilledButton(
          style: const ButtonStyle(visualDensity: small),
          onPressed: () => _act(id, () async {
            await PeopleService.respond(id, accept: true);
            _setState(id, 'friends');
          }),
          child: const Text('قبول', style: TextStyle(fontSize: 12)),
        );
      case 'friends':
        return OutlinedButton.icon(
          style: const ButtonStyle(visualDensity: small),
          onPressed: () => context.push(AppRoutes.chat(id)),
          icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
          label: const Text('رسالة', style: TextStyle(fontSize: 12)),
        );
      default:
        return FilledButton.icon(
          style: const ButtonStyle(visualDensity: small),
          onPressed: () => _act(id, () async {
            final newState = await PeopleService.sendRequest(id);
            _setState(id, newState);
          }),
          icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
          label: const Text('أضف صديق', style: TextStyle(fontSize: 12)),
        );
    }
  }
}
