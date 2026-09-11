import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/guard/guard_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';

const _passTypeLabels = {
  'delivery': 'دليفري طلبات',
  'guest': 'ضيف',
  'maintenance': 'صيانة',
  'other': 'أخرى',
};

/// The building guard's real console — see
/// backend/migrations/0019_guard_console.sql. A guard is appointed by
/// the union president/board (building_guards), not a resident role,
/// so this screen branches three ways depending on who's looking:
///  * an active guard sees the real scan/verify + custody console.
///  * a president/board member with no guard sees an appointment panel.
///  * anyone else sees an honest "not available to you" message.
class GuardConsoleScreen extends StatefulWidget {
  const GuardConsoleScreen({super.key});

  @override
  State<GuardConsoleScreen> createState() => _GuardConsoleScreenState();
}

class _GuardConsoleScreenState extends State<GuardConsoleScreen> {
  bool _loading = true;
  Map<String, dynamic>? _guardAssignment;
  Map<String, dynamic>? _membership;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final guardAssignment = await GuardService.fetchMyGuardAssignment();
    final membership = guardAssignment == null ? await UnionService.fetchMyMembership() : null;
    if (!mounted) return;
    setState(() {
      _guardAssignment = guardAssignment;
      _membership = membership;
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
    if (_guardAssignment != null) {
      final building = _guardAssignment!['building'] as Map<String, dynamic>?;
      return _GuardWorkConsole(buildingId: _guardAssignment!['building_id'] as String, buildingName: building?['name'] as String? ?? '');
    }
    final role = _membership?['role'] as String?;
    final status = _membership?['status'] as String?;
    if (status == 'verified' && (role == 'president' || role == 'board_member')) {
      return _AppointGuardPanel(buildingId: _membership!['building_id'] as String);
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة تحكم حارس العقار')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.security_outlined, color: AppColors.inkMuted, size: 36),
            const SizedBox(height: 12),
            const Text('هذه اللوحة متاحة فقط للحارس المعتمد من رئيس الاتحاد', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ]),
        ),
      ),
    );
  }
}

class _GuardWorkConsole extends StatefulWidget {
  const _GuardWorkConsole({required this.buildingId, required this.buildingName});
  final String buildingId, buildingName;

  @override
  State<_GuardWorkConsole> createState() => _GuardWorkConsoleState();
}

