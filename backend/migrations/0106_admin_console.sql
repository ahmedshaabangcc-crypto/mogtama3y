-- =====================================================================
-- Migration 0106 — the super-admin console (desktop dashboard).
--
-- Owner (2026-10-30): «لوحة تحكم أدمن احترافية … بقائمة جانبية ومربعات
-- تحليل … للمشتركين والمتاجر والعماير وكل شئ … لحظة بلحظة».
--
--   * admin_overview(): the KPI cards — users (total / today / 7 / 30 days /
--     active 24 h / by country), stores (total / with products / with an
--     owner, orders today / 30 days, sales by currency), buildings &
--     unions, ad-token revenue (today / month, online vs manual), and every
--     queue waiting for the admin.
--   * admin_series(p_days): per day — sign-ups, store orders, token revenue
--     (the overview charts).
--   * admin_users(p_q, p_offset, p_limit): the users table (search by name /
--     phone), with last sign-in (auth.users), country, role, stores owned.
--   * admin_token_payments(p_status, p_offset, p_limit): ad-token top-ups,
--     online and manual, with totals.
--   * admin_shops(p_q, p_offset, p_limit): the stores table — owner,
--     products, orders, sales, online-payment gateway, last order.
-- All: super admins only (is_super_admin()), read-only.
-- Run after 0105. Safe to re-run.
-- =====================================================================

create or replace function public.admin_overview() returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_today timestamptz := date_trunc('day', now() at time zone 'Africa/Cairo') at time zone 'Africa/Cairo';
  v_month timestamptz := date_trunc('month', now() at time zone 'Africa/Cairo') at time zone 'Africa/Cairo';
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'at', now(),
    'users', jsonb_build_object(
      'total', (select count(*) from public.profiles),
      'today', (select count(*) from public.profiles where created_at >= v_today),
      'week', (select count(*) from public.profiles where created_at >= now() - interval '7 days'),
      'month', (select count(*) from public.profiles where created_at >= now() - interval '30 days'),
      'active_24h', (select count(*) from auth.users where last_sign_in_at >= now() - interval '24 hours'),
      'verified_phone', (select count(*) from public.profiles where phone_verified_at is not null),
      'by_country', coalesce((select jsonb_agg(jsonb_build_object('country', country, 'n', n) order by n desc)
                                from (select coalesce(country, 'EG') country, count(*) n from public.profiles group by 1 order by 2 desc limit 8) x), '[]'::jsonb)),
    'shops', jsonb_build_object(
      'total', (select count(*) from public.shops),
      'with_owner', (select count(*) from public.shops where owner_id is not null),
      'with_products', (select count(distinct shop_id) from public.shop_products),
      'online_payments', (select count(distinct shop_id) from public.shop_payment_gateways where enabled and status = 'connected'),
      'orders_today', (select count(*) from public.shop_orders where status <> 'cart' and created_at >= v_today),
      'orders_month', (select count(*) from public.shop_orders where status <> 'cart' and created_at >= now() - interval '30 days'),
      'sales_month', coalesce((select jsonb_agg(jsonb_build_object('currency', currency, 'total', total))
                                 from (select currency, sum(total_amount) total from public.shop_orders
                                        where status not in ('cart', 'cancelled') and created_at >= now() - interval '30 days'
                                        group by 1 order by 2 desc) x), '[]'::jsonb)),
    'community', jsonb_build_object(
      'buildings', (select count(*) from public.buildings),
      'presidents', (select count(*) from public.union_members where role = 'president' and status = 'verified'),
      'members', (select count(*) from public.union_members where status = 'verified'),
      'reports_month', (select count(*) from public.reports where created_at >= now() - interval '30 days'),
      'held_escrow', (select coalesce(sum(held_balance), 0) from public.wallets)),
    'tokens', jsonb_build_object(
      'revenue_today', (select coalesce(sum(amount_egp), 0) from public.ad_token_topup_requests where status = 'approved' and coalesce(paid_at, created_at) >= v_today),
      'revenue_month', (select coalesce(sum(amount_egp), 0) from public.ad_token_topup_requests where status = 'approved' and coalesce(paid_at, created_at) >= v_month),
      'online_month', (select coalesce(sum(amount_egp), 0) from public.ad_token_topup_requests where status = 'approved' and method = 'online' and paid_at >= v_month),
      'awaiting_online', (select count(*) from public.ad_token_topup_requests where status = 'awaiting_payment'),
      'balance_total', (select coalesce(sum(ad_token_balance), 0) from public.profiles),
      'online_enabled', (select online_topup from public.ad_token_settings where id = 1)),
    'queues', jsonb_build_object(
      'token_topups', (select count(*) from public.ad_token_topup_requests where status = 'pending'),
      'wallet_topups', (select count(*) from public.wallet_topup_requests where status = 'pending'),
      'withdrawals', (select count(*) from public.wallet_withdrawal_requests where status = 'pending'),
      'fund_withdrawals', (select count(*) from public.union_fund_withdrawal_requests where status = 'pending'),
      'shop_claims', (select count(*) from public.shop_claim_requests where status = 'pending'),
      'disputes', (select count(*) from public.maintenance_requests where status = 'disputed'),
      'reports_new', (select count(*) from public.reports where status = 'new'),
      'place_reports', (select count(*) from public.directory_place_reports where status = 'open'),
      'tickets', (select count(*) from public.support_tickets where status not in ('resolved', 'closed'))));
