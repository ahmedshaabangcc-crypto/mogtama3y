import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_logo.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

/// Entry point offering login vs. sign-up, reached from the guest home
/// screen's CTA and from the More menu when no one is signed in. Light
/// background matching the rest of the app (was solid navy), with the
/// real مُجتمعي logo instead of a generic apartment icon.
class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
          child: Column(
            children: [
              const Spacer(),
              const MogtamayLogo(size: 84),
              const SizedBox(height: 20),
              const Text('مُجتمعي', style: TextStyle(color: AppColors.ink, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('سجّل دخولك أو أنشئ حسابك لإدارة عمارتك وحيّك',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen())),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('متابعة التصفح كزائر', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
