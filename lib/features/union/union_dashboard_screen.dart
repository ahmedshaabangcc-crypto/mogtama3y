import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/guard/guard_service.dart';
import '../../core/maps/maps_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/board_decisions_service.dart';
import '../../core/union/financial_report_service.dart';
import '../../core/union/maintenance_schedule_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../guard/guard_console_screen.dart';
import '../visitor/visitor_qr_pass_screen.dart';
import 'board_decisions_screen.dart';
import 'election_voting_screen.dart';
import 'financial_report_screen.dart';
import 'maintenance_payment_screen.dart';
import 'manage_tenants_screen.dart';
import 'pending_members_screen.dart';
import 'union_feed_screen.dart';

String _fmt(num n) {
  final s = n.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

const _weekdaysAr = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
String _weekdayAr(DateTime d) => _weekdaysAr[d.weekday - 1];

String _whenLabel(DateTime d) {
  final now = DateTime.now();
  final diffDays = DateTime(d.year, d.month, d.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  if (diffDays <= 0) return 'اليوم';
  if (diffDays == 1) return 'غدًا';
  return 'بعد $diffDays أيام';
}

/// The owners'-union governance dashboard — was reachable only after
/// signing in and founding/joining a building, but showed a screen's
/// worth of fabricated content anyway: a fake "الجمعية العمومية نشطة"
/// claim, a fake building code, a fake treasury balance with a fake
/// month-over-month trend, a fake live proposal card with invented vote
/// percentages and "quorum met," a fake upcoming-maintenance schedule,
/// and a fake board announcement from a made-up board member — with
/// action buttons that did nothing. Rebuilt around real data: the
/// treasury card reads the same union_financial_reports (0030) as the
/// financial report screen; the fake proposal card is removed since
/// board_decisions (0020) is already the real version of that feature,
/// one tap away; the maintenance schedule is now real — see
/// backend/migrations/0031_maintenance_schedule.sql.
class UnionDashboardScreen extends StatefulWidget {
  const UnionDashboardScreen({super.key});

  @override
  State<UnionDashboardScreen> createState() => _UnionDashboardScreenState();
}

class _UnionDashboardScreenState extends State<UnionDashboardScreen> {
  bool _loading = true;
  String? _loadError;
  String? _buildingId;
  String? _buildingName;
  String? _district;
  String? _city;
  double? _lat;
  double? _lng;
  bool _isBoard = false;
  int _unitsCount = 0;
  int _membersCount = 0;
  int _openDecisionsCount = 0;
  String? _guardName;
  Map<String, dynamic>? _report;
  List<Map<String, dynamic>> _schedule = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      await _loadReal();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _loadReal() async {
    final membership = await UnionService.fetchMyMembership();
    final isVerified = membership?['status'] == 'verified';
    final buildingId = isVerified ? membership!['building_id'] as String? : null;
    final building = membership?['building'] as Map<String, dynamic>?;
    final role = membership?['role'] as String?;

    int unitsCount = 0, membersCount = 0, openDecisions = 0;
    String? guardName;
    Map<String, dynamic>? report;
    List<Map<String, dynamic>> schedule = [];

    if (buildingId != null) {
      final results = await Future.wait([
        Supabase.instance.client.from('units').select('id').eq('building_id', buildingId),
        UnionService.fetchVerifiedMembers(buildingId),
        BoardDecisionsService.fetchDecisions(buildingId),
        GuardService.fetchGuardsFor(buildingId),
        FinancialReportService.fetchLatestReport(buildingId),
        MaintenanceScheduleService.fetchUpcoming(buildingId),
      ]);
      unitsCount = (results[0] as List).length;
      membersCount = (results[1] as List).length;
      openDecisions = (results[2] as List).where((d) => (d as Map)['status'] == 'open').length;
      final guards = results[3] as List<Map<String, dynamic>>;
      if (guards.isNotEmpty) {
        final guardProfile = guards.first['profile'] as Map<String, dynamic>?;
        guardName = guardProfile?['full_name'] as String?;
      }
      report = results[4] as Map<String, dynamic>?;
      schedule = List<Map<String, dynamic>>.from(results[5] as List);
    }

    if (!mounted) return;
    setState(() {
      _buildingId = buildingId;
      _buildingName = building?['name'] as String?;
      _district = building?['district'] as String?;
      _city = building?['city'] as String?;
      _lat = (building?['lat'] as num?)?.toDouble();
      _lng = (building?['lng'] as num?)?.toDouble();
      _isBoard = role == 'president' || role == 'board_member';
      _unitsCount = unitsCount;
      _membersCount = membersCount;
      _openDecisionsCount = openDecisions;
      _guardName = guardName;
      _report = report;
      _schedule = schedule;
      _loading = false;
    });
  }

  Future<void> _addScheduleItem() async {
    final buildingId = _buildingId;
    if (buildingId == null) return;
    final titleCtrl = TextEditingController();
    final vendorCtrl = TextEditingController();
    DateTime? scheduledFor;
    bool urgent = false;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إضافة صيانة مجدولة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'عنوان الصيانة')),
              const SizedBox(height: 8),
              TextField(controller: vendorCtrl, decoration: const InputDecoration(labelText: 'الشركة المنفذة (اختياري)')),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(scheduledFor == null ? 'اختر التاريخ والوقت' : '${_weekdayAr(scheduledFor!)} — ${scheduledFor!.year}/${scheduledFor!.month}/${scheduledFor!.day}'),
                trailing: const Icon(Icons.calendar_month_outlined),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date == null) return;
                  setSheetState(() => scheduledFor = date);
                },
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('عاجلة'),
                value: urgent,
                onChanged: (v) => setSheetState(() => urgent = v ?? false),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  child: const Text('حفظ'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    if (saved != true || titleCtrl.text.trim().isEmpty || scheduledFor == null) return;
    try {
      await MaintenanceScheduleService.addItem(
        buildingId: buildingId,
        title: titleCtrl.text.trim(),
        vendor: vendorCtrl.text.trim().isEmpty ? null : vendorCtrl.text.trim(),
        scheduledFor: scheduledFor!,
        isUrgent: urgent,
      );
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذّرت إضافة الصيانة')));
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
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('مجلس إدارة اتحاد الشاغلين')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.categorySos, size: 40),
                const SizedBox(height: 12),
                const Text('تعذر تحميل لوحة الاتحاد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 8),
                Text(_loadError!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _load, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ),
      );
    }
    if (_buildingId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('مجلس إدارة اتحاد الشاغلين')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('لازم تنضم لعمارتك وتوثّق حسابك الأول عشان توصل للوحة الاتحاد',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }

    final report = _report;
    final totalCollected = (report?['total_collected'] as num?) ?? 0;
    final totalExpected = (report?['total_expected'] as num?) ?? 0;
    final emergencyFund = (report?['emergency_fund'] as num?) ?? 0;
    final collectionRatio = totalExpected > 0 ? (totalCollected / totalExpected).clamp(0, 1).toDouble() : null;

    final locationLine = [
      if (_unitsCount > 0) '$_unitsCount وحدة سكنية',
      ?_district,
      ?_city,
    ].join(' • ');

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('مجلس إدارة اتحاد الشاغلين'),
        actions: [
          IconButton(
            tooltip: 'مجتمع الاتحاد',
            icon: const Icon(Icons.forum_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionFeedScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                  child: const Text('عمارة موثقة ✓', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.apartment_rounded, color: AppColors.inkMuted, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_buildingName ?? 'مجلس إدارة اتحاد الشاغلين', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('$_membersCount جار موثّق', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                        if (locationLine.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(locationLine, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                        ],
                      ],
                    ),
                  ),
                  if (_lat != null && _lng != null)
                    IconButton(
                      tooltip: 'الاتجاهات عبر خرائط Google',
                      icon: const Icon(Icons.directions_rounded, color: AppColors.teal),
                      onPressed: () => openDirections(lat: _lat!, lng: _lng!),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.savings_outlined, color: AppColors.gold, size: 16),
                    ),
                    const SizedBox(width: 8),
                    const Text('صندوق الصيانة والاحتياطي المالي', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                  ]),
                  const SizedBox(height: 10),
                  Text(report == null ? '—' : '${_fmt(emergencyFund)} ج.م', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                  if (report == null) ...[
                    const SizedBox(height: 6),
                    const Text('لسه ما فيش تقرير مالي منشور', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ] else if (collectionRatio != null) ...[
                    const SizedBox(height: 12),
                    const Text('نسبة تحصيل اشتراكات الفترة الحالية', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(value: collectionRatio, minHeight: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(AppColors.teal)),
                    ),
                    const SizedBox(height: 6),
                    Text('${(collectionRatio * 100).round()}% مكتمل', style: const TextStyle(color: AppColors.tealLight, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialReportScreen())),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      icon: const Icon(Icons.arrow_back_rounded, size: 15),
                      label: const Text('التقرير المالي المفصل', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('إجراءات سريعة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            const _QuickActionsRow(),
            const SizedBox(height: 22),
            const Text('الحوكمة والفريق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const Text('قرارات مجلس الإدارة لا يتخذها الرئيس بمفرده، وفريق الحراسة معتمد ومُدار من هنا', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _GovernanceTile(
                  icon: Icons.gavel_rounded,
                  title: 'قرارات مجلس الإدارة',
                  subtitle: _openDecisionsCount > 0 ? '$_openDecisionsCount قرار مفتوح' : 'لا توجد قرارات مفتوحة',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BoardDecisionsScreen())),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _GovernanceTile(
                  icon: Icons.security_rounded,
                  title: 'لوحة حارس العقار',
                  subtitle: _guardName ?? 'لا يوجد حارس معيّن حاليًا',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuardConsoleScreen())),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            _GovernanceTile(
              icon: Icons.person_add_alt_1_rounded,
              title: 'طلبات الانضمام المعلّقة',
              subtitle: 'راجع طلبات جيران جدد بانتظار موافقتك',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PendingMembersScreen())),
            ),
            const SizedBox(height: 10),
            _GovernanceTile(
              icon: Icons.key_rounded,
              title: 'حسابات المستأجرين',
              subtitle: 'مالك الوحدة يدعو مستأجره بحساب مستقل',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageTenantsScreen())),
            ),
            const SizedBox(height: 10),
            _GovernanceTile(
              icon: Icons.how_to_vote_outlined,
              title: 'انتخابات الرئاسة',
              subtitle: 'بدء أو متابعة انتخابات رئيس الاتحاد',
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ElectionVotingScreen())),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(child: Text('جدول الصيانات الدورية القادمة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
                if (_isBoard)
                  TextButton.icon(onPressed: _addScheduleItem, icon: const Icon(Icons.add_rounded, size: 16), label: const Text('إضافة', style: TextStyle(fontSize: 11.5))),
              ],
            ),
            const SizedBox(height: 8),
            if (_schedule.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('لا توجد صيانات مجدولة قادمة', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5))),
              )
            else
              for (final item in _schedule) ...[
                _MaintenanceItem(
                  title: item['title'] as String? ?? '',
                  subtitle: item['vendor'] as String? ?? '',
                  scheduledFor: DateTime.parse(item['scheduled_for'] as String),
                  urgent: item['is_urgent'] == true,
                ),
                const SizedBox(height: 10),
              ],
          ],
        ),
      ),
    );
  }
}

