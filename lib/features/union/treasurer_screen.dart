import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/fund_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'election_voting_screen.dart';
import 'union_fund_screen.dart';

/// «أمين الصندوق» — who manages the building fund. The president appoints
/// or removes the treasurer (the building is notified), or the owners
/// elect one (one vote per unit). Without a treasurer the president
/// manages the fund. See backend/migrations/0076_union_fund_treasurer.sql.
class TreasurerScreen extends StatefulWidget {
  const TreasurerScreen({super.key});

  @override
  State<TreasurerScreen> createState() => _TreasurerScreenState();
}

class _TreasurerScreenState extends State<TreasurerScreen> {
  bool _loading = true;
  bool _loadError = false;
  String? _buildingId;
  bool _isPresident = false;
  Map<String, dynamic>? _treasurer;
  List<Map<String, dynamic>> _members = [];

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
      final isPresident = membership?['role'] == 'president';
      Map<String, dynamic>? treasurer;
      var members = <Map<String, dynamic>>[];
      if (buildingId != null) {
        treasurer = await FundService.fetchTreasurer(buildingId);
        if (isPresident) members = await UnionService.fetchVerifiedMembers(buildingId);
      }
      if (!mounted) return;
      setState(() {
        _buildingId = buildingId;
        _isPresident = isPresident;
        _treasurer = treasurer;
        _members = members;
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

  void _toast(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _appoint() async {
    final me = AuthService.currentUser?.id;
    final candidates = _members.where((m) => m['user_id'] != me).toList();
    if (candidates.isEmpty) {
      _toast('مفيش جيران موثّقين تقدر تعيّن منهم لسه');
      return;
    }
    final picked = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(16), children: [
          const Text('اختار أمين الصندوق', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          for (final m in candidates)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
              title: Text((m['profile'] as Map?)?['full_name'] as String? ?? 'جار'),
              subtitle: Text('شقة ${(m['unit'] as Map?)?['unit_number'] ?? '—'}'),
              onTap: () => Navigator.of(context).pop(m),
            ),
        ]),
      ),
    );
    if (picked == null) return;
    try {
      await FundService.appointTreasurer(buildingId: _buildingId!, userId: picked['user_id'] as String);
      _toast('اتعيّن أمين الصندوق وبلّغنا العمارة');
      _load();
    } catch (e) {
      _toast(errorText(e, 'تعذّر التعيين'));
    }
  }

  Future<void> _remove() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('شيل أمين الصندوق؟'),
        content: const Text('الصندوق هيرجع تحت إدارتك كرئيس للاتحاد لحد ما تعيّن أو تنتخبوا أمين جديد.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('أيوه، شيله')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await FundService.removeTreasurer(_buildingId!);
      _toast('اتشال أمين الصندوق');
      _load();
    } catch (e) {
      _toast(errorText(e, 'تعذّر الإجراء'));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) return const AuthLandingScreen();
    final appBar = AppBar(title: const Text('أمين الصندوق'));
    if (_loading) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
    if (_loadError) return Scaffold(backgroundColor: AppColors.bg, appBar: appBar, body: LoadErrorView(onRetry: _load));
    if (_buildingId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: appBar,
        body: const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('لازم تنضم لعمارتك وتوثّق حسابك الأول', textAlign: TextAlign.center))),
      );
    }
    final t = _treasurer;
    final name = (t?['profile'] as Map?)?['full_name'] as String?;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              const CircleAvatar(radius: 24, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.account_balance_rounded, color: AppColors.teal)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t == null ? 'مفيش أمين صندوق' : (name ?? 'جار'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    t == null
                        ? 'رئيس الاتحاد هو اللي بيدير الصندوق دلوقتي'
                        : (t['source'] == 'elected' ? 'منتخب من الملاك — بيدير الصندوق' : 'معيّن من رئيس الاتحاد — بيدير الصندوق'),
                    style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                  ),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          const Text(
            'أمين الصندوق بيسجّل المصروفات بالإيصالات والدفع الكاش ويطلب السحب. الرئيس ومجلس الإدارة بيشوفوا الرصيد والدفتر، والسكان بيشوفوا نسبة التحصيل بس.',
            style: TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.7),
          ),
          const SizedBox(height: 16),
          if (_isPresident) ...[
            ElevatedButton.icon(
              onPressed: _appoint,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(46)),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: Text(t == null ? 'عيّن أمين صندوق' : 'غيّر أمين الصندوق'),
            ),
            if (t != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _remove,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, minimumSize: const Size.fromHeight(44)),
                icon: const Icon(Icons.person_remove_alt_1_rounded, size: 18),
                label: const Text('شيل أمين الصندوق'),
              ),
            ],
            const SizedBox(height: 8),
          ],
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ElectionVotingScreen(position: 'treasurer')))
                .then((_) => _load()),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
            icon: const Icon(Icons.how_to_vote_outlined, size: 18),
            label: const Text('انتخابات أمين الصندوق'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionFundScreen())),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
            icon: const Icon(Icons.savings_outlined, size: 18),
            label: const Text('صندوق العمارة'),
          ),
        ]),
      ),
    );
  }
}
