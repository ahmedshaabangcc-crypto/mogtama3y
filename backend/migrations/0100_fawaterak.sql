-- =====================================================================
-- Migration 0100 — متجري: online payment with Fawaterak (فواتيرك).
--
-- Phase 4 of «الربط والتكاملات» (0097), first gateway. Owner decision
-- (2026-10-30): every merchant connects THEIR OWN Fawaterak account (the
-- money goes to the merchant; the platform never holds it).
--
--   * 'fawaterak' joins the gateways (Egypt): one secret, the API key
--     (Bearer token — also the "vendor key" that signs webhooks), and an
--     optional public Provider Key.
--   * shop_orders gets payment columns: payment_method ('cod' | 'online'),
--     payment_status (null for cash; 'awaiting' | 'paid' | 'failed'),
--     provider, invoice id / key / link / data (Fawry code…), paid_at,
--     paid_amount. No client role can write them (column grants): only
--     the functions below, called by the Edge Functions (service role).
--   * Flow: the customer places the order as before (place_store_order),
--     then «ادفع أونلاين» → payments-checkout (Edge Function):
--       payment_begin()  — order code + phone prove it is them; the order
--                          becomes online / «مستني الدفع»,
--       Fawaterak invoiceInitPay (the merchant's key) → payment_attach(),
--       the customer pays on Fawaterak's page (or with a Fawry code),
--       payments-webhook (signed) / the return page → payment_settle():
--       re-checked with Fawaterak's getInvoiceData, amount and currency
--       must match the order, then «اتدفع ✓» + a notification.
--   * A paid order can't be cancelled by the customer (refunds go through
--     the shop); get_store_order / the merchant's order row show payment.
-- Run after 0099. Safe to re-run.
-- =====================================================================

-- ---------------------------------------------------------- 1. the gateway

alter table public.shop_payment_gateways drop constraint if exists shop_payment_gateways_provider_check;
alter table public.shop_payment_gateways add constraint shop_payment_gateways_provider_check
  check (provider in ('paymob', 'kashier', 'tap', 'moyasar', 'fawaterak'));

