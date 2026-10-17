-- =====================================================================
-- Migration 0097 — متجري «الربط والتكاملات»: payments, domain, pixels.
--
-- Owner decision (Shopify model): every merchant connects THEIR OWN
-- payment gateway and the money goes straight to the merchant — the
-- platform never holds funds. This migration is the connection/settings
-- layer; the online checkout itself is Phase 4, serving stores on custom
-- domains is Phase 5 (Cloudflare for SaaS).
--
--   * shop_payment_settings: cash on delivery + manual methods (InstaPay,
--     mobile wallet, bank transfer). Owner-only read; writes through
--     set_shop_payment_settings().
--   * shop_payment_gateways: one row per connected gateway (Paymob,
--     Kashier, Tap, Moyasar) — mode, public config, status, «…abcd»
--     hints. NO secrets: those live in private.shop_gateway_secrets
--     (no client role can read the private schema). set_shop_gateway()
--     is write-only for secrets; reads return has_secret + last 4 only.
--     Only the Edge Functions (service role) read the secrets, through
--     gateway_credentials().
--   * shop_payment_events: what payments-webhook received (signature
--     checked), owner-readable. Orders are NOT changed yet (Phase 4).
--   * shop_domains: «اربط دومين عندك» — one per shop for now, unique
--     hostname, TXT token; domains-verify (Edge Function, Deno.resolveDns)
--     records the result with domain_record_check(). verified ≠ active:
--     the platform turns serving on in Phase 5.
--   * shops.tracking jsonb: Meta / TikTok / Snapchat pixels, GA4, GTM,
--     Google Ads, Facebook domain-verification. Public by nature (the
--     storefront loads them); a check constraint keeps the formats valid
--     even for direct table updates.
--   * shop_checkout_methods(): what a customer may see at checkout
--     (Phase 4) — never secrets.
--   * integration_rate_hit(): owner check + hourly limit for the Edge
--     Functions («اختبر الاتصال», «تحقق دلوقتي»).
-- Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ------------------------------------------------------------ helpers

