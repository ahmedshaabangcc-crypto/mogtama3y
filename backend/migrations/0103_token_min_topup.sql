-- =====================================================================
-- Migration 0103 — the smallest token top-up is a setting (owner, 2026-10-30:
-- «خلي الشحن من اول 3 توكن»).
--
--   * ad_token_settings.min_topup_tokens (default 3) — read by the app and
--     enforced by request_token_topup (manual, 0026) and token_payment_begin
--     (online, 0102). Change it from the database, no deploy needed.
-- Run after 0102. Safe to re-run.
-- =====================================================================

alter table public.ad_token_settings add column if not exists min_topup_tokens int not null default 3;
alter table public.ad_token_settings drop constraint if exists ad_token_settings_min_topup_ok;
alter table public.ad_token_settings add constraint ad_token_settings_min_topup_ok check (min_topup_tokens between 1 and 1000);
update public.ad_token_settings set min_topup_tokens = 3 where id = 1;

-- 0026's manual top-up request, with the minimum from the settings.
create or replace function public.request_token_topup(p_tokens int, p_proof_note text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_price numeric;
  v_min int;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select token_price_egp, min_topup_tokens into v_price, v_min from public.ad_token_settings where id = 1;
  if p_tokens is null or p_tokens < coalesce(v_min, 3) then
    raise exception 'الحد الأدنى للشحن % توكن', coalesce(v_min, 3);
  end if;

  insert into public.ad_token_topup_requests (user_id, tokens_requested, amount_egp, proof_note)
  values (auth.uid(), p_tokens, p_tokens * v_price, p_proof_note)
  returning id into v_id;

  return v_id;
end;
$$;

grant execute on function public.request_token_topup(int, text) to authenticated;

-- 0102's online top-up, with the minimum from the settings.
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
  v_min int;
begin
  select * into s from public.ad_token_settings where id = 1;
  v_min := coalesce(s.min_topup_tokens, 3);
  if not coalesce(s.online_topup, false) then
    return jsonb_build_object('error', 'الشحن الأونلاين مش متاح دلوقتي — استخدم التحويل');
  end if;
  if p_tokens is null or p_tokens < v_min or p_tokens > 10000 then
    return jsonb_build_object('error', 'اختار من ' || v_min || ' لـ 10000 توكن');
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

revoke execute on function public.token_payment_begin(uuid, int) from public, anon, authenticated;
grant execute on function public.token_payment_begin(uuid, int) to service_role;
