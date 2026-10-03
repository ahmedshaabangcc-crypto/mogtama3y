-- =====================================================================
-- Migration 0050 — booking a technician without a building union.
--
-- Owners' unions now live in their own app; مُجتمعي no longer asks people
-- to join a building. Booking a technician used to require a verified
-- union unit (the technician's only way to know where to go). Now the
-- resident's digital address ("عنوانك الإلكتروني", 0048) works too: the
-- address is snapshotted onto the request at booking time, so the
-- technician sees exactly where to go even if the owner edits it later.
-- A verified unit still works as before.
-- =====================================================================

alter table public.maintenance_requests alter column unit_id drop not null;
alter table public.maintenance_requests add column if not exists service_address text;
alter table public.maintenance_requests add column if not exists service_landmark text;
alter table public.maintenance_requests add column if not exists service_lat double precision;
alter table public.maintenance_requests add column if not exists service_lng double precision;
alter table public.maintenance_requests add column if not exists service_address_code text;
-- Readable by the resident and the assigned technician (row policies from 0022).
grant select (service_address, service_landmark, service_lat, service_lng, service_address_code)
  on public.maintenance_requests to authenticated;

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
  v_technician_user_id uuid;
  v_wallet record;
  v_request_id uuid;
  v_addr public.e_addresses;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_inspection_fee is null or p_inspection_fee <= 0 then
    raise exception 'قيمة رسوم المعاينة غير صحيحة';
  end if;

  select user_id into v_technician_user_id from public.technicians where id = p_technician_id;
  if v_technician_user_id is null then
    raise exception 'الفني غير موجود';
  end if;
  if v_technician_user_id = auth.uid() then
    raise exception 'لا يمكنك حجز خدمة من نفسك';
  end if;

  -- Where to go: the resident's digital address (the one opened by their
  -- mobile number first, else the newest), or their verified union unit.
  select * into v_addr from public.e_addresses
   where owner_id = auth.uid() and is_active
   order by phone_lookup desc, updated_at desc
   limit 1;
  select unit_id into v_unit_id from public.union_members
    where user_id = auth.uid() and status = 'verified' limit 1;
  if v_addr.id is null and v_unit_id is null then
    raise exception 'اعمل «عنوانك الإلكتروني» الأول عشان الفني يعرف يوصلك';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < p_inspection_fee then
    raise exception 'رصيد المحفظة غير كافٍ لحجز الضمان';
  end if;

  insert into public.maintenance_requests (
    unit_id, resident_id, technician_id, category, description, status, quoted_amount, escrow_amount, escrow_status,
    service_address, service_landmark, service_lat, service_lng, service_address_code)
  values (
    v_unit_id, auth.uid(), p_technician_id, p_category, p_description, 'requested', p_inspection_fee, p_inspection_fee, 'held',
    case when v_addr.id is not null then concat_ws('، ',
      'عمارة ' || v_addr.building, 'الدور ' || v_addr.floor, 'شقة ' || v_addr.apartment,
      v_addr.street, v_addr.district, v_addr.city, v_addr.governorate) end,
    v_addr.landmark, v_addr.lat, v_addr.lng, v_addr.code)
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

revoke execute on function public.book_maintenance_service(uuid, text, text, numeric) from public, anon;
grant execute on function public.book_maintenance_service(uuid, text, text, numeric) to authenticated;
