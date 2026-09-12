-- =====================================================================
-- Migration 0022 — real technicians directory + escrow-backed
-- maintenance bookings. technicians/maintenance_requests/
-- maintenance_messages have sat in schema.sql since the start with RLS
-- enabled and no policies. wallets.held_balance has existed the whole
-- time too but nothing has ever used it — union dues (0014) only ever
-- moved available_balance straight to 'completed'. This is the first
-- real escrow: booking moves the fee from available -> held, and it
-- only reaches the technician's wallet once the resident types back a
-- one-time code. Run after 0002-0021, in order, in the Supabase SQL
-- editor.
--
-- Security note on the handshake OTP: both the resident and the
-- assigned technician can otherwise read the same maintenance_requests
-- row (needed so both sides see status/quote/schedule), so a plain RLS
-- row policy can't hide the OTP column from the technician alone —
-- RLS filters ROWS, not columns. Instead we use a genuine Postgres
-- column-level GRANT that excludes handshake_otp from what the
-- `authenticated` role can ever SELECT directly; the only way to read
-- or check it is through the SECURITY DEFINER functions below, which
-- bypass column grants as the functions' owner. So even though the
-- technician can see the rest of the row, they can never read the code
-- the resident is supposed to keep to themselves and hand over in
-- person once the work is actually done.
-- =====================================================================

-- ---- technicians: public directory, self-registration only ----

grant select on public.technicians to authenticated;

create policy "technicians: public read" on public.technicians
  for select using (true);

create or replace function public.register_technician(p_category text, p_bio text, p_service_area text) returns uuid
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

  insert into public.technicians (user_id, category, bio, service_area)
  values (auth.uid(), p_category, p_bio, p_service_area)
  returning id into v_id;

  return v_id;
end;
$$;

grant execute on function public.register_technician(text, text, text) to authenticated;

create or replace function public.update_technician_profile(p_technician_id uuid, p_category text, p_bio text, p_service_area text) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  update public.technicians set category = p_category, bio = p_bio, service_area = p_service_area
    where id = p_technician_id and user_id = auth.uid();

  if not found then
    raise exception 'غير مصرح لك بتعديل هذا الملف';
  end if;
end;
$$;

grant execute on function public.update_technician_profile(uuid, text, text, text) to authenticated;

-- ---- maintenance_requests: column-restricted grant (see note above) ----

grant select (
  id, unit_id, resident_id, technician_id, category, description, status,
  quoted_amount, escrow_status, visit_scheduled_at, completed_at, created_at
) on public.maintenance_requests to authenticated;

create policy "maintenance_requests: resident views own" on public.maintenance_requests
  for select using (auth.uid() = resident_id);

create policy "maintenance_requests: technician views assigned" on public.maintenance_requests
  for select using (
    exists (select 1 from public.technicians t where t.id = maintenance_requests.technician_id and t.user_id = auth.uid())
  );

-- ---- maintenance_messages: simple two-party chat per request ----

grant select, insert on public.maintenance_messages to authenticated;

create policy "maintenance_messages: participants view" on public.maintenance_messages
  for select using (
    exists (
      select 1 from public.maintenance_requests r
      where r.id = maintenance_messages.request_id
        and (r.resident_id = auth.uid() or exists (select 1 from public.technicians t where t.id = r.technician_id and t.user_id = auth.uid()))
    )
  );

create policy "maintenance_messages: participants send" on public.maintenance_messages
  for insert with check (
    auth.uid() = sender_id
    and exists (
      select 1 from public.maintenance_requests r
      where r.id = maintenance_messages.request_id
        and (r.resident_id = auth.uid() or exists (select 1 from public.technicians t where t.id = r.technician_id and t.user_id = auth.uid()))
    )
  );

-- ---- book_maintenance_service(): move the inspection fee into escrow ----

create or replace function public.book_maintenance_service(
  p_technician_id uuid,
  p_category text,
  p_description text,
  p_inspection_fee numeric
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_unit_id uuid;
  v_wallet record;
  v_request_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select unit_id into v_unit_id from public.union_members
    where user_id = auth.uid() and status = 'verified' limit 1;
  if v_unit_id is null then
    raise exception 'يجب الانضمام لعمارتك أولاً قبل حجز خدمة صيانة';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < p_inspection_fee then
    raise exception 'رصيد المحفظة غير كافٍ لحجز الضمان';
  end if;

  insert into public.maintenance_requests (unit_id, resident_id, technician_id, category, description, status, quoted_amount, escrow_status)
  values (v_unit_id, auth.uid(), p_technician_id, p_category, p_description, 'requested', p_inspection_fee, 'held')
  returning id into v_request_id;

  update public.wallets set
    available_balance = available_balance - p_inspection_fee,
    held_balance = held_balance + p_inspection_fee,
    updated_at = now()
  where id = v_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'maintenance_payment', 'held', -p_inspection_fee, 'maintenance_requests', v_request_id);

  return v_request_id;
end;
$$;

