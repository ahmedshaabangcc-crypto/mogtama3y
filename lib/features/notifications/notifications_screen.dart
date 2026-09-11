import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/notifications/notifications_service.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_landing_screen.dart';

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  return 'منذ ${diff.inDays} يوم';
}

/// Notifications tab — the bottom-nav "الإشعارات" tab, now reading real
/// notifications populated by actual app events (membership approval,
/// new dues, etc.) instead of six hardcoded sample notices.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _notices = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final notices = await NotificationsService.fetchMine();
    if (!mounted) return;
    setState(() {
      _notices = notices;
      _loading = false;
    });
  }

  Future<void> _markAllRead() async {
    await NotificationsService.markAllRead();
    _load();
  }

  Future<void> _onTapNotice(Map<String, dynamic> n) async {
    if (n['is_read'] != true) {
      await NotificationsService.markRead(n['id'] as String);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('الإشعارات')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthLandingScreen())),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
            child: const Text('سجّل دخولك لعرض إشعاراتك'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text('تحديد الكل كمقروء', style: TextStyle(color: Colors.white, fontSize: 11.5)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _notices.isEmpty
                ? ListView(children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Column(children: [
                        Icon(Icons.notifications_none_rounded, color: AppColors.inkMuted, size: 36),
                        SizedBox(height: 10),
                        Text('لا توجد إشعارات حالياً', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                      ]),
                    ),
                  ])
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: _notices.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final n = _notices[i];
                      final unread = n['is_read'] != true;
                      final createdAt = DateTime.tryParse(n['created_at'] as String? ?? '') ?? DateTime.now();
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _onTapNotice(n),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: unread ? AppColors.teal.withValues(alpha: 0.06) : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: unread ? AppColors.teal.withValues(alpha: 0.3) : AppColors.border),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.notifications_rounded, color: AppColors.teal, size: 19),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Expanded(child: Text(n['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5))),
                                      if (unread) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 6), decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
                                    ]),
                                    if (n['body'] != null) ...[
                                      const SizedBox(height: 3),
                                      Text(n['body'] as String, style: const TextStyle(fontSize: 10.5, color: AppColors.inkSecondary, height: 1.6)),
                                    ],
                                    const SizedBox(height: 6),
                                    Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
