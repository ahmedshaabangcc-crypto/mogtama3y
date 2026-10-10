import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/app_flavor.dart';
import '../../core/auth/auth_service.dart';
import '../../core/demo/demo_mode.dart';
import '../../core/support/feedback_route_observer.dart';
import '../../core/support/support_service.dart';
import '../../core/support/user_agent.dart';
import '../admin/admin_chat_rooms_screen.dart' show AdminRoomMessagesScreen;
import '../admin/admin_mosque_chat_screen.dart' show AdminMosqueChatScreen;
import '../assistant/assistant_chat_screen.dart' show AssistantChatScreen;
import '../auth/auth_landing_screen.dart' show AuthLandingScreen;
import '../auth/login_screen.dart' show LoginScreen;
import '../auth/password_reset_screens.dart' show ForgotPasswordScreen, SetNewPasswordScreen;
import '../auth/signup_screen.dart' show SignupScreen;
import '../chat/building_chat_screen.dart' show BuildingChatScreen, BuildingChatEntryScreen;
import '../guard/guard_console_screen.dart' show GuardConsoleScreen;
import '../marketplace/marketplace_chat_screen.dart' show MarketplaceChatScreen;
import '../masjid/mosque_chat_screen.dart' show MosqueChatScreen;
import '../people/chat_screen.dart' show ChatScreen;
import '../profile/phone_verify_screen.dart' show PhoneVerifyScreen;
import '../rooms/room_screen.dart' show RoomScreen;
import '../store/checkout_screen.dart' show CheckoutScreen;
import '../visitor/visitor_pass_link_screen.dart' show VisitorPassLinkScreen;
import '../visitor/visitor_qr_pass_screen.dart' show VisitorQrPassScreen;
import 'support_contact_screen.dart' show SupportContactScreen;

/// Pages (go_router paths) where the button would sit on top of input or a
/// full-screen view: chats, sign-in, the support form itself, the
/// «المحفّظ» recording flow and the qibla compass (deferred screens, so
/// matched by path — screens pushed inside them keep that URL), visitor
/// QR passes.
final _hiddenPaths = RegExp(
  r'^/(chat/|rooms/[0-9a-f-]{36}$|building-chat$|login$|reset-password$|support$|pass/|masjid/tools/(tutor|qibla)(/|$))',
);

/// Screens (also when opened with Navigator.push) where the button stays away.
bool _isHiddenScreen(Widget w) =>
    w is ChatScreen ||
    w is RoomScreen ||
    w is BuildingChatScreen ||
    w is BuildingChatEntryScreen ||
    w is MarketplaceChatScreen ||
    w is MosqueChatScreen ||
    w is AssistantChatScreen ||
    w is AdminMosqueChatScreen ||
    w is AdminRoomMessagesScreen ||
    w is CheckoutScreen ||
    w is AuthLandingScreen ||
    w is LoginScreen ||
    w is SignupScreen ||
    w is ForgotPasswordScreen ||
    w is SetNewPasswordScreen ||
    w is PhoneVerifyScreen ||
    w is GuardConsoleScreen ||
    w is VisitorQrPassScreen ||
    w is VisitorPassLinkScreen ||
    w is SupportContactScreen;

/// Optional `--dart-define=BUILD_DATE=…`, sent with feedback when present.
const _buildDate = String.fromEnvironment('BUILD_DATE');

/// «كلّمنا» — a small round button on every screen of every app, for a
/// suggestion («اقترح قسم»), a problem report or a question. Added once
/// over the router in main.dart's MaterialApp.builder; it follows the
/// root navigator through [FeedbackRouteObserver] and hides itself on
/// chats, sign-in, checkout, full-screen views, dialogs / sheets and
/// while the keyboard is open. Long-press → «إخفاء» hides it until the
/// page is reloaded. Never shown in the local demo build.
class FeedbackFabHost extends StatelessWidget {
  FeedbackFabHost({super.key, required this.router, required this.child, FeedbackRouteObserver? observer})
      : observer = observer ?? feedbackRouteObserver;

