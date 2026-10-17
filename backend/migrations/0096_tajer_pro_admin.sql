-- =====================================================================
-- Migration 0096 — متجري: professional admin foundations (phase 1).
--
--   * Order-line snapshots: shop_order_items + product_name,
--     variant_label (the chosen options), image_url (unit_price was
--     already there). place_shop_order / place_store_order (latest
--     bodies: 0092) fill them, existing rows are backfilled from the
--     current products, and every reader (get_store_order, my_shop_stats,
--     merchant_orders, merchant_order) reads the snapshot — renaming or
--     re-pricing a product no longer rewrites order history.
--   * shop_orders + internal_note (the merchant's own, never shown to the
--     customer) and cancel_reason.
--   * shop_order_events: the order timeline — created, every status
--     change (with who did it: merchant / customer / system), internal
--     notes and the cancel reason. Written by triggers / RPCs only; the
--     shop owner reads it.
--   * merchant_orders(p_shop, p_status, p_search, p_from, p_to, p_limit,
--     p_before, p_before_id): the server-side paginated orders list
--     (keyset on created_at, id), search by code / name / phone, plus the
--     per-status counts for the filter chips. merchant_order(p_order):
--     one order with its lines and timeline. merchant_set_order_note,
--     merchant_cancel_order (cancel with a reason).
--   * shop_products.status ('active' | 'draft' | 'archived'), kept in
--     step with is_available (only 'active' is visible — store-lite,
--     dalil and old builds keep reading is_available).
--     merchant_delete_product deletes a product only when it has no
--     orders; otherwise it reports has_orders so the app offers «أرشفة».
--   * shops.first_shared_at (onboarding checklist «شارك متجرك»), set by
--     merchant_mark_shared.
--   * shop_orders joins the supabase_realtime publication (the owner's
--     existing RLS read policy decides who gets the inserts) for the
--     new-order alert.
--
-- Run after 0095. Safe to re-run.
-- =====================================================================

-- ============================================================ columns

alter table public.shop_order_items add column if not exists product_name text;
alter table public.shop_order_items add column if not exists variant_label text;
alter table public.shop_order_items add column if not exists image_url text;
grant select (product_name, variant_label, image_url) on public.shop_order_items to authenticated;

alter table public.shop_orders add column if not exists internal_note text;
alter table public.shop_orders add column if not exists cancel_reason text;
grant select (internal_note, cancel_reason) on public.shop_orders to authenticated;

alter table public.shops add column if not exists first_shared_at timestamptz;

alter table public.shop_products add column if not exists status text not null default 'active';
alter table public.shop_products drop constraint if exists shop_products_status_valid;
alter table public.shop_products add constraint shop_products_status_valid check (status in ('active', 'draft', 'archived'));

-- Backfill: lines keep the product as it is today (best we know).
update public.shop_order_items i
   set product_name = p.name,
       image_url = coalesce(p.images[1], p.image_url),
       variant_label = coalesce(i.variant_label, i.chosen_options)
  from public.shop_products p
 where p.id = i.product_id and i.product_name is null;

create index if not exists shop_orders_shop_created_idx on public.shop_orders (shop_id, created_at desc, id desc);

-- ============================================================ product status

-- status ⇄ is_available: only 'active' products are visible. Clients
-- that only know is_available (old builds, quick pricing) still work:
-- showing a product makes it active, hiding it makes it a draft.
create or replace function public._shop_product_status_sync() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    if new.status = 'active' and not new.is_available then
      new.status := 'draft';
    end if;
    new.is_available := new.status = 'active';
  elsif new.status is distinct from old.status then
    new.is_available := new.status = 'active';
  elsif new.is_available is distinct from old.is_available then
    new.status := case when new.is_available then 'active' when old.status = 'archived' then 'archived' else 'draft' end;
  end if;
  return new;
end;
$$;
drop trigger if exists shop_product_status_sync on public.shop_products;
create trigger shop_product_status_sync before insert or update of status, is_available on public.shop_products
  for each row execute function public._shop_product_status_sync();

update public.shop_products set status = 'draft' where status = 'active' and not is_available;

-- Delete only a product nobody ordered; else tell the app to offer «أرشفة».
create or replace function public.merchant_delete_product(p_product uuid) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select p.shop_id into v_shop
    from public.shop_products p join public.shops s on s.id = p.shop_id
   where p.id = p_product and s.owner_id = auth.uid();
  if not found then
    raise exception 'المنتج ده مش بتاعك';
  end if;
  if exists (select 1 from public.shop_order_items where product_id = p_product) then
    return jsonb_build_object('deleted', false, 'has_orders', true);
  end if;
  delete from public.shop_products where id = p_product;
  return jsonb_build_object('deleted', true, 'has_orders', false);
