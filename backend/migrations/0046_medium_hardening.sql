-- =====================================================================
-- Migration 0046 — the remaining medium-severity holes from the review.
--
--   1. Job applications: 0036 added proper RPCs but never dropped the
--      old "applicant manages own" FOR ALL policy — an applicant could
--      insert or update their own application as 'hired'.
--   2. Token top-up and shop-claim requests could be inserted/updated
--      directly (e.g. a top-up claiming 0 EGP, a claim already
--      'approved'); review_shop_claim didn't check the request was
--      still pending or the shop still unclaimed.
--   3. Recycling auctions: bids were raw inserts (negative amounts,
--      bidding on your own lot, bidding after the auction ended) and the
--      seller could set winning_bid_id to any bid. Now both go through
--      place_recycling_bid() / accept_recycling_top_bid().
--   4. create_union_due / propose_board_decision / create_election
--      picked the caller's building with LIMIT 1 and no ORDER BY — a
--      board member of two buildings acted on an arbitrary one. They now
--      take p_building_id (optional while only one building applies).
--   5. Every function in `public` was executable by anonymous callers
--      (PostgreSQL's default PUBLIC grant). Now only signed-in users (and
--      the service role) can call them, and new functions no longer get
--      that default.
--
-- Run after 0045, in order, in the Supabase SQL editor.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Job applications: RPCs only (apply_to_job / review_job_application)
-- ---------------------------------------------------------------------

drop policy if exists "job_applications: applicant manages own" on public.job_applications;
revoke insert, update, delete on public.job_applications from authenticated, anon;


-- ---------------------------------------------------------------------
-- 2. Token top-up + shop-claim requests
-- ---------------------------------------------------------------------

drop policy if exists "ad_token_topup_requests: requester manages own" on public.ad_token_topup_requests;
create policy "ad_token_topup_requests: requester views own" on public.ad_token_topup_requests
  for select using (auth.uid() = user_id);
revoke insert, update, delete on public.ad_token_topup_requests from authenticated, anon;

drop policy if exists "shop_claim_requests: requester manages own" on public.shop_claim_requests;
create policy "shop_claim_requests: requester views own" on public.shop_claim_requests
  for select using (auth.uid() = requester_id);
create policy "shop_claim_requests: requester files pending claim" on public.shop_claim_requests
  for insert with check (auth.uid() = requester_id and status = 'pending' and reviewed_by is null);
revoke update, delete on public.shop_claim_requests from authenticated, anon;

create or replace function public.review_shop_claim(p_request_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات تملك المحلات';
  end if;

  select * into v_request from public.shop_claim_requests where id = p_request_id for update;
  if not found or v_request.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;
  if p_approve and exists (select 1 from public.shops where id = v_request.shop_id and is_claimed) then
    raise exception 'هذا المحل له مالك معتمد بالفعل';
  end if;

  update public.shop_claim_requests set status = case when p_approve then 'approved' else 'rejected' end, reviewed_by = auth.uid()
    where id = p_request_id;

  if p_approve then
    update public.shops set owner_id = v_request.requester_id, is_claimed = true, claimed_at = now()
      where id = v_request.shop_id;
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.requester_id,
    case when p_approve then 'تم قبول طلب تملك المحل' else 'تم رفض طلب تملك المحل' end,
    case when p_approve then 'تهانينا! تم تفعيل ملكيتك للمحل، يمكنك الآن إدارته من التطبيق.'
         else 'للأسف تم رفض طلب تملك المحل، تواصل مع الدعم لمزيد من التفاصيل.' end
  );
end;
$$;


-- ---------------------------------------------------------------------
-- 3. Recycling auctions
-- ---------------------------------------------------------------------

drop policy if exists "recycling_listings: seller manages own" on public.recycling_listings;
create policy "recycling_listings: seller views own" on public.recycling_listings
  for select using (auth.uid() = seller_id);
create policy "recycling_listings: seller creates own" on public.recycling_listings
  for insert with check (auth.uid() = seller_id);
revoke update, delete on public.recycling_listings from authenticated, anon;

