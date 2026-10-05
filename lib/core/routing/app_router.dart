import 'package:go_router/go_router.dart';

import '../app_flavor.dart';

import '../../features/about/about_platform_screen.dart';
import '../../features/admin/superadmin_control_panel_screen.dart';
import '../../features/auth/auth_landing_screen.dart';
import '../../features/bills/bill_payment_hub_screen.dart';
import '../../features/discover/discover_nearby_screen.dart';
import '../../features/e_address/my_e_addresses_screen.dart';
import '../../features/e_address/public_e_address_screen.dart';
import '../../features/jobs/jobs_board_screen.dart';
import '../../features/legal/privacy_policy_screen.dart';
import '../../features/legal/terms_conditions_screen.dart';
import '../../features/lost_found/lost_found_hub_screen.dart';
import '../../features/marketplace/marketplace_listing_screen.dart';
import '../../features/neighborhood/neighborhood_list_screen.dart';
import '../../features/post/smart_post_picker_screen.dart';
import '../../features/promote/token_wallet_screen.dart';
import '../../features/real_estate/real_estate_marketplace_screen.dart';
import '../../features/recycling/recycling_marketplace_screen.dart';
import '../../features/services/technicians_market_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/shell/open_tajer_app.dart';
import '../../features/shell/tajer_shell.dart';
import '../../features/shell/union_shell.dart';
import '../../features/shops/neighborhood_shops_screen.dart';
import '../../features/sos/sos_emergency_screen.dart';
import '../../features/store/order_tracking_screen.dart';
import '../../features/store/store_page_screen.dart';
import '../../features/support/faq_help_center_screen.dart';
import '../../features/support/support_contact_screen.dart';
import '../../features/union/union_dashboard_screen.dart';
import '../../features/union/union_landing_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/discover/directory_place_screen.dart';
import '../../features/reports/reports_feed_screen.dart';
import '../../features/reports/report_form_screen.dart';
import '../../features/reports/report_details_screen.dart';

/// URLs for the app's main sections, so a browser refresh or a shared
/// link lands back in the same section instead of always on home.
///
/// Every section is a child of '/', so its page sits on top of the
/// bottom-nav shell: the back button returns to home even when the
/// section was opened directly from a link. Deeper screens (a listing's
/// details, a chat, …) are still opened with Navigator.push and keep the
/// URL of the section they were opened from.
///
/// Uses Flutter web's default hash URLs (mogtama3y.com/#/marketplace),
/// which work on GitHub Pages with no server-side rewrite rules.
class AppRoutes {
  AppRoutes._();

  static const marketplace = '/marketplace';
  static const shops = '/shops';
  static const union = '/union';
  static const realEstate = '/real-estate';
  static const jobs = '/jobs';
  static const technicians = '/technicians';
  static const sos = '/sos';
  static const lostFound = '/lost-found';
  static const recycling = '/recycling';
  static const neighborhoods = '/neighborhoods';
  static const wallet = '/wallet';
  static const tokens = '/tokens';
  static const post = '/post';
  static const bills = '/bills';
  static const support = '/support';
  static const faq = '/faq';
  static const terms = '/terms';
  static const privacy = '/privacy';
  static const about = '/about';
  static const admin = '/admin';
  static const login = '/login';
  static const merchant = '/merchant';
  /// The owners'-union campaign page.
  static const ittihad = '/ittihad';
  /// "اكتشف حواليك" — businesses around the user.
  static const nearby = '/nearby';
  /// "عنوانك الإلكتروني" — the user's digital addresses.
  static const myAddress = '/my-address';
  /// "بلاغات حيّك" and "بلّغ عن مشكلة".
  static const reports = '/reports';
  static const newReport = '/report';

  /// A merchant's public store (the QR on the shop opens this).
  static String store(String slug) => '/s/$slug';

  /// A shared digital address (its link / QR opens this).
  static String eAddress(String code) => '/a/$code';
}

GoRoute _section(String path, GoRouterWidgetBuilder builder) => GoRoute(path: path.substring(1), builder: builder);

/// Sections each app exposes. The union app (APP_FLAVOR=ittihad) carries
/// only building governance; مُجتمعي carries everything else and nothing
/// about owners' unions. Shared: wallet, help, legal, login, admin.
final _sharedSections = <String, GoRouterWidgetBuilder>{
  AppRoutes.wallet: (_, _) => const WalletScreen(),
  AppRoutes.support: (_, _) => const SupportContactScreen(),
  AppRoutes.faq: (_, _) => const FaqHelpCenterScreen(),
  AppRoutes.terms: (_, _) => const TermsConditionsScreen(),
  AppRoutes.privacy: (_, _) => const PrivacyPolicyScreen(),
  AppRoutes.admin: (_, _) => const SuperadminControlPanelScreen(),
  AppRoutes.login: (_, _) => const AuthLandingScreen(),
};

