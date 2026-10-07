import 'package:flutter_test/flutter_test.dart';
import 'package:mogtama3y/core/demo/demo_mode.dart';
import 'package:mogtama3y/core/demo/demo_store.dart';

void main() {
  test('?elections= picks the mode, anything else falls back to open', () {
    expect(demoElectionsFrom(Uri.parse('http://localhost:8737/?role=president&elections=none')), 'none');
    expect(demoElectionsFrom(Uri.parse('http://localhost:8737/?elections=ending')), 'ending');
    expect(demoElectionsFrom(Uri.parse('http://localhost:8737/?elections=hack')), 'open');
    expect(demoElectionsFrom(Uri.parse('http://localhost:8737/')), 'open');
  });

  test('elections=none: no election, candidates or votes', () {
    final t = DemoStore.seedTables(DateTime.now(), elections: 'none');
    expect(t['union_elections'], isEmpty);
    expect(t['union_candidates'], isEmpty);
    expect(t['union_votes'], isEmpty);
  });

  test('elections=ending: time is up, 6 of 10 voted (4 / 2), finalising meets quorum', () {
    final s = DemoStore.boot(role: 'president', elections: 'ending', persist: false);
    final e = s.t('union_elections').single;
    expect(DateTime.parse(e['closes_at'] as String).isBefore(DateTime.now()), isTrue);
    expect(s.t('union_votes').length, 6);
    final counts = s.t('union_candidates').map((c) => c['vote_count']).toList()..sort();
    expect(counts, [2, 4]);
    s.rpc('finalize_election', {'p_election_id': e['id']});
    expect(e['is_finalized'], isTrue);
    final president = s.t('union_members').where((m) => m['role'] == 'president').map((m) => m['user_id']).toSet();
    final winner = s.t('union_candidates').firstWhere((c) => c['vote_count'] == 4)['user_id'];
    expect(president, {winner});
  });

  test('default stays an open election with candidates', () {
    final t = DemoStore.seedTables(DateTime.now());
    final e = t['union_elections']!.single;
    expect(DateTime.parse(e['closes_at'] as String).isAfter(DateTime.now()), isTrue);
    expect(t['union_candidates']!.length, 2);
    expect(t['union_votes']!.length, 5);
  });
}