end;
$$;
revoke execute on function public.merchant_delete_product(uuid) from public, anon;
grant execute on function public.merchant_delete_product(uuid) to authenticated;

-- ============================================================ order timeline

create table if not exists public.shop_order_events (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.shop_orders(id) on delete cascade,
  shop_id uuid not null references public.shops(id) on delete cascade,
  kind text not null check (kind in ('created', 'status', 'note', 'cancel')),
  from_status text,
  to_status text,
  body text,
  actor_id uuid,
  actor_role text not null default 'system' check (actor_role in ('merchant', 'customer', 'system')),
  created_at timestamptz not null default now()
);
create index if not exists shop_order_events_order_idx on public.shop_order_events (order_id, created_at);
alter table public.shop_order_events enable row level security;
revoke insert, update, delete on public.shop_order_events from authenticated, anon;
grant select on public.shop_order_events to authenticated;
drop policy if exists "shop_order_events: owner reads" on public.shop_order_events;
create policy "shop_order_events: owner reads" on public.shop_order_events
  for select to authenticated
  using (exists (select 1 from public.shops s where s.id = shop_order_events.shop_id and s.owner_id = auth.uid()));

-- Who is acting on an order: its shop's owner, its buyer, or the system.
create or replace function private.order_actor_role(p_shop uuid, p_buyer uuid) returns text
language sql
stable
security definer
set search_path = public
as $$
  select case
    when auth.uid() is null then 'system'
    when exists (select 1 from public.shops where id = p_shop and owner_id = auth.uid()) then 'merchant'
    when auth.uid() = p_buyer then 'customer'
    else 'system'
  end;
$$;

create or replace function public._shop_order_event_log() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    if new.status <> 'cart' then
      insert into public.shop_order_events (order_id, shop_id, kind, to_status, actor_id, actor_role)
      values (new.id, new.shop_id, 'created', new.status::text, auth.uid(), 'customer');
    end if;
  elsif new.status is distinct from old.status then
    insert into public.shop_order_events (order_id, shop_id, kind, from_status, to_status, body, actor_id, actor_role)
    values (new.id, new.shop_id,
            case when new.status = 'cancelled' then 'cancel' else 'status' end,
            old.status::text, new.status::text,
            case when new.status = 'cancelled' then new.cancel_reason end,
            auth.uid(), private.order_actor_role(new.shop_id, new.buyer_id));
  end if;
  return new;
end;
$$;
drop trigger if exists shop_order_event_log on public.shop_orders;
create trigger shop_order_event_log after insert or update of status on public.shop_orders
  for each row execute function public._shop_order_event_log();

-- Orders placed before 0096 get a «created» event once.
insert into public.shop_order_events (order_id, shop_id, kind, to_status, actor_role, created_at)
select o.id, o.shop_id, 'created', 'placed', 'customer', o.created_at
  from public.shop_orders o
 where o.status <> 'cart'
   and not exists (select 1 from public.shop_order_events e where e.order_id = o.id and e.kind = 'created');

-- ============================================================ ordering (snapshots)

-- 0092's in-app order + the line snapshots.
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
    insert into public.shop_order_items (order_id, product_id, quantity, unit_price, product_name, image_url)
    values (v_order_id, v_product.id, v_qty, v_product.price, v_product.name, coalesce(v_product.images[1], v_product.image_url));
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

-- 0092's store checkout + the line snapshots.
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
    insert into public.shop_order_items (order_id, product_id, quantity, unit_price, chosen_options, product_name, variant_label, image_url)
    values (v_order_id, v_product.id, v_qty, v_product.price, v_opts, v_product.name, v_opts, coalesce(v_product.images[1], v_product.image_url));
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

-- 0092's tracking page, reading the line snapshots.
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

