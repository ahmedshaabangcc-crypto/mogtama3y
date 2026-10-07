/// Local-only DEMO MODE of the owners'-union app, for recording tutorial
/// videos without logging in and without touching real data.
///
/// SAFETY: it is switched on ONLY at compile time, with
/// `--dart-define=DEMO=true` (see README / the `web-ittihad-demo` launch
/// config). Nothing at runtime — no URL, query parameter or storage — can
/// turn it on. Every demo code path sits behind `if (kDemo)`, so in a
/// normal build the compiler drops all of it (including [kDemoMarker],
/// which the deploy workflow greps for to make sure no demo build is ever
/// published).
library;

const bool kDemo = bool.fromEnvironment('DEMO');

/// Present in main.dart.js only when [kDemo] is true (it is referenced
/// only inside `if (kDemo)` blocks). `.github/workflows/deploy.yml` fails
/// the deploy if it finds this string in a build.
const String kDemoMarker = 'MOGTAMA3Y_DEMO_BUILD_9F27C1';

/// The demo build refuses to run anywhere but the local machine.
bool demoHostAllowed(Uri base) => const {'localhost', '127.0.0.1', '::1', '[::1]'}.contains(base.host);

/// Demo roles selectable with `?role=` (only read when [kDemo] is true).
const demoRoles = ['president', 'treasurer', 'owner', 'tenant', 'guard', 'new'];

const demoRoleLabels = {
  'president': 'رئيس الاتحاد',
  'treasurer': 'أمين الصندوق',
  'owner': 'مالك',
  'tenant': 'مستأجر',
  'guard': 'الحارس',
  'new': 'مستخدم جديد',
};

/// `?role=` from the page URL (default president).
String demoRoleFrom(Uri base) {
  final r = base.queryParameters['role'];
  return demoRoles.contains(r) ? r! : 'president';
}

/// `?panel=0` hides the floating role switcher for clean recordings.
bool demoPanelVisible(Uri base) => base.queryParameters['panel'] != '0';
