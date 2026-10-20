-- =====================================================================
-- Migration 0099 — متجري phase 3: checkout, shipping & discounts.
--
--   * Shipping («الشحن والتوصيل»): shop_shipping_settings (one row per
--     shop) + shop_shipping_zones (a zone = a set of governorates / areas
--     of the shop's country with its own fee, free-over threshold and ETA
--     text). An area belongs to at most one zone. Anything outside the
--     zones gets the default rate «باقي المناطق» — which IS the old flat
--     fee (shops.delivery_fee / free_delivery_over, 0057: old builds and
--     store-lite keep reading it, set_my_shop_delivery keeps writing it) —
--     or «مش بنوصّل هناك» (default_mode = 'none'). Pickup from the store
--     (address, instructions), store hours per weekday (in the shop
--     country's time zone; outside them orders are accepted with a notice
--     or refused — after_hours), vacation mode, the «بنستقبل طلبات»
--     switch, a minimum order (on the subtotal before discounts) and
--     «اطلب تأكيد واتساب قبل التجهيز». Every existing owned shop gets a
--     settings row with default_mode 'rate' (its flat fee = the default).
--   * Discounts («الخصومات»): shop_discounts — codes (case-insensitive,
--     unique per shop) and automatic discounts (no code); percent, fixed
--     amount or free shipping; on the whole order, some products or some
--     collections (0098's «الأقسام», manual or rule-based); minimum subtotal, total and per-phone limits, start /
--     end dates, active switch. shop_discount_uses records which order
--     used which discount (per-phone limit, «الطلبات اللي استخدمته»);
--     cancelling an order gives the use back.
--     STACKING RULE: an order gets at most ONE code (the one typed) and at
--     most ONE automatic discount (the eligible one saving the most). They
--     add up only when the code says so (combines = «يتجمع مع الخصومات
--     التلقائية»); otherwise the customer gets whichever saves more (a tie
--     goes to the code). A free-shipping discount saves the shipping fee.
--     The amount off never exceeds the subtotal.
--   * Pricing lives in helpers that place_store_order and the public
--     quote_store_checkout() share: private.checkout_lines (prices the
--     cart from the database — never the client), private.checkout_quote
--     (shipping, discounts, totals, blocking errors), private.shop_open_state.
--     place_store_order (latest body: 0096) takes the area, fulfillment,
--     code, cart token and the total the customer saw (a mismatch is
--     refused: «الأسعار اتغيرت»), and snapshots subtotal, discount_code /
--     discount_amount / discount_title, shipping (delivery_fee), shipping
--     zone / area and fulfillment on the order (+ a «discount» event).
--     Wrong codes are rate-limited (10 per phone / IP per hour, 200 per
--     shop per hour); place_store_order returns NULL (nothing placed, the
--     try counted) for a wrong / blocked code instead of raising.
--   * Abandoned checkouts: shop_carts — saved when the customer types the
--     phone (+ name) at checkout (save_store_cart, rate-limited, priced
--     server-side); the owner lists carts idle for more than an hour
--     without an order (merchant_abandoned_carts) and sends «كمّل طلبك»
--     on WhatsApp with /#/s/<slug>?cart=<token> (get_store_cart restores
--     only the lines — no name / phone). Placing an order from the shop
--     with that phone or token marks the cart recovered. Owner-only;
--     carts older than 30 days are deleted.
--   * COD confirmation: shop_orders.confirmation_status ('pending' for
--     every store order, 'confirmed' by merchant_confirm_order → «confirm»
--     event). With require_confirmation on, a pending order cannot move to
--     «بيتجهّز» (trigger — whoever changes the status).
--   * Guest cancel: guest_cancel_store_order(code, phone last 4, reason)
--     while the order is «placed» — 5 wrong tries per order per hour;
--     notifies the merchant; the timeline shows it as the customer.
--   * «عملة المتجر»: set_shop_currency(shop, code) — any of the 22 Arab
--     states' currencies (₪ for Palestine) or USD / EUR / GBP (labels,
--     decimals and caps: 0089 / 0092). Products follow, orders keep
--     theirs; nothing is converted, so a switch that would break a cap
--     (delivery / zone fee, product price) is refused.
--   * Zones use the first-level divisions of the shop's country (the app's
--     admin_areas: محافظة / منطقة / إمارة / ولاية…), matched by name.
--
-- Run after 0098. Safe to re-run (tests re-apply it after re-running 0096).
-- =====================================================================

create schema if not exists private;

-- The 6-argument store checkout of 0092 / 0096 (re-created when 0096 is
-- re-run) — replaced by the longer one below (old callers still fit it).
drop function if exists public.place_store_order(uuid, jsonb, text, text, text, text);

-- ============================================================ helpers

-- The time zone of each of the 22 states (shop hours).
create or replace function private.country_tz(p text) returns text
language sql immutable as $$
  select case upper(coalesce(p, 'EG'))
    when 'SA' then 'Asia/Riyadh' when 'AE' then 'Asia/Dubai' when 'KW' then 'Asia/Kuwait' when 'QA' then 'Asia/Qatar'
    when 'BH' then 'Asia/Bahrain' when 'OM' then 'Asia/Muscat' when 'YE' then 'Asia/Aden' when 'JO' then 'Asia/Amman'
    when 'PS' then 'Asia/Hebron' when 'LB' then 'Asia/Beirut' when 'SY' then 'Asia/Damascus' when 'IQ' then 'Asia/Baghdad'
    when 'SD' then 'Africa/Khartoum' when 'LY' then 'Africa/Tripoli' when 'TN' then 'Africa/Tunis' when 'DZ' then 'Africa/Algiers'
    when 'MA' then 'Africa/Casablanca' when 'MR' then 'Africa/Nouakchott' when 'SO' then 'Africa/Mogadishu'
    when 'DJ' then 'Africa/Djibouti' when 'KM' then 'Indian/Comoro'
    else 'Africa/Cairo' end
$$;

-- An area name for matching: trimmed, single spaces, أ/إ/آ → ا, ة → ه, ى → ي.
create or replace function private.area_key(p text) returns text
language sql immutable as $$
  select nullif(lower(translate(btrim(regexp_replace(coalesce(p, ''), '\s+', ' ', 'g')), 'أإآةى', 'اااهي')), '')
$$;

-- A discount code as stored: upper case, Arabic digits → ASCII, no spaces.
create or replace function private.discount_code_norm(p text) returns text
language sql immutable as $$
  select nullif(upper(regexp_replace(translate(coalesce(p, ''), '٠١٢٣٤٥٦٧٨٩', '0123456789'), '\s', '', 'g')), '')
$$;

-- The caller's IP when PostgREST forwards the headers (else null).
create or replace function private.client_ip() returns text
language plpgsql stable as $$
declare
  h json;
begin
  begin
    h := nullif(current_setting('request.headers', true), '')::json;
  exception when others then
    return null;
  end;
  return nullif(btrim(split_part(coalesce(h ->> 'cf-connecting-ip', h ->> 'x-real-ip', h ->> 'x-forwarded-for', ''), ',', 1)), '');
end;
$$;

-- ------------------------------------------------ rate limits (checkout)

create table if not exists private.checkout_hits (
  shop_id uuid not null,
  kind text not null,
  key text not null,
  at timestamptz not null default now()
);
create index if not exists checkout_hits_key_idx on private.checkout_hits (kind, key, at desc);
create index if not exists checkout_hits_shop_idx on private.checkout_hits (shop_id, kind, at desc);
revoke all on private.checkout_hits from public, anon, authenticated;

-- Hits in the window: of this key, or of the whole shop when p_key is null.
create or replace function private.checkout_hit_count(p_shop uuid, p_kind text, p_key text, p_window interval) returns int
language sql stable security definer set search_path = public as $$
  select count(*)::int from private.checkout_hits h
   where h.kind = p_kind and h.at > now() - p_window
     and (case when p_key is null then h.shop_id = p_shop else h.key = p_key end)
$$;

create or replace function private.checkout_hit(p_shop uuid, p_kind text, p_key text) returns void
language plpgsql security definer set search_path = public as $$
begin
  insert into private.checkout_hits (shop_id, kind, key) values (p_shop, p_kind, coalesce(p_key, 'anon'));
  if random() < 0.02 then
    delete from private.checkout_hits where at < now() - interval '1 day';
  end if;
end;
$$;

-- ============================================================ shipping

create table if not exists public.shop_shipping_settings (
  shop_id uuid primary key references public.shops(id) on delete cascade,
  -- outside every zone: 'rate' = the default rate (shops.delivery_fee /
  -- free_delivery_over), 'none' = «مش بنوصّل هناك».
  default_mode text not null default 'rate' check (default_mode in ('rate', 'none')),
  default_eta text check (default_eta is null or length(default_eta) <= 60),
  pickup_enabled boolean not null default false,
  pickup_address text check (pickup_address is null or length(pickup_address) <= 300),
  pickup_instructions text check (pickup_instructions is null or length(pickup_instructions) <= 300),
  accepting_orders boolean not null default true,
  vacation boolean not null default false,
  vacation_message text check (vacation_message is null or length(vacation_message) <= 200),
  -- null = always open; else 7 × {open, from, to} (Sunday first, 'HH:MM'
  -- in the shop country's time zone; to < from runs past midnight, from =
  -- to is the whole day).
  hours jsonb,
  after_hours text not null default 'accept' check (after_hours in ('accept', 'refuse')),
  min_order numeric(14,2) check (min_order is null or min_order > 0),
  require_confirmation boolean not null default false,
  updated_at timestamptz not null default now()
);
alter table public.shop_shipping_settings enable row level security;
revoke all on public.shop_shipping_settings from anon, authenticated;
grant select on public.shop_shipping_settings to authenticated;
drop policy if exists "shop_shipping_settings: owner reads" on public.shop_shipping_settings;
create policy "shop_shipping_settings: owner reads" on public.shop_shipping_settings
  for select to authenticated using (public.i_own_shop(shop_id));

