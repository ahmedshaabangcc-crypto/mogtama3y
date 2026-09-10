import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'auction_detail_screen.dart';

class _Lot {
  const _Lot({
    required this.badge,
    required this.badgeIsPersonal,
    required this.title,
    required this.description,
    required this.weightNote,
    required this.location,
    required this.currentBid,
    required this.offerLabel,
    required this.ctaLabel,
    required Duration remaining,
  }) : initialRemaining = remaining;

  final String badge, title, description, weightNote, location, offerLabel, ctaLabel;
  final bool badgeIsPersonal;
  final int currentBid;
  final Duration initialRemaining;
}

final _lots = [
  _Lot(
    badge: 'عائد شخصي للمالك',
    badgeIsPersonal: true,
    title: 'خردة 2 تكييف سبليت قديم + مواسير نحاس',
    description: '2 تكييف سبليت حصان 2.25 + غسالة تالفة',
    weightNote: 'الوزن التقديري: 48 كجم نحاس',
    location: 'شارع النصر، المعادي',
    currentBid: 1850,
    offerLabel: '4 عروض تجار',
    ctaLabel: 'متابعة المزاد',
    remaining: const Duration(hours: 4, minutes: 15),
  ),
  _Lot(
    badge: 'ريع مخصص لصندوق صيانة برج الياسمين',
    badgeIsPersonal: false,
    title: 'حديد تسليح وأبواب ألوميتال مجددة',
    description: 'أسياخ حديد وأبواب ألوميتال بحالة جيدة',
    weightNote: 'منح وزن فوري بميزان رقمي',
    location: 'بدروم برج الياسمين',
    currentBid: 920,
    offerLabel: '2 عروض معتمدة',
    ctaLabel: 'تفاصيل المزاد',
    remaining: const Duration(hours: 1, minutes: 40, seconds: 22),
  ),
  _Lot(
    badge: 'عائد شخصي للمالك',
    badgeIsPersonal: true,
    title: 'مجموعة كراتين ودفاتر مدرسية ومجلات قديمة',
    description: 'كراتين وورق أرشيف ومجلات ودفاتر قديمة',
    weightNote: 'حمولة تقريبية: 70 كجم',
    location: 'مدخل عمارة 12',
    currentBid: 310,
    offerLabel: '3 عروض تجار',
    ctaLabel: 'متابعة المزاد',
    remaining: const Duration(hours: 9, minutes: 12, seconds: 45),
  ),
];

/// Recycling & scrap ("بيكيا") marketplace with live auctions — matches
/// design/screens/19_recycling_marketplace.png.
class RecyclingMarketplaceScreen extends StatefulWidget {
  const RecyclingMarketplaceScreen({super.key});

  @override
  State<RecyclingMarketplaceScreen> createState() => _RecyclingMarketplaceScreenState();
}

class _RecyclingMarketplaceScreenState extends State<RecyclingMarketplaceScreen> {
  late final List<Duration> _remaining = _lots.map((l) => l.initialRemaining).toList();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        for (var i = 0; i < _remaining.length; i++) {
          if (_remaining[i].inSeconds > 0) _remaining[i] -= const Duration(seconds: 1);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('سوق البيكيا وتدوير المخلفات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF0E4A38), borderRadius: BorderRadius.circular(16)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.recycling_rounded, color: AppColors.tealLight, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('أثر مجتمعي مستدام', style: TextStyle(color: AppColors.tealLight, fontSize: 10.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      const Text('حي المعادي أعاد تدوير 1,420 كجم هذا الشهر!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14, height: 1.4)),
                      const SizedBox(height: 4),
                      const Text('تم تحويل مخلفات الأجهزة والمعادن إلى طاقة وموارد مفيدة', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(value: 0.71, minHeight: 6, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(AppColors.tealLight)),
                      ),
                      const SizedBox(height: 4),
                      Row(children: const [
                        Text('71%', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                        Spacer(),
                        Text('الهدف الشهري للحي (2,000 كجم)', style: TextStyle(color: Colors.white70, fontSize: 9.5)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.payments_outlined, color: AppColors.gold, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تخلص من الخردة والأجهزة القديمة', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.5)),
                    SizedBox(height: 3),
                    Text('اربح عائداً نقدياً فورياً أو وجّه بنقرة واحدة لصندوق صيانة وتجميل عمارتك.', style: TextStyle(color: Colors.white70, fontSize: 10, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          const _FilterChips(),
          const SizedBox(height: 18),
          Row(children: [
            const Expanded(child: Text('مزادات الخردة النشطة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.circle, size: 6, color: AppColors.teal),
                SizedBox(width: 4),
                Text('مزادات موثقة', style: TextStyle(fontSize: 9.5, color: AppColors.teal, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 10),
          for (var i = 0; i < _lots.length; i++) ...[
            _LotCard(lot: _lots[i], remainingLabel: _format(_remaining[i]), remaining: _remaining[i]),
            const SizedBox(height: 14),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(12)),
            child: Row(children: const [
              Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.inkSecondary),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سيارة تجميع المخلفات المعتمدة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    SizedBox(height: 3),
                    Text('تتحرك يوم خميس من 9 صباحاً إلى 2 ظهراً بميزان معتمد للدفع الفوري.', style: TextStyle(fontSize: 10, color: AppColors.inkMuted, height: 1.6)),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('إضافة خردة أو بيكيا جديدة للمزاد (بيع أو تبرع)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    const chips = ['الكل', 'أجهزة ومكيفات', 'معادن وحديد', 'ورق وكرتون', 'أثاث خشب'];
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

class _LotCard extends StatelessWidget {
  const _LotCard({required this.lot, required this.remainingLabel, required this.remaining});
  final _Lot lot;
  final String remainingLabel;
  final Duration remaining;

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
              Container(height: 140, color: AppColors.surfaceAlt, child: const Center(child: Icon(Icons.recycling_rounded, size: 34, color: AppColors.inkMuted))),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: lot.badgeIsPersonal ? Colors.black87 : AppColors.teal, borderRadius: BorderRadius.circular(8)),
                  child: Text(lot.badge, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.timer_outlined, size: 12, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(remainingLabel, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
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
                Text(lot.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, height: 1.4)),
                const SizedBox(height: 6),
                Text('الموقع: ${lot.location} • ${lot.weightNote}', style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('أعلى عرض معتمد', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                          Text('${lot.currentBid} ج.م', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.teal)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(100)),
                      child: Text(lot.offerLabel, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => AuctionDetailScreen(
                        title: lot.title,
                        lotNumber: '#${4800 + lot.title.length}',
                        description: lot.description,
                        weightNote: lot.weightNote,
                        location: lot.location,
                        currentBid: lot.currentBid,
                        bidderName: 'ورشة المعادي للتوريدات',
                        offerCount: int.tryParse(lot.offerLabel.split(' ').first) ?? 1,
                        remaining: remaining,
                      ),
                    )),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text(lot.ctaLabel, style: const TextStyle(fontSize: 12.5)),
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
