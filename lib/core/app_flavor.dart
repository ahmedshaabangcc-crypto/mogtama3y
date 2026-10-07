/// One codebase, three web apps (same accounts, same wallet):
///
///  * مُجتمعي (default): the neighbourhood super-app — no owners'-union
///    features or wording at all.
///  * اتحاد الملاك: building governance only (dues, decisions, elections,
///    reports, SOS, visitors, guard, lost & found) with a button back to
///    مُجتمعي. Built with `--dart-define=APP_FLAVOR=ittihad`.
///  * متجري (tajer): the merchant app — campaign page, the merchant panel
///    and store pages only, installable on the phone. Built with
///    `--dart-define=APP_FLAVOR=tajer`.
library;

const _flavor = String.fromEnvironment('APP_FLAVOR', defaultValue: 'mogtama3y');

const bool isUnionApp = _flavor == 'ittihad';

const bool isTajerApp = _flavor == 'tajer';

/// The name shown on this app's own screens (sign-in, sign-up…).
const String appBrandName = isTajerApp ? 'متجري' : (isUnionApp ? 'اتحاد الملاك' : 'مُجتمعي');

/// One-line pitch under the brand name on the sign-in screens.
const String appSignInTagline = isTajerApp
    ? 'سجّل دخولك أو اعمل حساب وابدأ متجرك أونلاين'
    : (isUnionApp ? 'سجّل دخولك أو أنشئ حسابك لإدارة عمارتك' : 'سجّل دخولك أو أنشئ حسابك وابدأ مع جيرانك وحيّك');

const String appLoginTagline = isTajerApp
    ? 'سجّل دخولك وتابع طلباتك ومنتجاتك'
    : (isUnionApp ? 'سجّل دخولك لمتابعة إدارة عمارتك' : 'سجّل دخولك وكمّل مع جيرانك وحيّك');

const String appSignupTagline = isTajerApp
    ? 'حساب واحد ومتجرك جاهز في دقيقتين'
    : (isUnionApp ? 'أنشئ حسابك أولاً، وبعدها اربطه بعمارتك ووحدتك السكنية' : 'حساب واحد لكل خدمات حيّك: السوق والمحلات والصيانة وأكتر');

const mogtama3yUrl = 'https://mogtama3y.com';

const tajerUrl = 'https://tajer.mogtama3y.com';

const ittihadUrl = 'https://ittihad.mogtama3y.com';
