import 'package:go_router/go_router.dart';

import '../app_flavor.dart';
import '../demo/demo_mode.dart';
import '../support/feedback_route_observer.dart';

import '../../features/about/about_platform_screen.dart';
import '../../features/admin/superadmin_control_panel_screen.dart';
import '../../features/auth/auth_landing_screen.dart';
import '../../features/auth/password_reset_screens.dart';
import '../../features/chat/building_chat_screen.dart';
import '../../features/guard/guard_console_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/union/board_decisions_screen.dart';
import '../../features/union/election_voting_screen.dart';
import '../../features/union/financial_report_screen.dart';
import '../../features/union/join_as_tenant_screen.dart';
import '../../features/union/manage_tenants_screen.dart';
import '../../features/union/union_registration_screen.dart';
import '../../features/visitor/visitor_qr_pass_screen.dart';
import '../../features/union/building_polls_screen.dart';
import '../../features/union/union_feed_screen.dart';
import '../../features/visitor/visitor_pass_link_screen.dart';
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
import '../../features/recycling/auction_detail_screen.dart';
import '../../features/recycling/recycling_marketplace_screen.dart';
import '../../features/recycling/scrap_dealer_home_screen.dart';
import '../../features/services/technicians_market_screen.dart';
import '../../features/masjid/masjid_home_screen.dart';
import '../../features/masjid/mosque_page_screen.dart';
import '../../features/masjid_tools/adhkar_screens.dart' deferred as tools_adhkar;
import '../../features/masjid_tools/hijri_screen.dart' deferred as tools_hijri;
import '../../features/masjid_tools/masjid_tools_entry.dart';
import '../../features/masjid_tools/qibla_screen.dart' deferred as tools_qibla;
import '../../features/masjid_tools/quran_screens.dart' deferred as tools_quran;
import '../../features/masjid_tools/reminders_screen.dart' deferred as tools_reminders;
import '../../features/masjid_tools/tutor_screens.dart' deferred as tools_tutor;
import '../../features/shell/app_shell.dart';
import '../../features/shell/masjid_shell.dart';
import '../../features/shell/open_tajer_app.dart';
import '../../features/shell/tajer_shell.dart';
import '../../features/shell/union_shell.dart';
import '../../features/shops/neighborhood_shops_screen.dart';
import '../../features/sos/sos_emergency_screen.dart';
import '../../features/store/order_tracking_screen.dart';
import '../../features/store/store_page_screen.dart';
import '../../features/support/faq_help_center_screen.dart';
import '../../features/support/support_contact_screen.dart';
import '../../features/union/dues_status_screen.dart';
import '../../features/union/maintenance_payment_screen.dart';
import '../../features/union/pending_members_screen.dart';
import '../../features/union/treasurer_screen.dart';
import '../../features/union/union_dashboard_screen.dart';
import '../../features/union/union_fund_screen.dart';
import '../../features/union/union_landing_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/discover/directory_place_screen.dart';
import '../../features/reports/reports_feed_screen.dart';
import '../../features/reports/report_form_screen.dart';
import '../../features/reports/report_details_screen.dart';
import '../../features/people/friends_screen.dart';
import '../../features/people/chat_screen.dart';
import '../../features/rooms/room_screen.dart';
import '../../features/rooms/rooms_home_screen.dart';
import '../../features/cars/cars_market_screen.dart';
import '../../features/cars/car_details_screen.dart';
import '../../features/tutoring/tutoring_market_screen.dart';
import '../../features/tutoring/tutor_details_screen.dart';
import '../../features/halls/halls_market_screen.dart';
import '../../features/halls/hall_details_screen.dart';
import '../../features/pets/pets_home_screen.dart';
import '../../features/pets/pet_details_screen.dart';
import '../../features/kids/kids_market_screen.dart';
import '../../features/kids/kids_item_details_screen.dart';
import '../../features/merchant/demo_merchant_routes.dart';

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

  /// Union money & approvals (notifications deep-link here — 0076).
  static const unionFund = '/union-fund';
  static const unionDues = '/union-dues';
  static const unionTreasurer = '/union-treasurer';
  static const unionApprovals = '/union-approvals';
  static const unionPay = '/union-pay';
  static const realEstate = '/real-estate';
  static const jobs = '/jobs';
  static const technicians = '/technicians';
  static const sos = '/sos';
  static const lostFound = '/lost-found';
  static const recycling = '/recycling';

  /// One recycling auction (dealer notifications deep-link here).
  static String recyclingLot(String id) => '/recycling/$id';

  /// «لوحة تاجر الخردة» — register as a scrap dealer / matching auctions.
  static const scrapDealer = '/scrap-dealer';
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
  /// "أصحابي والرسائل" — friends, requests and private chats.
  static const friends = '/friends';
  /// "سيارات" — cars for sale / rent and parts.
  static const cars = '/cars';

  /// One car listing (its share link opens this).
  static String car(String id) => '/cars/$id';

  /// "دروس خصوصية" — private tutors by subject, stage and place.
  static const tutoring = '/tutoring';

  /// One tutor listing (its share link opens this).
  static String tutor(String id) => '/tutoring/$id';
  /// "قاعات المناسبات" — event venues.
  static const halls = '/halls';

  /// One event hall (its share link opens this).
  static String hall(String id) => '/halls/$id';
  /// "الحيوانات الأليفة" — pets for sale / adoption / mating, lost & found, supplies.
  static const pets = '/pets';

  /// One pet listing (its share link opens this).
  static String pet(String id) => '/pets/$id';
  /// "مستلزمات الأطفال" — kids & baby gear, new and used.
  static const kids = '/kids';

  /// One kids-gear listing (its share link opens this).
  static String kidsItem(String id) => '/kids/$id';

  /// A private chat with a friend.
  static String chat(String userId) => '/chat/$userId';

  /// «غرف الدردشة» — public chat rooms (مُجتمعي only).
  static const rooms = '/rooms';

  /// One chat room (reply notifications deep-link here).
  static String room(String id) => '/rooms/$id';

  /// A merchant's public store (the QR on the shop opens this).
  static String store(String slug) => '/s/$slug';

  /// Set a new password — opened from a «نسيت كلمة المرور؟» email link.
  static const resetPassword = '/reset-password';

  /// Union app: «تصويت السكان», the building feed (official announcements)
  /// and the building chat — notifications deep-link here.
  static const polls = '/polls';
  static const feed = '/feed';
  static const buildingChat = '/building-chat';

  /// Union app: a visitor pass QR, shared to the visitor over WhatsApp.
  static String visitorPass(String code) => '/pass/$code';

  /// A shared digital address (its link / QR opens this).
  static String eAddress(String code) => '/a/$code';

  /// «المساجد» — mosques & prayer times (مُجتمعي section; the masjid app's home).
  static const masjid = '/masjid';

  /// One mosque's page (its share link and follower notifications open this).
  static String mosque(String id) => '/masjid/$id';

  /// «أدوات يومية» (masjid app and مُجتمعي, guests too) — each screen is a
  /// deferred library, loaded on first open.
  static const masjidToolsQuran = '/masjid/tools/quran';
  static const masjidToolsAdhkar = '/masjid/tools/adhkar';
  static const masjidToolsQibla = '/masjid/tools/qibla';
  static const masjidToolsHijri = '/masjid/tools/hijri';
  static const masjidToolsReminders = '/masjid/tools/reminders';
  static const masjidToolsTutor = '/masjid/tools/tutor';
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
  AppRoutes.resetPassword: (_, _) => const SetNewPasswordScreen(),
};

