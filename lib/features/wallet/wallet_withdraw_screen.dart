import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/wallet/wallet_service.dart';
import '../shared/load_error_view.dart';
import 'package:mogtama3y/core/utils/numbers.dart';

/// Manual withdrawal: the amount leaves the available balance right away
/// and the admin transfers it to the given mobile wallet (migration 0045).
class WalletWithdrawScreen extends StatefulWidget {
  const WalletWithdrawScreen({super.key});

  @override
  State<WalletWithdrawScreen> createState() => _WalletWithdrawScreenState();
}

class _WalletWithdrawScreenState extends State<WalletWithdrawScreen> {
  bool _loading = true;
  bool _loadError = false;
  double _available = 0;
  final _amountCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _submitting = false;
  bool _submitted = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final available = await WalletService.fetchAvailableBalance();
      if (!mounted) return;
      setState(() {
        _available = available;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  Future<void> _submit() async {
    final amount = looseDouble(_amountCtrl.text.trim());
    if (amount == null) {
      setState(() => _error = 'اكتب المبلغ المطلوب سحبه');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await WalletService.requestWithdrawal(amount: amount, payoutPhone: _phoneCtrl.text.trim());
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e is PostgrestException ? e.message : 'تعذر إرسال الطلب، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 11.5),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
      );

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError) {
      return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('سحب من المحفظة')), body: LoadErrorView(onRetry: _load));
    }
    if (_submitted) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('سحب من المحفظة')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: const Icon(Icons.schedule_send_rounded, color: AppColors.teal, size: 38),
              ),
            ),
            const SizedBox(height: 18),
            const Text('تم استلام طلب السحب', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'خُصم المبلغ من رصيدك المتاح، وسيُحوَّل إلى محفظتك يدوياً ويصلك إشعار عند التحويل. إذا رُفض الطلب يعود المبلغ لرصيدك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.8),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('رجوع للمحفظة', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سحب من المحفظة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const Expanded(child: Text('رصيدك المتاح للسحب', style: TextStyle(color: Colors.white70, fontSize: 12))),
              Text('${NumberFormat('#,##0.00').format(_available)} ج.م', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('المبلغ المطلوب (ج.م) *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: _decoration('أقل مبلغ 10 ج.م')),
          const SizedBox(height: 14),
          const Text('رقم محفظتك (فودافون كاش / إنستاباي) *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(controller: _phoneCtrl, keyboardType: TextInputType.phone, decoration: _decoration('01xxxxxxxxx')),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _submitting || _available < 10 ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.savings_outlined, size: 17),
              label: Text(_available < 10 ? 'رصيدك أقل من الحد الأدنى للسحب' : 'إرسال طلب السحب', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
