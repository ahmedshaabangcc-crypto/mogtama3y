import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/auth_text_field.dart';

/// «نسيت كلمة المرور؟» — sends a reset link to the email; the link opens
/// this same app, which then shows [SetNewPasswordScreen].
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail});
  final String? initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final _emailCtrl = TextEditingController(text: widget.initialEmail ?? '');
  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _emailCtrl.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _error = 'أدخل بريداً إلكترونياً صحيحاً');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await AuthService.sendPasswordReset(email);
      if (mounted) setState(() => _sent = true);
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _error = e.statusCode == '429' || e.message.contains('rate')
            ? 'طلبت رابط كتير ورا بعض — استنى دقيقة وجرّب تاني.'
            : 'تعذر إرسال الرابط، تأكد من البريد وحاول تاني.');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر إرسال الرابط، تحقق من الاتصال وحاول تاني.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('نسيت كلمة المرور')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
              child: Icon(_sent ? Icons.mark_email_read_outlined : Icons.lock_reset_rounded, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 16),
            if (_sent) ...[
              const Text('بعتنالك رابط على بريدك', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'افتح الرسالة اللي وصلت على ${_emailCtrl.text.trim()} واضغط على الرابط من نفس الموبايل/المتصفح ده، وهتقدر تكتب كلمة مرور جديدة.\n\nلو مش لاقي الرسالة بص في الـ Spam.',
                style: const TextStyle(fontSize: 13, color: AppColors.inkSecondary, height: 1.8),
              ),
              const SizedBox(height: 20),
              OutlinedButton(onPressed: _sending ? null : _send, child: const Text('ابعت الرابط تاني')),
            ] else ...[
              const Text('هنبعتلك رابط تغيّر بيه كلمة المرور', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('اكتب البريد الإلكتروني اللي عملت بيه حسابك.', style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
              const SizedBox(height: 20),
              const AuthFieldLabel('البريد الإلكتروني'),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                onSubmitted: (_) => _send(),
                decoration: authInputDecoration(hint: 'example@email.com', icon: Icons.email_outlined),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12.5)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _sending ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _sending
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                      : const Text('ابعت رابط تغيير كلمة المرور', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Opened when the app starts from a password-recovery link (route
/// /reset-password, pushed on AuthChangeEvent.passwordRecovery).
class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _pwCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _saving = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _pwCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final pw = _pwCtrl.text;
    if (pw.length < 6) {
      setState(() => _error = 'كلمة المرور 6 أحرف على الأقل');
      return;
    }
    if (pw != _confirmCtrl.text) {
      setState(() => _error = 'كلمتين المرور مش زي بعض');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await AuthService.updatePassword(pw);
      AuthService.passwordRecovery.value = false;
      if (mounted) setState(() => _done = true);
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _error = e.message.contains('different from the old')
            ? 'اختار كلمة مرور مختلفة عن القديمة'
            : 'تعذر حفظ كلمة المرور، اطلب رابط جديد وحاول تاني.');
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر حفظ كلمة المرور، تحقق من الاتصال وحاول تاني.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSession = AuthService.isSignedIn;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('كلمة مرور جديدة')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          children: [
            if (_done) ...[
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 64),
              const SizedBox(height: 12),
              const Text('اتغيّرت كلمة المرور ✓', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('إنت داخل بحسابك دلوقتي، والمرة الجاية ادخل بكلمة المرور الجديدة.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: () => context.go('/'), child: const Text('كمّل للتطبيق')),
            ] else if (!hasSession) ...[
              const Icon(Icons.link_off_rounded, color: AppColors.inkMuted, size: 56),
              const SizedBox(height: 12),
              const Text('الرابط ده مش شغال', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('ممكن يكون انتهى أو اتفتح من جهاز أو متصفح غير اللي طلبته منه. اطلب رابط جديد وافتحه من نفس الجهاز.',
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSecondary, height: 1.7)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                child: const Text('اطلب رابط جديد'),
              ),
            ] else ...[
              const Text('اكتب كلمة مرور جديدة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(AuthService.currentUser?.email ?? '', textDirection: TextDirection.ltr, style: const TextStyle(color: AppColors.inkMuted)),
              const SizedBox(height: 20),
              const AuthFieldLabel('كلمة المرور الجديدة'),
              const SizedBox(height: 6),
              TextField(
                controller: _pwCtrl,
                obscureText: _obscure,
                decoration: authInputDecoration(
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  suffix: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const AuthFieldLabel('أكّد كلمة المرور'),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmCtrl,
                obscureText: _obscure,
                onSubmitted: (_) => _save(),
                decoration: authInputDecoration(hint: '••••••••', icon: Icons.lock_outline_rounded),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12.5)),
              ],
              const SizedBox(height: 22),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _saving
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                      : const Text('احفظ كلمة المرور', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