final _unionSections = <String, GoRouterWidgetBuilder>{
  AppRoutes.union: (_, _) => const UnionDashboardScreen(),
  AppRoutes.ittihad: (_, _) => const UnionLandingScreen(),
  AppRoutes.sos: (_, _) => const SosEmergencyScreen(),
  AppRoutes.lostFound: (_, _) => const LostFoundHubScreen(),
  AppRoutes.unionFund: (_, _) => const UnionFundScreen(),
  AppRoutes.unionDues: (_, _) => const DuesStatusScreen(),
  AppRoutes.unionTreasurer: (_, _) => const TreasurerScreen(),
  AppRoutes.unionApprovals: (_, _) => const PendingMembersScreen(),
  AppRoutes.unionPay: (_, _) => const MaintenancePaymentScreen(),
  AppRoutes.polls: (_, _) => const BuildingPollsScreen(),
  AppRoutes.feed: (_, _) => const UnionFeedScreen(),
  AppRoutes.buildingChat: (_, _) => const BuildingChatEntryScreen(),
  // Demo build only: direct links to screens that are otherwise opened
  // from the dashboard, for recording shortcuts.
  if (kDemo) ..._demoSections,
};

final _demoSections = <String, GoRouterWidgetBuilder>{
  '/guard': (_, _) => const GuardConsoleScreen(),
  '/visitor-pass': (_, _) => const VisitorQrPassScreen(),
  '/elections': (_, _) => const ElectionVotingScreen(),
  '/board': (_, _) => const BoardDecisionsScreen(),
  '/financial-report': (_, _) => const FinancialReportScreen(),
  '/tenants': (_, _) => const ManageTenantsScreen(),
  '/join': (_, _) => const UnionRegistrationScreen(),
  '/join-tenant': (_, _) => const JoinAsTenantScreen(),
  '/notifications': (_, _) => const NotificationsScreen(),
};