-- New lots start active, with no winner, ending 1 hour – 30 days from now.
create or replace function public.guard_recycling_listing_insert() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user in ('authenticated', 'anon') then
    new.status := 'active';
    new.winning_bid_id := null;
    if new.auction_ends_at is null
       or new.auction_ends_at < now() + interval '1 hour'
       or new.auction_ends_at > now() + interval '30 days' then
      raise exception 'مدة المزاد يجب أن تكون بين ساعة و30 يوماً';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_recycling_listing_insert on public.recycling_listings;
create trigger guard_recycling_listing_insert
  before insert on public.recycling_listings
  for each row execute function public.guard_recycling_listing_insert();

drop policy if exists "recycling_bids: bidder creates own" on public.recycling_bids;
revoke insert, update, delete on public.recycling_bids from authenticated, anon;

create or replace function public.place_recycling_bid(p_listing_id uuid, p_amount numeric) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_listing record;
  v_top numeric;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_listing from public.recycling_listings where id = p_listing_id for update;
  if not found then
    raise exception 'المزاد غير موجود';
  end if;
  if v_listing.status <> 'active' or v_listing.auction_ends_at <= now() then
    raise exception 'انتهى هذا المزاد';
  end if;
  if v_listing.seller_id = auth.uid() then
    raise exception 'لا يمكنك المزايدة على مزادك';
  end if;
  if p_amount is null or p_amount <= 0 or p_amount > 1000000 then
    raise exception 'قيمة المزايدة غير صحيحة';
  end if;

  select max(amount) into v_top from public.recycling_bids where listing_id = p_listing_id;
  if v_top is not null and p_amount <= v_top then
    raise exception 'يجب أن تكون المزايدة أعلى من % ج.م', v_top;
  end if;

  insert into public.recycling_bids (listing_id, bidder_id, amount)
  values (p_listing_id, auth.uid(), round(p_amount, 2))
  returning id into v_id;

  insert into public.notifications (user_id, title, body)
  values (v_listing.seller_id, 'مزايدة جديدة على: ' || v_listing.title, 'وصلت أعلى مزايدة الآن إلى ' || round(p_amount, 2) || ' ج.م.');

  return v_id;
end;
$$;

