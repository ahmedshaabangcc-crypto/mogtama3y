import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/chat/building_chat_service.dart';
import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import '../services/maintenance_request_detail_screen.dart';
import 'building_chat_screen.dart';

const _requestStatusLabels = {
  'requested': 'بانتظار عرض سعر',
  'quoted': 'تم تحديد السعر',
  'scheduled': 'الزيارة محددة',
  'in_progress': 'العمل جارٍ',
  'completed': 'العمل مكتمل',
  'disputed': 'قيد النزاع',
  'cancelled': 'ملغي',
};

/// Real conversations inbox — the bottom-nav "المحادثات" tab. Used to
/// be a unified mockup mixing four fake conversation types; now shows
/// only what's genuinely real: the building-wide group chat (see
/// backend/migrations/0025_building_chat.sql) and the app's real 1:1
/// maintenance threads (0022), on both the resident and technician
/// side. Marketplace-seller and shop-delivery chat have no backing
/// schema and are dropped rather than shown fake.
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _loading = true;
  String? _buildingId;
  String? _buildingName;
  String? _lastBuildingMessage;
  List<Map<String, dynamic>> _myRequests = [];
  List<Map<String, dynamic>> _myJobs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final membership = await UnionService.fetchMyMembership();
    final buildingId = membership?['building_id'] as String?;
    final building = membership?['building'] as Map<String, dynamic>?;
    String? lastMessage;
    if (buildingId != null) {
      final last = await BuildingChatService.fetchLastMessage(buildingId);
      lastMessage = last?['body'] as String?;
    }

    final requests = await TechnicianService.fetchMyRequests();

    final profiles = await TechnicianService.fetchMyTechnicianProfiles();
    final jobs = <Map<String, dynamic>>[];
    for (final p in profiles) {
      jobs.addAll(await TechnicianService.fetchAssignedRequests(p['id'] as String));
    }

    if (!mounted) return;
    setState(() {
      _buildingId = buildingId;
      _buildingName = building?['name'] as String?;
      _lastBuildingMessage = lastMessage;
      _myRequests = requests;
      _myJobs = jobs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final hasAnything = _buildingId != null || _myRequests.isNotEmpty || _myJobs.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المحادثات')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: !hasAnything
            ? ListView(children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Column(children: [
                    Icon(Icons.chat_bubble_outline_rounded, color: AppColors.inkMuted, size: 36),
                    SizedBox(height: 10),
                    Text('لا توجد محادثات بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                  ]),
                ),
              ])
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  if (_buildingId != null) ...[
                    _ThreadTile(
                      icon: Icons.account_balance_rounded,
                      iconColor: AppColors.categoryUnion,
                      title: 'دردشة ${_buildingName ?? 'العمارة'}',
                      subtitle: _lastBuildingMessage ?? 'ابدأ الحديث مع جيرانك',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BuildingChatScreen(buildingId: _buildingId!, buildingName: _buildingName ?? 'العمارة'))),
                    ),
                    const SizedBox(height: 10),
                  ],
                  for (final r in _myRequests) ...[
                    _ThreadTile(
                      icon: Icons.build_rounded,
                      iconColor: AppColors.teal,
                      title: (r['technician'] as Map<String, dynamic>?)?['profile']?['full_name'] as String? ?? (r['category'] as String? ?? ''),
                      subtitle: _requestStatusLabels[r['status']] ?? r['status'] as String? ?? '',
                      escrow: r['escrow_status'] == 'held',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MaintenanceRequestDetailScreen(request: r, isTechnician: false))),
                    ),
                    const SizedBox(height: 10),
                  ],
                  for (final j in _myJobs) ...[
                    _ThreadTile(
                      icon: Icons.badge_rounded,
                      iconColor: AppColors.categoryMaintenance,
                      title: (j['resident'] as Map<String, dynamic>?)?['full_name'] as String? ?? (j['category'] as String? ?? ''),
                      subtitle: _requestStatusLabels[j['status']] ?? j['status'] as String? ?? '',
                      escrow: j['escrow_status'] == 'held',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MaintenanceRequestDetailScreen(request: j, isTechnician: true))),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.onTap, this.escrow = false});
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool escrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis)),
                    if (escrow) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.gold)),
                  ]),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
