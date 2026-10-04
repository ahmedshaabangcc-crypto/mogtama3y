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

const mogtama3yUrl = 'https://mogtama3y.com';

const tajerUrl = 'https://tajer.mogtama3y.com';
