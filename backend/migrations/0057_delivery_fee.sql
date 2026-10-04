-- =====================================================================
-- Migration 0057 — merchant-set delivery fee.
--
-- Each shop sets its delivery fee (0 = free) and, optionally, an order
-- amount above which delivery is free. place_store_order adds it to the
-- order total server-side (so it can't be tampered with) and keeps it on
-- the order; tracking shows products subtotal + delivery.
-- =====================================================================

alter table public.shops add column if not exists delivery_fee numeric(10,2) not null default 0;
alter table public.shops add column if not exists free_delivery_over numeric(12,2);
alter table public.shops drop constraint if exists shops_delivery_fee_valid;
alter table public.shops add constraint shops_delivery_fee_valid
  check (delivery_fee >= 0 and delivery_fee <= 1000 and (free_delivery_over is null or free_delivery_over > 0));
alter table public.shop_orders add column if not exists delivery_fee numeric(10,2) not null default 0;
grant select (delivery_fee) on public.shop_orders to authenticated;

create or replace function public.set_my_shop_delivery(p_shop_id uuid, p_fee numeric, p_free_over numeric default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_fee is null or p_fee < 0 or p_fee > 1000 then
    raise exception 'قيمة التوصيل لازم تكون من 0 لـ 1000 جنيه';
  end if;
  if p_free_over is not null and p_free_over <= 0 then
    raise exception 'حد التوصيل المجاني لازم يكون أكبر من صفر';
  end if;
  update public.shops set delivery_fee = round(p_fee, 2), free_delivery_over = p_free_over
   where id = p_shop_id and owner_id = auth.uid();
  if not found then
    raise exception 'المحل ده مش بتاعك';
  end if;
end;
$$;

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
  v_delivery numeric(10,2) := 0;
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

  -- Delivery is set by the merchant; free above their threshold.
  v_delivery := coalesce(v_shop.delivery_fee, 0);
  if v_shop.free_delivery_over is not null and v_total >= v_shop.free_delivery_over then
    v_delivery := 0;
  end if;
  update public.shop_orders set delivery_fee = v_delivery, total_amount = v_total + v_delivery where id = v_order_id;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد ' || v_code || ' — ' || v_shop.name,
          v_name || ' طلب ' || v_count || ' منتج بإجمالي ' || (v_total + v_delivery) || ' ج.م (شامل التوصيل). افتح «الطلبات» في متجري.');

  return v_code;
end;
$$;

-- Tracking now shows the delivery line too.
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

revoke execute on function public.set_my_shop_delivery(uuid, numeric, numeric) from public, anon;
grant execute on function public.set_my_shop_delivery(uuid, numeric, numeric) to authenticated;
revoke execute on function public.place_store_order(uuid, jsonb, text, text, text, text) from public;
grant execute on function public.place_store_order(uuid, jsonb, text, text, text, text) to anon, authenticated;
revoke execute on function public.get_store_order(text) from public;
grant execute on function public.get_store_order(text) to anon, authenticated;
