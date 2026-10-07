import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_service.dart';
import '../../core/demo/demo_boot.dart';
import '../../core/demo/demo_mode.dart';
import '../../core/demo/demo_store.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/fund_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'dues_status_screen.dart';

String fundMoney(num n) {
  final neg = n < 0;
  final s = n.abs().round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '${neg ? '-' : ''}$buf ج.م';
}

String fundDate(String? iso) {
  final d = DateTime.tryParse(iso ?? '')?.toLocal();
  if (d == null) return '';
  return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
}

String errorText(Object e, String fallback) => e is PostgrestException ? e.message : fallback;

const _typeLabels = {
  'due_payment': ('سداد من المحفظة', Icons.account_balance_wallet_outlined),
  'cash_due': ('سداد كاش', Icons.payments_outlined),
  'expense': ('مصروف', Icons.receipt_long_outlined),
  'withdrawal': ('سحب من الصندوق', Icons.outbox_rounded),
  'adjustment': ('تسوية', Icons.tune_rounded),
};

/// «صندوق العمارة» — balance, ledger and the manager's actions (expense
/// with receipt, mark cash, request withdrawal). Manager = treasurer, or
/// the president when there is no treasurer; president/board read only.
/// See backend/migrations/0076_union_fund_treasurer.sql.
class UnionFundScreen extends StatefulWidget {
  const UnionFundScreen({super.key});

  @override
  State<UnionFundScreen> createState() => _UnionFundScreenState();
}

class _UnionFundScreenState extends State<UnionFundScreen> {
  bool _loading = true;
  bool _loadError = false;
  String? _buildingId;
  bool _canView = false;
  bool _isManager = false;
  Map<String, dynamic>? _summary;
  Map<String, dynamic>? _rate;
  List<Map<String, dynamic>> _ledger = [];
  List<Map<String, dynamic>> _withdrawals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final membership = await UnionService.fetchMyMembership();
      final buildingId = membership?['status'] == 'verified' ? membership!['building_id'] as String? : null;
      var canView = false, isManager = false;
      Map<String, dynamic>? summary, rate;
      var ledger = <Map<String, dynamic>>[], withdrawals = <Map<String, dynamic>>[];
      if (buildingId != null) {
        canView = await FundService.canView(buildingId);
        rate = await FundService.fetchCollectionRate(buildingId);
        if (canView) {
          final r = await Future.wait([
            FundService.isManager(buildingId),
            FundService.fetchSummary(buildingId),
            FundService.fetchLedger(buildingId),
            FundService.fetchWithdrawalRequests(buildingId),
          ]);
          isManager = r[0] as bool;
          summary = r[1] as Map<String, dynamic>;
          ledger = r[2] as List<Map<String, dynamic>>;
          withdrawals = r[3] as List<Map<String, dynamic>>;
        }
      }
      if (!mounted) return;
      setState(() {
        _buildingId = buildingId;
        _canView = canView;
        _isManager = isManager;
        _summary = summary;
        _rate = rate;
        _ledger = ledger;
        _withdrawals = withdrawals;
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

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _recordExpense() async {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    XFile? receipt;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('سجّل مصروف', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'المبلغ (ج.م)')),
            const SizedBox(height: 8),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'اتصرف على إيه؟ (مثال: تغيير لمبات السلم)')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                final f = await UploadService.pickImage(source: ImageSource.gallery);
                if (f != null) setSheet(() => receipt = f);
              },
              icon: Icon(receipt == null ? Icons.add_a_photo_outlined : Icons.check_circle_rounded, size: 18),
              label: Text(receipt == null ? 'صورة الإيصال (اختياري)' : 'تم إرفاق الإيصال ✓'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              child: const Text('سجّل المصروف'),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
    if (saved != true) return;
    final amount = double.tryParse(amountCtrl.text.trim());
    if (amount == null || amount <= 0 || noteCtrl.text.trim().length < 3) {
      _toast('اكتب المبلغ وسبب المصروف');
      return;
    }
    try {
      await FundService.recordExpense(buildingId: _buildingId!, amount: amount, note: noteCtrl.text.trim(), receipt: receipt);
      _toast('اتسجّل المصروف واتخصم من الصندوق');
      _load();
    } catch (e) {
      _toast(errorText(e, 'تعذّر تسجيل المصروف'));
    }
  }

