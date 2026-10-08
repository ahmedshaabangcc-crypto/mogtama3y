import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/auth/auth_service.dart';
import '../../core/lost_found/lost_found_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';
import '../shared/load_error_view.dart';
import 'add_lost_found_item_screen.dart';
import '../../core/app_flavor.dart';
import '../union/union_home_link.dart';

IconData _categoryIcon(String category) => switch (category) {
  'مفاتيح' => Icons.vpn_key_rounded,
  'محافظ وبطاقات' => Icons.account_balance_wallet_rounded,
  'إلكترونية' => Icons.smartphone_rounded,
  'حيوانات أليفة' => Icons.pets_rounded,
  _ => Icons.inventory_2_outlined,
};

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  return 'منذ ${diff.inDays} يوم';
}

/// Lost & found hub — matches design/screens/40_lost_and_found_hub.png,
/// now reading real lost_found_items for the user's own building.
class LostFoundHubScreen extends StatefulWidget {
  const LostFoundHubScreen({super.key});

  @override
  State<LostFoundHubScreen> createState() => _LostFoundHubScreenState();
}

class _LostFoundHubScreenState extends State<LostFoundHubScreen> {
  int _tab = 1;
  bool _loading = true;
  bool _loadError = false;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = false;
    });
    try {
      final items = AuthService.isSignedIn ? await LostFoundService.fetchItems() : <Map<String, dynamic>>[];
      if (!mounted) return;
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = true;
      });
    }
  }

  List<Map<String, dynamic>> get _visibleItems => _items.where((i) => i['type'] == (_tab == 0 ? 'lost' : 'found')).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: isUnionApp ? const UnionHomeTitle(title: 'المفقودات') : const Text('المفقودات والمعثور عليها في الحي')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          children: [
            const Text('منظومة موثقة لحفظ المفقودات والأمانات مع سكان عمارتك.', style: TextStyle(fontSize: 11.5, color: AppColors.inkSecondary, height: 1.8)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _ModeTile(icon: Icons.search_off_rounded, title: 'أغراض مفقودة (Lost)', selected: _tab == 0, onTap: () => setState(() => _tab = 0)),
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
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text('أحدث البلاغات في عمارتك', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                ),
                Text('${_visibleItems.length} بلاغ', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              ],
            ),
            const SizedBox(height: 10),
            if (!AuthService.isSignedIn)
              _EmptyState(
                icon: Icons.lock_outline_rounded,
                text: 'سجّل دخولك لعرض بلاغات المفقودات في عمارتك',
                actionLabel: 'تسجيل الدخول',
                onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
              )
            else if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_loadError)
              LoadErrorView(onRetry: _load)
            else if (_visibleItems.isEmpty)
              const _EmptyState(icon: Icons.task_alt_rounded, text: 'لا توجد بلاغات حالياً في عمارتك')
            else
              for (final item in _visibleItems) ...[_ItemCard(item: item, onResolved: _load), const SizedBox(height: 14)],
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () async {
                final target = AuthService.isSignedIn ? const AddLostFoundItemScreen() : const AuthLandingScreen();
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
                _load();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('تسجيل بلاغ مفقود أو معثور عليه جديد', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text, this.actionLabel, this.onAction});
  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: AppColors.inkMuted, size: 32),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 12.5),
            ),
            if (actionLabel != null) ...[const SizedBox(height: 12), TextButton(onPressed: onAction, child: Text(actionLabel!))],
          ],
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
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: selected ? AppColors.teal : AppColors.inkSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

const _claimResultMessages = {
  'verified': 'إجابتك صحيحة! تم إبلاغ من وجد الغرض للتواصل معك وتسليمه.',
  'notified': 'تم إبلاغ صاحب البلاغ، وسيتواصل معك داخل العمارة.',
  'wrong': 'العلامة غير صحيحة، حاول مرة أخرى (لديك 3 محاولات فقط).',
  'locked': 'استنفدت محاولاتك الثلاث لهذا الغرض. تواصل مع حارس العمارة أو رئيس الاتحاد.',
};

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item, required this.onResolved});
  final Map<String, dynamic> item;
  final VoidCallback onResolved;

  /// Found item with a secret mark → ask for it (checked server-side).
  /// Lost item ("I know where it is") or no mark → just notify the reporter.
  Future<void> _claim(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    String? answer;
    if (item['type'] == 'found' && item['has_secret_mark'] == true) {
      final ctrl = TextEditingController();
      answer = await showDialog<String>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('أثبت أن الغرض يخصك'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اكتب العلامة المميزة التي وضعها من وجد الغرض (تفصيل لا يعرفه إلا صاحبه).', style: TextStyle(fontSize: 12, height: 1.6)),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'العلامة السرية'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
            ElevatedButton(onPressed: () => Navigator.of(dialogContext).pop(ctrl.text.trim()), child: const Text('تحقق')),
          ],
        ),
      );
      ctrl.dispose();
      if (answer == null || answer.isEmpty) return;
    }
    try {
      final result = await LostFoundService.claimItem(itemId: item['id'] as String, answer: answer);
      messenger.showSnackBar(SnackBar(content: Text(_claimResultMessages[result] ?? 'تم')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e is PostgrestException ? e.message : 'تعذر إرسال الطلب، حاول مرة أخرى')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLost = item['type'] == 'lost';
    final category = item['category'] as String? ?? '';
    final title = item['title'] as String? ?? '';
    final locationNote = item['location_note'] as String?;
    final rewardAmount = (item['reward_amount'] as num?)?.toDouble();
    final createdAt = DateTime.tryParse(item['created_at'] as String? ?? '') ?? DateTime.now();
    final isOwnReport = item['reporter_id'] == AuthService.currentUser?.id;
    final imageUrl = item['image_url'] as String?;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              imageUrl != null
                  ? Image.network(
                      imageUrl,
                      cacheWidth: 300,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 120,
                        color: AppColors.surfaceAlt,
                        child: Center(child: Icon(_categoryIcon(category), size: 36, color: AppColors.inkMuted)),
                      ),
                    )
                  : Container(
                      height: 120,
                      color: AppColors.surfaceAlt,
                      child: Center(child: Icon(_categoryIcon(category), size: 36, color: AppColors.inkMuted)),
                    ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: isLost ? AppColors.categorySos : Colors.black87, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    category.isEmpty ? (isLost ? 'مفقود' : 'معثور عليه') : category,
                    style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (rewardAmount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'مكافأة ${rewardAmount.toStringAsFixed(0)} ج.م',
                      style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: AppColors.inkMuted),
                    const SizedBox(width: 4),
                    Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, height: 1.4)),
                if (locationNote != null && locationNote.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 13, color: AppColors.inkMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          locationNote,
                          style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                if (isOwnReport)
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await LostFoundService.markResolved(item['id'] as String);
                        onResolved();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.teal,
                        side: const BorderSide(color: AppColors.teal),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                      label: const Text('تم الحل / الاستلام', style: TextStyle(fontSize: 11.5)),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () => _claim(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(isLost ? 'أعرف مكان هذا الغرض' : 'هذا الغرض يخصني', textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5)),
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
