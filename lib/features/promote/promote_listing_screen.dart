import 'package:flutter/material.dart';

import '../../core/promote/ad_token_service.dart';
import '../../core/theme/app_colors.dart';
import 'token_wallet_screen.dart';
import 'top_up_tokens_screen.dart';

const _categoryLabels = {
  'marketplace_listings': 'سوق المستعمل',
  'real_estate_listings': 'عقارات',
  'job_postings': 'وظائف',
};

/// Feature/promote any of the three real ad types (marketplace listing,
/// real estate listing, job posting) so it shows first with a "مميز"
/// badge — pays per day out of the real token balance. See
/// backend/migrations/0026_ad_tokens.sql.
class PromoteListingScreen extends StatefulWidget {
  const PromoteListingScreen({super.key, required this.listingTable, required this.listingId, required this.listingTitle});
  final String listingTable, listingId, listingTitle;

  @override
  State<PromoteListingScreen> createState() => _PromoteListingScreenState();
}

class _PromoteListingScreenState extends State<PromoteListingScreen> {
  bool _loading = true;
  int _days = 3;
  int _balance = 0;
  int _dailyRate = 1;
  bool _confirmed = false;
  bool _submitting = false;

  int get _cost => _days * _dailyRate;
  bool get _canAfford => _cost <= _balance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final settings = await AdTokenService.fetchSettings();
    final balance = await AdTokenService.fetchMyBalance();
    if (!mounted) return;
    setState(() {
      _dailyRate = settings['daily_rate_tokens'] as int? ?? 1;
      _balance = balance;
      _loading = false;
    });
  }

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    try {
      await AdTokenService.featureListing(listingTable: widget.listingTable, listingId: widget.listingId, days: _days);
      if (!mounted) return;
      setState(() => _confirmed = true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر تمييز الإعلان، حاول مرة أخرى.')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_confirmed) return _buildConfirmed(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('تمييز الإعلان'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('تخطي', style: TextStyle(color: Colors.white)))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.image_outlined, color: AppColors.inkMuted),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.listingTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(_categoryLabels[widget.listingTable] ?? '', style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: const Row(children: [
              Icon(Icons.bolt_rounded, color: AppColors.gold),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'الإعلانات المميزة تظهر أولاً في نتائج البحث وبعلامة "مميز" ذهبية لجذب أكبر عدد من الجيران.',
                  style: TextStyle(fontSize: 10.5, color: AppColors.gold, height: 1.7, fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('عدد أيام التمييز', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final d in [1, 3, 7]) ...[
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _days = d),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _days == d ? AppColors.navy : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _days == d ? AppColors.navy : AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Text('$d ${d == 1 ? 'يوم' : 'أيام'}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _days == d ? Colors.white : AppColors.ink)),
                          Text('${d * _dailyRate} توكن', style: TextStyle(fontSize: 9.5, color: _days == d ? Colors.white70 : AppColors.inkMuted)),
                        ],
                      ),
                    ),
                  ),
                ),
                if (d != 7) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Row(children: [
                  const Text('السعر اليومي الحالي', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary)),
                  const Spacer(),
                  Text('$_dailyRate توكن / يوم', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                ]),
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 8),
                Row(children: [
                  const Text('إجمالي التكلفة', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const Spacer(),
                  Text('$_cost توكن', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.teal)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Text('رصيدك الحالي', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  const Spacer(),
                  Text('$_balance توكن', style: TextStyle(fontSize: 10, color: _canAfford ? AppColors.inkMuted : AppColors.categorySos, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
          if (!_canAfford) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.categorySos.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.categorySos, size: 18),
                const SizedBox(width: 8),
                const Expanded(child: Text('رصيدك غير كافٍ لهذه المدة. اشحن رصيدك أولاً.', style: TextStyle(fontSize: 11, color: AppColors.categorySos, fontWeight: FontWeight.w600))),
                TextButton(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TopUpTokensScreen()));
                    _load();
                  },
                  child: const Text('شحن الآن', style: TextStyle(fontSize: 11)),
                ),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _canAfford && !_submitting ? _confirm : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.local_fire_department_rounded, size: 18),
              label: Text('تأكيد التمييز مقابل $_cost توكن', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmed(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تم التمييز')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.local_fire_department_rounded, color: AppColors.teal, size: 38),
            ),
          ),
          const SizedBox(height: 18),
          const Text('إعلانك مميز الآن! 🔥', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'تم خصم $_cost توكن من رصيدك، وسيظهر إعلانك أولاً في نتائج البحث لمدة $_days ${_days == 1 ? 'يوم' : 'أيام'}.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.inkSecondary, height: 1.8),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('تمام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TokenWalletScreen())),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.ink, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
              label: const Text('عرض محفظة التوكن', style: TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
