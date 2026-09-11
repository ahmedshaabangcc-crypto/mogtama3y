import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

const _tokenPriceEgp = 15;
const _minTokens = 5;

/// Request a manual token top-up: send via InstaPay/wallet, then upload
/// proof of payment for admin approval.
class TopUpTokensScreen extends StatefulWidget {
  const TopUpTokensScreen({super.key});

  @override
  State<TopUpTokensScreen> createState() => _TopUpTokensScreenState();
}

class _TopUpTokensScreenState extends State<TopUpTokensScreen> {
  int _tokens = _minTokens;
  bool _proofAttached = false;
  bool _submitted = false;

  int get _amountEgp => _tokens * _tokenPriceEgp;

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSubmitted(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('شحن رصيد التوكن')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text(
            'استخدم رصيد التوكن لتمييز إعلاناتك وظهورها أولاً لجيرانك. السعر الحالي 15 ج.م للتوكن الواحد.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
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
                    _StepperButton(
                      icon: Icons.remove_rounded,
                      onTap: _tokens > _minTokens ? () => setState(() => _tokens -= 5) : null,
                    ),
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
                  child: const Text('01050780807', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
                const SizedBox(height: 10),
                Row(children: const [
                  Icon(Icons.info_outline_rounded, size: 13, color: Colors.white70),
                  SizedBox(width: 6),
                  Expanded(child: Text('بعد التحويل، ارفع صورة إثبات الدفع تحت. رصيدك يُضاف بعد مراجعة واعتماد الإدارة يدوياً.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.6))),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('إثبات الدفع *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _proofAttached = true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _proofAttached ? AppColors.teal : AppColors.border, width: _proofAttached ? 1.5 : 1),
              ),
              child: Column(
                children: [
                  Icon(_proofAttached ? Icons.check_circle_rounded : Icons.upload_file_rounded, size: 32, color: _proofAttached ? AppColors.teal : AppColors.inkMuted),
                  const SizedBox(height: 8),
                  Text(
                    _proofAttached ? 'تم إرفاق إيصال التحويل' : 'اضغط لرفع لقطة شاشة الإيصال',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: _proofAttached ? AppColors.teal : AppColors.inkSecondary),
                  ),
                  const SizedBox(height: 3),
                  const Text('JPG, PNG (حد أقصى 10 ميجابايت)', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _proofAttached ? () => setState(() => _submitted = true) : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.send_rounded, size: 17),
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
            'تم استلام طلب شحن $_tokens توكن ($_amountEgp ج.م) وإثبات الدفع. سيتم مراجعته واعتماده يدوياً وإضافة الرصيد لحسابك خلال ساعات قليلة.',
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