create or replace function private.gateway_countries(p_provider text) returns text[]
language sql immutable as $$
  select case p_provider
    when 'fawaterak' then array['EG']
    when 'paymob'  then array['EG', 'SA', 'AE', 'OM']
    when 'kashier' then array['EG']
    when 'tap'     then array['SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'EG', 'JO']
    when 'moyasar' then array['SA']
    else array[]::text[] end
$$;

create or replace function private.gateways_for_country(p_country text) returns text[]
language sql immutable as $$
  select coalesce(array_agg(p order by o), array[]::text[])
  from unnest(array['fawaterak', 'paymob', 'kashier', 'tap', 'moyasar']) with ordinality as g(p, o)
  where upper(coalesce(p_country, 'EG')) = any (private.gateway_countries(p))
$$;

-- The currencies Fawaterak charges in.
create or replace function private.gateway_currencies(p_provider text) returns text[]
language sql immutable as $$
  select case p_provider
    when 'fawaterak' then array['EGP', 'USD', 'SAR', 'AED', 'KWD', 'QAR', 'BHD']
    else null end
$$;

create or replace function private.gateway_fields(p_provider text) returns jsonb
language sql immutable as $$
  select case p_provider
    when 'fawaterak' then jsonb_build_object(
      'public', jsonb_build_object('provider_key', '^[A-Za-z0-9_-]{6,120}$'),
      'secret', jsonb_build_object('api_key', '^[A-Za-z0-9]{20,200}$'),
      'required', jsonb_build_array('api_key'))
    when 'paymob' then jsonb_build_object(
      'public', jsonb_build_object(
        'card_integration_id', '^[0-9]{3,12}$',
        'wallet_integration_id', '^[0-9]{3,12}$',
        'iframe_id', '^[0-9]{2,12}$',
        'public_key', '^[a-z]{3}_pk_(test|live)_[A-Za-z0-9]{8,120}$'),
      'secret', jsonb_build_object(
        'api_key', '^[A-Za-z0-9+/=._-]{20,}$',
        'secret_key', '^[a-z]{3}_sk_(test|live)_[A-Za-z0-9]{8,200}$',
        'hmac_secret', '^[A-Za-z0-9]{16,128}$'),
      'required', jsonb_build_array('card_integration_id', 'api_key', 'hmac_secret'))
    when 'kashier' then jsonb_build_object(
      'public', jsonb_build_object('merchant_id', '^MID-[0-9]{1,10}-[0-9]{1,10}$'),
      'secret', jsonb_build_object(
        'api_key', '^[A-Za-z0-9-]{16,100}$',
        'secret_key', '^[A-Za-z0-9$._/-]{16,200}$'),
      'required', jsonb_build_array('merchant_id', 'api_key', 'secret_key'))
    when 'tap' then jsonb_build_object(
      'public', jsonb_build_object(
        'publishable_key', '^pk_(test|live)_[A-Za-z0-9]{10,64}$',
        'merchant_id', '^[0-9]{3,20}$'),
      'secret', jsonb_build_object('secret_key', '^sk_(test|live)_[A-Za-z0-9]{10,64}$'),
      'required', jsonb_build_array('publishable_key', 'secret_key'))
    when 'moyasar' then jsonb_build_object(
      'public', jsonb_build_object('publishable_key', '^pk_(test|live)_[A-Za-z0-9]{20,64}$'),
      'secret', jsonb_build_object('secret_key', '^sk_(test|live)_[A-Za-z0-9]{20,64}$'),
      'required', jsonb_build_array('publishable_key', 'secret_key'))
    else null end
$$;

-- ------------------------------------------------------ 2. order payment

alter table public.shop_orders add column if not exists payment_method text not null default 'cod';
alter table public.shop_orders add column if not exists payment_status text;
alter table public.shop_orders add column if not exists payment_provider text;
alter table public.shop_orders add column if not exists payment_invoice_id text;
alter table public.shop_orders add column if not exists payment_invoice_key text;
alter table public.shop_orders add column if not exists payment_url text;
alter table public.shop_orders add column if not exists payment_data jsonb;
alter table public.shop_orders add column if not exists paid_at timestamptz;
alter table public.shop_orders add column if not exists paid_amount numeric(14,3);
alter table public.shop_orders drop constraint if exists shop_orders_payment_ok;
alter table public.shop_orders add constraint shop_orders_payment_ok check (
  payment_method in ('cod', 'online')
  and (payment_status is null or payment_status in ('awaiting', 'paid', 'failed'))
  and (payment_method = 'online' or payment_status is null));
create unique index if not exists shop_orders_payment_invoice_idx on public.shop_orders (payment_provider, payment_invoice_id)
  where payment_invoice_id is not null;
-- Readable like the other order columns; written only by the functions below.
grant select (payment_method, payment_status, payment_provider, paid_at, paid_amount) on public.shop_orders to authenticated;

alter table public.shop_order_events drop constraint if exists shop_order_events_kind_check;
alter table public.shop_order_events add constraint shop_order_events_kind_check
  check (kind in ('created', 'status', 'note', 'cancel', 'confirm', 'discount', 'payment'));

create or replace function private.payment_provider_name(p text) returns text
language sql immutable as $$
  select case p when 'fawaterak' then 'فواتيرك' when 'paymob' then 'Paymob' when 'kashier' then 'Kashier'
                when 'tap' then 'Tap' when 'moyasar' then 'Moyasar' else coalesce(p, 'أونلاين') end
$$;

-- The same customer: the order's mobile, compared on its last 9 digits
-- (01… in Egypt or E.164 — both forms of one number end the same).
create or replace function private.same_phone(a text, b text) returns boolean
language sql immutable as $$
  select length(regexp_replace(coalesce(a, ''), '\D', '', 'g')) >= 8
     and right(regexp_replace(translate(coalesce(a, ''), '٠١٢٣٤٥٦٧٨٩', '0123456789'), '\D', '', 'g'), 9)
       = right(regexp_replace(translate(coalesce(b, ''), '٠١٢٣٤٥٦٧٨٩', '0123456789'), '\D', '', 'g'), 9)
$$;

-- payments-checkout: the customer starts (or retries) paying an order.
-- → {order_id, shop_id, code, total, currency, customer_name, customer_phone,
--    shop_name, mode, payment_status, invoice_id, payment_url, payment_data}
-- or {error} (returned, not raised, so the counted try stays).
create or replace function public.payment_begin(p_code text, p_phone text, p_provider text default 'fawaterak') returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_code text := upper(trim(coalesce(p_code, '')));
  o record;
  v_mode text;
begin
  select so.*, s.name as shop_name, s.owner_id into o
    from public.shop_orders so join public.shops s on s.id = so.shop_id
   where so.order_code = v_code
   for update of so;
  if not found then
    return jsonb_build_object('error', 'مفيش طلب بالرقم ده');
  end if;
  if private.checkout_hit_count(o.shop_id, 'pay_begin', 'order:' || v_code, interval '1 hour') >= 20 then
    return jsonb_build_object('error', 'محاولات كتير — استنى شوية وجرّب تاني');
  end if;
  perform private.checkout_hit(o.shop_id, 'pay_begin', 'order:' || v_code);
  if not private.same_phone(o.customer_phone, p_phone) then
    return jsonb_build_object('error', 'رقم الموبايل مش هو رقم الطلب');
  end if;
  if o.payment_status = 'paid' then
    return jsonb_build_object('order_id', o.id, 'shop_id', o.shop_id, 'code', o.order_code, 'payment_status', 'paid');
  end if;
  if o.status <> 'placed' then
    return jsonb_build_object('error', case when o.status = 'cancelled' then 'الطلب ده اتلغى' else 'الطلب ده المحل بدأ فيه — كلّم المحل' end);
  end if;
  if o.created_at < now() - interval '3 days' then
    return jsonb_build_object('error', 'الطلب ده قديم — اعمل طلب جديد أو كلّم المحل');
  end if;
  select g.mode into v_mode from public.shop_payment_gateways g
   where g.shop_id = o.shop_id and g.provider = p_provider and g.enabled and g.status = 'connected';
  if v_mode is null then
    return jsonb_build_object('error', 'المحل ده مش مفعّل الدفع الأونلاين دلوقتي — اختار الدفع عند الاستلام');
  end if;
  if not (o.currency = any (coalesce(private.gateway_currencies(p_provider), array[o.currency]))) then
    return jsonb_build_object('error', 'الدفع الأونلاين مش متاح بعملة المحل');
  end if;
  if o.total_amount <= 0 then
    return jsonb_build_object('error', 'مفيش مبلغ يتدفع');
  end if;

  if o.payment_method = 'cod' or o.payment_provider is distinct from p_provider then
    update public.shop_orders
       set payment_method = 'online', payment_provider = p_provider, payment_status = 'awaiting',
           payment_invoice_id = null, payment_invoice_key = null, payment_url = null, payment_data = null
     where id = o.id;
    insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
    values (o.id, o.shop_id, 'payment', 'الزبون اختار الدفع أونلاين (' || private.payment_provider_name(p_provider) || ') — مستني الدفع', 'customer');
  elsif o.payment_status = 'failed' then
    update public.shop_orders set payment_status = 'awaiting' where id = o.id;
  end if;

  return jsonb_build_object(
    'order_id', o.id, 'shop_id', o.shop_id, 'code', o.order_code,
    'total', o.total_amount, 'currency', o.currency,
    'customer_name', o.customer_name, 'customer_phone', o.customer_phone,
    'shop_name', o.shop_name, 'mode', v_mode, 'payment_status', 'awaiting',
    'invoice_id', case when o.payment_provider = p_provider then o.payment_invoice_id end,
    'payment_url', case when o.payment_provider = p_provider then o.payment_url end,
    'payment_data', case when o.payment_provider = p_provider then o.payment_data end);
end;
$$;

-- payments-checkout: the invoice Fawaterak made for the order.
create or replace function public.payment_attach(
  p_order uuid, p_provider text, p_invoice_id text, p_invoice_key text, p_url text, p_data jsonb
) returns void
language sql
security definer
set search_path = public
as $$
  update public.shop_orders
     set payment_invoice_id = left(p_invoice_id, 60), payment_invoice_key = left(p_invoice_key, 120),
         payment_url = case when p_url ~ '^https://' then left(p_url, 500) end,
         payment_data = case when length(coalesce(p_data, '{}'::jsonb)::text) > 4000 then null else p_data end
   where id = p_order and payment_provider = p_provider and payment_status <> 'paid';
$$;

-- payments-webhook / payments-checkout (status): what the gateway says
-- about an invoice — the caller has already re-read it from the gateway.
-- The order is found by the invoice, or by [p_code] (the order code we
-- put in the invoice's payLoad) for an older invoice of the same order —
-- a customer who switched from a Fawry code to a card may still pay the
-- first one.
-- → {ok, code?, status?, reason?}
create or replace function public.payment_settle(
  p_shop uuid, p_provider text, p_invoice_id text, p_paid boolean,
  p_amount numeric default null, p_currency text default null, p_method text default null, p_code text default null
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  o record;
  v_how text := nullif(left(trim(coalesce(p_method, '')), 40), '');
  v_current boolean;
begin
  select so.*, s.owner_id, s.name as shop_name into o
    from public.shop_orders so join public.shops s on s.id = so.shop_id
   where so.shop_id = p_shop and so.payment_provider = p_provider
     and (so.payment_invoice_id = p_invoice_id or (p_code is not null and so.order_code = upper(trim(p_code))))
   order by (so.payment_invoice_id = p_invoice_id) desc
   limit 1
   for update of so;
  if not found then
    return jsonb_build_object('ok', false, 'reason', 'no_order');
  end if;
  if o.payment_status = 'paid' then
    return jsonb_build_object('ok', true, 'code', o.order_code, 'status', 'paid', 'already', true);
  end if;
  v_current := o.payment_invoice_id is not distinct from p_invoice_id;

  if not coalesce(p_paid, false) then
    -- An old invoice failing / expiring says nothing about the current one.
    if not v_current then
      return jsonb_build_object('ok', true, 'code', o.order_code, 'status', o.payment_status);
    end if;
    if o.payment_status is distinct from 'failed' then
      update public.shop_orders set payment_status = 'failed' where id = o.id;
      insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
      values (o.id, o.shop_id, 'payment', 'محاولة الدفع الأونلاين مانجحتش — الزبون يقدر يحاول تاني', 'system');
    end if;
    return jsonb_build_object('ok', true, 'code', o.order_code, 'status', 'failed');
  end if;

  -- Paid: only for the order's exact amount and currency.
  if p_amount is null or abs(p_amount - o.total_amount) > 0.01 or upper(coalesce(p_currency, o.currency)) <> o.currency then
    insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
    values (o.id, o.shop_id, 'payment',
            'وصل دفع بمبلغ مش مطابق للطلب (' || coalesce(p_amount::text, '?') || ' ' || coalesce(upper(p_currency), '') || ') — راجعه في لوحة ' || private.payment_provider_name(p_provider),
            'system');
    return jsonb_build_object('ok', false, 'code', o.order_code, 'reason', 'amount_mismatch');
  end if;

  update public.shop_orders set payment_status = 'paid', paid_at = now(), paid_amount = p_amount, payment_invoice_id = p_invoice_id where id = o.id;
  insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
  values (o.id, o.shop_id, 'payment',
          'اتدفع أونلاين ✓ ' || private.money_text(p_amount, o.currency) || ' عن طريق ' || private.payment_provider_name(p_provider)
            || coalesce(' (' || v_how || ')', ''),
          'system');
  insert into public.notifications (user_id, title, body)
  values (o.owner_id, '💳 اتدفع الطلب ' || o.order_code || ' — ' || o.shop_name,
          coalesce(o.customer_name, 'الزبون') || ' دفع ' || private.money_text(p_amount, o.currency) || ' أونلاين'
            || case when o.status = 'cancelled' then '، بس الطلب ملغي — رجّعله فلوسه من لوحة ' || private.payment_provider_name(p_provider) || '.'
                    else '. الفلوس في حسابك على ' || private.payment_provider_name(p_provider) || ' — جهّز الطلب.' end);
  return jsonb_build_object('ok', true, 'code', o.order_code, 'status', 'paid');
end;
$$;

-- payments-checkout (status): the invoice of an order, by code + phone.
create or replace function public.payment_lookup(p_code text, p_phone text) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select case when o.id is null then null else jsonb_build_object(
    'order_id', o.id, 'shop_id', o.shop_id, 'code', o.order_code, 'provider', o.payment_provider,
    'invoice_id', o.payment_invoice_id, 'payment_status', o.payment_status, 'total', o.total_amount, 'currency', o.currency) end
  from public.shop_orders o
  where o.order_code = upper(trim(coalesce(p_code, ''))) and private.same_phone(o.customer_phone, p_phone)
$$;

-- A paid order isn't cancelled by the customer: the refund goes through the shop.
create or replace function public._shop_order_paid_guard() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status = 'cancelled' and old.status is distinct from 'cancelled' and old.payment_status = 'paid'
     and current_setting('app.order_actor', true) = 'customer' then
    raise exception 'الطلب ده اتدفع أونلاين — كلّم المحل عشان يلغيه ويرجّعلك فلوسك';
  end if;
  return new;
end;
$$;
drop trigger if exists shop_order_paid_guard on public.shop_orders;
create trigger shop_order_paid_guard before update of status on public.shop_orders
  for each row execute function public._shop_order_paid_guard();

-- ------------------------------------------------------ 3. order reads

-- 0099's tracking page + payment.
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
    'can_cancel', o.status = 'placed' and o.order_code is not null and o.payment_status is distinct from 'paid',
    'cancel_reason', case when o.status = 'cancelled' then o.cancel_reason end,
    'currency', o.currency,
    'payment_method', o.payment_method,
    'payment_status', o.payment_status,
    'payment_provider', o.payment_provider,
    'paid_at', o.paid_at,
    'can_pay', o.status = 'placed' and o.payment_method = 'online' and o.payment_status in ('awaiting', 'failed'),
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

-- 0099's merchant row + payment.
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
    'payment', case when o.payment_method = 'online' then 'online' else 'cash' end,
    'payment_status', o.payment_status,
    'payment_provider', o.payment_provider,
    'paid_at', o.paid_at,
    'items', private.order_lines_json(o.id));
$$;

-- ------------------------------------------------------------ grants

do $$
declare
  f text;
begin
  -- Edge Functions only
  foreach f in array array[
    'public.payment_begin(text, text, text)',
    'public.payment_attach(uuid, text, text, text, text, jsonb)',
    'public.payment_settle(uuid, text, text, boolean, numeric, text, text, text)',
    'public.payment_lookup(text, text)'] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
    execute format('grant execute on function %s to service_role', f);
  end loop;
end;
$$;
