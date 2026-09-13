import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/union/posts_service.dart';
import '../../core/union/union_service.dart';
import '../auth/auth_landing_screen.dart';
import 'union_dashboard_screen.dart';

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt.toLocal());
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  return 'منذ ${diff.inDays} يوم';
}

/// اتحاد الملاك community feed — was reachable straight from the home
/// screen with NO auth check and 100% fabricated content (a fake
/// building, fake residents, a fake "100% موثق" stat, fake posts with
/// fake engagement). Rebuilt around the real posts/post_comments/
/// post_reactions tables — see backend/migrations/0029_union_feed.sql.
class UnionFeedScreen extends StatefulWidget {
  const UnionFeedScreen({super.key});

  @override
  State<UnionFeedScreen> createState() => _UnionFeedScreenState();
}

class _UnionFeedScreenState extends State<UnionFeedScreen> {
  bool _loading = true;
  String? _loadError;
  String? _buildingId;
  String? _buildingName;
  int _memberCount = 0;
  List<Map<String, dynamic>> _posts = [];
  Set<String> _reactedIds = {};
  final _composeCtrl = TextEditingController();
  bool _posting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _composeCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final membership = await UnionService.fetchMyMembership();
      final isVerified = membership?['status'] == 'verified';
      final buildingId = isVerified ? membership!['building_id'] as String? : null;
      final building = membership?['building'] as Map<String, dynamic>?;

      List<Map<String, dynamic>> posts = [];
      Set<String> reacted = {};
      int memberCount = 0;
      if (buildingId != null) {
        posts = await PostsService.fetchPosts(buildingId);
        reacted = await PostsService.fetchMyReactedPostIds(posts.map((p) => p['id'] as String).toList());
        final members = await UnionService.fetchVerifiedMembers(buildingId);
        memberCount = members.length;
      }

      if (!mounted) return;
      setState(() {
        _buildingId = buildingId;
        _buildingName = building?['name'] as String?;
        _memberCount = memberCount;
        _posts = posts;
        _reactedIds = reacted;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _post() async {
    final text = _composeCtrl.text.trim();
    if (text.isEmpty || _buildingId == null) return;
    setState(() => _posting = true);
    try {
      await PostsService.createPost(buildingId: _buildingId!, body: text);
      _composeCtrl.clear();
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر نشر المنشور')));
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  Future<void> _toggleReaction(String postId) async {
    final reacted = _reactedIds.contains(postId);
    setState(() {
      if (reacted) {
        _reactedIds.remove(postId);
      } else {
        _reactedIds.add(postId);
      }
    });
    try {
      await PostsService.toggleReaction(postId: postId, currentlyReacted: reacted);
      _load();
    } catch (_) {
      _load();
    }
  }

  void _openComments(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _CommentsSheet(postId: postId, onPosted: _load),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isSignedIn) {
      return const AuthLandingScreen();
    }
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('اتحاد الملاك')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.categorySos, size: 40),
                const SizedBox(height: 12),
                const Text('تعذر تحميل مجتمع الاتحاد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 8),
                Text(_loadError!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _load, child: const Text('إعادة المحاولة')),
              ],
            ),
          ),
        ),
      );
    }
    if (_buildingId == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('اتحاد الملاك')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('لازم تنضم لعمارتك وتوثّق حسابك الأول عشان تشوف وتشارك في مجتمع اتحاد الملاك',
                textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkMuted, fontSize: 13)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text('مجتمع ${_buildingName ?? "عمارتك"}'),
        actions: [
          IconButton(
            tooltip: 'لوحة إدارة الاتحاد',
            icon: const Icon(Icons.dashboard_customize_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UnionDashboardScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: AppColors.categoryUnion, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_buildingName ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                      Text('$_memberCount جار موثّق', style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            if (_posts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('لا توجد منشورات بعد، ابدأ الحديث مع جيرانك', style: TextStyle(color: AppColors.inkMuted, fontSize: 13))),
              )
            else
              for (final p in _posts) ...[
                _PostCard(
                  post: p,
                  reacted: _reactedIds.contains(p['id']),
                  onToggleReaction: () => _toggleReaction(p['id'] as String),
                  onOpenComments: () => _openComments(p['id'] as String),
                ),
                const SizedBox(height: 14),
              ],
          ],
        ),
      ),
      bottomSheet: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _composeCtrl,
                  onSubmitted: (_) => _post(),
                  decoration: InputDecoration(
                    hintText: 'شارك جيرانك خبر، أو استفسار...',
                    hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
                    filled: true,
                    fillColor: AppColors.surfaceAlt,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _posting ? null : _post,
                icon: _posting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded, color: AppColors.teal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.reacted, required this.onToggleReaction, required this.onOpenComments});
  final Map<String, dynamic> post;
  final bool reacted;
  final VoidCallback onToggleReaction, onOpenComments;

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.tryParse(post['created_at'] as String? ?? '') ?? DateTime.now();
    final isOfficial = post['type'] == 'official';
    final isPinned = post['is_pinned'] == true;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPinned || isOfficial)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                const Icon(Icons.push_pin_rounded, size: 13, color: AppColors.teal),
                const SizedBox(width: 5),
                Text(isOfficial ? 'إعلان رسمي • اتحاد الملاك' : 'منشور مثبّت', style: const TextStyle(fontSize: 10.5, color: AppColors.teal, fontWeight: FontWeight.w600)),
              ]),
            ),
          Row(children: [
            const CircleAvatar(radius: 18, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, color: AppColors.inkMuted)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['author_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(_timeAgo(createdAt), style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 10),
          Text(post['body'] as String? ?? '', style: const TextStyle(fontSize: 12.5, height: 1.8, color: AppColors.inkSecondary)),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(children: [
              InkWell(
                onTap: onToggleReaction,
                child: Row(children: [
                  Icon(reacted ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 16, color: reacted ? AppColors.categorySos : AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text('${post['reaction_count'] ?? 0} تفاعل', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                ]),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: onOpenComments,
                child: Row(children: [
                  const Icon(Icons.mode_comment_outlined, size: 16, color: AppColors.inkMuted),
                  const SizedBox(width: 4),
                  Text('${post['comment_count'] ?? 0} تعليقات', style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet({required this.postId, required this.onPosted});
  final String postId;
  final VoidCallback onPosted;

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  bool _loading = true;
  List<Map<String, dynamic>> _comments = [];
  final _ctrl = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final rows = await PostsService.fetchComments(widget.postId);
    if (!mounted) return;
    setState(() {
      _comments = rows;
      _loading = false;
    });
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await PostsService.addComment(postId: widget.postId, body: text);
      _ctrl.clear();
      await _load();
      widget.onPosted();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال التعليق')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(14), child: Text('التعليقات', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                      ? const Center(child: Text('لا توجد تعليقات بعد', style: TextStyle(color: AppColors.inkMuted, fontSize: 12.5)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _comments.length,
                          itemBuilder: (context, i) {
                            final c = _comments[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceAlt, child: Icon(Icons.person_rounded, size: 14, color: AppColors.inkMuted)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text((c['author'] as Map<String, dynamic>?)?['full_name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
                                        Text(c['body'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Expanded(child: TextField(controller: _ctrl, decoration: const InputDecoration(hintText: 'اكتب تعليقك...', isDense: true, filled: true, fillColor: AppColors.surfaceAlt, border: OutlineInputBorder()))),
                  IconButton(onPressed: _sending ? null : _send, icon: const Icon(Icons.send_rounded, color: AppColors.teal)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
