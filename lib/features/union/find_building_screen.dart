import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'election_voting_screen.dart';
import 'found_building_screen.dart';
import 'join_as_tenant_screen.dart';
import 'union_founding_success_screen.dart';
import 'union_registration_screen.dart';

enum _QuorumStatus { forming, newCluster, completed }

class _Building {
  const _Building({
    required this.name,
    required this.landmark,
    required this.status,
    required this.note,
    this.progress,
    this.progressLabel,
  });
  final String name, landmark, note;
  final _QuorumStatus status;
  final double? progress;
  final String? progressLabel;
}

const _buildings = [
  _Building(
    name: 'عمارة 14 – شارع دجلة الرئيسي',
    landmark: 'بجوار مدرسة كابيتال',
    status: _QuorumStatus.forming,
    progress: 0.58,
    progressLabel: 'اكتمال النصاب القانوني: 7 من 12 شقة انضموا (58%)',
    note: 'التصويت لتأسيس اتحاد الملاك جارٍ حالياً!',
  ),
  _Building(
    name: 'عمارة 8 ب – متفرع من الرئيسي',
    landmark: 'ناصية صيدلية الترجس',
    status: _QuorumStatus.newCluster,
    note: 'يحتاج إلى 4 شقق إضافية لبدء انتخاب الممثل',
  ),
  _Building(
    name: 'عمارة 22 – شارع دجلة',
    landmark: 'أمام المركز الطبي',
    status: _QuorumStatus.completed,
    note: 'تم استيفاء نصاب الملاك بالكامل (16/16 شقة)',
  ),
];

/// Find your building & join its owners' union — matches
/// design/screens/43_find_building_join.png.
class FindBuildingScreen extends StatelessWidget {
  const FindBuildingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('البحث عن عقارك والانضمام')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                  child: const Text('خطوة التأسيس', style: TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                const Text('لعمارات بدون اتحاد ملاك رسمي — ابدأ بجمع جيرانك وتأسيس مجلس إدارتكم الرقمي بكل سهولة وشفافية.',
                    style: TextStyle(color: Colors.white, fontSize: 12.5, height: 1.8)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _FieldLabel('البحث عن موقع العقار'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: const Row(
              children: [
                Icon(Icons.my_location_rounded, size: 16, color: AppColors.teal),
                SizedBox(width: 6),
                Text('تحديث فوري', style: TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
                SizedBox(width: 10),
                Expanded(child: Text('شارع دجلة الرئيسي', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                Icon(Icons.search_rounded, size: 18, color: AppColors.inkMuted),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('المحافظة'),
                    const SizedBox(height: 6),
                    _DropdownBox(text: 'القاهرة'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('الحي / المجاورة'),
                    const SizedBox(height: 6),
                    _DropdownBox(text: 'المعادي - دجلة'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                  child: const Text('الأقل نسبة انضمام', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
                  child: const Text('عمارات بها تجمع فيد التأسيس', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 130,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
            child: Stack(
              children: [
                const Center(child: Icon(Icons.map_rounded, size: 34, color: AppColors.inkMuted)),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.location_on_rounded, size: 13, color: AppColors.teal),
                      SizedBox(width: 4),
                      Text('خريطة تفاعلية', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('العمارات المتاحة بالشارع (3) — مرتبة حسب النشاط',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          for (final b in _buildings) ...[
            _BuildingCard(building: b),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(children: [
                  Icon(Icons.apartment_rounded, color: AppColors.teal, size: 20),
                  SizedBox(width: 8),
                  Text('لم تجد عمارتك بالقائمة؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ]),
                const SizedBox(height: 8),
                const Text(
                  'كن أنت المبادر الأول! أضف عقارك واحصل على رابط دعوة فوري ورقمي قابل للمشاركة لتعليمه بمدخل العمارة لدعوة باقي الجيران.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FoundBuildingScreen())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text('إضافة وتسجيل عنوان عمارتك وبدء دعوة الجيران', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JoinAsTenantScreen())),
              icon: const Icon(Icons.key_rounded, size: 16, color: AppColors.teal),
              label: const Text('عندي كود دعوة من مالك شقتي (مستأجر)', style: TextStyle(fontSize: 12, color: AppColors.teal, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.help_outline_rounded, size: 16, color: AppColors.inkMuted),
              label: const Text('كيف نصل لنصاب الـ 51% قانونياً؟', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary));
  }
}

class _DropdownBox extends StatelessWidget {
  const _DropdownBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12.5), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.expand_more_rounded, size: 18, color: AppColors.inkMuted),
        ],
      ),
    );
  }
}

class _BuildingCard extends StatelessWidget {
  const _BuildingCard({required this.building});
  final _Building building;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.apartment_rounded, color: AppColors.inkSecondary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(building.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
                    Row(children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.inkMuted),
                      const SizedBox(width: 2),
                      Expanded(child: Text(building.landmark, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                ),
              ),
              _StatusBadge(status: building.status),
            ],
          ),
          const SizedBox(height: 12),
          if (building.progress != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: building.progress,
                minHeight: 7,
                backgroundColor: AppColors.surfaceAlt,
                valueColor: const AlwaysStoppedAnimation(AppColors.teal),
              ),
            ),
            const SizedBox(height: 6),
            Text(building.progressLabel ?? '', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
            const SizedBox(height: 6),
          ],
          if (building.status == _QuorumStatus.forming)
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ElectionVotingScreen(buildingName: building.name))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(building.note, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.inkSecondary)),
                  ),
                  const Icon(Icons.chevron_left_rounded, size: 16, color: AppColors.inkMuted),
                ],
              ),
            )
          else
            Text(building.note,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: building.status == _QuorumStatus.completed ? AppColors.teal : AppColors.inkSecondary,
                )),
          const SizedBox(height: 10),
          if (building.status == _QuorumStatus.completed) ...[
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => UnionFoundingSuccessScreen(buildingName: building.name))),
                  child: const Text('عرض لائحة الجمعية', style: TextStyle(fontSize: 12)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(8)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.lock_outline_rounded, size: 12, color: AppColors.inkMuted),
                    SizedBox(width: 4),
                    Text('باب الترشح مغلق (مرحلة إعلان النتيجة)', style: TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                  ]),
                ),
              ],
            ),
          ] else
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => UnionRegistrationScreen(buildingName: building.name)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: building.status == _QuorumStatus.forming ? AppColors.navy : AppColors.surface,
                  foregroundColor: building.status == _QuorumStatus.forming ? Colors.white : AppColors.ink,
                  side: building.status == _QuorumStatus.forming ? null : const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(building.status == _QuorumStatus.forming ? Icons.groups_rounded : Icons.login_rounded, size: 16),
                label: Text(building.status == _QuorumStatus.forming ? 'انضم لجروب سكان العمارة الآن' : 'انضم للعمارة',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final _QuorumStatus status;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;
    late final IconData icon;
    switch (status) {
      case _QuorumStatus.forming:
        label = 'قيد اكتمال النصاب';
        color = AppColors.gold;
        icon = Icons.hourglass_bottom_rounded;
      case _QuorumStatus.newCluster:
        label = 'تجمع جديد (4 شقق)';
        color = AppColors.categoryUnion;
        icon = Icons.fiber_new_rounded;
      case _QuorumStatus.completed:
        label = 'مكتمل وجاري فرز الأصوات';
        color = AppColors.teal;
        icon = Icons.verified_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: color)),
      ]),
    );
  }
}
