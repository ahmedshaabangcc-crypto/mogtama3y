import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_flavor.dart';
import '../../core/pwa/install_advice.dart';
import '../../core/pwa/install_prompt.dart' as pwa;
import '../../core/support/user_agent.dart';
import '../../core/theme/app_colors.dart';

/// What the overlay needs from the browser (faked in tests).
class InstallPlatform {
  const InstallPlatform();

  String get userAgent => rawUserAgent() ?? '';
  bool get hasInstallEvent => pwa.canInstallApp;
  bool get isInstalled => pwa.isInstalledApp;
  bool get justInstalled => pwa.appJustInstalled;
  bool get iPadDesktopMode => pwa.isIPadDesktopMode;
  bool prompt() => pwa.promptInstallApp();
  String? read(String key, {bool session = false}) => pwa.storageGet(key, session: session);
  void write(String key, String value, {bool session = false}) => pwa.storageSet(key, value, session: session);
  Future<bool> copyLink() => pwa.copyPageLink();
  void openInChrome() => pwa.openPageInChrome();
  DateTime now() => DateTime.now();
}

/// The advice for this visitor right now (dismissal included).
InstallAdvice currentInstallAdvice(InstallPlatform p) {
  final until = int.tryParse(p.read(installDismissKey) ?? '') ?? 0;
  return decideInstallAdvice(
    userAgent: p.userAgent,
    hasInstallEvent: p.hasInstallEvent,
    isInstalled: p.isInstalled || p.justInstalled,
    isDismissed: until > p.now().millisecondsSinceEpoch,
    iPadDesktopMode: p.iPadDesktopMode,
  );
}

/// «نزّل التطبيق على موبايلك» — a small card for phone visitors who came
/// straight into the app (deep links skip the HTML landing and its card).
/// Shown once per tab session (shared with the landing's card), ~5 s after
/// start, only where [placement] allows (the «كلّمنا» button's quiet-screen
/// rules); ✕ hides it for 7 days on both. Sits beside the «كلّمنا» button,
/// above the bottom nav.
class InstallAppOverlay extends StatefulWidget {
  const InstallAppOverlay({
    super.key,
    required this.placement,
    required this.listenable,
    required this.navigator,
    this.platform = const InstallPlatform(),
    this.delay = const Duration(seconds: 5),
    this.brand = appBrandName,
  });

  /// Distance from the bottom edge, or null where the card must stay away.
  final double? Function(BuildContext context) placement;
  final Listenable listenable;
  final NavigatorState? Function() navigator;
  final InstallPlatform platform;
  final Duration delay;
  final String brand;

  @override
  State<InstallAppOverlay> createState() => _InstallAppOverlayState();
}

class _InstallAppOverlayState extends State<InstallAppOverlay> {
  Timer? _start;
  Timer? _poll;
  bool _armed = false;
  bool _closed = false;
  bool _marked = false;
  bool _thanks = false;
  bool _copied = false;
  InstallAdvice _advice = InstallAdvice.none;

  InstallPlatform get _p => widget.platform;

  @override
  void initState() {
    super.initState();
    // Off the web (and in widget tests with no browser) there's nothing to do.
    if (_p.userAgent.isEmpty) return;
    // The landing's card (or this one) already showed in this tab.
    if (_p.read(installShownKey, session: true) == '1') return;
    if (currentInstallAdvice(_p) == InstallAdvice.none) return;
    _start = Timer(widget.delay, () {
      if (!mounted) return;
      setState(() {
        _armed = true;
        _advice = currentInstallAdvice(_p);
      });
      // Chrome offers its prompt late (engagement check) → upgrade to the
      // one-tap button; also notice an install from the browser menu.
      _poll = Timer.periodic(const Duration(seconds: 2), (_) => _refresh());
    });
  }

  void _refresh() {
    if (!mounted || _closed) return;
    if (_p.justInstalled && !_thanks) {
      _installed();
      return;
    }
    final a = currentInstallAdvice(_p);
    if (a != _advice) setState(() => _advice = a);
  }

  void _installed() {
    _p.write(installDismissKey, '${_p.now().add(const Duration(days: 180)).millisecondsSinceEpoch}');
    setState(() => _thanks = true);
    _poll?.cancel();
    Timer(const Duration(seconds: 4), () => mounted ? setState(() => _closed = true) : null);
  }

  void _dismiss() {
    _p.write(installDismissKey, '${_p.now().add(const Duration(days: installDismissDays)).millisecondsSinceEpoch}');
    _close();
  }

  void _close() {
    _poll?.cancel();
    setState(() => _closed = true);
  }

  @override
  void dispose() {
    _start?.cancel();
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    final ok = await _p.copyLink();
    if (mounted) setState(() => _copied = ok);
  }

