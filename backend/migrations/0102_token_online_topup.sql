-- =====================================================================
-- Migration 0102 — «اشحن أونلاين»: ad tokens bought with the platform's
-- own Fawaterak account (API v3).
--
-- Owner decision (2026-10-30): مُجتمعي itself takes the money — people
-- buy ad tokens (0026) online instead of a manual transfer + admin
-- review. The platform's Fawaterak credentials are Edge Function secrets
-- (FAWATERAK_CLIENT_ID / FAWATERAK_CLIENT_SECRET / FAWATERAK_API_KEY /
-- FAWATERAK_MODE), never in the database or the app.
--
--   * ad_token_topup_requests gets method ('manual' | 'online') and the
--     transaction (intent_key, link, paid_at, paid_amount). An online row
--     is 'awaiting_payment' until paid ('approved') — the admin's pending
--     queue (status = 'pending') stays manual-only.
--   * token_payment_begin / attach / settle / lookup: Edge Functions only
--     (service role). The price is always computed here from
--     ad_token_settings, never sent by the app; settle credits the tokens
--     once, only for the exact amount in EGP, re-read from Fawaterak.
--   * ad_token_settings.online_topup: the button shows only when the
--     owner turns it on (after setting the secrets).
-- Run after 0101. Safe to re-run.
-- =====================================================================

alter table public.ad_token_settings add column if not exists online_topup boolean not null default false;

alter table public.ad_token_topup_requests add column if not exists method text not null default 'manual';
alter table public.ad_token_topup_requests add column if not exists provider text;
alter table public.ad_token_topup_requests add column if not exists intent_key text;
alter table public.ad_token_topup_requests add column if not exists payment_url text;
alter table public.ad_token_topup_requests add column if not exists paid_at timestamptz;
alter table public.ad_token_topup_requests add column if not exists paid_amount numeric(12,2);
alter table public.ad_token_topup_requests drop constraint if exists ad_token_topup_requests_method_ok;
alter table public.ad_token_topup_requests add constraint ad_token_topup_requests_method_ok
  check (method in ('manual', 'online') and (method = 'online' or intent_key is null));
create unique index if not exists ad_token_topup_requests_intent_idx on public.ad_token_topup_requests (intent_key) where intent_key is not null;

-- Starts an online top-up for [p_user] (the Edge Function verified the
-- session). → {id, tokens, amount, currency, first_name, last_name, phone} | {error}
create or replace function public.token_payment_begin(p_user uuid, p_tokens int) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  s record;
  p record;
  v_id uuid;
  v_name text[];
begin
  select * into s from public.ad_token_settings where id = 1;
  if not coalesce(s.online_topup, false) then
    return jsonb_build_object('error', 'الشحن الأونلاين مش متاح دلوقتي — استخدم التحويل');
  end if;
  if p_tokens is null or p_tokens < 5 or p_tokens > 10000 then
    return jsonb_build_object('error', 'اختار من 5 لـ 10000 توكن');
  end if;
  select id, full_name, phone into p from public.profiles where id = p_user;
  if not found then
    return jsonb_build_object('error', 'سجّل دخول الأول');
  end if;
  if (select count(*) from public.ad_token_topup_requests r
       where r.user_id = p_user and r.method = 'online' and r.created_at > now() - interval '1 hour') >= 10 then
    return jsonb_build_object('error', 'محاولات كتير — استنى شوية وجرّب تاني');
  end if;

  insert into public.ad_token_topup_requests (user_id, tokens_requested, amount_egp, status, method, provider)
  values (p_user, p_tokens, round(p_tokens * s.token_price_egp, 2), 'awaiting_payment', 'online', 'fawaterak')
  returning id into v_id;

  v_name := regexp_split_to_array(btrim(coalesce(nullif(p.full_name, ''), 'مستخدم مجتمعي')), '\s+');
  return jsonb_build_object(
    'id', v_id, 'tokens', p_tokens, 'amount', round(p_tokens * s.token_price_egp, 2), 'currency', 'EGP',
    'first_name', v_name[1],
    'last_name', coalesce(nullif(array_to_string(v_name[2:], ' '), ''), v_name[1]),
    'phone', p.phone);
end;
$$;

create or replace function public.token_payment_attach(p_id uuid, p_intent text, p_url text) returns void
language sql
security definer
set search_path = public
as $$
  update public.ad_token_topup_requests
     set intent_key = left(p_intent, 60), payment_url = case when p_url ~ '^https://' then left(p_url, 500) end
   where id = p_id and method = 'online' and status = 'awaiting_payment';
$$;

-- The transaction as Fawaterak reports it (re-read by the caller).
-- Credits the tokens once, only for the exact amount in EGP.
-- → {ok, status?, reason?, user_id?}
create or replace function public.token_payment_settle(
  p_intent text, p_paid boolean, p_amount numeric default null, p_currency text default null, p_method text default null
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  r record;
begin
  select * into r from public.ad_token_topup_requests where intent_key = p_intent and method = 'online' for update;
  if not found then
    return jsonb_build_object('ok', false, 'reason', 'no_request');
  end if;
  if r.status = 'approved' then
    return jsonb_build_object('ok', true, 'status', 'approved', 'already', true, 'user_id', r.user_id);
  end if;
  if not coalesce(p_paid, false) then
    return jsonb_build_object('ok', true, 'status', r.status, 'user_id', r.user_id);
  end if;
  if p_amount is null or abs(p_amount - r.amount_egp) > 0.01 or upper(coalesce(p_currency, 'EGP')) <> 'EGP' then
    return jsonb_build_object('ok', false, 'reason', 'amount_mismatch', 'user_id', r.user_id);
  end if;

  update public.ad_token_topup_requests
     set status = 'approved', paid_at = now(), paid_amount = p_amount,
         proof_note = left('فواتيرك' || coalesce(' — ' || nullif(p_method, ''), ''), 120)
   where id = r.id;
  update public.profiles set ad_token_balance = ad_token_balance + r.tokens_requested where id = r.user_id;
  insert into public.ad_token_activity (user_id, kind, tokens, description)
  values (r.user_id, 'topup', r.tokens_requested, 'شحن أونلاين (' || r.amount_egp || ' ج.م)');
  insert into public.notifications (user_id, title, body)
  values (r.user_id, '🎉 اتشحن رصيدك', r.tokens_requested || ' توكن اتضافوا لرصيدك — تقدر تميّز إعلاناتك دلوقتي.');
  return jsonb_build_object('ok', true, 'status', 'approved', 'user_id', r.user_id);
end;
$$;

-- A user's own online top-up (for «اتأكد من الدفع» after Fawaterak's page).
create or replace function public.token_payment_lookup(p_user uuid, p_id uuid) returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object('id', r.id, 'status', r.status, 'intent_key', r.intent_key, 'tokens', r.tokens_requested, 'amount', r.amount_egp)
  from public.ad_token_topup_requests r
  where r.id = p_id and r.user_id = p_user and r.method = 'online'
$$;

do $$
declare
  f text;
begin
  foreach f in array array[
    'public.token_payment_begin(uuid, int)',
    'public.token_payment_attach(uuid, text, text)',
    'public.token_payment_settle(text, boolean, numeric, text, text)',
    'public.token_payment_lookup(uuid, uuid)'] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
    execute format('grant execute on function %s to service_role', f);
  end loop;
end;
$$;