create table if not exists public.shop_shipping_zones (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  name text not null check (length(name) between 1 and 60),
  areas text[] not null default '{}',
  fee numeric(14,2) not null default 0 check (fee >= 0),
  free_over numeric(14,2) check (free_over is null or free_over > 0),
  eta text check (eta is null or length(eta) <= 60),
  position int not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists shop_shipping_zones_shop_idx on public.shop_shipping_zones (shop_id, position);
alter table public.shop_shipping_zones enable row level security;
revoke all on public.shop_shipping_zones from anon, authenticated;
grant select on public.shop_shipping_zones to authenticated;
drop policy if exists "shop_shipping_zones: owner reads" on public.shop_shipping_zones;
create policy "shop_shipping_zones: owner reads" on public.shop_shipping_zones
  for select to authenticated using (public.i_own_shop(shop_id));

-- The flat fee becomes the default rate of every shop that sells.
insert into public.shop_shipping_settings (shop_id, default_mode)
select s.id, 'rate' from public.shops s where s.owner_id is not null
on conflict (shop_id) do nothing;

-- ============================================================ discounts

create table if not exists public.shop_discounts (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  method text not null check (method in ('code', 'auto')),
  code text,
  title text not null check (length(title) between 1 and 80),
  type text not null check (type in ('percent', 'fixed', 'free_shipping')),
  value numeric(14,2) not null default 0,
  applies_to text not null default 'all' check (applies_to in ('all', 'products', 'collections')),
  product_ids uuid[] not null default '{}',
  collection_ids uuid[] not null default '{}',
  min_subtotal numeric(14,2) check (min_subtotal is null or min_subtotal > 0),
  usage_limit int check (usage_limit is null or usage_limit > 0),
  per_phone_limit int check (per_phone_limit is null or per_phone_limit > 0),
  starts_at timestamptz not null default now(),
  ends_at timestamptz,
  active boolean not null default true,
  combines boolean not null default false,
  used_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint shop_discounts_code_method check ((method = 'code') = (code is not null)),
  constraint shop_discounts_value_ok check (
    (type = 'percent' and value > 0 and value <= 100) or (type = 'fixed' and value > 0) or type = 'free_shipping'),
  constraint shop_discounts_dates check (ends_at is null or ends_at > starts_at)
);
create unique index if not exists shop_discounts_code_uq on public.shop_discounts (shop_id, code) where code is not null;
create index if not exists shop_discounts_shop_idx on public.shop_discounts (shop_id, method, active);
alter table public.shop_discounts enable row level security;
revoke all on public.shop_discounts from anon, authenticated;
grant select on public.shop_discounts to authenticated;
drop policy if exists "shop_discounts: owner reads" on public.shop_discounts;
create policy "shop_discounts: owner reads" on public.shop_discounts
  for select to authenticated using (public.i_own_shop(shop_id));

create table if not exists public.shop_discount_uses (
  discount_id uuid not null references public.shop_discounts(id) on delete cascade,
  order_id uuid not null references public.shop_orders(id) on delete cascade,
  shop_id uuid not null references public.shops(id) on delete cascade,
  phone text not null,
  amount numeric(14,2) not null default 0,
  created_at timestamptz not null default now(),
  primary key (discount_id, order_id)
);
create index if not exists shop_discount_uses_phone_idx on public.shop_discount_uses (discount_id, phone);
alter table public.shop_discount_uses enable row level security;
revoke all on public.shop_discount_uses from anon, authenticated;
grant select on public.shop_discount_uses to authenticated;
drop policy if exists "shop_discount_uses: owner reads" on public.shop_discount_uses;
create policy "shop_discount_uses: owner reads" on public.shop_discount_uses
  for select to authenticated using (public.i_own_shop(shop_id));

-- Products of these collections of the shop (0098: manual lists and
-- rule-based «أقسام» alike).
create or replace function private.collection_product_ids(p_shop uuid, p_ids uuid[]) returns setof uuid
language sql stable security definer set search_path = public as $$
  select m.product_id
    from public.shop_collections c, lateral private.collection_members(c) m
   where c.shop_id = p_shop and c.id = any (coalesce(p_ids, '{}'))
$$;

-- ============================================================ carts

create table if not exists public.shop_carts (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  token text not null unique,
  phone text not null,
  name text,
  lines jsonb not null default '[]'::jsonb,
  subtotal numeric(14,2) not null default 0,
  item_count int not null default 0,
  currency text not null default 'EGP',
  area text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  reminded_at timestamptz,
  recovered_order_id uuid references public.shop_orders(id) on delete set null,
  recovered_at timestamptz,
  unique (shop_id, phone)
);
create index if not exists shop_carts_shop_idx on public.shop_carts (shop_id, updated_at desc);
create index if not exists shop_carts_updated_idx on public.shop_carts (updated_at);
alter table public.shop_carts enable row level security;
revoke all on public.shop_carts from anon, authenticated;
grant select on public.shop_carts to authenticated;
drop policy if exists "shop_carts: owner reads" on public.shop_carts;
create policy "shop_carts: owner reads" on public.shop_carts
  for select to authenticated using (public.i_own_shop(shop_id));

-- ============================================================ orders

alter table public.shop_orders add column if not exists subtotal numeric(14,2);
alter table public.shop_orders add column if not exists discount_code text;
alter table public.shop_orders add column if not exists discount_title text;
alter table public.shop_orders add column if not exists discount_amount numeric(14,2) not null default 0;
alter table public.shop_orders add column if not exists discount_id uuid references public.shop_discounts(id) on delete set null;
alter table public.shop_orders add column if not exists auto_discount_id uuid references public.shop_discounts(id) on delete set null;
alter table public.shop_orders add column if not exists shipping_zone text;
alter table public.shop_orders add column if not exists shipping_area text;
alter table public.shop_orders add column if not exists fulfillment text not null default 'delivery';
alter table public.shop_orders add column if not exists confirmation_status text;
alter table public.shop_orders add column if not exists confirmed_at timestamptz;
alter table public.shop_orders add column if not exists cart_id uuid;
alter table public.shop_orders drop constraint if exists shop_orders_fulfillment_ok;
alter table public.shop_orders add constraint shop_orders_fulfillment_ok check (fulfillment in ('delivery', 'pickup'));
alter table public.shop_orders drop constraint if exists shop_orders_confirmation_ok;
alter table public.shop_orders add constraint shop_orders_confirmation_ok check (confirmation_status is null or confirmation_status in ('pending', 'confirmed'));
grant select (subtotal, discount_code, discount_title, discount_amount, discount_id, auto_discount_id, shipping_zone, shipping_area,
              fulfillment, confirmation_status, confirmed_at, cart_id) on public.shop_orders to authenticated;

update public.shop_orders set subtotal = total_amount - coalesce(delivery_fee, 0)
 where subtotal is null and status <> 'cart';

alter table public.shop_order_events drop constraint if exists shop_order_events_kind_check;
alter table public.shop_order_events add constraint shop_order_events_kind_check
  check (kind in ('created', 'status', 'note', 'cancel', 'confirm', 'discount'));

-- 0096's actor + an explicit one for the RPCs that act for a guest.
create or replace function private.order_actor_role(p_shop uuid, p_buyer uuid) returns text
language sql
stable
security definer
set search_path = public
as $$
  select case
    when nullif(current_setting('app.order_actor', true), '') in ('merchant', 'customer', 'system') then current_setting('app.order_actor', true)
    when auth.uid() is null then 'system'
    when exists (select 1 from public.shops where id = p_shop and owner_id = auth.uid()) then 'merchant'
    when auth.uid() = p_buyer then 'customer'
    else 'system'
  end;
$$;

-- «اطلب تأكيد واتساب قبل التجهيز»: a pending order doesn't move on.
create or replace function public._shop_order_confirm_guard() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if old.status = 'placed' and new.status = 'preparing' and old.confirmation_status = 'pending'
     and exists (select 1 from public.shop_shipping_settings where shop_id = new.shop_id and require_confirmation) then
    raise exception 'أكّد الطلب مع الزبون الأول (زرار «اتأكد») قبل ما تبدأ تجهّزه';
  end if;
  return new;
end;
$$;
drop trigger if exists shop_order_confirm_guard on public.shop_orders;
create trigger shop_order_confirm_guard before update of status on public.shop_orders
  for each row execute function public._shop_order_confirm_guard();

-- A cancelled order gives its discount uses back.
create or replace function public._shop_order_release_discounts() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status = 'cancelled' and old.status is distinct from 'cancelled' then
    with gone as (delete from public.shop_discount_uses where order_id = new.id returning discount_id)
    update public.shop_discounts d set used_count = greatest(d.used_count - 1, 0)
      from gone where d.id = gone.discount_id;
  end if;
  return new;
end;
$$;
drop trigger if exists shop_order_release_discounts on public.shop_orders;
create trigger shop_order_release_discounts after update of status on public.shop_orders
  for each row execute function public._shop_order_release_discounts();

-- ============================================================ open / closed

create or replace function private.hhmm_ok(p text) returns boolean
language sql immutable as $$
  select coalesce(p ~ '^([01][0-9]|2[0-3]):[0-5][0-9]$', false)
$$;

-- {can_order, open_now, code: ok | after_hours | closed_hours | paused | vacation, message}
create or replace function private.shop_open_state(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_set public.shop_shipping_settings;
  v_local timestamp;
  v_dow int;
  v_t time;
  d jsonb;
  p jsonb;
  v_open boolean := false;
  v_from time;
  v_to time;
  v_msg text;
begin
  select * into v_set from public.shop_shipping_settings where shop_id = p_shop;
  if v_set.shop_id is null then
    return jsonb_build_object('can_order', true, 'open_now', true, 'code', 'ok');
  end if;
  if not v_set.accepting_orders then
    return jsonb_build_object('can_order', false, 'open_now', false, 'code', 'paused', 'message', 'المحل موقّف استقبال الطلبات مؤقتاً — جرّب بعد شوية');
  end if;
  if v_set.vacation then
    return jsonb_build_object('can_order', false, 'open_now', false, 'code', 'vacation',
                              'message', coalesce(nullif(btrim(v_set.vacation_message), ''), 'المحل في إجازة دلوقتي — ارجعلنا قريب'));
  end if;
  if v_set.hours is null or jsonb_typeof(v_set.hours) <> 'array' or jsonb_array_length(v_set.hours) <> 7 then
    return jsonb_build_object('can_order', true, 'open_now', true, 'code', 'ok');
  end if;
  v_local := now() at time zone private.country_tz((select country from public.shops where id = p_shop));
  v_dow := extract(dow from v_local)::int;
  v_t := v_local::time;
  d := v_set.hours -> v_dow;
  p := v_set.hours -> ((v_dow + 6) % 7);
  if coalesce((d ->> 'open')::boolean, false) and private.hhmm_ok(d ->> 'from') and private.hhmm_ok(d ->> 'to') then
    v_from := (d ->> 'from')::time;
    v_to := (d ->> 'to')::time;
    v_open := v_from = v_to or (v_from < v_to and v_t >= v_from and v_t < v_to) or (v_from > v_to and v_t >= v_from);
  end if;
  if not v_open and coalesce((p ->> 'open')::boolean, false) and private.hhmm_ok(p ->> 'from') and private.hhmm_ok(p ->> 'to')
     and (p ->> 'from')::time > (p ->> 'to')::time and v_t < (p ->> 'to')::time then
    v_open := true;
  end if;
  if v_open then
    return jsonb_build_object('can_order', true, 'open_now', true, 'code', 'ok');
  end if;
  v_msg := case
    when v_from is not null and v_t < v_from then 'المحل قافل دلوقتي — بيفتح النهارده الساعة ' || to_char(v_from, 'HH24:MI')
    when not coalesce((d ->> 'open')::boolean, false) then 'النهارده إجازة المحل'
    else 'المحل قافل دلوقتي' end;
  if v_set.after_hours = 'refuse' then
    return jsonb_build_object('can_order', false, 'open_now', false, 'code', 'closed_hours', 'message', v_msg);
  end if;
  return jsonb_build_object('can_order', true, 'open_now', false, 'code', 'after_hours',
                            'message', v_msg || ' — اطلب عادي وطلبك هيتجهّز أول ما يفتح');
end;
$$;

-- ============================================================ pricing

-- The cart priced from the database (never the client's prices), line by
-- line through 0098's private.store_line (variants: their price / label):
-- [{product_id, variant_id, quantity, options, unit_price, line_total, name, image_url}].
-- p_lenient (saved carts): bad / unavailable lines are skipped, not refused.
create or replace function private.checkout_lines(p_shop uuid, p_items jsonb, p_lenient boolean default false) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_item jsonb;
  v_line record;
  v_stock int;
  v_out jsonb := '[]'::jsonb;
begin
  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    if p_lenient then return v_out; end if;
    raise exception 'السلة فاضية';
  end if;
  if jsonb_array_length(p_items) > 50 then
    raise exception 'الطلب فيه منتجات كتير، قسّمه على أكتر من طلب';
  end if;
  for v_item in select * from jsonb_array_elements(p_items) loop
    if jsonb_typeof(v_item) <> 'object' or coalesce(v_item ->> 'quantity', v_item ->> 'qty', '') !~ '^[0-9]{1,3}$'
       or coalesce(v_item ->> 'product_id', '') !~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
       or coalesce(v_item ->> 'variant_id', '') !~* '^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})?$' then
      if p_lenient then continue; end if;
      raise exception 'الكمية غير صحيحة';
    end if;
    -- 0098's line: the variant (or the product) and its price / label.
    begin
      select * into v_line from private.store_line(p_shop, v_item, false);
    exception when others then
      if p_lenient then continue; end if;
      raise;
    end;
    v_stock := case when v_line.o_variant_id is not null
                    then (select stock from public.shop_product_variants where id = v_line.o_variant_id)
                    else (select stock from public.shop_products where id = v_line.o_product_id) end;
    if v_stock is not null and v_stock < v_line.o_quantity then
      if p_lenient and v_stock > 0 then
        v_line.o_quantity := v_stock;
      elsif p_lenient then
        continue;
      else
        raise exception 'الكمية المتاحة من «%» هي % بس', v_line.o_product_name || coalesce(' — ' || v_line.o_variant_label, ''), v_stock;
      end if;
    end if;
    v_out := v_out || jsonb_build_array(jsonb_build_object(
      'product_id', v_line.o_product_id, 'variant_id', v_line.o_variant_id, 'quantity', v_line.o_quantity,
      'options', v_line.o_variant_label, 'unit_price', v_line.o_unit_price, 'line_total', v_line.o_unit_price * v_line.o_quantity,
      'name', v_line.o_product_name, 'image_url', v_line.o_image_url));
  end loop;
  return v_out;
end;
$$;

-- Why this discount does not apply to this cart (null: it applies).
create or replace function private.discount_problem(
  d public.shop_discounts, p_lines jsonb, p_subtotal numeric, p_shipping numeric, p_fulfillment text, p_phone text, p_currency text
) returns text
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not d.active or d.starts_at > now() then
    return 'الكود ده مش شغال دلوقتي';
  end if;
  if d.ends_at is not null and d.ends_at <= now() then
    return 'الكود ده خلصت مدته';
  end if;
  if d.usage_limit is not null and d.used_count >= d.usage_limit then
    return 'الكود ده خلص عدد استخداماته';
  end if;
  if d.per_phone_limit is not null and p_phone is not null
     and (select count(*) from public.shop_discount_uses u where u.discount_id = d.id and u.phone = p_phone) >= d.per_phone_limit then
    return 'استخدمت الكود ده قبل كده';
  end if;
  if d.min_subtotal is not null and p_subtotal < d.min_subtotal then
    return 'الكود ده لطلبات من ' || private.money_text(d.min_subtotal, p_currency) || ' — زوّد ' || private.money_text(d.min_subtotal - p_subtotal, p_currency);
  end if;
  if d.type = 'free_shipping' then
    if p_fulfillment = 'pickup' then
      return 'الكود ده للتوصيل المجاني — اختار التوصيل';
    end if;
    if coalesce(p_shipping, 0) = 0 then
      return 'التوصيل مجاني أصلاً على طلبك';
    end if;
  elsif d.applies_to <> 'all' and private.discount_eligible(d, p_lines) = 0 then
    return 'الكود ده مش على المنتجات اللي في سلتك';
  end if;
  return null;
end;
$$;

-- The subtotal of the lines this discount covers.
create or replace function private.discount_eligible(d public.shop_discounts, p_lines jsonb) returns numeric
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(sum((l ->> 'line_total')::numeric), 0)
    from jsonb_array_elements(coalesce(p_lines, '[]'::jsonb)) l
   where d.applies_to = 'all'
      or (d.applies_to = 'products' and (l ->> 'product_id')::uuid = any (d.product_ids))
      or (d.applies_to = 'collections' and (l ->> 'product_id')::uuid in (select private.collection_product_ids(d.shop_id, d.collection_ids)))
$$;

-- What it saves: an amount off the lines, or the shipping fee.
create or replace function private.discount_saving(d public.shop_discounts, p_lines jsonb, p_shipping numeric) returns numeric
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_base numeric := private.discount_eligible(d, p_lines);
begin
  return case d.type
    when 'percent' then round(v_base * d.value / 100, 2)
    when 'fixed' then least(d.value, v_base)
    else coalesce(p_shipping, 0) end;
end;
$$;

-- Shipping, discounts and totals for a priced cart (private.checkout_lines
-- or place_store_order's own loop). p_strict (placing the order): the
-- first blocking problem — or a code that does not apply — is raised.
create or replace function private.checkout_quote(
  p_shop uuid,
  p_lines jsonb,
  p_area text default null,
  p_fulfillment text default 'delivery',
  p_code text default null,
  p_phone text default null,
  p_strict boolean default false
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop record;
  v_set public.shop_shipping_settings;
  v_cur text;
  v_sub numeric := 0;
  v_count int := 0;
  v_ful text := coalesce(nullif(p_fulfillment, ''), 'delivery');
  v_area text := nullif(left(btrim(coalesce(p_area, '')), 60), '');
  v_zone public.shop_shipping_zones;
  v_has_zones boolean := false;
  v_ship numeric := 0;
  v_zone_name text;
  v_eta text;
  v_free_over numeric;
  v_errors jsonb := '[]'::jsonb;
  v_open jsonb;
  v_code text := private.discount_code_norm(p_code);
  v_key text;
  v_cd public.shop_discounts;
  v_code_saving numeric := 0;
  v_code_status text;
  v_code_msg text;
  v_auto public.shop_discounts;
  v_auto_saving numeric := 0;
  d public.shop_discounts;
  s numeric;
  v_use_code boolean := false;
  v_use_auto boolean := false;
  v_amount numeric := 0;
  v_free_ship boolean := false;
  v_hint text;
  v_title text;
begin
  select * into v_shop from public.shops where id = p_shop;
  if not found or v_shop.owner_id is null then
    raise exception 'المحل ده مش مستقبل طلبات حالياً';
  end if;
  if v_ful not in ('delivery', 'pickup') then
    raise exception 'طريقة الاستلام مش معروفة';
  end if;
  v_cur := coalesce(v_shop.currency, 'EGP');
  select * into v_set from public.shop_shipping_settings where shop_id = p_shop;
  select coalesce(sum((l ->> 'line_total')::numeric), 0), coalesce(sum((l ->> 'quantity')::int), 0)
    into v_sub, v_count
    from jsonb_array_elements(coalesce(p_lines, '[]'::jsonb)) l;

  v_open := private.shop_open_state(p_shop);
  if not (v_open ->> 'can_order')::boolean then
    v_errors := v_errors || jsonb_build_array(jsonb_build_object('code', v_open ->> 'code', 'message', v_open ->> 'message'));
  end if;
  if v_set.min_order is not null and v_sub < v_set.min_order then
    v_errors := v_errors || jsonb_build_array(jsonb_build_object('code', 'min_order',
      'message', 'أقل طلب ' || private.money_text(v_set.min_order, v_cur) || ' — زوّد ' || private.money_text(v_set.min_order - v_sub, v_cur)));
  end if;

  -- ---- shipping
  if v_ful = 'pickup' then
    if not coalesce(v_set.pickup_enabled, false) then
      v_errors := v_errors || jsonb_build_array(jsonb_build_object('code', 'pickup_unavailable', 'message', 'الاستلام من المحل مش متاح في المحل ده'));
    end if;
    v_zone_name := 'استلام من المحل';
  else
    v_has_zones := exists (select 1 from public.shop_shipping_zones where shop_id = p_shop);
    if v_area is not null then
      select * into v_zone from public.shop_shipping_zones z
       where z.shop_id = p_shop and exists (select 1 from unnest(z.areas) a where private.area_key(a) = private.area_key(v_area))
       order by z.position, z.created_at limit 1;
    end if;
    if v_zone.id is not null then
      v_ship := v_zone.fee;
      v_free_over := v_zone.free_over;
      v_eta := v_zone.eta;
      v_zone_name := v_zone.name;
    elsif coalesce(v_set.default_mode, 'rate') = 'rate' then
      v_ship := coalesce(v_shop.delivery_fee, 0);
      v_free_over := v_shop.free_delivery_over;
      v_eta := v_set.default_eta;
      v_zone_name := case when v_has_zones then 'باقي المناطق' end;
    elsif v_area is null then
      v_errors := v_errors || jsonb_build_array(jsonb_build_object('code', 'area_required', 'message', 'اختار المحافظة / المنطقة عشان نحسب التوصيل'));
    else
      v_errors := v_errors || jsonb_build_array(jsonb_build_object('code', 'not_served',
        'message', 'للأسف المحل مش بيوصّل لـ«' || v_area || '»' || case when coalesce(v_set.pickup_enabled, false) then ' — تقدر تستلم طلبك من المحل' else '' end));
    end if;
    if v_free_over is not null and v_sub >= v_free_over then
      v_ship := 0;
    end if;
  end if;

  -- ---- automatic discounts: the eligible one saving the most
  for d in select * from public.shop_discounts
            where shop_id = p_shop and method = 'auto' and active order by created_at loop
    if private.discount_problem(d, p_lines, v_sub, v_ship, v_ful, p_phone, v_cur) is null then
      s := private.discount_saving(d, p_lines, v_ship);
      if s > v_auto_saving then
        v_auto := d;
        v_auto_saving := s;
      end if;
    end if;
  end loop;

  -- ---- the code (wrong codes are counted: no brute force)
  if v_code is not null then
    v_key := coalesce(p_phone, private.client_ip(), 'anon');
    if private.checkout_hit_count(p_shop, 'bad_code', v_key, interval '1 hour') >= 10
       or private.checkout_hit_count(p_shop, 'bad_code', null, interval '1 hour') >= 200 then
      v_code_status := 'blocked';
      v_code_msg := 'جرّبت أكواد غلط كتير — استنى ساعة وجرّب تاني';
    else
      if length(v_code) <= 30 then
        select * into v_cd from public.shop_discounts where shop_id = p_shop and method = 'code' and code = v_code;
      end if;
      if v_cd.id is null then
        v_code_status := 'invalid';
        v_code_msg := 'الكود ده مش صحيح';
        perform private.checkout_hit(p_shop, 'bad_code', v_key);
      else
        v_code_msg := private.discount_problem(v_cd, p_lines, v_sub, v_ship, v_ful, p_phone, v_cur);
        if v_code_msg is null then
          v_code_saving := private.discount_saving(v_cd, p_lines, v_ship);
          v_code_status := 'applied';
        else
          v_code_status := 'not_applicable';
        end if;
      end if;
    end if;
  end if;

  -- ---- the stacking rule (see the header)
  if v_code_status = 'applied' and v_auto.id is not null and not v_cd.combines then
    if v_code_saving >= v_auto_saving then
      v_use_code := true;
    else
      v_use_auto := true;
      v_code_status := 'not_better';
      v_code_msg := 'عندك خصم تلقائي أحسن من الكود ده — طبّقناه بداله';
    end if;
  else
    v_use_code := v_code_status = 'applied';
    v_use_auto := v_auto.id is not null;
  end if;
  if v_use_code then
    if v_cd.type = 'free_shipping' then v_free_ship := true; else v_amount := v_amount + v_code_saving; end if;
  end if;
  if v_use_auto then
    if v_auto.type = 'free_shipping' then v_free_ship := true; else v_amount := v_amount + v_auto_saving; end if;
  end if;
  v_amount := round(least(v_amount, v_sub), 2);
  v_title := nullif(concat_ws(' + ', case when v_use_code then v_cd.title end, case when v_use_auto then v_auto.title end), '');

  -- «زوّد … وخد …»: the next automatic discount within reach.
  select * into d from public.shop_discounts
   where shop_id = p_shop and method = 'auto' and active and starts_at <= now() and (ends_at is null or ends_at > now())
     and (usage_limit is null or used_count < usage_limit) and min_subtotal > v_sub
     and (v_auto.id is null or id <> v_auto.id)
   order by min_subtotal limit 1;
  if d.id is not null then
    v_hint := 'زوّد ' || private.money_text(d.min_subtotal - v_sub, v_cur) || ' وخد «' || d.title || '»';
  end if;

  if p_strict then
    if jsonb_array_length(v_errors) > 0 then
      raise exception '%', v_errors -> 0 ->> 'message';
    end if;
    if v_code is not null and v_code_status not in ('applied', 'not_better') then
      raise exception '%', v_code_msg;
    end if;
  end if;

  return jsonb_build_object(
    'currency', v_cur,
    'subtotal', v_sub,
    'item_count', v_count,
    'fulfillment', v_ful,
    'shipping_area', case when v_ful = 'delivery' then v_area end,
    'shipping_zone', v_zone_name,
    'shipping_eta', v_eta,
    'shipping_base', v_ship,
    'shipping_fee', case when v_free_ship then 0 else v_ship end,
    'free_over', v_free_over,
    'free_shipping', v_free_ship,
    'discount_amount', v_amount,
    'discount_title', v_title,
    'discount_code', case when v_use_code then v_cd.code end,
    'discount_id', case when v_use_code then v_cd.id end,
    'auto_discount_id', case when v_use_auto then v_auto.id end,
    'auto_title', case when v_use_auto then v_auto.title end,
    'code_status', v_code_status,
    'code_message', v_code_msg,
    'hint', v_hint,
    'total', v_sub - v_amount + case when v_free_ship then 0 else v_ship end,
    'errors', v_errors,
    'can_order', jsonb_array_length(v_errors) = 0,
    'open', v_open,
    'min_order', v_set.min_order);
end;
$$;

-- ============================================================ public reads

-- Totals for the checkout screen, live (anyone; the order is re-priced
-- when placed).
create or replace function public.quote_store_checkout(
  p_shop_id uuid,
  p_items jsonb,
  p_area text default null,
  p_fulfillment text default 'delivery',
  p_discount_code text default null,
  p_customer_phone text default null
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lines jsonb := private.checkout_lines(p_shop_id, p_items, false);
  v_phone text := private.phone_store(p_customer_phone, private.my_country());
begin
  return private.checkout_quote(p_shop_id, v_lines, p_area, p_fulfillment, p_discount_code, v_phone, false)
         || jsonb_build_object('lines', v_lines);
end;
$$;

-- What the checkout needs before the cart is priced (anyone): zones and
-- rates (public by nature), pickup, open state, minimum order.
create or replace function public.store_checkout_info(p_shop_id uuid) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'country', coalesce(s.country, 'EG'),
    'currency', coalesce(s.currency, 'EGP'),
    'default_mode', coalesce(ss.default_mode, 'rate'),
    'default_fee', coalesce(s.delivery_fee, 0),
    'default_free_over', s.free_delivery_over,
    'default_eta', ss.default_eta,
    'zones', coalesce((select jsonb_agg(jsonb_build_object('name', z.name, 'areas', to_jsonb(z.areas), 'fee', z.fee, 'free_over', z.free_over, 'eta', z.eta)
                                        order by z.position, z.created_at)
                         from public.shop_shipping_zones z where z.shop_id = s.id), '[]'::jsonb),
    'pickup', case when coalesce(ss.pickup_enabled, false)
                   then jsonb_build_object('address', ss.pickup_address, 'instructions', ss.pickup_instructions) end,
    'open', private.shop_open_state(s.id),
    'min_order', ss.min_order,
    'require_confirmation', coalesce(ss.require_confirmation, false),
    'has_codes', exists (select 1 from public.shop_discounts d where d.shop_id = s.id and d.method = 'code' and d.active
                          and (d.ends_at is null or d.ends_at > now())),
    'auto_discounts', coalesce((select jsonb_agg(jsonb_build_object('title', d.title, 'type', d.type, 'value', d.value, 'min_subtotal', d.min_subtotal)
                                                 order by d.min_subtotal nulls first)
                                  from public.shop_discounts d
                                 where d.shop_id = s.id and d.method = 'auto' and d.active and d.starts_at <= now()
                                   and (d.ends_at is null or d.ends_at > now()) and (d.usage_limit is null or d.used_count < d.usage_limit)), '[]'::jsonb))
  from public.shops s
  left join public.shop_shipping_settings ss on ss.shop_id = s.id
  where s.id = p_shop_id and s.owner_id is not null;
$$;

-- ============================================================ placing

-- 0098's store checkout (variants, private.store_line) + zones / pickup /
-- discounts / carts / snapshots.
-- Old callers (6 arguments) still fit: no area → the default rate.
create or replace function public.place_store_order(
  p_shop_id uuid,
  p_items jsonb,
  p_customer_name text,
  p_customer_phone text,
  p_address text,
  p_note text default null,
  p_area text default null,
  p_fulfillment text default 'delivery',
  p_discount_code text default null,
  p_cart_token text default null,
  p_expected_total numeric default null
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
  v_ful text := coalesce(nullif(p_fulfillment, ''), 'delivery');
  v_order_id uuid;
  v_code text;
  v_item jsonb;
  v_line record;
  v_lines jsonb := '[]'::jsonb;
  v_q jsonb;
  v_total numeric(14,2);
  v_count int := 0;
  v_bytes bytea;
  v_idx int;
  v_disc uuid;
  v_cart uuid;
  v_dcode text;
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
  if v_ful not in ('delivery', 'pickup') then
    raise exception 'طريقة الاستلام مش معروفة';
  end if;
  if v_ful = 'delivery' and length(v_address) < 8 then
    raise exception 'اكتب العنوان بالتفصيل عشان الطلب يوصلك';
  end if;
  if v_ful = 'pickup' and v_address = '' then
    v_address := 'استلام من المحل';
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
  -- A wrong (or rate-limited) code places nothing and returns null — no
  -- exception, so the wrong try is counted (an exception would roll the
  -- count back and make this a free code oracle). The app re-quotes to
  -- show why.
  v_dcode := private.discount_code_norm(p_discount_code);
  if v_dcode is not null then
    if private.checkout_hit_count(p_shop_id, 'bad_code', v_phone, interval '1 hour') >= 10
       or private.checkout_hit_count(p_shop_id, 'bad_code', null, interval '1 hour') >= 200 then
      return null;
    end if;
    if not exists (select 1 from public.shop_discounts where shop_id = p_shop_id and method = 'code' and code = v_dcode) then
      perform private.checkout_hit(p_shop_id, 'bad_code', v_phone);
      return null;
    end if;
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

  -- 0098's lines: the variant's price / stock (taken under a row lock) /
  -- snapshot; v_lines feeds the pricing below.
  for v_item in select * from jsonb_array_elements(p_items) loop
    select * into v_line from private.store_line(p_shop_id, v_item, true);
    insert into public.shop_order_items (order_id, product_id, variant_id, quantity, unit_price, chosen_options, product_name, variant_label, sku, image_url)
    values (v_order_id, v_line.o_product_id, v_line.o_variant_id, v_line.o_quantity, v_line.o_unit_price, v_line.o_variant_label,
            v_line.o_product_name, v_line.o_variant_label, v_line.o_sku, v_line.o_image_url);
    v_lines := v_lines || jsonb_build_array(jsonb_build_object(
      'product_id', v_line.o_product_id, 'variant_id', v_line.o_variant_id, 'quantity', v_line.o_quantity,
      'unit_price', v_line.o_unit_price, 'line_total', v_line.o_unit_price * v_line.o_quantity));
    v_count := v_count + v_line.o_quantity;
  end loop;

  -- Shipping, discounts, open / minimum — raised here when they don't hold.
  v_q := private.checkout_quote(p_shop_id, v_lines, p_area, v_ful, p_discount_code, v_phone, true);
  v_total := (v_q ->> 'total')::numeric;
  if p_expected_total is not null and abs(p_expected_total - v_total) > 0.009 then
    raise exception 'الأسعار أو التوصيل اتغيروا — الإجمالي دلوقتي %، راجع طلبك وأكّد تاني', private.money_text(v_total, v_shop.currency);
  end if;

  -- The discounts used: locked, counted, recorded (a limit reached in the
  -- meantime refuses the order).
  foreach v_disc in array array_remove(array[(v_q ->> 'discount_id')::uuid, (v_q ->> 'auto_discount_id')::uuid], null) loop
    perform 1 from public.shop_discounts where id = v_disc for update;
    update public.shop_discounts set used_count = used_count + 1
     where id = v_disc and (usage_limit is null or used_count < usage_limit);
    if not found then
      raise exception 'الخصم ده خلص عدد استخداماته — حدّث الصفحة';
    end if;
    insert into public.shop_discount_uses (discount_id, order_id, shop_id, phone, amount)
    values (v_disc, v_order_id, p_shop_id, v_phone, (v_q ->> 'discount_amount')::numeric);
  end loop;

  -- The abandoned cart this order came from (by its link, or the phone).
  update public.shop_carts set recovered_order_id = v_order_id, recovered_at = now()
   where shop_id = p_shop_id and recovered_order_id is null
     and (phone = v_phone or (p_cart_token is not null and token = p_cart_token))
  returning id into v_cart;

  update public.shop_orders set
    subtotal = (v_q ->> 'subtotal')::numeric,
    delivery_fee = (v_q ->> 'shipping_fee')::numeric,
    discount_amount = (v_q ->> 'discount_amount')::numeric,
    discount_code = v_q ->> 'discount_code',
    discount_title = v_q ->> 'discount_title',
    discount_id = (v_q ->> 'discount_id')::uuid,
    auto_discount_id = (v_q ->> 'auto_discount_id')::uuid,
    shipping_zone = v_q ->> 'shipping_zone',
    shipping_area = v_q ->> 'shipping_area',
    fulfillment = v_ful,
    confirmation_status = 'pending',
    cart_id = v_cart,
    total_amount = v_total
  where id = v_order_id;

  if (v_q ->> 'discount_amount')::numeric > 0 or (v_q ->> 'free_shipping')::boolean then
    insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
    values (v_order_id, p_shop_id, 'discount',
            coalesce(v_q ->> 'discount_title', 'خصم')
              || case when v_q ->> 'discount_code' is not null then ' (كود ' || (v_q ->> 'discount_code') || ')' else '' end
              || case when (v_q ->> 'discount_amount')::numeric > 0 then ' — ' || private.money_text((v_q ->> 'discount_amount')::numeric, v_shop.currency) else '' end
              || case when (v_q ->> 'free_shipping')::boolean then ' — توصيل مجاني' else '' end,
            'customer');
  end if;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد ' || v_code || ' — ' || v_shop.name,
          v_name || ' طلب ' || v_count || ' منتج بإجمالي ' || private.money_text(v_total, v_shop.currency)
            || case when v_ful = 'pickup' then ' (استلام من المحل)' else ' (شامل التوصيل)' end
            || case when (v_q ->> 'discount_amount')::numeric > 0 then ' بعد خصم ' || private.money_text((v_q ->> 'discount_amount')::numeric, v_shop.currency) else '' end
            || '. افتح «الطلبات» في متجري.');

  return v_code;
end;
$$;
revoke execute on function public.place_store_order(uuid, jsonb, text, text, text, text, text, text, text, text, numeric) from public;
grant execute on function public.place_store_order(uuid, jsonb, text, text, text, text, text, text, text, text, numeric) to anon, authenticated;

-- ============================================================ order reads

-- 0096's tracking page + discount / shipping / confirmation / cancel.
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
    'subtotal', coalesce(o.subtotal, o.total_amount - o.delivery_fee),
    'delivery_fee', o.delivery_fee,
    'shipping_fee', o.delivery_fee,
    'discount_amount', o.discount_amount,
    'discount_code', o.discount_code,
    'discount_title', o.discount_title,
    'shipping_zone', o.shipping_zone,
    'fulfillment', o.fulfillment,
    'confirmation_status', o.confirmation_status,
    'can_cancel', o.status = 'placed' and o.order_code is not null,
    'cancel_reason', case when o.status = 'cancelled' then o.cancel_reason end,
    'currency', o.currency,
    'created_at', o.created_at,
    'customer_name', o.customer_name,
    'shop_name', s.name,
    'shop_slug', s.slug,
    'shop_whatsapp', s.whatsapp,
    'pickup_address', case when o.fulfillment = 'pickup' then (select ss.pickup_address from public.shop_shipping_settings ss where ss.shop_id = s.id) end,
    'items', coalesce((
      select jsonb_agg(jsonb_build_object('name', coalesce(i.product_name, p.name), 'quantity', i.quantity, 'price', i.unit_price,
                                          'options', coalesce(i.variant_label, i.chosen_options), 'image_url', i.image_url) order by i.id)
        from public.shop_order_items i left join public.shop_products p on p.id = i.product_id
       where i.order_id = o.id), '[]'::jsonb)
  )
  from public.shop_orders o join public.shops s on s.id = o.shop_id
  where o.order_code = upper(trim(p_code));
$$;
revoke execute on function public.get_store_order(text) from public;
grant execute on function public.get_store_order(text) to anon, authenticated;

-- 0096's merchant row + the checkout snapshot.
create or replace function private.order_row_json(o public.shop_orders) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'id', o.id,
    'order_code', o.order_code,
    'created_at', o.created_at,
    'status', o.status,
    'customer_name', o.customer_name,
    'customer_phone', o.customer_phone,
    'delivery_address', o.delivery_address,
    'note', o.note,
    'internal_note', o.internal_note,
    'cancel_reason', o.cancel_reason,
    'total_amount', o.total_amount,
    'subtotal', coalesce(o.subtotal, o.total_amount - o.delivery_fee),
    'delivery_fee', o.delivery_fee,
    'shipping_fee', o.delivery_fee,
    'discount_amount', o.discount_amount,
    'discount_code', o.discount_code,
    'discount_title', o.discount_title,
    'shipping_zone', o.shipping_zone,
    'shipping_area', o.shipping_area,
    'fulfillment', o.fulfillment,
    'confirmation_status', o.confirmation_status,
    'confirmed_at', o.confirmed_at,
    'from_cart', o.cart_id is not null,
    'currency', o.currency,
    'payment', 'cash',
    'items', private.order_lines_json(o.id));
$$;

-- ============================================================ confirm / cancel

-- «اتأكد»: the customer confirmed the COD order (WhatsApp, a call…).
create or replace function public.merchant_confirm_order(p_order uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_order record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select o.id, o.shop_id, o.status, o.confirmation_status into v_order
    from public.shop_orders o join public.shops s on s.id = o.shop_id
   where o.id = p_order and s.owner_id = auth.uid() and o.status <> 'cart'
   for update of o;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;
  if v_order.status = 'cancelled' then
    raise exception 'الطلب ده اتلغى';
  end if;
  if v_order.confirmation_status = 'confirmed' then
    return;
  end if;
  update public.shop_orders set confirmation_status = 'confirmed', confirmed_at = now() where id = p_order;
  insert into public.shop_order_events (order_id, shop_id, kind, body, actor_id, actor_role)
  values (p_order, v_order.shop_id, 'confirm', 'الزبون أكّد الطلب', auth.uid(), 'merchant');
end;
$$;

-- The customer cancels from /#/o/<code> while the order is «placed»: the
-- last 4 digits of the order's phone prove it is them (5 wrong tries per
-- order per hour; a wrong try returns {ok: false, error}, not an exception).
create or replace function public.guest_cancel_store_order(p_code text, p_phone_last4 text, p_reason text default null) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text := upper(trim(coalesce(p_code, '')));
  v_last4 text := regexp_replace(translate(coalesce(p_phone_last4, ''), '٠١٢٣٤٥٦٧٨٩', '0123456789'), '\D', '', 'g');
  v_reason text := nullif(left(trim(coalesce(p_reason, '')), 300), '');
  v_order record;
begin
  select o.id, o.shop_id, o.status, o.customer_phone, o.customer_name, s.owner_id, s.name as shop_name into v_order
    from public.shop_orders o join public.shops s on s.id = o.shop_id
   where o.order_code = v_code
   for update of o;
  if not found then
    raise exception 'مفيش طلب بالرقم ده';
  end if;
  if private.checkout_hit_count(v_order.shop_id, 'cancel_fail', 'order:' || v_code, interval '1 hour') >= 5 then
    return jsonb_build_object('ok', false, 'error', 'محاولات كتير — استنى ساعة أو كلّم المحل');
  end if;
  -- Returned, not raised: an exception would roll the counted try back.
  if length(v_last4) <> 4 or right(regexp_replace(coalesce(v_order.customer_phone, ''), '\D', '', 'g'), 4) <> v_last4 then
    perform private.checkout_hit(v_order.shop_id, 'cancel_fail', 'order:' || v_code);
    return jsonb_build_object('ok', false, 'error', 'آخر 4 أرقام من الموبايل مش مطابقين لرقم الطلب');
  end if;
  if v_order.status <> 'placed' then
    raise exception 'مينفعش تلغي الطلب بعد ما المحل بدأ يجهّزه — كلّم المحل';
  end if;
  perform set_config('app.order_actor', 'customer', true);
  update public.shop_orders set cancel_reason = coalesce(v_reason, 'الزبون لغى الطلب'), status = 'cancelled' where id = v_order.id;
  perform set_config('app.order_actor', '', true);
  insert into public.notifications (user_id, title, body)
  values (v_order.owner_id, '❌ الزبون لغى الطلب ' || v_code || ' — ' || v_order.shop_name,
          coalesce(v_order.customer_name, 'الزبون') || ' لغى طلبه من صفحة المتابعة' || coalesce('. السبب: ' || v_reason, '') || '.');
  return public.get_store_order(v_code) || jsonb_build_object('ok', true);
end;
$$;

-- ============================================================ shipping (admin)

create or replace function public.get_shop_shipping(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  s public.shops;
  ss public.shop_shipping_settings;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  select * into s from public.shops where id = p_shop;
  select * into ss from public.shop_shipping_settings where shop_id = p_shop;
  return jsonb_build_object(
    'shop_id', s.id,
    'country', coalesce(s.country, 'EG'),
    'currency', coalesce(s.currency, 'EGP'),
    'default_mode', coalesce(ss.default_mode, 'rate'),
    'default_fee', coalesce(s.delivery_fee, 0),
    'default_free_over', s.free_delivery_over,
    'default_eta', ss.default_eta,
    'pickup_enabled', coalesce(ss.pickup_enabled, false),
    'pickup_address', ss.pickup_address,
    'pickup_instructions', ss.pickup_instructions,
    'accepting_orders', coalesce(ss.accepting_orders, true),
    'vacation', coalesce(ss.vacation, false),
    'vacation_message', ss.vacation_message,
    'hours', ss.hours,
    'after_hours', coalesce(ss.after_hours, 'accept'),
    'min_order', ss.min_order,
    'require_confirmation', coalesce(ss.require_confirmation, false),
    'open', private.shop_open_state(p_shop),
    'zones', coalesce((select jsonb_agg(jsonb_build_object('id', z.id, 'name', z.name, 'areas', to_jsonb(z.areas), 'fee', z.fee,
                                                           'free_over', z.free_over, 'eta', z.eta) order by z.position, z.created_at)
                         from public.shop_shipping_zones z where z.shop_id = p_shop), '[]'::jsonb));
end;
$$;

-- Saves everything «الشحن والتوصيل» shows (zones are replaced as a set).
create or replace function public.set_shop_shipping(p_shop uuid, p jsonb) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_cur text;
  v_cap numeric;
  z jsonb;
  a jsonb;
  v_areas text[];
  v_seen text[] := '{}';
  v_key text;
  v_name text;
  v_fee numeric;
  v_free numeric;
  v_pos int := 0;
  v_hours jsonb := p -> 'hours';
  h jsonb;
  v_default_fee numeric;
  v_default_free numeric;
  v_min numeric;
  v_pickup boolean := coalesce((p ->> 'pickup_enabled')::boolean, false);
  v_pickup_address text := nullif(left(btrim(coalesce(p ->> 'pickup_address', '')), 300), '');
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if p is null or jsonb_typeof(p) <> 'object' then
    raise exception 'بيانات الشحن مش صحيحة';
  end if;
  select coalesce(currency, 'EGP') into v_cur from public.shops where id = p_shop;
  v_cap := private.money_cap(1000, v_cur);

  -- the default rate (= the old flat fee)
  v_default_fee := coalesce(nullif(p ->> 'default_fee', '')::numeric, 0);
  v_default_free := nullif(p ->> 'default_free_over', '')::numeric;
  if v_default_fee < 0 or v_default_fee > v_cap then
    raise exception 'قيمة التوصيل لازم تكون من 0 لـ %', private.money_text(v_cap, v_cur);
  end if;
  if v_default_free is not null and v_default_free <= 0 then
    raise exception 'حد التوصيل المجاني لازم يكون أكبر من صفر';
  end if;
  if coalesce(p ->> 'default_mode', 'rate') not in ('rate', 'none') then
    raise exception 'اختيار «باقي المناطق» مش صحيح';
  end if;
  if coalesce(p ->> 'after_hours', 'accept') not in ('accept', 'refuse') then
    raise exception 'اختيار «بعد المواعيد» مش صحيح';
  end if;
  v_min := nullif(p ->> 'min_order', '')::numeric;
  if v_min is not null and (v_min <= 0 or v_min > private.money_cap(100000, v_cur)) then
    raise exception 'أقل قيمة للطلب مش صحيحة';
  end if;
  if v_pickup and coalesce(length(v_pickup_address), 0) < 5 then
    raise exception 'اكتب عنوان الاستلام من المحل';
  end if;
  if v_hours is not null and jsonb_typeof(v_hours) = 'null' then
    v_hours := null;
  end if;
  if v_hours is not null then
    if jsonb_typeof(v_hours) <> 'array' or jsonb_array_length(v_hours) <> 7 then
      raise exception 'مواعيد المحل لازم تكون لـ 7 أيام';
    end if;
    for h in select * from jsonb_array_elements(v_hours) loop
      if jsonb_typeof(h) <> 'object' or jsonb_typeof(h -> 'open') <> 'boolean'
         or ((h ->> 'open')::boolean and not (private.hhmm_ok(h ->> 'from') and private.hhmm_ok(h ->> 'to'))) then
        raise exception 'مواعيد المحل مش صحيحة (اكتبها كده 09:00)';
      end if;
    end loop;
    v_hours := (select jsonb_agg(jsonb_build_object('open', (x ->> 'open')::boolean, 'from', x ->> 'from', 'to', x ->> 'to') order by n)
                  from jsonb_array_elements(v_hours) with ordinality as e(x, n));
  end if;

  -- zones: validated as a set before anything is written
  if p -> 'zones' is not null and jsonb_typeof(p -> 'zones') <> 'array' then
    raise exception 'مناطق الشحن مش صحيحة';
  end if;
  if jsonb_array_length(coalesce(p -> 'zones', '[]'::jsonb)) > 30 then
    raise exception 'أقصى عدد 30 منطقة شحن';
  end if;
  for z in select * from jsonb_array_elements(coalesce(p -> 'zones', '[]'::jsonb)) loop
    v_name := btrim(coalesce(z ->> 'name', ''));
    if length(v_name) < 1 or length(v_name) > 60 then
      raise exception 'اكتب اسم لكل منطقة شحن';
    end if;
    if jsonb_typeof(z -> 'areas') <> 'array' or jsonb_array_length(z -> 'areas') = 0 then
      raise exception 'اختار محافظة / منطقة واحدة على الأقل في «%»', v_name;
    end if;
    if jsonb_array_length(z -> 'areas') > 80 then
      raise exception 'مناطق كتير في «%»', v_name;
    end if;
    for a in select * from jsonb_array_elements(z -> 'areas') loop
      v_key := private.area_key(a #>> '{}');
      if v_key is null or length(v_key) > 60 then
        raise exception 'اسم منطقة مش صحيح في «%»', v_name;
      end if;
      if v_key = any (v_seen) then
        raise exception '«%» موجودة في أكتر من منطقة شحن', btrim(a #>> '{}');
      end if;
      v_seen := v_seen || v_key;
    end loop;
    v_fee := coalesce(nullif(z ->> 'fee', '')::numeric, 0);
    v_free := nullif(z ->> 'free_over', '')::numeric;
    if v_fee < 0 or v_fee > v_cap then
      raise exception 'سعر التوصيل في «%» لازم يكون من 0 لـ %', v_name, private.money_text(v_cap, v_cur);
    end if;
    if v_free is not null and v_free <= 0 then
      raise exception 'حد التوصيل المجاني في «%» لازم يكون أكبر من صفر', v_name;
    end if;
  end loop;

  update public.shops set delivery_fee = round(v_default_fee, 2), free_delivery_over = v_default_free where id = p_shop;

  insert into public.shop_shipping_settings as ss (shop_id, default_mode, default_eta, pickup_enabled, pickup_address, pickup_instructions,
                                                   accepting_orders, vacation, vacation_message, hours, after_hours, min_order, require_confirmation, updated_at)
  values (p_shop, coalesce(p ->> 'default_mode', 'rate'), nullif(left(btrim(coalesce(p ->> 'default_eta', '')), 60), ''),
          v_pickup, v_pickup_address, nullif(left(btrim(coalesce(p ->> 'pickup_instructions', '')), 300), ''),
          coalesce((p ->> 'accepting_orders')::boolean, true), coalesce((p ->> 'vacation')::boolean, false),
          nullif(left(btrim(coalesce(p ->> 'vacation_message', '')), 200), ''), v_hours, coalesce(p ->> 'after_hours', 'accept'),
          v_min, coalesce((p ->> 'require_confirmation')::boolean, false), now())
  on conflict (shop_id) do update set
    default_mode = excluded.default_mode, default_eta = excluded.default_eta, pickup_enabled = excluded.pickup_enabled,
    pickup_address = excluded.pickup_address, pickup_instructions = excluded.pickup_instructions,
    accepting_orders = excluded.accepting_orders, vacation = excluded.vacation, vacation_message = excluded.vacation_message,
    hours = excluded.hours, after_hours = excluded.after_hours, min_order = excluded.min_order,
    require_confirmation = excluded.require_confirmation, updated_at = now();

  delete from public.shop_shipping_zones where shop_id = p_shop;
  for z in select * from jsonb_array_elements(coalesce(p -> 'zones', '[]'::jsonb)) loop
    select array_agg(btrim(regexp_replace(x #>> '{}', '\s+', ' ', 'g')) order by n) into v_areas
      from jsonb_array_elements(z -> 'areas') with ordinality as e(x, n);
    insert into public.shop_shipping_zones (shop_id, name, areas, fee, free_over, eta, position)
    values (p_shop, btrim(z ->> 'name'), v_areas, round(coalesce(nullif(z ->> 'fee', '')::numeric, 0), 2),
            nullif(z ->> 'free_over', '')::numeric, nullif(left(btrim(coalesce(z ->> 'eta', '')), 60), ''), v_pos);
    v_pos := v_pos + 1;
  end loop;

  return public.get_shop_shipping(p_shop);
end;
$$;

-- ============================================================ discounts (admin)

create or replace function private.discount_json(d public.shop_discounts) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select to_jsonb(d) || jsonb_build_object(
    'state', case
      when not d.active then 'disabled'
      when d.ends_at is not null and d.ends_at <= now() then 'expired'
      when d.usage_limit is not null and d.used_count >= d.usage_limit then 'used_up'
      when d.starts_at > now() then 'scheduled'
      else 'active' end,
    'sales', (select coalesce(sum(o.total_amount), 0) from public.shop_discount_uses u join public.shop_orders o on o.id = u.order_id
               where u.discount_id = d.id),
    'saved', (select coalesce(sum(o.discount_amount), 0) from public.shop_discount_uses u join public.shop_orders o on o.id = u.order_id
               where u.discount_id = d.id));
$$;

create or replace function public.merchant_discounts(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  return coalesce((select jsonb_agg(private.discount_json(d) order by d.created_at desc)
                     from public.shop_discounts d where d.shop_id = p_shop), '[]'::jsonb);
end;
$$;

-- Creates (no id) or updates a discount; returns it.
create or replace function public.save_shop_discount(p_shop uuid, p jsonb) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid := nullif(p ->> 'id', '')::uuid;
  v_method text := coalesce(p ->> 'method', 'code');
  v_type text := coalesce(p ->> 'type', 'percent');
  v_code text := private.discount_code_norm(p ->> 'code');
  v_title text := nullif(left(btrim(coalesce(p ->> 'title', '')), 80), '');
  v_value numeric := coalesce(nullif(p ->> 'value', '')::numeric, 0);
  v_applies text := coalesce(p ->> 'applies_to', 'all');
  v_products uuid[];
  v_collections uuid[];
  v_starts timestamptz := coalesce(nullif(p ->> 'starts_at', '')::timestamptz, now());
  v_ends timestamptz := nullif(p ->> 'ends_at', '')::timestamptz;
  v_min numeric := nullif(p ->> 'min_subtotal', '')::numeric;
  v_limit int := nullif(p ->> 'usage_limit', '')::int;
  v_per int := nullif(p ->> 'per_phone_limit', '')::int;
  v_cur text;
  d public.shop_discounts;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  select coalesce(currency, 'EGP') into v_cur from public.shops where id = p_shop;
  if v_method not in ('code', 'auto') then
    raise exception 'نوع الخصم مش صحيح';
  end if;
  if v_type not in ('percent', 'fixed', 'free_shipping') then
    raise exception 'نوع الخصم مش صحيح';
  end if;
  if v_method = 'code' then
    if v_code is null or v_code !~ '^[A-Z0-9_ء-ي-]{3,30}$' then
      raise exception 'الكود لازم يكون من 3 لـ 30 حرف أو رقم (من غير مسافات)';
    end if;
    v_title := coalesce(v_title, v_code);
  else
    v_code := null;
    if v_title is null then
      raise exception 'اكتب اسم للخصم التلقائي (الزبون بيشوفه)';
    end if;
  end if;
  if v_type = 'percent' and (v_value <= 0 or v_value > 100) then
    raise exception 'النسبة لازم تكون من 1 لـ 100%%';
  end if;
  if v_type = 'fixed' and (v_value <= 0 or v_value > private.money_cap(100000, v_cur)) then
    raise exception 'اكتب قيمة الخصم';
  end if;
  if v_type = 'free_shipping' then
    v_value := 0;
    v_applies := 'all';
  end if;
  if v_applies not in ('all', 'products', 'collections') then
    raise exception 'اختيار «يطبّق على» مش صحيح';
  end if;
  select coalesce(array_agg(pp.id), '{}') into v_products
    from public.shop_products pp
   where pp.shop_id = p_shop
     and pp.id::text in (select jsonb_array_elements_text(coalesce(p -> 'product_ids', '[]'::jsonb)));
  select coalesce(array_agg(distinct x::uuid), '{}') into v_collections
    from jsonb_array_elements_text(coalesce(p -> 'collection_ids', '[]'::jsonb)) x
   where x ~* '^[0-9a-f-]{36}$';
  if v_applies = 'products' and cardinality(v_products) = 0 then
    raise exception 'اختار المنتجات اللي عليها الخصم';
  end if;
  if v_applies = 'collections' and cardinality(v_collections) = 0 then
    raise exception 'اختار المجموعات اللي عليها الخصم';
  end if;
  if v_min is not null and v_min <= 0 then
    v_min := null;
  end if;
  if (v_limit is not null and v_limit <= 0) or (v_per is not null and v_per <= 0) then
    raise exception 'حد الاستخدام لازم يكون رقم أكبر من صفر';
  end if;
  if v_ends is not null and v_ends <= v_starts then
    raise exception 'تاريخ النهاية لازم يكون بعد البداية';
  end if;

  begin
    if v_id is null then
      insert into public.shop_discounts (shop_id, method, code, title, type, value, applies_to, product_ids, collection_ids,
                                         min_subtotal, usage_limit, per_phone_limit, starts_at, ends_at, active, combines)
      values (p_shop, v_method, v_code, v_title, v_type, v_value, v_applies,
              case when v_applies = 'products' then v_products else '{}' end,
              case when v_applies = 'collections' then v_collections else '{}' end,
              v_min, v_limit, v_per, v_starts, v_ends, coalesce((p ->> 'active')::boolean, true), coalesce((p ->> 'combines')::boolean, false))
      returning * into d;
    else
      update public.shop_discounts set
        method = v_method, code = v_code, title = v_title, type = v_type, value = v_value, applies_to = v_applies,
        product_ids = case when v_applies = 'products' then v_products else '{}' end,
        collection_ids = case when v_applies = 'collections' then v_collections else '{}' end,
        min_subtotal = v_min, usage_limit = v_limit, per_phone_limit = v_per, starts_at = v_starts, ends_at = v_ends,
        active = coalesce((p ->> 'active')::boolean, active), combines = coalesce((p ->> 'combines')::boolean, combines), updated_at = now()
      where id = v_id and shop_id = p_shop
      returning * into d;
      if d.id is null then
        raise exception 'الخصم ده مش موجود';
      end if;
    end if;
  exception when unique_violation then
    raise exception 'الكود «%» موجود قبل كده', v_code;
  end;
  return private.discount_json(d);
end;
$$;

-- Deletes a discount nobody used; a used one is switched off instead
-- (its orders keep the snapshot).
create or replace function public.delete_shop_discount(p_discount uuid) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  d public.shop_discounts;
begin
  select * into d from public.shop_discounts where id = p_discount;
  if d.id is null or not public.i_own_shop(d.shop_id) then
    raise exception 'الخصم ده مش موجود';
  end if;
  if exists (select 1 from public.shop_discount_uses where discount_id = p_discount)
     or exists (select 1 from public.shop_orders where discount_id = p_discount or auto_discount_id = p_discount) then
    update public.shop_discounts set active = false, updated_at = now() where id = p_discount;
    return jsonb_build_object('deleted', false, 'deactivated', true);
  end if;
  delete from public.shop_discounts where id = p_discount;
  return jsonb_build_object('deleted', true, 'deactivated', false);
end;
$$;

-- The orders that used a discount.
create or replace function public.merchant_discount_orders(p_discount uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_shop uuid := (select shop_id from public.shop_discounts where id = p_discount);
begin
  if v_shop is null or not public.i_own_shop(v_shop) then
    raise exception 'الخصم ده مش موجود';
  end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object('id', o.id, 'order_code', o.order_code, 'customer_name', o.customer_name, 'status', o.status,
                                        'created_at', o.created_at, 'total_amount', o.total_amount, 'discount_amount', o.discount_amount,
                                        'currency', o.currency) order by o.created_at desc)
      from public.shop_orders o
     where o.shop_id = v_shop and (o.discount_id = p_discount or o.auto_discount_id = p_discount)), '[]'::jsonb);
end;
$$;

-- ============================================================ carts

create or replace function private.purge_old_carts() returns void
language sql security definer set search_path = public as $$
  delete from public.shop_carts where updated_at < now() - interval '30 days';
$$;

-- The checkout's step 1 (phone + name typed): saves / refreshes the
-- customer's cart. Returns its token (null when rate-limited — the
-- checkout never fails because of it).
create or replace function public.save_store_cart(
  p_shop_id uuid,
  p_customer_phone text,
  p_customer_name text,
  p_items jsonb,
  p_area text default null
) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop record;
  v_phone text := private.phone_store(p_customer_phone, private.my_country());
  v_name text := nullif(left(btrim(coalesce(p_customer_name, '')), 80), '');
  v_lines jsonb;
  v_sub numeric;
  v_count int;
  v_token text;
  v_existing public.shop_carts;
begin
  select * into v_shop from public.shops where id = p_shop_id;
  if not found or v_shop.owner_id is null then
    raise exception 'المحل ده مش مستقبل طلبات حالياً';
  end if;
  if v_phone is null then
    raise exception 'رقم موبايل مش صحيح';
  end if;
  if auth.uid() is not null and v_shop.owner_id = auth.uid() then
    return null;
  end if;
  if private.checkout_hit_count(p_shop_id, 'cart', v_phone, interval '1 hour') >= 20
     or private.checkout_hit_count(p_shop_id, 'cart', null, interval '1 hour') >= 300 then
    return null;
  end if;
  perform private.checkout_hit(p_shop_id, 'cart', v_phone);
  perform private.purge_old_carts();

  v_lines := private.checkout_lines(p_shop_id, p_items, true);
  if jsonb_array_length(v_lines) = 0 then
    return null;
  end if;
  select coalesce(sum((l ->> 'line_total')::numeric), 0), coalesce(sum((l ->> 'quantity')::int), 0) into v_sub, v_count
    from jsonb_array_elements(v_lines) l;

  select * into v_existing from public.shop_carts where shop_id = p_shop_id and phone = v_phone for update;
  if v_existing.id is not null and v_existing.recovered_order_id is null then
    update public.shop_carts set name = coalesce(v_name, name), lines = v_lines, subtotal = v_sub, item_count = v_count,
                                 currency = coalesce(v_shop.currency, 'EGP'), area = coalesce(nullif(left(btrim(coalesce(p_area, '')), 60), ''), area),
                                 updated_at = now()
     where id = v_existing.id;
    return v_existing.token;
  end if;
  v_token := replace(gen_random_uuid()::text, '-', '');
  if v_existing.id is not null then
    -- a new shopping after an order: a fresh cart (new link)
    update public.shop_carts set token = v_token, name = coalesce(v_name, name), lines = v_lines, subtotal = v_sub, item_count = v_count,
                                 currency = coalesce(v_shop.currency, 'EGP'), area = nullif(left(btrim(coalesce(p_area, '')), 60), ''),
                                 created_at = now(), updated_at = now(), reminded_at = null, recovered_order_id = null, recovered_at = null
     where id = v_existing.id;
  else
    insert into public.shop_carts (shop_id, token, phone, name, lines, subtotal, item_count, currency, area)
    values (p_shop_id, v_token, v_phone, v_name, v_lines, v_sub, v_count, coalesce(v_shop.currency, 'EGP'),
            nullif(left(btrim(coalesce(p_area, '')), 60), ''));
  end if;
  return v_token;
end;
$$;

-- «كمّل طلبك» link: the cart's lines only (no name / phone).
create or replace function public.get_store_cart(p_token text) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'shop_slug', s.slug,
    'lines', coalesce((select jsonb_agg(jsonb_build_object('product_id', l ->> 'product_id', 'variant_id', l ->> 'variant_id',
                                                            'quantity', (l ->> 'quantity')::int, 'options', l ->> 'options'))
                         from jsonb_array_elements(c.lines) l), '[]'::jsonb))
  from public.shop_carts c join public.shops s on s.id = c.shop_id
  where c.token = lower(btrim(coalesce(p_token, ''))) and c.recovered_order_id is null and c.updated_at > now() - interval '30 days';
$$;

-- «سلات متروكة»: carts idle for more than an hour without an order, plus
-- what came back.
create or replace function public.merchant_abandoned_carts(p_shop uuid) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  perform private.purge_old_carts();
  return jsonb_build_object(
    'carts', coalesce((
      select jsonb_agg(jsonb_build_object('id', c.id, 'token', c.token, 'name', c.name, 'phone', c.phone, 'lines', c.lines,
                                          'subtotal', c.subtotal, 'item_count', c.item_count, 'currency', c.currency, 'area', c.area,
                                          'created_at', c.created_at, 'updated_at', c.updated_at, 'reminded_at', c.reminded_at)
                       order by c.updated_at desc)
        from (select * from public.shop_carts
               where shop_id = p_shop and recovered_order_id is null and updated_at < now() - interval '1 hour'
               order by updated_at desc limit 200) c), '[]'::jsonb),
    'recovered_count', (select count(*) from public.shop_carts where shop_id = p_shop and recovered_order_id is not null and reminded_at is not null),
    'recovered_value', (select coalesce(sum(o.total_amount), 0) from public.shop_carts c join public.shop_orders o on o.id = c.recovered_order_id
                         where c.shop_id = p_shop and c.reminded_at is not null and o.status <> 'cancelled'));
end;
$$;

-- The merchant sent «كمّل طلبك».
create or replace function public.merchant_mark_cart_reminded(p_cart uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.shop_carts c set reminded_at = now()
   where c.id = p_cart and public.i_own_shop(c.shop_id);
  if not found then
    raise exception 'السلة دي مش موجودة';
  end if;
end;
$$;

-- ============================================================ store currency

-- What a store can be priced in: the 22 Arab states' currencies (Palestine
-- uses ₪) + USD / EUR / GBP (the app's storeCurrencies).
create or replace function private.shop_currencies() returns text[]
language sql immutable as $$
  select array['EGP', 'SAR', 'AED', 'KWD', 'QAR', 'BHD', 'OMR', 'JOD', 'LBP', 'SYP', 'IQD', 'YER', 'SDG', 'LYD',
               'TND', 'DZD', 'MAD', 'MRU', 'SOS', 'DJF', 'KMF', 'ILS', 'USD', 'EUR', 'GBP']
$$;

-- «عملة المتجر»: the shop's currency (default: its country's, 0092).
-- Products follow (0092 trigger); orders keep the currency they were
-- placed in. Nothing is converted — amounts already typed (prices, fees,
-- discounts) keep their numbers, so a switch that would break a cap is
-- refused with what to fix first.
create or replace function public.set_shop_currency(p_shop uuid, p_currency text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_cur text := upper(btrim(coalesce(p_currency, '')));
  v_old text;
  v_fee_cap numeric;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if not v_cur = any (private.shop_currencies()) then
    raise exception 'العملة دي مش متاحة للمتاجر';
  end if;
  select currency into v_old from public.shops where id = p_shop for update;
  if v_old = v_cur then
    return jsonb_build_object('currency', v_cur, 'changed', false);
  end if;
  v_fee_cap := private.money_cap(1000, v_cur);
  if exists (select 1 from public.shops where id = p_shop and delivery_fee > v_fee_cap)
     or exists (select 1 from public.shop_shipping_zones where shop_id = p_shop and fee > v_fee_cap) then
    raise exception 'سعر التوصيل أكبر من المسموح بالعملة الجديدة (أقصى %) — عدّله الأول من «الشحن والتوصيل»', private.money_text(v_fee_cap, v_cur);
  end if;
  if exists (select 1 from public.shop_products where shop_id = p_shop and price > private.money_cap(1000000, v_cur)) then
    raise exception 'فيه منتجات سعرها أكبر من المسموح بالعملة الجديدة — عدّل أسعارها الأول';
  end if;
  update public.shops set currency = v_cur where id = p_shop;
  return jsonb_build_object('currency', v_cur, 'changed', true, 'label', private.currency_label(v_cur));
end;
$$;

-- ============================================================ grants

do $$
declare
  f text;
begin
  foreach f in array array[
    'public.get_shop_shipping(uuid)',
    'public.set_shop_shipping(uuid, jsonb)',
    'public.merchant_discounts(uuid)',
    'public.save_shop_discount(uuid, jsonb)',
    'public.delete_shop_discount(uuid)',
    'public.merchant_discount_orders(uuid)',
    'public.merchant_abandoned_carts(uuid)',
    'public.merchant_mark_cart_reminded(uuid)',
    'public.merchant_confirm_order(uuid)',
    'public.set_shop_currency(uuid, text)'] loop
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
  foreach f in array array[
    'public.quote_store_checkout(uuid, jsonb, text, text, text, text)',
    'public.store_checkout_info(uuid)',
    'public.save_store_cart(uuid, text, text, jsonb, text)',
    'public.get_store_cart(text)',
    'public.guest_cancel_store_order(text, text, text)'] loop
    execute format('revoke execute on function %s from public', f);
    execute format('grant execute on function %s to anon, authenticated', f);
  end loop;
  foreach f in array array[
    'public._shop_order_confirm_guard()',
    'public._shop_order_release_discounts()'] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
  end loop;
end;
$$;
