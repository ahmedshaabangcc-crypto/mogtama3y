-- =====================================================================
-- Migration 0098 — متجري: catalog pro (phase 2).
--
--   * Variants (Shopify-style): a product has up to 3 options (free names
--     — المقاس، اللون، الخامة…) kept in shop_products.options as before
--     ([{name, values}]), and one row per combination in
--     shop_product_variants (option_values = the values in option order,
--     sku, barcode, price, compare_at_price, stock, image_url, position,
--     is_available). A product with no options has NO variant rows: the
--     product row itself is its single "default variant" (price, stock,
--     sku, barcode on shop_products) — old builds, store-lite.js and the
--     dalil pages keep reading shop_products unchanged.
--     For products with variants, shop_products.price / old_price / stock
--     are a rollup kept by trigger: price = the cheapest available
--     variant, old_price = its compare-at, stock = the sum of available
--     variants' stock (null when any of them is unlimited, 0 when none is
--     available).
--   * Ordering: place_store_order / place_shop_order lines are
--     {product_id, variant_id?, quantity (or qty), options?}. With a
--     variant_id the variant's price / stock are used (stock locked and
--     decremented per variant); without one (old clients) the options
--     text is matched to a variant label («المقاس: M • اللون: أسود»), or
--     the only variant, else the product row (products without
--     variants — exactly the 0096 behaviour). Lines snapshot variant_id,
--     variant_label and sku; cancelling restocks the variant.
--   * SKU & barcode (unique SKU per shop across products and variants).
--   * Collections («الأقسام»): shop_collections + shop_collection_products
--     (manual, ordered) and simple smart collections (rules: tag,
--     min_price, max_price, in_stock). The public reads visible ones only.
--   * Products: tags, position (manual sort, drag reorder), slug (the
--     handle, unique per shop, filled automatically), seo_title,
--     seo_description, video_url (YouTube). Duplicate, bulk actions.
--   * CSV import (Shopify-like columns), server-side in batches of up to
--     500 rows with validation, a dry-run preview and an error report;
--     idempotent (matches by handle, then SKU).
--   * Low stock: shops.low_stock_threshold (default 3); a notification to
--     the owner when a variant / product drops to or below it after an
--     order (crossing only, once per variant per 24 h, at most 5 per shop
--     per hour; the merchant's own edits never alert).
--   * One-time data migration (marked in private.migration_marks, so a
--     re-run never repeats it): every product's old option lists become
--     its variants (price = the product's; stock: unlimited when the
--     product's was, else the product's stock split evenly across the
--     variants so the total is unchanged — no overselling, the merchant
--     adjusts per variant later); every shop's free-text product
--     categories become manual collections with their products.
--
-- Redefines (latest bodies: 0096) place_store_order, place_shop_order,
-- private.order_lines_json, and 0068's shop_order_restock_on_cancel.
-- Run after 0097. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table if not exists private.migration_marks (
  name text primary key,
  at timestamptz not null default now()
);
revoke all on private.migration_marks from public, anon, authenticated;

-- ============================================================ helpers

-- A handle from any text: lower-case Latin / Arabic letters and digits
-- joined by '-', at most 70 characters ('p' when nothing is left).
create or replace function public.catalog_slugify(p text) returns text
language sql
immutable
as $$
  select coalesce(nullif(trim(both '-' from left(trim(both '-' from regexp_replace(
           regexp_replace(lower(coalesce(p, '')), '[ً-ٟـ]', '', 'g'),
           '[^a-z0-9ء-ي٠-٩]+', '-', 'g')), 70)), ''), 'p');
$$;

-- The 11-character YouTube id of a watch / shorts / embed / youtu.be link.
create or replace function public.youtube_id(p text) returns text
language sql
immutable
as $$
  select substring(trim(coalesce(p, '')) from
    '^(?:https?://)?(?:www\.|m\.)?(?:youtube\.com/(?:watch\?(?:[^#]*&)?v=|shorts/|embed/|live/)|youtu\.be/)([A-Za-z0-9_-]{11})(?:[?&#/].*)?$');
$$;

-- «المقاس: M • اللون: أسود» — the same text the storefront cart always
-- wrote (so old clients' options match a variant).
create or replace function public.catalog_variant_label(p_options jsonb, p_values jsonb) returns text
language sql
immutable
as $$
  select nullif(string_agg((o.opt->>'name') || ': ' || (p_values->>((o.i - 1)::int)), ' • ' order by o.i), '')
    from jsonb_array_elements(case when jsonb_typeof(p_options) = 'array' then p_options else '[]'::jsonb end) with ordinality o(opt, i)
   where jsonb_typeof(p_values) = 'array' and p_values->>((o.i - 1)::int) is not null;
$$;

-- A number typed by a merchant / CSV ('1,250.50', '١٢٠'), null when blank.
create or replace function private.loose_num(p text) returns numeric
language plpgsql
immutable
as $$
declare
  v text := replace(replace(translate(trim(coalesce(p, '')), '٠١٢٣٤٥٦٧٨٩٫', '0123456789.'), ',', ''), '٬', '');
begin
  if v = '' then
    return null;
  end if;
  if v !~ '^-?[0-9]+(\.[0-9]+)?$' then
    raise exception 'invalid number' using errcode = '22P02';
  end if;
  return v::numeric;
end;
$$;

-- Cleans and validates the option definitions: ≤ 3 options, named,
-- 1–30 distinct values each (trimmed, ≤ 40 characters).
create or replace function private.catalog_options(p jsonb) returns jsonb
language plpgsql
immutable
as $$
declare
  v_out jsonb := '[]'::jsonb;
  v_o jsonb;
  v_name text;
  v_vals jsonb;
  v_v text;
  v_names text[] := '{}';
begin
  if p is null or jsonb_typeof(p) <> 'array' then
    return '[]'::jsonb;
  end if;
  if jsonb_array_length(p) > 3 then
    raise exception 'لحد 3 خيارات للمنتج (زي المقاس واللون والخامة)';
  end if;
  for v_o in select * from jsonb_array_elements(p) loop
    v_name := left(trim(coalesce(v_o->>'name', '')), 30);
    if v_name = '' then
      raise exception 'اكتب اسم الخيار (مثلاً: المقاس)';
    end if;
    if lower(v_name) = any(v_names) then
      raise exception 'الخيار «%» متكرر', v_name;
    end if;
    v_names := v_names || lower(v_name);
    v_vals := '[]'::jsonb;
    if jsonb_typeof(v_o->'values') = 'array' then
      for v_v in select left(trim(x), 40) from jsonb_array_elements_text(v_o->'values') as t(x) loop
        if v_v <> '' and not (v_vals ? v_v) then
          v_vals := v_vals || to_jsonb(v_v);
        end if;
      end loop;
    end if;
    if jsonb_array_length(v_vals) = 0 then
      raise exception 'ضيف قيمة واحدة على الأقل لـ «%»', v_name;
    end if;
    if jsonb_array_length(v_vals) > 30 then
      raise exception 'لحد 30 قيمة لـ «%»', v_name;
    end if;
    v_out := v_out || jsonb_build_array(jsonb_build_object('name', v_name, 'values', v_vals));
  end loop;
  return v_out;
end;
$$;

-- Every combination of the option values, in order (["S","أسود"], …).
create or replace function private.options_matrix(p_options jsonb) returns setof jsonb
language plpgsql
immutable
as $$
declare
  v_acc jsonb[] := array['[]'::jsonb];
  v_next jsonb[];
  v_opt jsonb;
  v_val text;
  v_a jsonb;
begin
  if p_options is null or jsonb_typeof(p_options) <> 'array' or jsonb_array_length(p_options) = 0 then
    return;
  end if;
  for v_opt in select * from jsonb_array_elements(p_options) loop
    v_next := '{}';
    foreach v_a in array v_acc loop
      for v_val in select * from jsonb_array_elements_text(v_opt->'values') loop
        v_next := array_append(v_next, v_a || jsonb_build_array(v_val));
      end loop;
    end loop;
    v_acc := v_next;
  end loop;
  foreach v_a in array v_acc loop
    return next v_a;
  end loop;
end;
$$;

-- ============================================================ products: new columns

alter table public.shop_products add column if not exists sku text;
alter table public.shop_products add column if not exists barcode text;
alter table public.shop_products add column if not exists tags text[] not null default '{}';
alter table public.shop_products add column if not exists position int;
alter table public.shop_products add column if not exists slug text;
alter table public.shop_products add column if not exists seo_title text;
alter table public.shop_products add column if not exists seo_description text;
alter table public.shop_products add column if not exists video_url text;

alter table public.shop_products drop constraint if exists shop_products_catalog_valid;
alter table public.shop_products add constraint shop_products_catalog_valid check (
  (sku is null or length(sku) between 1 and 64)
  and (barcode is null or length(barcode) between 1 and 64)
  and cardinality(tags) <= 20
  and (seo_title is null or length(seo_title) <= 120)
  and (seo_description is null or length(seo_description) <= 320)
  and (video_url is null or public.youtube_id(video_url) is not null)
  and (slug is null or (length(slug) <= 80 and slug ~ '^[a-z0-9ء-ي٠-٩]+(-[a-z0-9ء-ي٠-٩]+)*$'))
);

create unique index if not exists shop_products_slug_key on public.shop_products (shop_id, slug);
create unique index if not exists shop_products_sku_key on public.shop_products (shop_id, lower(sku)) where sku is not null;
create index if not exists shop_products_position_idx on public.shop_products (shop_id, position, created_at desc);

-- A handle not used by another product of the shop (base, base-2, …).
create or replace function private.unique_product_slug(p_shop uuid, p_base text, p_self uuid) returns text
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_base text := public.catalog_slugify(p_base);
  v_try text := v_base;
  v_n int := 1;
begin
  while exists (select 1 from public.shop_products where shop_id = p_shop and slug = v_try and id is distinct from p_self) loop
    v_n := v_n + 1;
    v_try := trim(both '-' from left(v_base, 70)) || '-' || v_n;
  end loop;
  return v_try;
end;
$$;

-- New rows (any client) get a handle and go first in the manual order.
create or replace function public._shop_product_catalog_defaults() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    if new.position is null then
      select coalesce(min(position), 0) - 1 into new.position from public.shop_products where shop_id = new.shop_id;
    end if;
    new.slug := private.unique_product_slug(new.shop_id, coalesce(nullif(trim(new.slug), ''), new.name), new.id);
  elsif new.slug is distinct from old.slug then
    if nullif(trim(coalesce(new.slug, '')), '') is null then
      new.slug := private.unique_product_slug(new.shop_id, new.name, new.id);
    else
      new.slug := public.catalog_slugify(new.slug);
      if exists (select 1 from public.shop_products where shop_id = new.shop_id and slug = new.slug and id <> new.id) then
        raise exception 'الرابط ده مستخدم لمنتج تاني في متجرك';
      end if;
    end if;
  end if;
  return new;
end;
$$;
drop trigger if exists shop_product_catalog_defaults on public.shop_products;
create trigger shop_product_catalog_defaults before insert or update of slug on public.shop_products
  for each row execute function public._shop_product_catalog_defaults();

-- Backfill: handles and the manual order (newest first, as before).
do $$
declare
  r record;
begin
  for r in select id, shop_id, name from public.shop_products where slug is null order by created_at, id loop
    update public.shop_products set slug = private.unique_product_slug(r.shop_id, r.name, r.id) where id = r.id;
  end loop;
end;
$$;
update public.shop_products p set position = r.n
  from (select id, (row_number() over (partition by shop_id order by created_at desc, id) - 1)::int as n
          from public.shop_products where position is null) r
 where r.id = p.id;

alter table public.shops add column if not exists low_stock_threshold int not null default 3;

-- Prices in the shop's currency (0092) keep 3 decimals for the 3-decimal
-- currencies (KWD, BHD, OMR, JOD, IQD, LYD, TND); catalog_save refuses a
-- third decimal for the others. (Only when not already 3 — a re-run never
-- touches columns triggers depend on.)
do $$
declare
  c record;
begin
  for c in select * from (values ('shop_products', 'price'), ('shop_products', 'old_price'), ('shop_order_items', 'unit_price'),
                                 ('shop_orders', 'total_amount'), ('shop_orders', 'delivery_fee')) v(t, col) loop
    if exists (select 1 from information_schema.columns
                where table_schema = 'public' and table_name = c.t and column_name = c.col and coalesce(numeric_scale, 0) <> 3) then
      execute format('alter table public.%I alter column %I type numeric(14,3)', c.t, c.col);
    end if;
  end loop;
end;
$$;

create or replace function public.currency_decimals(p text) returns int
language sql
immutable
as $$
  select case when upper(coalesce(p, '')) in ('KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'LYD', 'TND') then 3 else 2 end;
$$;
alter table public.shops drop constraint if exists shops_low_stock_threshold_valid;
alter table public.shops add constraint shops_low_stock_threshold_valid check (low_stock_threshold between 0 and 1000);

-- ============================================================ variants

create table if not exists public.shop_product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.shop_products(id) on delete cascade,
  shop_id uuid not null references public.shops(id) on delete cascade,
  option_values jsonb not null default '[]'::jsonb,
  sku text,
  barcode text,
  price numeric(14,3) not null,
  compare_at_price numeric(14,3),
  stock int,
  image_url text,
  position int not null default 0,
  is_available boolean not null default true,
  created_at timestamptz not null default now()
);
alter table public.shop_product_variants drop constraint if exists shop_product_variants_valid;
alter table public.shop_product_variants add constraint shop_product_variants_valid check (
  jsonb_typeof(option_values) = 'array' and jsonb_array_length(option_values) between 1 and 3
  and price >= 0 and price <= 1000000
  and (compare_at_price is null or (compare_at_price > price and compare_at_price <= 1000000))
  and (stock is null or stock between 0 and 1000000)
  and (sku is null or length(sku) between 1 and 64)
  and (barcode is null or length(barcode) between 1 and 64)
);
create unique index if not exists shop_product_variants_combo_key on public.shop_product_variants (product_id, option_values);
create unique index if not exists shop_product_variants_sku_key on public.shop_product_variants (shop_id, lower(sku)) where sku is not null;
create index if not exists shop_product_variants_product_idx on public.shop_product_variants (product_id, position);
create index if not exists shop_product_variants_shop_idx on public.shop_product_variants (shop_id);

alter table public.shop_product_variants enable row level security;
grant select on public.shop_product_variants to anon, authenticated;
revoke insert, update, delete on public.shop_product_variants from anon, authenticated;
drop policy if exists "shop_product_variants: public reads available" on public.shop_product_variants;
create policy "shop_product_variants: public reads available" on public.shop_product_variants
  for select using (is_available and exists (select 1 from public.shop_products p where p.id = shop_product_variants.product_id and p.is_available));
drop policy if exists "shop_product_variants: owner reads all" on public.shop_product_variants;
create policy "shop_product_variants: owner reads all" on public.shop_product_variants
  for select using (exists (select 1 from public.shops s where s.id = shop_product_variants.shop_id and s.owner_id = auth.uid()));

-- A variant always belongs to its product's shop.
create or replace function public._shop_variant_shop() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  select shop_id into new.shop_id from public.shop_products where id = new.product_id;
  return new;
end;
$$;
drop trigger if exists shop_variant_shop on public.shop_product_variants;
create trigger shop_variant_shop before insert or update of product_id, shop_id on public.shop_product_variants
  for each row execute function public._shop_variant_shop();

-- shop_products.price / old_price / stock of a product with variants.
create or replace function private.catalog_rollup(p_product uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_all int;
  v_avail int;
  v_min_avail numeric;
  v_min_all numeric;
  v_unlimited boolean;
  v_sum bigint;
  v_price numeric;
  v_cmp numeric;
  v_stock int;
begin
  select count(*), count(*) filter (where is_available), min(price) filter (where is_available), min(price),
         coalesce(bool_or(stock is null) filter (where is_available), false), coalesce(sum(stock) filter (where is_available), 0)
    into v_all, v_avail, v_min_avail, v_min_all, v_unlimited, v_sum
    from public.shop_product_variants where product_id = p_product;
  if v_all = 0 then
    return;
  end if;
  v_price := coalesce(v_min_avail, v_min_all);
  select compare_at_price into v_cmp from public.shop_product_variants
   where product_id = p_product and price = v_price and compare_at_price > price
   order by is_available desc, position limit 1;
  v_stock := case when v_avail = 0 then 0 when v_unlimited then null else least(v_sum, 2000000000)::int end;
  update public.shop_products set price = v_price, old_price = v_cmp, stock = v_stock
   where id = p_product and (price, old_price, stock) is distinct from (v_price, v_cmp, v_stock);
end;
$$;

create or replace function public._shop_variant_rollup() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'DELETE' then
    perform private.catalog_rollup(old.product_id);
  else
    perform private.catalog_rollup(new.product_id);
    if tg_op = 'UPDATE' and old.product_id <> new.product_id then
      perform private.catalog_rollup(old.product_id);
    end if;
  end if;
  return null;
end;
$$;
drop trigger if exists shop_variant_rollup on public.shop_product_variants;
create trigger shop_variant_rollup after insert or delete or update of price, compare_at_price, stock, is_available, product_id on public.shop_product_variants
  for each row execute function public._shop_variant_rollup();

-- ============================================================ low stock

create table if not exists private.low_stock_alerts (
  shop_id uuid not null,
  product_id uuid not null,
  variant_id uuid,
  at timestamptz not null default now()
);
create index if not exists low_stock_alerts_idx on private.low_stock_alerts (shop_id, at desc);
revoke all on private.low_stock_alerts from public, anon, authenticated;

-- Tells the owner a variant / product just dropped to (or below) the
-- shop's threshold. Crossing only; once per variant per 24 h; at most 5
-- per shop per hour; never for the merchant's own edits.
create or replace function private.low_stock_check(p_shop uuid, p_product uuid, p_variant uuid, p_old int, p_new int) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_thr int;
  v_owner uuid;
  v_name text;
  v_opts jsonb;
  v_label text;
begin
  if p_new is null then
    return;
  end if;
  select low_stock_threshold, owner_id into v_thr, v_owner from public.shops where id = p_shop;
  if v_owner is null or coalesce(v_thr, 0) <= 0 then
    return;
  end if;
  if p_new > v_thr or (p_old is not null and p_old <= v_thr) then
    return;
  end if;
  if auth.uid() is not null and auth.uid() = v_owner then
    return;
  end if;
  if exists (select 1 from private.low_stock_alerts
              where product_id = p_product and variant_id is not distinct from p_variant and at > now() - interval '24 hours') then
    return;
  end if;
  if (select count(*) from private.low_stock_alerts where shop_id = p_shop and at > now() - interval '1 hour') >= 5 then
    return;
  end if;
  delete from private.low_stock_alerts where at < now() - interval '2 days';
  insert into private.low_stock_alerts (shop_id, product_id, variant_id) values (p_shop, p_product, p_variant);
  select name, options into v_name, v_opts from public.shop_products where id = p_product;
  if p_variant is not null then
    select public.catalog_variant_label(v_opts, option_values) into v_label from public.shop_product_variants where id = p_variant;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (v_owner, '📦 منتج قرب يخلص — ' || v_name,
          case when p_new = 0 then 'خلصت الكمية من «' else 'فاضل ' || p_new || ' بس من «' end
            || v_name || coalesce(' — ' || v_label, '') || '». زوّد الكمية من «المنتجات» في متجري.',
          '/#/products/' || p_product);
end;
$$;

create or replace function public._shop_variant_low_stock() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.stock is distinct from old.stock and new.stock is not null and new.is_available then
    perform private.low_stock_check(new.shop_id, new.product_id, new.id, old.stock, new.stock);
  end if;
  return null;
end;
$$;
drop trigger if exists shop_variant_low_stock on public.shop_product_variants;
create trigger shop_variant_low_stock after update of stock on public.shop_product_variants
  for each row execute function public._shop_variant_low_stock();

-- Products without variants (their own stock).
create or replace function public._shop_product_low_stock() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.stock is distinct from old.stock and new.stock is not null and new.status <> 'archived'
     and not exists (select 1 from public.shop_product_variants where product_id = new.id) then
    perform private.low_stock_check(new.shop_id, new.id, null, old.stock, new.stock);
  end if;
  return null;
end;
$$;
drop trigger if exists shop_product_low_stock on public.shop_products;
create trigger shop_product_low_stock after update of stock on public.shop_products
  for each row execute function public._shop_product_low_stock();

-- ============================================================ collections

create table if not exists public.shop_collections (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  name text not null,
  slug text not null,
  description text,
  image_url text,
  position int not null default 0,
  is_visible boolean not null default true,
  -- null: a manual collection; else a smart one (see collection_rules_problem).
  rules jsonb,
  created_at timestamptz not null default now()
);
create unique index if not exists shop_collections_slug_key on public.shop_collections (shop_id, slug);
create index if not exists shop_collections_shop_idx on public.shop_collections (shop_id, position);

-- '' when the smart rules are valid, else the Arabic reason.
create or replace function public.collection_rules_problem(r jsonb) returns text
language plpgsql
immutable
as $$
declare
  k text;
begin
  if r is null then
    return '';
  end if;
  if jsonb_typeof(r) <> 'object' then
    return 'شروط القسم مش صحيحة';
  end if;
  for k in select jsonb_object_keys(r) loop
    if k not in ('tag', 'min_price', 'max_price', 'in_stock') then
      return 'شرط مش معروف: ' || k;
    end if;
  end loop;
  if r ? 'tag' and (jsonb_typeof(r->'tag') <> 'string' or length(trim(r->>'tag')) not between 1 and 40) then
    return 'اكتب الوسم صح';
  end if;
  if r ? 'min_price' and jsonb_typeof(r->'min_price') <> 'number' then
    return 'أقل سعر لازم يكون رقم';
  end if;
  if r ? 'max_price' and jsonb_typeof(r->'max_price') <> 'number' then
    return 'أعلى سعر لازم يكون رقم';
  end if;
  if r ? 'in_stock' and jsonb_typeof(r->'in_stock') <> 'boolean' then
    return 'شرط «المتاح بس» مش صحيح';
  end if;
  if not (r ? 'tag' or r ? 'min_price' or r ? 'max_price' or coalesce((r->>'in_stock')::boolean, false)) then
    return 'القسم الذكي محتاج شرط واحد على الأقل';
  end if;
  return '';
end;
$$;

alter table public.shop_collections drop constraint if exists shop_collections_valid;
alter table public.shop_collections add constraint shop_collections_valid check (
  length(trim(name)) between 1 and 80
  and length(slug) between 1 and 80
  and (description is null or length(description) <= 1000)
  and public.collection_rules_problem(rules) = ''
);

create table if not exists public.shop_collection_products (
  collection_id uuid not null references public.shop_collections(id) on delete cascade,
  product_id uuid not null references public.shop_products(id) on delete cascade,
  position int not null default 0,
  primary key (collection_id, product_id)
);
create index if not exists shop_collection_products_product_idx on public.shop_collection_products (product_id);

alter table public.shop_collections enable row level security;
alter table public.shop_collection_products enable row level security;
grant select on public.shop_collections, public.shop_collection_products to anon, authenticated;
revoke insert, update, delete on public.shop_collections, public.shop_collection_products from anon, authenticated;
drop policy if exists "shop_collections: public reads visible" on public.shop_collections;
create policy "shop_collections: public reads visible" on public.shop_collections
  for select using (is_visible or exists (select 1 from public.shops s where s.id = shop_collections.shop_id and s.owner_id = auth.uid()));
drop policy if exists "shop_collection_products: public reads visible" on public.shop_collection_products;
create policy "shop_collection_products: public reads visible" on public.shop_collection_products
  for select using (
    exists (select 1 from public.shop_collections c join public.shops s on s.id = c.shop_id where c.id = shop_collection_products.collection_id and s.owner_id = auth.uid())
    or (exists (select 1 from public.shop_collections c where c.id = shop_collection_products.collection_id and c.is_visible)
        and exists (select 1 from public.shop_products p where p.id = shop_collection_products.product_id and p.is_available)));

create or replace function private.unique_collection_slug(p_shop uuid, p_base text, p_self uuid) returns text
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_base text := public.catalog_slugify(p_base);
  v_try text := v_base;
  v_n int := 1;
begin
  while exists (select 1 from public.shop_collections where shop_id = p_shop and slug = v_try and id is distinct from p_self) loop
    v_n := v_n + 1;
    v_try := trim(both '-' from left(v_base, 70)) || '-' || v_n;
  end loop;
  return v_try;
end;
$$;

-- The products of a collection, in its order (manual: the merchant's;
-- smart: the shop's product order).
create or replace function private.collection_members(c public.shop_collections) returns table (product_id uuid, pos bigint)
language sql
stable
security definer
set search_path = public
as $$
  select cp.product_id, cp.position::bigint
    from public.shop_collection_products cp
   where c.rules is null and cp.collection_id = c.id
  union all
  select p.id, row_number() over (order by p.position nulls last, p.created_at desc)
    from public.shop_products p
   where c.rules is not null and p.shop_id = c.shop_id and p.status <> 'archived'
     and (not (c.rules ? 'tag') or (c.rules->>'tag') = any(p.tags))
     and (not (c.rules ? 'min_price') or p.price >= (c.rules->>'min_price')::numeric)
     and (not (c.rules ? 'max_price') or p.price <= (c.rules->>'max_price')::numeric)
     and (not coalesce((c.rules->>'in_stock')::boolean, false) or p.stock is null or p.stock > 0);
$$;

create or replace function private.collection_json(c public.shop_collections, p_public boolean) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'id', c.id, 'name', c.name, 'slug', c.slug, 'description', c.description, 'image_url', c.image_url,
    'position', c.position, 'is_visible', c.is_visible, 'rules', c.rules,
    'product_ids', coalesce((
      select jsonb_agg(m.product_id order by m.pos, m.product_id)
        from private.collection_members(c) m join public.shop_products p on p.id = m.product_id
       where not p_public or p.is_available), '[]'::jsonb));
$$;

-- ============================================================ save a product

-- Is this SKU used by another product / variant of the shop?
create or replace function private.sku_taken(p_shop uuid, p_sku text, p_product uuid) returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select p_sku is not null and (
    exists (select 1 from public.shop_products where shop_id = p_shop and lower(sku) = lower(p_sku) and id is distinct from p_product)
    or exists (select 1 from public.shop_product_variants where shop_id = p_shop and lower(sku) = lower(p_sku) and product_id is distinct from p_product));
$$;

-- The one writer of products + variants + collection membership (the
-- editor, the CSV import). p: the product fields; p_variants: [] for a
-- product without options, else one entry per combination
-- {option_values, sku, barcode, price, compare_at_price, stock,
-- image_url, is_available}; p_collections: the manual collections it is
-- in (null = leave as is). Ownership is checked by the callers.
create or replace function private.catalog_save(p_shop uuid, p jsonb, p_variants jsonb, p_collections uuid[]) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid := nullif(p->>'id', '')::uuid;
  v_old public.shop_products;
  v_name text := left(trim(coalesce(p->>'name', '')), 120);
  v_options jsonb := private.catalog_options(p->'options');
  v_has boolean;
  v_status text := coalesce(nullif(p->>'status', ''), 'active');
  v_images text[];
  v_highlights text[];
  v_tags text[];
  v_sku text := nullif(left(trim(coalesce(p->>'sku', '')), 64), '');
  v_barcode text := nullif(left(trim(coalesce(p->>'barcode', '')), 64), '');
  v_slug text := nullif(trim(coalesce(p->>'slug', '')), '');
  v_video text := nullif(trim(coalesce(p->>'video_url', '')), '');
  v_desc text := nullif(left(trim(coalesce(p->>'description', '')), 2000), '');
  v_category text := nullif(left(trim(coalesce(p->>'category', '')), 80), '');
  v_seo_title text := nullif(left(trim(coalesce(p->>'seo_title', '')), 120), '');
  v_seo_desc text := nullif(left(trim(coalesce(p->>'seo_description', '')), 320), '');
  v_price numeric;
  v_old_price numeric;
  v_stock numeric;
  v_v jsonb;
  v_vals jsonb;
  v_combos text[] := '{}';
  v_skus text[] := '{}';
  v_label text;
  v_vprice numeric;
  v_vcmp numeric;
  v_vstock numeric;
  v_vsku text;
  v_vimg text;
  v_k int;
  v_pos int := 0;
  v_cur text := coalesce((select currency from public.shops where id = p_shop), 'EGP');
  v_dec int := public.currency_decimals(v_cur);
begin
  if v_id is not null then
    select * into v_old from public.shop_products where id = v_id and shop_id = p_shop for update;
    if not found then
      raise exception 'المنتج ده مش بتاعك';
    end if;
  end if;
  if v_name = '' then
    raise exception 'اكتب اسم المنتج';
  end if;
  if v_status not in ('active', 'draft', 'archived') then
    raise exception 'حالة المنتج غير معروفة';
  end if;
  v_has := jsonb_array_length(v_options) > 0;

  select coalesce(array_agg(x order by i), '{}') into v_images
    from (select trim(x) as x, i from jsonb_array_elements_text(case when jsonb_typeof(p->'images') = 'array' then p->'images' else '[]'::jsonb end) with ordinality t(x, i)) s
   where x <> '';
  if cardinality(v_images) > 6 then
    raise exception 'لحد 6 صور للمنتج';
  end if;
  if exists (select 1 from unnest(v_images) u where u !~* '^https?://' or length(u) > 1000) then
    raise exception 'فيه لينك صورة مش صحيح';
  end if;
  select coalesce(array_agg(x order by i), '{}') into v_highlights
    from (select left(trim(x), 200) as x, i from jsonb_array_elements_text(case when jsonb_typeof(p->'highlights') = 'array' then p->'highlights' else '[]'::jsonb end) with ordinality t(x, i)) s
   where x <> '';
  if cardinality(v_highlights) > 6 then
    v_highlights := v_highlights[1:6];
  end if;
  select coalesce(array_agg(x order by i), '{}') into v_tags
    from (select left(trim(x), 40) as x, min(i) as i from jsonb_array_elements_text(case when jsonb_typeof(p->'tags') = 'array' then p->'tags' else '[]'::jsonb end) with ordinality t(x, i)
           where trim(x) <> '' group by 1) s;
  if cardinality(v_tags) > 20 then
    raise exception 'لحد 20 وسم للمنتج';
  end if;
  if v_video is not null and public.youtube_id(v_video) is null then
    raise exception 'لينك الفيديو لازم يكون من يوتيوب';
  end if;
  if v_slug is not null then
    v_slug := public.catalog_slugify(v_slug);
    if exists (select 1 from public.shop_products where shop_id = p_shop and slug = v_slug and id is distinct from v_id) then
      raise exception 'الرابط «%» مستخدم لمنتج تاني في متجرك', v_slug;
    end if;
  end if;

  if v_has then
    if p_variants is null or jsonb_typeof(p_variants) <> 'array' or jsonb_array_length(p_variants) = 0 then
      raise exception 'ضيف نوع واحد على الأقل (مقاس، لون…)';
    end if;
    if jsonb_array_length(p_variants) > 100 then
      raise exception 'لحد 100 نوع للمنتج الواحد';
    end if;
    v_sku := null;
    v_barcode := null;
  else
    if p_variants is not null and jsonb_typeof(p_variants) = 'array' and jsonb_array_length(p_variants) > 0 then
      raise exception 'الأنواع محتاجة خيارات (زي المقاس أو اللون)';
    end if;
    begin
      v_price := private.loose_num(p->>'price');
      v_old_price := private.loose_num(p->>'old_price');
      v_stock := private.loose_num(p->>'stock');
    exception when invalid_text_representation then
      raise exception 'السعر والكمية لازم يكونوا أرقام';
    end;
    if v_price is null or v_price < 0 or v_price > 1000000 then
      raise exception 'اكتب سعر صحيح';
    end if;
    if round(v_price, v_dec) <> v_price or (v_old_price is not null and round(v_old_price, v_dec) <> v_old_price) then
      raise exception 'الأسعار بالـ % لحد % أرقام بعد العلامة', v_cur, v_dec;
    end if;
    if v_old_price is not null and (v_old_price <= v_price or v_old_price > 1000000) then
      raise exception 'السعر قبل الخصم لازم يكون أكبر من السعر الحالي';
    end if;
    if v_stock is not null and (v_stock < 0 or v_stock > 1000000 or v_stock <> trunc(v_stock)) then
      raise exception 'الكمية لازم تكون رقم صحيح من 0';
    end if;
    if private.sku_taken(p_shop, v_sku, v_id) then
      raise exception 'الـ SKU «%» مستخدم لمنتج تاني', v_sku;
    end if;
  end if;

  -- Validate every variant before writing anything.
  if v_has then
    for v_v in select * from jsonb_array_elements(p_variants) loop
      if jsonb_typeof(v_v->'option_values') <> 'array' then
        raise exception 'نوع من غير خيارات';
      end if;
      select coalesce(jsonb_agg(trim(x) order by i), '[]'::jsonb) into v_vals
        from jsonb_array_elements_text(v_v->'option_values') with ordinality t(x, i);
      if jsonb_array_length(v_vals) <> jsonb_array_length(v_options) then
        raise exception 'كل نوع لازم يكون له قيمة لكل خيار';
      end if;
      for v_k in 0 .. jsonb_array_length(v_options) - 1 loop
        if not ((v_options->v_k->'values') ? (v_vals->>v_k)) then
          raise exception 'القيمة «%» مش موجودة في «%»', v_vals->>v_k, v_options->v_k->>'name';
        end if;
      end loop;
      v_label := public.catalog_variant_label(v_options, v_vals);
      if v_vals::text = any(v_combos) then
        raise exception 'النوع «%» متكرر', v_label;
      end if;
      v_combos := v_combos || v_vals::text;
      begin
        v_vprice := private.loose_num(v_v->>'price');
        v_vcmp := private.loose_num(v_v->>'compare_at_price');
        v_vstock := private.loose_num(v_v->>'stock');
      exception when invalid_text_representation then
        raise exception 'السعر والكمية لـ «%» لازم يكونوا أرقام', v_label;
      end;
      if v_vprice is null or v_vprice < 0 or v_vprice > 1000000 then
        raise exception 'اكتب سعر صحيح لـ «%»', v_label;
      end if;
      if round(v_vprice, v_dec) <> v_vprice or (v_vcmp is not null and round(v_vcmp, v_dec) <> v_vcmp) then
        raise exception 'الأسعار بالـ % لحد % أرقام بعد العلامة («%»)', v_cur, v_dec, v_label;
      end if;
      if v_vcmp is not null and (v_vcmp <= v_vprice or v_vcmp > 1000000) then
        raise exception 'السعر قبل الخصم لـ «%» لازم يكون أكبر من سعره', v_label;
      end if;
      if v_vstock is not null and (v_vstock < 0 or v_vstock > 1000000 or v_vstock <> trunc(v_vstock)) then
        raise exception 'الكمية لـ «%» لازم تكون رقم صحيح من 0', v_label;
      end if;
      v_vsku := nullif(trim(coalesce(v_v->>'sku', '')), '');
      if v_vsku is not null then
        if length(v_vsku) > 64 then
          raise exception 'الـ SKU لـ «%» طويل (لحد 64 حرف)', v_label;
        end if;
        if lower(v_vsku) = any(v_skus) or private.sku_taken(p_shop, v_vsku, v_id) then
          raise exception 'الـ SKU «%» مستخدم قبل كده', v_vsku;
        end if;
        v_skus := v_skus || lower(v_vsku);
      end if;
      if length(coalesce(v_v->>'barcode', '')) > 64 then
        raise exception 'الباركود لـ «%» طويل (لحد 64 حرف)', v_label;
      end if;
      v_vimg := nullif(trim(coalesce(v_v->>'image_url', '')), '');
      if v_vimg is not null and not (v_vimg = any(v_images)) then
        raise exception 'صورة «%» لازم تكون من صور المنتج', v_label;
      end if;
    end loop;
  end if;

  if v_id is null then
    if (select count(*) from public.shop_products where shop_id = p_shop) >= 5000 then
      raise exception 'وصلت للحد الأقصى (5,000 منتج للمتجر)';
    end if;
    insert into public.shop_products (shop_id, name, price, old_price, stock, description, images, image_url, highlights, category, options,
                                      status, is_available, sku, barcode, tags, slug, seo_title, seo_description, video_url)
    values (p_shop, v_name, coalesce(v_price, 0), v_old_price, v_stock::int, v_desc, v_images, v_images[1], v_highlights, v_category, v_options,
            v_status, v_status = 'active', v_sku, v_barcode, v_tags, v_slug, v_seo_title, v_seo_desc, v_video)
    returning id into v_id;
  else
    if not v_has then
      -- Back to a single product: its variants go (orders keep their snapshot).
      delete from public.shop_product_variants where product_id = v_id;
    end if;
    update public.shop_products set
      name = v_name, description = v_desc, images = v_images, image_url = v_images[1], highlights = v_highlights,
      category = v_category, options = v_options, status = v_status, is_available = v_status = 'active',
      sku = v_sku, barcode = v_barcode, tags = v_tags, slug = coalesce(v_slug, slug),
      seo_title = v_seo_title, seo_description = v_seo_desc, video_url = v_video,
      price = case when v_has then price else v_price end,
      old_price = case when v_has then old_price else v_old_price end,
      stock = case when v_has then stock else v_stock::int end
    where id = v_id;
  end if;

  if v_has then
    -- A variant is its combination: combinations that are gone are
    -- deleted, the others updated in place (ids kept), new ones added.
    delete from public.shop_product_variants where product_id = v_id and not (option_values::text = any(v_combos));
    update public.shop_product_variants set sku = null where product_id = v_id and sku is not null;
    for v_v in select * from jsonb_array_elements(p_variants) loop
      select coalesce(jsonb_agg(trim(x) order by i), '[]'::jsonb) into v_vals
        from jsonb_array_elements_text(v_v->'option_values') with ordinality t(x, i);
      insert into public.shop_product_variants (product_id, shop_id, option_values, sku, barcode, price, compare_at_price, stock, image_url, position, is_available)
      values (v_id, p_shop, v_vals, nullif(trim(coalesce(v_v->>'sku', '')), ''), nullif(trim(coalesce(v_v->>'barcode', '')), ''),
              private.loose_num(v_v->>'price'), private.loose_num(v_v->>'compare_at_price'), private.loose_num(v_v->>'stock')::int,
              nullif(trim(coalesce(v_v->>'image_url', '')), ''), v_pos, coalesce((v_v->>'is_available')::boolean, true))
      on conflict (product_id, option_values) do update set
        sku = excluded.sku, barcode = excluded.barcode, price = excluded.price, compare_at_price = excluded.compare_at_price,
        stock = excluded.stock, image_url = excluded.image_url, position = excluded.position, is_available = excluded.is_available;
      v_pos := v_pos + 1;
    end loop;
    perform private.catalog_rollup(v_id);
  end if;

  if p_collections is not null then
    delete from public.shop_collection_products cp using public.shop_collections c
     where cp.collection_id = c.id and c.shop_id = p_shop and cp.product_id = v_id and not (c.id = any(p_collections));
    insert into public.shop_collection_products (collection_id, product_id, position)
    select c.id, v_id, coalesce((select max(position) + 1 from public.shop_collection_products where collection_id = c.id), 0)
      from public.shop_collections c
     where c.shop_id = p_shop and c.id = any(p_collections) and c.rules is null
    on conflict do nothing;
  end if;
  return v_id;
end;
$$;

-- The editor's save. Returns the product id.
create or replace function public.merchant_save_product(p_shop uuid, p_product jsonb, p_variants jsonb default '[]'::jsonb, p_collections uuid[] default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if p_product is null or jsonb_typeof(p_product) <> 'object' then
    raise exception 'بيانات المنتج ناقصة';
  end if;
  return private.catalog_save(p_shop, p_product, coalesce(p_variants, '[]'::jsonb), p_collections);
end;
$$;
revoke execute on function public.merchant_save_product(uuid, jsonb, jsonb, uuid[]) from public, anon;
grant execute on function public.merchant_save_product(uuid, jsonb, jsonb, uuid[]) to authenticated;

create or replace function private.product_json(p public.shop_products, p_public boolean) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select to_jsonb(p) || jsonb_build_object(
    'variants', coalesce((select jsonb_agg(to_jsonb(v) - 'shop_id' order by v.position, v.created_at)
                            from public.shop_product_variants v
                           where v.product_id = p.id and (not p_public or v.is_available)), '[]'::jsonb));
$$;

-- One product for the editor: with its variants and manual collections.
create or replace function public.merchant_product(p_product uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v public.shop_products;
begin
  select p.* into v from public.shop_products p where p.id = p_product;
  if not found or not public.i_own_shop(v.shop_id) then
    return null;
  end if;
  return private.product_json(v, false) || jsonb_build_object(
    'collection_ids', coalesce((select jsonb_agg(cp.collection_id) from public.shop_collection_products cp where cp.product_id = p_product), '[]'::jsonb));
end;
$$;
revoke execute on function public.merchant_product(uuid) from public, anon;
grant execute on function public.merchant_product(uuid) to authenticated;

-- The whole catalogue for the admin: every product (any status) with its
-- variants, every collection with its products, the low-stock threshold.
create or replace function public.merchant_catalog(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'products', coalesce((select jsonb_agg(private.product_json(p, false) order by p.position nulls last, p.created_at desc)
                            from public.shop_products p where p.shop_id = p_shop), '[]'::jsonb),
    'collections', coalesce((select jsonb_agg(private.collection_json(c, false) order by c.position, c.created_at)
                               from public.shop_collections c where c.shop_id = p_shop), '[]'::jsonb),
    'low_stock_threshold', (select low_stock_threshold from public.shops where id = p_shop));
end;
$$;
revoke execute on function public.merchant_catalog(uuid) from public, anon;
grant execute on function public.merchant_catalog(uuid) to authenticated;

-- The storefront: visible products (with their available variants) in
-- the merchant's order, and the visible collections that have any.
create or replace function public.store_catalog(p_shop uuid) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object(
    'products', coalesce((select jsonb_agg(private.product_json(p, true) order by p.position nulls last, p.created_at desc)
                            from (select * from public.shop_products where shop_id = p_shop and is_available
                                   order by position nulls last, created_at desc limit 2000) p), '[]'::jsonb),
    'collections', coalesce((select jsonb_agg(j order by pos, created_at)
                               from (select private.collection_json(c, true) as j, c.position as pos, c.created_at
                                       from public.shop_collections c where c.shop_id = p_shop and c.is_visible) s
                              where jsonb_array_length(j->'product_ids') > 0), '[]'::jsonb));
$$;
revoke execute on function public.store_catalog(uuid) from public;
grant execute on function public.store_catalog(uuid) to anon, authenticated;

-- ============================================================ duplicate / reorder / bulk

create or replace function public.merchant_duplicate_product(p_product uuid) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v public.shop_products;
  v_new uuid;
begin
  select p.* into v from public.shop_products p where p.id = p_product;
  if not found or not public.i_own_shop(v.shop_id) then
    raise exception 'المنتج ده مش بتاعك';
  end if;
  if (select count(*) from public.shop_products where shop_id = v.shop_id) >= 5000 then
    raise exception 'وصلت للحد الأقصى (5,000 منتج للمتجر)';
  end if;
  insert into public.shop_products (shop_id, name, price, old_price, stock, description, images, image_url, highlights, category, options,
                                    status, is_available, tags, seo_title, seo_description, video_url, position)
  values (v.shop_id, left(v.name, 111) || ' (نسخة)', v.price, v.old_price, v.stock, v.description, v.images, v.image_url, v.highlights,
          v.category, v.options, 'draft', false, v.tags, v.seo_title, v.seo_description, v.video_url, v.position)
  returning id into v_new;
  -- SKUs / barcodes are not copied (they're unique).
  insert into public.shop_product_variants (product_id, shop_id, option_values, price, compare_at_price, stock, image_url, position, is_available)
  select v_new, shop_id, option_values, price, compare_at_price, stock, image_url, position, is_available
    from public.shop_product_variants where product_id = p_product;
  insert into public.shop_collection_products (collection_id, product_id, position)
  select collection_id, v_new, position from public.shop_collection_products where product_id = p_product;
  return v_new;
end;
$$;
revoke execute on function public.merchant_duplicate_product(uuid) from public, anon;
grant execute on function public.merchant_duplicate_product(uuid) to authenticated;

-- The manual product order: p_ids in the new order (0, 1, 2…).
create or replace function public.merchant_reorder_products(p_shop uuid, p_ids uuid[]) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if cardinality(p_ids) > 5000 then
    raise exception 'منتجات كتير';
  end if;
  update public.shop_products p set position = o.i - 1
    from unnest(p_ids) with ordinality o(id, i)
   where p.id = o.id and p.shop_id = p_shop and p.position is distinct from (o.i - 1)::int;
end;
$$;
revoke execute on function public.merchant_reorder_products(uuid, uuid[]) from public, anon;
grant execute on function public.merchant_reorder_products(uuid, uuid[]) to authenticated;

-- Bulk actions on selected products. p_action: status (p_value
-- 'active'|'draft'|'archived'), add_collection / remove_collection
-- (p_value: the collection id), price / stock (products with a single
-- variant only — the others are skipped), delete (products with orders
-- are archived instead). Returns {updated, skipped, deleted, archived}.
create or replace function public.merchant_bulk_products(p_shop uuid, p_ids uuid[], p_action text, p_value jsonb default null) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_ids uuid[];
  v_updated int := 0;
  v_skipped int := 0;
  v_deleted int := 0;
  v_archived int := 0;
  v_text text := p_value #>> '{}';
  v_num numeric;
  v_coll uuid;
  r record;
  v_vid uuid;
  v_nv int;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if p_ids is null or cardinality(p_ids) = 0 then
    raise exception 'اختار منتجات الأول';
  end if;
  if cardinality(p_ids) > 500 then
    raise exception 'لحد 500 منتج في المرة';
  end if;
  select coalesce(array_agg(id), '{}') into v_ids from public.shop_products where shop_id = p_shop and id = any(p_ids);
  v_skipped := cardinality(p_ids) - cardinality(v_ids);

  if p_action = 'status' then
    if coalesce(v_text, '') not in ('active', 'draft', 'archived') then
      raise exception 'حالة المنتج غير معروفة';
    end if;
    update public.shop_products set status = v_text, is_available = v_text = 'active' where id = any(v_ids) and status <> v_text;
    get diagnostics v_updated = row_count;
  elsif p_action in ('add_collection', 'remove_collection') then
    v_coll := v_text::uuid;
    if not exists (select 1 from public.shop_collections where id = v_coll and shop_id = p_shop and rules is null) then
      raise exception 'القسم ده مش موجود (أو قسم ذكي بيتملا لوحده)';
    end if;
    if p_action = 'add_collection' then
      insert into public.shop_collection_products (collection_id, product_id, position)
      select v_coll, u.id, coalesce((select max(position) from public.shop_collection_products where collection_id = v_coll), -1) + u.i::int
        from unnest(v_ids) with ordinality u(id, i)
      on conflict do nothing;
    else
      delete from public.shop_collection_products where collection_id = v_coll and product_id = any(v_ids);
    end if;
    get diagnostics v_updated = row_count;
  elsif p_action in ('price', 'stock') then
    begin
      v_num := private.loose_num(v_text);
    exception when invalid_text_representation then
      raise exception 'اكتب رقم صحيح';
    end;
    if p_action = 'price' and (v_num is null or v_num < 0 or v_num > 1000000) then
      raise exception 'اكتب سعر صحيح';
    end if;
    if p_action = 'price' and round(v_num, public.currency_decimals((select currency from public.shops where id = p_shop))) <> v_num then
      raise exception 'السعر فيه أرقام بعد العلامة أكتر من عملة متجرك';
    end if;
    if p_action = 'stock' and v_num is not null and (v_num < 0 or v_num > 1000000 or v_num <> trunc(v_num)) then
      raise exception 'الكمية لازم تكون رقم صحيح من 0';
    end if;
    for r in select id from public.shop_products where id = any(v_ids) loop
      select count(*), min(id::text)::uuid into v_nv, v_vid from public.shop_product_variants where product_id = r.id;
      if v_nv > 1 then
        v_skipped := v_skipped + 1;
      elsif v_nv = 1 then
        if p_action = 'price' then
          update public.shop_product_variants set price = v_num,
                 compare_at_price = case when compare_at_price > v_num then compare_at_price end where id = v_vid;
        else
          update public.shop_product_variants set stock = v_num::int where id = v_vid;
        end if;
        v_updated := v_updated + 1;
      else
        if p_action = 'price' then
          update public.shop_products set price = v_num, old_price = case when old_price > v_num then old_price end where id = r.id;
        else
          update public.shop_products set stock = v_num::int where id = r.id;
        end if;
        v_updated := v_updated + 1;
      end if;
    end loop;
  elsif p_action = 'delete' then
    for r in select id from public.shop_products where id = any(v_ids) loop
      if exists (select 1 from public.shop_order_items where product_id = r.id) then
        update public.shop_products set status = 'archived', is_available = false where id = r.id and status <> 'archived';
        v_archived := v_archived + 1;
      else
        delete from public.shop_products where id = r.id;
        v_deleted := v_deleted + 1;
      end if;
    end loop;
  else
    raise exception 'إجراء غير معروف';
  end if;
  return jsonb_build_object('updated', v_updated, 'skipped', v_skipped, 'deleted', v_deleted, 'archived', v_archived);
end;
$$;
revoke execute on function public.merchant_bulk_products(uuid, uuid[], text, jsonb) from public, anon;
grant execute on function public.merchant_bulk_products(uuid, uuid[], text, jsonb) to authenticated;

-- ============================================================ collections (writes)

-- Create / edit a collection: {id?, name, slug?, description, image_url,
-- is_visible, rules (null = manual)}. Returns its id.
create or replace function public.merchant_save_collection(p_shop uuid, p_collection jsonb) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid := nullif(p_collection->>'id', '')::uuid;
  v_name text := left(trim(coalesce(p_collection->>'name', '')), 80);
  v_slug text := nullif(trim(coalesce(p_collection->>'slug', '')), '');
  v_desc text := nullif(left(trim(coalesce(p_collection->>'description', '')), 1000), '');
  v_img text := nullif(trim(coalesce(p_collection->>'image_url', '')), '');
  v_visible boolean := coalesce((p_collection->>'is_visible')::boolean, true);
  v_rules jsonb := case when jsonb_typeof(p_collection->'rules') = 'object' then p_collection->'rules' end;
  v_problem text;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if v_name = '' then
    raise exception 'اكتب اسم القسم';
  end if;
  if v_img is not null and v_img !~* '^https?://' then
    raise exception 'لينك الصورة مش صحيح';
  end if;
  if v_rules is not null then
    if v_rules ? 'tag' and jsonb_typeof(v_rules->'tag') = 'string' then
      v_rules := jsonb_set(v_rules, '{tag}', to_jsonb(trim(v_rules->>'tag')));
    end if;
    v_problem := public.collection_rules_problem(v_rules);
    if v_problem <> '' then
      raise exception '%', v_problem;
    end if;
  end if;
  if v_id is not null then
    if not exists (select 1 from public.shop_collections where id = v_id and shop_id = p_shop) then
      raise exception 'القسم ده مش موجود';
    end if;
  elsif (select count(*) from public.shop_collections where shop_id = p_shop) >= 200 then
    raise exception 'وصلت للحد الأقصى (200 قسم)';
  end if;
  if v_slug is not null then
    v_slug := public.catalog_slugify(v_slug);
    if exists (select 1 from public.shop_collections where shop_id = p_shop and slug = v_slug and id is distinct from v_id) then
      raise exception 'الرابط «%» مستخدم لقسم تاني', v_slug;
    end if;
  end if;
  if v_id is null then
    insert into public.shop_collections (shop_id, name, slug, description, image_url, is_visible, rules, position)
    values (p_shop, v_name, coalesce(v_slug, private.unique_collection_slug(p_shop, v_name, null)), v_desc, v_img, v_visible, v_rules,
            coalesce((select max(position) + 1 from public.shop_collections where shop_id = p_shop), 0))
    returning id into v_id;
  else
    update public.shop_collections set name = v_name, slug = coalesce(v_slug, slug), description = v_desc, image_url = v_img,
           is_visible = v_visible, rules = v_rules
     where id = v_id;
    if v_rules is not null then
      delete from public.shop_collection_products where collection_id = v_id;
    end if;
  end if;
  return v_id;
end;
$$;
revoke execute on function public.merchant_save_collection(uuid, jsonb) from public, anon;
grant execute on function public.merchant_save_collection(uuid, jsonb) to authenticated;

create or replace function public.merchant_delete_collection(p_collection uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.shop_collections c where c.id = p_collection and public.i_own_shop(c.shop_id);
  if not found then
    raise exception 'القسم ده مش موجود';
  end if;
end;
$$;
revoke execute on function public.merchant_delete_collection(uuid) from public, anon;
grant execute on function public.merchant_delete_collection(uuid) to authenticated;

-- A manual collection's products, in order (drag to reorder, add, remove).
create or replace function public.merchant_set_collection_products(p_collection uuid, p_product_ids uuid[]) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.shop_collections;
begin
  select * into c from public.shop_collections where id = p_collection;
  if not found or not public.i_own_shop(c.shop_id) then
    raise exception 'القسم ده مش موجود';
  end if;
  if c.rules is not null then
    raise exception 'القسم الذكي بيتملا لوحده من الشروط';
  end if;
  if cardinality(coalesce(p_product_ids, '{}')) > 5000 then
    raise exception 'منتجات كتير';
  end if;
  delete from public.shop_collection_products where collection_id = p_collection and not (product_id = any(coalesce(p_product_ids, '{}')));
  insert into public.shop_collection_products (collection_id, product_id, position)
  select p_collection, o.id, min(o.i)::int - 1
    from unnest(coalesce(p_product_ids, '{}')) with ordinality o(id, i)
    join public.shop_products p on p.id = o.id and p.shop_id = c.shop_id
   group by o.id
  on conflict (collection_id, product_id) do update set position = excluded.position;
end;
$$;
revoke execute on function public.merchant_set_collection_products(uuid, uuid[]) from public, anon;
grant execute on function public.merchant_set_collection_products(uuid, uuid[]) to authenticated;

create or replace function public.merchant_reorder_collections(p_shop uuid, p_ids uuid[]) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  update public.shop_collections c set position = o.i - 1
    from unnest(p_ids) with ordinality o(id, i)
   where c.id = o.id and c.shop_id = p_shop;
end;
$$;
revoke execute on function public.merchant_reorder_collections(uuid, uuid[]) from public, anon;
grant execute on function public.merchant_reorder_collections(uuid, uuid[]) to authenticated;

-- ============================================================ low stock (admin)

-- «منتجات قربت تخلص»: variants / products at or below the threshold.
create or replace function public.merchant_low_stock(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_thr int;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  select low_stock_threshold into v_thr from public.shops where id = p_shop;
  return jsonb_build_object('threshold', v_thr, 'items', coalesce((
    select jsonb_agg(x order by (x->>'stock')::int, x->>'name') from (
      select jsonb_build_object('product_id', p.id, 'variant_id', v.id, 'name', p.name,
                                'variant_label', public.catalog_variant_label(p.options, v.option_values),
                                'sku', v.sku, 'stock', v.stock, 'image_url', coalesce(v.image_url, p.images[1], p.image_url)) as x
        from public.shop_product_variants v join public.shop_products p on p.id = v.product_id
       where v.shop_id = p_shop and p.status <> 'archived' and v.is_available and v.stock is not null and v.stock <= v_thr
      union all
      select jsonb_build_object('product_id', p.id, 'variant_id', null, 'name', p.name, 'variant_label', null,
                                'sku', p.sku, 'stock', p.stock, 'image_url', coalesce(p.images[1], p.image_url))
        from public.shop_products p
       where p.shop_id = p_shop and p.status <> 'archived' and p.stock is not null and p.stock <= v_thr
         and not exists (select 1 from public.shop_product_variants v where v.product_id = p.id)
      limit 50) s), '[]'::jsonb));
end;
$$;
revoke execute on function public.merchant_low_stock(uuid) from public, anon;
grant execute on function public.merchant_low_stock(uuid) to authenticated;

create or replace function public.merchant_set_low_stock_threshold(p_shop uuid, p_threshold int) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if p_threshold is null or p_threshold < 0 or p_threshold > 1000 then
    raise exception 'الحد لازم يكون من 0 لـ 1,000';
  end if;
  update public.shops set low_stock_threshold = p_threshold where id = p_shop;
end;
$$;
revoke execute on function public.merchant_set_low_stock_threshold(uuid, int) from public, anon;
grant execute on function public.merchant_set_low_stock_threshold(uuid, int) to authenticated;

-- ============================================================ CSV import

-- The product a CSV row belongs to: its handle, else its title's, else
-- the product that already has its SKU ('' when none of these).
create or replace function private.import_handle(p_shop uuid, r jsonb) returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    case when nullif(trim(coalesce(r->>'handle', '')), '') is not null then public.catalog_slugify(r->>'handle') end,
    case when nullif(trim(coalesce(r->>'title', '')), '') is not null then public.catalog_slugify(r->>'title') end,
    (select p.slug from public.shop_products p
      where p.shop_id = p_shop and nullif(trim(coalesce(r->>'sku', '')), '') is not null
        and (lower(p.sku) = lower(trim(r->>'sku'))
             or exists (select 1 from public.shop_product_variants v where v.product_id = p.id and lower(v.sku) = lower(trim(r->>'sku'))))
      limit 1),
    '');
$$;

create or replace function private.import_text(p text) returns text
language sql
immutable
as $$
  select left(btrim(replace(replace(replace(replace(replace(replace(
           regexp_replace(regexp_replace(coalesce(p, ''), '<\s*(br|/p|/div|/li)\s*/?>', E'\n', 'gi'), '<[^>]*>', '', 'g'),
           '&nbsp;', ' '), '&quot;', '"'), '&#39;', ''''), '&lt;', '<'), '&gt;', '>'), '&amp;', '&'), E' \n\r\t'), 2000);
$$;

create or replace function private.import_list(p text) returns text[]
language sql
immutable
as $$
  select coalesce(array_agg(x order by i), '{}')
    from (select trim(x) as x, min(i) as i from regexp_split_to_table(coalesce(p, ''), '[,،]') with ordinality t(x, i)
           where trim(x) <> '' group by trim(x)) s;
$$;

-- One product of the file (its rows, in file order). Returns
-- {row, handle, title, action: create|update, variants, id}.
create or replace function private.catalog_import_product(p_shop uuid, p_handle text, p_rows jsonb) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_first int := (p_rows->0->>'_row')::int;
  v_old public.shop_products;
  v_found boolean := false;
  r jsonb;
  v_n int;
  v_title text;
  v_desc text;
  v_status text;
  v_tags text;
  v_colls text;
  v_seo_title text;
  v_seo_desc text;
  v_video text;
  v_names text[] := array[null, null, null]::text[];
  v_images text[] := '{}';
  v_img text;
  v_k int;
  v_nopts int := 0;
  v_options jsonb := '[]'::jsonb;
  v_vals jsonb;
  v_variants jsonb := '[]'::jsonb;
  v_single jsonb;
  v_price numeric;
  v_cmp numeric;
  v_stock numeric;
  v_ex_price numeric;
  v_ex_stock int;
  v_ex_img text;
  v_ex_sku text;
  v_ex_barcode text;
  v_coll_ids uuid[];
  v_cname text;
  v_cid uuid;
  v_p jsonb;
  v_id uuid;
  v_sku text;
begin
  if p_handle = '' then
    raise exception 'سطر %: اكتب الـ handle أو اسم المنتج (Title)', v_first;
  end if;
  -- The Currency column (export) is the store's — informative, but a
  -- file priced in another currency is refused rather than misread.
  for r in select * from jsonb_array_elements(p_rows) loop
    if nullif(trim(coalesce(r->>'currency', '')), '') is not null
       and upper(trim(r->>'currency')) <> upper(coalesce((select currency from public.shops where id = p_shop), 'EGP')) then
      raise exception 'سطر %: العملة «%» مش عملة متجرك (%) — الأسعار لازم تكون بعملة المتجر', (r->>'_row')::int, upper(trim(r->>'currency')),
        coalesce((select currency from public.shops where id = p_shop), 'EGP');
    end if;
  end loop;
  select * into v_old from public.shop_products where shop_id = p_shop and slug = p_handle;
  v_found := found;
  if not v_found then
    for r in select * from jsonb_array_elements(p_rows) loop
      v_sku := nullif(trim(coalesce(r->>'sku', '')), '');
      continue when v_sku is null;
      select p.* into v_old from public.shop_products p
       where p.shop_id = p_shop and (lower(p.sku) = lower(v_sku)
             or exists (select 1 from public.shop_product_variants v where v.product_id = p.id and lower(v.sku) = lower(v_sku)))
       limit 1;
      v_found := found;
      exit when v_found;
    end loop;
  end if;

  -- Product-level fields: the first row that has each.
  for r in select * from jsonb_array_elements(p_rows) loop
    v_title := coalesce(v_title, nullif(left(trim(coalesce(r->>'title', '')), 120), ''));
    v_desc := coalesce(v_desc, nullif(private.import_text(r->>'description'), ''));
    v_status := coalesce(v_status, nullif(lower(trim(coalesce(r->>'status', ''))), ''));
    v_tags := coalesce(v_tags, nullif(trim(coalesce(r->>'tags', '')), ''));
    v_colls := coalesce(v_colls, nullif(trim(coalesce(r->>'collection', '')), ''));
    v_seo_title := coalesce(v_seo_title, nullif(trim(coalesce(r->>'seo_title', '')), ''));
    v_seo_desc := coalesce(v_seo_desc, nullif(trim(coalesce(r->>'seo_description', '')), ''));
    v_video := coalesce(v_video, nullif(trim(coalesce(r->>'video_url', '')), ''));
    for v_k in 1 .. 3 loop
      v_names[v_k] := coalesce(v_names[v_k], nullif(left(trim(coalesce(r->>('option' || v_k || '_name'), '')), 30), ''));
    end loop;
    for v_img in select trim(x) from regexp_split_to_table(concat_ws(' ', r->>'image_src', r->>'image_urls', r->>'variant_image'), '[\s|,]+') x loop
      continue when v_img = '' or v_img = any(v_images);
      if v_img !~* '^https?://' then
        raise exception 'سطر %: لينك الصورة «%» مش صحيح', (r->>'_row')::int, left(v_img, 60);
      end if;
      if cardinality(v_images) >= 6 then
        raise exception 'سطر %: لحد 6 صور للمنتج', (r->>'_row')::int;
      end if;
      v_images := v_images || v_img;
    end loop;
  end loop;
  if v_title is null and not v_found then
    raise exception 'سطر %: اكتب اسم المنتج (Title)', v_first;
  end if;
  v_status := case
    when v_status is null then coalesce(v_old.status, 'active')
    when v_status in ('active', 'نشط', 'true', 'yes') then 'active'
    when v_status in ('draft', 'مسودة', 'false', 'no') then 'draft'
    when v_status in ('archived', 'مؤرشف') then 'archived'
    else null end;
  if v_status is null then
    raise exception 'سطر %: الحالة لازم تكون active أو draft أو archived', v_first;
  end if;
  -- Shopify's single-variant convention.
  if lower(coalesce(v_names[1], '')) = 'title' and v_names[2] is null
     and not exists (select 1 from jsonb_array_elements(p_rows) x where coalesce(x->>'option1_value', '') not in ('', 'Default Title')) then
    v_names[1] := null;
  end if;
  for v_k in 1 .. 3 loop
    exit when v_names[v_k] is null;
    v_nopts := v_k;
  end loop;

  if v_nopts = 0 and v_found and exists (select 1 from public.shop_product_variants where product_id = v_old.id) then
    raise exception 'سطر %: «%» ليه أنواع — اكتب أعمدة الخيارات (Option1 Name / Option1 Value…)', v_first, v_old.name;
  end if;

  if v_nopts > 0 then
    for v_k in 1 .. v_nopts loop
      select coalesce(jsonb_agg(v order by i), '[]'::jsonb) into v_vals
        from (select left(trim(x->>('option' || v_k || '_value')), 40) as v, min(i) as i
                from jsonb_array_elements(p_rows) with ordinality t(x, i)
               where trim(coalesce(x->>('option' || v_k || '_value'), '')) <> '' group by 1) s;
      v_options := v_options || jsonb_build_array(jsonb_build_object('name', v_names[v_k], 'values', v_vals));
    end loop;
    for r in select * from jsonb_array_elements(p_rows) loop
      v_n := (r->>'_row')::int;
      select coalesce(jsonb_agg(left(trim(coalesce(r->>('option' || k || '_value'), '')), 40) order by k), '[]'::jsonb) into v_vals
        from generate_series(1, v_nopts) k;
      continue when not exists (select 1 from jsonb_array_elements_text(v_vals) e where e <> '');
      for v_k in 0 .. v_nopts - 1 loop
        if v_vals->>v_k = '' then
          raise exception 'سطر %: ناقص قيمة «%»', v_n, v_names[v_k + 1];
        end if;
      end loop;
      begin
        v_price := private.loose_num(r->>'price');
        v_cmp := private.loose_num(r->>'compare_at');
        v_stock := private.loose_num(r->>'stock');
      exception when invalid_text_representation then
        raise exception 'سطر %: السعر أو الكمية مش رقم', v_n;
      end;
      v_ex_price := null;
      v_ex_stock := null;
      v_ex_img := null;
      v_ex_sku := null;
      v_ex_barcode := null;
      if v_found then
        select price, stock, image_url, sku, barcode into v_ex_price, v_ex_stock, v_ex_img, v_ex_sku, v_ex_barcode
          from public.shop_product_variants where product_id = v_old.id and option_values = v_vals;
      end if;
      if v_price is null then
        v_price := v_ex_price;
        if v_price is null then
          raise exception 'سطر %: اكتب السعر (Variant Price)', v_n;
        end if;
      end if;
      if v_cmp is not null and v_cmp <= v_price then
        v_cmp := null;
      end if;
      if v_stock is null and nullif(trim(coalesce(r->>'stock', '')), '') is null then
        v_stock := v_ex_stock;
      end if;
      v_variants := v_variants || jsonb_build_array(jsonb_build_object(
        'option_values', v_vals,
        'sku', coalesce(nullif(trim(coalesce(r->>'sku', '')), ''), v_ex_sku),
        'barcode', coalesce(nullif(trim(coalesce(r->>'barcode', '')), ''), v_ex_barcode),
        'price', v_price, 'compare_at_price', v_cmp, 'stock', v_stock,
        'image_url', coalesce(nullif(trim(coalesce(r->>'variant_image', '')), ''),
                              case when v_ex_img = any(case when cardinality(v_images) > 0 then v_images else v_old.images end) then v_ex_img end),
        'is_available', true));
    end loop;
    if jsonb_array_length(v_variants) = 0 then
      raise exception 'سطر %: المنتج ليه خيارات من غير أي قيم', v_first;
    end if;
  else
    v_single := p_rows->0;
    begin
      v_price := private.loose_num(v_single->>'price');
      v_cmp := private.loose_num(v_single->>'compare_at');
      v_stock := private.loose_num(v_single->>'stock');
    exception when invalid_text_representation then
      raise exception 'سطر %: السعر أو الكمية مش رقم', v_first;
    end;
    v_price := coalesce(v_price, v_old.price);
    if v_price is null then
      raise exception 'سطر %: اكتب السعر (Variant Price)', v_first;
    end if;
    if v_cmp is not null and v_cmp <= v_price then
      v_cmp := null;
    end if;
    if v_stock is null and nullif(trim(coalesce(v_single->>'stock', '')), '') is null and v_found then
      v_stock := v_old.stock;
    end if;
  end if;

  if v_colls is not null then
    v_coll_ids := '{}';
    foreach v_cname in array private.import_list(v_colls) loop
      v_cname := left(v_cname, 80);
      select id into v_cid from public.shop_collections where shop_id = p_shop and lower(name) = lower(v_cname) and rules is null limit 1;
      if not found then
        if (select count(*) from public.shop_collections where shop_id = p_shop) >= 200 then
          raise exception 'سطر %: وصلت للحد الأقصى (200 قسم)', v_first;
        end if;
        insert into public.shop_collections (shop_id, name, slug, position)
        values (p_shop, v_cname, private.unique_collection_slug(p_shop, v_cname, null),
                coalesce((select max(position) + 1 from public.shop_collections where shop_id = p_shop), 0))
        returning id into v_cid;
      end if;
      v_coll_ids := v_coll_ids || v_cid;
    end loop;
  elsif not v_found then
    v_coll_ids := '{}';
  end if;

  v_p := jsonb_build_object(
    'id', v_old.id,
    'name', coalesce(v_title, v_old.name),
    'description', coalesce(v_desc, v_old.description),
    'images', to_jsonb(case when cardinality(v_images) > 0 then v_images else coalesce(v_old.images, '{}') end),
    'highlights', to_jsonb(coalesce(v_old.highlights, '{}')),
    'category', coalesce((select name from public.shop_collections where id = v_coll_ids[1]), v_old.category),
    'options', v_options,
    'status', v_status,
    'tags', to_jsonb(case when v_tags is not null then private.import_list(v_tags) else coalesce(v_old.tags, '{}') end),
    'slug', case when v_found then v_old.slug else p_handle end,
    'seo_title', coalesce(v_seo_title, v_old.seo_title),
    'seo_description', coalesce(v_seo_desc, v_old.seo_description),
    'video_url', coalesce(v_video, v_old.video_url),
    'price', v_price, 'old_price', v_cmp, 'stock', v_stock,
    'sku', case when v_nopts = 0 then coalesce(nullif(trim(coalesce(v_single->>'sku', '')), ''), v_old.sku) end,
    'barcode', case when v_nopts = 0 then coalesce(nullif(trim(coalesce(v_single->>'barcode', '')), ''), v_old.barcode) end);
  begin
    v_id := private.catalog_save(p_shop, v_p, v_variants, v_coll_ids);
  exception when raise_exception or check_violation or unique_violation then
    raise exception 'سطر %: %', v_first, sqlerrm;
  end;
  return jsonb_build_object('row', v_first, 'handle', p_handle, 'title', coalesce(v_title, v_old.name),
                            'action', case when v_found then 'update' else 'create' end,
                            'variants', jsonb_array_length(v_variants), 'id', v_id);
end;
$$;

create or replace function private.catalog_import(p_shop uuid, p_rows jsonb) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  g record;
  v_res jsonb;
  v_created int := 0;
  v_updated int := 0;
  v_failed int := 0;
  v_errors jsonb := '[]'::jsonb;
  v_items jsonb := '[]'::jsonb;
begin
  for g in
    with r as (
      select case when jsonb_typeof(x) = 'object' then x else '{}'::jsonb end
               || jsonb_build_object('_row', coalesce(case when (x->>'_row') ~ '^[0-9]{1,7}$' then (x->>'_row')::int end, (i + 1)::int)) as row,
             i
        from jsonb_array_elements(p_rows) with ordinality t(x, i)
    )
    select private.import_handle(p_shop, r.row) as handle, jsonb_agg(r.row order by r.i) as rows, min(r.i) as first
      from r group by 1 order by 3
  loop
    begin
      if jsonb_array_length(g.rows) > 100 then
        raise exception 'سطر %: لحد 100 نوع للمنتج الواحد', (g.rows->0->>'_row')::int;
      end if;
      v_res := private.catalog_import_product(p_shop, g.handle, g.rows);
      if v_res->>'action' = 'create' then
        v_created := v_created + 1;
      else
        v_updated := v_updated + 1;
      end if;
      if jsonb_array_length(v_items) < 500 then
        v_items := v_items || jsonb_build_array(v_res);
      end if;
    exception when others then
      v_failed := v_failed + 1;
      if jsonb_array_length(v_errors) < 200 then
        v_errors := v_errors || jsonb_build_array(jsonb_build_object('row', (g.rows->0->>'_row')::int, 'handle', g.handle, 'message', sqlerrm));
      end if;
    end;
  end loop;
  return jsonb_build_object('created', v_created, 'updated', v_updated, 'failed', v_failed, 'errors', v_errors, 'items', v_items);
end;
$$;

-- p_rows: the parsed CSV rows (≤ 500 per call; the app sends batches
-- that never split a product), keys: handle, title, description,
-- option1_name, option1_value … option3_value, sku, barcode, price,
-- compare_at, stock, status, collection, tags, image_src, image_urls,
-- variant_image, seo_title, seo_description, video_url, currency (must
-- be the store's when given), _row (the file
-- line, for the error report). p_dry_run: validate and report only —
-- the very same work is done and then rolled back, so the preview is
-- exactly what an import does.
create or replace function public.merchant_import_products(p_shop uuid, p_rows jsonb, p_dry_run boolean default true) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_result jsonb;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if p_rows is null or jsonb_typeof(p_rows) <> 'array' or jsonb_array_length(p_rows) = 0 then
    raise exception 'الملف فاضي';
  end if;
  if jsonb_array_length(p_rows) > 500 then
    raise exception 'الدفعة الواحدة لحد 500 سطر';
  end if;
  if (select count(*) from private.integration_hits where shop_id = p_shop and kind = 'catalog_import' and at > now() - interval '1 hour') >= 120 then
    raise exception 'استوردت كتير في ساعة — استنى شوية وجرّب تاني';
  end if;
  insert into private.integration_hits (shop_id, kind) values (p_shop, 'catalog_import');
  begin
    v_result := private.catalog_import(p_shop, p_rows);
    if coalesce(p_dry_run, true) then
      raise exception 'dry run' using errcode = 'P0098';
    end if;
  exception when sqlstate 'P0098' then
    null;
  end;
  return v_result || jsonb_build_object('dry_run', coalesce(p_dry_run, true));
end;
$$;
revoke execute on function public.merchant_import_products(uuid, jsonb, boolean) from public, anon;
grant execute on function public.merchant_import_products(uuid, jsonb, boolean) to authenticated;

-- ============================================================ ordering

alter table public.shop_order_items add column if not exists variant_id uuid references public.shop_product_variants(id) on delete set null;
alter table public.shop_order_items add column if not exists sku text;
create index if not exists shop_order_items_variant_idx on public.shop_order_items (variant_id) where variant_id is not null;

-- One cart line → what gets ordered. Lines: {product_id, variant_id?,
-- quantity (or qty), options?}. With p_take_stock the variant's (or the
-- product's) stock is checked and taken under a row lock.
create or replace function private.store_line(p_shop uuid, p_item jsonb, p_take_stock boolean,
  out o_product_id uuid, out o_variant_id uuid, out o_quantity int, out o_unit_price numeric, out o_product_name text,
  out o_variant_label text, out o_sku text, out o_image_url text)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_product public.shop_products;
  v_variant public.shop_product_variants;
  v_vid uuid;
  v_opts text;
begin
  o_quantity := coalesce((p_item->>'quantity')::int, (p_item->>'qty')::int, 0);
  if o_quantity < 1 or o_quantity > 99 then
    raise exception 'الكمية غير صحيحة';
  end if;
  select * into v_product from public.shop_products
    where id = (p_item->>'product_id')::uuid and shop_id = p_shop and is_available;
  if not found then
    raise exception 'فيه منتج في السلة مبقاش متاح، حدّث الصفحة';
  end if;
  v_opts := nullif(left(trim(coalesce(p_item->>'options', '')), 120), '');
  v_vid := nullif(p_item->>'variant_id', '')::uuid;
  if v_vid is null and exists (select 1 from public.shop_product_variants where product_id = v_product.id) then
    -- An old client: its options text, else the only variant.
    select id into v_vid from public.shop_product_variants
     where product_id = v_product.id and is_available
       and public.catalog_variant_label(v_product.options, option_values) = v_opts
     limit 1;
    if v_vid is null and (select count(*) from public.shop_product_variants where product_id = v_product.id and is_available) = 1 then
      select id into v_vid from public.shop_product_variants where product_id = v_product.id and is_available;
    end if;
    if v_vid is null then
      raise exception 'اختار النوع (المقاس/اللون…) لـ «%» من صفحة المنتج', v_product.name;
    end if;
  end if;

  o_product_id := v_product.id;
  o_product_name := v_product.name;
  if v_vid is not null then
    select * into v_variant from public.shop_product_variants
      where id = v_vid and product_id = v_product.id and is_available
      for update;
    if not found then
      raise exception 'فيه نوع في السلة مبقاش متاح، حدّث الصفحة';
    end if;
    o_variant_label := public.catalog_variant_label(v_product.options, v_variant.option_values);
    if p_take_stock and v_variant.stock is not null then
      if v_variant.stock < o_quantity then
        raise exception 'الكمية المتاحة من «%» هي % بس', v_product.name || coalesce(' — ' || o_variant_label, ''), v_variant.stock;
      end if;
      update public.shop_product_variants set stock = stock - o_quantity where id = v_variant.id;
    end if;
    o_variant_id := v_variant.id;
    o_unit_price := v_variant.price;
    o_sku := v_variant.sku;
    o_image_url := coalesce(v_variant.image_url, v_product.images[1], v_product.image_url);
  else
    if p_take_stock then
      select * into v_product from public.shop_products where id = v_product.id for update;
      if v_product.stock is not null then
        if v_product.stock < o_quantity then
          raise exception 'الكمية المتاحة من «%» هي % بس', v_product.name, v_product.stock;
        end if;
        update public.shop_products set stock = stock - o_quantity where id = v_product.id;
      end if;
    end if;
    o_variant_label := v_opts;
    o_unit_price := v_product.price;
    o_sku := v_product.sku;
    o_image_url := coalesce(v_product.images[1], v_product.image_url);
  end if;
end;
$$;

-- 0096's in-app order + variants (price / snapshot of the variant).
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
  v_line record;
  v_total numeric(14,3) := 0;
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
    select * into v_line from private.store_line(p_shop_id, v_item, false);
    insert into public.shop_order_items (order_id, product_id, variant_id, quantity, unit_price, chosen_options, product_name, variant_label, sku, image_url)
    values (v_order_id, v_line.o_product_id, v_line.o_variant_id, v_line.o_quantity, v_line.o_unit_price, v_line.o_variant_label,
            v_line.o_product_name, v_line.o_variant_label, v_line.o_sku, v_line.o_image_url);
    v_total := v_total + v_line.o_unit_price * v_line.o_quantity;
    v_count := v_count + v_line.o_quantity;
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

-- 0096's store checkout + variants: stock per variant, line snapshots
-- with variant_id / variant_label / sku. Same signature as before.
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
  v_line record;
  v_total numeric(14,3) := 0;
  v_delivery numeric(14,3) := 0;
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
    select * into v_line from private.store_line(p_shop_id, v_item, true);
    insert into public.shop_order_items (order_id, product_id, variant_id, quantity, unit_price, chosen_options, product_name, variant_label, sku, image_url)
    values (v_order_id, v_line.o_product_id, v_line.o_variant_id, v_line.o_quantity, v_line.o_unit_price, v_line.o_variant_label,
            v_line.o_product_name, v_line.o_variant_label, v_line.o_sku, v_line.o_image_url);
    v_total := v_total + v_line.o_unit_price * v_line.o_quantity;
    v_count := v_count + v_line.o_quantity;
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

-- 0068's restock, per variant now (and once per product even when it
-- appears on several lines).
create or replace function public.shop_order_restock_on_cancel() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status = 'cancelled' and old.status is distinct from 'cancelled' then
    update public.shop_product_variants v
       set stock = v.stock + i.qty
      from (select variant_id, sum(quantity)::int as qty from public.shop_order_items
             where order_id = new.id and variant_id is not null group by variant_id) i
     where v.id = i.variant_id and v.stock is not null;
    update public.shop_products p
       set stock = p.stock + i.qty
      from (select product_id, sum(quantity)::int as qty from public.shop_order_items
             where order_id = new.id and variant_id is null group by product_id) i
     where i.product_id = p.id and p.stock is not null
       and not exists (select 1 from public.shop_product_variants v where v.product_id = p.id);
  end if;
  return new;
end;
$$;

-- 0096's order lines for the merchant + variant / SKU.
create or replace function private.order_lines_json(p_order uuid) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
           'product_id', i.product_id,
           'variant_id', i.variant_id,
           'product_name', coalesce(i.product_name, p.name),
           'variant_label', coalesce(i.variant_label, i.chosen_options),
           'sku', i.sku,
           'quantity', i.quantity,
           'unit_price', i.unit_price,
           'image_url', i.image_url) order by i.id), '[]'::jsonb)
    from public.shop_order_items i left join public.shop_products p on p.id = i.product_id
   where i.order_id = p_order;
$$;

-- ============================================================ one-time data migration

do $$
declare
  r record;
  v_opts jsonb;
  v_n int;
  v_i int;
  v_each int;
  v_rem int;
  v_vals jsonb;
  v_cid uuid;
begin
  if exists (select 1 from private.migration_marks where name = '0098_catalog') then
    return;
  end if;

  -- 1. The old option lists → variants.
  for r in select p.* from public.shop_products p
            where jsonb_typeof(p.options) = 'array' and jsonb_array_length(p.options) > 0
              and not exists (select 1 from public.shop_product_variants v where v.product_id = p.id)
            order by p.created_at loop
    begin
      v_opts := private.catalog_options(r.options);
    exception when others then
      continue; -- malformed options: the product stays as it was
    end;
    select count(*) into v_n from private.options_matrix(v_opts);
    continue when v_n = 0 or v_n > 100;
    update public.shop_products set options = v_opts where id = r.id and options is distinct from v_opts;
    v_each := case when r.stock is null then null else r.stock / v_n end;
    v_rem := case when r.stock is null then 0 else r.stock % v_n end;
    v_i := 0;
    for v_vals in select * from private.options_matrix(v_opts) loop
      insert into public.shop_product_variants (product_id, shop_id, option_values, price, compare_at_price, stock, position, is_available)
      values (r.id, r.shop_id, v_vals, r.price, case when r.old_price > r.price then r.old_price end,
              case when r.stock is null then null else v_each + case when v_i < v_rem then 1 else 0 end end, v_i, true)
      on conflict do nothing;
      v_i := v_i + 1;
    end loop;
  end loop;

  -- 2. Free-text categories → manual collections.
  for r in select shop_id, left(trim(category), 80) as name
             from public.shop_products
            where nullif(trim(category), '') is not null
            group by shop_id, left(trim(category), 80)
            order by shop_id, min(created_at) loop
    select id into v_cid from public.shop_collections where shop_id = r.shop_id and lower(name) = lower(r.name) limit 1;
    if not found then
      insert into public.shop_collections (shop_id, name, slug, position)
      values (r.shop_id, r.name, private.unique_collection_slug(r.shop_id, r.name, null),
              coalesce((select max(position) + 1 from public.shop_collections where shop_id = r.shop_id), 0))
      returning id into v_cid;
    end if;
    insert into public.shop_collection_products (collection_id, product_id, position)
    select v_cid, p.id, (row_number() over (order by p.position nulls last, p.created_at desc) - 1)::int
      from public.shop_products p
     where p.shop_id = r.shop_id and left(trim(p.category), 80) = r.name
    on conflict do nothing;
  end loop;

  insert into private.migration_marks (name) values ('0098_catalog');
end;
$$;
