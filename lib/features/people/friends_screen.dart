import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/people/people_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../discover/discover_nearby_screen.dart';
import '../shared/load_error_view.dart';
import 'people_widgets.dart';

/// "أصحابي والرسائل" — incoming requests, friends (with the latest
/// message and an unread badge) and requests I sent.
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _rows = [];
  final Set<String> _busy = {};
  late final StreamSubscription<AuthState> _authSub;
  bool _signedIn = AuthService.isSignedIn;

  @override
  void initState() {
    super.initState();
    if (_signedIn) _load();
    _authSub = AuthService.authStateChanges.listen((_) {
      if (!mounted || AuthService.isSignedIn == _signedIn) return;
      setState(() => _signedIn = AuthService.isSignedIn);
      if (_signedIn) _load();
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final rows = await PeopleService.myFriends();
      if (!mounted) return;
      setState(() {
        _rows = rows;
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

  Future<void> _act(String userId, Future<void> Function() action) async {
    setState(() => _busy.add(userId));
    try {
      await action();
      await _load();
    } catch (e) {
      if (mounted) showPeopleSnack(context, peopleError(e));
    } finally {
      if (mounted) setState(() => _busy.remove(userId));
    }
  }

  Future<void> _openChat(String userId) async {
    await context.push(AppRoutes.chat(userId));
    if (mounted) _load(); // unread counts changed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('أصحابي والرسائل'),
        actions: [
          IconButton(
            tooltip: 'ناس حواليك',
            icon: const Icon(Icons.person_search_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiscoverNearbyScreen(showPeople: true))),
          ),
        ],
      ),
      body: Padding(padding: EdgeInsets.symmetric(horizontal: peopleSidePadding(context)), child: _body()),
    );
  }

  Widget _body() {
    if (!_signedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.forum_rounded, size: 40, color: AppColors.inkMuted),
            const SizedBox(height: 10),
            const Text('سجّل دخولك عشان تشوف أصحابك ورسايلك',
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
    if (_loading && _rows.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_loadError) return LoadErrorView(onRetry: _load, message: 'تعذر تحميل أصحابك');

    final received = _rows.where((r) => r['state'] == 'received').toList();
    final friends = _rows.where((r) => r['state'] == 'friends').toList();
    final sent = _rows.where((r) => r['state'] == 'sent').toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
        children: [
          if (received.isNotEmpty) ...[
            _label('طلبات صداقة جاية ليك (${received.length})'),
            for (final r in received) _tile(r, trailing: _receivedActions(r)),
            const SizedBox(height: 14),
          ],
          _label('أصحابي'),
          if (friends.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(children: [
                const Text('لسه معندكش أصحاب هنا — دوّر على جيرانك في "ناس حواليك"',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, height: 1.6)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiscoverNearbyScreen(showPeople: true))),
                  icon: const Icon(Icons.person_search_rounded, size: 18),
                  label: const Text('ناس حواليك'),
                ),
              ]),
            )
          else
            for (final r in friends) _friendTile(r),
          if (sent.isNotEmpty) ...[
            const SizedBox(height: 14),
            _label('طلبات بعتها'),
            for (final r in sent)
              _tile(r,
                  subtitle: 'مستني الرد',
                  trailing: _busyOr(
                    r['user_id'] as String,
                    TextButton(
                      onPressed: () => _act(r['user_id'] as String, () => PeopleService.remove(r['user_id'] as String)),
                      child: const Text('إلغاء'),
                    ),
                  )),
          ],
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 2),
        child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted, fontWeight: FontWeight.w700)),
      );

  Widget _busyOr(String id, Widget child) => _busy.contains(id)
      ? const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
        )
      : child;

  Widget _receivedActions(Map<String, dynamic> r) {
    final id = r['user_id'] as String;
    return _busyOr(
      id,
      Row(mainAxisSize: MainAxisSize.min, children: [
        FilledButton(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: () => _act(id, () => PeopleService.respond(id, accept: true)),
          child: const Text('قبول', style: TextStyle(fontSize: 12)),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: () => _act(id, () => PeopleService.respond(id, accept: false)),
          child: const Text('رفض', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
        ),
      ]),
    );
  }

  Widget _tile(Map<String, dynamic> r, {String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    final name = r['full_name'] as String? ?? 'جار';
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        tileColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
        leading: PersonAvatar(name: name, url: r['avatar_url'] as String?),
        title: PersonName(name: name, verified: r['is_verified'] == true, fontSize: 13),
        subtitle: subtitle == null
            ? null
            : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
        trailing: trailing,
      ),
    );
  }

  Widget _friendTile(Map<String, dynamic> r) {
    final id = r['user_id'] as String;
    final unread = (r['unread'] as num?)?.toInt() ?? 0;
    final last = r['last_message'] as String?;
    return _tile(
      r,
      subtitle: last == null || last.isEmpty ? 'ابدأ المحادثة' : last,
      onTap: () => _openChat(id),
      trailing: unread > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(100)),
              child: Text(unread > 99 ? '99+' : '$unread', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
            )
          : const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
    );
  }
}
