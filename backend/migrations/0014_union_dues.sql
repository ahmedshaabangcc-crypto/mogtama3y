-- =====================================================================
-- Migration 0014 — real union dues (maintenance subscriptions), paid
-- from the in-app wallet. union_dues had RLS enabled with no policies
-- and no grants. Run after 0002-0013, in order, in the Supabase SQL
-- editor.
--
-- Design: creating dues (for a whole building at once) and paying a
-- due are both done through SECURITY DEFINER functions, not raw
-- table access — creating dues is president/board-only, and paying
-- one has to atomically move real money (deduct the wallet, log a
-- wallet_transactions row, mark the due paid) so it can never end up
-- half-done.
-- =====================================================================

grant select on public.union_dues to authenticated;

create policy "union_dues: unit resident views own" on public.union_dues
  for select using (
    exists (
      select 1 from public.union_members m
      where m.unit_id = union_dues.unit_id and m.user_id = auth.uid()
    )
  );

create policy "union_dues: building admin views all" on public.union_dues
  for select using (
    exists (
      select 1 from public.union_members m
      where m.building_id = union_dues.building_id
        and m.user_id = auth.uid()
        and m.status = 'verified'
        and m.role in ('president', 'board_member')
    )
  );

-- ---- create_union_due(): president/board issues a due for every unit in their building ----

create or replace function public.create_union_due(
  p_period_label text,
  p_amount numeric,
  p_due_date date
) returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_is_authorized boolean;
  v_count integer;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select building_id into v_building_id from public.union_members
    where user_id = auth.uid() and status = 'verified' and role in ('president', 'board_member')
    limit 1;

  if v_building_id is null then
    raise exception 'غير مصرح لك بإصدار مستحقات صيانة';
  end if;

  insert into public.union_dues (building_id, unit_id, period_label, amount, due_date)
  select v_building_id, u.id, p_period_label, p_amount, p_due_date
  from public.units u
  where u.building_id = v_building_id;

  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

grant execute on function public.create_union_due(text, numeric, date) to authenticated;

-- ---- pay_union_due(): atomically pay a due from the caller's wallet ----

create or replace function public.pay_union_due(p_due_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_due record;
  v_wallet record;
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

  if not exists (
    select 1 from public.union_members m
    where m.unit_id = v_due.unit_id and m.user_id = auth.uid()
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
end;
$$;

grant execute on function public.pay_union_due(uuid) to authenticated;