grant execute on function public.book_maintenance_service(uuid, text, text, numeric) to authenticated;

-- ---- update_request_status(): technician moves the job forward ----

create or replace function public.update_request_status(
  p_request_id uuid,
  p_status text,
  p_quoted_amount numeric default null,
  p_visit_scheduled_at timestamptz default null
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_status not in ('quoted', 'scheduled', 'in_progress') then
    raise exception 'حالة غير صحيحة';
  end if;

  select r.* into v_request from public.maintenance_requests r
    join public.technicians t on t.id = r.technician_id
    where r.id = p_request_id and t.user_id = auth.uid();
  if not found then
    raise exception 'غير مصرح لك بتحديث هذا الطلب';
  end if;

  update public.maintenance_requests set
    status = p_status::maintenance_status,
    quoted_amount = coalesce(p_quoted_amount, quoted_amount),
    visit_scheduled_at = coalesce(p_visit_scheduled_at, visit_scheduled_at)
  where id = p_request_id;
end;
$$;

grant execute on function public.update_request_status(uuid, text, numeric, timestamptz) to authenticated;

-- ---- request_escrow_release(): technician says the job's done ----

create or replace function public.request_escrow_release(p_request_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_otp text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select r.* into v_request from public.maintenance_requests r
    join public.technicians t on t.id = r.technician_id
    where r.id = p_request_id and t.user_id = auth.uid();
  if not found then
    raise exception 'غير مصرح لك بإنهاء هذا الطلب';
  end if;
  if v_request.escrow_status <> 'held' then
    raise exception 'لا يوجد مبلغ ضمان معلّق على هذا الطلب';
  end if;

  v_otp := lpad((floor(random() * 1000000))::int::text, 6, '0');

  update public.maintenance_requests set
    status = 'completed',
    completed_at = now(),
    handshake_otp = v_otp
  where id = p_request_id;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.resident_id,
    'كود تأكيد استلام الخدمة',
    'الفني أبلغ بإتمام العمل. كود التأكيد: ' || v_otp || ' — أعطه للفني بعد التأكد من جودة العمل فقط، وهذا هو ما يُفرج عن مبلغ الضمان له.'
  );
end;
$$;

grant execute on function public.request_escrow_release(uuid) to authenticated;

-- ---- confirm_completion_and_release(): resident hands over the code, funds move ----

create or replace function public.confirm_completion_and_release(p_request_id uuid, p_otp text) returns void
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
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_request from public.maintenance_requests where id = p_request_id for update;
  if not found or v_request.resident_id <> auth.uid() then
    raise exception 'غير مصرح لك بتأكيد هذا الطلب';
  end if;
  if v_request.escrow_status <> 'held' then
    raise exception 'لا يوجد مبلغ ضمان معلّق على هذا الطلب';
  end if;
  if v_request.handshake_otp is null or v_request.handshake_otp <> p_otp then
    raise exception 'كود التأكيد غير صحيح';
  end if;

  select * into v_resident_wallet from public.wallets where user_id = auth.uid() for update;

  select user_id into v_technician_user_id from public.technicians where id = v_request.technician_id;
  select * into v_technician_wallet from public.wallets where user_id = v_technician_user_id for update;

  update public.wallets set held_balance = greatest(held_balance - v_request.quoted_amount, 0), updated_at = now()
    where id = v_resident_wallet.id;
  update public.wallets set available_balance = available_balance + v_request.quoted_amount, updated_at = now()
    where id = v_technician_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_resident_wallet.id, 'maintenance_payment', 'completed', -v_request.quoted_amount, 'maintenance_requests', p_request_id);
  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_technician_wallet.id, 'maintenance_payment', 'completed', v_request.quoted_amount, 'maintenance_requests', p_request_id);

  update public.maintenance_requests set escrow_status = 'released' where id = p_request_id;
  update public.technicians set rating_count = rating_count + 1 where id = v_request.technician_id;
end;
$$;

grant execute on function public.confirm_completion_and_release(uuid, text) to authenticated;

-- ---- cancel_maintenance_request(): refund before work starts ----

create or replace function public.cancel_maintenance_request(p_request_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_wallet record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_request from public.maintenance_requests where id = p_request_id for update;
  if not found or v_request.resident_id <> auth.uid() then
    raise exception 'غير مصرح لك بإلغاء هذا الطلب';
  end if;
  if v_request.status not in ('requested', 'quoted') then
    raise exception 'لا يمكن إلغاء الطلب بعد بدء الزيارة';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;

  update public.wallets set
    available_balance = available_balance + v_request.quoted_amount,
    held_balance = greatest(held_balance - v_request.quoted_amount, 0),
    updated_at = now()
  where id = v_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'refund', 'completed', v_request.quoted_amount, 'maintenance_requests', p_request_id);

  update public.maintenance_requests set status = 'cancelled', escrow_status = 'refunded' where id = p_request_id;
end;
$$;

grant execute on function public.cancel_maintenance_request(uuid) to authenticated;
