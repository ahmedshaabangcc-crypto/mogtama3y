/// Which "install the app" message a phone visitor should get — the same
/// rules as the HTML card in web/index.html (keep the two in sync).
library;

enum InstallAdvice {
  /// Nothing to show (desktop, already installed, dismissed…).
  none,

  /// Android with a captured `beforeinstallprompt`: one-tap «نزّله».
  androidPrompt,

  /// Android in a real browser that hasn't offered the prompt (yet), e.g.
  /// Firefox, Samsung Internet, or Chrome before its engagement check:
  /// «من القايمة ⋮ اختار تثبيت التطبيق».
  androidMenu,

  /// Android inside Facebook / Instagram / WhatsApp / TikTok… (a webview
  /// that can't install): «افتح الصفحة في Chrome» + copy link.
  androidInApp,

  /// iPhone / iPad Safari: Share → Add to Home Screen → Add.
  iosSafari,

  /// Chrome / Firefox / Edge on iOS 16.4+: the same steps from their own
  /// share button.
  iosOtherBrowser,

  /// An iOS in-app webview (or an old iOS browser that can't add to the
  /// home screen): «افتح الصفحة في Safari الأول» + copy link.
  iosInApp,
}

/// Facebook, Messenger, Instagram, WhatsApp, TikTok, Snapchat, LINE,
/// WeChat, X/Twitter, LinkedIn, Pinterest, Telegram, the Google app on iOS,
/// and Android's generic webview marker «; wv)».
final _inAppRe = RegExp(
  r'FBAN|FBAV|FB_IAB|FBIOS|Messenger|Instagram|WhatsApp|musical_ly|TikTok|BytedanceWebview|Snapchat|Line/|MicroMessenger|Twitter|LinkedInApp|Pinterest|Telegram|GSA/|; wv\)',
  caseSensitive: false,
);

bool isInAppBrowserUA(String ua) => _inAppRe.hasMatch(ua);

/// iOS major/minor from «OS 16_4 like Mac OS X» (0,0 when unknown).
(int, int) _iosVersion(String ua) {
  final m = RegExp(r'OS (\d+)[_.](\d+)').firstMatch(ua);
  if (m == null) return (0, 0);
  return (int.parse(m.group(1)!), int.parse(m.group(2)!));
}

InstallAdvice decideInstallAdvice({
  required String userAgent,
  required bool hasInstallEvent,
  required bool isInstalled,
  required bool isDismissed,
  bool iPadDesktopMode = false,
}) {
  if (isInstalled || isDismissed) return InstallAdvice.none;
  final ua = userAgent;
  if (ua.contains('Chrome-Lighthouse')) return InstallAdvice.none;
  final isIOS = RegExp(r'iPhone|iPad|iPod', caseSensitive: false).hasMatch(ua) || iPadDesktopMode;
  final isAndroid = RegExp(r'Android', caseSensitive: false).hasMatch(ua);
  if (isIOS) {
    if (isInAppBrowserUA(ua)) return InstallAdvice.iosInApp;
    if (RegExp(r'CriOS|FxiOS|EdgiOS|OPiOS').hasMatch(ua)) {
      final (major, minor) = _iosVersion(ua);
      final canAdd = major > 16 || (major == 16 && minor >= 4);
      return canAdd ? InstallAdvice.iosOtherBrowser : InstallAdvice.iosInApp;
    }
    return InstallAdvice.iosSafari;
  }
  if (isAndroid) {
    if (hasInstallEvent) return InstallAdvice.androidPrompt;
    if (isInAppBrowserUA(ua)) return InstallAdvice.androidInApp;
    return InstallAdvice.androidMenu;
  }
  return InstallAdvice.none; // desktop
}

/// localStorage key (shared with the HTML card): dismissed until this
/// epoch-ms. sessionStorage key: a prompt was already shown in this tab.
const installDismissKey = 'm3_install_dismissed_until';
const installShownKey = 'm3_install_shown';
const installDismissDays = 7;