class _GovernanceTile extends StatelessWidget {
  const _GovernanceTile({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.teal, size: 17),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  static const _actions = [
    (icon: Icons.picture_as_pdf_outlined, label: 'التقرير المالي PDF'),
    (icon: Icons.payments_outlined, label: 'سداد الصيانة'),
    (icon: Icons.qr_code_2_rounded, label: 'إصدار تصريح QR'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: switch (i) {
                0 => () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FinancialReportScreen())),
                1 => () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MaintenancePaymentScreen())),
                2 => () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VisitorQrPassScreen())),
                _ => null,
              },
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: Icon(_actions[i].icon, size: 20, color: AppColors.teal),
                  ),
                  const SizedBox(height: 6),
                  Text(_actions[i].label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _MaintenanceItem extends StatelessWidget {
  const _MaintenanceItem({required this.title, required this.subtitle, required this.scheduledFor, required this.urgent});
  final String title, subtitle;
  final DateTime scheduledFor;
  final bool urgent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.build_outlined, color: AppColors.inkSecondary, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: urgent ? AppColors.gold.withValues(alpha: 0.15) : AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text(_whenLabel(scheduledFor), style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: urgent ? AppColors.gold : AppColors.inkMuted)),
              ),
              const SizedBox(height: 3),
              Text(_weekdayAr(scheduledFor), style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