-- Whose shop: true when the signed-in user owns it.
create or replace function public.i_own_shop(p_shop uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select auth.uid() is not null and exists (select 1 from public.shops s where s.id = p_shop and s.owner_id = auth.uid())
$$;

-- Gateways and the countries they serve (shops.country, 0092).
create or replace function private.gateway_countries(p_provider text) returns text[]
language sql immutable as $$
  select case p_provider
    when 'paymob'  then array['EG', 'SA', 'AE', 'OM']
    when 'kashier' then array['EG']
    when 'tap'     then array['SA', 'AE', 'KW', 'QA', 'BH', 'OM', 'EG', 'JO']
    when 'moyasar' then array['SA']
    else array[]::text[] end
$$;

create or replace function private.gateways_for_country(p_country text) returns text[]
language sql immutable as $$
  select coalesce(array_agg(p order by o), array[]::text[])
  from unnest(array['paymob', 'kashier', 'tap', 'moyasar']) with ordinality as g(p, o)
  where upper(coalesce(p_country, 'EG')) = any (private.gateway_countries(p))
$$;

-- IBAN (ISO 13616): shape + mod-97 checksum.
create or replace function public.iban_ok(p text) returns boolean
language plpgsql immutable as $$
declare
  s text := upper(regexp_replace(coalesce(p, ''), '\s', '', 'g'));
  d text;
  r int := 0;
  i int;
  j int;
begin
  if s !~ '^[A-Z]{2}[0-9]{2}[A-Z0-9]{10,30}$' then
    return false;
  end if;
  s := substr(s, 5) || substr(s, 1, 4);
  for i in 1 .. length(s) loop
    d := substr(s, i, 1);
    if d ~ '[A-Z]' then
      d := (ascii(d) - 55)::text;
    end if;
    for j in 1 .. length(d) loop
      r := (r * 10 + substr(d, j, 1)::int) % 97;
    end loop;
  end loop;
  return r = 1;
end;
$$;
grant execute on function public.iban_ok(text) to anon, authenticated;

-- «…abcd» for a secret (never more than the last 4).
create or replace function private.hint(p text) returns text
language sql immutable as $$
  select case when p is null or p = '' then null when length(p) <= 8 then '••••' else '…' || right(p, 4) end
$$;

-- ---------------------------------------------- 1. payments: settings

create table if not exists public.shop_payment_settings (
  shop_id uuid primary key references public.shops(id) on delete cascade,
  cod_enabled boolean not null default true,
  -- {instapay:{enabled,handle}, wallet:{enabled,number,label}, bank:{enabled,bank_name,account_name,iban}}
  manual jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.shop_payment_settings enable row level security;
revoke all on public.shop_payment_settings from anon, authenticated;
grant select on public.shop_payment_settings to authenticated;
drop policy if exists "shop_payment_settings: owner reads" on public.shop_payment_settings;
create policy "shop_payment_settings: owner reads" on public.shop_payment_settings
  for select to authenticated using (public.i_own_shop(shop_id));

create table if not exists public.shop_payment_gateways (
  shop_id uuid not null references public.shops(id) on delete cascade,
  provider text not null check (provider in ('paymob', 'kashier', 'tap', 'moyasar')),
  mode text not null default 'test' check (mode in ('test', 'live')),
  enabled boolean not null default true,
  public_cfg jsonb not null default '{}'::jsonb,
  secret_hint jsonb not null default '{}'::jsonb,
  status text not null default 'pending' check (status in ('pending', 'connected', 'error')),
  last_error text,
  last_checked_at timestamptz,
  connected_at timestamptz,
  -- Ours, for gateways whose webhook carries a shared token (Moyasar's
  -- secret_token): the merchant pastes it in their gateway dashboard.
  webhook_token text not null default replace(gen_random_uuid()::text, '-', ''),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (shop_id, provider)
);
alter table public.shop_payment_gateways enable row level security;
revoke all on public.shop_payment_gateways from anon, authenticated;
grant select on public.shop_payment_gateways to authenticated;
drop policy if exists "shop_payment_gateways: owner reads" on public.shop_payment_gateways;
create policy "shop_payment_gateways: owner reads" on public.shop_payment_gateways
  for select to authenticated using (public.i_own_shop(shop_id));

-- The secrets. Private schema: no API role can even see the table.
create table if not exists private.shop_gateway_secrets (
  shop_id uuid not null references public.shops(id) on delete cascade,
  provider text not null,
  secret_cfg jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (shop_id, provider)
);
revoke all on private.shop_gateway_secrets from public, anon, authenticated;

create table if not exists public.shop_payment_events (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  provider text not null,
  event_type text,
  external_id text,
  signature_ok boolean not null default false,
  payload jsonb,
  received_at timestamptz not null default now()
);
create index if not exists shop_payment_events_shop_idx on public.shop_payment_events (shop_id, received_at desc);
create unique index if not exists shop_payment_events_dedup on public.shop_payment_events (shop_id, provider, external_id, event_type)
  where external_id is not null;
alter table public.shop_payment_events enable row level security;
revoke all on public.shop_payment_events from anon, authenticated;
grant select on public.shop_payment_events to authenticated;
drop policy if exists "shop_payment_events: owner reads" on public.shop_payment_events;
create policy "shop_payment_events: owner reads" on public.shop_payment_events
  for select to authenticated using (public.i_own_shop(shop_id));

grant select, insert, update, delete on public.shop_payment_settings, public.shop_payment_gateways, public.shop_payment_events to service_role;

-- Field rules per gateway: {public: {field: regex}, secret: {...}, required: [...]}.
create or replace function private.gateway_fields(p_provider text) returns jsonb
language sql immutable as $$
  select case p_provider
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

-- The owner's (and only the owner's) view of a gateway row: no secrets.
create or replace function private.gateway_view(g public.shop_payment_gateways) returns jsonb
language sql stable as $$
  select jsonb_build_object(
    'provider', g.provider, 'mode', g.mode, 'enabled', g.enabled, 'public', g.public_cfg,
    'has_secret', exists (select 1 from private.shop_gateway_secrets s where s.shop_id = g.shop_id and s.provider = g.provider and s.secret_cfg <> '{}'::jsonb),
    'secret_hint', g.secret_hint, 'status', g.status, 'last_error', g.last_error,
    'last_checked_at', g.last_checked_at, 'connected_at', g.connected_at, 'webhook_token', g.webhook_token)
$$;

create or replace function public.set_shop_payment_settings(p_shop uuid, p_cod boolean, p_manual jsonb default '{}'::jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_country text;
  m jsonb := coalesce(p_manual, '{}'::jsonb);
  v_out jsonb := '{}'::jsonb;
  v jsonb;
  v_handle text;
  v_phone text;
  v_iban text;
  v_any boolean;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if jsonb_typeof(m) <> 'object' then
    raise exception 'بيانات طرق الدفع مش صحيحة';
  end if;
  select country into v_country from public.shops where id = p_shop;

  -- InstaPay: name@instapay (we add @instapay) or an ipn.eg payment link.
  v := m -> 'instapay';
  if v is not null and jsonb_typeof(v) = 'object' then
    v_handle := btrim(coalesce(v ->> 'handle', ''));
    -- Payment links keep their case (the path may be case-sensitive).
    if v_handle !~* '^https://' then
      v_handle := lower(v_handle);
      if v_handle <> '' and v_handle !~ '@' then
        v_handle := v_handle || '@instapay';
      end if;
    end if;
    if coalesce((v ->> 'enabled')::boolean, false) or v_handle <> '' then
      if v_handle !~ '^[a-z0-9._-]{2,40}@instapay$' and v_handle !~* '^https://ipn\.eg/s/[a-z0-9/_.-]{3,120}$' then
        raise exception 'عنوان InstaPay مش صحيح — اكتبه زي name@instapay أو لينك ipn.eg';
      end if;
    end if;
    v_out := v_out || jsonb_build_object('instapay', jsonb_build_object(
      'enabled', coalesce((v ->> 'enabled')::boolean, false), 'handle', nullif(v_handle, '')));
  end if;

  -- Mobile wallet (Vodafone Cash, Orange, STC Pay …): a mobile of the shop's country.
  v := m -> 'wallet';
  if v is not null and jsonb_typeof(v) = 'object' then
    v_phone := nullif(btrim(coalesce(v ->> 'number', '')), '');
    if v_phone is not null then
      v_phone := private.phone_store(v_phone, v_country);
      if v_phone is null then
        raise exception 'رقم المحفظة مش صحيح';
      end if;
    elsif coalesce((v ->> 'enabled')::boolean, false) then
      raise exception 'اكتب رقم المحفظة';
    end if;
    if length(coalesce(v ->> 'label', '')) > 40 then
      raise exception 'اسم المحفظة طويل';
    end if;
    v_out := v_out || jsonb_build_object('wallet', jsonb_build_object(
      'enabled', coalesce((v ->> 'enabled')::boolean, false), 'number', v_phone,
      'label', nullif(btrim(coalesce(v ->> 'label', '')), '')));
  end if;

  -- Bank transfer: bank, account holder, IBAN (checksum).
  v := m -> 'bank';
  if v is not null and jsonb_typeof(v) = 'object' then
    v_iban := nullif(upper(regexp_replace(coalesce(v ->> 'iban', ''), '\s', '', 'g')), '');
    if coalesce((v ->> 'enabled')::boolean, false) then
      if length(btrim(coalesce(v ->> 'bank_name', ''))) < 2 then raise exception 'اكتب اسم البنك'; end if;
      if length(btrim(coalesce(v ->> 'account_name', ''))) < 2 then raise exception 'اكتب اسم صاحب الحساب'; end if;
      if v_iban is null then raise exception 'اكتب رقم الـ IBAN'; end if;
    end if;
    if v_iban is not null and not public.iban_ok(v_iban) then
      raise exception 'رقم الـ IBAN مش صحيح — راجعه من البنك أو من تطبيق البنك';
    end if;
    if length(coalesce(v ->> 'bank_name', '')) > 60 or length(coalesce(v ->> 'account_name', '')) > 80 then
      raise exception 'اسم البنك أو صاحب الحساب طويل';
    end if;
    v_out := v_out || jsonb_build_object('bank', jsonb_build_object(
      'enabled', coalesce((v ->> 'enabled')::boolean, false),
      'bank_name', nullif(btrim(coalesce(v ->> 'bank_name', '')), ''),
      'account_name', nullif(btrim(coalesce(v ->> 'account_name', '')), ''),
      'iban', v_iban));
  end if;

  v_any := coalesce(p_cod, true)
    or coalesce((v_out #>> '{instapay,enabled}')::boolean, false)
    or coalesce((v_out #>> '{wallet,enabled}')::boolean, false)
    or coalesce((v_out #>> '{bank,enabled}')::boolean, false)
    or exists (select 1 from public.shop_payment_gateways g where g.shop_id = p_shop and g.enabled and g.status = 'connected');
  if not v_any then
    raise exception 'لازم تسيب طريقة دفع واحدة على الأقل شغالة';
  end if;

  insert into public.shop_payment_settings (shop_id, cod_enabled, manual, updated_at)
  values (p_shop, coalesce(p_cod, true), v_out, now())
  on conflict (shop_id) do update set cod_enabled = excluded.cod_enabled, manual = excluded.manual, updated_at = now();
  return public.get_shop_integrations(p_shop);
end;
$$;

-- Connect / update a gateway. Secret fields left out (or null / '') keep
-- the saved value, so editing an integration id needs no re-typing.
create or replace function public.set_shop_gateway(
  p_shop uuid, p_provider text, p_public jsonb, p_secret jsonb, p_mode text default 'test'
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_country text;
  v_rules jsonb := private.gateway_fields(p_provider);
  v_pub jsonb := '{}'::jsonb;
  v_sec jsonb;
  v_hint jsonb := '{}'::jsonb;
  k text;
  val text;
  v_req text;
  v_mode text := coalesce(p_mode, 'test');
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if v_rules is null then
    raise exception 'بوابة الدفع دي مش مدعومة';
  end if;
  if v_mode not in ('test', 'live') then
    raise exception 'اختار تجريبي أو حقيقي';
  end if;
  select country into v_country from public.shops where id = p_shop;
  if not (upper(coalesce(v_country, 'EG')) = any (private.gateway_countries(p_provider))) then
    raise exception 'بوابة الدفع دي مش متاحة في دولة متجرك';
  end if;
  if p_public is not null and jsonb_typeof(p_public) <> 'object' or p_secret is not null and jsonb_typeof(p_secret) <> 'object' then
    raise exception 'البيانات مش صحيحة';
  end if;

  -- Public fields: only the known ones, each matching its format.
  for k, val in select key, btrim(value) from jsonb_each_text(coalesce(p_public, '{}'::jsonb)) loop
    if not (v_rules -> 'public') ? k then
      raise exception 'حقل غير معروف: %', k;
    end if;
    if length(val) > 1000 then raise exception 'الحقل «%» طويل قوي', k; end if;
    if val <> '' then
      if val !~ (v_rules #>> array['public', k]) then
        raise exception 'الحقل «%» مش بالشكل الصحيح — انسخه زي ما هو من لوحة البوابة', k;
      end if;
      v_pub := v_pub || jsonb_build_object(k, val);
    end if;
  end loop;

  -- Secrets: merged over what is saved.
  select secret_cfg into v_sec from private.shop_gateway_secrets where shop_id = p_shop and provider = p_provider;
  v_sec := coalesce(v_sec, '{}'::jsonb);
  for k, val in select key, btrim(value) from jsonb_each_text(coalesce(p_secret, '{}'::jsonb)) loop
    if not (v_rules -> 'secret') ? k then
      raise exception 'حقل غير معروف: %', k;
    end if;
    if length(val) > 1000 then raise exception 'الحقل «%» طويل قوي', k; end if;
    if val <> '' then
      if val !~ (v_rules #>> array['secret', k]) then
        raise exception 'الحقل «%» مش بالشكل الصحيح — انسخه زي ما هو من لوحة البوابة', k;
      end if;
      v_sec := v_sec || jsonb_build_object(k, val);
    end if;
  end loop;

  for v_req in select jsonb_array_elements_text(v_rules -> 'required') loop
    if not (v_pub ? v_req or v_sec ? v_req) then
      raise exception 'الحقل «%» مطلوب', v_req;
    end if;
  end loop;

  -- Keys that say test/live must match the chosen mode.
  for k, val in select key, value from jsonb_each_text(v_pub || v_sec) loop
    if (val ~ '_(pk|sk)_test_' or val ~ '^(pk|sk)_test_') and v_mode = 'live'
       or (val ~ '_(pk|sk)_live_' or val ~ '^(pk|sk)_live_') and v_mode = 'test' then
      raise exception 'المفتاح «%» مش متوافق مع الوضع (%)', k, case v_mode when 'live' then 'حقيقي' else 'تجريبي' end;
    end if;
  end loop;

  for k, val in select key, value from jsonb_each_text(v_sec) loop
    v_hint := v_hint || jsonb_build_object(k, private.hint(val));
  end loop;

  insert into private.shop_gateway_secrets (shop_id, provider, secret_cfg, updated_at)
  values (p_shop, p_provider, v_sec, now())
  on conflict (shop_id, provider) do update set secret_cfg = excluded.secret_cfg, updated_at = now();

  insert into public.shop_payment_gateways (shop_id, provider, mode, public_cfg, secret_hint, status, last_error, updated_at)
  values (p_shop, p_provider, v_mode, v_pub, v_hint, 'pending', null, now())
  on conflict (shop_id, provider) do update
    set mode = excluded.mode, public_cfg = excluded.public_cfg, secret_hint = excluded.secret_hint,
        status = 'pending', last_error = null, enabled = true, updated_at = now();

  return public.get_shop_integrations(p_shop);
end;
$$;

create or replace function public.disconnect_shop_gateway(p_shop uuid, p_provider text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  delete from private.shop_gateway_secrets where shop_id = p_shop and provider = p_provider;
  delete from public.shop_payment_gateways where shop_id = p_shop and provider = p_provider;
  -- Nothing left to pay with? Cash on delivery comes back on.
  if not exists (select 1 from public.shop_payment_gateways g where g.shop_id = p_shop and g.enabled and g.status = 'connected')
     and exists (select 1 from public.shop_payment_settings s where s.shop_id = p_shop and not s.cod_enabled
                   and not coalesce((s.manual #>> '{instapay,enabled}')::boolean, false)
                   and not coalesce((s.manual #>> '{wallet,enabled}')::boolean, false)
                   and not coalesce((s.manual #>> '{bank,enabled}')::boolean, false)) then
    update public.shop_payment_settings set cod_enabled = true, updated_at = now() where shop_id = p_shop;
  end if;
  return public.get_shop_integrations(p_shop);
end;
$$;

-- Edge Functions only (service role): the full credentials …
create or replace function public.gateway_credentials(p_shop uuid, p_provider text) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object('provider', g.provider, 'mode', g.mode, 'public', g.public_cfg,
           'secret', coalesce(s.secret_cfg, '{}'::jsonb), 'webhook_token', g.webhook_token,
           'country', (select country from public.shops where id = g.shop_id))
  from public.shop_payment_gateways g
  left join private.shop_gateway_secrets s on s.shop_id = g.shop_id and s.provider = g.provider
  where g.shop_id = p_shop and g.provider = p_provider
$$;

-- … and the «اختبر الاتصال» result.
create or replace function public.gateway_record_check(p_shop uuid, p_provider text, p_ok boolean, p_error text default null)
returns void
language sql security definer set search_path = public as $$
  update public.shop_payment_gateways
     set status = case when p_ok then 'connected' else 'error' end,
         last_error = case when p_ok then null else left(coalesce(p_error, 'فيه مشكلة'), 300) end,
         last_checked_at = now(),
         connected_at = case when p_ok then coalesce(connected_at, now()) else connected_at end
   where shop_id = p_shop and provider = p_provider
$$;

-- payments-webhook: one row per event (duplicates ignored).
create or replace function public.record_shop_payment_event(
  p_shop uuid, p_provider text, p_event_type text, p_external_id text, p_signature_ok boolean, p_payload jsonb
) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid;
begin
  if not exists (select 1 from public.shop_payment_gateways where shop_id = p_shop and provider = p_provider) then
    return null;
  end if;
  insert into public.shop_payment_events (shop_id, provider, event_type, external_id, signature_ok, payload)
  values (p_shop, p_provider, left(p_event_type, 80), left(p_external_id, 120), coalesce(p_signature_ok, false),
          case when length(coalesce(p_payload, '{}'::jsonb)::text) > 20000 then jsonb_build_object('truncated', true) else p_payload end)
  on conflict do nothing
  returning id into v_id;
  return v_id;
end;
$$;

-- ------------------------------------------------------- 2. domains

create table if not exists public.shop_domains (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null unique references public.shops(id) on delete cascade, -- 1 domain per shop for now
  hostname text not null unique,
  is_apex boolean not null default false,
  status text not null default 'pending' check (status in ('pending', 'verified', 'active', 'error')),
  verify_token text not null default ('mogtama3y-verify=' || replace(gen_random_uuid()::text, '-', '')),
  last_error text,
  last_checked_at timestamptz,
  check_count int not null default 0,
  created_at timestamptz not null default now(),
  verified_at timestamptz,
  constraint shop_domains_hostname_format check (hostname ~ '^[a-z0-9.-]{4,253}$')
);
alter table public.shop_domains enable row level security;
revoke all on public.shop_domains from anon, authenticated;
grant select on public.shop_domains to authenticated;
grant select, insert, update, delete on public.shop_domains to service_role;
drop policy if exists "shop_domains: owner reads" on public.shop_domains;
create policy "shop_domains: owner reads" on public.shop_domains
  for select to authenticated using (public.i_own_shop(shop_id));

-- Registrable suffixes with two labels (com.eg, com.sa …): the "apex" is one label under them.
create or replace function private.two_label_suffix(p text) returns boolean
language sql immutable as $$
  select p = any (array[
    'com.eg', 'net.eg', 'org.eg', 'edu.eg', 'gov.eg', 'sci.eg',
    'com.sa', 'net.sa', 'org.sa', 'edu.sa', 'med.sa',
    'co.ae', 'net.ae', 'org.ae', 'com.kw', 'net.kw', 'org.kw', 'com.qa', 'net.qa', 'com.bh', 'net.bh',
    'com.om', 'co.om', 'net.om', 'com.jo', 'net.jo', 'com.lb', 'net.lb', 'com.iq', 'com.ly', 'com.tn',
    'com.dz', 'co.ma', 'net.ma', 'com.sd', 'com.sy', 'com.ye', 'com.ps', 'co.uk', 'org.uk', 'com.tr', 'com.au'])
$$;

-- '' when fine, else the Arabic reason. Input must already be normalized.
create or replace function public.shop_hostname_problem(h text) returns text
language plpgsql immutable as $$
declare
  lbl text;
  n int := 0;
  tld text;
begin
  if h is null or h = '' then return 'اكتب الدومين'; end if;
  if h !~ '^[a-z0-9.-]+$' then
    return 'اكتب الدومين بالحروف الإنجليزية (الدومين العربي يتكتب بصيغة xn--)';
  end if;
  if length(h) > 253 then return 'الدومين طويل قوي'; end if;
  foreach lbl in array string_to_array(h, '.') loop
    n := n + 1;
    if lbl !~ '^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$' then
      return 'الدومين فيه جزء مش صحيح';
    end if;
    tld := lbl;
  end loop;
  if n < 2 then return 'الدومين لازم يبقى زي shop.example.com أو example.com'; end if;
  if tld !~ '^([a-z]{2,63}|xn--[a-z0-9-]{1,59})$' then
    return 'ده مش دومين (عناوين الـ IP مش مسموحة)';
  end if;
  if h = 'mogtama3y.com' or h like '%.mogtama3y.com' then
    return 'ده دومين مُجتمعي نفسه — اكتب دومين بتاعك';
  end if;
  if tld in ('localhost', 'local', 'test', 'example', 'invalid', 'internal', 'lan', 'home', 'onion') then
    return 'الدومين ده مينفعش يتوصل بالإنترنت';
  end if;
  return '';
end;
$$;
grant execute on function public.shop_hostname_problem(text) to anon, authenticated;

create or replace function public.add_shop_domain(p_shop uuid, p_hostname text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  h text := lower(btrim(coalesce(p_hostname, '')));
  v_problem text;
  v_parts text[];
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  h := regexp_replace(h, '^[a-z]+://', '');
  h := regexp_replace(h, '[/?#].*$', '');
  h := regexp_replace(h, '\.+$', '');
  if h ~ ':[0-9]*$' then
    raise exception 'اكتب الدومين من غير رقم بورت';
  end if;
  v_problem := public.shop_hostname_problem(h);
  if v_problem <> '' then
    raise exception '%', v_problem;
  end if;
  if exists (select 1 from public.shop_domains where shop_id = p_shop) then
    raise exception 'متجرك متربط بدومين فعلاً — امسحه الأول لو عايز تغيّره';
  end if;
  if exists (select 1 from public.shop_domains where hostname = h) then
    raise exception 'الدومين ده متربط بمتجر تاني';
  end if;
  v_parts := string_to_array(h, '.');
  insert into public.shop_domains (shop_id, hostname, is_apex)
  values (p_shop, h, array_length(v_parts, 1) = 2
                     or (array_length(v_parts, 1) = 3 and private.two_label_suffix(v_parts[2] || '.' || v_parts[3])));
  return public.get_shop_integrations(p_shop);
end;
$$;

create or replace function public.remove_shop_domain(p_shop uuid) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  delete from public.shop_domains where shop_id = p_shop;
  return public.get_shop_integrations(p_shop);
end;
$$;

-- domains-verify (service role) records what DNS said. Verified needs the
-- TXT token, plus (for a subdomain) the CNAME to stores.mogtama3y.com.
-- 'active' is set by the platform when serving starts (Phase 5).
create or replace function public.domain_record_check(p_shop uuid, p_txt_ok boolean, p_cname_ok boolean, p_error text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  d public.shop_domains;
begin
  select * into d from public.shop_domains where shop_id = p_shop;
  if not found then
    return null;
  end if;
  if d.status = 'active' then
    update public.shop_domains set last_checked_at = now(), check_count = check_count + 1 where id = d.id;
  elsif coalesce(p_txt_ok, false) and (d.is_apex or coalesce(p_cname_ok, false)) then
    update public.shop_domains set status = 'verified', verified_at = coalesce(verified_at, now()), last_error = null,
           last_checked_at = now(), check_count = check_count + 1 where id = d.id;
  else
    update public.shop_domains set status = case when d.status = 'verified' then 'error' else 'pending' end,
           last_error = left(coalesce(p_error, 'لسه مش لاقيين السجلات'), 300),
           last_checked_at = now(), check_count = check_count + 1 where id = d.id;
  end if;
  return (select to_jsonb(x) - 'shop_id' from public.shop_domains x where x.id = d.id);
end;
$$;

-- --------------------------------------------- rate limit (Edge Functions)

create table if not exists private.integration_hits (
  shop_id uuid not null,
  kind text not null,
  at timestamptz not null default now()
);
create index if not exists integration_hits_idx on private.integration_hits (shop_id, kind, at desc);
revoke all on private.integration_hits from public, anon, authenticated;

-- Called by the Edge Functions AS the user: proves ownership and counts.
create or replace function public.integration_rate_hit(p_shop uuid, p_kind text) returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_limit int := case p_kind when 'domain_verify' then 12 when 'gateway_test' then 20 else 0 end;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if v_limit = 0 then
    raise exception 'unknown kind';
  end if;
  if (select count(*) from private.integration_hits where shop_id = p_shop and kind = p_kind and at > now() - interval '1 hour') >= v_limit then
    raise exception 'جرّبت كتير — استنى شوية وجرّب تاني';
  end if;
  delete from private.integration_hits where at < now() - interval '1 day';
  insert into private.integration_hits (shop_id, kind) values (p_shop, p_kind);
  return true;
end;
$$;

-- ------------------------------------------------------- 3. tracking

-- '' when the jsonb is valid, else the Arabic reason. Used by the check
-- constraint (runs as the writing user: public schema, no private refs).
create or replace function public.shop_tracking_problem(t jsonb) returns text
language plpgsql immutable as $$
declare
  k text;
  v text;
  rules constant jsonb := jsonb_build_object(
    'meta_pixel', '^[0-9]{10,20}$',
    'tiktok_pixel', '^[A-Z0-9]{16,24}$',
    'snap_pixel', '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    'ga4', '^G-[A-Z0-9]{6,12}$',
    'gtm', '^GTM-[A-Z0-9]{5,9}$',
    'google_ads', '^AW-[0-9]{8,12}(/[A-Za-z0-9_-]{6,40})?$',
    'fb_domain_verification', '^[a-z0-9]{20,40}$');
  names constant jsonb := jsonb_build_object(
    'meta_pixel', 'Meta Pixel ID (أرقام بس)', 'tiktok_pixel', 'TikTok Pixel ID', 'snap_pixel', 'Snapchat Pixel ID',
    'ga4', 'Google Analytics (G-XXXXXXX)', 'gtm', 'Google Tag Manager (GTM-XXXXXX)',
    'google_ads', 'Google Ads (AW-123456789/label)', 'fb_domain_verification', 'كود تأكيد الدومين من فيسبوك');
begin
  if t is null or t = '{}'::jsonb then return ''; end if;
  if jsonb_typeof(t) <> 'object' then return 'بيانات التتبع مش صحيحة'; end if;
  for k in select jsonb_object_keys(t) loop
    if not rules ? k then return 'حقل تتبع غير معروف: ' || k; end if;
    if jsonb_typeof(t -> k) <> 'string' then return 'قيمة «' || (names ->> k) || '» مش صحيحة'; end if;
    v := t ->> k;
    if v !~ (rules ->> k) then return 'قيمة «' || (names ->> k) || '» مش بالشكل الصحيح'; end if;
  end loop;
  return '';
end;
$$;
grant execute on function public.shop_tracking_problem(jsonb) to anon, authenticated, service_role;

alter table public.shops add column if not exists tracking jsonb not null default '{}'::jsonb;
alter table public.shops drop constraint if exists shops_tracking_valid;
alter table public.shops add constraint shops_tracking_valid check (public.shop_tracking_problem(tracking) = '');

create or replace function public.set_shop_tracking(p_shop uuid, p_tracking jsonb) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  t jsonb := '{}'::jsonb;
  k text;
  v text;
  v_problem text;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  if p_tracking is null or jsonb_typeof(p_tracking) <> 'object' then
    raise exception 'بيانات التتبع مش صحيحة';
  end if;
  for k, v in select key, btrim(value) from jsonb_each_text(p_tracking) loop
    continue when v is null or v = '';
    v := case k
      when 'snap_pixel' then lower(v)
      when 'fb_domain_verification' then lower(v)
      when 'google_ads' then case when position('/' in v) > 0
                                  then upper(split_part(v, '/', 1)) || '/' || split_part(v, '/', 2)
                                  else upper(v) end
      else upper(v) end;
    t := t || jsonb_build_object(k, v);
  end loop;
  v_problem := public.shop_tracking_problem(t);
  if v_problem <> '' then
    raise exception '%', v_problem;
  end if;
  update public.shops set tracking = t where id = p_shop;
  return public.get_shop_integrations(p_shop);
end;
$$;

-- ------------------------------------------------- the hub's one read

create or replace function public.get_shop_integrations(p_shop uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  s public.shops;
  ps public.shop_payment_settings;
begin
  if not public.i_own_shop(p_shop) then
    raise exception 'المتجر ده مش بتاعك' using errcode = '42501';
  end if;
  select * into s from public.shops where id = p_shop;
  select * into ps from public.shop_payment_settings where shop_id = p_shop;
  return jsonb_build_object(
    'shop_id', s.id,
    'slug', s.slug,
    'country', coalesce(s.country, 'EG'),
    'currency', s.currency,
    'payments', jsonb_build_object(
      'cod_enabled', coalesce(ps.cod_enabled, true),
      'manual', coalesce(ps.manual, '{}'::jsonb),
      'available', to_jsonb(private.gateways_for_country(s.country)),
      'gateways', coalesce((select jsonb_agg(private.gateway_view(g) order by g.created_at)
                              from public.shop_payment_gateways g where g.shop_id = p_shop), '[]'::jsonb)),
    'domain', (select to_jsonb(d) - 'shop_id' from public.shop_domains d where d.shop_id = p_shop),
    'tracking', coalesce(s.tracking, '{}'::jsonb));
end;
$$;

-- ------------------------------------------- Phase 4: checkout methods
-- What a customer may see when paying (anyone): never secrets, only
-- connected gateways and their publishable keys.
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
                        where g.shop_id = s.id and g.enabled and g.status = 'connected'), '[]'::jsonb))
  from public.shops s
  left join public.shop_payment_settings ps on ps.shop_id = s.id
  where s.id = p_shop and s.owner_id is not null
$$;

-- ------------------------------------------------------------ grants

-- The RLS policies call it as the reader, so it lives in public.
revoke execute on function public.i_own_shop(uuid) from public, anon;
grant execute on function public.i_own_shop(uuid) to authenticated, service_role;

do $$
declare
  f text;
begin
  -- the owner's RPCs
  foreach f in array array[
    'public.set_shop_payment_settings(uuid, boolean, jsonb)',
    'public.set_shop_gateway(uuid, text, jsonb, jsonb, text)',
    'public.disconnect_shop_gateway(uuid, text)',
    'public.add_shop_domain(uuid, text)',
    'public.remove_shop_domain(uuid)',
    'public.integration_rate_hit(uuid, text)',
    'public.set_shop_tracking(uuid, jsonb)',
    'public.get_shop_integrations(uuid)'] loop
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated, service_role', f);
  end loop;
  -- Edge Functions only
  foreach f in array array[
    'public.gateway_credentials(uuid, text)',
    'public.gateway_record_check(uuid, text, boolean, text)',
    'public.record_shop_payment_event(uuid, text, text, text, boolean, jsonb)',
    'public.domain_record_check(uuid, boolean, boolean, text)'] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
    execute format('grant execute on function %s to service_role', f);
  end loop;
end;
$$;

revoke execute on function public.shop_checkout_methods(uuid) from public;
grant execute on function public.shop_checkout_methods(uuid) to anon, authenticated, service_role;
