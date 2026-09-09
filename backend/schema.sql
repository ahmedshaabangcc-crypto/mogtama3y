-- =====================================================================
-- مُجتمعي (Mogtama3y) — Initial Database Schema
-- Target: Supabase (PostgreSQL)
-- Generated from Stitch design screens (design/screens/)
-- =====================================================================
-- Notes:
--  * auth.users is managed by Supabase Auth. public.profiles extends it 1:1.
--  * All primary keys are UUID (gen_random_uuid()).
--  * Money columns use numeric(12,2) — Egyptian pounds.
--  * RLS is enabled on every table (project has "auto RLS" on by default).
--    Baseline policies are included; refine per-feature as the app grows.
-- =====================================================================

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------
-- ENUMS
-- ---------------------------------------------------------------------
create type residency_type as enum ('owner', 'tenant');
create type union_role as enum ('resident', 'board_member', 'president');
create type union_member_status as enum ('pending', 'verified', 'rejected');
create type post_type as enum ('official', 'resident', 'complaint', 'poll');
create type maintenance_status as enum (
  'requested', 'quoted', 'scheduled', 'in_progress', 'completed', 'disputed', 'cancelled'
);
create type escrow_status as enum ('held', 'released', 'refunded', 'disputed');
create type wallet_tx_type as enum (
  'top_up', 'maintenance_payment', 'union_dues', 'marketplace_sale',
  'marketplace_purchase', 'recycling_sale', 'withdrawal', 'refund', 'fee'
);
create type wallet_tx_status as enum ('pending', 'held', 'completed', 'reversed');
create type listing_condition as enum ('new', 'like_new', 'light_use', 'used', 'heavy_use');
create type listing_status as enum ('active', 'reserved', 'sold', 'removed');
create type shop_source as enum ('claimed', 'google_imported');
create type shop_order_status as enum ('cart', 'placed', 'preparing', 'delivering', 'delivered', 'cancelled');
create type recycling_category as enum ('metal', 'plastic', 'electronics', 'furniture', 'paper_cardboard', 'other');
create type auction_status as enum ('active', 'ended', 'collected');
create type employment_type as enum ('full_time', 'part_time', 'freelance', 'shift');
create type application_status as enum ('submitted', 'shortlisted', 'interview', 'offered', 'rejected', 'hired');
create type pass_type as enum ('delivery', 'guest', 'maintenance', 'other');
create type pass_status as enum ('active', 'used', 'expired', 'revoked');
create type lost_found_type as enum ('lost', 'found');
create type ticket_category as enum ('technical', 'billing', 'complaint', 'suggestion', 'other');
create type ticket_status as enum ('open', 'in_progress', 'resolved', 'closed');
create type sos_type as enum ('medical', 'fire', 'gas_electric', 'security');
create type sos_status as enum ('active', 'responding', 'resolved', 'false_alarm');
create type user_role as enum ('resident', 'union_president', 'technician', 'shop_owner', 'super_admin');

-- ---------------------------------------------------------------------
-- CORE: PROFILES, BUILDINGS, UNITS
-- ---------------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text unique,
  phone_hidden boolean not null default true,
  avatar_url text,
  is_verified boolean not null default false,           -- "سكن موثّق" badge
  role user_role not null default 'resident',
  wallet_id uuid,                                        -- set after wallets row created
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.buildings (
  id uuid primary key default gen_random_uuid(),
  name text not null,                                     -- "برج الياسمين الفاخر"
  district text,                                           -- "المعادي - دجلة"
  city text,
  governorate text,
  total_units int,
  registered_units int not null default 0,
  is_officially_registered boolean not null default false, -- "عمارة قيد التأسيس الرقمي"
  cover_image_url text,
  lat numeric(9,6),
  lng numeric(9,6),
  created_at timestamptz not null default now()
);

create table public.units (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  unit_number text not null,                              -- "شقة 4B"
  floor_label text,                                        -- "الدور الرابع"
  unique (building_id, unit_number)
);

create table public.unit_residents (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  residency_type residency_type not null,
  is_primary boolean not null default true,
  created_at timestamptz not null default now(),
  unique (unit_id, user_id)
);

-- ---------------------------------------------------------------------
-- UNION (اتحاد الملاك): membership, elections, dues, financial reports
-- ---------------------------------------------------------------------