final _unionSections = <String, GoRouterWidgetBuilder>{
  AppRoutes.union: (_, _) => const UnionDashboardScreen(),
  AppRoutes.ittihad: (_, _) => const UnionLandingScreen(),
  AppRoutes.sos: (_, _) => const SosEmergencyScreen(),
  AppRoutes.lostFound: (_, _) => const LostFoundHubScreen(),
};

final _mogtama3ySections = <String, GoRouterWidgetBuilder>{
  AppRoutes.marketplace: (_, _) => const MarketplaceListingScreen(),
  AppRoutes.shops: (_, _) => const NeighborhoodShopsScreen(),
  AppRoutes.realEstate: (_, _) => const RealEstateMarketplaceScreen(),
  AppRoutes.jobs: (_, _) => const JobsBoardScreen(),
  AppRoutes.technicians: (_, _) => const TechniciansMarketScreen(),
  AppRoutes.recycling: (_, _) => const RecyclingMarketplaceScreen(),
  AppRoutes.neighborhoods: (_, _) => const NeighborhoodListScreen(),
  AppRoutes.tokens: (_, _) => const TokenWalletScreen(),
  AppRoutes.post: (_, _) => const SmartPostPickerScreen(),
  AppRoutes.bills: (_, _) => const BillPaymentHubScreen(),
  AppRoutes.about: (_, _) => const AboutPlatformScreen(),
  // Merchants use their own app now; old /#/merchant links hand off to it.
  AppRoutes.merchant: (_, _) => const OpenTajerApp(),
  AppRoutes.nearby: (_, _) => const DiscoverNearbyScreen(),
  AppRoutes.myAddress: (_, _) => const MyEAddressesScreen(),
  AppRoutes.reports: (_, _) => const ReportsFeedScreen(),
  AppRoutes.newReport: (_, _) => const ReportFormScreen(),
};

final _tajerSections = <String, GoRouterWidgetBuilder>{
  AppRoutes.merchant: (_, _) => const TajerShell(),
};

final _sections = {
  ..._sharedSections,
  ...(isUnionApp ? _unionSections : (isTajerApp ? _tajerSections : _mogtama3ySections)),
};

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => isUnionApp ? const UnionShell() : (isTajerApp ? const TajerShell() : const AppShell()),
      routes: [
        for (final e in _sections.entries) _section(e.key, e.value),
        if (!isUnionApp) ...[
          GoRoute(path: 'a/:code', builder: (_, state) => PublicEAddressScreen(code: state.pathParameters['code']!)),
          GoRoute(
            path: 's/:slug',
            builder: (_, state) => StorePageScreen(slug: state.pathParameters['slug']!),
            routes: [
              GoRoute(
                path: 'p/:pid',
                builder: (_, state) => StorePageScreen(slug: state.pathParameters['slug']!, productId: state.pathParameters['pid']),
              ),
            ],
          ),
          GoRoute(path: 'o/:code', builder: (_, state) => OrderTrackingScreen(code: state.pathParameters['code']!)),
          GoRoute(path: 'd/:id', builder: (_, state) => DirectoryPlaceScreen(placeId: state.pathParameters['id']!)),
          GoRoute(path: 'r/:id', builder: (_, state) => ReportDetailsScreen(reportId: state.pathParameters['id']!)),
        ],
      ],
    ),
  ],
  // Unknown or stale links (and OAuth callbacks carrying ?code=...) go home.
  // That includes the other app's sections (e.g. /union on مُجتمعي).
  redirect: (_, state) {
    final path = state.uri.path;
    if (path == '/' || path.isEmpty) return null;
    if (_sections.containsKey(path)) return null;
    if (!isUnionApp && (_storePath.hasMatch(path.toLowerCase()) || _eAddressPath.hasMatch(path) || _orderPath.hasMatch(path) || _placePath.hasMatch(path) || _reportPath.hasMatch(path))) return null;
    return '/';
  },
);

final _storePath = RegExp(r'^/s/[a-z0-9-]{3,40}(/p/[0-9a-f-]{36})?$');
final _orderPath = RegExp(r'^/o/T[0-9A-Z]{7}$');
final _placePath = RegExp(r'^/d/[0-9a-zA-Z-]{8,64}$');
final _eAddressPath = RegExp(r'^/a/[A-Za-z0-9-]{4,30}$');
final _reportPath = RegExp(r'^/r/[0-9a-f-]{36}$');
