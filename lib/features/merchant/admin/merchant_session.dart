import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/geo/money.dart';
import '../../../core/realtime/realtime_inserts.dart';
import '../../../core/shops/store_service.dart';

/// The signed-in merchant's state shared by every admin page (متجري): the
/// shops, the one shown, the «new orders» badge and the new-order alert —
/// Realtime inserts on shop_orders (0096) with a 60 s poll as fallback.
class MerchantSession extends ChangeNotifier {
  MerchantSession({this.pollEvery = const Duration(seconds: 60)});

  static MerchantSession? _instance;

  /// Tests: the session every shell uses.
  @visibleForTesting
  static MerchantSession? debugInstance;

  /// A test session is in place (the shell then skips the sign-in check).
  static bool get isTestSession => debugInstance != null;

  /// One session per signed-in user.
  static MerchantSession get instance {
    if (debugInstance != null) return debugInstance!;
    final uid = AuthService.currentUser?.id;
    final s = _instance;
    if (s != null && s._uid == uid) return s;
    s?.dispose();
    return _instance = MerchantSession().._uid = uid;
  }

  String? _uid;
  final Duration pollEvery;

  bool loading = true;
  bool loadError = false;
  List<Map<String, dynamic>> shops = [];
  int selected = 0;

  /// Orders waiting for the merchant («طلب جديد»).
  int newOrders = 0;

  /// Every order of the shop (for the onboarding checklist).
  int allOrders = 0;

  /// Bumped when orders changed elsewhere (a new one arrived, a status
  /// moved): pages showing orders reload.
  final ordersVersion = ValueNotifier<int>(0);

  /// New orders as they arrive (the shell shows a banner + chime).
  final _alerts = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get alerts => _alerts.stream;

  Map<String, dynamic>? get shop => shops.isEmpty ? null : shops[selected.clamp(0, shops.length - 1)];
  String? get shopId => shop?['id'] as String?;

  RealtimeChannel? _channel;
  Timer? _poll;
  String? _watching;
  DateTime? _latestSeen;
  bool _disposed = false;
  Future<void>? _loading;

  Future<void> load() => _loading ??= _load().whenComplete(() => _loading = null);

  Future<void> _load() async {
    loading = shops.isEmpty;
    loadError = false;
    _notify();
    try {
      final list = await StoreService.fetchMyShops();
      shops = list;
      selected = selected.clamp(0, list.isEmpty ? 0 : list.length - 1);
      loading = false;
      _applyShop();
    } catch (_) {
      loading = false;
      loadError = shops.isEmpty;
    }
    _notify();
  }

  void select(int i) {
    if (i == selected || i < 0 || i >= shops.length) return;
    selected = i;
    newOrders = 0;
    allOrders = 0;
    _applyShop();
    _notify();
  }

  void _applyShop() {
    final s = shop;
    if (s != null) StoreService.merchantCurrency = currencyOf(s);
    _watch(s?['id'] as String?);
  }

  void _watch(String? shopId) {
    if (shopId == _watching) return;
    _stopWatching();
    _watching = shopId;
    _latestSeen = null;
    if (shopId == null) return;
    try {
      _channel = subscribeToInserts(table: 'shop_orders', column: 'shop_id', value: shopId, onInsert: (_) => refreshOrders(alert: true));
    } catch (_) {
      // No Realtime (tests / offline): the poll still runs.
    }
    _poll = Timer.periodic(pollEvery, (_) => refreshOrders(alert: true));
    refreshOrders();
  }

  /// The admin shell is on screen: watch the shown shop for new orders.
  void resume() {
    if (shops.isNotEmpty) _applyShop();
  }

  /// The admin shell left the screen (store page, sign-out): no Realtime
  /// channel or poll keeps running behind it.
  void pause() {
    _stopWatching();
    _watching = null;
  }

  void _stopWatching() {
    _poll?.cancel();
    _poll = null;
    final c = _channel;
    _channel = null;
    if (c != null) unsubscribe(c).ignore();
  }

  /// Re-reads the badge. With [alert], an order newer than the last one
  /// seen is announced on [alerts] and the order pages reload.
  Future<void> refreshOrders({bool alert = false}) async {
    final id = _watching;
    if (id == null) return;
    try {
      final page = await StoreService.merchantOrders(shopId: id, limit: 1);
      if (_disposed || id != _watching) return;
      newOrders = page.counts['placed'] ?? 0;
      allOrders = page.counts['all'] ?? 0;
      final latest = page.orders.isEmpty ? null : page.orders.first;
      final at = DateTime.tryParse(latest?['created_at'] as String? ?? '');
      final seen = _latestSeen;
      if (at != null && (seen == null || at.isAfter(seen))) {
        _latestSeen = at;
        if (seen != null && alert) {
          _alerts.add(latest!);
          ordersVersion.value++;
        }
      }
      _notify();
    } catch (_) {}
  }

  /// A page changed an order (status, note): badge and other pages follow.
  void ordersChanged() {
    ordersVersion.value++;
    refreshOrders();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _stopWatching();
    _alerts.close();
    ordersVersion.dispose();
    if (identical(_instance, this)) _instance = null;
    super.dispose();
  }
}

/// Gives the admin pages the [MerchantSession] (rebuilding on changes).
class MerchantScope extends InheritedNotifier<MerchantSession> {
  const MerchantScope({super.key, required MerchantSession session, required super.child}) : super(notifier: session);

  static MerchantSession of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<MerchantScope>()!.notifier!;

  /// Without listening (callbacks).
  static MerchantSession read(BuildContext context) => context.getInheritedWidgetOfExactType<MerchantScope>()!.notifier!;
}
