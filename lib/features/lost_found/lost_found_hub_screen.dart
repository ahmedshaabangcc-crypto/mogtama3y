import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'add_lost_found_item_screen.dart';

enum _ItemKind { key, wallet, pet }

class _LostFoundItem {
  const _LostFoundItem({
    required this.kind,
    required this.categoryLabel,
    required this.overlayNote,
    required this.time,
    required this.title,
    required this.location,
    required this.custodyLabel,
    required this.custodyNote,
    required this.ctaLabel,
    required this.isLostReport,
  });
  final _ItemKind kind;
  final String categoryLabel, overlayNote, time, title, location, custodyLabel, custodyNote, ctaLabel;
  final bool isLostReport;
}

const _items = [
  _LostFoundItem(
    kind: _ItemKind.key,
    categoryLabel: 'مفاتيح وسيارات',
    overlayNote: 'طمس ذكي للعلامة والشعار لحماية الملكية',
    time: 'اليوم، 11:30 صباحاً',
    title: 'ميدالية مفاتيح سيارة تويوتا حديثة',
    location: 'تم العثور عليها بمدخل عمارة 16 - دجلة',
    custodyLabel: 'أمانة محفوظة وموثقة',
    custodyNote: 'مودعة طرف عم رجب (حارس العقار المعتمد)',
    ctaLabel: 'هذا الغرض يخصني (مطابقة العلامة واستلام الأمانة)',
    isLostReport: false,
  ),
  _LostFoundItem(
    kind: _ItemKind.wallet,
    categoryLabel: 'محافظ وبطاقات',
    overlayNote: 'تم تشفير وطمس بيانات الهوية والبطاقات',
    time: 'أمس، 06:15 مساءً',
    title: 'محفظة جلدية رجالية بنية مع مستندات',
    location: 'تم العثور عليها قرب حديقة عمارة دجلة',
    custodyLabel: 'حراسة وغرفة الأمن',
    custodyNote: 'الأمانة بغرفة أمن برج الياسمين',
    ctaLabel: 'إثبات الملكية',
    isLostReport: false,
  ),
  _LostFoundItem(
    kind: _ItemKind.pet,
    categoryLabel: 'مكافأة مالية',
    overlayNote: 'بلاغ مفقود (بحث جاري)',
    time: 'مفقودة منذ يومين',
    title: 'قطة شيرازي بيضاء ضائعة (تستجيب لاسم سكر)',
    location: 'بلاغ مفقود من الجار - شقة 302',
    custodyLabel: 'طوق وردي مميز',
    custodyNote: 'مكافأة مجزية لمن يعثر عليها (التواصل عبر المحادثة الآمنة المشفرة)',
    ctaLabel: 'تواصل مشفر مع صاحب البلاغ أو إبلاغ بمشاهدة',
    isLostReport: true,
  ),
];

/// Lost & found hub — matches design/screens/40_lost_and_found_hub.png.
class LostFoundHubScreen extends StatefulWidget {
  const LostFoundHubScreen({super.key});

  @override
  State<LostFoundHubScreen> createState() => _LostFoundHubScreenState();
}

class _LostFoundHubScreenState extends State<LostFoundHubScreen> {
  int _tab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('المفقودات والمعثور عليها في الحي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const Text(
            'منظومة موثقة لحفظ المفقودات والأمانات برعاية حراس العقارات المعتمدين مع تشفير العلامات المميزة.',
            style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ModeTile(
                  icon: Icons.search_off_rounded,
                  title: 'أغراض مفقودة (Lost)',
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ModeTile(
                  icon: Icons.inventory_2_outlined,
                  title: 'معثور عليه في الحي (Found)',
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: const Row(children: [
              Icon(Icons.search_rounded, color: AppColors.inkMuted, size: 20),
              SizedBox(width: 8),
              Text('ابحث عن مفتاح، محفظة، هاتف، أو موقع...', style: TextStyle(color: AppColors.inkMuted, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 12),
          const _FilterChips(),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.privacy_tip_outlined, size: 16, color: AppColors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'تنبيه أمان وتسليم: لا يوجد دليفري للمفقودات؛ الاستلام يتم شخصياً بعد إثبات العلامة السرية ومطابقة الرمز التشفيري مع الحارس الأمين.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.teal, height: 1.7),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            const Expanded(child: Text('أحدث البلاغات والأمانات المودعة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
              child: const Text('تعتيم ذكي للعلامات السرية', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ]),
          const SizedBox(height: 10),
          for (final item in _items) ...[
            _ItemCard(item: item),
            const SizedBox(height: 14),
          ],
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddLostFoundItemScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('تسجيل بلاغ مفقود أو معثور عليه جديد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({required this.icon, required this.title, required this.selected, required this.onTap});
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.teal.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.teal : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.teal : AppColors.inkSecondary, size: 22),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: selected ? AppColors.teal : AppColors.inkSecondary)),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل', 'مفاتيح', 'محافظ وبطاقات', 'إلكترونية'];
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.navy : AppColors.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: selected ? AppColors.navy : AppColors.border),
            ),
            child: Text(chips[i], style: TextStyle(fontSize: 11.5, color: selected ? Colors.white : AppColors.inkSecondary, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});
  final _LostFoundItem item;

  IconData get _icon => switch (item.kind) {
        _ItemKind.key => Icons.vpn_key_rounded,
        _ItemKind.wallet => Icons.account_balance_wallet_rounded,
        _ItemKind.pet => Icons.pets_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(height: 140, color: AppColors.surfaceAlt, child: Center(child: Icon(_icon, size: 36, color: AppColors.inkMuted))),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: item.isLostReport ? AppColors.categorySos : Colors.black87, borderRadius: BorderRadius.circular(8)),
                  child: Text(item.categoryLabel, style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  color: Colors.black54,
                  child: Row(children: [
                    const Icon(Icons.blur_on_rounded, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Expanded(child: Text(item.overlayNote, style: const TextStyle(fontSize: 9.5, color: Colors.white), overflow: TextOverflow.ellipsis)),
                  ]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.access_time_rounded, size: 12, color: AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text(item.time, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ]),
                const SizedBox(height: 6),
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, height: 1.4)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Expanded(child: Text(item.location, style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const Icon(Icons.verified_user_outlined, size: 15, color: AppColors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.custodyLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                          Text(item.custodyNote, style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text(item.ctaLabel, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