  Future<void> _markCash() async {
    List<Map<String, dynamic>> rows;
    try {
      rows = (await FundService.fetchDuesStatus(_buildingId!)).where((r) => r['due_id'] != null && r['is_paid'] != true).toList();
    } catch (e) {
      _toast(errorText(e, 'تعذّر تحميل المستحقات'));
      return;
    }
    if (!mounted) return;
    if (rows.isEmpty) {
      _toast('مفيش مستحقات متأخرة في الفترة الحالية 👌');
      return;
    }
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(16), children: [
          const Text('علّم دفع كاش — اختار الشقة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          for (final r in rows)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.door_front_door_outlined),
              title: Text('شقة ${r['unit_number'] ?? ''} — ${r['period_label'] ?? ''}'),
              subtitle: Text((r['residents'] as String?) ?? 'مفيش سكان مسجّلين'),
              trailing: Text(fundMoney((r['amount'] as num?) ?? 0), style: const TextStyle(fontWeight: FontWeight.w700)),
              onTap: () => Navigator.of(context).pop(r),
            ),
        ]),
      ),
    );
    if (picked == null || !mounted) return;
    await confirmMarkCash(context, picked);
    _load();
  }

  Future<void> _requestWithdrawal() async {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    var toWallet = true;
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('اطلب سحب من الصندوق', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 4),
            const Text('إدارة مُجتمعي بتراجع الطلب وتحوّل المبلغ، والصندوق بيتخصم منه بعد التحويل بس.',
                style: TextStyle(fontSize: 11, color: AppColors.inkMuted, height: 1.6)),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'المبلغ (ج.م)')),
            const SizedBox(height: 8),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'السبب (مثال: أجرة الكهربائي)')),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              ChoiceChip(label: const Text('على محفظتي في مُجتمعي'), selected: toWallet, onSelected: (_) => setSheet(() => toWallet = true)),
              ChoiceChip(label: const Text('تحويل على رقم محفظة موبايل'), selected: !toWallet, onSelected: (_) => setSheet(() => toWallet = false)),
            ]),
            const SizedBox(height: 8),
            if (!toWallet)
              TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم المحفظة (01xxxxxxxxx)')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              child: const Text('ابعت الطلب'),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
    if (saved != true) return;
    final amount = double.tryParse(amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      _toast('اكتب المبلغ');
      return;
    }
    try {
      await FundService.requestWithdrawal(
        buildingId: _buildingId!,
        amount: amount,
        note: noteCtrl.text.trim(),
        payoutPhone: toWallet ? null : phoneCtrl.text.trim(),
      );
      _toast('اتبعت طلب السحب للمراجعة');
      _load();
    } catch (e) {
      _toast(errorText(e, 'تعذّر إرسال الطلب'));
    }
  }

  Future<void> _openReceipt(String path) async {
    if (kDemo) {
      // Demo build: the (placeholder or just-picked) receipt, in the app.
      final uploaded = DemoStore.instance.files[path];
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: uploaded != null ? Image.memory(uploaded.$1) : DemoReceiptCard(tx: DemoStore.instance.ledgerRowForReceipt(path)),
          ),
        ),
      );
      return;
    }
    try {
      final url = await FundService.receiptUrl(path);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      _toast('تعذّر فتح الإيصال');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) return const AuthLandingScreen();
    final appBar = AppBar(title: const Text('صندوق العمارة'));
    if (_loading) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
    if (_loadError) return Scaffold(backgroundColor: AppColors.bg, appBar: appBar, body: LoadErrorView(onRetry: _load));
    if (_buildingId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: appBar,
        body: const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('لازم تنضم لعمارتك وتوثّق حسابك الأول', textAlign: TextAlign.center))),
      );
    }
    if (!_canView) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: appBar,
        body: ListView(padding: const EdgeInsets.all(16), children: [
          CollectionRateCard(rate: _rate),
          const SizedBox(height: 14),
          const Text('رصيد الصندوق وتفاصيله بيشوفها رئيس الاتحاد ومجلس الإدارة وأمين الصندوق.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.inkMuted, height: 1.6)),
        ]),
      );
    }

    final s = _summary ?? const {};
    final balance = (s['balance'] as num?) ?? 0;
    final pending = (s['pending_withdrawals'] as num?) ?? 0;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('رصيد صندوق العمارة', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 6),
              Text(fundMoney(balance), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              if (pending > 0) ...[
                const SizedBox(height: 4),
                Text('طلبات سحب معلّقة: ${fundMoney(pending)}', style: const TextStyle(color: AppColors.gold, fontSize: 11)),
              ],
              const SizedBox(height: 12),
              Row(children: [
                _MiniStat(label: 'دخل من المحفظة', value: fundMoney((s['income_wallet'] as num?) ?? 0)),
                _MiniStat(label: 'دخل كاش', value: fundMoney((s['income_cash'] as num?) ?? 0)),
                _MiniStat(label: 'مصروفات', value: fundMoney((s['expenses'] as num?) ?? 0)),
              ]),
              const SizedBox(height: 8),
              Text(_isManager ? 'إنت مدير الصندوق' : 'عرض فقط — أمين الصندوق (أو الرئيس لو مفيش أمين) هو اللي بيدير الفلوس',
                  style: const TextStyle(color: Colors.white60, fontSize: 10.5)),
            ]),
          ),
          const SizedBox(height: 12),
          CollectionRateCard(rate: _rate),
          const SizedBox(height: 12),
          if (_isManager) ...[
            Row(children: [
              Expanded(child: _ActionButton(icon: Icons.receipt_long_rounded, label: 'سجّل مصروف بإيصال', onTap: _recordExpense)),
              const SizedBox(width: 8),
              Expanded(child: _ActionButton(icon: Icons.payments_rounded, label: 'علّم دفع كاش', onTap: _markCash)),
              const SizedBox(width: 8),
              Expanded(child: _ActionButton(icon: Icons.outbox_rounded, label: 'اطلب سحب', onTap: _requestWithdrawal)),
            ]),
            const SizedBox(height: 12),
          ],
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DuesStatusScreen())),
            icon: const Icon(Icons.fact_check_outlined, size: 18),
            label: const Text('مين دفع ومين لسه'),
          ),
          if (_withdrawals.isNotEmpty) ...[
            const SizedBox(height: 18),
            const Text('طلبات السحب', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            for (final w in _withdrawals)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.outbox_rounded, color: AppColors.inkSecondary),
                title: Text('${fundMoney((w['amount_egp'] as num?) ?? 0)} — ${w['note'] ?? ''}', style: const TextStyle(fontSize: 12.5)),
                subtitle: Text('${w['destination'] == 'wallet' ? 'على المحفظة' : 'تحويل على ${w['payout_phone'] ?? ''}'} • ${fundDate(w['created_at'] as String?)}',
                    style: const TextStyle(fontSize: 10.5)),
                trailing: _StatusChip(status: w['status'] as String? ?? 'pending'),
              ),
          ],
          const SizedBox(height: 18),
          const Text('دفتر الصندوق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          if (_ledger.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('لسه مفيش حركات في الصندوق', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5))),
            )
          else
            for (final t in _ledger) _LedgerRow(tx: t, onReceipt: _openReceipt),
        ]),
      ),
    );
  }
}

