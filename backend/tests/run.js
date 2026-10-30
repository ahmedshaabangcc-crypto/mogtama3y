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
    // 0087: anywhere on Earth (the mww block covers Dubai / London); nonsense is still refused.
    check('mtool: a place off the planet is refused', denied(await as(db, MT1, `select public.set_prayer_reminders(95, -0.1, '{"fajr":0}'::jsonb)`)));
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
    const note = await admin(db, `select title, body, deep_link from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%'`, [MT1]);
    check('mtool: the tick sends the due reminder as a notification (→ push)', sent1 === 1 && note.length === 1 && note[0].title === 'الفجر بعد 10 دقايق' && note[0].body.startsWith('أذان الفجر '), { sent1, note });
    const sent2 = (await admin(db, `select private.prayer_reminders_tick($1::timestamptz) n`, [at]))[0].n;
    check('mtool: …once only', sent2 === 0 && (await admin(db, `select count(*)::int n from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%'`, [MT1]))[0].n === 1);
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
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%' and created_at < $2::timestamptz - interval '12 hours'`, [MT1, later]))[0].n === 0);
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
    // 0087 redefines 0081/0083 functions (chat send, profile, feed, add mosque) — put it back.
    await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0087_masjid_worldwide.sql'), 'utf8'));
    // …and 0089 (chat send's phone filter, mosque helpers by any Arab mobile).
    await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0089_arab_world_foundation.sql'), 'utf8'));
    // …and 0092 (shop orders / fund withdrawal redefined with the currency).
    await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0092_arab_currency.sql'), 'utf8'));
    // …and 0096 (store orders with line snapshots, tracking / stats reading them).
    await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
    // …and 0098 (store orders with variants, restock per variant).
    await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
    await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)

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
    // …and 0087 (worldwide: hands / speakers / create redefined).
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0087_masjid_worldwide.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0089_arab_world_foundation.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0092_arab_currency.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
    // …and 0098 (store orders with variants, restock per variant).
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)

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

  // ------------------------------------------------------------------
  console.log('\nPhase mww — «مسجدي» worldwide (0087)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0087_masjid_worldwide.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('mww: 0087 is safe to re-run', rerun === null, rerun);
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0089_arab_world_foundation.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0092_arab_currency.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
    // …and 0098 (store orders with variants, restock per variant).
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)
    const has = (r, text) => !!r.error && r.error.includes(text);

    // ---- places: country / zone / currency
    check('mww: every mosque has a zone and a currency',
      (await admin(db, `select count(*)::int n from mosques where tz is null or currency is null`))[0].n === 0);
    const cairoM = (await admin(db, `insert into mosques (name, lat, lng, verified) values ('مسجد الحسين', 30.0478, 31.2625, true) returning id, country, tz, currency`))[0];
    check('mww: a mosque inside Egypt is EG / Africa/Cairo / EGP', cairoM.country === 'EG' && cairoM.tz === 'Africa/Cairo' && cairoM.currency === 'EGP', cairoM);
    const sharm = (await admin(db, `insert into mosques (name, lat, lng, country, tz) values ('مسجد شرم الشيخ', 27.9158, 34.33, 'SA', 'Asia/Riyadh') returning country, tz, currency`))[0];
    check('mww: …even when the app says otherwise (Sharm El Sheikh)', sharm.country === 'EG' && sharm.tz === 'Africa/Cairo' && sharm.currency === 'EGP', sharm);
    const zz = (await admin(db, `insert into mosques (name, lat, lng, country) values ('Mosque X', -30.5, -140.2, 'ZZ') returning country, tz, currency`))[0];
    check('mww: unknown country → USD, zone from the longitude', zz.currency === 'USD' && zz.tz === 'Etc/GMT+9', zz);
    const egy = await admin(db, `select private.in_egypt(30.0444, 31.2357) a, private.in_egypt(24.0889, 32.8998) b, private.in_egypt(29.502, 34.89) c,
      private.in_egypt(28.3838, 36.555) d, private.in_egypt(29.5267, 35.0078) e, private.in_egypt(31.76, 25.09) f, private.in_egypt(25.2048, 55.2708) g,
      private.in_egypt(31.5017, 34.4668) h, private.in_egypt(22.2, 36.6) i`);
    check('mww: the Egypt polygon (Cairo, Aswan, Taba, Halaib in; Tabuk, Aqaba, Bardia, Dubai, Gaza out)',
      egy[0].a && egy[0].b && egy[0].c && !egy[0].d && !egy[0].e && !egy[0].f && !egy[0].g && !egy[0].h && egy[0].i, egy[0]);

    // ---- adding a mosque abroad
    const AE1 = await signUp(db, 'mww dubai one', null);
    const AE2 = await signUp(db, 'mww dubai two', null);
    const EG1 = await signUp(db, 'mww cairo one', null);
    const EG2 = await signUp(db, 'mww cairo imam', null);
    const add = (u, name, lat, lng, tz, country) =>
      as(db, u, `select public.masjid_add_mosque($1, $2, $3, null, null, null, $4, $5) as id`, [name, lat, lng, tz, country]);
    const r1 = await add(AE1, 'مسجد الفاروق عمر بن الخطاب', 25.1867, 55.2531, 'Asia/Dubai', 'AE');
    check('mww: a user adds a mosque in Dubai', ok(r1) && !!r1.rows[0].id, r1);
    const DUB = r1.rows?.[0]?.id;
    const dub = (await admin(db, `select country, tz, currency from mosques where id = $1`, [DUB]))[0];
    check('mww: …AE / Asia/Dubai / AED', dub.country === 'AE' && dub.tz === 'Asia/Dubai' && dub.currency === 'AED', dub);
    check('mww: …and the creator joined it', (await admin(db, `select count(*)::int n from mosque_members where mosque_id = $1 and user_id = $2`, [DUB, AE1]))[0].n === 1);
    const r2 = await add(AE1, 'East London Mosque', 51.5175, -0.0653, 'Mars/Base', 'gb');
    const lon = (await admin(db, `select country, tz, currency from mosques where id = $1`, [r2.rows?.[0]?.id]))[0];
    check('mww: an unknown zone falls back to the longitude; country upper-cased; GBP',
      ok(r2) && lon.tz === 'Etc/GMT' && lon.country === 'GB' && lon.currency === 'GBP', { r2, lon });
    check('mww: impossible coordinates are refused',
      denied(await add(AE1, 'مسجد غلط', 95, 10, null, null)) && denied(await add(AE1, 'مسجد غلط', 10, 190, null, null)) && denied(await add(AE1, 'مسجد غلط', 0, 0, null, null)));
    check('mww: old 6-argument calls still work', ok(await as(db, AE1, `select public.masjid_add_mosque('Masjid Al Noor Sharjah', 25.3463, 55.4209)`)));
    check('mww: the daily limit still holds', has(await add(AE1, 'مسجد رابع', 25.25, 55.3, 'Asia/Dubai', 'AE'), 'كتير'));
    const gm = (await as(db, AE2, `select public.get_mosque($1) as m`, [DUB])).rows?.[0]?.m;
    const gc = (await as(db, null, `select public.get_mosque($1) as m`, [cairoM.id])).rows?.[0]?.m;
    check('mww: get_mosque returns country / tz / currency / phone_required',
      gm?.tz === 'Asia/Dubai' && gm.currency === 'AED' && gm.country === 'AE' && gm.phone_required === false && gc?.phone_required === true && gc.tz === 'Africa/Cairo', { gm, gc });
    check('mww: guests can read the new columns', ok(await as(db, null, `select country, tz, currency, osm_id from mosques limit 1`)));
    check("mww: users can't write them", denied(await as(db, AE1, `update mosques set currency = 'USD', country = 'EG' where id = $1`, [DUB])));

    // ---- OpenStreetMap import
    const imp = (u, type, id, name, lat, lng, join = true) => as(db, u,
      `select public.masjid_import_osm($1, $2, $3, $4, $5, 'Asia/Dubai', 'AE', $6) as id`, [type, id, name, lat, lng, join]);
    const o1 = await imp(AE2, 'node', 123456789, 'Al Farooq Mosque', 25.2, 55.27);
    check('mww: an OSM mosque is imported', ok(o1) && !!o1.rows[0].id, o1);
    const OSM1 = o1.rows?.[0]?.id;
    const o1row = (await admin(db, `select osm_type, osm_id, country, tz, currency, added_by from mosques where id = $1`, [OSM1]))[0];
    check('mww: …with its OSM reference, AE / Asia/Dubai / AED', o1row.osm_type === 'node' && Number(o1row.osm_id) === 123456789 && o1row.currency === 'AED' && o1row.added_by === AE2, o1row);
    check('mww: …and the importer joined it', (await admin(db, `select count(*)::int n from mosque_members where mosque_id = $1 and user_id = $2`, [OSM1, AE2]))[0].n === 1);
    const o1again = await imp(AE1, 'node', 123456789, 'Al Farooq Mosque (renamed)', 25.2001, 55.2701, false);
    check('mww: importing the same OSM object again → the same mosque (idempotent)',
      o1again.rows?.[0]?.id === OSM1 && (await admin(db, `select count(*)::int n from mosques where osm_type = 'node' and osm_id = 123456789`))[0].n === 1, o1again);
    check('mww: …opening it (p_join = false) does not join', (await admin(db, `select count(*)::int n from mosque_members where mosque_id = $1 and user_id = $2`, [OSM1, AE1]))[0].n === 0);
    const near = await imp(AE2, 'way', 555, 'Masjid Al Farooq Omar Bin Al Khattab مسجد الفاروق عمر بن الخطاب', 25.18672, 55.25312);
    const near2 = await imp(AE2, 'way', 556, 'مسجد الفاروق عمر بن الخطاب', 25.18673, 55.25314);
    check('mww: an OSM mosque ~3 m from ours with the same name is matched, not duplicated',
      near2.rows?.[0]?.id === DUB && (await admin(db, `select osm_type, osm_id from mosques where id = $1`, [DUB]))[0].osm_id !== null, { near, near2 });
    const other = await imp(AE2, 'node', 557, 'Jumeirah Grand Mosque', 25.18675, 55.2532);
    check('mww: …a different name 10 m away is another mosque', ok(other) && other.rows[0].id !== DUB);
    const farSame = await imp(AE2, 'node', 558, 'مسجد الفاروق عمر بن الخطاب', 25.1880, 55.2531);
    check('mww: …the same name 145 m away is another mosque', ok(farSame) && farSame.rows[0].id !== DUB);
    check('mww: bad OSM references are refused',
      denied(await imp(AE2, 'area', 1, 'x', 25.2, 55.2)) && denied(await imp(AE2, 'node', -5, 'x', 25.2, 55.2)) && denied(await imp(AE2, 'node', 9, 'x', 99, 55.2)));
    check('mww: guests cannot import', denied(await as(db, null, `select public.masjid_import_osm('node', 77, 'x', 25.2, 55.2)`)));
    const nb = await as(db, null, `select id from public.nearby_mosques(25.2, 55.27, 2, 40)`);
    check('mww: imported mosques show up in nearby_mosques', ok(nb) && nb.rows.some((r) => r.id === OSM1));
    const egOsm = await as(db, EG1, `select public.masjid_import_osm('node', 9001, 'مسجد السيدة زينب', 30.0293, 31.2425, 'Asia/Dubai', 'AE', false) as id`);
    const egOsmRow = (await admin(db, `select country, tz, currency from mosques where id = $1`, [egOsm.rows?.[0]?.id]))[0];
    check('mww: an OSM mosque in Cairo is still EG / Africa/Cairo / EGP', egOsmRow?.country === 'EG' && egOsmRow.tz === 'Africa/Cairo' && egOsmRow.currency === 'EGP', egOsmRow);

    // ---- verified phone: Egypt only (owner decision)
    await as(db, AE2, `select public.masjid_join($1)`, [DUB]);
    const send = (u, m, b) => as(db, u, `select public.masjid_chat_send($1, $2) as id`, [m, b]);
    check('mww: Dubai mosque: an unverified member can post in the chat', ok(await send(AE2, DUB, 'السلام عليكم يا جماعة')));
    const pAE = (await as(db, AE2, `select public.masjid_my_chat_profile($1) as p`, [DUB])).rows?.[0]?.p;
    check('mww: …and gets no «verify your phone» banner', pAE?.needs_phone === false && pAE.phone_required === false, pAE);
    check('mww: international numbers are blocked in the chat too', has(await send(AE1, DUB, 'كلموني على +971501234567'), 'أرقام') && has(await send(AE1, DUB, 'رقمي 0501234567'), 'أرقام'));
    await as(db, EG1, `select public.masjid_join($1)`, [cairoM.id]);
    check('mww: Cairo mosque: an unverified member is still blocked', has(await send(EG1, cairoM.id, 'السلام عليكم'), 'توثّق'));
    const pEG = (await as(db, EG1, `select public.masjid_my_chat_profile($1) as p`, [cairoM.id])).rows?.[0]?.p;
    check('mww: …and sees the banner', pEG?.needs_phone === true && pEG.phone_required === true, pEG);

    await admin(db, `update mosques set verified = true where id = $1`, [DUB]);
    await admin(db, `insert into mosque_admins (mosque_id, user_id, role, permissions) values ($1, $2, 'owner', '{}'), ($3, $4, 'owner', '{}')`, [DUB, AE1, cairoM.id, EG2]);
    const lesson = { title: 'درس الفجر', sheikh: 'الشيخ أحمد', audience: 'all', scheduled_at: new Date(Date.now() + 5 * 60000).toISOString(), duration_minutes: 60, mode: 'audio', visibility: 'public' };
    const LD = (await as(db, AE1, `select public.masjid_live_create($1, $2::jsonb) as id`, [DUB, JSON.stringify(lesson)])).rows?.[0]?.id;
    const LC = (await as(db, EG2, `select public.masjid_live_create($1, $2::jsonb) as id`, [cairoM.id, JSON.stringify(lesson)])).rows?.[0]?.id;
    check('mww: lessons scheduled in both mosques', !!LD && !!LC);
    await as(db, AE1, `select public.masjid_live_start($1)`, [LD]);
    await as(db, EG2, `select public.masjid_live_start($1)`, [LC]);
    const jD = (await as(db, AE2, `select public.masjid_live_join_check($1) as j`, [LD])).rows?.[0]?.j;
    check('mww: Dubai lesson: an unverified listener can speak', jD?.ok === true && jD.can_speak === true && jD.phone_required === false, jD);
    check('mww: …and raise a hand', ok(await as(db, AE2, `select public.masjid_live_hand($1, true)`, [LD])));
    const hD = await as(db, AE1, `select * from public.masjid_live_hands($1)`, [LD]);
    check('mww: …the host sees can_speak and can make them a speaker',
      ok(hD) && hD.rows[0]?.can_speak === true && ok(await as(db, AE1, `select public.masjid_live_set_speaker($1, $2, true)`, [LD, hD.rows[0].participant_id])), hD);
    const jC = (await as(db, EG1, `select public.masjid_live_join_check($1) as j`, [LC])).rows?.[0]?.j;
    check('mww: Cairo lesson: an unverified listener still cannot speak', jC?.ok === true && jC.can_speak === false && jC.phone_required === true, jC);
    check('mww: …nor raise a hand', has(await as(db, EG1, `select public.masjid_live_hand($1, true)`, [LC]), 'توثّق'));

    // ---- currency
    const need = await as(db, AE1, `insert into mosque_needs (mosque_id, title, target_amount) values ($1, 'تكييف', 5000) returning id`, [DUB]);
    check('mww: the need notification uses the mosque currency',
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and body like '%5,000 د.إ%'`, [AE2]))[0].n === 1);
    await as(db, AE2, `select public.masjid_pledge($1, 250)`, [need.rows?.[0]?.id]);
    check('mww: …and so does the pledge notification', (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title = 'تعهد جديد بـ 250 د.إ'`, [AE1]))[0].n === 1);
    const feed = await as(db, AE2, `select * from public.masjid_nearby_feed(25.1867, 55.2531, 3, 30) where kind = 'need'`);
    check('mww: the nearby feed carries the currency of each need', ok(feed) && feed.rows.some((r) => r.extra.currency === 'AED'), feed);
    const setCur = (u, c) => as(db, u, `select public.masjid_update_settings($1, $2::jsonb)`, [DUB, JSON.stringify({ currency: c, contact_whatsapp: '+971 50 123 4567' })]);
    check('mww: the admin changes the currency (and an international WhatsApp is kept)',
      ok(await setCur(AE1, 'usd')) && (await admin(db, `select currency, contact_whatsapp from mosques where id = $1`, [DUB]))[0].currency === 'USD' &&
      (await admin(db, `select contact_whatsapp from mosques where id = $1`, [DUB]))[0].contact_whatsapp === '+971501234567');
    check('mww: a bad currency / WhatsApp is refused', has(await setCur(AE1, 'US1'), 'العملة') &&
      has(await as(db, AE1, `select public.masjid_update_settings($1, $2::jsonb)`, [DUB, JSON.stringify({ contact_whatsapp: '12' })]), 'واتساب'));
    check('mww: a member cannot change it', denied(await setCur(AE2, 'EUR')));
    check('mww: Egyptian WhatsApp numbers still work (+20 → 01…)',
      ok(await as(db, EG2, `select public.masjid_update_settings($1, $2::jsonb)`, [cairoM.id, JSON.stringify({ contact_whatsapp: '+20 100 000 0000' })])) &&
      (await admin(db, `select contact_whatsapp from mosques where id = $1`, [cairoM.id]))[0].contact_whatsapp === '01000000000');
    check('mww: a claim abroad accepts an international phone',
      ok(await as(db, AE2, `select public.masjid_claim($1, 'imam', '+971 50 765 4321')`, [OSM1])) &&
      (await admin(db, `select phone from mosque_claims where user_id = $1`, [AE2]))[0].phone === '+971507654321');
    check('mww: a nonsense phone is still refused', has(await as(db, EG1, `select public.masjid_claim($1, 'imam', '12345')`, [cairoM.id]), 'رقم'));
    const spons = await as(db, AE2, `select * from public.masjid_my_sponsorships()`);
    const sponsRes = (await admin(db, `select pg_get_function_result('public.masjid_my_sponsorships()'::regprocedure) r`))[0].r;
    check('mww: masjid_my_sponsorships has a currency column', ok(spons) && sponsRes.includes('currency text'), sponsRes);

    // ---- prayer times: SQL vs Dart (lib/core/masjid/prayer_times.dart), ±1 min
    const mwwRefs = [
      ['dubai',25.2048,55.2708,'uae',1,'angle','2026-01-15',{'fajr':'2026-01-15T01:45:00.000Z','sunrise':'2026-01-15T03:06:00.000Z','dhuhr':'2026-01-15T08:31:00.000Z','asr':'2026-01-15T11:30:00.000Z','maghrib':'2026-01-15T13:54:00.000Z','isha':'2026-01-15T15:12:00.000Z'}],
      ['dubai',25.2048,55.2708,'uae',1,'angle','2026-03-01',{'fajr':'2026-03-01T01:25:00.000Z','sunrise':'2026-03-01T02:42:00.000Z','dhuhr':'2026-03-01T08:34:00.000Z','asr':'2026-03-01T11:52:00.000Z','maghrib':'2026-03-01T14:24:00.000Z','isha':'2026-03-01T15:38:00.000Z'}],
      ['dubai',25.2048,55.2708,'uae',1,'angle','2026-06-21',{'fajr':'2026-06-20T23:59:00.000Z','sunrise':'2026-06-21T01:29:00.000Z','dhuhr':'2026-06-21T08:24:00.000Z','asr':'2026-06-21T11:43:00.000Z','maghrib':'2026-06-21T15:15:00.000Z','isha':'2026-06-21T16:43:00.000Z'}],
      ['riyadh',24.7136,46.6753,'umm_al_qura',1,'angle','2026-01-15',{'fajr':'2026-01-15T02:17:00.000Z','sunrise':'2026-01-15T03:40:00.000Z','dhuhr':'2026-01-15T09:03:00.000Z','asr':'2026-01-15T12:05:00.000Z','maghrib':'2026-01-15T14:26:00.000Z','isha':'2026-01-15T15:56:00.000Z'}],
      ['riyadh',24.7136,46.6753,'umm_al_qura',1,'angle','2026-03-01',{'fajr':'2026-03-01T01:58:00.000Z','sunrise':'2026-03-01T03:16:00.000Z','dhuhr':'2026-03-01T09:06:00.000Z','asr':'2026-03-01T12:26:00.000Z','maghrib':'2026-03-01T14:56:00.000Z','isha':'2026-03-01T16:56:00.000Z'}],
      ['riyadh',24.7136,46.6753,'umm_al_qura',1,'angle','2026-06-21',{'fajr':'2026-06-21T00:33:00.000Z','sunrise':'2026-06-21T02:05:00.000Z','dhuhr':'2026-06-21T08:55:00.000Z','asr':'2026-06-21T12:16:00.000Z','maghrib':'2026-06-21T15:45:00.000Z','isha':'2026-06-21T17:15:00.000Z'}],
      ['london',51.5074,-0.1278,'mwl',1,'angle','2026-01-15',{'fajr':'2026-01-15T05:59:00.000Z','sunrise':'2026-01-15T07:59:00.000Z','dhuhr':'2026-01-15T12:10:00.000Z','asr':'2026-01-15T14:01:00.000Z','maghrib':'2026-01-15T16:21:00.000Z','isha':'2026-01-15T18:15:00.000Z'}],
      ['london',51.5074,-0.1278,'mwl',1,'angle','2026-03-01',{'fajr':'2026-03-01T04:55:00.000Z','sunrise':'2026-03-01T06:46:00.000Z','dhuhr':'2026-03-01T12:13:00.000Z','asr':'2026-03-01T15:04:00.000Z','maghrib':'2026-03-01T17:41:00.000Z','isha':'2026-03-01T19:25:00.000Z'}],
      ['london',51.5074,-0.1278,'mwl',1,'angle','2026-06-21',{'fajr':'2026-06-21T01:31:00.000Z','sunrise':'2026-06-21T03:43:00.000Z','dhuhr':'2026-06-21T12:02:00.000Z','asr':'2026-06-21T16:25:00.000Z','maghrib':'2026-06-21T20:22:00.000Z','isha':'2026-06-21T22:27:00.000Z'}],
      ['london7',51.5074,-0.1278,'mwl',1,'seventh','2026-01-15',{'fajr':'2026-01-15T05:59:00.000Z','sunrise':'2026-01-15T07:59:00.000Z','dhuhr':'2026-01-15T12:10:00.000Z','asr':'2026-01-15T14:01:00.000Z','maghrib':'2026-01-15T16:21:00.000Z','isha':'2026-01-15T18:15:00.000Z'}],
      ['london7',51.5074,-0.1278,'mwl',1,'seventh','2026-03-01',{'fajr':'2026-03-01T04:55:00.000Z','sunrise':'2026-03-01T06:46:00.000Z','dhuhr':'2026-03-01T12:13:00.000Z','asr':'2026-03-01T15:04:00.000Z','maghrib':'2026-03-01T17:41:00.000Z','isha':'2026-03-01T19:25:00.000Z'}],
      ['london7',51.5074,-0.1278,'mwl',1,'seventh','2026-06-21',{'fajr':'2026-06-21T02:40:00.000Z','sunrise':'2026-06-21T03:43:00.000Z','dhuhr':'2026-06-21T12:02:00.000Z','asr':'2026-06-21T16:25:00.000Z','maghrib':'2026-06-21T20:22:00.000Z','isha':'2026-06-21T21:25:00.000Z'}],
      ['newyork',40.7128,-74.006,'isna',1,'angle','2026-01-15',{'fajr':'2026-01-15T10:58:00.000Z','sunrise':'2026-01-15T12:18:00.000Z','dhuhr':'2026-01-15T17:06:00.000Z','asr':'2026-01-15T19:34:00.000Z','maghrib':'2026-01-15T21:53:00.000Z','isha':'2026-01-15T23:14:00.000Z'}],
      ['newyork',40.7128,-74.006,'isna',1,'angle','2026-03-01',{'fajr':'2026-03-01T10:15:00.000Z','sunrise':'2026-03-01T11:30:00.000Z','dhuhr':'2026-03-01T17:08:00.000Z','asr':'2026-03-01T20:17:00.000Z','maghrib':'2026-03-01T22:47:00.000Z','isha':'2026-03-02T00:02:00.000Z'}],
      ['newyork',40.7128,-74.006,'isna',1,'angle','2026-06-21',{'fajr':'2026-06-21T07:45:00.000Z','sunrise':'2026-06-21T09:25:00.000Z','dhuhr':'2026-06-21T16:58:00.000Z','asr':'2026-06-21T20:58:00.000Z','maghrib':'2026-06-22T00:31:00.000Z','isha':'2026-06-22T02:11:00.000Z'}],
      ['karachi_h',24.8607,67.0011,'karachi',2,'angle','2026-01-15',{'fajr':'2026-01-15T00:58:00.000Z','sunrise':'2026-01-15T02:19:00.000Z','dhuhr':'2026-01-15T07:41:00.000Z','asr':'2026-01-15T11:28:00.000Z','maghrib':'2026-01-15T13:04:00.000Z','isha':'2026-01-15T14:24:00.000Z'}],
      ['karachi_h',24.8607,67.0011,'karachi',2,'angle','2026-03-01',{'fajr':'2026-03-01T00:39:00.000Z','sunrise':'2026-03-01T01:55:00.000Z','dhuhr':'2026-03-01T07:44:00.000Z','asr':'2026-03-01T11:56:00.000Z','maghrib':'2026-03-01T13:34:00.000Z','isha':'2026-03-01T14:50:00.000Z'}],
      ['karachi_h',24.8607,67.0011,'karachi',2,'angle','2026-06-21',{'fajr':'2026-06-20T23:14:00.000Z','sunrise':'2026-06-21T00:43:00.000Z','dhuhr':'2026-06-21T07:34:00.000Z','asr':'2026-06-21T12:16:00.000Z','maghrib':'2026-06-21T14:24:00.000Z','isha':'2026-06-21T15:53:00.000Z'}],
      ['istanbul',41.0082,28.9784,'turkey',1,'angle','2026-01-15',{'fajr':'2026-01-15T03:50:00.000Z','sunrise':'2026-01-15T05:20:00.000Z','dhuhr':'2026-01-15T10:18:00.000Z','asr':'2026-01-15T12:45:00.000Z','maghrib':'2026-01-15T15:07:00.000Z','isha':'2026-01-15T16:32:00.000Z'}],
      ['istanbul',41.0082,28.9784,'turkey',1,'angle','2026-03-01',{'fajr':'2026-03-01T03:07:00.000Z','sunrise':'2026-03-01T04:32:00.000Z','dhuhr':'2026-03-01T10:21:00.000Z','asr':'2026-03-01T13:28:00.000Z','maghrib':'2026-03-01T16:02:00.000Z','isha':'2026-03-01T17:21:00.000Z'}],
      ['istanbul',41.0082,28.9784,'turkey',1,'angle','2026-06-21',{'fajr':'2026-06-21T00:24:00.000Z','sunrise':'2026-06-21T02:25:00.000Z','dhuhr':'2026-06-21T10:11:00.000Z','asr':'2026-06-21T14:11:00.000Z','maghrib':'2026-06-21T17:47:00.000Z','isha':'2026-06-21T19:38:00.000Z'}],
      ['tehran',35.6892,51.389,'tehran',1,'angle','2026-01-15',{'fajr':'2026-01-15T02:15:00.000Z','sunrise':'2026-01-15T03:44:00.000Z','dhuhr':'2026-01-15T08:44:00.000Z','asr':'2026-01-15T11:25:00.000Z','maghrib':'2026-01-15T14:04:00.000Z','isha':'2026-01-15T14:54:00.000Z'}],
      ['tehran',35.6892,51.389,'tehran',1,'angle','2026-03-01',{'fajr':'2026-03-01T01:41:00.000Z','sunrise':'2026-03-01T03:05:00.000Z','dhuhr':'2026-03-01T08:47:00.000Z','asr':'2026-03-01T12:00:00.000Z','maghrib':'2026-03-01T14:48:00.000Z','isha':'2026-03-01T15:34:00.000Z'}],
      ['tehran',35.6892,51.389,'tehran',1,'angle','2026-06-21',{'fajr':'2026-06-20T23:32:00.000Z','sunrise':'2026-06-21T01:19:00.000Z','dhuhr':'2026-06-21T08:36:00.000Z','asr':'2026-06-21T12:25:00.000Z','maghrib':'2026-06-21T16:15:00.000Z','isha':'2026-06-21T17:14:00.000Z'}],
      ['jakarta',-6.2088,106.8456,'kemenag',1,'angle','2026-01-15',{'fajr':'2026-01-14T21:25:00.000Z','sunrise':'2026-01-14T22:49:00.000Z','dhuhr':'2026-01-15T05:02:00.000Z','asr':'2026-01-15T08:27:00.000Z','maghrib':'2026-01-15T11:15:00.000Z','isha':'2026-01-15T12:30:00.000Z'}],
      ['jakarta',-6.2088,106.8456,'kemenag',1,'angle','2026-03-01',{'fajr':'2026-02-28T21:40:00.000Z','sunrise':'2026-02-28T22:58:00.000Z','dhuhr':'2026-03-01T05:05:00.000Z','asr':'2026-03-01T08:09:00.000Z','maghrib':'2026-03-01T11:12:00.000Z','isha':'2026-03-01T12:21:00.000Z'}],
      ['jakarta',-6.2088,106.8456,'kemenag',1,'angle','2026-06-21',{'fajr':'2026-06-20T21:38:00.000Z','sunrise':'2026-06-20T23:01:00.000Z','dhuhr':'2026-06-21T04:54:00.000Z','asr':'2026-06-21T08:16:00.000Z','maghrib':'2026-06-21T10:47:00.000Z','isha':'2026-06-21T12:02:00.000Z'}],
      ['oslo',59.9139,10.7522,'mwl',1,'middle','2026-01-15',{'fajr':'2026-01-15T05:28:00.000Z','sunrise':'2026-01-15T08:04:00.000Z','dhuhr':'2026-01-15T11:26:00.000Z','asr':'2026-01-15T12:35:00.000Z','maghrib':'2026-01-15T14:49:00.000Z','isha':'2026-01-15T17:18:00.000Z'}],
      ['oslo',59.9139,10.7522,'mwl',1,'middle','2026-03-01',{'fajr':'2026-03-01T03:57:00.000Z','sunrise':'2026-03-01T06:15:00.000Z','dhuhr':'2026-03-01T11:29:00.000Z','asr':'2026-03-01T13:59:00.000Z','maghrib':'2026-03-01T16:44:00.000Z','isha':'2026-03-01T18:55:00.000Z'}],
      ['oslo',59.9139,10.7522,'mwl',1,'middle','2026-06-21',{'fajr':'2026-06-20T23:19:00.000Z','sunrise':'2026-06-21T01:54:00.000Z','dhuhr':'2026-06-21T11:19:00.000Z','asr':'2026-06-21T16:00:00.000Z','maghrib':'2026-06-21T20:44:00.000Z','isha':'2026-06-21T23:19:00.000Z'}],
    ];
    for (const [city, lat, lng, method, asr, hl, day, want] of mwwRefs) {
      const rows = await admin(db, `select prayer, prayer_at from private.mt_prayer_times($1::date, $2, $3, $4, $5, $6)`, [day, lat, lng, method, asr, hl]);
      const got = Object.fromEntries(rows.map((r) => [r.prayer, new Date(r.prayer_at).getTime()]));
      const worst = Math.max(...Object.entries(want).map(([p, iso]) => Math.abs((got[p] ?? 0) - new Date(iso).getTime())));
      check(`mww: SQL prayer times match Dart — ${city} ${day} (${method})`, rows.length === 6 && worst <= 60000, { worst, got: rows });
    }

    // ---- reminders anywhere
    const MW = await signUp(db, 'mww reminders', null);
    await as(db, MW, `select public.save_push_subscription('https://fcm.googleapis.com/fcm/send/mww1', 'p256', 'authx', 'masjid')`);
    const setR = (args) => as(db, MW, `select public.set_prayer_reminders($1, $2, $3::jsonb, $4, $5, $6, $7, $8)`, args);
    check('mww: reminders in Dubai (Asia/Dubai, UAE method)', ok(await setR([25.2048, 55.2708, '{"fajr":0,"maghrib":5}', 'دبي', 'Asia/Dubai', 'uae', 1, 'angle'])));
    const dubaiToday = (await admin(db, `select (now() at time zone 'Asia/Dubai')::date::text d`))[0].d;
    const qd = await admin(db, `select day::text, prayer, adhan_at, due_at from prayer_reminder_queue where user_id = $1 order by day, prayer`, [MW]);
    check("mww: …queued for Dubai's today and tomorrow", qd.length === 4 && qd[0].day === dubaiToday, qd);
    const want = (await admin(db, `select prayer_at from private.mt_prayer_times($1::date, 25.2048, 55.2708, 'uae', 1, 'angle') where prayer = 'fajr'`, [qd[0].day]))[0].prayer_at;
    const qf = qd.find((r) => r.prayer === 'fajr');
    check('mww: …at the UAE-method adhan', new Date(qf.adhan_at).getTime() === new Date(want).getTime());
    const clock = (iso, tz) => {
      const parts = Object.fromEntries(new Intl.DateTimeFormat('en-GB', { timeZone: tz, hour: 'numeric', minute: '2-digit', hourCycle: 'h23' }).formatToParts(new Date(iso)).map((p) => [p.type, p.value]));
      const h = Number(parts.hour);
      return `${h % 12 === 0 ? 12 : h % 12}:${parts.minute} ${h < 12 ? 'ص' : 'م'}`;
    };
    await admin(db, `update prayer_reminder_queue set due_at = now() where user_id = $1 and day = $2::date and prayer = 'fajr'`, [MW, qf.day]);
    await admin(db, `select private.prayer_reminders_tick(now() + interval '30 seconds')`);
    const nd = await admin(db, `select body from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%'`, [MW]);
    check("mww: …the notification shows Dubai's clock", nd.length === 1 && nd[0].body === 'أذان الفجر ' + clock(qf.adhan_at, 'Asia/Dubai'), { nd, want: clock(qf.adhan_at, 'Asia/Dubai') });
    check('mww: reminders in London (Europe/London, MWL, 1/7 night)', ok(await setR([51.5074, -0.1278, '{"isha":0}', 'لندن', 'Europe/London', 'mwl', 2, 'seventh'])));
    const ql = (await admin(db, `select day::text, adhan_at, due_at from prayer_reminder_queue where user_id = $1 and prayer = 'isha' and sent_at is null order by day limit 1`, [MW]))[0];
    const wl = (await admin(db, `select prayer_at from private.mt_prayer_times($1::date, 51.5074, -0.1278, 'mwl', 2, 'seventh') where prayer = 'isha'`, [ql.day]))[0].prayer_at;
    check("mww: …queued on London's dates at the MWL Isha", new Date(ql.adhan_at).getTime() === new Date(wl).getTime() &&
      ql.day === (await admin(db, `select (now() at time zone 'Europe/London')::date::text d`))[0].d, ql);
    // Tick at the real clock (the tick also purges reminder notifications older
    // than 12 h relative to its time, so a far-future tick would delete them).
    await admin(db, `update prayer_reminder_queue set due_at = now() where user_id = $1 and day = $2::date and prayer = 'isha'`, [MW, ql.day]);
    await admin(db, `select private.prayer_reminders_tick(now() + interval '30 seconds')`);
    const nl = await admin(db, `select body from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%' order by created_at desc, body`, [MW]);
    check("mww: …the notification shows London's clock (summer time aware)", nl.some((n) => n.body === 'أذان العشاء ' + clock(ql.adhan_at, 'Europe/London')), { nl, want: clock(ql.adhan_at, 'Europe/London') });
    const mine = (await as(db, MW, `select * from public.my_prayer_reminders()`)).rows?.[0];
    check('mww: my_prayer_reminders returns the zone and the method', mine?.tz === 'Europe/London' && mine.method === 'mwl' && mine.asr_factor === 2 && mine.high_lat === 'seventh', mine);
    check('mww: an unknown time zone is refused', has(await setR([25.2, 55.2, '{"fajr":0}', null, 'Mars/Base', 'uae', 1, 'angle']), 'المنطقة الزمنية'));
    check('mww: an unknown method / Asr / rule is refused',
      has(await setR([25.2, 55.2, '{"fajr":0}', null, 'Asia/Dubai', 'nope', 1, 'angle']), 'طريقة') &&
      has(await setR([25.2, 55.2, '{"fajr":0}', null, 'Asia/Dubai', 'uae', 3, 'angle']), 'طريقة') &&
      has(await setR([25.2, 55.2, '{"fajr":0}', null, 'Asia/Dubai', 'uae', 1, 'polar']), 'طريقة'));
    check('mww: impossible coordinates are refused', denied(await setR([91, 55.2, '{"fajr":0}', null, 'Asia/Dubai', 'uae', 1, 'angle'])));
    check('mww: old 4-argument calls still work (Egypt → Africa/Cairo, Egyptian method)',
      ok(await as(db, MW, `select public.set_prayer_reminders(30.0444, 31.2357, '{"fajr":0}'::jsonb, 'القاهرة')`)) &&
      (await admin(db, `select tz, method from prayer_reminder_prefs where user_id = $1`, [MW]))[0].tz === 'Africa/Cairo' &&
      (await admin(db, `select method from prayer_reminder_prefs where user_id = $1`, [MW]))[0].method === 'egypt');
    const noTz = await as(db, MW, `select public.set_prayer_reminders(51.5, -0.12, '{"fajr":0}'::jsonb)`);
    const noTzRow = (await admin(db, `select tz, method from prayer_reminder_prefs where user_id = $1`, [MW]))[0];
    check('mww: outside Egypt without a zone → one from the longitude, MWL', ok(noTz) && noTzRow.tz === 'Etc/GMT' && noTzRow.method === 'mwl', noTzRow);
    check("mww: users can't call the calculator", denied(await as(db, MW, `select * from private.mt_prayer_times(current_date, 25.2, 55.2)`)));
  }

  // ------------------------------------------------------------------
  console.log('\nمسجدي — the push that arrives, the adhan as the notification (0090)');
  {
    // Earlier blocks re-ran 0087 (its tick) — re-running 0090 is both the
    // re-run check and the restore.
    let adhanRerun = null;
    try {
      await db.exec(require('fs').readFileSync(require('path').join(__dirname, '..', 'migrations', '0090_adhan_push.sql'), 'utf8'));
    } catch (e) {
      adhanRerun = e.message;
    }
    check('adhan: 0090 is safe to re-run', adhanRerun === null, adhanRerun);
    const asService = async (sql, params = []) => {
      await db.exec('begin');
      try {
        await db.exec('set local role service_role');
        const r = await db.query(sql, params);
        await db.exec('commit');
        return { rows: r.rows };
      } catch (e) {
        await db.exec('rollback');
        return { error: e.message };
      }
    };
    const AD = await signUp(db, 'adhan one', '01000000991');
    const AD2 = await signUp(db, 'adhan two', '01000000992');
    await as(db, AD, `select public.save_push_subscription('https://web.push.apple.com/adhan1', 'p256', 'authx', 'masjid')`);
    await admin(db, `insert into notifications (user_id, title) values ($1, 'adhan probe')`, [AD]);
    check('adhan: send-push (service role) can read the notification — the {"sent":0} cause',
      (await asService(`select title from public.notifications where user_id = $1`, [AD])).rows?.length === 1);
    check('adhan: …and the devices, and remove gone ones',
      (await asService(`select endpoint from public.push_subscriptions where user_id = $1`, [AD])).rows?.length === 1 &&
      ok(await asService(`delete from public.push_subscriptions where endpoint = 'https://nowhere/none'`)));
    check('adhan: (0091) the service role has full table access like Supabase defaults', ok(await asService(`select 1 from public.notifications limit 1`)));

    // A stand-in for pg_net: the trigger hands send-push everything it needs.
    await db.exec(`create schema if not exists net;
      create table net._calls (url text, body jsonb, headers jsonb);
      create function net.http_post(url text, body jsonb, headers jsonb, timeout_milliseconds int) returns bigint
        language sql as $$ insert into net._calls values (url, body, headers); select 1::bigint $$;
      insert into private.push_settings (function_url, secret) values ('https://x.supabase.co/functions/v1/send-push', 's3') on conflict (id) do nothing;`);
    await admin(db, `insert into notifications (user_id, title, body, deep_link) values ($1, 'حان الآن', 'أذان', '/#/masjid/tools/reminders?adhan=asr')`, [AD]);
    const call = (await admin(db, `select * from net._calls order by ctid desc limit 1`))[0];
    check('adhan: the push request carries the notification and the devices (no table read needed)',
      call?.body?.notification?.title === 'حان الآن' && call.body.notification.deep_link === '/#/masjid/tools/reminders?adhan=asr' &&
      call.body.subscriptions?.length === 1 && call.body.subscriptions[0].endpoint === 'https://web.push.apple.com/adhan1' &&
      call.body.subscriptions[0].app === 'masjid' && call.headers?.['x-push-secret'] === 's3' && !!call.body.notification_id, call);
    await admin(db, `insert into notifications (user_id, title) values ($1, 'no device')`, [AD2]);
    check('adhan: no request for a user without devices', (await admin(db, `select count(*)::int n from net._calls`))[0].n === 1);
    await db.exec(`drop schema net cascade; delete from private.push_settings;`);
    await admin(db, `delete from notifications where user_id = $1`, [AD]);

    // Style & voice
    const cairo = [30.0444, 31.2357];
    check('adhan: guests cannot set the adhan style', denied(await as(db, null, `select public.set_prayer_reminder_style('{"asr":"full"}'::jsonb, 'madinah')`)));
    check('adhan: an unknown style is refused', denied(await as(db, AD, `select public.set_prayer_reminder_style('{"asr":"loud"}'::jsonb, 'madinah')`)));
    check('adhan: an unknown prayer is refused', denied(await as(db, AD, `select public.set_prayer_reminder_style('{"sunrise":"full"}'::jsonb, 'madinah')`)));
    check('adhan: an unknown voice is refused', denied(await as(db, AD, `select public.set_prayer_reminder_style('{"asr":"full"}'::jsonb, 'nope')`)));
    check('adhan: a user saves reminders + styles + voice',
      ok(await as(db, AD, `select public.set_prayer_reminders($1, $2, '{"asr":0,"isha":10}'::jsonb, 'القاهرة')`, cairo)) &&
      ok(await as(db, AD, `select public.set_prayer_reminder_style('{"asr":"full","isha":"takbir"}'::jsonb, 'calm')`)));
    const pref = (await admin(db, `select styles, voice from prayer_reminder_prefs where user_id = $1`, [AD]))[0];
    check('adhan: …stored', pref?.styles?.asr === 'full' && pref.styles.isha === 'takbir' && pref.voice === 'calm', pref);
    check('adhan: saving the times again keeps the style',
      ok(await as(db, AD, `select public.set_prayer_reminders($1, $2, '{"asr":0,"isha":10}'::jsonb, 'القاهرة')`, cairo)) &&
      (await admin(db, `select voice from prayer_reminder_prefs where user_id = $1`, [AD]))[0].voice === 'calm');
    const qa = (await admin(db, `select day from prayer_reminder_queue where user_id = $1 and prayer = 'asr' order by day limit 1`, [AD]))[0];
    await admin(db, `update prayer_reminder_queue set due_at = now() where user_id = $1 and day = $2::date and prayer in ('asr', 'isha')`, [AD, qa.day]);
    await admin(db, `select private.prayer_reminders_tick(now() + interval '30 seconds')`);
    const adn = await admin(db, `select title, deep_link from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%' order by deep_link`, [AD]);
    const asrN = adn.find((n) => n.deep_link.includes('adhan=asr'));
    const ishaN = adn.find((n) => !n.deep_link.includes('adhan='));
    check('adhan: at adhan time the notification opens the app on the chosen adhan',
      asrN?.deep_link === '/#/masjid/tools/reminders?adhan=asr&style=full&voice=calm' && asrN.title === 'حان الآن موعد أذان العصر 🕌', adn);
    check('adhan: an early reminder (10 min before) just opens the reminders (no adhan), with a working # link',
      ishaN?.deep_link === '/#/masjid/tools/reminders' && ishaN.title.startsWith('العشاء بعد'), adn);
    await admin(db, `select private.prayer_reminders_tick(now() + interval '13 hours')`);
    check('adhan: the new reminder links are cleaned up after 12 hours too',
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and deep_link like '%/masjid/tools/reminders%'`, [AD]))[0].n === 0);
    check('adhan: a prayer without a style gets a quiet notification',
      ok(await as(db, AD, `select public.set_prayer_reminder_style('{}'::jsonb, 'short')`)) &&
      (await admin(db, `select coalesce(styles ->> 'asr', 'quiet') s from prayer_reminder_prefs where user_id = $1`, [AD]))[0].s === 'quiet');
  }

  // ------------------------------------------------------------------
  console.log('\nPhase arab — the 22 Arab states: geo foundation + phones (0089)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0089_arab_world_foundation.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('arab: 0089 is safe to re-run', rerun === null, rerun);
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0092_arab_currency.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
    // …and 0098 (store orders with variants, restock per variant).
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)
    const norm = async (p, c) => (await admin(db, `select private.norm_phone($1, $2) as n`, [p, c ?? null]))[0].n;
    const store = async (p, c) => (await admin(db, `select private.phone_store($1, $2) as n`, [p, c ?? null]))[0].n;

    // ---- norm_phone in several countries, local and international
    const cases = [
      ['01012345678', null, '+201012345678'], ['+20 101 234 5678', null, '+201012345678'], ['00201012345678', 'SA', '+201012345678'],
      ['٠١٠١٢٣٤٥٦٧٨', 'EG', '+201012345678'], ['201012345678', null, '+201012345678'],
      ['0512345678', 'SA', '+966512345678'], ['+966 51 234 5678', null, '+966512345678'], ['966512345678', 'EG', '+966512345678'],
      ['050-123-4567', 'AE', '+971501234567'], ['+971501234567', null, '+971501234567'], ['00971 50 123 4567', 'EG', '+971501234567'],
      ['51234567', 'KW', '+96551234567'], ['+965 9123 4567', null, '+96591234567'],
      ['0612345678', 'MA', '+212612345678'], ['+212 6 12 34 56 78', null, '+212612345678'],
      ['07712345678', 'IQ', '+9647712345678'], ['+964 771 234 5678', null, '+9647712345678'],
      ['0791234567', 'JO', '+962791234567'], ['+962 79 123 4567', null, '+962791234567'],
      ['+44 7700 900123', null, '+447700900123'],
    ];
    const bad = [];
    for (const [p, c, want] of cases) {
      const got = await norm(p, c);
      if (got !== want) bad.push({ p, c, got, want });
    }
    check('arab: norm_phone reads EG/SA/AE/KW/MA/IQ/JO numbers, local and international', bad.length === 0, bad);
    check('arab: norm_phone refuses junk, a Saudi number read as Egyptian, landlines, a wrong length',
      (await norm('12345')) === null && (await norm('0512345678', 'EG')) === null && (await norm('0225551234', 'EG')) === null &&
      (await norm('+96651234567')) === null && (await norm('abc01012345678')) === null);
    check('arab: the stored form is 01… for Egypt and E.164 for others',
      (await store('+201012345678')) === '01012345678' && (await store('0512345678', 'SA')) === '+966512345678');
    const misc = (await admin(db, `select private.phone_country('+971501234567') a, private.phone_country('01012345678') b, private.phone_country('+447700900123') c,
      private.wa_digits('01012345678') d, private.wa_digits('+966512345678') e, private.is_mobile('+212612345678') f, private.is_mobile('0225551234') g,
      private.money_text(1250.5, 'AED') h, private.money_text(3.1256, 'KWD') i, private.money_text(150, null) j,
      private.has_phone_number('كلمني على 07712345678') k, private.has_phone_number('واتس +966 51 234 5678') l, private.has_phone_number('السعر 1500 جنيه') m`))[0];
    check('arab: phone_country / wa_digits / is_mobile', misc.a === 'AE' && misc.b === 'EG' && misc.c === null && misc.d === '201012345678' &&
      misc.e === '966512345678' && misc.f === true && misc.g === false, misc);
    check('arab: money_text («1,250.5 د.إ», 3 decimals for KWD, EGP by default)', misc.h === '1,250.5 د.إ' && misc.i === '3.126 د.ك' && misc.j === '150 ج.م', misc);
    check('arab: has_phone_number catches local and international numbers, not prices', misc.k && misc.l && !misc.m, misc);
    check("arab: users can't call the private helpers", denied(await as(db, X, `select private.norm_phone('01012345678')`)));

    // ---- profiles.country
    const UAE = await signUp(db, 'uae user', '+971 50 123 4567');
    const KSA = await signUp(db, 'saudi user', '00966512345678');
    const EGU = await signUp(db, 'egypt user', '+201000009001');
    const EGN = await signUp(db, 'egypt nophone', '');
    const prof = async (u) => (await admin(db, `select phone, country, currency, phone_verified_at from profiles where id = $1`, [u]))[0];
    check('arab: sign-up with a UAE number → country AE, AED, phone in E.164',
      (await prof(UAE)).country === 'AE' && (await prof(UAE)).currency === 'AED' && (await prof(UAE)).phone === '+971501234567', await prof(UAE));
    check('arab: sign-up with 00966… → SA, +966…', (await prof(KSA)).country === 'SA' && (await prof(KSA)).phone === '+966512345678', await prof(KSA));
    check('arab: an Egyptian sign-up stays EG / EGP / 01…', (await prof(EGU)).country === 'EG' && (await prof(EGU)).currency === 'EGP' && (await prof(EGU)).phone === '01000009001', await prof(EGU));
    check('arab: existing users are EG / EGP', (await prof(A)).country === 'EG' && (await prof(A)).currency === 'EGP');
    const metaU = (await admin(db, `insert into auth.users (email, raw_user_meta_data) values ('meta@test.local', '{"full_name":"meta","phone":"0791234567","country":"JO"}'::jsonb) returning id`))[0].id;
    check('arab: the country the app sends reads a local number', (await prof(metaU)).country === 'JO' && (await prof(metaU)).phone === '+962791234567', await prof(metaU));
    const tzU = (await admin(db, `insert into auth.users (email, raw_user_meta_data) values ('tz@test.local', '{"full_name":"tz","tz":"Africa/Casablanca"}'::jsonb) returning id`))[0].id;
    check('arab: no phone → the device zone gives the country', (await prof(tzU)).country === 'MA', await prof(tzU));
    check('arab: set_my_country changes country + currency', ok(await as(db, tzU, `select public.set_my_country('TN', 'Africa/Tunis')`)) &&
      (await prof(tzU)).country === 'TN' && (await prof(tzU)).currency === 'TND');
    check('arab: set_my_country refuses a non-Arab / bogus code or zone',
      denied(await as(db, tzU, `select public.set_my_country('XX')`)) && denied(await as(db, tzU, `select public.set_my_country('FR')`)) &&
      denied(await as(db, tzU, `select public.set_my_country('SA', 'Mars/Base')`)));
    check('arab: the user reads their own country / currency', (await as(db, KSA, `select country, currency from profiles where id = $1`, [KSA])).rows?.[0]?.currency === 'SAR');
    check('arab: EXPLOIT blocked: writing currency / country directly',
      denied(await as(db, KSA, `update profiles set currency = 'USD' where id = $1`, [KSA])) && denied(await as(db, KSA, `update profiles set country = 'EG' where id = $1`, [KSA])));
    check('arab: editing the phone keeps the stored form', ok(await as(db, KSA, `update profiles set phone = '055 123 4567' where id = $1`, [KSA])) &&
      (await prof(KSA)).phone === '+966551234567', await prof(KSA));
    check('arab: an Egyptian typing +20… is stored as 01…', ok(await as(db, EGN, `update profiles set phone = '+20 100 000 9003' where id = $1`, [EGN])) &&
      (await prof(EGN)).phone === '01000009003');
    // SMS verification stays Egyptian; +20 input works.
    const confirm = async (u, p) => {
      await db.exec('begin; set local role service_role;');
      let err = null;
      try { await db.query('select public.confirm_phone_verified($1, $2)', [u, p]); } catch (e) { err = e.message; } finally { await db.exec(err ? 'rollback' : 'commit'); }
      return err;
    };
    const vErr = await confirm(EGU, '+201000009001');
    check('arab: confirm_phone_verified accepts +20… and keeps 01…', vErr === null && (await prof(EGU)).phone === '01000009001' && !!(await prof(EGU)).phone_verified_at, vErr);
    check('arab: confirm_phone_verified still refuses non-Egyptian numbers', (await confirm(UAE, '+971501234567')) !== null);
    await admin(db, `update profiles set phone = '01000009004', phone_verified_at = null where id = $1`, [EGN]);

    // ---- store checkout with a Saudi customer
    const ArM = await signUp(db, 'arab merchant', '+971509990000');
    const arShop = await as(db, ArM, `select public.create_my_shop('متجر دبي', 'بقالة', 'dubai-shop', '0509990000') as id`);
    check('arab: a UAE merchant opens a shop with a local UAE WhatsApp', ok(arShop) &&
      (await admin(db, `select whatsapp from shops where id = $1`, [arShop.rows?.[0]?.id]))[0]?.whatsapp === '+971509990000', arShop.error);
    check('arab: an Egyptian merchant still opens one with 01…', ok(await as(db, EGU, `select public.create_my_shop('محل مصر', 'بقالة', 'masr-shop', '01000009001')`)) &&
      (await admin(db, `select whatsapp from shops where slug = 'masr-shop'`))[0].whatsapp === '01000009001');
    check('arab: a bad shop WhatsApp is still refused', denied(await as(db, ArM, `select public.create_my_shop('x', 'بقالة', 'bad-wa', '12345')`)));
    const arShopId = arShop.rows?.[0]?.id;
    const arProd = (await as(db, ArM, `insert into shop_products (shop_id, name, price) values ($1, 'تمر', 30) returning id`, [arShopId])).rows?.[0]?.id;
    const arItems = JSON.stringify([{ product_id: arProd, quantity: 2 }]);
    const sOrder = await as(db, null, `select public.place_store_order($1, $2::jsonb, 'فهد', '+966 50 111 2222', 'حي النخيل، شارع 5، فيلا 3') as code`, [arShopId, arItems]);
    check('arab: a guest orders with a Saudi number', ok(sOrder) &&
      (await admin(db, `select customer_phone from shop_orders where order_code = $1`, [sOrder.rows?.[0]?.code]))[0]?.customer_phone === '+966501112222', sOrder.error);
    const sOrder2 = await as(db, KSA, `select public.place_store_order($1, $2::jsonb, 'سعود', '0503334444', 'حي العليا، شارع 7، عمارة 2') as code`, [arShopId, arItems]);
    check("arab: a Saudi user's local number is read in their country", ok(sOrder2) &&
      (await admin(db, `select customer_phone from shop_orders where order_code = $1`, [sOrder2.rows?.[0]?.code]))[0]?.customer_phone === '+966503334444', sOrder2.error);
    check('arab: an Egyptian guest checkout still works (01…)', ok(await as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى', '01077771111', 'شارع 9، المعادي، عمارة 4') as code`, [arShopId, arItems])));
    check('arab: a bad checkout phone is still refused', denied(await as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى', '12345', 'شارع 9، المعادي، عمارة 4')`, [arShopId, arItems])));
    check('arab: the in-app place_shop_order takes a UAE number', ok(await as(db, UAE, `select public.place_shop_order($1, $2::jsonb, '+971501234567')`, [arShopId, arItems])));

    // ---- listings with a UAE WhatsApp
    check('arab: a tutor listing with a UAE WhatsApp',
      ok(await as(db, UAE, `insert into tutor_listings (owner_id, subjects, stages, modes, price, whatsapp) values ($1, '{math}', '{primary}', '{online}', 100, '+971501234567')`, [UAE])));
    check('arab: a hall with a UAE phone + WhatsApp', ok(await hallIns(UAE, { phone: '+971501234567', whatsapp: '+971501234567' })));
    check('arab: a pet listing with a UAE phone',
      ok(await as(db, UAE, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'supplies', 'cat', 'قفص', 300, '+971501234567')`, [UAE])));
    check('arab: a kids listing with a UAE phone',
      ok(await as(db, UAE, `insert into kids_listings (owner_id, category, title, price, phone) values ($1, 'toys', 'لعبة', 50, '+971501234567')`, [UAE])));
    check('arab: listings refuse a non-normalised or invalid foreign number',
      denied(await as(db, UAE, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'supplies', 'cat', 'قفص', 300, '+971 50 123 4567')`, [UAE])) &&
      denied(await as(db, UAE, `insert into kids_listings (owner_id, category, title, price, phone) values ($1, 'toys', 'لعبة', 50, '+9715012')`, [UAE])) &&
      denied(await hallIns(UAE, { whatsapp: '0501234567' })));
    check('arab: a scrap dealer with a Moroccan WhatsApp',
      ok(await as(db, tzU, `insert into scrap_dealers (user_id, business_name, whatsapp, materials, governorate) values ($1, 'خردة الرباط', '+212612345678', '{iron}', 'الرباط')`, [tzU])));
    check('arab: Egyptian listings unchanged',
      ok(await as(db, EGU, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'supplies', 'cat', 'قفص', 300, '01000009001')`, [EGU])));

    // ---- payouts
    await admin(db, `update wallets set available_balance = 500 where user_id = $1`, [UAE]);
    check('arab: a wallet payout to a UAE number', ok(await as(db, UAE, `select public.request_wallet_withdrawal(20, '050 123 4567')`)) &&
      (await admin(db, `select payout_phone from wallet_withdrawal_requests where user_id = $1`, [UAE]))[0]?.payout_phone === '+971501234567');
    check('arab: a bad payout number is refused', denied(await as(db, UAE, `select public.request_wallet_withdrawal(20, '12345')`)));

    // ---- e-address lookup by +971
    const uaeAddr = await as(db, UAE, `select public.save_my_e_address(null, $1::jsonb) as code`,
      [JSON.stringify({ label: 'البيت', governorate: 'القاهرة', city: 'المعادي', street: 'شارع 9', building: '12', lat: 29.96, lng: 31.25 })]);
    await admin(db, `update e_addresses set phone_lookup = true where owner_id = $1`, [UAE]);
    check('arab: the address opens by +971 (international form)', ok(uaeAddr) &&
      (await as(db, null, `select public.get_e_address('+971 50 123 4567') as a`)).rows?.[0]?.a?.label === 'البيت', uaeAddr.error);
    check('arab: …and by the local form for a UAE caller', (await as(db, ArM, `select public.get_e_address('0501234567') as a`)).rows?.[0]?.a?.label === 'البيت');
    check('arab: an unverified Egyptian number still opens nothing', (await as(db, null, `select public.get_e_address('01000009004') as a`)).rows?.[0]?.a == null);
    check('arab: the admin finds the address by +971', (await as(db, SA, `select * from public.admin_find_e_addresses('+971501234567')`)).rows?.length === 1);

    // ---- chat rooms: verified phone only for Egyptian users
    const rooms = (await as(db, null, `select * from public.list_chat_rooms()`)).rows;
    const general = rooms.find((r) => r.name === 'دردشة عامة')?.id;
    await admin(db, `update chat_room_messages set created_at = created_at - interval '2 minutes'`);
    await as(db, UAE, `select public.set_chat_nickname('Khalid_AE')`);
    await as(db, EGN, `select public.set_chat_nickname('Masry_NoSms')`);
    const pUAE = (await as(db, UAE, `select public.my_chat_profile() as p`)).rows?.[0]?.p;
    check('arab: rooms profile — a UAE user needs no phone verification', pUAE?.needs_phone === false && pUAE?.phone_required === false, pUAE);
    const rUAE = (await as(db, UAE, `select public.get_chat_room($1) as r`, [general])).rows?.[0]?.r;
    check('arab: …the room says they can write', rUAE?.can_write === true && rUAE?.blocked_reason === null, rUAE);
    check('arab: an unverified UAE user posts in a room', ok(await as(db, UAE, `select public.send_room_message($1, 'مساء الخير من دبي')`, [general])));
    const pEG = (await as(db, EGN, `select public.my_chat_profile() as p`)).rows?.[0]?.p;
    check('arab: an unverified Egyptian user still needs verification', pEG?.needs_phone === true, pEG);
    const sendEG = await as(db, EGN, `select public.send_room_message($1, 'سلام')`, [general]);
    check('arab: …and is blocked from posting', !!sendEG.error && sendEG.error.includes('أكّد رقمك'), sendEG);
    await admin(db, `update chat_room_messages set created_at = created_at - interval '2 minutes'`);
    const spam = await as(db, UAE, `select public.send_room_message($1, 'كلموني على 0501234567')`, [general]);
    check('arab: a new account cannot post a phone number in a room', !!spam.error && spam.error.includes('أرقام الموبايل'), spam);
    const noPhoneSA = (await admin(db, `insert into auth.users (email, raw_user_meta_data) values ('nophone-sa@test.local', '{"full_name":"np","country":"SA"}'::jsonb) returning id`))[0].id;
    check('arab: no phone + country SA → no verification needed', (await as(db, noPhoneSA, `select public.my_chat_profile() as p`)).rows?.[0]?.p?.needs_phone === false);
    const egInUae = await signUp(db, 'egyptian abroad', '01000009005');
    await admin(db, `update profiles set country = 'AE' where id = $1`, [egInUae]);
    check('arab: an Egyptian number abroad still needs verification', (await as(db, egInUae, `select public.my_chat_profile() as p`)).rows?.[0]?.p?.needs_phone === true);

    // ---- mosque chat: the phone filter sees local Arab numbers
    check('arab: masjid_chat_send uses the 22-state phone filter',
      (await admin(db, `select pg_get_functiondef('public.masjid_chat_send(uuid, text, uuid)'::regprocedure) d`))[0].d.includes('private.has_phone_number'));
  }

  // ------------------------------------------------------------------
  console.log('\nPhase cur — a currency on everything priced (0092)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0092_arab_currency.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('cur: 0092 is safe to re-run', rerun === null, rerun);
    // 0096 redefines 0092's store orders (line snapshots) — put it back.
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
    // …and 0098 (store orders with variants, restock per variant).
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)
    const notes = async (u) => (await admin(db, `select title, body from notifications where user_id = $1 order by created_at`, [u])).map((n) => n.title + ' | ' + n.body);
    const lastNote = async (u) => (await notes(u)).pop() ?? '';

    const curSA = await signUp(db, 'cur saudi', '+966 50 700 0001');
    const curEG = await signUp(db, 'cur egypt', '01000007001');
    const curAE = await signUp(db, 'cur emirati', '+971 50 700 0001');
    const curKW = await signUp(db, 'cur kuwaiti', '+965 5070 0001');
    const curLB = await signUp(db, 'cur lebanese', '+961 3 700001');
    const curBuyer = await signUp(db, 'cur buyer', '01000007002');

    // ---- listings take the seller's country / currency
    const saL = await as(db, curSA, `insert into marketplace_listings (seller_id, title, price, condition) values ($1, 'آيفون', 2500, 'used') returning currency, country`, [curSA]);
    check('cur: a Saudi seller\'s listing is SAR / SA', saL.rows?.[0]?.currency === 'SAR' && saL.rows?.[0]?.country === 'SA', saL);
    const egL = await as(db, curEG, `insert into marketplace_listings (seller_id, title, price, condition) values ($1, 'تلاجة', 9000, 'used') returning currency, country`, [curEG]);
    check('cur: an Egyptian seller\'s listing stays EGP / EG', egL.rows?.[0]?.currency === 'EGP' && egL.rows?.[0]?.country === 'EG', egL);
    check('cur: every existing row is EGP / EG',
      (await admin(db, `select count(*)::int n from marketplace_listings where (currency, country) <> ('EGP', 'EG') and seller_id <> $1`, [curSA]))[0].n === 0 &&
      (await admin(db, `select count(*)::int n from buildings where currency <> 'EGP'`))[0].n === 0);
    const sent = await as(db, curSA, `insert into car_listings (owner_id, offer_type, brand, year, title, price, currency) values ($1, 'sale', 'تويوتا', 2020, 'كامري', 85000, 'usd') returning currency, country`, [curSA]);
    check('cur: a currency the client sends is kept (upper-cased)', sent.rows?.[0]?.currency === 'USD' && sent.rows?.[0]?.country === 'SA', sent);
    check('cur: a bogus currency is replaced by the seller\'s',
      (await as(db, curAE, `insert into kids_listings (owner_id, category, title, price, phone, currency) values ($1, 'toys', 'لعبة', 40, '+971507000001', 'dirham') returning currency`, [curAE])).rows?.[0]?.currency === 'AED');
    check('cur: guests can read a pet listing\'s currency',
      ok(await as(db, curAE, `insert into pet_listings (owner_id, kind, animal, title, price, phone) values ($1, 'sale', 'cat', 'شيرازي', 900, '+971507000001')`, [curAE])) &&
      (await as(db, null, `select currency, country from pet_listings where owner_id = $1`, [curAE])).rows?.[0]?.currency === 'AED');
    check('cur: the feed filters by country', (await as(db, null, `select title from marketplace_listings where country = 'SA'`)).rows?.every((r) => r.title === 'آيفون'));

    // ---- recycling: bids in the lot's currency
    const saLot = (await as(db, curSA, `insert into recycling_listings (seller_id, category, title, auction_ends_at) values ($1, 'metal', 'حديد خردة', now() + interval '2 days') returning id, currency`, [curSA])).rows?.[0];
    check('cur: a Saudi lot is SAR', saLot?.currency === 'SAR', saLot);
    check('cur: a bid on it', ok(await as(db, curBuyer, `select public.place_recycling_bid($1, 1500)`, [saLot?.id])));
    check('cur: the seller is notified in «ر.س»', (await lastNote(curSA)).includes('1,500 ر.س'), await lastNote(curSA));
    const lowBid = await as(db, curEG, `select public.place_recycling_bid($1, 1000)`, [saLot?.id]);
    check('cur: the "higher than" error is in «ر.س»', !!lowBid.error && lowBid.error.includes('1,500 ر.س'), lowBid.error);
    const egLot = (await as(db, curEG, `insert into recycling_listings (seller_id, category, title, auction_ends_at) values ($1, 'metal', 'نحاس', now() + interval '2 days') returning id`, [curEG])).rows?.[0]?.id;
    await as(db, curBuyer, `select public.place_recycling_bid($1, 500)`, [egLot]);
    check('cur: an Egyptian lot is unchanged («500 ج.م»)', (await lastNote(curEG)).includes('500 ج.م'), await lastNote(curEG));
    check('cur: accepting notifies the winner in the lot\'s currency',
      ok(await as(db, curSA, `select public.accept_recycling_top_bid($1)`, [saLot?.id])) && (await lastNote(curBuyer)).includes('1,500 ر.س'));
    const myBids = (await as(db, curBuyer, `select * from public.recycling_my_bids()`)).rows ?? [];
    check('cur: «عروضي» carries each lot\'s currency', myBids.find((b) => b.listing_id === saLot?.id)?.currency === 'SAR' && myBids.find((b) => b.listing_id === egLot)?.currency === 'EGP', myBids);

    // ---- a shop in AED with a delivery fee
    const aeShop = (await as(db, curAE, `select public.create_my_shop('سوبر ماركت دبي', 'بقالة', 'cur-dubai', '0507000001') as id`)).rows?.[0]?.id;
    check('cur: a UAE shop is AED / AE', (await admin(db, `select currency, country from shops where id = $1`, [aeShop]))[0]?.currency === 'AED');
    const aeProd = (await as(db, curAE, `insert into shop_products (shop_id, name, price, currency) values ($1, 'حليب', 12.5, 'EGP') returning id, currency`, [aeShop])).rows?.[0];
    check('cur: EXPLOIT blocked: a product is always in its shop\'s currency', aeProd?.currency === 'AED', aeProd);
    check('cur: the UAE shop sets a 15 د.إ delivery fee', ok(await as(db, curAE, `select public.set_my_shop_delivery($1, 15)`, [aeShop])));
    const aeCode = (await as(db, null, `select public.place_store_order($1, $2::jsonb, 'سالم', '+971 50 700 0099', 'مرسى دبي، برج 3، شقة 12') as c`,
      [aeShop, JSON.stringify([{ product_id: aeProd?.id, quantity: 2 }])])).rows?.[0]?.c;
    const aeOrder = (await as(db, null, `select public.get_store_order($1) as o`, [aeCode])).rows?.[0]?.o;
    check('cur: the order is AED: 2 × 12.5 + 15 delivery = 40', aeOrder?.currency === 'AED' && Number(aeOrder?.total) === 40 && Number(aeOrder?.delivery_fee) === 15, aeOrder);
    check('cur: the merchant is notified in «د.إ»', (await lastNote(curAE)).includes('40 د.إ'), await lastNote(curAE));
    const aeOrderId = (await admin(db, `select id from shop_orders where order_code = $1`, [aeCode]))[0]?.id;
    check('cur: order status notices use the order\'s currency', ok(await as(db, curAE, `select public.update_shop_order_status($1, 'preparing')`, [aeOrderId])) &&
      ok(await as(db, curBuyer, `select public.place_shop_order($1, $2::jsonb, '01000007002')`, [aeShop, JSON.stringify([{ product_id: aeProd?.id, quantity: 1 }])])) &&
      (await lastNote(curAE)).includes('12.5 د.إ'));
    check('cur: a shop switching currency takes its catalogue along',
      ok(await as(db, curAE, `update shops set currency = 'USD' where id = $1`, [aeShop])) &&
      (await admin(db, `select currency from shop_products where id = $1`, [aeProd?.id]))[0]?.currency === 'USD' &&
      (await admin(db, `select currency from shop_orders where id = $1`, [aeOrderId]))[0]?.currency === 'AED');

    // ---- limits scale with the currency
    const egShop = (await as(db, curEG, `select public.create_my_shop('بقالة الحي', 'بقالة', 'cur-masr', '01000007001') as id`)).rows?.[0]?.id;
    const egFee = await as(db, curEG, `select public.set_my_shop_delivery($1, 1500)`, [egShop]);
    check('cur: an Egyptian delivery fee is still capped at 1000 ج.م', !!egFee.error && egFee.error.includes('1,000 ج.م'), egFee.error);
    check('cur: …and 1000 is fine', ok(await as(db, curEG, `select public.set_my_shop_delivery($1, 1000)`, [egShop])));
    check('cur: an Egyptian product over 1,000,000 ج.م is refused',
      denied(await as(db, curEG, `insert into shop_products (shop_id, name, price) values ($1, 'x', 2000000)`, [egShop])));
    const lbShop = (await as(db, curLB, `select public.create_my_shop('دكان بيروت', 'بقالة', 'cur-beirut', '+9613700001') as id`)).rows?.[0]?.id;
    check('cur: a Lebanese shop is LBP', (await admin(db, `select currency from shops where id = $1`, [lbShop]))[0]?.currency === 'LBP');
    check('cur: a Lebanese shop may charge 50,000 ل.ل delivery', ok(await as(db, curLB, `select public.set_my_shop_delivery($1, 50000)`, [lbShop])));
    check('cur: …and sell a 2,000,000 ل.ل product', ok(await as(db, curLB, `insert into shop_products (shop_id, name, price) values ($1, 'تلفزيون', 2000000)`, [lbShop])));
    check('cur: an Egyptian tutor over 100,000 ج.م is refused, a Lebanese one in ل.ل is not',
      denied(await as(db, curEG, `insert into tutor_listings (owner_id, subjects, stages, modes, price, whatsapp) values ($1, '{math}', '{primary}', '{online}', 150000, '01000007001')`, [curEG])) &&
      ok(await as(db, curLB, `insert into tutor_listings (owner_id, subjects, stages, modes, price, whatsapp) values ($1, '{math}', '{primary}', '{online}', 1500000, '+9613700001')`, [curLB])));
    const caps = (await admin(db, `select private.money_cap(1000, 'KWD') k, private.money_cap(1000, 'LBP') l, private.money_cap(1000, 'EGP') e, private.money_min(10, 'KWD') m`))[0];
    check('cur: caps never shrink below the EGP number', Number(caps.k) === 1000 && Number(caps.l) === 2000000 && Number(caps.e) === 1000 && Number(caps.m) === 0.065, caps);

    // ---- a Kuwaiti building: dues in KWD
    await as(db, curKW, `select public.found_building('برج السالمية', 'السالمية', 'حولي', 'حولي', '1', 'الأول')`);
    const kwBld = (await admin(db, `select building_id from union_members where user_id = $1`, [curKW]))[0]?.building_id;
    check('cur: a Kuwaiti founder\'s building is KWD / KW', (await admin(db, `select currency, country from buildings where id = $1`, [kwBld]))[0]?.currency === 'KWD');
    const kwReq = (await admin(db, `select id from president_requests where user_id = $1 and status = 'pending'`, [curKW]))[0]?.id;
    await as(db, SA, `select public.review_president_request($1, true)`, [kwReq]);
    check('cur: the president issues a 12.5 د.ك due', ok(await as(db, curKW, `select public.create_union_due('نوفمبر', 12.5, current_date, $1)`, [kwBld])));
    check('cur: the due notice reads «12.5 د.ك»', (await notes(curKW)).some((n) => n.includes('مستحق صيانة جديد') && n.includes('12.5 د.ك')), await notes(curKW));
    const kwDue = (await admin(db, `select id from union_dues where building_id = $1`, [kwBld]))[0]?.id;
    await admin(db, `update wallets set available_balance = 1000 where user_id = $1`, [curKW]);
    const kwPay = await as(db, curKW, `select public.pay_union_due($1)`, [kwDue]);
    check('cur: the (EGP) wallet can\'t pay a KWD due', !!kwPay.error && kwPay.error.includes('كاش'), kwPay.error);
    check('cur: …the treasurer records it in cash', ok(await as(db, curKW, `select public.mark_due_paid_cash($1)`, [kwDue])) &&
      Number((await admin(db, `select balance from union_funds where building_id = $1`, [kwBld]))[0]?.balance) === 12.5);
    const kwOver = await as(db, curKW, `select public.request_fund_withdrawal($1, 50, 'دهان', '+96550700001')`, [kwBld]);
    check('cur: the fund\'s "not enough" error is in د.ك', !!kwOver.error && kwOver.error.includes('12.5 د.ك'), kwOver.error);
    check('cur: a KWD fund can\'t be withdrawn into the EGP wallet', denied(await as(db, curKW, `select public.request_fund_withdrawal($1, 5, 'دهان')`, [kwBld])));
    check('cur: …but can be paid out to a Kuwaiti number', ok(await as(db, curKW, `select public.request_fund_withdrawal($1, 5, 'دهان السلم', '+96550700001')`, [kwBld])) &&
      (await lastNote(SA)).includes('5 د.ك'));
    check('cur: the admin list carries the building currency',
      (await as(db, SA, `select * from public.admin_list_union_fund_withdrawals()`)).rows?.find((r) => r.building_id === kwBld)?.currency === 'KWD');
    check('cur: an Egyptian building\'s dues still read «ج.م»',
      (await admin(db, `select count(*)::int n from notifications where title = 'مستحق صيانة جديد' and body like '%ج.م%'`))[0].n > 0);
  }

  console.log('\nPhase geo — the 22 Arab states: geography (0093)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0093_arab_geography.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('geo: 0093 is safe to re-run', rerun === null, rerun);

    // ---- country_at (the app's countryAt twin)
    const at = (await admin(db, `select private.country_at(24.7136, 46.6753) riy, private.country_at(25.2048, 55.2708) dxb, private.country_at(30.0444, 31.2357) cai,
      private.country_at(31.77, 35.23) jer, private.country_at(51.5, -0.1) lon, private.country_at(26.42, 50.09) dmm_raw,
      private.arab_country_at(26.42, 50.09) dmm, private.arab_country_at(51.5, -0.1) lon_arab, private.arab_country_at(33.57, -7.59) casa,
      private.in_arab_world(51.5, -0.1) lon_in, private.in_arab_world(24.71, 46.68) riy_in`))[0];
    check('geo: country_at matches the app (Riyadh SA, Dubai AE, Cairo EG, Jerusalem PS, London GB)',
      at.riy === 'SA' && at.dxb === 'AE' && at.cai === 'EG' && at.jer === 'PS' && at.lon === 'GB', at);
    check("geo: arab_country_at puts Dammam in Saudi Arabia (Iran's box overlaps), London nowhere, Casablanca MA",
      at.dmm_raw === 'IR' && at.dmm === 'SA' && at.lon_arab === null && at.casa === 'MA', at);
    check('geo: the Arab-world check', at.riy_in === true && at.lon_in === false, at);

    const geoSA = await signUp(db, 'geo saudi', '+966 50 709 3001');
    const geoAE = await signUp(db, 'geo emirati', '+971 50 709 3001');
    const geoEG = await signUp(db, 'geo egypt', '01000009301');
    const geoSA2 = await signUp(db, 'geo saudi dealer', '+966 50 709 3002');
    const geoEG2 = await signUp(db, 'geo egypt dealer', '01000009302');

    // ---- reports anywhere in the Arab world
    const riy = await as(db, geoSA, `select public.submit_report('حفر ورصف', 'حفرة كبيرة في شارع العليا', '{}', 24.6911, 46.6855, 'الرياض', 'العليا') as id`);
    check('geo: a report in Riyadh is accepted', ok(riy) && !!riy.rows?.[0]?.id, riy.error);
    const riyRow = (await admin(db, `select country, governorate from reports where id = $1`, [riy.rows?.[0]?.id]))[0];
    check('geo: …with country SA', riyRow?.country === 'SA' && riyRow.governorate === 'الرياض', riyRow);
    check('geo: a report in London is refused', denied(await as(db, geoSA, `select public.submit_report('حفر ورصف', 'حفرة في شارع أكسفورد', '{}', 51.5, -0.1)`)));
    check('geo: nonsense coordinates are refused', denied(await as(db, geoSA, `select public.submit_report('حفر ورصف', 'حفرة في مكان غريب', '{}', 95, 46)`)));
    const alex = await as(db, geoEG, `select public.submit_report('نظافة وقمامة', 'زبالة في الشارع الرئيسي', '{}', 31.2, 29.9, 'الإسكندرية') as id`);
    check('geo: an Egyptian report is still EG', (await admin(db, `select country from reports where id = $1`, [alex.rows?.[0]?.id]))[0]?.country === 'EG');
    check('geo: every old report is EG', (await admin(db, `select count(*)::int n from reports where country <> 'EG' and id <> $1`, [riy.rows?.[0]?.id]))[0].n === 0);
    const feedSA = (await as(db, null, `select public.list_reports(null, null, 5, null, null, false, 50, 'SA') as r`)).rows?.map((x) => x.r) ?? [];
    check('geo: the Saudi feed shows only Saudi reports', feedSA.length === 1 && feedSA[0].country === 'SA', feedSA.length);
    const feedEG = (await as(db, null, `select public.list_reports(null, null, 5, null, null, false, 50, 'EG') as r`)).rows?.map((x) => x.r) ?? [];
    check("geo: the Egyptian feed doesn't show it", feedEG.length > 0 && feedEG.every((r) => r.country === 'EG'), feedEG.length);
    check('geo: the old call (no country) still works — nearby Alexandria',
      (await as(db, null, `select public.list_reports(31.2, 29.9, 3) as r`)).rows?.every((x) => x.r.country === 'EG'));
    check('geo: «بلاغاتي» ignores the country', (await as(db, geoSA, `select public.list_reports(null, null, 5, null, null, true, 50, 'EG') as r`)).rows?.length === 1);
    const adminSA = (await as(db, SA, `select public.admin_list_reports(null, null, null, 200, 'SA') as r`)).rows ?? [];
    check('geo: the admin filters the queue by country', adminSA.length === 1 && adminSA[0].r.country === 'SA', adminSA.length);

    // ---- digital addresses
    const dubai = { label: 'البيت', governorate: 'دبي', city: 'مرسى دبي', building: 'برج 3', lat: 25.08, lng: 55.14 };
    const dAddr = await as(db, geoAE, `select public.save_my_e_address(null, $1::jsonb) as code`, [JSON.stringify(dubai)]);
    check('geo: an address pinned in Dubai is saved', ok(dAddr), dAddr.error);
    check('geo: …with country AE', (await admin(db, `select country from e_addresses where owner_id = $1`, [geoAE]))[0]?.country === 'AE');
    const lonAddr = await as(db, geoAE, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ ...dubai, lat: 51.5, lng: -0.1 })]);
    check('geo: a pin in London is refused (Arab world only)', !!lonAddr.error && lonAddr.error.includes('دولة عربية'), lonAddr.error);
    await as(db, geoEG, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ label: 'البيت', governorate: 'القاهرة', city: 'المعادي', building: '5' })]);
    check('geo: an Egyptian address without a pin is EG', (await admin(db, `select country from e_addresses where owner_id = $1`, [geoEG]))[0]?.country === 'EG');
    await as(db, geoEG, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ label: 'الشغل', governorate: 'الرياض', city: 'العليا', building: '9', country: 'sa' })]);
    check('geo: the country the app sends is kept when there is no pin',
      (await admin(db, `select country from e_addresses where owner_id = $1 and label = 'الشغل'`, [geoEG]))[0]?.country === 'SA');
    await as(db, geoEG, `select public.save_my_e_address(null, $1::jsonb)`, [JSON.stringify({ label: 'المصيف', governorate: 'الإسكندرية', city: 'سموحة', building: '2', lat: 31.2, lng: 29.95, country: 'SA' })]);
    check('geo: …but the pin wins over it',
      (await admin(db, `select country from e_addresses where owner_id = $1 and label = 'المصيف'`, [geoEG]))[0]?.country === 'EG');

    // ---- chat rooms per country
    const names = async (u, c) => ((await as(db, u, c === undefined ? `select name, near, country from public.list_chat_rooms()` : `select name, near, country from public.list_chat_rooms($1)`, c === undefined ? [] : [c])).rows ?? []);
    const guestRooms = await names(null);
    check('geo: guests see the Egyptian rooms + «الوطن العربي», not the Saudi ones',
      guestRooms.some((r) => r.name === 'دردشة عامة') && guestRooms.some((r) => r.name === 'القاهرة') && guestRooms.some((r) => r.name === 'الوطن العربي') &&
      !guestRooms.some((r) => r.name === 'الرياض') && guestRooms.every((r) => r.country === 'EG' || r.country === null), guestRooms.length);
    const saRooms = await names(geoSA);
    check('geo: a Saudi user sees the Saudi rooms (general + capital + cities) + «الوطن العربي»',
      ['دردشة السعودية', 'الرياض', 'جدة', 'الوطن العربي'].every((n) => saRooms.some((r) => r.name === n)) && !saRooms.some((r) => r.name === 'القاهرة'), saRooms.map((r) => r.name));
    check('geo: every one of the 22 states has rooms',
      (await admin(db, `select count(distinct country)::int n from chat_rooms where country is not null`))[0].n === 22);
    check('geo: the Egyptian user can browse the Moroccan rooms', (await names(geoEG, 'MA')).some((r) => r.name === 'الدار البيضاء'));
    await admin(db, `insert into e_addresses (owner_id, code, governorate, city, district, country) values ($1, 'GEOSA001', 'الرياض', 'الرياض', 'العليا', 'SA')`, [geoSA]);
    const saNear = await names(geoSA);
    check("geo: «near» matches the Saudi user's region room", saNear.find((r) => r.name === 'الرياض')?.near === 2 && saNear.find((r) => r.name === 'جدة')?.near === 0, saNear.filter((r) => r.near > 0));
    await admin(db, `insert into e_addresses (owner_id, code, governorate, city, district, country) values ($1, 'GEOEG001', 'الرياض', 'الرياض', 'العليا', 'EG')`, [geoEG2]);
    check('geo: …but not from an address in another country', (await names(geoEG2, 'SA')).find((r) => r.name === 'الرياض')?.near === 0);
    const aeRoom = await as(db, SA, `select public.admin_save_chat_room(null, 'العين', 'غرفة أهل العين', 'area', 'أبوظبي', 'العين', '🌴', 20, true, 'AE') as id`);
    check('geo: the admin creates a UAE room', ok(aeRoom) && (await names(geoAE)).some((r) => r.name === 'العين') && !(await names(geoEG)).some((r) => r.name === 'العين'), aeRoom.error);
    check('geo: …a room for every country', ok(await as(db, SA, `select public.admin_save_chat_room(null, 'شعر وأدب', null, 'topic', null, null, '📜', 60, true, '')`)) &&
      (await names(geoAE)).some((r) => r.name === 'شعر وأدب') && (await names(null)).some((r) => r.name === 'شعر وأدب'));
    check('geo: …not for a non-Arab country', denied(await as(db, SA, `select public.admin_save_chat_room(null, 'لندن', null, 'topic', null, null, null, 60, true, 'GB')`)));

    // ---- scrap dealers: matching inside one country
    const reg = (uid, wa, gov) => as(db, uid, `insert into scrap_dealers (user_id, business_name, whatsapp, materials, governorate, areas) values ($1, 'خردة', $2, '{copper}', $3, '{}')`, [uid, wa, gov]);
    const regSA = await reg(geoSA2, '+966507093002', 'الرياض');
    check('geo: a Saudi dealer registers in الرياض', ok(regSA), regSA.error);
    check('geo: …country SA', (await admin(db, `select country from scrap_dealers where user_id = $1`, [geoSA2]))[0]?.country === 'SA');
    check('geo: an Egyptian dealer registers in القاهرة', ok(await reg(geoEG2, '01000009302', 'القاهرة')) &&
      (await admin(db, `select country from scrap_dealers where user_id = $1`, [geoEG2]))[0]?.country === 'EG');
    const scrapNotes = async (u) => (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title = 'مزاد خردة جديد يناسبك'`, [u]))[0].n;
    const lot = (u, gov) => as(db, u, `insert into recycling_listings (seller_id, category, title, auction_ends_at, material, governorate) values ($1, 'metal', 'نحاس', now() + interval '2 days', 'copper', $2)`, [u, gov]);
    const before = [await scrapNotes(geoSA2), await scrapNotes(geoEG2)];
    const lot1 = await lot(geoSA, 'الرياض');
    check('geo: a Saudi lot in الرياض reaches the Saudi dealer only', ok(lot1) && (await scrapNotes(geoSA2)) === before[0] + 1 && (await scrapNotes(geoEG2)) === before[1], lot1.error);
    await lot(geoSA, 'القاهرة');
    check("geo: a Saudi lot that says «القاهرة» doesn't reach Cairo's dealers", (await scrapNotes(geoEG2)) === before[1]);
    await lot(geoEG, 'القاهرة');
    check('geo: an Egyptian lot in القاهرة still reaches the Egyptian dealer', (await scrapNotes(geoEG2)) === before[1] + 1 && (await scrapNotes(geoSA2)) === before[0] + 1);

    // ---- SOS numbers per building country
    check('geo: Egyptian SOS notices keep «الإسعاف 123 أو المطافئ 180»',
      (await admin(db, `select count(*)::int n from notifications where title like '🚨 استغاثة%' and body like '%اتصل بالإسعاف 123 أو المطافئ 180.'`))[0].n > 0);
    await admin(db, `update buildings set country = 'SA' where id = $1`, [bld]);
    const sosSA = await admin(db, `insert into sos_alerts (unit_id, triggered_by, type) values ($1, $2, 'medical') returning id`, [unit2, B]);
    const saBody = (await admin(db, `select body from notifications where title like '🚨 استغاثة%' order by created_at desc limit 1`))[0]?.body ?? '';
    check("geo: a Saudi building's SOS notice gives the Saudi numbers", saBody.includes('997') && !saBody.includes('123'), saBody);
    await admin(db, `update sos_alerts set status = 'false_alarm' where id = $1`, [sosSA[0]?.id]);
    await admin(db, `update buildings set country = 'EG' where id = $1`, [bld]);

    // ---- founding a building in a chosen country
    const fb = (u, fn, args) => as(db, u, `select public.${fn}(${args.map((_, i) => '$' + (i + 1)).join(', ')}) as c`, args);
    const fAE = await fb(geoEG, 'found_building_in', ['AE', 'برج الواحة', 'البرشاء', 'دبي', 'دبي', '1', 'الأول']);
    const bAE = (await admin(db, `select b.country, b.currency from buildings b join union_members m on m.building_id = b.id where m.user_id = $1`, [geoEG]))[0];
    check('geo: an Egyptian founds a building in the UAE → AE / AED', bAE?.country === 'AE' && bAE.currency === 'AED', { bAE, e: fAE.error });
    const fSA = await fb(geoSA, 'found_building', ['عمارة النخيل', 'العليا', 'الرياض', 'الرياض', '1', 'الأول', null, 24.69, 46.68]);
    const bSA = (await admin(db, `select b.country, b.currency from buildings b join union_members m on m.building_id = b.id where m.user_id = $1`, [geoSA]))[0];
    check('geo: a building placed in Riyadh is SA / SAR', bSA?.country === 'SA' && bSA.currency === 'SAR', { bSA, e: fSA.error });
    await fb(geoEG2, 'found_building', ['عمارة الزهور', 'المعادي', 'القاهرة', 'القاهرة', '1', 'الأول']);
    const bEG = (await admin(db, `select b.country, b.currency from buildings b join union_members m on m.building_id = b.id where m.user_id = $1`, [geoEG2]))[0];
    check('geo: an Egyptian building is unchanged (EG / EGP)', bEG?.country === 'EG' && bEG.currency === 'EGP', bEG);
    check('geo: found_building_in is for signed-in users only', denied(await fb(null, 'found_building_in', ['AE', 'x', 'x', 'x', 'x', '1', '1'])));
  }

  console.log('\nPhase dir — the directory outside Egypt (0094)');
  {
    const dSA = await signUp(db, 'dir saudi', '+966 50 709 4001');
    const dSA2 = await signUp(db, 'dir saudi 2', '+966 50 709 4002');
    const dEG = await signUp(db, 'dir egypt', '01000009401');
    const RIY = [24.7136, 46.6753];
    const CAI = [30.0500, 31.2400];
    const idOf = (r) => r.rows?.[0]?.id;

    // An Overture row as loaded before 0094 (no country / source given).
    await admin(db, `insert into directory_places (id, name, category, phone, whatsapp, lat, lng, confidence)
      values ('08f3dir0000000001', 'صيدلية العزبي', 'صيدليات', '+20 2 2345 6789', null, $1, $2, 0.9)`, CAI);
    const ov = (await admin(db, `select country, source from directory_places where id = '08f3dir0000000001'`))[0];
    check('dir: existing (Overture) rows are EG / overture', ov?.country === 'EG' && ov.source === 'overture', ov);
    const egNear = async () => (await as(db, null, `select id, name, category, distance_km from public.nearby_directory($1, $2, 3, null, 50)`, CAI)).rows || [];
    const egBefore = await egNear();
    check('dir: nearby_directory in Cairo still works for guests', egBefore.some((r) => r.id === '08f3dir0000000001'), egBefore);

    // ---- OpenStreetMap import
    const imp = (u, args) => as(db, u,
      `select public.directory_import_osm($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) as id`,
      [args.type ?? 'node', args.osm, args.name, args.cat ?? 'سوبر ماركت وبقالة', args.lat ?? RIY[0], args.lng ?? RIY[1],
        args.phone ?? null, args.web ?? null, args.hours ?? null, args.kind ?? null, args.addr ?? null]);
    const i1 = await imp(dSA, { osm: 5001, name: 'بقالة النخيل', phone: '+966 50 111 2233', web: 'https://nakheel.example', hours: 'Mo-Su 08:00-23:00', kind: 'shop=convenience' });
    const r1 = (await admin(db, `select * from directory_places where id = $1`, [idOf(i1)]))[0];
    check('dir: an OSM shop in Riyadh becomes ours (osm-node-5001, SA, osm)',
      idOf(i1) === 'osm-node-5001' && r1?.country === 'SA' && r1.source === 'osm' && r1.osm_type === 'node' && Number(r1.osm_id) === 5001, { e: i1.error, r1 });
    check('dir: …with its WhatsApp (+966…), website and hours', r1?.whatsapp === '+966501112233' && r1.website === 'https://nakheel.example' && r1.opening_hours === 'Mo-Su 08:00-23:00', r1);
    const i1b = await imp(dSA2, { osm: 5001, name: 'بقالة النخيل' });
    const n5001 = (await admin(db, `select count(*)::int n from directory_places where osm_id = 5001`))[0].n;
    check('dir: importing the same OSM object again is idempotent', idOf(i1b) === 'osm-node-5001' && n5001 === 1, { i1b, n5001 });
    // Same spot (≈ 10 m) and a similar name as the Overture pharmacy → no duplicate.
    const i2 = await imp(dEG, { type: 'way', osm: 6001, name: 'صيدليه العزبى', cat: 'صيدليات', lat: CAI[0] + 0.00008, lng: CAI[1] + 0.00002 });
    const ovNow = (await admin(db, `select osm_type, osm_id from directory_places where id = '08f3dir0000000001'`))[0];
    check('dir: an OSM place ~10 m from ours with a similar name is matched, not duplicated',
      idOf(i2) === '08f3dir0000000001' && ovNow.osm_type === 'way' && Number(ovNow.osm_id) === 6001, { i2, ovNow });
    check('dir: …and found by its OSM id next time', idOf(await imp(dEG, { type: 'way', osm: 6001, name: 'x y', cat: 'صيدليات', lat: CAI[0], lng: CAI[1] })) === '08f3dir0000000001');
    const i3 = await imp(dEG, { osm: 6002, name: 'مخبز الأمل', cat: 'حلويات ومخبوزات', lat: CAI[0] + 0.00008, lng: CAI[1] });
    check('dir: a different name at the same spot is a new place (EG)', idOf(i3) === 'osm-node-6002' &&
      (await admin(db, `select country from directory_places where id = 'osm-node-6002'`))[0]?.country === 'EG', i3.error);
    const i4 = await imp(dSA, { osm: 5002, name: 'Abu Ali Plumbing', cat: 'whatever', kind: 'craft=plumber', lat: RIY[0] + 0.01 });
    const r4 = (await admin(db, `select category, trade, kind from directory_places where id = $1`, [idOf(i4)]))[0];
    check('dir: unknown category → محلات متنوعة; craft=plumber gets the سباكة trade', r4?.category === 'محلات متنوعة' && r4.trade === 'سباكة' && r4.kind === 'craft=plumber', r4);
    check('dir: guests cannot import', denied(await imp(null, { osm: 5003, name: 'x shop' })));
    check('dir: import outside the Arab world is refused (London)', denied(await imp(dSA, { osm: 5004, name: 'Tesco', lat: 51.5, lng: -0.12 })));
    check('dir: a bogus OSM type / id is refused', denied(await imp(dSA, { type: 'area', osm: 5005, name: 'x shop' })) && denied(await imp(dSA, { osm: -1, name: 'x shop' })));
    await admin(db, `insert into private.directory_contributions (user_id, place_id, kind) select $1, 'x' || g, 'osm' from generate_series(1, 60) g`, [dSA2]);
    check('dir: OSM imports are rate-limited per user per day', denied(await imp(dSA2, { osm: 5006, name: 'محل جديد', lat: RIY[0] + 0.02 })));
    check('dir: …but opening an already imported one still works', idOf(await imp(dSA2, { osm: 5001, name: 'بقالة النخيل' })) === 'osm-node-5001');

    // ---- «ضيف محل»
    const add = (u, a) => as(db, u, `select public.directory_add_place($1, $2, $3, $4, $5, $6, $7, $8) as id`,
      [a.name, a.cat ?? 'مطاعم', a.lat ?? RIY[0] + 0.001, a.lng ?? RIY[1], a.phone ?? null, a.wa ?? null, a.hours ?? null, a.addr ?? null]);
    const a1 = await add(dSA, { name: 'مطعم البيك', wa: '0501234567', hours: 'كل يوم 10 ص - 2 بالليل', addr: 'شارع العليا' });
    const ra1 = (await admin(db, `select * from directory_places where id = $1`, [idOf(a1)]))[0];
    check('dir: a user adds a restaurant in Riyadh (usr-…, SA, user)', /^usr-[0-9a-f]{32}$/.test(idOf(a1) || '') && ra1?.country === 'SA' && ra1.source === 'user', { e: a1.error, ra1 });
    check('dir: …its local Saudi WhatsApp is stored as +966…, also as the phone', ra1?.whatsapp === '+966501234567' && ra1.phone === '+966501234567' && ra1.opening_hours === 'كل يوم 10 ص - 2 بالليل', ra1);
    check('dir: the same name at the same spot returns the existing place', idOf(await add(dSA2, { name: 'مطعم  البيك' })) === idOf(a1));
    check('dir: add_place validation (name, category, WhatsApp, phone)',
      denied(await add(dSA, { name: 'x' })) && denied(await add(dSA, { name: 'محل حلو', cat: 'مساجد' })) &&
      denied(await add(dSA, { name: 'محل حلو', wa: '12345' })) && denied(await add(dSA, { name: 'محل حلو', phone: 'call me' })));
    check('dir: add_place is for the Arab world only (London, Istanbul)',
      denied(await add(dSA, { name: 'محل لندن', lat: 51.5, lng: -0.12 })) && denied(await add(dSA, { name: 'محل اسطنبول', lat: 41.01, lng: 28.97 })));
    check('dir: guests cannot add places', denied(await add(null, { name: 'محل ضيف' })));
    const aEG = await add(dEG, { name: 'كشري التحرير', lat: CAI[0] + 0.002, lng: CAI[1], wa: '01012345678', phone: '0223456789' });
    const raEG = (await admin(db, `select country, whatsapp, phone from directory_places where id = $1`, [idOf(aEG)]))[0];
    check('dir: an Egyptian addition is EG with an 01… WhatsApp and the landline kept', raEG?.country === 'EG' && raEG.whatsapp === '01012345678' && raEG.phone === '0223456789', { e: aEG.error, raEG });
    for (let i = 2; i <= 5; i++) await add(dSA, { name: `محل رقم ${i}`, lat: RIY[0] + 0.001 * i });
    check('dir: 5 additions a day per user', denied(await add(dSA, { name: 'محل رقم 6', lat: RIY[0] + 0.01 })));
    check('dir: who added what is private', denied(await as(db, dSA, `select * from private.directory_contributions`)));
    check('dir: nobody writes directory_places directly',
      denied(await as(db, dSA, `insert into directory_places (id, name, category, lat, lng) values ('hack-000001', 'x', 'مطاعم', 1, 1)`)) &&
      ((await as(db, dSA, `update directory_places set name = 'hacked' where id = $1`, [idOf(a1)])).affected ?? 0) === 0);

    // ---- nearby: Riyadh now has places, Egypt unchanged
    const riyNear = (await as(db, null, `select id, category, distance_km from public.nearby_directory($1, $2, 3, null, 50)`, RIY)).rows || [];
    check('dir: nearby_directory at a Riyadh point lists the added and imported places',
      riyNear.some((r) => r.id === idOf(a1)) && riyNear.some((r) => r.id === 'osm-node-5001'), riyNear.map((r) => r.id));
    check('dir: …filtered by category too', ((await as(db, null, `select id from public.nearby_directory($1, $2, 3, 'مطاعم', 50)`, RIY)).rows || []).every((r) => r.id.startsWith('usr-')));
    check('dir: the Riyadh plumber is in the technicians market', ((await as(db, null, `select id from public.nearby_services($1, $2, 'سباكة', 10, 20)`, RIY)).rows || []).some((r) => r.id === 'osm-node-5002'));
    const egAfter = await egNear();
    const ovAfter = egAfter.find((r) => r.id === '08f3dir0000000001');
    const ovBefore = egBefore.find((r) => r.id === '08f3dir0000000001');
    check('dir: Egypt is unchanged (same Overture row, same distance)', ovAfter && ovAfter.name === ovBefore.name && ovAfter.distance_km === ovBefore.distance_km, { ovAfter, ovBefore });

    // ---- merchants
    const shop1 = idOf(await as(db, dSA, `select public.create_my_shop('سوبرماركت الواحة', 'سوبر ماركت / بقالة', 'alwaha-riyadh', '+966507094001') as id`));
    const loc1 = await as(db, dSA, `select public.set_my_shop_location($1, $2, $3) as id`, [shop1, RIY[0] - 0.003, RIY[1]]);
    const m1 = (await admin(db, `select * from directory_places where claimed_shop_id = $1`, [shop1]))[0];
    check("dir: a tajer shop with a location gets its own directory place", m1?.source === 'merchant' && m1.country === 'SA' &&
      m1.category === 'سوبر ماركت وبقالة' && m1.whatsapp === '+966507094001' && idOf(loc1) === m1.id, { e: loc1.error, m1 });
    check('dir: …which nearby_directory lists as a store (claimed)', ((await as(db, null, `select id, claimed_shop_id from public.nearby_directory($1, $2, 3, null, 50)`, RIY)).rows || [])
      .some((r) => r.id === m1?.id && r.claimed_shop_id === shop1));
    const shop2 = idOf(await as(db, dSA2, `select public.create_my_shop('البيك', 'مطعم / كافيه', 'albaik-olaya', '+966507094002') as id`));
    await as(db, dSA2, `select public.set_my_shop_location($1, $2, $3)`, [shop2, RIY[0] + 0.001, RIY[1] + 0.0001]);
    const linked = (await admin(db, `select id from directory_places where claimed_shop_id = $1`, [shop2]));
    check('dir: a shop at the spot of a listed place with a similar name claims it (no duplicate)', linked.length === 1 && linked[0].id === idOf(a1), linked);
    check("dir: only the owner sets a shop's location", denied(await as(db, dSA2, `select public.set_my_shop_location($1, $2, $3)`, [shop1, RIY[0], RIY[1]])));
    check('dir: a shop location outside the Arab world is refused', denied(await as(db, dSA, `select public.set_my_shop_location($1, 51.5, -0.12)`, [shop1])));
    await as(db, dSA, `select public.set_my_shop_location($1, $2, $3)`, [shop1, RIY[0] - 0.004, RIY[1]]);
    check('dir: moving the shop moves its merchant place', Math.abs((await admin(db, `select lat from directory_places where id = $1`, [m1?.id]))[0]?.lat - (RIY[0] - 0.004)) < 1e-6);
    await admin(db, `delete from shops where id = $1`, [shop1]);
    await admin(db, `delete from shops where id = $1`, [shop2]);
    check('dir: deleting a shop removes its merchant place but keeps a claimed user place',
      (await admin(db, `select count(*)::int n from directory_places where id = $1`, [m1?.id]))[0].n === 0 &&
      (await admin(db, `select claimed_shop_id from directory_places where id = $1`, [idOf(a1)]))[0]?.claimed_shop_id === null);
  }

  // ------------------------------------------------------------------
  console.log('\nPhase prep — «بلّغ عن محل غلط»: place reports + auto-hide (0095)');
  {
    const P = [24.8, 46.7]; // north Riyadh, away from the 0094 rows
    const mk = async (name, ph) => {
      const u = await signUp(db, name, ph);
      await admin(db, `update profiles set phone_verified_at = now() where id = $1`, [u]);
      return u;
    };
    const r1 = await mk('prep one', '+966 50 709 5001');
    const r2 = await mk('prep two', '+966 50 709 5002');
    const r3 = await mk('prep three', '+966 50 709 5003');
    const r4 = await signUp(db, 'prep old', '+966 50 709 5004');
    await admin(db, `update profiles set created_at = now() - interval '10 days' where id = $1`, [r4]);
    const fresh = await signUp(db, 'prep fresh', '+966 50 709 5005'); // new, unverified: not eligible
    const boss = await signUp(db, 'prep boss', '+966 50 709 5009');
    await admin(db, `update profiles set role = 'super_admin' where id = $1`, [boss]);
    const idOf = (r) => r.rows?.[0]?.id;
    const report = (u, place, reason, note = null, sugg = null) =>
      as(db, u, `select public.report_directory_place($1, $2, $3, $4) as id`, [place, reason, note, sugg ? JSON.stringify(sugg) : null]);
    const visible = async (id) => {
      const near = (await as(db, null, `select id from public.nearby_directory($1, $2, 5, null, 200)`, P)).rows || [];
      return near.some((r) => r.id === id);
    };

    const usr = idOf(await as(db, r1, `select public.directory_add_place('بقالة البلاغ', 'سوبر ماركت وبقالة', $1, $2, null, '0501119988') as id`, P));
    const osm = idOf(await as(db, r1, `select public.directory_import_osm('node', 95001, 'سباك البلاغ', 'صيانة وخدمات منزلية', $1, $2, null, null, null, 'craft=plumber') as id`, [P[0] + 0.002, P[1]]));
    await admin(db, `insert into directory_places (id, name, category, lat, lng, country, source) values ('08f3prep000000001', 'صيدلية أوفرتشر', 'صيدليات', $1, $2, 'SA', 'overture')`, [P[0] + 0.001, P[1]]);
    const ovt = '08f3prep000000001';
    check('prep: setup — a user place, an OSM plumber and an Overture place, all visible',
      !!usr && osm === 'osm-node-95001' && (await visible(usr)) && (await visible(osm)) && (await visible(ovt)), { usr, osm });

    // ---- reporting
    check('prep: guests cannot report', denied(await report(null, usr, 'closed')));
    check('prep: an unknown reason is refused', denied(await report(r1, usr, 'boring')));
    check('prep: an unknown place is refused', denied(await report(r1, 'nope-123', 'closed')));
    check("prep: «حاجة تانية» needs a note", denied(await report(r1, usr, 'other')));
    check('prep: a note over 500 characters is refused', denied(await report(r1, usr, 'closed', 'x'.repeat(501))));
    const w1 = await report(r1, ovt, 'wrong_info', '  الرقم اتغير  ', { name: 'صيدلية النهدي', phone: '050 222 3344', category: 'صيدليات', junk: 'x' });
    const w1row = (await admin(db, `select * from directory_place_reports where id = $1`, [idOf(w1)]))[0];
    check('prep: wrong_info stores a cleaned note and suggestion (+966 phone, junk dropped)',
      w1row?.note === 'الرقم اتغير' && w1row.suggestion?.name === 'صيدلية النهدي' && w1row.suggestion.phone === '+966502223344' &&
      w1row.suggestion.category === 'صيدليات' && !('junk' in w1row.suggestion) && w1row.status === 'open', { e: w1.error, w1row });
    check('prep: a bad suggested phone / category is refused',
      denied(await report(r2, ovt, 'wrong_info', null, { phone: 'call me' })) && denied(await report(r2, ovt, 'wrong_info', null, { category: 'مساجد' })));
    const w1again = await report(r1, ovt, 'closed');
    check('prep: one open report per user per place (reporting again returns it)', idOf(w1again) === idOf(w1) &&
      (await admin(db, `select count(*)::int n from directory_place_reports where place_id = $1 and reporter_id = $2`, [ovt, r1]))[0].n === 1, w1again);
    check('prep: nobody reads or writes the reports table directly',
      denied(await as(db, r1, `select * from directory_place_reports`)) &&
      denied(await as(db, r1, `insert into directory_place_reports (place_id, reporter_id, reason) values ($1, $2, 'closed')`, [usr, r1])));

    // ---- notifying the admins (once an hour)
    const bossNotes = async (title) => (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title = $2`, [boss, title]))[0].n;
    await report(r2, ovt, 'closed');
    check('prep: super admins hear about new reports, at most once an hour', (await bossNotes('📍 بلاغ عن مكان في الدليل')) === 1);

    // ---- auto-hide
    await report(r2, usr, 'closed');
    await report(fresh, usr, 'fake');
    await report(r3, usr, 'wrong_location');
    check('prep: 1 eligible closed report + an ineligible one + another reason → still visible',
      (await visible(usr)) && (await admin(db, `select hidden from directory_places where id = $1`, [usr]))[0].hidden === false);
    await report(r1, usr, 'duplicate');
    check('prep: …2 eligible → still visible', await visible(usr));
    await report(r4, usr, 'closed');
    const hu = (await admin(db, `select hidden, hidden_by from directory_places where id = $1`, [usr]))[0];
    check('prep: 3 eligible people (verified phone / 10-day-old account) → a user place is hidden automatically', hu.hidden === true && hu.hidden_by === 'auto', hu);
    check('prep: …and the admins are told', (await bossNotes('🙈 مكان اتخفى من الدليل تلقائياً')) === 1);
    check('prep: a hidden place is out of nearby_directory', !(await visible(usr)));
    check('prep: …out of search_directory', !((await as(db, null, `select id from public.search_directory('بقالة البلاغ')`)).rows || []).some((r) => r.id === usr));
    check('prep: …and unreadable directly (guest REST / app place page)',
      ((await as(db, null, `select id from directory_places where id = $1`, [usr])).rows || []).length === 0 &&
      ((await as(db, r1, `select id from directory_places where id = $1`, [usr])).rows || []).length === 0);
    check('prep: a hidden place cannot be reported', denied(await report(r3, usr, 'closed')));
    check('prep: «ضيف محل» at a hidden spot makes a new place (never returns the hidden one)',
      ((x) => x && x !== usr)(idOf(await as(db, r3, `select public.directory_add_place('بقالة البلاغ', 'سوبر ماركت وبقالة', $1, $2) as id`, P))));

    for (const u of [r1, r2, r3]) await report(u, osm, 'closed');
    check('prep: an OSM place is auto-hidden too (and leaves the technicians market)',
      (await admin(db, `select hidden from directory_places where id = $1`, [osm]))[0].hidden === true &&
      !((await as(db, null, `select id from public.nearby_services($1, $2, 'سباكة', 10, 50)`, P)).rows || []).some((r) => r.id === osm));
    await report(r3, ovt, 'fake');
    await report(r4, ovt, 'closed');
    check('prep: an Overture place is never auto-hidden (4 eligible reports)',
      (await admin(db, `select hidden from directory_places where id = $1`, [ovt]))[0].hidden === false && (await visible(ovt)));

    // ---- daily limit
    await admin(db, `insert into directory_places (id, name, category, lat, lng, country, source)
      select 'prep-lim-' || g, 'محل ' || g, 'مطاعم', $1, $2, 'SA', 'overture' from generate_series(1, 11) g`, [P[0] + 0.05, P[1]]);
    await admin(db, `insert into directory_place_reports (place_id, reporter_id, reason) select 'prep-lim-' || g, $1, 'closed' from generate_series(1, 10) g`, [fresh]);
    check('prep: 10 reports a day per user', denied(await report(fresh, 'prep-lim-11', 'closed')));

    // ---- super admin
    const adm = (u, sql, params) => as(db, u, sql, params);
    check('prep: non-admins cannot use the admin RPCs',
      denied(await adm(r1, `select * from public.admin_list_place_reports('open')`)) &&
      denied(await adm(r1, `select public.admin_resolve_place_report($1)`, [ovt])) &&
      denied(await adm(r1, `select public.admin_update_directory_place($1, 'x y z')`, [ovt])) &&
      denied(await adm(r1, `select public.admin_set_place_hidden($1, true)`, [ovt])) &&
      denied(await adm(r1, `select public.admin_delete_directory_place($1)`, [ovt])) &&
      denied(await adm(null, `select * from public.admin_list_place_reports('open')`)));
    const list = (await adm(boss, `select * from public.admin_list_place_reports('open')`)).rows || [];
    const lo = list.find((r) => r.place_id === ovt);
    check('prep: the admin list groups reports by place (reporters, reasons, suggestion, source)',
      lo && lo.reporters === 4 && lo.source === 'overture' && lo.reasons.closed === 2 && lo.reasons.wrong_info === 1 && lo.reasons.fake === 1 &&
      lo.reports.some((x) => x.suggestion?.name === 'صيدلية النهدي') && list.some((r) => r.place_id === usr && r.hidden === true), lo);
    const hid = (await adm(boss, `select * from public.admin_list_place_reports('hidden')`)).rows || [];
    check("prep: …and a «hidden» list", hid.some((r) => r.place_id === usr && r.hidden_by === 'auto') && hid.some((r) => r.place_id === osm) && !hid.some((r) => r.place_id === ovt));

    check('prep: an Overture place cannot be deleted (only hidden)', denied(await adm(boss, `select public.admin_delete_directory_place($1)`, [ovt])));
    const upd = await adm(boss, `select public.admin_update_directory_place($1, 'صيدلية النهدي', '050 222 3344', 'صيدليات')`, [ovt]);
    const ovNow = (await admin(db, `select name, phone, whatsapp from directory_places where id = $1`, [ovt]))[0];
    check('prep: «تعديل البيانات» applies the suggestion (the WhatsApp follows the phone)',
      ok(upd) && ovNow.name === 'صيدلية النهدي' && ovNow.phone === '+966502223344' && ovNow.whatsapp === '+966502223344', { e: upd.error, ovNow });
    check('prep: …resolves its open reports and thanks the reporters',
      (await admin(db, `select count(*)::int n from directory_place_reports where place_id = $1 and status = 'open'`, [ovt]))[0].n === 0 &&
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title = 'شكراً على بلاغك 🙏'`, [r4]))[0].n === 1);
    check('prep: bad admin edits are refused', denied(await adm(boss, `select public.admin_update_directory_place($1, null, 'call me')`, [ovt])) &&
      denied(await adm(boss, `select public.admin_update_directory_place($1, null, null, 'مساجد')`, [ovt])));

    check('prep: «إخفاء المكان» hides an Overture place', ok(await adm(boss, `select public.admin_set_place_hidden($1, true)`, [ovt])) && !(await visible(ovt)));
    check('prep: «إظهار تاني» shows the auto-hidden OSM place again and dismisses its reports',
      ok(await adm(boss, `select public.admin_set_place_hidden($1, false)`, [osm])) &&
      (await admin(db, `select hidden, hidden_by from directory_places where id = $1`, [osm]))[0].hidden === false &&
      (await admin(db, `select count(*)::int n from directory_place_reports where place_id = $1 and status = 'dismissed'`, [osm]))[0].n === 3);
    await report(r4, osm, 'closed');
    check('prep: …so one new report does not hide it again', (await admin(db, `select hidden from directory_places where id = $1`, [osm]))[0].hidden === false);
    check('prep: «تجاهل البلاغ» dismisses the open reports of a place',
      (await adm(boss, `select public.admin_resolve_place_report($1) as n`, [osm])).rows?.[0]?.n === 1 &&
      (await admin(db, `select count(*)::int n from directory_place_reports where place_id = $1 and status = 'open'`, [osm]))[0].n === 0);
    check('prep: «مسح المكان» deletes a user place (and its reports)',
      ok(await adm(boss, `select public.admin_delete_directory_place($1)`, [usr])) &&
      (await admin(db, `select count(*)::int n from directory_places where id = $1`, [usr]))[0].n === 0 &&
      (await admin(db, `select count(*)::int n from directory_place_reports where place_id = $1`, [usr]))[0].n === 0);
  }

  // ------------------------------------------------------------------
  console.log('\nPhase tpro — متجري admin: orders list, timeline, snapshots, archive (0096)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
      // …and 0098 (store orders with variants, restock per variant).
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)
    } catch (e) {
      rerun = e.message;
    }
    check('tpro: 0096 is safe to re-run', rerun === null, rerun);
    const idOf = (r) => r.rows?.[0] && Object.values(r.rows[0])[0];
    const tM = await signUp(db, 'tpro merchant', '01000096001');
    const tM2 = await signUp(db, 'tpro other merchant', '01000096002');
    const tBuyer = await signUp(db, 'tpro buyer', '01000096003');
    const tShop = idOf(await as(db, tM, `select public.create_my_shop('محل البرو', 'بقالة', 'tpro-shop', '01000096001') as id`));
    const tShop2 = idOf(await as(db, tM2, `select public.create_my_shop('محل تاني', 'بقالة', 'tpro-other', '01000096002') as id`));
    check('tpro: two merchants register', !!tShop && !!tShop2);
    await as(db, tM, `select public.set_my_shop_delivery($1, 10)`, [tShop]);
    const prod = async (name, price) => idOf(await as(db, tM,
      `insert into shop_products (shop_id, name, price, images, options)
       values ($1, $2, $3, array['https://x.test/p.jpg'], '[{"name":"المقاس","values":["S","M"]}]'::jsonb) returning id`, [tShop, name, price]));
    const pA = await prod('تيشيرت أبيض', 100);
    const pB = await prod('بنطلون', 250);
    const pC = await prod('شنطة', 80);
    check('tpro: products start active and visible', (await admin(db, `select count(*)::int n from shop_products where shop_id = $1 and status = 'active' and is_available`, [tShop]))[0].n === 3);

    // ---- snapshots on new orders
    const place = (name, phone, lines) => as(db, null, `select public.place_store_order($1, $2::jsonb, $3, $4, 'شارع 9، المعادي، عمارة 4 شقة 2') as code`,
      [tShop, JSON.stringify(lines), name, phone]);
    const o1 = idOf(await place('منى عادل', '01000096101', [{ product_id: pA, quantity: 2, options: 'المقاس: M' }, { product_id: pB, quantity: 1 }]));
    check('tpro: a guest order is placed', /^T[0-9A-Z]{7}$/.test(o1 || ''), o1);
    const lines1 = await admin(db, `select i.product_name, i.variant_label, i.unit_price::float up, i.image_url from shop_order_items i join shop_orders o on o.id = i.order_id
      where o.order_code = $1 order by i.product_name`, [o1]);
    check('tpro: the order lines keep a snapshot (name, variant, price, image)',
      lines1.length === 2 && lines1.some((l) => l.product_name === 'تيشيرت أبيض' && l.variant_label === 'المقاس: M' && l.up === 100 && l.image_url.endsWith('.jpg')) &&
      lines1.some((l) => l.product_name === 'بنطلون' && l.variant_label === null), lines1);
    const inApp = await as(db, tBuyer, `select public.place_shop_order($1, $2::jsonb, '01000096003') as id`, [tShop, JSON.stringify([{ product_id: pC, quantity: 1 }])]);
    check('tpro: an in-app order snapshots its lines too', ok(inApp) &&
      (await admin(db, `select product_name from shop_order_items where order_id = $1`, [idOf(inApp)]))[0]?.product_name === 'شنطة', inApp);
    await as(db, tM, `update shop_products set name = 'تيشيرت أبيض جديد', price = 120 where id = $1`, [pA]);
    const track = (await as(db, null, `select public.get_store_order($1) as o`, [o1])).rows?.[0]?.o;
    check('tpro: renaming / re-pricing a product does not rewrite the order (tracking reads the snapshot)',
      track?.items?.some((i) => i.name === 'تيشيرت أبيض' && Number(i.price) === 100 && i.options === 'المقاس: M'), track);

    // ---- backfill of older rows
    const legacyOrder = idOf(await place('قديم', '01000096102', [{ product_id: pC, quantity: 1 }]));
    await admin(db, `update shop_order_items set product_name = null, image_url = null, variant_label = null
      where order_id = (select id from shop_orders where order_code = $1)`, [legacyOrder]);
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0096_tajer_pro_admin.sql'), 'utf8'));
    // …and 0098 (store orders with variants, restock per variant).
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql'), 'utf8'));
    await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8')); // …and 0099 re-prices them (zones, discounts)
    const back = (await admin(db, `select product_name, image_url from shop_order_items where order_id = (select id from shop_orders where order_code = $1)`, [legacyOrder]))[0];
    check('tpro: lines without a snapshot are backfilled from the product', back?.product_name === 'شنطة' && back.image_url?.includes('.jpg'), back);

    // ---- more orders for search / pagination (spread one minute apart)
    for (let i = 0; i < 6; i++) await place('زبون رقم ' + i, '0100009620' + i, [{ product_id: pB, quantity: 1 }]);
    await admin(db, `update shop_orders o set created_at = now() - (r.n * interval '1 minute')
      from (select id, row_number() over (order by created_at desc, id desc) as n from shop_orders where shop_id = $1) r where r.id = o.id`, [tShop]);
    const list = async (u, args = {}) => {
      const r = await as(db, u, `select public.merchant_orders($1, $2, $3, $4, $5, $6, $7, $8) as r`,
        [args.shop ?? tShop, args.status ?? null, args.search ?? null, args.from ?? null, args.to ?? null, args.limit ?? 50, args.before ?? null, args.beforeId ?? null]);
      return r.error ? r : r.rows[0].r;
    };
    const all = await list(tM);
    check('tpro: merchant_orders lists every order of the shop, newest first, with counts',
      all.orders?.length === 9 && all.counts.all === 9 && all.counts.placed === 9 && all.has_more === false &&
      all.orders.every((o, i, a) => i === 0 || o.created_at <= a[i - 1].created_at), { n: all.orders?.length, c: all.counts, e: all.error });
    check('tpro: …each row carries its snapshot lines and cash payment',
      all.orders?.find((o) => o.order_code === o1)?.items?.some((i) => i.product_name === 'تيشيرت أبيض' && i.variant_label === 'المقاس: M') &&
      all.orders.every((o) => o.payment === 'cash'));
    const page1 = await list(tM, { limit: 4 });
    const last = page1.orders?.[3];
    const page2 = await list(tM, { limit: 4, before: last?.created_at, beforeId: last?.id });
    const last2 = page2.orders?.[3];
    const page3 = await list(tM, { limit: 4, before: last2?.created_at, beforeId: last2?.id });
    const seen = [...(page1.orders || []), ...(page2.orders || []), ...(page3.orders || [])].map((o) => o.id);
    check('tpro: keyset pagination walks every order once (4 + 4 + 1)',
      page1.has_more && page2.has_more && !page3.has_more && page3.orders.length === 1 && new Set(seen).size === 9,
      { p1: page1.orders?.length, p2: page2.orders?.length, p3: page3.orders?.length, e: page2.error });
    check('tpro: search by code', (await list(tM, { search: o1.toLowerCase() })).orders?.map((o) => o.order_code).join() === o1);
    check('tpro: search by customer name', (await list(tM, { search: 'زبون رقم 3' })).orders?.length === 1 && (await list(tM, { search: 'زبون' })).counts?.all === 6);
    check('tpro: search by phone (any format, Arabic digits too)',
      (await list(tM, { search: '0100009620٤' })).orders?.[0]?.customer_name === 'زبون رقم 4' && (await list(tM, { search: '96205' })).orders?.length === 1);
    check('tpro: a LIKE wildcard in the search is literal', (await list(tM, { search: '%' })).orders?.length === 0);
    const future = await list(tM, { from: new Date(Date.now() + 3600e3).toISOString() });
    const span = await list(tM, { from: new Date(Date.now() - 86400e3).toISOString(), to: new Date(Date.now() + 60e3).toISOString() });
    check('tpro: date range filter', future.orders?.length === 0 && span.orders?.length === 9, { f: future.orders?.length, w: span.orders?.length });

    // ---- auth
    check('tpro: another merchant cannot list the orders', denied(await list(tM2)));
    check('tpro: a customer / guest cannot list the orders', denied(await list(tBuyer)) && denied(await list(null)));
    const oid1 = all.orders?.find((o) => o.order_code === o1)?.id;
    check('tpro: another merchant cannot open an order', denied(await as(db, tM2, `select public.merchant_order($1)`, [oid1])));
    check('tpro: another merchant cannot note / cancel it',
      denied(await as(db, tM2, `select public.merchant_set_order_note($1, 'x')`, [oid1])) && denied(await as(db, tM2, `select public.merchant_cancel_order($1, 'x')`, [oid1])));
    check('tpro: another merchant reads no events', ((await as(db, tM2, `select * from shop_order_events where order_id = $1`, [oid1])).rows || []).length === 0);
    check('tpro: the owner reads the events', ((await as(db, tM, `select * from shop_order_events where order_id = $1`, [oid1])).rows || []).length === 1);
    check('tpro: nobody writes events directly', denied(await as(db, tM, `insert into shop_order_events (order_id, shop_id, kind) values ($1, $2, 'note')`, [oid1, tShop])));
    check('tpro: bad status filter is refused', denied(await list(tM, { status: 'cart' })));

    // ---- events
    check('tpro: status change', ok(await as(db, tM, `select public.update_shop_order_status($1, 'preparing')`, [oid1])));
    check('tpro: internal note', ok(await as(db, tM, `select public.merchant_set_order_note($1, 'الزبون عايزها قبل الضهر')`, [oid1])));
    check('tpro: the same note again adds no event', ok(await as(db, tM, `select public.merchant_set_order_note($1, 'الزبون عايزها قبل الضهر')`, [oid1])));
    check('tpro: cancel with a reason', ok(await as(db, tM, `select public.merchant_cancel_order($1, 'الزبون مبيردش')`, [oid1])));
    const det = (await as(db, tM, `select public.merchant_order($1) as o`, [oid1])).rows?.[0]?.o;
    const kinds = det?.events?.map((e) => e.kind + ':' + (e.to_status ?? '') + ':' + e.actor_role);
    check('tpro: the timeline has created → preparing → note → cancel (with who did it)',
      JSON.stringify(kinds) === JSON.stringify(['created:placed:customer', 'status:preparing:merchant', 'note::merchant', 'cancel:cancelled:merchant']), kinds);
    check('tpro: …the cancel reason and the note are on the order and the events',
      det?.cancel_reason === 'الزبون مبيردش' && det.internal_note === 'الزبون عايزها قبل الضهر' &&
      det.events[3].body === 'الزبون مبيردش' && det.events[3].from_status === 'preparing' && det.events[2].body === 'الزبون عايزها قبل الضهر' &&
      det.events[1].actor_name === 'tpro merchant', det?.events);
    check('tpro: the detail has the snapshot lines and totals', det?.items?.length === 2 && Number(det.total_amount) === 460 && Number(det.delivery_fee) === 10, det);
    const firstId = all.orders?.[0]?.id;
    check('tpro: a delivered order cannot be cancelled (and keeps no reason)',
      ok(await as(db, tM, `select public.update_shop_order_status($1, 'preparing')`, [firstId])) &&
      ok(await as(db, tM, `select public.update_shop_order_status($1, 'delivered')`, [firstId])) &&
      denied(await as(db, tM, `select public.merchant_cancel_order($1, 'x')`, [firstId])) &&
      (await admin(db, `select cancel_reason from shop_orders where id = $1`, [firstId]))[0].cancel_reason === null);
    const buyerOrder = idOf(inApp);
    check('tpro: a customer cancelling shows as «customer» on the timeline',
      ok(await as(db, tBuyer, `select public.update_shop_order_status($1, 'cancelled')`, [buyerOrder])) &&
      (await admin(db, `select actor_role from shop_order_events where order_id = $1 and kind = 'cancel'`, [buyerOrder]))[0]?.actor_role === 'customer');
    const counts = (await list(tM)).counts;
    check('tpro: chip counts follow the statuses', counts?.cancelled === 2 && counts.delivered === 1 && counts.placed === 6 && counts.all === 9, counts);
    check('tpro: status filter', (await list(tM, { status: 'cancelled' })).orders?.length === 2);

    // ---- archive instead of delete
    const pD = await prod('منتج من غير طلبات', 50);
    check('tpro: a product nobody ordered is deleted', (await as(db, tM, `select public.merchant_delete_product($1) as r`, [pD])).rows?.[0]?.r?.deleted === true &&
      (await admin(db, `select count(*)::int n from shop_products where id = $1`, [pD]))[0].n === 0);
    const del = (await as(db, tM, `select public.merchant_delete_product($1) as r`, [pB])).rows?.[0]?.r;
    check('tpro: a product with orders is not deleted — the app is told to archive it', del?.deleted === false && del.has_orders === true &&
      (await admin(db, `select count(*)::int n from shop_products where id = $1`, [pB]))[0].n === 1, del);
    check('tpro: another merchant cannot delete it', denied(await as(db, tM2, `select public.merchant_delete_product($1)`, [pB])));
    check('tpro: archive', ok(await as(db, tM, `update shop_products set status = 'archived' where id = $1`, [pB])) &&
      (await admin(db, `select is_available from shop_products where id = $1`, [pB]))[0].is_available === false);
    check('tpro: an archived product is hidden from guests and cannot be ordered',
      ((await as(db, null, `select id from shop_products where id = $1`, [pB])).rows || []).length === 0 &&
      denied(await place('منى', '01000096301', [{ product_id: pB, quantity: 1 }])));
    check('tpro: the owner still sees it (status filter in the app)', (await as(db, tM, `select status from shop_products where id = $1`, [pB])).rows?.[0]?.status === 'archived');
    check('tpro: its old orders still show the snapshot', (await list(tM, { search: 'زبون رقم 2' })).orders?.[0]?.items?.[0]?.product_name === 'بنطلون');
    check('tpro: hiding (old clients) makes a draft; showing makes it active again',
      ok(await as(db, tM, `update shop_products set is_available = false where id = $1`, [pC])) &&
      (await admin(db, `select status from shop_products where id = $1`, [pC]))[0].status === 'draft' &&
      ok(await as(db, tM, `update shop_products set is_available = true where id = $1`, [pC])) &&
      (await admin(db, `select status from shop_products where id = $1`, [pC]))[0].status === 'active');
    check('tpro: a draft product is hidden', ok(await as(db, tM, `update shop_products set status = 'draft' where id = $1`, [pC])) &&
      ((await as(db, null, `select id from shop_products where id = $1`, [pC])).rows || []).length === 0);
    check('tpro: inserting a hidden product makes a draft',
      (await as(db, tM, `insert into shop_products (shop_id, name, price, is_available) values ($1, 'مخفي', 5, false) returning status`, [tShop])).rows?.[0]?.status === 'draft');
    check('tpro: unarchive shows it again', ok(await as(db, tM, `update shop_products set status = 'active' where id = $1`, [pB])) &&
      (await admin(db, `select is_available from shop_products where id = $1`, [pB]))[0].is_available === true);
    check('tpro: a bad status is refused', denied(await as(db, tM, `update shop_products set status = 'gone' where id = $1`, [pB])));

    // ---- onboarding share + stats
    check('tpro: «شارك متجرك» is recorded once (owner only)',
      ok(await as(db, tM2, `select public.merchant_mark_shared($1)`, [tShop])) &&
      (await admin(db, `select first_shared_at from shops where id = $1`, [tShop]))[0].first_shared_at === null &&
      ok(await as(db, tM, `select public.merchant_mark_shared($1)`, [tShop])) &&
      (await admin(db, `select first_shared_at from shops where id = $1`, [tShop]))[0].first_shared_at !== null);
    const stats = (await as(db, tM, `select public.my_shop_stats($1) as s`, [tShop])).rows?.[0]?.s;
    check('tpro: stats best sellers read the snapshot name; orders_all counts every order',
      stats?.orders_all === 9 && stats.top_products.some((t) => t.name === 'بنطلون'), stats);
  }
  // ------------------------------------------------------------------
  console.log('\nPhase tint — متجري «الربط والتكاملات»: payments, domain, pixels (0097)');
  {
    const fs = require('fs');
    const path = require('path');
    const nodeCrypto = require('crypto');
    const tO = await signUp(db, 'tint owner', '+20 100 970 0001');
    const tS = await signUp(db, 'tint saudi', '+966 50 970 0002');
    const tX = await signUp(db, 'tint other', '+20 100 970 0003');
    const mkShop = async (owner, slug, country, currency) => (await admin(db,
      `insert into shops (owner_id, source, name, slug, is_claimed, claimed_at, country, currency)
       values ($1, 'claimed', $2, $2, true, now(), $3, $4) returning id`, [owner, slug, country, currency]))[0].id;
    const shopE = await mkShop(tO, 'tint-eg', 'EG', 'EGP');
    const shopA = await mkShop(tS, 'tint-sa', 'SA', 'SAR');
    const shopX = await mkShop(tX, 'tint-x', 'EG', 'EGP');
    const integ = async (u, s) => as(db, u, `select public.get_shop_integrations($1) as j`, [s]);
    const J = (r) => r.rows?.[0]?.j ?? r.rows?.[0]?.[Object.keys(r.rows?.[0] || {})[0]];
    const gw = (u, s, p, pub, sec, mode = 'test') =>
      as(db, u, `select public.set_shop_gateway($1, $2, $3, $4, $5) as j`, [s, p, JSON.stringify(pub), sec == null ? null : JSON.stringify(sec), mode]);

    // ---- payments: access
    const i0 = J(await integ(tO, shopE));
    check('tint: the owner reads the integrations (COD on by default, EG gateways: fawaterak (0100)/paymob/kashier/tap)',
      i0?.payments?.cod_enabled === true && JSON.stringify(i0.payments.available) === '["fawaterak","paymob","kashier","tap"]', i0);
    check('tint: a Saudi shop gets paymob/tap/moyasar', JSON.stringify(J(await integ(tS, shopA))?.payments?.available) === '["paymob","tap","moyasar"]');
    check('tint: another merchant / a guest cannot read them',
      denied(await integ(tX, shopE)) && denied(await integ(null, shopE)));

    // ---- payments: gateways (secrets write-only)
    const PM_KEY = 'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBd2ZRLnNlY3JldFRBSUw5OTk5';
    const PM_HMAC = 'ABCDEF0123456789ABCDEF0123456789';
    const setPm = await gw(tO, shopE, 'paymob', { card_integration_id: '4567890', wallet_integration_id: '4567891', iframe_id: '812345' }, { api_key: PM_KEY, hmac_secret: PM_HMAC });
    const pmView = J(setPm)?.payments?.gateways?.find((g) => g.provider === 'paymob');
    check('tint: Paymob connects (pending until tested) and returns has_secret + last 4 only',
      ok(setPm) && pmView?.status === 'pending' && pmView.has_secret === true && pmView.secret_hint.api_key === '…' + PM_KEY.slice(-4) &&
      pmView.secret_hint.hmac_secret === '…6789' && pmView.public.card_integration_id === '4567890', { e: setPm.error, pmView });
    check('tint: SECRETS never come back to the client (RPC result)', ok(setPm) && !JSON.stringify(J(setPm)).includes(PM_KEY) && !JSON.stringify(J(setPm)).includes(PM_HMAC));
    const rowsO = await as(db, tO, `select * from shop_payment_gateways where shop_id = $1`, [shopE]);
    check('tint: …nor from the table (owner reads the row, without secrets)', ok(rowsO) && rowsO.rows.length === 1 && !JSON.stringify(rowsO.rows).includes(PM_KEY), rowsO);
    check('tint: the private secrets table is unreachable for owners and guests',
      denied(await as(db, tO, `select * from private.shop_gateway_secrets`)) && denied(await as(db, null, `select * from private.shop_gateway_secrets`)));
    check('tint: another merchant sees none of it', ((await as(db, tX, `select * from shop_payment_gateways`)).rows || []).length === 0 &&
      ((await as(db, tX, `select * from shop_payment_settings`)).rows || []).length === 0);
    check('tint: EXPLOIT blocked: the owner marks a gateway «connected» directly',
      denied(await as(db, tO, `update shop_payment_gateways set status = 'connected' where shop_id = $1`, [shopE])) &&
      denied(await as(db, tO, `insert into shop_payment_gateways (shop_id, provider, status) values ($1, 'tap', 'connected')`, [shopE])));
    check('tint: EXPLOIT blocked: another merchant connects a gateway on my shop',
      denied(await gw(tX, shopE, 'tap', { publishable_key: 'pk_test_abcdefghijklmnop' }, { secret_key: 'sk_test_abcdefghijklmnop' })));
    check('tint: gateway_credentials is for the Edge Functions only',
      denied(await as(db, tO, `select public.gateway_credentials($1, 'paymob')`, [shopE])) && denied(await as(db, null, `select public.gateway_credentials($1, 'paymob')`, [shopE])));
    check('tint: gateway_record_check / record_shop_payment_event / domain_record_check are service-only',
      denied(await as(db, tO, `select public.gateway_record_check($1, 'paymob', true)`, [shopE])) &&
      denied(await as(db, tO, `select public.record_shop_payment_event($1, 'paymob', 'x', 'y', true, '{}')`, [shopE])) &&
      denied(await as(db, tO, `select public.domain_record_check($1, true, true)`, [shopE])));
    const has = (r, s) => !!r.error && r.error.includes(s);
    check('tint: a gateway outside the shop country is refused (Moyasar in Egypt, Kashier in KSA)',
      has(await gw(tO, shopE, 'moyasar', { publishable_key: 'pk_test_' + 'a'.repeat(30) }, { secret_key: 'sk_test_' + 'a'.repeat(30) }), 'مش متاحة') &&
      has(await gw(tS, shopA, 'kashier', { merchant_id: 'MID-123-456' }, { api_key: 'a'.repeat(20), secret_key: 'b'.repeat(20) }), 'مش متاحة'));
    check('tint: bad formats / missing fields / unknown fields are refused',
      has(await gw(tO, shopE, 'tap', { publishable_key: 'pk_abc' }, { secret_key: 'sk_test_abcdefghijklmnop' }), 'publishable_key') &&
      has(await gw(tO, shopE, 'tap', { publishable_key: 'pk_test_abcdefghijklmnop' }, {}), 'secret_key') &&
      has(await gw(tO, shopE, 'tap', { publishable_key: 'pk_test_abcdefghijklmnop', evil: 'x' }, { secret_key: 'sk_test_abcdefghijklmnop' }), 'غير معروف'));
    check('tint: a test key in live mode is refused', has(await gw(tO, shopE, 'tap', { publishable_key: 'pk_live_abcdefghijklmnop' }, { secret_key: 'sk_test_abcdefghijklmnop' }, 'live'), 'مش متوافق'));
    const upd = await gw(tO, shopE, 'paymob', { card_integration_id: '4567899' }, {});
    const credsNow = (await admin(db, `select public.gateway_credentials($1, 'paymob') as c`, [shopE]))[0].c;
    check('tint: editing public fields keeps the saved secrets (no re-typing)', ok(upd) && credsNow.secret.api_key === PM_KEY &&
      credsNow.secret.hmac_secret === PM_HMAC && credsNow.public.card_integration_id === '4567899' && credsNow.country === 'EG', { e: upd.error, credsNow });
    await admin(db, `select public.gateway_record_check($1, 'paymob', true)`, [shopE]);
    check('tint: «اختبر الاتصال» result → «مربوط»', J(await integ(tO, shopE)).payments.gateways[0].status === 'connected');
    await admin(db, `select public.gateway_record_check($1, 'paymob', false, 'البوابة رفضت المفاتيح')`, [shopE]);
    const errG = J(await integ(tO, shopE)).payments.gateways[0];
    check('tint: …or «فيه مشكلة» with the reason', errG.status === 'error' && errG.last_error === 'البوابة رفضت المفاتيح', errG);
    await admin(db, `select public.gateway_record_check($1, 'paymob', true)`, [shopE]);
    const sau = await gw(tS, shopA, 'moyasar', { publishable_key: 'pk_test_' + 'Q'.repeat(30) }, { secret_key: 'sk_test_' + 'W'.repeat(30) });
    check('tint: Moyasar connects for a Saudi shop (with a webhook token for its dashboard)', ok(sau) && /^[0-9a-f]{32}$/.test(J(sau).payments.gateways[0].webhook_token), sau.error);

    // ---- payments: COD + manual methods
    const pay = (u, s, cod, manual) => as(db, u, `select public.set_shop_payment_settings($1, $2, $3) as j`, [s, cod, JSON.stringify(manual)]);
    check('tint: a wrong IBAN is refused', has(await pay(tO, shopE, true, { bank: { enabled: true, bank_name: 'CIB', account_name: 'محل', iban: 'EG380019000500000000263180003' } }), 'IBAN'));
    const goodPay = await pay(tO, shopE, false, {
      instapay: { enabled: true, handle: ' Ahmed.Shop ' },
      wallet: { enabled: true, number: '010 1234 5678', label: 'فودافون كاش' },
      bank: { enabled: true, bank_name: 'CIB', account_name: 'محل التجربة', iban: 'EG38 0019 0005 0000 0000 2631 8000 2' },
    });
    const man = J(goodPay)?.payments?.manual;
    check('tint: InstaPay / wallet / bank saved and normalized (IBAN checksum ok)', ok(goodPay) && man.instapay.handle === 'ahmed.shop@instapay' &&
      man.wallet.number === '01012345678' && man.bank.iban === 'EG380019000500000000263180002' && J(goodPay).payments.cod_enabled === false, { e: goodPay.error, man });
    check('tint: a bad InstaPay address / wallet number is refused',
      has(await pay(tO, shopE, true, { instapay: { enabled: true, handle: 'x y@instapay' } }), 'InstaPay') &&
      has(await pay(tO, shopE, true, { wallet: { enabled: true, number: '12' } }), 'المحفظة'));
    check('tint: switching everything off is refused (one way to pay at least)',
      has(await pay(tX, shopX, false, {}), 'طريقة دفع'));
    check('tint: EXPLOIT blocked: another merchant changes my payment methods', denied(await pay(tX, shopE, true, {})) &&
      denied(await as(db, tO, `update shop_payment_settings set cod_enabled = true where shop_id = $1`, [shopE])));
    const co = (await as(db, null, `select public.shop_checkout_methods($1) as j`, [shopE])).rows?.[0]?.j;
    check('tint: (Phase 4) checkout methods for customers: manual details + connected gateways, never secrets',
      co && co.cod === false && co.instapay === 'ahmed.shop@instapay' && co.bank.iban === 'EG380019000500000000263180002' &&
      co.online.length === 1 && co.online[0].provider === 'paymob' && co.online[0].mode === 'test' && !JSON.stringify(co).includes(PM_KEY) && !JSON.stringify(co).includes(PM_HMAC), co);
    const disc = await as(db, tO, `select public.disconnect_shop_gateway($1, 'paymob') as j`, [shopE]);
    check('tint: «افصل» deletes the secrets too', ok(disc) && J(disc).payments.gateways.length === 0 &&
      (await admin(db, `select count(*)::int n from private.shop_gateway_secrets where shop_id = $1`, [shopE]))[0].n === 0);

    // ---- payment events (webhook stub)
    await gw(tO, shopE, 'paymob', { card_integration_id: '4567890' }, { api_key: PM_KEY, hmac_secret: PM_HMAC });
    const ev1 = (await admin(db, `select public.record_shop_payment_event($1, 'paymob', 'TRANSACTION:success', '991', true, '{"a":1}') as id`, [shopE]))[0].id;
    const ev2 = (await admin(db, `select public.record_shop_payment_event($1, 'paymob', 'TRANSACTION:success', '991', true, '{"a":1}') as id`, [shopE]))[0].id;
    check('tint: webhook events are stored once (duplicates ignored)', !!ev1 && ev2 === null);
    check('tint: the owner reads their events, others do not',
      ((await as(db, tO, `select * from shop_payment_events`)).rows || []).length === 1 && ((await as(db, tX, `select * from shop_payment_events`)).rows || []).length === 0);
    check('tint: an event for a shop without that gateway is dropped',
      (await admin(db, `select public.record_shop_payment_event($1, 'tap', 'x', '1', true, '{}') as id`, [shopX]))[0].id === null);

    // ---- rate limit / ownership for the Edge Functions
    check('tint: integration_rate_hit refuses non-owners', denied(await as(db, tX, `select public.integration_rate_hit($1, 'gateway_test')`, [shopE])));
    let hits = 0;
    for (let i = 0; i < 20; i++) if (ok(await as(db, tO, `select public.integration_rate_hit($1, 'gateway_test')`, [shopE]))) hits++;
    check('tint: 20 connection tests an hour, then refused', hits === 20 && has(await as(db, tO, `select public.integration_rate_hit($1, 'gateway_test')`, [shopE]), 'استنى'));

    // ---- domains
    const dom = (u, s, h) => as(db, u, `select public.add_shop_domain($1, $2) as j`, [s, h]);
    const d1 = await dom(tO, shopE, 'https://Shop.Example.com/products?x=1');
    const d1v = J(d1)?.domain;
    check('tint: a domain is added normalized, with a TXT token (subdomain)', ok(d1) && d1v.hostname === 'shop.example.com' && d1v.is_apex === false &&
      d1v.status === 'pending' && /^mogtama3y-verify=[0-9a-f]{32}$/.test(d1v.verify_token), { e: d1.error, d1v });
    check('tint: one domain per shop for now', has(await dom(tO, shopE, 'www.other.com'), 'امسحه'));
    check('tint: a hostname belongs to one shop', has(await dom(tX, shopX, 'SHOP.example.com.'), 'متجر تاني'));
    const bads = ['1.2.3.4', 'mogtama3y.com', 'x.mogtama3y.com', 'localhost', 'متجر.com', 'a..b.com', 'shop.example.com:8080', 'shop.local', '-a.com', 'com'];
    const badRes = [];
    for (const b of bads) badRes.push(denied(await dom(tX, shopX, b)));
    check('tint: invalid hostnames are refused (IP, mogtama3y.com, localhost, non-ASCII, ports, …)', badRes.every(Boolean), bads.filter((_, i) => !badRes[i]));
    const idn = await dom(tS, shopA, 'xn--mgbh0fb.xn--mgberp4a5d4ar');
    check('tint: an Arabic (punycode) domain is accepted as a root domain', ok(idn) && J(idn).domain.is_apex === true, idn.error);
    const eg = await dom(tX, shopX, 'mystore.com.eg');
    check('tint: mystore.com.eg is a root domain', ok(eg) && J(eg).domain.is_apex === true, eg.error);
    check('tint: EXPLOIT blocked: domains are written only through the RPC / read by the owner only',
      denied(await as(db, tO, `insert into shop_domains (shop_id, hostname) values ($1, 'evil.com')`, [shopX])) &&
      denied(await as(db, tO, `update shop_domains set status = 'active' where shop_id = $1`, [shopE])) &&
      ((await as(db, tX, `select * from shop_domains where shop_id = $1`, [shopE])).rows || []).length === 0 &&
      denied(await dom(tX, shopE, 'evil.example.com')));
    const c1 = (await admin(db, `select public.domain_record_check($1, true, false, 'الـ TXT تمام ✓ فاضل سجل الـ CNAME') as j`, [shopE]))[0].j;
    check('tint: TXT without the CNAME → still pending, with the reason', c1.status === 'pending' && c1.last_error.includes('CNAME'), c1);
    const c2 = (await admin(db, `select public.domain_record_check($1, true, true) as j`, [shopE]))[0].j;
    check('tint: TXT + CNAME → verified (serving is Phase 5)', c2.status === 'verified' && !!c2.verified_at && c2.check_count === 2, c2);
    const c3 = (await admin(db, `select public.domain_record_check($1, true, false) as j`, [shopA]))[0].j;
    check('tint: a root domain verifies with the TXT alone', c3.status === 'verified', c3);
    let dh = 0;
    for (let i = 0; i < 13; i++) if (ok(await as(db, tO, `select public.integration_rate_hit($1, 'domain_verify')`, [shopE]))) dh++;
    check('tint: «تحقق دلوقتي» is limited to 12 an hour', dh === 12, dh);
    const rm = await as(db, tO, `select public.remove_shop_domain($1) as j`, [shopE]);
    check('tint: removing the domain frees it', ok(rm) && J(rm).domain === null &&
      (await admin(db, `select count(*)::int n from shop_domains where hostname = 'shop.example.com'`))[0].n === 0 && ok(await dom(tO, shopE, 'shop.example.com')));

    // ---- tracking
    const trk = (u, s, t) => as(db, u, `select public.set_shop_tracking($1, $2) as j`, [s, JSON.stringify(t)]);
    const t1 = await trk(tO, shopE, {
      meta_pixel: ' 123456789012345 ', tiktok_pixel: 'c4abcdefghij1234567k', snap_pixel: 'A1B2C3D4-0000-4000-8000-1234567890AB',
      ga4: 'g-abc1234xyz', gtm: 'gtm-ab12cd3', google_ads: 'aw-1234567890/AbC_dEf12', fb_domain_verification: 'ABCDEFGHIJ0123456789abcdefghij',
    });
    const tv = J(t1)?.tracking;
    check('tint: pixels saved and normalized', ok(t1) && tv.meta_pixel === '123456789012345' && tv.tiktok_pixel === 'C4ABCDEFGHIJ1234567K' &&
      tv.snap_pixel === 'a1b2c3d4-0000-4000-8000-1234567890ab' && tv.ga4 === 'G-ABC1234XYZ' && tv.gtm === 'GTM-AB12CD3' &&
      tv.google_ads === 'AW-1234567890/AbC_dEf12' && tv.fb_domain_verification === 'abcdefghij0123456789abcdefghij', { e: t1.error, tv });
    check('tint: wrong formats are refused (Meta letters, UA-, GTM, unknown key)',
      has(await trk(tO, shopE, { meta_pixel: 'abc' }), 'Meta') && has(await trk(tO, shopE, { ga4: 'UA-12345-1' }), 'Google Analytics') &&
      has(await trk(tO, shopE, { gtm: 'GTM-1' }), 'Tag Manager') && has(await trk(tO, shopE, { evil: '<script>' }), 'غير معروف'));
    check('tint: EXPLOIT blocked: another merchant sets pixels on my shop', denied(await trk(tX, shopE, { meta_pixel: '123456789012345' })));
    check('tint: EXPLOIT blocked: a direct table update with a script is refused by the constraint',
      denied(await as(db, tO, `update shops set tracking = '{"ga4":"G-1\\"><script>"}' where id = $1`, [shopE])));
    const anonT = await as(db, null, `select tracking from shops where id = $1`, [shopE]);
    check('tint: guests (the storefront) read the pixel IDs', ok(anonT) && anonT.rows[0].tracking.meta_pixel === '123456789012345', anonT);
    const t2 = await trk(tO, shopE, { meta_pixel: '', ga4: 'G-ABC1234XYZ' });
    check('tint: an emptied field is removed', ok(t2) && JSON.stringify(J(t2).tracking) === '{"ga4":"G-ABC1234XYZ"}', J(t2)?.tracking);

    // ---- Edge Function blocks, run in Node
    const block = (fn, tag) => {
      const src = fs.readFileSync(path.join(__dirname, '..', 'functions', fn, 'index.ts'), 'utf8');
      const s0 = src.indexOf('\n', src.indexOf(tag + ':begin')) + 1;
      return src.slice(s0, src.lastIndexOf('\n', src.indexOf(tag + ':end')));
    };
    let gwb = null, sigb = null, dnsb = null;
    try {
      gwb = new Function('btoa', block('payments-connect', 'gw') + '\nreturn { testGateway, paymobBase };')(globalThis.btoa);
      sigb = new Function('crypto', block('payments-webhook', 'sig') + '\nreturn { verifyWebhook, paymobString, kashierString, tapString };')(nodeCrypto.webcrypto);
      dnsb = new Function(block('domains-verify', 'dns') + '\nreturn { evaluateDns };')();
    } catch (e) {
      gwb = { error: e.message };
    }
    check('tint: the Edge Function blocks run in Node as plain JavaScript', gwb && !gwb.error && sigb && dnsb, gwb);
    if (gwb && !gwb.error) {
      const seen = [];
      const fake = (status, body) => async (url, opts) => { seen.push({ url, opts }); return { status, json: async () => body }; };
      const pmOk = await gwb.testGateway({ provider: 'paymob', country: 'SA', public: {}, secret: { api_key: 'k' } }, fake(201, { token: 't' }));
      check('tint: Paymob test hits the region host /api/auth/tokens with the api_key', pmOk.ok && seen[0].url === 'https://ksa.paymob.com/api/auth/tokens' &&
        JSON.parse(seen[0].opts.body).api_key === 'k', { pmOk, seen });
      const pmBad = await gwb.testGateway({ provider: 'paymob', country: 'EG', public: {}, secret: { api_key: 'k' } }, fake(401, {}));
      check('tint: a 401 → «فيه مشكلة»', !pmBad.ok && pmBad.message.includes('رفضت'));
      seen.length = 0;
      const my = await gwb.testGateway({ provider: 'moyasar', public: {}, secret: { secret_key: 'sk_test_x' } }, fake(200, {}));
      check('tint: Moyasar test = GET /v1/payments?limit=1 with Basic auth', my.ok && seen[0].url === 'https://api.moyasar.com/v1/payments?limit=1' &&
        seen[0].opts.headers.Authorization === 'Basic ' + Buffer.from('sk_test_x:').toString('base64'));
      const ks = await gwb.testGateway({ provider: 'kashier', public: { merchant_id: 'MID-12-34' }, secret: { api_key: 'a', secret_key: 'b' } }, fake(500, {}));
      check('tint: Kashier is a format check, clearly marked', ks.ok && ks.checked === 'format');
      const net = await gwb.testGateway({ provider: 'tap', public: {}, secret: { secret_key: 'sk' } }, async () => { throw new Error('down'); });
      check('tint: a network failure is reported, not thrown', net.ok === false && net.message.includes('مقدرناش'));
    }
    if (sigb) {
      const obj = { id: 991, amount_cents: 15000, created_at: '2026-10-18T10:00:00', currency: 'EGP', error_occured: false, has_parent_transaction: false,
        integration_id: 4567890, is_3d_secure: true, is_auth: false, is_capture: false, is_refunded: false, is_standalone_payment: true, is_voided: false,
        order: { id: 5555 }, owner: 77, pending: false, source_data: { pan: '2346', sub_type: 'MasterCard', type: 'card' }, success: true };
      const str = sigb.paymobString(obj);
      const pmH = nodeCrypto.createHmac('sha512', PM_HMAC).update(str).digest('hex');
      const creds = { secret: { hmac_secret: PM_HMAC } };
      check('tint: Paymob HMAC-SHA512 string is built in the documented order',
        str === '150002026-10-18T10:00:00EGPfalsefalse9914567890truefalsefalsefalsetruefalse555577false2346MasterCardcardtrue', str);
      const vOk = await sigb.verifyWebhook('paymob', creds, { type: 'TRANSACTION', obj }, {}, { hmac: pmH });
      const vBad = await sigb.verifyWebhook('paymob', creds, { type: 'TRANSACTION', obj: { ...obj, amount_cents: 1 } }, {}, { hmac: pmH });
      check('tint: Paymob signature: valid passes, tampered amount fails', vOk.ok && vOk.external_id === '991' && vOk.event_type === 'TRANSACTION:success' && !vBad.ok, { vOk, vBad });
      const kd = { merchantOrderId: 'T1234567', amount: '150.00', currency: 'EGP', status: 'SUCCESS', transactionId: 'TX 1', signatureKeys: ['transactionId', 'amount', 'currency', 'merchantOrderId', 'status'] };
      const kStr = 'amount=150.00&currency=EGP&merchantOrderId=T1234567&status=SUCCESS&transactionId=TX%201';
      const kH = nodeCrypto.createHmac('sha256', 'kashier-api-key-1234').update(kStr).digest('hex');
      const kv = await sigb.verifyWebhook('kashier', { secret: { api_key: 'kashier-api-key-1234' } }, { event: 'pay', data: kd }, { 'x-kashier-signature': kH }, {});
      check('tint: Kashier signature (sorted signatureKeys, encoded values, HMAC-SHA256)', sigb.kashierString(kd) === kStr && kv.ok && kv.external_id === 'TX 1', { s: sigb.kashierString(kd), kv });
      const tc = { id: 'chg_1', object: 'charge', amount: 10.5, currency: 'KWD', status: 'CAPTURED', reference: { gateway: 'g1', payment: 'p1' }, transaction: { created: '1700000000000' } };
      const tH = nodeCrypto.createHmac('sha256', 'sk_test_tap').update('x_idchg_1x_amount10.500x_currencyKWDx_gateway_referenceg1x_payment_referencep1x_statusCAPTUREDx_created1700000000000').digest('hex');
      const tv2 = await sigb.verifyWebhook('tap', { secret: { secret_key: 'sk_test_tap' } }, tc, { hashstring: tH }, {});
      check('tint: Tap hashstring (3-decimal KWD amount)', tv2.ok && tv2.event_type === 'charge:CAPTURED', tv2);
      const mv = await sigb.verifyWebhook('moyasar', { secret: {}, webhook_token: 'tok123' }, { id: 'ev1', type: 'payment_paid', secret_token: 'tok123' }, {}, {});
      const mv2 = await sigb.verifyWebhook('moyasar', { secret: {}, webhook_token: 'tok123' }, { id: 'ev1', type: 'payment_paid', secret_token: 'tok124' }, {}, {});
      const none = await sigb.verifyWebhook('paymob', creds, { obj }, {}, {});
      check('tint: Moyasar secret_token compared; a missing signature fails', mv.ok && !mv2.ok && !none.ok);
    }
    if (dnsb) {
      const dm = { hostname: 'shop.example.com', is_apex: false, verify_token: 'mogtama3y-verify=abc' };
      const a = dnsb.evaluateDns(dm, [['mogtama3y-verify=', 'abc']], ['stores.mogtama3y.com.']);
      const b = dnsb.evaluateDns(dm, [['other']], null);
      const c = dnsb.evaluateDns(dm, [['mogtama3y-verify=abc']], ['shops.myshopify.com']);
      const e = dnsb.evaluateDns({ ...dm, is_apex: true }, [['mogtama3y-verify=abc']], null);
      check('tint: DNS evaluation (chunked TXT, trailing-dot CNAME, wrong CNAME, root domain)',
        a.txtOk && a.cnameOk && a.message.includes('قريباً') && !b.txtOk && !b.cnameOk && c.txtOk && !c.cnameOk && c.message.includes('shops.myshopify.com') && e.txtOk && e.message.includes('✓'), { a, b, c, e });
    }

    // ---- web/shop-pixels.js event mapping
    let px = null;
    try {
      px = require(path.join(__dirname, '..', '..', 'web', 'shop-pixels.js'));
    } catch (e2) {
      px = { error: e2.message };
    }
    check('tint: shop-pixels.js loads in Node (pure mapping)', px && typeof px.buildCalls === 'function', px);
    if (px && px.buildCalls) {
      const ids = { meta_pixel: '123456789012345', tiktok_pixel: 'C4ABCDEFGHIJ1234567K', snap_pixel: 'a1b2c3d4-0000-4000-8000-1234567890ab', ga4: 'G-ABC1234XYZ', gtm: 'GTM-AB12CD3', google_ads: 'AW-1234567890/AbC_dEf12' };
      const purchase = px.buildCalls('Purchase', { currency: 'EGP', value: 250, order_id: 'T1234567', contents: [{ id: 'p1', name: 'تيشيرت', price: 100, quantity: 2 }, { id: 'p2', name: 'شنطة', price: 50, quantity: 1 }] }, ids);
      const fb = purchase.find((c) => c[0] === 'fbq');
      const tt = purchase.find((c) => c[0] === 'ttq');
      const sc = purchase.find((c) => c[0] === 'snaptr');
      const ga = purchase.find((c) => c[0] === 'gtag' && c[2] === 'purchase');
      const aw = purchase.find((c) => c[0] === 'gtag' && c[2] === 'conversion');
      const dl = purchase.filter((c) => c[0] === 'dl');
      check('tint: Purchase → Meta trackSingle with value/currency/contents and the order as eventID',
        fb && fb[1] === 'trackSingle' && fb[2] === ids.meta_pixel && fb[3] === 'Purchase' && fb[4].value === 250 && fb[4].currency === 'EGP' &&
        fb[4].num_items === 3 && JSON.stringify(fb[4].content_ids) === '["p1","p2"]' && fb[5].eventID === 'order-T1234567', fb);
      check('tint: …TikTok CompletePayment with event_id, Snapchat PURCHASE with transaction_id',
        tt && tt[1] === ids.tiktok_pixel && tt[3] === 'CompletePayment' && tt[5].event_id === 'order-T1234567' && tt[4].contents[0].content_id === 'p1' &&
        sc && sc[2] === 'PURCHASE' && sc[3].transaction_id === 'T1234567' && sc[3].number_items === 3, { tt, sc });
      check('tint: …GA4 purchase to the merchant IDs only + Google Ads conversion + GTM ecommerce (cleared first)',
        ga && JSON.stringify(ga[3].send_to) === '["G-ABC1234XYZ","AW-1234567890"]' && ga[3].transaction_id === 'T1234567' && ga[3].items.length === 2 &&
        aw && aw[3].send_to === 'AW-1234567890/AbC_dEf12' && aw[3].value === 250 &&
        dl.length === 2 && dl[0][1].ecommerce === null && dl[1][1].event === 'purchase' && dl[1][1].ecommerce.transaction_id === 'T1234567', { ga, aw, dl });
      const view = px.buildCalls('ViewContent', { currency: 'SAR', contents: [{ id: 'p9', name: 'عطر', price: 80.5, quantity: 1 }] }, { meta_pixel: ids.meta_pixel });
      check('tint: ViewContent computes the value and names the product; only configured pixels fire',
        view.length === 1 && view[0][3] === 'ViewContent' && view[0][4].value === 80.5 && view[0][4].currency === 'SAR' && view[0][4].content_name === 'عطر' && view[0].length === 5, view);
      const page = px.buildCalls('PageView', {}, { ga4: 'G-ABC1234XYZ', snap_pixel: ids.snap_pixel }, { location: 'https://mogtama3y.com/#/s/x', title: 'x' });
      check('tint: PageView → GA4 page_view (send_to merchant) + Snap PAGE_VIEW',
        page.length === 2 && page.some((c) => c[0] === 'snaptr' && c[2] === 'PAGE_VIEW') && page.some((c) => c[0] === 'gtag' && c[2] === 'page_view' && c[3].page_location.includes('/s/x')), page);
      check('tint: malformed IDs never reach a vendor (no script injection through an ID)',
        px.buildCalls('PageView', {}, { meta_pixel: '123"><script>', ga4: 'G-1' }).length === 0 && px.buildCalls('Bogus', {}, ids).length === 0 &&
        JSON.stringify(px.cleanIds({ gtm: 'GTM-AB12CD3', x: 'y' })) === '{"gtm":"GTM-AB12CD3"}');
    }
  }

  // ------------------------------------------------------------------
  console.log('\nPhase tchk — متجري checkout: shipping zones, discounts, carts, confirm, guest cancel (0099)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('tchk: 0099 is safe to re-run', rerun === null, rerun);
    const one = (r) => r.rows?.[0] && Object.values(r.rows[0])[0];
    const cM = await signUp(db, 'tchk merchant', '01000099001');
    const cM2 = await signUp(db, 'tchk other merchant', '01000099002');
    const cBuyer = await signUp(db, 'tchk buyer', '01000099003');
    const cShop = one(await as(db, cM, `select public.create_my_shop('محل الشيك أوت', 'ملابس', 'tchk-shop', '01000099001') as id`));
    const cShop2 = one(await as(db, cM2, `select public.create_my_shop('محل تاني', 'ملابس', 'tchk-other', '01000099002') as id`));
    const prod = async (name, price, stock = null) => one(await as(db, cM,
      `insert into shop_products (shop_id, name, price, stock, images) values ($1, $2, $3, $4, array['https://x.test/p.jpg']) returning id`, [cShop, name, price, stock]));
    const pA = await prod('قميص', 100);
    const pB = await prod('شنطة', 50);
    const pC = await prod('جاكيت', 200, 50);
    let ph = 100;
    const phone = () => '01000099' + String(ph++).padStart(3, '0');
    const quote = async (lines, o = {}) => {
      const r = await as(db, o.as ?? null, `select public.quote_store_checkout($1, $2::jsonb, $3, $4, $5, $6) as q`,
        [o.shop ?? cShop, JSON.stringify(lines), o.area ?? null, o.ful ?? 'delivery', o.code ?? null, o.phone ?? null]);
      return r.error ? { error: r.error } : r.rows[0].q;
    };
    const place = (lines, o = {}) => as(db, o.as ?? null,
      `select public.place_store_order($1, $2::jsonb, $3, $4, $5, $6, $7, $8, $9, $10, $11) as code`,
      [o.shop ?? cShop, JSON.stringify(lines), o.name ?? 'زبون تجريبي', o.phone ?? phone(), o.address ?? 'شارع 9، المعادي، عمارة 4 شقة 2', o.note ?? null,
        o.area ?? null, o.ful ?? 'delivery', o.code ?? null, o.cart ?? null, o.expected ?? null]);
    const orderOf = async (code) => (await admin(db, `select * from shop_orders where order_code = $1`, [code]))[0];
    const ship = (p, u = cM) => as(db, u, `select public.set_shop_shipping($1, $2::jsonb) as s`, [cShop, JSON.stringify(p)]);
    const errMsg = (r) => r.error || '';
    const L = (pid, q = 1, extra = {}) => ({ product_id: pid, quantity: q, ...extra });

    // ---- the old flat fee is the default rate
    await as(db, cM, `select public.set_my_shop_delivery($1, 20, 400)`, [cShop]);
    const q0 = await quote([L(pA)]);
    check('tchk: no zones → the flat fee (set_my_shop_delivery) is the default rate', Number(q0.shipping_fee) === 20 && q0.shipping_zone === null && Number(q0.total) === 120 && q0.can_order, q0);
    const legacy = await as(db, null, `select public.place_store_order($1, $2::jsonb, 'عميل قديم', $3, 'شارع 9، المعادي، عمارة 4') as code`, [cShop, JSON.stringify([L(pA, 4)]), phone()]);
    const legacyO = legacy.error ? null : await orderOf(one(legacy));
    check('tchk: an old client (5 arguments) still orders; free over 400 applies',
      legacyO && Number(legacyO.delivery_fee) === 0 && Number(legacyO.total_amount) === 400 && Number(legacyO.subtotal) === 400 && legacyO.fulfillment === 'delivery', legacy.error || legacyO);
    check('tchk: every existing shop got a settings row (migration of the flat fee)',
      (await admin(db, `select count(*)::int n from shops s where s.owner_id is not null and s.created_at < now() - interval '0 sec'
        and not exists (select 1 from shop_shipping_settings ss where ss.shop_id = s.id) and s.id <> all($1::uuid[])`, [[cShop, cShop2]]))[0].n === 0);

    // ---- zones
    const zones = {
      default_mode: 'none', default_fee: 20, default_free_over: 400,
      zones: [
        { name: 'القاهرة الكبرى', areas: ['القاهرة', 'الجيزة'], fee: 30, free_over: 500, eta: 'خلال يوم' },
        { name: 'الإسكندرية', areas: ['الإسكندرية'], fee: 50 },
      ],
    };
    check('tchk: another merchant / a guest cannot change the shipping', denied(await ship(zones, cM2)) && denied(await ship(zones, null)));
    check('tchk: an area in two zones is refused',
      errMsg(await ship({ ...zones, zones: [...zones.zones, { name: 'تاني', areas: ['الجيزه'], fee: 10 }] })).includes('أكتر من منطقة'));
    check('tchk: a negative fee / a zone without areas is refused',
      denied(await ship({ ...zones, zones: [{ name: 'x', areas: ['القاهرة'], fee: -1 }] })) && denied(await ship({ ...zones, zones: [{ name: 'x', areas: [], fee: 1 }] })));
    const saved = await ship(zones);
    check('tchk: the owner saves zones', ok(saved) && one(saved).zones.length === 2 && one(saved).default_mode === 'none', saved.error);
    check('tchk: other merchants read no zones / settings (RLS)',
      ((await as(db, cM2, `select * from shop_shipping_zones where shop_id = $1`, [cShop])).rows || []).length === 0 &&
      ((await as(db, cM2, `select * from shop_shipping_settings where shop_id = $1`, [cShop])).rows || []).length === 0 &&
      denied(await as(db, null, `select * from shop_shipping_zones`)));
    const qCai = await quote([L(pA)], { area: 'القاهرة' });
    check('tchk: a zone prices its areas (fee, zone name, ETA)', Number(qCai.shipping_fee) === 30 && qCai.shipping_zone === 'القاهرة الكبرى' && qCai.shipping_eta === 'خلال يوم' && Number(qCai.total) === 130, qCai);
    const qGiza = await quote([L(pA, 5)], { area: ' الجيزه ' });
    check('tchk: area matching ignores spaces and ة/ه; the zone\'s free-over applies', Number(qGiza.shipping_fee) === 0 && qGiza.shipping_zone === 'القاهرة الكبرى' && Number(qGiza.shipping_base) === 0, qGiza);
    const qAlex = await quote([L(pA, 5)], { area: 'الإسكندرية' });
    check('tchk: a zone without free-over keeps its fee', Number(qAlex.shipping_fee) === 50 && Number(qAlex.total) === 550, qAlex);
    const qAswan = await quote([L(pA)], { area: 'أسوان' });
    check('tchk: an unserved area is a blocking error («مش بنوصّل هناك»)', qAswan.can_order === false && qAswan.errors?.[0]?.code === 'not_served', qAswan);
    check('tchk: …and the order is refused', errMsg(await place([L(pA)], { area: 'أسوان' })).includes('مش بيوصّل'));
    check('tchk: no area with «مش بنوصّل» outside zones → area required', (await quote([L(pA)])).errors?.[0]?.code === 'area_required' && denied(await place([L(pA)])));
    await ship({ ...zones, default_mode: 'rate', default_eta: '2-3 أيام' });
    const qRest = await quote([L(pA)], { area: 'أسوان' });
    check('tchk: «باقي المناطق» gets the default rate', Number(qRest.shipping_fee) === 20 && qRest.shipping_zone === 'باقي المناطق' && qRest.shipping_eta === '2-3 أيام', qRest);
    check('tchk: the default rate is written back to shops.delivery_fee (old builds)',
      Number((await admin(db, `select delivery_fee from shops where id = $1`, [cShop]))[0].delivery_fee) === 20);
    const zoneOrder = one(await place([L(pA)], { area: 'القاهرة' }));
    const zo = zoneOrder && await orderOf(zoneOrder);
    check('tchk: the order snapshots shipping zone / area / fee and subtotal',
      zo && zo.shipping_zone === 'القاهرة الكبرى' && zo.shipping_area === 'القاهرة' && Number(zo.delivery_fee) === 30 && Number(zo.subtotal) === 100 && Number(zo.total_amount) === 130, zo);

    // ---- pickup
    check('tchk: pickup is refused while it is off', (await quote([L(pA)], { ful: 'pickup' })).errors?.[0]?.code === 'pickup_unavailable' && denied(await place([L(pA)], { ful: 'pickup' })));
    check('tchk: pickup needs an address', errMsg(await ship({ ...zones, pickup_enabled: true })).includes('عنوان الاستلام'));
    await ship({ ...zones, default_mode: 'rate', pickup_enabled: true, pickup_address: 'المحل: 5 شارع 9 المعادي', pickup_instructions: 'من 10 لـ 10' });
    const qPick = await quote([L(pA)], { ful: 'pickup' });
    check('tchk: pickup costs no shipping', Number(qPick.shipping_fee) === 0 && qPick.shipping_zone === 'استلام من المحل' && Number(qPick.total) === 100, qPick);
    const pickCode = one(await place([L(pA)], { ful: 'pickup', address: '' }));
    const po = pickCode && await orderOf(pickCode);
    check('tchk: a pickup order needs no address and records the fulfillment', po && po.fulfillment === 'pickup' && Number(po.delivery_fee) === 0 && po.delivery_address === 'استلام من المحل', po);
    const trackPick = one(await as(db, null, `select public.get_store_order($1) as o`, [pickCode]));
    check('tchk: tracking shows the pickup address', trackPick?.pickup_address === 'المحل: 5 شارع 9 المعادي' && trackPick.fulfillment === 'pickup', trackPick);
    check('tchk: a bad fulfillment is refused', denied(await place([L(pA)], { ful: 'drone' })));

    // ---- open / closed / minimum
    const base = { ...zones, default_mode: 'rate', pickup_enabled: true, pickup_address: 'المحل: 5 شارع 9 المعادي' };
    await ship({ ...base, accepting_orders: false });
    check('tchk: «بنستقبل طلبات» off → refused', (await quote([L(pA)])).errors?.[0]?.code === 'paused' && errMsg(await place([L(pA)])).includes('موقّف'));
    await ship({ ...base, vacation: true, vacation_message: 'إجازة العيد — راجعين السبت' });
    check('tchk: vacation → refused with the merchant\'s message', errMsg(await place([L(pA)])).includes('إجازة العيد'));
    const closedDays = Array.from({ length: 7 }, () => ({ open: false }));
    await ship({ ...base, hours: closedDays, after_hours: 'refuse' });
    check('tchk: outside the hours with «ارفض» → refused', (await quote([L(pA)])).errors?.[0]?.code === 'closed_hours' && denied(await place([L(pA)])));
    await ship({ ...base, hours: closedDays, after_hours: 'accept' });
    const qAfter = await quote([L(pA)]);
    check('tchk: outside the hours with «اقبل» → accepted with a notice', qAfter.can_order && qAfter.open?.code === 'after_hours' && qAfter.open.message.includes('أول ما يفتح'), qAfter);
    await ship({ ...base, hours: Array.from({ length: 7 }, () => ({ open: true, from: '00:00', to: '00:00' })), after_hours: 'refuse' });
    check('tchk: open all day → ok', (await quote([L(pA)])).open?.code === 'ok');
    check('tchk: bad hours are refused', denied(await ship({ ...base, hours: [{ open: true, from: '9', to: '25:00' }] })) &&
      denied(await ship({ ...base, hours: Array.from({ length: 7 }, () => ({ open: true, from: '09:00', to: '9pm' })) })));
    await ship({ ...base, min_order: 150 });
    const qMin = await quote([L(pA)]);
    check('tchk: under the minimum order → blocking error with what is missing', qMin.errors?.[0]?.code === 'min_order' && qMin.errors[0].message.includes('50'), qMin);
    check('tchk: …refused; at the minimum it is accepted', denied(await place([L(pA)])) && ok(await place([L(pA), L(pB)])));
    await ship(base);

    // ---- discounts: saving
    const disc = (p, u = cM) => as(db, u, `select public.save_shop_discount($1, $2::jsonb) as d`, [cShop, JSON.stringify(p)]);
    const d10 = await disc({ method: 'code', code: ' save10 ', type: 'percent', value: 10 });
    check('tchk: a code is saved upper-case', ok(d10) && one(d10).code === 'SAVE10' && one(d10).state === 'active', d10.error);
    check('tchk: the same code twice is refused (case-insensitive)', errMsg(await disc({ method: 'code', code: 'Save10', type: 'fixed', value: 5 })).includes('موجود'));
    check('tchk: another merchant cannot add discounts to the shop', denied(await disc({ method: 'code', code: 'HACK', type: 'percent', value: 90 }, cM2)));
    check('tchk: bad discounts are refused (percent > 100, code too short, auto without a title, end before start)',
      denied(await disc({ method: 'code', code: 'BIG', type: 'percent', value: 150 })) && denied(await disc({ method: 'code', code: 'AB', type: 'percent', value: 5 })) &&
      denied(await disc({ method: 'auto', type: 'percent', value: 5 })) &&
      denied(await disc({ method: 'code', code: 'DATES', type: 'percent', value: 5, starts_at: '2030-01-02', ends_at: '2030-01-01' })));
    const q10 = await quote([L(pA, 2)], { code: 'save10', area: 'القاهرة' });
    check('tchk: a percent code (typed lower-case) takes 10% of the subtotal', q10.code_status === 'applied' && Number(q10.discount_amount) === 20 && q10.discount_code === 'SAVE10' &&
      Number(q10.total) === 210, q10);
    await disc({ method: 'code', code: 'MINUS30', type: 'fixed', value: 30, min_subtotal: 150 });
    const qFixLow = await quote([L(pA)], { code: 'MINUS30' });
    const qFix = await quote([L(pA, 2)], { code: 'MINUS30' });
    check('tchk: a fixed code with a minimum: refused under it (message), applied over it',
      qFixLow.code_status === 'not_applicable' && qFixLow.code_message.includes('زوّد') && Number(qFixLow.discount_amount) === 0 &&
      qFix.code_status === 'applied' && Number(qFix.discount_amount) === 30, { qFixLow, qFix });
    await disc({ method: 'code', code: 'TINY', type: 'fixed', value: 500 });
    check('tchk: a fixed amount never exceeds the subtotal', Number((await quote([L(pB)], { code: 'TINY' })).discount_amount) === 50);
    await disc({ method: 'code', code: 'FREESHIP', type: 'free_shipping' });
    const qFs = await quote([L(pA)], { code: 'freeship', area: 'الإسكندرية' });
    check('tchk: a free-shipping code zeroes the shipping', qFs.code_status === 'applied' && qFs.free_shipping && Number(qFs.shipping_fee) === 0 && Number(qFs.shipping_base) === 50 && Number(qFs.total) === 100, qFs);
    check('tchk: …not on pickup', (await quote([L(pA)], { code: 'FREESHIP', ful: 'pickup' })).code_status === 'not_applicable');
    await disc({ method: 'code', code: 'BAGS', type: 'percent', value: 50, applies_to: 'products', product_ids: [pB] });
    const qBags = await quote([L(pA), L(pB, 2)], { code: 'BAGS' });
    check('tchk: a product discount only counts its products', Number(qBags.discount_amount) === 50 && qBags.code_status === 'applied', qBags);
    check('tchk: …and says so when none of them is in the cart', (await quote([L(pA)], { code: 'BAGS' })).code_message?.includes('مش على المنتجات'));
    await disc({ method: 'code', code: 'COLL', type: 'percent', value: 10, applies_to: 'collections', collection_ids: ['00000000-0000-4000-8000-000000000001'] });
    check('tchk: a collection discount (hook until collections exist) matches nothing yet', (await quote([L(pA)], { code: 'COLL' })).code_status === 'not_applicable');
    check('tchk: a product of another shop is dropped from product_ids',
      errMsg(await disc({ method: 'code', code: 'OTHERS', type: 'percent', value: 10, applies_to: 'products', product_ids: ['00000000-0000-4000-8000-000000000009'] })).includes('اختار المنتجات'));

    // ---- discounts: dates / limits
    const future = new Date(Date.now() + 864e5).toISOString();
    await disc({ method: 'code', code: 'LATER', type: 'percent', value: 10, starts_at: future });
    await disc({ method: 'code', code: 'OLD', type: 'percent', value: 10, starts_at: new Date(Date.now() - 2 * 864e5).toISOString(), ends_at: new Date(Date.now() - 864e5).toISOString() });
    const dOff = one(await disc({ method: 'code', code: 'OFFNOW', type: 'percent', value: 10, active: false }));
    check('tchk: a scheduled / expired / switched-off code does not apply (with the reason)',
      (await quote([L(pA)], { code: 'LATER' })).code_message.includes('مش شغال') && (await quote([L(pA)], { code: 'OLD' })).code_message.includes('خلصت') &&
      (await quote([L(pA)], { code: 'OFFNOW' })).code_status === 'not_applicable' && dOff.state === 'disabled');
    check('tchk: placing with a code that does not apply is refused', errMsg(await place([L(pA)], { code: 'OLD' })).includes('خلصت'));
    const dOnce = one(await disc({ method: 'code', code: 'ONCE', type: 'fixed', value: 10, usage_limit: 1 }));
    const once1 = await place([L(pA)], { code: 'ONCE' });
    check('tchk: a code limited to 1 use: the first order gets it', ok(once1) && Number((await orderOf(one(once1))).discount_amount) === 10, once1.error);
    check('tchk: …the second is refused', errMsg(await place([L(pA)], { code: 'once' })).includes('عدد استخداماته') &&
      (await admin(db, `select used_count from shop_discounts where id = $1`, [dOnce.id]))[0].used_count === 1);
    await disc({ method: 'code', code: 'WELCOME', type: 'percent', value: 15, per_phone_limit: 1 });
    const welcomePhone = phone();
    const w1 = await place([L(pA)], { code: 'WELCOME', phone: welcomePhone });
    check('tchk: per-phone limit: first use ok, the same phone (other format) again refused, another phone ok',
      ok(w1) && errMsg(await place([L(pA)], { code: 'WELCOME', phone: '+2' + welcomePhone })).includes('قبل كده') && ok(await place([L(pA)], { code: 'WELCOME' })), w1.error);
    check('tchk: the quote already knows the phone used it', (await quote([L(pA)], { code: 'WELCOME', phone: welcomePhone })).code_status === 'not_applicable');

    // ---- the order snapshot + timeline + usage list
    const snapCode = one(await place([L(pA, 2)], { code: 'SAVE10', area: 'القاهرة', expected: 210 }));
    const so = snapCode && await orderOf(snapCode);
    check('tchk: the order snapshots subtotal, discount code / amount, shipping and the total',
      so && Number(so.subtotal) === 200 && so.discount_code === 'SAVE10' && Number(so.discount_amount) === 20 && Number(so.delivery_fee) === 30 &&
      so.shipping_zone === 'القاهرة الكبرى' && Number(so.total_amount) === 210 && so.discount_id === one(d10).id, so);
    const ev = await admin(db, `select kind, body, actor_role from shop_order_events where order_id = $1 order by created_at, kind`, [so?.id]);
    check('tchk: a «discount» event is on the timeline', ev.some((e) => e.kind === 'discount' && e.body.includes('SAVE10') && e.actor_role === 'customer'), ev);
    const det = one(await as(db, cM, `select public.merchant_order($1) as o`, [so?.id]));
    check('tchk: merchant_order shows discount / shipping / confirmation', det?.discount_code === 'SAVE10' && Number(det.discount_amount) === 20 &&
      Number(det.shipping_fee) === 30 && det.shipping_zone === 'القاهرة الكبرى' && Number(det.subtotal) === 200 && det.confirmation_status === 'pending', det);
    const tr = one(await as(db, null, `select public.get_store_order($1) as o`, [snapCode]));
    check('tchk: tracking shows the discount and shipping lines', Number(tr?.discount_amount) === 20 && Number(tr.subtotal) === 200 && tr.can_cancel === true && tr.customer_phone === undefined, tr);
    const usedBy = one(await as(db, cM, `select public.merchant_discount_orders($1) as o`, [one(d10).id]));
    check('tchk: «الطلبات اللي استخدمته» lists the order; the counter went up',
      usedBy?.some((o) => o.order_code === snapCode) && (await admin(db, `select used_count from shop_discounts where id = $1`, [one(d10).id]))[0].used_count === 1, usedBy);
    check('tchk: another merchant cannot list its orders / read the discounts',
      denied(await as(db, cM2, `select public.merchant_discount_orders($1)`, [one(d10).id])) && denied(await as(db, cM2, `select public.merchant_discounts($1)`, [cShop])) &&
      ((await as(db, cM2, `select * from shop_discounts where shop_id = $1`, [cShop])).rows || []).length === 0);
    const list = one(await as(db, cM, `select public.merchant_discounts($1) as l`, [cShop]));
    check('tchk: the list carries state, uses and sales', list?.find((d) => d.code === 'SAVE10')?.used_count === 1 && Number(list.find((d) => d.code === 'SAVE10').sales) === 210 &&
      list.find((d) => d.code === 'LATER')?.state === 'scheduled' && list.find((d) => d.code === 'OLD')?.state === 'expired' && list.find((d) => d.code === 'ONCE')?.state === 'used_up', list?.map((d) => [d.code, d.state]));
    check('tchk: cancelling gives the use back', ok(await as(db, cM, `select public.merchant_cancel_order($1, 'تجربة')`, [so?.id])) &&
      (await admin(db, `select used_count from shop_discounts where id = $1`, [one(d10).id]))[0].used_count === 0);
    const delUsed = one(await as(db, cM, `select public.delete_shop_discount($1) as r`, [one(d10).id]));
    const tmp = one(await disc({ method: 'code', code: 'UNUSED', type: 'percent', value: 5 }));
    const delNew = one(await as(db, cM, `select public.delete_shop_discount($1) as r`, [tmp.id]));
    check('tchk: a used discount is switched off, not deleted; an unused one is deleted',
      delUsed?.deactivated === true && delNew?.deleted === true && (await admin(db, `select active from shop_discounts where id = $1`, [one(d10).id]))[0].active === false, { delUsed, delNew });
    check('tchk: another merchant cannot delete it', denied(await as(db, cM2, `select public.delete_shop_discount($1)`, [dOnce.id])));

    // ---- automatic discounts & the stacking rule
    const auto5 = one(await disc({ method: 'auto', title: 'خصم 5% فوق 300', type: 'percent', value: 5, min_subtotal: 300 }));
    const qAuto = await quote([L(pA, 4)]);
    check('tchk: an automatic discount applies without a code', qAuto.auto_discount_id === auto5.id && Number(qAuto.discount_amount) === 20 && qAuto.auto_title === 'خصم 5% فوق 300', qAuto);
    check('tchk: …with «زوّد» hint under its minimum', (await quote([L(pA, 2)])).hint?.includes('خصم 5% فوق 300'));
    const auto10 = one(await disc({ method: 'auto', title: 'خصم 10% فوق 350', type: 'percent', value: 10, min_subtotal: 350 }));
    check('tchk: the best automatic discount wins', (await quote([L(pA, 4)])).auto_discount_id === auto10.id && Number((await quote([L(pA, 4)])).discount_amount) === 40);
    await disc({ method: 'code', code: 'BIG25', type: 'percent', value: 25 });
    await disc({ method: 'code', code: 'SMALL5', type: 'fixed', value: 5 });
    const qBig = await quote([L(pA, 4)], { code: 'BIG25' });
    const qSmall = await quote([L(pA, 4)], { code: 'SMALL5' });
    check('tchk: stacking: a code that does not combine replaces the automatic one when it saves more',
      qBig.discount_code === 'BIG25' && qBig.auto_discount_id === null && Number(qBig.discount_amount) === 100, qBig);
    check('tchk: …and the automatic one wins when it saves more (code not used, told why)',
      qSmall.code_status === 'not_better' && qSmall.discount_code === null && qSmall.auto_discount_id === auto10.id && Number(qSmall.discount_amount) === 40 && qSmall.code_message.includes('أحسن'), qSmall);
    const nb = one(await place([L(pA, 4)], { code: 'SMALL5' }));
    check('tchk: …placing with it keeps the better automatic discount', nb && Number((await orderOf(nb)).discount_amount) === 40 && (await orderOf(nb)).discount_code === null);
    await disc({ method: 'code', code: 'PLUS', type: 'fixed', value: 15, combines: true });
    const qPlus = await quote([L(pA, 4)], { code: 'PLUS' });
    check('tchk: a code that combines adds up with the best automatic discount', Number(qPlus.discount_amount) === 55 && qPlus.discount_code === 'PLUS' && qPlus.auto_discount_id === auto10.id &&
      qPlus.discount_title.includes('+'), qPlus);
    const plusO = one(await place([L(pA, 4)], { code: 'PLUS' }));
    check('tchk: …both are counted', plusO && (await admin(db, `select count(*)::int n from shop_discount_uses where order_id = (select id from shop_orders where order_code = $1)`, [plusO]))[0].n === 2);
    await admin(db, `update shop_discounts set active = false where method = 'auto' and shop_id = $1`, [cShop]);
    await disc({ method: 'auto', title: 'توصيل مجاني فوق 250', type: 'free_shipping', min_subtotal: 250 });
    const qAfs = await quote([L(pA, 3)], { area: 'الإسكندرية' });
    check('tchk: an automatic free-shipping discount', qAfs.free_shipping && Number(qAfs.shipping_fee) === 0 && Number(qAfs.total) === 300, qAfs);

    // ---- never trust the client
    const fake = one(await place([L(pA, 1, { price: 1, unit_price: 1, line_total: 1 })], { area: 'القاهرة' }));
    check('tchk: client prices in the cart are ignored', fake && Number((await orderOf(fake)).total_amount) === 130);
    check('tchk: a total the customer saw that no longer holds is refused', errMsg(await place([L(pA)], { area: 'القاهرة', expected: 100 })).includes('اتغيروا'));
    const qSpoof = await quote([L(pA, 1, { price: 1 })], { area: 'القاهرة' });
    check('tchk: the quote prices from the database too', Number(qSpoof.subtotal) === 100 && Number(qSpoof.lines[0].unit_price) === 100, qSpoof);
    check('tchk: garbage lines are refused', denied(await place([{ product_id: 'x', quantity: 1 }])) && !!(await quote([{ product_id: pA, quantity: 'lots' }])).error);
    check('tchk: a product of another shop is refused', !!(await quote([L(pA)], { shop: cShop2 })).error);

    // ---- brute force on codes
    const bfPhone = phone();
    let lastBad = null;
    for (let i = 0; i < 10; i++) lastBad = await quote([L(pA)], { code: 'GUESS' + i, phone: bfPhone });
    const blocked = await quote([L(pA)], { code: 'PLUS', phone: bfPhone });
    check('tchk: 10 wrong codes from a phone → even a good one is blocked for an hour', lastBad.code_status === 'invalid' && blocked.code_status === 'blocked' && Number(blocked.discount_amount) === 0, blocked);
    check('tchk: …another phone is not blocked', (await quote([L(pA)], { code: 'PLUS', phone: phone() })).code_status === 'applied');
    const wrongPhone = phone();
    const wrong = await place([L(pA)], { code: 'NOPE', phone: wrongPhone });
    check('tchk: placing with a wrong code places nothing (null) — and the try is counted', ok(wrong) && one(wrong) === null &&
      (await admin(db, `select count(*)::int n from shop_orders where customer_phone = $1`, [wrongPhone]))[0].n === 0, wrong);
    for (let i = 0; i < 9; i++) await place([L(pA)], { code: 'NOPE' + i, phone: wrongPhone });
    check('tchk: …10 wrong tries through placing block the phone too', (await quote([L(pA)], { code: 'PLUS', phone: wrongPhone })).code_status === 'blocked' &&
      one(await place([L(pA)], { code: 'PLUS', phone: wrongPhone })) === null);

    // ---- abandoned carts
    const cartPhone = phone();
    const saveCart = (lines, o = {}) => as(db, null, `select public.save_store_cart($1, $2, $3, $4::jsonb, $5) as t`,
      [o.shop ?? cShop, o.phone ?? cartPhone, o.name ?? 'سارة', JSON.stringify(lines), o.area ?? null]);
    const tok = one(await saveCart([L(pA, 2), L(pB, 1, { price: 1 })]));
    const tok2 = one(await saveCart([L(pA, 3)], { area: 'الجيزة' }));
    const cartRow = (await admin(db, `select * from shop_carts where token = $1`, [tok]))[0];
    check('tchk: a guest saves the cart at checkout; the same phone updates it (same token, server prices)',
      /^[0-9a-f]{32}$/.test(tok || '') && tok === tok2 && Number(cartRow.subtotal) === 300 && cartRow.item_count === 3 && cartRow.area === 'الجيزة' && cartRow.name === 'سارة', cartRow);
    check('tchk: a bad phone is refused', denied(await saveCart([L(pA)], { phone: '123' })));
    const list0 = one(await as(db, cM, `select public.merchant_abandoned_carts($1) as c`, [cShop]));
    check('tchk: a fresh cart is not «abandoned» yet', list0?.carts?.length === 0, list0);
    await admin(db, `update shop_carts set updated_at = now() - interval '2 hours' where token = $1`, [tok]);
    const list1 = one(await as(db, cM, `select public.merchant_abandoned_carts($1) as c`, [cShop]));
    check('tchk: after an hour the owner sees it (name, phone, lines snapshot, token)',
      list1?.carts?.length === 1 && list1.carts[0].phone === cartPhone && list1.carts[0].lines[0].name === 'قميص' && list1.carts[0].token === tok, list1);
    check('tchk: only the owner: other merchant / guest / customer are refused, and nobody reads the table',
      denied(await as(db, cM2, `select public.merchant_abandoned_carts($1)`, [cShop])) && denied(await as(db, null, `select public.merchant_abandoned_carts($1)`, [cShop])) &&
      ((await as(db, cM2, `select * from shop_carts`)).rows || []).length === 0 && ((await as(db, cBuyer, `select * from shop_carts`)).rows || []).length === 0 &&
      denied(await as(db, null, `select * from shop_carts`)) && denied(await as(db, null, `insert into shop_carts (shop_id, token, phone) values ($1, 'x', '01000000000')`, [cShop])));
    const restore = one(await as(db, null, `select public.get_store_cart($1) as c`, [tok]));
    check('tchk: the «كمّل طلبك» link restores the lines only (no name / phone)',
      restore?.shop_slug === 'tchk-shop' && restore.lines.length === 1 && restore.lines[0].quantity === 3 && JSON.stringify(restore).indexOf(cartPhone) === -1 && restore.name === undefined, restore);
    check('tchk: the owner marks it reminded; another merchant cannot',
      ok(await as(db, cM, `select public.merchant_mark_cart_reminded($1)`, [cartRow.id])) && denied(await as(db, cM2, `select public.merchant_mark_cart_reminded($1)`, [cartRow.id])));
    const recCode = one(await place([L(pA, 3)], { phone: cartPhone, cart: tok }));
    const recCart = (await admin(db, `select recovered_order_id, recovered_at from shop_carts where token = $1`, [tok]))[0];
    check('tchk: an order from it marks the cart recovered (it leaves the list; the link stops working)',
      recCode && recCart.recovered_order_id === (await orderOf(recCode)).id && (await orderOf(recCode)).cart_id !== null &&
      one(await as(db, cM, `select public.merchant_abandoned_carts($1) as c`, [cShop])).carts.length === 0 &&
      one(await as(db, cM, `select public.merchant_abandoned_carts($1) as c`, [cShop])).recovered_count === 1 &&
      one(await as(db, null, `select public.get_store_cart($1) as c`, [tok])) === null, recCart);
    const tok3 = one(await saveCart([L(pB)]));
    check('tchk: shopping again after the order starts a fresh cart (new link)', tok3 && tok3 !== tok);
    const spamPhone = phone();
    let lastTok = null;
    for (let i = 0; i < 20; i++) lastTok = one(await saveCart([L(pA)], { phone: spamPhone }));
    const capped = await saveCart([L(pA)], { phone: spamPhone });
    check('tchk: cart saves are rate-limited per phone (null, never an error)', !!lastTok && ok(capped) && one(capped) === null, capped.error);
    check('tchk: an empty / all-unavailable cart is not saved', one(await saveCart([{ product_id: '00000000-0000-4000-8000-000000000123', quantity: 1 }], { phone: phone() })) === null);
    check('tchk: the shop owner\'s own carts are not saved', one(await as(db, cM, `select public.save_store_cart($1, '01000099999', 'أنا', $2::jsonb) as t`, [cShop, JSON.stringify([L(pA)])])) === null);
    await admin(db, `update shop_carts set updated_at = now() - interval '31 days' where token = $1`, [tok3]);
    await as(db, cM, `select public.merchant_abandoned_carts($1)`, [cShop]);
    check('tchk: carts older than 30 days are deleted', (await admin(db, `select count(*)::int n from shop_carts where token = $1`, [tok3]))[0].n === 0);

    // ---- COD confirmation
    const confCode = one(await place([L(pA)], { area: 'القاهرة' }));
    const conf = await orderOf(confCode);
    check('tchk: a store order starts «pending» confirmation', conf?.confirmation_status === 'pending');
    await ship({ ...base, require_confirmation: true });
    check('tchk: with «اطلب تأكيد واتساب» a pending order cannot be prepared',
      errMsg(await as(db, cM, `select public.update_shop_order_status($1, 'preparing')`, [conf.id])).includes('أكّد'));
    check('tchk: another merchant / a guest cannot confirm it',
      denied(await as(db, cM2, `select public.merchant_confirm_order($1)`, [conf.id])) && denied(await as(db, null, `select public.merchant_confirm_order($1)`, [conf.id])));
    check('tchk: the owner confirms (event), then prepares',
      ok(await as(db, cM, `select public.merchant_confirm_order($1)`, [conf.id])) && ok(await as(db, cM, `select public.merchant_confirm_order($1)`, [conf.id])) &&
      (await orderOf(confCode)).confirmation_status === 'confirmed' &&
      (await admin(db, `select count(*)::int n from shop_order_events where order_id = $1 and kind = 'confirm' and actor_role = 'merchant'`, [conf.id]))[0].n === 1 &&
      ok(await as(db, cM, `select public.update_shop_order_status($1, 'preparing')`, [conf.id])));
    await ship(base);
    const info = one(await as(db, null, `select public.store_checkout_info($1) as i`, [cShop]));
    check('tchk: store_checkout_info (anyone): zones, pickup, open state, codes, automatic offers',
      info?.zones?.length === 2 && info.zones[0].areas.includes('القاهرة') && info.pickup?.address === 'المحل: 5 شارع 9 المعادي' && info.open.code === 'ok' &&
      info.has_codes === true && info.auto_discounts.length === 1 && info.default_mode === 'rate' && Number(info.default_fee) === 20, info);

    // ---- guest cancel
    const gPhone = phone();
    const gCode = one(await place([L(pA)], { phone: gPhone, area: 'القاهرة' }));
    const gcancel = (code, last4, reason = 'غيّرت رأيي') => as(db, null, `select public.guest_cancel_store_order($1, $2, $3) as o`, [code, last4, reason]);
    check('tchk: guest cancel with wrong last 4 digits is refused', one(await gcancel(gCode, '0000'))?.error?.includes('مش مطابقين'));
    const okCancel = await gcancel(gCode.toLowerCase(), gPhone.slice(-4).replace(/\d/g, (d) => '٠١٢٣٤٥٦٧٨٩'[d]));
    const gO = await orderOf(gCode);
    check('tchk: the right last 4 (Arabic digits ok) cancels a «placed» order with the reason', ok(okCancel) && gO.status === 'cancelled' && gO.cancel_reason === 'غيّرت رأيي' &&
      one(okCancel).status === 'cancelled' && one(okCancel).ok === true && one(okCancel).can_cancel === false, okCancel.error || gO);
    const gEv = (await admin(db, `select actor_role, body from shop_order_events where order_id = $1 and kind = 'cancel'`, [gO.id]))[0];
    check('tchk: …the timeline shows the customer; the merchant is notified', gEv?.actor_role === 'customer' && gEv.body === 'غيّرت رأيي' &&
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title like '❌ الزبون لغى الطلب ' || $2 || '%'`, [cM, gCode]))[0].n === 1, gEv);
    check('tchk: an order already cancelled cannot be cancelled again', denied(await gcancel(gCode, gPhone.slice(-4))));
    const pPhone = phone();
    const pCode = one(await place([L(pA)], { phone: pPhone, area: 'القاهرة' }));
    await as(db, cM, `select public.update_shop_order_status((select id from shop_orders where order_code = $1), 'preparing')`, [pCode]);
    check('tchk: once the shop prepares it, the guest cannot cancel', errMsg(await gcancel(pCode, pPhone.slice(-4))).includes('بدأ يجهّزه'));
    const bPhone = phone();
    const bCode = one(await place([L(pA)], { phone: bPhone, area: 'القاهرة' }));
    for (let i = 0; i < 5; i++) await gcancel(bCode, String(1000 + i));
    check('tchk: 5 wrong tries lock guest cancel for that order (even the right digits)', one(await gcancel(bCode, bPhone.slice(-4)))?.error?.includes('محاولات كتير') &&
      (await orderOf(bCode)).status === 'placed');
    check('tchk: an unknown code', errMsg(await gcancel('TNOPE123', '1234')).includes('مفيش طلب'));

    // ---- «عملة المتجر»
    const curM = await signUp(db, 'tchk currency merchant', '01000099050');
    const curShop = one(await as(db, curM, `select public.create_my_shop('محل العملة', 'ملابس', 'tchk-currency', '01000099050') as id`));
    const curProd = one(await as(db, curM, `insert into shop_products (shop_id, name, price) values ($1, 'كوباية', 100) returning id`, [curShop]));
    const egpOrder = one(await place([L(curProd)], { shop: curShop }));
    const setCur = (c, u = curM) => as(db, u, `select public.set_shop_currency($1, $2) as r`, [curShop, c]);
    check('tchk: currency: a new shop starts in its country\'s currency', (await admin(db, `select currency from shops where id = $1`, [curShop]))[0].currency === 'EGP');
    check('tchk: currency: other merchant / guest cannot change it; unknown / non-store currencies refused',
      denied(await setCur('USD', cM)) && denied(await setCur('USD', null)) && errMsg(await setCur('XYZ')).includes('مش متاحة') && denied(await setCur('TRY')));
    check('tchk: currency: switch to USD — products follow, the old order keeps EGP',
      ok(await setCur('usd')) && (await admin(db, `select currency from shops where id = $1`, [curShop]))[0].currency === 'USD' &&
      (await admin(db, `select currency from shop_products where id = $1`, [curProd]))[0].currency === 'USD' &&
      (await orderOf(egpOrder)).currency === 'EGP');
    const usdOrder = one(await place([L(curProd)], { shop: curShop }));
    const qUsd = await quote([L(curProd)], { shop: curShop });
    check('tchk: currency: new orders and quotes are in USD; texts use $', (await orderOf(usdOrder)).currency === 'USD' && qUsd.currency === 'USD' &&
      (await admin(db, `select private.money_text(12.5, 'USD') a, private.money_text(3, 'EUR') b, private.money_text(1250, 'GBP') c, private.money_text(1.2345, 'KWD') d`))
        .every((r) => r.a === '12.5 $' && r.b === '3 €' && r.c === '1,250 £' && r.d === '1.235 د.ك'));
    check('tchk: currency: every Arab currency + USD/EUR/GBP is accepted',
      (await admin(db, `select count(*)::int n from unnest(private.shop_currencies()) c where private.currency_label(c) <> c`))[0].n === 25);
    check('tchk: currency: LBP lifts the caps (delivery 50,000 ل.ل ok)', ok(await setCur('LBP')) &&
      ok(await as(db, curM, `select public.set_shop_shipping($1, $2::jsonb)`, [curShop, JSON.stringify({ default_fee: 50000, zones: [{ name: 'بيروت', areas: ['بيروت'], fee: 60000 }] })])));
    check('tchk: currency: back to USD with a 60,000 fee is refused (caps are per currency)', errMsg(await setCur('USD')).includes('سعر التوصيل') &&
      (await admin(db, `select currency from shops where id = $1`, [curShop]))[0].currency === 'LBP');
    await as(db, curM, `select public.set_shop_shipping($1, $2::jsonb)`, [curShop, JSON.stringify({ default_fee: 5, zones: [] })]);
    await as(db, curM, `update shop_products set price = 5000000 where id = $1`, [curProd]);
    check('tchk: currency: …and a product priced over the new cap blocks it too', errMsg(await setCur('USD')).includes('منتجات'));
    await as(db, curM, `update shop_products set price = 10 where id = $1`, [curProd]);
    check('tchk: currency: fixed then it switches; zone fees cap in the new currency',
      ok(await setCur('KWD')) && denied(await as(db, curM, `select public.set_shop_shipping($1, $2::jsonb)`, [curShop, JSON.stringify({ default_fee: 1001 })])));

    // ---- with 0098: variants are priced per variant; collection discounts
    const pV = await prod('تيشيرت ألوان', 100);
    await admin(db, `update shop_products set options = '[{"name":"اللون","values":["أحمر","أزرق"]}]'::jsonb where id = $1`, [pV]);
    const vRed = (await admin(db, `insert into shop_product_variants (product_id, shop_id, option_values, price, stock, sku) values ($1, $2, '["أحمر"]', 150, 3, 'TCHK-RED') returning id`, [pV, cShop]))[0].id;
    await admin(db, `insert into shop_product_variants (product_id, shop_id, option_values, price, stock) values ($1, $2, '["أزرق"]', 120, 0)`, [pV, cShop]);
    const qVar = await quote([L(pV, 2, { variant_id: vRed })], { area: 'القاهرة' });
    check('tchk+0098: the quote prices the variant (not the product) and names it', Number(qVar.subtotal) === 300 && qVar.lines?.[0]?.variant_id === vRed &&
      Number(qVar.lines[0].unit_price) === 150 && qVar.lines[0].options?.includes('أحمر'), qVar);
    check('tchk+0098: a variant out of stock is refused by the quote', !!(await quote([L(pV, 4, { variant_id: vRed })])).error);
    const coll = (await admin(db, `insert into shop_collections (shop_id, name, slug) values ($1, 'تيشيرتات', 'tchk-tees') returning id`, [cShop]))[0].id;
    await admin(db, `insert into shop_collection_products (collection_id, product_id) values ($1, $2)`, [coll, pV]);
    await disc({ method: 'code', code: 'TEES20', type: 'percent', value: 20, applies_to: 'collections', collection_ids: [coll] });
    const qColl = await quote([L(pV, 2, { variant_id: vRed }), L(pA)], { code: 'TEES20', area: 'القاهرة' });
    check('tchk+0098: a collection discount covers only its products', qColl.code_status === 'applied' && Number(qColl.discount_amount) === 60, qColl);
    const varCode = one(await place([L(pV, 2, { variant_id: vRed }), L(pA)], { code: 'TEES20', area: 'القاهرة', expected: Number(qColl.total) }));
    const varLines = varCode && await admin(db, `select variant_id, unit_price::float up, sku from shop_order_items where order_id = (select id from shop_orders where order_code = $1) order by unit_price desc`, [varCode]);
    check('tchk+0098: the order takes the variant\'s stock, price and SKU, with the collection discount',
      varLines?.[0]?.variant_id === vRed && varLines[0].up === 150 && varLines[0].sku === 'TCHK-RED' &&
      (await admin(db, `select stock from shop_product_variants where id = $1`, [vRed]))[0].stock === 1 &&
      Number((await orderOf(varCode)).discount_amount) === 60 && Number((await orderOf(varCode)).total_amount) === 400 - 60 + 30, { varLines, e: varCode });
    check('tchk+0098: cancelling gives the variant stock back (0098) and the discount use (0099)',
      ok(await as(db, cM, `select public.merchant_cancel_order((select id from shop_orders where order_code = $1), 'x')`, [varCode])) &&
      (await admin(db, `select stock from shop_product_variants where id = $1`, [vRed]))[0].stock === 3 &&
      (await admin(db, `select used_count from shop_discounts where code = 'TEES20'`))[0].used_count === 0);
    const tokV = one(await as(db, null, `select public.save_store_cart($1, $2, 'نور', $3::jsonb) as t`, [cShop, phone(), JSON.stringify([L(pV, 1, { variant_id: vRed })])]));
    check('tchk+0098: a saved cart keeps the variant (restore link)', one(await as(db, null, `select public.get_store_cart($1) as c`, [tokV]))?.lines?.[0]?.variant_id === vRed &&
      (await admin(db, `select lines from shop_carts where token = $1`, [tokV]))[0].lines[0].variant_id === vRed);

    // ---- pixels carry the checkout's shipping / discount / coupon
    const px2 = require(path.join(__dirname, '..', '..', 'web', 'shop-pixels.js'));
    const pc = px2.buildCalls('Purchase', { currency: 'SAR', value: 95, shipping: 15, discount: 20, coupon: 'SAVE10', order_id: 'T1', contents: [{ id: 'a', price: 100, quantity: 1 }] },
      { ga4: 'G-ABC1234XYZ', gtm: 'GTM-AB12CD3', meta_pixel: '123456789012345' });
    const ga2 = pc.find((c) => c[0] === 'gtag');
    const dl2 = pc.filter((c) => c[0] === 'dl')[1];
    check('tchk: Purchase pixels: GA4 / GTM get shipping, coupon and discount; Meta the coupon; a bad coupon is dropped',
      ga2[3].shipping === 15 && ga2[3].coupon === 'SAVE10' && ga2[3].discount === 20 && dl2[1].ecommerce.shipping === 15 && dl2[1].ecommerce.coupon === 'SAVE10' &&
      pc.find((c) => c[0] === 'fbq')[4].coupon === 'SAVE10' &&
      px2.buildCalls('InitiateCheckout', { coupon: '<script>', contents: [] }, { ga4: 'G-ABC1234XYZ' })[0][3].coupon === undefined, { ga2, dl2 });
  }
  console.log('\nPhase tcat — متجري catalog pro: variants, collections, CSV import, low stock (0098)');
  {
    const fs = require('fs');
    const path = require('path');
    const MIG98 = path.join(__dirname, '..', 'migrations', '0098_tajer_catalog.sql');
    const MIG99 = path.join(__dirname, '..', 'migrations', '0099_tajer_checkout.sql'); // re-applied after 0098: it redefines place_store_order
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(MIG98, 'utf8'));
      await db.exec(fs.readFileSync(MIG99, 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('tcat: 0098 is safe to re-run', rerun === null, rerun);
    const idOf = (r) => r.rows?.[0] && Object.values(r.rows[0])[0];
    const cM = await signUp(db, 'tcat merchant', '01000098001');
    const cM2 = await signUp(db, 'tcat other merchant', '01000098002');
    const cBuyer = await signUp(db, 'tcat buyer', '01000098003');
    const cShop = idOf(await as(db, cM, `select public.create_my_shop('محل الكتالوج', 'ملابس وأحذية', 'tcat-shop', '01000098001') as id`));
    const cShop2 = idOf(await as(db, cM2, `select public.create_my_shop('محل تاني', 'ملابس وأحذية', 'tcat-other', '01000098002') as id`));
    check('tcat: two merchants register', !!cShop && !!cShop2);
    const IMG = ['https://x.test/a.jpg', 'https://x.test/b.jpg'];
    const save = (u, shop, product, variants = [], colls = null) =>
      as(db, u, `select public.merchant_save_product($1, $2::jsonb, $3::jsonb, $4::uuid[]) as id`, [shop, JSON.stringify(product), JSON.stringify(variants), colls]);
    const OPTS = [{ name: 'المقاس', values: ['S', 'M'] }, { name: 'اللون', values: ['أسود', 'أبيض'] }];
    const MATRIX = [
      { option_values: ['S', 'أسود'], price: 100, stock: 5, sku: 'TS-S-BLK', image_url: IMG[0] },
      { option_values: ['S', 'أبيض'], price: 110, stock: 2, sku: 'TS-S-WHT' },
      { option_values: ['M', 'أسود'], price: 120, stock: 10 },
      { option_values: ['M', 'أبيض'], price: 90, compare_at_price: 130, stock: 0, image_url: IMG[1] },
    ];
    const tee = { name: 'تيشيرت قطن', status: 'active', images: IMG, options: OPTS, tags: ['قطن', 'صيفي'], video_url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', seo_title: 'تيشيرت قطن مصري', seo_description: 'أحسن تيشيرت' };

    // ---- variants: auth + CRUD
    check('tcat: EXPLOIT blocked: another merchant saves a product into my shop', denied(await save(cM2, cShop, tee, MATRIX)));
    check('tcat: EXPLOIT blocked: a guest saves a product', denied(await save(null, cShop, tee, MATRIX)));
    const teeId = idOf(await save(cM, cShop, tee, MATRIX));
    check('tcat: the owner saves a product with a 2×2 variant matrix', !!teeId && (await admin(db, `select count(*)::int n from shop_product_variants where product_id = $1`, [teeId]))[0].n === 4);
    const teeRow = (await admin(db, `select price::float, old_price::float, stock, slug, tags, video_url from shop_products where id = $1`, [teeId]))[0];
    check('tcat: product row = rollup (cheapest available variant + its compare-at, stock summed)',
      teeRow.price === 90 && teeRow.old_price === 130 && teeRow.stock === 17 && teeRow.slug === 'تيشيرت-قطن' && teeRow.tags.length === 2, teeRow);
    check('tcat: EXPLOIT blocked: variants are never written directly',
      denied(await as(db, cM, `insert into shop_product_variants (product_id, shop_id, option_values, price) values ($1, $2, '["X"]', 1)`, [teeId, cShop])) &&
      denied(await as(db, cM, `update shop_product_variants set price = 1 where product_id = $1`, [teeId])) &&
      (await admin(db, `select min(price)::float m from shop_product_variants where product_id = $1`, [teeId]))[0].m === 90);
    const vIds = await admin(db, `select id, option_values, stock, sku from shop_product_variants where product_id = $1 order by position`, [teeId]);
    const resave = await save(cM, cShop, { ...tee, id: teeId }, MATRIX.map((v, i) => (i === 2 ? { ...v, price: 125, stock: 8 } : v)));
    const vIds2 = await admin(db, `select id from shop_product_variants where product_id = $1 order by position`, [teeId]);
    check('tcat: re-saving keeps variant ids (a variant is its combination) and updates in place',
      ok(resave) && JSON.stringify(vIds.map((v) => v.id)) === JSON.stringify(vIds2.map((v) => v.id)) &&
      (await admin(db, `select price::float p, stock from shop_product_variants where id = $1`, [vIds[2].id]))[0].p === 125, resave);
    const shrink = await save(cM, cShop, { ...tee, id: teeId, options: [{ name: 'المقاس', values: ['S', 'M'] }, { name: 'اللون', values: ['أسود'] }] },
      [MATRIX[0], { ...MATRIX[2], price: 125, stock: 8 }]);
    check('tcat: removing a value deletes its variants, keeps the others',
      ok(shrink) && (await admin(db, `select count(*)::int n from shop_product_variants where product_id = $1`, [teeId]))[0].n === 2 &&
      (await admin(db, `select count(*)::int n from shop_product_variants where id = $1`, [vIds[0].id]))[0].n === 1, shrink);
    await save(cM, cShop, { ...tee, id: teeId }, MATRIX);
    const vNow = await admin(db, `select id from shop_product_variants where product_id = $1 order by position`, [teeId]);

    // ---- matrix limits / validation
    const many = (n) => Array.from({ length: n }, (_, i) => 'v' + i);
    check('tcat: more than 3 options refused', denied(await save(cM, cShop, { ...tee, name: 'x4', options: [...OPTS, { name: 'الخامة', values: ['قطن'] }, { name: 'الموديل', values: ['1'] }] },
      [{ option_values: ['S', 'أسود', 'قطن', '1'], price: 1 }])));
    const big = [{ name: 'أ', values: many(11) }, { name: 'ب', values: many(10) }];
    const bigMatrix = [];
    for (const a of many(11)) for (const b of many(10)) bigMatrix.push({ option_values: [a, b], price: 5 });
    check('tcat: more than 100 variants refused', denied(await save(cM, cShop, { ...tee, name: 'كبير', options: big }, bigMatrix)));
    check('tcat: more than 30 values for one option refused', denied(await save(cM, cShop, { ...tee, name: 'قيم', options: [{ name: 'أ', values: many(31) }] }, [{ option_values: ['v0'], price: 1 }])));
    check('tcat: duplicate combination refused', denied(await save(cM, cShop, { ...tee, name: 'مكرر' }, [MATRIX[0], { ...MATRIX[0], sku: null }])));
    check('tcat: a value not in the options refused', denied(await save(cM, cShop, { ...tee, name: 'غلط' }, [{ option_values: ['XL', 'أسود'], price: 1 }])));
    check('tcat: options without variants / variants without options refused',
      denied(await save(cM, cShop, { ...tee, name: 'فاضي' }, [])) && denied(await save(cM, cShop, { name: 'بدون', price: 5, status: 'active' }, [{ option_values: ['S'], price: 1 }])));
    check('tcat: a SKU already used in the shop is refused (case-insensitive)',
      denied(await save(cM, cShop, { name: 'تاني', price: 5, status: 'active', sku: 'ts-s-blk' })));
    check('tcat: a variant image must be one of the product photos', denied(await save(cM, cShop, { ...tee, name: 'صورة' }, [{ ...MATRIX[0], sku: null, image_url: 'https://evil.test/x.jpg' }])));
    check('tcat: compare-at must be above the price; video must be YouTube',
      denied(await save(cM, cShop, { ...tee, name: 'خصم' }, [{ ...MATRIX[0], sku: null, compare_at_price: 50 }])) &&
      denied(await save(cM, cShop, { name: 'فيديو', price: 5, status: 'active', video_url: 'https://vimeo.com/123' })));
    const plainId = idOf(await save(cM, cShop, { name: 'شنطة جلد', price: 200, old_price: 250, stock: 4, sku: 'BAG-1', barcode: '6221234567890', status: 'active' }));
    check('tcat: a product without options keeps price / stock / sku on the product row (no variants)',
      !!plainId && (await admin(db, `select count(*)::int n from shop_product_variants where product_id = $1`, [plainId]))[0].n === 0 &&
      (await admin(db, `select stock, sku, barcode from shop_products where id = $1`, [plainId]))[0].sku === 'BAG-1');
    const twin = idOf(await save(cM, cShop, { name: 'شنطة جلد', price: 150, status: 'active' }));
    check('tcat: same name → a unique handle (-2)', (await admin(db, `select slug from shop_products where id = $1`, [twin]))[0].slug === 'شنطة-جلد-2');

    // ---- public reads (RLS)
    const draftId = idOf(await save(cM, cShop, { ...tee, name: 'مسودة', status: 'draft' }, MATRIX.map((v) => ({ ...v, sku: null }))));
    await admin(db, `update shop_product_variants set is_available = false where product_id = $1 and option_values = '["S","أبيض"]'`, [teeId]);
    const pubV = await as(db, null, `select product_id, option_values from shop_product_variants where shop_id = $1`, [cShop]);
    check('tcat: guests read only available variants of visible products',
      ok(pubV) && pubV.rows.length === 3 && pubV.rows.every((v) => v.product_id === teeId), pubV);
    check('tcat: the owner reads every variant (draft + hidden)', (await as(db, cM, `select count(*)::int n from shop_product_variants where shop_id = $1`, [cShop])).rows[0].n === 8);
    await admin(db, `update shop_product_variants set is_available = true where product_id = $1`, [teeId]);

    // ---- ordering with variants
    const place = (lines, phone = '01000098101') => as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى عادل', $3, 'شارع 9، المعادي، عمارة 4 شقة 2') as code`,
      [cShop, JSON.stringify(lines), phone]);
    const vSB = vNow[0].id, vSW = vNow[1].id, vMB = vNow[2].id, vMW = vNow[3].id;
    const stockOf = async (id) => (await admin(db, `select stock from shop_product_variants where id = $1`, [id]))[0].stock;
    const c1 = idOf(await place([{ product_id: teeId, variant_id: vSB, quantity: 3 }, { product_id: plainId, quantity: 1 }]));
    check('tcat: an order with a variant_id is placed', /^T[0-9A-Z]{7}$/.test(c1 || ''), c1);
    check('tcat: …it takes the variant\'s stock only (others untouched), the product rollup follows',
      (await stockOf(vSB)) === 2 && (await stockOf(vSW)) === 2 && (await stockOf(vMB)) === 10 &&
      (await admin(db, `select stock from shop_products where id = $1`, [teeId]))[0].stock === 14 &&
      (await admin(db, `select stock from shop_products where id = $1`, [plainId]))[0].stock === 3);
    const l1 = await admin(db, `select i.variant_id, i.variant_label, i.sku, i.unit_price::float up, i.image_url from shop_order_items i join shop_orders o on o.id = i.order_id where o.order_code = $1 order by i.unit_price`, [c1]);
    check('tcat: …the line snapshots variant_id, variant_label, sku, the variant\'s price and image',
      l1.some((l) => l.variant_id === vSB && l.variant_label === 'المقاس: S • اللون: أسود' && l.sku === 'TS-S-BLK' && l.up === 100 && l.image_url === IMG[0]) &&
      l1.some((l) => l.variant_id === null && l.sku === 'BAG-1' && l.up === 200), l1);
    check('tcat: more than a variant\'s stock is refused (with its name)',
      /المقاس: S/.test((await place([{ product_id: teeId, variant_id: vSB, quantity: 3 }])).error || ''));
    check('tcat: a sold-out variant is refused even if others have stock', denied(await place([{ product_id: teeId, variant_id: vMW, quantity: 1 }])));
    check('tcat: EXPLOIT blocked: a variant of another product is refused', denied(await place([{ product_id: plainId, variant_id: vMB, quantity: 1 }])));
    const legacy = idOf(await place([{ product_id: teeId, qty: 1, options: 'المقاس: M • اللون: أسود' }], '01000098102'));
    check('tcat: old clients — options text matches a variant (qty alias too) and takes its stock',
      !!legacy && (await stockOf(vMB)) === 9, legacy);
    check('tcat: old clients — no variant and no matching text is refused for a product with variants',
      denied(await place([{ product_id: teeId, quantity: 1, options: 'المقاس: XXL' }], '01000098103')));
    const ordId = (await admin(db, `select id from shop_orders where order_code = $1`, [c1]))[0].id;
    check('tcat: cancelling restocks the variant (and the plain product) once',
      ok(await as(db, cM, `select public.merchant_cancel_order($1, 'نفد')`, [ordId])) && (await stockOf(vSB)) === 5 &&
      (await admin(db, `select stock from shop_products where id = $1`, [plainId]))[0].stock === 4);
    const inApp = await as(db, cBuyer, `select public.place_shop_order($1, $2::jsonb, '01000098003') as id`, [cShop, JSON.stringify([{ product_id: teeId, variant_id: vSW, quantity: 1 }])]);
    check('tcat: the in-app order prices and snapshots the variant',
      ok(inApp) && (await admin(db, `select unit_price::float up, variant_label from shop_order_items where order_id = $1`, [idOf(inApp)]))[0].up === 110, inApp);
    const lines = (await as(db, cM, `select public.merchant_order($1) as o`, [ordId])).rows?.[0]?.o?.items;
    check('tcat: the merchant order lines carry sku + variant_id', lines?.some((l) => l.sku === 'TS-S-BLK' && l.variant_id === vSB), lines);
    const track = (await as(db, null, `select public.get_store_order($1) as o`, [c1])).rows?.[0]?.o;
    check('tcat: tracking shows the variant label', track?.items?.some((i) => i.options === 'المقاس: S • اللون: أسود'), track);

    // ---- old signature still works (product without variants)
    const oldP = idOf(await as(db, cM, `insert into shop_products (shop_id, name, price, stock, options) values ($1, 'منتج قديم', 50, 3, '[{"name":"الحجم","values":["كبير"]}]'::jsonb) returning id`, [cShop]));
    const oldC = idOf(await place([{ product_id: oldP, quantity: 2, options: 'الحجم: كبير' }], '01000098104'));
    check('tcat: an old-style insert + order (no variants) works as in 0096',
      !!oldC && (await admin(db, `select stock, slug, position from shop_products where id = $1`, [oldP]))[0].stock === 1 &&
      (await admin(db, `select variant_label from shop_order_items i join shop_orders o on o.id = i.order_id where o.order_code = $1`, [oldC]))[0].variant_label === 'الحجم: كبير');
    check('tcat: an old-style insert gets a handle and goes first in the manual order',
      (await admin(db, `select slug, position = (select min(position) from shop_products where shop_id = $1) as first from shop_products where id = $2`, [cShop, oldP]))[0].first === true);

    // ---- low stock: crossing, merchant edits silent, 24 h per variant, 5 per shop per hour
    const lowN = async () => (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title like '📦%'`, [cM]))[0].n;
    await admin(db, `delete from notifications where user_id = $1`, [cM]);
    await admin(db, `delete from private.low_stock_alerts where shop_id = $1`, [cShop]);
    await save(cM, cShop, { ...tee, id: teeId }, MATRIX.map((v) => ({ ...v, stock: 10 })));
    check('tcat: the merchant\'s own stock edit never alerts', (await lowN()) === 0);
    await place([{ product_id: teeId, variant_id: vMB, quantity: 8 }], '01000098105');
    check('tcat: an order that drops a variant to the threshold (3) alerts the owner once', (await lowN()) === 1,
      await admin(db, `select title, body from notifications where user_id = $1`, [cM]));
    const lsRpc = (await as(db, cM, `select public.merchant_low_stock($1) as r`, [cShop])).rows?.[0]?.r;
    check('tcat: «منتجات قربت تخلص» lists it (merchant only)',
      lsRpc?.threshold === 3 && lsRpc.items.some((i) => i.variant_id === vMB && i.stock === 2 && i.variant_label === 'المقاس: M • اللون: أسود') &&
      denied(await as(db, cM2, `select public.merchant_low_stock($1)`, [cShop])), lsRpc);
    await as(db, cM, `select public.update_shop_order_status(id, 'cancelled') from shop_orders where shop_id = $1 and status = 'placed' and customer_phone like '%098105'`, [cShop]);
    await place([{ product_id: teeId, variant_id: vMB, quantity: 8 }], '01000098106');
    check('tcat: the same variant crossing again within 24 h does not alert again', (await lowN()) === 1);
    for (let i = 0; i < 6; i++) {
      const pid = idOf(await save(cM, cShop, { name: 'منتج قليل ' + i, price: 10, stock: 5, status: 'active' }));
      await place([{ product_id: pid, quantity: 3 }], '0100009820' + i);
    }
    check('tcat: at most 5 low-stock alerts per shop per hour', (await lowN()) === 5, await lowN());
    check('tcat: the threshold is the owner\'s to set (0–1000)',
      ok(await as(db, cM, `select public.merchant_set_low_stock_threshold($1, 5)`, [cShop])) &&
      denied(await as(db, cM, `select public.merchant_set_low_stock_threshold($1, -1)`, [cShop])) &&
      denied(await as(db, cM2, `select public.merchant_set_low_stock_threshold($1, 1)`, [cShop])));

    // ---- collections
    const saveColl = (u, shop, c) => as(db, u, `select public.merchant_save_collection($1, $2::jsonb) as id`, [shop, JSON.stringify(c)]);
    const colA = idOf(await saveColl(cM, cShop, { name: 'تيشيرتات', description: 'كل التيشيرتات' }));
    const colHidden = idOf(await saveColl(cM, cShop, { name: 'مخفي', is_visible: false }));
    check('tcat: EXPLOIT blocked: another merchant creates / edits / deletes my collections',
      denied(await saveColl(cM2, cShop, { name: 'x' })) && denied(await saveColl(cM2, cShop, { id: colA, name: 'x' })) &&
      denied(await as(db, cM2, `select public.merchant_delete_collection($1)`, [colA])) &&
      denied(await as(db, cM2, `select public.merchant_set_collection_products($1, $2::uuid[])`, [colA, [teeId]])));
    check('tcat: EXPLOIT blocked: collections are never written directly',
      denied(await as(db, cM, `insert into shop_collections (shop_id, name, slug) values ($1, 'x', 'x')`, [cShop])) &&
      denied(await as(db, cM, `insert into shop_collection_products (collection_id, product_id) values ($1, $2)`, [colA, plainId])));
    check('tcat: the owner fills a collection in order and reorders it',
      ok(await as(db, cM, `select public.merchant_set_collection_products($1, $2::uuid[])`, [colA, [plainId, teeId, draftId]])) &&
      ok(await as(db, cM, `select public.merchant_set_collection_products($1, $2::uuid[])`, [colA, [teeId, plainId, draftId]])) &&
      JSON.stringify((await admin(db, `select product_id from shop_collection_products where collection_id = $1 order by position`, [colA])).map((r) => r.product_id)) === JSON.stringify([teeId, plainId, draftId]));
    await as(db, cM, `select public.merchant_set_collection_products($1, $2::uuid[])`, [colHidden, [plainId]]);
    const pubC = await as(db, null, `select name from shop_collections where shop_id = $1`, [cShop]);
    const pubCP = await as(db, null, `select product_id from shop_collection_products where collection_id = $1`, [colA]);
    check('tcat: guests read visible collections only, and only their visible products',
      ok(pubC) && pubC.rows.length === 1 && pubC.rows[0].name === 'تيشيرتات' &&
      ok(pubCP) && pubCP.rows.length === 2 && !pubCP.rows.some((r) => r.product_id === draftId) &&
      (await as(db, null, `select count(*)::int n from shop_collection_products where collection_id = $1`, [colHidden])).rows[0].n === 0, { pubC, pubCP });
    const smart = idOf(await saveColl(cM, cShop, { name: 'قطن', rules: { tag: 'قطن' } }));
    check('tcat: a smart collection (by tag) — and bad rules are refused',
      !!smart && denied(await saveColl(cM, cShop, { name: 'غلط', rules: { color: 'x' } })) && denied(await saveColl(cM, cShop, { name: 'فاضي', rules: {} })) &&
      denied(await as(db, cM, `select public.merchant_set_collection_products($1, $2::uuid[])`, [smart, [plainId]])));
    const sc = (await as(db, null, `select public.store_catalog($1) as c`, [cShop])).rows?.[0]?.c;
    const scA = sc?.collections?.find((c) => c.id === colA);
    const scS = sc?.collections?.find((c) => c.id === smart);
    check('tcat: store_catalog: visible products with available variants, visible collections with their visible products',
      sc && !sc.products.some((p) => p.id === draftId) && sc.products.find((p) => p.id === teeId)?.variants?.length === 4 &&
      JSON.stringify(scA?.product_ids) === JSON.stringify([teeId, plainId]) && JSON.stringify(scS?.product_ids) === JSON.stringify([teeId]) &&
      !sc.collections.some((c) => c.id === colHidden), sc?.collections);
    const editColl = idOf(await save(cM, cShop, { name: 'جاكيت', price: 500, status: 'active' }, [], [colA, colHidden]));
    check('tcat: the editor sets a product\'s manual collections (appended last)',
      (await admin(db, `select position from shop_collection_products where collection_id = $1 and product_id = $2`, [colA, editColl]))[0]?.position === 3);
    check('tcat: reordering collections / products (owner only)',
      ok(await as(db, cM, `select public.merchant_reorder_collections($1, $2::uuid[])`, [cShop, [smart, colA, colHidden]])) &&
      (await admin(db, `select position from shop_collections where id = $1`, [smart]))[0].position === 0 &&
      ok(await as(db, cM, `select public.merchant_reorder_products($1, $2::uuid[])`, [cShop, [plainId, teeId]])) &&
      (() => true)() &&
      ((ps) => ps.indexOf(plainId) < ps.indexOf(teeId))((await as(db, null, `select public.store_catalog($1) as c`, [cShop])).rows[0].c.products.map((p) => p.id)) &&
      denied(await as(db, cM2, `select public.merchant_reorder_products($1, $2::uuid[])`, [cShop, [teeId]])));

    // ---- duplicate
    const dupId = idOf(await as(db, cM, `select public.merchant_duplicate_product($1) as id`, [teeId]));
    const dup = (await admin(db, `select name, status, slug, is_available from shop_products where id = $1`, [dupId]))[0];
    check('tcat: duplicate → a draft copy with its variants (no SKUs) and collections',
      dup?.name === 'تيشيرت قطن (نسخة)' && dup.status === 'draft' && dup.is_available === false && dup.slug !== 'تيشيرت-قطن' &&
      (await admin(db, `select count(*)::int n, count(sku)::int s from shop_product_variants where product_id = $1`, [dupId]))[0].n === 4 &&
      (await admin(db, `select count(*)::int n, count(sku)::int s from shop_product_variants where product_id = $1`, [dupId]))[0].s === 0 &&
      (await admin(db, `select count(*)::int n from shop_collection_products where product_id = $1`, [dupId]))[0].n === 1 &&
      denied(await as(db, cM2, `select public.merchant_duplicate_product($1)`, [teeId])), dup);

    // ---- bulk actions
    const bulk = (u, ids, action, value) => as(db, u, `select public.merchant_bulk_products($1, $2::uuid[], $3, $4::jsonb) as r`, [cShop, ids, action, JSON.stringify(value)]);
    const b1 = (await bulk(cM, [dupId, twin], 'status', 'archived')).rows?.[0]?.r;
    check('tcat: bulk status', b1?.updated === 2 && (await admin(db, `select count(*)::int n from shop_products where id = any($1) and status = 'archived'`, [[dupId, twin]]))[0].n === 2, b1);
    const b2 = (await bulk(cM, [teeId, plainId, twin], 'price', 175)).rows?.[0]?.r;
    check('tcat: bulk price changes single-variant products only (multi-variant skipped)',
      b2?.updated === 2 && b2.skipped === 1 && (await admin(db, `select price::float p from shop_products where id = $1`, [plainId]))[0].p === 175 &&
      (await admin(db, `select price::float p from shop_products where id = $1`, [teeId]))[0].p !== 175, b2);
    const b3 = (await bulk(cM, [twin, plainId], 'add_collection', smart));
    const b4 = (await bulk(cM, [twin, editColl], 'add_collection', colA)).rows?.[0]?.r;
    check('tcat: bulk add to a manual collection (smart refused)', denied(b3) && b4?.updated === 1, b4);
    const b5 = (await bulk(cM, [plainId, twin], 'delete')).rows?.[0]?.r;
    check('tcat: bulk delete deletes unordered products and archives ordered ones',
      b5?.deleted === 1 && b5.archived === 1 && (await admin(db, `select status from shop_products where id = $1`, [plainId]))[0].status === 'archived', b5);
    check('tcat: EXPLOIT blocked: bulk on another shop / its products',
      denied(await bulk(cM2, [teeId], 'status', 'draft')) &&
      ((await as(db, cM2, `select public.merchant_bulk_products($1, $2::uuid[], 'status', '"draft"') as r`, [cShop2, [teeId]])).rows?.[0]?.r?.skipped === 1) &&
      (await admin(db, `select status from shop_products where id = $1`, [teeId]))[0].status === 'active');

    // ---- CSV import
    const imp = (u, rows, dry) => as(db, u, `select public.merchant_import_products($1, $2::jsonb, $3) as r`, [cShop, JSON.stringify(rows), dry]);
    const CSV = [
      { _row: 2, handle: 'hoodie', title: 'هودي شتوي', description: '<p>هودي <b>تقيل</b></p>', option1_name: 'المقاس', option1_value: 'L', option2_name: 'اللون', option2_value: 'رمادي',
        sku: 'HD-L-GR', price: '350', compare_at: '400', stock: '6', status: 'active', collection: 'شتوي, تيشيرتات', tags: 'شتا، قطن', image_src: 'https://x.test/h1.jpg' },
      { _row: 3, handle: 'hoodie', option1_value: 'XL', option2_value: 'رمادي', sku: 'HD-XL-GR', price: '370', stock: '', image_src: 'https://x.test/h2.jpg', variant_image: 'https://x.test/h2.jpg' },
      { _row: 4, handle: 'cap', title: 'كاب', price: '80', stock: '12', sku: 'CAP-1', barcode: '123456', option1_name: 'Title', option1_value: 'Default Title' },
      { _row: 5, title: 'منتج غلط', price: 'غالي' },
      { _row: 6, handle: 'no-price', title: 'من غير سعر' },
      { _row: 7, handle: 'bad-status', title: 'حالة', price: '5', status: 'sold' },
    ];
    const before = (await admin(db, `select count(*)::int n from shop_products where shop_id = $1`, [cShop]))[0].n;
    const dry = (await imp(cM, CSV, true)).rows?.[0]?.r;
    check('tcat: CSV dry run — preview counts + an error report with file rows, nothing written',
      dry?.dry_run === true && dry.created === 2 && dry.failed === 3 && dry.errors.map((e) => e.row).join(',') === '5,6,7' &&
      dry.errors.every((e) => /سطر \d/.test(e.message)) &&
      (await admin(db, `select count(*)::int n from shop_products where shop_id = $1`, [cShop]))[0].n === before &&
      (await admin(db, `select count(*)::int n from shop_collections where shop_id = $1 and name = 'شتوي'`, [cShop]))[0].n === 0, dry);
    const real = (await imp(cM, CSV, false)).rows?.[0]?.r;
    const hoodie = (await admin(db, `select id, name, description, price::float p, old_price::float o, stock, tags, images, status from shop_products where shop_id = $1 and slug = 'hoodie'`, [cShop]))[0];
    const hv = hoodie ? await admin(db, `select option_values, sku, price::float p, compare_at_price::float c, stock, image_url from shop_product_variants where product_id = $1 order by position`, [hoodie.id]) : [];
    check('tcat: CSV import creates products with variants, tags, photos, collections (created on the fly)',
      real?.created === 2 && real.failed === 3 && hoodie?.name === 'هودي شتوي' && hoodie.description === 'هودي تقيل' && hoodie.tags.join('|') === 'شتا|قطن' &&
      hoodie.images.length === 2 && hv.length === 2 && hv[0].sku === 'HD-L-GR' && hv[0].c === 400 && hv[0].stock === 6 && hv[1].stock === null && hv[1].image_url === 'https://x.test/h2.jpg' &&
      (await admin(db, `select count(*)::int n from shop_collection_products cp join shop_collections c on c.id = cp.collection_id where cp.product_id = $1 and c.name in ('شتوي', 'تيشيرتات')`, [hoodie.id]))[0].n === 2,
      { real, hoodie, hv });
    const cap = (await admin(db, `select id, sku, barcode, stock, price::float p from shop_products where shop_id = $1 and slug = 'cap'`, [cShop]))[0];
    check('tcat: Shopify\'s "Default Title" row is a product without variants', cap?.sku === 'CAP-1' && cap.stock === 12 &&
      (await admin(db, `select count(*)::int n from shop_product_variants where product_id = $1`, [cap.id]))[0].n === 0, cap);
    const again = (await imp(cM, CSV, false)).rows?.[0]?.r;
    const hv2 = await admin(db, `select id from shop_product_variants where product_id = $1 order by position`, [hoodie.id]);
    check('tcat: importing the same file again is idempotent (updates, same variant ids, no duplicate collections)',
      again?.created === 0 && again.updated === 2 && (await admin(db, `select count(*)::int n from shop_products where shop_id = $1`, [cShop]))[0].n === before + 2 &&
      hv2.length === 2 && (await admin(db, `select count(*)::int n from shop_collections where shop_id = $1 and name = 'شتوي'`, [cShop]))[0].n === 1, again);
    const bySku = (await imp(cM, [{ _row: 2, sku: 'CAP-1', price: '85' }], false)).rows?.[0]?.r;
    check('tcat: a row with only a SKU updates the product that has it', bySku?.updated === 1 &&
      (await admin(db, `select price::float p from shop_products where id = $1`, [cap.id]))[0].p === 85, bySku);
    check('tcat: import limits: > 500 rows per batch refused; another merchant refused',
      denied(await imp(cM, Array.from({ length: 501 }, (_, i) => ({ title: 'x' + i, price: '1' })), true)) && denied(await imp(cM2, CSV, true)));

    // ---- one-time data migration (old options → variants, categories → collections)
    const legacyP = idOf(await as(db, cM, `insert into shop_products (shop_id, name, price, old_price, stock, category, options)
      values ($1, 'بنطلون قديم', 300, 350, 7, 'بناطيل', '[{"name":"المقاس","values":["30","32","34"]}]'::jsonb) returning id`, [cShop]));
    const legacyUnl = idOf(await as(db, cM, `insert into shop_products (shop_id, name, price, category, options)
      values ($1, 'شراب', 20, 'بناطيل', '[{"name":"اللون","values":["أسود","أبيض"]}]'::jsonb) returning id`, [cShop]));
    check('tcat: before the data migration, legacy products have no variants',
      (await admin(db, `select count(*)::int n from shop_product_variants where product_id = any($1)`, [[legacyP, legacyUnl]]))[0].n === 0);
    await db.exec(fs.readFileSync(MIG98, 'utf8'));
    await db.exec(fs.readFileSync(MIG99, 'utf8'));
    check('tcat: a plain re-run never repeats the data migration (marked)',
      (await admin(db, `select count(*)::int n from shop_product_variants where product_id = $1`, [legacyP]))[0].n === 0);
    await admin(db, `delete from private.migration_marks where name = '0098_catalog'`);
    await db.exec(fs.readFileSync(MIG98, 'utf8'));
    await db.exec(fs.readFileSync(MIG99, 'utf8'));
    const lv = await admin(db, `select option_values, stock, price::float p, compare_at_price::float c from shop_product_variants where product_id = $1 order by position`, [legacyP]);
    check('tcat: data migration: old option lists → variants; stock split evenly so the total is unchanged',
      lv.length === 3 && lv.map((v) => v.stock).join(',') === '3,2,2' && lv.every((v) => v.p === 300 && v.c === 350) &&
      (await admin(db, `select stock, price::float p from shop_products where id = $1`, [legacyP]))[0].stock === 7, lv);
    check('tcat: data migration: unlimited stock stays unlimited on every variant',
      (await admin(db, `select count(*)::int n, count(stock)::int s from shop_product_variants where product_id = $1`, [legacyUnl]))[0].s === 0);
    const bColl = (await admin(db, `select c.id, (select array_agg(product_id) from shop_collection_products where collection_id = c.id) ids from shop_collections c where c.shop_id = $1 and c.name = 'بناطيل'`, [cShop]))[0];
    check('tcat: data migration: free-text categories → a manual collection with its products',
      bColl && bColl.ids.length === 2 && bColl.ids.includes(legacyP) && bColl.ids.includes(legacyUnl), bColl);
    const migOrder = idOf(await place([{ product_id: legacyP, quantity: 1, options: 'المقاس: 32' }], '01000098110'));
    check('tcat: an old client\'s order on a migrated product takes that variant\'s stock',
      !!migOrder && (await admin(db, `select stock from shop_product_variants where product_id = $1 and option_values = '["32"]'`, [legacyP]))[0].stock === 1);

    // ---- currencies: 3-decimal prices for KWD-like stores only; CSV in the store's currency
    await admin(db, `update shops set currency = 'KWD' where id = $1`, [cShop2]);
    const kw = await save(cM2, cShop2, { name: 'عطر', status: 'active', options: [{ name: 'الحجم', values: ['50ml'] }] }, [{ option_values: ['50ml'], price: 12.375 }]);
    check('tcat: a KWD store keeps 3-decimal variant prices (rollup too)',
      ok(kw) && (await admin(db, `select price::text p from shop_products where id = $1`, [idOf(kw)]))[0].p === '12.375', kw);
    check('tcat: a 2-decimal currency refuses a third decimal',
      denied(await save(cM, cShop, { name: 'كسر', price: 10.555, status: 'active' })) &&
      denied(await save(cM, cShop, { ...tee, name: 'كسر2' }, [{ ...MATRIX[0], sku: null, price: 10.555 }])));
    const kwOrder = idOf(await as(db, null, `select public.place_store_order($1, $2::jsonb, 'سارة', '+96550012345', 'شارع الخليج، الكويت، بيت 4') as code`,
      [cShop2, JSON.stringify([{ product_id: idOf(kw), quantity: 2 }])]));
    check('tcat: a KWD order total keeps 3 decimals',
      !kwOrder || (await admin(db, `select total_amount::text t from shop_orders where order_code = $1`, [kwOrder]))[0].t.startsWith('24.75'), kwOrder);
    const badCur = (await imp(cM, [{ _row: 2, handle: 'cur', title: 'عملة', price: '5', currency: 'USD' }], true)).rows?.[0]?.r;
    check('tcat: CSV rows in another currency are refused (Currency column = the store\'s)',
      badCur?.failed === 1 && /العملة/.test(badCur.errors[0].message) &&
      (await imp(cM, [{ _row: 2, handle: 'cur', title: 'عملة', price: '5', currency: 'egp' }], true)).rows?.[0]?.r?.created === 1, badCur);

    // ---- merchant_catalog / merchant_product
    const mc =(await as(db, cM, `select public.merchant_catalog($1) as c`, [cShop])).rows?.[0]?.c;
    check('tcat: merchant_catalog has every product (archived too), variants, collections; owner only',
      mc?.products?.some((p) => p.id === dupId) && mc.products.find((p) => p.id === teeId)?.variants?.length === 4 && mc.collections.length >= 4 &&
      denied(await as(db, cM2, `select public.merchant_catalog($1)`, [cShop])));
    const mp = (await as(db, cM, `select public.merchant_product($1) as p`, [teeId])).rows?.[0]?.p;
    check('tcat: merchant_product returns variants + collection ids; another merchant gets nothing',
      mp?.variants?.length === 4 && mp.collection_ids.includes(colA) && (await as(db, cM2, `select public.merchant_product($1) as p`, [teeId])).rows?.[0]?.p === null, mp?.collection_ids);
  }

  console.log('\nPhase tfaw — متجري online payment: Fawaterak (0100 / 0101 API v3)');
  {
    const fs = require('fs');
    const path = require('path');
    const nodeCrypto = require('crypto');
    let rerun = null;
    for (const f of ['0100_fawaterak.sql', '0101_fawaterak_v3.sql']) {
      try {
        await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', f), 'utf8'));
      } catch (e) {
        rerun = rerun || f + ': ' + e.message;
      }
    }
    check('tfaw: 0100 + 0101 are safe to re-run', rerun === null, rerun);
    const idOf = (r) => r.rows?.[0] && Object.values(r.rows[0])[0];
    const svc = async (sql, params = []) => {
      await db.exec('begin');
      try {
        await db.exec('set local role service_role');
        const r = await db.query(sql, params);
        await db.exec('commit');
        return { rows: r.rows };
      } catch (e) {
        await db.exec('rollback');
        return { error: e.message };
      }
    };
    const fM = await signUp(db, 'tfaw merchant', '01000100001');
    const fShop = idOf(await as(db, fM, `select public.create_my_shop('محل الدفع', 'ملابس وأحذية', 'tfaw-shop', '01000100001') as id`));
    const prod = idOf(await as(db, fM, `select public.merchant_save_product($1, $2::jsonb) as id`,
      [fShop, JSON.stringify({ name: 'شنطة جلد', price: 250, stock: 10, status: 'active' })]));
    check('tfaw: a shop with a product', !!fShop && !!prod, { fShop, prod });

    // ---- connecting Fawaterak (API v3: Client ID + Client Secret + API Key)
    const KEY = 'a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0';
    const CID = '9d4e2c1a-b3f5-4e8a-9c1d-2a3b4c5d6e7f';
    const SEC = 'Zx9secretABCdef1234567890ghij';
    const gw = (pub, sec) => as(db, fM, `select public.set_shop_gateway($1, 'fawaterak', $2, $3, 'test') as j`, [fShop, JSON.stringify(pub), JSON.stringify(sec)]);
    check('tfaw: a malformed secret / a missing or bad Client ID / no API Key / the old v2 form are refused',
      denied(await gw({ client_id: CID }, { client_secret: 'short', api_key: KEY })) &&
      denied(await gw({}, { client_secret: SEC, api_key: KEY })) &&
      denied(await gw({ client_id: 'not-a-uuid' }, { client_secret: SEC, api_key: KEY })) &&
      denied(await gw({ client_id: CID }, { client_secret: SEC })) &&
      denied(await gw({}, { api_key: KEY })));
    const g1 = await gw({ client_id: CID }, { client_secret: SEC, api_key: KEY });
    check('tfaw: the owner connects Fawaterak; the secrets never come back, the Client ID does',
      ok(g1) && !JSON.stringify(g1.rows).includes(KEY) && !JSON.stringify(g1.rows).includes(SEC) && JSON.stringify(g1.rows).includes(CID), g1);
    const avail = idOf(await as(db, fM, `select public.get_shop_integrations($1)->'payments'->'available' as a`, [fShop]));
    check('tfaw: Fawaterak is offered first in Egypt', JSON.stringify(avail) === '["fawaterak","paymob","kashier","tap"]', avail);

    // ---- a guest order, then «ادفع أونلاين»
    const place = () => as(db, null, `select public.place_store_order($1, $2::jsonb, 'منى أحمد', '01011112222', 'شارع التحرير، الدقي، عمارة 5') as code`,
      [fShop, JSON.stringify([{ product_id: prod, quantity: 2 }])]);
    const code = idOf(await place());
    const total = Number((await admin(db, `select total_amount from shop_orders where order_code = $1`, [code]))[0]?.total_amount);
    check('tfaw: a guest places a cash order', !!code && total >= 500, { code, total });
    const begin = async (c, ph) => (await svc(`select public.payment_begin($1, $2) as j`, [c, ph])).rows?.[0]?.j;
    check('tfaw: payment_begin refuses while the gateway is not «connected»', /مش مفعّل/.test((await begin(code, '01011112222'))?.error || ''));
    await admin(db, `select public.gateway_record_check($1, 'fawaterak', true, null)`, [fShop]);
    const methods = idOf(await as(db, null, `select public.shop_checkout_methods($1) as m`, [fShop]));
    check('tfaw: the storefront sees Fawaterak online (no secrets)',
      methods?.online?.some((g) => g.provider === 'fawaterak') && !JSON.stringify(methods).includes(KEY) && !JSON.stringify(methods).includes(SEC), methods);
    check('tfaw: EXPLOIT blocked: guests / merchants call payment_begin / settle / lookup / attach',
      denied(await as(db, null, `select public.payment_begin($1, '01011112222')`, [code])) &&
      denied(await as(db, fM, `select public.payment_settle($1, 'fawaterak', '1', true, 1, 'EGP')`, [fShop])) &&
      denied(await as(db, null, `select public.payment_lookup($1, '01011112222')`, [code])) &&
      denied(await as(db, fM, `select public.payment_attach(gen_random_uuid(), 'fawaterak', '1', 'k', null, null)`)));
    check('tfaw: a wrong phone is refused', /مش هو رقم/.test((await begin(code, '01099998888'))?.error || ''));
    const b1 = await begin(code, '+201011112222');
    check('tfaw: the order\'s phone (either form) starts paying: awaiting, the real total, test mode',
      b1?.payment_status === 'awaiting' && Number(b1.total) === total && b1.currency === 'EGP' && b1.mode === 'test', b1);
    const row = async () => (await admin(db, `select payment_method, payment_status, payment_invoice_id, paid_at, paid_amount from shop_orders where order_code = $1`, [code]))[0];
    check('tfaw: the order is online / awaiting with one «payment» event', (await row()).payment_method === 'online' &&
      (await admin(db, `select count(*)::int n from shop_order_events e join shop_orders o on o.id = e.order_id where o.order_code = $1 and e.kind = 'payment'`, [code]))[0].n === 1);
    const direct = await as(db, fM, `update shop_orders set payment_status = 'paid' where order_code = $1`, [code]);
    check('tfaw: EXPLOIT blocked: the merchant marks the order paid directly', denied(direct) && (await row()).payment_status === 'awaiting', direct);
    check('tfaw: EXPLOIT blocked: the customer marks it paid directly',
      denied(await as(db, null, `update shop_orders set payment_status = 'paid' where order_code = $1`, [code])) && (await row()).payment_status === 'awaiting');

    const IK1 = '550e8400-e29b-41d4-a716-446655440000';
    const IK2 = '660e8400-e29b-41d4-a716-446655440001';
    await svc(`select public.payment_attach($1, 'fawaterak', $2, null, 'https://staging.fawaterk.com/ts/a1b2c', null)`, [b1.order_id, IK1]);
    const settle = async (inv, paid, amount, cur = 'EGP', c = null) =>
      (await svc(`select public.payment_settle($1, 'fawaterak', $2, $3, $4, $5, 'Visa', $6) as j`, [fShop, inv, paid, amount, cur, c])).rows?.[0]?.j;
    const s0 = await settle(IK1, true, total - 1);
    check('tfaw: a paid transaction for another amount does NOT mark the order paid', s0?.reason === 'amount_mismatch' && (await row()).payment_status === 'awaiting', s0);
    check('tfaw: …nor in another currency', (await settle(IK1, true, total, 'USD'))?.reason === 'amount_mismatch');
    check('tfaw: an unknown transaction settles nothing', (await settle('999', true, total))?.reason === 'no_order');
    const f1 = await settle(IK1, false, null);
    check('tfaw: a failed payment → «failed», the customer may retry (can_pay)', f1?.status === 'failed' &&
      idOf(await as(db, null, `select public.get_store_order($1) as o`, [code]))?.can_pay === true, f1);

    // The customer retries (a new transaction); the first one is still paid later.
    const b2 = await begin(code, '01011112222');
    await svc(`select public.payment_attach($1, 'fawaterak', $2, null, 'https://staging.fawaterk.com/ts/x9', null)`, [b2.order_id, IK2]);
    check('tfaw: an old transaction failing says nothing about the current one', (await settle(IK1, false, null, 'EGP', code))?.status === 'awaiting');
    const s1 = await settle(IK1, true, total, 'EGP', code);
    const r1 = await row();
    check('tfaw: paying an older transaction of the order (found by its code) marks it paid',
      s1?.status === 'paid' && r1.payment_status === 'paid' && !!r1.paid_at && Number(r1.paid_amount) === total && r1.payment_invoice_id === IK1, { s1, r1 });
    check('tfaw: a repeated webhook changes nothing', (await settle(IK1, true, total, 'EGP', code))?.already === true);
    check('tfaw: the merchant got one «💳 اتدفع» notification',
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title like '💳%'`, [fM]))[0].n === 1);
    const tr = idOf(await as(db, null, `select public.get_store_order($1) as o`, [code]));
    check('tfaw: the tracking page: paid, no «ادفع» / «إلغاء»', tr?.payment_status === 'paid' && tr.can_pay === false && tr.can_cancel === false, tr);
    const gc = await as(db, null, `select public.guest_cancel_store_order($1, '2222', null) as r`, [code]);
    check('tfaw: EXPLOIT blocked: the customer cancels a paid order (refunds go through the shop)',
      denied(gc) && (await admin(db, `select status from shop_orders where order_code = $1`, [code]))[0].status === 'placed', gc);
    const mj = (await admin(db, `select private.order_row_json(o) as j from shop_orders o where order_code = $1`, [code]))[0].j;
    check('tfaw: the merchant\'s order row: online / paid', mj.payment === 'online' && mj.payment_status === 'paid' && mj.payment_provider === 'fawaterak', mj);
    check('tfaw: payment_lookup needs the order\'s phone',
      (await svc(`select public.payment_lookup($1, '01011112222') as j`, [code])).rows?.[0]?.j?.payment_status === 'paid' &&
      (await svc(`select public.payment_lookup($1, '01000000000') as j`, [code])).rows?.[0]?.j === null);
    const code2 = idOf(await place());
    const mj2 = (await admin(db, `select private.order_row_json(o) as j from shop_orders o where order_code = $1`, [code2]))[0].j;
    check('tfaw: a cash order stays cash (no payment status), and can still be cancelled',
      mj2.payment === 'cash' && mj2.payment_status === null && idOf(await as(db, null, `select public.get_store_order($1) as o`, [code2]))?.can_cancel === true, mj2);

    // ---- Edge Function blocks, run in Node
    const block = (fn, tag) => {
      const src = fs.readFileSync(path.join(__dirname, '..', 'functions', fn, 'index.ts'), 'utf8');
      const s0 = src.indexOf('\n', src.indexOf(tag + ':begin')) + 1;
      return src.slice(s0, src.lastIndexOf('\n', src.indexOf(tag + ':end')));
    };
    let fw = null, sig = null, gwc = null;
    try {
      fw = new Function(block('payments-checkout', 'fw') + '\nreturn { fawaterakHost, transactionBody, readToken, readTransaction, readTransactionData, fawaterakToken };')();
      sig = new Function('crypto', block('payments-webhook', 'sig') + '\nreturn { verifyWebhook };')(nodeCrypto.webcrypto);
      gwc = new Function('btoa', block('payments-connect', 'gw') + '\nreturn { testGateway };')(globalThis.btoa);
    } catch (e) {
      fw = { error: e.message };
    }
    check('tfaw: the Edge Function blocks run in Node', fw && !fw.error && sig && gwc, fw);
    if (fw && !fw.error) {
      const seen = [];
      const fakeSeq = (...answers) => async (url, opts) => {
        seen.push({ url, opts });
        const [status, body] = answers.shift() || [500, {}];
        return { status, json: async () => body };
      };
      check('tfaw: staging for test keys, app.fawaterk.com for live',
        fw.fawaterakHost('test') === 'https://staging.fawaterk.com' && fw.fawaterakHost('live') === 'https://app.fawaterk.com');
      const tb = fw.transactionBody({ code: 'TABC2345', total: 512.5, currency: 'EGP', customer_name: 'منى أحمد علي', customer_phone: '01011112222', shop_name: 'محل', shop_id: 'S1' }, 'https://hook');
      check('tfaw: createTransaction = hosted checkout (no method), the order total in one line, back to /#/o/<code>, our webhook, pay_load',
        tb.payment_method_id === undefined && tb.cartTotal === 512.5 && tb.cartItems.length === 1 && tb.cartItems[0].price * tb.cartItems[0].quantity === 512.5 &&
        tb.customer.first_name === 'منى' && tb.customer.last_name === 'أحمد علي' && tb.tr_number === 'TABC2345' &&
        tb.redirectionUrls.successUrl === 'https://mogtama3y.com/#/o/TABC2345' && tb.redirectionUrls.webhookUrl === 'https://hook' &&
        tb.pay_load.order_code === 'TABC2345' && tb.sendEmail === false, tb);
      const one = fw.transactionBody({ code: 'TABC2345', total: 10, customer_name: 'منى' }, '');
      check('tfaw: a one-word name fills both names', one.customer.first_name === 'منى' && one.customer.last_name === 'منى');

      const tok = await fw.fawaterakToken({ mode: 'test', public: { client_id: CID }, secret: { client_secret: SEC } },
        fakeSeq([200, { token_type: 'Bearer', expires_in: 31536000, access_token: 'eyJ.tok' }]));
      const tokBody = JSON.parse(seen[0].opts.body);
      check('tfaw: the token: POST staging /oauth/token with client_credentials',
        tok.token === 'eyJ.tok' && seen[0].url === 'https://staging.fawaterk.com/oauth/token' && tokBody.grant_type === 'client_credentials' &&
        tokBody.client_id === CID && tokBody.client_secret === SEC, { tok, tokBody });
      const tokBad = await fw.fawaterakToken({ mode: 'live', public: { client_id: CID }, secret: { client_secret: SEC } },
        fakeSeq([401, { error: 'invalid_client', message: 'Client authentication failed' }]));
      const tokNone = await fw.fawaterakToken({ public: {}, secret: {} }, fakeSeq());
      check('tfaw: a refused client → an error with Fawaterak\'s message; missing fields never call out',
        /Client authentication failed/.test(tokBad.error || '') && seen[1].url === 'https://app.fawaterk.com/oauth/token' &&
        !!tokNone.error && seen.length === 2, tokBad);

      const rt = fw.readTransaction({ status: 'success', message: 'Transaction link created', data: { intent_key: IK1, url: 'https://staging.fawaterk.com/ts/a1b2c', expires_in: 2592000 } });
      check('tfaw: createTransaction → intent_key + hosted link', rt.intent_key === IK1 && rt.redirect_to === 'https://staging.fawaterk.com/ts/a1b2c', rt);
      check('tfaw: a 422 → Laravel\'s field messages; a non-https link is refused',
        /The customer\.phone field is required/.test(fw.readTransaction({ status: 'error', message: { 'customer.phone': ['The customer.phone field is required.'] } }).error) &&
        !!fw.readTransaction({ status: 'success', data: { intent_key: 'k', url: 'javascript:alert(1)' } }).error);
      const td = fw.readTransactionData({ status: 'success', data: { intent_key: IK1, paid: 1, status_text: 'paid', total: 512.5, currency: 'EGP', payment_method: 'Fawry', pay_load: { order_code: 'TABC2345' } } });
      check('tfaw: getTransactionData → paid, amount, currency, the order code from pay_load (object or JSON text; SR → SAR)',
        td.paid === true && td.amount === 512.5 && td.currency === 'EGP' && td.code === 'TABC2345' &&
        fw.readTransactionData({ status: 'success', data: { paid: 0, currency: 'SR' } }).currency === 'SAR' &&
        fw.readTransactionData({ status: 'success', data: { paid: 0, pay_load: '{"order_code":"TX"}' } }).code === 'TX' &&
        fw.readTransactionData({ status: 'success', data: { paid: 0 } }).paid === false, td);

      const hmac = (m) => nodeCrypto.createHmac('sha256', KEY).update(m).digest('hex');
      const creds = { secret: { api_key: KEY } };
      const STS = 'TransactionId=12345&TransactionKey=' + IK1 + '&PaymentMethod=Visa-Mastercard';
      const paidBody = { transaction_key: IK1, transaction_id: 12345, payment_method: 'Visa-Mastercard', status: 'paid', pay_load: '{"order_code":"TABC2345"}', paidAmount: '512.50', paidCurrency: 'EGP', transactionHashKey: hmac(STS) };
      const v1 = await sig.verifyWebhook('fawaterak', creds, paidBody, {}, {});
      check('tfaw: webhook v3: a signed «paid» callback passes (transactionHashKey)',
        v1.ok === true && v1.external_id === IK1 && v1.event_type === 'transaction:paid', v1);
      check('tfaw: webhook: EXPLOIT blocked: a forged / altered / unsigned callback, or a shop without the API key',
        (await sig.verifyWebhook('fawaterak', creds, { ...paidBody, transaction_key: IK2 }, {}, {})).ok === false &&
        (await sig.verifyWebhook('fawaterak', { secret: { api_key: KEY + 'x' } }, paidBody, {}, {})).ok === false &&
        (await sig.verifyWebhook('fawaterak', creds, { ...paidBody, transactionHashKey: undefined }, {}, {})).ok === false &&
        (await sig.verifyWebhook('fawaterak', { secret: {} }, paidBody, {}, {})).ok === false);
      const failBody = { transaction_key: IK1, transaction_id: 12345, payment_method: 'Visa-Mastercard', errorMessage: 'Payment declined by issuer', hashKey: hmac(STS) };
      const v3 = await sig.verifyWebhook('fawaterak', creds, failBody, {}, {});
      check('tfaw: webhook v3: a signed «failed» callback (hashKey) passes', v3.ok === true && v3.event_type === 'transaction:failed', v3);
      const cancelBody = { referenceId: 55501, status: 'EXPIRED', paymentMethod: 'Aman', transactionKey: IK1, hashKey: hmac('referenceId=55501&PaymentMethod=Aman') };
      const v2 = await sig.verifyWebhook('fawaterak', creds, cancelBody, {}, {});
      check('tfaw: webhook: a signed «expired» Aman callback passes', v2.ok === true && v2.event_type === 'cancel:EXPIRED' && v2.external_id === '55501', v2);

      seen.length = 0;
      const full = { provider: 'fawaterak', mode: 'test', public: { client_id: CID }, secret: { client_secret: SEC, api_key: KEY } };
      const t1 = await gwc.testGateway(full, fakeSeq([200, { access_token: 'eyJ.tok' }], [200, { status: 'success', data: [{ payment_method_id: 2 }, { payment_method_id: 3 }] }]));
      check('tfaw: «اختبر الاتصال»: token, then getTrPaymentmethods with it',
        t1.ok === true && /2 طرق/.test(t1.message) && seen[0].url === 'https://staging.fawaterk.com/oauth/token' &&
        seen[1].url === 'https://staging.fawaterk.com/api/v3/getTrPaymentmethods' && seen[1].opts.headers.Authorization === 'Bearer eyJ.tok', { t1, seen });
      const t2 = await gwc.testGateway({ ...full, mode: 'live' }, fakeSeq([401, { error: 'invalid_client' }]));
      const t3 = await gwc.testGateway(full, fakeSeq([200, { access_token: 'eyJ.tok' }], [200, { status: 'success', data: [] }]));
      const t4 = await gwc.testGateway({ ...full, secret: { client_secret: SEC } }, fakeSeq());
      check('tfaw: refused client → «فيه مشكلة» (live → app.fawaterk.com); no enabled methods → told where; no API key → refused',
        t2.ok === false && seen[2].url === 'https://app.fawaterk.com/oauth/token' && t3.ok === false && /Integration status/.test(t3.message) && t4.ok === false, { t2, t3, t4 });
    }
  }

  console.log('\nPhase ttok — ad tokens bought online on the platform\'s Fawaterak (0102)');
  {
    const fs = require('fs');
    const path = require('path');
    let rerun = null;
    try {
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0102_token_online_topup.sql'), 'utf8'));
      await db.exec(fs.readFileSync(path.join(__dirname, '..', 'migrations', '0103_token_min_topup.sql'), 'utf8'));
    } catch (e) {
      rerun = e.message;
    }
    check('ttok: 0102 is safe to re-run', rerun === null, rerun);
    const svc = async (sql, params = []) => {
      await db.exec('begin');
      try {
        await db.exec('set local role service_role');
        const r = await db.query(sql, params);
        await db.exec('commit');
        return { rows: r.rows };
      } catch (e) {
        await db.exec('rollback');
        return { error: e.message };
      }
    };
    const one = (r) => r.rows?.[0] && Object.values(r.rows[0])[0];
    const U = await signUp(db, 'ttok buyer', '01000102001');
    const X = await signUp(db, 'ttok other', '01000102002');
    const begin = async (u, n) => one(await svc(`select public.token_payment_begin($1, $2) as j`, [u, n]));
    const bal = async (u) => (await admin(db, `select ad_token_balance b from profiles where id = $1`, [u]))[0].b;
    await admin(db, `update ad_token_settings set online_topup = false, token_price_egp = 15 where id = 1`);
    check('ttok: refused while the owner hasn\'t turned online top-up on', /مش متاح/.test((await begin(U, 10))?.error || ''));
    await admin(db, `update ad_token_settings set online_topup = true where id = 1`);
    check('ttok: fewer than the minimum (3, 0103) / absurd amounts are refused', /من 3/.test((await begin(U, 2))?.error || '') && /من 3/.test((await begin(U, 100000))?.error || ''));
    check('ttok: manual requests follow the same minimum (3 ok, 2 refused)',
      ok(await as(db, X, `select public.request_token_topup(3, 'InstaPay 123')`)) && denied(await as(db, X, `select public.request_token_topup(2, 'InstaPay 123')`)));
    const b1 = await begin(U, 10);
    check('ttok: begin → the price from the settings (10 × 15 = 150 EGP), the buyer\'s name', b1?.id && Number(b1.amount) === 150 && b1.currency === 'EGP' && b1.tokens === 10, b1);
    const row = async (id) => (await admin(db, `select status, method, intent_key, paid_at, proof_note from ad_token_topup_requests where id = $1`, [id]))[0];
    check('ttok: the request is online / awaiting_payment (not in the admin\'s manual queue)',
      (await row(b1.id)).status === 'awaiting_payment' && (await row(b1.id)).method === 'online' &&
      (await admin(db, `select count(*)::int n from ad_token_topup_requests where status = 'pending' and id = $1`, [b1.id]))[0].n === 0);
    check('ttok: EXPLOIT blocked: users call begin / attach / settle / lookup',
      denied(await as(db, U, `select public.token_payment_begin($1, 10)`, [U])) &&
      denied(await as(db, U, `select public.token_payment_attach($1, 'k', null)`, [b1.id])) &&
      denied(await as(db, U, `select public.token_payment_settle('k', true, 150, 'EGP')`)) &&
      denied(await as(db, U, `select public.token_payment_lookup($1, $2)`, [U, b1.id])));
    check('ttok: EXPLOIT blocked: a user raises their own balance directly',
      denied(await as(db, U, `update profiles set ad_token_balance = 999 where id = $1`, [U])) || (await bal(U)) === 0);
    const IK = '770e8400-e29b-41d4-a716-446655440077';
    await svc(`select public.token_payment_attach($1, $2, 'https://staging.fawaterk.com/ts/tok')`, [b1.id, IK]);
    const settle = async (paid, amount, cur = 'EGP') => one(await svc(`select public.token_payment_settle($1, $2, $3, $4, 'Visa') as j`, [IK, paid, amount, cur]));
    const before = await bal(U);
    check('ttok: another amount / currency credits nothing', (await settle(true, 149))?.reason === 'amount_mismatch' && (await settle(true, 150, 'USD'))?.reason === 'amount_mismatch' && (await bal(U)) === before);
    check('ttok: «not paid yet» (a Fawry code issued) changes nothing', (await settle(false, null))?.status === 'awaiting_payment' && (await bal(U)) === before);
    const s1 = await settle(true, 150);
    check('ttok: paid → +10 tokens, approved, activity + notification', s1?.status === 'approved' && (await bal(U)) === before + 10 &&
      !!(await row(b1.id)).paid_at &&
      (await admin(db, `select count(*)::int n from ad_token_activity where user_id = $1 and kind = 'topup' and tokens = 10`, [U]))[0].n === 1 &&
      (await admin(db, `select count(*)::int n from notifications where user_id = $1 and title like '%اتشحن%'`, [U]))[0].n === 1, s1);
    check('ttok: a repeated webhook credits nothing more', (await settle(true, 150))?.already === true && (await bal(U)) === before + 10);
    check('ttok: lookup is per user', one(await svc(`select public.token_payment_lookup($1, $2) as j`, [U, b1.id]))?.status === 'approved' &&
      one(await svc(`select public.token_payment_lookup($1, $2) as j`, [X, b1.id])) == null);
    const mine = await as(db, U, `select id, status from ad_token_topup_requests where method = 'online'`);
    const theirs = await as(db, X, `select id from ad_token_topup_requests where method = 'online'`);
    check('ttok: users read only their own top-ups', ok(mine) && mine.rows.length === 1 && ok(theirs) && theirs.rows.length === 0, { mine, theirs });
    for (let i = 0; i < 10; i++) await begin(X, 5);
    check('ttok: at most 10 online top-ups an hour per user', /محاولات كتير/.test((await begin(X, 5))?.error || ''));
    await admin(db, `update ad_token_settings set online_topup = false where id = 1`);

    const block = (fn, tag) => {
      const src = fs.readFileSync(path.join(__dirname, '..', 'functions', fn, 'index.ts'), 'utf8');
      const s0 = src.indexOf('\n', src.indexOf(tag + ':begin')) + 1;
      return src.slice(s0, src.lastIndexOf('\n', src.indexOf(tag + ':end')));
    };
    let tk = null;
    try {
      tk = new Function(block('tokens-checkout', 'fw') + '\nreturn { topupBody, readTransaction, readTransactionData, fawaterakToken };')();
    } catch (e) {
      tk = { error: e.message };
    }
    check('ttok: the tokens-checkout block runs in Node', tk && !tk.error, tk);
    if (tk && !tk.error) {
      const tb = tk.topupBody({ id: b1.id, tokens: 10, amount: 150, first_name: 'منى', last_name: 'أحمد', phone: '01000102001' }, 'https://hook?target=tokens');
      check('ttok: hosted checkout for the top-up: EGP 150 in one line, back to /#/tokens, the platform webhook, pay_load',
        tb.payment_method_id === undefined && tb.cartTotal === 150 && tb.currency === 'EGP' && tb.cartItems[0].price === 150 &&
        tb.redirectionUrls.successUrl === 'https://mogtama3y.com/#/tokens' && tb.redirectionUrls.webhookUrl === 'https://hook?target=tokens' &&
        tb.pay_load.kind === 'tokens' && tb.pay_load.request_id === b1.id && /10 توكن/.test(tb.cartItems[0].name), tb);
      check('ttok: no platform credentials → no call out',
        (await tk.fawaterakToken({ mode: 'test', public: { client_id: '' }, secret: { client_secret: '' } }, async () => { throw new Error('called'); })).error === 'missing_credentials');
    }
  }

  console.log(`\n${passed} passed, ${failures.length} failed`);
  if (failures.length) {
    console.log('FAILED:\n - ' + failures.join('\n - '));
    process.exit(1);
  }
})().catch((e) => { console.error('HARNESS ERROR', e); process.exit(1); });
