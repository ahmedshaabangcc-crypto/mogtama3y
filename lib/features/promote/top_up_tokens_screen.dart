import 'package:flutter/material.dart';

import '../../core/promote/ad_token_service.dart';
import '../../core/theme/app_colors.dart';

const _minTokens = 5;

/// Request a real manual token top-up — see
/// backend/migrations/0026_ad_tokens.sql. No file/image upload exists
/// anywhere in this app yet, so "proof" here is a short typed
/// reference (transaction id, sender name) rather than a screenshot —
/// honest and fully functional today; swap in real upload later.
class TopUpTokensScreen extends StatefulWidget {
  const TopUpTokensScreen({super.key});

  @override
  State<TopUpTokensScreen> createState() => _TopUpTokensScreenState();
}

class _TopUpTokensScreenState extends State<TopUpTokensScreen> {
  bool _loading = true;
  int _tokens = _minTokens;
  double _tokenPrice = 15;
  String _phone = '01050780807';
  final _proofCtrl = TextEditingController();
  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  int get _amountEgp => (_tokens * _tokenPrice).round();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _proofCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final settings = await AdTokenService.fetchSettings();
    if (!mounted) return;
    setState(() {
      _tokenPrice = (settings['token_price_egp'] as num?)?.toDouble() ?? 15;
      _phone = settings['topup_phone'] as String? ?? _phone;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    if (_proofCtrl.text.trim().isEmpty) {
      setState(() => _error = 'اكتب رقم العملية أو تفاصيل التحويل أولاً');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await AdTokenService.requestTopup(tokens: _tokens, proofNote: _proofCtrl.text.trim());
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (_) {
      setState(() => _error = 'تعذر إرسال الطلب، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_submitted) return _buildSubmitted(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('شحن رصيد التوكن')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Text(
            'استخدم رصيد التوكن لتمييز إعلاناتك وظهورها أولاً لجيرانك. السعر الحالي ${_tokenPrice.toStringAsFixed(0)} ج.م للتوكن الواحد.',
            style: const TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 18),
          const Text('اختر عدد التوكنات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StepperButton(icon: Icons.remove_rounded, onTap: _tokens > _minTokens ? () => setState(() => _tokens -= 5) : null),
                    SizedBox(
                      width: 120,
                      child: Column(
                        children: [
                          Text('$_tokens', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 32)),
                          const Text('توكن', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    _StepperButton(icon: Icons.add_rounded, onTap: () => setState(() => _tokens += 5)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('الحد الأدنى 5 توكن (75 ج.م) • بمضاعفات 5', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                const Divider(height: 28, color: AppColors.border),
                Row(children: [
                  const Text('المبلغ المطلوب تحويله', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                  const Spacer(),
                  Text('$_amountEgp ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.teal)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.qr_code_2_rounded, color: AppColors.gold, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text('طريقة التحويل', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ]),
                const SizedBox(height: 12),
                const Text('حوّل المبلغ عبر إنستاباي أو أي محفظة إلكترونية على الرقم:', style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.7)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: Text(_phone, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
                const SizedBox(height: 10),
                const Row(children: [
                  Icon(Icons.info_outline_rounded, size: 13, color: Colors.white70),
                  SizedBox(width: 6),
                  Expanded(child: Text('بعد التحويل، اكتب تفاصيل العملية تحت. رصيدك يُضاف بعد مراجعة واعتماد الإدارة يدوياً.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.6))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('تفاصيل التحويل *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _proofCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'مثال: تحويل InstaPay رقم 123456 باسم أحمد',
              hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 11.5),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded, size: 17),
              label: const Text('إرسال طلب الشحن للمراجعة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitted(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('طلب الشحن')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: const Icon(Icons.hourglass_top_rounded, color: AppColors.gold, size: 38),
            ),
          ),
          const SizedBox(height: 18),
          const Text('طلبك قيد المراجعة', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'تم استلام طلب شحن $_tokens توكن ($_amountEgp ج.م). سيتم مراجعته واعتماده يدوياً وإضافة الرصيد لحسابك خلال ساعات قليلة.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('رجوع لمحفظة التوكن', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: enabled ? AppColors.surfaceAlt : AppColors.surfaceAlt.withValues(alpha: 0.4), shape: BoxShape.circle),
        child: Icon(icon, color: enabled ? AppColors.inkSecondary : AppColors.inkMuted, size: 20),
      ),
    );
  }
}
