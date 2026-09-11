import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'token_wallet_screen.dart';
import 'top_up_tokens_screen.dart';

const _dailyRateTokens = 1;
const _currentBalance = 7;

/// Feature/promote a listing so it shows first with a "مميز" badge —
/// pay per day out of the token balance.
class PromoteListingScreen extends StatefulWidget {
  const PromoteListingScreen({super.key, this.listingTitle = 'صالون زاوية L-Shape مودرن تركي'});
  final String listingTitle;

  @override
  State<PromoteListingScreen> createState() => _PromoteListingScreenState();
}

class _PromoteListingScreenState extends State<PromoteListingScreen> {
  int _days = 3;
  bool _confirmed = false;

  int get _cost => _days * _dailyRateTokens;
  bool get _canAfford => _cost <= _currentBalance;

  @override
  Widget build(BuildContext context) {
    if (_confirmed) return _buildConfirmed(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('تمييز الإعلان')),
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
                    const Text('سوق المستعمل', style: TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
              ),
            ]),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Icon(Icons.bolt_rounded, color: AppColors.gold),
              const SizedBox(width: 10),
              const Expanded(
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
                          Text('$d توكن', style: TextStyle(fontSize: 9.5, color: _days == d ? Colors.white70 : AppColors.inkMuted)),
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
                  const Text('1 توكن / يوم', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
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
                  Text('$_currentBalance توكن', style: TextStyle(fontSize: 10, color: _canAfford ? AppColors.inkMuted : AppColors.categorySos, fontWeight: FontWeight.w600)),
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
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TopUpTokensScreen())),
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
              onPressed: _canAfford ? () => setState(() => _confirmed = true) : null,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white, disabledBackgroundColor: AppColors.surfaceAlt, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              icon: const Icon(Icons.local_fire_department_rounded, size: 18),
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
