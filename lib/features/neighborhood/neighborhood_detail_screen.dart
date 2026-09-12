import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/neighborhood/neighborhood_service.dart';
import '../../core/theme/app_colors.dart';

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  return 'منذ ${diff.inDays} يوم';
}

/// One neighborhood group: real posts feed + real live chat, both
/// scoped to the whole district rather than one building. See
/// backend/migrations/0028_neighborhood_groups.sql.
class NeighborhoodDetailScreen extends StatefulWidget {
  const NeighborhoodDetailScreen({super.key, required this.neighborhoodId, required this.neighborhoodName});
  final String neighborhoodId, neighborhoodName;

  @override
  State<NeighborhoodDetailScreen> createState() => _NeighborhoodDetailScreenState();
}

class _NeighborhoodDetailScreenState extends State<NeighborhoodDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _leave() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مغادرة جروب الحي'),
        content: Text('هتتشال من "${widget.neighborhoodName}" وتقدر تنضم تاني وقت ما تحب.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('تراجع')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('مغادرة')),
        ],
      ),
    );
    if (confirmed == true) {
      await NeighborhoodService.leave(widget.neighborhoodId);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(widget.neighborhoodName),
        actions: [PopupMenuButton<String>(
          onSelected: (v) { if (v == 'leave') _leave(); },
          itemBuilder: (context) => [const PopupMenuItem(value: 'leave', child: Text('مغادرة الجروب'))],
        )],
        bottom: TabBar(controller: _tabController, tabs: const [Tab(text: 'المنشورات'), Tab(text: 'الدردشة')]),
      ),
      body: TabBarView(controller: _tabController, children: [
        _NeighborhoodPostsTab(neighborhoodId: widget.neighborhoodId),
        _NeighborhoodChatTab(neighborhoodId: widget.neighborhoodId),
      ]),
    );
  }
}

class _NeighborhoodPostsTab extends StatefulWidget {
  const _NeighborhoodPostsTab({required this.neighborhoodId});
  final String neighborhoodId;

  @override
  State<_NeighborhoodPostsTab> createState() => _NeighborhoodPostsTabState();
}

class _NeighborhoodPostsTabState extends State<_NeighborhoodPostsTab> {
  bool _loading = true;
  List<Map<String, dynamic>> _posts = [];
  final _bodyCtrl = TextEditingController();
  bool _posting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rows = await NeighborhoodService.fetchPosts(widget.neighborhoodId);
    if (!mounted) return;
    setState(() {
      _posts = rows;
      _loading = false;
    });
  }

  Future<void> _post() async {
    final text = _bodyCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _posting = true);
    try {
      await NeighborhoodService.createPost(neighborhoodId: widget.neighborhoodId, body: text);
      _bodyCtrl.clear();
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر نشر البوست')));
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
            child: Column(children: [
              TextField(
                controller: _bodyCtrl,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'شارك حاجة مع جيران حيّك...', border: InputBorder.none, isDense: true),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: _posting ? null : _post, child: Text(_posting ? '...' : 'نشر')),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
          else if (_posts.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 30), child: Center(child: Text('لا توجد منشورات بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13))))
          else
            for (final p in _posts) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 14, color: AppColors.inkMuted)),
                      const SizedBox(width: 8),
                      Expanded(child: Text((p['author'] as Map<String, dynamic>?)?['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
                      Text(_timeAgo(DateTime.tryParse(p['created_at'] as String? ?? '') ?? DateTime.now()), style: const TextStyle(fontSize: 9.5, color: AppColors.inkMuted)),
                    ]),
                    const SizedBox(height: 8),
                    Text(p['body'] as String? ?? '', style: const TextStyle(fontSize: 12.5, height: 1.6)),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}

class _NeighborhoodChatTab extends StatefulWidget {
  const _NeighborhoodChatTab({required this.neighborhoodId});
  final String neighborhoodId;

  @override
  State<_NeighborhoodChatTab> createState() => _NeighborhoodChatTabState();
}

class _NeighborhoodChatTabState extends State<_NeighborhoodChatTab> {
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  final _messageCtrl = TextEditingController();
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
    _poll = Timer.periodic(const Duration(seconds: 4), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _poll?.cancel();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    final rows = await NeighborhoodService.fetchChatMessages(widget.neighborhoodId);
    if (!mounted) return;
    setState(() {
      _messages = rows;
      _loading = false;
    });
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;
    _messageCtrl.clear();
    try {
      await NeighborhoodService.sendChatMessage(neighborhoodId: widget.neighborhoodId, body: text);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال الرسالة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = AuthService.currentUser?.id;
    return Column(
      children: [
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _messages.isEmpty
                  ? const Center(child: Text('لا توجد رسائل بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final m = _messages[i];
                        final isMe = m['sender_id'] == myUserId;
                        final senderName = (m['sender'] as Map<String, dynamic>?)?['full_name'] as String? ?? '';
                        return Align(
                          alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            constraints: const BoxConstraints(maxWidth: 280),
                            decoration: BoxDecoration(
                              color: isMe ? AppColors.teal.withValues(alpha: 0.1) : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isMe ? AppColors.teal.withValues(alpha: 0.3) : AppColors.border),
                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              if (!isMe) Text(senderName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10.5)),
                              Text(m['body'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                            ]),
                          ),
                        );
                      },
                    ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _messageCtrl,
                  decoration: const InputDecoration(hintText: 'اكتب رسالتك...', isDense: true, filled: true, fillColor: AppColors.surface, border: OutlineInputBorder()),
                  onSubmitted: (_) => _send(),
                ),
              ),
              IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded, color: AppColors.teal)),
            ]),
          ),
        ),
      ],
    );
  }
}
