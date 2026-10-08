import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

import '../../core/auth/auth_service.dart';
import '../../core/rooms/rooms_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../profile/phone_verify_screen.dart';
import '../shared/load_error_view.dart';
import 'room_widgets.dart';

/// «غرف الدردشة» (route `/rooms`) — public rooms by area and topic, most
/// active first, with the live "online now" count. Guests can browse and
/// read; writing needs a verified phone and a room nickname.
class RoomsHomeScreen extends StatefulWidget {
  const RoomsHomeScreen({super.key});

  @override
  State<RoomsHomeScreen> createState() => _RoomsHomeScreenState();
}

class _RoomsHomeScreenState extends State<RoomsHomeScreen> {
  bool _loading = true;
  bool _error = false;
  List<Map<String, dynamic>> _rooms = [];
  Map<String, dynamic>? _me;
  String _filter = 'all';
  Timer? _refresh;
  late final StreamSubscription<AuthState> _authSub;
  bool _signedIn = AuthService.isSignedIn;

  @override
  void initState() {
    super.initState();
    _load();
    _refresh = Timer.periodic(const Duration(seconds: 30), (_) => _load(quiet: true));
    _authSub = AuthService.authStateChanges.listen((_) {
      if (!mounted || AuthService.isSignedIn == _signedIn) return;
      _signedIn = AuthService.isSignedIn;
      _load();
    });
  }

  @override
  void dispose() {
    _refresh?.cancel();
    _authSub.cancel();
    super.dispose();
  }

  Future<void> _load({bool quiet = false}) async {
    if (!quiet) {
      setState(() {
        _loading = true;
        _error = false;
      });
    }
    try {
      final rooms = await RoomsService.rooms();
      Map<String, dynamic>? me;
      if (AuthService.isSignedIn) {
        try {
          me = await RoomsService.myProfile();
        } catch (_) {}
      }
      if (!mounted) return;
      setState(() {
        _rooms = rooms;
        _me = me;
        _loading = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted || quiet) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Map<String, dynamic>? get _nearest {
    final near = _rooms.where((r) => ((r['near'] as num?) ?? 0) > 0).toList()
      ..sort((a, b) => (a['near'] as num).compareTo(b['near'] as num));
    return near.isEmpty ? null : near.first;
  }

  Future<void> _verifyPhone() async {
    final ok = await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const PhoneVerifyScreen()));
    if (ok == true) _load(quiet: true);
  }

  Future<void> _pickNickname() async {
    final saved = await pickRoomNickname(context, current: _me?['nickname'] as String?);
    if (saved != null && mounted) {
      showRoomSnack(context, 'اسمك في الغرف: $saved');
      _load(quiet: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final side = roomSidePadding(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('غرف الدردشة'),
        actions: [
          if (_signedIn && _me?['nickname'] != null)
            TextButton.icon(
              onPressed: _pickNickname,
              icon: const Icon(Icons.badge_outlined, size: 18),
              label: Text(_me!['nickname'] as String, overflow: TextOverflow.ellipsis),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error
              ? LoadErrorView(onRetry: _load, message: 'تعذر تحميل الغرف')
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(side, 12, side, 24),
                    children: [
                      _statusCard(),
                      if (_nearest != null) ...[
                        const SizedBox(height: 14),
                        const Text('أقرب غرفة لمنطقتك', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                        const SizedBox(height: 8),
                        _roomTile(_nearest!, highlight: true),
                      ],
                      const SizedBox(height: 14),
                      Wrap(spacing: 8, children: [
                        for (final (key, label) in const [('all', 'الكل'), ('area', 'مناطق'), ('topic', 'مواضيع')])
                          ChoiceChip(label: Text(label), selected: _filter == key, onSelected: (_) => setState(() => _filter = key)),
                      ]),
                      const SizedBox(height: 10),
                      for (final r in _rooms.where((r) => _filter == 'all' || r['kind'] == _filter)) ...[
                        _roomTile(r),
                        const SizedBox(height: 8),
                      ],
                      if (_rooms.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('مفيش غرف دلوقتي', style: TextStyle(color: AppColors.inkMuted))),
                        ),
                      const SizedBox(height: 8),
                      const Text(
                        'الغرف عامة وأي حد يقدر يقرا. احترم الناس: الشتيمة والسبام والإعلانات ممنوعة، وأي رسالة 3 أشخاص يبلّغوا عنها بتستخبى لحد ما الإدارة تراجعها.',
                        style: TextStyle(fontSize: 11, color: AppColors.inkMuted, height: 1.6),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _statusCard() {
    String text;
    String? action;
    VoidCallback? onTap;
    if (!_signedIn) {
      text = 'تقدر تقرا الغرف كضيف. سجّل دخولك عشان تكتب وتتعرف على ناس من منطقتك.';
      action = 'تسجيل الدخول';
      onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
    } else if (_me?['phone_verified'] != true) {
      text = 'أكّد رقمك عشان تكتب في الغرف — كل اللي بيكتبوا أرقامهم متأكدة، عشان الغرف تفضل محترمة.';
      action = 'أكّد رقمك';
      onTap = _verifyPhone;
    } else if (_me?['nickname'] == null) {
      text = 'اختار اسمك في الغرف. اسمك الحقيقي مش هيظهر لحد.';
      action = 'اختار اسمك';
      onTap = _pickNickname;
    } else {
      text = 'أهلاً ${_me!['nickname']}! ادخل أي غرفة وابدأ الكلام.';
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(gradient: AppColors.brandGradient, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const Text('💬', style: TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12.5, height: 1.55, fontWeight: FontWeight.w600))),
        if (action != null) ...[
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.navy),
            child: Text(action),
          ),
        ],
      ]),
    );
  }

  Widget _roomTile(Map<String, dynamic> r, {bool highlight = false}) {
    final online = (r['online_count'] as num?)?.toInt() ?? 0;
    final recent = (r['recent_count'] as num?)?.toInt() ?? 0;
    final subtitle = (r['description'] as String?) ?? '';
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push(AppRoutes.room(r['id'] as String)).then((_) => _load(quiet: true)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: highlight ? AppColors.gold : AppColors.border, width: highlight ? 1.5 : 1),
          ),
          child: Row(children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.surfaceAlt,
              child: Text((r['icon'] as String?) ?? '💬', style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: online > 0 ? AppColors.success : AppColors.inkMuted, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(online > 0 ? '$online موجود دلوقتي' : 'مفيش حد دلوقتي',
                      style: TextStyle(fontSize: 11, color: online > 0 ? AppColors.success : AppColors.inkMuted, fontWeight: FontWeight.w700)),
                  if (recent > 0) ...[
                    const SizedBox(width: 10),
                    Text('$recent رسالة آخر ساعة', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                  ],
                ]),
              ]),
            ),
            const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
          ]),
        ),
      ),
    );
  }
}