  final GoRouter router;
  final FeedbackRouteObserver observer;
  final Widget child;

  /// «إخفاء» — until the next page load.
  static final hiddenForSession = ValueNotifier<bool>(false);

  String _path() {
    try {
      final p = router.routerDelegate.currentConfiguration.uri.path;
      return p.isEmpty ? '/' : p;
    } catch (_) {
      return '/';
    }
  }

  static final _screens = Expando<Object>();

  /// The screen widget a route shows: a go_router page's child, or what a
  /// MaterialPageRoute builds (cached per route).
  Widget? _screenOf(Route<dynamic> route) {
    final settings = route.settings;
    if (settings is MaterialPage) return settings.child;
    if (settings is CustomTransitionPage) return settings.child;
    if (route is MaterialPageRoute) {
      final cached = _screens[route];
      if (cached != null) return cached is Widget ? cached : null;
      Object result = false;
      final ctx = observer.navigator?.context;
      if (ctx != null) {
        try {
          result = route.builder(ctx);
        } catch (_) {}
      }
      _screens[route] = result;
      return result is Widget ? result : null;
    }
    return null;
  }

  /// null = hidden; otherwise the distance from the bottom edge.
  double? _bottomOffset(BuildContext context) {
    if (hiddenForSession.value) return null;
    if (MediaQuery.viewInsetsOf(context).bottom > 0) return null; // keyboard open
    final stack = observer.stack;
    if (stack.isEmpty || stack.last is PopupRoute) return null; // dialog / sheet / menu on top
    final path = _path();
    if (_hiddenPaths.hasMatch(path)) return null;
    final screen = _screenOf(stack.last);
    if (screen != null && _isHiddenScreen(screen)) return null;
    // Home of every app has a bottom nav bar (and مُجتمعي's home a CTA
    // sheet above it, which its assistant button also clears).
    final onShell = path == '/' && stack.length == 1;
    return (onShell ? 160 : 96) + MediaQuery.paddingOf(context).bottom;
  }

  @override
  Widget build(BuildContext context) {
    if (kDemo) return child;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ListenableBuilder(
          listenable: Listenable.merge([router.routerDelegate, observer, hiddenForSession]),
          builder: (context, _) {
            final bottom = _bottomOffset(context);
            if (bottom == null) return const SizedBox.shrink();
            // RTL: start = the right edge; the apps' own FABs sit on the left (end).
            return PositionedDirectional(
              start: 12,
              bottom: bottom,
              child: _FeedbackButton(onTap: () => _open(context)),
            );
          },
        ),
      ],
    );
  }

  Future<void> _open(BuildContext context) async {
    final nav = observer.navigator;
    if (nav == null) return;
    final stack = observer.stack;
    final title = stack.isEmpty ? null : _screenTitle(stack.last);
    final path = _path();
    final ua = rawUserAgent();
    final source = <String, String>{
      'app': appFlavorId,
      'path': title == null || title.isEmpty ? path : '$path › $title',
      if (_buildDate.isNotEmpty) 'version': _buildDate,
      if (ua != null) 'ua': shortUserAgent(ua),
    };
    var signedIn = false;
    try {
      signedIn = AuthService.isSignedIn;
    } catch (_) {}
    await showModalBottomSheet<void>(
      context: nav.context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => FeedbackSheet(source: source, signedIn: signedIn),
    );
  }
}

