-- =====================================================================
-- Migration 0026 — real featured-ad token economy. UI for this
-- (lib/features/promote/*) has existed since before this session's
-- backend-wiring pass with every number hardcoded (7-token balance,
-- fake activity log, "confirm" as a no-op) — this wires it for real.
-- Run after 0002-0025, in order, in the Supabase SQL editor.
--
-- Ahmed's explicit requirement: tokens must work across ANY ad type,
-- not just the marketplace listing they were first designed for. Kept
-- simple rather than a polymorphic table: `is_featured`/`featured_until`
-- columns added directly to each of the three ad-shaped tables
-- (marketplace_listings, real_estate_listings, job_postings), and
-- feature_listing() branches on a `p_listing_table` argument with
-- hardcoded per-table UPDATE statements — deliberately NOT dynamic SQL
-- (no EXECUTE/format()), so there's no injection surface from that
-- argument no matter what a client sends.
--
-- Token balance lives directly on profiles (ad_token_balance) — a
-- separate currency from the EGP `wallets`, never interchangeable with
-- it. The day-rate and token price live in a real one-row settings
-- table (ad_token_settings) so Ahmed can change them later from the
-- database without a code deploy, matching how the day-rate was
-- already described as something that "can change".
--
-- Payment proof: this app has NO file/image upload anywhere yet (no
-- Supabase Storage bucket, no image_picker dependency) — every image
-- field across the whole schema so far is either a Google-sourced URL
-- or simply unused. Building real upload is a bigger, reusable piece
-- of infrastructure (lost & found photos, dispute evidence, listing
-- photos would all want it too), not something to bolt on just for
-- this feature. So `proof_note` here is a short TEXT reference (a
-- transaction id, sender name, last 4 digits) the client types in, not
-- an uploaded image — honest and fully functional today; swap in real
-- image upload later without changing the approval flow around it.
-- =====================================================================

alter table public.profiles add column if not exists ad_token_balance int not null default 0;

alter table public.marketplace_listings add column if not exists is_featured boolean not null default false;
alter table public.marketplace_listings add column if not exists featured_until timestamptz;

alter table public.real_estate_listings add column if not exists is_featured boolean not null default false;
alter table public.real_estate_listings add column if not exists featured_until timestamptz;

alter table public.job_postings add column if not exists is_featured boolean not null default false;
alter table public.job_postings add column if not exists featured_until timestamptz;

-- ---- settings (one row) ----

create table public.ad_token_settings (
  id int primary key default 1,
  token_price_egp numeric(10,2) not null default 15.00,
  daily_rate_tokens int not null default 1,
  topup_phone text not null default '01050780807',
  updated_at timestamptz not null default now(),
  constraint ad_token_settings_singleton check (id = 1)
);

insert into public.ad_token_settings (id) values (1) on conflict (id) do nothing;

grant select on public.ad_token_settings to authenticated;

create policy "ad_token_settings: public read" on public.ad_token_settings
  for select using (true);

-- ---- top-up requests (manual bank-transfer proof, admin-approved) ----

create table public.ad_token_topup_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  tokens_requested int not null,
  amount_egp numeric(10,2) not null,
  proof_note text,
  status text not null default 'pending',
  reviewed_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

grant select, insert on public.ad_token_topup_requests to authenticated;

create policy "ad_token_topup_requests: requester manages own" on public.ad_token_topup_requests
  for all using (auth.uid() = user_id);

create policy "ad_token_topup_requests: super_admin views all" on public.ad_token_topup_requests
  for select using (public.is_super_admin());

-- ---- activity log (real history for the wallet screen) ----

create table public.ad_token_activity (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  kind text not null,                                    -- 'topup' | 'spend'
  tokens int not null,                                    -- positive for topup, negative for spend
  description text,
  created_at timestamptz not null default now()
);

grant select on public.ad_token_activity to authenticated;

create policy "ad_token_activity: user views own" on public.ad_token_activity
  for select using (auth.uid() = user_id);

-- ---- request_token_topup(): submit a manual top-up with payment proof ----

create or replace function public.request_token_topup(p_tokens int, p_proof_note text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_price numeric;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_tokens < 5 then
    raise exception 'الحد الأدنى للشحن 5 توكن';
  end if;

  select token_price_egp into v_price from public.ad_token_settings where id = 1;

  insert into public.ad_token_topup_requests (user_id, tokens_requested, amount_egp, proof_note)
  values (auth.uid(), p_tokens, p_tokens * v_price, p_proof_note)
  returning id into v_id;

  return v_id;
end;
$$;

grant execute on function public.request_token_topup(int, text) to authenticated;

-- ---- review_token_topup(): super_admin approves/rejects ----

create or replace function public.review_token_topup(p_request_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_request record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة طلبات شحن التوكن';
  end if;

  select * into v_request from public.ad_token_topup_requests where id = p_request_id for update;
  if not found or v_request.status <> 'pending' then
    raise exception 'الطلب غير موجود أو تمت مراجعته بالفعل';
  end if;

  update public.ad_token_topup_requests set status = case when p_approve then 'approved' else 'rejected' end, reviewed_by = auth.uid()
    where id = p_request_id;

  if p_approve then
    update public.profiles set ad_token_balance = ad_token_balance + v_request.tokens_requested where id = v_request.user_id;

    insert into public.ad_token_activity (user_id, kind, tokens, description)
    values (v_request.user_id, 'topup', v_request.tokens_requested, 'شحن رصيد معتمد');
  end if;

  insert into public.notifications (user_id, title, body)
  values (
    v_request.user_id,
    case when p_approve then 'تم اعتماد شحن رصيد التوكن' else 'تم رفض طلب شحن التوكن' end,
    case when p_approve then v_request.tokens_requested || ' توكن أُضيفت لرصيدك.' else 'تعذر التحقق من إثبات الدفع، تواصل مع الدعم.' end
  );
end;
$$;

grant execute on function public.review_token_topup(uuid, boolean) to authenticated;

-- ---- feature_listing(): spend tokens to feature any of the three ad types ----

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
  if p_days <= 0 then
    raise exception 'عدد أيام غير صحيح';
  end if;
  if p_listing_table not in ('marketplace_listings', 'real_estate_listings', 'job_postings') then
    raise exception 'نوع إعلان غير مدعوم';
  end if;

  select daily_rate_tokens into v_daily_rate from public.ad_token_settings where id = 1;
  v_cost := p_days * v_daily_rate;

  select ad_token_balance into v_balance from public.profiles where id = auth.uid() for update;
  if v_balance < v_cost then
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

grant execute on function public.feature_listing(text, uuid, int) to authenticated;

-- ---- extend the 0024 admin stats RPC with pending top-up count ----

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
    'disputed_requests_count', (select count(*) from public.maintenance_requests where status = 'disputed'),
    'pending_token_topups_count', (select count(*) from public.ad_token_topup_requests where status = 'pending')
  ) into v_result;

  return v_result;
end;
$$;
