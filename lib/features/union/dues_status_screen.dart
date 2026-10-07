import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/fund_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'union_fund_screen.dart';

/// «مين دفع ومين لسه» — every unit with its due for a period and
/// مدفوع / لسه / متأخر, plus «فكّر الكل» (once per 24h). President, board
/// and treasurer only; the fund manager can also mark a unit paid in cash
/// from here. See backend/migrations/0076_union_fund_treasurer.sql.
class DuesStatusScreen extends StatefulWidget {
  const DuesStatusScreen({super.key});

  @override
  State<DuesStatusScreen> createState() => _DuesStatusScreenState();
}

class _DuesStatusScreenState extends State<DuesStatusScreen> {
  bool _loading = true;
  bool _loadError = false;
  bool _denied = false;
  bool _reminding = false;
  String? _buildingId;
  bool _isManager = false;
  String? _period;
  List<Map<String, dynamic>> _periods = [];
  List<Map<String, dynamic>> _rows = [];

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
      var denied = buildingId == null;
      var isManager = false;
      var periods = <Map<String, dynamic>>[];
      var rows = <Map<String, dynamic>>[];
      if (buildingId != null) {
        denied = !await FundService.canView(buildingId);
        if (!denied) {
          isManager = await FundService.isManager(buildingId);
          periods = await FundService.fetchDuePeriods(buildingId);
          rows = await FundService.fetchDuesStatus(buildingId, period: _period);
        }
      }
      if (!mounted) return;
      setState(() {
        _buildingId = buildingId;
        _denied = denied;
        _isManager = isManager;
        _periods = periods;
        _period ??= periods.isEmpty ? null : periods.first['period_label'] as String?;
        _rows = rows;
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

  Future<void> _remindAll() async {
    setState(() => _reminding = true);
    try {
      final n = await FundService.remindUnpaid(_buildingId!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(n == 0 ? 'مفيش حد عليه مستحقات 👌' : 'اتبعت تذكير لـ $n جار')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(e, 'تعذّر إرسال التذكير'))));
    } finally {
      if (mounted) setState(() => _reminding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) return const AuthLandingScreen();
    final appBar = AppBar(title: const Text('مين دفع ومين لسه'));
    if (_loading) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
    if (_loadError) return Scaffold(backgroundColor: AppColors.bg, appBar: appBar, body: LoadErrorView(onRetry: _load));
    if (_denied) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: appBar,
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('حالة السداد لكل شقة بيشوفها رئيس الاتحاد ومجلس الإدارة وأمين الصندوق بس.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
          ),
        ),
      );
    }

    final dueRows = _rows.where((r) => r['status'] != 'none').toList();
    final paid = dueRows.where((r) => r['status'] == 'paid').length;
    final unpaid = dueRows.length - paid;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
          if (_periods.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text('لسه مفيش مستحقات صيانة اتعملت — اعملها من «سداد الصيانة».', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted)),
            )
          else ...[
            SizedBox(
              height: 40,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                for (final p in _periods)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text('${p['period_label']} (${p['paid']}/${p['total']})'),
                      selected: p['period_label'] == _period,
                      onSelected: (_) {
                        _period = p['period_label'] as String?;
                        _load();
                      },
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            Row(children: [
              _Count(label: 'دفعوا', value: paid, color: AppColors.success),
              const SizedBox(width: 8),
              _Count(label: 'لسه', value: unpaid, color: AppColors.categorySos),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: unpaid == 0 || _reminding ? null : _remindAll,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                icon: const Icon(Icons.notifications_active_rounded, size: 18),
                label: const Text('فكّر الكل', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 4),
            const Text('بيبعت إشعار لكل شقة عليها مستحقات (مرة كل 24 ساعة).', textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            const SizedBox(height: 12),
            for (final r in _rows) _UnitRow(
              row: r,
              onMarkCash: _isManager && (r['status'] == 'unpaid' || r['status'] == 'overdue')
                  ? () async {
                      await confirmMarkCash(context, r);
                      _load();
                    }
                  : null,
            ),
          ],
        ]),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.label, required this.value, required this.color});
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
          child: Column(children: [
            Text('$value', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 11.5)),
          ]),
        ),
      );
}

class _UnitRow extends StatelessWidget {
  const _UnitRow({required this.row, this.onMarkCash});
  final Map<String, dynamic> row;
  final VoidCallback? onMarkCash;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (row['status']) {
      'paid' => (row['paid_via'] == 'cash' ? 'مدفوع كاش' : 'مدفوع', AppColors.success),
      'overdue' => ('متأخر', AppColors.categorySos),
      'unpaid' => ('لسه', AppColors.gold),
      _ => ('مفيش مستحق', AppColors.inkMuted),
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        CircleAvatar(radius: 18, backgroundColor: color.withValues(alpha: 0.12), child: Text('${row['unit_number'] ?? ''}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color))),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('شقة ${row['unit_number'] ?? ''}${row['floor_label'] == null ? '' : ' • ${row['floor_label']}'}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
            Text((row['residents'] as String?) ?? 'مفيش سكان مسجّلين', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
            if (row['amount'] != null) Text(fundMoney(row['amount'] as num), style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
            child: Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
          ),
          if (onMarkCash != null)
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 28)),
              onPressed: onMarkCash,
              child: const Text('دفع كاش', style: TextStyle(fontSize: 11)),
            ),
        ]),
      ]),
    );
  }
}
