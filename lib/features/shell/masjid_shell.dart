import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/masjid/masjid_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../masjid/masjid_home_screen.dart';
import '../masjid_tools/masjid_tools_entry.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../shared/made_by_apex.dart';
import '../shared/push_opt_in.dart';
import '../tutorials/tutorial_widgets.dart';
import '../union/union_home_link.dart';
import 'union_shell.dart' show GoToMogtama3yButton;

/// Shell of the separate «مسجدي» app (APP_FLAVOR=masjid): mosques & prayer
/// times, notifications, and «المزيد» with a way back to مُجتمعي.
class MasjidShell extends StatefulWidget {
  const MasjidShell({super.key});

  @override
  State<MasjidShell> createState() => _MasjidShellState();
}

class _MasjidShellState extends State<MasjidShell> {
  int _index = 0;
  String? _userId = AuthService.currentUser?.id;
  late final StreamSubscription<AuthState> _authSub;

  static const _pages = [MasjidHomeScreen(), NotificationsScreen(), MasjidMoreScreen()];

  @override
  void initState() {
    super.initState();
    _authSub = AuthService.authStateChanges.listen((_) {
      final userId = AuthService.currentUser?.id;
      if (userId != _userId && mounted) setState(() => _userId = userId);
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyedSubtree(key: ValueKey(_userId), child: IndexedStack(index: _index, children: _pages)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.mosque_rounded), label: 'المساجد'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: 'الإشعارات'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}

class MasjidMoreScreen extends StatelessWidget {
  const MasjidMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String title, VoidCallback onTap) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(leading: Icon(icon, color: AppColors.crystal), title: Text(title), trailing: const Icon(Icons.chevron_left_rounded), onTap: onTap),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('المزيد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          const PushOptInCard(text: 'فعّل الإشعارات عشان توصلك إعلانات مسجدك والدروس وصلاة الجنازة فوراً.'),
          const DailyToolsStrip(dark: false, title: 'أدوات يومية'),
          const SizedBox(height: 12),
          tile(Icons.home_rounded, 'الصفحة الرئيسية لمسجدي', openUnionHome),
          if (AuthService.isSignedIn)
            tile(Icons.person_outline_rounded, 'حسابي', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())))
          else
            tile(Icons.login_rounded, 'سجّل دخول أو اعمل حساب', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()))),
          if (AuthService.isSignedIn) tile(Icons.volunteer_activism_rounded, 'كفالاتي', () => _mySponsorships(context)),
          const TutorialVideosSection(padding: EdgeInsets.only(top: 4, bottom: 14)),
          tile(Icons.support_agent_rounded, 'الدعم والمساعدة', () => context.go(AppRoutes.support)),
          tile(Icons.gavel_rounded, 'الشروط والأحكام', () => context.go(AppRoutes.terms)),
          tile(Icons.privacy_tip_outlined, 'سياسة الخصوصية', () => context.go(AppRoutes.privacy)),
          if (AuthService.isSignedIn) tile(Icons.logout_rounded, 'تسجيل الخروج', AuthService.signOut),
          const SizedBox(height: 18),
          const GoToMogtama3yButton(expanded: true),
          const SizedBox(height: 8),
          const Text('نفس حسابك بيشتغل على مُجتمعي: سوق الجيران والمحلات والصيانة وأكتر.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5)),
          const SizedBox(height: 12),
          const MadeByApex(dark: false),
        ],
      ),
    );
  }

  static Future<void> _mySponsorships(BuildContext context) async {
    List<Map<String, dynamic>> rows = [];
    try {
      rows = await MasjidService.mySponsorships();
    } catch (_) {}
    if (!context.mounted) return;
    const labels = {'pledged': 'مستني تأكيد المسجد', 'active': 'كفالة مؤكدة ✓', 'ended': 'انتهت', 'cancelled': 'اتلغت'};
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(16), children: [
          const Text('كفالاتي', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          if (rows.isEmpty) const Padding(padding: EdgeInsets.all(16), child: Text('لسه مسجّلتش في أي كفالة.')),
          for (final r in rows)
            ListTile(
              title: Text('${r['title']} — ${r['mosque_name']}'),
              subtitle: Text('${masjidAmount(r['monthly_amount'] as num?, r['currency'] as String?)} شهرياً • ${labels[r['status']] ?? ''}'),
              onTap: () {
                Navigator.pop(ctx);
                context.push(AppRoutes.mosque(r['mosque_id'] as String));
              },
            ),
        ]),
      ),
    );
  }
}
