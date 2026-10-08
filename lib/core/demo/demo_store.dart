import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'demo_mode.dart';
import 'demo_platform.dart';

part 'demo_tajer.dart';

/// An error the fake backend returns as a PostgREST error (the screens
/// show `PostgrestException.message`, like with the real server).
class DemoError implements Exception {
  DemoError(this.message, [this.status = 400]);
  final String message;
  final int status;

  @override
  String toString() => message;
}

typedef DemoRow = Map<String, dynamic>;

/// The in-memory "database" of the demo build: a few JSON tables seeded
/// with a fictional building, a tiny PostgREST query engine (select with
/// embeds, filters, order, limit; insert/update/delete) and the RPCs the
/// owners'-union screens call — or, for the merchant app (`flavor:
/// 'tajer'`), the demo shop of [DemoTajer]. Everything lives in this
/// browser tab only (sessionStorage, so a role switch keeps what was done
/// in the video).
class DemoStore {
  DemoStore._(this.tables, {required this.role, required this.persist, required this.key, this.flavor = 'ittihad'}) {
    if (isTajer) {
      me = DemoTajer.roleUsers[role]!;
    } else {
      me = roleUsers[role]!;
      _applyRole();
    }
  }

  static DemoStore? _instance;
  static DemoStore get instance => _instance!;

  static const _storageKey = 'mogtama3y-demo-store-v1';
  static const _tajerStorageKey = 'mogtama3y-demo-tajer-v1';
  // Each `?elections=` mode keeps its own saved data in the tab.
  static String _keyFor(String elections) => elections == 'open' ? _storageKey : '$_storageKey-$elections';

  /// [persist] false keeps everything in memory only (tests).
  static DemoStore boot({required String role, String elections = 'open', String flavor = 'ittihad', bool persist = true, DateTime? now}) {
    final tajer = flavor == 'tajer';
    final key = tajer ? _tajerStorageKey : _keyFor(elections);
    Map<String, List<DemoRow>>? saved;
    if (persist) {
      final raw = demoSessionGet(key);
      if (raw != null) {
        try {
          final decoded = jsonDecode(raw) as Map<String, dynamic>;
          saved = {
            for (final e in (decoded['tables'] as Map<String, dynamic>).entries) e.key: [for (final r in e.value as List) Map<String, dynamic>.from(r as Map)],
          };
        } catch (_) {
          saved = null;
        }
      }
    }
    final store = DemoStore._(
      saved ?? (tajer ? DemoTajer.seed(now ?? DateTime.now()) : seedTables(now ?? DateTime.now(), elections: elections)),
      role: role,
      persist: persist,
      key: key,
      flavor: flavor,
    );
    store.save();
    return _instance = store;
  }

  /// The same data seen as another role (what the role switcher does
  /// across a reload, without the reload — used by the tests).
  DemoStore asRole(String role) => _instance = DemoStore._(tables, role: role, persist: persist, key: key, flavor: flavor);

  /// Forget everything done in this tab (the role switcher's «ابدأ من الأول»).
  static void clearSaved() {
    for (final m in demoElectionModes) {
      demoSessionRemove(_keyFor(m));
    }
    demoSessionRemove(_tajerStorageKey);
  }

  final Map<String, List<DemoRow>> tables;
  final String role;
  final bool persist;
  final String key;
  late final String me;

  /// 'ittihad' (owners' union) or 'tajer' (merchant app).
  final String flavor;
  bool get isTajer => flavor == 'tajer';

  /// The merchant app's `customer` role browses and orders signed out.
  bool get guest => isTajer && role == 'customer';

  /// Files "uploaded" in this page session (receipt photos), by path.
  final Map<String, (Uint8List, String)> files = {};

  final _rand = Random();

  List<DemoRow> t(String name) => tables.putIfAbsent(name, () => <DemoRow>[]);

  void save() {
    if (persist) demoSessionSet(key, jsonEncode({'tables': tables}));
  }

  // ------------------------------------------------------------------
  // ids, users, roles
  // ------------------------------------------------------------------

  static String fixedId(String kind, int n) => '${kind}0000000-0000-4000-8000-${n.toString().padLeft(12, '0')}';

  String newId() {
    String hex(int len) => List.generate(len, (_) => _rand.nextInt(16).toRadixString(16)).join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-a${hex(3)}-${hex(12)}';
  }

