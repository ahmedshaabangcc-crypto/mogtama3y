-- =====================================================================
-- Migration 0092 — the Arab world, phase 2: a currency on everything
-- that has a price.
--
-- 0089 gave every profile a country and a currency. Now every priced row
-- carries its own ISO currency (and, for the public listings, a country
-- the feeds filter on), filled from the creator's profile when the client
-- doesn't send one. Every existing row is EGP / EG, so Egyptian users see
-- exactly what they saw before («ج.م»).
--
--   * currency (ISO 4217, not null) + country (ISO2, not null) on
--     marketplace_listings, real_estate_listings, car_listings,
--     job_postings, event_halls, tutor_listings, pet_listings,
--     kids_listings, recycling_listings (bids are in the lot's currency),
--     shops and buildings (dues / fund / expenses / reports are in the
--     building's currency).
--   * currency only on lost_found_items (reward) and maintenance_requests
--     (quote) — they are building-scoped, not feeds.
--   * shop_products / shop_orders take the shop's currency (forced from
--     the shop on insert; products follow a shop that changes currency).
--   * EGP-scale caps (delivery fee ≤ 1000, product ≤ 1,000,000, tutor
--     ≤ 100,000, bid ≤ 1,000,000) are multiplied by
--     private.money_cap(): the currency's rough units per EGP, never below
--     1 — so a Lebanese shop can charge 50,000 ل.ل delivery while an
--     Egyptian one is still capped at 1000 ج.م.
--   * Notification and error texts print private.money_text(amount,
--     currency) of their entity (create_union_due, recycling bids, shop
--     orders, store checkout, order status, delivery fee, the union fund,
--     dues reminders). The wallet (0045) stays Egypt-only EGP — its texts
--     just go through money_text(…, 'EGP') too.
--   * Wallet money is EGP: paying a due from the wallet and withdrawing a
--     building fund into the wallet work for EGP buildings only (others pay
--     the treasurer cash / get paid out by hand) — phase 4 adds payments.
--   * get_store_order, scrap_dealer_matching_lots, recycling_my_bids and
--     admin_list_union_fund_withdrawals return the currency.
--
-- Run after 0091. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ============================================================ helpers

-- Rough units of a currency per 1 EGP (late 2026, generous for the
-- volatile ones). Only used to scale sanity caps — never to convert money.
create or replace function private.currency_rate(p text) returns numeric
language sql immutable as $$
  select case upper(coalesce(p, 'EGP'))
    when 'EGP' then 1 when 'SAR' then 0.08 when 'AED' then 0.08 when 'QAR' then 0.08 when 'KWD' then 0.0065
    when 'BHD' then 0.008 when 'OMR' then 0.008 when 'JOD' then 0.015 when 'ILS' then 0.08 when 'LYD' then 0.12
    when 'TND' then 0.065 when 'MAD' then 0.2 when 'USD' then 0.021 when 'EUR' then 0.02 when 'GBP' then 0.017
    when 'MRU' then 0.85 when 'TRY' then 0.9 when 'DZD' then 3 when 'DJF' then 4 when 'KMF' then 10
    when 'SOS' then 12 when 'IQD' then 30 when 'YER' then 35 when 'SDG' then 50 when 'SYP' then 300
    when 'LBP' then 2000 when 'IRR' then 2000
    else 1 end::numeric
$$;

-- An EGP-scale upper limit in another currency (never lower than in EGP).
-- Security definer: check constraints run it as the writing user.
create or replace function private.money_cap(p_egp numeric, p_currency text) returns numeric
language sql immutable security definer set search_path = public as $$
  select p_egp * greatest(1, private.currency_rate(p_currency))
$$;

-- An EGP-scale minimum (10 ج.م → 0.065 د.ك), rounded to the minor unit.
create or replace function private.money_min(p_egp numeric, p_currency text) returns numeric
language sql immutable security definer set search_path = public as $$
  select greatest(round(p_egp * private.currency_rate(p_currency), 3), 0.001)
$$;

create or replace function private.building_currency(p_building uuid) returns text
language plpgsql stable security definer set search_path = public as $$
begin
  return coalesce((select currency from public.buildings where id = p_building), 'EGP');
end;
$$;
revoke execute on function private.building_currency(uuid) from public, anon, authenticated;

-- BEFORE INSERT: currency (and country, when the table has one) from what
-- the client sent if valid, else from the creator's profile
-- (TG_ARGV[0] = the creator column; '' = the signed-in user), else EG/EGP.
create or replace function public._row_money_defaults() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  j jsonb := to_jsonb(new);
  v_uid uuid;
  v_country text;
  v_cur text;
  v_patch jsonb := '{}'::jsonb;
begin
  begin
    v_uid := case when coalesce(tg_argv[0], '') = '' then auth.uid()
                  else nullif(j ->> tg_argv[0], '')::uuid end;
  exception when others then
    v_uid := null;
  end;
  v_country := upper(nullif(btrim(coalesce(j ->> 'country', '')), ''));
  if not (j ? 'country') or not private.is_arab_country(v_country) then
    v_country := coalesce((select p.country from public.profiles p where p.id = v_uid), 'EG');
  end if;
  if j ? 'country' then
    v_patch := v_patch || jsonb_build_object('country', v_country);
  end if;
  v_cur := upper(nullif(btrim(coalesce(j ->> 'currency', '')), ''));
  if v_cur is null or v_cur !~ '^[A-Z]{3}$' then
    v_cur := private.country_currency(v_country);
  end if;
  v_patch := v_patch || jsonb_build_object('currency', v_cur);
  new := jsonb_populate_record(new, v_patch);
  return new;
end;
$$;
revoke execute on function public._row_money_defaults() from public, anon, authenticated;

-- ============================================================== tables

do $$
declare
  t record;
begin
  -- (table, creator column, has country)
  for t in select * from (values
      ('marketplace_listings', 'seller_id', true),
      ('real_estate_listings', 'owner_id', true),
      ('car_listings', 'owner_id', true),
      ('job_postings', 'poster_id', true),
      ('event_halls', 'owner_id', true),
      ('tutor_listings', 'owner_id', true),
      ('pet_listings', 'owner_id', true),
      ('kids_listings', 'owner_id', true),
      ('recycling_listings', 'seller_id', true),
      ('shops', 'owner_id', true),
      ('buildings', '', true),
      ('lost_found_items', 'reporter_id', false),
      ('maintenance_requests', 'resident_id', false)
    ) v(tbl, creator, has_country)
  loop
    -- Existing rows: Egypt. New rows: the trigger (no column default, so it
    -- can tell "not sent" from "sent EGP").
    if not exists (select 1 from information_schema.columns
                    where table_schema = 'public' and table_name = t.tbl and column_name = 'currency') then
      execute format('alter table public.%I add column currency text not null default %L', t.tbl, 'EGP');
    end if;
    execute format('alter table public.%I alter column currency drop default', t.tbl);
    execute format('alter table public.%I drop constraint if exists %I', t.tbl, t.tbl || '_currency_iso');
    execute format('alter table public.%I add constraint %I check (currency ~ ''^[A-Z]{3}$'')', t.tbl, t.tbl || '_currency_iso');
    if t.has_country then
      if not exists (select 1 from information_schema.columns
                      where table_schema = 'public' and table_name = t.tbl and column_name = 'country') then
        execute format('alter table public.%I add column country text not null default %L', t.tbl, 'EG');
      end if;
      execute format('alter table public.%I alter column country drop default', t.tbl);
      execute format('alter table public.%I drop constraint if exists %I', t.tbl, t.tbl || '_country_iso');
      execute format('alter table public.%I add constraint %I check (country ~ ''^[A-Z]{2}$'')', t.tbl, t.tbl || '_country_iso');
      execute format('create index if not exists %I on public.%I (country, created_at desc)', t.tbl || '_country_recent', t.tbl);
    end if;
    execute format('drop trigger if exists row_money_defaults on public.%I', t.tbl);
    execute format('create trigger row_money_defaults before insert on public.%I for each row execute function public._row_money_defaults(%L)',
                   t.tbl, t.creator);
  end loop;
end;
$$;

-- Column-restricted tables: the new columns are readable like the price.
grant select (currency, country) on public.pet_listings to anon, authenticated;
grant select (currency, country) on public.kids_listings to anon;
grant select (currency) on public.lost_found_items to authenticated;
grant select (currency) on public.maintenance_requests to authenticated;
grant select (country, currency) on public.buildings to anon;

-- ---------------------------------------------------- shops' children
alter table public.shop_products add column if not exists currency text not null default 'EGP';
alter table public.shop_orders add column if not exists currency text not null default 'EGP';
alter table public.shop_products drop constraint if exists shop_products_currency_iso;
alter table public.shop_products add constraint shop_products_currency_iso check (currency ~ '^[A-Z]{3}$');
alter table public.shop_orders drop constraint if exists shop_orders_currency_iso;
alter table public.shop_orders add constraint shop_orders_currency_iso check (currency ~ '^[A-Z]{3}$');
grant select (currency) on public.shop_orders to authenticated;
update public.shop_products p set currency = s.currency from public.shops s
 where s.id = p.shop_id and p.currency is distinct from s.currency;

-- A product / order is always in its shop's currency.
create or replace function public._shop_child_currency() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  new.currency := coalesce((select s.currency from public.shops s where s.id = new.shop_id), 'EGP');
  return new;
end;
$$;
revoke execute on function public._shop_child_currency() from public, anon, authenticated;
drop trigger if exists shop_child_currency on public.shop_products;
create trigger shop_child_currency before insert or update of shop_id, currency on public.shop_products
  for each row execute function public._shop_child_currency();
drop trigger if exists shop_child_currency on public.shop_orders;
create trigger shop_child_currency before insert on public.shop_orders
  for each row execute function public._shop_child_currency();

-- A shop that changes currency takes its catalogue along (orders keep
-- the currency they were placed in).
create or replace function public._shop_currency_follow() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  update public.shop_products set currency = new.currency where shop_id = new.id and currency <> new.currency;
  return null;
end;
$$;
revoke execute on function public._shop_currency_follow() from public, anon, authenticated;
drop trigger if exists shop_currency_follow on public.shops;
create trigger shop_currency_follow after update of currency on public.shops
  for each row when (new.currency is distinct from old.currency) execute function public._shop_currency_follow();

-- ======================================================= scaled limits

alter table public.shops drop constraint if exists shops_delivery_fee_valid;
alter table public.shops add constraint shops_delivery_fee_valid
  check (delivery_fee >= 0 and delivery_fee <= private.money_cap(1000, currency)
         and (free_delivery_over is null or free_delivery_over > 0));

alter table public.shop_products drop constraint if exists shop_products_valid;
alter table public.shop_products add constraint shop_products_valid
  check (price >= 0 and price <= private.money_cap(1000000, currency) and length(trim(name)) between 1 and 120);

-- Room for the bigger numbers of LBP / IQD / SYP prices.
alter table public.tutor_listings alter column price type numeric(14,2);
alter table public.kids_listings alter column price type numeric(14,2);
alter table public.shops alter column delivery_fee type numeric(14,2);
alter table public.shop_orders alter column delivery_fee type numeric(14,2);
alter table public.tutor_listings drop constraint if exists tutor_listings_price_check;
alter table public.tutor_listings drop constraint if exists tutor_listings_price_valid;
alter table public.tutor_listings add constraint tutor_listings_price_valid
  check (price > 0 and price <= private.money_cap(100000, currency));

-- ================================================================ RPCs

-- 0057's delivery fee: the cap and its message in the shop's currency.
create or replace function public.set_my_shop_delivery(p_shop_id uuid, p_fee numeric, p_free_over numeric default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_cur text := (select currency from public.shops where id = p_shop_id and owner_id = auth.uid());
begin
  if v_cur is null then
    raise exception 'المحل ده مش بتاعك';
  end if;
  if p_fee is null or p_fee < 0 or p_fee > private.money_cap(1000, v_cur) then
    raise exception 'قيمة التوصيل لازم تكون من 0 لـ %', private.money_text(private.money_cap(1000, v_cur), v_cur);
  end if;
  if p_free_over is not null and p_free_over <= 0 then
    raise exception 'حد التوصيل المجاني لازم يكون أكبر من صفر';
  end if;
  update public.shops set delivery_fee = round(p_fee, 3), free_delivery_over = p_free_over
   where id = p_shop_id and owner_id = auth.uid();
  if not found then
    raise exception 'المحل ده مش بتاعك';
  end if;
end;
$$;
revoke execute on function public.set_my_shop_delivery(uuid, numeric, numeric) from public, anon;
grant execute on function public.set_my_shop_delivery(uuid, numeric, numeric) to authenticated;

-- 0046 / 0037: a due notice in the building's currency.
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
         p_period_label || ' - ' || private.money_text(p_amount, private.building_currency(v_building_id))
           || '، تاريخ الاستحقاق ' || p_due_date
  from public.union_members m
  where m.building_id = v_building_id and m.status = 'verified';

  return v_count;
end;
$$;
revoke execute on function public.create_union_due(text, numeric, date, uuid) from public, anon;
grant execute on function public.create_union_due(text, numeric, date, uuid) to authenticated;

-- 0075's bids: cap and texts in the lot's currency.
create or replace function public.place_recycling_bid(p_listing_id uuid, p_amount numeric) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_listing record;
  v_top numeric;
  v_prev_bidder uuid;
  v_id uuid;
  v_link text := '/#/recycling/' || p_listing_id;
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
  if p_amount is null or p_amount <= 0 or p_amount > private.money_cap(1000000, v_listing.currency) then
    raise exception 'قيمة المزايدة غير صحيحة';
  end if;

  select amount, bidder_id into v_top, v_prev_bidder from public.recycling_bids
    where listing_id = p_listing_id
    order by amount desc, created_at asc
    limit 1;
  if v_top is not null and p_amount <= v_top then
    raise exception 'يجب أن تكون المزايدة أعلى من %', private.money_text(v_top, v_listing.currency);
  end if;

  insert into public.recycling_bids (listing_id, bidder_id, amount)
  values (p_listing_id, auth.uid(), round(p_amount, 2))
  returning id into v_id;

  insert into public.notifications (user_id, title, body, deep_link)
  values (v_listing.seller_id, 'مزايدة جديدة على: ' || v_listing.title,
          'وصلت أعلى مزايدة الآن إلى ' || private.money_text(round(p_amount, 2), v_listing.currency) || '.', v_link);

  if v_prev_bidder is not null and v_prev_bidder <> auth.uid() then
    insert into public.notifications (user_id, title, body, deep_link)
    values (v_prev_bidder, 'عرضك اتعدّى',
            'عرضك على مزاد «' || v_listing.title || '» اتعدّى، أعلى عرض دلوقتي '
              || private.money_text(round(p_amount, 2), v_listing.currency),
            v_link);
  end if;

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
    insert into public.notifications (user_id, title, body, deep_link)
    values (v_top.bidder_id, 'مبروك! البائع قبل عرضك',
            'على «' || v_listing.title || '» بـ ' || private.money_text(v_top.amount, v_listing.currency)
              || ' — افتح المزاد وكلّم البائع عشان تتفقوا على الاستلام.',
            '/#/recycling/' || p_listing_id);
  end if;
end;
$$;
revoke execute on function public.place_recycling_bid(uuid, numeric) from public, anon;
revoke execute on function public.accept_recycling_top_bid(uuid) from public, anon;
grant execute on function public.place_recycling_bid(uuid, numeric) to authenticated;
grant execute on function public.accept_recycling_top_bid(uuid) to authenticated;

-- 0075's dealer lists + the lot's currency (return type changes).
drop function if exists public.scrap_dealer_matching_lots();
create function public.scrap_dealer_matching_lots()
returns table (
  id uuid, title text, material text, category text, governorate text, area text,
  estimated_weight_kg numeric, auction_ends_at timestamptz, created_at timestamptz,
  top_amount numeric, bid_count integer, my_amount numeric, distance_km double precision, currency text)
language sql
stable
security definer
set search_path = public
as $$
  select l.id, l.title, l.material, l.category::text, l.governorate, l.area,
         l.estimated_weight_kg, l.auction_ends_at, l.created_at,
         (select max(b.amount) from public.recycling_bids b where b.listing_id = l.id),
         (select count(*)::int from public.recycling_bids b where b.listing_id = l.id),
         (select max(b.amount) from public.recycling_bids b where b.listing_id = l.id and b.bidder_id = d.user_id),
         case when d.base_lat is not null and l.lat is not null
              then public.scrap_distance_km(d.base_lat, d.base_lng, l.lat, l.lng) end,
         l.currency
  from public.scrap_dealers d
  join public.recycling_listings l on l.status = 'active' and l.auction_ends_at > now()
  where d.user_id = auth.uid()
    and public.scrap_dealer_matches_lot(d, l)
  order by l.auction_ends_at
  limit 100;
$$;

drop function if exists public.recycling_my_bids();
create function public.recycling_my_bids()
returns table (
  listing_id uuid, title text, material text, category text, governorate text, area text,
  status text, auction_ends_at timestamptz, my_amount numeric, top_amount numeric,
  bid_count integer, won boolean, last_bid_at timestamptz, currency text)
language sql
stable
security definer
set search_path = public
as $$
  select l.id, l.title, l.material, l.category::text, l.governorate, l.area,
         l.status::text, l.auction_ends_at, mine.amount,
         (select max(b.amount) from public.recycling_bids b where b.listing_id = l.id),
         (select count(*)::int from public.recycling_bids b where b.listing_id = l.id),
         exists (select 1 from public.recycling_bids w where w.id = l.winning_bid_id and w.bidder_id = auth.uid()),
         mine.last_at,
         l.currency
  from (
    select b.listing_id, max(b.amount) as amount, max(b.created_at) as last_at
    from public.recycling_bids b
    where b.bidder_id = auth.uid()
    group by b.listing_id
  ) mine
  join public.recycling_listings l on l.id = mine.listing_id
  order by mine.last_at desc
  limit 200;
$$;
revoke execute on function public.scrap_dealer_matching_lots() from public, anon;
revoke execute on function public.recycling_my_bids() from public, anon;
grant execute on function public.scrap_dealer_matching_lots() to authenticated;
grant execute on function public.recycling_my_bids() to authenticated;

-- 0089's in-app order: the total in the shop's currency.
create or replace function public.place_shop_order(
  p_shop_id uuid,
  p_items jsonb,
  p_customer_phone text,
  p_note text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop record;
  v_phone text := private.phone_store(p_customer_phone, private.my_country());
  v_order_id uuid;
  v_item jsonb;
  v_product record;
  v_qty int;
  v_total numeric(14,2) := 0;
  v_count int := 0;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول عشان تقدر تطلب';
  end if;
  select * into v_shop from public.shops where id = p_shop_id;
  if not found or v_shop.owner_id is null then
    raise exception 'المحل ده مش مستقبل طلبات حالياً';
  end if;
  if v_shop.owner_id = auth.uid() then
    raise exception 'مينفعش تطلب من محلك';
  end if;
  if v_phone is null then
    raise exception 'اكتب رقم موبايل صحيح عشان المحل يتواصل معاك';
  end if;
  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'السلة فاضية';
  end if;
  if jsonb_array_length(p_items) > 50 then
    raise exception 'الطلب فيه منتجات كتير، قسّمه على أكتر من طلب';
  end if;
  if (select count(*) from public.shop_orders where buyer_id = auth.uid() and created_at > now() - interval '1 hour') >= 10 then
    raise exception 'طلبات كتير في وقت قصير، جرّب بعد شوية';
  end if;

  insert into public.shop_orders (shop_id, buyer_id, status, total_amount, customer_phone, note)
  values (p_shop_id, auth.uid(), 'placed', 0, v_phone, nullif(left(trim(coalesce(p_note, '')), 500), ''))
  returning id into v_order_id;

  for v_item in select * from jsonb_array_elements(p_items) loop
    v_qty := coalesce((v_item->>'quantity')::int, 0);
    if v_qty < 1 or v_qty > 99 then
      raise exception 'الكمية غير صحيحة';
    end if;
    select * into v_product from public.shop_products
      where id = (v_item->>'product_id')::uuid and shop_id = p_shop_id and is_available;
    if not found then
      raise exception 'فيه منتج في السلة مبقاش متاح، حدّث الصفحة';
    end if;
    insert into public.shop_order_items (order_id, product_id, quantity, unit_price)
    values (v_order_id, v_product.id, v_qty, v_product.price);
    v_total := v_total + v_product.price * v_qty;
    v_count := v_count + v_qty;
  end loop;

  update public.shop_orders set total_amount = v_total where id = v_order_id;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد لمحل ' || v_shop.name,
          v_count || ' منتج بإجمالي ' || private.money_text(v_total, v_shop.currency) || ' — موبايل العميل ' || v_phone
            || '. افتح لوحة التاجر لتفاصيل الطلب.');

  return v_order_id;
end;
$$;
revoke execute on function public.place_shop_order(uuid, jsonb, text, text) from public, anon;
grant execute on function public.place_shop_order(uuid, jsonb, text, text) to authenticated;

-- 0089's store checkout: totals and delivery in the shop's currency.
create or replace function public.place_store_order(
  p_shop_id uuid,
  p_items jsonb,
  p_customer_name text,
  p_customer_phone text,
  p_address text,
  p_note text default null
) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop record;
  v_phone text := private.phone_store(p_customer_phone, private.my_country());
  v_name text := left(trim(coalesce(p_customer_name, '')), 80);
  v_address text := left(trim(coalesce(p_address, '')), 400);
  v_order_id uuid;
  v_code text;
  v_item jsonb;
  v_product record;
  v_qty int;
  v_opts text;
  v_total numeric(14,2) := 0;
  v_delivery numeric(14,2) := 0;
  v_count int := 0;
  v_bytes bytea;
  v_idx int;
begin
  select * into v_shop from public.shops where id = p_shop_id;
  if not found or v_shop.owner_id is null then
    raise exception 'المحل ده مش مستقبل طلبات حالياً';
  end if;
  if auth.uid() is not null and v_shop.owner_id = auth.uid() then
    raise exception 'مينفعش تطلب من محلك';
  end if;
  if length(v_name) < 2 then
    raise exception 'اكتب اسمك';
  end if;
  if v_phone is null then
    raise exception 'رقم موبايل مش صحيح';
  end if;
  if length(v_address) < 8 then
    raise exception 'اكتب العنوان بالتفصيل عشان الطلب يوصلك';
  end if;
  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'السلة فاضية';
  end if;
  if jsonb_array_length(p_items) > 50 then
    raise exception 'الطلب فيه منتجات كتير، قسّمه على أكتر من طلب';
  end if;
  if (select count(*) from public.shop_orders where customer_phone = v_phone and shop_id = p_shop_id and created_at > now() - interval '1 hour') >= 5
     or (select count(*) from public.shop_orders where customer_phone = v_phone and created_at > now() - interval '1 day') >= 20 then
    raise exception 'طلبات كتير من الرقم ده في وقت قصير، جرّب بعد شوية';
  end if;

  loop
    v_bytes := uuid_send(gen_random_uuid());
    v_code := 'T';
    foreach v_idx in array array[0, 1, 2, 3, 4, 5, 10] loop
      v_code := v_code || substr('23456789ABCDEFGHJKLMNPQRSTUVWXYZ', (get_byte(v_bytes, v_idx) % 32) + 1, 1);
    end loop;
    exit when not exists (select 1 from public.shop_orders where order_code = v_code);
  end loop;

  insert into public.shop_orders (shop_id, buyer_id, status, total_amount, customer_name, customer_phone, delivery_address, note, order_code)
  values (p_shop_id, auth.uid(), 'placed', 0, v_name, v_phone, v_address, nullif(left(trim(coalesce(p_note, '')), 500), ''), v_code)
  returning id into v_order_id;

  for v_item in select * from jsonb_array_elements(p_items) loop
    v_qty := coalesce((v_item->>'quantity')::int, 0);
    if v_qty < 1 or v_qty > 99 then
      raise exception 'الكمية غير صحيحة';
    end if;
    select * into v_product from public.shop_products
      where id = (v_item->>'product_id')::uuid and shop_id = p_shop_id and is_available
      for update;
    if not found then
      raise exception 'فيه منتج في السلة مبقاش متاح، حدّث الصفحة';
    end if;
    if v_product.stock is not null then
      if v_product.stock < v_qty then
        raise exception 'الكمية المتاحة من «%» هي % بس', v_product.name, v_product.stock;
      end if;
      update public.shop_products set stock = stock - v_qty where id = v_product.id;
    end if;
    v_opts := nullif(left(trim(coalesce(v_item->>'options', '')), 120), '');
    insert into public.shop_order_items (order_id, product_id, quantity, unit_price, chosen_options)
    values (v_order_id, v_product.id, v_qty, v_product.price, v_opts);
    v_total := v_total + v_product.price * v_qty;
    v_count := v_count + v_qty;
  end loop;

  v_delivery := coalesce(v_shop.delivery_fee, 0);
  if v_shop.free_delivery_over is not null and v_total >= v_shop.free_delivery_over then
    v_delivery := 0;
  end if;
  update public.shop_orders set delivery_fee = v_delivery, total_amount = v_total + v_delivery where id = v_order_id;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد ' || v_code || ' — ' || v_shop.name,
          v_name || ' طلب ' || v_count || ' منتج بإجمالي ' || private.money_text(v_total + v_delivery, v_shop.currency)
            || ' (شامل التوصيل). افتح «الطلبات» في متجري.');

  return v_code;
end;
$$;
revoke execute on function public.place_store_order(uuid, jsonb, text, text, text, text) from public;
grant execute on function public.place_store_order(uuid, jsonb, text, text, text, text) to anon, authenticated;

-- 0057's tracking page + the order's currency.
create or replace function public.get_store_order(p_code text) returns jsonb
language sql
security definer
stable
set search_path = public
as $$
  select jsonb_build_object(
    'code', o.order_code,
    'status', o.status,
    'total', o.total_amount,
    'delivery_fee', o.delivery_fee,
    'currency', o.currency,
    'created_at', o.created_at,
    'customer_name', o.customer_name,
    'shop_name', s.name,
    'shop_slug', s.slug,
    'shop_whatsapp', s.whatsapp,
    'items', coalesce((
      select jsonb_agg(jsonb_build_object('name', p.name, 'quantity', i.quantity, 'price', i.unit_price, 'options', i.chosen_options))
        from public.shop_order_items i join public.shop_products p on p.id = i.product_id
       where i.order_id = o.id), '[]'::jsonb)
  )
  from public.shop_orders o join public.shops s on s.id = o.shop_id
  where o.order_code = upper(trim(p_code));
$$;
revoke execute on function public.get_store_order(text) from public;
grant execute on function public.get_store_order(text) to anon, authenticated;

-- 0068's status change: the order's own currency.
create or replace function public.update_shop_order_status(p_order_id uuid, p_status text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_order record;
  v_is_owner boolean;
  v_label text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select o.*, s.owner_id, s.name as shop_name into v_order
    from public.shop_orders o join public.shops s on s.id = o.shop_id
    where o.id = p_order_id for update of o;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;
  v_is_owner := v_order.owner_id = auth.uid();

  if v_is_owner then
    if not (
      (v_order.status = 'placed' and p_status in ('preparing', 'cancelled'))
      or (v_order.status = 'preparing' and p_status in ('delivering', 'delivered', 'cancelled'))
      or (v_order.status = 'delivering' and p_status in ('delivered', 'cancelled'))
    ) then
      raise exception 'مينفعش تغيّر حالة الطلب بالشكل ده';
    end if;
  elsif v_order.buyer_id = auth.uid() then
    if not (v_order.status = 'placed' and p_status = 'cancelled') then
      raise exception 'تقدر تلغي الطلب بس قبل ما المحل يبدأ يجهّزه';
    end if;
  else
    raise exception 'غير مصرح لك';
  end if;

  update public.shop_orders set status = p_status::shop_order_status where id = p_order_id;

  v_label := case p_status
    when 'preparing' then 'المحل بيجهّز طلبك'
    when 'delivering' then 'طلبك في الطريق'
    when 'delivered' then 'تم تسليم طلبك'
    when 'cancelled' then 'تم إلغاء الطلب'
  end;
  if (case when v_is_owner then v_order.buyer_id else v_order.owner_id end) is null then
    return;
  end if;
  insert into public.notifications (user_id, title, body)
  values (
    case when v_is_owner then v_order.buyer_id else v_order.owner_id end,
    v_label || ' — ' || v_order.shop_name,
    'طلب بقيمة ' || private.money_text(v_order.total_amount, v_order.currency) || '.'
  );
end;
$$;
revoke execute on function public.update_shop_order_status(uuid, text) from public, anon;
grant execute on function public.update_shop_order_status(uuid, text) to authenticated;

-- ---------------------------------------------------- the union fund

-- 0076: the "not enough" error in the building's currency.
create or replace function public._union_fund_post(
  p_building_id uuid,
  p_type text,
  p_amount numeric,
  p_due_id uuid,
  p_unit_id uuid,
  p_note text,
  p_receipt_path text,
  p_by uuid
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_balance numeric;
  v_id uuid;
begin
  insert into public.union_funds (building_id) values (p_building_id) on conflict (building_id) do nothing;
  select balance into v_balance from public.union_funds where building_id = p_building_id for update;
  if v_balance + p_amount < 0 then
    raise exception 'رصيد صندوق العمارة مش كفاية (المتاح %)', private.money_text(v_balance, private.building_currency(p_building_id));
  end if;
  update public.union_funds set balance = balance + p_amount, updated_at = now() where building_id = p_building_id;
  insert into public.union_fund_transactions (building_id, type, amount, due_id, unit_id, note, receipt_path, created_by)
  values (p_building_id, p_type, p_amount, p_due_id, p_unit_id, p_note, p_receipt_path, p_by)
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public._union_fund_post(uuid, text, numeric, uuid, uuid, text, text, uuid) from public, anon, authenticated;

-- 0076: wallet payment (the wallet is EGP — Egyptian buildings only).
create or replace function public.pay_union_due(p_due_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_due record;
  v_wallet record;
  v_unit text;
  v_manager uuid;
  v_cur text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_due from public.union_dues where id = p_due_id for update;
  if not found then
    raise exception 'المستحق غير موجود';
  end if;
  if v_due.is_paid then
    raise exception 'تم سداد هذا المستحق بالفعل';
  end if;
  if v_due.amount <= 0 then
    raise exception 'قيمة المستحق غير صحيحة';
  end if;

  if not exists (
    select 1 from public.union_members m
    where m.unit_id = v_due.unit_id and m.user_id = auth.uid() and m.status = 'verified'
  ) then
    raise exception 'غير مصرح لك بسداد هذا المستحق';
  end if;

  v_cur := private.building_currency(v_due.building_id);
  if v_cur <> 'EGP' then
    raise exception 'السداد من المحفظة متاح للعمارات في مصر بس — ادفع لأمين الصندوق كاش وهو يسجّله';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < v_due.amount then
    raise exception 'رصيد المحفظة غير كافٍ لسداد هذا المستحق';
  end if;

  update public.wallets set available_balance = available_balance - v_due.amount, updated_at = now()
    where id = v_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'union_dues', 'completed', -v_due.amount, 'union_dues', v_due.id);

  update public.union_dues set is_paid = true, paid_at = now(), paid_via = 'wallet'
    where id = p_due_id;

  perform public._union_fund_post(v_due.building_id, 'due_payment', v_due.amount, v_due.id, v_due.unit_id,
                                  'سداد «' || v_due.period_label || '» من المحفظة', null, auth.uid());

  select unit_number into v_unit from public.units where id = v_due.unit_id;
  v_manager := public._union_fund_manager_of(v_due.building_id);
  if v_manager is not null and v_manager <> auth.uid() then
    insert into public.notifications (user_id, title, body, deep_link)
    values (v_manager, '💰 وصل سداد صيانة',
            'شقة ' || coalesce(v_unit, '—') || ' دفعت «' || v_due.period_label || '» — '
              || private.money_text(v_due.amount, v_cur) || ' دخلت صندوق العمارة.',
            '/#/union-fund');
  end if;
end;
$$;
revoke execute on function public.pay_union_due(uuid) from public, anon;
grant execute on function public.pay_union_due(uuid) to authenticated;

create or replace function public.mark_due_paid_cash(p_due_id uuid, p_note text default null) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_due record;
  v_unit text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_due from public.union_dues where id = p_due_id for update;
  if not found then
    raise exception 'المستحق غير موجود';
  end if;
  if not public.is_union_fund_manager(v_due.building_id) then
    raise exception 'تسجيل الدفع الكاش لأمين الصندوق (أو الرئيس لو مفيش أمين صندوق) بس';
  end if;
  if v_due.is_paid then
    raise exception 'تم سداد هذا المستحق بالفعل';
  end if;
  if v_due.amount <= 0 then
    raise exception 'قيمة المستحق غير صحيحة';
  end if;

  update public.union_dues set is_paid = true, paid_at = now(), paid_via = 'cash' where id = p_due_id;

  select unit_number into v_unit from public.units where id = v_due.unit_id;
  perform public._union_fund_post(v_due.building_id, 'cash_due', v_due.amount, v_due.id, v_due.unit_id,
    coalesce(nullif(trim(p_note), ''), 'سداد كاش «' || v_due.period_label || '» — شقة ' || coalesce(v_unit, '—')),
    null, auth.uid());

  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, 'اتسجّل سدادك ✓',
         'أمين الصندوق سجّل إن «' || v_due.period_label || '» ('
           || private.money_text(v_due.amount, private.building_currency(v_due.building_id)) || ') اتدفع كاش لشقتك.',
         '/#/union-pay'
    from public.union_members m
   where m.unit_id = v_due.unit_id and m.status = 'verified' and m.user_id <> auth.uid();
end;
$$;
revoke execute on function public.mark_due_paid_cash(uuid, text) from public, anon;
grant execute on function public.mark_due_paid_cash(uuid, text) to authenticated;

-- 0089's fund withdrawal: minimum and texts in the building's currency;
-- into the (EGP) wallet only for Egyptian buildings.
create or replace function public.request_fund_withdrawal(
  p_building uuid,
  p_amount numeric,
  p_note text,
  p_payout_phone text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_balance numeric;
  v_pending numeric;
  v_raw text := nullif(private.phone_clean(p_payout_phone), '');
  v_phone text;
  v_name text;
  v_id uuid;
  v_cur text := private.building_currency(p_building);
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not public.is_union_fund_manager(p_building) then
    raise exception 'طلب السحب من الصندوق لأمين الصندوق (أو الرئيس لو مفيش أمين صندوق) بس';
  end if;
  if p_amount is null or p_amount < private.money_min(10, v_cur) then
    raise exception 'أقل مبلغ للسحب %', private.money_text(private.money_min(10, v_cur), v_cur);
  end if;
  if p_note is null or length(trim(p_note)) < 3 then
    raise exception 'اكتب سبب السحب';
  end if;
  if v_raw is not null then
    v_phone := private.phone_store(v_raw, private.my_country());
    if v_phone is null then
      raise exception 'رقم المحفظة مش صحيح';
    end if;
  elsif v_cur <> 'EGP' then
    raise exception 'اكتب الرقم اللي هيتحوّل عليه المبلغ (محفظة مُجتمعي بالجنيه المصري بس)';
  end if;

  insert into public.union_funds (building_id) values (p_building) on conflict (building_id) do nothing;
  select balance into v_balance from public.union_funds where building_id = p_building for update;
  select coalesce(sum(amount_egp), 0) into v_pending from public.union_fund_withdrawal_requests
   where building_id = p_building and status = 'pending';
  if v_balance - v_pending < p_amount then
    raise exception 'رصيد الصندوق المتاح مش كفاية (المتاح بعد الطلبات المعلّقة %)', private.money_text(v_balance - v_pending, v_cur);
  end if;

  insert into public.union_fund_withdrawal_requests (building_id, requested_by, amount_egp, destination, payout_phone, note)
  values (p_building, auth.uid(), round(p_amount, 3), case when v_phone is null then 'wallet' else 'payout' end, v_phone, trim(p_note))
  returning id into v_id;

  select name into v_name from public.buildings where id = p_building;
  insert into public.notifications (user_id, title, body, deep_link)
  select p.id, '🏦 طلب سحب من صندوق عمارة',
         private.money_text(round(p_amount, 3), v_cur) || ' من صندوق «' || coalesce(v_name, '') || '» محتاج مراجعتك.', '/#/admin'
    from public.profiles p where p.role = 'super_admin';

  return v_id;
end;
$$;
revoke execute on function public.request_fund_withdrawal(uuid, numeric, text, text) from public, anon;
grant execute on function public.request_fund_withdrawal(uuid, numeric, text, text) to authenticated;

-- 0076's review: texts in the building's currency (amount_egp is the
-- historical column name; it holds the building's currency).
create or replace function public.review_union_fund_withdrawal(p_request_id uuid, p_paid boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  r public.union_fund_withdrawal_requests;
  v_wallet_id uuid;
  v_cur text;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات السحب';
  end if;

  select * into r from public.union_fund_withdrawal_requests where id = p_request_id for update;
  if not found or r.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;
  v_cur := private.building_currency(r.building_id);
  if p_paid and r.destination = 'wallet' and v_cur <> 'EGP' then
    raise exception 'محفظة مُجتمعي بالجنيه المصري بس — حوّل المبلغ يدوياً وارفض الطلب ده';
  end if;

  if p_paid then
    perform public._union_fund_post(r.building_id, 'withdrawal', -r.amount_egp, null, null,
      'سحب: ' || r.note || case when r.destination = 'wallet' then ' (إلى محفظة مُجتمعي)' else ' (تحويل إلى ' || r.payout_phone || ')' end,
      null, r.requested_by);
    if r.destination = 'wallet' then
      perform public._create_profile_and_wallet(r.requested_by);
      update public.wallets set available_balance = available_balance + r.amount_egp, updated_at = now()
       where user_id = r.requested_by
      returning id into v_wallet_id;
      insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_wallet_id, 'union_dues', 'completed', r.amount_egp, 'union_fund_withdrawal_requests', r.id);
    end if;
  end if;

  update public.union_fund_withdrawal_requests
     set status = case when p_paid then 'paid' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
   where id = p_request_id;

  insert into public.notifications (user_id, title, body, deep_link)
  values (r.requested_by,
    case when p_paid then 'تم تنفيذ طلب السحب من الصندوق' else 'تم رفض طلب السحب من الصندوق' end,
    case when p_paid and r.destination = 'wallet' then private.money_text(r.amount_egp, v_cur) || ' اتحوّلت من صندوق العمارة لمحفظتك.'
         when p_paid then private.money_text(r.amount_egp, v_cur) || ' اتحوّلت من صندوق العمارة على ' || r.payout_phone || '.'
         else 'طلب سحب ' || private.money_text(r.amount_egp, v_cur) || ' اترفض ورصيد الصندوق زي ما هو. تواصل مع الدعم لمعرفة السبب.' end,
    '/#/union-fund');
end;
$$;
revoke execute on function public.review_union_fund_withdrawal(uuid, boolean) from public, anon;
grant execute on function public.review_union_fund_withdrawal(uuid, boolean) to authenticated;

drop function if exists public.admin_list_union_fund_withdrawals();
create function public.admin_list_union_fund_withdrawals() returns table (
  id uuid, building_id uuid, building_name text, user_id uuid, full_name text, phone text,
  amount_egp numeric, destination text, payout_phone text, note text, fund_balance numeric, created_at timestamptz,
  currency text
)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  return query
    select r.id, r.building_id, b.name, r.requested_by, p.full_name, p.phone,
           r.amount_egp, r.destination, r.payout_phone, r.note, coalesce(f.balance, 0), r.created_at,
           b.currency
      from public.union_fund_withdrawal_requests r
      join public.buildings b on b.id = r.building_id
      join public.profiles p on p.id = r.requested_by
      left join public.union_funds f on f.building_id = r.building_id
     where r.status = 'pending'
     order by r.created_at;
end;
$$;
revoke execute on function public.admin_list_union_fund_withdrawals() from public, anon;
grant execute on function public.admin_list_union_fund_withdrawals() to authenticated;

-- 0076's «فكّر الكل»: the sum in the building's currency.
create or replace function public.remind_unpaid_dues(p_building uuid) returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_last timestamptz;
  v_count integer;
  v_cur text := private.building_currency(p_building);
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not (
    public.is_union_fund_manager(p_building)
    or exists (select 1 from public.union_members m
                where m.building_id = p_building and m.user_id = auth.uid()
                  and m.status = 'verified' and m.role in ('president', 'board_member'))
  ) then
    raise exception 'التذكير للرئيس ومجلس الإدارة وأمين الصندوق بس';
  end if;

  select last_sent_at into v_last from public.union_due_reminders where building_id = p_building for update;
  if v_last is not null and v_last > now() - interval '24 hours' then
    raise exception 'فكّرت الجيران من شوية — تقدر تفكّرهم تاني بعد 24 ساعة من آخر تذكير';
  end if;

  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, '⏰ تذكير بمستحقات الصيانة',
         'عليك ' || private.money_text(sum(d.amount), v_cur) || ' مستحقات صيانة لسه ما اتدفعتش ('
           || string_agg(d.period_label, '، ' order by d.created_at) || ').'
           || case when v_cur = 'EGP' then ' ادفع من التطبيق في ثانية.' else ' ادفعها لأمين الصندوق.' end,
         '/#/union-pay'
    from public.union_dues d
    join public.union_members m on m.unit_id = d.unit_id and m.building_id = d.building_id and m.status = 'verified'
   where d.building_id = p_building and not d.is_paid
   group by m.user_id;
  get diagnostics v_count = row_count;

  insert into public.union_due_reminders (building_id, last_sent_at, sent_by)
  values (p_building, now(), auth.uid())
  on conflict (building_id) do update set last_sent_at = excluded.last_sent_at, sent_by = excluded.sent_by;

  return v_count;
end;
$$;
revoke execute on function public.remind_unpaid_dues(uuid) from public, anon;
grant execute on function public.remind_unpaid_dues(uuid) to authenticated;

-- ------------------------------------------- the wallet (EGP, 0045)

create or replace function public.review_wallet_topup(p_request_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_wallet_id uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات شحن المحفظة';
  end if;

  select * into v_request from public.wallet_topup_requests where id = p_request_id for update;
  if not found or v_request.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;

  update public.wallet_topup_requests
  set status = case when p_approve then 'approved' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
  where id = p_request_id;

  if p_approve then
    perform public._create_profile_and_wallet(v_request.user_id);
    update public.wallets set available_balance = available_balance + v_request.amount_egp, updated_at = now()
      where user_id = v_request.user_id
      returning id into v_wallet_id;
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_wallet_id, 'top_up', 'completed', v_request.amount_egp, 'wallet_topup_requests', p_request_id);
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.user_id,
    case when p_approve then 'تم شحن محفظتك' else 'تم رفض طلب شحن المحفظة' end,
    case when p_approve then private.money_text(v_request.amount_egp, 'EGP') || ' أُضيفت لرصيد محفظتك.'
         else 'لم نتمكن من مطابقة التحويل (' || private.money_text(v_request.amount_egp, 'EGP') || '). تواصل مع الدعم إذا كنت حوّلت المبلغ بالفعل.' end
  );
end;
$$;
revoke execute on function public.review_wallet_topup(uuid, boolean) from public, anon;
grant execute on function public.review_wallet_topup(uuid, boolean) to authenticated;

create or replace function public.review_wallet_withdrawal(p_request_id uuid, p_paid boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_wallet_id uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات السحب';
  end if;

  select * into v_request from public.wallet_withdrawal_requests where id = p_request_id for update;
  if not found or v_request.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;

  select id into v_wallet_id from public.wallets where user_id = v_request.user_id for update;

  update public.wallet_withdrawal_requests
  set status = case when p_paid then 'paid' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
  where id = p_request_id;

  if p_paid then
    update public.wallet_transactions set status = 'completed'
      where reference_table = 'wallet_withdrawal_requests' and reference_id = p_request_id;
  else
    update public.wallets set available_balance = available_balance + v_request.amount_egp, updated_at = now()
      where id = v_wallet_id;
    update public.wallet_transactions set status = 'reversed'
      where reference_table = 'wallet_withdrawal_requests' and reference_id = p_request_id;
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.user_id,
    case when p_paid then 'تم تحويل أرباحك' else 'تم رفض طلب السحب' end,
    case when p_paid then private.money_text(v_request.amount_egp, 'EGP') || ' حُوّلت إلى محفظتك ' || v_request.payout_phone || '.'
         else 'أعدنا ' || private.money_text(v_request.amount_egp, 'EGP') || ' إلى رصيدك المتاح. تواصل مع الدعم لمعرفة السبب.' end
  );
end;
$$;
revoke execute on function public.review_wallet_withdrawal(uuid, boolean) from public, anon;
grant execute on function public.review_wallet_withdrawal(uuid, boolean) to authenticated;
