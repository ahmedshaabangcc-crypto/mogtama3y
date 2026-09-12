import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'maintenance_request_detail_screen.dart';

const _statusLabels = {
  'requested': 'بانتظار عرض سعر',
  'quoted': 'تم تحديد السعر',
  'scheduled': 'الزيارة محددة',
  'in_progress': 'العمل جارٍ',
  'completed': 'العمل مكتمل',
  'disputed': 'قيد النزاع',
  'cancelled': 'ملغي',
};

/// Resident's own maintenance bookings — see
/// backend/migrations/0022_technicians_maintenance.sql.
class MyMaintenanceRequestsScreen extends StatefulWidget {
  const MyMaintenanceRequestsScreen({super.key});

  @override
  State<MyMaintenanceRequestsScreen> createState() => _MyMaintenanceRequestsScreenState();
}

class _MyMaintenanceRequestsScreenState extends State<MyMaintenanceRequestsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await TechnicianService.fetchMyRequests();
    if (!mounted) return;
    setState(() {
      _requests = rows;
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
      appBar: AppBar(title: const Text('طلبات الصيانة الخاصة بي')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _requests.isEmpty
                ? ListView(children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Column(children: [
                        Icon(Icons.build_outlined, color: AppColors.inkMuted, size: 36),
                        SizedBox(height: 10),
                        Text('لا توجد طلبات صيانة بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                      ]),
                    ),
                  ])
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _requests.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final r = _requests[i];
                      final technician = r['technician'] as Map<String, dynamic>?;
                      final technicianProfile = technician?['profile'] as Map<String, dynamic>?;
                      final status = r['status'] as String? ?? 'requested';
                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          final changed = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => MaintenanceRequestDetailScreen(request: r, isTechnician: false)));
                          if (changed == true) _load();
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
                                  Text(r['category'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                  Text(technicianProfile?['full_name'] as String? ?? '', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
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
                    },
                  ),
      ),
    );
  }
}
