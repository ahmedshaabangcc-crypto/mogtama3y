-- =====================================================================
-- Migration 0076 — the building fund (صندوق العمارة), treasurer
-- (أمين الصندوق), who-paid / who-didn't, invite-code sharing and
-- join-request notifications.
--
-- The bug this fixes: pay_union_due (0037) took the money out of the
-- resident's wallet and marked the due paid, but credited NOTHING — the
-- money just vanished. Now every payment lands in the building's fund.
--
-- Decisions (confirmed with the project owner):
--   * One fund per building (union_funds) with a ledger
--     (union_fund_transactions). The money belongs to the building, not
--     to the president's personal wallet, so a new president inherits it.
--   * The fund MANAGER is the treasurer when the building has one,
--     otherwise the president. The manager has every fund power: mark a
--     due paid in cash, record an expense (receipt photo optional), ask
--     to withdraw. No board approval.
--   * With a treasurer in place the president keeps READ access to the
--     fund (balance + ledger) and can remove the treasurer, but the fund
--     operations are the treasurer's alone. Board members also read.
--   * Residents never see the balance or the ledger, only the collection
--     percentage of the current period (union_collection_rate).
--   * Withdrawals work like wallet withdrawals (0045): the manager files a
--     request, the platform admin pays it out by hand (or into the
--     manager's in-app wallet) and only then is the fund debited.
--   * Treasurer: appointed by the president (building is notified) or
--     elected with the existing election machinery
--     (union_elections.position = 'treasurer'; one vote per unit, same
--     50% quorum). The president can remove the treasurer.
--   * Dues already paid before this migration are carried into the fund
--     (one ledger row each), since that money did leave the residents'
--     wallets.
--
-- Run after 0075, in order, in the Supabase SQL editor. Deploy the
-- matching app build after this has run.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Tables
-- ---------------------------------------------------------------------

create table if not exists public.union_funds (
  building_id uuid primary key references public.buildings(id) on delete cascade,
  balance numeric(12,2) not null default 0 check (balance >= 0),
  updated_at timestamptz not null default now()
);

create table if not exists public.union_fund_transactions (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  type text not null check (type in ('due_payment', 'cash_due', 'expense', 'withdrawal', 'adjustment')),
  amount numeric(12,2) not null check (amount <> 0),          -- positive = into the fund
  due_id uuid references public.union_dues(id) on delete set null,
  unit_id uuid references public.units(id) on delete set null,
  note text,
  receipt_path text,                                           -- private-documents path
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);
create index if not exists union_fund_transactions_building
  on public.union_fund_transactions (building_id, created_at desc);
-- A due can only ever be credited to the fund once.
create unique index if not exists union_fund_transactions_one_credit_per_due
  on public.union_fund_transactions (due_id) where type in ('due_payment', 'cash_due');

create table if not exists public.union_treasurers (
  building_id uuid primary key references public.buildings(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  source text not null check (source in ('appointed', 'elected')),
  appointed_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table if not exists public.union_fund_withdrawal_requests (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  requested_by uuid not null references public.profiles(id),
  amount_egp numeric(12,2) not null check (amount_egp > 0),
  destination text not null check (destination in ('wallet', 'payout')),
  payout_phone text,
  note text not null,
  status text not null default 'pending' check (status in ('pending', 'paid', 'rejected')),
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

-- «فكّر الكل» rate limit: once per 24h per building.
create table if not exists public.union_due_reminders (
  building_id uuid primary key references public.buildings(id) on delete cascade,
  last_sent_at timestamptz not null,
  sent_by uuid references public.profiles(id)
);

-- Which office an election fills.
alter table public.union_elections add column if not exists position text not null default 'president';
alter table public.union_elections drop constraint if exists union_elections_position_check;
alter table public.union_elections add constraint union_elections_position_check check (position in ('president', 'treasurer'));


-- ---------------------------------------------------------------------
-- 2. Who manages / who may look
-- ---------------------------------------------------------------------

-- The building's treasurer, while they are still a verified member.
create or replace function public._union_treasurer_of(p_building_id uuid) returns uuid
language sql
security definer
stable
set search_path = public
as $$
  select t.user_id
    from public.union_treasurers t
    join public.union_members m
      on m.building_id = t.building_id and m.user_id = t.user_id and m.status = 'verified'
   where t.building_id = p_building_id;
$$;

-- Treasurer if there is one, otherwise the president.
create or replace function public._union_fund_manager_of(p_building_id uuid) returns uuid
language sql
security definer
stable
set search_path = public
as $$
  select coalesce(
    public._union_treasurer_of(p_building_id),
    (select m.user_id from public.union_members m
      where m.building_id = p_building_id and m.status = 'verified' and m.role = 'president'
      order by m.verified_at nulls last, m.created_at
      limit 1)
  );
$$;

create or replace function public.is_union_fund_manager(p_building_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select auth.uid() is not null and auth.uid() = public._union_fund_manager_of(p_building_id);
$$;

-- Manager, president, board members (and the platform admin) see the
-- balance and the ledger; plain residents don't.
create or replace function public.can_view_union_fund(p_building_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select auth.uid() is not null and (
    public.is_union_fund_manager(p_building_id)
    or exists (select 1 from public.union_members m
                where m.building_id = p_building_id and m.user_id = auth.uid()
                  and m.status = 'verified' and m.role in ('president', 'board_member'))
    or public.is_super_admin()
  );
$$;

-- Move money in/out of a building's fund and write the ledger row.
-- Internal: every caller does its own authorization first.
create or replace function public._union_fund_post(
  p_building_id uuid,
  p_type text,
  p_amount numeric,
  p_due_id uuid,
  p_unit_id uuid,
  p_note text,
  p_receipt_path text,
  p_by uuid
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_balance numeric;
  v_id uuid;
begin
  insert into public.union_funds (building_id) values (p_building_id) on conflict (building_id) do nothing;
  select balance into v_balance from public.union_funds where building_id = p_building_id for update;
  if v_balance + p_amount < 0 then
    raise exception 'رصيد صندوق العمارة مش كفاية (المتاح % ج.م)', v_balance;
  end if;
  update public.union_funds set balance = balance + p_amount, updated_at = now() where building_id = p_building_id;
  insert into public.union_fund_transactions (building_id, type, amount, due_id, unit_id, note, receipt_path, created_by)
  values (p_building_id, p_type, p_amount, p_due_id, p_unit_id, p_note, p_receipt_path, p_by)
  returning id into v_id;
  return v_id;
end;
$$;

revoke execute on function public._union_treasurer_of(uuid) from public, anon, authenticated;
revoke execute on function public._union_fund_manager_of(uuid) from public, anon, authenticated;
revoke execute on function public._union_fund_post(uuid, text, numeric, uuid, uuid, text, text, uuid) from public, anon, authenticated;
revoke execute on function public.is_union_fund_manager(uuid) from public, anon;
revoke execute on function public.can_view_union_fund(uuid) from public, anon;
grant execute on function public.is_union_fund_manager(uuid) to authenticated;
grant execute on function public.can_view_union_fund(uuid) to authenticated;


-- ---------------------------------------------------------------------
-- 3. Access
-- ---------------------------------------------------------------------

revoke all on public.union_funds, public.union_fund_transactions, public.union_treasurers,
  public.union_fund_withdrawal_requests, public.union_due_reminders from anon, authenticated;
grant select on public.union_funds, public.union_fund_transactions, public.union_treasurers,
  public.union_fund_withdrawal_requests to authenticated;

alter table public.union_funds enable row level security;
alter table public.union_fund_transactions enable row level security;
alter table public.union_treasurers enable row level security;
alter table public.union_fund_withdrawal_requests enable row level security;
alter table public.union_due_reminders enable row level security;

drop policy if exists "union_funds: managers and board read" on public.union_funds;
create policy "union_funds: managers and board read" on public.union_funds
  for select to authenticated using (public.can_view_union_fund(building_id));

drop policy if exists "union_fund_transactions: managers and board read" on public.union_fund_transactions;
create policy "union_fund_transactions: managers and board read" on public.union_fund_transactions
  for select to authenticated using (public.can_view_union_fund(building_id));

drop policy if exists "union_treasurers: building members read" on public.union_treasurers;
create policy "union_treasurers: building members read" on public.union_treasurers
  for select to authenticated using (public.is_verified_member_of(building_id) or public.is_super_admin());

drop policy if exists "union_fund_withdrawal_requests: managers, board, admin read" on public.union_fund_withdrawal_requests;
create policy "union_fund_withdrawal_requests: managers, board, admin read" on public.union_fund_withdrawal_requests
  for select to authenticated using (public.can_view_union_fund(building_id));

-- Expense receipts live in private-documents under the uploader's folder;
-- whoever may read the ledger may open the receipts it references.
drop policy if exists "private-documents: union fund viewers read receipts" on storage.objects;
create policy "private-documents: union fund viewers read receipts" on storage.objects
  for select using (
    bucket_id = 'private-documents'
    and exists (
      select 1 from public.union_fund_transactions t
       where t.receipt_path = storage.objects.name
         and public.can_view_union_fund(t.building_id)
    )
  );


-- ---------------------------------------------------------------------
-- 4. Carry already-paid dues into the fund
-- ---------------------------------------------------------------------

insert into public.union_fund_transactions (building_id, type, amount, due_id, unit_id, note, created_at)
select d.building_id,
       case when d.paid_via = 'cash' then 'cash_due' else 'due_payment' end,
       d.amount, d.id, d.unit_id,
       'رصيد مُرحَّل: «' || d.period_label || '» اتدفع قبل تفعيل الصندوق',
       coalesce(d.paid_at, now())
  from public.union_dues d
 where d.is_paid and d.amount > 0
   and not exists (select 1 from public.union_fund_transactions t
                    where t.due_id = d.id and t.type in ('due_payment', 'cash_due'));

insert into public.union_funds (building_id, balance)
select t.building_id, sum(t.amount)
  from public.union_fund_transactions t
 group by t.building_id
on conflict (building_id) do update set balance = excluded.balance, updated_at = now();


-- ---------------------------------------------------------------------
-- 5. Paying dues: wallet (resident) and cash (manager)
-- ---------------------------------------------------------------------

create or replace function public.pay_union_due(p_due_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_due record;
  v_wallet record;
  v_unit text;
  v_manager uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_due from public.union_dues where id = p_due_id for update;
  if not found then
    raise exception 'المستحق غير موجود';
  end if;
  if v_due.is_paid then
    raise exception 'تم سداد هذا المستحق بالفعل';
  end if;
  if v_due.amount <= 0 then
    raise exception 'قيمة المستحق غير صحيحة';
  end if;

  if not exists (
    select 1 from public.union_members m
    where m.unit_id = v_due.unit_id and m.user_id = auth.uid() and m.status = 'verified'
  ) then
    raise exception 'غير مصرح لك بسداد هذا المستحق';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < v_due.amount then
    raise exception 'رصيد المحفظة غير كافٍ لسداد هذا المستحق';
  end if;

  update public.wallets set available_balance = available_balance - v_due.amount, updated_at = now()
    where id = v_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'union_dues', 'completed', -v_due.amount, 'union_dues', v_due.id);

  update public.union_dues set is_paid = true, paid_at = now(), paid_via = 'wallet'
    where id = p_due_id;

  -- The money goes to the building's fund, in the same transaction.
  perform public._union_fund_post(v_due.building_id, 'due_payment', v_due.amount, v_due.id, v_due.unit_id,
                                  'سداد «' || v_due.period_label || '» من المحفظة', null, auth.uid());

  select unit_number into v_unit from public.units where id = v_due.unit_id;
  v_manager := public._union_fund_manager_of(v_due.building_id);
  if v_manager is not null and v_manager <> auth.uid() then
    insert into public.notifications (user_id, title, body, deep_link)
    values (v_manager, '💰 وصل سداد صيانة',
            'شقة ' || coalesce(v_unit, '—') || ' دفعت «' || v_due.period_label || '» — ' || v_due.amount || ' ج.م دخلت صندوق العمارة.',
            '/#/union-fund');
  end if;
end;
$$;

create or replace function public.mark_due_paid_cash(p_due_id uuid, p_note text default null) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_due record;
  v_unit text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_due from public.union_dues where id = p_due_id for update;
  if not found then
    raise exception 'المستحق غير موجود';
  end if;
  if not public.is_union_fund_manager(v_due.building_id) then
    raise exception 'تسجيل الدفع الكاش لأمين الصندوق (أو الرئيس لو مفيش أمين صندوق) بس';
  end if;
  if v_due.is_paid then
    raise exception 'تم سداد هذا المستحق بالفعل';
  end if;
  if v_due.amount <= 0 then
    raise exception 'قيمة المستحق غير صحيحة';
  end if;

  update public.union_dues set is_paid = true, paid_at = now(), paid_via = 'cash' where id = p_due_id;

  select unit_number into v_unit from public.units where id = v_due.unit_id;
  perform public._union_fund_post(v_due.building_id, 'cash_due', v_due.amount, v_due.id, v_due.unit_id,
    coalesce(nullif(trim(p_note), ''), 'سداد كاش «' || v_due.period_label || '» — شقة ' || coalesce(v_unit, '—')),
    null, auth.uid());

  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, 'اتسجّل سدادك ✓',
         'أمين الصندوق سجّل إن «' || v_due.period_label || '» (' || v_due.amount || ' ج.م) اتدفع كاش لشقتك.',
         '/#/union-pay'
    from public.union_members m
   where m.unit_id = v_due.unit_id and m.status = 'verified' and m.user_id <> auth.uid();
end;
$$;


-- ---------------------------------------------------------------------
-- 6. Expenses and withdrawals
-- ---------------------------------------------------------------------

create or replace function public.record_union_expense(
  p_building uuid,
  p_amount numeric,
  p_note text,
  p_receipt_path text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_path text := nullif(trim(coalesce(p_receipt_path, '')), '');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not public.is_union_fund_manager(p_building) then
    raise exception 'تسجيل المصروفات لأمين الصندوق (أو الرئيس لو مفيش أمين صندوق) بس';
  end if;
  if p_amount is null or p_amount <= 0 then
    raise exception 'المبلغ لازم يكون أكبر من صفر';
  end if;
  if p_note is null or length(trim(p_note)) < 3 then
    raise exception 'اكتب المصروف ده كان على إيه';
  end if;
  -- Only a receipt the manager uploaded themselves (never someone else's
  -- private document, e.g. an ID card).
  if v_path is not null and (v_path not like auth.uid()::text || '/union-receipts/%' or v_path like '%..%') then
    raise exception 'صورة الإيصال غير صالحة';
  end if;

  return public._union_fund_post(p_building, 'expense', -round(p_amount, 2), null, null, trim(p_note), v_path, auth.uid());
end;
$$;

-- No payout phone = into the manager's own in-app wallet.
create or replace function public.request_fund_withdrawal(
  p_building uuid,
  p_amount numeric,
  p_note text,
  p_payout_phone text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_balance numeric;
  v_pending numeric;
  v_phone text := nullif(regexp_replace(coalesce(p_payout_phone, ''), '\s', '', 'g'), '');
  v_name text;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not public.is_union_fund_manager(p_building) then
    raise exception 'طلب السحب من الصندوق لأمين الصندوق (أو الرئيس لو مفيش أمين صندوق) بس';
  end if;
  if p_amount is null or p_amount < 10 then
    raise exception 'أقل مبلغ للسحب 10 ج.م';
  end if;
  if p_note is null or length(trim(p_note)) < 3 then
    raise exception 'اكتب سبب السحب';
  end if;
  if v_phone is not null and v_phone !~ '^01[0125][0-9]{8}$' then
    raise exception 'رقم المحفظة غير صحيح (مثال: 01012345678)';
  end if;

  insert into public.union_funds (building_id) values (p_building) on conflict (building_id) do nothing;
  select balance into v_balance from public.union_funds where building_id = p_building for update;
  select coalesce(sum(amount_egp), 0) into v_pending from public.union_fund_withdrawal_requests
   where building_id = p_building and status = 'pending';
  if v_balance - v_pending < p_amount then
    raise exception 'رصيد الصندوق المتاح مش كفاية (المتاح بعد الطلبات المعلّقة % ج.م)', v_balance - v_pending;
  end if;

  insert into public.union_fund_withdrawal_requests (building_id, requested_by, amount_egp, destination, payout_phone, note)
  values (p_building, auth.uid(), round(p_amount, 2), case when v_phone is null then 'wallet' else 'payout' end, v_phone, trim(p_note))
  returning id into v_id;

  select name into v_name from public.buildings where id = p_building;
  insert into public.notifications (user_id, title, body, deep_link)
  select p.id, '🏦 طلب سحب من صندوق عمارة',
         round(p_amount, 2) || ' ج.م من صندوق «' || coalesce(v_name, '') || '» محتاج مراجعتك.', '/#/admin'
    from public.profiles p where p.role = 'super_admin';

  return v_id;
end;
$$;

create or replace function public.review_union_fund_withdrawal(p_request_id uuid, p_paid boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  r public.union_fund_withdrawal_requests;
  v_wallet_id uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات السحب';
  end if;

  select * into r from public.union_fund_withdrawal_requests where id = p_request_id for update;
  if not found or r.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;

  if p_paid then
    -- Debited only now; fails cleanly if the fund can't cover it any more.
    perform public._union_fund_post(r.building_id, 'withdrawal', -r.amount_egp, null, null,
      'سحب: ' || r.note || case when r.destination = 'wallet' then ' (إلى محفظة مُجتمعي)' else ' (تحويل إلى ' || r.payout_phone || ')' end,
      null, r.requested_by);
    if r.destination = 'wallet' then
      perform public._create_profile_and_wallet(r.requested_by);
      update public.wallets set available_balance = available_balance + r.amount_egp, updated_at = now()
       where user_id = r.requested_by
      returning id into v_wallet_id;
      insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_wallet_id, 'union_dues', 'completed', r.amount_egp, 'union_fund_withdrawal_requests', r.id);
    end if;
  end if;

  update public.union_fund_withdrawal_requests
     set status = case when p_paid then 'paid' else 'rejected' end, reviewed_by = auth.uid(), reviewed_at = now()
   where id = p_request_id;

  insert into public.notifications (user_id, title, body, deep_link)
  values (r.requested_by,
    case when p_paid then 'تم تنفيذ طلب السحب من الصندوق' else 'تم رفض طلب السحب من الصندوق' end,
    case when p_paid and r.destination = 'wallet' then r.amount_egp || ' ج.م اتحوّلت من صندوق العمارة لمحفظتك.'
         when p_paid then r.amount_egp || ' ج.م اتحوّلت من صندوق العمارة على ' || r.payout_phone || '.'
         else 'طلب سحب ' || r.amount_egp || ' ج.م اترفض ورصيد الصندوق زي ما هو. تواصل مع الدعم لمعرفة السبب.' end,
    '/#/union-fund');
end;
$$;

create or replace function public.admin_list_union_fund_withdrawals() returns table (
  id uuid, building_id uuid, building_name text, user_id uuid, full_name text, phone text,
  amount_egp numeric, destination text, payout_phone text, note text, fund_balance numeric, created_at timestamptz
)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  return query
    select r.id, r.building_id, b.name, r.requested_by, p.full_name, p.phone,
           r.amount_egp, r.destination, r.payout_phone, r.note, coalesce(f.balance, 0), r.created_at
      from public.union_fund_withdrawal_requests r
      join public.buildings b on b.id = r.building_id
      join public.profiles p on p.id = r.requested_by
      left join public.union_funds f on f.building_id = r.building_id
     where r.status = 'pending'
     order by r.created_at;
end;
$$;


-- ---------------------------------------------------------------------
-- 7. Who paid / who didn't
-- ---------------------------------------------------------------------

-- The current period = the most recently issued dues of the building.
create or replace function public._union_current_period(p_building_id uuid) returns text
language sql
security definer
stable
set search_path = public
as $$
  select period_label from public.union_dues
   where building_id = p_building_id
   order by created_at desc, due_date desc nulls last
   limit 1;
$$;
revoke execute on function public._union_current_period(uuid) from public, anon, authenticated;

-- Board / president / treasurer: every unit with its due for the period
-- (default: the current one) and مدفوع / لسه / متأخر.
create or replace function public.union_dues_status(p_building uuid, p_period text default null)
returns table (
  unit_id uuid, unit_number text, floor_label text, residents text,
  due_id uuid, period_label text, amount numeric, due_date date,
  is_paid boolean, paid_at timestamptz, paid_via text, status text
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_period text;
begin
  if not public.can_view_union_fund(p_building) then
    raise exception 'حالة السداد للرئيس ومجلس الإدارة وأمين الصندوق بس';
  end if;
  v_period := coalesce(p_period, public._union_current_period(p_building));
  return query
    select u.id, u.unit_number, u.floor_label,
           (select string_agg(coalesce(p.full_name, 'ساكن'), '، ' order by m.created_at)
              from public.union_members m join public.profiles p on p.id = m.user_id
             where m.unit_id = u.id and m.status = 'verified'),
           d.id, d.period_label, d.amount, d.due_date, coalesce(d.is_paid, false), d.paid_at, d.paid_via,
           case when d.id is null then 'none'
                when d.is_paid then 'paid'
                when d.due_date is not null and d.due_date < current_date then 'overdue'
                else 'unpaid' end
      from public.units u
      left join public.union_dues d on d.unit_id = u.id and d.period_label = v_period
     where u.building_id = p_building
     order by (case when d.id is null then 3 when d.is_paid then 2 when d.due_date < current_date then 0 else 1 end),
              u.unit_number;
end;
$$;

-- The periods dues were issued for, newest first (for the period picker).
create or replace function public.union_due_periods(p_building uuid)
returns table (period_label text, issued_at timestamptz, total int, paid int)
language plpgsql
security definer
stable
set search_path = public
as $$
begin
  if not public.can_view_union_fund(p_building) then
    raise exception 'غير مسموح';
  end if;
  return query
    select d.period_label, max(d.created_at), count(*)::int, count(*) filter (where d.is_paid)::int
      from public.union_dues d
     where d.building_id = p_building
     group by d.period_label
     order by max(d.created_at) desc;
end;
$$;

-- Every verified member: just the collection percentage of the period.
create or replace function public.union_collection_rate(p_building uuid, p_period text default null)
returns table (period_label text, total_units int, paid_units int, pct numeric)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_period text;
begin
  if not (public.is_verified_member_of(p_building) or public.is_super_admin()) then
    raise exception 'لازم تكون ساكن موثّق في العمارة';
  end if;
  v_period := coalesce(p_period, public._union_current_period(p_building));
  if v_period is null then
    return;
  end if;
  return query
    select v_period, count(*)::int, count(*) filter (where d.is_paid)::int,
           case when count(*) = 0 then 0::numeric
                else round(count(*) filter (where d.is_paid)::numeric * 100 / count(*), 1) end
      from public.union_dues d
     where d.building_id = p_building and d.period_label = v_period;
end;
$$;

-- «فكّر الكل»: notify the members of every unit with an unpaid due.
create or replace function public.remind_unpaid_dues(p_building uuid) returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_last timestamptz;
  v_count integer;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not (
    public.is_union_fund_manager(p_building)
    or exists (select 1 from public.union_members m
                where m.building_id = p_building and m.user_id = auth.uid()
                  and m.status = 'verified' and m.role in ('president', 'board_member'))
  ) then
    raise exception 'التذكير للرئيس ومجلس الإدارة وأمين الصندوق بس';
  end if;

  select last_sent_at into v_last from public.union_due_reminders where building_id = p_building for update;
  if v_last is not null and v_last > now() - interval '24 hours' then
    raise exception 'فكّرت الجيران من شوية — تقدر تفكّرهم تاني بعد 24 ساعة من آخر تذكير';
  end if;

  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, '⏰ تذكير بمستحقات الصيانة',
         'عليك ' || sum(d.amount) || ' ج.م مستحقات صيانة لسه ما اتدفعتش (' || string_agg(d.period_label, '، ' order by d.created_at) || '). ادفع من التطبيق في ثانية.',
         '/#/union-pay'
    from public.union_dues d
    join public.union_members m on m.unit_id = d.unit_id and m.building_id = d.building_id and m.status = 'verified'
   where d.building_id = p_building and not d.is_paid
   group by m.user_id;
  get diagnostics v_count = row_count;

  insert into public.union_due_reminders (building_id, last_sent_at, sent_by)
  values (p_building, now(), auth.uid())
  on conflict (building_id) do update set last_sent_at = excluded.last_sent_at, sent_by = excluded.sent_by;

  return v_count;
end;
$$;

-- Ledger-derived financial summary (the in-app financial report).
create or replace function public.union_fund_summary(p_building uuid, p_since timestamptz default null) returns jsonb
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_result jsonb;
begin
  if not public.can_view_union_fund(p_building) then
    raise exception 'رصيد الصندوق للرئيس ومجلس الإدارة وأمين الصندوق بس';
  end if;
  select jsonb_build_object(
    'balance', coalesce((select balance from public.union_funds where building_id = p_building), 0),
    'income_wallet', coalesce(sum(t.amount) filter (where t.type = 'due_payment'), 0),
    'income_cash', coalesce(sum(t.amount) filter (where t.type = 'cash_due'), 0),
    'expenses', coalesce(-sum(t.amount) filter (where t.type = 'expense'), 0),
    'withdrawals', coalesce(-sum(t.amount) filter (where t.type = 'withdrawal'), 0),
    'adjustments', coalesce(sum(t.amount) filter (where t.type = 'adjustment'), 0),
    'pending_withdrawals', (select coalesce(sum(amount_egp), 0) from public.union_fund_withdrawal_requests
                             where building_id = p_building and status = 'pending'),
    'manager_id', public._union_fund_manager_of(p_building),
    'treasurer_id', public._union_treasurer_of(p_building),
    'expense_items', coalesce((
      select jsonb_agg(jsonb_build_object('id', e.id, 'note', e.note, 'amount', -e.amount, 'receipt_path', e.receipt_path, 'created_at', e.created_at)
                       order by e.created_at desc)
        from (select * from public.union_fund_transactions x
               where x.building_id = p_building and x.type = 'expense' and (p_since is null or x.created_at >= p_since)
               order by x.created_at desc limit 100) e
    ), '[]'::jsonb)
  ) into v_result
  from public.union_fund_transactions t
  where t.building_id = p_building and (p_since is null or t.created_at >= p_since);
  return v_result;
end;
$$;


-- ---------------------------------------------------------------------
-- 8. Treasurer: appoint / remove (president), elections
-- ---------------------------------------------------------------------

create or replace function public._is_president_of(p_building_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (select 1 from public.union_members m
                  where m.building_id = p_building_id and m.user_id = auth.uid()
                    and m.status = 'verified' and m.role = 'president');
$$;
revoke execute on function public._is_president_of(uuid) from public, anon, authenticated;

create or replace function public.appoint_union_treasurer(p_building uuid, p_user_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not public._is_president_of(p_building) then
    raise exception 'تعيين أمين الصندوق لرئيس الاتحاد بس';
  end if;
  if p_user_id = auth.uid() then
    raise exception 'إنت كرئيس بتدير الصندوق أصلاً لو مفيش أمين صندوق — اختار حد تاني';
  end if;
  if not exists (select 1 from public.union_members m
                  where m.building_id = p_building and m.user_id = p_user_id and m.status = 'verified') then
    raise exception 'أمين الصندوق لازم يكون ساكن موثّق في العمارة';
  end if;

  insert into public.union_treasurers (building_id, user_id, source, appointed_by)
  values (p_building, p_user_id, 'appointed', auth.uid())
  on conflict (building_id) do update
    set user_id = excluded.user_id, source = 'appointed', appointed_by = auth.uid(), created_at = now();

  select full_name into v_name from public.profiles where id = p_user_id;
  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id,
         case when m.user_id = p_user_id then 'بقيت أمين صندوق العمارة 💼' else 'أمين صندوق جديد للعمارة' end,
         case when m.user_id = p_user_id then 'رئيس الاتحاد عيّنك أمين للصندوق — تقدر تسجّل المصروفات والدفع الكاش من التطبيق.'
              else coalesce(v_name, 'جار') || ' بقى أمين صندوق العمارة بتعيين من رئيس الاتحاد.' end,
         '/#/union-treasurer'
    from public.union_members m
   where m.building_id = p_building and m.status = 'verified' and m.user_id <> auth.uid();
end;
$$;

create or replace function public.remove_union_treasurer(p_building uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_old uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not public._is_president_of(p_building) then
    raise exception 'شيل أمين الصندوق لرئيس الاتحاد بس';
  end if;
  delete from public.union_treasurers where building_id = p_building returning user_id into v_old;
  if v_old is null then
    raise exception 'العمارة ملهاش أمين صندوق';
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, 'تغيير في إدارة الصندوق',
         case when m.user_id = v_old then 'رئيس الاتحاد شالك من أمانة الصندوق. الصندوق رجع يتدار من الرئيس.'
              else 'العمارة ملهاش أمين صندوق دلوقتي — رئيس الاتحاد بيدير الصندوق.' end,
         '/#/union-treasurer'
    from public.union_members m
   where m.building_id = p_building and m.status = 'verified' and m.user_id <> auth.uid();
end;
$$;

-- create_election gains p_position. A treasurer election is called by
-- the president/board; a presidential one works exactly as in 0051. Only
-- one open election per office.
drop function if exists public.create_election(text, timestamptz, numeric, uuid);
create or replace function public.create_election(
  p_title text,
  p_closes_at timestamptz,
  p_legal_quorum_pct numeric default 50.00,
  p_building_id uuid default null,
  p_position text default 'president'
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_ids uuid[];
  v_eligible int;
  v_id uuid;
  v_position text := coalesce(p_position, 'president');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if v_position not in ('president', 'treasurer') then
    raise exception 'نوع الانتخابات غير صحيح';
  end if;
  if p_closes_at is null or p_closes_at < now() + interval '23 hours' then
    raise exception 'مدة التصويت يجب ألا تقل عن يوم واحد';
  end if;
  if p_closes_at > now() + interval '60 days' then
    raise exception 'مدة التصويت يجب ألا تزيد عن 60 يوماً';
  end if;

  v_building_id := public._board_building_for(p_building_id);
  if v_building_id is null and v_position = 'treasurer' then
    raise exception 'انتخابات أمين الصندوق بيبدأها رئيس الاتحاد أو مجلس الإدارة';
  end if;
  if v_building_id is null then
    -- No board role: a verified primary owner may call a presidential
    -- election in their building while it has no approved board.
    select array_agg(m.building_id) into v_ids
      from public.union_members m
     where m.user_id = auth.uid() and m.status = 'verified'
       and public.is_election_voter(m.building_id, auth.uid())
       and not public._building_has_board(m.building_id)
       and (p_building_id is null or m.building_id = p_building_id);
    if v_ids is null then
      raise exception 'غير مصرح لك بإنشاء انتخابات لهذه العمارة';
    end if;
    if array_length(v_ids, 1) > 1 then
      raise exception 'إنت مالك في أكتر من عمارة — حدّد العمارة الأول';
    end if;
    v_building_id := v_ids[1];
  end if;

  if exists (select 1 from public.union_elections
              where building_id = v_building_id and not is_finalized and position = v_position) then
    raise exception 'توجد انتخابات مفتوحة بالفعل لهذه العمارة';
  end if;

  select count(*) into v_eligible
  from public.union_members m
  join public.unit_residents ur
    on ur.user_id = m.user_id and ur.unit_id = m.unit_id
   and ur.residency_type = 'owner' and ur.is_primary
  where m.building_id = v_building_id and m.status = 'verified';

  insert into public.union_elections (building_id, title, legal_quorum_pct, eligible_voters, closes_at, position)
  values (v_building_id, p_title, 50.00, v_eligible, p_closes_at, v_position)
  returning id into v_id;

  if v_position = 'treasurer' then
    insert into public.notifications (user_id, title, body, deep_link)
    select m.user_id, '🗳️ انتخابات أمين الصندوق', 'اترشّح أو صوّت لأمين صندوق العمارة: «' || p_title || '».', '/#/union-treasurer'
      from public.union_members m
     where m.building_id = v_building_id and m.status = 'verified' and m.user_id <> auth.uid();
  end if;

  return v_id;
end;
$$;

-- finalize_election: as in 0051; the winner of a treasurer election
-- becomes the building's treasurer (the presidency is untouched).
create or replace function public.finalize_election(p_election_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_eligible int;
  v_total_votes int;
  v_top_votes int;
  v_top_count int;
  v_winner_user_id uuid;
  v_name text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id for update;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized then
    raise exception 'تم إغلاق هذه الانتخابات بالفعل';
  end if;

  if not exists (
    select 1 from public.union_members m
    where m.building_id = v_election.building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
  ) and not (
    not public._building_has_board(v_election.building_id)
    and public.is_election_voter(v_election.building_id, auth.uid())
  ) then
    raise exception 'غير مصرح لك بإغلاق هذه الانتخابات';
  end if;

  v_eligible := v_election.eligible_voters;

  select count(*) into v_total_votes
  from public.union_votes v
  where v.election_id = p_election_id
    and v.candidate_id is not null
    and public.is_election_voter(v_election.building_id, v.voter_id);

  if now() < v_election.closes_at and v_total_votes < v_eligible then
    raise exception 'لا يمكن إغلاق الانتخابات قبل موعد انتهاء التصويت';
  end if;

  update public.union_elections set
    is_finalized = true,
    result_pct = case when v_eligible > 0 then round(v_total_votes::numeric / v_eligible * 100, 2) else 0 end
  where id = p_election_id;

  if v_eligible = 0 or (v_total_votes::numeric / v_eligible * 100) < 50 then
    return;
  end if;

  with tally as (
    select v.candidate_id, count(*) as votes
    from public.union_votes v
    where v.election_id = p_election_id
      and v.candidate_id is not null
      and public.is_election_voter(v_election.building_id, v.voter_id)
    group by v.candidate_id
  )
  select max(votes), count(*) filter (where votes = (select max(votes) from tally))
    into v_top_votes, v_top_count
  from tally;

  if coalesce(v_top_votes, 0) = 0 or v_top_count <> 1 then
    return;
  end if;

  select c.user_id into v_winner_user_id
  from public.union_candidates c
  where c.election_id = p_election_id
    and c.id = (
      select v.candidate_id
      from public.union_votes v
      where v.election_id = p_election_id
        and v.candidate_id is not null
        and public.is_election_voter(v_election.building_id, v.voter_id)
      group by v.candidate_id
      order by count(*) desc
      limit 1
    );

  if v_winner_user_id is null then
    return;
  end if;

  if v_election.position = 'treasurer' then
    insert into public.union_treasurers (building_id, user_id, source, appointed_by)
    values (v_election.building_id, v_winner_user_id, 'elected', null)
    on conflict (building_id) do update
      set user_id = excluded.user_id, source = 'elected', appointed_by = null, created_at = now();

    select full_name into v_name from public.profiles where id = v_winner_user_id;
    insert into public.notifications (user_id, title, body, deep_link)
    select m.user_id,
           case when m.user_id = v_winner_user_id then 'مبروك! اتنتخبت أمين صندوق العمارة 🎉' else 'نتيجة انتخابات أمين الصندوق' end,
           case when m.user_id = v_winner_user_id then 'الملاك اختاروك أمين للصندوق — تقدر تدير الصندوق من التطبيق.'
                else coalesce(v_name, 'جار') || ' اتنتخب أمين صندوق العمارة.' end,
           '/#/union-treasurer'
      from public.union_members m
     where m.building_id = v_election.building_id and m.status = 'verified';
    return;
  end if;

  update public.union_members set role = 'board_member'
    where building_id = v_election.building_id and role = 'president' and user_id <> v_winner_user_id;

  update public.union_members set role = 'president'
    where building_id = v_election.building_id and user_id = v_winner_user_id;

  update public.president_requests set status = 'superseded', reviewed_at = now()
   where building_id = v_election.building_id and status = 'pending';
end;
$$;


-- ---------------------------------------------------------------------
-- 9. Building invite code: show / rotate (president & board)
-- ---------------------------------------------------------------------

create or replace function public.get_building_invite_code(p_building uuid) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid := public._board_building_for(p_building);
  v_code text;
begin
  if v_building_id is null then
    raise exception 'كود الدعوة للرئيس ومجلس الإدارة بس';
  end if;
  select code into v_code from public.union_invite_codes
   where building_id = v_building_id
     and used_count < max_uses
     and (expires_at is null or expires_at > now())
   order by created_at desc
   limit 1;
  if v_code is null then
    v_code := 'BLD-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    insert into public.union_invite_codes (building_id, code, issued_by, max_uses, used_count)
    values (v_building_id, v_code, auth.uid(), 9999, 0);
  end if;
  return v_code;
end;
$$;

-- The old code(s) stop working immediately.
create or replace function public.rotate_building_invite_code(p_building uuid) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid := public._board_building_for(p_building);
  v_code text;
begin
  if v_building_id is null then
    raise exception 'تغيير كود الدعوة للرئيس ومجلس الإدارة بس';
  end if;
  update public.union_invite_codes set expires_at = now() - interval '1 second'
   where building_id = v_building_id and (expires_at is null or expires_at > now());
  loop
    v_code := 'BLD-' || upper(substr(md5(random()::text || clock_timestamp()::text), 1, 6));
    exit when not exists (select 1 from public.union_invite_codes where code = v_code);
  end loop;
  insert into public.union_invite_codes (building_id, code, issued_by, max_uses, used_count)
  values (v_building_id, v_code, auth.uid(), 9999, 0);
  return v_code;
end;
$$;


-- ---------------------------------------------------------------------
-- 10. A join request notifies the president and the board
-- ---------------------------------------------------------------------

create or replace function public._notify_union_join_request() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
  v_building text;
  v_unit text;
begin
  if new.status <> 'pending' then
    return new;
  end if;
  select full_name into v_name from public.profiles where id = new.user_id;
  select name into v_building from public.buildings where id = new.building_id;
  select unit_number into v_unit from public.units where id = new.unit_id;
  insert into public.notifications (user_id, title, body, deep_link)
  select m.user_id, '🏠 طلب انضمام جديد',
         coalesce(v_name, 'جار جديد') || ' طالب ينضم لـ«' || coalesce(v_building, 'العمارة') || '»'
           || coalesce(' — شقة ' || v_unit, '') || '. راجع الطلب ووافق أو ارفض.',
         '/#/union-approvals'
    from public.union_members m
   where m.building_id = new.building_id and m.status = 'verified'
     and m.role in ('president', 'board_member') and m.user_id <> new.user_id;
  return new;
end;
$$;
revoke execute on function public._notify_union_join_request() from public, anon, authenticated;

drop trigger if exists notify_union_join_request on public.union_members;
create trigger notify_union_join_request
  after insert on public.union_members
  for each row execute function public._notify_union_join_request();


-- ---------------------------------------------------------------------
-- 11. Grants
-- ---------------------------------------------------------------------

revoke execute on function public.pay_union_due(uuid) from public, anon;
revoke execute on function public.mark_due_paid_cash(uuid, text) from public, anon;
revoke execute on function public.record_union_expense(uuid, numeric, text, text) from public, anon;
revoke execute on function public.request_fund_withdrawal(uuid, numeric, text, text) from public, anon;
revoke execute on function public.review_union_fund_withdrawal(uuid, boolean) from public, anon;
revoke execute on function public.admin_list_union_fund_withdrawals() from public, anon;
revoke execute on function public.union_dues_status(uuid, text) from public, anon;
revoke execute on function public.union_due_periods(uuid) from public, anon;
revoke execute on function public.union_collection_rate(uuid, text) from public, anon;
revoke execute on function public.remind_unpaid_dues(uuid) from public, anon;
revoke execute on function public.union_fund_summary(uuid, timestamptz) from public, anon;
revoke execute on function public.appoint_union_treasurer(uuid, uuid) from public, anon;
revoke execute on function public.remove_union_treasurer(uuid) from public, anon;
revoke execute on function public.create_election(text, timestamptz, numeric, uuid, text) from public, anon;
revoke execute on function public.finalize_election(uuid) from public, anon;
revoke execute on function public.get_building_invite_code(uuid) from public, anon;
revoke execute on function public.rotate_building_invite_code(uuid) from public, anon;

grant execute on function public.pay_union_due(uuid) to authenticated;
grant execute on function public.mark_due_paid_cash(uuid, text) to authenticated;
grant execute on function public.record_union_expense(uuid, numeric, text, text) to authenticated;
grant execute on function public.request_fund_withdrawal(uuid, numeric, text, text) to authenticated;
grant execute on function public.review_union_fund_withdrawal(uuid, boolean) to authenticated;
grant execute on function public.admin_list_union_fund_withdrawals() to authenticated;
grant execute on function public.union_dues_status(uuid, text) to authenticated;
grant execute on function public.union_due_periods(uuid) to authenticated;
grant execute on function public.union_collection_rate(uuid, text) to authenticated;
grant execute on function public.remind_unpaid_dues(uuid) to authenticated;
grant execute on function public.union_fund_summary(uuid, timestamptz) to authenticated;
grant execute on function public.appoint_union_treasurer(uuid, uuid) to authenticated;
grant execute on function public.remove_union_treasurer(uuid) to authenticated;
grant execute on function public.create_election(text, timestamptz, numeric, uuid, text) to authenticated;
grant execute on function public.finalize_election(uuid) to authenticated;
grant execute on function public.get_building_invite_code(uuid) to authenticated;
grant execute on function public.rotate_building_invite_code(uuid) to authenticated;
