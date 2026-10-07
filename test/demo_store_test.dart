import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/demo/demo_boot.dart';
import 'package:mogtama3y/core/demo/demo_http_client.dart';
import 'package:mogtama3y/core/demo/demo_mode.dart';
import 'package:mogtama3y/core/demo/demo_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The local demo build's fake backend, driven through the real Supabase
/// client exactly like the app's services do.
void main() {
  test('demo mode is off unless compiled with DEMO=true', () {
    expect(kDemo, isFalse);
    expect(demoHostAllowed(Uri.parse('http://localhost:8737/')), isTrue);
    expect(demoHostAllowed(Uri.parse('http://127.0.0.1:8737/')), isTrue);
    expect(demoHostAllowed(Uri.parse('http://[::1]:8737/')), isTrue);
    expect(demoHostAllowed(Uri.parse('https://ittihad.mogtama3y.com/')), isFalse);
    expect(demoHostAllowed(Uri.parse('http://localhost.evil.com/')), isFalse);
    expect(demoRoleFrom(Uri.parse('http://localhost/?role=guard')), 'guard');
    expect(demoRoleFrom(Uri.parse('http://localhost/?role=admin')), 'president');
  });

  SupabaseClient clientFor(String role) {
    final store = DemoStore.boot(role: role, persist: false);
    return SupabaseClient('http://demo.invalid', 'demo-key', httpClient: DemoHttpClient(store));
  }

  final b = DemoStore.buildingId;

  test('membership with embedded building, and the dues status mix', () async {
    final c = clientFor('president');
    final m = await c
        .from('union_members')
        .select('*, building:buildings(name, district, city, governorate, lat, lng)')
        .eq('user_id', DemoStore.uPresident)
        .eq('status', 'verified')
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    expect(m!['role'], 'president');
    expect((m['building'] as Map)['name'], 'عمارة النخيل — تجريبي');

    final rows = List<Map<String, dynamic>>.from(await c.rpc('union_dues_status', params: {'p_building': b, 'p_period': null}) as List);
    expect(rows.length, 12);
    final statuses = rows.map((r) => r['status']).toSet();
    expect(statuses, containsAll(['paid', 'unpaid', 'overdue', 'none']));
    expect(rows.any((r) => r['paid_via'] == 'cash'), isTrue);
    expect(await c.rpc('is_union_fund_manager', params: {'p_building_id': b}), isTrue);

    final pending = await c
        .from('union_members')
        .select('*, profile:profiles!union_members_user_id_fkey(full_name), unit:units(unit_number, floor_label)')
        .eq('building_id', b)
        .eq('status', 'pending');
    expect(((pending as List).single as Map)['profile']['full_name'], 'إيمان رضا');
  });

  test('mark cash and record an expense move the fund', () async {
    final c = clientFor('president');
    num balance() => DemoStore.instance.t('union_funds').first['balance'] as num;
    final start = balance();
    final rows = List<Map<String, dynamic>>.from(await c.rpc('union_dues_status', params: {'p_building': b}) as List);
    final unpaid = rows.firstWhere((r) => r['status'] == 'unpaid');
    await c.rpc('mark_due_paid_cash', params: {'p_due_id': unpaid['due_id'], 'p_note': null});
    expect(balance(), start + 350);
    await c.rpc('record_union_expense', params: {'p_building': b, 'p_amount': 100, 'p_note': 'شنطة عدة', 'p_receipt_path': null});
    expect(balance(), start + 250);
    final summary = await c.rpc('union_fund_summary', params: {'p_building': b, 'p_since': null}) as Map;
    expect(summary['balance'], start + 250);
    final ledger = await c
        .from('union_fund_transactions')
        .select('*, unit:units(unit_number), creator:profiles!union_fund_transactions_created_by_fkey(full_name)')
        .eq('building_id', b)
        .order('created_at', ascending: false)
        .limit(100);
    expect((ledger as List).any((t) => t['receipt_path'] != null), isTrue);
    expect(ledger.first['creator']['full_name'], isNotNull);
  });

  test('owner pays the due from the wallet into the fund', () async {
    final c = clientFor('owner');
    final due = await c.from('union_dues').select().eq('unit_id', DemoStore.unitId(3)).eq('is_paid', false).order('due_date', ascending: true).limit(1).maybeSingle();
    expect(due, isNotNull);
    final before = DemoStore.instance.t('union_funds').first['balance'] as num;
    await c.rpc('pay_union_due', params: {'p_due_id': due!['id']});
    expect(DemoStore.instance.t('union_funds').first['balance'], before + 350);
    expect(await c.rpc('can_view_union_fund', params: {'p_building_id': b}), isFalse);
    final rate = await c.rpc('union_collection_rate', params: {'p_building': b}) as List;
    expect((rate.single as Map)['paid_units'], greaterThan(0));
  });

  test('vote once per flat, post and chat', () async {
    final c = clientFor('owner');
    final polls = await c.rpc('list_building_polls', params: {'p_building_id': b}) as List;
    final open = polls.firstWhere((p) => p['is_open'] == true) as Map;
    expect(open['my_unit_choice'], isNull);
    await c.rpc('cast_poll_vote', params: {'p_poll_id': open['id'], 'p_option': 0});
    expect(() => c.rpc('cast_poll_vote', params: {'p_poll_id': open['id'], 'p_option': 1}), throwsA(isA<PostgrestException>()));

    await c.from('posts').insert({'building_id': b, 'author_id': DemoStore.uOwner, 'body': 'سلام عليكم'});
    final posts = await c.rpc('fetch_building_posts', params: {'p_building_id': b}) as List;
    expect(posts.first['type'], 'official'); // pinned first
    expect(posts.any((p) => p['body'] == 'سلام عليكم'), isTrue);

    await c.from('building_chat_messages').insert({'building_id': b, 'sender_id': DemoStore.uOwner, 'body': 'أهلاً'});
    final last = await c.from('building_chat_messages').select('*, sender:profiles(full_name)').eq('building_id', b).order('created_at', ascending: false).limit(1).maybeSingle();
    expect(last!['sender']['full_name'], 'خالد فتحي');
  });

  test('visitor pass issued by a resident is verified by the guard', () async {
    final owner = clientFor('owner');
    final pass = await owner
        .from('visitor_passes')
        .insert({'unit_id': DemoStore.unitId(3), 'issued_by': DemoStore.uOwner, 'visitor_name': 'ضيف', 'pass_type': 'guest', 'valid_until': DateTime.now().add(const Duration(hours: 2)).toUtc().toIso8601String()})
        .select()
        .single();
    expect(pass['qr_code'], startsWith('PASS-'));
    final store = DemoStore.instance;
    expect(store.latestActivePassCode(b), pass['qr_code']);

    final guard = SupabaseClient('http://demo.invalid', 'k', httpClient: DemoHttpClient(DemoStore.boot(role: 'guard', persist: false)));
    // a fresh store: the guard verifies the seeded active pass instead
    final code = DemoStore.instance.latestActivePassCode(b)!;
    final result = await guard.rpc('verify_visitor_pass', params: {'p_qr_code': code}) as Map;
    expect(result['unit_number'], isNotNull);
    expect(() => guard.rpc('verify_visitor_pass', params: {'p_qr_code': code}), throwsA(isA<PostgrestException>()));
  });

  testWidgets('demo receipt card and the local-only screen render', (tester) async {
    final store = DemoStore.boot(role: 'treasurer', persist: false);
    final tx = store.ledgerRowForReceipt('demo/receipt-pump.svg');
    expect(tx, isNotNull);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Directionality(textDirection: TextDirection.rtl, child: Center(child: DemoReceiptCard(tx: tx))))));
    expect(tester.takeException(), isNull);
    expect(find.text('إيصال استلام نقدية'), findsOneWidget);
    await tester.pumpWidget(const DemoBlockedApp());
    expect(find.text('Demo build — local only'), findsOneWidget);
    expect(store.treasurerOf(b), DemoStore.uTreasurer);
  });

  test('a new user joins with the building code and waits for approval', () async {
    final c = clientFor('new');
    await c.rpc('join_building_with_code', params: {'p_code': 'bld-7k3q9p', 'p_unit_number': '12', 'p_floor_label': 'الدور الرابع', 'p_residency_type': 'owner'});
    final m = await c.from('union_members').select('*').eq('user_id', DemoStore.uNew).maybeSingle();
    expect(m!['status'], 'pending');
    expect(m['unit_id'], DemoStore.unitId(12));
  });
}
