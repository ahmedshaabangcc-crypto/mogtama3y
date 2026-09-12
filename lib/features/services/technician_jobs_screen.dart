import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'maintenance_request_detail_screen.dart';
import 'register_technician_screen.dart';
import 'technician_verification_screen.dart';

const _statusLabels = {
  'requested': 'بانتظار عرض سعر',
  'quoted': 'تم تحديد السعر',
  'scheduled': 'الزيارة محددة',
  'in_progress': 'العمل جارٍ',
  'completed': 'العمل مكتمل',
  'disputed': 'قيد النزاع',
  'cancelled': 'ملغي',
};

/// Jobs assigned to the caller's own technician profile(s) — see
/// backend/migrations/0022_technicians_maintenance.sql. A user with no
/// technician profile yet sees an honest empty state pointing at
/// registration, rather than a broken/empty jobs list.
class TechnicianJobsScreen extends StatefulWidget {
  const TechnicianJobsScreen({super.key});

  @override
  State<TechnicianJobsScreen> createState() => _TechnicianJobsScreenState();
}

class _TechnicianJobsScreenState extends State<TechnicianJobsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _jobs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final profiles = await TechnicianService.fetchMyTechnicianProfiles();
    final jobs = <Map<String, dynamic>>[];
    for (final p in profiles) {
      jobs.addAll(await TechnicianService.fetchAssignedRequests(p['id'] as String));
    }
    jobs.sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    if (!mounted) return;
    setState(() {
      _profiles = profiles;
      _jobs = jobs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('طلبات الصيانة الواردة إليّ')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.badge_outlined, color: AppColors.inkMuted, size: 36),
                      const SizedBox(height: 10),
                      const Text('لسه مسجّلش نفسك كفني', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterTechnicianScreen()));
                          _load();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                        child: const Text('سجّل كفني الآن'),
                      ),
                    ]),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final p in _profiles) ...[
                        _ProfileVerificationTile(profile: p, onChanged: _load),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 8),
                      if (_jobs.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(child: Text('لا توجد طلبات واردة بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13))),
                        )
                      else
                        for (final r in _jobs) ...[
                          _JobTile(job: r, onChanged: _load),
                          const SizedBox(height: 10),
                        ],
                    ],
                  ),
                ),
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({required this.job, required this.onChanged});
  final Map<String, dynamic> job;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final resident = job['resident'] as Map<String, dynamic>?;
    final unit = job['unit'] as Map<String, dynamic>?;
    final status = job['status'] as String? ?? 'requested';
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final changed = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => MaintenanceRequestDetailScreen(request: job, isTechnician: true)));
        if (changed == true) onChanged();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.build_outlined, color: AppColors.teal, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job['category'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text('${resident?['full_name'] ?? ''} • شقة ${unit?['unit_number'] ?? ''}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
            child: Text(_statusLabels[status] ?? status, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}

class _ProfileVerificationTile extends StatelessWidget {
  const _ProfileVerificationTile({required this.profile, required this.onChanged});
  final Map<String, dynamic> profile;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final status = profile['verification_status'] as String? ?? 'unsubmitted';
    final isVerified = profile['is_verified'] == true;
    final (label, color) = switch (status) {
      'pending' => ('طلب التوثيق قيد المراجعة', AppColors.gold),
      'approved' => ('حساب موثّق ✓', AppColors.teal),
      'rejected' => ('تم رفض طلب التوثيق السابق', AppColors.categorySos),
      _ => ('حسابك غير موثّق بعد', AppColors.inkMuted),
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(children: [
        Icon(isVerified ? Icons.verified_rounded : Icons.badge_outlined, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile['category'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
              Text(label, style: TextStyle(fontSize: 10.5, color: color, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (status == 'unsubmitted' || status == 'rejected')
          TextButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) => TechnicianVerificationScreen(technicianId: profile['id'] as String)));
              onChanged();
            },
            child: const Text('توثيق', style: TextStyle(fontSize: 11.5)),
          ),
      ]),
    );
  }
}
