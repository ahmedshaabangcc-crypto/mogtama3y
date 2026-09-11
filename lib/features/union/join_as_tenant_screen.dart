import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import 'union_dashboard_screen.dart';

/// Redeems a tenant invite code from a unit's owner — see
/// backend/migrations/0018_tenant_accounts.sql. Unlike joining with a
/// building-wide code, this is verified instantly: the owner handing
/// over the code already vetted the tenant, so there's no separate
/// president/board review step.
class JoinAsTenantScreen extends StatefulWidget {
  const JoinAsTenantScreen({super.key});

  @override
  State<JoinAsTenantScreen> createState() => _JoinAsTenantScreenState();
}

class _JoinAsTenantScreenState extends State<JoinAsTenantScreen> {
  final _codeCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'أدخل كود الدعوة أولاً');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await UnionService.joinAsTenant(code: code);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const UnionDashboardScreen()));
    } catch (e) {
      setState(() => _error = e.toString().contains('كود')
          ? e.toString().replaceFirst('Exception: ', '')
          : 'تعذر التحقق من الكود، تأكد من صحته وحاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('الانضمام كمستأجر')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: const Text(
              'اطلب من مالك الشقة كود الدعوة الخاص بيها، وهتقدر بعد إدخاله تشوف وتدفع مستحقاتك وتتابع بوستات العمارة فوراً.',
              style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.8),
            ),
          ),
          const SizedBox(height: 20),
          const Text('كود دعوة المستأجر', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _codeCtrl,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.5),
            decoration: InputDecoration(
              hintText: 'TEN-XXXXXX',
              hintStyle: const TextStyle(color: AppColors.inkMuted, fontWeight: FontWeight.w400),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: _submitting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                  : const Text('تأكيد الانضمام', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
