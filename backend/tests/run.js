// Security scenarios for the Supabase backend — run after every new
// migration:  cd backend/tests && npm install && npm test
// Each "EXPLOIT blocked" check is an attack that worked before
// migrations 0037/0038; the others make sure the real flows still work.
const { createDb, signUp, as, admin } = require('./harness');

let passed = 0;
const failures = [];
function check(name, cond, detail) {
  if (cond) {
    passed++;
    console.log('  ✓ ' + name);
  } else {
    failures.push(name);
    console.log('  ✗ ' + name + (detail ? '  →  ' + JSON.stringify(detail) : ''));
  }
}
const ok = (r) => !r.error;
const denied = (r) => !!r.error;

(async () => {
  const db = await createDb();

  // ------------------------------------------------------------------
  console.log('\nPhase 1 — sign-up, profile & wallet');
  const A = await signUp(db, 'ahmed', '01000000001');
  const B = await signUp(db, 'bassem', '01000000002');
  const C = await signUp(db, 'carim', '01000000003');
  const T = await signUp(db, 'tamer', '01000000004');
  const X = await signUp(db, 'outsider', '01000000005');
  const dup = await signUp(db, 'samephone', '01000000001');

  const profiles = await admin(db, `select id, full_name, phone from profiles`);
  const wallets = await admin(db, `select user_id from wallets`);
  check('sign-up creates a profile for every user', profiles.length === 6, profiles.length);
  check('sign-up creates a wallet for every user', wallets.length === 6, wallets.length);
  check('duplicate phone still creates the account (without phone)', profiles.find((p) => p.id === dup)?.phone === null);
  check('ensure_my_profile is idempotent', ok(await as(db, A, `select public.ensure_my_profile()`)) && ok(await as(db, A, `select public.ensure_my_profile()`)));

  check('EXPLOIT blocked: user sets own role to super_admin',
    denied(await as(db, X, `update profiles set role = 'super_admin' where id = $1`, [X])));
  check('EXPLOIT blocked: user sets own ad_token_balance',
    denied(await as(db, X, `update profiles set ad_token_balance = 99999 where id = $1`, [X])));
  check('EXPLOIT blocked: user sets is_verified',
    denied(await as(db, X, `update profiles set is_verified = true where id = $1`, [X])));
  check('user can still edit own name/phone',
    ok(await as(db, X, `update profiles set full_name = 'Xavier', phone = '01000000099', updated_at = now() where id = $1`, [X])));
  check('EXPLOIT blocked: user edits own wallet balance',
    denied(await as(db, X, `update wallets set available_balance = 1000000 where user_id = $1`, [X])));
  check('EXPLOIT blocked: user inserts a wallet',
    denied(await as(db, X, `insert into wallets (user_id, available_balance) values ($1, 5000)`, [X])));
  check('EXPLOIT blocked: user inserts a ledger row',
    denied(await as(db, X, `insert into wallet_transactions (wallet_id, type, amount) select id, 'top_up', 5000 from wallets where user_id = $1`, [X])));
  check('user can read own wallet', (await as(db, X, `select * from wallets`)).rows?.length === 1);

  // featured listings
  const ins = await as(db, X, `insert into marketplace_listings (seller_id, title, price, condition, is_featured, featured_until, hide_phone_number)
    values ($1, 'TV', 100, 'used', true, now() + interval '1 year', false) returning id, is_featured, featured_until`, [X]);
  check('EXPLOIT blocked: listing inserted as featured is stored un-featured',
    ok(ins) && ins.rows[0].is_featured === false && ins.rows[0].featured_until === null, ins);
  const listingId = ins.rows?.[0]?.id;
  check('EXPLOIT blocked: seller sets featured_until directly',
    denied(await as(db, X, `update marketplace_listings set featured_until = now() + interval '1 year' where id = $1`, [listingId])));
  check('seller can still edit own listing text',
    ok(await as(db, X, `update marketplace_listings set title = 'Smart TV' where id = $1`, [listingId])));
  await admin(db, `update profiles set ad_token_balance = 100 where id = $1`, [X]);
  check('feature_listing with tokens still works',
    ok(await as(db, X, `select public.feature_listing('marketplace_listings', $1, 2)`, [listingId])));
  const feat = await admin(db, `select is_featured from marketplace_listings where id = $1`, [listingId]);
  check('listing is featured after paying tokens', feat[0].is_featured === true);

  // ------------------------------------------------------------------
  console.log('\nPhase 2 — joining a building');
  const code = (await as(db, A, `select public.found_building('برج الياسمين','المعادي','القاهرة','القاهرة','1','الأول') as c`)).rows[0].c;
  const bld = (await admin(db, `select building_id from union_members where user_id = $1`, [A]))[0].building_id;
  check('A founded a building and is its president',
    (await admin(db, `select role, status from union_members where user_id = $1`, [A]))[0].role === 'president');

  // B asks to join by picking the building id (the old takeover path) for a NEW unit 2
  check('B requests to join existing building',
    ok(await as(db, B, `select public.found_building('x','x','x','x','2','الثاني', null, null, null, true, $1)`, [bld])));
  // X tries the old attack: request A's own unit 1 and immediately act as its owner
  await as(db, X, `select public.found_building('x','x','x','x','1','الأول', null, null, null, true, $1)`, [bld]);
  const unit1 = (await admin(db, `select id from units where building_id = $1 and unit_number = '1'`, [bld]))[0].id;
  const unit2 = (await admin(db, `select id from units where building_id = $1 and unit_number = '2'`, [bld]))[0].id;
  check('EXPLOIT blocked: pending request gives no residency on the unit',
    (await admin(db, `select 1 from unit_residents where user_id = $1`, [X])).length === 0);
  check('EXPLOIT blocked: pending requester cannot invite a tenant into A\'s unit',
    denied(await as(db, X, `select public.invite_tenant_for_unit($1)`, [unit1])));
  check('EXPLOIT blocked: pending requester cannot issue a visitor pass',
    denied(await as(db, X, `insert into visitor_passes (unit_id, issued_by, visitor_name, pass_type, valid_until) values ($1, $2, 'v', 'guest', now() + interval '2 hours')`, [unit1, X])));
  check('EXPLOIT blocked: pending requester cannot trigger SOS',
    denied(await as(db, X, `insert into sos_alerts (unit_id, triggered_by, type) values ($1, $2, 'fire')`, [unit1, X])));
  check('EXPLOIT blocked: pending requester cannot post to the building',
    denied(await as(db, X, `insert into posts (building_id, author_id, body) values ($1, $2, 'hi')`, [bld, X])));

  const bReq = (await admin(db, `select id from union_members where user_id = $1`, [B]))[0].id;
  const xReq = (await admin(db, `select id from union_members where user_id = $1`, [X]))[0].id;
  check('A approves B', ok(await as(db, A, `select public.review_union_member($1, true)`, [bReq])));
  const bRes = await admin(db, `select residency_type, is_primary from unit_residents where user_id = $1`, [B]);
  check('approval gives B primary-owner residency on unit 2', bRes.length === 1 && bRes[0].is_primary === true, bRes);
  check('reviewing an already-reviewed request is refused', denied(await as(db, A, `select public.review_union_member($1, false)`, [bReq])));
  const aMember = (await admin(db, `select id from union_members where user_id = $1`, [A]))[0].id;
  check('EXPLOIT blocked: a board member cannot "reject" the verified president',
    denied(await as(db, A, `select public.review_union_member($1, false)`, [aMember])));
  check('A approves X (who asked for A\'s own unit 1)', ok(await as(db, A, `select public.review_union_member($1, true)`, [xReq])));
  const xRes = await admin(db, `select residency_type, is_primary from unit_residents where user_id = $1`, [X]);
  check('second owner of unit 1 becomes a co-owner, NOT primary', xRes.length === 1 && xRes[0].is_primary === false, xRes);
  check('co-owner cannot invite tenants to unit 1', denied(await as(db, X, `select public.invite_tenant_for_unit($1)`, [unit1])));

  // C joins with the building invite code as a tenant of unit 2
  check('C joins with invite code', ok(await as(db, C, `select public.join_building_with_code($1, '3', 'الثالث', 'owner')`, [code])));
  const cReq = (await admin(db, `select id from union_members where user_id = $1`, [C]))[0].id;
  check('C has no residency until approved', (await admin(db, `select 1 from unit_residents where user_id = $1`, [C])).length === 0);
  await as(db, A, `select public.review_union_member($1, true)`, [cReq]);

  // ------------------------------------------------------------------
  console.log('\nPhase 2 — tenants');
  const tenCode = (await as(db, B, `select public.invite_tenant_for_unit($1) as c`, [unit2])).rows?.[0]?.c;
  check('B (verified primary owner) can invite a tenant', !!tenCode);
  check('tenant invite code expires in ~7 days',
    (await admin(db, `select expires_at > now() + interval '6 days' and expires_at < now() + interval '8 days' as ok from tenant_invite_codes where code = $1`, [tenCode]))[0].ok);
  check('T redeems the tenant code', ok(await as(db, T, `select public.join_as_tenant_with_code($1)`, [tenCode])));
  check('T is a verified tenant of unit 2',
    (await admin(db, `select m.status, ur.residency_type from union_members m join unit_residents ur on ur.user_id = m.user_id where m.user_id = $1`, [T]))[0]?.residency_type === 'tenant');
  // tenant cap
  const extra = [];
  for (let i = 0; i < 5; i++) extra.push(await signUp(db, 'ten' + i, null));
  let capHit = false;
  for (const u of extra) {
    const c = (await as(db, B, `select public.invite_tenant_for_unit($1) as c`, [unit2]));
    if (c.error) { capHit = true; break; }
    await as(db, u, `select public.join_as_tenant_with_code($1)`, [c.rows[0].c]);
  }
  check('tenant cap: a unit cannot exceed 5 tenants', capHit &&
    (await admin(db, `select count(*)::int n from unit_residents where unit_id = $1 and residency_type = 'tenant'`, [unit2]))[0].n === 5);

  // ------------------------------------------------------------------
  console.log('\nPhase 2 — visitor passes & SOS');
  const pass = await as(db, B, `insert into visitor_passes (unit_id, issued_by, visitor_name, pass_type, qr_code, valid_until)
    values ($1, $2, 'ضيف', 'guest', 'MY-CHOSEN-CODE', now() + interval '30 days') returning id, qr_code, valid_until, status`, [unit2, B]);
  check('verified owner can issue a visitor pass', ok(pass), pass);
  check('pass code is generated by the server, not the client', pass.rows?.[0]?.qr_code !== 'MY-CHOSEN-CODE' && pass.rows?.[0]?.qr_code.startsWith('PASS-'));
  check('pass validity is capped at 48h', new Date(pass.rows?.[0]?.valid_until) <= new Date(Date.now() + 48 * 3600e3 + 60e3));
  const passId = pass.rows?.[0]?.id;
  check('EXPLOIT blocked: issuer extends a pass', denied(await as(db, B, `update visitor_passes set valid_until = now() + interval '1 year' where id = $1`, [passId])));
  await admin(db, `update visitor_passes set status = 'used' where id = $1`, [passId]);
  check('EXPLOIT blocked: issuer re-activates a used pass', denied(await as(db, B, `update visitor_passes set status = 'active' where id = $1`, [passId])));
  const pass2 = (await as(db, B, `insert into visitor_passes (unit_id, issued_by, visitor_name, pass_type, valid_until) values ($1, $2, 'v', 'delivery', now() + interval '2 hours') returning id`, [unit2, B])).rows[0].id;
  check('issuer can revoke an active pass', ok(await as(db, B, `update visitor_passes set status = 'revoked' where id = $1`, [pass2])));

  const sos = await as(db, B, `insert into sos_alerts (unit_id, triggered_by, type) values ($1, $2, 'fire') returning id`, [unit2, B]);
  check('verified member can trigger SOS', ok(sos), sos);
  check('EXPLOIT blocked: SOS type changed after the fact', denied(await as(db, B, `update sos_alerts set type = 'medical' where id = $1`, [sos.rows?.[0]?.id])));
  const sosNotes = await admin(db, `select user_id from notifications where title like '🚨 استغاثة%'`);
  check('SOS notifies the building\'s verified members (not the sender)',
    sosNotes.some((n) => n.user_id === A) && sosNotes.some((n) => n.user_id === X) && !sosNotes.some((n) => n.user_id === B), sosNotes.length);
  check('SOS reaches tenants too, but not people outside the building', sosNotes.some((n) => n.user_id === T) && !sosNotes.some((n) => n.user_id === dup));
  check('triggerer can cancel (false alarm)', ok(await as(db, B, `update sos_alerts set status = 'false_alarm' where id = $1`, [sos.rows?.[0]?.id])));
  check('cancelling notifies the building too',
    (await admin(db, `select 1 from notifications where user_id = $1 and title like 'تم إلغاء الاستغاثة%'`, [A])).length === 1);

  // ------------------------------------------------------------------
  console.log('\nPhase 2 — announcements');
  check('verified resident can post a normal post', ok(await as(db, B, `insert into posts (building_id, author_id, body) values ($1, $2, 'مرحبا')`, [bld, B])));
  check('EXPLOIT blocked: resident posts an official pinned announcement',
    denied(await as(db, B, `insert into posts (building_id, author_id, body, type, is_pinned) values ($1, $2, 'ادفعوا على 010', 'official', true)`, [bld, B])));
  check('president can post an official pinned announcement',
    ok(await as(db, A, `insert into posts (building_id, author_id, body, type, is_pinned) values ($1, $2, 'اجتماع', 'official', true)`, [bld, A])));
  const outsider = await signUp(db, 'stranger', null);
  check('EXPLOIT blocked: outsider posts into the building', denied(await as(db, outsider, `insert into posts (building_id, author_id, body) values ($1, $2, 'spam')`, [bld, outsider])));

  // ------------------------------------------------------------------
  console.log('\nPhase 2 — elections');
  check('election shorter than a day is refused', denied(await as(db, A, `select public.create_election('e', now() + interval '1 hour', 0)`)));
  const e1 = await as(db, A, `select public.create_election('انتخاب', now() + interval '3 days', 0) as id`);
  check('president creates an election', ok(e1), e1);
  const e1id = e1.rows?.[0]?.id;
  const e1row = (await admin(db, `select legal_quorum_pct::float q, eligible_voters from union_elections where id = $1`, [e1id]))[0];
  check('quorum is fixed at 50% even when creator asks for 0%', e1row.q === 50, e1row);
  // primary owners: A (unit 1), B (unit 2), C (unit 3). X = co-owner, T + 5 = tenants
  check('eligible voters = one per unit with a primary owner (3)', e1row.eligible_voters === 3, e1row);
  check('a second open election is refused', denied(await as(db, A, `select public.create_election('again', now() + interval '3 days')`)));
  check('tenant cannot nominate', denied(await as(db, T, `select public.nominate_self($1, 'x')`, [e1id])));
  const candA = (await as(db, A, `select public.nominate_self($1, 'A') as id`, [e1id])).rows[0].id;
  const candB = (await as(db, B, `select public.nominate_self($1, 'B') as id`, [e1id])).rows[0].id;
  check('EXPLOIT blocked: tenant votes', denied(await as(db, T, `select public.cast_election_vote($1, $2)`, [e1id, candA])));
  check('EXPLOIT blocked: co-owner votes (unit 1 already has its primary owner\'s vote)', denied(await as(db, X, `select public.cast_election_vote($1, $2)`, [e1id, candA])));
  check('primary owner A votes', ok(await as(db, A, `select public.cast_election_vote($1, $2)`, [e1id, candA])));
  check('EXPLOIT blocked: finalize before voting closes', denied(await as(db, A, `select public.finalize_election($1)`, [e1id])));
  await as(db, B, `select public.cast_election_vote($1, $2)`, [e1id, candB]);
  await admin(db, `update union_elections set closes_at = now() - interval '1 minute' where id = $1`, [e1id]);
  check('finalize after closing works', ok(await as(db, A, `select public.finalize_election($1)`, [e1id])));
  check('1–1 tie: nobody wins, A stays president',
    (await admin(db, `select role from union_members where user_id = $1`, [A]))[0].role === 'president');

  const e2id = (await as(db, A, `select public.create_election('انتخاب 2', now() + interval '3 days') as id`)).rows[0].id;
  const c2A = (await as(db, A, `select public.nominate_self($1, 'A') as id`, [e2id])).rows[0].id;
  const c2B = (await as(db, B, `select public.nominate_self($1, 'B') as id`, [e2id])).rows[0].id;
  await as(db, B, `select public.cast_election_vote($1, $2)`, [e2id, c2B]);
  await as(db, C, `select public.cast_election_vote($1, $2)`, [e2id, c2B]);
  await as(db, A, `select public.cast_election_vote($1, $2)`, [e2id, c2A]);
  check('full turnout lets the board finalize early', ok(await as(db, A, `select public.finalize_election($1)`, [e2id])));
  const roles = await admin(db, `select user_id, role from union_members where user_id in ($1, $2)`, [A, B]);
  check('B wins 2–1: B becomes president, A becomes board member',
    roles.find((r) => r.user_id === B).role === 'president' && roles.find((r) => r.user_id === A).role === 'board_member', roles);

  // ------------------------------------------------------------------
  console.log('\nPhase 2 — phone numbers');
  check('EXPLOIT blocked: select phone directly from profiles', denied(await as(db, B, `select phone from profiles`)));
  check('EXPLOIT blocked: select * from profiles', denied(await as(db, B, `select * from profiles`)));
  check('select without phone still works', ok(await as(db, B, `select id, full_name from profiles`)));
  const phones = async (who, ids) => {
    const r = await as(db, who, `select user_id, phone from public.get_contact_phones($1::uuid[])`, [ids]);
    return Object.fromEntries((r.rows || []).map((x) => [x.user_id, x.phone]));
  };
  let p = await phones(outsider, [A, B, C, T]);
  check('outsider sees nobody\'s phone', Object.keys(p).length === 0, p);
  p = await phones(C, [A, B, T]);
  check('ordinary neighbour sees no phones', Object.keys(p).length === 0, p);
  p = await phones(B, [A, C, T]);  // B is now president
  check('president sees building members\' phones', p[A] && p[C] && p[T], p);
  p = await phones(T, [T]);
  check('user sees their own phone', p[T] === '01000000004', p);
  p = await phones(outsider, [X]);
  check('anyone sees a seller\'s phone when their listing shows it', p[X] === '01000000099', p);
  await admin(db, `update marketplace_listings set hide_phone_number = true where seller_id = $1`, [X]);
  p = await phones(outsider, [X]);
  check('seller\'s phone hidden once the listing hides it', !p[X], p);

  // ------------------------------------------------------------------
  console.log('\nPhase 1 — money');
  check('EXPLOIT blocked: negative union due',
    denied(await as(db, B, `select public.create_union_due('x', -1000000, current_date)`)));
  check('president can issue a positive due', ok(await as(db, B, `select public.create_union_due('أكتوبر', 200, current_date)`)));
  const tech = (await as(db, X, `select public.register_technician('سباكة', 'bio', 'المعادي') as id`)).rows[0].id;
  check('EXPLOIT blocked: negative inspection fee',
    denied(await as(db, C, `select public.book_maintenance_service($1, 'سباكة', 'x', -500)`, [tech])));
  check('EXPLOIT blocked: booking yourself',
    denied(await as(db, X, `select public.book_maintenance_service($1, 'سباكة', 'x', 50)`, [tech])));
  await admin(db, `update wallets set available_balance = 100 where user_id = $1`, [C]);
  const req = await as(db, C, `select public.book_maintenance_service($1, 'سباكة', 'x', 50) as id`, [tech]);
  check('resident books a technician with a 50 EGP fee', ok(req), req);
  const reqId = req.rows?.[0]?.id;
  check('technician can send a quote', ok(await as(db, X, `select public.update_request_status($1, 'quoted', 1000000000)`, [reqId])));
  check('resident cancels the quoted job', ok(await as(db, C, `select public.cancel_maintenance_request($1)`, [reqId])));
  const w = (await admin(db, `select available_balance::float a, held_balance::float h from wallets where user_id = $1`, [C]))[0];
  check('EXPLOIT blocked: refund is the 50 actually held, not the 1,000,000,000 quote', w.a === 100 && w.h === 0, w);
  check('EXPLOIT blocked: technician moves a cancelled job back to quoted',
    denied(await as(db, X, `select public.update_request_status($1, 'quoted', 10)`, [reqId])));

  // ------------------------------------------------------------------
  console.log('\nSupport inbox');
  const ticket = await as(db, C, `insert into support_tickets (user_id, category, subject, body) values ($1, 'complaint', 'بلاغ عن إعلان', 'سعر مشبوه') returning id`, [C]);
  check('user files a support ticket', ok(ticket), ticket);
  const ticketId = ticket.rows?.[0]?.id;
  check('another user cannot read it', (await as(db, B, `select id from support_tickets where id = $1`, [ticketId])).rows?.length === 0);
  check('non-admin cannot reply to tickets', denied(await as(db, B, `select public.resolve_support_ticket($1, 'تم')`, [ticketId])));
  const boss = await signUp(db, 'boss', '01000000999');
  await admin(db, `update profiles set role = 'super_admin' where id = $1`, [boss]);
  check('super admin sees the ticket', (await as(db, boss, `select id from support_tickets where id = $1`, [ticketId])).rows?.length === 1);
  check('super admin sees requester names', (await as(db, boss, `select full_name from profiles where id = $1`, [C])).rows?.[0]?.full_name === 'carim');
  check('super admin replies', ok(await as(db, boss, `select public.resolve_support_ticket($1, 'تمت مراجعة الإعلان وحذفه')`, [ticketId])));
  check('the reply reaches the user as a notification',
    (await admin(db, `select 1 from notifications where user_id = $1 and body = 'تمت مراجعة الإعلان وحذفه'`, [C])).length === 1);
  check('ticket is marked resolved', (await admin(db, `select status from support_tickets where id = $1`, [ticketId]))[0].status === 'resolved');

  console.log(`\n${passed} passed, ${failures.length} failed`);
  if (failures.length) {
    console.log('FAILED:\n - ' + failures.join('\n - '));
    process.exit(1);
  }
})().catch((e) => { console.error('HARNESS ERROR', e); process.exit(1); });