  String _code(String prefix) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return '$prefix-${List.generate(6, (_) => chars[_rand.nextInt(chars.length)]).join()}';
  }

  static String nowIso() => DateTime.now().toUtc().toIso8601String();

  static final buildingId = fixedId('b', 1);
  static final uPresident = fixedId('a', 1);
  static final uTreasurer = fixedId('a', 2);
  static final uOwner = fixedId('a', 3);
  static final uSara = fixedId('a', 4);
  static final uHisham = fixedId('a', 5);
  static final uTenant = fixedId('a', 6);
  static final uNadia = fixedId('a', 7);
  static final uMohamed = fixedId('a', 8);
  static final uAmr = fixedId('a', 9);
  static final uReham = fixedId('a', 10);
  static final uGuard = fixedId('a', 11);
  static final uPending = fixedId('a', 12);
  static final uNew = fixedId('a', 13);

  static String unitId(int n) => fixedId('c', n);

  static final roleUsers = {'president': uPresident, 'treasurer': uTreasurer, 'owner': uOwner, 'tenant': uTenant, 'guard': uGuard, 'new': uNew};

  DemoRow? profileOf(String? userId) => userId == null ? null : _firstWhere('profiles', (r) => r['id'] == userId);

  String nameOf(String? userId) => profileOf(userId)?['full_name'] as String? ?? 'ساكن';

  /// The «أمين الصندوق» exists while recording as the treasurer; for the
  /// other roles the president manages the fund (the common case), unless
  /// a treasurer was appointed during the session.
  void _applyRole() {
    final treasurers = t('union_treasurers');
    if (role == 'treasurer') {
      if (!treasurers.any((r) => r['building_id'] == buildingId)) {
        treasurers.add({
          'building_id': buildingId,
          'user_id': uTreasurer,
          'source': 'appointed',
          'appointed_by': uPresident,
          'created_at': nowIso(),
          '_auto': true,
        });
      }
    } else {
      treasurers.removeWhere((r) => r['_auto'] == true);
    }
  }

  // ------------------------------------------------------------------
  // seed data — all fictional
  // ------------------------------------------------------------------

  static const _monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

  static String periodLabel(DateTime d) => 'صيانة ${_monthsAr[d.month - 1]} ${d.year}';

  static Map<String, List<DemoRow>> seedTables(DateTime now, {String elections = 'open'}) {
    String ago({int days = 0, int hours = 0, int minutes = 0}) => now.subtract(Duration(days: days, hours: hours, minutes: minutes)).toUtc().toIso8601String();
    String inFuture({int days = 0, int hours = 0}) => now.add(Duration(days: days, hours: hours)).toUtc().toIso8601String();
    String date(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    var seq = 0;
    String id(String kind) => fixedId(kind, ++seq);

    final people = <String, (String, String)>{
      uPresident: ('أحمد عبد الرحمن', '01000000101'),
      uTreasurer: ('منى السيد', '01000000102'),
      uOwner: ('خالد فتحي', '01000000103'),
      uSara: ('سارة محمود', '01000000104'),
      uHisham: ('هشام الشريف', '01000000105'),
      uTenant: ('ياسر حسن', '01000000106'),
      uNadia: ('نادية إبراهيم', '01000000107'),
      uMohamed: ('محمد عادل', '01000000108'),
      uAmr: ('عمرو جمال', '01000000109'),
      uReham: ('ريهام فاروق', '01000000110'),
      uGuard: ('عم سيد عبد الله', '01000000111'),
      uPending: ('إيمان رضا', '01000000112'),
      uNew: ('كريم ناصر', '01000000113'),
    };
    final profiles = [
      for (final e in people.entries)
        {
          'id': e.key,
          'full_name': e.value.$1,
          'phone': e.value.$2,
          'phone_hidden': false,
          'avatar_url': null,
          'is_verified': true,
          'role': 'user',
          'ad_token_balance': 0,
          'created_at': ago(days: 120),
          'updated_at': ago(days: 3),
          'phone_verified_at': ago(days: 100),
        },
    ];

    const floors = [
      'الدور الأول',
      'الدور الأول',
      'الدور الأول',
      'الدور الثاني',
      'الدور الثاني',
      'الدور الثاني',
      'الدور الثالث',
      'الدور الثالث',
      'الدور الثالث',
      'الدور الرابع',
      'الدور الرابع',
      'الدور الرابع',
    ];
    final units = [
      for (var n = 1; n <= 12; n++)
        {'id': unitId(n), 'building_id': buildingId, 'unit_number': '$n', 'floor_label': floors[n - 1], 'created_at': ago(days: 90)},
    ];

    final buildings = [
      {
        'id': buildingId,
        'name': 'عمارة النخيل — تجريبي',
        'district': 'حي النخيل',
        'city': 'القاهرة',
        'governorate': 'القاهرة',
        'lat': null,
        'lng': null,
        'invite_code': 'BLD-7K3Q9P',
        'created_at': ago(days: 90),
      },
    ];

    // (user, unit, role, residency, family-name-only)
    final memberSpecs = <(String, int?, String, String, bool)>[
      (uPresident, 1, 'president', 'owner', false),
      (uTreasurer, 2, 'member', 'owner', false),
      (uOwner, 3, 'member', 'owner', false),
      (uSara, 4, 'member', 'owner', false),
      (uHisham, 5, 'board_member', 'owner', false),
      (uTenant, 6, 'member', 'tenant', false),
      (uNadia, 7, 'member', 'owner', true),
      (uMohamed, 8, 'member', 'owner', false),
      (uAmr, 9, 'member', 'owner', false),
      (uReham, 10, 'member', 'owner', false),
      (uGuard, null, 'member', 'tenant', false),
    ];
    final members = <DemoRow>[
      for (final (i, s) in memberSpecs.indexed)
        {
          'id': fixedId('d', i + 1),
          'building_id': buildingId,
          'unit_id': s.$2 == null ? null : unitId(s.$2!),
          'user_id': s.$1,
          'role': s.$3,
          'status': 'verified',
          'residency_type': s.$4,
          'show_family_name_only': s.$5,
          'verified_by': uPresident,
          'created_at': ago(days: 80 - i),
        },
      {
        'id': fixedId('d', 50),
        'building_id': buildingId,
        'unit_id': unitId(11),
        'user_id': uPending,
        'role': 'member',
        'status': 'pending',
        'residency_type': 'owner',
        'show_family_name_only': false,
        'verified_by': null,
        'created_at': ago(hours: 5),
      },
    ];

    final residents = <DemoRow>[
      for (final s in memberSpecs)
        if (s.$2 != null && s.$4 == 'owner')
          {'id': id('f'), 'unit_id': unitId(s.$2!), 'user_id': s.$1, 'residency_type': 'owner', 'is_primary': true, 'created_at': ago(days: 80)},
      // خالد also owns flat 6 and rents it to ياسر.
      {'id': id('f'), 'unit_id': unitId(6), 'user_id': uOwner, 'residency_type': 'owner', 'is_primary': true, 'created_at': ago(days: 80)},
      {'id': id('f'), 'unit_id': unitId(6), 'user_id': uTenant, 'residency_type': 'tenant', 'is_primary': false, 'created_at': ago(days: 40)},
    ];

    // ---- dues: previous period (all paid but flat 8) + current period with every status ----
    final prevMonth = DateTime(now.year, now.month - 1, 1);
    final prevLabel = periodLabel(prevMonth);
    final curLabel = periodLabel(now);
    final dues = <DemoRow>[];
    final ledger = <DemoRow>[];
    final payerOf = {
      for (final s in memberSpecs)
        if (s.$2 != null) s.$2!: s.$1,
    };
    void addDue(int unit, String label, String createdAt, DateTime dueDate, {String? paidVia, String? paidAt}) {
      final dueId = id('e');
      dues.add({
        'id': dueId,
        'building_id': buildingId,
        'unit_id': unitId(unit),
        'period_label': label,
        'amount': 350,
        'due_date': date(dueDate),
        'is_paid': paidVia != null,
        'paid_at': paidAt,
        'paid_via': paidVia,
        'paid_by': paidVia == null ? null : (paidVia == 'cash' ? uPresident : payerOf[unit]),
        'created_at': createdAt,
      });
      if (paidVia != null) {
        ledger.add({
          'id': id('9'),
          'building_id': buildingId,
          'type': paidVia == 'cash' ? 'cash_due' : 'due_payment',
          'amount': 350,
          'due_id': dueId,
          'unit_id': unitId(unit),
          'note': 'سداد «$label»',
          'receipt_path': null,
          'created_by': paidVia == 'cash' ? uPresident : payerOf[unit],
          'created_at': paidAt,
        });
      }
    }

    for (var u = 1; u <= 11; u++) {
      final created = ago(days: 36, minutes: u);
      if (u == 8) {
        addDue(u, prevLabel, created, now.subtract(const Duration(days: 26)));
      } else {
        addDue(
          u,
          prevLabel,
          created,
          now.subtract(const Duration(days: 26)),
          paidVia: u == 7 || u == 11 ? 'cash' : 'wallet',
          paidAt: ago(days: 30 - u),
        );
      }
    }
    final curCreated = ago(days: 6);
    final soon = now.add(const Duration(days: 8));
    final passed = now.subtract(const Duration(days: 2));
    addDue(1, curLabel, curCreated, soon, paidVia: 'wallet', paidAt: ago(days: 5));
    addDue(2, curLabel, curCreated, soon, paidVia: 'wallet', paidAt: ago(days: 4, hours: 3));
    addDue(3, curLabel, curCreated, soon); // خالد — لسه (the owner pays it in the video)
    addDue(4, curLabel, curCreated, soon, paidVia: 'cash', paidAt: ago(days: 3));
    addDue(5, curLabel, curCreated, soon, paidVia: 'wallet', paidAt: ago(days: 2, hours: 6));
    addDue(6, curLabel, curCreated, soon); // ياسر (tenant) — لسه
    addDue(7, curLabel, curCreated, soon, paidVia: 'cash', paidAt: ago(days: 1, hours: 2));
    addDue(8, curLabel, curCreated, passed); // متأخر
    addDue(9, curLabel, curCreated, soon); // لسه
    addDue(10, curLabel, curCreated, passed); // متأخر
    addDue(11, curLabel, curCreated, soon); // لسه (no verified resident yet)
    // flat 12 is empty → «مفيش مستحق»

    ledger.addAll([
      {
        'id': id('9'),
        'building_id': buildingId,
        'type': 'adjustment',
        'amount': 6500,
        'due_id': null,
        'unit_id': null,
        'note': 'رصيد افتتاحي منقول من دفتر الاتحاد القديم',
        'receipt_path': null,
        'created_by': uPresident,
        'created_at': ago(days: 60),
      },
      {
        'id': id('9'),
        'building_id': buildingId,
        'type': 'expense',
        'amount': -600,
        'due_id': null,
        'unit_id': null,
        'note': 'اشتراك شركة النظافة — ${_monthsAr[prevMonth.month - 1]}',
        'receipt_path': null,
        'created_by': uPresident,
        'created_at': ago(days: 28),
      },
      {
        'id': id('9'),
        'building_id': buildingId,
        'type': 'expense',
        'amount': -450,
        'due_id': null,
        'unit_id': null,
        'note': 'تغيير لمبات السلم والمدخل',
        'receipt_path': 'demo/receipt-lamps.svg',
        'created_by': uPresident,
        'created_at': ago(days: 3, hours: 5),
      },
      {
        'id': id('9'),
        'building_id': buildingId,
        'type': 'expense',
        'amount': -1200,
        'due_id': null,
        'unit_id': null,
        'note': 'صيانة موتور رفع المياه',
        'receipt_path': 'demo/receipt-pump.svg',
        'created_by': uPresident,
        'created_at': ago(hours: 20),
      },
    ]);
    final balance = ledger.fold<num>(0, (s, r) => s + (r['amount'] as num));

    final wallets = [
      for (final (i, u) in [uPresident, uTreasurer, uOwner, uSara, uHisham, uTenant, uNadia, uMohamed, uAmr, uReham, uGuard, uPending, uNew].indexed)
        {
          'id': fixedId('7', i + 1),
          'user_id': u,
          'available_balance': u == uOwner ? 1250 : (u == uTenant ? 900 : 2000),
          'held_balance': 0,
          'created_at': ago(days: 100),
        },
    ];
    final walletTx = [
      for (final w in wallets) {'id': id('8'), 'wallet_id': w['id'], 'type': 'top_up', 'amount': 1500, 'status': 'completed', 'created_at': ago(days: 40)},
    ];

    final electionId = id('5');
    final cPresident = id('5');
    final cHisham = id('5');

    final pollOpen = id('6');
    final pollClosed = id('6');

    final postOfficial = id('4');
    final postThanks = id('4');
    final postElevator = id('4');
    final postPlumber = id('4');

    final decisionOpen = id('3');
    final decisionDone = id('3');

    final reportId = id('2');

    return {
      'profiles': profiles,
      'buildings': buildings,
      'units': units,
      'union_members': members,
      'unit_residents': residents,
      'union_dues': dues,
      'union_fund_transactions': ledger,
      'union_funds': [
        {'building_id': buildingId, 'balance': balance, 'updated_at': ago(days: 1)},
      ],
      'union_fund_withdrawal_requests': [
        {
          'id': id('1'),
          'building_id': buildingId,
          'requested_by': uPresident,
          'amount_egp': 350,
          'destination': 'wallet',
          'payout_phone': null,
          'note': 'أجرة الكهربائي — كشاف الجراج',
          'status': 'pending',
          'created_at': ago(days: 1, hours: 4),
        },
      ],
      'union_treasurers': <DemoRow>[],
      'union_tenant_invites': [
        {
          'id': id('1'),
          'unit_id': unitId(9),
          'code': 'TEN-4M8X2D',
          'created_by': uAmr,
          'used_by': null,
          'expires_at': inFuture(days: 6),
          'created_at': ago(days: 1),
        },
      ],
      'wallets': wallets,
      'wallet_transactions': walletTx,
      'ad_token_settings': [
        {'id': 1, 'topup_phone': '01000000999'},
      ],
      'union_elections': [
        if (elections != 'none')
          {
            'id': electionId,
            'building_id': buildingId,
            'position': 'president',
            'title': 'انتخاب رئيس اتحاد الملاك — الدورة الجديدة',
            'closes_at': elections == 'ending' ? ago(hours: 1) : inFuture(days: 3),
            'is_finalized': false,
            'eligible_voters': 10,
            'legal_quorum_pct': 50,
            'created_by': uPresident,
            'created_at': ago(days: elections == 'ending' ? 7 : 1),
          },
      ],
      'union_candidates': [
        if (elections != 'none') ...[
          {
            'id': cPresident,
            'election_id': electionId,
            'user_id': uPresident,
            'vote_count': elections == 'ending' ? 4 : 3,
            'created_at': ago(days: 1),
            'pledge': 'نكمّل اللي بدأناه: صيانة الأسانسير كل شهر، ودفتر صندوق مفتوح لكل السكان، وكاميرات على المدخل.',
          },
          {
            'id': cHisham,
            'election_id': electionId,
            'user_id': uHisham,
            'vote_count': 2,
            'created_at': ago(hours: 20),
            'pledge': 'دهان واجهة العمارة، وعقد صيانة سنوي للمواتير بسعر أقل، واجتماع شهري للسكان.',
          },
        ],
      ],
      'union_votes': [
        if (elections != 'none')
          for (final (v, c) in [
            (uSara, cPresident),
            (uNadia, cPresident),
            (uAmr, cPresident),
            if (elections == 'ending') (uOwner, cPresident),
            (uMohamed, cHisham),
            (uReham, cHisham),
          ])
            {'id': id('1'), 'election_id': electionId, 'voter_id': v, 'candidate_id': c, 'created_at': ago(hours: 10)},
      ],
      'union_polls': [
        {
          'id': pollOpen,
          'building_id': buildingId,
          'created_by': uPresident,
          'created_at': ago(days: 1, hours: 2),
          'ends_at': inFuture(days: 4),
          'closed_at': null,
          'question': 'نركّب كاميرات مراقبة على المدخل والجراج؟ (التكلفة حوالي 9,000 ج.م من الصندوق)',
          'options': ['موافق', 'مش موافق', 'محتاج عروض أسعار الأول'],
        },
        {
          'id': pollClosed,
          'building_id': buildingId,
          'created_by': uHisham,
          'created_at': ago(days: 15),
          'ends_at': ago(days: 10),
          'closed_at': ago(days: 10),
          'question': 'أنسب ميعاد لتنظيف خزانات المياه؟',
          'options': ['السبت الصبح', 'الجمعة بعد الصلاة'],
        },
      ],
      'union_poll_votes': [
        for (final (u, voter, o) in [(4, uSara, 0), (5, uHisham, 0), (7, uNadia, 2), (8, uMohamed, 1)])
          {'id': id('1'), 'poll_id': pollOpen, 'unit_id': unitId(u), 'voter_id': voter, 'option_index': o, 'created_at': ago(hours: 20 - u)},
        for (final (u, voter, o) in [(1, uPresident, 0), (2, uTreasurer, 0), (3, uOwner, 1), (4, uSara, 0), (9, uAmr, 0), (10, uReham, 1)])
          {'id': id('1'), 'poll_id': pollClosed, 'unit_id': unitId(u), 'voter_id': voter, 'option_index': o, 'created_at': ago(days: 12)},
      ],
      'posts': [
        {
          'id': postOfficial,
          'building_id': buildingId,
          'author_id': uPresident,
          'type': 'official',
          'is_pinned': true,
          'images': <String>[],
          'created_at': ago(hours: 7),
          'body': 'هيتم قطع المياه يوم السبت الجاي من 10 الصبح لحد 2 الضهر لتنظيف وتعقيم الخزانات. برجاء تخزين مياه كفاية. شكراً لتعاونكم 🙏',
        },
        {
          'id': postElevator,
          'building_id': buildingId,
          'author_id': uMohamed,
          'type': 'complaint',
          'is_pinned': false,
          'images': <String>[],
          'created_at': ago(hours: 3),
          'body': 'الأسانسير بيقف بين الدور التالت والرابع ساعات، ياريت نستعجل الصيانة الدورية.',
        },
        {
          'id': postThanks,
          'building_id': buildingId,
          'author_id': uSara,
          'type': 'resident',
          'is_pinned': false,
          'images': <String>[],
          'created_at': ago(days: 1, hours: 1),
          'body': 'شكراً لعم سيد على مجهوده في تنظيف السلم والمدخل الأسبوع ده 👏',
        },
        {
          'id': postPlumber,
          'building_id': buildingId,
          'author_id': uNadia,
          'type': 'resident',
          'is_pinned': false,
          'images': <String>[],
          'created_at': ago(days: 2),
          'body': 'حد يعرف سبّاك شاطر وأمين قريب من العمارة؟',
        },
      ],
      'post_comments': [
        {
          'id': id('1'),
          'post_id': postElevator,
          'author_id': uPresident,
          'body': 'كلّمت شركة الصيانة، جايين يوم الإتنين إن شاء الله.',
          'created_at': ago(hours: 2),
        },
        {'id': id('1'), 'post_id': postThanks, 'author_id': uHisham, 'body': 'فعلاً يستاهل كل خير 🌹', 'created_at': ago(hours: 23)},
        {'id': id('1'), 'post_id': postPlumber, 'author_id': uAmr, 'body': 'عندي رقم واحد كويس، هبعتهولك على الدردشة.', 'created_at': ago(days: 1, hours: 20)},
      ],
      'post_reactions': [
        for (final (p, u) in [
          (postOfficial, uSara),
          (postOfficial, uHisham),
          (postOfficial, uAmr),
          (postOfficial, uReham),
          (postThanks, uPresident),
          (postThanks, uNadia),
          (postElevator, uReham),
        ])
          {'id': id('1'), 'post_id': p, 'user_id': u, 'created_at': ago(hours: 1)},
      ],
      'building_chat_messages': [
        for (final (i, (u, body)) in [
          (uSara, 'صباح الخير يا جيران ☀️'),
          (uHisham, 'صباح النور، حد عارف المية هتتقطع إمتى بالظبط؟'),
          (uPresident, 'السبت من 10 لـ 2 الضهر، نزّلت إعلان رسمي بالتفاصيل.'),
          (uNadia, 'تمام شكراً يا أستاذ أحمد 🙏'),
          (uMohamed, 'الأسانسير وقف تاني النهارده الصبح'),
          (uPresident, 'شركة الصيانة جاية الإتنين، ولو اتكرر كلموا عم سيد على طول.'),
          (uGuard, 'موجود تحت يا جماعة، أي حاجة رنّوا عليّا.'),
          (uReham, 'فيه طرد جه باسمي عند الأمن؟'),
          (uGuard, 'أيوه يا مدام ريهام، مستنيكي تحت.'),
        ].indexed)
          {'id': id('1'), 'building_id': buildingId, 'sender_id': u, 'body': body, 'created_at': ago(hours: 6 - (i ~/ 2), minutes: 50 - i * 5)},
      ],
      'building_guards': [
        {'id': id('1'), 'building_id': buildingId, 'user_id': uGuard, 'is_active': true, 'appointed_by': uPresident, 'created_at': ago(days: 70)},
      ],
      'visitor_passes': [
        {
          'id': id('1'),
          'unit_id': unitId(4),
          'issued_by': uSara,
          'visitor_name': 'مندوب توصيل — طلبات',
          'pass_type': 'delivery',
          'qr_code': 'PASS-7Q4K2M',
          'valid_from': ago(minutes: 20),
          'valid_until': inFuture(hours: 3),
          'status': 'active',
          'created_at': ago(minutes: 20),
        },
        {
          'id': id('1'),
          'unit_id': unitId(8),
          'issued_by': uMohamed,
          'visitor_name': 'فني تكييف — شركة البرودة',
          'pass_type': 'maintenance',
          'qr_code': 'PASS-3H8W5T',
          'valid_from': ago(hours: 2),
          'valid_until': inFuture(hours: 2),
          'status': 'used',
          'created_at': ago(hours: 2),
        },
        {
          'id': id('1'),
          'unit_id': unitId(1),
          'issued_by': uPresident,
          'visitor_name': 'مندوب صيدلية',
          'pass_type': 'delivery',
          'qr_code': 'PASS-9R2V6N',
          'valid_from': ago(hours: 4),
          'valid_until': ago(hours: 1),
          'status': 'used',
          'created_at': ago(hours: 4),
        },
        {
          'id': id('1'),
          'unit_id': unitId(5),
          'issued_by': uHisham,
          'visitor_name': 'ضيوف عائلة الشريف',
          'pass_type': 'guest',
          'qr_code': 'PASS-5L7P3C',
          'valid_from': ago(days: 2),
          'valid_until': ago(days: 1),
          'status': 'expired',
          'created_at': ago(days: 2),
        },
      ],
      'lost_found_items': [
        {
          'id': id('1'),
          'building_id': buildingId,
          'reporter_id': uGuard,
          'type': 'found',
          'category': 'مفاتيح',
          'title': 'مفتاح عربية بميدالية زرقا',
          'description': null,
          'image_url': null,
          'location_note': 'اتلقى جنب الأسانسير — مع الأمن',
          'is_resolved': false,
          'reward_amount': null,
          'created_at': ago(hours: 9),
          'has_secret_mark': true,
          '_secret': 'ميدالية نادي',
        },
        {
          'id': id('1'),
          'building_id': buildingId,
          'reporter_id': uNadia,
          'type': 'lost',
          'category': 'محافظ وبطاقات',
          'title': 'محفظة جلد بني',
          'description': null,
          'image_url': null,
          'location_note': 'غالباً في الجراج',
          'is_resolved': false,
          'reward_amount': 200,
          'created_at': ago(days: 1, hours: 3),
          'has_secret_mark': false,
        },
      ],
      'union_maintenance_schedule': [
        {
          'id': id('1'),
          'building_id': buildingId,
          'title': 'صيانة دورية للأسانسير',
          'vendor': 'شركة الصعود للمصاعد (تجريبي)',
          'scheduled_for': inFuture(days: 3),
          'is_urgent': true,
          'created_by': uPresident,
          'created_at': ago(days: 2),
        },
        {
          'id': id('1'),
          'building_id': buildingId,
          'title': 'رش مبيدات للمدخل والسلم',
          'vendor': 'شركة النظافة (تجريبي)',
          'scheduled_for': inFuture(days: 10),
          'is_urgent': false,
          'created_by': uPresident,
          'created_at': ago(days: 2),
        },
      ],
      'board_decisions': [
        {
          'id': decisionOpen,
          'building_id': buildingId,
          'title': 'التعاقد مع شركة نظافة جديدة بـ 1,800 ج.م شهرياً',
          'description': 'العرض بيشمل تنظيف السلم يومياً والمدخل والجراج مرتين في الأسبوع.',
          'requires_unanimous': false,
          'status': 'open',
          'eligible_voters': 2,
          'proposed_by': uPresident,
          'created_at': ago(days: 1),
        },
        {
          'id': decisionDone,
          'building_id': buildingId,
          'title': 'دهان مدخل العمارة قبل الشتا',
          'description': null,
          'requires_unanimous': true,
          'status': 'approved',
          'eligible_voters': 2,
          'proposed_by': uHisham,
          'created_at': ago(days: 20),
        },
      ],
      'board_decision_votes': [
        {'id': id('1'), 'decision_id': decisionOpen, 'voter_id': uPresident, 'choice': 'approve', 'created_at': ago(days: 1)},
        {'id': id('1'), 'decision_id': decisionDone, 'voter_id': uPresident, 'choice': 'approve', 'created_at': ago(days: 19)},
        {'id': id('1'), 'decision_id': decisionDone, 'voter_id': uHisham, 'choice': 'approve', 'created_at': ago(days: 19)},
      ],
      'union_financial_reports': [
        {
          'id': reportId,
          'building_id': buildingId,
          'period_label': 'تقرير الربع الثالث ${now.year}',
          'total_collected': 10150,
          'total_expected': 11550,
          'emergency_fund': 2000,
          'actual_expenses': 4250,
          'published_at': ago(days: 7),
          'approved_by': uHisham,
          'audited_by': 'مراجعة داخلية (تجريبي)',
          'pdf_url': null,
          'status': 'published',
          'created_at': ago(days: 7),
        },
      ],
      'union_expense_items': [
        {
          'id': id('1'),
          'report_id': reportId,
          'label': 'صيانة الأسانسير',
          'vendor': 'شركة الصعود للمصاعد (تجريبي)',
          'amount': 1800,
          'invoice_ref': 'INV-DEMO-101',
        },
        {'id': id('1'), 'report_id': reportId, 'label': 'النظافة', 'vendor': 'شركة النظافة (تجريبي)', 'amount': 1800, 'invoice_ref': 'INV-DEMO-102'},
        {'id': id('1'), 'report_id': reportId, 'label': 'كهرباء السلم', 'vendor': null, 'amount': 650, 'invoice_ref': null},
      ],
      'notifications': [
        for (final u in [uPresident, uTreasurer, uOwner, uSara, uHisham, uTenant, uNadia, uMohamed, uAmr, uReham, uGuard]) ...[
          {
            'id': id('1'),
            'user_id': u,
            'title': '📢 إعلان رسمي من الاتحاد',
            'body': 'قطع المياه يوم السبت من 10 الصبح لحد 2 الضهر لتنظيف الخزانات.',
            'deep_link': '/#/feed',
            'is_read': false,
            'created_at': ago(hours: 7),
          },
          {
            'id': id('1'),
            'user_id': u,
            'title': '🗳️ تصويت جديد للسكان',
            'body': 'نركّب كاميرات مراقبة على المدخل والجراج؟ صوت واحد لكل شقة.',
            'deep_link': '/#/polls',
            'is_read': false,
            'created_at': ago(days: 1, hours: 2),
          },
          {
            'id': id('1'),
            'user_id': u,
            'title': '🔧 صيانة مجدولة',
            'body': 'صيانة دورية للأسانسير بعد 3 أيام.',
            'deep_link': '/#/union',
            'is_read': true,
            'created_at': ago(days: 2),
          },
        ],
        for (final u in [uOwner, uTenant, uAmr])
          {
            'id': id('1'),
            'user_id': u,
            'title': '⏰ تذكير بمستحقات الصيانة',
            'body': 'عليك 350 ج.م مستحقات «$curLabel» لسه ما اتدفعتش. ادفع من التطبيق في ثانية.',
            'deep_link': '/#/union-pay',
            'is_read': false,
            'created_at': ago(hours: 20),
          },
        {
          'id': id('1'),
          'user_id': uPresident,
          'title': '🙋 طلب انضمام جديد',
          'body': 'إيمان رضا طلبت تنضم للعمارة (شقة 11).',
          'deep_link': '/#/union-approvals',
          'is_read': false,
          'created_at': ago(hours: 5),
        },
        {
          'id': id('1'),
          'user_id': uNew,
          'title': '👋 أهلاً بيك في اتحاد الملاك',
          'body': 'انضم لعمارتك بكود الدعوة من رئيس الاتحاد.',
          'deep_link': '/#/union',
          'is_read': false,
          'created_at': ago(minutes: 30),
        },
      ],
      'sos_alerts': <DemoRow>[],
    };
  }

  // ------------------------------------------------------------------
  // PostgREST-style table access
  // ------------------------------------------------------------------

  DemoRow? _firstWhere(String table, bool Function(DemoRow r) test) {
    for (final r in t(table)) {
      if (test(r)) return r;
    }
    return null;
  }

  /// GET /rest/v1/<table>?select=…&col=op.value&order=…&limit=…
  List<DemoRow> select(String table, Map<String, String> query) {
    var rows = t(table).where((r) => _visible(table, r) && _matches(r, query)).toList();
    final order = query['order'];
    if (order != null) rows = _sorted(rows, order);
    final offset = int.tryParse(query['offset'] ?? '') ?? 0;
    if (offset > 0) rows = rows.skip(offset).toList();
    final limit = int.tryParse(query['limit'] ?? '');
    if (limit != null) rows = rows.take(limit).toList();
    final sel = parseSelect(query['select'] ?? '*');
    return [for (final r in rows) _project(table, r, sel)];
  }

  List<DemoRow> insert(String table, Object body, {String? select}) {
    final items = body is List ? body : [body];
    final inserted = <DemoRow>[];
    for (final item in items) {
      final row = <String, dynamic>{'id': newId(), 'created_at': nowIso(), ...Map<String, dynamic>.from(item as Map)};
      _beforeInsert(table, row);
      t(table).add(row);
      inserted.add(row);
    }
    save();
    final sel = parseSelect(select ?? '*');
    return [for (final r in inserted) _project(table, r, sel)];
  }

  List<DemoRow> update(String table, Map<String, String> query, Map<String, dynamic> values, {String? select}) {
    final rows = t(table).where((r) => _matches(r, query)).toList();
    for (final r in rows) {
      r.addAll(values);
    }
    save();
    final sel = parseSelect(select ?? '*');
    return [for (final r in rows) _project(table, r, sel)];
  }

  List<DemoRow> delete(String table, Map<String, String> query) {
    final rows = t(table).where((r) => _matches(r, query)).toList();
    // Like the real foreign key: a product with orders can only be hidden.
    if (table == 'shop_products' && rows.any((r) => t('shop_order_items').any((i) => i['product_id'] == r['id']))) {
      throw DemoError('تعذر الحذف — المنتج ده عليه طلبات، اخفيه بدل الحذف', 409);
    }
    t(table).removeWhere(rows.contains);
    save();
    return rows;
  }

  /// Row-level security the screens rely on (owner-only tables).
  bool _visible(String table, DemoRow r) => switch (table) {
    'e_addresses' => !guest && r['owner_id'] == me,
    _ => true,
  };

  void _beforeInsert(String table, DemoRow row) {
    switch (table) {
      case 'shop_products':
        row['is_available'] ??= true;
        row['options'] ??= <Object>[];
        row['highlights'] ??= <String>[];
        row['images'] ??= <String>[];
      case 'visitor_passes':
        row['qr_code'] = _code('PASS');
        row['status'] = 'active';
        row['valid_from'] = nowIso();
        final until = DateTime.tryParse(row['valid_until'] as String? ?? '');
        final cap = DateTime.now().toUtc().add(const Duration(hours: 24));
        if (until == null || until.isAfter(cap)) row['valid_until'] = cap.toIso8601String();
      case 'posts':
        row['type'] ??= 'resident';
        row['is_pinned'] ??= false;
        row['images'] ??= <String>[];
      case 'union_maintenance_schedule':
        row['is_urgent'] ??= false;
    }
  }

  static const _reserved = {'select', 'order', 'limit', 'offset', 'on_conflict', 'columns'};

  bool _matches(DemoRow r, Map<String, String> query) {
    for (final e in query.entries) {
      if (_reserved.contains(e.key)) continue;
      if (!_test(r[e.key], e.value)) return false;
    }
    return true;
  }

  bool _test(dynamic value, String filter) {
    if (filter.startsWith('not.')) return !_test(value, filter.substring(4));
    final dot = filter.indexOf('.');
    if (dot < 0) return true;
    final op = filter.substring(0, dot);
    final arg = filter.substring(dot + 1);
    switch (op) {
      case 'eq':
        return _cmp(value, arg) == 0;
      case 'neq':
        return _cmp(value, arg) != 0;
      case 'gt':
        return (_cmp(value, arg) ?? -1) > 0;
      case 'gte':
        return (_cmp(value, arg) ?? -1) >= 0;
      case 'lt':
        return (_cmp(value, arg) ?? 1) < 0;
      case 'lte':
        return (_cmp(value, arg) ?? 1) <= 0;
      case 'is':
        if (arg == 'null') return value == null;
        if (arg == 'true') return value == true;
        if (arg == 'false') return value == false;
        return false;
      case 'in':
        final inner = arg.startsWith('(') && arg.endsWith(')') ? arg.substring(1, arg.length - 1) : arg;
        final values = inner.split(',').map((v) => v.trim().replaceAll('"', ''));
        return values.any((v) => _cmp(value, v) == 0);
      case 'like':
      case 'ilike':
        if (value == null) return false;
        final pattern = RegExp('^${arg.split(RegExp(r'[%*]')).map(RegExp.escape).join('.*')}\$', caseSensitive: op == 'like');
        return pattern.hasMatch(value.toString());
    }
    return true;
  }

  int? _cmp(dynamic a, String b) {
    if (a == null) return null;
    if (a is num) {
      final n = num.tryParse(b);
      return n == null ? null : a.compareTo(n);
    }
    if (a is bool) return a.toString() == b ? 0 : 1;
    final aDate = a is String && a.length >= 19 ? DateTime.tryParse(a) : null;
    final bDate = aDate == null ? null : DateTime.tryParse(b);
    if (aDate != null && bDate != null) return aDate.compareTo(bDate);
    return a.toString().compareTo(b);
  }

  List<DemoRow> _sorted(List<DemoRow> rows, String order) {
    final keys = [
      for (final part in order.split(','))
        if (part.trim().isNotEmpty) part.trim().split('.'),
    ];
    final sorted = [...rows];
    sorted.sort((x, y) {
      for (final k in keys) {
        final desc = k.contains('desc');
        final nullsFirst = k.contains('nullsfirst');
        final a = x[k.first], b = y[k.first];
        int c;
        if (a == null && b == null) {
          c = 0;
        } else if (a == null) {
          return nullsFirst ? -1 : 1;
        } else if (b == null) {
          return nullsFirst ? 1 : -1;
        } else if (a is num && b is num) {
          c = a.compareTo(b);
        } else if (a is bool && b is bool) {
          c = (a ? 1 : 0).compareTo(b ? 1 : 0);
        } else {
          c = a.toString().compareTo(b.toString());
        }
        if (c != 0) return desc ? -c : c;
      }
      return 0;
    });
    return sorted;
  }

  // ---- select parsing & embeds ----

  static List<SelectItem> parseSelect(String s) {
    final parts = <String>[];
    var depth = 0;
    final buf = StringBuffer();
    for (final ch in s.split('')) {
      if (ch == '(') depth++;
      if (ch == ')') depth--;
      if (ch == ',' && depth == 0) {
        parts.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    parts.add(buf.toString());
    final items = <SelectItem>[];
    for (final raw in parts) {
      final p = raw.trim();
      if (p.isEmpty) continue;
      final open = p.indexOf('(');
      var head = open < 0 ? p : p.substring(0, open);
      String? alias;
      final colon = head.indexOf(':');
      if (colon >= 0 && (colon + 1 >= head.length || head[colon + 1] != ':')) {
        alias = head.substring(0, colon).trim();
        head = head.substring(colon + 1).trim();
      }
      String? hint;
      final bang = head.indexOf('!');
      if (bang >= 0) {
        hint = head.substring(bang + 1).trim();
        head = head.substring(0, bang).trim();
      }
      final children = open < 0 ? null : parseSelect(p.substring(open + 1, p.lastIndexOf(')')));
      items.add(SelectItem(name: head.split('::').first.trim(), alias: alias, hint: hint, children: children));
    }
    return items;
  }

  /// to-many embeds: parent table → child table → child's FK column.
  static const _toMany = {
    'board_decisions': {'board_decision_votes': 'decision_id'},
    'union_financial_reports': {'union_expense_items': 'report_id'},
    'shop_orders': {'shop_order_items': 'order_id'},
  };

  /// to-one embeds whose FK column isn't `<table minus s>_id`.
  static const _toOneFk = {
    'shop_order_items': {'shop_products': 'product_id'},
  };

  /// The FK column to `profiles` when the select names no `!hint`.
  static const _profileFk = {
    'union_members': 'user_id',
    'unit_residents': 'user_id',
    'union_candidates': 'user_id',
    'union_treasurers': 'user_id',
    'building_guards': 'user_id',
    'board_decisions': 'proposed_by',
    'board_decision_votes': 'voter_id',
    'union_financial_reports': 'approved_by',
    'building_chat_messages': 'sender_id',
    'post_comments': 'author_id',
    'posts': 'author_id',
    'union_fund_transactions': 'created_by',
    'wallet_topup_requests': 'user_id',
    'wallet_withdrawal_requests': 'user_id',
  };

  DemoRow _project(String table, DemoRow row, List<SelectItem> sel) {
    final out = <String, dynamic>{};
    final star = sel.any((s) => s.name == '*' && !s.isEmbed);
    if (star) {
      for (final e in row.entries) {
        if (!e.key.startsWith('_')) out[e.key] = e.value;
      }
    }
    for (final s in sel) {
      if (s.name == '*') continue;
      if (!s.isEmbed) {
        out[s.alias ?? s.name] = row[s.name];
        continue;
      }
      final key = s.alias ?? s.name;
      final childFk = _toMany[table]?[s.name];
      if (childFk != null) {
        out[key] = [
          for (final c in t(s.name))
            if (c[childFk] == row['id']) _project(s.name, c, s.children!),
        ];
        continue;
      }
      String? fk;
      final hint = s.hint;
      if (hint != null && hint.startsWith('${table}_') && hint.endsWith('_fkey')) {
        fk = hint.substring(table.length + 1, hint.length - 5);
      } else if (_toOneFk[table]?[s.name] != null) {
        fk = _toOneFk[table]![s.name];
      } else if (s.name == 'profiles') {
        fk = _profileFk[table] ?? 'user_id';
      } else {
        fk = '${s.name.endsWith('s') ? s.name.substring(0, s.name.length - 1) : s.name}_id';
      }
      final target = _firstWhere(s.name, (r) => r['id'] == row[fk]);
      out[key] = target == null ? null : _project(s.name, target, s.children!);
    }
    return out;
  }

  // ------------------------------------------------------------------
  // helpers for the RPCs
  // ------------------------------------------------------------------

  DemoRow? membershipOf(String userId, {String? building, bool verifiedOnly = true}) {
    final rows =
        t('union_members')
            .where((m) => m['user_id'] == userId && (building == null || m['building_id'] == building) && (!verifiedOnly || m['status'] == 'verified'))
            .toList()
          ..sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    return rows.isEmpty ? null : rows.first;
  }

  DemoRow? get myMembership => membershipOf(me);

  void _requireSignedIn() {
    if (profileOf(me) == null) throw DemoError('يجب تسجيل الدخول أولاً', 401);
  }

  bool _isVerifiedMember(String building) => membershipOf(me, building: building) != null;

  bool _isBoard(String building) {
    final m = membershipOf(me, building: building);
    return m != null && const ['president', 'board_member'].contains(m['role']);
  }

  bool _isPresident(String building) => membershipOf(me, building: building)?['role'] == 'president';

  String? treasurerOf(String building) {
    final tr = _firstWhere('union_treasurers', (r) => r['building_id'] == building);
    if (tr == null) return null;
    return membershipOf(tr['user_id'] as String, building: building) == null ? null : tr['user_id'] as String;
  }

  String? presidentOf(String building) =>
      _firstWhere('union_members', (m) => m['building_id'] == building && m['status'] == 'verified' && m['role'] == 'president')?['user_id'] as String?;

  String? fundManagerOf(String building) => treasurerOf(building) ?? presidentOf(building);

  bool _isManager(String building) => fundManagerOf(building) == me;

  bool _canViewFund(String building) => _isManager(building) || _isBoard(building);

  DemoRow _building(String? id) => _firstWhere('buildings', (b) => b['id'] == id) ?? (throw DemoError('العمارة مش موجودة'));

  DemoRow _unit(String? id) => _firstWhere('units', (u) => u['id'] == id) ?? (throw DemoError('الشقة مش موجودة'));

  DemoRow _fund(String building) {
    final f = _firstWhere('union_funds', (r) => r['building_id'] == building);
    if (f != null) return f;
    final created = <String, dynamic>{'building_id': building, 'balance': 0, 'updated_at': nowIso()};
    t('union_funds').add(created);
    return created;
  }

  void _ledger(String building, String type, num amount, {String? dueId, String? unitId, String? note, String? receipt}) {
    t('union_fund_transactions').add({
      'id': newId(),
      'building_id': building,
      'type': type,
      'amount': amount,
      'due_id': dueId,
      'unit_id': unitId,
      'note': note,
      'receipt_path': receipt,
      'created_by': me,
      'created_at': nowIso(),
    });
    final fund = _fund(building);
    fund['balance'] = (fund['balance'] as num) + amount;
    fund['updated_at'] = nowIso();
  }

  void _notify(Iterable<String> userIds, String title, String body, String deepLink) {
    for (final u in userIds.toSet()) {
      t('notifications').add({'id': newId(), 'user_id': u, 'title': title, 'body': body, 'deep_link': deepLink, 'is_read': false, 'created_at': nowIso()});
    }
  }

  Iterable<String> _verifiedUsers(String building) =>
      t('union_members').where((m) => m['building_id'] == building && m['status'] == 'verified').map((m) => m['user_id'] as String);

  Iterable<String> _unitMembers(String? unitId) =>
      t('union_members').where((m) => m['unit_id'] == unitId && m['status'] == 'verified').map((m) => m['user_id'] as String);

  String? _currentPeriod(String building) {
    final dues = t('union_dues').where((d) => d['building_id'] == building).toList()
      ..sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    return dues.isEmpty ? null : dues.first['period_label'] as String;
  }

  String _displayName(String building, String userId) {
    final full = nameOf(userId);
    final m = _firstWhere('union_members', (r) => r['building_id'] == building && r['user_id'] == userId);
    if (m?['show_family_name_only'] == true && userId != me && !_isBoard(building)) {
      final parts = full.split(' ');
      return 'عائلة ${parts.length > 1 ? parts.last : full}';
    }
    return full;
  }

  /// The newest still-valid active pass of [building] — what the guard's
  /// «محاكاة المسح» button "scans".
  String? latestActivePassCode(String building) {
    final unitIds = t('units').where((u) => u['building_id'] == building).map((u) => u['id']).toSet();
    final now = DateTime.now().toUtc();
    final passes =
        t('visitor_passes')
            .where(
              (p) => unitIds.contains(p['unit_id']) && p['status'] == 'active' && (DateTime.tryParse(p['valid_until'] as String? ?? '')?.isAfter(now) ?? false),
            )
            .toList()
          ..sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
    return passes.isEmpty ? null : passes.first['qr_code'] as String;
  }

  /// The ledger entry a receipt belongs to (for the placeholder receipt).
  DemoRow? ledgerRowForReceipt(String path) => _firstWhere('union_fund_transactions', (r) => r['receipt_path'] == path);

  // ------------------------------------------------------------------
  // RPCs (POST /rest/v1/rpc/<fn>)
  // ------------------------------------------------------------------

  Object? rpc(String fn, Map<String, dynamic> p) {
    final result = _rpc(fn, p);
    save();
    return result;
  }

  Object? _rpc(String fn, Map<String, dynamic> p) {
    if (isTajer) return _tajerRpc(fn, p);
    String s(String k) => p[k] as String;
    switch (fn) {
      case 'ensure_my_profile':
      case 'save_push_subscription':
        return null;

      case 'get_contact_phones':
        final ids = List<String>.from(p['p_user_ids'] as List? ?? const []);
        return [
          for (final id in ids)
            if (profileOf(id)?['phone'] != null) {'user_id': id, 'phone': profileOf(id)!['phone']},
        ];

      // ---- membership ----
      case 'building_member_names':
        final b = s('p_building_id');
        if (!_isVerifiedMember(b)) return <DemoRow>[];
        return [
          for (final u in _verifiedUsers(b)) {'user_id': u, 'display_name': _displayName(b, u)},
        ];

      case 'set_my_name_privacy':
        final mine = t('union_members').where((m) => m['user_id'] == me && (p['p_building_id'] == null || m['building_id'] == p['p_building_id'])).toList();
        if (mine.isEmpty) throw DemoError('إنت مش عضو في العمارة دي');
        for (final m in mine) {
          m['show_family_name_only'] = p['p_family_only'] == true;
        }
        return null;

      case 'join_building_with_code':
        _requireSignedIn();
        final code = (p['p_code'] as String? ?? '').trim().toUpperCase();
        final building = _firstWhere('buildings', (b) => (b['invite_code'] as String).toUpperCase() == code);
        if (building == null) throw DemoError('كود الدعوة غير صحيح أو انتهت صلاحيته');
        final b = building['id'] as String;
        if (t('union_members').any((m) => m['user_id'] == me && m['building_id'] == b && m['status'] != 'rejected')) {
          throw DemoError('إنت عضو أو طلبك متبعت قبل كده في العمارة دي');
        }
        final unitNumber = (p['p_unit_number'] as String? ?? '').trim();
        var unit = _firstWhere('units', (u) => u['building_id'] == b && u['unit_number'] == unitNumber);
        if (unit == null) {
          unit = {'id': newId(), 'building_id': b, 'unit_number': unitNumber, 'floor_label': p['p_floor_label'], 'created_at': nowIso()};
          t('units').add(unit);
        }
        t('union_members').add({
          'id': newId(),
          'building_id': b,
          'unit_id': unit['id'],
          'user_id': me,
          'role': 'member',
          'status': 'pending',
          'residency_type': p['p_residency_type'] ?? 'owner',
          'show_family_name_only': false,
          'verified_by': null,
          'created_at': nowIso(),
        });
        _notify(
          t('union_members')
              .where((m) => m['building_id'] == b && m['status'] == 'verified' && const ['president', 'board_member'].contains(m['role']))
              .map((m) => m['user_id'] as String),
          '🙋 طلب انضمام جديد',
          '${nameOf(me)} طلب ينضم للعمارة (شقة $unitNumber).',
          '/#/union-approvals',
        );
        return null;

      case 'found_building':
        _requireSignedIn();
        final b = newId();
        final inviteCode = _code('BLD');
        t('buildings').add({
          'id': b,
          'name': p['p_name'],
          'district': p['p_district'],
          'city': p['p_city'],
          'governorate': p['p_governorate'],
          'lat': null,
          'lng': null,
          'invite_code': inviteCode,
          'created_at': nowIso(),
        });
        final u = newId();
        t('units').add({'id': u, 'building_id': b, 'unit_number': p['p_unit_number'], 'floor_label': p['p_floor_label'], 'created_at': nowIso()});
        t('union_members').add({
          'id': newId(),
          'building_id': b,
          'unit_id': u,
          'user_id': me,
          'role': p['p_as_president'] == false ? 'board_member' : 'president',
          'status': 'verified',
          'residency_type': 'owner',
          'show_family_name_only': false,
          'verified_by': me,
          'created_at': nowIso(),
        });
        t('unit_residents').add({'id': newId(), 'unit_id': u, 'user_id': me, 'residency_type': 'owner', 'is_primary': true, 'created_at': nowIso()});
        return inviteCode;

      case 'review_union_member':
        final m = _firstWhere('union_members', (r) => r['id'] == p['p_member_id']) ?? (throw DemoError('الطلب مش موجود'));
        if (!_isBoard(m['building_id'] as String)) throw DemoError('الموافقة لرئيس الاتحاد وأعضاء المجلس بس');
        final approve = p['p_approve'] == true;
        m['status'] = approve ? 'verified' : 'rejected';
        m['verified_by'] = me;
        if (approve && m['unit_id'] != null) {
          t('unit_residents').add({
            'id': newId(),
            'unit_id': m['unit_id'],
            'user_id': m['user_id'],
            'residency_type': m['residency_type'],
            'is_primary': m['residency_type'] == 'owner',
            'created_at': nowIso(),
          });
        }
        _notify(
          [m['user_id'] as String],
          approve ? '✅ تم اعتماد عضويتك' : 'طلب الانضمام اترفض',
          approve ? 'أهلاً بيك في ${_building(m['building_id'] as String)['name']} — تقدر تستخدم كل خدمات الاتحاد دلوقتي.' : 'كلّم رئيس الاتحاد لو فيه لبس.',
          '/#/union',
        );
        return null;

      // ---- tenants ----
      case 'invite_tenant_for_unit':
        final unitId = s('p_unit_id');
        if (!t('unit_residents').any((r) => r['unit_id'] == unitId && r['user_id'] == me && r['residency_type'] == 'owner' && r['is_primary'] == true)) {
          throw DemoError('دعوة المستأجر لمالك الشقة بس');
        }
        final code = _code('TEN');
        t('union_tenant_invites').add({
          'id': newId(),
          'unit_id': unitId,
          'code': code,
          'created_by': me,
          'used_by': null,
          'expires_at': DateTime.now().toUtc().add(const Duration(days: 7)).toIso8601String(),
          'created_at': nowIso(),
        });
        return code;

      case 'join_as_tenant_with_code':
        _requireSignedIn();
        final code = (p['p_code'] as String? ?? '').trim().toUpperCase();
        final invite = _firstWhere('union_tenant_invites', (r) => (r['code'] as String).toUpperCase() == code && r['used_by'] == null);
        if (invite == null) throw DemoError('كود المستأجر غير صحيح أو اتستخدم قبل كده');
        final unit = _unit(invite['unit_id'] as String);
        invite['used_by'] = me;
        t('union_members').add({
          'id': newId(),
          'building_id': unit['building_id'],
          'unit_id': unit['id'],
          'user_id': me,
          'role': 'member',
          'status': 'verified',
          'residency_type': 'tenant',
          'show_family_name_only': false,
          'verified_by': invite['created_by'],
          'created_at': nowIso(),
        });
        t('unit_residents').add({'id': newId(), 'unit_id': unit['id'], 'user_id': me, 'residency_type': 'tenant', 'is_primary': false, 'created_at': nowIso()});
        return null;

      case 'revoke_tenant':
        final unitId = s('p_unit_id');
        final tenant = s('p_tenant_user_id');
        t('unit_residents').removeWhere((r) => r['unit_id'] == unitId && r['user_id'] == tenant && r['residency_type'] == 'tenant');
        for (final m in t('union_members').where((m) => m['unit_id'] == unitId && m['user_id'] == tenant)) {
          m['status'] = 'rejected';
        }
        return null;

      // ---- fund ----
      case 'is_union_fund_manager':
        return _isManager(s('p_building_id'));
      case 'can_view_union_fund':
        return _canViewFund(s('p_building_id'));

      case 'union_fund_summary':
        final b = s('p_building');
        if (!_canViewFund(b)) throw DemoError('رصيد الصندوق للرئيس ومجلس الإدارة وأمين الصندوق بس');
        final since = p['p_since'] == null ? null : DateTime.tryParse(p['p_since'] as String);
        final txs = t('union_fund_transactions')
            .where((x) => x['building_id'] == b && (since == null || DateTime.parse(x['created_at'] as String).isAfter(since)))
            .toList();
        num sumOf(String type) => txs.where((x) => x['type'] == type).fold<num>(0, (a, x) => a + (x['amount'] as num));
        final expenses = txs.where((x) => x['type'] == 'expense').toList()..sort((a, b) => (b['created_at'] as String).compareTo(a['created_at'] as String));
        return {
          'balance': _fund(b)['balance'],
          'income_wallet': sumOf('due_payment'),
          'income_cash': sumOf('cash_due'),
          'expenses': -sumOf('expense'),
          'withdrawals': -sumOf('withdrawal'),
          'adjustments': sumOf('adjustment'),
          'pending_withdrawals': t('union_fund_withdrawal_requests')
              .where((w) => w['building_id'] == b && w['status'] == 'pending')
              .fold<num>(0, (a, w) => a + (w['amount_egp'] as num)),
          'manager_id': fundManagerOf(b),
          'treasurer_id': treasurerOf(b),
          'expense_items': [
            for (final e in expenses)
              {'id': e['id'], 'note': e['note'], 'amount': -(e['amount'] as num), 'receipt_path': e['receipt_path'], 'created_at': e['created_at']},
          ],
        };

      case 'union_dues_status':
        final b = s('p_building');
        if (!_canViewFund(b)) throw DemoError('حالة السداد للرئيس ومجلس الإدارة وأمين الصندوق بس');
        final period = p['p_period'] as String? ?? _currentPeriod(b);
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final rows = <DemoRow>[];
        for (final u in t('units').where((u) => u['building_id'] == b)) {
          final d = _firstWhere('union_dues', (d) => d['unit_id'] == u['id'] && d['period_label'] == period);
          final dueDate = d == null ? null : DateTime.tryParse(d['due_date'] as String? ?? '');
          final status = d == null
              ? 'none'
              : d['is_paid'] == true
              ? 'paid'
              : (dueDate != null && dueDate.isBefore(todayDate) ? 'overdue' : 'unpaid');
          final names = _unitMembers(u['id'] as String).map(nameOf).toList();
          rows.add({
            'unit_id': u['id'],
            'unit_number': u['unit_number'],
            'floor_label': u['floor_label'],
            'residents': names.isEmpty ? null : names.join('، '),
            'due_id': d?['id'],
            'period_label': d?['period_label'],
            'amount': d?['amount'],
            'due_date': d?['due_date'],
            'is_paid': d?['is_paid'] ?? false,
            'paid_at': d?['paid_at'],
            'paid_via': d?['paid_via'],
            'status': status,
          });
        }
        const rank = {'overdue': 0, 'unpaid': 1, 'paid': 2, 'none': 3};
        rows.sort((a, c) {
          final r = rank[a['status']]!.compareTo(rank[c['status']]!);
          if (r != 0) return r;
          return (int.tryParse('${a['unit_number']}') ?? 0).compareTo(int.tryParse('${c['unit_number']}') ?? 0);
        });
        return rows;

      case 'union_due_periods':
        final b = s('p_building');
        if (!_canViewFund(b)) throw DemoError('غير مسموح');
        final byPeriod = <String, List<DemoRow>>{};
        for (final d in t('union_dues').where((d) => d['building_id'] == b)) {
          byPeriod.putIfAbsent(d['period_label'] as String, () => []).add(d);
        }
        final out = [
          for (final e in byPeriod.entries)
            {
              'period_label': e.key,
              'issued_at': e.value.map((d) => d['created_at'] as String).reduce((a, c) => a.compareTo(c) > 0 ? a : c),
              'total': e.value.length,
              'paid': e.value.where((d) => d['is_paid'] == true).length,
            },
        ]..sort((a, c) => (c['issued_at'] as String).compareTo(a['issued_at'] as String));
        return out;

      case 'union_collection_rate':
        final b = s('p_building');
        if (!_isVerifiedMember(b)) throw DemoError('لازم تكون ساكن موثّق في العمارة');
        final period = p['p_period'] as String? ?? _currentPeriod(b);
        if (period == null) return <DemoRow>[];
        final dues = t('union_dues').where((d) => d['building_id'] == b && d['period_label'] == period).toList();
        final paid = dues.where((d) => d['is_paid'] == true).length;
        return [
          {'period_label': period, 'total_units': dues.length, 'paid_units': paid, 'pct': dues.isEmpty ? 0 : (paid * 1000 / dues.length).round() / 10},
        ];

      case 'remind_unpaid_dues':
        final b = s('p_building');
        if (!(_isManager(b) || _isBoard(b))) throw DemoError('التذكير للرئيس ومجلس الإدارة وأمين الصندوق بس');
        final last = _firstWhere('union_due_reminders', (r) => r['building_id'] == b);
        final lastAt = DateTime.tryParse(last?['last_sent_at'] as String? ?? '');
        if (lastAt != null && DateTime.now().toUtc().difference(lastAt) < const Duration(hours: 24)) {
          throw DemoError('فكّرت الجيران من شوية — تقدر تفكّرهم تاني بعد 24 ساعة من آخر تذكير');
        }
        final unpaid = t('union_dues').where((d) => d['building_id'] == b && d['is_paid'] != true).toList();
        final users = <String>{for (final d in unpaid) ..._unitMembers(d['unit_id'] as String)};
        _notify(users, '⏰ تذكير بمستحقات الصيانة', 'عليك مستحقات صيانة لسه ما اتدفعتش. ادفع من التطبيق في ثانية.', '/#/union-pay');
        t('union_due_reminders').removeWhere((r) => r['building_id'] == b);
        t('union_due_reminders').add({'building_id': b, 'last_sent_at': nowIso(), 'sent_by': me});
        return users.length;

      case 'mark_due_paid_cash':
        final due = _firstWhere('union_dues', (d) => d['id'] == p['p_due_id']) ?? (throw DemoError('المستحق مش موجود'));
        final b = due['building_id'] as String;
        if (!_isManager(b)) throw DemoError('تسجيل الكاش لمدير الصندوق بس (أمين الصندوق أو الرئيس)');
        if (due['is_paid'] == true) throw DemoError('المستحق ده مدفوع خلاص');
        due['is_paid'] = true;
        due['paid_at'] = nowIso();
        due['paid_via'] = 'cash';
        due['paid_by'] = me;
        _ledger(
          b,
          'cash_due',
          due['amount'] as num,
          dueId: due['id'] as String,
          unitId: due['unit_id'] as String,
          note: (p['p_note'] as String?) ?? 'سداد «${due['period_label']}» كاش',
        );
        _notify(_unitMembers(due['unit_id'] as String), '✅ اتسجّل سدادك', 'استلمنا «${due['period_label']}» كاش ودخلت صندوق العمارة. شكراً!', '/#/union');
        return null;

      case 'record_union_expense':
        final b = s('p_building');
        if (!_isManager(b)) throw DemoError('المصروفات بيسجّلها مدير الصندوق بس');
        final amount = (p['p_amount'] as num?) ?? 0;
        if (amount <= 0) throw DemoError('اكتب مبلغ صحيح');
        if ((_fund(b)['balance'] as num) < amount) throw DemoError('رصيد الصندوق مش كفاية للمصروف ده');
        _ledger(b, 'expense', -amount, note: p['p_note'] as String?, receipt: p['p_receipt_path'] as String?);
        return null;

      case 'request_fund_withdrawal':
        final b = s('p_building');
        if (!_isManager(b)) throw DemoError('طلب السحب لمدير الصندوق بس');
        final amount = (p['p_amount'] as num?) ?? 0;
        if (amount <= 0) throw DemoError('اكتب مبلغ صحيح');
        if ((_fund(b)['balance'] as num) < amount) throw DemoError('رصيد الصندوق مش كفاية');
        t('union_fund_withdrawal_requests').add({
          'id': newId(),
          'building_id': b,
          'requested_by': me,
          'amount_egp': amount,
          'destination': p['p_payout_phone'] == null ? 'wallet' : 'payout',
          'payout_phone': p['p_payout_phone'],
          'note': p['p_note'] ?? '',
          'status': 'pending',
          'created_at': nowIso(),
        });
        return null;

      case 'appoint_union_treasurer':
        final b = s('p_building');
        if (!_isPresident(b)) throw DemoError('تعيين أمين الصندوق لرئيس الاتحاد بس');
        final userId = s('p_user_id');
        t('union_treasurers').removeWhere((r) => r['building_id'] == b);
        t('union_treasurers').add({'building_id': b, 'user_id': userId, 'source': 'appointed', 'appointed_by': me, 'created_at': nowIso()});
        _notify(_verifiedUsers(b), '💼 أمين صندوق جديد', '${nameOf(userId)} بقى أمين صندوق العمارة.', '/#/union-treasurer');
        return null;

      case 'remove_union_treasurer':
        final b = s('p_building');
        if (!_isPresident(b)) throw DemoError('إزالة أمين الصندوق لرئيس الاتحاد بس');
        t('union_treasurers').removeWhere((r) => r['building_id'] == b);
        return null;

      case 'get_building_invite_code':
        final b = s('p_building');
        if (!_isBoard(b)) throw DemoError('كود الدعوة لرئيس الاتحاد وأعضاء المجلس بس');
        return _building(b)['invite_code'];

      case 'rotate_building_invite_code':
        final b = s('p_building');
        if (!_isBoard(b)) throw DemoError('تغيير الكود لرئيس الاتحاد وأعضاء المجلس بس');
        final code = _code('BLD');
        _building(b)['invite_code'] = code;
        return code;

      // ---- dues ----
      case 'create_union_due':
        final b = s('p_building_id');
        if (!_isBoard(b)) throw DemoError('إصدار المستحقات لرئيس الاتحاد وأعضاء المجلس بس');
        final label = (p['p_period_label'] as String? ?? '').trim();
        if (t('union_dues').any((d) => d['building_id'] == b && d['period_label'] == label)) throw DemoError('المستحقات دي اتعملت قبل كده');
        var count = 0;
        for (final u in t('units').where((u) => u['building_id'] == b)) {
          t('union_dues').add({
            'id': newId(),
            'building_id': b,
            'unit_id': u['id'],
            'period_label': label,
            'amount': p['p_amount'],
            'due_date': p['p_due_date'],
            'is_paid': false,
            'paid_at': null,
            'paid_via': null,
            'paid_by': null,
            'created_at': nowIso(),
          });
          count++;
        }
        _notify(
          _verifiedUsers(b).where((u) => u != me),
          '🧾 مستحقات صيانة جديدة',
          '«$label» — ${p['p_amount']} ج.م. ادفع من التطبيق في ثانية.',
          '/#/union-pay',
        );
        return count;

      case 'pay_union_due':
        final due = _firstWhere('union_dues', (d) => d['id'] == p['p_due_id']) ?? (throw DemoError('المستحق مش موجود'));
        if (due['is_paid'] == true) throw DemoError('المستحق ده مدفوع خلاص');
        final wallet = _firstWhere('wallets', (w) => w['user_id'] == me) ?? (throw DemoError('مفيش محفظة'));
        final amount = due['amount'] as num;
        if ((wallet['available_balance'] as num) < amount) throw DemoError('رصيد محفظتك مش كفاية — اشحن المحفظة الأول');
        wallet['available_balance'] = (wallet['available_balance'] as num) - amount;
        t('wallet_transactions')
            .add({'id': newId(), 'wallet_id': wallet['id'], 'type': 'union_dues', 'amount': -amount, 'status': 'completed', 'created_at': nowIso()});
        due['is_paid'] = true;
        due['paid_at'] = nowIso();
        due['paid_via'] = 'wallet';
        due['paid_by'] = me;
        _ledger(
          due['building_id'] as String,
          'due_payment',
          amount,
          dueId: due['id'] as String,
          unitId: due['unit_id'] as String,
          note: 'سداد «${due['period_label']}»',
        );
        return null;

      // ---- board decisions ----
      case 'propose_board_decision':
        final b = s('p_building_id');
        if (!_isBoard(b)) throw DemoError('القرارات لمجلس الإدارة بس');
        final id = newId();
        t('board_decisions').add({
          'id': id,
          'building_id': b,
          'title': p['p_title'],
          'description': p['p_description'],
          'requires_unanimous': p['p_requires_unanimous'] == true,
          'status': 'open',
          'eligible_voters': t('union_members')
              .where((m) => m['building_id'] == b && m['status'] == 'verified' && const ['president', 'board_member'].contains(m['role']))
              .length,
          'proposed_by': me,
          'created_at': nowIso(),
        });
        return id;

      case 'cast_board_vote':
        final d = _firstWhere('board_decisions', (r) => r['id'] == p['p_decision_id']) ?? (throw DemoError('القرار مش موجود'));
        if (!_isBoard(d['building_id'] as String)) throw DemoError('التصويت لمجلس الإدارة بس');
        if (d['status'] != 'open') throw DemoError('القرار ده اتقفل');
        t('board_decision_votes').removeWhere((v) => v['decision_id'] == d['id'] && v['voter_id'] == me);
        t('board_decision_votes').add({'id': newId(), 'decision_id': d['id'], 'voter_id': me, 'choice': p['p_choice'], 'created_at': nowIso()});
        final votes = t('board_decision_votes').where((v) => v['decision_id'] == d['id']).toList();
        final approvals = votes.where((v) => v['choice'] == 'approve').length;
        final rejects = votes.length - approvals;
        final eligible = (d['eligible_voters'] as num).toInt();
        if (d['requires_unanimous'] == true) {
          if (rejects > 0) {
            d['status'] = 'rejected';
          } else if (approvals >= eligible) {
            d['status'] = 'approved';
          }
        } else if (approvals * 2 > eligible) {
          d['status'] = 'approved';
        } else if (rejects * 2 >= eligible) {
          d['status'] = 'rejected';
        }
        return null;

      // ---- elections ----
      case 'create_election':
        final b = s('p_building_id');
        final id = newId();
        t('union_elections').add({
          'id': id,
          'building_id': b,
          'position': p['p_position'] ?? 'president',
          'title': p['p_title'],
          'closes_at': p['p_closes_at'],
          'is_finalized': false,
          'eligible_voters': t('units').where((u) => u['building_id'] == b && _unitMembers(u['id'] as String).isNotEmpty).length,
          'legal_quorum_pct': 50,
          'created_by': me,
          'created_at': nowIso(),
        });
        return id;

      case 'nominate_self':
        final e = s('p_election_id');
        if (t('union_candidates').any((c) => c['election_id'] == e && c['user_id'] == me)) throw DemoError('إنت مترشّح خلاص');
        t('union_candidates').add({'id': newId(), 'election_id': e, 'user_id': me, 'pledge': p['p_pledge'], 'vote_count': 0, 'created_at': nowIso()});
        return null;

      case 'cast_election_vote':
        final e = s('p_election_id');
        if (t('union_votes').any((v) => v['election_id'] == e && v['voter_id'] == me)) throw DemoError('إنت صوّت قبل كده في الانتخابات دي');
        final c = _firstWhere('union_candidates', (r) => r['id'] == p['p_candidate_id']) ?? (throw DemoError('المرشح مش موجود'));
        t('union_votes').add({'id': newId(), 'election_id': e, 'voter_id': me, 'candidate_id': c['id'], 'created_at': nowIso()});
        c['vote_count'] = ((c['vote_count'] as num?) ?? 0).toInt() + 1;
        return null;

      case 'finalize_election':
        final e = _firstWhere('union_elections', (r) => r['id'] == p['p_election_id']) ?? (throw DemoError('الانتخابات مش موجودة'));
        e['is_finalized'] = true;
        final cands = t('union_candidates').where((c) => c['election_id'] == e['id']).toList()
          ..sort((a, b) => ((b['vote_count'] as num?) ?? 0).compareTo((a['vote_count'] as num?) ?? 0));
        final total = cands.fold<num>(0, (a, c) => a + ((c['vote_count'] as num?) ?? 0));
        final eligible = ((e['eligible_voters'] as num?) ?? 0).toInt();
        if (cands.isNotEmpty && eligible > 0 && total * 100 / eligible >= ((e['legal_quorum_pct'] as num?) ?? 50)) {
          final winner = cands.first['user_id'] as String;
          final b = e['building_id'] as String;
          if (e['position'] == 'treasurer') {
            t('union_treasurers').removeWhere((r) => r['building_id'] == b);
            t('union_treasurers').add({'building_id': b, 'user_id': winner, 'source': 'elected', 'appointed_by': null, 'created_at': nowIso()});
          } else {
            for (final m in t('union_members').where((m) => m['building_id'] == b && m['status'] == 'verified')) {
              if (m['user_id'] == winner) {
                m['role'] = 'president';
              } else if (m['role'] == 'president') {
                m['role'] = 'member';
              }
            }
          }
        }
        return null;

      // ---- polls & announcements ----
      case 'list_building_polls':
        final b = s('p_building_id');
        if (!_isVerifiedMember(b)) return <DemoRow>[];
        final myUnit = myMembership?['unit_id'];
        final totalUnits = t('union_members')
            .where((m) => m['building_id'] == b && m['status'] == 'verified' && m['unit_id'] != null)
            .map((m) => m['unit_id'])
            .toSet()
            .length;
        final now = DateTime.now().toUtc();
        final polls =
            t('union_polls').where((r) => r['building_id'] == b).map((poll) {
              final votes = t('union_poll_votes').where((v) => v['poll_id'] == poll['id']).toList();
              final options = List<String>.from(poll['options'] as List);
              final isOpen = poll['closed_at'] == null && now.isBefore(DateTime.parse(poll['ends_at'] as String));
              DemoRow? mine;
              for (final v in votes) {
                if (v['unit_id'] == myUnit) mine = v;
              }
              return <String, dynamic>{
                'id': poll['id'],
                'question': poll['question'],
                'options': options,
                'ends_at': poll['ends_at'],
                'closed_at': poll['closed_at'],
                'created_at': poll['created_at'],
                'created_by_name': _displayName(b, poll['created_by'] as String),
                'is_open': isOpen,
                'counts': [for (var i = 0; i < options.length; i++) votes.where((v) => v['option_index'] == i).length],
                'units_voted': votes.length,
                'total_units': max(totalUnits, votes.length),
                'my_unit_choice': mine?['option_index'],
                'voted_by_me': votes.any((v) => v['voter_id'] == me),
              };
            }).toList()..sort((a, c) {
              final o = (c['is_open'] == true ? 1 : 0).compareTo(a['is_open'] == true ? 1 : 0);
              return o != 0 ? o : (c['created_at'] as String).compareTo(a['created_at'] as String);
            });
        return polls;

      case 'create_building_poll':
        final b = s('p_building_id');
        if (!_isBoard(b)) throw DemoError('التصويت بيعمله رئيس الاتحاد أو المجلس');
        final options = List<String>.from(p['p_options'] as List);
        if (options.length < 2) throw DemoError('محتاج اختيارين على الأقل');
        final id = newId();
        t('union_polls').add({
          'id': id,
          'building_id': b,
          'question': p['p_question'],
          'options': options,
          'ends_at': p['p_ends_at'],
          'closed_at': null,
          'created_by': me,
          'created_at': nowIso(),
        });
        _notify(_verifiedUsers(b).where((u) => u != me), '🗳️ تصويت جديد للسكان', '${p['p_question']}', '/#/polls');
        return id;

      case 'cast_poll_vote':
        final poll = _firstWhere('union_polls', (r) => r['id'] == p['p_poll_id']) ?? (throw DemoError('التصويت مش موجود'));
        final m = membershipOf(me, building: poll['building_id'] as String);
        if (m == null) throw DemoError('التصويت لسكان العمارة الموثّقين بس');
        if (m['unit_id'] == null) throw DemoError('التصويت صوت لكل شقة — حسابك مش مربوط بشقة');
        if (poll['closed_at'] != null || DateTime.now().toUtc().isAfter(DateTime.parse(poll['ends_at'] as String))) throw DemoError('التصويت ده اتقفل');
        if (t('union_poll_votes').any((v) => v['poll_id'] == poll['id'] && v['unit_id'] == m['unit_id'])) throw DemoError('شقتكم صوّتت قبل كده');
        t('union_poll_votes')
            .add({'id': newId(), 'poll_id': poll['id'], 'unit_id': m['unit_id'], 'voter_id': me, 'option_index': p['p_option'], 'created_at': nowIso()});
        return null;

      case 'close_building_poll':
        final poll = _firstWhere('union_polls', (r) => r['id'] == p['p_poll_id']) ?? (throw DemoError('التصويت مش موجود'));
        if (!_isBoard(poll['building_id'] as String)) throw DemoError('قفل التصويت لرئيس الاتحاد أو المجلس');
        poll['closed_at'] = nowIso();
        return null;

      case 'publish_official_announcement':
        final b = (p['p_building_id'] as String?) ?? myMembership?['building_id'] as String?;
        if (b == null || !_isBoard(b)) throw DemoError('الإعلان الرسمي لرئيس الاتحاد وأعضاء المجلس بس');
        final body = (p['p_body'] as String? ?? '').trim();
        if (body.length < 5) throw DemoError('اكتب نص الإعلان');
        final id = newId();
        t(
          'posts',
        ).add({'id': id, 'building_id': b, 'author_id': me, 'type': 'official', 'body': body, 'images': <String>[], 'is_pinned': true, 'created_at': nowIso()});
        _notify(_verifiedUsers(b).where((u) => u != me), '📢 إعلان رسمي من الاتحاد', body.length > 90 ? '${body.substring(0, 90)}…' : body, '/#/feed');
        return id;

      case 'set_post_pinned':
        final post = _firstWhere('posts', (r) => r['id'] == p['p_post_id']) ?? (throw DemoError('المنشور مش موجود'));
        if (!_isBoard(post['building_id'] as String)) throw DemoError('التثبيت لرئيس الاتحاد أو المجلس');
        post['is_pinned'] = p['p_pinned'] == true;
        return null;

      case 'fetch_building_posts':
        final b = s('p_building_id');
        final posts = t('posts').where((r) => r['building_id'] == b).toList()
          ..sort((a, c) {
            final pin = (c['is_pinned'] == true ? 1 : 0).compareTo(a['is_pinned'] == true ? 1 : 0);
            return pin != 0 ? pin : (c['created_at'] as String).compareTo(a['created_at'] as String);
          });
        return [
          for (final post in posts)
            {
              'id': post['id'],
              'author_id': post['author_id'],
              'author_name': _displayName(b, post['author_id'] as String),
              'type': post['type'],
              'body': post['body'],
              'images': post['images'] ?? <String>[],
              'is_pinned': post['is_pinned'] == true,
              'created_at': post['created_at'],
              'comment_count': t('post_comments').where((c) => c['post_id'] == post['id']).length,
              'reaction_count': t('post_reactions').where((c) => c['post_id'] == post['id']).length,
            },
        ];

      // ---- guard & visitors ----
      case 'appoint_guard':
        final b = s('p_building_id');
        if (!_isBoard(b)) throw DemoError('تعيين الحارس لرئيس الاتحاد أو المجلس');
        t('building_guards').removeWhere((g) => g['building_id'] == b && g['user_id'] == p['p_user_id']);
        t('building_guards').add({'id': newId(), 'building_id': b, 'user_id': p['p_user_id'], 'is_active': true, 'appointed_by': me, 'created_at': nowIso()});
        return null;

      case 'revoke_guard':
        for (final g in t('building_guards').where((g) => g['building_id'] == p['p_building_id'] && g['user_id'] == p['p_user_id'])) {
          g['is_active'] = false;
        }
        return null;

      case 'verify_visitor_pass':
        final code = (p['p_qr_code'] as String? ?? '').trim().toUpperCase();
        final pass = _firstWhere('visitor_passes', (r) => (r['qr_code'] as String).toUpperCase() == code) ?? (throw DemoError('كود التصريح غير صحيح'));
        final unit = _unit(pass['unit_id'] as String);
        if (!t('building_guards').any((g) => g['building_id'] == unit['building_id'] && g['user_id'] == me && g['is_active'] == true)) {
          throw DemoError('غير مصرح لك بالتحقق من تصاريح هذه العمارة');
        }
        if (pass['status'] == 'active' && DateTime.parse(pass['valid_until'] as String).isBefore(DateTime.now().toUtc())) {
          pass['status'] = 'expired';
          throw DemoError('انتهت صلاحية هذا التصريح');
        }
        if (pass['status'] != 'active') throw DemoError('هذا التصريح غير نشط (تم استخدامه أو إلغاؤه بالفعل)');
        pass['status'] = 'used';
        _notify([pass['issued_by'] as String], '🚪 زائرك وصل', '${pass['visitor_name']} دخل العمارة والأمن اتحقق من التصريح.', '/#/union');
        return {'visitor_name': pass['visitor_name'], 'pass_type': pass['pass_type'], 'unit_number': unit['unit_number'], 'floor_label': unit['floor_label']};

      case 'fetch_guard_recent_passes':
        final b = s('p_building_id');
        final units = {for (final u in t('units').where((u) => u['building_id'] == b)) u['id']: u};
        final passes = t('visitor_passes').where((v) => units.containsKey(v['unit_id']) && const ['used', 'expired'].contains(v['status'])).toList()
          ..sort((a, c) => (c['created_at'] as String).compareTo(a['created_at'] as String));
        return [
          for (final v in passes.take((p['p_limit'] as num?)?.toInt() ?? 20))
            {
              'id': v['id'],
              'visitor_name': v['visitor_name'],
              'pass_type': v['pass_type'],
              'status': v['status'],
              'unit_number': units[v['unit_id']]!['unit_number'],
              'floor_label': units[v['unit_id']]!['floor_label'],
              'created_at': v['created_at'],
            },
        ];

      // ---- lost & found ----
      case 'report_lost_found_item':
        final m = myMembership ?? (throw DemoError('لازم تنضم لعمارتك الأول'));
        final secret = (p['p_secret_mark'] as String?)?.trim();
        t('lost_found_items').add({
          'id': newId(),
          'building_id': m['building_id'],
          'reporter_id': me,
          'type': p['p_type'],
          'category': p['p_category'],
          'title': p['p_title'],
          'description': null,
          'image_url': p['p_image_url'],
          'location_note': p['p_location_note'],
          'is_resolved': false,
          'reward_amount': p['p_reward_amount'],
          'created_at': nowIso(),
          'has_secret_mark': secret != null && secret.isNotEmpty,
          '_secret': secret,
        });
        return null;

      case 'claim_lost_found_item':
        final item = _firstWhere('lost_found_items', (r) => r['id'] == p['p_item_id']) ?? (throw DemoError('العنصر مش موجود'));
        final secret = item['_secret'] as String?;
        _notify([item['reporter_id'] as String], '🔎 حد بيسأل على «${item['title']}»', '${nameOf(me)} بيقول إن ده بتاعه / يعرف مكانه.', '/#/lost-found');
        if (item['has_secret_mark'] == true && secret != null) {
          final answer = (p['p_answer'] as String? ?? '').trim();
          return answer.isNotEmpty && (secret.contains(answer) || answer.contains(secret)) ? 'verified' : 'wrong';
        }
        return 'notified';

      // ---- wallet ----
      case 'request_wallet_topup':
      case 'request_wallet_withdrawal':
        return null;
    }
    throw DemoError('الخاصية دي مش متاحة في النسخة التجريبية', 404);
  }
}

class SelectItem {
  SelectItem({required this.name, this.alias, this.hint, this.children});
  final String name;
  final String? alias;
  final String? hint;
  final List<SelectItem>? children;
  bool get isEmbed => children != null;
}
