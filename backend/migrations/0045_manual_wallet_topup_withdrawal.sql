-- =====================================================================
-- Migration 0045 — interim manual wallet top-ups and withdrawals.
--
-- Until a payment gateway is integrated, money moves through the
-- platform owner's mobile wallet (the same number as token top-ups,
-- ad_token_settings.topup_phone):
--
--   Top-up:     resident transfers → files request_wallet_topup(amount,
--               transfer reference) → super admin checks the money
--               arrived → review_wallet_topup(approve) credits the wallet.
--   Withdrawal: user (e.g. a technician paid through escrow) files
--               request_wallet_withdrawal(amount, payout phone) → the
--               amount leaves their available balance immediately
--               (pending ledger row) → super admin transfers it and marks
--               it paid, or rejects it and the amount is refunded.
--
-- Clients never write these tables or the wallet directly; every step is
-- a SECURITY DEFINER function with its own checks (see 0037).
--
-- Run after 0044, in order, in the Supabase SQL editor.
-- =====================================================================

-- ---- tables ----

create table if not exists public.wallet_topup_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  amount_egp numeric(12,2) not null check (amount_egp > 0),
  proof_note text not null,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.wallet_withdrawal_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  amount_egp numeric(12,2) not null check (amount_egp > 0),
  payout_phone text not null,
  status text not null default 'pending' check (status in ('pending', 'paid', 'rejected')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

revoke all on public.wallet_topup_requests, public.wallet_withdrawal_requests from anon, authenticated;
grant select on public.wallet_topup_requests, public.wallet_withdrawal_requests to authenticated;

alter table public.wallet_topup_requests enable row level security;
alter table public.wallet_withdrawal_requests enable row level security;

create policy "wallet_topup_requests: owner views own" on public.wallet_topup_requests
  for select using (auth.uid() = user_id);
create policy "wallet_topup_requests: super_admin views all" on public.wallet_topup_requests
  for select using (public.is_super_admin());
create policy "wallet_withdrawal_requests: owner views own" on public.wallet_withdrawal_requests
  for select using (auth.uid() = user_id);
create policy "wallet_withdrawal_requests: super_admin views all" on public.wallet_withdrawal_requests
  for select using (public.is_super_admin());

-- ---- top-up ----

create or replace function public.request_wallet_topup(p_amount numeric, p_proof_note text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_amount is null or p_amount < 10 or p_amount > 20000 then
    raise exception 'مبلغ الشحن يجب أن يكون بين 10 و 20,000 ج.م';
  end if;
  if p_proof_note is null or length(trim(p_proof_note)) < 3 then
    raise exception 'اكتب رقم العملية أو اسم المحوِّل حتى نتمكن من مطابقة التحويل';
  end if;
  if (select count(*) from public.wallet_topup_requests where user_id = auth.uid() and status = 'pending') >= 3 then
    raise exception 'لديك 3 طلبات شحن قيد المراجعة بالفعل، انتظر مراجعتها أولاً';
  end if;

  insert into public.wallet_topup_requests (user_id, amount_egp, proof_note)
  values (auth.uid(), round(p_amount, 2), trim(p_proof_note))
  returning id into v_id;
  return v_id;
end;
$$;

create or replace function public.review_wallet_topup(p_request_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_wallet_id uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات شحن المحفظة';
  end if;

  select * into v_request from public.wallet_topup_requests where id = p_request_id for update;
  if not found or v_request.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;

  update public.wallet_topup_requests
  set status = case when p_approve then 'approved' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
  where id = p_request_id;

  if p_approve then
    perform public._create_profile_and_wallet(v_request.user_id);
    update public.wallets set available_balance = available_balance + v_request.amount_egp, updated_at = now()
      where user_id = v_request.user_id
      returning id into v_wallet_id;
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_wallet_id, 'top_up', 'completed', v_request.amount_egp, 'wallet_topup_requests', p_request_id);
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.user_id,
    case when p_approve then 'تم شحن محفظتك' else 'تم رفض طلب شحن المحفظة' end,
    case when p_approve then v_request.amount_egp || ' ج.م أُضيفت لرصيد محفظتك.'
         else 'لم نتمكن من مطابقة التحويل (' || v_request.amount_egp || ' ج.م). تواصل مع الدعم إذا كنت حوّلت المبلغ بالفعل.' end
  );
end;
$$;

-- ---- withdrawal ----

create or replace function public.request_wallet_withdrawal(p_amount numeric, p_payout_phone text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_wallet record;
  v_phone text;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_amount is null or p_amount < 10 then
    raise exception 'أقل مبلغ للسحب 10 ج.م';
  end if;
  v_phone := regexp_replace(coalesce(p_payout_phone, ''), '\s', '', 'g');
  if v_phone !~ '^01[0125][0-9]{8}$' then
    raise exception 'رقم المحفظة غير صحيح (مثال: 01012345678)';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < p_amount then
    raise exception 'رصيدك المتاح غير كافٍ لهذا المبلغ';
  end if;

  insert into public.wallet_withdrawal_requests (user_id, amount_egp, payout_phone)
  values (auth.uid(), round(p_amount, 2), v_phone)
  returning id into v_id;

  update public.wallets set available_balance = available_balance - round(p_amount, 2), updated_at = now()
    where id = v_wallet.id;
  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'withdrawal', 'pending', -round(p_amount, 2), 'wallet_withdrawal_requests', v_id);

  return v_id;
end;
$$;

create or replace function public.review_wallet_withdrawal(p_request_id uuid, p_paid boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_wallet_id uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات السحب';
  end if;

  select * into v_request from public.wallet_withdrawal_requests where id = p_request_id for update;
  if not found or v_request.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;

  select id into v_wallet_id from public.wallets where user_id = v_request.user_id for update;

  update public.wallet_withdrawal_requests
  set status = case when p_paid then 'paid' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
  where id = p_request_id;

  if p_paid then
    update public.wallet_transactions set status = 'completed'
      where reference_table = 'wallet_withdrawal_requests' and reference_id = p_request_id;
  else
    -- Refund: the amount left the balance when the request was filed.
    update public.wallets set available_balance = available_balance + v_request.amount_egp, updated_at = now()
      where id = v_wallet_id;
    update public.wallet_transactions set status = 'reversed'
      where reference_table = 'wallet_withdrawal_requests' and reference_id = p_request_id;
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.user_id,
    case when p_paid then 'تم تحويل أرباحك' else 'تم رفض طلب السحب' end,
    case when p_paid then v_request.amount_egp || ' ج.م حُوّلت إلى محفظتك ' || v_request.payout_phone || '.'
         else 'أعدنا ' || v_request.amount_egp || ' ج.م إلى رصيدك المتاح. تواصل مع الدعم لمعرفة السبب.' end
  );
end;
$$;

revoke execute on function public.request_wallet_topup(numeric, text) from public, anon;
revoke execute on function public.review_wallet_topup(uuid, boolean) from public, anon;
revoke execute on function public.request_wallet_withdrawal(numeric, text) from public, anon;
revoke execute on function public.review_wallet_withdrawal(uuid, boolean) from public, anon;
grant execute on function public.request_wallet_topup(numeric, text) to authenticated;
grant execute on function public.review_wallet_topup(uuid, boolean) to authenticated;
grant execute on function public.request_wallet_withdrawal(numeric, text) to authenticated;
grant execute on function public.review_wallet_withdrawal(uuid, boolean) to authenticated;
