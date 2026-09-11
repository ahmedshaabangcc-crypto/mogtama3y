import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/assistant/assistant_config.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/app_colors.dart';

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

/// The "مساعد مُجتمعي الذكي" — an AI assistant that (once its n8n backend
/// is wired, see AssistantConfig) can answer questions about anything in
/// the app. Reachable from a floating button on every tab via AppShell.
class AssistantChatScreen extends StatefulWidget {
  const AssistantChatScreen({super.key});

  @override
  State<AssistantChatScreen> createState() => _AssistantChatScreenState();
}

class _AssistantChatScreenState extends State<AssistantChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatMessage(
      isUser: false,
      text: AssistantConfig.isConfigured
          ? 'أهلاً! أنا مساعد مُجتمعي الذكي، اسألني عن أي حاجة في التطبيق وهساعدك فوراً.'
          : 'أهلاً! المساعد الذكي قيد التفعيل حالياً وهيكون جاهز قريباً للإجابة عن أي سؤال في التطبيق.',
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
    });
    _scrollToEnd();

    if (!AssistantConfig.isConfigured) {
      setState(() {
        _messages.add(const _ChatMessage(
          text: 'لسه بيتم توصيل المساعد الذكي بالنظام، جرّب تاني بعد شوية.',
          isUser: false,
        ));
      });
      _scrollToEnd();
      return;
    }

    setState(() => _sending = true);
    try {
      final response = await http.post(
        Uri.parse(AssistantConfig.webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text, 'user_id': AuthService.currentUser?.id}),
      );
      final reply = (jsonDecode(response.body) as Map<String, dynamic>)['reply'] as String? ?? 'لم أفهم سؤالك، حاول بصياغة أخرى.';
      setState(() => _messages.add(_ChatMessage(text: reply, isUser: false)));
    } catch (_) {
      setState(() => _messages.add(const _ChatMessage(text: 'حدث خطأ في الاتصال بالمساعد، حاول مرة أخرى.', isUser: false)));
    } finally {
      if (mounted) setState(() => _sending = false);
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_rounded, size: 20),
            SizedBox(width: 8),
            Text('مساعد مُجتمعي الذكي'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_sending ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) return const _TypingBubble();
                return _MessageBubble(message: _messages[i]);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: AppColors.border)),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(
                          hintText: 'اكتب سؤالك هنا...',
                          hintStyle: TextStyle(color: AppColors.inkMuted, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 13),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: _send,
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.teal : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: message.isUser ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          message.text,
          style: TextStyle(fontSize: 12.5, height: 1.6, color: message.isUser ? Colors.white : AppColors.ink),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: const SizedBox(width: 18, height: 12, child: Center(child: SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)))),
      ),
    );
  }
}
