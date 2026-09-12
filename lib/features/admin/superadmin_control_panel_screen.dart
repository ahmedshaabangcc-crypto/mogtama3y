import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../core/admin/admin_service.dart';
import '../../core/auth/auth_service.dart';
import '../../core/promote/ad_token_service.dart';
import '../../core/storage/upload_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';

String _money(num v) => '${NumberFormat('#,##0.00').format(v)} ج.م';

/// Platform super-admin control panel — real stats plus two real
/// arbitration queues (shop-claim review, maintenance-escrow disputes)
/// instead of the fully mocked dashboard this used to be. See
/// backend/migrations/0024_superadmin.sql. Requires `profiles.role =
/// 'super_admin'`, granted manually in the SQL editor — there is
/// deliberately no self-service way to become an admin.
class SuperadminControlPanelScreen extends StatefulWidget {
  const SuperadminControlPanelScreen({super.key});

  @override
  State<SuperadminControlPanelScreen> createState() => _SuperadminControlPanelScreenState();
}

class _SuperadminControlPanelScreenState extends State<SuperadminControlPanelScreen> {
  bool _loading = true;
  bool _denied = false;
  Map<String, dynamic> _stats = {};
  List<Map<String, dynamic>> _shopClaims = [];
  List<Map<String, dynamic>> _disputes = [];
  List<Map<String, dynamic>> _topups = [];
  List<Map<String, dynamic>> _technicianVerifications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _denied = false;
    });
    try {
      final stats = await AdminService.fetchDashboardStats();
      final claims = await AdminService.fetchPendingShopClaims();
      final disputes = await AdminService.fetchDisputedRequests();
      final topups = await AdTokenService.fetchPendingTopups();
      final technicianVerifications = await AdminService.fetchPendingTechnicianVerifications();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _shopClaims = claims;
        _disputes = disputes;
        _topups = topups;
        _technicianVerifications = technicianVerifications;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _denied = true;
        _loading = false;
      });
    }
  }

  Future<void> _reviewClaim(String requestId, bool approve) async {
    try {
      await AdminService.reviewShopClaim(requestId: requestId, approve: approve);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تنفيذ الإجراء')));
    }
  }

  Future<void> _reviewTopup(String requestId, bool approve) async {
    try {
      await AdTokenService.reviewTopup(requestId: requestId, approve: approve);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تنفيذ الإجراء')));
    }
  }

  Future<void> _reviewTechnicianVerification(String technicianId, bool approve) async {
    try {
      await AdminService.reviewTechnicianVerification(technicianId: technicianId, approve: approve);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تنفيذ الإجراء')));
    }
  }

  Future<void> _openTechnicianDoc(String technicianId, {required bool isVideo}) async {
    try {
      final docs = await AdminService.fetchTechnicianVerificationDocs(technicianId);
      final path = isVideo ? docs['verification_video_url'] as String? : docs['id_card_url'] as String?;
      if (path == null) return;
      final url = await UploadService.createPrivateSignedUrl(path);
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح المستند')));
    }
  }

  Future<void> _resolveDispute(String requestId, bool releaseToTechnician) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('فض النزاع'),
        content: Text(releaseToTechnician ? 'سيتم تحويل المبلغ المحجوز بالكامل للفني.' : 'سيتم رد المبلغ المحجوز بالكامل للساكن.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('تأكيد')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await AdminService.resolveDispute(requestId: requestId, releaseToTechnician: releaseToTechnician);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فض النزاع')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_denied) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('لوحة تحكم السوبر أدمن')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('هذه اللوحة متاحة فقط لمدير المنصة', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة تحكم السوبر أدمن')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const Text('مؤشرات المنصة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
              children: [
                _StatCard(icon: Icons.lock_outline_rounded, value: _money((_stats['total_held_escrow'] as num?) ?? 0), label: 'أموال الضمان المحجوزة حالياً'),
                _StatCard(icon: Icons.apartment_rounded, value: '${_stats['buildings_count'] ?? 0} عمارة', label: 'عمارات مسجّلة'),
                _StatCard(icon: Icons.groups_rounded, value: '${_stats['presidents_count'] ?? 0} رئيس', label: 'رؤساء اتحادات موثقين'),
                _StatCard(
                  icon: Icons.storefront_outlined,
                  value: '${_stats['pending_shop_claims_count'] ?? 0} طلب',
                  label: 'طلبات تملك محلات معلّقة',
                  noteColor: (_stats['pending_shop_claims_count'] as int? ?? 0) > 0 ? AppColors.gold : AppColors.inkMuted,
                ),
                _StatCard(
                  icon: Icons.toll_outlined,
                  value: '${_stats['pending_token_topups_count'] ?? 0} طلب',
                  label: 'طلبات شحن توكن معلّقة',
                  noteColor: (_stats['pending_token_topups_count'] as int? ?? 0) > 0 ? AppColors.gold : AppColors.inkMuted,
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(children: [
              const Expanded(child: Text('فض النزاعات المالية (Escrow)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
              if (_disputes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                  child: const Text('عاجل', style: TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
                ),
            ]),
            const SizedBox(height: 10),
            if (_disputes.isEmpty)
              const Text('لا توجد نزاعات مفتوحة حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final d in _disputes) ...[
                _DisputeCard(request: d, onResolve: _resolveDispute),
                const SizedBox(height: 14),
              ],
            const SizedBox(height: 22),
            Row(children: [
              const Expanded(child: Text('اعتماد تملك المحلات (Claim Business)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text('${_shopClaims.length} طلب', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
            if (_shopClaims.isEmpty)
              const Text('لا توجد طلبات معلّقة حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final c in _shopClaims) ...[
                _ClaimBusinessCard(claim: c, onReview: _reviewClaim),
                const SizedBox(height: 14),
              ],
            const SizedBox(height: 22),
            Row(children: [
              const Expanded(child: Text('توثيق هوية الفنيين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text('${_technicianVerifications.length} طلب', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
            if (_technicianVerifications.isEmpty)
              const Text('لا توجد طلبات معلّقة حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final v in _technicianVerifications) ...[
                _TechnicianVerificationCard(technician: v, onOpenDoc: _openTechnicianDoc, onReview: _reviewTechnicianVerification),
                const SizedBox(height: 14),
              ],
            const SizedBox(height: 22),
            Row(children: [
              const Expanded(child: Text('طلبات شحن رصيد التوكن', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text('${_topups.length} طلب', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
            if (_topups.isEmpty)
              const Text('لا توجد طلبات معلّقة حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final t in _topups) ...[
                _TokenTopUpCard(request: t, onReview: _reviewTopup),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label, this.noteColor = AppColors.inkMuted});
  final IconData icon;
  final String value, label;
  final Color noteColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          Text(label, style: TextStyle(fontSize: 9.5, color: noteColor)),
        ],
      ),
    );
  }
}

class _DisputeCard extends StatelessWidget {
  const _DisputeCard({required this.request, required this.onResolve});
  final Map<String, dynamic> request;
  final void Function(String requestId, bool releaseToTechnician) onResolve;

  @override
  Widget build(BuildContext context) {
    final resident = request['resident'] as Map<String, dynamic>?;
    final unit = request['unit'] as Map<String, dynamic>?;
    final amount = (request['quoted_amount'] as num?) ?? 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: Text('${_money(amount)} محجوزة بالضمان', style: const TextStyle(fontSize: 9, color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 8),
          Text('نزاع على خدمة ${request['category']}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 4),
          Text('${resident?['full_name'] ?? ''} • شقة ${unit?['unit_number'] ?? ''}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          if (request['description'] != null && (request['description'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(request['description'] as String, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.6)),
          ],
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () => onResolve(request['id'] as String, false),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.inkSecondary, side: const BorderSide(color: AppColors.border)),
                  child: const Text('رد المبلغ للساكن', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () => onResolve(request['id'] as String, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  child: const Text('تحويل المبلغ للفني', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _TechnicianVerificationCard extends StatelessWidget {
  const _TechnicianVerificationCard({required this.technician, required this.onOpenDoc, required this.onReview});
  final Map<String, dynamic> technician;
  final Future<void> Function(String technicianId, {required bool isVideo}) onOpenDoc;
  final void Function(String technicianId, bool approve) onReview;

  @override
  Widget build(BuildContext context) {
    final id = technician['id'] as String;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 16, color: AppColors.inkMuted)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(technician['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text('${technician['category'] ?? ''} • ${technician['phone'] ?? ''}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onOpenDoc(id, isVideo: false),
                icon: const Icon(Icons.badge_outlined, size: 15),
                label: const Text('صورة البطاقة', style: TextStyle(fontSize: 11)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => onOpenDoc(id, isVideo: true),
                icon: const Icon(Icons.videocam_outlined, size: 15),
                label: const Text('فيديو الوجه', style: TextStyle(fontSize: 11)),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: OutlinedButton(
                  onPressed: () => onReview(id, false),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border)),
                  child: const Text('رفض', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () => onReview(id, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
                  child: const Text('اعتماد التوثيق', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _TokenTopUpCard extends StatelessWidget {
  const _TokenTopUpCard({required this.request, required this.onReview});
  final Map<String, dynamic> request;
  final void Function(String requestId, bool approve) onReview;

  @override
  Widget build(BuildContext context) {
    final requester = request['requester'] as Map<String, dynamic>?;
    final tokens = request['tokens_requested'] as int? ?? 0;
    final amount = (request['amount_egp'] as num?) ?? 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 16, color: AppColors.inkMuted)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(requester?['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  Text(requester?['phone'] as String? ?? '', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('$tokens توكن', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.gold)),
                Text('$amount ج.م', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
              ],
            ),
          ]),
          if (request['proof_note'] != null && (request['proof_note'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.receipt_long_outlined, size: 13, color: AppColors.inkSecondary),
                const SizedBox(width: 6),
                Expanded(child: Text(request['proof_note'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, fontWeight: FontWeight.w600))),
              ]),
            ),
          ],
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 38,
                child: OutlinedButton(
                  onPressed: () => onReview(request['id'] as String, false),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border)),
                  child: const Text('رفض', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 38,
                child: ElevatedButton(
                  onPressed: () => onReview(request['id'] as String, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
                  child: const Text('اعتماد وإضافة الرصيد', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _ClaimBusinessCard extends StatelessWidget {
  const _ClaimBusinessCard({required this.claim, required this.onReview});
  final Map<String, dynamic> claim;
  final void Function(String requestId, bool approve) onReview;

  @override
  Widget build(BuildContext context) {
    final shop = claim['shop'] as Map<String, dynamic>?;
    final requester = claim['requester'] as Map<String, dynamic>?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shop?['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          if (shop?['address'] != null)
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 12, color: AppColors.inkMuted),
              const SizedBox(width: 4),
              Text(shop!['address'] as String, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            ]),
          const SizedBox(height: 8),
          Text('مقدَّم من: ${requester?['full_name'] ?? ''} (${requester?['phone'] ?? ''})', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('طريقة التحقق: ${claim['verification_method']}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () => onReview(claim['id'] as String, false),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.categorySos, side: const BorderSide(color: AppColors.border)),
                  child: const Text('رفض', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () => onReview(claim['id'] as String, true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white),
                  child: const Text('اعتماد الملكية', style: TextStyle(fontSize: 11)),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
