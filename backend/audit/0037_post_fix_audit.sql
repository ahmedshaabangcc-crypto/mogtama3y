-- =====================================================================
-- Read-only audit to run once, right after migration 0037, in the
-- Supabase SQL editor. It changes nothing — it only lists rows that
-- look like the holes 0037 closed were already used. Run each query
-- separately and review the results by hand before correcting anything.
-- =====================================================================

-- 1) Everyone with an elevated profile role. Every row here should be
--    someone you set on purpose from the SQL editor.
select p.id, p.full_name, u.email, p.role, p.created_at, p.updated_at
from public.profiles p
join auth.users u on u.id = p.id
where p.role <> 'resident'
order by p.updated_at desc;

-- 2) profiles.is_verified = true. Nothing in the app sets this flag
--    today, so any true value was probably set by the user themselves.
select p.id, p.full_name, u.email, p.updated_at
from public.profiles p
join auth.users u on u.id = p.id
where p.is_verified;

-- 3) Every wallet holding any money. The app has no way to top up a
--    wallet yet, so unless you credited someone by hand from the SQL
--    editor, ANY non-zero balance here came from editing the wallet
--    directly (or from dues/escrow paid with that money). The
--    transaction count helps trace where it went.
select w.id as wallet_id, w.user_id, u.email,
       w.available_balance, w.held_balance, w.updated_at,
       count(t.id) as tx_count
from public.wallets w
join auth.users u on u.id = w.user_id
left join public.wallet_transactions t on t.wallet_id = w.id
where w.available_balance <> 0 or w.held_balance <> 0
group by w.id, u.email
order by w.available_balance desc;

-- 3b) Token top-ups approved by someone who is not on your list of
--     real admins (compare reviewed_by with query 1).
select r.id, r.user_id, r.tokens_requested, r.status, r.reviewed_by, p.full_name as reviewer
from public.ad_token_topup_requests r
left join public.profiles p on p.id = r.reviewed_by
where r.status = 'approved';

-- 4) Ad-token balances that don't match approved top-ups minus spend.
select p.id, p.full_name, p.ad_token_balance,
       coalesce(sum(a.tokens), 0) as activity_sum
from public.profiles p
left join public.ad_token_activity a on a.user_id = p.id
group by p.id
having p.ad_token_balance <> coalesce(sum(a.tokens), 0)
order by p.ad_token_balance desc;

-- 5) Non-positive union dues (the negative-due exploit).
select id, building_id, unit_id, period_label, amount, is_paid, paid_at
from public.union_dues
where amount <= 0;

-- 6) Maintenance requests with no escrow amount recovered from the
--    ledger (backfill couldn't find the booking row), or where the
--    quote was raised above what was actually held.
select id, resident_id, technician_id, status, escrow_status,
       escrow_amount, quoted_amount, created_at
from public.maintenance_requests
where escrow_status is not null
  and (escrow_amount is null or quoted_amount > escrow_amount)
order by created_at desc;

-- 7) Refunds/releases larger than what was held for the same request.
select r.id as request_id, r.escrow_amount,
       sum(t.amount) filter (where t.amount > 0) as paid_out
from public.maintenance_requests r
join public.wallet_transactions t
  on t.reference_table = 'maintenance_requests' and t.reference_id = r.id
group by r.id
having sum(t.amount) filter (where t.amount > 0) > coalesce(r.escrow_amount, 0);

-- 8) Listings featured without a matching token spend.
select 'marketplace_listings' as tbl, id, seller_id as owner_id, featured_until
from public.marketplace_listings where is_featured or featured_until is not null
union all
select 'real_estate_listings', id, owner_id, featured_until
from public.real_estate_listings where is_featured or featured_until is not null
union all
select 'job_postings', id, poster_id, featured_until
from public.job_postings where is_featured or featured_until is not null;