  void _showSteps() {
    final nav = widget.navigator();
    if (nav == null) return;
    showModalBottomSheet<void>(
      context: nav.context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => IosInstallSteps(brand: widget.brand, otherBrowser: _advice == InstallAdvice.iosOtherBrowser),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_armed || _closed) return const SizedBox.shrink();
    return ListenableBuilder(
      listenable: widget.listenable,
      builder: (context, _) {
        if (!_thanks && _advice == InstallAdvice.none) return const SizedBox.shrink();
        final bottom = widget.placement(context);
        if (bottom == null) return const SizedBox.shrink();
        if (!_marked) {
          _marked = true;
          _p.write(installShownKey, '1', session: true);
        }
        // RTL: start = right, where the «كلّمنا» button (42 px) sits.
        return PositionedDirectional(
          start: 62,
          end: 12,
          bottom: bottom,
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: _card(),
            ),
          ),
        );
      },
    );
  }

  Widget _card() {
    final title = _thanks ? 'شكراً! «${widget.brand}» اتنزّل على موبايلك 🎉' : 'نزّل تطبيق ${widget.brand} على موبايلك';
    final (String? sub, List<Widget> actions) = switch (_advice) {
      _ when _thanks => (null, const <Widget>[]),
      InstallAdvice.androidPrompt => (
          'بيفتح بلمسة من الشاشة الرئيسية زي أي تطبيق.',
          [
            _btn('نزّله', const ValueKey('install-now'), gold: true, () {
              _p.prompt();
              _close();
            }),
          ],
        ),
      InstallAdvice.androidMenu => ('من قايمة المتصفح ⋮ اختار «تثبيت التطبيق» أو «إضافة إلى الشاشة الرئيسية».', const <Widget>[]),
      InstallAdvice.androidInApp => (
          'افتح الصفحة في Chrome وبعدين من القايمة ⋮ اختار «تثبيت التطبيق».',
          [
            _btn('افتح في Chrome', const ValueKey('install-open-chrome'), gold: true, _p.openInChrome),
            _btn(_copied ? 'اتنسخ ✓' : 'انسخ اللينك', const ValueKey('install-copy'), _copy),
          ],
        ),
      InstallAdvice.iosSafari || InstallAdvice.iosOtherBrowser => (
          'ضيفه للشاشة الرئيسية في 3 خطوات من زرار المشاركة.',
          [_btn('إزاي؟', const ValueKey('install-how'), gold: true, _showSteps)],
        ),
      InstallAdvice.iosInApp => (
          'افتح الصفحة في Safari الأول (من زرار ⋯ اختار «فتح في Safari»)، وبعدين ضيفه للشاشة الرئيسية.',
          [_btn(_copied ? 'اتنسخ ✓' : 'انسخ اللينك', const ValueKey('install-copy'), _copy)],
        ),
      InstallAdvice.none => (null, const <Widget>[]),
    };
    return Material(
      key: const ValueKey('install-card'),
      color: AppColors.nightMid,
      elevation: 8,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 4, 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.install_mobile_rounded, color: AppColors.gold, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800, height: 1.4)),
              if (sub != null) ...[
                const SizedBox(height: 3),
                Text(sub, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 6, children: actions),
              ],
            ]),
          ),
          if (!_thanks)
            // No tooltip: this sits above the Navigator (no Overlay here).
            Semantics(
              label: 'مش دلوقتي',
              button: true,
              child: IconButton(
                key: const ValueKey('install-dismiss'),
                visualDensity: VisualDensity.compact,
                onPressed: _dismiss,
                icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 18),
              ),
            ),
        ]),
      ),
    );
  }

  Widget _btn(String label, Key key, VoidCallback onTap, {bool gold = false}) => TextButton(
        key: key,
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: gold ? AppColors.gold : Colors.white.withValues(alpha: 0.1),
          foregroundColor: gold ? AppColors.night : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          minimumSize: const Size(0, 34),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      );
}

/// «إزاي؟» — the three Add-to-Home-Screen steps on iPhone, illustrated.
class IosInstallSteps extends StatelessWidget {
  const IosInstallSteps({super.key, required this.brand, this.otherBrowser = false});
  final String brand;
  final bool otherBrowser;

  @override
  Widget build(BuildContext context) {
    final shareWhere = otherBrowser
        ? 'في Chrome هتلاقيه فوق جنب العنوان، وفي Firefox من القايمة ☰.'
        : 'تحت في شريط Safari (أو جوه زرار ⋯ في iOS الجديد).';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('نزّل «$brand» على الآيفون', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          _step('1', Icons.ios_share_rounded, 'دوس زرار المشاركة (المربع اللي فيه سهم ⬆️)', shareWhere),
          _step('2', Icons.add_box_outlined, 'اختار «إضافة إلى الشاشة الرئيسية»', 'لو مش ظاهر، انزل في القايمة لتحت شوية.'),
          _step('3', Icons.check_circle_outline_rounded, 'دوس «إضافة»', 'هتلاقي أيقونة «$brand» على الشاشة الرئيسية — افتحه منها زي أي تطبيق.'),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('تمام')),
          ),
        ]),
      ),
    );
  }

  Widget _step(String n, IconData icon, String title, String hint) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: AppColors.night, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.gold, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$n. $title', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, height: 1.5)),
              Text(hint, style: const TextStyle(fontSize: 12.5, color: Colors.black54, height: 1.5)),
            ]),
          ),
        ]),
      );
}
