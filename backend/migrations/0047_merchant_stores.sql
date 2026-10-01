-- =====================================================================
-- Migration 0047 — real merchant stores ("مشروعك أونلاين").
--
-- shop_products / shop_orders / shop_order_items existed since the first
-- schema but had no policies, grants or code. This wires them:
--
--   * Each shop gets a public link  mogtama3y.com/#/s/<slug>  (+ QR) and a
--     WhatsApp number for orders; scans of the QR are counted.
--   * A merchant registers a new shop (create_my_shop) or uses a shop
--     they already own (claimed Google shop), then adds products from the
--     merchant panel.
--   * Anyone can browse a store without an account. Ordering needs an
--     account: place_shop_order() prices the order from the database
--     (never from the client), notifies the merchant in the app, and the
--     app also opens WhatsApp to the shop with the order summary. No
--     payment or delivery goes through مُجتمعي — the shop handles both.
--   * The merchant moves the order through preparing → delivering →
--     delivered (or cancels); the customer is notified at each step.
--
-- Run after 0046, in order, in the Supabase SQL editor.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Shops: slug, WhatsApp, scan counter
-- ---------------------------------------------------------------------

alter table public.shops add column if not exists slug text;
alter table public.shops add column if not exists whatsapp text;
alter table public.shops add column if not exists scan_count int not null default 0;

create unique index if not exists shops_slug_key on public.shops (slug);

alter table public.shops drop constraint if exists shops_slug_format;
alter table public.shops add constraint shops_slug_format
  check (slug is null or slug ~ '^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$');

alter table public.shops drop constraint if exists shops_whatsapp_format;
alter table public.shops add constraint shops_whatsapp_format
  check (whatsapp is null or whatsapp ~ '^01[0125][0-9]{8}$');

