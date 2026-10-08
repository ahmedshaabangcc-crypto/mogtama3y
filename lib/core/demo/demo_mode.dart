/// Local-only DEMO MODE of the owners'-union app and the merchant app (متجري), for recording tutorial
/// videos without logging in and without touching real data.
///
/// SAFETY: it is switched on ONLY at compile time, with
/// `--dart-define=DEMO=true` (tool/build_ittihad_demo.sh, tool/build_tajer_demo.sh; the `web-ittihad-demo` / `web-tajer-demo` launch
/// config). Nothing at runtime — no URL, query parameter or storage — can
/// turn it on. Every demo code path sits behind `if (kDemo)`, so in a
/// normal build the compiler drops all of it (including [kDemoMarker],
/// which the deploy workflow greps for to make sure no demo build is ever
/// published).
library;

import '../app_flavor.dart';

const bool kDemo = bool.fromEnvironment('DEMO');

/// Present in main.dart.js only when [kDemo] is true (it is referenced
/// only inside `if (kDemo)` blocks). `.github/workflows/deploy.yml` fails
/// the deploy if it finds this string in a build.
const String kDemoMarker = 'MOGTAMA3Y_DEMO_BUILD_9F27C1';

/// The demo build refuses to run anywhere but the local machine.
bool demoHostAllowed(Uri base) => const {'localhost', '127.0.0.1', '::1', '[::1]'}.contains(base.host);

/// Demo roles selectable with `?role=` (only read when [kDemo] is true):
/// the owners'-union roles, or the merchant-app (متجري) roles when built
/// with APP_FLAVOR=tajer.
const unionDemoRoles = ['president', 'treasurer', 'owner', 'tenant', 'guard', 'new'];

/// متجري: `merchant` (the demo shop «محل بيت الشاي — تجريبي»), `new` (a
/// signed-in merchant with no shop yet) and `customer` (a guest on the
/// store page — customers order without an account).
const tajerDemoRoles = ['merchant', 'new', 'customer'];

const demoRoles = isTajerApp ? tajerDemoRoles : unionDemoRoles;

const unionDemoRoleLabels = {'president': 'رئيس الاتحاد', 'treasurer': 'أمين الصندوق', 'owner': 'مالك', 'tenant': 'مستأجر', 'guard': 'الحارس', 'new': 'مستخدم جديد'};

const tajerDemoRoleLabels = {'merchant': 'التاجر (بيت الشاي)', 'new': 'تاجر جديد بدون محل', 'customer': 'زبون (صفحة المتجر)'};

const demoRoleLabels = isTajerApp ? tajerDemoRoleLabels : unionDemoRoleLabels;

/// `?role=` from the page URL (default president / merchant).
String demoRoleFrom(Uri base, {bool tajer = isTajerApp}) {
  final roles = tajer ? tajerDemoRoles : unionDemoRoles;
  final r = base.queryParameters['role'];
  return roles.contains(r) ? r! : roles.first;
}

/// The demo shop's link name: `/#/s/beit-elshay-demo`.
const demoShopSlug = 'beit-elshay-demo';

/// Election state for the demo building (`?elections=`, only read when
/// [kDemo] is true): `open` (default — candidates, voting), `none` (no
/// election, so the president can start one), `ending` (voting time is up,
/// 6 of 10 voted, ready for «إغلاق التصويت وإعلان النتيجة»).
const demoElectionModes = ['open', 'none', 'ending'];

String demoElectionsFrom(Uri base) {
  final e = base.queryParameters['elections'];
  return demoElectionModes.contains(e) ? e! : 'open';
}

/// `?panel=0` hides the floating role switcher for clean recordings.
bool demoPanelVisible(Uri base) => base.queryParameters['panel'] != '0';
