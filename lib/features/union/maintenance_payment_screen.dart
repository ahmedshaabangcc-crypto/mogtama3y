import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/auth/auth_service.dart';
import '../../core/dues/dues_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';

/// Monthly maintenance-dues payment — matches
/// design/screens/11_maintenance_payment.png, now backed by real
/// union_dues and paid atomically from the real wallet.
class MaintenancePaymentScreen extends StatefulWidget {
  const MaintenancePaymentScreen({super.key});

  @override
  State<MaintenancePaymentScreen> createState() => _MaintenancePaymentScreenState();
}

class _MaintenancePaymentScreenState extends State<MaintenancePaymentScreen> {
  int _method = 0;
  bool _loading = true;
  bool _paying = false;
  bool _canIssue = false;
  Map<String, dynamic>? _due;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final due = await DuesService.fetchMyOutstandingDue();
    final canIssue = await DuesService.canIssueDues();
    if (!mounted) return;
    setState(() {
      _due = due;
      _canIssue = canIssue;
      _loading = false;
    });
  }

  Future<void> _pay() async {
    final due = _due;
    if (due == null || _method != 0) return;
    setState(() {
      _paying = true;
      _error = null;
    });
    try {
      await DuesService.payDue(due['id'] as String);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString().contains('رصيد')
          ? 'رصيد محفظتك غير كافٍ لسداد هذا المستحق.'
          : 'تعذر السداد، حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  Future<void> _showIssueDuesDialog() async {
    final periodCtrl = TextEditingController(text: 'اشتراك صيانة');
    final amountCtrl = TextEditingController(text: '350');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إصدار مستحقات صيانة جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: periodCtrl, decoration: const InputDecoration(labelText: 'الوصف (مثال: اشتراك صيانة مارس)')),
            const SizedBox(height: 10),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ لكل وحدة (ج.م)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('إصدار للجميع')),
        ],
      ),
    );
    if (result != true) return;
    final amount = double.tryParse(amountCtrl.text.trim());
    if (amount == null || amount <= 0) return;
    try {
      final count = await DuesService.issueDuesForBuilding(
        periodLabel: periodCtrl.text.trim(),
        amount: amount,
        dueDate: DateTime.now().add(const Duration(days: 14)),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم إصدار المستحق لـ $count وحدة سكنية')));
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إصدار المستحقات')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('سداد رسوم صيانة العمارة')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
            child: const Text('سجّل دخولك لعرض مستحقاتك'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('سداد رسوم صيانة العمارة'),
        actions: [
          if (_canIssue)
            IconButton(
              onPressed: _showIssueDuesDialog,
              icon: const Icon(Icons.add_circle_outline_rounded),
              tooltip: 'إصدار مستحقات جديدة',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _due == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.task_alt_rounded, color: AppColors.teal, size: 40),
                        const SizedBox(height: 12),
                        const Text('لا توجد مستحقات صيانة عليك حالياً', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        if (_canIssue) ...[
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showIssueDuesDialog,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                            label: const Text('إصدار مستحقات صيانة جديدة'),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(_due!['period_label'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                              child: const Text('مستحق الآن', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
                            ),
                          ]),
                          if (_due!['due_date'] != null) ...[
                            const SizedBox(height: 6),
                            Text('تاريخ الاستحقاق: ${_due!['due_date']}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                          ],
                          const Divider(height: 26, color: AppColors.border),
                          Row(children: [
                            const Text('المبلغ المستحق', style: TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
                            const Spacer(),
                            Text('${NumberFormat('#,##0.00').format(_due!['amount'])} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.teal)),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('اختر وسيلة الدفع المناسبة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                    const SizedBox(height: 10),
                    _PaymentTile(
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'محفظة مُجتمعي الرقمية',
                      subtitle: 'سداد فوري من رصيدك الحالي',
                      selected: _method == 0,
                      onTap: () => setState(() => _method = 0),
                    ),
                    const SizedBox(height: 8),
                    _PaymentTile(
                      icon: Icons.credit_card_rounded,
                      title: 'بطاقة بنكية (قريباً)',
                      subtitle: 'الدفع بالبطاقات لسه مش متاح',
                      selected: _method == 1,
                      enabled: false,
                      onTap: () => setState(() => _method = 1),
                    ),
                    const SizedBox(height: 8),
                    _PaymentTile(
                      icon: Icons.phone_android_rounded,
                      title: 'فوري / المحافظ الإلكترونية (قريباً)',
                      subtitle: 'التكامل مع فوري لسه مش متاح',
                      selected: _method == 2,
                      enabled: false,
                      onTap: () => setState(() => _method = 2),
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
                  ],
                ),
      bottomSheet: (_loading || _due == null)
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: (_method == 0 && !_paying) ? _pay : null,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    icon: _paying
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                        : const Icon(Icons.lock_outline_rounded, size: 17),
                    label: Text(
                      _due == null ? '' : 'سداد ${NumberFormat('#,##0.00').format(_due!['amount'])} ج.م',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap, this.enabled = true});
  final IconData icon;
  final String title, subtitle;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
          ),
          child: Row(children: [
            Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, size: 18, color: selected ? AppColors.teal : AppColors.inkMuted),
            const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: AppColors.inkSecondary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text(subtitle, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
