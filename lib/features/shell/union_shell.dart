import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../lost_found/lost_found_hub_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../sos/sos_emergency_screen.dart';
import '../union/union_dashboard_screen.dart';
import '../union/union_landing_screen.dart';
import '../shared/made_by_apex.dart';

/// Shell of the separate owners'-union app (APP_FLAVOR=ittihad): only
/// building governance, plus a permanent "اذهب إلى مُجتمعي" button.
class UnionShell extends StatefulWidget {
  const UnionShell({super.key});

  @override
  State<UnionShell> createState() => _UnionShellState();
}

class _UnionShellState extends State<UnionShell> {
  int _index = 0;
  String? _userId = AuthService.currentUser?.id;
  late final StreamSubscription<AuthState> _authSub;

  static const _pages = [
    _UnionHome(),
    SosEmergencyScreen(),
    LostFoundHubScreen(),
    NotificationsScreen(),
    UnionMoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Rebuild every tab when the signed-in account changes (see AppShell).
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
      body: Stack(
        children: [
          KeyedSubtree(key: ValueKey(_userId), child: IndexedStack(index: _index, children: _pages)),
          const Positioned(bottom: 16, left: 16, child: GoToMogtama3yButton()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apartment_rounded), label: 'عمارتي'),
          BottomNavigationBarItem(icon: Icon(Icons.sos_rounded), label: 'الطوارئ'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_search_rounded), label: 'المفقودات'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none_rounded), label: 'الإشعارات'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'المزيد'),
        ],
      ),
    );
  }
}

/// Signed out → the union campaign page; signed in → the union dashboard
/// (which itself asks non-members to found or join their building).
class _UnionHome extends StatelessWidget {
  const _UnionHome();

  @override
  Widget build(BuildContext context) => AuthService.isSignedIn ? const UnionDashboardScreen() : const UnionLandingScreen();
}

/// Gold pill that opens مُجتمعي (same account; the other site may ask to
/// sign in once since each domain keeps its own session).
class GoToMogtama3yButton extends StatelessWidget {
  const GoToMogtama3yButton({super.key, this.expanded = false});
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.night,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () => launchUrl(Uri.parse(mogtama3yUrl), webOnlyWindowName: '_self'),
      icon: const Icon(Icons.travel_explore_rounded, size: 18),
      label: const Text('اذهب إلى مُجتمعي'),
    );
    return expanded ? SizedBox(width: double.infinity, height: 52, child: button) : button;
  }
}

class UnionMoreScreen extends StatelessWidget {
  const UnionMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String title, VoidCallback onTap) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(leading: Icon(icon, color: AppColors.crystal), title: Text(title), trailing: const Icon(Icons.chevron_left_rounded), onTap: onTap),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('المزيد')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          if (AuthService.isSignedIn)
            tile(Icons.person_outline_rounded, 'حسابي', () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen())))
          else
            tile(Icons.login_rounded, 'سجّل دخول أو اعمل حساب',
                () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()))),
          tile(Icons.account_balance_wallet_outlined, 'المحفظة والمستحقات', () => context.go(AppRoutes.wallet)),
          tile(Icons.support_agent_rounded, 'الدعم والمساعدة', () => context.go(AppRoutes.support)),
          tile(Icons.help_outline_rounded, 'الأسئلة الشائعة', () => context.go(AppRoutes.faq)),
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
}
