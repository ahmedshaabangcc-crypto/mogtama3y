-- =====================================================================
-- Migration 0108 — «اربط مع مُجتمعي»: stores take online payments through
-- the PLATFORM's Fawaterak account.
--
-- Owner decision (2026-10-30): a merchant can turn online payment on from
-- day one without their own gateway — the customer pays مُجتمعي, the money
-- lands in the platform's account and مُجتمعي transfers it to the merchant
-- by hand. Before that the merchant sends proof of identity (ID card; a
-- company: commercial register + tax card) and the admin approves.
-- No platform commission for now (a setting, 0 %); Fawaterak's own fee is
-- the merchant's (taken off what they are owed).
--
--   * shop_platform_pay: the application — individual / company, legal
--     name, ID / register number, documents (private-documents paths, the
--     owner's own folder), how to be paid (InstaPay / wallet / bank),
--     status pending → approved / rejected / suspended, the admin's note.
--   * Orders paid this way: payment_provider = 'mogtama3y'; payment_fee =
--     Fawaterak's fee on that transaction (payment_record_fee).
--   * shop_payouts: what the platform transferred to the merchant.
--   * Balance = paid online orders (not cancelled) − Fawaterak fees −
--     commission − payouts.
--   * RPCs — merchant: platform_pay_get / platform_pay_apply;
--     admin: admin_platform_pay_list / admin_platform_pay_review /
--     admin_platform_balances / admin_record_payout.
--   * payment_begin / shop_checkout_methods / payment_settle learn the
--     'mogtama3y' provider (0100 / 0097 bodies + that, same signatures).
-- Run after 0107. Safe to re-run.
-- =====================================================================

create table if not exists public.platform_pay_settings (
  id int primary key default 1 check (id = 1),
  commission_pct numeric(5,2) not null default 0 check (commission_pct between 0 and 50),
  updated_at timestamptz not null default now()
);
insert into public.platform_pay_settings (id) values (1) on conflict (id) do nothing;
alter table public.platform_pay_settings enable row level security;
revoke all on public.platform_pay_settings from anon, authenticated;

create table if not exists public.shop_platform_pay (
  shop_id uuid primary key references public.shops(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected', 'suspended')),
  entity text not null check (entity in ('individual', 'company')),
  legal_name text not null,
  id_number text not null,
  tax_number text,
  documents jsonb not null default '[]'::jsonb,
  payout jsonb not null default '{}'::jsonb,
  commission_pct numeric(5,2) check (commission_pct is null or commission_pct between 0 and 50),
  review_note text,
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references public.profiles(id) on delete set null
);
alter table public.shop_platform_pay enable row level security;
revoke all on public.shop_platform_pay from anon, authenticated;

create table if not exists public.shop_payouts (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  amount numeric(14,2) not null check (amount > 0),
  currency text not null default 'EGP',
  method text,
  reference text,
  note text,
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);
create index if not exists shop_payouts_shop_idx on public.shop_payouts (shop_id, created_at desc);
alter table public.shop_payouts enable row level security;
revoke all on public.shop_payouts from anon, authenticated;

alter table public.shop_orders add column if not exists payment_fee numeric(14,2);

-- ------------------------------------------------------------ balance

create or replace function private.platform_pay_balance(p_shop uuid) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  with o as (
    select coalesce(sum(coalesce(paid_amount, total_amount)), 0) gross,
           coalesce(sum(coalesce(payment_fee, 0)), 0) fees,
           count(*) n
      from public.shop_orders
     where shop_id = p_shop and payment_provider = 'mogtama3y' and payment_status = 'paid' and status <> 'cancelled'
  ), c as (
    select coalesce((select commission_pct from public.shop_platform_pay where shop_id = p_shop),
                    (select commission_pct from public.platform_pay_settings where id = 1), 0) pct
  ), p as (
    select coalesce(sum(amount), 0) paid from public.shop_payouts where shop_id = p_shop
  )
  select jsonb_build_object(
    'orders', o.n,
    'gross', o.gross,
    'fees', o.fees,
    'commission_pct', c.pct,
    'commission', round(o.gross * c.pct / 100, 2),
    'paid_out', p.paid,
    'due', round(o.gross - o.fees - o.gross * c.pct / 100 - p.paid, 2),
    'currency', coalesce((select currency from public.shops where id = p_shop), 'EGP'))
  from o, c, p
$$;

-- ------------------------------------------------------------ merchant

create or replace function public.platform_pay_get(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  a public.shop_platform_pay;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  select * into a from public.shop_platform_pay where shop_id = p_shop;
  return jsonb_build_object(
    'application', case when a.shop_id is null then null else to_jsonb(a) - 'reviewed_by' end,
    'balance', private.platform_pay_balance(p_shop),
    'payouts', coalesce((select jsonb_agg(jsonb_build_object('amount', amount, 'currency', currency, 'method', method, 'reference', reference, 'note', note, 'created_at', created_at) order by created_at desc)
                           from public.shop_payouts where shop_id = p_shop), '[]'::jsonb));
end;
$$;

-- Apply (or re-apply after a rejection / to update the payout details).
-- p: {entity, legal_name, id_number, tax_number?, documents: [path…], payout: {method, …}}
create or replace function public.platform_pay_apply(p_shop uuid, p jsonb) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_entity text := coalesce(p ->> 'entity', '');
  v_name text := left(btrim(coalesce(p ->> 'legal_name', '')), 150);
  v_id text := left(regexp_replace(coalesce(p ->> 'id_number', ''), '\s', '', 'g'), 40);
  v_tax text := nullif(left(regexp_replace(coalesce(p ->> 'tax_number', ''), '\s', '', 'g'), 40), '');
  v_docs jsonb := coalesce(p -> 'documents', '[]'::jsonb);
  v_payout jsonb := coalesce(p -> 'payout', '{}'::jsonb);
  v_method text := coalesce(v_payout ->> 'method', '');
  v_doc text;
  v_cur public.shop_platform_pay;
  v_shop record;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if v_entity not in ('individual', 'company') then
    raise exception 'اختار فرد ولا شركة';
  end if;
  if length(v_name) < 3 then
    raise exception 'اكتب الاسم زي ما هو في البطاقة / السجل التجاري';
  end if;
  if v_entity = 'individual' and v_id !~ '^[0-9]{14}$' then
    raise exception 'الرقم القومي 14 رقم';
  end if;
  if v_entity = 'company' and length(v_id) < 3 then
    raise exception 'اكتب رقم السجل التجاري';
  end if;
  if v_entity = 'company' and v_tax is null then
    raise exception 'اكتب رقم البطاقة الضريبية';
  end if;
  if jsonb_typeof(v_docs) <> 'array' or jsonb_array_length(v_docs) < 2 or jsonb_array_length(v_docs) > 8 then
    raise exception 'ارفع صور الأوراق المطلوبة (من 2 لـ 8 صور)';
  end if;
  for v_doc in select jsonb_array_elements_text(v_docs) loop
    -- Only files the owner uploaded to their own private folder.
    if v_doc !~ ('^' || auth.uid()::text || '/platform_pay/[A-Za-z0-9._-]{1,120}$') then
      raise exception 'ملف مش صحيح — ارفع الصور تاني';
    end if;
  end loop;
  if v_method not in ('instapay', 'wallet', 'bank') then
    raise exception 'اختار هتستلم فلوسك إزاي';
  end if;
  if v_method = 'instapay' and coalesce(v_payout ->> 'handle', '') !~* '^([a-z0-9._-]{2,40}@instapay|https://ipn\.eg/s/[a-z0-9/_.-]{3,120})$' then
    raise exception 'عنوان InstaPay مش صحيح — زي name@instapay';
  end if;
  if v_method = 'wallet' and private.phone_store(v_payout ->> 'number', 'EG') is null then
    raise exception 'رقم المحفظة مش صحيح';
  end if;
  if v_method = 'bank' and (length(coalesce(v_payout ->> 'bank_name', '')) < 2 or not public.iban_ok(v_payout ->> 'iban')) then
    raise exception 'اكتب اسم البنك و IBAN صحيح';
  end if;

  select * into v_cur from public.shop_platform_pay where shop_id = p_shop for update;
  if v_cur.status = 'suspended' then
    raise exception 'الدفع عن طريق مُجتمعي متوقف لمتجرك — كلّم الدعم';
  end if;

  insert into public.shop_platform_pay (shop_id, status, entity, legal_name, id_number, tax_number, documents, payout, submitted_at, review_note, reviewed_at)
  values (p_shop, 'pending', v_entity, v_name, v_id, v_tax, v_docs,
          jsonb_strip_nulls(jsonb_build_object('method', v_method, 'handle', lower(v_payout ->> 'handle'),
            'number', private.phone_store(v_payout ->> 'number', 'EG'), 'bank_name', v_payout ->> 'bank_name',
            'account_name', v_payout ->> 'account_name', 'iban', upper(regexp_replace(coalesce(v_payout ->> 'iban', ''), '\s', '', 'g')))),
          now(), null, null)
  on conflict (shop_id) do update set
    -- An approved store that only changes its payout stays approved.
    status = case when public.shop_platform_pay.status = 'approved'
                       and public.shop_platform_pay.entity = excluded.entity
                       and public.shop_platform_pay.legal_name = excluded.legal_name
                       and public.shop_platform_pay.id_number = excluded.id_number
                       and public.shop_platform_pay.documents = excluded.documents
                  then 'approved' else 'pending' end,
    entity = excluded.entity, legal_name = excluded.legal_name, id_number = excluded.id_number,
    tax_number = excluded.tax_number, documents = excluded.documents, payout = excluded.payout,
    submitted_at = now(), review_note = null;

  select name into v_shop from public.shops where id = p_shop;
  insert into public.notifications (user_id, title, body)
  select pr.id, '🧾 طلب تشغيل دفع أونلاين — ' || v_shop.name, v_name || ' بعت أوراقه — راجعها من لوحة التحكم ← الدفع عن طريق مُجتمعي.'
    from public.profiles pr where pr.role = 'super_admin';
  return public.platform_pay_get(p_shop);
end;
$$;

-- ------------------------------------------------------------ admin

create or replace function public.admin_platform_pay_list(p_status text default null) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  return coalesce((
    select jsonb_agg(jsonb_build_object(
             'shop_id', a.shop_id, 'shop_name', s.name, 'slug', s.slug, 'owner_name', o.full_name, 'owner_phone', o.phone,
             'status', a.status, 'entity', a.entity, 'legal_name', a.legal_name, 'id_number', a.id_number, 'tax_number', a.tax_number,
             'documents', a.documents, 'payout', a.payout, 'commission_pct', a.commission_pct, 'review_note', a.review_note,
             'submitted_at', a.submitted_at, 'reviewed_at', a.reviewed_at, 'balance', private.platform_pay_balance(a.shop_id))
           order by (a.status = 'pending') desc, a.submitted_at desc)
      from public.shop_platform_pay a
      join public.shops s on s.id = a.shop_id
      left join public.profiles o on o.id = s.owner_id
     where p_status is null or a.status = p_status), '[]'::jsonb);
end;
$$;

-- p_action: approve | reject | suspend. A rejection / suspension needs a note (sent to the owner).
create or replace function public.admin_platform_pay_review(p_shop uuid, p_action text, p_note text default null) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  a public.shop_platform_pay;
  v_note text := nullif(left(btrim(coalesce(p_note, '')), 400), '');
  v_status text := case p_action when 'approve' then 'approved' when 'reject' then 'rejected' when 'suspend' then 'suspended' end;
  v_shop record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  if v_status is null then
    raise exception 'إجراء غير معروف';
  end if;
  if v_status <> 'approved' and v_note is null then
    raise exception 'اكتب السبب — بيوصل للتاجر';
  end if;
  select * into a from public.shop_platform_pay where shop_id = p_shop for update;
  if not found then
    raise exception 'مفيش طلب للمتجر ده';
  end if;
  update public.shop_platform_pay set status = v_status, review_note = v_note, reviewed_at = now(), reviewed_by = auth.uid() where shop_id = p_shop;
  select s.name, s.owner_id into v_shop from public.shops s where s.id = p_shop;
  if v_shop.owner_id is not null then
    insert into public.notifications (user_id, title, body)
    values (v_shop.owner_id,
            case v_status when 'approved' then '✅ الدفع الأونلاين اتفعّل لمتجرك «' || v_shop.name || '»'
                          when 'rejected' then '⚠️ طلب الدفع الأونلاين محتاج تعديل'
                          else '⛔ الدفع الأونلاين عن طريق مُجتمعي اتوقف لمتجرك' end,
            case v_status when 'approved' then 'زباينك يقدروا يدفعوا أونلاين دلوقتي، والفلوس بتتحوّلك من مُجتمعي.'
                          else 'السبب: ' || v_note end);
  end if;
end;
$$;

create or replace function public.admin_platform_balances() returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  return coalesce((
    select jsonb_agg(x order by (x -> 'balance' ->> 'due')::numeric desc)
      from (select jsonb_build_object('shop_id', a.shop_id, 'shop_name', s.name, 'status', a.status, 'legal_name', a.legal_name,
                                      'payout', a.payout, 'balance', private.platform_pay_balance(a.shop_id)) x
              from public.shop_platform_pay a join public.shops s on s.id = a.shop_id) b), '[]'::jsonb);
end;
$$;

create or replace function public.admin_record_payout(p_shop uuid, p_amount numeric, p_method text default null, p_reference text default null, p_note text default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_bal jsonb;
  v_shop record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  if p_amount is null or p_amount <= 0 then
    raise exception 'المبلغ لازم يكون أكبر من صفر';
  end if;
  v_bal := private.platform_pay_balance(p_shop);
  if p_amount > (v_bal ->> 'due')::numeric + 0.009 then
    raise exception 'المبلغ أكبر من مستحقات التاجر (%)', v_bal ->> 'due';
  end if;
  insert into public.shop_payouts (shop_id, amount, currency, method, reference, note, created_by)
  values (p_shop, round(p_amount, 2), v_bal ->> 'currency', left(p_method, 40), left(p_reference, 120), left(p_note, 300), auth.uid());
  select s.name, s.owner_id into v_shop from public.shops s where s.id = p_shop;
  if v_shop.owner_id is not null then
    insert into public.notifications (user_id, title, body)
    values (v_shop.owner_id, '💸 اتحوّلك ' || private.money_text(round(p_amount, 2), v_bal ->> 'currency'),
            'مُجتمعي حوّلت مستحقات متجرك «' || v_shop.name || '»' || coalesce(' — مرجع التحويل: ' || nullif(p_reference, ''), '') || '.');
  end if;
  return private.platform_pay_balance(p_shop);
end;
$$;

-- ------------------------------------------------------------ checkout

-- 0097's methods + «مُجتمعي» when the store's application is approved.
create or replace function public.shop_checkout_methods(p_shop uuid) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'cod', coalesce(ps.cod_enabled, true),
    'instapay', case when coalesce((ps.manual #>> '{instapay,enabled}')::boolean, false) then ps.manual #>> '{instapay,handle}' end,
    'wallet', case when coalesce((ps.manual #>> '{wallet,enabled}')::boolean, false)
                   then jsonb_build_object('number', ps.manual #>> '{wallet,number}', 'label', ps.manual #>> '{wallet,label}') end,
    'bank', case when coalesce((ps.manual #>> '{bank,enabled}')::boolean, false)
                 then (ps.manual -> 'bank') - 'enabled' end,
    'online', coalesce((select jsonb_agg(jsonb_build_object('provider', g.provider, 'mode', g.mode,
                                 'publishable_key', coalesce(g.public_cfg ->> 'publishable_key', g.public_cfg ->> 'public_key')))
                        from public.shop_payment_gateways g
                        where g.shop_id = s.id and g.enabled and g.status = 'connected'), '[]'::jsonb)
              || case when exists (select 1 from public.shop_platform_pay a where a.shop_id = s.id and a.status = 'approved')
                      then jsonb_build_array(jsonb_build_object('provider', 'mogtama3y', 'mode', 'live')) else '[]'::jsonb end)
  from public.shops s
  left join public.shop_payment_settings ps on ps.shop_id = s.id
  where s.id = p_shop and s.owner_id is not null
$$;

-- 0100's payment_begin; 'mogtama3y' needs an approved application
-- instead of a connected gateway (the platform's own Fawaterak, EGP).
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
  -- 'auto' (the storefront doesn't name one): the order's own provider while
  -- the store still takes it, else the store's own Fawaterak, else «مُجتمعي».
  if p_provider is null or p_provider = 'auto' then
    select c into p_provider
      from unnest(array[o.payment_provider, 'fawaterak', 'mogtama3y']) with ordinality as t(c, i)
     where (c = 'mogtama3y' and exists (select 1 from public.shop_platform_pay a where a.shop_id = o.shop_id and a.status = 'approved'))
        or (c = 'fawaterak' and exists (select 1 from public.shop_payment_gateways g
                                         where g.shop_id = o.shop_id and g.provider = 'fawaterak' and g.enabled and g.status = 'connected'))
     order by i limit 1;
    p_provider := coalesce(p_provider, 'fawaterak');
  end if;
  if p_provider = 'mogtama3y' then
    if exists (select 1 from public.shop_platform_pay a where a.shop_id = o.shop_id and a.status = 'approved') then
      v_mode := 'live';
    end if;
  else
    select g.mode into v_mode from public.shop_payment_gateways g
     where g.shop_id = o.shop_id and g.provider = p_provider and g.enabled and g.status = 'connected';
  end if;
  if v_mode is null then
    return jsonb_build_object('error', 'المحل ده مش مفعّل الدفع الأونلاين دلوقتي — اختار الدفع عند الاستلام');
  end if;
  if not (o.currency = any (coalesce(private.gateway_currencies(case when p_provider = 'mogtama3y' then 'fawaterak' else p_provider end), array[o.currency]))) then
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
    'shop_name', o.shop_name, 'mode', v_mode, 'payment_status', 'awaiting', 'provider', p_provider,
    'invoice_id', case when o.payment_provider = p_provider then o.payment_invoice_id end,
    'payment_url', case when o.payment_provider = p_provider then o.payment_url end,
    'payment_data', case when o.payment_provider = p_provider then o.payment_data end);
end;
$$;

create or replace function private.payment_provider_name(p text) returns text
language sql immutable as $$
  select case p when 'fawaterak' then 'فواتيرك' when 'mogtama3y' then 'مُجتمعي' when 'paymob' then 'Paymob' when 'kashier' then 'Kashier'
                when 'tap' then 'Tap' when 'moyasar' then 'Moyasar' else coalesce(p, 'أونلاين') end
$$;

-- 0100's payment_settle, same signature, with the «مُجتمعي» wording.
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

  if p_amount is null or abs(p_amount - o.total_amount) > 0.01 or upper(coalesce(p_currency, o.currency)) <> o.currency then
    insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
    values (o.id, o.shop_id, 'payment',
            'وصل دفع بمبلغ مش مطابق للطلب (' || coalesce(p_amount::text, '?') || ' ' || coalesce(upper(p_currency), '') || ') — راجعه في لوحة ' || private.payment_provider_name(p_provider),
            'system');
    return jsonb_build_object('ok', false, 'code', o.order_code, 'reason', 'amount_mismatch');
  end if;

  update public.shop_orders
     set payment_status = 'paid', paid_at = now(), paid_amount = p_amount, payment_invoice_id = p_invoice_id
   where id = o.id;
  insert into public.shop_order_events (order_id, shop_id, kind, body, actor_role)
  values (o.id, o.shop_id, 'payment',
          'اتدفع أونلاين ✓ ' || private.money_text(p_amount, o.currency) || ' عن طريق ' || private.payment_provider_name(p_provider)
            || coalesce(' (' || v_how || ')', ''),
          'system');
  insert into public.notifications (user_id, title, body)
  values (o.owner_id, '💳 اتدفع الطلب ' || o.order_code || ' — ' || o.shop_name,
          coalesce(o.customer_name, 'الزبون') || ' دفع ' || private.money_text(p_amount, o.currency) || ' أونلاين'
            || case when o.status = 'cancelled' then '، بس الطلب ملغي — ' ||
                      case when p_provider = 'mogtama3y' then 'مُجتمعي هترجّع للزبون فلوسه.' else 'رجّعله فلوسه من لوحة ' || private.payment_provider_name(p_provider) || '.' end
                    when p_provider = 'mogtama3y' then '. الفلوس عند مُجتمعي وهتتحوّلك — جهّز الطلب.'
                    else '. الفلوس في حسابك على ' || private.payment_provider_name(p_provider) || ' — جهّز الطلب.' end);
  return jsonb_build_object('ok', true, 'code', o.order_code, 'status', 'paid');
end;
$$;

-- Fawaterak's fee on a paid transaction (Edge Functions, after payment_settle).
create or replace function public.payment_record_fee(p_shop uuid, p_provider text, p_invoice_id text, p_fee numeric) returns void
language sql
security definer
set search_path = public
as $$
  update public.shop_orders
     set payment_fee = round(p_fee, 2)
   where shop_id = p_shop and payment_provider = p_provider and payment_invoice_id = p_invoice_id
     and payment_status = 'paid' and p_fee is not null and p_fee >= 0 and p_fee < coalesce(paid_amount, total_amount);
$$;

-- ------------------------------------------------------------ grants

do $$
declare
  f text;
begin
  foreach f in array array[
    'public.platform_pay_get(uuid)',
    'public.platform_pay_apply(uuid, jsonb)',
    'public.admin_platform_pay_list(text)',
    'public.admin_platform_pay_review(uuid, text, text)',
    'public.admin_platform_balances()',
    'public.admin_record_payout(uuid, numeric, text, text, text)'] loop
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
  foreach f in array array[
    'public.payment_begin(text, text, text)',
    'public.payment_settle(uuid, text, text, boolean, numeric, text, text, text)',
    'public.payment_record_fee(uuid, text, text, numeric)'] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
    execute format('grant execute on function %s to service_role', f);
  end loop;
end;
$$;