create table public.union_invite_codes (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  code text not null unique,                              -- "YSM-9482"
  issued_by uuid references public.profiles(id),
  max_uses int not null default 1,
  used_count int not null default 0,
  expires_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.union_members (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  unit_id uuid references public.units(id),
  role union_role not null default 'resident',
  status union_member_status not null default 'pending',
  invite_code_id uuid references public.union_invite_codes(id),
  verified_by uuid references public.profiles(id),
  verified_at timestamptz,
  show_family_name_only boolean not null default false,   -- privacy toggle
  created_at timestamptz not null default now(),
  unique (building_id, user_id)
);

create table public.union_elections (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  title text not null,
  legal_quorum_pct numeric(5,2) not null default 65.00,
  eligible_voters int not null,
  opens_at timestamptz not null default now(),
  closes_at timestamptz not null,
  is_finalized boolean not null default false,
  result_pct numeric(5,2),
  created_at timestamptz not null default now()
);

create table public.union_candidates (
  id uuid primary key default gen_random_uuid(),
  election_id uuid not null references public.union_elections(id) on delete cascade,
  user_id uuid not null references public.profiles(id),
  pledge text,
  vote_count int not null default 0
);

create table public.union_votes (
  id uuid primary key default gen_random_uuid(),
  election_id uuid not null references public.union_elections(id) on delete cascade,
  candidate_id uuid references public.union_candidates(id),  -- null = abstain
  voter_id uuid not null references public.profiles(id),
  cast_at timestamptz not null default now(),
  unique (election_id, voter_id)
);

create table public.union_dues (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  unit_id uuid not null references public.units(id) on delete cascade,
  period_label text not null,                              -- "مارس 2025"
  amount numeric(12,2) not null,
  due_date date,
  is_paid boolean not null default false,
  paid_at timestamptz,
  paid_via text,                                            -- wallet | card | fawry ...
  created_at timestamptz not null default now()
);

create table public.union_financial_reports (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  period_label text not null,                               -- "الربع الثالث 2025"
  total_collected numeric(12,2) not null default 0,
  total_expected numeric(12,2) not null default 0,
  emergency_fund numeric(12,2) not null default 0,
  actual_expenses numeric(12,2) not null default 0,
  pdf_url text,
  approved_by uuid references public.profiles(id),
  audited_by text,
  published_at timestamptz not null default now()
);

create table public.union_expense_items (
  id uuid primary key default gen_random_uuid(),
  report_id uuid not null references public.union_financial_reports(id) on delete cascade,
  label text not null,                                      -- "صيانة لوحة تحكم المصعد"
  amount numeric(12,2) not null,
  vendor text,
  invoice_ref text,
  invoice_url text
);

-- ---------------------------------------------------------------------
-- COMMUNITY FEED (posts / comments)
-- ---------------------------------------------------------------------

create table public.posts (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  author_id uuid not null references public.profiles(id),
  type post_type not null default 'resident',
  body text not null,
  images text[] default '{}',
  is_pinned boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.post_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  author_id uuid not null references public.profiles(id),
  body text not null,
  created_at timestamptz not null default now()
);

create table public.post_reactions (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

-- ---------------------------------------------------------------------
-- WALLET & ESCROW (المحفظة الرقمية)
-- ---------------------------------------------------------------------

create table public.wallets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.profiles(id) on delete cascade,
  available_balance numeric(12,2) not null default 0,
  held_balance numeric(12,2) not null default 0,           -- funds locked in escrow
  updated_at timestamptz not null default now()
);

alter table public.profiles
  add constraint profiles_wallet_fk foreign key (wallet_id) references public.wallets(id);

create table public.wallet_transactions (
  id uuid primary key default gen_random_uuid(),
  wallet_id uuid not null references public.wallets(id) on delete cascade,
  type wallet_tx_type not null,
  status wallet_tx_status not null default 'completed',
  amount numeric(12,2) not null,                            -- positive=credit, negative=debit
  reference_table text,                                      -- e.g. 'maintenance_requests'
  reference_id uuid,
  receipt_url text,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- SERVICES / TECHNICIANS (سوق الفنيين) & MAINTENANCE (Escrow-backed)
-- ---------------------------------------------------------------------

create table public.technicians (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category text not null,                                   -- "سباكة" / "كهرباء" ...
  bio text,
  rating numeric(2,1) not null default 5.0,
  rating_count int not null default 0,
  is_verified boolean not null default false,
  escrow_supported boolean not null default true,
  service_area text,
  created_at timestamptz not null default now()
);

create table public.maintenance_requests (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id),
  resident_id uuid not null references public.profiles(id),
  technician_id uuid references public.technicians(id),
  category text not null,
  description text,
  status maintenance_status not null default 'requested',
  quoted_amount numeric(12,2),
  escrow_status escrow_status,
  visit_scheduled_at timestamptz,
  handshake_otp text,                                        -- delivery/completion OTP
  completed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.maintenance_messages (
  id uuid primary key default gen_random_uuid(),
  request_id uuid not null references public.maintenance_requests(id) on delete cascade,
  sender_id uuid not null references public.profiles(id),
  body text,
  attachment_url text,
  voice_note_url text,
  created_at timestamptz not null default now()
);

create table public.technician_reviews (
  id uuid primary key default gen_random_uuid(),
  technician_id uuid not null references public.technicians(id) on delete cascade,
  request_id uuid references public.maintenance_requests(id),
  reviewer_id uuid not null references public.profiles(id),
  rating int not null check (rating between 1 and 5),
  comment text,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- MARKETPLACE (سوق المستعمل) — Escrow-backed P2P listings
-- ---------------------------------------------------------------------

create table public.marketplace_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  parent_id uuid references public.marketplace_categories(id)
);

create table public.marketplace_listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid not null references public.profiles(id),
  building_id uuid references public.buildings(id),          -- for "hide from my building" logic
  category_id uuid references public.marketplace_categories(id),
  title text not null,
  description text,
  price numeric(12,2) not null,
  is_negotiable boolean not null default false,
  condition listing_condition not null,
  images text[] default '{}',
  status listing_status not null default 'active',
  hide_from_own_building boolean not null default false,
  hide_phone_number boolean not null default true,
  lat numeric(9,6),
  lng numeric(9,6),
  created_at timestamptz not null default now()
);

create table public.marketplace_reservations (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.marketplace_listings(id) on delete cascade,
  buyer_id uuid not null references public.profiles(id),
  escrow_amount numeric(12,2) not null,
  escrow_status escrow_status not null default 'held',
  handshake_otp text,
  meetup_note text,
  created_at timestamptz not null default now()
);

create table public.marketplace_messages (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.marketplace_listings(id) on delete cascade,
  sender_id uuid not null references public.profiles(id),
  body text,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- SHOPS (المحلات) — claimed businesses + Google-imported listings
-- ---------------------------------------------------------------------

create table public.shops (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references public.profiles(id),               -- null until claimed
  source shop_source not null default 'google_imported',
  google_place_id text unique,
  name text not null,
  category text,
  description text,
  cover_image_url text,
  address text,
  lat numeric(9,6),
  lng numeric(9,6),
  rating numeric(2,1),
  rating_count int default 0,
  delivery_radius_m int default 500,
  discount_pct_for_verified_residents numeric(5,2),
  is_claimed boolean not null default false,
  claimed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.shop_products (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  name text not null,
  price numeric(12,2) not null,
  image_url text,
  is_available boolean not null default true,
  stock int,
  category text
);

create table public.shop_orders (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id),
  buyer_id uuid not null references public.profiles(id),
  status shop_order_status not null default 'cart',
  total_amount numeric(12,2) not null default 0,
  delivery_unit_id uuid references public.units(id),
  created_at timestamptz not null default now()
);

create table public.shop_order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.shop_orders(id) on delete cascade,
  product_id uuid not null references public.shop_products(id),
  quantity int not null default 1,
  unit_price numeric(12,2) not null
);

-- ---------------------------------------------------------------------
-- RECYCLING MARKETPLACE (بيكيا وتدوير المخلفات) — auction style
-- ---------------------------------------------------------------------

create table public.recycling_listings (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid not null references public.profiles(id),
  building_id uuid references public.buildings(id),
  category recycling_category not null,
  title text not null,
  description text,
  estimated_weight_kg numeric(8,2),
  images text[] default '{}',
  location_note text,
  status auction_status not null default 'active',
  auction_ends_at timestamptz not null,
  winning_bid_id uuid,
  created_at timestamptz not null default now()
);

create table public.recycling_bids (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.recycling_listings(id) on delete cascade,
  bidder_id uuid not null references public.profiles(id),
  amount numeric(12,2) not null,
  created_at timestamptz not null default now()
);

alter table public.recycling_listings
  add constraint recycling_listings_winning_bid_fk foreign key (winning_bid_id) references public.recycling_bids(id);

create table public.recycling_handovers (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.recycling_listings(id) on delete cascade,
  otp_code text not null,
  confirmed_at timestamptz,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- JOBS (وظائف)
-- ---------------------------------------------------------------------

create table public.job_postings (
  id uuid primary key default gen_random_uuid(),
  poster_id uuid not null references public.profiles(id),      -- resident or shop owner
  shop_id uuid references public.shops(id),
  title text not null,
  category text,
  employment_type employment_type not null,
  salary_min numeric(12,2),
  salary_max numeric(12,2),
  salary_negotiable boolean not null default false,
  requirements text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.job_applications (
  id uuid primary key default gen_random_uuid(),
  job_id uuid not null references public.job_postings(id) on delete cascade,
  applicant_id uuid not null references public.profiles(id),
  cv_url text,
  intro_message text,
  status application_status not null default 'submitted',
  interview_at timestamptz,
  offer_salary numeric(12,2),
  created_at timestamptz not null default now(),
  unique (job_id, applicant_id)
);

-- ---------------------------------------------------------------------
-- SECURITY: visitor QR passes, lost & found, SOS
-- ---------------------------------------------------------------------

create table public.visitor_passes (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id),
  issued_by uuid not null references public.profiles(id),
  visitor_name text not null,
  pass_type pass_type not null,
  qr_code text not null unique,
  valid_from timestamptz not null default now(),
  valid_until timestamptz not null,
  status pass_status not null default 'active',
  created_at timestamptz not null default now()
);

create table public.lost_found_items (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id),
  reporter_id uuid not null references public.profiles(id),
  type lost_found_type not null,
  category text,
  title text not null,
  description text,
  image_url text,
  location_note text,
  secret_mark_hash text,                                       -- for ownership verification
  is_resolved boolean not null default false,
  reward_amount numeric(12,2),
  created_at timestamptz not null default now()
);

create table public.sos_alerts (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id),
  triggered_by uuid not null references public.profiles(id),
  type sos_type not null,
  status sos_status not null default 'active',
  responded_by uuid references public.profiles(id),
  resolved_at timestamptz,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- SUPPORT / LEGAL / PLATFORM
-- ---------------------------------------------------------------------

create table public.support_tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  unit_id uuid references public.units(id),
  category ticket_category not null,
  subject text not null,
  body text not null,
  attachment_url text,
  status ticket_status not null default 'open',
  created_at timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text,
  deep_link text,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

-- Super-admin dispute resolution over escrow-backed transactions
create table public.disputes (
  id uuid primary key default gen_random_uuid(),
  reference_table text not null,                               -- 'maintenance_requests' | 'marketplace_reservations'
  reference_id uuid not null,
  raised_by uuid not null references public.profiles(id),
  against uuid references public.profiles(id),
  reason text not null,
  evidence_urls text[] default '{}',
  resolution text,
  resolved_by uuid references public.profiles(id),
  resolved_at timestamptz,
  created_at timestamptz not null default now()
);

-- Business claim requests (شاشة [42])
create table public.shop_claim_requests (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null references public.shops(id) on delete cascade,
  requester_id uuid not null references public.profiles(id),
  verification_method text not null,                           -- 'otp' | 'document' | 'union_president'
  document_url text,
  status text not null default 'pending',                      -- pending | approved | rejected
  reviewed_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

-- =====================================================================
-- ROW LEVEL SECURITY — baseline (enable everywhere; refine policies later)
-- =====================================================================
do $$
declare t text;
begin
  for t in
    select tablename from pg_tables
    where schemaname = 'public'
  loop
    execute format('alter table public.%I enable row level security;', t);
  end loop;
end $$;

-- Example baseline policies (extend per table as features are built):

-- Everyone can read their own profile; anyone can read minimal public profile fields via a view (TODO).
create policy "profiles: user can view own" on public.profiles
  for select using (auth.uid() = id);
create policy "profiles: user can update own" on public.profiles
  for update using (auth.uid() = id);

-- Wallet is private to its owner.
create policy "wallets: owner only" on public.wallets
  for all using (auth.uid() = user_id);
create policy "wallet_transactions: owner only" on public.wallet_transactions
  for select using (
    wallet_id in (select id from public.wallets where user_id = auth.uid())
  );

-- Marketplace listings are public read, owner write.
create policy "marketplace_listings: public read" on public.marketplace_listings
  for select using (status = 'active');
create policy "marketplace_listings: seller manages own" on public.marketplace_listings
  for all using (auth.uid() = seller_id);

-- Posts readable by verified members of the same building (checked via union_members).
create policy "posts: building members read" on public.posts
  for select using (
    exists (
      select 1 from public.union_members m
      where m.building_id = posts.building_id
        and m.user_id = auth.uid()
        and m.status = 'verified'
    )
  );
create policy "posts: author writes own" on public.posts
  for insert with check (auth.uid() = author_id);

-- NOTE: This baseline intentionally leaves most tables with RLS enabled
-- but no policy yet (= default deny). Add policies table-by-table as each
-- feature screen is implemented, instead of opening everything at once.