final _mogtama3ySections = <String, GoRouterWidgetBuilder>{
  AppRoutes.marketplace: (_, _) => const MarketplaceListingScreen(),
  AppRoutes.shops: (_, _) => const NeighborhoodShopsScreen(),
  AppRoutes.realEstate: (_, _) => const RealEstateMarketplaceScreen(),
  AppRoutes.jobs: (_, _) => const JobsBoardScreen(),
  AppRoutes.technicians: (_, _) => const TechniciansMarketScreen(),
  AppRoutes.recycling: (_, _) => const RecyclingMarketplaceScreen(),
  AppRoutes.scrapDealer: (_, _) => const ScrapDealerHomeScreen(),
  AppRoutes.neighborhoods: (_, _) => const NeighborhoodListScreen(),
  AppRoutes.tokens: (_, _) => const TokenWalletScreen(),
  AppRoutes.post: (_, _) => const SmartPostPickerScreen(),
  AppRoutes.bills: (_, _) => const BillPaymentHubScreen(),
  AppRoutes.about: (_, _) => const AboutPlatformScreen(),
  // Merchants use their own app now; old /#/merchant links hand off to it.
  AppRoutes.merchant: (_, _) => const OpenTajerApp(),
  AppRoutes.nearby: (_, state) => DiscoverNearbyScreen(
        showPeople: state.uri.queryParameters['tab'] == 'people',
        initialQuery: state.uri.queryParameters['q'],
        initialCategory: state.uri.queryParameters['cat'],
      ),
  AppRoutes.myAddress: (_, _) => const MyEAddressesScreen(),
  AppRoutes.reports: (_, _) => const ReportsFeedScreen(),
  AppRoutes.newReport: (_, _) => const ReportFormScreen(),
  AppRoutes.friends: (_, _) => const FriendsScreen(),
  AppRoutes.cars: (_, _) => const CarsMarketScreen(),
  AppRoutes.tutoring: (_, _) => const TutoringMarketScreen(),
  AppRoutes.halls: (_, _) => const HallsMarketScreen(),
  AppRoutes.pets: (_, _) => const PetsHomeScreen(),
  AppRoutes.kids: (_, _) => const KidsMarketScreen(),
  AppRoutes.rooms: (_, _) => const RoomsHomeScreen(),
  ..._masjidSections,
};

