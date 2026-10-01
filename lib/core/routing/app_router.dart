import 'package:go_router/go_router.dart';

import '../../features/about/about_platform_screen.dart';
import '../../features/admin/superadmin_control_panel_screen.dart';
import '../../features/auth/auth_landing_screen.dart';
import '../../features/bills/bill_payment_hub_screen.dart';
import '../../features/jobs/jobs_board_screen.dart';
import '../../features/legal/privacy_policy_screen.dart';
import '../../features/legal/terms_conditions_screen.dart';
import '../../features/lost_found/lost_found_hub_screen.dart';
import '../../features/marketplace/marketplace_listing_screen.dart';
import '../../features/merchant/merchant_dashboard_screen.dart';
import '../../features/neighborhood/neighborhood_list_screen.dart';
import '../../features/post/smart_post_picker_screen.dart';
import '../../features/promote/token_wallet_screen.dart';
import '../../features/real_estate/real_estate_marketplace_screen.dart';
import '../../features/recycling/recycling_marketplace_screen.dart';
import '../../features/services/technicians_market_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/shops/neighborhood_shops_screen.dart';
import '../../features/sos/sos_emergency_screen.dart';
import '../../features/store/store_page_screen.dart';
import '../../features/support/faq_help_center_screen.dart';
import '../../features/support/support_contact_screen.dart';
import '../../features/union/union_dashboard_screen.dart';
import '../../features/union/union_landing_screen.dart';
import '../../features/wallet/wallet_screen.dart';

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

  /// A merchant's public store (the QR on the shop opens this).
  static String store(String slug) => '/s/$slug';
}

GoRoute _section(String path, GoRouterWidgetBuilder builder) => GoRoute(path: path.substring(1), builder: builder);

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const AppShell(),
      routes: [
        _section(AppRoutes.marketplace, (_, _) => const MarketplaceListingScreen()),
        _section(AppRoutes.shops, (_, _) => const NeighborhoodShopsScreen()),
        _section(AppRoutes.union, (_, _) => const UnionDashboardScreen()),
        _section(AppRoutes.realEstate, (_, _) => const RealEstateMarketplaceScreen()),
        _section(AppRoutes.jobs, (_, _) => const JobsBoardScreen()),
        _section(AppRoutes.technicians, (_, _) => const TechniciansMarketScreen()),
        _section(AppRoutes.sos, (_, _) => const SosEmergencyScreen()),
        _section(AppRoutes.lostFound, (_, _) => const LostFoundHubScreen()),
        _section(AppRoutes.recycling, (_, _) => const RecyclingMarketplaceScreen()),
        _section(AppRoutes.neighborhoods, (_, _) => const NeighborhoodListScreen()),
        _section(AppRoutes.wallet, (_, _) => const WalletScreen()),
        _section(AppRoutes.tokens, (_, _) => const TokenWalletScreen()),
        _section(AppRoutes.post, (_, _) => const SmartPostPickerScreen()),
        _section(AppRoutes.bills, (_, _) => const BillPaymentHubScreen()),
        _section(AppRoutes.support, (_, _) => const SupportContactScreen()),
        _section(AppRoutes.faq, (_, _) => const FaqHelpCenterScreen()),
        _section(AppRoutes.terms, (_, _) => const TermsConditionsScreen()),
        _section(AppRoutes.privacy, (_, _) => const PrivacyPolicyScreen()),
        _section(AppRoutes.about, (_, _) => const AboutPlatformScreen()),
        _section(AppRoutes.admin, (_, _) => const SuperadminControlPanelScreen()),
        _section(AppRoutes.login, (_, _) => const AuthLandingScreen()),
        _section(AppRoutes.merchant, (_, _) => const MerchantDashboardScreen()),
        _section(AppRoutes.ittihad, (_, _) => const UnionLandingScreen()),
        GoRoute(path: 's/:slug', builder: (_, state) => StorePageScreen(slug: state.pathParameters['slug']!)),
      ],
    ),
  ],
  // Unknown or stale links (and OAuth callbacks carrying ?code=...) go home.
  redirect: (_, state) {
    final path = state.uri.path;
    if (path == '/' || path.isEmpty) return null;
    const known = {
      AppRoutes.marketplace, AppRoutes.shops, AppRoutes.union, AppRoutes.realEstate, AppRoutes.jobs,
      AppRoutes.technicians, AppRoutes.sos, AppRoutes.lostFound, AppRoutes.recycling, AppRoutes.neighborhoods,
      AppRoutes.wallet, AppRoutes.tokens, AppRoutes.post, AppRoutes.bills, AppRoutes.support, AppRoutes.faq,
      AppRoutes.terms, AppRoutes.privacy, AppRoutes.about, AppRoutes.admin, AppRoutes.login, AppRoutes.merchant, AppRoutes.ittihad,
    };
    if (known.contains(path) || _storePath.hasMatch(path.toLowerCase())) return null;
    return '/';
  },
);

final _storePath = RegExp(r'^/s/[a-z0-9-]{3,40}$');
