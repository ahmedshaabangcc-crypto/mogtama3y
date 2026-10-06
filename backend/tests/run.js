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
    won?.bidder_id === T && (await admin(db, `select 1 from notifications where user_id = $1 and title like 'فزت بالمزاد:%'`, [T])).length === 1);
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
  check('opens by mobile number when enabled', (await as(db, null, `select public.get_e_address('01011111111') as a`)).rows?.[0]?.a?.handle === 'salam-maadi');
  check('…also written as +20 1011111111', (await as(db, null, `select public.get_e_address('+20 1011111111') as a`)).rows?.[0]?.a?.handle === 'salam-maadi');
  const h2 = await as(db, M, `select public.save_my_e_address(null, $1::jsonb) as code`, [JSON.stringify({ ...addr, label: 'الشغل', phone_lookup: true })]);
  check('only one address per person answers the mobile number',
    ok(h2) && (await admin(db, `select count(*)::int n from e_addresses where owner_id = $1 and phone_lookup`, [M]))[0].n === 1);
  check('the number now opens the newer choice', (await as(db, null, `select public.get_e_address('01011111111') as a`)).rows?.[0]?.a?.label === 'الشغل');
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
  check('EXPLOIT blocked: reading messages directly', denied(await as(db, P3, `select * from direct_messages`)));
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

  console.log(`\n${passed} passed, ${failures.length} failed`);
  if (failures.length) {
    console.log('FAILED:\n - ' + failures.join('\n - '));
    process.exit(1);
  }
})().catch((e) => { console.error('HARNESS ERROR', e); process.exit(1); });