create or replace function public.accept_recycling_top_bid(p_listing_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_listing record;
  v_top record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_listing from public.recycling_listings where id = p_listing_id for update;
  if not found or v_listing.seller_id <> auth.uid() then
    raise exception 'غير مصرح لك بإنهاء هذا المزاد';
  end if;
  if v_listing.status <> 'active' then
    raise exception 'هذا المزاد منتهي بالفعل';
  end if;

  select id, bidder_id, amount into v_top from public.recycling_bids
    where listing_id = p_listing_id
    order by amount desc, created_at asc
    limit 1;

  update public.recycling_listings
  set status = 'ended', winning_bid_id = v_top.id
  where id = p_listing_id;

  if v_top.id is not null then
    insert into public.notifications (user_id, title, body)
    values (v_top.bidder_id, 'فزت بالمزاد: ' || v_listing.title, 'قبل البائع مزايدتك (' || v_top.amount || ' ج.م). تواصل معه لترتيب الاستلام.');
  end if;
end;
$$;

revoke execute on function public.place_recycling_bid(uuid, numeric) from public, anon;
revoke execute on function public.accept_recycling_top_bid(uuid) from public, anon;
grant execute on function public.place_recycling_bid(uuid, numeric) to authenticated;
grant execute on function public.accept_recycling_top_bid(uuid) to authenticated;


-- ---------------------------------------------------------------------
-- 4. Board actions act on an explicit building
-- ---------------------------------------------------------------------

-- The building the caller is a verified president/board member of:
-- p_building_id when given (and they really are board there); otherwise
-- their only such building, or an error if there is more than one.
create or replace function public._board_building_for(p_building_id uuid) returns uuid
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_ids uuid[];
begin
  select array_agg(building_id) into v_ids from public.union_members
    where user_id = auth.uid() and status = 'verified' and role in ('president', 'board_member');
  if v_ids is null then
    return null;
  end if;
  if p_building_id is not null then
    return case when p_building_id = any(v_ids) then p_building_id else null end;
  end if;
  if array_length(v_ids, 1) > 1 then
    raise exception 'أنت عضو مجلس في أكثر من عمارة — حدّد العمارة أولاً';
  end if;
  return v_ids[1];
end;
$$;

revoke execute on function public._board_building_for(uuid) from public, anon, authenticated;

drop function if exists public.create_union_due(text, numeric, date);
create or replace function public.create_union_due(
  p_period_label text,
  p_amount numeric,
  p_due_date date,
  p_building_id uuid default null
) returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_count integer;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_amount is null or p_amount <= 0 then
    raise exception 'قيمة المستحق يجب أن تكون أكبر من صفر';
  end if;

  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null then
    raise exception 'غير مصرح لك بإصدار مستحقات صيانة';
  end if;

  insert into public.union_dues (building_id, unit_id, period_label, amount, due_date)
  select v_building_id, u.id, p_period_label, p_amount, p_due_date
  from public.units u
  where u.building_id = v_building_id;

  get diagnostics v_count = row_count;

  insert into public.notifications (user_id, title, body)
  select m.user_id,
         'مستحق صيانة جديد',
         p_period_label || ' - ' || p_amount || ' ج.م، تاريخ الاستحقاق ' || p_due_date
  from public.union_members m
  where m.building_id = v_building_id and m.status = 'verified';

  return v_count;
end;
$$;

drop function if exists public.propose_board_decision(text, text, boolean);
create or replace function public.propose_board_decision(
  p_title text,
  p_description text,
  p_requires_unanimous boolean,
  p_building_id uuid default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_eligible int;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null then
    raise exception 'غير مصرح لك باقتراح قرار مجلس';
  end if;

  select count(*) into v_eligible from public.union_members
    where building_id = v_building_id and status = 'verified' and role in ('president', 'board_member');

  insert into public.board_decisions (building_id, proposed_by, title, description, requires_unanimous, eligible_voters)
  values (v_building_id, auth.uid(), p_title, p_description, p_requires_unanimous, v_eligible)
  returning id into v_id;

  return v_id;
end;
$$;

drop function if exists public.create_election(text, timestamptz, numeric);
create or replace function public.create_election(
  p_title text,
  p_closes_at timestamptz,
  p_legal_quorum_pct numeric default 50.00,
  p_building_id uuid default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_eligible int;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_closes_at is null or p_closes_at < now() + interval '23 hours' then
    raise exception 'مدة التصويت يجب ألا تقل عن يوم واحد';
  end if;
  if p_closes_at > now() + interval '60 days' then
    raise exception 'مدة التصويت يجب ألا تزيد عن 60 يوماً';
  end if;

  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null then
    raise exception 'غير مصرح لك بإنشاء انتخابات لهذه العمارة';
  end if;

  if exists (select 1 from public.union_elections where building_id = v_building_id and not is_finalized) then
    raise exception 'توجد انتخابات مفتوحة بالفعل لهذه العمارة';
  end if;

  select count(*) into v_eligible
  from public.union_members m
  join public.unit_residents ur
    on ur.user_id = m.user_id and ur.unit_id = m.unit_id
   and ur.residency_type = 'owner' and ur.is_primary
  where m.building_id = v_building_id and m.status = 'verified';

  insert into public.union_elections (building_id, title, legal_quorum_pct, eligible_voters, closes_at)
  values (v_building_id, p_title, 50.00, v_eligible, p_closes_at)
  returning id into v_id;

  return v_id;
end;
$$;


-- ---------------------------------------------------------------------
-- 5. No anonymous access to database functions
-- ---------------------------------------------------------------------

-- Functions get EXECUTE for PUBLIC by default, which includes `anon`.
-- Signed-in users keep everything they could call before; the internal
-- helpers that were deliberately closed stay closed.
revoke execute on all functions in schema public from public, anon;
grant execute on all functions in schema public to authenticated, service_role;
revoke execute on function public._create_profile_and_wallet(uuid) from authenticated;
revoke execute on function public._board_building_for(uuid) from authenticated;
revoke execute on function public.bump_places_usage(text, int) from authenticated;

-- Functions created later don't get the PUBLIC default either; each
-- migration grants what it needs explicitly.
alter default privileges in schema public revoke execute on functions from public;
