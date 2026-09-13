import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/auth/auth_service.dart';
import '../../core/marketplace/marketplace_chat_service.dart';
import '../../core/theme/app_colors.dart';

String _timeLabel(DateTime dt) {
  final local = dt.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

/// Real 1:1 chat between a listing's buyer and seller — see
/// backend/migrations/0035_marketplace_chat.sql. Polls every few
/// seconds while open, consistent with the rest of the app's chat
/// screens (no realtime subscriptions anywhere in مُجتمعي).
class MarketplaceChatScreen extends StatefulWidget {
  const MarketplaceChatScreen({super.key, required this.listingId, required this.buyerId, required this.otherPartyName});
  final String listingId, buyerId, otherPartyName;

  @override
  State<MarketplaceChatScreen> createState() => _MarketplaceChatScreenState();
}

class _MarketplaceChatScreenState extends State<MarketplaceChatScreen> {
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
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
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    final rows = await MarketplaceChatService.fetchMessages(listingId: widget.listingId, buyerId: widget.buyerId);
    if (!mounted) return;
    final grew = rows.length != _messages.length;
    setState(() {
      _messages = rows;
      _loading = false;
    });
    if (grew && _scrollCtrl.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
      });
    }
  }

  Future<void> _send() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;
    _messageCtrl.clear();
    try {
      await MarketplaceChatService.sendMessage(listingId: widget.listingId, buyerId: widget.buyerId, body: text);
      _load();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر إرسال الرسالة')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = AuthService.currentUser?.id;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(widget.otherPartyName)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surfaceAlt,
            child: const Text('محادثة خاصة عن هذا الإعلان بينك وبين الطرف الآخر فقط', style: TextStyle(fontSize: 10.5, color: AppColors.inkMuted)),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(child: Text('لا توجد رسائل بعد، ابدأ المحادثة', style: TextStyle(color: AppColors.inkMuted, fontSize: 13)))
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final m = _messages[i];
                          final isMe = m['sender_id'] == myUserId;
                          final createdAt = DateTime.tryParse(m['created_at'] as String? ?? '');
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m['body'] as String? ?? '', style: const TextStyle(fontSize: 12)),
                                  if (createdAt != null) ...[
                                    const SizedBox(height: 3),
                                    Text(_timeLabel(createdAt), style: const TextStyle(fontSize: 9, color: AppColors.inkMuted)),
                                  ],
                                ],
                              ),
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
      ),
    );
  }
}