/// The top screen's app-bar title, so the admin sees «/marketplace ›
/// تفاصيل الإعلان» for a screen pushed over a section.
String? _screenTitle(Route<dynamic> route) {
  if (route is! ModalRoute) return null;
  final ctx = route.subtreeContext;
  if (ctx == null) return null;
  String? found;
  var budget = 3000;
  void findText(Element e) {
    if (found != null || budget-- <= 0) return;
    final w = e.widget;
    if (w is Text && (w.data?.trim().isNotEmpty ?? false)) {
      found = w.data!.trim();
      return;
    }
    e.visitChildren(findText);
  }

  void findAppBar(Element e) {
    if (found != null || budget-- <= 0) return;
    if (e.widget is AppBar || e.widget is SliverAppBar) {
      final title = e.widget is AppBar ? (e.widget as AppBar).title : (e.widget as SliverAppBar).title;
      if (title is Text && title.data != null) {
        found = title.data!.trim();
      } else {
        e.visitChildren(findText);
      }
      found ??= '';
      return;
    }
    e.visitChildren(findAppBar);
  }

  try {
    ctx.visitChildElements(findAppBar);
  } catch (_) {}
  final t = found;
  if (t == null || t.isEmpty) return null;
  return t.length > 50 ? t.substring(0, 50) : t;
}

/// «Chrome 129 · Android» out of a full user-agent string.
String shortUserAgent(String ua) {
  String? browser;
  for (final (name, pattern) in [
    ('Edge', RegExp(r'Edg[A-Za-z]*/(\d+)')),
    ('Samsung', RegExp(r'SamsungBrowser/(\d+)')),
    ('Opera', RegExp(r'OPR/(\d+)')),
    ('Firefox', RegExp(r'(?:Firefox|FxiOS)/(\d+)')),
    ('Chrome', RegExp(r'(?:Chrome|CriOS)/(\d+)')),
    ('Safari', RegExp(r'Version/(\d+)[\d.]* .*Safari')),
  ]) {
    final m = pattern.firstMatch(ua);
    if (m != null) {
      browser = '$name ${m.group(1)}';
      break;
    }
  }
  final os = ua.contains('Android')
      ? 'Android'
      : (ua.contains('iPhone') || ua.contains('iPad'))
      ? 'iOS'
      : ua.contains('Windows')
      ? 'Windows'
      : ua.contains('Mac OS')
      ? 'Mac'
      : ua.contains('Linux')
      ? 'Linux'
      : null;
  final parts = [browser, os].whereType<String>().toList();
  if (parts.isEmpty) return ua.length > 60 ? ua.substring(0, 60) : ua;
  return parts.join(' · ') + (ua.contains('wv)') ? ' (WebView)' : '');
}

class _FeedbackButton extends StatefulWidget {
  const _FeedbackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_FeedbackButton> createState() => _FeedbackButtonState();
}

