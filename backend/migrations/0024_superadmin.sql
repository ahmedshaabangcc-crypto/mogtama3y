-- =====================================================================
-- Migration 0024 — real superadmin panel: platform stats, shop-claim
-- review, and maintenance-escrow dispute arbitration. Run after
-- 0002-0023, in order, in the Supabase SQL editor.
--
-- profiles.user_role already had a 'super_admin' value sitting in its
-- enum since schema.sql was first written, with nothing checking it
-- anywhere. IMPORTANT — after running this, promote yourself manually
-- (there's deliberately no self-service way to grant platform admin):
--   update public.profiles set role = 'super_admin' where id = '<your auth.users id>';
-- Find your id via Authentication > Users in the Supabase dashboard,
-- or `select id from auth.users where email = '...';` in the SQL editor.
--
-- Scope decisions:
--  * The stats are returned by one SECURITY DEFINER RPC rather than
--    granting admins broad table access — an admin sees the totals
--    (how much is held in escrow platform-wide), not a browsable list
--    of every resident's individual wallet balance.
--  * Admin visibility into maintenance_requests is narrowed to
--    status = 'disputed' only — arbitration needs those, nothing else.
--  * A dispute has to come from somewhere: flag_maintenance_dispute()
--    lets either party (resident or the assigned technician) flag a
--    held escrow as disputed instead of the normal confirm/cancel
--    path. There's no admin inbox yet, so this doesn't notify anyone —
--    an admin just has to check the panel.
-- =====================================================================

create or replace function public.is_super_admin() returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'super_admin');
$$;

-- ---- platform stats ----

create or replace function public.fetch_admin_dashboard_stats() returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_result jsonb;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة';
  end if;

  select jsonb_build_object(
    'buildings_count', (select count(*) from public.buildings),
    'presidents_count', (select count(*) from public.union_members where role = 'president' and status = 'verified'),
    'total_held_escrow', (select coalesce(sum(held_balance), 0) from public.wallets),
    'pending_shop_claims_count', (select count(*) from public.shop_claim_requests where status = 'pending'),
    'disputed_requests_count', (select count(*) from public.maintenance_requests where status = 'disputed')
  ) into v_result;

  return v_result;
end;
$$;

grant execute on function public.fetch_admin_dashboard_stats() to authenticated;

-- ---- shop claim review ----

create policy "shop_claim_requests: super_admin views all" on public.shop_claim_requests
  for select using (public.is_super_admin());

create or replace function public.review_shop_claim(p_request_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات تملك المحلات';
  end if;

  select * into v_request from public.shop_claim_requests where id = p_request_id for update;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;

  update public.shop_claim_requests set status = case when p_approve then 'approved' else 'rejected' end, reviewed_by = auth.uid()
    where id = p_request_id;

  if p_approve then
    update public.shops set owner_id = v_request.requester_id, is_claimed = true, claimed_at = now()
      where id = v_request.shop_id;
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.requester_id,
    case when p_approve then 'تم قبول طلب تملك المحل' else 'تم رفض طلب تملك المحل' end,
    case when p_approve then 'تهانينا! تم تفعيل ملكيتك للمحل، يمكنك الآن إدارته من التطبيق.'
         else 'للأسف تم رفض طلب تملك المحل، تواصل مع الدعم لمزيد من التفاصيل.' end
  );
end;
$$;

grant execute on function public.review_shop_claim(uuid, boolean) to authenticated;

-- ---- maintenance dispute arbitration ----

create policy "maintenance_requests: super_admin views disputed" on public.maintenance_requests
  for select using (public.is_super_admin() and status = 'disputed');

create or replace function public.flag_maintenance_dispute(p_request_id uuid, p_reason text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_is_party boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_request from public.maintenance_requests where id = p_request_id for update;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;
  if v_request.escrow_status <> 'held' then
    raise exception 'لا يوجد مبلغ ضمان معلّق على هذا الطلب';
  end if;

  select v_request.resident_id = auth.uid()
    or exists (select 1 from public.technicians t where t.id = v_request.technician_id and t.user_id = auth.uid())
    into v_is_party;
  if not v_is_party then
    raise exception 'غير مصرح لك بفتح نزاع على هذا الطلب';
  end if;

  update public.maintenance_requests set status = 'disputed', escrow_status = 'disputed' where id = p_request_id;

  insert into public.maintenance_messages (request_id, sender_id, body)
  values (p_request_id, auth.uid(), 'تم فتح نزاع: ' || p_reason);
end;
$$;

grant execute on function public.flag_maintenance_dispute(uuid, text) to authenticated;

create or replace function public.resolve_maintenance_dispute(p_request_id uuid, p_release_to_technician boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_resident_wallet record;
  v_technician_user_id uuid;
  v_technician_wallet record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بفض هذا النزاع';
  end if;

  select * into v_request from public.maintenance_requests where id = p_request_id for update;
  if not found or v_request.status <> 'disputed' then
    raise exception 'لا يوجد نزاع مفتوح على هذا الطلب';
  end if;

  select * into v_resident_wallet from public.wallets where user_id = v_request.resident_id for update;
  select user_id into v_technician_user_id from public.technicians where id = v_request.technician_id;
  select * into v_technician_wallet from public.wallets where user_id = v_technician_user_id for update;

  update public.wallets set held_balance = greatest(held_balance - v_request.quoted_amount, 0), updated_at = now()
    where id = v_resident_wallet.id;

  if p_release_to_technician then
    update public.wallets set available_balance = available_balance + v_request.quoted_amount, updated_at = now()
      where id = v_technician_wallet.id;
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_technician_wallet.id, 'maintenance_payment', 'completed', v_request.quoted_amount, 'maintenance_requests', p_request_id);
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_resident_wallet.id, 'maintenance_payment', 'completed', -v_request.quoted_amount, 'maintenance_requests', p_request_id);
    update public.maintenance_requests set status = 'completed', escrow_status = 'released' where id = p_request_id;
  else
    update public.wallets set available_balance = available_balance + v_request.quoted_amount, updated_at = now()
      where id = v_resident_wallet.id;
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_resident_wallet.id, 'refund', 'completed', v_request.quoted_amount, 'maintenance_requests', p_request_id);
    update public.maintenance_requests set status = 'cancelled', escrow_status = 'refunded' where id = p_request_id;
  end if;
end;
$$;

grant execute on function public.resolve_maintenance_dispute(uuid, boolean) to authenticated;
