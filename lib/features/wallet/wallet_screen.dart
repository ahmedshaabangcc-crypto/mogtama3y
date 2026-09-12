import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';

(IconData, String) _txMeta(String type) => switch (type) {
      'top_up' => (Icons.add_card_rounded, 'شحن رصيد المحفظة'),
      'maintenance_payment' => (Icons.receipt_long_rounded, 'سداد صيانة'),
      'union_dues' => (Icons.apartment_rounded, 'اشتراك اتحاد الملاك'),
      'marketplace_sale' => (Icons.sell_rounded, 'بيع في سوق المستعمل'),
      'marketplace_purchase' => (Icons.shopping_bag_rounded, 'شراء من سوق المستعمل'),
      'recycling_sale' => (Icons.recycling_rounded, 'أرباح بيكيا'),
      'withdrawal' => (Icons.savings_outlined, 'سحب أرباح'),
      'refund' => (Icons.replay_rounded, 'استرداد مبلغ'),
      'fee' => (Icons.percent_rounded, 'رسوم خدمة'),
      _ => (Icons.sync_alt_rounded, 'معاملة مالية'),
    };

String _statusLabel(String status) => switch (status) {
      'pending' => 'قيد الانتظار',
      'held' => 'محجوز بالضمان',
      'completed' => 'مكتمل',
      'reversed' => 'تم الاسترجاع',
      _ => status,
    };

String _formatDateTime(DateTime dt) {
  final local = dt.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '${local.day}/${local.month}/${local.year} - $h:$m';
}

String _formatAmount(double amount) {
  final formatted = NumberFormat('#,##0.00').format(amount.abs());
  final sign = amount >= 0 ? '+' : '-';
  return '$sign$formatted ج.م';
}

/// Digital wallet & transaction ledger — matches
/// design/screens/21_wallet_transactions.png, now backed by the real
/// `wallets` / `wallet_transactions` tables for the signed-in user.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _loading = true;
  double _available = 0;
  double _held = 0;
  List<Map<String, dynamic>> _transactions = [];
  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();
    _load();
    _authSub = AuthService.authStateChanges.listen((_) => _load());
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) {
      setState(() {
        _loading = false;
        _available = 0;
        _held = 0;
        _transactions = [];
      });
      return;
    }
    setState(() => _loading = true);
    final client = Supabase.instance.client;
    final userId = AuthService.currentUser!.id;
    final wallet = await client.from('wallets').select().eq('user_id', userId).maybeSingle();
    var txns = <Map<String, dynamic>>[];
    if (wallet != null) {
      final rows = await client
          .from('wallet_transactions')
          .select()
          .eq('wallet_id', wallet['id'] as String)
          .order('created_at', ascending: false)
          .limit(20);
      txns = List<Map<String, dynamic>>.from(rows as List);
    }
    if (!mounted) return;
    setState(() {
      _available = (wallet?['available_balance'] as num?)?.toDouble() ?? 0;
      _held = (wallet?['held_balance'] as num?)?.toDouble() ?? 0;
      _transactions = txns;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('المحفظة الرقمية وسجل المعاملات')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.navy.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.navy, size: 32),
                ),
                const SizedBox(height: 16),
                const Text('سجّل دخولك لعرض محفظتك', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('رصيدك وسجل معاملاتك المالية متاحة فقط بعد تسجيل الدخول',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text('تسجيل الدخول'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المحفظة الرقمية وسجل المعاملات')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.sync_alt_rounded, color: Colors.white, size: 16),
                    ),
                    const Spacer(),
                    const Text('الرصيد الكلي المتاح', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ]),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _loading ? '...' : '${NumberFormat('#,##0.00').format(_available)} ج.م',
                      style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                  ),
                  if (_held > 0) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        const Icon(Icons.lock_outline_rounded, color: AppColors.gold, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('مبلغ مُعلّق بالضمان الذكي', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        ),
                        Text('${NumberFormat('#,##0.00').format(_held)} ج.م',
                            style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13)),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(child: _QuickAction(icon: Icons.savings_outlined, label: 'سحب أرباح إلى حسابك البنكي')),
                SizedBox(width: 10),
                Expanded(child: _QuickAction(icon: Icons.sync_alt_rounded, label: 'تحويل لرئيس الاتحاد (اشتراك الصيانة)')),
                SizedBox(width: 10),
                Expanded(child: _QuickAction(icon: Icons.add_card_rounded, label: 'شحن المحفظة (InstaPay / كارت)')),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [
              const Expanded(child: Text('سجل المعاملات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              TextButton(onPressed: () {}, child: const Text('عرض الكشف الكامل', style: TextStyle(fontSize: 11.5))),
            ]),
            const SizedBox(height: 8),
            const _FilterChips(),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_transactions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.receipt_long_outlined, color: AppColors.inkMuted, size: 32),
                      const SizedBox(height: 8),
                      const Text('لا توجد معاملات مالية بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)),
                    ],
                  ),
                ),
              )
            else
              for (final t in _transactions) ...[
                _TransactionTile(row: t),
                const SizedBox(height: 10),
              ],
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
              child: Row(children: const [
                Icon(Icons.shield_outlined, size: 14, color: AppColors.inkMuted),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'جميع المعاملات المالية ومبالغ الضمان تخضع لرقابة مجلس إدارة اتحاد الملاك وحماية بموجب اللائحة الداخلية المعتمدة.',
                    style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted, height: 1.6),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.teal, size: 22),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1.4)),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل', 'اشتراك صيانة', 'حجز ضمان صيانة', 'عوائد بيكيا'];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.row});
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final amount = (row['amount'] as num).toDouble();
    final isCredit = amount >= 0;
    final (icon, title) = _txMeta(row['type'] as String? ?? '');
    final status = _statusLabel(row['status'] as String? ?? '');
    final createdAt = DateTime.tryParse(row['created_at'] as String? ?? '') ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isCredit ? AppColors.teal : AppColors.categorySos).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: isCredit ? AppColors.teal : AppColors.categorySos),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                Text(_formatDateTime(createdAt), style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_formatAmount(amount), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: isCredit ? AppColors.teal : AppColors.ink)),
              Text(status, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
