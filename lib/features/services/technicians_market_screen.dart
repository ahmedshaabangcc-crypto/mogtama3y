import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/maintenance/technician_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import 'escrow_booking_confirm_screen.dart';
import 'my_maintenance_requests_screen.dart';
import 'register_technician_screen.dart';
import 'technician_jobs_screen.dart';

const _categories = ['الكل', 'سباكة', 'كهرباء', 'تكييف وتبريد', 'نجارة', 'دهانات', 'أخرى'];

/// Verified technicians & services market, now reading the real
/// `technicians` directory (self-registered by neighbors) instead of
/// three hardcoded providers — see
/// backend/migrations/0022_technicians_maintenance.sql.
class TechniciansMarketScreen extends StatefulWidget {
  const TechniciansMarketScreen({super.key});

  @override
  State<TechniciansMarketScreen> createState() => _TechniciansMarketScreenState();
}

class _TechniciansMarketScreenState extends State<TechniciansMarketScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _technicians = [];
  int _categoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final category = _categoryIndex == 0 ? null : _categories[_categoryIndex];
    final rows = await TechnicianService.fetchTechnicians(category: category);
    if (!mounted) return;
    setState(() {
      _technicians = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('سوق الفنيين والخدمات المعتمدة'),
        actions: [
          if (AuthService.isSignedIn) ...[
            IconButton(
              tooltip: 'طلبات واردة لي كفني',
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TechnicianJobsScreen())),
              icon: const Icon(Icons.badge_outlined),
            ),
            IconButton(
              tooltip: 'طلباتي',
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyMaintenanceRequestsScreen())),
              icon: const Icon(Icons.receipt_long_outlined),
            ),
          ],
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
                child: const Text('Escrow ضمان مالي', style: TextStyle(fontSize: 10, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 4),
            const Text('صيانة منزلية موثقة بضمان مالي (Escrow) وتقييمات حقيقية من الجيران.',
                style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(14)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.shield_rounded, color: AppColors.teal, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('كيف يحميك ضمان مُجتمعي المالي (Escrow)؟', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                        SizedBox(height: 6),
                        Text(
                          'أتعاب الفني تظل معلقة بأمان في محفظتك، ولا تُصرف له إلا بعد فحصك التام للعمل وإعطائه «كود التسليم الرقمي».',
                          style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.7),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final selected = i == _categoryIndex;
                  return InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      setState(() => _categoryIndex = i);
                      _load();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected ? AppColors.navy : AppColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: selected ? AppColors.navy : AppColors.border),
                      ),
                      child: Text(_categories[i], style: TextStyle(fontSize: 11.5, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()))
            else if (_technicians.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('لا يوجد فنيون في هذا التخصص بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13))),
              )
            else
              for (final t in _technicians) ...[
                _TechnicianCard(technician: t),
                const SizedBox(height: 14),
              ],
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () async {
                  if (!AuthService.isSignedIn) {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
                    return;
                  }
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterTechnicianScreen()));
                  _load();
                },
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.navy, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.badge_outlined, size: 17),
                label: const Text('أنا فني وعايز أسجل خدماتي', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: const [
                  Text('ميثاق الجودة والأمان السكني', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  SizedBox(height: 6),
                  Text(
                    'الفنيون هنا جيران من نفس الأحياء سجّلوا خدماتهم بأنفسهم. راجع تقييمات الجيران قبل الحجز، ومبلغ المعاينة يظل محجوزاً في محفظتك حتى توافق على إتمام العمل.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted, height: 1.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechnicianCard extends StatelessWidget {
  const _TechnicianCard({required this.technician});
  final Map<String, dynamic> technician;

  @override
  Widget build(BuildContext context) {
    final profile = technician['profile'] as Map<String, dynamic>?;
    final name = profile?['full_name'] as String? ?? 'فني';
    final category = technician['category'] as String? ?? '';
    final rating = (technician['rating'] as num?)?.toDouble() ?? 5.0;
    final ratingCount = technician['rating_count'] as int? ?? 0;
    final isVerified = technician['is_verified'] == true;
    final serviceArea = technician['service_area'] as String?;
    final bio = technician['bio'] as String?;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 24, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted, size: 26)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 4),
                      if (isVerified) const Icon(Icons.verified_rounded, size: 14, color: AppColors.teal),
                    ]),
                    Text(category, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
                    Row(children: [
                      const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                      const SizedBox(width: 2),
                      Text('${rating.toStringAsFixed(1)} ($ratingCount تقييم)', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          if (bio != null && bio.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(bio, style: const TextStyle(fontSize: 11, color: AppColors.inkSecondary, height: 1.6)),
          ],
          if (serviceArea != null && serviceArea.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkMuted),
              const SizedBox(width: 3),
              Expanded(child: Text(serviceArea, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
            ]),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (!AuthService.isSignedIn) {
                  await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen()));
                  return;
                }
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => EscrowBookingConfirmScreen(
                    technicianId: technician['id'] as String,
                    providerName: name,
                    category: category,
                    rating: rating,
                    ratingCount: ratingCount,
                  ),
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              icon: const Icon(Icons.calendar_month_outlined, size: 15),
              label: const Text('طلب زيارة صيانة', style: TextStyle(fontSize: 11.5)),
            ),
          ),
        ],
      ),
    );
  }
}