class _GuardWorkConsoleState extends State<_GuardWorkConsole> {
  bool _loading = true;
  List<Map<String, dynamic>> _recentPasses = [];
  List<Map<String, dynamic>> _custodyItems = [];
  final _codeCtrl = TextEditingController();
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final passes = await GuardService.fetchRecentPasses(widget.buildingId);
    final custody = await GuardService.fetchCustodyItems(widget.buildingId);
    if (!mounted) return;
    setState(() {
      _recentPasses = passes;
      _custodyItems = custody;
      _loading = false;
    });
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    setState(() => _verifying = true);
    try {
      final result = await GuardService.verifyPass(code);
      _codeCtrl.clear();
      if (!mounted) return;
      final label = _passTypeLabels[result['pass_type']] ?? result['pass_type'];
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('تم التحقق ✓'),
          content: Text('${result['visitor_name']} • $label\nشقة ${result['unit_number']} - ${result['floor_label'] ?? ''}'),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))],
        ),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _handOver(String itemId) async {
    await GuardService.markCustodyHandedOver(itemId);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final verifiedToday = _recentPasses.where((p) => p['status'] == 'used' && _isSameDay(DateTime.tryParse(p['created_at'] as String? ?? ''), today)).length;
    final deliveriesToday = _recentPasses.where((p) => p['pass_type'] == 'delivery' && p['status'] == 'used' && _isSameDay(DateTime.tryParse(p['created_at'] as String? ?? ''), today)).length;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('لوحة تحكم حارس العقار')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                const CircleAvatar(radius: 24, backgroundColor: Colors.white24, child: Icon(Icons.security_rounded, color: Colors.white, size: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.buildingName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                        child: const Text('حارس معتمد من رئيس الاتحاد', style: TextStyle(fontSize: 8.5, color: AppColors.tealLight, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _StatTile(icon: Icons.qr_code_scanner_rounded, value: '$verifiedToday', label: 'زوار تم التحقق منهم اليوم')),
              const SizedBox(width: 8),
              Expanded(child: _StatTile(icon: Icons.inventory_2_outlined, value: '$deliveriesToday', label: 'طرود مستلمة اليوم')),
              const SizedBox(width: 8),
              Expanded(child: _StatTile(icon: Icons.key_outlined, value: '${_custodyItems.length}', label: 'أمانات تحت العهدة')),
            ]),
            const SizedBox(height: 20),
            const Text('التحقق من تصريح زائر', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _codeCtrl,
                  textAlign: TextAlign.center,
                  onSubmitted: (_) => _verify(),
                  style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2),
                  decoration: InputDecoration(
                    hintText: 'PASS-XXXXXX',
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.teal, width: 1.4)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _verifying ? null : _verify,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _verifying
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_rounded),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            const Text('اطلب من الزائر كود التصريح المكتوب أو المعروض له من الساكن', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            const SizedBox(height: 22),
            const Text('آخر عمليات المسح والتحقق', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
            else if (_recentPasses.isEmpty)
              const Text('لا توجد عمليات تحقق حتى الآن', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final p in _recentPasses) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(p['status'] == 'expired' ? Icons.timer_off_outlined : Icons.check_circle_outline_rounded, color: AppColors.teal, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['visitor_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                          Text('شقة ${p['unit_number']} • ${_passTypeLabels[p['pass_type']] ?? p['pass_type']}', style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            const SizedBox(height: 12),
            Row(children: [
              const Expanded(child: Text('الأمانات والمفقودات تحت عهدتك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                child: Text('${_custodyItems.length} أمانة', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 10),
            if (_custodyItems.isEmpty)
              const Text('لا توجد أمانات تحت عهدتك حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
            else
              for (final item in _custodyItems) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.inventory_outlined, color: AppColors.gold, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(item['location_note'] as String? ?? (item['category'] as String? ?? ''), style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    TextButton(onPressed: () => _handOver(item['id'] as String), child: const Text('تسليم', style: TextStyle(fontSize: 11))),
                  ]),
                ),
              ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
              child: const Row(children: [
                Icon(Icons.shield_outlined, size: 16, color: AppColors.inkSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'صلاحياتك كحارس معتمد تخضع لتعيين ومراجعة رئيس اتحاد الملاك، ويمكن سحبها في أي وقت من لوحة إدارة الاتحاد.',
                    style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6),
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

bool _isSameDay(DateTime? a, DateTime b) {
  if (a == null) return false;
  final local = a.toLocal();
  return local.year == b.year && local.month == b.month && local.day == b.day;
}

class _AppointGuardPanel extends StatefulWidget {
  const _AppointGuardPanel({required this.buildingId});
  final String buildingId;

  @override
  State<_AppointGuardPanel> createState() => _AppointGuardPanelState();
}

class _AppointGuardPanelState extends State<_AppointGuardPanel> {
  bool _loading = true;
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _guards = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final members = await UnionService.fetchVerifiedMembers(widget.buildingId);
    final guards = await GuardService.fetchGuardsFor(widget.buildingId);
    if (!mounted) return;
    setState(() {
      _members = members;
      _guards = guards;
      _loading = false;
    });
  }

  Future<void> _appoint(String userId) async {
    try {
      await GuardService.appointGuard(buildingId: widget.buildingId, userId: userId);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تعيين الحارس، حاول مرة أخرى.')));
    }
  }

  Future<void> _revoke(String userId) async {
    await GuardService.revokeGuard(buildingId: widget.buildingId, userId: userId);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final guardUserIds = _guards.map((g) => g['user_id'] as String).toSet();
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تعيين حارس العقار')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
                    child: const Text(
                      'اختر أحد جيرانك الموثقين ليكون حارس العقار، وهيقدر يتحقق من تصاريح الزوار ويستلم الأمانات المفقودة نيابة عن العمارة.',
                      style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.8),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (_guards.isNotEmpty) ...[
                    const Text('الحراس الحاليون', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    const SizedBox(height: 8),
                    for (final g in _guards) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.teal.withValues(alpha: 0.3))),
                        child: Row(children: [
                          const Icon(Icons.security_rounded, color: AppColors.teal, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text((g['profile'] as Map<String, dynamic>?)?['full_name'] as String? ?? '', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
                          TextButton(onPressed: () => _revoke(g['user_id'] as String), child: const Text('إلغاء التعيين', style: TextStyle(fontSize: 11, color: Colors.redAccent))),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 12),
                  ],
                  const Text('اختر من سكان العمارة الموثقين', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  const SizedBox(height: 8),
                  if (_members.isEmpty)
                    const Text('لا يوجد سكان موثقون بعد', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
                  else
                    for (final m in _members) ...[
                      Builder(builder: (context) {
                        final userId = m['user_id'] as String;
                        final isGuard = guardUserIds.contains(userId);
                        final profile = m['profile'] as Map<String, dynamic>?;
                        final unit = m['unit'] as Map<String, dynamic>?;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                          child: Row(children: [
                            const CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(profile?['full_name'] as String? ?? '', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                                  if (unit != null) Text('شقة ${unit['unit_number']}', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                                ],
                              ),
                            ),
                            if (isGuard)
                              const Text('حارس حالياً', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w700))
                            else
                              TextButton(onPressed: () => _appoint(userId), child: const Text('تعيين كحارس', style: TextStyle(fontSize: 11))),
                          ]),
                        );
                      }),
                    ],
                ],
              ),
            ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          Text(label, style: const TextStyle(fontSize: 8.5, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