end;
$$;

create or replace function public.admin_series(p_days int default 30) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_days int := least(greatest(coalesce(p_days, 30), 7), 120);
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة' using errcode = '42501';
  end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
             'day', d.day,
             'signups', (select count(*) from public.profiles p where (p.created_at at time zone 'Africa/Cairo')::date = d.day),
             'orders', (select count(*) from public.shop_orders o where o.status <> 'cart' and (o.created_at at time zone 'Africa/Cairo')::date = d.day),
             'tokens', (select coalesce(sum(t.amount_egp), 0) from public.ad_token_topup_requests t
                         where t.status = 'approved' and (coalesce(t.paid_at, t.created_at) at time zone 'Africa/Cairo')::date = d.day))
           order by d.day)
    from (select generate_series((now() at time zone 'Africa/Cairo')::date - (v_days - 1), (now() at time zone 'Africa/Cairo')::date, interval '1 day')::date as day) d
  ), '[]'::jsonb);
end;
$$;

create or replace function public.admin_users(p_q text default null, p_offset int default 0, p_limit int default 50) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_q text := nullif(btrim(coalesce(p_q, '')), '');
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'total', (select count(*) from public.profiles p
               where v_q is null or p.full_name ilike '%' || v_q || '%' or p.phone ilike '%' || v_q || '%'),
    'rows', coalesce((
      select jsonb_agg(r order by r.created_at desc) from (
        select p.id, p.full_name, p.phone, coalesce(p.country, 'EG') country, p.role, p.is_verified,
               p.phone_verified_at is not null as phone_verified, p.created_at, u.last_sign_in_at, u.email,
               p.ad_token_balance,
               (select count(*) from public.shops s where s.owner_id = p.id) as shops
          from public.profiles p
          left join auth.users u on u.id = p.id
         where v_q is null or p.full_name ilike '%' || v_q || '%' or p.phone ilike '%' || v_q || '%'
         order by p.created_at desc
         offset greatest(coalesce(p_offset, 0), 0)
         limit least(greatest(coalesce(p_limit, 50), 1), 200)) r), '[]'::jsonb));
end;
$$;

create or replace function public.admin_token_payments(p_status text default null, p_offset int default 0, p_limit int default 50) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'total', (select count(*) from public.ad_token_topup_requests t where p_status is null or t.status = p_status),
    'approved_sum', (select coalesce(sum(amount_egp), 0) from public.ad_token_topup_requests where status = 'approved'),
    'rows', coalesce((
      select jsonb_agg(r order by r.created_at desc) from (
        select t.id, t.tokens_requested, t.amount_egp, t.status, t.method, t.provider, t.proof_note,
               t.created_at, t.paid_at, p.full_name, p.phone
          from public.ad_token_topup_requests t
          left join public.profiles p on p.id = t.user_id
         where p_status is null or t.status = p_status
         order by t.created_at desc
         offset greatest(coalesce(p_offset, 0), 0)
         limit least(greatest(coalesce(p_limit, 50), 1), 200)) r), '[]'::jsonb));
end;
$$;

create or replace function public.admin_shops(p_q text default null, p_offset int default 0, p_limit int default 50) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_q text := nullif(btrim(coalesce(p_q, '')), '');
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'total', (select count(*) from public.shops s
               where v_q is null or s.name ilike '%' || v_q || '%' or s.slug ilike '%' || v_q || '%'),
    'rows', coalesce((
      select jsonb_agg(r order by r.created_at desc) from (
        select s.id, s.name, s.slug, s.category, coalesce(s.country, 'EG') country, coalesce(s.currency, 'EGP') currency,
               s.source, s.is_claimed, s.created_at, s.whatsapp,
               o.full_name as owner_name, o.phone as owner_phone,
               (select count(*) from public.shop_products sp where sp.shop_id = s.id) as products,
               (select count(*) from public.shop_orders so where so.shop_id = s.id and so.status <> 'cart') as orders,
               (select coalesce(sum(so.total_amount), 0) from public.shop_orders so
                 where so.shop_id = s.id and so.status not in ('cart', 'cancelled')) as sales,
               (select max(so.created_at) from public.shop_orders so where so.shop_id = s.id and so.status <> 'cart') as last_order_at,
               (select g.provider from public.shop_payment_gateways g
                 where g.shop_id = s.id and g.enabled and g.status = 'connected' limit 1) as gateway
          from public.shops s
          left join public.profiles o on o.id = s.owner_id
         where v_q is null or s.name ilike '%' || v_q || '%' or s.slug ilike '%' || v_q || '%'
         order by s.created_at desc
         offset greatest(coalesce(p_offset, 0), 0)
         limit least(greatest(coalesce(p_limit, 50), 1), 200)) r), '[]'::jsonb));
end;
$$;

do $$
declare
  f text;
begin
  foreach f in array array[
    'public.admin_overview()',
    'public.admin_series(int)',
    'public.admin_users(text, int, int)',
    'public.admin_token_payments(text, int, int)',
    'public.admin_shops(text, int, int)'] loop
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end;
$$;
