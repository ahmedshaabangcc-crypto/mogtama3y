import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../legal/terms_conditions_screen.dart';
import 'login_screen.dart';
import 'widgets/auth_text_field.dart';

/// Real Supabase email/password sign-up. Creates the `profiles` +
/// `wallets` rows for the new account (see AuthService).
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _agreedToTerms = false;
  bool _loading = false;
  bool _confirmationSent = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _googleLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    try {
      await AuthService.signInWithGoogle();
    } catch (e) {
      if (mounted) setState(() => _error = 'تعذر بدء التسجيل بجوجل: $e');
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(() => _error = 'يجب الموافقة على الشروط والأحكام وميثاق الجيران أولاً.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final signedInImmediately = await AuthService.signUpWithEmail(
        fullName: _nameCtrl.text,
        phone: _phoneCtrl.text,
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (!mounted) return;
      if (signedInImmediately) {
        Navigator.of(context).popUntil((r) => r.isFirst);
      } else {
        setState(() => _confirmationSent = true);
      }
    } on AuthException catch (e) {
      setState(() => _error = _mapError(e.message));
    } catch (e) {
      setState(() => _error = 'حدث خطأ غير متوقع: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapError(String raw) {
    if (raw.contains('User already registered')) return 'هذا البريد الإلكتروني مسجل بالفعل، جرّب تسجيل الدخول.';
    if (raw.contains('Password should be')) return 'كلمة المرور ضعيفة جداً، اختر كلمة مرور أقوى.';
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmationSent) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('إنشاء حساب جديد')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.mark_email_read_outlined, color: AppColors.teal, size: 34),
                ),
                const SizedBox(height: 18),
                const Text('تحقق من بريدك الإلكتروني', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('أرسلنا رابط تفعيل إلى ${_emailCtrl.text.trim()}، افتحه لتفعيل حسابك ثم سجّل دخولك.',
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.inkMuted, height: 1.7)),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('الذهاب لتسجيل الدخول', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          children: [
            const Text('انضم إلى مُجتمعي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('أنشئ حسابك أولاً، وبعدها اربطه بعمارتك ووحدتك السكنية',
                style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
            const SizedBox(height: 22),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthFieldLabel('الاسم الكامل'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: authInputDecoration(hint: 'مثال: أحمد شعبان', icon: Icons.person_outline_rounded),
                    validator: (v) => (v == null || v.trim().length < 3) ? 'أدخل اسمك الكامل' : null,
                  ),
                  const SizedBox(height: 14),
                  const AuthFieldLabel('رقم الهاتف'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: authInputDecoration(hint: '01xxxxxxxxx', icon: Icons.phone_outlined),
                    validator: (v) => (v == null || v.trim().length < 10) ? 'أدخل رقم هاتف صحيح' : null,
                  ),
                  const SizedBox(height: 14),
                  const AuthFieldLabel('البريد الإلكتروني'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: authInputDecoration(hint: 'example@email.com', icon: Icons.email_outlined),
                    validator: (v) => (v == null || !v.contains('@')) ? 'أدخل بريداً إلكترونياً صحيحاً' : null,
                  ),
                  const SizedBox(height: 14),
                  const AuthFieldLabel('كلمة المرور'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: authInputDecoration(
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'كلمة المرور 6 أحرف على الأقل' : null,
                  ),
                  const SizedBox(height: 14),
                  const AuthFieldLabel('تأكيد كلمة المرور'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscure,
                    decoration: authInputDecoration(hint: '••••••••', icon: Icons.lock_outline_rounded),
                    validator: (v) => (v != _passwordCtrl.text) ? 'كلمتا المرور غير متطابقتين' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              borderRadius: BorderRadius.circular(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                    activeColor: AppColors.teal,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6),
                          children: [
                            const TextSpan(text: 'أوافق على '),
                            TextSpan(
                              text: 'الشروط والأحكام وميثاق الجيران',
                              style: const TextStyle(color: AppColors.teal, fontWeight: FontWeight.w700),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TermsConditionsScreen())),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              _ErrorBanner(text: _error!),
            ],
            const SizedBox(height: 18),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _loading
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                    : const Text('إنشاء الحساب', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 18),
            Row(children: const [
              Expanded(child: Divider(color: AppColors.border)),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('أو', style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5))),
              Expanded(child: Divider(color: AppColors.border)),
            ]),
            const SizedBox(height: 18),
            SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _googleLoading ? null : _signInWithGoogle,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                icon: _googleLoading
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.g_mobiledata_rounded, size: 26),
                label: const Text('المتابعة بحساب جوجل', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('لديك حساب بالفعل؟ تسجيل الدخول', style: TextStyle(fontSize: 12.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.redAccent, fontSize: 12))),
      ]),
    );
  }
}
