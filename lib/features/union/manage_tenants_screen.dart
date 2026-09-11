import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/union/union_service.dart';

/// Lets a unit owner invite/revoke a tenant sub-account for their own
/// unit — see backend/migrations/0018_tenant_accounts.sql. Only shows
/// units the caller actually owns (fetchMyOwnedUnits), so someone who
/// owns no unit sees an honest empty state instead of a broken form.
class ManageTenantsScreen extends StatefulWidget {
  const ManageTenantsScreen({super.key});

  @override
  State<ManageTenantsScreen> createState() => _ManageTenantsScreenState();
}

class _ManageTenantsScreenState extends State<ManageTenantsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _units = [];
  final Map<String, List<Map<String, dynamic>>> _tenantsByUnit = {};
  final Map<String, String> _lastCode = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final units = await UnionService.fetchMyOwnedUnits();
    for (final row in units) {
      final unit = row['unit'] as Map<String, dynamic>?;
      final unitId = unit?['id'] as String?;
      if (unitId != null) {
        _tenantsByUnit[unitId] = await UnionService.fetchUnitTenants(unitId: unitId);
      }
    }
    if (!mounted) return;
    setState(() {
      _units = units;
      _loading = false;
    });
  }

  Future<void> _invite(String unitId) async {
    try {
      final code = await UnionService.inviteTenant(unitId: unitId);
      if (!mounted) return;
      setState(() => _lastCode[unitId] = code);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إنشاء كود الدعوة، حاول مرة أخرى.')));
    }
  }

  Future<void> _revoke(String unitId, String tenantUserId) async {
    try {
      await UnionService.revokeTenant(unitId: unitId, tenantUserId: tenantUserId);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إلغاء صلاحية المستأجر، حاول مرة أخرى.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('إدارة حسابات المستأجرين')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _units.isEmpty
              ? ListView(children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                    child: Column(children: [
                      Icon(Icons.key_off_outlined, color: AppColors.inkMuted, size: 36),
                      SizedBox(height: 10),
                      Text('هذه الميزة متاحة فقط لمالكي الوحدات', textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                    ]),
                  ),
                ])
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    children: [
                      for (final row in _units) _UnitCard(
                        unit: row['unit'] as Map<String, dynamic>,
                        tenants: _tenantsByUnit[(row['unit'] as Map<String, dynamic>)['id']] ?? const [],
                        lastCode: _lastCode[(row['unit'] as Map<String, dynamic>)['id']],
                        onInvite: () => _invite((row['unit'] as Map<String, dynamic>)['id'] as String),
                        onRevoke: (tenantUserId) => _revoke((row['unit'] as Map<String, dynamic>)['id'] as String, tenantUserId),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit, required this.tenants, required this.lastCode, required this.onInvite, required this.onRevoke});
  final Map<String, dynamic> unit;
  final List<Map<String, dynamic>> tenants;
  final String? lastCode;
  final VoidCallback onInvite;
  final void Function(String tenantUserId) onRevoke;

  @override
  Widget build(BuildContext context) {
    final building = unit['building'] as Map<String, dynamic>?;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.door_front_door_outlined, color: AppColors.teal, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${unit['unit_number'] ?? ''} • ${unit['floor_label'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  if (building?['name'] != null) Text(building!['name'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 12),
          if (tenants.isEmpty)
            const Text('لا يوجد مستأجر مسجّل على هذه الوحدة حالياً', style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted))
          else
            ...tenants.map((t) {
              final profile = t['profile'] as Map<String, dynamic>?;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  const CircleAvatar(radius: 16, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile?['full_name'] as String? ?? 'مستأجر', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                        if (profile?['phone'] != null) Text(profile!['phone'] as String, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => onRevoke(t['user_id'] as String),
                    child: const Text('إلغاء الصلاحية', style: TextStyle(fontSize: 11, color: Colors.redAccent)),
                  ),
                ]),
              );
            }),
          const SizedBox(height: 6),
          if (lastCode != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(lastCode!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            ),
            const SizedBox(height: 6),
            const Text('شارك الكود ده مع المستأجر، هيدخل بيه على شقتك فوراً بدون مراجعة', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: onInvite,
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.navy, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
              label: const Text('إنشاء كود دعوة مستأجر جديد', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
