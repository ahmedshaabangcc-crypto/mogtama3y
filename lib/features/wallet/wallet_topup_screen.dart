import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/wallet/wallet_service.dart';
import '../shared/load_error_view.dart';

/// Manual wallet top-up: transfer to the platform's mobile wallet, then
/// file the transfer reference for admin approval (migration 0045).
class WalletTopUpScreen extends StatefulWidget {
  const WalletTopUpScreen({super.key});

  @override
  State<WalletTopUpScreen> createState() => _WalletTopUpScreenState();
}

class _WalletTopUpScreenState extends State<WalletTopUpScreen> {
  bool _loading = true;
  bool _loadError = false;
  String _phone = '';
  final _amountCtrl = TextEditingController();
  final _proofCtrl = TextEditingController();
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
    _proofCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final phone = await WalletService.fetchTransferPhone();
      if (!mounted) return;
      setState(() {
        _phone = phone ?? '';
        // Never show a transfer screen without the real number.
        _loadError = _phone.isEmpty;
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
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null) {
      setState(() => _error = 'اكتب المبلغ الذي حوّلته');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await WalletService.requestTopup(amount: amount, proofNote: _proofCtrl.text.trim());
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
      return Scaffold(backgroundColor: AppColors.bg, appBar: AppBar(title: const Text('شحن المحفظة')), body: LoadErrorView(onRetry: _load));
    }
    if (_submitted) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('شحن المحفظة')),
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
            const Text(
              'بعد التأكد من وصول التحويل سيُضاف المبلغ لرصيدك ويصلك إشعار بذلك.',
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
      appBar: AppBar(title: const Text('شحن المحفظة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1. حوّل المبلغ عبر فودافون كاش أو إنستاباي على الرقم:', style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.7)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                  child: SelectableText(_phone, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ),
                const SizedBox(height: 10),
                const Text('2. اكتب المبلغ وتفاصيل التحويل بالأسفل، وسيُضاف الرصيد بعد مراجعة الإدارة.', style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.6)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('المبلغ الذي حوّلته (ج.م) *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: _decoration('مثال: 500')),
          const SizedBox(height: 14),
          const Text('تفاصيل التحويل *', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(controller: _proofCtrl, maxLines: 2, decoration: _decoration('مثال: فودافون كاش من الرقم 010xxxxxxxx — رقم العملية 123456')),
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
}