-- scan_count is server-maintained like rating (0041's guard).
create or replace function public.guard_shop_protected_columns() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if new.owner_id is distinct from old.owner_id
       or new.source is distinct from old.source
       or new.google_place_id is distinct from old.google_place_id
       or new.rating is distinct from old.rating
       or new.rating_count is distinct from old.rating_count
       or new.is_claimed is distinct from old.is_claimed
       or new.claimed_at is distinct from old.claimed_at
       or new.scan_count is distinct from old.scan_count then
      raise exception 'لا يمكن تعديل هذه البيانات' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;

-- A merchant registers their own shop (the campaign's sign-up form).
create or replace function public.create_my_shop(
  p_name text,
  p_category text,
  p_slug text,
  p_whatsapp text,
  p_address text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_slug text := lower(trim(coalesce(p_slug, '')));
  v_phone text := regexp_replace(coalesce(p_whatsapp, ''), '\s', '', 'g');
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_name is null or length(trim(p_name)) < 2 then
    raise exception 'اكتب اسم المحل';
  end if;
  if v_slug !~ '^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$' then
    raise exception 'اسم الرابط لازم يكون بالإنجليزي (حروف وأرقام وشرطة) من 3 لـ 40 حرف';
  end if;
  if exists (select 1 from public.shops where slug = v_slug) then
    raise exception 'اسم الرابط ده مستخدم، جرّب اسم تاني';
  end if;
  if v_phone !~ '^01[0125][0-9]{8}$' then
    raise exception 'رقم الواتساب غير صحيح (مثال: 01012345678)';
  end if;
  if (select count(*) from public.shops where owner_id = auth.uid()) >= 3 then
    raise exception 'وصلت للحد الأقصى (3 محلات لكل حساب)';
  end if;

  insert into public.shops (owner_id, source, name, category, slug, whatsapp, address, is_claimed, claimed_at)
  values (auth.uid(), 'claimed', trim(p_name), p_category, v_slug, v_phone, nullif(trim(coalesce(p_address, '')), ''), true, now())
  returning id into v_id;
  return v_id;
end;
$$;

-- Counted every time someone opens a store from its QR / link.
create or replace function public.record_shop_scan(p_slug text) returns void
language sql
security definer
set search_path = public
as $$
  update public.shops set scan_count = scan_count + 1 where slug = lower(p_slug);
$$;


-- ---------------------------------------------------------------------
-- 2. Products: public catalogue, owner-managed
-- ---------------------------------------------------------------------

alter table public.shop_products add column if not exists description text;
alter table public.shop_products add column if not exists created_at timestamptz not null default now();
alter table public.shop_products drop constraint if exists shop_products_valid;
alter table public.shop_products add constraint shop_products_valid
  check (price >= 0 and price <= 1000000 and length(trim(name)) between 1 and 120);

grant select on public.shop_products to anon, authenticated;
grant insert, update, delete on public.shop_products to authenticated;

create policy "shop_products: public reads available" on public.shop_products
  for select using (is_available);
create policy "shop_products: owner reads all own" on public.shop_products
  for select using (exists (select 1 from public.shops s where s.id = shop_products.shop_id and s.owner_id = auth.uid()));
create policy "shop_products: owner inserts" on public.shop_products
  for insert with check (exists (select 1 from public.shops s where s.id = shop_products.shop_id and s.owner_id = auth.uid()));
create policy "shop_products: owner updates" on public.shop_products
  for update using (exists (select 1 from public.shops s where s.id = shop_products.shop_id and s.owner_id = auth.uid()))
  with check (exists (select 1 from public.shops s where s.id = shop_products.shop_id and s.owner_id = auth.uid()));
create policy "shop_products: owner deletes" on public.shop_products
  for delete using (exists (select 1 from public.shops s where s.id = shop_products.shop_id and s.owner_id = auth.uid()));


-- ---------------------------------------------------------------------
-- 3. Orders
-- ---------------------------------------------------------------------

alter table public.shop_orders add column if not exists customer_phone text;
alter table public.shop_orders add column if not exists note text;

grant select on public.shop_orders, public.shop_order_items to authenticated;
revoke insert, update, delete on public.shop_orders, public.shop_order_items from authenticated, anon;

create policy "shop_orders: buyer views own" on public.shop_orders
  for select using (auth.uid() = buyer_id);
create policy "shop_orders: shop owner views" on public.shop_orders
  for select using (exists (select 1 from public.shops s where s.id = shop_orders.shop_id and s.owner_id = auth.uid()));
create policy "shop_order_items: parties view" on public.shop_order_items
  for select using (exists (
    select 1 from public.shop_orders o join public.shops s on s.id = o.shop_id
    where o.id = shop_order_items.order_id and (o.buyer_id = auth.uid() or s.owner_id = auth.uid())
  ));

-- p_items: [{"product_id": "...", "quantity": 2}, …]. Prices come from
-- shop_products, never from the client.
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
  v_phone text := regexp_replace(coalesce(p_customer_phone, ''), '\s', '', 'g');
  v_order_id uuid;
  v_item jsonb;
  v_product record;
  v_qty int;
  v_total numeric(12,2) := 0;
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
  if v_phone !~ '^01[0125][0-9]{8}$' then
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
          v_count || ' منتج بإجمالي ' || v_total || ' ج.م — موبايل العميل ' || v_phone || '. افتح لوحة التاجر لتفاصيل الطلب.');

  return v_order_id;
end;
$$;

-- Merchant moves an order forward; the customer may cancel while it is
-- still 'placed'.
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
  insert into public.notifications (user_id, title, body)
  values (
    case when v_is_owner then v_order.buyer_id else v_order.owner_id end,
    v_label || ' — ' || v_order.shop_name,
    'طلب بقيمة ' || v_order.total_amount || ' ج.م.'
  );
end;
$$;

revoke execute on function public.create_my_shop(text, text, text, text, text) from public, anon;
revoke execute on function public.place_shop_order(uuid, jsonb, text, text) from public, anon;
revoke execute on function public.update_shop_order_status(uuid, text) from public, anon;
grant execute on function public.create_my_shop(text, text, text, text, text) to authenticated;
grant execute on function public.place_shop_order(uuid, jsonb, text, text) to authenticated;
grant execute on function public.update_shop_order_status(uuid, text) to authenticated;
-- Store pages are public: opening one from a QR counts a scan even for guests.
grant execute on function public.record_shop_scan(text) to anon, authenticated;
