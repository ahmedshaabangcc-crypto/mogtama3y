import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'top_up_tokens_screen.dart';

enum _ActivityKind { topUp, spend, pending }

class _Activity {
  const _Activity({required this.kind, required this.title, required this.subtitle, required this.amount, required this.time});
  final _ActivityKind kind;
  final String title, subtitle, amount, time;
}

const _activities = [
  _Activity(kind: _ActivityKind.pending, title: 'طلب شحن قيد المراجعة', subtitle: '5 توكن • 75 ج.م', amount: '+5', time: 'منذ 10 دقائق'),
  _Activity(kind: _ActivityKind.spend, title: 'تمييز إعلان "صالون زاوية L-Shape"', subtitle: '3 أيام تمييز • سوق المستعمل', amount: '-3', time: 'أمس'),
  _Activity(kind: _ActivityKind.topUp, title: 'شحن رصيد معتمد', subtitle: '10 توكن • 150 ج.م', amount: '+10', time: 'منذ 4 أيام'),
];

/// Token balance & history for the featured-listing promotion feature.
class TokenWalletScreen extends StatelessWidget {
  const TokenWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('رصيد التوكن ومميزات الإعلانات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.navy, Color(0xFF1B3A63)], begin: Alignment.topRight, end: Alignment.bottomLeft),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.toll_rounded, color: AppColors.gold, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text('رصيدك الحالي', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                ]),
                const SizedBox(height: 10),
                Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                  const Text('7', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 6),
                  const Text('توكن', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ]),
                const SizedBox(height: 4),
                const Text('≈ 105 ج.م بسعر التوكن الحالي (15 ج.م)', style: TextStyle(color: Colors.white54, fontSize: 10)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TopUpTokensScreen())),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold, foregroundColor: AppColors.ink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 17),
                    label: const Text('شحن رصيد جديد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: const [
                  Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.gold),
                  SizedBox(width: 6),
                  Text('كيف يعمل تمييز الإعلانات؟', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                ]),
                const SizedBox(height: 8),
                const _StepLine(number: 1, text: 'اشحن رصيدك بالتوكن (15 ج.م للتوكن، بحد أدنى 5 توكن).'),
                const _StepLine(number: 2, text: 'اختر إعلانك وحدد عدد أيام التمييز المطلوبة.'),
                const _StepLine(number: 3, text: 'يُخصم رصيد يومي من توكناتك طوال مدة التمييز (السعر اليومي الحالي: توكن واحد/يوم).'),
                const _StepLine(number: 4, text: 'إعلانك يظهر أولاً في نتائج البحث وبعلامة "إعلان مميز" مدة التمييز.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('سجل النشاط', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
          const SizedBox(height: 10),
          for (final a in _activities) ...[
            _ActivityTile(activity: a),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 1),
            decoration: const BoxDecoration(color: AppColors.surfaceAlt, shape: BoxShape.circle),
            child: Text('$number', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.6))),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});
  final _Activity activity;

  @override
  Widget build(BuildContext context) {
    final isCredit = activity.amount.startsWith('+');
    final Color color = switch (activity.kind) {
      _ActivityKind.topUp => AppColors.teal,
      _ActivityKind.spend => AppColors.ink,
      _ActivityKind.pending => AppColors.gold,
    };
    final IconData icon = switch (activity.kind) {
      _ActivityKind.topUp => Icons.add_card_rounded,
      _ActivityKind.spend => Icons.local_fire_department_outlined,
      _ActivityKind.pending => Icons.hourglass_top_rounded,
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                Text(activity.subtitle, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${activity.amount} توكن', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: isCredit ? AppColors.teal : AppColors.ink)),
              Text(activity.time, style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
