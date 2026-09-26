-- =====================================================================
-- Migration 0037 — lock down privilege and money columns.
--
-- Before this, any signed-in user could, straight from the browser
-- console with the public key:
--   * update their own profiles row with role = 'super_admin',
--     is_verified = true, or any ad_token_balance ("profiles: user can
--     update own" had no column limit and no WITH CHECK);
--   * insert/update their own wallets row with any available_balance
--     ("wallets: owner only" was FOR ALL);
--   * set is_featured / featured_until on their own listings for free;
--   * mint wallet money through the money RPCs, which trusted caller
--     amounts: a negative union due (paying it credits the wallet), a
--     negative inspection fee, or a technician raising quoted_amount
--     while the fee sat in escrow (release/refund then paid out the new
--     amount, not what was actually held).
--
-- Approach:
--   1. profiles + wallets are created server-side only — a trigger on
--      auth.users for new sign-ups, plus an idempotent ensure_my_profile()
--      RPC the app calls on sign-in (covers existing users and replaces
--      the racy client-side check-then-insert).
--   2. Clients lose INSERT on profiles/wallets/wallet_transactions and
--      UPDATE on wallets; profiles UPDATE is limited to safe columns.
--   3. A guard trigger (defence in depth, independent of grants) rejects
--      changes to protected columns when the caller is the API role
--      itself (`authenticated`/`anon`). SECURITY DEFINER functions run
--      as their owner, so review_token_topup, feature_listing etc. keep
--      working, and so does the SQL editor.
--   4. The money RPCs validate amounts, and escrow pays out a frozen
--      escrow_amount recorded at booking time.
--
-- Run after 0002–0036, in order, in the Supabase SQL editor. Deploy the
-- matching app build (auth_service.dart calls ensure_my_profile) AFTER
-- this has run. Then run backend/audit/0037_post_fix_audit.sql to look
-- for signs the old holes were already used.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Server-side profile + wallet creation
-- ---------------------------------------------------------------------

create or replace function public._create_profile_and_wallet(p_user_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_meta jsonb;
  v_name text;
  v_phone text;
  v_avatar text;
begin
  select coalesce(raw_user_meta_data, '{}'::jsonb) into v_meta from auth.users where id = p_user_id;
  if not found then
    return;
  end if;

  v_name := nullif(trim(coalesce(v_meta->>'full_name', v_meta->>'name', '')), '');
  v_phone := nullif(trim(coalesce(v_meta->>'phone', '')), '');
  v_avatar := coalesce(v_meta->>'avatar_url', v_meta->>'picture');

  begin
    insert into public.profiles (id, full_name, phone, avatar_url)
    values (p_user_id, coalesce(v_name, 'عضو مُجتمعي'), v_phone, v_avatar)
    on conflict (id) do nothing;
  exception when unique_violation then
    -- profiles.phone is unique: if the sign-up phone is already taken,
    -- still create the account, just without the phone.
    insert into public.profiles (id, full_name, avatar_url)
    values (p_user_id, coalesce(v_name, 'عضو مُجتمعي'), v_avatar)
    on conflict (id) do nothing;
  end;

  insert into public.wallets (user_id) values (p_user_id)
  on conflict (user_id) do nothing;
end;
$$;

revoke execute on function public._create_profile_and_wallet(uuid) from public, anon, authenticated;

create or replace function public.handle_new_auth_user() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public._create_profile_and_wallet(new.id);
  return new;
exception when others then
  -- Never block a sign-up on this; ensure_my_profile() retries on sign-in.
  raise warning 'handle_new_auth_user failed for %: %', new.id, sqlerrm;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

create or replace function public.ensure_my_profile() returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  perform public._create_profile_and_wallet(auth.uid());
end;
$$;

revoke execute on function public.ensure_my_profile() from public, anon;
grant execute on function public.ensure_my_profile() to authenticated;

-- Backfill anyone who signed up but never got a profile or wallet.
do $$
declare
  v_id uuid;
begin
  for v_id in
    select u.id from auth.users u
    where not exists (select 1 from public.profiles p where p.id = u.id)
       or not exists (select 1 from public.wallets w where w.user_id = u.id)
  loop
    perform public._create_profile_and_wallet(v_id);
  end loop;
end;
$$;


-- ---------------------------------------------------------------------
-- 2. Grants and policies
-- ---------------------------------------------------------------------

-- profiles: no direct inserts; updates only on the user-editable columns.
drop policy if exists "profiles: user can insert own" on public.profiles;
revoke insert, update on public.profiles from authenticated, anon;
grant update (full_name, phone, phone_hidden, avatar_url, updated_at) on public.profiles to authenticated;

drop policy if exists "profiles: user can update own" on public.profiles;
create policy "profiles: user can update own" on public.profiles
  for update using (auth.uid() = id) with check (auth.uid() = id);

-- wallets: read-only for their owner. Every balance change goes through
-- a SECURITY DEFINER function.
drop policy if exists "wallets: owner only" on public.wallets;
create policy "wallets: owner reads own" on public.wallets
  for select using (auth.uid() = user_id);
revoke insert, update, delete on public.wallets from authenticated, anon;

-- wallet_transactions: ledger rows are written by the RPCs only.
revoke insert, update, delete on public.wallet_transactions from authenticated, anon;


-- ---------------------------------------------------------------------
-- 3. Guard triggers (defence in depth)
-- ---------------------------------------------------------------------

create or replace function public.guard_profile_protected_columns() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if new.id is distinct from old.id
       or new.role is distinct from old.role
       or new.is_verified is distinct from old.is_verified
       or new.ad_token_balance is distinct from old.ad_token_balance
       or new.wallet_id is distinct from old.wallet_id
       or new.created_at is distinct from old.created_at then
      raise exception 'لا يمكن تعديل هذه البيانات' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_profile_protected_columns on public.profiles;
create trigger guard_profile_protected_columns
  before update on public.profiles
  for each row execute function public.guard_profile_protected_columns();

-- Featured status is paid for with tokens via feature_listing(); the
-- seller must not be able to set it directly on insert or update.
create or replace function public.guard_listing_featured_columns() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if tg_op = 'INSERT' then
      new.is_featured := false;
      new.featured_until := null;
    elsif new.is_featured is distinct from old.is_featured
       or new.featured_until is distinct from old.featured_until then
      raise exception 'تمييز الإعلان يتم عبر التوكن فقط' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_listing_featured_columns on public.marketplace_listings;
create trigger guard_listing_featured_columns
  before insert or update on public.marketplace_listings
  for each row execute function public.guard_listing_featured_columns();

drop trigger if exists guard_listing_featured_columns on public.real_estate_listings;
create trigger guard_listing_featured_columns
  before insert or update on public.real_estate_listings
  for each row execute function public.guard_listing_featured_columns();

drop trigger if exists guard_listing_featured_columns on public.job_postings;
create trigger guard_listing_featured_columns
  before insert or update on public.job_postings
  for each row execute function public.guard_listing_featured_columns();


-- ---------------------------------------------------------------------
-- 4. Union dues: amounts must be positive
-- ---------------------------------------------------------------------

-- NOT VALID: enforced for every new/updated row without failing on any
-- bad rows that may already exist (the audit script lists those).
alter table public.union_dues drop constraint if exists union_dues_amount_positive;
alter table public.union_dues add constraint union_dues_amount_positive check (amount > 0) not valid;

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
  v_count integer;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_amount is null or p_amount <= 0 then
    raise exception 'قيمة المستحق يجب أن تكون أكبر من صفر';
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

  insert into public.notifications (user_id, title, body)
  select m.user_id,
         'مستحق صيانة جديد',
         p_period_label || ' - ' || p_amount || ' ج.م، تاريخ الاستحقاق ' || p_due_date
  from public.union_members m
  where m.building_id = v_building_id and m.status = 'verified';

  return v_count;
end;
$$;

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
  if v_due.amount <= 0 then
    raise exception 'قيمة المستحق غير صحيحة';
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


-- ---------------------------------------------------------------------
-- 5. Maintenance escrow: pay out exactly what was held
-- ---------------------------------------------------------------------

-- quoted_amount stays the technician's (editable) price quote. The money
-- actually moved into escrow at booking is frozen in escrow_amount, and
-- that is the only amount release/refund/dispute ever move.
alter table public.maintenance_requests add column if not exists escrow_amount numeric(12,2);

-- Backfill from the ledger row written at booking time (the true amount
-- held), not from quoted_amount, which may have been inflated since.
update public.maintenance_requests r
set escrow_amount = -t.amount
from public.wallet_transactions t
where r.escrow_amount is null
  and t.reference_table = 'maintenance_requests'
  and t.reference_id = r.id
  and t.type = 'maintenance_payment'
  and t.status = 'held';

grant select (escrow_amount) on public.maintenance_requests to authenticated;

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

  select unit_id into v_unit_id from public.union_members
    where user_id = auth.uid() and status = 'verified' limit 1;
  if v_unit_id is null then
    raise exception 'يجب الانضمام لعمارتك أولاً قبل حجز خدمة صيانة';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < p_inspection_fee then
    raise exception 'رصيد المحفظة غير كافٍ لحجز الضمان';
  end if;

  insert into public.maintenance_requests (unit_id, resident_id, technician_id, category, description, status, quoted_amount, escrow_amount, escrow_status)
  values (v_unit_id, auth.uid(), p_technician_id, p_category, p_description, 'requested', p_inspection_fee, p_inspection_fee, 'held')
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
  if p_quoted_amount is not null and p_quoted_amount <= 0 then
    raise exception 'قيمة عرض السعر غير صحيحة';
  end if;

  select r.* into v_request from public.maintenance_requests r
    join public.technicians t on t.id = r.technician_id
    where r.id = p_request_id and t.user_id = auth.uid()
    for update of r;
  if not found then
    raise exception 'غير مصرح لك بتحديث هذا الطلب';
  end if;
  -- A finished, cancelled or disputed job can't be moved back.
  if v_request.status not in ('requested', 'quoted', 'scheduled', 'in_progress')
     or v_request.escrow_status is distinct from 'held' then
    raise exception 'لا يمكن تحديث هذا الطلب في حالته الحالية';
  end if;

  update public.maintenance_requests set
    status = p_status::maintenance_status,
    quoted_amount = coalesce(p_quoted_amount, quoted_amount),
    visit_scheduled_at = coalesce(p_visit_scheduled_at, visit_scheduled_at)
  where id = p_request_id;
end;
$$;

create or replace function public.confirm_completion_and_release(p_request_id uuid, p_otp text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_amount numeric(12,2);
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
  if v_request.escrow_status is distinct from 'held' then
    raise exception 'لا يوجد مبلغ ضمان معلّق على هذا الطلب';
  end if;
  if v_request.handshake_otp is null or v_request.handshake_otp <> p_otp then
    raise exception 'كود التأكيد غير صحيح';
  end if;

  v_amount := v_request.escrow_amount;
  if v_amount is null or v_amount <= 0 then
    raise exception 'مبلغ الضمان غير معروف، تواصل مع الدعم';
  end if;

  select * into v_resident_wallet from public.wallets where user_id = auth.uid() for update;

  select user_id into v_technician_user_id from public.technicians where id = v_request.technician_id;
  perform public._create_profile_and_wallet(v_technician_user_id);
  select * into v_technician_wallet from public.wallets where user_id = v_technician_user_id for update;
  if not found then
    raise exception 'تعذر العثور على محفظة الفني';
  end if;

  update public.wallets set held_balance = greatest(held_balance - v_amount, 0), updated_at = now()
    where id = v_resident_wallet.id;
  update public.wallets set available_balance = available_balance + v_amount, updated_at = now()
    where id = v_technician_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_resident_wallet.id, 'maintenance_payment', 'completed', -v_amount, 'maintenance_requests', p_request_id);
  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_technician_wallet.id, 'maintenance_payment', 'completed', v_amount, 'maintenance_requests', p_request_id);

  update public.maintenance_requests set escrow_status = 'released' where id = p_request_id;
  update public.technicians set rating_count = rating_count + 1 where id = v_request.technician_id;
end;
$$;

create or replace function public.cancel_maintenance_request(p_request_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_amount numeric(12,2);
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
  if v_request.escrow_status is distinct from 'held' then
    raise exception 'لا يوجد مبلغ ضمان معلّق على هذا الطلب';
  end if;

  v_amount := v_request.escrow_amount;
  if v_amount is null or v_amount <= 0 then
    raise exception 'مبلغ الضمان غير معروف، تواصل مع الدعم';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;

  update public.wallets set
    available_balance = available_balance + v_amount,
    held_balance = greatest(held_balance - v_amount, 0),
    updated_at = now()
  where id = v_wallet.id;

  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'refund', 'completed', v_amount, 'maintenance_requests', p_request_id);

  update public.maintenance_requests set status = 'cancelled', escrow_status = 'refunded' where id = p_request_id;
end;
$$;

create or replace function public.resolve_maintenance_dispute(p_request_id uuid, p_release_to_technician boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
  v_amount numeric(12,2);
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

  v_amount := v_request.escrow_amount;
  if v_amount is null or v_amount <= 0 then
    raise exception 'مبلغ الضمان غير معروف، راجع سجل المعاملات يدوياً';
  end if;

  select * into v_resident_wallet from public.wallets where user_id = v_request.resident_id for update;

  update public.wallets set held_balance = greatest(held_balance - v_amount, 0), updated_at = now()
    where id = v_resident_wallet.id;

  if p_release_to_technician then
    select user_id into v_technician_user_id from public.technicians where id = v_request.technician_id;
    perform public._create_profile_and_wallet(v_technician_user_id);
    select * into v_technician_wallet from public.wallets where user_id = v_technician_user_id for update;
    if not found then
      raise exception 'تعذر العثور على محفظة الفني';
    end if;

    update public.wallets set available_balance = available_balance + v_amount, updated_at = now()
      where id = v_technician_wallet.id;
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_technician_wallet.id, 'maintenance_payment', 'completed', v_amount, 'maintenance_requests', p_request_id);
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_resident_wallet.id, 'maintenance_payment', 'completed', -v_amount, 'maintenance_requests', p_request_id);
    update public.maintenance_requests set status = 'completed', escrow_status = 'released' where id = p_request_id;
  else
    update public.wallets set available_balance = available_balance + v_amount, updated_at = now()
      where id = v_resident_wallet.id;
    insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
      values (v_resident_wallet.id, 'refund', 'completed', v_amount, 'maintenance_requests', p_request_id);
    update public.maintenance_requests set status = 'cancelled', escrow_status = 'refunded' where id = p_request_id;
  end if;
