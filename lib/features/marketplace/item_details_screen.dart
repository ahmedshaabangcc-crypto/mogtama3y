import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';

const _conditionLabels = {
  'new': 'جديد',
  'like_new': 'شبه جديد (كالجديد)',
  'light_use': 'استعمال خفيف',
  'used': 'بحالة متوسطة',
  'heavy_use': 'استعمال كثيف',
};

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
  return 'منذ ${(diff.inDays / 30).floor()} شهر';
}

/// Item details screen for a real `marketplace_listings` row — matches
/// design/screens/05_item_details.png.
class ItemDetailsScreen extends StatelessWidget {
  const ItemDetailsScreen({super.key, required this.listing});
  final Map<String, dynamic> listing;

  @override
  Widget build(BuildContext context) {
    final title = listing['title'] as String? ?? 'إعلان بدون عنوان';
    final description = listing['description'] as String?;
    final price = (listing['price'] as num?)?.toDouble() ?? 0;
    final isNegotiable = listing['is_negotiable'] as bool? ?? false;
    final condition = listing['condition'] as String? ?? 'used';
    final images = (listing['images'] as List?)?.cast<String>() ?? const [];
    final createdAt = DateTime.tryParse(listing['created_at'] as String? ?? '') ?? DateTime.now();
    final id = listing['id'] as String? ?? '';
    final itemCode = id.length >= 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();
    final sellerProfile = listing['seller'] as Map<String, dynamic>?;
    final sellerName = sellerProfile?['full_name'] as String? ?? 'بائع مُجتمعي';
    final sellerVerified = sellerProfile?['is_verified'] as bool? ?? false;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('تفاصيل السلعة'),
        actions: const [
          Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.storefront_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded, size: 20),
              const SizedBox(width: 16),
              const Icon(Icons.share_outlined, size: 20),
              const Spacer(),
              const Text('سوق الحي المستعمل • تفاصيل القطعة', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: images.isEmpty
                    ? Container(
                        height: 200,
                        color: AppColors.surfaceAlt,
                        child: const Center(child: Icon(Icons.image_outlined, size: 56, color: AppColors.inkMuted)),
                      )
                    : Image.network(
                        images.first,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 200,
                          color: AppColors.surfaceAlt,
                          child: const Center(child: Icon(Icons.image_outlined, size: 56, color: AppColors.inkMuted)),
                        ),
                      ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(8)),
                  child: Text(_conditionLabels[condition] ?? condition, style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.5)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.inkMuted),
              const SizedBox(width: 4),
              Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
              const Spacer(),
              Text('رمز القطعة: #MKT-$itemCode', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(NumberFormat('#,##0').format(price), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.teal)),
              const SizedBox(width: 6),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('جنيه مصري', style: TextStyle(fontSize: 13, color: AppColors.inkMuted)),
              ),
              if (isNegotiable) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                  child: const Text('قابل للتفاوض', style: TextStyle(fontSize: 10, color: AppColors.gold, fontWeight: FontWeight.w600)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const _EscrowNotice(),
          const SizedBox(height: 16),
          _SellerCard(name: sellerName, verified: sellerVerified),
          const SizedBox(height: 20),
          const _SectionTitle(icon: Icons.description_outlined, title: 'وصف السلعة وحالتها'),
          const SizedBox(height: 8),
          Text(
            (description == null || description.trim().isEmpty) ? 'لم يضف البائع وصفاً تفصيلياً لهذه السلعة.' : description,
            style: const TextStyle(fontSize: 13, height: 1.9, color: AppColors.inkSecondary),
          ),
          const SizedBox(height: 20),
          const _SectionTitle(icon: Icons.handshake_outlined, title: 'ميثاق حسن الجوار للبيع والشراء'),
          const SizedBox(height: 8),
          const _CharterLine(text: 'يحق للمشتري معاينة وفحص القطعة وتشغيلها للتأكد قبل تحويل المبلغ أو سداده.'),
          const _CharterLine(text: 'الحجز الآمن يضمن حجب السلعة عن باقي الأعضاء لمدة 24 ساعة للتسليم المباشر.'),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 17),
                    label: const Text('محادثة آمنة مع الجار'),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                    icon: const Icon(Icons.lock_outline_rounded, size: 17),
                    label: const Text('حجز بالضمان (24س)'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EscrowNotice extends StatelessWidget {
  const _EscrowNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.teal, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.shield_outlined, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('حماية مُجتمعي الموثوقة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    SizedBox(width: 6),
                    Text('آمن 100%', style: TextStyle(color: AppColors.teal, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'التسليم يتم يدًا بيد داخل المجمع السكني مع إيداع الأمانة عبر بوابة مُجتمعي الرئيسية، بدون شركات شحن وبدون أي تحويلات خارجية مجهولة.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({required this.name, required this.verified});
  final String name;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                    if (verified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, color: AppColors.teal, size: 14),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(verified ? 'جار موثّق' : 'عضو مُجتمعي', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.ink),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
      ],
    );
  }
}

class _CharterLine extends StatelessWidget {
  const _CharterLine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.teal, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.6))),
        ],
      ),
    );
  }
}
