import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

/// The "مساعد مُجتمعي الذكي" — answers questions about anything in the
/// app and can hand the user over to the support team (Telegram + a
/// support ticket). Goes through the `assistant` Edge Function
/// (backend/functions/assistant), which applies a daily quota and forwards
/// to the n8n "مُجتمعي – AI Assistant" workflow. Reachable from a floating
/// button on every tab via AppShell.
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
  // Keeps a guest's conversation memory together for this visit (signed-in
  // users are identified server-side by their account instead).
  final _guestSessionId = List.generate(16, (_) => Random.secure().nextInt(16).toRadixString(16)).join();

  @override
  void initState() {
    super.initState();
    _messages.add(const _ChatMessage(
      isUser: false,
      text: 'أهلاً! أنا مساعد مُجتمعي الذكي. اسألني عن أي حاجة في التطبيق، ولو حابب تكلّم حد من فريق الدعم قولّي وأنا أوصّلك.',
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

    setState(() => _sending = true);
    try {
      final response = await Supabase.instance.client.functions.invoke(
        // Deployed under the slug 'hyper-api' (set by the dashboard editor).
        'hyper-api',
        body: {'action': 'chat', 'message': text, 'session_id': _guestSessionId},
      );
      final data = response.data;
      final reply = data is Map && data['reply'] is String ? data['reply'] as String : 'لم أفهم سؤالك، حاول بصياغة أخرى.';
      if (!mounted) return;
      setState(() => _messages.add(_ChatMessage(text: reply, isUser: false)));
    } catch (_) {
      if (!mounted) return;
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
        child: message.isUser
            ? Text(message.text, style: const TextStyle(fontSize: 12.5, height: 1.6, color: Colors.white))
            : _withLinks(context, message.text),
      ),
    );
  }

  // [label](url) and bare https:// links in the assistant's reply become
  // buttons under the text; app links (mogtama3y.com/#/…) open in-app.
  static final _md = RegExp(r'\[([^\]]{1,60})\]\((https?://[^\s)]+)\)');
  static final _bare = RegExp(r'https?://[^\s)\]،]+');

  Widget _withLinks(BuildContext context, String raw) {
    final links = <(String, String)>[];
    // Markdown bold/headers from the model are shown as plain text.
    var text = raw.replaceAll('**', '').replaceAll(RegExp(r'^#+\s*', multiLine: true), '').replaceAllMapped(_md, (m) {
      links.add((m[1]!, m[2]!));
      return m[1]!;
    });
    text = text.replaceAllMapped(_bare, (m) {
      final url = m[0]!.replaceAll(RegExp(r'[.,]$'), '');
      if (!links.any((l) => l.$2 == url)) links.add((_labelFor(url), url));
      return '';
    }).replaceAll(RegExp(r'[ \t]+\n'), '\n').trim();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      if (text.isNotEmpty) Text(text, style: const TextStyle(fontSize: 12.5, height: 1.6, color: AppColors.ink)),
      if (links.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final (label, url) in links)
            ActionChip(
              avatar: const Icon(Icons.open_in_new_rounded, size: 15, color: AppColors.teal),
              label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              onPressed: () => _open(context, url),
            ),
        ]),
      ],
    ]);
  }

  static String _labelFor(String url) {
    final path = _appPath(url) ?? '';
    for (final (prefix, label) in const [
      ('/nearby', 'اكتشف حواليك'), ('/reports', 'بلاغات حيّك'), ('/report', 'بلّغ عن مشكلة'), ('/marketplace', 'سوق المستعمل'),
      ('/technicians', 'الفنيين'), ('/real-estate', 'العقارات'), ('/jobs', 'الوظائف'), ('/my-address', 'عنوانك الإلكتروني'),
      ('/friends', 'أصحابي'), ('/wallet', 'المحفظة'), ('/post', 'انشر إعلان'), ('/support', 'الدعم'), ('/d/', 'صفحة المحل'),
      ('/s/', 'المتجر'), ('/r/', 'البلاغ'),
    ]) {
      if (path.startsWith(prefix)) return label;
    }
    if (url.contains('tajer.mogtama3y.com')) return 'افتح متجرك';
    if (url.contains('ittihad.mogtama3y.com')) return 'اتحاد الملاك';
    return 'افتح الرابط';
  }

  /// '/nearby?q=…' for https://mogtama3y.com/#/nearby?q=…, else null.
  static String? _appPath(String url) {
    final m = RegExp(r'^https?://(www\.)?mogtama3y\.com/#(/.*)$').firstMatch(url);
    return m?[2];
  }

  static void _open(BuildContext context, String url) {
    final path = _appPath(url);
    if (path != null) {
      context.push(path);
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
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