-- 0054's home numbers; best sellers by the snapshot name.
create or replace function public.my_shop_stats(p_shop_id uuid) returns jsonb
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_scans int;
begin
  select scan_count into v_scans from public.shops where id = p_shop_id and owner_id = auth.uid();
  if not found then
    raise exception 'المحل ده مش بتاعك';
  end if;
  return jsonb_build_object(
    'visits', coalesce(v_scans, 0),
    'new_orders', (select count(*) from public.shop_orders where shop_id = p_shop_id and status = 'placed'),
    'orders_today', (select count(*) from public.shop_orders where shop_id = p_shop_id and status <> 'cart' and created_at >= date_trunc('day', now())),
    'sales_today', (select coalesce(sum(total_amount), 0) from public.shop_orders where shop_id = p_shop_id and status not in ('cart', 'cancelled') and created_at >= date_trunc('day', now())),
    'sales_30d', (select coalesce(sum(total_amount), 0) from public.shop_orders where shop_id = p_shop_id and status not in ('cart', 'cancelled') and created_at >= now() - interval '30 days'),
    'orders_30d', (select count(*) from public.shop_orders where shop_id = p_shop_id and status not in ('cart', 'cancelled') and created_at >= now() - interval '30 days'),
    'orders_all', (select count(*) from public.shop_orders where shop_id = p_shop_id and status <> 'cart'),
    'products', (select count(*) from public.shop_products where shop_id = p_shop_id),
    'top_products', coalesce((
      select jsonb_agg(t) from (
        select coalesce(i.product_name, p.name) as name, sum(i.quantity)::int as sold
          from public.shop_order_items i
          join public.shop_orders o on o.id = i.order_id
          left join public.shop_products p on p.id = i.product_id
         where o.shop_id = p_shop_id and o.status not in ('cart', 'cancelled') and o.created_at >= now() - interval '30 days'
         group by 1 order by sold desc limit 5) t), '[]'::jsonb)
  );
end;
$$;
revoke execute on function public.my_shop_stats(uuid) from public, anon;
grant execute on function public.my_shop_stats(uuid) to authenticated;

-- ============================================================ merchant orders

create or replace function private.order_lines_json(p_order uuid) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
           'product_id', i.product_id,
           'product_name', coalesce(i.product_name, p.name),
           'variant_label', coalesce(i.variant_label, i.chosen_options),
           'quantity', i.quantity,
           'unit_price', i.unit_price,
           'image_url', i.image_url) order by i.id), '[]'::jsonb)
    from public.shop_order_items i left join public.shop_products p on p.id = i.product_id
   where i.order_id = p_order;
$$;

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
    'delivery_fee', o.delivery_fee,
    'currency', o.currency,
    'payment', 'cash',
    'items', private.order_lines_json(o.id));
$$;

