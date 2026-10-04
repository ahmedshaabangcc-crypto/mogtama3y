-- =====================================================================
-- Migration 0054 — a real storefront (Taager-style experience).
--
--   * Guest checkout: customers order with name, mobile and address —
--     no account — and pay on delivery. Every order gets a short public
--     code (e.g. T7K3P9QM) to follow it at /#/o/<code>.
--   * Product options ("المقاس": S/M/L, "اللون": …) and stock: an order
--     takes stock down and is refused when it runs out.
--   * Shop logo, and owners edit their store profile (name, description,
--     logo, cover) through update_my_shop_profile.
--   * my_shop_stats: the merchant home screen numbers.
-- Abuse limits: a mobile number can place 5 orders per shop per hour and
-- 20 per day overall.
-- =====================================================================

alter table public.shops add column if not exists logo_url text;

alter table public.shop_products add column if not exists options jsonb not null default '[]'::jsonb;
alter table public.shop_products drop constraint if exists shop_products_options_shape;
alter table public.shop_products add constraint shop_products_options_shape
  check (jsonb_typeof(options) = 'array' and jsonb_array_length(options) <= 3);
alter table public.shop_products drop constraint if exists shop_products_stock_valid;
alter table public.shop_products add constraint shop_products_stock_valid check (stock is null or stock >= 0);

alter table public.shop_orders alter column buyer_id drop not null;
alter table public.shop_orders add column if not exists customer_name text;
alter table public.shop_orders add column if not exists delivery_address text;
alter table public.shop_orders add column if not exists order_code text;
create unique index if not exists shop_orders_code_key on public.shop_orders (order_code);
alter table public.shop_order_items add column if not exists chosen_options text;

grant select (customer_name, delivery_address, order_code) on public.shop_orders to authenticated;
grant select (chosen_options) on public.shop_order_items to authenticated;

-- ---------------------------------------------------------------------
-- Guest checkout
-- ---------------------------------------------------------------------
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
  v_phone text := regexp_replace(coalesce(p_customer_phone, ''), '[^0-9]', '', 'g');
  v_name text := left(trim(coalesce(p_customer_name, '')), 80);
  v_address text := left(trim(coalesce(p_address, '')), 400);
  v_order_id uuid;
  v_code text;
  v_item jsonb;
  v_product record;
  v_qty int;
  v_opts text;
  v_total numeric(12,2) := 0;
  v_count int := 0;
  v_bytes bytea;
  v_idx int;
begin
  if v_phone ~ '^201[0125][0-9]{8}$' then
    v_phone := substr(v_phone, 2);
  end if;
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
  if v_phone !~ '^01[0125][0-9]{8}$' then
    raise exception 'اكتب رقم موبايل صحيح (مثال: 01012345678)';
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

  -- Short public tracking code (no look-alike characters).
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

  update public.shop_orders set total_amount = v_total where id = v_order_id;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد ' || v_code || ' — ' || v_shop.name,
          v_name || ' طلب ' || v_count || ' منتج بإجمالي ' || v_total || ' ج.م. افتح «الطلبات» في متجري.');

  return v_code;
end;
$$;

-- Public order tracking by code (no phone or address in the answer).
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

-- ---------------------------------------------------------------------
-- Store profile and merchant numbers
-- ---------------------------------------------------------------------
create or replace function public.update_my_shop_profile(
  p_shop_id uuid,
  p_name text,
  p_description text,
  p_logo_url text,
  p_cover_url text
) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_name is null or length(trim(p_name)) < 2 then
    raise exception 'اكتب اسم المحل';
  end if;
  update public.shops set
    name = left(trim(p_name), 80),
    description = nullif(left(trim(coalesce(p_description, '')), 600), ''),
    logo_url = nullif(trim(coalesce(p_logo_url, '')), ''),
    cover_image_url = nullif(trim(coalesce(p_cover_url, '')), '')
  where id = p_shop_id and owner_id = auth.uid();
  if not found then
    raise exception 'المحل ده مش بتاعك';
  end if;
end;
$$;

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
    'products', (select count(*) from public.shop_products where shop_id = p_shop_id),
    'top_products', coalesce((
      select jsonb_agg(t) from (
        select p.name, sum(i.quantity)::int as sold
          from public.shop_order_items i
          join public.shop_orders o on o.id = i.order_id
          join public.shop_products p on p.id = i.product_id
         where o.shop_id = p_shop_id and o.status not in ('cart', 'cancelled') and o.created_at >= now() - interval '30 days'
         group by p.name order by sold desc limit 5) t), '[]'::jsonb)
  );
end;
$$;

revoke execute on function public.place_store_order(uuid, jsonb, text, text, text, text) from public;
grant execute on function public.place_store_order(uuid, jsonb, text, text, text, text) to anon, authenticated;
revoke execute on function public.get_store_order(text) from public;
grant execute on function public.get_store_order(text) to anon, authenticated;
revoke execute on function public.update_my_shop_profile(uuid, text, text, text, text) from public, anon;
grant execute on function public.update_my_shop_profile(uuid, text, text, text, text) to authenticated;
revoke execute on function public.my_shop_stats(uuid) from public, anon;
grant execute on function public.my_shop_stats(uuid) to authenticated;
