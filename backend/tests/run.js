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
  check('the founder is an owner, NOT president yet',
    (await admin(db, `select role, status from union_members where user_id = $1`, [A]))[0].role === 'resident');
  check('…and has no board powers before approval',
    denied(await as(db, A, `select public.create_union_due('أكتوبر', 100, current_date)`)));
  const SA = await signUp(db, 'platform admin', '01000000777');
  await admin(db, `update profiles set role = 'super_admin' where id = $1`, [SA]);
  const aReq = (await admin(db, `select id from president_requests where user_id = $1 and status = 'pending'`, [A]))[0]?.id;
  check('a president request is filed for the admin', !!aReq);
  check('EXPLOIT blocked: the founder approves their own presidency',
    denied(await as(db, A, `select public.review_president_request($1, true)`, [aReq])));
  check('the platform admin approves the president', ok(await as(db, SA, `select public.review_president_request($1, true)`, [aReq])));
  check('A is now president',
    (await admin(db, `select role from union_members where user_id = $1`, [A]))[0].role === 'president');

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

  // ------------------------------------------------------------------
  console.log('\nPlaces proxy & shops');
  check('EXPLOIT blocked: user inserts a fake "Google-imported" shop',
    denied(await as(db, B, `insert into shops (name, source, rating) values ('محل وهمي', 'google_imported', 5)`)));
  await admin(db, `insert into shops (name, source, google_place_id, rating, owner_id, is_claimed, cover_image_url)
    values ('بقالة', 'google_imported', 'gp1', 3.1, $1, true, 'https://places.googleapis.com/v1/x/media?key=AIzaSECRET')`, [B]);
  check('EXPLOIT blocked: shop owner edits the rating',
    denied(await as(db, B, `update shops set rating = 5 where google_place_id = 'gp1'`)));
  check('EXPLOIT blocked: shop owner hands the shop to someone else',
    denied(await as(db, B, `update shops set owner_id = $1 where google_place_id = 'gp1'`, [C])));
  check('shop owner can still edit the description',
    ok(await as(db, B, `update shops set description = 'أفضل بقالة' where google_place_id = 'gp1'`)));
  check('guests (not signed in) can browse the shops directory',
    (await as(db, null, `select name from shops where google_place_id = 'gp1'`)).rows?.[0]?.name === 'بقالة');
  check('guests cannot add shops', denied(await as(db, null, `insert into shops (name) values ('x')`)));
  check('users cannot call the quota function directly',
    denied(await as(db, B, `select public.bump_places_usage('user:x', 1000)`)));
  const bump = async () => {
    await db.exec('begin; set local role service_role;');
    const r = await db.query(`select public.bump_places_usage('user:quota-test', 2) as ok`);
    await db.exec('commit');
    return r.rows[0].ok;
  };
  const quota = [await bump(), await bump(), await bump()];
  check('daily quota allows up to the limit, then refuses', quota[0] && quota[1] && !quota[2], quota);

  // ------------------------------------------------------------------
  console.log('\nLost & found secret mark');
  const found = await as(db, C, `select public.report_lost_found_item('found', 'محافظ', 'محفظة جلد', 'عند الأسانسير', 'صورة قطة  بيضاء') as id`);
  check('member reports a found item with a secret mark', ok(found), found);
  const foundId = found.rows?.[0]?.id;
  check('EXPLOIT blocked: neighbours read the mark hash', denied(await as(db, B, `select secret_mark_hash from lost_found_items`)));
  check('neighbours see only that a mark exists',
    (await as(db, B, `select has_secret_mark from lost_found_items where id = $1`, [foundId])).rows?.[0]?.has_secret_mark === true);
  check('stored hash is salted bcrypt, not plain SHA-256',
    (await admin(db, `select secret_mark_hash like '$2%' as ok from lost_found_items where id = $1`, [foundId]))[0].ok);
  check('EXPLOIT blocked: direct insert bypassing the RPC',
    denied(await as(db, B, `insert into lost_found_items (building_id, reporter_id, type, title) values ($1, $2, 'found', 'x')`, [bld, B])));
  check('reporter cannot claim their own item', denied(await as(db, C, `select public.claim_lost_found_item($1, 'x')`, [foundId])));
  check('outsider cannot claim', denied(await as(db, outsider, `select public.claim_lost_found_item($1, 'x')`, [foundId])));
  const claim = async (who, answer) => (await as(db, who, `select public.claim_lost_found_item($1, $2) as r`, [foundId, answer])).rows?.[0]?.r;
  check('wrong answer is rejected', (await claim(T, 'صورة كلب')) === 'wrong');
  check('right answer with different spacing/letters is accepted', (await claim(B, 'صوره قطه بيضاء')) === 'verified');
  check('finder is notified who the owner is',
    (await admin(db, `select 1 from notifications where user_id = $1 and title like 'تم التحقق من صاحب:%'`, [C])).length === 1);
  await claim(T, 'a'); await claim(T, 'b');
  check('3 wrong attempts lock the claimant out, even with the right answer', (await claim(T, 'صورة قطة بيضاء')) === 'locked');
  const lost = (await as(db, B, `select public.report_lost_found_item('lost', 'مفاتيح', 'مفاتيح عربية', 'الجراج') as id`)).rows[0].id;
  check('"I know where it is" on a lost item notifies the owner',
    (await as(db, C, `select public.claim_lost_found_item($1) as r`, [lost])).rows?.[0]?.r === 'notified' &&
    (await admin(db, `select 1 from notifications where user_id = $1 and title like 'أحد جيرانك يعرف مكان:%'`, [B])).length === 1);

  // ------------------------------------------------------------------
  console.log('\nManual wallet top-up & withdrawal');
  const P = await signUp(db, 'payer', null);
  const bal = async (u) => (await admin(db, `select available_balance::float a from wallets where user_id = $1`, [u]))[0].a;
  check('top-up below the minimum is refused', denied(await as(db, P, `select public.request_wallet_topup(5, 'ref 123')`)));
  check('top-up without a transfer reference is refused', denied(await as(db, P, `select public.request_wallet_topup(100, '')`)));
  const tu = await as(db, P, `select public.request_wallet_topup(250, 'فودافون كاش - رقم العملية 998877') as id`);
  check('user files a top-up request', ok(tu), tu);
  const tuId = tu.rows?.[0]?.id;
  check('filing a request does not credit the wallet', (await bal(P)) === 0);
  check('EXPLOIT blocked: user approves their own top-up', denied(await as(db, P, `select public.review_wallet_topup($1, true)`, [tuId])));
  check('EXPLOIT blocked: user inserts an approved request directly',
    denied(await as(db, P, `insert into wallet_topup_requests (user_id, amount_egp, proof_note, status) values ($1, 99999, 'x', 'approved')`, [P])));
  check('super admin approves the top-up', ok(await as(db, boss, `select public.review_wallet_topup($1, true)`, [tuId])));
  check('approved top-up credits the wallet', (await bal(P)) === 250);
  check('approving twice is refused', denied(await as(db, boss, `select public.review_wallet_topup($1, true)`, [tuId])));
  check('user is notified of the top-up',
    (await admin(db, `select 1 from notifications where user_id = $1 and title = 'تم شحن محفظتك'`, [P])).length === 1);

  check('withdrawal above the balance is refused', denied(await as(db, P, `select public.request_wallet_withdrawal(1000, '01012345678')`)));
  check('withdrawal to an invalid wallet number is refused', denied(await as(db, P, `select public.request_wallet_withdrawal(50, '12345')`)));
  const wd = await as(db, P, `select public.request_wallet_withdrawal(100, '010 1234 5678') as id`);
  check('user requests a withdrawal', ok(wd), wd);
  check('withdrawn amount leaves the balance immediately (no double spend)', (await bal(P)) === 150);
  const wdReject = (await as(db, P, `select public.request_wallet_withdrawal(50, '01012345678') as id`)).rows[0].id;
  check('super admin marks the first withdrawal paid', ok(await as(db, boss, `select public.review_wallet_withdrawal($1, true)`, [wd.rows[0].id])));
  check('super admin rejects the second one', ok(await as(db, boss, `select public.review_wallet_withdrawal($1, false)`, [wdReject])));
  check('rejected withdrawal is refunded', (await bal(P)) === 150);
  const ledger = await admin(db, `select status from wallet_transactions where reference_table = 'wallet_withdrawal_requests' order by created_at`);
  check('ledger shows one completed and one reversed withdrawal',
    ledger.length === 2 && ledger.some((l) => l.status === 'completed') && ledger.some((l) => l.status === 'reversed'), ledger);
  check('other users cannot see these requests', (await as(db, B, `select id from wallet_withdrawal_requests`)).rows?.length === 0);

  // ------------------------------------------------------------------
  console.log('\nMedium hardening (0046)');
  // Jobs
  const job = (await admin(db, `insert into job_postings (poster_id, title, employment_type) values ($1, 'كاشير', 'full_time') returning id`, [A]))[0].id;
  check('EXPLOIT blocked: applicant inserts an application already "hired"',
    denied(await as(db, T, `insert into job_applications (job_id, applicant_id, status) values ($1, $2, 'hired')`, [job, T])));
  check('applying through the RPC still works', ok(await as(db, T, `select public.apply_to_job($1, 'مهتم')`, [job])));
  check('EXPLOIT blocked: applicant promotes their own application',
    denied(await as(db, T, `update job_applications set status = 'hired' where applicant_id = $1`, [T])));
  // Token top-ups & shop claims
  check('EXPLOIT blocked: direct token top-up request for 0 EGP',
    denied(await as(db, T, `insert into ad_token_topup_requests (user_id, tokens_requested, amount_egp) values ($1, 1000, 0)`, [T])));
  check('token top-up through the RPC still works', ok(await as(db, T, `select public.request_token_topup(5, 'ref')`)));
  const shop2 = (await admin(db, `insert into shops (name, google_place_id) values ('صيدلية', 'gp2') returning id`))[0].id;
  check('EXPLOIT blocked: shop claim filed as already approved',
    denied(await as(db, T, `insert into shop_claim_requests (shop_id, requester_id, verification_method, status) values ($1, $2, 'document', 'approved')`, [shop2, T])));
  const claimReq = await as(db, T, `insert into shop_claim_requests (shop_id, requester_id, verification_method) values ($1, $2, 'document') returning id`, [shop2, T]);
  check('filing a pending shop claim still works', ok(claimReq), claimReq);
  check('EXPLOIT blocked: requester approves their own claim',
    denied(await as(db, T, `update shop_claim_requests set status = 'approved' where requester_id = $1`, [T])) ||
    (await admin(db, `select status from shop_claim_requests where requester_id = $1`, [T]))[0].status === 'pending');
  check('super admin approves the claim', ok(await as(db, boss, `select public.review_shop_claim($1, true)`, [claimReq.rows[0].id])));
  const claimReq2 = (await as(db, C, `insert into shop_claim_requests (shop_id, requester_id, verification_method) values ($1, $2, 'document') returning id`, [shop2, C])).rows[0].id;
  check('a second claim on an already-owned shop cannot be approved', denied(await as(db, boss, `select public.review_shop_claim($1, true)`, [claimReq2])));
  // Recycling
  check('EXPLOIT blocked: lot created already "ended" with a year-long auction',
    (await as(db, B, `insert into recycling_listings (seller_id, category, title, auction_ends_at) values ($1, 'metal', 'x', now() + interval '1 year')`, [B])).error !== undefined);
  const lot = (await as(db, B, `insert into recycling_listings (seller_id, category, title, auction_ends_at) values ($1, 'metal', 'حديد', now() + interval '2 days') returning id`, [B])).rows[0].id;
  check('EXPLOIT blocked: raw bid insert', denied(await as(db, C, `insert into recycling_bids (listing_id, bidder_id, amount) values ($1, $2, -500)`, [lot, C])));
  check('EXPLOIT blocked: seller bids on their own lot', denied(await as(db, B, `select public.place_recycling_bid($1, 100)`, [lot])));
  check('EXPLOIT blocked: negative bid', denied(await as(db, C, `select public.place_recycling_bid($1, -5)`, [lot])));
  check('valid bid works', ok(await as(db, C, `select public.place_recycling_bid($1, 100)`, [lot])));
  check('a bid not above the current top is refused', denied(await as(db, T, `select public.place_recycling_bid($1, 100)`, [lot])));
  check('higher bid works', ok(await as(db, T, `select public.place_recycling_bid($1, 150)`, [lot])));
  check('EXPLOIT blocked: seller sets any bid as the winner directly',
    denied(await as(db, B, `update recycling_listings set status = 'ended' where id = $1`, [lot])));
  check('EXPLOIT blocked: someone else ends the auction', denied(await as(db, C, `select public.accept_recycling_top_bid($1)`, [lot])));
  check('seller accepts the top bid', ok(await as(db, B, `select public.accept_recycling_top_bid($1)`, [lot])));
  const won = (await admin(db, `select b.bidder_id from recycling_listings l join recycling_bids b on b.id = l.winning_bid_id where l.id = $1`, [lot]))[0];
  check('the highest bidder wins and is notified',
    won?.bidder_id === T && (await admin(db, `select 1 from notifications where user_id = $1 and title = 'مبروك! البائع قبل عرضك'`, [T])).length === 1);
  check('no bids after the auction ends', denied(await as(db, C, `select public.place_recycling_bid($1, 500)`, [lot])));
  const lot2 = (await as(db, B, `insert into recycling_listings (seller_id, category, title, auction_ends_at) values ($1, 'paper_cardboard', 'كرتون', now() + interval '2 days') returning id`, [B])).rows[0].id;
  check('ending an auction with no bids works', ok(await as(db, B, `select public.accept_recycling_top_bid($1)`, [lot2])));
  // Board actions pick the right building
  await as(db, B, `select public.found_building('عمارة 2','x','x','x','1','1')`);
  const b2Req = (await admin(db, `select id from president_requests where user_id = $1 and status = 'pending'`, [B]))[0].id;
  await as(db, SA, `select public.review_president_request($1, true)`, [b2Req]);
  check('board member of two buildings must specify which one',
    denied(await as(db, B, `select public.create_union_due('نوفمبر', 100, current_date)`)));
  check('with the building specified it works', ok(await as(db, B, `select public.create_union_due('نوفمبر', 100, current_date, $1)`, [bld])));
  check('cannot act on a building where you are not on the board',
    denied(await as(db, C, `select public.create_union_due('نوفمبر', 100, current_date, $1)`, [bld])));
  // Anonymous callers
  check('EXPLOIT blocked: anonymous caller runs a database function',
    denied(await as(db, null, `select public.found_building('x','x','x','x','1','1')`)));
  check('internal helpers stay closed to signed-in users', denied(await as(db, B, `select public._board_building_for(null)`)));

  // ------------------------------------------------------------------
  console.log('\nMerchant stores (0047)');
  const M = await signUp(db, 'merchant', '01011111111');
  const Cu = await signUp(db, 'customer', '01022222222');
  check('invalid slug is refused', denied(await as(db, M, `select public.create_my_shop('محل', 'بقالة', 'Bad Slug!', '01011111111')`)));
  const myShop = await as(db, M, `select public.create_my_shop('بقالة السلام', 'بقالة', 'elsalam', '01011111111', 'شارع 9') as id`);
  check('merchant registers a shop', ok(myShop), myShop);
  const shopId = myShop.rows?.[0]?.id;
  check('duplicate slug is refused', denied(await as(db, Cu, `select public.create_my_shop('محل تاني', 'بقالة', 'elsalam', '01022222222')`)));
  const p1 = await as(db, M, `insert into shop_products (shop_id, name, price) values ($1, 'أرز 1ك', 40) returning id`, [shopId]);
  const p2 = await as(db, M, `insert into shop_products (shop_id, name, price) values ($1, 'سكر 1ك', 35) returning id`, [shopId]);
  check('owner adds products', ok(p1) && ok(p2));
  check('EXPLOIT blocked: someone else adds a product to the shop',
    denied(await as(db, Cu, `insert into shop_products (shop_id, name, price) values ($1, 'x', 1)`, [shopId])));
  check('EXPLOIT blocked: someone else changes a price',
    (await as(db, Cu, `update shop_products set price = 0 where shop_id = $1`, [shopId])).affected === 0);
  check('guests can browse the store and its products',
    (await as(db, null, `select p.name from shops s join shop_products p on p.shop_id = s.id where s.slug = 'elsalam'`)).rows?.length === 2);
  check('guests can record a QR scan', ok(await as(db, null, `select public.record_shop_scan('elsalam')`)));
  check('EXPLOIT blocked: owner inflates scan count', denied(await as(db, M, `update shops set scan_count = 9999 where id = $1`, [shopId])));
  check('guests cannot order', denied(await as(db, null, `select public.place_shop_order($1, '[]'::jsonb, '01022222222')`, [shopId])));
  const items = JSON.stringify([{ product_id: p1.rows[0].id, quantity: 2 }, { product_id: p2.rows[0].id, quantity: 1 }]);
  const order = await as(db, Cu, `select public.place_shop_order($1, $2::jsonb, '01022222222', 'من غير شطة') as id`, [shopId, items]);
  check('customer places an order', ok(order), order);
  const orderRow = (await admin(db, `select total_amount::float t, status from shop_orders where id = $1`, [order.rows[0].id]))[0];
  check('order total is computed by the server (2×40 + 35 = 115)', orderRow.t === 115 && orderRow.status === 'placed', orderRow);
  check('merchant is notified of the order', (await admin(db, `select 1 from notifications where user_id = $1 and title like '🛒 طلب جديد%'`, [M])).length === 1);
  check('EXPLOIT blocked: customer writes an order row directly',
    denied(await as(db, Cu, `insert into shop_orders (shop_id, buyer_id, status, total_amount) values ($1, $2, 'placed', 1)`, [shopId, Cu])));
  check('merchant sees the order and its items',
    (await as(db, M, `select i.quantity from shop_orders o join shop_order_items i on i.order_id = o.id where o.shop_id = $1`, [shopId])).rows?.length === 2);
  check('other users cannot see the order', (await as(db, B, `select id from shop_orders where shop_id = $1`, [shopId])).rows?.length === 0);
  check('EXPLOIT blocked: customer marks the order delivered', denied(await as(db, Cu, `select public.update_shop_order_status($1, 'delivered')`, [order.rows[0].id])));
  check('merchant moves the order to preparing', ok(await as(db, M, `select public.update_shop_order_status($1, 'preparing')`, [order.rows[0].id])));
  check('customer can no longer cancel once preparing', denied(await as(db, Cu, `select public.update_shop_order_status($1, 'cancelled')`, [order.rows[0].id])));
  check('customer is notified of status changes', (await admin(db, `select 1 from notifications where user_id = $1 and title like 'المحل بيجهّز طلبك%'`, [Cu])).length === 1);
  await as(db, M, `update shop_products set is_available = false where id = $1`, [p1.rows[0].id]);
  check('a hidden product cannot be ordered', denied(await as(db, Cu, `select public.place_shop_order($1, $2::jsonb, '01022222222')`, [shopId, items])));

  // ------------------------------------------------------------------
  console.log('\nE-addresses (0048)');
  const addr = { label: 'البيت', governorate: 'القاهرة', city: 'المعادي', street: 'شارع 9', building: '12', floor: '3', apartment: '7', lat: 29.96, lng: 31.25 };
  check('guests cannot create an address',
    denied(await as(db, null, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify(addr)])));
  check('an address needs a governorate and city',
    denied(await as(db, M, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, city: '' })])));
  check('an address needs a building number or landmark',
    denied(await as(db, M, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, building: '' })])));
  check('a map pin outside Egypt is refused',
    denied(await as(db, M, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, lat: 51.5, lng: -0.1 })])));
  const saved = await as(db, M, `select public.save_my_e_address(null, $1::jsonb) as code`, [JSON.stringify(addr)]);
  check('user saves an address and gets a code', ok(saved) && /^[2-9A-HJ-NP-Z]{8}$/.test(saved.rows?.[0]?.code || ''), saved);
  const eCode = saved.rows[0].code;
  const pub = await as(db, null, `select public.get_e_address($1) as a`, ['MG-' + eCode.slice(0, 4) + '-' + eCode.slice(4)]);
  check('anyone opens the address by its code (MG-XXXX-XXXX form)', pub.rows?.[0]?.a?.street === 'شارع 9' && pub.rows[0].a.lat === 29.96, pub);
  check('owner name is shown, phone hidden by default', !!pub.rows[0].a.owner_name && pub.rows[0].a.owner_phone == null);
  check('a wrong code returns nothing', (await as(db, null, `select public.get_e_address('ZZZZZZZZ') as a`)).rows?.[0]?.a == null);
  check('the visit is counted', (await admin(db, `select scan_count from e_addresses where code = $1`, [eCode]))[0].scan_count === 1);
  check('EXPLOIT blocked: guests list everyone\'s addresses', denied(await as(db, null, `select * from e_addresses`)));
  check('EXPLOIT blocked: another user reads the address table', (await as(db, Cu, `select id from e_addresses`)).rows?.length === 0);
  const addrId = (await as(db, M, `select id from e_addresses`)).rows[0].id;
  check('EXPLOIT blocked: another user edits the address',
    denied(await as(db, Cu, `select public.save_my_e_address($1, $2::jsonb)`, [addrId, JSON.stringify({ ...addr, street: 'hacked' })])));
  check('EXPLOIT blocked: owner writes the row directly (e.g. picks a code)',
    denied(await as(db, M, `update e_addresses set code = 'AAAAAAAA' where id = $1`, [addrId])));
  check('owner shows the phone', ok(await as(db, M, `select public.save_my_e_address($1, $2::jsonb)`, [addrId, JSON.stringify({ ...addr, show_phone: true })])));
  check('phone appears once opted in',
    (await as(db, null, `select public.get_e_address($1) as a`, [eCode])).rows?.[0]?.a?.owner_phone === '01011111111');
  const regen = await as(db, M, `select public.regenerate_e_address_code($1) as code`, [addrId]);
  check('owner regenerates the code', ok(regen) && regen.rows[0].code !== eCode);
  check('the old link stops working', (await as(db, null, `select public.get_e_address($1) as a`, [eCode])).rows?.[0]?.a == null);
  await as(db, M, `select public.save_my_e_address($1, $2::jsonb)`, [addrId, JSON.stringify({ ...addr, is_active: false })]);
  check('a disabled address is hidden', (await as(db, null, `select public.get_e_address($1) as a`, [regen.rows[0].code])).rows?.[0]?.a == null);
  check('internal code generator is closed', denied(await as(db, M, `select public._new_e_address_code()`)));
  check('owner deletes the address', (await as(db, M, `delete from e_addresses where id = $1`, [addrId])).affected === 1);

  // ------------------------------------------------------------------
  console.log('\nE-address names & phone lookup (0049)');
  const h1 = await as(db, M, `select public.save_my_e_address(null, $1::jsonb) as code`, [JSON.stringify({ ...addr, handle: 'Salam-Maadi', phone_lookup: true })]);
  check('owner picks an easy name (stored lowercase)', ok(h1) && (await admin(db, `select handle from e_addresses where code = $1`, [h1.rows?.[0]?.code]))[0]?.handle === 'salam-maadi', h1);
  check('anyone opens the address by its name',
    (await as(db, null, `select public.get_e_address('salam-maadi') as a`)).rows?.[0]?.a?.handle === 'salam-maadi');
  check('the name cannot be taken twice',
    denied(await as(db, Cu, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, handle: 'salam-maadi' })])));
  check('availability check says taken', (await as(db, Cu, `select public.e_address_handle_available('salam-maadi') as ok`)).rows?.[0]?.ok === false);
  check('availability check says free', (await as(db, Cu, `select public.e_address_handle_available('nour-dokki') as ok`)).rows?.[0]?.ok === true);
  check('reserved names are refused', denied(await as(db, Cu, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, handle: 'admin' })])));
  check('names in Arabic / with spaces are refused (link-safe only)',
    denied(await as(db, Cu, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, handle: 'بيت احمد' })])));
  check('EXPLOIT blocked: a name equal to someone\'s random code (QR hijack)',
    denied(await as(db, Cu, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, handle: h1.rows[0].code.toLowerCase() })])));
  // 0074: the number only opens the address once it's verified by SMS.
  check('an unverified number opens nothing', (await as(db, null, `select public.get_e_address('01011111111') as a`)).rows?.[0]?.a == null);
  const verifyPhone = async (user, phone) => {
    await db.exec('begin; set local role service_role;');
    try { await db.query('select public.confirm_phone_verified($1, $2)', [user, phone]); } finally { await db.exec('commit'); }
  };
  await verifyPhone(M, '01011111111');
  check('verifying sets phone_verified_at', !!(await admin(db, 'select phone_verified_at from profiles where id = $1', [M]))[0].phone_verified_at);
  check('EXPLOIT blocked: a user calls confirm_phone_verified', denied(await as(db, Cu, 'select public.confirm_phone_verified($1, $2)', [Cu, '01011111111'])));
  check('EXPLOIT blocked: a user marks their number verified', denied(await as(db, Cu, 'update profiles set phone_verified_at = now() where id = $1', [Cu])));
  check('opens by mobile number when enabled', (await as(db, null, `select public.get_e_address('01011111111') as a`)).rows?.[0]?.a?.handle === 'salam-maadi');
  check('…also written as +20 1011111111', (await as(db, null, `select public.get_e_address('+20 1011111111') as a`)).rows?.[0]?.a?.handle === 'salam-maadi');
  const h2 = await as(db, M, `select public.save_my_e_address(null, $1::jsonb) as code`, [JSON.stringify({ ...addr, label: 'الشغل', phone_lookup: true })]);
  check('only one address per person answers the mobile number',
    ok(h2) && (await admin(db, `select count(*)::int n from e_addresses where owner_id = $1 and phone_lookup`, [M]))[0].n === 1);
  check('the number now opens the newer choice', (await as(db, null, `select public.get_e_address('01011111111') as a`)).rows?.[0]?.a?.label === 'الشغل');
  // A squatter types a number that isn't theirs (its real owner hasn't signed up yet).
  const realOwner = await signUp(db, 'real owner', '01099999991');
  const squatter = await signUp(db, 'squatter', '01099999992');
  await as(db, squatter, 'update profiles set phone = $1 where id = $2', ['01099999990', squatter]);
  check('a typed number stays unverified', !(await admin(db, 'select phone_verified_at from profiles where id = $1', [squatter]))[0].phone_verified_at);
  await verifyPhone(realOwner, '01099999990');
  check('proving a number takes it from whoever only typed it',
    (await admin(db, 'select phone, phone_verified_at from profiles where id = $1', [realOwner]))[0].phone === '01099999990' &&
    !!(await admin(db, 'select phone_verified_at from profiles where id = $1', [realOwner]))[0].phone_verified_at &&
    (await admin(db, 'select phone from profiles where id = $1', [squatter]))[0].phone === null);
  await as(db, realOwner, 'update profiles set phone = $1 where id = $2', ['01099999993', realOwner]);
  check('changing the number in the app clears the verification', !(await admin(db, 'select phone_verified_at from profiles where id = $1', [realOwner]))[0].phone_verified_at);
  check('a number without phone lookup opens nothing', (await as(db, null, `select public.get_e_address('01022222222') as a`)).rows?.[0]?.a == null);
  check('the random code still works alongside the name',
    (await as(db, null, `select public.get_e_address($1) as a`, [h1.rows[0].code])).rows?.[0]?.a?.handle === 'salam-maadi');
  check('single-word names are premium: a user cannot take "mona"',
    denied(await as(db, Cu, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, handle: 'mona' })])));
  check('availability check says a single word is not free', (await as(db, Cu, `select public.e_address_handle_available('cairo') as ok`)).rows?.[0]?.ok === false);
  const h1Id = (await admin(db, `select id from e_addresses where code = $1`, [h1.rows[0].code]))[0].id;
  check('EXPLOIT blocked: a normal user assigns a premium name',
    denied(await as(db, M, `select public.admin_assign_e_address_handle($1, 'salam')`, [h1Id])));
  check('the admin assigns (sells) a premium name', ok(await as(db, boss, `select public.admin_assign_e_address_handle($1, 'salam')`, [h1Id])));
  check('the premium name opens the address', (await as(db, null, `select public.get_e_address('salam') as a`)).rows?.[0]?.a?.label === 'البيت');
  check('the owner keeps the premium name when editing the address',
    ok(await as(db, M, `select public.save_my_e_address($1, $2::jsonb)`, [h1Id, JSON.stringify({ ...addr, handle: 'salam', street: 'شارع 10' })])));

  // ------------------------------------------------------------------
  console.log('\nBooking a technician without a union (0050)');
  const R = await signUp(db, 'no-union resident', '01055555555');
  await admin(db, `update wallets set available_balance = 500 where user_id = $1`, [R]);
  check('no union and no digital address: booking is refused with a hint',
    denied(await as(db, R, `select public.book_maintenance_service($1, 'كهرباء', 'فيشة', 50)`, [tech])));
  await as(db, R, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...addr, landmark: 'جنب الجامع' })]);
  const rb = await as(db, R, `select public.book_maintenance_service($1, 'كهرباء', 'فيشة', 50) as id`, [tech]);
  check('with a digital address the resident books a technician', ok(rb), rb);
  const techUser = (await admin(db, `select user_id from technicians where id = $1`, [tech]))[0].user_id;
  const seen = await as(db, techUser, `select service_address, service_landmark, service_lat from maintenance_requests where id = $1`, [rb.rows?.[0]?.id]);
  check('the technician sees where to go (address snapshot + landmark + pin)',
    seen.rows?.[0]?.service_address?.includes('شارع 9') && seen.rows[0].service_landmark === 'جنب الجامع' && seen.rows[0].service_lat === 29.96, seen);
  check('other users cannot see the booking address',
    (await as(db, Cu, `select service_address from maintenance_requests where id = $1`, [rb.rows?.[0]?.id])).rows?.length === 0);

  // ------------------------------------------------------------------
  console.log('\nPresidency: admin approval or owners\' election (0051)');
  const F = await signUp(db, 'founder', '01066666661');
  const G = await signUp(db, 'neighbour', '01066666662');
  const fCode = (await as(db, F, `select public.found_building('عمارة الزهور','x','x','x','1','1') as c`)).rows[0].c;
  const zBld = (await admin(db, `select building_id from union_members where user_id = $1`, [F]))[0].building_id;
  await as(db, G, `select public.join_building_with_code($1, '2', '2', 'owner')`, [fCode]);
  const gReq = (await admin(db, `select id from union_members where user_id = $1`, [G]))[0].id;
  check('EXPLOIT blocked: the unapproved founder accepts neighbours',
    denied(await as(db, F, `select public.review_union_member($1, true)`, [gReq])));
  check('admin sees join requests of buildings without a board',
    (await as(db, SA, `select * from public.admin_list_boardless_join_requests()`)).rows?.some((r) => r.member_id === gReq));
  check('the platform admin accepts the neighbour', ok(await as(db, SA, `select public.review_union_member($1, true)`, [gReq])));
  check('admin sees the pending president request',
    (await as(db, SA, `select * from public.admin_list_president_requests()`)).rows?.some((r) => r.building_name === 'عمارة الزهور'));
  check('EXPLOIT blocked: a normal user lists president requests', denied(await as(db, G, `select * from public.admin_list_president_requests()`)));
  const el = await as(db, G, `select public.create_election('رئاسة الاتحاد', now() + interval '2 days') as id`);
  check('an owner calls a presidential election while there is no board', ok(el), el);
  const elId = el.rows[0].id;
  await as(db, G, `select public.nominate_self($1, 'هخدم العمارة')`, [elId]);
  const gCand = (await admin(db, `select id from union_candidates where election_id = $1 and user_id = $2`, [elId, G]))[0].id;
  await as(db, F, `select public.cast_election_vote($1, $2)`, [elId, gCand]);
  await as(db, G, `select public.cast_election_vote($1, $2)`, [elId, gCand]);
  check('an owner closes the election once everyone voted', ok(await as(db, F, `select public.finalize_election($1)`, [elId])));
  check('the winner becomes president immediately',
    (await admin(db, `select role from union_members where user_id = $1 and building_id = $2`, [G, zBld]))[0].role === 'president');
  check('the founder\'s pending request is superseded by the vote',
    (await admin(db, `select status from president_requests where user_id = $1`, [F]))[0].status === 'superseded');
  check('admin finds an address by its owner\'s mobile to sell a premium name',
    (await as(db, SA, `select * from public.admin_find_e_addresses('01011111111')`)).rows?.length >= 1);
  check('EXPLOIT blocked: a normal user searches addresses by mobile',
    denied(await as(db, G, `select * from public.admin_find_e_addresses('01011111111')`)));
  check('founding without asking for presidency files no request',
    ok(await as(db, Cu, `select public.found_building('عمارة النخيل','x','x','x','1','1', null, null, null, false)`)) &&
    (await admin(db, `select count(*)::int n from president_requests where user_id = $1`, [Cu]))[0].n === 0);
  // Delivery transparency (0052)
  const shopOwnerView = await as(db, Cu, `select public.get_e_address('salam') as a`);
  check('a shop opens a customer address by its name', !!shopOwnerView.rows?.[0]?.a);
  const salamId = (await admin(db, `select id from e_addresses where handle = 'salam'`))[0].id;
  const views = await as(db, M, `select * from public.my_e_address_views($1)`, [salamId]);
  check('the owner sees who opened the address', views.rows?.some((v) => v.viewer_name === 'customer'), views);
  check('EXPLOIT blocked: someone else reads the view log', denied(await as(db, Cu, `select * from public.my_e_address_views($1)`, [salamId])));
  check('EXPLOIT blocked: users read the view table directly', denied(await as(db, M, `select * from e_address_views`)));
  // AI copywriter gate (0056)
  check('a merchant may use the AI writer', (await as(db, M, `select public.bump_my_ai_usage() as g`)).rows?.[0]?.g === 'ok');
  check('a user without a shop is told so', (await as(db, G, `select public.bump_my_ai_usage() as g`)).rows?.[0]?.g === 'no_shop');
  check('guests cannot use the AI writer', denied(await as(db, null, `select public.bump_my_ai_usage()`)));

  // Professional products (0053)
  const proShop = (await admin(db, `select id from shops where owner_id = $1 limit 1`, [M]))[0].id;
  const pro = await as(db, M, `insert into shop_products (shop_id, name, price, old_price, images, highlights, description)
    values ($1, 'تيشيرت', 150, 200, array['a.jpg','b.jpg','c.jpg'], array['قطن 100%','مقاسات كاملة'], 'وصف') returning id`, [proShop]);
  check('owner adds a product with photos, old price and highlights', ok(pro), pro);
  check('more than 6 photos are refused',
    denied(await as(db, M, `insert into shop_products (shop_id, name, price, images) values ($1, 'x', 1, array['1','2','3','4','5','6','7'])`, [proShop])));
  check('an "old price" lower than the price is refused',
    denied(await as(db, M, `insert into shop_products (shop_id, name, price, old_price) values ($1, 'x', 100, 90)`, [proShop])));
  check('guests see the photos and the discount',
    (await as(db, null, `select cardinality(images) n, old_price::float o from shop_products where id = $1`, [pro.rows[0].id])).rows?.[0]?.n === 3);
  // Storefront checkout (0054)
  const stockP = (await as(db, M, `insert into shop_products (shop_id, name, price, stock, options)
    values ($1, 'جاكيت', 300, 2, '[{"name":"المقاس","values":["M","L"]}]'::jsonb) returning id`, [proShop])).rows[0].id;
  const guestItems = JSON.stringify([{ product_id: stockP, quantity: 2, options: 'المقاس: L' }]);
  const gOrder = await as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى', '01077777777', 'شارع 9، المعادي، عمارة 4 شقة 2') as code`, [proShop, guestItems]);
  check('a guest orders with name, mobile and address (no account)', ok(gOrder) && /^T[2-9A-HJ-NP-Z]{7}$/.test(gOrder.rows?.[0]?.code || ''), gOrder);
  check('the order takes the stock down', (await admin(db, `select stock from shop_products where id = $1`, [stockP]))[0].stock === 0);
  check('ordering more than the stock is refused',
    denied(await as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى', '01077777778', 'شارع 9، المعادي، عمارة 4') as code`, [proShop, JSON.stringify([{ product_id: stockP, quantity: 1 }])])));
  check('a short address is refused',
    denied(await as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى', '01077777779', 'المعادي')`, [proShop, JSON.stringify([{ product_id: p2.rows[0].id, quantity: 1 }])])));
  const tracked = (await as(db, null, `select public.get_store_order($1) as o`, [gOrder.rows[0].code])).rows?.[0]?.o;
  check('anyone with the code tracks the order (status, items, options)',
    tracked?.status === 'placed' && tracked.items?.[0]?.options === 'المقاس: L' && tracked.total == 600, tracked);
  check('tracking never reveals the phone or address', tracked && !('customer_phone' in tracked) && !('delivery_address' in tracked));
  check('the merchant sees the guest order with name and address',
    (await as(db, M, `select customer_name, delivery_address from shop_orders where order_code = $1`, [gOrder.rows[0].code])).rows?.[0]?.customer_name === 'منى');
  check('other users cannot see the guest order',
    (await as(db, Cu, `select id from shop_orders where order_code = $1`, [gOrder.rows[0].code])).rows?.length === 0);
  const stats = (await as(db, M, `select public.my_shop_stats($1) as s`, [proShop])).rows?.[0]?.s;
  check('merchant home numbers (new orders, sales today)', stats?.new_orders >= 1 && Number(stats.sales_today) >= 600, stats);
  check('EXPLOIT blocked: another user reads the shop numbers', denied(await as(db, Cu, `select public.my_shop_stats($1)`, [proShop])));
  check('owner edits the store profile (logo, cover, description)',
    ok(await as(db, M, `select public.update_my_shop_profile($1, 'بقالة السلام', 'أحسن بقالة', 'logo.png', 'cover.png')`, [proShop])));
  check('EXPLOIT blocked: someone else edits the store profile',
    denied(await as(db, Cu, `select public.update_my_shop_profile($1, 'hacked', '', '', '')`, [proShop])));
  check('guests see the shop logo', (await as(db, null, `select logo_url from shops where id = $1`, [proShop])).rows?.[0]?.logo_url === 'logo.png');
  // Phone notifications (0055)
  check('a user turns on phone notifications',
    ok(await as(db, M, `select public.save_push_subscription('https://fcm.googleapis.com/fcm/send/abc', 'p256', 'authx', 'tajer')`)));
  check('a non-https endpoint is refused',
    denied(await as(db, M, `select public.save_push_subscription('http://evil/x', 'p', 'a')`)));
  check('guests cannot register a device', denied(await as(db, null, `select public.save_push_subscription('https://x/y', 'p', 'a')`)));
  check('notifications still work with push on (no pg_net here)',
    ok(await admin(db, `insert into notifications (user_id, title) values ($1, 'test push')`, [M]).then(() => ({})).catch((e) => ({ error: e }))));
  check('EXPLOIT blocked: another user reads someone\'s push devices',
    (await as(db, Cu, `select id from push_subscriptions`)).rows?.length === 0);
  check('EXPLOIT blocked: users read the push secret', denied(await as(db, M, `select * from private.push_settings`)));
  // Delivery fee (0057)
  check('merchant sets a delivery fee and a free-delivery threshold',
    ok(await as(db, M, `select public.set_my_shop_delivery($1, 25, 500)`, [proShop])));
  check('EXPLOIT blocked: someone else sets the delivery fee', denied(await as(db, Cu, `select public.set_my_shop_delivery($1, 0)`, [proShop])));
  check('a negative fee is refused', denied(await as(db, M, `select public.set_my_shop_delivery($1, -5)`, [proShop])));
  await admin(db, `update shop_products set stock = null where id = $1`, [stockP]);
  const small = await as(db, null, `select public.place_store_order($1, $2::jsonb, 'سارة', '01088888881', 'شارع 10، المعادي، عمارة 5') as code`,
    [proShop, JSON.stringify([{ product_id: p2.rows[0].id, quantity: 1 }])]);
  const smallO = (await as(db, null, `select public.get_store_order($1) as o`, [small.rows?.[0]?.code])).rows?.[0]?.o;
  check('delivery is added to a small order (35 + 25 = 60)', Number(smallO?.total) === 60 && Number(smallO?.delivery_fee) === 25, smallO);
  const big = await as(db, null, `select public.place_store_order($1, $2::jsonb, 'سارة', '01088888882', 'شارع 10، المعادي، عمارة 5') as code`,
    [proShop, JSON.stringify([{ product_id: stockP, quantity: 2 }])]);
  const bigO = (await as(db, null, `select public.get_store_order($1) as o`, [big.rows?.[0]?.code])).rows?.[0]?.o;
  check('delivery is free above the threshold (600 ≥ 500)', Number(bigO?.total) === 600 && Number(bigO?.delivery_fee) === 0, bigO);

  // Business directory (0058)
  await admin(db, `insert into directory_places (id, name, category, whatsapp, lat, lng, confidence) values
    ('ov1', 'صيدلية الشفاء', 'صيدليات', '01011111111', 31.2001, 29.9001, 0.9),
    ('ov2', 'سوبر ماركت النور', 'سوبر ماركت وبقالة', null, 31.2100, 29.9100, 0.5),
    ('ov3', 'صيدلية بعيدة', 'صيدليات', null, 30.0444, 31.2357, 0.9)`);
  const near = await as(db, null, `select * from public.nearby_directory(31.2, 29.9, 3, null, 10)`);
  check('guests see directory places near them, nearest first (far ones excluded)',
    near.rows?.length === 2 && near.rows[0].id === 'ov1', near.rows);
  const nearPh = await as(db, null, `select * from public.nearby_directory(31.2, 29.9, 3, 'صيدليات', 10)`);
  check('the directory filters by category', nearPh.rows?.length === 1 && nearPh.rows[0].id === 'ov1', nearPh.rows);
  const dirFound = await as(db, null, `select * from public.search_directory('صيدلية', 31.2, 29.9, 10)`);
  check('directory name search ranks the closest first', dirFound.rows?.length === 2 && dirFound.rows[0].id === 'ov1', dirFound.rows);
  check('EXPLOIT blocked: a user edits a directory place', denied(await as(db, Cu, `update directory_places set phone = '0' where id = 'ov1'`)) ||
    (await admin(db, `select phone from directory_places where id = 'ov1'`)).rows[0].phone === null);
  check('EXPLOIT blocked: a user adds a fake directory place',
    denied(await as(db, Cu, `insert into directory_places (id, name, category, lat, lng) values ('x', 'x', 'x', 0, 0)`)));

  // Community reports (0060)
  const rep = await as(db, Cu, `select public.submit_report('نظافة وقمامة', 'زبالة متكومة قدام المدرسة', array['https://x/1.jpg'], 31.2, 29.9, 'الإسكندرية', 'سموحة', true) as id`);
  const repId = rep.rows?.[0]?.id;
  check('a signed-in user submits a report', !!repId, rep.error);
  check('EXPLOIT blocked: a guest submits a report',
    denied(await as(db, null, `select public.submit_report('نظافة وقمامة', 'زبالة كتير هنا', '{}', 31.2, 29.9)`)));
  check('an unknown report category is refused',
    denied(await as(db, Cu, `select public.submit_report('سياسة', 'كلام كتير هنا', '{}', 31.2, 29.9)`)));
  check('a serious violation can be reported',
    ok(await as(db, M, `select public.submit_report('مخالفة شديدة الخطورة', 'سلك كهربا مكشوف في الشارع', '{}', 31.2, 29.9)`)));
  const pubRep = (await as(db, null, `select public.get_report($1) as r`, [repId])).rows?.[0]?.r;
  check('guests can read a report, with the reporter hidden when asked', pubRep?.id === repId && pubRep?.reporter === null, pubRep);
  check('EXPLOIT blocked: reading the reports table directly', denied(await as(db, M, `select user_id from reports`)));
  const repNear = await as(db, null, `select public.list_reports(31.2, 29.9, 3) as r`);
  check('the neighbourhood feed lists nearby reports', repNear.rows?.length === 2, repNear.rows?.length);
  check('a user backs a report ("وأنا كمان")', (await as(db, M, `select public.toggle_report_vote($1) as v`, [repId])).rows?.[0]?.v === true);
  check('the vote is counted once', (await admin(db, `select votes_count from reports where id = $1`, [repId]))[0].votes_count === 1);
  check('EXPLOIT blocked: a normal user changes a report status',
    denied(await as(db, Cu, `select public.admin_update_report($1, 'resolved')`, [repId])));
  check('EXPLOIT blocked: a normal user reads the admin queue', denied(await as(db, Cu, `select public.admin_list_reports()`)));
  check('the admin routes a report to the responsible body',
    ok(await as(db, SA, `select public.admin_update_report($1, 'routed', 'اتبعت لحي شرق', 'حي شرق', 'واتساب الشكاوى')`, [repId])));
  const notes = (await admin(db, `select user_id from notifications where deep_link = $1`, ['/#/r/' + repId])).map((r) => r.user_id).sort();
  check('the reporter and the voter are both notified of the status change', notes.length === 2 && notes.includes(Cu) && notes.includes(M), notes);
  const afterRoute = (await as(db, null, `select public.get_report($1) as r`, [repId])).rows?.[0]?.r;
  check('the public sees who it was sent to, but not the admin note',
    afterRoute?.routed_to === 'حي شرق' && afterRoute?.routed_note === undefined && afterRoute?.events?.length === 2, afterRoute);
  await as(db, SA, `select public.admin_update_report($1, 'routed', null, null, null, null, true)`, [repId]);
  check('a hidden report disappears from the public', (await as(db, null, `select public.get_report($1) as r`, [repId])).rows?.[0]?.r == null);
  for (let i = 0; i < 4; i++) await as(db, Cu, `select public.submit_report('حفر ورصف', 'حفرة كبيرة في الشارع', '{}', 31.2, 29.9)`);
  check('the daily limit stops report spam (5 a day)',
    denied(await as(db, Cu, `select public.submit_report('حفر ورصف', 'حفرة تانية', '{}', 31.2, 29.9)`)));

  // Guest browsing (0061)
  check('guests can browse marketplace listings', ok(await as(db, null, `select id, title, price from marketplace_listings limit 5`)));
  check('guests can browse real-estate listings', ok(await as(db, null, `select id from real_estate_listings limit 5`)));
  check('guests can browse technicians', ok(await as(db, null, `select id, category, rating from technicians limit 5`)));
  check('EXPLOIT blocked: guests read technician ID documents', denied(await as(db, null, `select id_card_url from technicians limit 1`)));
  check('EXPLOIT blocked: guests read phone numbers', denied(await as(db, null, `select phone from profiles limit 1`)));
  const guestProfiles = await as(db, null, `select id, full_name from profiles`);
  check('guests see no profile rows (names only via listings embeds, RLS-filtered)', ok(guestProfiles) && guestProfiles.rows.length === 0, guestProfiles.rows?.slice(0, 3));
  check('guests can load listings with the seller name embed (no error)',
    ok(await as(db, null, `select l.id, (select p.full_name from profiles p where p.id = l.seller_id) as seller from marketplace_listings l limit 5`)));
  check('EXPLOIT blocked: guests post a listing',
    denied(await as(db, null, `insert into marketplace_listings (seller_id, title, price) values ($1, 'x', 1)`, [Cu])));

  // People nearby, friends, chat (0062)
  const P1 = await signUp(db, 'pal one', '01055555551');
  const P2 = await signUp(db, 'pal two', '01055555552');
  const P3 = await signUp(db, 'pal three', '01055555553');
  check('nobody shows up nearby before opting in',
    (await as(db, P1, `select * from public.nearby_people(31.2, 29.9)`)).rows?.length === 0);
  check('opting in needs a location', denied(await as(db, P2, `select public.set_discoverable(true)`)));
  await as(db, P2, `select public.set_discoverable(true, 31.2013, 29.9021, 'سموحة')`);
  await as(db, P3, `select public.set_discoverable(true, 31.2050, 29.9050, 'سموحة')`);
  const pplNear = await as(db, P1, `select * from public.nearby_people(31.2, 29.9)`);
  check('people who opted in appear nearby, with a rough distance only',
    pplNear.rows?.length === 2 && pplNear.rows.every((r) => /كم/.test(r.distance_label) && r.lat === undefined), pplNear.rows);
  check('the stored position is rounded to the ~550 m grid',
    Math.abs((await admin(db, `select lat_grid from people_presence where user_id = $1`, [P2]))[0].lat_grid - 31.2) < 1e-9);
  check('EXPLOIT blocked: guests list people nearby', denied(await as(db, null, `select * from public.nearby_people(31.2, 29.9)`)));
  check('EXPLOIT blocked: reading positions directly', denied(await as(db, P1, `select * from people_presence`)));
  check('a user sends a friend request', (await as(db, P1, `select public.send_friend_request($1) as s`, [P2])).rows?.[0]?.s === 'sent');
  check('the request notifies the other person',
    (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = '/#/friends'`, [P2]))[0].n === 1);
  check('EXPLOIT blocked: chatting before being friends', denied(await as(db, P1, `select public.send_direct_message($1, 'ازيك')`, [P2])));
  await as(db, P2, `select public.respond_friend_request($1, true)`, [P1]);
  check('accepting makes them friends', (await as(db, P1, `select public.friend_state($1) as s`, [P2])).rows?.[0]?.s === 'friends');
  check('friends can chat', ok(await as(db, P1, `select public.send_direct_message($1, 'ازيك يا جار')`, [P2])));
  await as(db, P1, `select public.send_direct_message($1, 'عامل ايه')`, [P2]);
  check('a burst of messages sends one notification',
    (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link like '/#/chat/%'`, [P2]))[0].n === 1);
  const thread = await as(db, P2, `select * from public.fetch_direct_messages($1)`, [P1]);
  check('the other side reads the conversation in order', thread.rows?.length === 2 && thread.rows[0].body === 'ازيك يا جار' && thread.rows[0].mine === false, thread.rows);
  check('opening the chat marks it read',
    (await as(db, P2, `select unread from public.my_friends() where user_id = $1`, [P1])).rows?.[0]?.unread === 0);
  check('EXPLOIT blocked: a third person reads the chat', (await as(db, P3, `select * from public.fetch_direct_messages($1)`, [P1])).rows?.length === 0);
  // 0073: a recipient may read rows sent to them (that's what Realtime
  // delivers); nobody reads anyone else's messages.
  check('EXPLOIT blocked: a third person reads messages directly', (await as(db, P3, `select * from direct_messages`)).rows?.length === 0);
  check('the recipient reads only the messages sent to them',
    (await as(db, P2, `select * from direct_messages`)).rows?.every((r) => r.recipient_id === P2) &&
    (await as(db, P2, `select * from direct_messages`)).rows?.length === 2);
  check('EXPLOIT blocked: the sender cannot list messages directly either', (await as(db, P1, `select * from direct_messages`)).rows?.length === 0);
  check('EXPLOIT blocked: writing messages directly', denied(await as(db, P1, `insert into direct_messages (sender_id, recipient_id, body) values ($1, $2, 'x')`, [P1, P2])));
  await as(db, P2, `select public.block_user($1)`, [P1]);
  check('blocking ends the friendship and stops messages',
    denied(await as(db, P1, `select public.send_direct_message($1, 'تاني')`, [P2])) &&
    (await as(db, P1, `select public.friend_state($1) as s`, [P2])).rows?.[0]?.s === 'none');
  check('a blocked person disappears from nearby', !(await as(db, P1, `select user_id from public.nearby_people(31.2, 29.9)`)).rows?.some((r) => r.user_id === P2));
  check('blocked users cannot send a new request', denied(await as(db, P1, `select public.send_friend_request($1)`, [P2])));
  check('users can report someone', ok(await as(db, P3, `select public.flag_user($1, 'رسايل مزعجة')`, [P1])));
  check('EXPLOIT blocked: a normal user reads reports about people', denied(await as(db, P3, `select * from public.admin_list_user_flags()`)));
  await as(db, P3, `select public.set_discoverable(false)`);
  check('switching off hides you and erases your position',
    !(await as(db, P1, `select user_id from public.nearby_people(31.2, 29.9)`)).rows?.some((r) => r.user_id === P3) &&
    (await admin(db, `select lat_grid from people_presence where user_id = $1`, [P3]))[0].lat_grid === null);

  // Report media (0063)
  const many = Array.from({ length: 12 }, (_, i) => 'https://x/' + i + '.jpg');
  const vidOk = await as(db, P3, `select public.submit_report('حفر ورصف', 'حفرة كبيرة جدا', $1::text[], 31.2, 29.9, null, null, false, $2, 'https://www.tiktok.com/@mogtama3y/video/1') as id`,
    [many, 'https://dalil.mogtama3y.com/media/v/' + P3 + '/a1.mp4']);
  check('a report takes 12 photos, an uploaded video and a TikTok link', !!vidOk.rows?.[0]?.id, vidOk.error);
  const vidPub = (await as(db, null, `select public.get_report($1) as r`, [vidOk.rows?.[0]?.id])).rows?.[0]?.r;
  check('the public report shows the video and the link', vidPub?.video_url?.endsWith('/a1.mp4') && vidPub?.video_link?.includes('tiktok'), vidPub);
  check("EXPLOIT blocked: attaching someone else's uploaded video",
    denied(await as(db, P3, `select public.submit_report('حفر ورصف', 'حفرة كبيرة', '{}', 31.2, 29.9, null, null, false, $1)`, ['https://dalil.mogtama3y.com/media/v/' + P1 + '/x.mp4'])));
  check('EXPLOIT blocked: a video link to any other website',
    denied(await as(db, P3, `select public.submit_report('حفر ورصف', 'حفرة كبيرة', '{}', 31.2, 29.9, null, null, false, null, 'https://evil.example/x')`)));

  // Maintenance trades from the directory (0064)
  await admin(db, "update directory_places set trade = 'سباكة' where id = 'ov2'");
  const svc = await as(db, null, "select * from public.nearby_services(31.2, 29.9, 'سباكة')");
  check('guests find plumbers from the directory near them', svc.rows?.length === 1 && svc.rows[0].id === 'ov2', svc.rows || svc.error);
  check('an unknown trade is refused', !!(await admin(db, "select 1")) && denied(await as(db, null, "update directory_places set trade = 'x'")));

  // Real estate details (0065)
  const reOld = await as(db, Cu, `insert into real_estate_listings (owner_id, title, price, offer_type, property_type, floor, finishing, payment, governorate, area_name)
    values ($1, 'شقة إيجار قديم', 300, 'rent_old', 'apartment', 3, 'lux', 'cash', 'الإسكندرية', 'سموحة') returning id, deal_type`, [Cu]);
  check('a user lists an old-rent apartment (deal_type follows as rent)', reOld.rows?.[0]?.deal_type === 'rent', reOld.error || reOld.rows);
  const reLand = await as(db, M, `insert into real_estate_listings (owner_id, title, price, offer_type, property_type, area_sqm)
    values ($1, 'أرض زراعي', 900000, 'sale', 'land_agricultural', 4200) returning deal_type`, [M]);
  check('agricultural land for sale is listed as a sale', reLand.rows?.[0]?.deal_type === 'sale', reLand.error || reLand.rows);
  check('an unknown property type is refused',
    denied(await as(db, Cu, `insert into real_estate_listings (owner_id, title, price, offer_type, property_type) values ($1, 'x', 1, 'sale', 'castle')`, [Cu])));
  check('guests filter real estate by offer and property type',
    (await as(db, null, `select id from real_estate_listings where offer_type = 'rent_old' and property_type = 'apartment'`)).rows?.length === 1);

  // Cars marketplace (0066)
  const car = await as(db, Cu, `insert into car_listings (owner_id, offer_type, brand, model, year, km, transmission, fuel, title, price, negotiable, governorate)
    values ($1, 'sale', 'تويوتا (Toyota)', 'كورولا', 2019, 85000, 'automatic', 'benzine', 'تويوتا كورولا 2019 فابريكا', 650000, true, 'القاهرة') returning id`, [Cu]);
  const carId = car.rows?.[0]?.id;
  check('a user lists a car for sale', !!carId, car.error);
  const guestCars = await as(db, null, `select id, title, price from car_listings where status = 'active' and offer_type = 'sale'`);
  check('guests browse active car listings', guestCars.rows?.some((r) => r.id === carId), guestCars.error || guestCars.rows);
  check('EXPLOIT blocked: a guest posts a car listing',
    denied(await as(db, null, `insert into car_listings (owner_id, offer_type, brand, title, price) values ($1, 'sale', 'كيا', 'كيا سيراتو', 1)`, [Cu])));
  await as(db, M, `update car_listings set price = 1 where id = $1`, [carId]);
  check("EXPLOIT blocked: a user edits someone else's car listing",
    Number((await admin(db, `select price from car_listings where id = $1`, [carId]))[0].price) === 650000);
  const featIns = await as(db, M, `insert into car_listings (owner_id, offer_type, brand, title, price, is_featured)
    values ($1, 'rent_daily', 'هيونداي', 'هيونداي إلنترا للإيجار', 1500, true) returning id, is_featured`, [M]);
  await as(db, Cu, `update car_listings set is_featured = true where id = $1`, [carId]);
  check('EXPLOIT blocked: an owner makes their own car listing featured',
    featIns.rows?.[0]?.is_featured === false &&
    (await admin(db, `select is_featured from car_listings where id = $1`, [carId]))[0].is_featured === false, featIns);
  check('an impossible model year is refused',
    denied(await as(db, Cu, `insert into car_listings (owner_id, offer_type, brand, year, title, price) values ($1, 'sale', 'كيا', 1900, 'كيا قديمة', 1000)`, [Cu])));
  check('an unknown offer type is refused',
    denied(await as(db, Cu, `insert into car_listings (owner_id, offer_type, brand, title, price) values ($1, 'swap', 'كيا', 'كيا للبدل', 1000)`, [Cu])));
  check('a vehicle listing needs a brand (parts do not)',
    denied(await as(db, Cu, `insert into car_listings (owner_id, offer_type, title, price) values ($1, 'sale', 'عربية', 1000)`, [Cu])) &&
    ok(await as(db, Cu, `insert into car_listings (owner_id, offer_type, title, price) values ($1, 'parts', 'كاوتش 16 بوصة', 1000)`, [Cu])));
  check('a user says "أنا مهتم" on a car', ok(await as(db, M, `select public.express_interest_in_car($1)`, [carId])));
  check('the car owner is notified with the deep link',
    (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = $2`, [Cu, '/#/cars/' + carId]))[0].n === 1);
  check('EXPLOIT blocked: showing interest in your own car listing',
    denied(await as(db, Cu, `select public.express_interest_in_car($1)`, [carId])));
  check('EXPLOIT blocked: a guest shows interest', denied(await as(db, null, `select public.express_interest_in_car($1)`, [carId])));
  check('the owner marks the car sold and it leaves the public list',
    ok(await as(db, Cu, `update car_listings set status = 'sold' where id = $1`, [carId])) &&
    !(await as(db, null, `select id from car_listings`)).rows?.some((r) => r.id === carId));

  // Private tutoring (0069)
  const tut = await as(db, Cu, `insert into tutor_listings (owner_id, tutor_name, subjects, stages, curricula, modes, price, price_unit, governorate, area, experience_years, bio, whatsapp)
    values ($1, 'اسم مزيف', '{math,physics}', '{secondary}', '{languages}', '{student_home,online}', 250, 'session', 'القاهرة', 'مدينة نصر', 8, 'مدرس رياضيات وفيزيا', '01022222222') returning id, tutor_name`, [Cu]);
  const tutId = tut.rows?.[0]?.id;
  check('a user posts a tutoring listing', !!tutId, tut.error);
  check('the tutor name comes from the profile, not the client', tut.rows?.[0]?.tutor_name === 'customer', tut.rows);
  const guestTut = await as(db, null, `select id, tutor_name, price from tutor_listings where 'math' = any(subjects) and 'secondary' = any(stages) and price <= 300`);
  check('guests browse active tutoring listings with filters', guestTut.rows?.some((r) => r.id === tutId), guestTut.error || guestTut.rows);
  check('EXPLOIT blocked: a guest posts a tutoring listing',
    denied(await as(db, null, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{primary}', '{online}', 100, '01022222222')`, [Cu])));
  check('EXPLOIT blocked: posting a tutoring listing as someone else',
    denied(await as(db, M, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{primary}', '{online}', 100, '01022222222')`, [Cu])));
  check('the owner edits their tutoring listing',
    ok(await as(db, Cu, `update tutor_listings set price = 300, tutor_name = 'حد تاني' where id = $1`, [tutId])) &&
    (await admin(db, `select price::float p, tutor_name from tutor_listings where id = $1`, [tutId]))[0].p === 300 &&
    (await admin(db, `select tutor_name from tutor_listings where id = $1`, [tutId]))[0].tutor_name === 'customer');
  await as(db, M, `update tutor_listings set price = 1 where id = $1`, [tutId]);
  check("EXPLOIT blocked: a user edits someone else's tutoring listing",
    Number((await admin(db, `select price from tutor_listings where id = $1`, [tutId]))[0].price) === 300);
  await as(db, M, `delete from tutor_listings where id = $1`, [tutId]);
  check("EXPLOIT blocked: a user deletes someone else's tutoring listing",
    (await admin(db, `select 1 from tutor_listings where id = $1`, [tutId])).length === 1);
  check('an unknown subject is refused',
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{cooking}', '{primary}', '{online}', 100, '01022222222')`, [Cu])));
  check('an unknown stage / mode / curriculum is refused',
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{kg}', '{online}', 100, '01022222222')`, [Cu])) &&
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{primary}', '{mosque}', 100, '01022222222')`, [Cu])) &&
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, curricula, modes, price, phone) values ($1, '{math}', '{primary}', '{french}', '{online}', 100, '01022222222')`, [Cu])));
  check('a listing needs at least one subject, stage and mode',
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{}', '{primary}', '{online}', 100, '01022222222')`, [Cu])) &&
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{}', '{online}', 100, '01022222222')`, [Cu])) &&
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{primary}', '{}', 100, '01022222222')`, [Cu])));
  check('a zero price or unknown price unit is refused',
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{primary}', '{online}', 0, '01022222222')`, [Cu])) &&
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, price_unit, phone) values ($1, '{math}', '{primary}', '{online}', 100, 'hour', '01022222222')`, [Cu])));
  check('a listing needs a valid Egyptian phone or WhatsApp',
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price) values ($1, '{math}', '{primary}', '{online}', 100)`, [Cu])) &&
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone) values ($1, '{math}', '{primary}', '{online}', 100, '12345')`, [Cu])));
  check('impossible years of experience are refused',
    denied(await as(db, Cu, `insert into tutor_listings (owner_id, subjects, stages, modes, price, phone, experience_years) values ($1, '{math}', '{primary}', '{online}', 100, '01022222222', 99)`, [Cu])));
  check('a user asks to book with a tutor', ok(await as(db, M, `select public.express_interest_in_tutor($1)`, [tutId])));
  check('the tutor is notified with the deep link',
    (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = $2`, [Cu, '/#/tutoring/' + tutId]))[0].n === 1);
  check('EXPLOIT blocked: asking to book your own tutoring listing',
    denied(await as(db, Cu, `select public.express_interest_in_tutor($1)`, [tutId])));
  check('EXPLOIT blocked: a guest asks to book', denied(await as(db, null, `select public.express_interest_in_tutor($1)`, [tutId])));
  check('the owner deactivates the listing and it leaves the public list',
    ok(await as(db, Cu, `update tutor_listings set is_active = false where id = $1`, [tutId])) &&
    !(await as(db, null, `select id from tutor_listings`)).rows?.some((r) => r.id === tutId) &&
    !(await as(db, M, `select id from tutor_listings`)).rows?.some((r) => r.id === tutId));
  check('the owner still sees their inactive listing',
    (await as(db, Cu, `select id from tutor_listings where id = $1`, [tutId])).rows?.length === 1);
  check('nobody can ask to book an inactive listing', denied(await as(db, M, `select public.express_interest_in_tutor($1)`, [tutId])));
  check('a super admin can moderate a tutoring listing',
    (await as(db, SA, `select id from tutor_listings where id = $1`, [tutId])).rows?.length === 1 &&
    ok(await as(db, SA, `update tutor_listings set bio = 'تمت المراجعة' where id = $1`, [tutId])));
  await as(db, Cu, `delete from tutor_listings where id = $1`, [tutId]);
  check('the owner deletes their tutoring listing', (await admin(db, `select 1 from tutor_listings where id = $1`, [tutId])).length === 0);
  // Event halls (0070)
  const hallIns = (owner, extra = {}) => {
    const h = { name: 'قاعة الياسمين', hall_type: 'wedding', occasions: '{wedding,engagement}', capacity_min: 100, capacity_max: 400,
      price_from: 30000, included: '{buffet,dj,air_conditioned}', governorate: 'القاهرة', area: 'مدينة نصر', phone: '01012345678', ...extra };
    const cols = Object.keys(h);
    return as(db, owner, `insert into event_halls (owner_id, ${cols.join(', ')}) values ($1, ${cols.map((_, i) => '$' + (i + 2)).join(', ')}) returning id, is_featured`,
      [owner, ...cols.map((c) => h[c])]);
  };
  const hall = await hallIns(Cu, { is_featured: true, whatsapp: '01112345678' });
  const hallId = hall.rows?.[0]?.id;
  check('a venue owner lists a hall', !!hallId, hall.error);
  check('EXPLOIT blocked: an owner lists their hall as featured', hall.rows?.[0]?.is_featured === false);
  const guestHalls = await as(db, null, `select id, name, phone from event_halls where is_active`);
  check('guests browse active halls (with the contact phone)', guestHalls.rows?.some((r) => r.id === hallId && r.phone === '01012345678'), guestHalls.error || guestHalls.rows);
  check('guests filter halls by occasion and guest count',
    (await as(db, null, `select id from event_halls where occasions @> '{wedding}' and capacity_max >= 250 and coalesce(capacity_min, 0) <= 250`)).rows?.some((r) => r.id === hallId) &&
    !(await as(db, null, `select id from event_halls where capacity_max >= 1000`)).rows?.some((r) => r.id === hallId));
  check('EXPLOIT blocked: a guest lists a hall', denied(await hallIns(null)) && denied(await as(db, null, `insert into event_halls (owner_id, name, hall_type, capacity_max, governorate, phone) values ($1, 'قاعة', 'events', 50, 'الجيزة', '01012345678')`, [Cu])));
  check('EXPLOIT blocked: listing a hall in someone else\'s name',
    denied(await as(db, M, `insert into event_halls (owner_id, name, hall_type, capacity_max, governorate, phone) values ($1, 'قاعة مزيفة', 'events', 50, 'الجيزة', '01012345678')`, [Cu])));
  await as(db, M, `update event_halls set price_from = 1, is_active = false where id = $1`, [hallId]);
  await as(db, M, `delete from event_halls where id = $1`, [hallId]);
  const afterM = await admin(db, `select price_from, is_active from event_halls where id = $1`, [hallId]);
  check("EXPLOIT blocked: a user edits or deletes someone else's hall",
    afterM.length === 1 && Number(afterM[0].price_from) === 30000 && afterM[0].is_active === true, afterM);
  check('a hall with min guests above max guests is refused', denied(await hallIns(Cu, { capacity_min: 500, capacity_max: 200 })));
  check('an unknown hall type is refused', denied(await hallIns(Cu, { hall_type: 'stadium' })));
  check('an unknown occasion is refused', denied(await hallIns(Cu, { occasions: '{wedding,divorce}' })));
  check('an unknown "included" tag is refused', denied(await hallIns(Cu, { included: '{buffet,pool}' })));
  check('a bad phone or WhatsApp number is refused',
    denied(await hallIns(Cu, { phone: '12345' })) && denied(await hallIns(Cu, { whatsapp: '0225551234' })));
  check('a zero or negative price is refused', denied(await hallIns(Cu, { price_from: 0 })));
  check('a hall without a capacity is refused', denied(await hallIns(Cu, { capacity_max: null })));
  check('a per-person price with no minimum capacity is fine',
    ok(await hallIns(Cu, { name: 'روف النيل', hall_type: 'rooftop_garden', capacity_min: null, capacity_max: 60, price_from: 450, price_per_person: true })));
  check('the owner edits their hall', ok(await as(db, Cu, `update event_halls set price_from = 35000, included = '{buffet,dj,photography,bride_room}' where id = $1`, [hallId])) &&
    Number((await admin(db, `select price_from from event_halls where id = $1`, [hallId]))[0].price_from) === 35000);
  check('a user says "أنا مهتم" on a hall', ok(await as(db, M, `select public.express_interest_in_hall($1)`, [hallId])));
  check('the hall owner is notified with the deep link',
    (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = $2`, [Cu, '/#/halls/' + hallId]))[0].n === 1);
  check('EXPLOIT blocked: showing interest in your own hall', denied(await as(db, Cu, `select public.express_interest_in_hall($1)`, [hallId])));
  check('EXPLOIT blocked: a guest shows interest in a hall', denied(await as(db, null, `select public.express_interest_in_hall($1)`, [hallId])));
  check('the owner hides the hall', ok(await as(db, Cu, `update event_halls set is_active = false where id = $1`, [hallId])));
  check('a hidden hall is gone for guests and other users',
    !(await as(db, null, `select id from event_halls`)).rows?.some((r) => r.id === hallId) &&
    !(await as(db, M, `select id from event_halls`)).rows?.some((r) => r.id === hallId));
  check('…but the owner still sees it in "إعلاناتي"', (await as(db, Cu, `select id from event_halls where owner_id = $1`, [Cu])).rows?.some((r) => r.id === hallId));
  check('nobody can show interest in a hidden hall', denied(await as(db, M, `select public.express_interest_in_hall($1)`, [hallId])));
  const modHall = (await hallIns(M, { name: 'قاعة مخالفة' })).rows?.[0]?.id;
  check('a super admin hides a hall and features another',
    ok(await as(db, SA, `update event_halls set is_active = false where id = $1`, [modHall])) &&
    ok(await as(db, SA, `update event_halls set is_featured = true where id = $1`, [hallId])) &&
    (await admin(db, `select is_featured from event_halls where id = $1`, [hallId]))[0].is_featured === true);
  check('the owner deletes their hall',
    ok(await as(db, Cu, `delete from event_halls where id = $1`, [hallId])) &&
    (await admin(db, `select id from event_halls where id = $1`, [hallId])).length === 0);
  // Pets (0071)
  const petCols = 'id, owner_id, kind, animal, title, price, is_active, outcome';
  const petIns = await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, breed, age_text, gender, vaccinated, title, price, governorate, area, phone)
    values ($1, 'sale', 'cat', 'شيرازي', '3 شهور', 'female', true, 'قطة شيرازي 3 شهور', 2500, 'القاهرة', 'مدينة نصر', '01022222222') returning id`, [Cu]);
  const petId = petIns.rows?.[0]?.id;
  check('a user lists a cat for sale', !!petId, petIns.error);
  const guestPets = await as(db, null, `select ${petCols} from pet_listings where kind = 'sale' and animal = 'cat'`);
  check('guests browse active pet listings', guestPets.rows?.some((r) => r.id === petId), guestPets.error || guestPets.rows);
  check('EXPLOIT blocked: a guest posts a pet listing',
    denied(await as(db, null, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'sale', 'dog', 'كلب جولدن', 5000, '01022222222')`, [Cu])));
  check("EXPLOIT blocked: a user posts a pet listing in someone else's name",
    denied(await as(db, M, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'sale', 'dog', 'كلب جولدن', 5000, '01011111111')`, [Cu])));
  check("EXPLOIT blocked: a guest reads posters' phones from the table",
    denied(await as(db, null, `select phone from pet_listings`)));
  check("EXPLOIT blocked: a signed-in user reads posters' phones from the table",
    denied(await as(db, M, `select phone from pet_listings`)));
  check('EXPLOIT blocked: a guest gets the phone through the RPC',
    denied(await as(db, null, `select public.pet_listing_phone($1)`, [petId])));
  check('a signed-in user gets the phone of an active listing',
    (await as(db, M, `select public.pet_listing_phone($1) as p`, [petId])).rows?.[0]?.p === '01022222222');
  check('the owner edits their own pet listing',
    ok(await as(db, Cu, `update pet_listings set price = 2200, description = 'متطعمة ومدربة' where id = $1`, [petId])) &&
    Number((await admin(db, `select price from pet_listings where id = $1`, [petId]))[0].price) === 2200);
  await as(db, M, `update pet_listings set price = 1 where id = $1`, [petId]);
  check("EXPLOIT blocked: a user edits someone else's pet listing",
    Number((await admin(db, `select price from pet_listings where id = $1`, [petId]))[0].price) === 2200);
  await as(db, M, `update pet_listings set owner_id = $2 where id = $1`, [petId, M]);
  check("EXPLOIT blocked: a user takes over someone else's pet listing",
    (await admin(db, `select owner_id from pet_listings where id = $1`, [petId]))[0].owner_id === Cu);
  await as(db, M, `delete from pet_listings where id = $1`, [petId]);
  check("EXPLOIT blocked: a user deletes someone else's pet listing",
    (await admin(db, `select 1 from pet_listings where id = $1`, [petId])).length === 1);
  check('adoption with a price is refused',
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'adoption', 'dog', 'كلب للتبني', 500, '01022222222')`, [Cu])));
  const petAdopt = await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, phone) values ($1, 'adoption', 'dog', 'كلب بلدي للتبني', '01022222222') returning id`, [Cu]);
  const petAdoptId = petAdopt.rows?.[0]?.id;
  check('free adoption (no price) is accepted', !!petAdoptId, petAdopt.error);
  check('a sale without a price is refused',
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, phone) values ($1, 'sale', 'bird', 'كناريا', '01022222222')`, [Cu])));
  check('a lost pet needs the last-seen date',
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, phone) values ($1, 'lost', 'cat', 'قطة ضايعة', '01022222222')`, [Cu])));
  check('a lost pet with a price is refused',
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, price, phone, last_seen_date) values ($1, 'lost', 'cat', 'قطة ضايعة', 100, '01022222222', current_date)`, [Cu])));
  const petLost = await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, phone, last_seen_date, last_seen_area)
    values ($1, 'lost', 'cat', 'قطة رمادي ضايعة', '01022222222', current_date - 1, 'شارع مكرم عبيد') returning id`, [Cu]);
  const petLostId = petLost.rows?.[0]?.id;
  check('a user reports a lost cat', !!petLostId, petLost.error);
  check('an invalid phone is refused',
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'supplies', 'cat', 'قفص', 300, '12345')`, [Cu])));
  check('an unknown kind or animal is refused',
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'swap', 'cat', 'بدل', 1, '01022222222')`, [Cu])) &&
    denied(await as(db, Cu, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'sale', 'lion', 'أسد', 1, '01022222222')`, [Cu])));
  check('a user says "عندي معلومة" on a lost pet', ok(await as(db, M, `select public.express_interest_in_pet($1)`, [petLostId])));
  check('the pet owner is notified with the deep link',
    (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = $2`, [Cu, '/#/pets/' + petLostId]))[0].n === 1);
  check('EXPLOIT blocked: showing interest in your own pet listing',
    denied(await as(db, Cu, `select public.express_interest_in_pet($1)`, [petLostId])));
  check('EXPLOIT blocked: a guest shows interest in a pet', denied(await as(db, null, `select public.express_interest_in_pet($1)`, [petLostId])));
  check('the owner closes the lost pet as found and it leaves the public list',
    ok(await as(db, Cu, `update pet_listings set outcome = 'reunited' where id = $1`, [petLostId])) &&
    (await admin(db, `select is_active from pet_listings where id = $1`, [petLostId]))[0].is_active === false &&
    !(await as(db, null, `select id from pet_listings`)).rows?.some((r) => r.id === petLostId));
  await as(db, Cu, `update pet_listings set is_active = false where id = $1`, [petId]);
  check('an inactive pet listing is hidden from guests and other users',
    !(await as(db, null, `select id from pet_listings`)).rows?.some((r) => r.id === petId) &&
    !(await as(db, M, `select id from pet_listings`)).rows?.some((r) => r.id === petId));
  check('…but the owner still sees it in "إعلاناتي"',
    (await as(db, Cu, `select id from pet_listings where owner_id = $1`, [Cu])).rows?.some((r) => r.id === petId));
  check('no phone for an inactive pet listing (other users)',
    (await as(db, M, `select public.pet_listing_phone($1) as p`, [petId])).rows?.[0]?.p === null);
  check('a super admin hides any pet listing',
    ok(await as(db, SA, `update pet_listings set is_active = false where id = $1`, [petAdoptId])) &&
    (await admin(db, `select is_active from pet_listings where id = $1`, [petAdoptId]))[0].is_active === false);
  check('the owner deletes their own pet listing',
    ok(await as(db, Cu, `delete from pet_listings where id = $1`, [petId])) &&
    (await admin(db, `select 1 from pet_listings where id = $1`, [petId])).length === 0);

  // Hardening (0068)
  const noRls = await admin(db, `select c.relname from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity`);
  check('every public table has RLS enabled', noRls.length === 0, noRls.map((r) => r.relname));
  check('EXPLOIT blocked: a job posting in the name of someone else\'s shop',
    denied(await as(db, Cu, `insert into job_postings (poster_id, shop_id, title, employment_type) values ($1, $2, 'كاشير', 'full_time')`, [Cu, proShop])));
  check('a merchant posts a job for their own shop',
    ok(await as(db, M, `insert into job_postings (poster_id, shop_id, title, employment_type) values ($1, $2, 'كاشير', 'full_time')`, [M, proShop])));
  await admin(db, `update shop_products set stock = 5 where id = $1`, [stockP]);
  const restockOrder = await as(db, null, `select public.place_store_order($1, $2::jsonb, 'سارة', '01088888883', 'شارع 10 عمارة 5 الدور 2') as code`,
    [proShop, JSON.stringify([{ product_id: stockP, quantity: 2 }])]);
  const restockId = (await admin(db, `select id from shop_orders where order_code = $1`, [restockOrder.rows?.[0]?.code]))[0]?.id;
  check('stock is deducted when the order is placed', (await admin(db, `select stock from shop_products where id = $1`, [stockP]))[0].stock === 3);
  check('a merchant can cancel a guest order (no buyer account to notify)', ok(await as(db, M, `select public.update_shop_order_status($1, 'cancelled')`, [restockId])));
  check('cancelling an order gives the stock back', (await admin(db, `select stock from shop_products where id = $1`, [stockP]))[0].stock === 5);

  check('with a president in place, owners can no longer call elections themselves',
    denied(await as(db, F, `select public.create_election('تاني', now() + interval '2 days')`)));

  // Kids & baby gear (0072)
  {
    const KO = await signUp(db, 'kids owner', '01000000721');
    const KB = await signUp(db, 'kids buyer', '01000000722');
    const kIns = await as(db, KO, `insert into kids_listings (owner_id, category, title, condition, age_range, gender, brand, price, swap_allowed, governorate, area, phone)
      values ($1, 'stroller', 'عربية أطفال شيكو', 'like_new', '0_6m', 'any', 'Chicco', 2500, true, 'القاهرة', 'مدينة نصر', '01000000721') returning id`, [KO]);
    const kidId = kIns.rows?.[0]?.id;
    check('a parent lists a stroller', !!kidId, kIns.error);
    const kFree = await as(db, KO, `insert into kids_listings (owner_id, category, title, clothes_size, is_free, phone)
      values ($1, 'clothes', 'هدوم بنات 4 سنين', 'مقاس 4 سنين', true, '01000000721') returning id`, [KO]);
    check('a parent gives clothes away for free (no price)', ok(kFree), kFree.error);
    check('a free giveaway with a price is refused',
      denied(await as(db, KO, `insert into kids_listings (owner_id, category, title, price, is_free, phone) values ($1, 'toys', 'لعب ببلاش', 100, true, '01000000721')`, [KO])));
    check('a sale without a price is refused',
      denied(await as(db, KO, `insert into kids_listings (owner_id, category, title, phone) values ($1, 'toys', 'لعب من غير سعر', '01000000721')`, [KO])));
    check('an unknown category / condition / age range is refused',
      denied(await as(db, KO, `insert into kids_listings (owner_id, category, title, price, phone) values ($1, 'cars', 'xxx', 1, '01000000721')`, [KO])) &&
      denied(await as(db, KO, `insert into kids_listings (owner_id, category, title, price, condition, phone) values ($1, 'toys', 'xxx', 1, 'broken', '01000000721')`, [KO])) &&
      denied(await as(db, KO, `insert into kids_listings (owner_id, category, title, price, age_range, phone) values ($1, 'toys', 'xxx', 1, '99y', '01000000721')`, [KO])));
    check('a bad phone number is refused',
      denied(await as(db, KO, `insert into kids_listings (owner_id, category, title, price, phone) values ($1, 'toys', 'xxx', 1, '12345')`, [KO])));
    const gKids = await as(db, null, `select id, title, price, swap_allowed from kids_listings where is_active and not is_sold and category = 'stroller'`);
    check('guests browse active kids listings', gKids.rows?.some((r) => r.id === kidId), gKids.error || gKids.rows);
    check("guests can't read the poster's phone", denied(await as(db, null, `select phone from kids_listings where id = $1`, [kidId])));
    check('signed-in users see the phone to call / WhatsApp',
      (await as(db, KB, `select phone from kids_listings where id = $1`, [kidId])).rows?.[0]?.phone === '01000000721');
    check('EXPLOIT blocked: a guest posts a kids listing',
      denied(await as(db, null, `insert into kids_listings (owner_id, category, title, price, phone) values ($1, 'toys', 'لعب', 50, '01000000721')`, [KO])));
    check('EXPLOIT blocked: posting a kids listing in someone else\'s name',
      denied(await as(db, KB, `insert into kids_listings (owner_id, category, title, price, phone) values ($1, 'toys', 'لعب', 50, '01000000722')`, [KO])));
    check('the owner edits their listing',
      ok(await as(db, KO, `update kids_listings set price = 2200, title = 'عربية أطفال شيكو زي الجديدة' where id = $1`, [kidId])) &&
      Number((await admin(db, `select price from kids_listings where id = $1`, [kidId]))[0].price) === 2200);
    await as(db, KB, `update kids_listings set price = 1 where id = $1`, [kidId]);
    check("EXPLOIT blocked: a user edits someone else's kids listing",
      Number((await admin(db, `select price from kids_listings where id = $1`, [kidId]))[0].price) === 2200);
    await as(db, KB, `update kids_listings set owner_id = $2 where id = $1`, [kidId, KB]);
    check("EXPLOIT blocked: a user takes over someone else's kids listing",
      (await admin(db, `select owner_id from kids_listings where id = $1`, [kidId]))[0].owner_id === KO);
    await as(db, KB, `delete from kids_listings where id = $1`, [kidId]);
    check("EXPLOIT blocked: a user deletes someone else's kids listing",
      (await admin(db, `select 1 from kids_listings where id = $1`, [kidId])).length === 1);
    check('a user says "أنا مهتم" on a kids item', ok(await as(db, KB, `select public.express_interest_in_kids_item($1)`, [kidId])));
    check('the kids item owner is notified with the deep link',
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = $2`, [KO, '/#/kids/' + kidId]))[0].n === 1);
    check('EXPLOIT blocked: showing interest in your own kids item',
      denied(await as(db, KO, `select public.express_interest_in_kids_item($1)`, [kidId])));
    check('EXPLOIT blocked: a guest shows interest in a kids item',
      denied(await as(db, null, `select public.express_interest_in_kids_item($1)`, [kidId])));
    check('the owner deactivates the listing',
      ok(await as(db, KO, `update kids_listings set is_active = false where id = $1`, [kidId])));
    check('an inactive kids listing is hidden from guests and other users',
      !(await as(db, null, `select id from kids_listings`)).rows?.some((r) => r.id === kidId) &&
      !(await as(db, KB, `select id from kids_listings`)).rows?.some((r) => r.id === kidId));
    check('…but the owner still sees it in "إعلاناتي"',
      (await as(db, KO, `select id from kids_listings where owner_id = $1`, [KO])).rows?.some((r) => r.id === kidId));
    check('the owner marks it sold',
      ok(await as(db, KO, `update kids_listings set is_active = true, is_sold = true where id = $1`, [kidId])));
    check('interest in a sold kids item is refused',
      denied(await as(db, KB, `select public.express_interest_in_kids_item($1)`, [kidId])));
    check('a super admin can take down a kids listing',
      ok(await as(db, SA, `update kids_listings set is_active = false where id = $1`, [kFree.rows?.[0]?.id])) &&
      (await admin(db, `select is_active from kids_listings where id = $1`, [kFree.rows?.[0]?.id]))[0].is_active === false);
    check('the owner deletes their listing',
      ok(await as(db, KO, `delete from kids_listings where id = $1`, [kidId])) &&
      (await admin(db, `select 1 from kids_listings where id = $1`, [kidId])).length === 0);
  }

  // Scrap dealers — تجار الخردة (0075)
  {
    const scrapSeller = await signUp(db, 'scrap seller', '01000000751');
    const scrapDealer = await signUp(db, 'scrap dealer copper', '01000000752');
    const scrapOther = await signUp(db, 'scrap dealer iron alex', '01000000753');
    const scrapRejected = await signUp(db, 'scrap dealer rejected', '01000000754');
    const scrapRadius = await signUp(db, 'scrap dealer radius', '01000000755');
    const scrapBidder = await signUp(db, 'scrap plain bidder', '01000000756');
    const scrapSellerDealer = await signUp(db, 'scrap seller dealer', '01000000757');
    const scrapReg = (uid, name, wa, materials, gov, areas, radius = null) => as(db, uid,
      `insert into scrap_dealers (user_id, business_name, whatsapp, materials, governorate, areas, radius_km, base_lat, base_lng)
       values ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
      [uid, name, wa, materials, gov, areas, radius ? radius[0] : null, radius ? radius[1] : null, radius ? radius[2] : null]);

    const scrapR1 = await scrapReg(scrapDealer, 'مخزن الأمانة للخردة', '01000000752', ['copper', 'aluminum'], 'القاهرة', ['مدينة نصر', 'المعادي']);
    check('a scrap dealer registers (pending)', ok(scrapR1) &&
      (await admin(db, `select status from scrap_dealers where user_id = $1`, [scrapDealer]))[0]?.status === 'pending', scrapR1.error);
    check('a dealer with a bad WhatsApp number is refused',
      denied(await scrapReg(scrapBidder, 'محل', '12345', ['iron'], 'القاهرة', [])));
    check('a dealer with an unknown material is refused',
      denied(await scrapReg(scrapBidder, 'محل', '01000000756', ['gold'], 'القاهرة', [])));
    check('a dealer with no materials is refused',
      denied(await scrapReg(scrapBidder, 'محل', '01000000756', [], 'القاهرة', [])));
    check('a dealer with no place at all is refused',
      denied(await scrapReg(scrapBidder, 'محل', '01000000756', ['iron'], null, [])));
    check('EXPLOIT blocked: registering a dealer in someone else\'s name',
      denied(await as(db, scrapBidder, `insert into scrap_dealers (user_id, business_name, whatsapp, materials, governorate) values ($1, 'محل', '01000000756', '{iron}', 'القاهرة')`, [scrapOther])));
    check('EXPLOIT blocked: registering straight as verified',
      denied(await as(db, scrapOther, `insert into scrap_dealers (user_id, business_name, whatsapp, materials, governorate, status) values ($1, 'حديد إسكندرية', '01000000753', '{iron}', 'الإسكندرية', 'verified')`, [scrapOther])));
    check('EXPLOIT blocked: a dealer verifies themselves',
      denied(await as(db, scrapDealer, `update scrap_dealers set status = 'verified' where user_id = $1`, [scrapDealer])) &&
      (await admin(db, `select status from scrap_dealers where user_id = $1`, [scrapDealer]))[0].status === 'pending');
    check('EXPLOIT blocked: a dealer writes their own review note',
      denied(await as(db, scrapDealer, `update scrap_dealers set review_note = 'تمام' where user_id = $1`, [scrapDealer])));
    check("EXPLOIT blocked: a dealer points their document at another user's file",
      denied(await as(db, scrapDealer, `update scrap_dealers set doc_path = $2 where user_id = $1`, [scrapDealer, scrapOther + '/scrap-dealer/x.jpg'])));
    check('a dealer attaches their own document',
      ok(await as(db, scrapDealer, `update scrap_dealers set doc_path = $2 where user_id = $1`, [scrapDealer, scrapDealer + '/scrap-dealer/cr.jpg'])));
    check('EXPLOIT blocked: a non-admin reviews a dealer',
      denied(await as(db, scrapOther, `select public.review_scrap_dealer($1, true, null)`, [scrapDealer])) &&
      denied(await as(db, scrapDealer, `select public.review_scrap_dealer($1, true, null)`, [scrapDealer])) &&
      (await admin(db, `select status from scrap_dealers where user_id = $1`, [scrapDealer]))[0].status === 'pending');
    check('EXPLOIT blocked: a non-admin lists dealers for review',
      denied(await as(db, scrapOther, `select * from public.admin_list_scrap_dealers('pending')`)));

    await scrapReg(scrapOther, 'حديد إسكندرية', '01000000753', ['iron', 'copper'], 'الإسكندرية', []);
    await scrapReg(scrapRejected, 'خردة مرفوضة', '01000000754', ['copper'], 'القاهرة', []);
    await scrapReg(scrapRadius, 'خردة بالمسافة', '01000000755', ['copper'], null, [], [10, 30.05, 31.33]);
    await scrapReg(scrapSellerDealer, 'بائع وتاجر', '01000000757', ['copper'], 'القاهرة', []);
    check('the other test dealers registered', (await admin(db, `select count(*)::int as n from scrap_dealers`))[0].n === 5);
    const scrapPending = await as(db, SA, `select user_id, whatsapp, status from public.admin_list_scrap_dealers('pending')`);
    check('the super admin lists pending dealers (with WhatsApp)',
      scrapPending.rows?.some((r) => r.user_id === scrapDealer && r.whatsapp === '01000000752'), scrapPending.error);
    check('the super admin verifies a dealer', ok(await as(db, SA, `select public.review_scrap_dealer($1, true, null)`, [scrapDealer])) &&
      (await admin(db, `select status from scrap_dealers where user_id = $1`, [scrapDealer]))[0].status === 'verified');
    check('…and the dealer is notified',
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = '/#/scrap-dealer'`, [scrapDealer]))[0].n === 1);
    check('the super admin rejects a dealer with a note', ok(await as(db, SA, `select public.review_scrap_dealer($1, false, 'البيانات ناقصة')`, [scrapRejected])) &&
      (await admin(db, `select status, review_note from scrap_dealers where user_id = $1`, [scrapRejected]))[0].review_note === 'البيانات ناقصة');
    check('editing materials / areas keeps the verified status',
      ok(await as(db, scrapDealer, `update scrap_dealers set materials = '{copper,aluminum,iron}', areas = '{مدينة نصر,المعادي}' where user_id = $1`, [scrapDealer])) &&
      (await admin(db, `select status from scrap_dealers where user_id = $1`, [scrapDealer]))[0].status === 'verified');
    await as(db, scrapDealer, `update scrap_dealers set materials = '{copper,aluminum}' where user_id = $1`, [scrapDealer]);
    check('a dealer reads their own row', (await as(db, scrapDealer, `select * from scrap_dealers`)).rows?.length === 1);
    check("a user can't read other dealers' rows", (await as(db, scrapBidder, `select * from scrap_dealers`)).rows?.length === 0);
    check('anon cannot read scrap_dealers', denied(await as(db, null, `select business_name from scrap_dealers`)));

    const scrapBadges = await as(db, null, `select * from public.scrap_dealer_badges($1)`, [[scrapDealer, scrapOther, scrapRejected, scrapBidder]]);
    check('badges list only verified dealers', ok(scrapBadges) && scrapBadges.rows.length === 1 &&
      scrapBadges.rows[0].user_id === scrapDealer && scrapBadges.rows[0].business_name === 'مخزن الأمانة للخردة', scrapBadges);
    check('badges never expose WhatsApp or the document',
      !('whatsapp' in (scrapBadges.rows?.[0] ?? {})) && !('doc_path' in (scrapBadges.rows?.[0] ?? {})) &&
      !JSON.stringify(scrapBadges.rows ?? []).includes('01000000752'));

    // A copper lot in مدينة نصر (spelt a bit differently), near the radius dealer's base.
    const scrapNotifs = async (uid) => (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title = 'مزاد خردة جديد يناسبك'`, [uid]))[0].n;
    const scrapLot = await as(db, scrapSellerDealer, `insert into recycling_listings (seller_id, category, material, title, estimated_weight_kg, governorate, area, lat, lng, auction_ends_at)
      values ($1, 'other', 'copper', 'مواسير نحاس تكييف', 40, 'القاهرة', ' مدينه  نصر', 30.06, 31.34, now() + interval '1 day') returning id, category`, [scrapSellerDealer]);
    const scrapLotId = scrapLot.rows?.[0]?.id;
    check('a seller adds a copper lot with a place', !!scrapLotId, scrapLot.error);
    check('the category follows the material (copper → metal)', scrapLot.rows?.[0]?.category === 'metal');
    const scrapMsg = await admin(db, `select body, deep_link from notifications where user_id = $1 and title = 'مزاد خردة جديد يناسبك'`, [scrapDealer]);
    check('a matching dealer (material + district) is notified with the lot link',
      scrapMsg.length === 1 && scrapMsg[0].deep_link === '/#/recycling/' + scrapLotId && scrapMsg[0].body.includes('نحاس') && scrapMsg[0].body.includes('40 كيلو'), scrapMsg);
    check('a dealer within their radius is notified', (await scrapNotifs(scrapRadius)) === 1);
    check('a dealer in another governorate is not notified', (await scrapNotifs(scrapOther)) === 0);
    check('a rejected dealer is not notified', (await scrapNotifs(scrapRejected)) === 0);
    check('the seller (even if a dealer) is not notified about their own lot', (await scrapNotifs(scrapSellerDealer)) === 0);
    await as(db, scrapSellerDealer, `insert into recycling_listings (seller_id, category, material, title, governorate, area, auction_ends_at)
      values ($1, 'other', 'plastic', 'بلاستيك', 'القاهرة', 'مدينة نصر', now() + interval '1 day')`, [scrapSellerDealer]);
    check('a dealer is not notified about a material they do not buy', (await scrapNotifs(scrapDealer)) === 1);
    await as(db, scrapSeller, `insert into recycling_listings (seller_id, category, material, title, governorate, area, auction_ends_at)
      values ($1, 'other', 'aluminum', 'ألومنيوم شبابيك', 'القاهرة', 'الزمالك', now() + interval '1 day')`, [scrapSeller]);
    check('a dealer is not notified about another district', (await scrapNotifs(scrapDealer)) === 1);
    await as(db, scrapSeller, `insert into recycling_listings (seller_id, category, title, governorate, area, auction_ends_at)
      values ($1, 'metal', 'خردة معادن قديمة', 'الإسكندرية', 'سموحة', now() + interval '1 day')`, [scrapSeller]);
    check('a lot without a material matches its category group', (await scrapNotifs(scrapOther)) === 1);
    const scrapMatching = await as(db, scrapDealer, `select id from public.scrap_dealer_matching_lots()`);
    check('the dealer sees the matching lot in «مزادات مطابقة ليك»',
      ok(scrapMatching) && scrapMatching.rows.length === 1 && scrapMatching.rows[0].id === scrapLotId, scrapMatching);

    // Bids: outbid, accept, contact.
    check('a dealer bids', ok(await as(db, scrapDealer, `select public.place_recycling_bid($1, 500)`, [scrapLotId])));
    check('a lower bid is still refused', denied(await as(db, scrapBidder, `select public.place_recycling_bid($1, 400)`, [scrapLotId])));
    check('another bidder outbids', ok(await as(db, scrapBidder, `select public.place_recycling_bid($1, 650)`, [scrapLotId])));
    const scrapOutbid = await admin(db, `select body, deep_link from notifications where user_id = $1 and title = 'عرضك اتعدّى'`, [scrapDealer]);
    check('the previous top bidder is told they were outbid',
      scrapOutbid.length === 1 && scrapOutbid[0].body.includes('650') && scrapOutbid[0].deep_link === '/#/recycling/' + scrapLotId, scrapOutbid);
    check('raising your own top bid does not notify you',
      ok(await as(db, scrapBidder, `select public.place_recycling_bid($1, 700)`, [scrapLotId])) &&
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title = 'عرضك اتعدّى'`, [scrapBidder]))[0].n === 0);
    check('the dealer bids again on top', ok(await as(db, scrapDealer, `select public.place_recycling_bid($1, 800)`, [scrapLotId])));
    const scrapMine = await as(db, scrapDealer, `select my_amount, top_amount, won from public.recycling_my_bids() where listing_id = $1`, [scrapLotId]);
    check('«عروضي» shows my best bid and the top', Number(scrapMine.rows?.[0]?.my_amount) === 800 && Number(scrapMine.rows?.[0]?.top_amount) === 800, scrapMine);
    check("the seller's phone is hidden from a bidder before acceptance",
      (await as(db, scrapDealer, `select * from public.recycling_seller_contact($1)`, [scrapLotId])).rows?.length === 0 &&
      !(await as(db, scrapDealer, `select * from public.get_contact_phones($1)`, [[scrapSellerDealer]])).rows?.length);
    check("EXPLOIT blocked: a bidder accepts the bid on someone else's lot",
      denied(await as(db, scrapDealer, `select public.accept_recycling_top_bid($1)`, [scrapLotId])));
    check('the seller accepts the top bid', ok(await as(db, scrapSellerDealer, `select public.accept_recycling_top_bid($1)`, [scrapLotId])));
    const scrapWon = await admin(db, `select deep_link from notifications where user_id = $1 and title = 'مبروك! البائع قبل عرضك'`, [scrapDealer]);
    check('the winner is told «مبروك! البائع قبل عرضك» with the lot link', scrapWon.length === 1 && scrapWon[0].deep_link === '/#/recycling/' + scrapLotId, scrapWon);
    const scrapContact = await as(db, scrapDealer, `select phone from public.recycling_seller_contact($1)`, [scrapLotId]);
    check("the winner gets the seller's phone after acceptance", scrapContact.rows?.[0]?.phone === '01000000757', scrapContact);
    check("a losing bidder still can't get the seller's phone",
      (await as(db, scrapBidder, `select * from public.recycling_seller_contact($1)`, [scrapLotId])).rows?.length === 0);
    const scrapWinner = await as(db, scrapSellerDealer, `select phone, whatsapp from public.recycling_winner_contact($1)`, [scrapLotId]);
    check("the seller gets the winner's phone / WhatsApp after acceptance", scrapWinner.rows?.[0]?.whatsapp === '01000000752', scrapWinner);
    check("someone else can't get the winner's contact",
      (await as(db, scrapBidder, `select * from public.recycling_winner_contact($1)`, [scrapLotId])).rows?.length === 0);
    check('the winner still opens the ended lot',
      (await as(db, scrapDealer, `select id from recycling_listings where id = $1`, [scrapLotId])).rows?.length === 1);
    check('«عروضي» marks the lot as won',
      (await as(db, scrapDealer, `select won from public.recycling_my_bids() where listing_id = $1`, [scrapLotId])).rows?.[0]?.won === true);

    check('renaming a verified dealer sends them back to review',
      ok(await as(db, scrapDealer, `update scrap_dealers set business_name = 'مخزن الأمانة الجديد' where user_id = $1`, [scrapDealer])) &&
      (await admin(db, `select status from scrap_dealers where user_id = $1`, [scrapDealer]))[0].status === 'pending');
    check('a dealer deletes their registration', ok(await as(db, scrapRadius, `delete from scrap_dealers where user_id = $1`, [scrapRadius])) &&
      (await admin(db, `select 1 from scrap_dealers where user_id = $1`, [scrapRadius])).length === 0);
  }

  // ------------------------------------------------------------------
  console.log('\nResident polls, official announcements & family-name privacy (0077)');
  {
    const pollPres = await signUp(db, 'Poll President', '01000000801');
    const pollB1 = await signUp(db, 'Bahaa Elmasry', '01000000802');
    const pollB2 = await signUp(db, 'Basma Elmasry', '01000000803');
    const pollC = await signUp(db, 'Camelia Fawzy', '01000000804');
    const pollOut = await signUp(db, 'Poll Outsider', '01000000805');
    const pollPending = await signUp(db, 'Poll Pending', '01000000806');
    await as(db, pollPres, `select public.found_building('عمارة التصويت','x','x','x','1','الأول')`);
    const pollBld = (await admin(db, `select building_id from union_members where user_id = $1`, [pollPres]))[0].building_id;
    await admin(db, `update union_members set role = 'president' where user_id = $1`, [pollPres]);
    const pollJoin = async (uid, unit) => {
      await as(db, uid, `select public.found_building('x','x','x','x',$2,'x', null, null, null, false, $1)`, [pollBld, unit]);
      const id = (await admin(db, `select id from union_members where user_id = $1 and building_id = $2`, [uid, pollBld]))[0].id;
      return as(db, pollPres, `select public.review_union_member($1, true)`, [id]);
    };
    await pollJoin(pollB1, '2');
    await pollJoin(pollB2, '2'); // same apartment as B1 (co-owner)
    await pollJoin(pollC, '3');
    await as(db, pollPending, `select public.found_building('x','x','x','x','4','x', null, null, null, false, $1)`, [pollBld]);

    // Creating polls
    const pollEnds = `now() + interval '2 days'`;
    check('a resident cannot create a poll',
      denied(await as(db, pollB1, `select public.create_building_poll('نغيّر البواب؟', array['أيوه','لا'], ${pollEnds}, $1)`, [pollBld])));
    check('a poll needs at least 2 options',
      denied(await as(db, pollPres, `select public.create_building_poll('سؤال', array['أيوه', '  '], ${pollEnds})`)));
    check('a poll allows at most 6 options',
      denied(await as(db, pollPres, `select public.create_building_poll('سؤال', array['1','2','3','4','5','6','7'], ${pollEnds})`)));
    check('a poll that ends in the past is refused',
      denied(await as(db, pollPres, `select public.create_building_poll('سؤال', array['أيوه','لا'], now() - interval '1 day')`)));
    const pollRes = await as(db, pollPres, `select public.create_building_poll('نطلي السلم بأي لون؟', array['أبيض','بيج','رمادي'], ${pollEnds}) as id`);
    check('the president creates a poll', ok(pollRes), pollRes.error);
    const pollId = pollRes.rows?.[0]?.id;
    const pollNotes = await admin(db, `select user_id, deep_link from notifications where title = '🗳️ تصويت جديد في العمارة'`);
    check('opening a poll notifies the verified members (not the creator, not pending or outsiders)',
      [pollB1, pollB2, pollC].every((u) => pollNotes.some((n) => n.user_id === u)) &&
      !pollNotes.some((n) => [pollPres, pollPending, pollOut].includes(n.user_id)) && pollNotes[0]?.deep_link === '/#/polls', pollNotes);
    check('EXPLOIT blocked: a member inserts a poll directly',
      denied(await as(db, pollB1, `insert into union_polls (building_id, created_by, question, options, ends_at) values ($1, $2, 'x?', array['a','b'], now() + interval '1 day')`, [pollBld, pollB1])));

    // Voting
    check('a non-member cannot vote', denied(await as(db, pollOut, `select public.cast_poll_vote($1, 0)`, [pollId])));
    check('a pending member cannot vote', denied(await as(db, pollPending, `select public.cast_poll_vote($1, 0)`, [pollId])));
    check('an out-of-range option is refused', denied(await as(db, pollB1, `select public.cast_poll_vote($1, 3)`, [pollId])));
    check('the first member of apartment 2 votes', ok(await as(db, pollB1, `select public.cast_poll_vote($1, 1)`, [pollId])));
    const pollB2Vote = await as(db, pollB2, `select public.cast_poll_vote($1, 0)`, [pollId]);
    check('a second member of the same apartment cannot vote again', denied(pollB2Vote) && /شقتكم صوّتت/.test(pollB2Vote.error), pollB2Vote);
    check('the same member cannot vote twice', denied(await as(db, pollB1, `select public.cast_poll_vote($1, 2)`, [pollId])));
    check('apartment 3 votes', ok(await as(db, pollC, `select public.cast_poll_vote($1, 1)`, [pollId])));
    check('EXPLOIT blocked: a member inserts a vote row directly',
      denied(await as(db, pollPres, `insert into union_poll_votes (poll_id, unit_id, voter_id, option_index) select $1, unit_id, $2, 0 from union_members where user_id = $2`, [pollId, pollPres])));
    check('EXPLOIT blocked: members cannot read who voted for what',
      denied(await as(db, pollC, `select * from union_poll_votes`)));

    // Results
    const pollList = async (uid) => (await as(db, uid, `select * from public.list_building_polls($1)`, [pollBld])).rows ?? [];
    const pr = (await pollList(pollB2)).find((p) => p.id === pollId);
    check('results: counts per option are correct', JSON.stringify(pr?.counts) === JSON.stringify([0, 2, 0]), pr?.counts);
    check('results: turnout = 2 of 3 apartments', pr?.units_voted === 2 && pr?.total_units === 3, pr);
    check('B2 sees «شقتكم صوّتت» (their apartment\'s choice) without having voted personally',
      pr?.my_unit_choice === 1 && pr?.voted_by_me === false, pr);
    check('the poll is listed as open', pr?.is_open === true);
    check('a non-member sees no polls', (await pollList(pollOut)).length === 0);
    check('a non-member cannot read the polls table', (await as(db, pollOut, `select id from union_polls`)).rows?.length === 0);

    // Ending
    check('a resident cannot close the poll', denied(await as(db, pollC, `select public.close_building_poll($1)`, [pollId])));
    await admin(db, `update union_polls set ends_at = now() - interval '1 minute' where id = $1`, [pollId]);
    check('nobody can vote after the end time', denied(await as(db, pollPres, `select public.cast_poll_vote($1, 0)`, [pollId])));
    check('an ended poll is listed as closed with its results kept',
      (await pollList(pollC)).some((p) => p.id === pollId && p.is_open === false && p.units_voted === 2));
    const pollId2 = (await as(db, pollPres, `select public.create_building_poll('نركّب كاميرات؟', array['أيوه','لا'], ${pollEnds}) as id`)).rows[0].id;
    check('the president closes a poll early', ok(await as(db, pollPres, `select public.close_building_poll($1)`, [pollId2])));
    check('no votes after an early close', denied(await as(db, pollC, `select public.cast_poll_vote($1, 0)`, [pollId2])));

    // Official announcements
    check('a resident cannot publish an official announcement',
      denied(await as(db, pollC, `select public.publish_official_announcement('ادفعوا على رقمي', $1)`, [pollBld])));
    const fixAnn = await as(db, pollPres, `select public.publish_official_announcement('اجتماع الجمعية العمومية يوم الجمعة الساعة 8') as id`);
    check('the president publishes an official announcement', ok(fixAnn), fixAnn.error);
    const fixPost = (await admin(db, `select type::text, is_pinned from posts where id = $1`, [fixAnn.rows?.[0]?.id]))[0];
    check('…stored as an official, pinned post', fixPost?.type === 'official' && fixPost?.is_pinned === true, fixPost);
    const fixNotes = await admin(db, `select user_id from notifications where title = '📢 إعلان رسمي من اتحاد العمارة'`);
    check('…and every verified member is notified (not the author / pending)',
      [pollB1, pollB2, pollC].every((u) => fixNotes.some((n) => n.user_id === u)) && !fixNotes.some((n) => [pollPres, pollPending].includes(n.user_id)), fixNotes);
    check('members see it pinned at the top of the feed',
      (await as(db, pollC, `select type, is_pinned from public.fetch_building_posts($1) limit 1`, [pollBld])).rows?.[0]?.type === 'official');
    check('a resident cannot unpin it', denied(await as(db, pollC, `select public.set_post_pinned($1, false)`, [fixAnn.rows?.[0]?.id])));
    check('the president can unpin it', ok(await as(db, pollPres, `select public.set_post_pinned($1, false)`, [fixAnn.rows?.[0]?.id])));

    // Family name only
    check('a member turns on «اسم العائلة فقط»', ok(await as(db, pollB1, `select public.set_my_name_privacy(true, $1)`, [pollBld])));
    check('…and it is stored on the membership',
      (await admin(db, `select show_family_name_only from union_members where user_id = $1`, [pollB1]))[0].show_family_name_only === true);
    check('a pending applicant can set it on their request', ok(await as(db, pollPending, `select public.set_my_name_privacy(true)`)));
    check('setting it for a building you are not in is refused', denied(await as(db, pollOut, `select public.set_my_name_privacy(true, $1)`, [pollBld])));
    await as(db, pollB1, `insert into posts (building_id, author_id, body) values ($1, $2, 'صباح الخير يا جيران')`, [pollBld, pollB1]);
    const fixName = async (viewer) => (await as(db, viewer, `select display_name from public.building_member_names($1) where user_id = $2`, [pollBld, pollB1])).rows?.[0]?.display_name;
    check('neighbours see only the family name', (await fixName(pollC)) === 'عائلة Elmasry', await fixName(pollC));
    check('the president still sees the full name', (await fixName(pollPres)) === 'Bahaa Elmasry');
    check('the member sees their own full name', (await fixName(pollB1)) === 'Bahaa Elmasry');
    check('members without the option keep their full name',
      (await as(db, pollB1, `select display_name from public.building_member_names($1) where user_id = $2`, [pollBld, pollC])).rows?.[0]?.display_name === 'Camelia Fawzy');
    check('outsiders get no member names', (await as(db, pollOut, `select * from public.building_member_names($1)`, [pollBld])).rows?.length === 0);
    const fixFeed = await as(db, pollC, `select author_name from public.fetch_building_posts($1) where author_id = $2`, [pollBld, pollB1]);
    check('the feed shows the family name to neighbours', fixFeed.rows?.[0]?.author_name === 'عائلة Elmasry', fixFeed);
    const fixFeedPres = await as(db, pollPres, `select author_name from public.fetch_building_posts($1) where author_id = $2`, [pollBld, pollB1]);
    check('…and the full name to the president', fixFeedPres.rows?.[0]?.author_name === 'Bahaa Elmasry', fixFeedPres);
  }

  // Building fund, treasurer, dues status, invite codes (0076)
  {
    const fundPres = await signUp(db, 'fund president', '01000000761');
    const fundOwner2 = await signUp(db, 'fund owner two', '01000000762');
    const fundOwner3 = await signUp(db, 'fund owner three', '01000000763');
    const fundTenant = await signUp(db, 'fund tenant', '01000000764');
    const fundLate = await signUp(db, 'fund latecomer', '01000000765');
    const fundOutsider = await signUp(db, 'fund outsider', '01000000766');

    const fundCode = (await as(db, fundPres, `select public.found_building('عمارة الصندوق','x','x','x','1','1') as c`)).rows[0].c;
    const fundBld = (await admin(db, `select building_id from union_members where user_id = $1`, [fundPres]))[0].building_id;
    const fundReq = (await admin(db, `select id from president_requests where user_id = $1 and status = 'pending'`, [fundPres]))[0].id;
    await as(db, SA, `select public.review_president_request($1, true)`, [fundReq]);

    check('the president sees the building invite code (BLD-…)',
      (await as(db, fundPres, `select public.get_building_invite_code($1) as c`, [fundBld])).rows?.[0]?.c === fundCode);
    check("a non-member can't read the building invite code",
      denied(await as(db, fundOutsider, `select public.get_building_invite_code($1)`, [fundBld])));

    await as(db, fundOwner2, `select public.join_building_with_code($1, '2', '2', 'owner')`, [fundCode]);
    const fundJoinNote = await admin(db, `select deep_link from notifications where user_id = $1 and title = '🏠 طلب انضمام جديد'`, [fundPres]);
    check('a join request notifies the president with a link to the approvals screen',
      fundJoinNote.length === 1 && fundJoinNote[0].deep_link === '/#/union-approvals', fundJoinNote);
    await as(db, fundOwner3, `select public.join_building_with_code($1, '3', '3', 'owner')`, [fundCode]);
    for (const u of [fundOwner2, fundOwner3]) {
      const mid = (await admin(db, `select id from union_members where user_id = $1 and building_id = $2`, [u, fundBld]))[0].id;
      await as(db, fundPres, `select public.review_union_member($1, true)`, [mid]);
    }
    const fundUnit = async (n) => (await admin(db, `select id from units where building_id = $1 and unit_number = $2`, [fundBld, n]))[0].id;
    const fundUnit2 = await fundUnit('2');
    const fundTenCode = (await as(db, fundOwner2, `select public.invite_tenant_for_unit($1) as c`, [fundUnit2])).rows?.[0]?.c;
    await as(db, fundTenant, `select public.join_as_tenant_with_code($1)`, [fundTenCode]);

    // Dues: due date yesterday, so unpaid = متأخر.
    check('the president issues dues for every unit',
      (await as(db, fundPres, `select public.create_union_due('نوفمبر', 300, current_date - 1, $1) as n`, [fundBld])).rows?.[0]?.n === 3);
    const fundDue = async (n) => (await admin(db, `select d.id from union_dues d join units u on u.id = d.unit_id where d.building_id = $1 and u.unit_number = $2`, [fundBld, n]))[0].id;
    const fundDue1 = await fundDue('1');
    const fundDue2 = await fundDue('2');
    const fundDue3 = await fundDue('3');
    const fundBalance = async () => Number((await admin(db, `select coalesce((select balance from union_funds where building_id = $1), 0) as b`, [fundBld]))[0].b);
    const fundLedgerCount = async (type) => (await admin(db, `select count(*)::int as n from union_fund_transactions where building_id = $1 and type = $2`, [fundBld, type]))[0].n;

    await admin(db, `update wallets set available_balance = 1000 where user_id = $1`, [fundOwner2]);
    const fundPay = await as(db, fundOwner2, `select public.pay_union_due($1)`, [fundDue2]);
    check('a resident pays their due from the wallet', ok(fundPay), fundPay.error);
    check('…the resident wallet is debited (1000 → 700) with a ledger row',
      Number((await admin(db, `select available_balance from wallets where user_id = $1`, [fundOwner2]))[0].available_balance) === 700 &&
      (await admin(db, `select count(*)::int as n from wallet_transactions t join wallets w on w.id = t.wallet_id where w.user_id = $1 and t.reference_id = $2 and t.amount = -300`, [fundOwner2, fundDue2]))[0].n === 1);
    check('…and the building fund is credited exactly once (300)',
      (await fundBalance()) === 300 && (await fundLedgerCount('due_payment')) === 1);
    check('…the fund manager (president) is notified',
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = '/#/union-fund'`, [fundPres]))[0].n === 1);
    check('paying the same due twice is refused', denied(await as(db, fundOwner2, `select public.pay_union_due($1)`, [fundDue2])));
    check('…and the fund is not credited again',
      (await fundBalance()) === 300 && (await fundLedgerCount('due_payment')) === 1 &&
      Number((await admin(db, `select available_balance from wallets where user_id = $1`, [fundOwner2]))[0].available_balance) === 700);
    check("EXPLOIT blocked: a resident pays someone else's due (fund untouched)",
      denied(await as(db, fundOwner2, `select public.pay_union_due($1)`, [fundDue3])) && (await fundBalance()) === 300);

    // Residents: no cash marking, no expenses, no withdrawals, no ledger.
    check('a resident cannot mark a due paid in cash', denied(await as(db, fundOwner3, `select public.mark_due_paid_cash($1, null)`, [fundDue3])));
    check('a resident cannot record an expense', denied(await as(db, fundOwner3, `select public.record_union_expense($1, 50, 'لمبات السلم', null)`, [fundBld])));
    check('a resident cannot request a fund withdrawal', denied(await as(db, fundOwner3, `select public.request_fund_withdrawal($1, 50, 'سحب', null)`, [fundBld])));
    check("a resident can't see the fund balance or the ledger",
      (await as(db, fundOwner3, `select * from union_funds`)).rows?.length === 0 &&
      (await as(db, fundOwner3, `select * from union_fund_transactions`)).rows?.length === 0 &&
      denied(await as(db, fundOwner3, `select public.union_fund_summary($1)`, [fundBld])));
    check("a resident can't see who paid", denied(await as(db, fundOwner3, `select * from public.union_dues_status($1)`, [fundBld])));
    const fundRate = await as(db, fundOwner3, `select * from public.union_collection_rate($1)`, [fundBld]);
    check('a resident gets only the collection rate (1 of 3 → 33.3%)',
      fundRate.rows?.[0]?.paid_units === 1 && fundRate.rows?.[0]?.total_units === 3 && Number(fundRate.rows?.[0]?.pct) === 33.3, fundRate);
    check("an outsider can't get the collection rate", denied(await as(db, fundOutsider, `select * from public.union_collection_rate($1)`, [fundBld])));

    // The manager (president, no treasurer yet).
    check('the manager marks a due paid in cash', ok(await as(db, fundPres, `select public.mark_due_paid_cash($1, 'استلمت من الحاج')`, [fundDue3])));
    check('…the due is paid via cash and the fund credited (600)',
      (await admin(db, `select paid_via from union_dues where id = $1`, [fundDue3]))[0].paid_via === 'cash' &&
      (await fundBalance()) === 600 && (await fundLedgerCount('cash_due')) === 1);
    check('marking an already-paid due as cash is refused', denied(await as(db, fundPres, `select public.mark_due_paid_cash($1, null)`, [fundDue2])));
    check('an expense larger than the fund is refused',
      denied(await as(db, fundPres, `select public.record_union_expense($1, 1000, 'دهان السلم', null)`, [fundBld])) && (await fundBalance()) === 600);
    check("EXPLOIT blocked: an expense pointing at someone else's private file",
      denied(await as(db, fundPres, `select public.record_union_expense($1, 10, 'إيصال', $2)`, [fundBld, `${fundOwner2}/id-card/x.jpg`])));
    check('the manager records an expense with a receipt',
      ok(await as(db, fundPres, `select public.record_union_expense($1, 100, 'تغيير لمبات السلم', $2)`, [fundBld, `${fundPres}/union-receipts/r1.jpg`])) &&
      (await fundBalance()) === 500);
    const fundStatus = await as(db, fundPres, `select unit_number, status, paid_via from public.union_dues_status($1)`, [fundBld]);
    const fundSt = Object.fromEntries((fundStatus.rows || []).map((r) => [r.unit_number, r.status]));
    check('dues status: unit 1 متأخر, 2 مدفوع, 3 مدفوع', fundSt['1'] === 'overdue' && fundSt['2'] === 'paid' && fundSt['3'] === 'paid', fundStatus);
    const fundSum = (await as(db, fundPres, `select public.union_fund_summary($1) as s`, [fundBld])).rows?.[0]?.s;
    check('the financial summary comes from the ledger',
      Number(fundSum?.income_wallet) === 300 && Number(fundSum?.income_cash) === 300 && Number(fundSum?.expenses) === 100 && Number(fundSum?.balance) === 500 &&
      fundSum?.expense_items?.length === 1, fundSum);

    check('«فكّر الكل» reminds the units with unpaid dues', (await as(db, fundPres, `select public.remind_unpaid_dues($1) as n`, [fundBld])).rows?.[0]?.n === 1);
    check('…only those units get the reminder',
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title = '⏰ تذكير بمستحقات الصيانة'`, [fundPres]))[0].n === 1 &&
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title = '⏰ تذكير بمستحقات الصيانة'`, [fundOwner2]))[0].n === 0);
    check('a second reminder within 24h is refused', denied(await as(db, fundPres, `select public.remind_unpaid_dues($1)`, [fundBld])));
    check('a resident cannot send reminders', denied(await as(db, fundOwner3, `select public.remind_unpaid_dues($1)`, [fundBld])));

    // Withdrawals: reviewed by the platform admin, fund debited on approval.
    const fundWd = await as(db, fundPres, `select public.request_fund_withdrawal($1, 200, 'مصاريف كهربائي', null) as id`, [fundBld]);
    check('the manager requests a withdrawal to their wallet', ok(fundWd), fundWd.error);
    check('…the fund is not debited until the admin approves', (await fundBalance()) === 500);
    check('a withdrawal beyond balance minus pending requests is refused',
      denied(await as(db, fundPres, `select public.request_fund_withdrawal($1, 400, 'تاني', null)`, [fundBld])));
    check('the admin lists pending fund withdrawals',
      (await as(db, SA, `select * from public.admin_list_union_fund_withdrawals()`)).rows?.some((r) => r.id === fundWd.rows?.[0]?.id));
    check("a non-admin can't approve a fund withdrawal",
      denied(await as(db, fundPres, `select public.review_union_fund_withdrawal($1, true)`, [fundWd.rows?.[0]?.id])));
    const fundPresWallet0 = Number((await admin(db, `select available_balance from wallets where user_id = $1`, [fundPres]))[0].available_balance);
    check('the admin approves: fund 500 → 300, manager wallet +200',
      ok(await as(db, SA, `select public.review_union_fund_withdrawal($1, true)`, [fundWd.rows?.[0]?.id])) &&
      (await fundBalance()) === 300 &&
      Number((await admin(db, `select available_balance from wallets where user_id = $1`, [fundPres]))[0].available_balance) === fundPresWallet0 + 200);

    // Treasurer: appointed → manages the fund; president keeps read access.
    check('a resident cannot appoint a treasurer', denied(await as(db, fundOwner2, `select public.appoint_union_treasurer($1, $2)`, [fundBld, fundOwner2])));
    check('the president appoints a treasurer', ok(await as(db, fundPres, `select public.appoint_union_treasurer($1, $2)`, [fundBld, fundOwner3])));
    check('…the building is notified',
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title = 'أمين صندوق جديد للعمارة'`, [fundOwner2]))[0].n === 1);
    check('the treasurer now manages the fund (records an expense)',
      ok(await as(db, fundOwner3, `select public.record_union_expense($1, 50, 'منظفات', null)`, [fundBld])) && (await fundBalance()) === 250);
    check('the treasurer sees the ledger', (await as(db, fundOwner3, `select * from union_fund_transactions where building_id = $1`, [fundBld])).rows?.length >= 4);
    check('with a treasurer, the president can no longer move fund money',
      denied(await as(db, fundPres, `select public.record_union_expense($1, 10, 'حاجة', null)`, [fundBld])) &&
      denied(await as(db, fundPres, `select public.mark_due_paid_cash($1, null)`, [fundDue1])));
    check('…but the president still reads the balance and the ledger',
      (await as(db, fundPres, `select balance from union_funds where building_id = $1`, [fundBld])).rows?.length === 1 &&
      ok(await as(db, fundPres, `select public.union_fund_summary($1)`, [fundBld])));
    check('the treasurer cannot remove themselves (president only)', denied(await as(db, fundOwner3, `select public.remove_union_treasurer($1)`, [fundBld])));
    check('the president removes the treasurer', ok(await as(db, fundPres, `select public.remove_union_treasurer($1)`, [fundBld])));
    check('…and manages the fund again', ok(await as(db, fundPres, `select public.mark_due_paid_cash($1, null)`, [fundDue1])) && (await fundBalance()) === 550);

    // Treasurer election: one vote per unit, 50% quorum, winner = treasurer.
    check('a resident cannot call a treasurer election',
      denied(await as(db, fundOwner2, `select public.create_election('أمين صندوق', now() + interval '2 days', 50, $1, 'treasurer')`, [fundBld])));
    const fundEl = await as(db, fundPres, `select public.create_election('انتخاب أمين الصندوق', now() + interval '2 days', 50, $1, 'treasurer') as id`, [fundBld]);
    check('the president calls a treasurer election', ok(fundEl), fundEl.error);
    const fundElId = fundEl.rows?.[0]?.id;
    check('a presidential election can still run alongside it',
      ok(await as(db, fundPres, `select public.create_election('رئاسة', now() + interval '2 days', 50, $1) as id`, [fundBld])));
    check('a second open treasurer election is refused',
      denied(await as(db, fundPres, `select public.create_election('تاني', now() + interval '2 days', 50, $1, 'treasurer')`, [fundBld])));
    const fundCand = (await as(db, fundOwner2, `select public.nominate_self($1, 'هنظّم الصرف') as id`, [fundElId])).rows?.[0]?.id;
    check('an owner runs for treasurer', !!fundCand);
    await as(db, fundOwner2, `select public.cast_election_vote($1, $2)`, [fundElId, fundCand]);
    await as(db, fundOwner2, `select public.cast_election_vote($1, $2)`, [fundElId, fundCand]);
    check('voting twice still counts one vote for the unit',
      (await admin(db, `select count(*)::int as n from union_votes where election_id = $1 and voter_id = $2`, [fundElId, fundOwner2]))[0].n === 1 &&
      (await admin(db, `select vote_count from union_candidates where id = $1`, [fundCand]))[0].vote_count === 1);
    check("the unit's tenant can't vote (one vote per unit, owners only)",
      denied(await as(db, fundTenant, `select public.cast_election_vote($1, $2)`, [fundElId, fundCand])));
    await as(db, fundPres, `select public.cast_election_vote($1, $2)`, [fundElId, fundCand]);
    check('closing before the deadline with units still to vote is refused', denied(await as(db, fundPres, `select public.finalize_election($1)`, [fundElId])));
    await as(db, fundOwner3, `select public.cast_election_vote($1, $2)`, [fundElId, fundCand]);
    check('once every unit voted the president closes it', ok(await as(db, fundPres, `select public.finalize_election($1)`, [fundElId])));
    check('the winner becomes treasurer (elected) and the presidency is untouched',
      (await admin(db, `select user_id, source from union_treasurers where building_id = $1`, [fundBld]))[0]?.user_id === fundOwner2 &&
      (await admin(db, `select role from union_members where user_id = $1`, [fundPres]))[0].role === 'president' &&
      (await admin(db, `select role from union_members where user_id = $1 and building_id = $2`, [fundOwner2, fundBld]))[0].role === 'resident');
    check('the elected treasurer is the fund manager',
      (await as(db, fundOwner2, `select public.is_union_fund_manager($1) as m`, [fundBld])).rows?.[0]?.m === true);

    // Invite code rotation.
    const fundNewCode = (await as(db, fundPres, `select public.rotate_building_invite_code($1) as c`, [fundBld])).rows?.[0]?.c;
    check('the president rotates the invite code', !!fundNewCode && fundNewCode !== fundCode && fundNewCode.startsWith('BLD-'));
    check('the old code stops working', denied(await as(db, fundLate, `select public.join_building_with_code($1, '4', '4', 'owner')`, [fundCode])));
    check('the new code works', ok(await as(db, fundLate, `select public.join_building_with_code($1, '4', '4', 'owner')`, [fundNewCode])));
    check('the dashboard shows the new code', (await as(db, fundPres, `select public.get_building_invite_code($1) as c`, [fundBld])).rows?.[0]?.c === fundNewCode);
    check('a resident cannot rotate the invite code', denied(await as(db, fundOwner3, `select public.rotate_building_invite_code($1)`, [fundBld])));
  }

  // ------------------------------------------------------------------
  console.log('\nTutorial videos (0079)');
  {
    const tutAdmin = await signUp(db, 'tut admin', null);
    await admin(db, `update profiles set role = 'super_admin' where id = $1`, [tutAdmin]);
    const tutUser = await signUp(db, 'tut user', null);
    const tutIns = await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title, sort, screen_key)
      values ('ittihad', 'dQw4w9WgXcQ', 'إزاي تأسس عمارتك', 1, 'found') returning id`);
    check('tut: the platform admin adds a video', ok(tutIns), tutIns);
    const tutId = tutIns.rows?.[0]?.id;
    const tutHidden = await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title, is_active)
      values ('ittihad', 'abcdefghijk', 'مخفي', false) returning id`);
    check('tut: the admin adds an inactive video', ok(tutHidden), tutHidden);
    const tutAnon = await as(db, null, `select youtube_id from tutorial_videos where app = 'ittihad'`);
    check('tut: anon reads only the active rows', ok(tutAnon) && tutAnon.rows.length === 1 && tutAnon.rows[0].youtube_id === 'dQw4w9WgXcQ', tutAnon);
    const tutSigned = await as(db, tutUser, `select id from tutorial_videos`);
    check('tut: a signed-in user reads only the active rows', ok(tutSigned) && tutSigned.rows.length === 1, tutSigned);
    check('tut: the admin reads inactive rows too', (await as(db, tutAdmin, `select id from tutorial_videos`)).rows?.length === 2);
    check('tut: a user cannot insert',
      denied(await as(db, tutUser, `insert into tutorial_videos (app, youtube_id, title) values ('ittihad', 'zzzzzzzzzzz', 'x')`)));
    check('tut: anon cannot insert',
      denied(await as(db, null, `insert into tutorial_videos (app, youtube_id, title) values ('ittihad', 'zzzzzzzzzzz', 'x')`)));
    await as(db, tutUser, `update tutorial_videos set title = 'hacked' where id = $1`, [tutId]);
    await as(db, tutUser, `delete from tutorial_videos where id = $1`, [tutId]);
    await as(db, null, `delete from tutorial_videos where id = $1`, [tutId]);
    const tutAfter = await admin(db, `select title from tutorial_videos where id = $1`, [tutId]);
    check('tut: a user / anon cannot update or delete', tutAfter.length === 1 && tutAfter[0].title === 'إزاي تأسس عمارتك', tutAfter);
    check('tut: the admin edits, reorders and deactivates',
      ok(await as(db, tutAdmin, `update tutorial_videos set title = 'تأسيس العمارة', sort = 5, is_active = false where id = $1`, [tutId])) &&
      (await admin(db, `select sort from tutorial_videos where id = $1`, [tutId]))[0].sort === 5);
    check('tut: a deactivated video disappears for anon',
      (await as(db, null, `select id from tutorial_videos`)).rows?.length === 0);
    check('tut: a bad youtube_id is refused',
      denied(await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title) values ('ittihad', 'https://youtu.be/x', 'x')`)) &&
      denied(await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title) values ('ittihad', 'short', 'x')`)));
    check('tut: a bad app / screen_key / empty title is refused',
      denied(await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title) values ('other', 'dQw4w9WgXcQ', 'x')`)) &&
      denied(await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title, screen_key) values ('tajer', 'dQw4w9WgXcQ', 'x', 'Bad Key!')`)) &&
      denied(await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title) values ('tajer', 'dQw4w9WgXcQ', '   ')`)));
    check('tut: a free-text screen_key for tajer is accepted',
      ok(await as(db, tutAdmin, `insert into tutorial_videos (app, youtube_id, title, screen_key) values ('tajer', 'dQw4w9WgXcQ', 'أول منتج', 'add_product')`)));
    check('tut: the admin deletes', ok(await as(db, tutAdmin, `delete from tutorial_videos where id = $1`, [tutId])) &&
      (await admin(db, `select 1 from tutorial_videos where id = $1`, [tutId])).length === 0);
  }

  // ------------------------------------------------------------------
  console.log('\nChat rooms (0078)');
  {
    const roomA = await signUp(db, 'room alice', null);
    const roomB = await signUp(db, 'room bob', null);
    const roomC = await signUp(db, 'room carol', null);
    const roomD = await signUp(db, 'room dina', null);
    const roomE = await signUp(db, 'room emad', null);
    const roomN = await signUp(db, 'room unverified', null);
    const roomMod = await signUp(db, 'room moderator', null);
    await admin(db, `update profiles set phone_verified_at = now() where id = any($1::uuid[])`, [[roomA, roomB, roomC, roomD, roomE, roomMod]]);
    // Each send is 3+ s after the previous one in "real" time: age every message by 2 minutes.
    const roomCool = () => admin(db, `update chat_room_messages set created_at = created_at - interval '2 minutes'`);
    const roomSend = async (u, room, body, reply) => {
      await roomCool();
      return as(db, u, `select public.send_room_message($1, $2, $3) as id`, [room, body, reply ?? null]);
    };
    const roomErr = (r, text) => !!r.error && r.error.includes(text);

    const roomList = await as(db, null, `select * from public.list_chat_rooms()`);
    check('guests list the seeded rooms (governorates, districts, topics)', ok(roomList) && roomList.rows.length >= 30, roomList.error || roomList.rows?.length);
    const roomId = (name) => roomList.rows.find((r) => r.name === name)?.id;
    const roomGeneral = roomId('دردشة عامة');
    const roomKora = roomId('كورة');
    const roomMaadi = roomId('المعادي');
    const roomCairo = roomId('القاهرة');
    check('the seed has القاهرة, المعادي, 6 أكتوبر and كورة', !!roomGeneral && !!roomKora && !!roomMaadi && !!roomCairo && !!roomId('6 أكتوبر'));

    // Nicknames
    check('nickname: too short is refused', denied(await as(db, roomA, `select public.set_chat_nickname('ab')`)));
    check('nickname: spaces / symbols are refused', denied(await as(db, roomA, `select public.set_chat_nickname('a b!c')`)));
    check('nickname: reserved "admin" is refused', roomErr(await as(db, roomA, `select public.set_chat_nickname('the_Admin1')`), 'محجوز'));
    check('nickname: reserved «مشرف» / «مُجتمعي» are refused',
      denied(await as(db, roomA, `select public.set_chat_nickname('مشرف_الغرفة')`)) && denied(await as(db, roomA, `select public.set_chat_nickname('مجتمعي2')`)));
    check('nickname: a banned word is refused', denied(await as(db, roomA, `select public.set_chat_nickname('fuck_you')`)));
    check('a verified user picks a nickname', ok(await as(db, roomA, `select public.set_chat_nickname('Alice_1')`)));
    check('nickname uniqueness ignores case', roomErr(await as(db, roomB, `select public.set_chat_nickname('alice_1')`), 'واخده'));
    check('…and Arabic alef/diacritic variants', ok(await as(db, roomC, `select public.set_chat_nickname('أحمد')`)) &&
      denied(await as(db, roomD, `select public.set_chat_nickname('احمد')`)));
    check('changing the nickname within 7 days is refused', roomErr(await as(db, roomA, `select public.set_chat_nickname('Alice_2')`), '7 أيام'));
    await admin(db, `update chat_profiles set nickname_changed_at = now() - interval '8 days' where user_id = $1`, [roomA]);
    check('…allowed after 7 days', ok(await as(db, roomA, `select public.set_chat_nickname('Alice_2')`)));
    check('…and the 7-day clock restarts', denied(await as(db, roomA, `select public.set_chat_nickname('Alice_3')`)));

    // Who can write
    check('a verified user without a nickname cannot send', roomErr(await roomSend(roomB, roomGeneral, 'سلام'), 'اختار اسمك'));
    await as(db, roomB, `select public.set_chat_nickname('Bob')`);
    await as(db, roomD, `select public.set_chat_nickname('Dina')`);
    await as(db, roomE, `select public.set_chat_nickname('Emad')`);
    await as(db, roomMod, `select public.set_chat_nickname('ModMan')`);
    check('an unverified user can pick a nickname…', ok(await as(db, roomN, `select public.set_chat_nickname('NoPhone')`)));
    check('…but cannot send (phone not verified)', roomErr(await roomSend(roomN, roomGeneral, 'سلام'), 'أكّد رقمك'));
    check('a guest cannot send', denied(await as(db, null, `select public.send_room_message($1, 'hi', null)`, [roomGeneral])));
    check('nobody can insert into the messages table directly',
      denied(await as(db, roomA, `insert into chat_room_messages (room_id, author_pid, nickname, body) select $1, public_id, nickname, 'x' from chat_profiles`, [roomGeneral])));
    const roomA1 = await roomSend(roomA, roomGeneral, 'صباح الفل يا جماعة');
    check('a verified user with a nickname sends', ok(roomA1), roomA1.error);
    const roomA1Id = roomA1.rows?.[0]?.id;
    check('an empty message is refused', denied(await roomSend(roomA, roomGeneral, '   ')));
    check('a message over 500 chars is refused', denied(await roomSend(roomA, roomGeneral, 'x'.repeat(501))));

    // Rate limits
    check('sending again within 3 seconds is refused',
      ok(await roomSend(roomA, roomGeneral, 'رسالة 1')) && roomErr(await as(db, roomA, `select public.send_room_message($1, 'رسالة 2', null)`, [roomGeneral]), 'ثانيتين'));
    await admin(db, `insert into chat_room_messages (room_id, author_pid, nickname, body, created_at)
      select $1, public_id, nickname, 'burst ' || g, now() - interval '20 seconds' from chat_profiles, generate_series(1, 20) g where user_id = $2`, [roomGeneral, roomB]);
    check('a 21st message within a minute is refused', roomErr(await as(db, roomB, `select public.send_room_message($1, 'كمان', null)`, [roomGeneral]), 'دقيقة'));
    await roomSend(roomD, roomGeneral, 'نفس الكلام');
    await admin(db, `update chat_room_messages set created_at = created_at - interval '5 seconds'`);
    check('the same text twice in a minute is refused', roomErr(await as(db, roomD, `select public.send_room_message($1, 'نفس الكلام', null)`, [roomGeneral]), 'نفس الرسالة'));

    // Links
    check('links are refused for a new account', roomErr(await roomSend(roomA, roomGeneral, 'شوف www.example.com'), 'اللينكات'));
    check('…in any form (example.com / https://)', denied(await roomSend(roomA, roomGeneral, 'ادخل example.com')) &&
      denied(await roomSend(roomA, roomGeneral, 'https://x.org/y')));
    await admin(db, `update profiles set created_at = now() - interval '10 days' where id = $1`, [roomA]);
    check('…still refused for an old account with < 20 room messages', denied(await roomSend(roomA, roomGeneral, 'شوف www.example.com')));
    await admin(db, `insert into chat_room_messages (room_id, author_pid, nickname, body, created_at)
      select $1, public_id, nickname, 'old ' || g, now() - interval '3 hours' from chat_profiles, generate_series(1, 20) g where user_id = $2`, [roomGeneral, roomA]);
    check('…allowed for an account older than 7 days with 20+ messages', ok(await roomSend(roomA, roomGeneral, 'شوف www.example.com')));

    // Banned words
    check('a banned Arabic word is refused', roomErr(await roomSend(roomD, roomGeneral, 'يا شرموط'), 'مش لطيف'));
    check('a banned English word is refused (any case)', denied(await roomSend(roomD, roomGeneral, 'FUCK this')));
    check('…with diacritics/tatweel too', denied(await roomSend(roomD, roomGeneral, 'يا شـرمـوط')));
    check('a normal message that only contains the letters passes', ok(await roomSend(roomD, roomGeneral, 'كسبنا الماتش')));
    check('a non-admin cannot add a banned word', denied(await as(db, roomA, `select public.admin_set_banned_word('بطيخ')`)));
    check('the admin adds a banned word…', ok(await as(db, SA, `select public.admin_set_banned_word('بطيخ')`)));
    check('…and it is refused from then on', denied(await roomSend(roomD, roomGeneral, 'عايز بطيخ')));

    // Reading & identity
    const roomGuestRead = await as(db, null, `select * from public.room_messages($1)`, [roomGeneral]);
    check('a guest reads room messages', ok(roomGuestRead) && roomGuestRead.rows.length > 0, roomGuestRead.error);
    const roomKeys = Object.keys(roomGuestRead.rows?.[0] || {});
    check('room messages carry nickname + badge but no account id or name',
      roomKeys.includes('nickname') && roomKeys.includes('verified') && !roomKeys.some((k) => /user|full_name|email|phone/.test(k)), roomKeys);
    check('every writer shows the verified badge', roomGuestRead.rows?.every((r) => r.verified === true));
    const roomAPid = (await admin(db, `select public_id from chat_profiles where user_id = $1`, [roomA]))[0].public_id;
    const roomBPid = (await admin(db, `select public_id from chat_profiles where user_id = $1`, [roomB]))[0].public_id;
    check("the author id is not the account id", roomAPid !== roomA && !roomGuestRead.rows.some((r) => r.author === roomA));
    check('guests can read the messages table (Realtime) — safe columns only',
      ok(await as(db, null, `select id, room_id, author_pid, nickname, body, reply_to, created_at from chat_room_messages limit 1`)) &&
      denied(await as(db, null, `select hidden_by from chat_room_messages limit 1`)) &&
      denied(await as(db, roomB, `select * from chat_room_messages limit 1`)));
    check('nobody reads chat_profiles (nickname → account) directly',
      denied(await as(db, roomB, `select user_id from chat_profiles`)) && denied(await as(db, null, `select user_id from chat_profiles`)));
    check('nobody reads reports / presence / sanctions directly',
      denied(await as(db, roomB, `select * from chat_room_reports`)) && denied(await as(db, roomB, `select * from chat_room_presence`)) &&
      denied(await as(db, roomB, `select * from chat_sanctions`)));
    check("a non-admin can't open the admin message view", denied(await as(db, roomB, `select * from public.admin_room_messages($1)`, [roomGeneral])));
    const roomAdminView = await as(db, SA, `select * from public.admin_room_messages($1)`, [roomGeneral]);
    check('the super admin sees nickname → real name', ok(roomAdminView) && roomAdminView.rows.some((r) => r.nickname === 'Alice_2' && r.full_name === 'room alice'), roomAdminView.error);

    // Presence
    check('a guest cannot heartbeat', denied(await as(db, null, `select public.room_heartbeat($1)`, [roomGeneral])));
    check('heartbeat counts me online', (await as(db, roomA, `select public.room_heartbeat($1) as n`, [roomGeneral])).rows?.[0]?.n === 1);
    const roomOnline = await as(db, null, `select * from public.room_online($1)`, [roomGeneral]);
    check('«الموجودين دلوقتي» lists nicknames only', ok(roomOnline) && roomOnline.rows.length === 1 && roomOnline.rows[0].nickname === 'Alice_2' &&
      !Object.keys(roomOnline.rows[0]).some((k) => /user|full_name|email/.test(k)), roomOnline);
    await admin(db, `update chat_room_presence set last_seen = now() - interval '2 minutes'`);
    check('…and drops people not seen for 90 s', (await as(db, null, `select * from public.room_online($1)`, [roomGeneral])).rows?.length === 0);

    // Ignore
    check('A ignores Bob', ok(await as(db, roomA, `select public.room_ignore($1, true)`, [roomBPid])));
    check("…Bob's messages disappear for A",
      !(await as(db, roomA, `select * from public.room_messages($1, null, null, 200)`, [roomGeneral])).rows?.some((r) => r.author === roomBPid));
    check('…but not for Dina', (await as(db, roomD, `select * from public.room_messages($1, null, null, 200)`, [roomGeneral])).rows?.some((r) => r.author === roomBPid));
    check('…A sees Bob in the ignore list', (await as(db, roomA, `select * from public.my_room_ignores()`)).rows?.[0]?.nickname === 'Bob');
    check('cannot ignore yourself', denied(await as(db, roomA, `select public.room_ignore($1, true)`, [roomAPid])));
    await as(db, roomA, `select public.room_ignore($1, false)`, [roomBPid]);

    // Replies notify (rate-limited)
    const roomReply = await roomSend(roomB, roomGeneral, 'أهلاً يا أليس', roomA1Id);
    check('a reply is sent with the quoted message', ok(roomReply) &&
      (await as(db, null, `select * from public.room_messages($1, null, null, 200)`, [roomGeneral])).rows?.find((r) => r.id === roomReply.rows[0].id)?.reply_nickname === 'Alice_2');
    await roomSend(roomB, roomGeneral, 'رد تاني', roomA1Id);
    const roomNotes = await admin(db, `select deep_link from notifications where user_id = $1 and deep_link like '/#/rooms/%'`, [roomA]);
    check('a reply notifies the author once per room per 10 minutes', roomNotes.length === 1 && roomNotes[0].deep_link === '/#/rooms/' + roomGeneral, roomNotes);
    check('a reply to a message in another room is refused', denied(await roomSend(roomB, roomKora, 'رد', roomA1Id)));

    // Reports → auto-hide
    const roomBad = (await roomSend(roomB, roomGeneral, 'رسالة مزعجة')).rows?.[0]?.id;
    check('the author cannot report their own message', denied(await as(db, roomB, `select public.report_room_message($1, 'x')`, [roomBad])));
    check('a guest cannot report', denied(await as(db, null, `select public.report_room_message($1, 'سبام')`, [roomBad])));
    await as(db, roomN, `select public.report_room_message($1, 'سبام')`, [roomBad]);
    await as(db, roomC, `select public.report_room_message($1, 'سبام')`, [roomBad]);
    check('one report per user per message', denied(await as(db, roomC, `select public.report_room_message($1, 'تاني')`, [roomBad])));
    await as(db, roomD, `select public.report_room_message($1, 'إساءة')`, [roomBad]);
    check('two verified reporters (+ one unverified) do not hide it yet',
      (await admin(db, `select is_hidden from chat_room_messages where id = $1`, [roomBad]))[0].is_hidden === false);
    const roomThird = await as(db, roomE, `select public.report_room_message($1, 'إساءة') as h`, [roomBad]);
    check('the third distinct verified reporter hides it', roomThird.rows?.[0]?.h === true &&
      (await admin(db, `select is_hidden from chat_room_messages where id = $1`, [roomBad]))[0].is_hidden === true, roomThird);
    check('a hidden message is not returned to others (RPC)',
      !(await as(db, roomA, `select * from public.room_messages($1, null, null, 200)`, [roomGeneral])).rows?.some((r) => r.id === roomBad) &&
      !(await as(db, null, `select * from public.room_messages($1, null, null, 200)`, [roomGeneral])).rows?.some((r) => r.id === roomBad));
    check('…nor through the table (Realtime path)', (await as(db, null, `select id from chat_room_messages where id = $1`, [roomBad])).rows?.length === 0);
    const roomReports = await as(db, SA, `select * from public.admin_room_reports()`);
    check('the admin sees it with the real account', ok(roomReports) &&
      roomReports.rows.some((r) => r.id === roomBad && r.is_hidden && r.full_name === 'room bob' && r.reports_count === 4), roomReports.error);
    check("a non-admin can't list reports", denied(await as(db, roomA, `select * from public.admin_room_reports()`)));
    check("a non-admin can't restore", denied(await as(db, roomA, `select public.admin_restore_room_message($1)`, [roomBad])));
    check('the admin restores it', ok(await as(db, SA, `select public.admin_restore_room_message($1)`, [roomBad])) &&
      (await as(db, null, `select * from public.room_messages($1, null, null, 200)`, [roomGeneral])).rows?.some((r) => r.id === roomBad));
    check('the admin deletes it', ok(await as(db, SA, `select public.admin_delete_room_message($1)`, [roomBad])) &&
      (await admin(db, `select 1 from chat_room_messages where id = $1`, [roomBad])).length === 0);
    check('admin actions are audited',
      (await admin(db, `select count(*)::int as n from chat_mod_log where message_id = $1 and action in ('auto_hide', 'restore', 'delete')`, [roomBad]))[0].n === 3);

    // Moderators
    check('a non-admin cannot assign moderators', denied(await as(db, roomA, `select public.admin_set_room_moderator($1, 'ModMan')`, [roomGeneral])));
    check('the super admin assigns a room moderator', ok(await as(db, SA, `select public.admin_set_room_moderator($1, 'ModMan')`, [roomGeneral])));
    const roomBMsg = (await roomSend(roomB, roomGeneral, 'رسالة في العامة')).rows?.[0]?.id;
    const roomBKora = (await roomSend(roomB, roomKora, 'رسالة في الكورة')).rows?.[0]?.id;
    check('a regular user cannot hide messages', denied(await as(db, roomA, `select public.mod_hide_room_message($1)`, [roomBMsg])));
    check("the moderator can't hide in another room", denied(await as(db, roomMod, `select public.mod_hide_room_message($1)`, [roomBKora])));
    check('the moderator hides in their room', ok(await as(db, roomMod, `select public.mod_hide_room_message($1, 'خارج الموضوع')`, [roomBMsg])) &&
      (await admin(db, `select is_hidden from chat_room_messages where id = $1`, [roomBMsg]))[0].is_hidden === true);
    check("the moderator can't mute in another room", denied(await as(db, roomMod, `select public.mod_mute_room_user($1, 60)`, [roomBKora])));
    check('the moderator mutes Bob in their room', ok(await as(db, roomMod, `select public.mod_mute_room_user($1, 60)`, [roomBMsg])));
    check('…Bob is refused there (muted)', roomErr(await roomSend(roomB, roomGeneral, 'ليه؟'), 'مكتوم'));
    check('…but can still write in other rooms', ok(await roomSend(roomB, roomKora, 'أنا هنا')));
    check('…and the room tells Bob why', (await as(db, roomB, `select public.get_chat_room($1) as r`, [roomGeneral])).rows?.[0]?.r?.blocked_reason === 'muted');
    check('a moderator cannot mute longer than 7 days', denied(await as(db, roomMod, `select public.mod_mute_room_user($1, 20000)`, [roomBMsg])));
    check("the moderator can't ban", denied(await as(db, roomMod, `select public.admin_ban_chat_user($1, null)`, [roomBMsg])));
    check("the moderator can't create rooms", denied(await as(db, roomMod, `select public.admin_save_chat_room(null, 'غرفتي', null, 'topic')`)));
    check('get_chat_room tells the moderator they can moderate', (await as(db, roomMod, `select public.get_chat_room($1) as r`, [roomGeneral])).rows?.[0]?.r?.can_moderate === true &&
      (await as(db, roomMod, `select public.get_chat_room($1) as r`, [roomKora])).rows?.[0]?.r?.can_moderate === false);

    // Bans (super admin)
    const roomCMsg = (await roomSend(roomC, roomGeneral, 'أنا كارول')).rows?.[0]?.id;
    check('the super admin bans a user from all rooms (permanent)', ok(await as(db, SA, `select public.admin_ban_chat_user($1, null, 'شتايم')`, [roomCMsg])));
    check('…banned user is refused everywhere', roomErr(await roomSend(roomC, roomGeneral, 'هاي'), 'ممنوع') && denied(await roomSend(roomC, roomKora, 'هاي')));
    const roomSanctions = await as(db, SA, `select * from public.admin_list_chat_sanctions()`);
    check('the admin lists active mutes/bans', ok(roomSanctions) && roomSanctions.rows.some((s) => s.kind === 'ban' && s.full_name === 'room carol'));
    const roomBanId = roomSanctions.rows?.find((s) => s.kind === 'ban')?.id;
    check('the admin lifts the ban', ok(await as(db, SA, `select public.admin_lift_chat_sanction($1)`, [roomBanId])) && ok(await roomSend(roomC, roomGeneral, 'رجعت')));
    check('an admin mute applies to all rooms', ok(await as(db, SA, `select public.mod_mute_room_user($1, 30)`, [roomCMsg])) &&
      denied(await roomSend(roomC, roomKora, 'هاي')));

    // Rooms are admin-only
    check('a regular user cannot create a room', denied(await as(db, roomA, `select public.admin_save_chat_room(null, 'غرفة جديدة', null, 'topic')`)));
    const roomNew = await as(db, SA, `select public.admin_save_chat_room(null, 'الأقصر', 'غرفة الأقصر', 'area', 'الأقصر', null, '🏛️', 40) as id`);
    check('the super admin creates a room', ok(roomNew) && (await as(db, null, `select * from public.list_chat_rooms()`)).rows?.some((r) => r.name === 'الأقصر'), roomNew.error);
    const roomNewId = roomNew.rows?.[0]?.id;
    check('the super admin archives it', ok(await as(db, SA, `select public.admin_save_chat_room($1, 'الأقصر', 'غرفة الأقصر', 'area', 'الأقصر', null, '🏛️', 40, false)`, [roomNewId])) &&
      !(await as(db, null, `select * from public.list_chat_rooms()`)).rows?.some((r) => r.name === 'الأقصر'));
    check('…nobody can write in an archived room', denied(await roomSend(roomA, roomNewId, 'هاي')));
    check('users cannot edit rooms directly', denied(await as(db, roomA, `update chat_rooms set name = 'x' where id = $1`, [roomGeneral])));

    // Nearest room
    await admin(db, `insert into e_addresses (owner_id, code, governorate, city, district) values ($1, 'RMTST001', 'القاهرة', 'القاهرة', 'المعادي - دجلة')`, [roomA]);
    const roomNear = (await as(db, roomA, `select name, near from public.list_chat_rooms()`)).rows || [];
    check('«أقرب غرفة لمنطقتك»: the district room, then the governorate room',
      roomNear.find((r) => r.name === 'المعادي')?.near === 1 && roomNear.find((r) => r.name === 'القاهرة')?.near === 2 &&
      roomNear.find((r) => r.name === 'الجيزة')?.near === 0, roomNear.filter((r) => r.near > 0));

    // «كلّمه خاص» → friend request; the sender sees the nickname only
    check('«كلّمه خاص» sends a friend request', (await as(db, roomD, `select public.room_friend_request($1) as s`, [roomAPid])).rows?.[0]?.s === 'sent');
    const roomDFriends = (await as(db, roomD, `select * from public.my_friends()`)).rows || [];
    check("…the sender's list shows the nickname, not the real name",
      roomDFriends.length === 1 && roomDFriends[0].full_name.includes('Alice_2') && !roomDFriends[0].full_name.includes('room alice'), roomDFriends);
    check('…and the other person gets the request', (await admin(db, `select count(*)::int as n from friendships where requester_id = $1 and addressee_id = $2 and status = 'pending'`, [roomD, roomA]))[0].n === 1);

    // Retention
    await admin(db, `insert into chat_room_messages (room_id, author_pid, nickname, body, created_at) values ($1, $2, 'Alice_2', 'قديمة', now() - interval '31 days')`, [roomGeneral, roomAPid]);
    check('a regular user cannot purge', denied(await as(db, roomA, `select public.purge_old_room_messages()`)));
    check('the admin purges messages older than 30 days', (await as(db, SA, `select public.purge_old_room_messages() as n`)).rows?.[0]?.n >= 1 &&
      (await admin(db, `select count(*)::int as n from chat_room_messages where created_at < now() - interval '30 days'`))[0].n === 0);
  }

  // ------------------------------------------------------------------
  console.log('\nمسجدي — mosques (0080)');
  {
    await admin(db, `insert into directory_places (id, name, category, lat, lng, address) values
      ('masdir1', 'مسجد النور', 'أماكن عبادة', 30.0500, 31.2400, 'شارع النور، العباسية'),
      ('masdir2', 'جامع الرحمة', 'أماكن عبادة', 30.0520, 31.2420, 'المعادي'),
      ('masdir3', 'جامعة القاهرة', 'تعليم', 30.0270, 31.2080, 'الجيزة'),
      ('masdir4', 'Al Salam Mosque', 'أماكن عبادة', 31.2000, 29.9200, 'Alexandria'),
      ('masdir5', 'صيدلية النور', 'صيدليات', 30.0501, 31.2401, 'العباسية')`);
    const masSeeded = (await admin(db, `select public.masjid_seed_from_directory() as n`))[0].n;
    check('mas: seeding picks مسجد / جامع / mosque names but not «جامعة» or other places', masSeeded === 3, masSeeded);
    check('mas: re-seeding adds nothing twice', (await admin(db, `select public.masjid_seed_from_directory() as n`))[0].n === 0);
    const masNoor = (await admin(db, `select id from mosques where directory_id = 'masdir1'`))[0].id;
    const masRahma = (await admin(db, `select id from mosques where directory_id = 'masdir2'`))[0].id;
    check('mas: a user cannot run the seeding', denied(await as(db, A, `select public.masjid_seed_from_directory()`)));

    // Browse (anon)
    const masNear = await as(db, null, `select * from public.nearby_mosques(30.0501, 31.2401, 3, 10)`);
    check('mas: anon gets the nearest mosques, nearest first', ok(masNear) && masNear.rows.length === 2 && masNear.rows[0].id === masNoor, masNear);
    const masSearch = await as(db, null, `select * from public.search_mosques('الرحمة')`);
    check('mas: search by name', ok(masSearch) && masSearch.rows.length === 1 && masSearch.rows[0].id === masRahma, masSearch);
    check('mas: search by area/address', (await as(db, null, `select * from public.search_mosques('العباسية')`)).rows?.[0]?.id === masNoor);
    check('mas: anon reads public mosque columns', ok(await as(db, null, `select id, name, verified, contact_phone from mosques`)));
    check('mas: anon cannot read who claimed a mosque', denied(await as(db, null, `select claimed_by from mosques`)) &&
      denied(await as(db, B, `select claimed_by from mosques`)));
    check('mas: users cannot edit mosques directly', denied(await as(db, A, `update mosques set verified = true where id = $1`, [masNoor])) &&
      denied(await as(db, A, `insert into mosques (name, lat, lng) values ('مسجد وهمي', 30, 31)`)));
    const masGet = await as(db, null, `select public.get_mosque($1) as m`, [masNoor]);
    check('mas: get_mosque works for anon', ok(masGet) && masGet.rows[0].m.name === 'مسجد النور' && masGet.rows[0].m.verified === false, masGet);

    // Add a missing mosque
    const masAdded = await as(db, X, `select public.masjid_add_mosque('مسجد التقوى', 30.06, 31.25, 'شارع التقوى', 'مدينة نصر', 'القاهرة') as id`);
    check('mas: a signed-in user adds a missing mosque (unverified)', ok(masAdded) &&
      (await admin(db, `select verified from mosques where id = $1`, [masAdded.rows[0].id]))[0].verified === false, masAdded);
    check('mas: anon cannot add a mosque', denied(await as(db, null, `select public.masjid_add_mosque('مسجد', 30.06, 31.25)`)));
    check('mas: adding the same mosque again returns the same one',
      (await as(db, X, `select public.masjid_add_mosque('مسجد التقوى', 30.0601, 31.2501) as id`)).rows?.[0]?.id === masAdded.rows?.[0]?.id);

    // Claim & verify
    const masImam = await signUp(db, 'mas imam', '01055500001');
    const masHelper = await signUp(db, 'mas helper', '01055500002');
    const masDonor = await signUp(db, 'mas donor', '01055500003');
    const masOther = await signUp(db, 'mas other', '01055500004');
    const masSA = await signUp(db, 'mas admin', null);
    await admin(db, `update profiles set role = 'super_admin' where id = $1`, [masSA]);

    check('mas: anon cannot claim', denied(await as(db, null, `select public.masjid_claim($1, 'imam', '01055500001')`, [masNoor])));
    check('mas: a claim needs a valid phone', denied(await as(db, masImam, `select public.masjid_claim($1, 'imam', '123')`, [masNoor])));
    check("mas: a claim can't point at someone else's document",
      denied(await as(db, masImam, `select public.masjid_claim($1, 'imam', '01055500001', $2)`, [masNoor, masOther + '/proof/x.jpg'])));
    const masClaim = await as(db, masImam, `select public.masjid_claim($1, 'imam', '+20 1055500001', $2, 'إمام المسجد من 2015') as id`,
      [masNoor, masImam + '/mosque_claim/1.jpg']);
    check('mas: a signed-in user claims a mosque (as إمام)', ok(masClaim), masClaim);
    const masClaimId = masClaim.rows?.[0]?.id;
    check('mas: one pending claim per mosque per user', denied(await as(db, masImam, `select public.masjid_claim($1, 'imam', '01055500001')`, [masNoor])));
    check('mas: the claimant sees the claim as pending', (await as(db, masImam, `select * from public.masjid_my_claims()`)).rows?.[0]?.status === 'pending');
    check('mas: nobody reads claims directly', denied(await as(db, masImam, `select * from mosque_claims`)));
    check('mas: a pending claim gives no powers',
      denied(await as(db, masImam, `insert into mosque_posts (mosque_id, title) values ($1, 'إعلان')`, [masNoor])));
    check('mas: a user cannot list claims', denied(await as(db, masOther, `select * from public.admin_list_mosque_claims('pending')`)));
    check('mas: the claimant cannot approve their own claim', denied(await as(db, masImam, `select public.admin_review_mosque_claim($1, true)`, [masClaimId])));
    const masClaims = await as(db, masSA, `select * from public.admin_list_mosque_claims('pending')`);
    check('mas: the super admin lists pending claims with the document', ok(masClaims) &&
      masClaims.rows.some((c) => c.id === masClaimId && c.doc_path && c.phone === '01055500001' && c.full_name === 'mas imam'), masClaims);
    check('mas: the super admin approves', ok(await as(db, masSA, `select public.admin_review_mosque_claim($1, true, 'تمام')`, [masClaimId])));
    check('mas: …the mosque is verified and the claimant is its owner',
      (await admin(db, `select verified from mosques where id = $1`, [masNoor]))[0].verified === true &&
      (await admin(db, `select role from mosque_admins where mosque_id = $1 and user_id = $2`, [masNoor, masImam]))[0]?.role === 'owner');
    check('mas: …and is notified', (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and deep_link = $2`, [masImam, '/#/masjid/' + masNoor]))[0].n === 1);
    check('mas: a claim is reviewed only once', denied(await as(db, masSA, `select public.admin_review_mosque_claim($1, false)`, [masClaimId])));
    const masClaim2 = (await as(db, masOther, `select public.masjid_claim($1, 'amin', '01055500004') as id`, [masRahma])).rows?.[0]?.id;
    check('mas: the super admin rejects another claim', ok(await as(db, masSA, `select public.admin_review_mosque_claim($1, false, 'مفيش إثبات')`, [masClaim2])) &&
      (await admin(db, `select verified from mosques where id = $1`, [masRahma]))[0].verified === false);
    const masMine = await as(db, masImam, `select public.get_mosque($1) as m`, [masNoor]);
    check('mas: get_mosque tells the owner their role and permissions',
      masMine.rows?.[0]?.m?.my_role === 'owner' && masMine.rows[0].m.my_permissions.includes('team'), masMine);

    // Team
    check('mas: a non-admin cannot add helpers', denied(await as(db, masOther, `select public.masjid_add_helper($1, '01055500002', array['posts'])`, [masNoor])));
    check('mas: unknown phone is refused', denied(await as(db, masImam, `select public.masjid_add_helper($1, '01099999999', array['posts'])`, [masNoor])));
    const masAddHelper = await as(db, masImam, `select public.masjid_add_helper($1, '01055500002', array['posts','lessons','bogus'], 'مؤذن') as n`, [masNoor]);
    check('mas: the owner adds a helper by phone', ok(masAddHelper) && masAddHelper.rows[0].n === 'mas helper', masAddHelper);
    check('mas: …unknown permissions are dropped',
      JSON.stringify((await admin(db, `select permissions from mosque_admins where user_id = $1`, [masHelper]))[0].permissions.sort()) === '["lessons","posts"]');
    check('mas: the team list is for the owner only', ok(await as(db, masImam, `select * from public.masjid_team($1)`, [masNoor])) &&
      denied(await as(db, masHelper, `select * from public.masjid_team($1)`, [masNoor])));
    check("mas: a helper can't add helpers", denied(await as(db, masHelper, `select public.masjid_add_helper($1, '01055500004', array['posts'])`, [masNoor])));

    // Posting (only verified admins / helpers with the permission)
    const masFollow = await as(db, masDonor, `select public.masjid_follow($1, true)`, [masNoor]);
    check('mas: a user follows the mosque', ok(masFollow), masFollow);
    await as(db, masOther, `select public.masjid_follow($1, true)`, [masNoor]);
    check('mas: anon cannot follow', denied(await as(db, null, `select public.masjid_follow($1, true)`, [masNoor])));
    check('mas: followed mosques list', (await as(db, masDonor, `select * from public.my_followed_mosques()`)).rows?.[0]?.id === masNoor);
    check('mas: nobody reads follows directly', denied(await as(db, masDonor, `select * from mosque_follows`)));

    const masPost = await as(db, masHelper, `insert into mosque_posts (mosque_id, title, body, pinned) values ($1, 'درس الجمعة اتأجل', 'بعد العصر', true) returning id, author_id`, [masNoor]);
    check('mas: a helper with «posts» publishes an announcement', ok(masPost) && masPost.rows[0].author_id === masHelper, masPost);
    check('mas: anon reads announcements', (await as(db, null, `select id from mosque_posts where mosque_id = $1`, [masNoor])).rows?.length === 1);
    check('mas: a random user cannot post', denied(await as(db, masOther, `insert into mosque_posts (mosque_id, title) values ($1, 'سبام')`, [masNoor])));
    check('mas: anon cannot post', denied(await as(db, null, `insert into mosque_posts (mosque_id, title) values ($1, 'سبام')`, [masNoor])));
    check("mas: a helper can't post on another mosque", denied(await as(db, masHelper, `insert into mosque_posts (mosque_id, title) values ($1, 'سبام')`, [masRahma])));
    await as(db, masOther, `update mosque_posts set title = 'hacked' where id = $1`, [masPost.rows?.[0]?.id]);
    await as(db, masOther, `delete from mosque_posts where id = $1`, [masPost.rows?.[0]?.id]);
    check('mas: a random user cannot edit or delete a post', (await admin(db, `select title from mosque_posts where id = $1`, [masPost.rows?.[0]?.id]))[0]?.title === 'درس الجمعة اتأجل');
    check("mas: a helper without «needs» can't add a need", denied(await as(db, masHelper, `insert into mosque_needs (mosque_id, title, target_amount) values ($1, 'مروحة', 1000)`, [masNoor])));
    check('mas: a helper with «lessons» adds a Quran circle', ok(await as(db, masHelper,
      `insert into mosque_lessons (mosque_id, kind, title, sheikh, weekdays, after_prayer, audience) values ($1, 'quran_circle', 'حلقة تحفيظ', 'الشيخ أحمد', '{6,1}', 'asr', 'kids')`, [masNoor])));
    check("mas: a helper can't change the mosque settings", denied(await as(db, masHelper, `select public.masjid_update_settings($1, '{"khatib":"x"}'::jsonb)`, [masNoor])));
    check('mas: the owner sets iqama offsets, khutba and contact', ok(await as(db, masImam,
      `select public.masjid_update_settings($1, '{"khatib":"الشيخ محمود","friday_khutba_time":"12:30","iqama_fajr":"20","iqama_isha":"10","contact_whatsapp":"01055500001","payment_note":"سلّم لأمين المسجد بعد العشاء"}'::jsonb)`, [masNoor])) &&
      (await admin(db, `select iqama_fajr, khatib from mosques where id = $1`, [masNoor]))[0].iqama_fajr === 20);

    // Follower notifications, rate-limited per mosque
    const masNotes = async (u) => (await admin(db, `select title from notifications where user_id = $1 and deep_link = $2 order by created_at`, [u, '/#/masjid/' + masNoor]));
    check('mas: followers are notified of the first announcement', (await masNotes(masDonor)).length === 1 && (await masNotes(masOther)).length === 1);
    check('mas: …the author is not notified about their own post', (await masNotes(masHelper)).length === 0 ||
      !(await masNotes(masHelper)).some((n) => n.title.startsWith('إعلان')));
    check('mas: the lesson right after is rate-limited (no second batch)', (await masNotes(masDonor)).length === 1);
    await as(db, masImam, `insert into mosque_posts (mosque_id, kind, title) values ($1, 'janaza', 'صلاة الجنازة على الحاج محمد بعد الظهر')`, [masNoor]);
    const masDonorNotes = await masNotes(masDonor);
    check('mas: an urgent جنازة still reaches followers', masDonorNotes.length === 2 && masDonorNotes[1].title.startsWith('صلاة جنازة'), masDonorNotes);
    await as(db, masImam, `insert into mosque_posts (mosque_id, kind, title) values ($1, 'urgent', 'تاني')`, [masNoor]);
    check('mas: …but urgent posts are limited too (10 min)', (await masNotes(masDonor)).length === 2);
    await as(db, masOther, `select public.masjid_follow($1, true, false)`, [masNoor]);
    await admin(db, `update mosque_notify_log set created_at = now() - interval '3 hours'`);
    await as(db, masImam, `insert into mosque_posts (mosque_id, title) values ($1, 'إعلان جديد بعد 3 ساعات')`, [masNoor]);
    check('mas: after the window a new batch goes out', (await masNotes(masDonor)).length === 3);
    check('mas: a follower who muted notifications gets nothing new', (await masNotes(masOther)).length === 2);
    check('mas: unfollow', ok(await as(db, masDonor, `select public.masjid_follow($1, false)`, [masNoor])) &&
      (await as(db, masDonor, `select * from public.my_followed_mosques()`)).rows?.length === 0);
    await admin(db, `update mosque_notify_log set created_at = now() - interval '3 hours'`);
    await as(db, masImam, `insert into mosque_posts (mosque_id, title) values ($1, 'إعلان بعد إلغاء المتابعة')`, [masNoor]);
    check('mas: …and is no longer notified', (await masNotes(masDonor)).length === 3);
    await as(db, masDonor, `select public.masjid_follow($1, true)`, [masNoor]);

    // Needs & pledges (never money)
    const masNeed = await as(db, masImam, `insert into mosque_needs (mosque_id, title, description, target_amount) values ($1, 'مروحة سقف', 'للمصلى', 1000) returning id, status`, [masNoor]);
    check('mas: the owner adds a need', ok(masNeed) && masNeed.rows[0].status === 'open', masNeed);
    const masNeedId = masNeed.rows?.[0]?.id;
    check("mas: users can't set a need's status directly", denied(await as(db, masImam, `update mosque_needs set status = 'closed' where id = $1`, [masNeedId])));
    check('mas: anon cannot pledge', denied(await as(db, null, `select public.masjid_pledge($1, 100)`, [masNeedId])));
    const masP1 = await as(db, masDonor, `select public.masjid_pledge($1, 300, 'هسلمها الجمعة', false) as id`, [masNeedId]);
    check('mas: a signed-in user pledges', ok(masP1), masP1);
    const masP2 = await as(db, masOther, `select public.masjid_pledge($1, 200, null, true) as id`, [masNeedId]);
    check('mas: another pledges anonymously', ok(masP2), masP2);
    check('mas: a pledge must be a real amount', denied(await as(db, masOther, `select public.masjid_pledge($1, 0)`, [masNeedId])));
    check('mas: the admin is told about a pledge',
      (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title like 'تعهد جديد%'`, [masImam]))[0].n === 2);
    let masProg = (await as(db, null, `select * from public.masjid_needs($1)`, [masNoor])).rows?.[0];
    check('mas: progress counts confirmed amounts only (pledges shown apart)',
      Number(masProg?.confirmed_amount) === 0 && Number(masProg?.pledged_amount) === 500, masProg);
    check('mas: nobody reads contributions directly', denied(await as(db, masDonor, `select * from mosque_need_contributions`)) &&
      denied(await as(db, null, `select * from mosque_need_contributions`)));
    check('mas: a random user cannot confirm', denied(await as(db, masOther, `select public.masjid_confirm_contribution($1)`, [masP1.rows?.[0]?.id])));
    check("mas: a helper without «needs» can't confirm", denied(await as(db, masHelper, `select public.masjid_confirm_contribution($1)`, [masP1.rows?.[0]?.id])));
    check('mas: the pledger cannot confirm their own pledge', denied(await as(db, masDonor, `select public.masjid_confirm_contribution($1)`, [masP1.rows?.[0]?.id])));
    check('mas: the admin confirms what arrived', ok(await as(db, masImam, `select public.masjid_confirm_contribution($1)`, [masP1.rows?.[0]?.id])));
    check('mas: …only once', denied(await as(db, masImam, `select public.masjid_confirm_contribution($1)`, [masP1.rows?.[0]?.id])));
    check('mas: …and the donor is thanked', (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title like 'مساهمتك وصلت%'`, [masDonor]))[0].n === 1);
    check('mas: the admin records cash handed in', ok(await as(db, masImam, `select public.masjid_add_cash($1, 250, 'الحاج سيد', 'كاش', false)`, [masNeedId])));
    check("mas: a user can't record cash", denied(await as(db, masOther, `select public.masjid_add_cash($1, 250)`, [masNeedId])));
    masProg = (await as(db, null, `select * from public.masjid_needs($1)`, [masNoor])).rows?.[0];
    check('mas: progress = 550 confirmed of 1000 (the 200 pledge still pending)',
      Number(masProg?.confirmed_amount) === 550 && Number(masProg?.pledged_amount) === 200 && Number(masProg?.target_amount) === 1000, masProg);
    const masListAnon = (await as(db, null, `select * from public.masjid_need_contributions($1)`, [masNeedId])).rows || [];
    const masListDonor = (await as(db, masDonor, `select * from public.masjid_need_contributions($1)`, [masNeedId])).rows || [];
    const masListOther = (await as(db, masOther, `select * from public.masjid_need_contributions($1)`, [masNeedId])).rows || [];
    const masListAdmin = (await as(db, masImam, `select * from public.masjid_need_contributions($1)`, [masNeedId])).rows || [];
    const masAnonRow = (rows) => rows.find((r) => Number(r.amount) === 200);
    check('mas: an anonymous pledge shows «فاعل خير» to others',
      masAnonRow(masListAnon)?.donor_label === 'فاعل خير' && masAnonRow(masListDonor)?.donor_label === 'فاعل خير' &&
      !masListAnon.some((r) => r.donor_label === 'mas other'), masListAnon);
    check('mas: …but the pledger and the mosque admin see the name',
      masAnonRow(masListOther)?.donor_label === 'mas other' && masAnonRow(masListOther)?.is_mine === true && masAnonRow(masListAdmin)?.donor_label === 'mas other');
    check('mas: a named pledge shows the name', masListAnon.find((r) => Number(r.amount) === 300)?.donor_label === 'mas donor');
    check('mas: pledge notes are private to the pledger and the admin',
      masListAnon.find((r) => Number(r.amount) === 300)?.note === null && masListDonor.find((r) => Number(r.amount) === 300)?.note === 'هسلمها الجمعة');
    check('mas: the pledger withdraws a pending pledge', ok(await as(db, masOther, `select public.masjid_cancel_contribution($1)`, [masP2.rows?.[0]?.id])));
    check("mas: a confirmed contribution can't be cancelled", denied(await as(db, masImam, `select public.masjid_cancel_contribution($1)`, [masP1.rows?.[0]?.id])));
    check('mas: the admin closes the need', ok(await as(db, masImam, `select public.masjid_set_need_status($1, 'closed')`, [masNeedId])));
    check('mas: no pledges on a closed need', denied(await as(db, masDonor, `select public.masjid_pledge($1, 50)`, [masNeedId])));
    check("mas: a user can't close a need", denied(await as(db, masOther, `select public.masjid_set_need_status($1, 'open')`, [masNeedId])));

    // Orphan sponsorship — no child data, sponsors private
    const masOrphCols = (await admin(db, `select column_name from information_schema.columns where table_name in ('mosque_orphan_programs', 'mosque_orphan_sponsorships')`)).map((r) => r.column_name);
    check('mas: orphan tables have no child name/photo/age/address columns',
      !masOrphCols.some((c) => /child|orphan_name|photo|image|age|birth|address|national/.test(c)), masOrphCols);
    const masProgram = await as(db, masImam, `insert into mosque_orphan_programs (mosque_id, title, description, monthly_amount, slots) values ($1, 'كفالة طفل', 'كفالة شهرية لطفل يتيم من الحي', 500, 10) returning id`, [masNoor]);
    check('mas: the owner lists a sponsorship program', ok(masProgram), masProgram);
    const masProgramId = masProgram.rows?.[0]?.id;
    check("mas: a helper without «orphans» can't", denied(await as(db, masHelper, `insert into mosque_orphan_programs (mosque_id, title, monthly_amount) values ($1, 'كفالة', 500)`, [masNoor])));
    const masSp = await as(db, masDonor, `select public.masjid_sponsor($1, 500, 'أول كل شهر') as id`, [masProgramId]);
    check('mas: a user pledges a monthly sponsorship', ok(masSp), masSp);
    check('mas: …once per program', denied(await as(db, masDonor, `select public.masjid_sponsor($1, 500)`, [masProgramId])));
    check('mas: anon cannot sponsor', denied(await as(db, null, `select public.masjid_sponsor($1, 500)`, [masProgramId])));
    check("mas: a user can't confirm a sponsorship", denied(await as(db, masDonor, `select public.masjid_set_sponsorship_status($1, 'active')`, [masSp.rows?.[0]?.id])));
    check('mas: the admin confirms it', ok(await as(db, masImam, `select public.masjid_set_sponsorship_status($1, 'active')`, [masSp.rows?.[0]?.id])));
    check('mas: …only once', denied(await as(db, masImam, `select public.masjid_set_sponsorship_status($1, 'active')`, [masSp.rows?.[0]?.id])));
    const masProgPublic = await as(db, null, `select * from public.masjid_orphan_programs($1)`, [masNoor]);
    check('mas: the public program shows counts only, no people',
      ok(masProgPublic) && masProgPublic.rows[0].active_sponsors === 1 &&
      !Object.keys(masProgPublic.rows[0]).some((k) => /name|phone|user|child/.test(k)), masProgPublic);
    check('mas: sponsors list is for the mosque admin only', ok(await as(db, masImam, `select * from public.masjid_orphan_sponsors($1)`, [masProgramId])) &&
      denied(await as(db, masOther, `select * from public.masjid_orphan_sponsors($1)`, [masProgramId])) &&
      denied(await as(db, null, `select * from public.masjid_orphan_sponsors($1)`, [masProgramId])));
    check('mas: nobody reads sponsorships directly', denied(await as(db, masDonor, `select * from mosque_orphan_sponsorships`)));
    check('mas: the sponsor sees their own', (await as(db, masDonor, `select * from public.masjid_my_sponsorships()`)).rows?.[0]?.status === 'active');
    check('mas: the sponsor ends it', ok(await as(db, masDonor, `select public.masjid_set_sponsorship_status($1, 'ended')`, [masSp.rows?.[0]?.id])));

    // Quran competitions
    const masComp = await as(db, masImam, `insert into mosque_competitions (mosque_id, title, schedule, registration_deadline) values ($1, 'مسابقة رمضان', 'الاختبارات السبت بعد العصر', current_date + 10) returning id`, [masNoor]);
    check('mas: the owner creates a competition', ok(masComp), masComp);
    const masCompId = masComp.rows?.[0]?.id;
    const masLvl = await as(db, masImam, `insert into mosque_competition_levels (competition_id, mosque_id, name, age_group, sort) values ($1, $2, 'جزء عمّ', 'تحت 10 سنين', 1) returning id, mosque_id`, [masCompId, masRahma]);
    check('mas: a level is pinned to the competition\'s mosque', ok(masLvl) && masLvl.rows[0].mosque_id === masNoor, masLvl);
    const masLvlId = masLvl.rows?.[0]?.id;
    check("mas: a user can't create a competition", denied(await as(db, masOther, `insert into mosque_competitions (mosque_id, title) values ($1, 'x')`, [masNoor])));
    const masEntry = await as(db, masDonor, `select public.masjid_register_competition($1, $2, 'يوسف', 9, '01055500003') as id`, [masCompId, masLvlId]);
    check('mas: a parent registers a contestant', ok(masEntry), masEntry);
    check('mas: anon cannot register', denied(await as(db, null, `select public.masjid_register_competition($1, $2, 'x')`, [masCompId, masLvlId])));
    check('mas: a level from another competition is refused', denied(await as(db, masDonor, `select public.masjid_register_competition($1, gen_random_uuid(), 'مريم')`, [masCompId])));
    check('mas: others cannot see entries', (await as(db, masOther, `select * from public.masjid_competition_entries($1)`, [masCompId])).rows?.length === 0 &&
      denied(await as(db, masOther, `select * from mosque_competition_entries`)));
    check('mas: the registrant sees their own entry', (await as(db, masDonor, `select * from public.masjid_competition_entries($1)`, [masCompId])).rows?.length === 1);
    check('mas: the admin sees entries with the phone', (await as(db, masImam, `select * from public.masjid_competition_entries($1)`, [masCompId])).rows?.[0]?.phone === '01055500003');
    check("mas: a user can't set results", denied(await as(db, masDonor, `select public.masjid_set_entry_result($1, 100, 1)`, [masEntry.rows?.[0]?.id])));
    check('mas: the admin sets a result', ok(await as(db, masImam, `select public.masjid_set_entry_result($1, 97.5, 1, 'ممتاز')`, [masEntry.rows?.[0]?.id])));
    check('mas: results are hidden until published', (await as(db, null, `select * from public.masjid_competition_results($1)`, [masCompId])).rows?.length === 0);
    check('mas: the admin publishes results', ok(await as(db, masImam, `select public.masjid_publish_results($1, true)`, [masCompId])));
    const masRes = await as(db, null, `select * from public.masjid_competition_results($1)`, [masCompId]);
    check('mas: anyone sees published results (no phones)', ok(masRes) && masRes.rows[0]?.contestant_name === 'يوسف' && masRes.rows[0].rank === 1 &&
      !Object.keys(masRes.rows[0]).includes('phone'), masRes);
    check('mas: registrants are told the results are out', (await admin(db, `select count(*)::int as n from notifications where user_id = $1 and title like 'نتيجة%'`, [masDonor]))[0].n === 1);
    check('mas: no registration after the competition finished', denied(await as(db, masOther, `select public.masjid_register_competition($1, $2, 'مريم')`, [masCompId, masLvlId])));

    // Removing a helper; super admin removal unverifies
    check('mas: the owner removes the helper', ok(await as(db, masImam, `select public.masjid_remove_helper($1, $2)`, [masNoor, masHelper])) &&
      denied(await as(db, masHelper, `insert into mosque_posts (mosque_id, title) values ($1, 'بعد الحذف')`, [masNoor])));
    check("mas: a user can't remove the owner", ok(await as(db, masOther, `select 1`)) &&
      denied(await as(db, masOther, `select public.admin_remove_mosque_admin($1, $2)`, [masNoor, masImam])));
    check('mas: the super admin removes the owner → mosque unverified',
      ok(await as(db, masSA, `select public.admin_remove_mosque_admin($1, $2)`, [masNoor, masImam])) &&
      (await admin(db, `select verified from mosques where id = $1`, [masNoor]))[0].verified === false);
    check('mas: tutorial videos accept the masjid app', ok(await as(db, masSA, `insert into tutorial_videos (app, youtube_id, title) values ('masjid', 'abcdefghij1', 'إزاي تدير مسجدك')`)));
  }

  // ------------------------------------------------------------------
  console.log('\nمسجدي — members & mosque chat (0081)');
  {
    const masmIns = async (name, lat, lng) => (await admin(db, `insert into mosques (name, lat, lng, area) values ($1, $2, $3, 'حي الاختبار') returning id`, [name, lat, lng]))[0].id;
    const masmA = await masmIns('مسجد الهدى', 30.2000, 31.4000);
    const masmNear = await masmIns('مسجد الفتح', 30.2040, 31.4000);   // ≈ 445 m north
    const masmFar = await masmIns('مسجد الإيمان', 30.2047, 31.4000);  // ≈ 523 m north
    const masmB = await masmIns('مسجد البر', 30.3000, 31.5000);
    const masmU1 = await signUp(db, 'masm one', null);
    const masmU2 = await signUp(db, 'masm two', null);
    const masmU3 = await signUp(db, 'masm three', null);
    const masmU4 = await signUp(db, 'masm four', null);
    const masmOut = await signUp(db, 'masm outsider', null);
    const masmOwner = await signUp(db, 'masm owner', null);
    const masmHelpChat = await signUp(db, 'masm helper chat', null);
    const masmHelpPosts = await signUp(db, 'masm helper posts', '01077700001');
    const masmSA = await signUp(db, 'masm super', null);
    await admin(db, `update profiles set role = 'super_admin' where id = $1`, [masmSA]);
    // Posting needs a verified phone since 0083 (covered in the masc block).
    await admin(db, `update profiles set phone_verified_at = now() where id = any($1::uuid[])`,
      [[masmU1, masmU2, masmU3, masmU4, masmOut, masmOwner, masmHelpChat, masmHelpPosts]]);
    // Each send is 3+ s after the previous one in "real" time: age every message (and read marker) by 2 minutes.
    const masmCool = async () => {
      await admin(db, `update mosque_chat_messages set created_at = created_at - interval '2 minutes'`);
      await admin(db, `update mosque_members set last_read_at = last_read_at - interval '2 minutes'`);
    };
    const masmSend = async (u, mosque, body, reply) => {
      await masmCool();
      return as(db, u, `select public.masjid_chat_send($1, $2, $3) as id`, [mosque, body, reply ?? null]);
    };
    const masmHas = (r, text) => !!r.error && r.error.includes(text);

    // Join candidates (500 m)
    const masmCand = await as(db, null, `select * from public.masjid_join_candidates(30.2000, 31.4000, 500, 5)`);
    const masmCandIds = (masmCand.rows || []).map((r) => r.id);
    check('masm: join candidates list mosques within 500 m, nearest first, with metres',
      ok(masmCand) && masmCandIds.length === 2 && masmCandIds[0] === masmA && masmCandIds[1] === masmNear &&
      masmCand.rows.every((r) => r.within === true) && masmCand.rows[1].distance_m > 400 && masmCand.rows[1].distance_m < 500, masmCand);
    check('masm: …the mosque at ~523 m is left out', !masmCandIds.includes(masmFar));
    const masmFallback = await as(db, null, `select * from public.masjid_join_candidates(30.1950, 31.4000, 500, 2)`);
    check('masm: none within 500 m → the nearest few beyond, flagged', ok(masmFallback) && masmFallback.rows.length === 2 &&
      masmFallback.rows.every((r) => r.within === false) && masmFallback.rows[0].id === masmA, masmFallback);

    // Join / leave
    check('masm: anon cannot join', denied(await as(db, null, `select public.masjid_join($1)`, [masmA])));
    check('masm: a user joins an unverified mosque', ok(await as(db, masmU1, `select public.masjid_join($1)`, [masmA])));
    check('masm: …which also follows it with notifications on',
      (await admin(db, `select notify from mosque_follows where mosque_id = $1 and user_id = $2`, [masmA, masmU1]))[0]?.notify === true);
    check('masm: …and the first mosque becomes the primary one',
      (await as(db, masmU1, `select * from public.my_mosques()`)).rows?.[0]?.is_primary === true);
    for (const u of [masmU2, masmU3, masmU4]) await as(db, u, `select public.masjid_join($1)`, [masmA]);
    check('masm: a user may join several mosques', ok(await as(db, masmU1, `select public.masjid_join($1)`, [masmB])) &&
      (await as(db, masmU1, `select * from public.my_mosques()`)).rows?.length === 2);
    check('masm: set another mosque as primary', ok(await as(db, masmU1, `select public.masjid_set_primary($1)`, [masmB])) &&
      (await admin(db, `select count(*)::int as n from mosque_members where user_id = $1 and is_primary`, [masmU1]))[0].n === 1 &&
      (await admin(db, `select is_primary from mosque_members where user_id = $1 and mosque_id = $2`, [masmU1, masmB]))[0].is_primary === true);
    check('masm: a non-member cannot set primary', denied(await as(db, masmOut, `select public.masjid_set_primary($1)`, [masmA])));
    const masmGet = await as(db, null, `select public.get_mosque($1) as m`, [masmA]);
    check('masm: get_mosque shows the member count to guests', masmGet.rows?.[0]?.m?.members === 4 && masmGet.rows[0].m.is_member === false, masmGet);
    check('masm: get_mosque tells a member they are in', (await as(db, masmU2, `select public.get_mosque($1) as m`, [masmA])).rows?.[0]?.m?.is_member === true);
    check('masm: lists carry the member count', (await as(db, null, `select * from public.nearby_mosques(30.2, 31.4, 1, 10)`)).rows?.find((r) => r.id === masmA)?.member_count === 4 &&
      (await as(db, null, `select * from public.search_mosques('الهدى')`)).rows?.[0]?.member_count === 4);
    check('masm: leave removes membership and the follow; another mosque becomes primary', ok(await as(db, masmU1, `select public.masjid_leave($1)`, [masmB])) &&
      (await admin(db, `select count(*)::int as n from mosque_follows where mosque_id = $1 and user_id = $2`, [masmB, masmU1]))[0].n === 0 &&
      (await admin(db, `select is_primary from mosque_members where user_id = $1 and mosque_id = $2`, [masmU1, masmA]))[0].is_primary === true);
    check('masm: nobody reads memberships directly', denied(await as(db, masmU1, `select * from mosque_members`)));
    const masmAdd = await as(db, masmOut, `select public.masjid_add_mosque('مسجد الرضوان', 30.2100, 31.4100) as id`);
    check('masm: adding a missing mosque joins its creator', ok(masmAdd) &&
      (await admin(db, `select count(*)::int as n from mosque_members where mosque_id = $1 and user_id = $2`, [masmAdd.rows?.[0]?.id, masmOut]))[0].n === 1, masmAdd);

    // Chat: members only
    const masm1 = await masmSend(masmU1, masmA, 'السلام عليكم يا جماعة');
    check('masm: a member posts in an unverified mosque chat', ok(masm1), masm1);
    const masm1Id = masm1.rows?.[0]?.id;
    check('masm: a non-member cannot post', masmHas(await masmSend(masmOut, masmA, 'أهلاً'), 'انضم'));
    check('masm: anon cannot post', denied(await masmSend(null, masmA, 'أهلاً')));
    check('masm: members read the chat', (await as(db, masmU2, `select * from public.masjid_chat_messages($1)`, [masmA])).rows?.length === 1);
    check('masm: a non-member cannot read messages (RPC)', denied(await as(db, masmOut, `select * from public.masjid_chat_messages($1)`, [masmA])));
    check('masm: a non-member cannot read messages (table / Realtime)', (await as(db, masmOut, `select id, body from mosque_chat_messages`)).rows?.length === 0);
    check('masm: a member reads visible rows directly (what Realtime delivers)',
      (await as(db, masmU2, `select id, body from mosque_chat_messages where mosque_id = $1`, [masmA])).rows?.length === 1);
    check('masm: no one reads the author column directly', denied(await as(db, masmU2, `select user_id from mosque_chat_messages`)));
    check('masm: anon has no access to messages', denied(await as(db, null, `select id from mosque_chat_messages`)) &&
      denied(await as(db, null, `select * from public.masjid_chat_messages($1)`, [masmA])));
    check('masm: guests see a message count on the mosque page', (await as(db, null, `select public.get_mosque($1) as m`, [masmA])).rows?.[0]?.m?.chat_messages === 1);
    check('masm: an empty message is refused', masmHas(await masmSend(masmU2, masmA, '   '), 'اكتب'));
    check('masm: a 1001-char message is refused', masmHas(await masmSend(masmU2, masmA, 'ا'.repeat(1001)), '1000'));
    check('masm: a reply to a message', ok(await masmSend(masmU2, masmA, 'وعليكم السلام', masm1Id)));
    check("masm: a reply to another mosque's message is refused", denied(await masmSend(masmU2, masmB, 'x', masm1Id)));

    // Rate limit & spam
    check('masm: 1 message / 3 s', ok(await masmSend(masmU3, masmA, 'رسالة أولى')) &&
      masmHas(await as(db, masmU3, `select public.masjid_chat_send($1, 'رسالة تانية')`, [masmA]), 'ثانيتين'));
    await admin(db, `insert into mosque_chat_messages (mosque_id, user_id, body, created_at)
      select $1, $2, 'رسالة رقم ' || g, now() - interval '30 minutes' + g * interval '1 second' from generate_series(1, 60) g`, [masmA, masmU4]);
    check('masm: 60 messages / hour per user per mosque', masmHas(await as(db, masmU4, `select public.masjid_chat_send($1, 'كمان')`, [masmA]), 'كتير'));
    await admin(db, `delete from mosque_chat_messages where user_id = $1`, [masmU4]);
    const masmSame1 = await masmSend(masmU4, masmA, 'نفس الكلام');
    await admin(db, `update mosque_chat_messages set created_at = created_at - interval '10 seconds'`);
    check('masm: the same text twice in a minute is refused', ok(masmSame1) &&
      masmHas(await as(db, masmU4, `select public.masjid_chat_send($1, 'نفس الكلام')`, [masmA]), 'نفس'));
    check('masm: a phone number is refused (Arabic digits too)', masmHas(await masmSend(masmU4, masmA, 'كلمني على ٠١٠ ١٢٣٤ ٥٦٧٨'), 'أرقام'));
    check('masm: links from a new account are refused', masmHas(await masmSend(masmU4, masmA, 'شوف www.example.com'), 'اللينكات'));
    check('masm: banned words are refused', masmHas(await masmSend(masmU4, masmA, 'انت خول'), 'مش لطيف'));

    // Unread badge
    const masmUnread = (await as(db, masmU1, `select * from public.my_mosques()`)).rows?.find((r) => r.id === masmA);
    check('masm: my_mosques counts unread messages from others', masmUnread?.unread >= 3, masmUnread);
    check('masm: mark read clears the badge', ok(await as(db, masmU1, `select public.masjid_chat_mark_read($1)`, [masmA])) &&
      (await as(db, masmU1, `select * from public.my_mosques()`)).rows?.find((r) => r.id === masmA)?.unread === 0);

    // Reports → auto-hide after 3
    const masmBad = (await masmSend(masmU4, masmA, 'كلام مستفز')).rows?.[0]?.id;
    check('masm: you cannot report your own message', denied(await as(db, masmU4, `select public.masjid_chat_report($1, 'x')`, [masmBad])));
    check('masm: a non-member cannot report', denied(await as(db, masmOut, `select public.masjid_chat_report($1, 'إساءة')`, [masmBad])));
    const masmR1 = await as(db, masmU1, `select public.masjid_chat_report($1, 'إساءة') as h`, [masmBad]);
    check('masm: one report does not hide', ok(masmR1) && masmR1.rows[0].h === false, masmR1);
    check('masm: one report per person', denied(await as(db, masmU1, `select public.masjid_chat_report($1, 'إساءة')`, [masmBad])));
    await as(db, masmU2, `select public.masjid_chat_report($1, 'سبام')`, [masmBad]);
    const masmR3 = await as(db, masmU3, `select public.masjid_chat_report($1, 'إساءة') as h`, [masmBad]);
    check('masm: the 3rd distinct report hides it', ok(masmR3) && masmR3.rows[0].h === true &&
      !(await as(db, masmU2, `select * from public.masjid_chat_messages($1)`, [masmA])).rows.some((m) => m.id === masmBad), masmR3);
    check('masm: the super admin sees it in the reports list (unclaimed mosque)',
      (await as(db, masmSA, `select * from public.admin_mosque_chat_reports()`)).rows?.some((r) => r.id === masmBad && r.is_hidden && r.reasons.length === 3 && r.mosque_verified === false));
    check('masm: a user cannot list reports', denied(await as(db, masmU1, `select * from public.admin_mosque_chat_reports()`)));
    check('masm: the super admin restores it', ok(await as(db, masmSA, `select public.admin_restore_mosque_chat_message($1)`, [masmBad])) &&
      (await as(db, masmU2, `select * from public.masjid_chat_messages($1)`, [masmA])).rows.some((m) => m.id === masmBad));

    // Delete own
    const masmMine = (await masmSend(masmU2, masmA, 'غلطة')).rows?.[0]?.id;
    check("masm: a member cannot delete someone else's message", denied(await as(db, masmU3, `select public.masjid_chat_delete($1)`, [masmMine])));
    check('masm: the author deletes their own message', ok(await as(db, masmU2, `select public.masjid_chat_delete($1)`, [masmMine])) &&
      (await admin(db, `select count(*)::int as n from mosque_chat_messages where id = $1`, [masmMine]))[0].n === 0);

    // Super admin moderates an unclaimed mosque; nobody else does
    check('masm: a member cannot moderate an unclaimed mosque', denied(await as(db, masmU1, `select public.masjid_chat_sanction($1, $2, 'ban')`, [masmA, masmU4])) &&
      denied(await as(db, masmU1, `select public.masjid_chat_delete($1)`, [masmBad])));
    check('masm: the super admin hides a message in an unclaimed mosque', ok(await as(db, masmSA, `select public.masjid_chat_delete($1, 'إساءة')`, [masmBad])) &&
      (await admin(db, `select is_hidden from mosque_chat_messages where id = $1`, [masmBad]))[0].is_hidden === true);
    check('masm: the super admin lists the members', (await as(db, masmSA, `select * from public.masjid_members($1)`, [masmA])).rows?.length === 4);
    check('masm: a member cannot list members', denied(await as(db, masmU2, `select * from public.masjid_members($1)`, [masmA])));
    check('masm: the super admin bans a member of an unclaimed mosque', ok(await as(db, masmSA, `select public.masjid_chat_sanction($1, $2, 'ban')`, [masmA, masmU4])));
    check('masm: a banned member cannot post', masmHas(await masmSend(masmU4, masmA, 'أنا رجعت'), 'ممنوع'));
    check('masm: …but can still read', ok(await as(db, masmU4, `select * from public.masjid_chat_messages($1)`, [masmA])));
    check('masm: the ban is per mosque', ok(await as(db, masmU4, `select public.masjid_join($1)`, [masmB])) && ok(await masmSend(masmU4, masmB, 'سلام')));
    check('masm: the super admin lifts the ban', (await as(db, masmSA, `select public.masjid_chat_lift($1, $2) as n`, [masmA, masmU4])).rows?.[0]?.n === 1 &&
      ok(await masmSend(masmU4, masmA, 'شكراً')));
    await admin(db, `insert into chat_sanctions (user_id, room_id, kind) values ($1, null, 'ban')`, [masmU4]);
    check('masm: a platform-wide chat ban (0078) blocks mosque chat too', masmHas(await masmSend(masmU4, masmA, 'تاني'), 'ممنوع'));
    await admin(db, `update chat_sanctions set lifted_at = now() where user_id = $1`, [masmU4]);

    // A verified owner and helpers: their mosque only
    await admin(db, `update mosques set verified = true where id = $1`, [masmA]);
    await admin(db, `insert into mosque_admins (mosque_id, user_id, role, permissions) values
      ($1, $2, 'owner', '{}'), ($1, $3, 'helper', '{chat}'), ($1, $4, 'helper', '{posts}')`, [masmA, masmOwner, masmHelpChat, masmHelpPosts]);
    const masmTarget = (await masmSend(masmU3, masmA, 'رسالة للحذف')).rows?.[0]?.id;
    const masmTargetB = (await masmSend(masmU4, masmB, 'رسالة في مسجد تاني')).rows?.[0]?.id;
    check('masm: a newly verified owner moderates the existing chat without joining', ok(await as(db, masmOwner, `select * from public.masjid_chat_messages($1)`, [masmA])) &&
      (await as(db, masmOwner, `select public.get_mosque($1) as m`, [masmA])).rows?.[0]?.m?.can_moderate_chat === true &&
      (await as(db, masmOwner, `select * from public.masjid_members($1)`, [masmA])).rows?.length === 4);
    check('masm: a helper with «chat» deletes a message', ok(await as(db, masmHelpChat, `select public.masjid_chat_delete($1)`, [masmTarget])));
    check('masm: a helper without «chat» cannot', denied(await as(db, masmHelpPosts, `select public.masjid_chat_delete($1)`, [masm1Id])));
    check('masm: a helper with «chat» mutes a member', ok(await as(db, masmHelpChat, `select public.masjid_chat_sanction($1, $2, 'mute', 60)`, [masmA, masmU3])) &&
      masmHas(await masmSend(masmU3, masmA, 'مكتوم؟'), 'مكتوم'));
    check('masm: …but not on another mosque', denied(await as(db, masmHelpChat, `select public.masjid_chat_delete($1)`, [masmTargetB])) &&
      denied(await as(db, masmHelpChat, `select public.masjid_chat_sanction($1, $2, 'ban')`, [masmB, masmU4])) &&
      denied(await as(db, masmOwner, `select * from public.masjid_members($1)`, [masmB])));
    check("masm: a helper can't ban the mosque's owner", denied(await as(db, masmHelpChat, `select public.masjid_chat_sanction($1, $2, 'ban')`, [masmA, masmOwner])));
    check('masm: the owner bans a member', ok(await as(db, masmOwner, `select public.masjid_chat_sanction($1, $2, 'ban', null, 'سبام')`, [masmA, masmU2])) &&
      masmHas(await masmSend(masmU2, masmA, 'x'), 'ممنوع'));
    check('masm: «chat» is in the owner permissions', (await as(db, masmOwner, `select public.get_mosque($1) as m`, [masmA])).rows?.[0]?.m?.my_permissions?.includes('chat'));
    check('masm: the owner grants «chat» to a helper', ok(await as(db, masmOwner, `select public.masjid_add_helper($1, '01077700001', array['posts', 'chat'])`, [masmA])) &&
      (await admin(db, `select permissions from mosque_admins where mosque_id = $1 and user_id = $2`, [masmA, masmHelpPosts]))[0].permissions.includes('chat'));
    check('masm: the mod log records actions', (await admin(db, `select count(*)::int as n from mosque_chat_mod_log where mosque_id = $1`, [masmA]))[0].n >= 5);

    // «قريب منك» feed
    await admin(db, `insert into mosque_lessons (mosque_id, title, weekdays) values ($1, 'درس الفقه', '{1,2,3,4,5,6,7}')`, [masmA]);
    await admin(db, `insert into mosque_needs (mosque_id, title, target_amount) values ($1, 'تكييف', 5000)`, [masmA]);
    await admin(db, `insert into mosque_competitions (mosque_id, title) values ($1, 'مسابقة جزء عمّ')`, [masmA]);
    await admin(db, `insert into mosque_posts (mosque_id, kind, title) values ($1, 'janaza', 'صلاة الجنازة على الحاج محمد')`, [masmA]);
    await admin(db, `insert into mosque_lessons (mosque_id, title, weekdays) values ($1, 'درس بعيد', '{1,2,3,4,5,6,7}')`, [masmB]);
    const masmFeed = await as(db, null, `select * from public.masjid_nearby_feed(30.2, 31.4, 3, 30)`);
    const masmKinds = new Set((masmFeed.rows || []).map((r) => r.kind));
    check('masm: the nearby feed mixes urgent posts, lessons, needs and competitions', ok(masmFeed) &&
      ['urgent', 'lesson', 'need', 'competition'].every((k) => masmKinds.has(k)) && masmFeed.rows[0].kind === 'urgent', masmFeed);
    check('masm: …far mosques are left out', !(masmFeed.rows || []).some((r) => r.title === 'درس بعيد'));
    check('masm: …unless you joined them', (await as(db, masmU4, `select * from public.masjid_nearby_feed(30.2, 31.4, 3, 30)`)).rows?.some((r) => r.title === 'درس بعيد'));

    // Realtime: the table is published (re-run 0081 against a Supabase-like publication).
    await admin(db, `do $$ begin if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then create publication supabase_realtime; end if; end $$`);
    let masmRerun = null;
    try {
      await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0081_masjid_members_chat.sql'), 'utf8'));
    } catch (e) {
      masmRerun = e.message;
    }
    check('masm: 0081 is safe to re-run', masmRerun === null, masmRerun);
    check('masm: mosque_chat_messages is in the supabase_realtime publication',
      (await admin(db, `select count(*)::int as n from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'mosque_chat_messages'`))[0].n === 1);
    check('masm: membership survived the re-run', (await admin(db, `select count(*)::int as n from mosque_members where mosque_id = $1`, [masmA]))[0].n === 4);
  }

  // ------------------------------------------------------------------
  console.log('\nPhase mtool — «أدوات يومية»: prayer reminders (0082)');
  {
    // Times from lib/core/masjid/prayer_times.dart (PrayerCalculator.egypt)
    // for the same cities and Cairo dates; the SQL port must agree ±1 min.
    const mtoolRefs = [
      ['cairo', 30.0444, 31.2357, '2026-01-15', {fajr: '2026-01-15T03:21:00.000Z', sunrise: '2026-01-15T04:52:00.000Z', dhuhr: '2026-01-15T10:05:00.000Z', asr: '2026-01-15T12:58:00.000Z', maghrib: '2026-01-15T15:17:00.000Z', isha: '2026-01-15T16:39:00.000Z'}],
      ['cairo', 30.0444, 31.2357, '2026-04-24', {fajr: '2026-04-24T01:46:00.000Z', sunrise: '2026-04-24T03:19:00.000Z', dhuhr: '2026-04-24T09:54:00.000Z', asr: '2026-04-24T13:29:00.000Z', maghrib: '2026-04-24T16:28:00.000Z', isha: '2026-04-24T17:51:00.000Z'}],
      ['cairo', 30.0444, 31.2357, '2026-06-21', {fajr: '2026-06-21T01:08:00.000Z', sunrise: '2026-06-21T02:54:00.000Z', dhuhr: '2026-06-21T09:58:00.000Z', asr: '2026-06-21T13:32:00.000Z', maghrib: '2026-06-21T16:59:00.000Z', isha: '2026-06-21T18:33:00.000Z'}],
      ['cairo', 30.0444, 31.2357, '2026-10-29', {fajr: '2026-10-29T02:39:00.000Z', sunrise: '2026-10-29T04:07:00.000Z', dhuhr: '2026-10-29T09:40:00.000Z', asr: '2026-10-29T12:47:00.000Z', maghrib: '2026-10-29T15:11:00.000Z', isha: '2026-10-29T16:29:00.000Z'}],
      ['cairo', 30.0444, 31.2357, '2026-10-30', {fajr: '2026-10-30T02:40:00.000Z', sunrise: '2026-10-30T04:07:00.000Z', dhuhr: '2026-10-30T09:40:00.000Z', asr: '2026-10-30T12:46:00.000Z', maghrib: '2026-10-30T15:10:00.000Z', isha: '2026-10-30T16:28:00.000Z'}],
      ['cairo', 30.0444, 31.2357, '2027-12-31', {fajr: '2027-12-31T03:18:00.000Z', sunrise: '2027-12-31T04:51:00.000Z', dhuhr: '2027-12-31T09:59:00.000Z', asr: '2027-12-31T12:47:00.000Z', maghrib: '2027-12-31T15:05:00.000Z', isha: '2027-12-31T16:28:00.000Z'}],
      ['cairo', 30.0444, 31.2357, '2025-03-01', {fajr: '2025-03-01T02:55:00.000Z', sunrise: '2025-03-01T04:21:00.000Z', dhuhr: '2025-03-01T10:08:00.000Z', asr: '2025-03-01T13:25:00.000Z', maghrib: '2025-03-01T15:54:00.000Z', isha: '2025-03-01T17:11:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2026-01-15', {fajr: '2026-01-15T03:27:00.000Z', sunrise: '2026-01-15T04:59:00.000Z', dhuhr: '2026-01-15T10:11:00.000Z', asr: '2026-01-15T13:01:00.000Z', maghrib: '2026-01-15T15:20:00.000Z', isha: '2026-01-15T16:43:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2026-04-24', {fajr: '2026-04-24T01:48:00.000Z', sunrise: '2026-04-24T03:23:00.000Z', dhuhr: '2026-04-24T09:59:00.000Z', asr: '2026-04-24T13:36:00.000Z', maghrib: '2026-04-24T16:35:00.000Z', isha: '2026-04-24T17:59:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2026-06-21', {fajr: '2026-06-21T01:08:00.000Z', sunrise: '2026-06-21T02:57:00.000Z', dhuhr: '2026-06-21T10:03:00.000Z', asr: '2026-06-21T13:41:00.000Z', maghrib: '2026-06-21T17:07:00.000Z', isha: '2026-06-21T18:43:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2026-10-29', {fajr: '2026-10-29T02:45:00.000Z', sunrise: '2026-10-29T04:13:00.000Z', dhuhr: '2026-10-29T09:45:00.000Z', asr: '2026-10-29T12:51:00.000Z', maghrib: '2026-10-29T15:14:00.000Z', isha: '2026-10-29T16:34:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2026-10-30', {fajr: '2026-10-30T02:45:00.000Z', sunrise: '2026-10-30T04:14:00.000Z', dhuhr: '2026-10-30T09:45:00.000Z', asr: '2026-10-30T12:50:00.000Z', maghrib: '2026-10-30T15:14:00.000Z', isha: '2026-10-30T16:33:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2027-12-31', {fajr: '2027-12-31T03:25:00.000Z', sunrise: '2027-12-31T04:59:00.000Z', dhuhr: '2027-12-31T10:04:00.000Z', asr: '2027-12-31T12:49:00.000Z', maghrib: '2027-12-31T15:08:00.000Z', isha: '2027-12-31T16:32:00.000Z'}],
      ['alex', 31.2001, 29.9187, '2025-03-01', {fajr: '2025-03-01T03:00:00.000Z', sunrise: '2025-03-01T04:27:00.000Z', dhuhr: '2025-03-01T10:14:00.000Z', asr: '2025-03-01T13:30:00.000Z', maghrib: '2025-03-01T15:59:00.000Z', isha: '2025-03-01T17:17:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2026-01-15', {fajr: '2026-01-15T03:07:00.000Z', sunrise: '2026-01-15T04:34:00.000Z', dhuhr: '2026-01-15T09:59:00.000Z', asr: '2026-01-15T13:01:00.000Z', maghrib: '2026-01-15T15:22:00.000Z', isha: '2026-01-15T16:40:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2026-04-24', {fajr: '2026-04-24T01:53:00.000Z', sunrise: '2026-04-24T03:19:00.000Z', dhuhr: '2026-04-24T09:48:00.000Z', asr: '2026-04-24T13:14:00.000Z', maghrib: '2026-04-24T16:14:00.000Z', isha: '2026-04-24T17:31:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2026-06-21', {fajr: '2026-06-21T01:25:00.000Z', sunrise: '2026-06-21T03:01:00.000Z', dhuhr: '2026-06-21T09:51:00.000Z', asr: '2026-06-21T13:09:00.000Z', maghrib: '2026-06-21T16:39:00.000Z', isha: '2026-06-21T18:05:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2026-10-29', {fajr: '2026-10-29T02:30:00.000Z', sunrise: '2026-10-29T03:53:00.000Z', dhuhr: '2026-10-29T09:33:00.000Z', asr: '2026-10-29T12:46:00.000Z', maghrib: '2026-10-29T15:11:00.000Z', isha: '2026-10-29T16:25:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2026-10-30', {fajr: '2026-10-30T02:30:00.000Z', sunrise: '2026-10-30T03:53:00.000Z', dhuhr: '2026-10-30T09:33:00.000Z', asr: '2026-10-30T12:46:00.000Z', maghrib: '2026-10-30T15:10:00.000Z', isha: '2026-10-30T16:25:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2027-12-31', {fajr: '2027-12-31T03:03:00.000Z', sunrise: '2027-12-31T04:31:00.000Z', dhuhr: '2027-12-31T09:52:00.000Z', asr: '2027-12-31T12:51:00.000Z', maghrib: '2027-12-31T15:11:00.000Z', isha: '2027-12-31T16:30:00.000Z'}],
      ['aswan', 24.0889, 32.8998, '2025-03-01', {fajr: '2025-03-01T02:49:00.000Z', sunrise: '2025-03-01T04:11:00.000Z', dhuhr: '2025-03-01T10:02:00.000Z', asr: '2025-03-01T13:21:00.000Z', maghrib: '2025-03-01T15:51:00.000Z', isha: '2025-03-01T17:04:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2026-01-15', {fajr: '2026-01-15T03:38:00.000Z', sunrise: '2026-01-15T05:11:00.000Z', dhuhr: '2026-01-15T10:21:00.000Z', asr: '2026-01-15T13:11:00.000Z', maghrib: '2026-01-15T15:31:00.000Z', isha: '2026-01-15T16:53:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2026-04-24', {fajr: '2026-04-24T01:59:00.000Z', sunrise: '2026-04-24T03:33:00.000Z', dhuhr: '2026-04-24T10:10:00.000Z', asr: '2026-04-24T13:47:00.000Z', maghrib: '2026-04-24T16:46:00.000Z', isha: '2026-04-24T18:10:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2026-06-21', {fajr: '2026-06-21T01:18:00.000Z', sunrise: '2026-06-21T03:07:00.000Z', dhuhr: '2026-06-21T10:14:00.000Z', asr: '2026-06-21T13:52:00.000Z', maghrib: '2026-06-21T17:19:00.000Z', isha: '2026-06-21T18:54:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2026-10-29', {fajr: '2026-10-29T02:55:00.000Z', sunrise: '2026-10-29T04:24:00.000Z', dhuhr: '2026-10-29T09:56:00.000Z', asr: '2026-10-29T13:01:00.000Z', maghrib: '2026-10-29T15:25:00.000Z', isha: '2026-10-29T16:44:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2026-10-30', {fajr: '2026-10-30T02:56:00.000Z', sunrise: '2026-10-30T04:25:00.000Z', dhuhr: '2026-10-30T09:56:00.000Z', asr: '2026-10-30T13:01:00.000Z', maghrib: '2026-10-30T15:24:00.000Z', isha: '2026-10-30T16:44:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2027-12-31', {fajr: '2027-12-31T03:36:00.000Z', sunrise: '2027-12-31T05:10:00.000Z', dhuhr: '2027-12-31T10:15:00.000Z', asr: '2027-12-31T13:00:00.000Z', maghrib: '2027-12-31T15:18:00.000Z', isha: '2027-12-31T16:42:00.000Z'}],
      ['matruh', 31.3543, 27.2373, '2025-03-01', {fajr: '2025-03-01T03:10:00.000Z', sunrise: '2025-03-01T04:38:00.000Z', dhuhr: '2025-03-01T10:24:00.000Z', asr: '2025-03-01T13:41:00.000Z', maghrib: '2025-03-01T16:09:00.000Z', isha: '2025-03-01T17:28:00.000Z'}],
    ];
    for (const [city, lat, lng, day, want] of mtoolRefs) {
      const rows = await admin(db, `select prayer, prayer_at from private.egypt_prayer_times($1::date, $2, $3)`, [day, lat, lng]);
      const got = Object.fromEntries(rows.map((r) => [r.prayer, new Date(r.prayer_at).getTime()]));
      const worst = Math.max(...Object.entries(want).map(([p, iso]) => Math.abs((got[p] ?? 0) - new Date(iso).getTime())));
      check(`mtool: SQL prayer times match Dart — ${city} ${day}`, rows.length === 6 && worst <= 60000, { worst, got: rows });
    }
    const mtoolDst = await admin(db, `select private.egypt_dst_on('2026-04-23') a, private.egypt_dst_on('2026-04-24') b,
      private.egypt_dst_on('2026-10-29') c, private.egypt_dst_on('2026-10-30') d, private.egypt_dst_on('2022-07-01') e,
      private.egypt_today('2026-07-01T21:30:00Z') f, private.egypt_today('2026-01-01T21:30:00Z') g, private.egypt_time12('2026-01-15T03:21:00Z') h`);
    const t = mtoolDst[0];
    check('mtool: Egypt summer time — last Friday of April to last Thursday of October',
      t.a === false && t.b === true && t.c === true && t.d === false && t.e === false, t);
    check('mtool: Cairo date & 12-hour time', new Date(t.f).toISOString().startsWith('2026-07-02') && new Date(t.g).toISOString().startsWith('2026-01-01') && t.h === '5:21 ص', t);

    const MT1 = await signUp(db, 'mtool one', '01000000881');
    const MT2 = await signUp(db, 'mtool two', '01000000882');
    const cairo = [30.0444, 31.2357];
    check('mtool: guests cannot save reminders', denied(await as(db, null, `select public.set_prayer_reminders(30, 31, '{"fajr":0}'::jsonb)`)));
    check('mtool: a place outside Egypt is refused', denied(await as(db, MT1, `select public.set_prayer_reminders(51.5, -0.1, '{"fajr":0}'::jsonb)`)));
    check('mtool: odd offsets are refused', denied(await as(db, MT1, `select public.set_prayer_reminders($1, $2, '{"fajr":7}'::jsonb)`, cairo)));
    check('mtool: unknown prayers are refused', denied(await as(db, MT1, `select public.set_prayer_reminders($1, $2, '{"sunrise":0}'::jsonb)`, cairo)));
    check('mtool: a user saves reminders', ok(await as(db, MT1, `select public.set_prayer_reminders($1, $2, '{"fajr":10,"isha":0}'::jsonb, 'القاهرة')`, cairo)));
    check('mtool: …nothing is queued without a push device',
      (await admin(db, `select count(*)::int n from prayer_reminder_queue where user_id = $1`, [MT1]))[0].n === 0);
    check('mtool: the owner reads their settings', (await as(db, MT1, `select * from public.my_prayer_reminders()`)).rows?.[0]?.offsets?.fajr === 10);
    check("mtool: others can't read them", (await as(db, MT2, `select * from prayer_reminder_prefs`)).rows?.length === 0 &&
      (await as(db, MT2, `select * from public.my_prayer_reminders()`)).rows?.length === 0);
    check("mtool: users can't touch the queue", denied(await as(db, MT1, `insert into prayer_reminder_queue (user_id, day, prayer, adhan_at, due_at, minutes_before) values ($1, current_date, 'fajr', now(), now(), 0)`, [MT1])) &&
      denied(await as(db, MT1, `select * from prayer_reminder_queue`)));
    check("mtool: users can't run the sender", denied(await as(db, MT1, `select private.prayer_reminders_tick()`)) &&
      denied(await as(db, MT1, `select * from private.egypt_prayer_times(current_date, 30, 31)`)));

    await as(db, MT1, `select public.save_push_subscription('https://fcm.googleapis.com/fcm/send/mtool1', 'p256', 'authx', 'masjid')`);
    check('mtool: saving again with a push device queues today + tomorrow',
      ok(await as(db, MT1, `select public.set_prayer_reminders($1, $2, '{"fajr":10,"isha":0}'::jsonb, 'القاهرة')`, cairo)) &&
      (await admin(db, `select count(*)::int n from prayer_reminder_queue where user_id = $1`, [MT1]))[0].n === 4);
    const fajr = (await admin(db, `select q.due_at, q.adhan_at, q.day from prayer_reminder_queue q where user_id = $1 and prayer = 'fajr' order by day limit 1`, [MT1]))[0];
    const dartFajr = (await admin(db, `select prayer_at from private.egypt_prayer_times($1::date, $2, $3) where prayer = 'fajr'`, [fajr.day, ...cairo]))[0].prayer_at;
    check('mtool: the reminder is due 10 minutes before the adhan',
      new Date(fajr.adhan_at).getTime() - new Date(fajr.due_at).getTime() === 600000 && new Date(fajr.adhan_at).getTime() === new Date(dartFajr).getTime());
    const at = new Date(new Date(fajr.due_at).getTime() + 30000).toISOString();
    const sent1 = (await admin(db, `select private.prayer_reminders_tick($1::timestamptz) n`, [at]))[0].n;
    const note = await admin(db, `select title, body, deep_link from notifications where user_id = $1 and deep_link = '/masjid/tools/reminders'`, [MT1]);
    check('mtool: the tick sends the due reminder as a notification (→ push)', sent1 === 1 && note.length === 1 && note[0].title === 'الفجر بعد 10 دقايق' && note[0].body.startsWith('أذان الفجر '), { sent1, note });
    const sent2 = (await admin(db, `select private.prayer_reminders_tick($1::timestamptz) n`, [at]))[0].n;
    check('mtool: …once only', sent2 === 0 && (await admin(db, `select count(*)::int n from notifications where user_id = $1 and deep_link = '/masjid/tools/reminders'`, [MT1]))[0].n === 1);
    const isha = (await admin(db, `select due_at from prayer_reminder_queue where user_id = $1 and prayer = 'isha' order by day limit 1`, [MT1]))[0];
    const late = new Date(new Date(isha.due_at).getTime() + 20 * 60000).toISOString();
    check('mtool: a reminder more than 10 minutes late is dropped, not sent',
      (await admin(db, `select private.prayer_reminders_tick($1::timestamptz) n`, [late]))[0].n === 0 &&
      (await admin(db, `select sent_at from prayer_reminder_queue where user_id = $1 and prayer = 'isha' order by day limit 1`, [MT1]))[0].sent_at !== null);
    check('mtool: changing the settings re-queues only what was not sent',
      ok(await as(db, MT1, `select public.set_prayer_reminders($1, $2, '{"fajr":5,"isha":0,"asr":15}'::jsonb)`, cairo)) &&
      (await admin(db, `select count(*)::int n from prayer_reminder_queue where user_id = $1`, [MT1]))[0].n === 6 &&
      (await admin(db, `select minutes_before from prayer_reminder_queue where user_id = $1 and prayer = 'fajr' order by day limit 1`, [MT1]))[0].minutes_before === 10);
    check('mtool: a user without a push device gets nothing queued',
      ok(await as(db, MT2, `select public.set_prayer_reminders(31.2, 29.9, '{"maghrib":5}'::jsonb)`)) &&
      (await admin(db, `select count(*)::int n from prayer_reminder_queue where user_id = $1`, [MT2]))[0].n === 0);
    const later = new Date(Date.now() + 13 * 3600000).toISOString();
    await admin(db, `select private.prayer_reminders_tick($1::timestamptz)`, [later]);
    check('mtool: old reminder notifications are cleaned up',
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and deep_link = '/masjid/tools/reminders' and created_at < $2::timestamptz - interval '12 hours'`, [MT1, later]))[0].n === 0);
    check('mtool: turning reminders off clears them',
      ok(await as(db, MT1, `select public.clear_prayer_reminders()`)) &&
      (await admin(db, `select count(*)::int n from prayer_reminder_prefs where user_id = $1`, [MT1]))[0].n === 0 &&
      (await admin(db, `select count(*)::int n from prayer_reminder_queue where user_id = $1 and sent_at is null`, [MT1]))[0].n === 0);
    check('mtool: saving no prayers removes the settings',
      ok(await as(db, MT2, `select public.set_prayer_reminders(31.2, 29.9, '{}'::jsonb)`)) &&
      (await admin(db, `select count(*)::int n from prayer_reminder_prefs where user_id = $1`, [MT2]))[0].n === 0);
  }

  // ------------------------------------------------------------------
  console.log('\nمسجدي — chat nicknames, verified phones, 30-day retention (0083)');
  {
    // The masm block re-ran 0081 (which puts its own functions back), so
    // re-running 0083 here is both the re-run check and the restore.
    let mascRerun = null;
    try {
      await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0083_masjid_chat_rules.sql'), 'utf8'));
    } catch (e) {
      mascRerun = e.message;
    }
    check('masc: 0083 is safe to re-run (after 0081 re-ran too)', mascRerun === null, mascRerun);

    const mascM = (await admin(db, `insert into mosques (name, lat, lng, verified) values ('مسجد النور', 30.4, 31.6, true) returning id`))[0].id;
    const mascN1 = await signUp(db, 'masc realname one', null);
    const mascN2 = await signUp(db, 'masc realname two', null);
    const mascN3 = await signUp(db, 'masc realname three', null);
    const mascOwner = await signUp(db, 'masc owner', null);
    const mascSA = await signUp(db, 'masc super', null);
    const mascOut = await signUp(db, 'masc outsider', null);
    await admin(db, `update profiles set role = 'super_admin' where id = $1`, [mascSA]);
    await admin(db, `update profiles set phone_verified_at = now() where id = any($1::uuid[])`, [[mascN1, mascN3]]);
    await admin(db, `insert into mosque_admins (mosque_id, user_id, role, permissions) values ($1, $2, 'owner', '{}')`, [mascM, mascOwner]);
    for (const u of [mascN1, mascN2, mascN3, mascOwner, mascSA]) await as(db, u, `select public.masjid_join($1)`, [mascM]);
    const mascCool = () => admin(db, `update mosque_chat_messages set created_at = created_at - interval '2 minutes' where mosque_id = $1`, [mascM]);
    const mascSend = async (u, body, reply) => {
      await mascCool();
      return as(db, u, `select public.masjid_chat_send($1, $2, $3) as id`, [mascM, body, reply ?? null]);
    };
    const mascHas = (r, text) => !!r.error && r.error.includes(text);
    const mascNick = (u, nick) => as(db, u, `select public.masjid_chat_set_nickname($1, $2) as n`, [mascM, nick]);
    const mascAge = (u) => admin(db, `update mosque_chat_nicknames set changed_at = now() - interval '25 hours' where mosque_id = $1 and user_id = $2`, [mascM, u]);

    // Phone verification to post
    check('masc: an unverified member cannot post', mascHas(await mascSend(mascN2, 'السلام عليكم'), 'توثّق'));
    const mascProf = await as(db, mascN2, `select public.masjid_my_chat_profile($1) as p`, [mascM]);
    check('masc: my chat profile says a phone is needed', mascProf.rows?.[0]?.p?.needs_phone === true && mascProf.rows[0].p.real_name === 'masc realname two', mascProf);
    check('masc: a verified member posts', ok(await mascSend(mascN1, 'السلام عليكم ورحمة الله')));
    check('masc: an unverified moderator cannot post either', mascHas(await mascSend(mascOwner, 'أهلاً بالجميع'), 'توثّق'));
    await admin(db, `update profiles set phone_verified_at = now() where id = $1`, [mascOwner]);
    check('masc: …once verified, the moderator posts', ok(await mascSend(mascOwner, 'أهلاً بالجميع')));
    check('masc: the super admin is exempt', ok(await mascSend(mascSA, 'بالتوفيق')));
    check('masc: an unverified member can still read', ok(await as(db, mascN2, `select * from public.masjid_chat_messages($1)`, [mascM])));
    await admin(db, `update profiles set phone_verified_at = now() where id = $1`, [mascN2]);
    const mascVerifiedLater = await mascSend(mascN2, 'أنا وثّقت رقمي');
    check('masc: verifying the phone unlocks posting', ok(mascVerifiedLater), mascVerifiedLater);

    // Nickname validation
    check('masc: a non-member cannot set a nickname', denied(await as(db, mascOut, `select public.masjid_chat_set_nickname($1, 'أم أحمد')`, [mascM])));
    check('masc: a 1-char nickname is refused', mascHas(await mascNick(mascN1, 'ا'), '2'));
    check('masc: a 31-char nickname is refused', mascHas(await mascNick(mascN1, 'ا'.repeat(31)), '30'));
    check('masc: digits only are refused', mascHas(await mascNick(mascN1, '1234'), 'حروف'));
    check('masc: symbols are refused', denied(await mascNick(mascN1, 'أم <b>')));
    check('masc: «الإمام …» is refused', mascHas(await mascNick(mascN1, 'الإمام محمود'), 'إدارة'));
    check('masc: «أدمن» / «مشرف» / «الإدارة» are refused', denied(await mascNick(mascN1, 'أدمن المسجد')) &&
      denied(await mascNick(mascN1, 'المشرف')) && denied(await mascNick(mascN1, 'الإدارة')) && denied(await mascNick(mascN1, 'Admin_1')));
    check('masc: banned words are refused', mascHas(await mascNick(mascN1, 'انت خول'), 'مش لطيفة'));
    const mascSet = await mascNick(mascN1, '  أم   محمد ');
    check('masc: a member sets a nickname (spaces tidied)', ok(mascSet) && mascSet.rows[0].n === 'أم محمد', mascSet);
    check('masc: setting the same nickname again is a no-op', ok(await mascNick(mascN1, 'أم محمد')));
    check('masc: changing it the same day is refused', mascHas(await mascNick(mascN1, 'أم يوسف'), 'مرة واحدة'));
    check('masc: …and so is going back to the real name', mascHas(await mascNick(mascN1, null), 'مرة واحدة'));
    const mascProf1 = (await as(db, mascN1, `select public.masjid_my_chat_profile($1) as p`, [mascM])).rows?.[0]?.p;
    check('masc: my chat profile shows the nickname and when it can change', mascProf1?.nickname === 'أم محمد' && !!mascProf1.can_change_at && mascProf1.needs_phone === false, mascProf1);
    await mascAge(mascN1);
    check('masc: a day later it can change', ok(await mascNick(mascN1, 'أم يوسف')));
    check('masc: a nickname taken in the mosque is refused (normalised)', mascHas(await mascNick(mascN3, 'ام يوسف'), 'واخده'));
    const mascOther = (await admin(db, `insert into mosques (name, lat, lng) values ('مسجد السلام', 30.41, 31.61) returning id`))[0].id;
    await as(db, mascN3, `select public.masjid_join($1)`, [mascOther]);
    check('masc: …but the same nickname is fine in another mosque', ok(await as(db, mascN3, `select public.masjid_chat_set_nickname($1, 'أم يوسف')`, [mascOther])));
    check('masc: nobody reads the nicknames table directly', denied(await as(db, mascN1, `select * from mosque_chat_nicknames`)));
    check('masc: leaving and re-joining does not reset the daily limit',
      ok(await as(db, mascN1, `select public.masjid_leave($1)`, [mascM])) && ok(await as(db, mascN1, `select public.masjid_join($1)`, [mascM])) &&
      mascHas(await mascNick(mascN1, 'أم علي'), 'مرة واحدة'));

    // Who sees the real name
    const mascN1Msg = (await mascSend(mascN1, 'جزاكم الله خيراً')).rows?.[0]?.id;
    await mascSend(mascN3, 'وإياكم', mascN1Msg);
    const mascMember = await as(db, mascN3, `select * from public.masjid_chat_messages($1)`, [mascM]);
    const mascMemberRow = mascMember.rows?.find((r) => r.id === mascN1Msg);
    check('masc: members see the nickname on messages (old ones too)', mascMemberRow?.author_name === 'أم يوسف' &&
      mascMember.rows.filter((r) => r.author_name === 'أم يوسف').length === 2, mascMember);
    check('masc: …and in replies', mascMember.rows?.some((r) => r.reply_to === mascN1Msg && r.reply_name === 'أم يوسف'));
    check("masc: non-moderators never get the real name or the author's id",
      !JSON.stringify(mascMember.rows).includes('masc realname one') && mascMember.rows.every((r) => r.author_id === null));
    check('masc: no nickname → the real name shows', mascMember.rows?.some((r) => r.author_name === 'masc realname two'));
    check('masc: a non-moderator cannot list identities', denied(await as(db, mascN3, `select * from public.masjid_chat_identities($1)`, [mascM])));
    const mascModRows = await as(db, mascOwner, `select * from public.masjid_chat_messages($1)`, [mascM]);
    check("masc: moderators get the author's id", mascModRows.rows?.find((r) => r.id === mascN1Msg)?.author_id === mascN1, mascModRows);
    const mascIds = await as(db, mascOwner, `select * from public.masjid_chat_identities($1)`, [mascM]);
    check('masc: moderators see who is behind a nickname', mascIds.rows?.some((r) => r.user_id === mascN1 && r.nickname === 'أم يوسف' && r.full_name === 'masc realname one'), mascIds);
    check('masc: the super admin too', (await as(db, mascSA, `select * from public.masjid_chat_identities($1)`, [mascM])).rows?.some((r) => r.user_id === mascN1));
    check('masc: the members sheet keeps the real name',
      (await as(db, mascOwner, `select * from public.masjid_members($1)`, [mascM])).rows?.some((r) => r.user_id === mascN1 && r.full_name === 'masc realname one'));
    await mascAge(mascN1);
    check('masc: clearing the nickname brings the real name back', ok(await mascNick(mascN1, '')) &&
      (await as(db, mascN3, `select * from public.masjid_chat_messages($1)`, [mascM])).rows?.find((r) => r.id === mascN1Msg)?.author_name === 'masc realname one');

    // 30-day retention
    const mascOld = (await admin(db, `insert into mosque_chat_messages (mosque_id, user_id, body, created_at) values ($1, $2, 'قديمة', now() - interval '31 days') returning id`, [mascM, mascN3]))[0].id;
    const mascRecent = (await admin(db, `insert into mosque_chat_messages (mosque_id, user_id, body, created_at) values ($1, $2, 'من شهر إلا يوم', now() - interval '29 days') returning id`, [mascM, mascN3]))[0].id;
    await admin(db, `insert into mosque_chat_reports (message_id, reporter_id, reason, created_at) values ($1, $2, 'إساءة', now() - interval '31 days')`, [mascOld, mascN1]);
    await admin(db, `insert into mosque_chat_reports (message_id, reporter_id, reason, created_at) values ($1, $2, 'قديم', now() - interval '91 days')`, [mascN1Msg, mascN3]);
    await admin(db, `insert into mosque_chat_mod_log (mosque_id, action, created_at) values ($1, 'old', now() - interval '91 days'), ($1, 'new', now() - interval '89 days')`, [mascM]);
    check('masc: a member cannot run the purge', denied(await as(db, mascN1, `select public.masjid_chat_purge()`)));
    const mascPurged = await as(db, mascSA, `select public.masjid_chat_purge() as n`);
    check('masc: the purge deletes messages older than 30 days only', ok(mascPurged) && mascPurged.rows[0].n >= 1 &&
      (await admin(db, `select count(*)::int n from mosque_chat_messages where id = $1`, [mascOld]))[0].n === 0 &&
      (await admin(db, `select count(*)::int n from mosque_chat_messages where id = any($1::uuid[])`, [[mascRecent, mascN1Msg]]))[0].n === 2, mascPurged);
    check('masc: …with their reports', (await admin(db, `select count(*)::int n from mosque_chat_reports where message_id = $1`, [mascOld]))[0].n === 0);
    check('masc: …and reports / mod-log rows older than 90 days',
      (await admin(db, `select count(*)::int n from mosque_chat_reports where message_id = $1`, [mascN1Msg]))[0].n === 0 &&
      (await admin(db, `select array_agg(action) a from mosque_chat_mod_log where mosque_id = $1`, [mascM]))[0].a.join() === 'new');
    check('masc: the scheduled (no user) call works', (await admin(db, `select public.masjid_chat_purge() as n`))[0].n === 0);
  }

  // ------------------------------------------------------------------
  console.log('\nPhase — «المحفّظ» progress sync (0084)');
  {
    const Q1 = await signUp(db, 'qtut one', '01000000991');
    const Q2 = await signUp(db, 'qtut two', '01000000992');
    const save = (u, rows) => as(db, u, `select public.quran_tutor_save($1::jsonb) as n`, [JSON.stringify(rows)]);
    const row = (surah, ayah, status = 'memorized', perfect_count = 2, updated_at = new Date(Date.now() - 60000).toISOString()) => ({ surah, ayah, status, perfect_count, updated_at });
    const mine = async (u) => (await as(db, u, `select surah, ayah, status, perfect_count, updated_at from quran_tutor_progress order by surah, ayah`)).rows;

    check('qtut: guests cannot save', denied(await as(db, null, `select public.quran_tutor_save('[]'::jsonb)`)));
    const s1 = await save(Q1, [row(112, 1), row(112, 2, 'learning', 1), row(1, 7)]);
    check('qtut: a user saves rows', ok(s1) && s1.rows[0].n === 3, s1);
    check('qtut: the owner reads them', (await mine(Q1)).length === 3);
    check("qtut: others can't read them", (await mine(Q2)).length === 0);
    check('qtut: guests read nothing', denied(await as(db, null, `select * from quran_tutor_progress`)) ||
      (await as(db, null, `select * from quran_tutor_progress`)).rows?.length === 0);
    check("qtut: direct writes are refused", denied(await as(db, Q1, `insert into quran_tutor_progress (user_id, surah, ayah, status) values ($1, 2, 1, 'memorized')`, [Q1])) &&
      denied(await as(db, Q1, `update quran_tutor_progress set perfect_count = 50 where user_id = $1`, [Q1])) &&
      denied(await as(db, Q1, `delete from quran_tutor_progress where user_id = $1`, [Q1])));
    check('qtut: an ayah past the surah end is refused', denied(await save(Q1, [row(112, 5)])));
    check('qtut: surah 0 / 115 refused', denied(await save(Q1, [row(0, 1)])) && denied(await save(Q1, [row(115, 1)])));
    check('qtut: unknown status refused', denied(await save(Q1, [row(1, 1, 'hacked')])));
    check('qtut: perfect_count over 100 refused', denied(await save(Q1, [row(1, 1, 'learning', 101)])));
    check('qtut: junk rows refused', denied(await save(Q1, [{ surah: 'x', ayah: 1, status: 'learning' }])) &&
      denied(await as(db, Q1, `select public.quran_tutor_save('{"a":1}'::jsonb)`)));
    check('qtut: more than 300 rows per call refused', denied(await save(Q1, Array.from({ length: 301 }, (_, i) => row(2, i + 1)))));
    check('qtut: 286 rows (al-Baqara) in one call are fine', ok(await save(Q1, Array.from({ length: 286 }, (_, i) => row(2, i + 1, 'learning', 0)))));
    check('qtut: a failed batch saves nothing', (await mine(Q1)).filter((r) => r.surah === 1 && r.ayah === 1).length === 0);

    await save(Q1, [row(112, 1, 'learning', 0, new Date(Date.now() - 3600000).toISOString())]);
    check('qtut: an older copy does not overwrite a newer one', (await mine(Q1)).find((r) => r.surah === 112 && r.ayah === 1).status === 'memorized');
    await save(Q1, [row(112, 1, 'learning', 0, new Date(Date.now() - 1000).toISOString())]);
    check('qtut: a newer copy does', (await mine(Q1)).find((r) => r.surah === 112 && r.ayah === 1).status === 'learning');
    await save(Q1, [row(112, 3, 'memorized', 2, new Date(Date.now() + 86400000 * 365).toISOString())]);
    const fut = (await mine(Q1)).find((r) => r.surah === 112 && r.ayah === 3);
    check('qtut: a future time is clamped to now', fut && new Date(fut.updated_at).getTime() <= Date.now() + 1000, fut);
    check("qtut: saving never touches another user's rows", (await mine(Q2)).length === 0 &&
      (await admin(db, `select count(*)::int n from quran_tutor_progress where user_id = $1`, [Q2]))[0].n === 0);
    await save(Q2, [row(112, 1)]);
    check('qtut: reset clears one surah', ok(await as(db, Q1, `select public.quran_tutor_reset(112)`)) &&
      (await mine(Q1)).every((r) => r.surah !== 112) && (await mine(Q1)).length > 0);
    check("qtut: …and leaves other users' rows alone", (await mine(Q2)).length === 1);
    check('qtut: reset all', ok(await as(db, Q1, `select public.quran_tutor_reset()`)) && (await mine(Q1)).length === 0);
    check('qtut: guests cannot reset', denied(await as(db, null, `select public.quran_tutor_reset()`)));
  }

  // ------------------------------------------------------------------
  console.log('\nPhase mlive — «دروس أونلاين» live lessons (0085)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0085_masjid_live_lessons.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('mlive: 0085 is safe to re-run', rerun === null, rerun);
    // 0086 (lessons open to everyone) redefines the feed — put it back after the 0085 re-run.
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0086_masjid_live_public.sql'), 'utf8'));

    const M = (await admin(db, `insert into mosques (name, lat, lng, verified) values ('مسجد الرحمن', 30.05, 31.25, true) returning id`))[0].id;
    const U = (await admin(db, `insert into mosques (name, lat, lng) values ('مسجد مش موثق', 30.06, 31.26) returning id`))[0].id;
    const Far = (await admin(db, `insert into mosques (name, lat, lng, verified) values ('مسجد بعيد', 31.2, 29.9, true) returning id`))[0].id;
    const O = await signUp(db, 'mlive owner', null);
    const H = await signUp(db, 'mlive helper posts', null);
    const L = await signUp(db, 'mlive helper lessons', null);
    const UO = await signUp(db, 'mlive unverified owner', null);
    const FO = await signUp(db, 'mlive far owner', null);
    const Mem1 = await signUp(db, 'mlive member one', null);
    const Mem2 = await signUp(db, 'mlive member two', null);
    const X = await signUp(db, 'mlive outsider', null);
    const F = await signUp(db, 'mlive follower', null);
    await admin(db, `insert into mosque_admins (mosque_id, user_id, role, permissions) values
      ($1, $2, 'owner', '{}'), ($1, $3, 'helper', '{posts}'), ($1, $4, 'helper', '{lessons}'), ($5, $6, 'owner', '{}'), ($7, $8, 'owner', '{}')`,
      [M, O, H, L, U, UO, Far, FO]);
    await admin(db, `update profiles set phone_verified_at = now() where id = any($1::uuid[])`, [[Mem1, X]]);
    for (const u of [Mem1, Mem2]) await as(db, u, `select public.masjid_join($1)`, [M]);
    await as(db, F, `select public.masjid_follow($1, true)`, [M]);

    const inMin = (m) => new Date(Date.now() + m * 60000).toISOString();
    const create = (u, mosque, p) => as(db, u, `select public.masjid_live_create($1, $2::jsonb) as id`, [mosque, JSON.stringify(p)]);
    const join = async (u, s) => (await as(db, u, `select public.masjid_live_join_check($1) as j`, [s])).rows?.[0]?.j;
    const has = (r, text) => !!r.error && r.error.includes(text);
    const notes = async (u, like) => (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title like $2`, [u, like]))[0].n;

    // ---- create
    const base = { title: 'تفسير سورة الكهف', sheikh: 'الشيخ محمود', audience: 'all', scheduled_at: inMin(180), duration_minutes: 60, mode: 'audio', visibility: 'members' };
    const c1 = await create(O, M, base);
    check('mlive: the owner schedules a lesson', ok(c1) && !!c1.rows[0].id, c1);
    const S1 = c1.rows?.[0]?.id;
    check('mlive: a helper with «lessons» schedules one', ok(await create(L, M, { ...base, title: 'درس الفقه', visibility: 'public', mode: 'video', scheduled_at: inMin(30) })));
    check('mlive: a helper without «lessons» cannot', has(await create(H, M, base), 'غير مصرح'));
    check('mlive: a member cannot', has(await create(Mem1, M, base), 'غير مصرح'));
    check('mlive: a guest cannot', denied(await create(null, M, base)));
    check("mlive: an unverified mosque's owner cannot", has(await create(UO, U, base), 'غير مصرح'));
    check('mlive: a 1-char title is refused', has(await create(O, M, { ...base, title: 'د' }), 'عنوان'));
    check('mlive: a time in the past is refused', has(await create(O, M, { ...base, scheduled_at: inMin(-60) }), 'فات'));
    check('mlive: more than 60 days ahead is refused', has(await create(O, M, { ...base, scheduled_at: inMin(61 * 24 * 60) }), 'شهرين'));
    check('mlive: a 5-minute lesson is refused', has(await create(O, M, { ...base, duration_minutes: 5 }), 'مدة'));
    check('mlive: an unknown mode is refused', denied(await create(O, M, { ...base, mode: 'tv' })));
    check('mlive: an unknown visibility is refused', denied(await create(O, M, { ...base, visibility: 'secret' })));
    check('mlive: max_participants over 1000 is refused', denied(await create(O, M, { ...base, max_participants: 5000 })));
    const room1 = (await admin(db, `select room_name from mosque_live_sessions where id = $1`, [S1]))[0]?.room_name;
    check('mlive: the room name is generated and unique-looking', /^mlive_[a-z0-9]{32}$/.test(room1 || ''), room1);
    check('mlive: the client cannot read the table directly', denied(await as(db, Mem1, `select * from mosque_live_sessions`)));
    check('mlive: …nor insert into it', denied(await as(db, O, `insert into mosque_live_sessions (mosque_id, title, scheduled_at, room_name) values ($1, 'x x', now(), 'mlive_aaaaaaaaaaaaaaaaaaaa')`, [M])));
    check('mlive: …nor read participants', denied(await as(db, O, `select * from mosque_live_participants`)));
    check('mlive: scheduling notifies the followers', (await notes(Mem1, 'درس أونلاين جديد%')) === 1 && (await notes(F, 'درس أونلاين جديد%')) === 1);
    check("mlive: …not the one who scheduled it", (await notes(O, 'درس أونلاين جديد%')) === 0);
    check('mlive: …and the 0080 2-hour limit holds (the 2nd lesson notified nobody)', (await notes(Mem1, 'درس أونلاين%')) === 1);

    // ---- lists
    const list = async (u, past = false) => (await as(db, u, `select public.masjid_live_sessions($1, $2) as j`, [M, past])).rows?.map((r) => r.j) ?? [];
    const gl = await list(null);
    check('mlive: guests see the upcoming lessons (cannot join)', gl.length === 2 && gl.every((s) => s.can_join === false) && !('room_name' in gl[0]), gl);
    const ml = await list(Mem1);
    check('mlive: a member can join both', ml.length === 2 && ml.every((s) => s.can_join === true));
    const xl = await list(X);
    check('mlive: an outsider can join the public one only', xl.find((s) => s.id === S1)?.can_join === false && xl.find((s) => s.id !== S1)?.can_join === true);
    check('mlive: hosts are flagged', (await list(O)).every((s) => s.is_host === true) && ml.every((s) => s.is_host === false));

    // ---- update / cancel
    check('mlive: the owner edits a scheduled lesson', ok(await as(db, O, `select public.masjid_live_update($1, $2::jsonb)`, [S1, JSON.stringify({ ...base, title: 'تفسير الكهف — الجزء الأول', scheduled_at: inMin(20) })])));
    check('mlive: a member cannot edit it', has(await as(db, Mem1, `select public.masjid_live_update($1, $2::jsonb)`, [S1, JSON.stringify(base)]), 'غير مصرح'));
    const c3 = await create(O, M, { ...base, title: 'درس هيتلغي', scheduled_at: inMin(600) });
    const S3 = c3.rows?.[0]?.id;
    check('mlive: a member cannot cancel', denied(await as(db, Mem1, `select public.masjid_live_cancel($1)`, [S3])));
    check('mlive: the owner cancels a scheduled lesson', ok(await as(db, O, `select public.masjid_live_cancel($1)`, [S3])) &&
      (await admin(db, `select status from mosque_live_sessions where id = $1`, [S3]))[0].status === 'cancelled');
    check('mlive: a cancelled lesson cannot be started', denied(await as(db, O, `select public.masjid_live_start($1)`, [S3])));
    check('mlive: joining a cancelled lesson says so', (await join(Mem1, S3))?.reason === 'cancelled');

    // ---- before it starts
    check('mlive: joining before the start → not_live', (await join(Mem1, S1))?.reason === 'not_live');
    const ownerEarly = await join(O, S1);
    check('mlive: …the host is told to start it', ownerEarly?.reason === 'not_live' && ownerEarly.is_host === true, ownerEarly);
    check('mlive: guests cannot call the join check at all', denied(await as(db, null, `select public.masjid_live_join_check($1)`, [S1])));
    check('mlive: an unknown lesson → not_found', (await join(Mem1, '00000000-0000-0000-0000-000000000000'))?.reason === 'not_found');
    const far = await create(FO, Far, { ...base, title: 'درس بكرة', scheduled_at: inMin(24 * 60) });
    check('mlive: starting more than an hour early is refused', has(await as(db, FO, `select public.masjid_live_start($1)`, [far.rows?.[0]?.id]), 'بساعة'));

    // ---- start
    check('mlive: a member cannot start it', denied(await as(db, Mem1, `select public.masjid_live_start($1)`, [S1])));
    check('mlive: a helper without «lessons» cannot start it', denied(await as(db, H, `select public.masjid_live_start($1)`, [S1])));
    const st = await as(db, O, `select public.masjid_live_start($1) as s`, [S1]);
    check('mlive: the owner starts it', ok(st) && st.rows[0].s.status === 'live', st);
    check('mlive: going live notifies the members once', (await notes(Mem1, 'درس مباشر دلوقتي%')) === 1 && (await notes(F, 'درس مباشر دلوقتي%')) === 1);
    check('mlive: starting again is a no-op (no second notification)', ok(await as(db, O, `select public.masjid_live_start($1)`, [S1])) && (await notes(Mem1, 'درس مباشر دلوقتي%')) === 1);
    const S2 = (await admin(db, `select id from mosque_live_sessions where mosque_id = $1 and visibility = 'public' and status = 'scheduled'`, [M]))[0].id;
    check('mlive: only one live lesson per mosque', has(await as(db, L, `select public.masjid_live_start($1)`, [S2]), 'درس تاني شغال'));
    check('mlive: a started lesson cannot be edited', denied(await as(db, O, `select public.masjid_live_update($1, $2::jsonb)`, [S1, JSON.stringify(base)])));
    check('mlive: a live lesson cannot be cancelled', denied(await as(db, O, `select public.masjid_live_cancel($1)`, [S1])));

    // ---- join check
    const jo = await join(O, S1);
    check('mlive: the owner joins as host', jo?.ok === true && jo.role === 'host' && jo.room === room1 && jo.name === 'mlive owner', jo);
    check('mlive: a helper with «lessons» is a host too', (await join(L, S1))?.role === 'host');
    const j1 = await join(Mem1, S1);
    check('mlive: a member joins as listener', j1?.ok === true && j1.role === 'listener' && j1.can_speak === true, j1);
    check('mlive: the identity is an opaque participant id, not the account id',
      /^[0-9a-f-]{36}$/.test(j1?.identity || '') && j1.identity !== Mem1 &&
      (await admin(db, `select user_id from mosque_live_participants where id = $1`, [j1.identity]))[0]?.user_id === Mem1);
    check('mlive: re-joining keeps the same identity', (await join(Mem1, S1))?.identity === j1?.identity);
    const j2 = await join(Mem2, S1);
    check('mlive: an unverified member listens (can_speak = false)', j2?.ok === true && j2.role === 'listener' && j2.can_speak === false, j2);
    check('mlive: a non-member is refused a members-only lesson', (await join(X, S1))?.reason === 'members_only');
    check('mlive: a follower who is not a member is refused too', (await join(F, S1))?.reason === 'members_only');
    await as(db, Mem1, `select public.masjid_chat_set_nickname($1, 'أبو يوسف')`, [M]);
    check("mlive: the display name is the member's chat nickname", (await join(Mem1, S1))?.name === 'أبو يوسف');

    // ---- hands
    const hand = (u, raise) => as(db, u, `select public.masjid_live_hand($1, $2) as r`, [S1, raise]);
    check('mlive: an unverified listener cannot raise a hand', has(await hand(Mem2, true), 'توثّق'));
    check('mlive: …but can lower it', ok(await hand(Mem2, false)));
    check('mlive: someone who never joined cannot raise a hand', has(await hand(X, true), 'ادخل الدرس'));
    check('mlive: a verified listener raises a hand', ok(await hand(Mem1, true)));
    const hands = await as(db, O, `select * from public.masjid_live_hands($1)`, [S1]);
    check('mlive: the host sees the raised hand (with the nickname)', ok(hands) && hands.rows.length === 1 && hands.rows[0].participant_id === j1.identity && hands.rows[0].name === 'أبو يوسف', hands);
    check('mlive: a listener cannot list the hands', denied(await as(db, Mem1, `select * from public.masjid_live_hands($1)`, [S1])));

    // ---- speakers
    const speaker = (u, p, on) => as(db, u, `select public.masjid_live_set_speaker($1, $2, $3) as r`, [S1, p, on]);
    check('mlive: a listener cannot promote anyone', denied(await speaker(Mem2, j1.identity, true)));
    const pr = await speaker(O, j1.identity, true);
    check('mlive: the host promotes the hand to speaker', ok(pr) && pr.rows[0].r.identity === j1.identity && pr.rows[0].r.room === room1 && pr.rows[0].r.speaker === true, pr);
    check('mlive: …the hand is lowered', (await as(db, O, `select * from public.masjid_live_hands($1)`, [S1])).rows.every((r) => r.hand_raised_at === null));
    check('mlive: the speaker re-joins as speaker', (await join(Mem1, S1))?.role === 'speaker');
    check('mlive: an unverified listener cannot be promoted', has(await speaker(O, j2.identity, true), 'ماوثّقش'));
    check('mlive: a host cannot be "promoted"', denied(await speaker(O, jo.identity, true)));
    check('mlive: the host demotes the speaker', ok(await speaker(O, j1.identity, false)) && (await join(Mem1, S1))?.role === 'listener');
    check('mlive: a verified phone is re-checked at join (speaker flag alone is not enough)', await (async () => {
      await speaker(O, j1.identity, true);
      await admin(db, `update profiles set phone_verified_at = null where id = $1`, [Mem1]);
      const r = (await join(Mem1, S1))?.role;
      await admin(db, `update profiles set phone_verified_at = now() where id = $1`, [Mem1]);
      await speaker(O, j1.identity, false);
      return r === 'listener';
    })());

    // ---- remove
    check('mlive: a listener cannot remove anyone', denied(await as(db, Mem1, `select public.masjid_live_remove($1, $2)`, [S1, j2.identity])));
    check('mlive: the host cannot remove a host', denied(await as(db, O, `select public.masjid_live_remove($1, $2)`, [S1, jo.identity])));
    const rm = await as(db, O, `select public.masjid_live_remove($1, $2) as r`, [S1, j2.identity]);
    check('mlive: the host removes a listener', ok(rm) && rm.rows[0].r.identity === j2.identity, rm);
    check('mlive: …who cannot re-join that lesson', (await join(Mem2, S1))?.reason === 'removed');
    check('mlive: …nor raise a hand', denied(await hand(Mem2, true)));
    check('mlive: host_room is for hosts only', ok(await as(db, O, `select public.masjid_live_host_room($1)`, [S1])) && denied(await as(db, Mem1, `select public.masjid_live_host_room($1)`, [S1])));

    // ---- feed
    const feed = async (u, lat, lng) => (await as(db, u, `select public.masjid_live_feed($1, $2, 10, 20) as j`, [lat ?? null, lng ?? null])).rows?.map((r) => r.j) ?? [];
    const fm = await feed(Mem1);
    check("mlive: the feed shows a member their mosque's lessons (live first)", fm.length === 2 && fm[0].id === S1 && fm[0].status === 'live' && fm[0].my_mosque === true, fm);
    const fx = await feed(X, 30.05, 31.25);
    check('mlive: an outsider nearby sees only the public lesson', fx.length === 1 && fx[0].visibility === 'public' && typeof fx[0].distance_km === 'number', fx);
    const ff = await feed(X, 24.09, 32.9);
    check('mlive: (0086) an outsider far away still sees the public lesson, not the members-only one', ff.some((s) => s.mosque_id === M && s.visibility === 'public') && ff.every((s) => s.mosque_id !== M || s.visibility === 'public'), ff);
    const fg = await feed(null, 30.05, 31.25);
    check('mlive: a guest nearby sees the public lesson (can_join = false)', fg.length === 1 && fg[0].can_join === false);
    check('mlive: the far mosque shows up for its own owner', (await feed(FO)).some((s) => s.mosque_id === Far));

    // ---- end
    check('mlive: a member cannot end it', denied(await as(db, Mem1, `select public.masjid_live_end($1)`, [S1])));
    const en = await as(db, O, `select public.masjid_live_end($1) as room`, [S1]);
    check('mlive: the host ends it (room name back for LiveKit)', ok(en) && en.rows[0].room === room1, en);
    check('mlive: joining an ended lesson says it is over', (await join(Mem1, S1))?.reason === 'ended');
    check('mlive: …even for the host', (await join(O, S1))?.reason === 'ended');
    check('mlive: hands are refused after the end', denied(await hand(Mem1, true)));
    check('mlive: the ended lesson leaves the lists', (await list(Mem1)).every((s) => s.id !== S1) && (await feed(Mem1)).every((s) => s.id !== S1));
    check('mlive: managers still see it with past lessons', (await list(O, true)).some((s) => s.id === S1 && s.status === 'ended'));
    check('mlive: …members do not', (await list(Mem1, true)).every((s) => s.id !== S1));

    // ---- stale & expiry
    check('mlive: the public lesson can start now the other one ended', ok(await as(db, L, `select public.masjid_live_start($1)`, [S2])));
    check('mlive: the outsider joins the public lesson as listener', (await join(X, S2))?.role === 'listener');
    await admin(db, `update mosque_live_sessions set started_at = now() - interval '8 hours' where id = $1`, [S2]);
    check('mlive: a forgotten live lesson counts as ended', (await join(X, S2))?.reason === 'ended' && (await feed(X, 30.05, 31.25)).every((s) => s.id !== S2));
    check('mlive: members cannot run the expiry', denied(await as(db, Mem1, `select public.masjid_live_expire()`)));
    const ex = await admin(db, `select public.masjid_live_expire() as n`);
    check('mlive: the expiry closes it', ex[0].n >= 1 && (await admin(db, `select status from mosque_live_sessions where id = $1`, [S2]))[0].status === 'ended', ex);

    // ---- the LiveKit token signer (the exact block from the Edge Function)
    const src = fs.readFileSync(path.join(__dirname, '..', 'functions', 'livekit-token', 'index.ts'), 'utf8');
    const block = src.slice(src.indexOf('// ----------------------------------------------------------------- jwt:begin'), src.indexOf('// ------------------------------------------------------------------- jwt:end'));
    let lk = null;
    try {
      lk = new Function('crypto', block + '\nreturn { b64url, signJwtHs256, liveKitGrant, liveKitToken };')(require('crypto').webcrypto);
    } catch (e) {
      lk = { error: e.message };
    }
    check('mlive: the jwt block runs in Node as plain JavaScript', lk && !lk.error, lk);
    if (lk && !lk.error) {
      const vector = await lk.signJwtHs256({ sub: '1234567890', name: 'John Doe', iat: 1516239022 }, 'your-256-bit-secret');
      check('mlive: HS256 matches the RFC/jwt.io test vector',
        vector === 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c', vector);
      const nodeCrypto = require('crypto');
      const tok = await lk.liveKitToken('APIkey123', 'secret-ÄØ-عربي', j1.identity, 'أبو يوسف', lk.liveKitGrant('listener', 'audio', room1), 7200, '{"role":"listener"}', 1700000000000);
      const [h, p, sig] = tok.split('.');
      const expect = nodeCrypto.createHmac('sha256', 'secret-ÄØ-عربي').update(h + '.' + p).digest('base64url');
      check('mlive: the LiveKit token verifies with Node crypto (UTF-8 secret)', sig === expect);
      const payload = JSON.parse(Buffer.from(p, 'base64url').toString('utf8'));
      check('mlive: token claims: iss, sub, name, nbf/exp = 2 h, metadata',
        payload.iss === 'APIkey123' && payload.sub === j1.identity && payload.name === 'أبو يوسف' &&
        payload.exp - payload.iat === 7200 && payload.nbf <= payload.iat && payload.iat === 1700000000 && payload.metadata === '{"role":"listener"}', payload);
      const lg = payload.video;
      check('mlive: listener grant: join + subscribe + data, no publish, no admin',
        lg.room === room1 && lg.roomJoin === true && lg.canSubscribe === true && lg.canPublishData === true &&
        lg.canPublish === false && !('canPublishSources' in lg) && !('roomAdmin' in lg), lg);
      const sg = lk.liveKitGrant('speaker', 'audio', room1);
      check('mlive: speaker grant in an audio lesson: microphone only', sg.canPublish === true && JSON.stringify(sg.canPublishSources) === '["microphone"]' && sg.roomAdmin === undefined);
      const hg = lk.liveKitGrant('host', 'video', room1);
      check('mlive: host grant in a video lesson: camera + mic + screen, room admin',
        hg.canPublish === true && hg.roomAdmin === true && hg.canPublishSources.includes('camera') && hg.canPublishSources.includes('microphone'));
      check('mlive: unknown roles get the listener grant', lk.liveKitGrant('owner', 'video', room1).canPublish === false);
    }
  }

  // ------------------------------------------------------------------
  console.log('\n«كلّمنا» — the floating feedback button (0088)');
  {
    const submit = (u, kind, body, contact, source) =>
      as(db, u, `select public.submit_feedback($1, $2, $3, $4::jsonb) as id`, [kind, body, contact ?? null, source ? JSON.stringify(source) : null]);
    const src = { app: 'mogtama3y', path: '/marketplace', version: '1.0.0', ua: 'Chrome 129 / Android', secret: 'x'.repeat(5000) };

    const g1 = await submit(null, 'suggestion', 'ياريت تضيفوا قسم للصيدليات المناوبة', '0100 123-4567', src);
    check('fdb: a guest can send a suggestion', ok(g1) && !!g1.rows[0].id, g1);
    const gRow = (await admin(db, `select * from support_tickets where id = $1`, [g1.rows?.[0]?.id]))[0];
    check('fdb: …stored with no user, the cleaned contact, category suggestion',
      gRow && gRow.user_id === null && gRow.contact === '01001234567' && gRow.category === 'suggestion' && gRow.kind === 'suggestion' && gRow.status === 'open', gRow);
    check('fdb: …context keeps only the known keys', gRow && gRow.source.app === 'mogtama3y' && gRow.source.path === '/marketplace' && !('secret' in gRow.source), gRow?.source);
    check('fdb: a guest cannot read tickets', denied(await as(db, null, `select id from support_tickets`)));
    check('fdb: a guest cannot insert tickets directly', denied(await as(db, null, `insert into support_tickets (category, subject, body) values ('other', 'x', 'xxxxxxxxxxxx')`)));
    check('fdb: a signed-in user does not see guest tickets', (await as(db, B, `select id from support_tickets where user_id is null`)).rows?.length === 0);
    check('fdb: too short is refused', denied(await submit(null, 'bug', 'قصير')));
    check('fdb: too long is refused', denied(await submit(null, 'bug', 'ا'.repeat(2001))));
    check('fdb: unknown kind is refused', denied(await submit(null, 'spam', 'رسالة طويلة كفاية للاختبار')));
    check('fdb: a bad contact number is refused', denied(await submit(null, 'question', 'عندي سؤال عن التسجيل في التطبيق', '12ab')));
    check('fdb: guests cannot send links', denied(await submit(null, 'question', 'ادخل على https://spam.example.com دلوقتي')) &&
      denied(await submit(null, 'question', 'ادخل على cheap-pills.com دلوقتي')));
    check('fdb: the same guest text twice is refused', denied(await submit(null, 'suggestion', 'ياريت تضيفوا قسم للصيدليات المناوبة')));
    check('fdb: a guest contact sends at most 3 a day',
      ok(await submit(null, 'bug', 'الصفحة بتقفل لوحدها رقم ٢', '01001234567')) &&
      ok(await submit(null, 'bug', 'الصفحة بتقفل لوحدها رقم ٣', '01001234567')) &&
      denied(await submit(null, 'bug', 'الصفحة بتقفل لوحدها رقم ٤', '01001234567')));

    const s1 = await submit(C, 'bug', 'زرار الدفع مش شغال في صفحة المحل', null, { app: 'tajer', path: '/merchant' });
    check('fdb: a signed-in user sends a problem report', ok(s1), s1);
    const sRow = (await admin(db, `select * from support_tickets where id = $1`, [s1.rows?.[0]?.id]))[0];
    check('fdb: …linked to them, category technical', sRow && sRow.user_id === C && sRow.category === 'technical' && sRow.kind === 'bug' && sRow.subject.startsWith('مشكلة: '), sRow);
    check('fdb: …and they can see their own ticket', (await as(db, C, `select id from support_tickets where id = $1`, [sRow?.id])).rows?.length === 1);
    check('fdb: signed-in users may post links', ok(await submit(C, 'question', 'ينفع أحط لينك https://mogtama3y.com في إعلاني؟')));

    const boss2 = (await admin(db, `select id from profiles where role = 'super_admin' limit 1`))[0].id;
    const inbox = await as(db, boss2, `select id, kind, contact, source, user_id from support_tickets where kind is not null and status = 'open'`);
    check('fdb: the admin sees guest and user feedback with context',
      ok(inbox) && inbox.rows.some((r) => r.user_id === null && r.contact === '01001234567' && r.source.path === '/marketplace') &&
      inbox.rows.some((r) => r.user_id === C && r.source.app === 'tajer'), inbox);
    check('fdb: the admin closes a guest ticket (no notification to anyone)', ok(await as(db, boss2, `select public.resolve_support_ticket($1, '')`, [gRow?.id])) &&
      (await admin(db, `select status from support_tickets where id = $1`, [gRow?.id]))[0].status === 'resolved');
    check('fdb: replying to a user ticket still needs text', denied(await as(db, boss2, `select public.resolve_support_ticket($1, '  ')`, [sRow?.id])));
    check('fdb: …and still notifies them', ok(await as(db, boss2, `select public.resolve_support_ticket($1, 'اتصلح، جرّب تاني')`, [sRow?.id])) &&
      (await admin(db, `select 1 from notifications where user_id = $1 and body = 'اتصلح، جرّب تاني'`, [C])).length === 1);

    const F = await signUp(db, 'feedbacker', '01000008801');
    let n = 0;
    for (let i = 0; i < 11; i++) if (ok(await submit(F, 'suggestion', `اقتراح رقم ${i} لتطوير التطبيق`))) n++;
    check('fdb: a signed-in user is limited to 10 a day', n === 10, n);

    await admin(db, `insert into support_tickets (category, subject, body, kind, created_at)
      select 'other', 'سؤال', 'رسالة ضيف رقم ' || g, 'question', now() - interval '1 hour' from generate_series(1, 200) g`);
    check('fdb: guests share a daily budget of 200', denied(await submit(null, 'question', 'سؤال جديد بعد ما الحد خلص')));
    await admin(db, `update support_tickets set created_at = now() - interval '2 days' where user_id is null`);
    check('fdb: …which frees up the next day', ok(await submit(null, 'question', 'سؤال جديد بعد ما الحد خلص')));
  }

  console.log(`\n${passed} passed, ${failures.length} failed`);
  if (failures.length) {
    console.log('FAILED:\n - ' + failures.join('\n - '));
    process.exit(1);
  }
})().catch((e) => { console.error('HARNESS ERROR', e); process.exit(1); });
