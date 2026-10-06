-- =====================================================================
-- 0068 — Hardening from the security audit.
--
-- 1. RLS is enabled explicitly on every public table. On the live
--    database it already was (the project enabled it from the dashboard),
--    but a migration must not depend on a dashboard toggle.
-- 2. Storage buckets get a size cap and an allow-list of types: anyone
--    signed in could upload any file of any size before.
-- 3. Cancelling a store order gives its stock back.
-- 4. Job postings can only be attached to a shop the poster owns.
-- 5. Merchants can move guest orders along (it crashed on the notification).
-- =====================================================================

do $$
declare t record;
begin
  for t in
    select c.relname from pg_class c join pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relkind = 'r' and not c.relrowsecurity
  loop
    execute format('alter table public.%I enable row level security', t.relname);
    raise notice 'RLS enabled on %', t.relname;
  end loop;
end;
$$;

-- Photos: 8 MB, images only. Documents: 10 MB, images + PDF (+ the
-- technician verification video). The test harness's stub buckets table
-- has no such columns, so this is skipped there.
do $$
begin
  if exists (select 1 from information_schema.columns where table_schema = 'storage' and table_name = 'buckets' and column_name = 'file_size_limit') then
    update storage.buckets
       set file_size_limit = 8 * 1024 * 1024,
           allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif']
     where id = 'public-photos';
    update storage.buckets
       set file_size_limit = 10 * 1024 * 1024,
           allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'image/heif', 'application/pdf', 'video/mp4', 'video/quicktime']
     where id = 'private-documents';
  end if;
end;
$$;

-- Stock returns when an order is cancelled (it was deducted at placement).
create or replace function public.shop_order_restock_on_cancel() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status = 'cancelled' and old.status is distinct from 'cancelled' then
    update public.shop_products p
       set stock = p.stock + i.quantity
      from public.shop_order_items i
     where i.order_id = new.id and i.product_id = p.id and p.stock is not null;
  end if;
  return new;
end;
$$;
drop trigger if exists shop_order_restock_on_cancel on public.shop_orders;
create trigger shop_order_restock_on_cancel after update of status on public.shop_orders
  for each row execute function public.shop_order_restock_on_cancel();

-- A job posting may name a shop only if the poster owns that shop.
create or replace function public.job_posting_shop_guard() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.shop_id is not null and not public.is_super_admin()
     and not exists (select 1 from public.shops s where s.id = new.shop_id and s.owner_id = auth.uid()) then
    raise exception 'المحل ده مش بتاعك';
  end if;
  return new;
end;
$$;
drop trigger if exists job_posting_shop_guard on public.job_postings;
create trigger job_posting_shop_guard before insert or update of shop_id on public.job_postings
  for each row execute function public.job_posting_shop_guard();

-- Guest orders have no buyer account (buyer_id is null). The status change
-- tried to notify that null user, failed, and rolled back — so a merchant
-- could not accept, prepare or cancel any guest order. Notify only a real user.
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
    'طلب بقيمة ' || v_order.total_amount || ' ج.م.'
  );
end;
$$;
