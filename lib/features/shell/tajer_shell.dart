import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../merchant/merchant_dashboard_screen.dart';
import '../merchant/merchant_landing_screen.dart';

/// Home of the merchant app (APP_FLAVOR=tajer): the campaign page while
/// signed out, the merchant panel once signed in — the merchant never
/// lands in مُجتمعي.
class TajerShell extends StatelessWidget {
  const TajerShell({super.key, this.demoTab, this.demoAdd = false});

  /// Demo build only (`/?tab=…&add=1`): the panel tab to show, and whether
  /// to open «منتج جديد» right away.
  final int? demoTab;
  final bool demoAdd;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService.authStateChanges,
      builder: (context, _) => AuthService.isSignedIn
          ? MerchantDashboardScreen(key: ValueKey(AuthService.currentUser?.id), initialTab: demoTab, openAddProduct: demoAdd)
          : const MerchantLandingScreen(),
    );
  }
}