-- The paginated orders list. Keyset: pass the last row's created_at (and
-- id) as p_before / p_before_id for the next page. Counts ignore the
-- status filter (they label the chips) but follow search and dates.
create or replace function public.merchant_orders(
  p_shop uuid,
  p_status text default null,
  p_search text default null,
  p_from timestamptz default null,
  p_to timestamptz default null,
  p_limit int default 50,
  p_before timestamptz default null,
  p_before_id uuid default null
) returns jsonb
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_limit int := least(greatest(coalesce(p_limit, 50), 1), 200);
  v_q text := nullif(trim(translate(coalesce(p_search, ''), '٠١٢٣٤٥٦٧٨٩', '0123456789')), '');
  v_like text;
  v_digits text;
  v_rows jsonb;
  v_counts jsonb;
  v_more boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not exists (select 1 from public.shops where id = p_shop and owner_id = auth.uid()) then
    raise exception 'المحل ده مش بتاعك';
  end if;
  if p_status is not null and p_status not in ('placed', 'preparing', 'delivering', 'delivered', 'cancelled') then
    raise exception 'حالة غير معروفة';
  end if;
  if v_q is not null then
    v_q := left(v_q, 60);
    v_like := '%' || replace(replace(replace(v_q, '\', '\\'), '%', '\%'), '_', '\_') || '%';
    v_digits := nullif(regexp_replace(v_q, '\D', '', 'g'), '');
    if v_digits is not null and length(v_digits) < 3 then
      v_digits := null;
    end if;
  end if;

  with f as (
    select o as r, o.id, o.created_at, o.status::text as status
      from public.shop_orders o
     where o.shop_id = p_shop
       and o.status <> 'cart'
       and (p_from is null or o.created_at >= p_from)
       and (p_to is null or o.created_at < p_to)
       and (v_q is null
            or upper(coalesce(o.order_code, '')) like upper(v_like)
            or coalesce(o.customer_name, '') ilike v_like
            or (v_digits is not null and regexp_replace(coalesce(o.customer_phone, ''), '\D', '', 'g') like '%' || v_digits || '%'))
  ), page as (
    select f.r, f.id, f.created_at
      from f
     where (p_status is null or f.status = p_status)
       -- p_before without p_before_id: strictly older than p_before.
       and (p_before is null or (f.created_at, f.id) < (p_before, coalesce(p_before_id, '00000000-0000-0000-0000-000000000000'::uuid)))
     order by f.created_at desc, f.id desc
     limit v_limit + 1
  )
  select (select jsonb_build_object(
                   'all', count(*),
                   'placed', count(*) filter (where status = 'placed'),
                   'preparing', count(*) filter (where status = 'preparing'),
                   'delivering', count(*) filter (where status = 'delivering'),
                   'delivered', count(*) filter (where status = 'delivered'),
                   'cancelled', count(*) filter (where status = 'cancelled'))
            from f),
         (select coalesce(jsonb_agg(private.order_row_json(page.r) order by page.created_at desc, page.id desc), '[]'::jsonb) from page)
    into v_counts, v_rows;

  v_more := jsonb_array_length(v_rows) > v_limit;
  if v_more then
    v_rows := v_rows - v_limit;
  end if;
  return jsonb_build_object('orders', v_rows, 'counts', v_counts, 'has_more', v_more);
end;
$$;
revoke execute on function public.merchant_orders(uuid, text, text, timestamptz, timestamptz, int, timestamptz, uuid) from public, anon;
grant execute on function public.merchant_orders(uuid, text, text, timestamptz, timestamptz, int, timestamptz, uuid) to authenticated;

-- One order: lines, totals, customer and the timeline.
create or replace function public.merchant_order(p_order uuid) returns jsonb
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_order public.shop_orders;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select o.* into v_order
    from public.shop_orders o join public.shops s on s.id = o.shop_id
   where o.id = p_order and s.owner_id = auth.uid() and o.status <> 'cart';
  if not found then
    raise exception 'الطلب غير موجود';
  end if;
  return private.order_row_json(v_order) || jsonb_build_object(
    'events', coalesce((
      select jsonb_agg(jsonb_build_object(
               'id', e.id, 'kind', e.kind, 'from_status', e.from_status, 'to_status', e.to_status, 'body', e.body,
               'actor_role', e.actor_role, 'actor_name', pr.full_name, 'created_at', e.created_at) order by e.created_at, e.id)
        from public.shop_order_events e left join public.profiles pr on pr.id = e.actor_id
       where e.order_id = p_order), '[]'::jsonb));
end;
$$;
revoke execute on function public.merchant_order(uuid) from public, anon;
grant execute on function public.merchant_order(uuid) to authenticated;

-- The merchant's internal note (never shown to the customer).
create or replace function public.merchant_set_order_note(p_order uuid, p_note text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_order record;
  v_note text := nullif(left(trim(coalesce(p_note, '')), 1000), '');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select o.id, o.shop_id, o.internal_note into v_order
    from public.shop_orders o join public.shops s on s.id = o.shop_id
   where o.id = p_order and s.owner_id = auth.uid() and o.status <> 'cart'
   for update of o;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;
  if v_note is not distinct from v_order.internal_note then
    return;
  end if;
  update public.shop_orders set internal_note = v_note where id = p_order;
  insert into public.shop_order_events (order_id, shop_id, kind, body, actor_id, actor_role)
  values (p_order, v_order.shop_id, 'note', coalesce(v_note, '(اتمسحت الملاحظة)'), auth.uid(), 'merchant');
end;
$$;
revoke execute on function public.merchant_set_order_note(uuid, text) from public, anon;
grant execute on function public.merchant_set_order_note(uuid, text) to authenticated;

-- Cancel with a reason (the status rules and the customer notification
-- stay update_shop_order_status's).
create or replace function public.merchant_cancel_order(p_order uuid, p_reason text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_reason text := nullif(left(trim(coalesce(p_reason, '')), 300), '');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not exists (
    select 1 from public.shop_orders o join public.shops s on s.id = o.shop_id
     where o.id = p_order and s.owner_id = auth.uid()
  ) then
    raise exception 'الطلب غير موجود';
  end if;
  update public.shop_orders set cancel_reason = v_reason where id = p_order and status in ('placed', 'preparing', 'delivering');
  perform public.update_shop_order_status(p_order, 'cancelled');
end;
$$;
revoke execute on function public.merchant_cancel_order(uuid, text) from public, anon;
grant execute on function public.merchant_cancel_order(uuid, text) to authenticated;

-- «شارك متجرك» on the onboarding checklist.
create or replace function public.merchant_mark_shared(p_shop uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.shops set first_shared_at = coalesce(first_shared_at, now())
   where id = p_shop and owner_id = auth.uid();
end;
$$;
revoke execute on function public.merchant_mark_shared(uuid) from public, anon;
grant execute on function public.merchant_mark_shared(uuid) to authenticated;

-- ============================================================ realtime

do $$
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    raise notice 'supabase_realtime publication not found — skipping (not a Supabase database)';
    return;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'shop_orders'
  ) then
    alter publication supabase_realtime add table public.shop_orders;
  end if;
end;
$$;
