import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../merchant/merchant_landing_screen.dart';

/// Home of the merchant app (APP_FLAVOR=tajer): the campaign page while
/// signed out. Signed in, the router sends `/` to the admin (`/dashboard`,
/// see tajer_routes.dart) — this only covers the moment before it does.
class TajerShell extends StatelessWidget {
  const TajerShell({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthService.authStateChanges,
      builder: (context, _) {
        if (!AuthService.isSignedIn) return const MerchantLandingScreen();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go('/dashboard');
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