/// Confirm + mark one due paid in cash (shared with the dues status screen).
Future<void> confirmMarkCash(BuildContext context, Map<String, dynamic> row) async {
  final noteCtrl = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('شقة ${row['unit_number'] ?? ''} دفعت كاش؟'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('«${row['period_label'] ?? ''}» — ${fundMoney((row['amount'] as num?) ?? 0)} هتدخل الصندوق وتتعلّم مدفوعة.'),
        const SizedBox(height: 8),
        TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'ملاحظة (اختياري)')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
        ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('أيوه، استلمت')),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  try {
    await FundService.markDuePaidCash(row['due_id'] as String, note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اتسجّل الدفع الكاش ودخل الصندوق')));
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(e, 'تعذّر تسجيل الدفع'))));
  }
}

/// Collection percentage of the current period (what every resident sees).
class CollectionRateCard extends StatelessWidget {
  const CollectionRateCard({super.key, required this.rate});
  final Map<String, dynamic>? rate;

  @override
  Widget build(BuildContext context) {
    final r = rate;
    final pct = ((r?['pct'] as num?) ?? 0).toDouble();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: r == null
          ? const Text('لسه مفيش مستحقات صيانة اتعملت للعمارة', style: TextStyle(fontSize: 12, color: AppColors.inkMuted))
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('نسبة تحصيل «${r['period_label'] ?? ''}»', style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary)),
              const SizedBox(height: 6),
              Text('${pct.toStringAsFixed(pct == pct.roundToDouble() ? 0 : 1)}%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(value: (pct / 100).clamp(0, 1), minHeight: 7, backgroundColor: AppColors.surfaceAlt, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
              ),
              const SizedBox(height: 4),
              Text('${r['paid_units'] ?? 0} من ${r['total_units'] ?? 0} شقة دفعت', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            ]),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
        ]),
      );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Column(children: [
            Icon(icon, color: AppColors.teal, size: 22),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'paid' => ('اتحوّل', AppColors.success),
      'rejected' => ('مرفوض', AppColors.categorySos),
      _ => ('قيد المراجعة', AppColors.gold),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.tx, required this.onReceipt});
  final Map<String, dynamic> tx;
  final void Function(String path) onReceipt;

  @override
  Widget build(BuildContext context) {
    final amount = (tx['amount'] as num?) ?? 0;
    final (label, icon) = _typeLabels[tx['type']] ?? ('حركة', Icons.swap_vert_rounded);
    final unit = (tx['unit'] as Map?)?['unit_number'];
    final by = (tx['creator'] as Map?)?['full_name'] as String?;
    final receipt = tx['receipt_path'] as String?;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(icon, size: 20, color: amount >= 0 ? AppColors.success : AppColors.categorySos),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tx['note'] as String? ?? label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            Text([label, if (unit != null) 'شقة $unit', ?by, fundDate(tx['created_at'] as String?)].join(' • '),
                style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            if (receipt != null)
              TextButton.icon(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 28)),
                onPressed: () => onReceipt(receipt),
                icon: const Icon(Icons.image_outlined, size: 14),
                label: const Text('الإيصال', style: TextStyle(fontSize: 11)),
              ),
          ]),
        ),
        Text('${amount >= 0 ? '+' : ''}${fundMoney(amount)}',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: amount >= 0 ? AppColors.success : AppColors.categorySos)),
      ]),
    );
  }
}
