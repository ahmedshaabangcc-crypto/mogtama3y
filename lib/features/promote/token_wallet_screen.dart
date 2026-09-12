import 'package:flutter/material.dart';

import '../../core/promote/ad_token_service.dart';
import '../../core/theme/app_colors.dart';
import 'top_up_tokens_screen.dart';

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
  return 'منذ ${(diff.inDays / 30).floor()} شهر';
}

/// Real token balance & activity history — see
/// backend/migrations/0026_ad_tokens.sql.
class TokenWalletScreen extends StatefulWidget {
  const TokenWalletScreen({super.key});

  @override
  State<TokenWalletScreen> createState() => _TokenWalletScreenState();
}

class _TokenWalletScreenState extends State<TokenWalletScreen> {
  bool _loading = true;
  int _balance = 0;
  double _tokenPrice = 15;
  int _dailyRate = 1;
  List<Map<String, dynamic>> _activity = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final balance = await AdTokenService.fetchMyBalance();
    final settings = await AdTokenService.fetchSettings();
    final activity = await AdTokenService.fetchMyActivity();
    if (!mounted) return;
    setState(() {
      _balance = balance;
      _tokenPrice = (settings['token_price_egp'] as num?)?.toDouble() ?? 15;
      _dailyRate = settings['daily_rate_tokens'] as int? ?? 1;
      _activity = activity;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('رصيد التوكن ومميزات الإعلانات')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
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
                    Text('$_balance', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 6),
                    const Text('توكن', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ]),
                  const SizedBox(height: 4),
                  Text('≈ ${(_balance * _tokenPrice).toStringAsFixed(0)} ج.م بسعر التوكن الحالي (${_tokenPrice.toStringAsFixed(0)} ج.م)', style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TopUpTokensScreen()));
                        _load();
                      },
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
                  _StepLine(number: 1, text: 'اشحن رصيدك بالتوكن (${_tokenPrice.toStringAsFixed(0)} ج.م للتوكن، بحد أدنى 5 توكن).'),
                  const _StepLine(number: 2, text: 'اختر أي إعلان (سوق مستعمل، عقار، أو وظيفة) وحدد عدد أيام التمييز.'),
                  _StepLine(number: 3, text: 'يُخصم رصيد يومي من توكناتك طوال مدة التمييز (السعر اليومي الحالي: $_dailyRate توكن/يوم).'),
                  const _StepLine(number: 4, text: 'إعلانك يظهر أولاً في نتائج البحث وبعلامة "إعلان مميز" مدة التمييز.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('سجل النشاط', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 10),
            if (_activity.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: Text('لا يوجد نشاط بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5))),
              )
            else
              for (final a in _activity) ...[
                _ActivityTile(activity: a),
                const SizedBox(height: 10),
              ],
          ],
        ),
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
  final Map<String, dynamic> activity;

  @override
  Widget build(BuildContext context) {
    final kind = activity['kind'] as String;
    final tokens = activity['tokens'] as int;
    final createdAt = DateTime.tryParse(activity['created_at'] as String? ?? '') ?? DateTime.now();
    final (icon, color) = switch (kind) {
      'topup' => (Icons.add_card_rounded, AppColors.teal),
      'spend' => (Icons.local_fire_department_outlined, AppColors.ink),
      _ => (Icons.hourglass_top_rounded, AppColors.gold),
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
            child: Text(activity['description'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${tokens > 0 ? '+' : ''}$tokens توكن', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5, color: tokens > 0 ? AppColors.teal : AppColors.ink)),
              Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