final _masjidSections = <String, GoRouterWidgetBuilder>{
  AppRoutes.masjid: (_, _) => const MasjidHomeScreen(),
  AppRoutes.masjidToolsQuran: (_, _) => DeferredPage(title: 'المصحف', load: tools_quran.loadLibrary, builder: () => tools_quran.QuranHomeScreen()),
  AppRoutes.masjidToolsAdhkar: (_, _) => DeferredPage(title: 'الأذكار', load: tools_adhkar.loadLibrary, builder: () => tools_adhkar.AdhkarHomeScreen()),
  AppRoutes.masjidToolsQibla: (_, _) => DeferredPage(title: 'اتجاه القبلة', load: tools_qibla.loadLibrary, builder: () => tools_qibla.QiblaScreen()),
  AppRoutes.masjidToolsHijri: (_, _) => DeferredPage(title: 'التقويم الهجري', load: tools_hijri.loadLibrary, builder: () => tools_hijri.HijriCalendarScreen()),
  AppRoutes.masjidToolsReminders: (_, _) =>
      DeferredPage(title: 'تنبيه الصلاة', load: tools_reminders.loadLibrary, builder: () => tools_reminders.PrayerRemindersScreen()),
  AppRoutes.masjidToolsTutor: (_, _) => DeferredPage(title: 'المحفّظ', load: tools_tutor.loadLibrary, builder: () => tools_tutor.QuranTutorScreen()),
};

final _tajerSections = <String, GoRouterWidgetBuilder>{
  AppRoutes.merchant: (_, _) => const TajerShell(),
};

final _sections = {
  ..._sharedSections,
  ...(isUnionApp ? _unionSections : (isTajerApp ? _tajerSections : (isMasjidApp ? _masjidSections : _mogtama3ySections))),
};

final appRouter = GoRouter(
  // The floating «كلّمنا» button follows the top screen (0088).
  observers: [feedbackRouteObserver],
  routes: [
    GoRoute(
      path: '/',
      builder: (_, state) => isUnionApp
          ? const UnionShell()
          : isMasjidApp
          ? const MasjidShell()
          : (isTajerApp
                // Demo build only: `/?tab=1&add=1` opens a panel tab directly.
                ? (kDemo ? TajerShell(demoTab: int.tryParse(state.uri.queryParameters['tab'] ?? ''), demoAdd: state.uri.queryParameters['add'] == '1') : const TajerShell())
                : const AppShell()),
      routes: [
        for (final e in _sections.entries) _section(e.key, e.value),
        if (isUnionApp) GoRoute(path: 'pass/:code', builder: (_, state) => VisitorPassLinkScreen(code: state.pathParameters['code']!)),
        if (_hasMosques)
          GoRoute(path: 'masjid/:id', builder: (_, state) => MosquePageScreen(mosqueId: state.pathParameters['id']!)),
        if (_neighbourhoodLinks) ...[
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
          GoRoute(path: 'd/:id', builder: (_, state) => DirectoryPlaceScreen(placeId: state.pathParameters['id']!, place: state.extra as Map<String, dynamic>?)),
          GoRoute(path: 'r/:id', builder: (_, state) => ReportDetailsScreen(reportId: state.pathParameters['id']!)),
          GoRoute(path: 'cars/:id', builder: (_, state) => CarDetailsScreen(listingId: state.pathParameters['id']!, initial: state.extra as Map<String, dynamic>?)),
          GoRoute(path: 'tutoring/:id', builder: (_, state) => TutorDetailsScreen(listingId: state.pathParameters['id']!, initial: state.extra as Map<String, dynamic>?)),
          GoRoute(path: 'halls/:id', builder: (_, state) => HallDetailsScreen(hallId: state.pathParameters['id']!, initial: state.extra as Map<String, dynamic>?)),
          GoRoute(path: 'pets/:id', builder: (_, state) => PetDetailsScreen(listingId: state.pathParameters['id']!, initial: state.extra as Map<String, dynamic>?)),
          GoRoute(path: 'recycling/:id', builder: (_, state) => AuctionDetailScreen(listingId: state.pathParameters['id']!)),
          GoRoute(path: 'kids/:id', builder: (_, state) => KidsItemDetailsScreen(listingId: state.pathParameters['id']!, initial: state.extra as Map<String, dynamic>?)),
          GoRoute(path: 'chat/:userId', builder: (_, state) => ChatScreen(userId: state.pathParameters['userId']!)),
        ],
        if (!isUnionApp && !isTajerApp && !isMasjidApp)
          GoRoute(path: 'rooms/:id', builder: (_, state) => RoomScreen(roomId: state.pathParameters['id']!)),
        // Demo build only: direct links to merchant screens for recordings.
        if (kDemo && isTajerApp) ...demoTajerRoutes,
      ],
    ),
  ],
  // Unknown or stale links (and OAuth callbacks carrying ?code=...) go home.
  // That includes the other app's sections (e.g. /union on مُجتمعي).
  redirect: (_, state) => isInAppPath(state.uri.path) ? null : '/',
);

