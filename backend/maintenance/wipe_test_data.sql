-- =====================================================================
-- ONE-TIME: wipe all test data before launch.  NOT a migration.
--
-- Deletes EVERY account (including admins) and everything users created:
-- buildings, units, memberships, posts, chats, listings, auctions, jobs,
-- lost & found, SOS alerts, visitor passes, wallets and their ledger,
-- top-up/withdrawal requests, notifications, support tickets, …
--
-- Keeps:
--   * shops imported from Google Maps (real public data) — with no owner
--   * ad_token_settings (token price, the transfer wallet number)
--   * marketplace_categories
--
-- This cannot be undone. Run STEP 1 first and read the numbers; then run
-- STEP 2 on its own. Files in Storage (photos, ID documents) are NOT
-- removed by SQL — empty the buckets from Dashboard → Storage.
-- =====================================================================


-- ---------------------------------------------------------------------
-- STEP 1 — preview (changes nothing)
-- ---------------------------------------------------------------------
select 'accounts' as what, count(*) from auth.users
union all select 'buildings', count(*) from public.buildings
union all select 'union members', count(*) from public.union_members
union all select 'marketplace listings', count(*) from public.marketplace_listings
union all select 'wallets with money', count(*) from public.wallets where available_balance <> 0 or held_balance <> 0
union all select 'notifications', count(*) from public.notifications
union all select 'digital addresses', count(*) from public.e_addresses
union all select 'merchant test stores (deleted)', count(*) from public.shops where google_place_id is null
union all select 'Google shops (kept)', count(*) from public.shops where google_place_id is not null;


-- ---------------------------------------------------------------------
-- STEP 2 — wipe (run separately, after checking STEP 1)
-- ---------------------------------------------------------------------
begin;

-- Keep only the shops imported from Google Maps, detached from any test
-- owner; test stores registered from the merchant panel go.
create temp table _kept_shops on commit drop as
  select * from public.shops where google_place_id is not null;
update _kept_shops set owner_id = null, is_claimed = false, claimed_at = null,
  slug = null, whatsapp = null, scan_count = 0;

do $$
declare
  v_tables text;
begin
  select string_agg(format('public.%I', table_name), ', ')
    into v_tables
  from information_schema.tables
  where table_schema = 'public'
    and table_type = 'BASE TABLE'
    and table_name not in ('ad_token_settings', 'marketplace_categories');

  -- CASCADE also empties shops (it references profiles); restored below.
  execute 'truncate table ' || v_tables || ' restart identity cascade';
end;
$$;

insert into public.shops select * from _kept_shops;

-- Every login account (profiles/wallets are already gone).
delete from auth.users;

commit;


-- ---------------------------------------------------------------------
-- AFTER: sign up again in the app, then make yourself admin
-- (replace the email):
-- ---------------------------------------------------------------------
-- update public.profiles set role = 'super_admin'
-- where id = (select id from auth.users where email = 'you@example.com');