end;
$$;


-- ---------------------------------------------------------------------
-- 6. feature_listing(): no free featuring when the rate is missing
-- ---------------------------------------------------------------------

create or replace function public.feature_listing(p_listing_table text, p_listing_id uuid, p_days int) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_daily_rate int;
  v_cost int;
  v_balance int;
  v_owner uuid;
  v_current_until timestamptz;
  v_new_until timestamptz;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_days is null or p_days <= 0 or p_days > 365 then
    raise exception 'عدد أيام غير صحيح';
  end if;
  if p_listing_table not in ('marketplace_listings', 'real_estate_listings', 'job_postings') then
    raise exception 'نوع إعلان غير مدعوم';
  end if;

  select daily_rate_tokens into v_daily_rate from public.ad_token_settings where id = 1;
  if v_daily_rate is null or v_daily_rate <= 0 then
    raise exception 'إعدادات التمييز غير مكتملة، تواصل مع الدعم';
  end if;
  v_cost := p_days * v_daily_rate;

  select ad_token_balance into v_balance from public.profiles where id = auth.uid() for update;
  if v_balance is null or v_balance < v_cost then
    raise exception 'رصيدك من التوكن غير كافٍ';
  end if;

  if p_listing_table = 'marketplace_listings' then
    select seller_id, featured_until into v_owner, v_current_until from public.marketplace_listings where id = p_listing_id for update;
  elsif p_listing_table = 'real_estate_listings' then
    select owner_id, featured_until into v_owner, v_current_until from public.real_estate_listings where id = p_listing_id for update;
  else
    select poster_id, featured_until into v_owner, v_current_until from public.job_postings where id = p_listing_id for update;
  end if;

  if v_owner is null then
    raise exception 'الإعلان غير موجود';
  end if;
  if v_owner <> auth.uid() then
    raise exception 'غير مصرح لك بتمييز هذا الإعلان';
  end if;

  v_new_until := greatest(coalesce(v_current_until, now()), now()) + make_interval(days => p_days);

  if p_listing_table = 'marketplace_listings' then
    update public.marketplace_listings set is_featured = true, featured_until = v_new_until where id = p_listing_id;
  elsif p_listing_table = 'real_estate_listings' then
    update public.real_estate_listings set is_featured = true, featured_until = v_new_until where id = p_listing_id;
  else
    update public.job_postings set is_featured = true, featured_until = v_new_until where id = p_listing_id;
  end if;

  update public.profiles set ad_token_balance = ad_token_balance - v_cost where id = auth.uid();

  insert into public.ad_token_activity (user_id, kind, tokens, description)
  values (auth.uid(), 'spend', -v_cost, p_days || ' يوم تمييز');
end;
$$;