/// Whether [path] opens a screen in this app (flavour). Anything else —
/// unknown links, OAuth callbacks, another app's sections (e.g. /union on
/// مُجتمعي, /friends in the union app) — would just bounce to home.
bool isInAppPath(String path) {
  if (path == '/' || path.isEmpty) return true;
  if (_sections.containsKey(path)) return true;
  if (kDemo && isTajerApp && demoTajerPaths.contains(path)) return true;
  if (_hasMosques && _mosquePath.hasMatch(path)) return true;
  if (_neighbourhoodLinks && _hallPath.hasMatch(path)) return true;
  if (_neighbourhoodLinks && _petPath.hasMatch(path)) return true;
  if (_neighbourhoodLinks && _recyclingLotPath.hasMatch(path)) return true;
  if (isUnionApp && _passPath.hasMatch(path)) return true;
  if (!isUnionApp && !isTajerApp && !isMasjidApp && _roomPath.hasMatch(path)) return true;
  return _neighbourhoodLinks &&
      (_storePath.hasMatch(path.toLowerCase()) || _eAddressPath.hasMatch(path) || _orderPath.hasMatch(path) || _placePath.hasMatch(path) || _reportPath.hasMatch(path) || _carPath.hasMatch(path) || _tutorPath.hasMatch(path) || _kidsPath.hasMatch(path) || _chatPath.hasMatch(path));
}

/// Where to open an in-app [path] this app can't show: union sections live
/// on the union app, everything else on مُجتمعي.
Uri otherAppUrlFor(String path) {
  const union = {
    AppRoutes.union, AppRoutes.ittihad, AppRoutes.sos, AppRoutes.lostFound,
    AppRoutes.unionFund, AppRoutes.unionDues, AppRoutes.unionTreasurer, AppRoutes.unionApprovals, AppRoutes.unionPay,
    AppRoutes.polls, AppRoutes.feed, AppRoutes.buildingChat,
  };
  final base = union.contains(path) ? 'https://ittihad.mogtama3y.com' : mogtama3yUrl;
  return Uri.parse('$base/#$path');
}

/// Store / order / place / listing / chat links: مُجتمعي and متجري (not the
/// union or the masjid app).
const _neighbourhoodLinks = !isUnionApp && !isMasjidApp;

/// Mosque pages: مُجتمعي's «المساجد» section and the masjid app.
const _hasMosques = isMasjidApp || (!isUnionApp && !isTajerApp);

final _mosquePath = RegExp(r'^/masjid/[0-9a-f-]{36}$');
final _storePath = RegExp(r'^/s/[a-z0-9-]{3,40}(/p/[0-9a-f-]{36})?$');
final _orderPath = RegExp(r'^/o/T[0-9A-Z]{7}$');
final _placePath = RegExp(r'^/d/[0-9a-zA-Z-]{8,64}$');
final _eAddressPath = RegExp(r'^/a/[A-Za-z0-9-]{4,30}$');
final _reportPath = RegExp(r'^/r/[0-9a-f-]{36}$');
final _chatPath = RegExp(r'^/chat/[0-9a-f-]{36}$');
final _roomPath = RegExp(r'^/rooms/[0-9a-f-]{36}$');
final _carPath = RegExp(r'^/cars/[0-9a-f-]{36}$');
final _tutorPath = RegExp(r'^/tutoring/[0-9a-f-]{36}$');
final _hallPath = RegExp(r'^/halls/[0-9a-f-]{36}$');
final _petPath = RegExp(r'^/pets/[0-9a-f-]{36}$');
final _kidsPath = RegExp(r'^/kids/[0-9a-f-]{36}$');
final _recyclingLotPath = RegExp(r'^/recycling/[0-9a-f-]{36}$');
final _passPath = RegExp(r'^/pass/[A-Za-z0-9-]{4,40}$');
