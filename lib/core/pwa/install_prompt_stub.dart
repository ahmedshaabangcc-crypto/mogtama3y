bool get canInstallApp => false;
bool get isInstalledApp => false;
bool get isIOSBrowser => false;
bool promptInstallApp() => false;

/// iPadOS Safari reports a Mac user agent; true when it's really a touch iPad.
bool get isIPadDesktopMode => false;

/// The app was just installed from this tab (`appinstalled`).
bool get appJustInstalled => false;

String? storageGet(String key, {bool session = false}) => null;
void storageSet(String key, String value, {bool session = false}) {}

/// Copies this page's link; false when the browser refused.
Future<bool> copyPageLink() async => false;

/// Android: reopens this page in Chrome (an intent: link) from an in-app browser.
void openPageInChrome() {}
