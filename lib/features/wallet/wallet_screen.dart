import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../support/support_contact_screen.dart';

enum _TxnKind { earning, payment, escrowHold }

class _Transaction {
  const _Transaction({required this.kind, required this.title, required this.subtitle, required this.amount, required this.status, required this.icon});
  final _TxnKind kind;
  final String title, subtitle, amount, status;
  final IconData icon;
}

const _transactions = [
  _Transaction(
    kind: _TxnKind.earning,
    title: 'أرباح بيع خردة بيكيا',
    subtitle: 'مزاد البرج التشاركي • اليوم، 11:15 ص',
    amount: '+450.00 ج.م',
    status: 'مكتمل',
    icon: Icons.recycling_rounded,
  ),
  _Transaction(
    kind: _TxnKind.payment,
    title: 'سداد صيانة شهر مارس',
    subtitle: 'اشتراك البرج الشهري • 1 مارس',
    amount: '-350.00 ج.م',
    status: 'سدد',
    icon: Icons.receipt_long_rounded,
  ),
  _Transaction(
    kind: _TxnKind.escrowHold,
    title: 'حجز ضمان في سباكة الثقة',
    subtitle: 'معاق بالضمان الذكي • أحمد السباك',
    amount: '-120.00 ج.م',
    status: 'تحرير العملية',
    icon: Icons.lock_outline_rounded,
  ),
];

/// Digital wallet & transaction ledger — matches
/// design/screens/21_wallet_transactions.png.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المحفظة الرقمية وسجل المعاملات')),
      body: ListView(
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
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('2,450.00 ج.م', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    const Icon(Icons.lock_outline_rounded, color: AppColors.gold, size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('مبلغ مُعلّق بالضمان الذكي', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          Text('معلق في الصيانة - سباكة المطبخ', style: TextStyle(color: Colors.white70, fontSize: 9)),
                        ],
                      ),
                    ),
                    const Text('180.00 ج.م', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                ),
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.recycling_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('أرباحك الشاركية هذا الشهر', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                    Text('مبيعات بيكيا وخدمات ...', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('+1,200 ج.م', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.teal)),
                  Text('+24%', style: TextStyle(fontSize: 10, color: AppColors.teal)),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.apartment_rounded, color: AppColors.inkMuted),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مبادرة التدوير الذاتي للبرج', style: TextStyle(fontSize: 9.5, color: AppColors.gold, fontWeight: FontWeight.w700)),
                    Text('مُجمّع خردة أكتوبر النشط', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    Text('تمت مشاركة العوائد المالية بالتساوي مع صندوق ...', style: TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('سجل المعاملات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            TextButton(onPressed: () {}, child: const Text('عرض الكشف الكامل', style: TextStyle(fontSize: 11.5))),
          ]),
          const SizedBox(height: 8),
          const _FilterChips(),
          const SizedBox(height: 12),
          for (final t in _transactions) ...[
            _TransactionTile(txn: t),
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
                  'جميع المعاملات المالية ومبالغ الضمان تخضع لرقابة مجلس إدارة اتحاد ملاك برج الياسمين وحماية بموجب اللائحة الداخلية المعتمدة.',
                  style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted, height: 1.6),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportContactScreen())),
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
              child: const Icon(Icons.support_agent_rounded, color: AppColors.inkSecondary, size: 20),
            ),
            title: const Text('الدعم والمساعدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            subtitle: const Text('تواصل مع فريق علاقات السكان', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.inkMuted),
          ),
        ],
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
  const _TransactionTile({required this.txn});
  final _Transaction txn;

  bool get _isCredit => txn.amount.startsWith('+');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (_isCredit ? AppColors.teal : AppColors.categorySos).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(txn.icon, size: 18, color: _isCredit ? AppColors.teal : AppColors.categorySos),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                Text(txn.subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(txn.amount, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _isCredit ? AppColors.teal : AppColors.ink)),
              Text(txn.status, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