class _FeedbackButtonState extends State<_FeedbackButton> {
  bool _showHide = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleHide() {
    _timer?.cancel();
    setState(() => _showHide = !_showHide);
    if (_showHide) _timer = Timer(const Duration(seconds: 4), () => mounted ? setState(() => _showHide = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'كلّمنا: اقتراح أو مشكلة أو سؤال',
          child: Material(
            color: primary.withValues(alpha: 0.92),
            shape: const CircleBorder(),
            elevation: 4,
            shadowColor: primary.withValues(alpha: 0.5),
            child: InkWell(
              key: const ValueKey('feedback-fab'),
              customBorder: const CircleBorder(),
              onTap: () {
                if (_showHide) {
                  _toggleHide();
                } else {
                  widget.onTap();
                }
              },
              onLongPress: _toggleHide,
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(Icons.feedback_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
        if (_showHide) ...[
          const SizedBox(width: 6),
          Material(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              key: const ValueKey('feedback-fab-hide'),
              borderRadius: BorderRadius.circular(100),
              onTap: () => FeedbackFabHost.hiddenForSession.value = true,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.close_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('إخفاء', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

const _kinds = [
  (FeedbackKind.suggestion, '💡', 'اقترح قسم أو فكرة جديدة', 'إيه القسم أو الفكرة اللي نفسك تلاقيها؟'),
  (FeedbackKind.bug, '🐞', 'بلّغ عن مشكلة', 'إيه اللي حصل؟ وكنت بتعمل إيه وقتها؟'),
  (FeedbackKind.question, '❓', 'سؤال أو استفسار', 'اكتب سؤالك وهنرد عليك'),
];

/// The «كلّمنا» sheet: kind, message, optional contact for guests.
class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key, required this.source, required this.signedIn});
  final Map<String, String> source;
  final bool signedIn;

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  FeedbackKind? _kind;
  final _body = TextEditingController();
  final _contact = TextEditingController();
  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _body.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _body.text.trim();
    final contact = _contact.text.replaceAll(RegExp(r'[^0-9+]'), '');
    String? error;
    if (_kind == null) {
      error = 'اختار نوع رسالتك الأول';
    } else if (body.length < 10) {
      error = 'اكتب رسالتك في 10 حروف على الأقل';
    } else if (body.length > 2000) {
      error = 'الرسالة طويلة — 2000 حرف بحد أقصى';
    } else if (contact.isNotEmpty && !RegExp(r'^\+?[0-9]{8,15}$').hasMatch(contact)) {
      error = 'رقم التواصل مش صحيح';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await FeedbackService.submit(kind: _kind!, body: body, contact: widget.signedIn ? null : contact, source: widget.source);
      if (mounted) setState(() => _sent = true);
    } on PostgrestException catch (e) {
      final arabic = RegExp(r'[؀-ۿ]').hasMatch(e.message);
      if (mounted) setState(() => _error = arabic ? e.message : 'تعذر الإرسال، حاول تاني');
    } catch (_) {
      if (mounted) setState(() => _error = 'تعذر الإرسال، اتأكد من النت وحاول تاني');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final insets = MediaQuery.viewInsetsOf(context).bottom;
    if (_sent) {
      final guestWithContact = !widget.signedIn && _contact.text.trim().isNotEmpty;
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle_rounded, color: primary, size: 52),
          const SizedBox(height: 12),
          const Text('وصلتنا رسالتك، شكراً!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            widget.signedIn
                ? 'هنرد عليك في الإشعارات'
                : (guestWithContact ? 'هنرد عليك على الرقم اللي سبته' : 'هنقراها ونهتم بيها'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('تمام')),
          ),
        ]),
      );
    }
    final hint = _kinds.firstWhere((k) => k.$1 == _kind, orElse: () => _kinds.first).$4;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + insets),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('كلّمنا', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('عندك اقتراح لقسم جديد أو قابلتك مشكلة؟ قولنا وهنشوفها بنفسنا.', style: TextStyle(fontSize: 12.5, height: 1.6)),
            const SizedBox(height: 14),
            for (final (kind, emoji, label, _) in _kinds) ...[
              _KindTile(
                emoji: emoji,
                label: label,
                selected: _kind == kind,
                color: primary,
                onTap: _sending ? null : () => setState(() => _kind = kind),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 4),
            TextField(
              key: const ValueKey('feedback-body'),
              controller: _body,
              enabled: !_sending,
              minLines: 3,
              maxLines: 7,
              maxLength: 2000,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder()),
            ),
            if (!widget.signedIn) ...[
              const SizedBox(height: 4),
              TextField(
                key: const ValueKey('feedback-contact'),
                controller: _contact,
                enabled: !_sending,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'رقم موبايل أو واتساب (اختياري)',
                  helperText: 'لو عايز نرد عليك — مش لازم تسجّل دخول',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12.5)),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _sending ? null : _send,
              icon: _sending
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded, size: 18),
              label: const Text('إرسال'),
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(46)),
            ),
          ],
        ),
      ),
    );
  }
}

class _KindTile extends StatelessWidget {
  const _KindTile({required this.emoji, required this.label, required this.selected, required this.color, required this.onTap});
  final String emoji, label;
  final bool selected;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? color.withValues(alpha: 0.10) : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: selected ? color : Theme.of(context).dividerColor, width: selected ? 1.6 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, fontWeight: selected ? FontWeight.w700 : FontWeight.w500))),
            if (selected) Icon(Icons.check_circle_rounded, color: color, size: 18),
          ]),
        ),
      ),
    );
  }
}
