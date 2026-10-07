-- =====================================================================
-- 0075 — Scrap dealers ("تجار الخردة") for «تدوير وتوفير — مزادات الخردة».
--
-- 1. Lots get a precise material (حديد/نحاس/ألومنيوم/…) next to the old
--    category enum (derived from the material on insert), and an optional
--    location: governorate, area, lat/lng.
-- 2. scrap_dealers: one row per dealer (user_id). A dealer registers
--    business name, WhatsApp, materials they buy and where they work
--    (governorate + districts, and/or "within N km of my base").
--    status pending → verified / rejected is set ONLY by a super admin
--    through review_scrap_dealer(); editing the business name or the
--    document sends a verified/rejected dealer back to pending.
--    Nobody but the dealer and a super admin can read the row — the
--    public only learns "verified dealer + business name" through
--    scrap_dealer_badges() (never WhatsApp or the document).
-- 3. A new lot notifies every registered (pending or verified, not
--    rejected) dealer whose materials and area match it — never the
--    seller. Outbid bidders and the accepted winner are notified too,
--    with a deep link to /#/recycling/<lot id>.
-- 4. The seller's phone stays hidden from bidders until the seller
--    accepts; then recycling_seller_contact() gives it to the winner
--    only, and recycling_winner_contact() gives the seller the winner's.
-- 5. Bidders can still open a lot they bid on after it ends.
-- =====================================================================

-- ------------------------------------------------------------ materials
create or replace function public.recycling_material_category(p_material text)
returns recycling_category
language sql immutable
set search_path = public
as $$
  select case p_material
    when 'iron' then 'metal'
    when 'copper' then 'metal'
    when 'aluminum' then 'metal'
    when 'paper_cardboard' then 'paper_cardboard'
    when 'plastic' then 'plastic'
    when 'electronics' then 'electronics'
    when 'furniture' then 'furniture'
    else 'other'
  end::recycling_category;
$$;

create or replace function public.recycling_material_label(p_material text, p_category text default null)
returns text
language sql immutable
set search_path = public
as $$
  select coalesce(
    case p_material
      when 'iron' then 'حديد'
      when 'copper' then 'نحاس'
      when 'aluminum' then 'ألومنيوم'
      when 'paper_cardboard' then 'كرتون وورق'
      when 'plastic' then 'بلاستيك'
      when 'electronics' then 'أجهزة كهربائية'
      when 'furniture' then 'أثاث وبيكيا'
      when 'other' then 'خردة'
    end,
    case p_category
      when 'metal' then 'معادن'
      when 'paper_cardboard' then 'كرتون وورق'
      when 'plastic' then 'بلاستيك'
      when 'electronics' then 'أجهزة كهربائية'
      when 'furniture' then 'أثاث وبيكيا'
    end,
    'خردة');
$$;

-- "مدينة نصر" = "مدينه  نصر" = "مدينة نصر " when matching districts.
create or replace function public.scrap_norm_area(p text)
returns text
language sql immutable
set search_path = public
as $$
  select translate(lower(regexp_replace(coalesce(p, ''), '\s+', '', 'g')), 'أإآةى', 'اااهي');
$$;

create or replace function public.scrap_distance_km(lat1 double precision, lng1 double precision, lat2 double precision, lng2 double precision)
returns double precision
language sql immutable
set search_path = public
as $$
  select 111.0 * sqrt(power(lat2 - lat1, 2) + power((lng2 - lng1) * cos(radians(lat1)), 2));
$$;

-- 500 → '500', 1250.5 → '1,250.50'
create or replace function public.scrap_money(p numeric)
returns text
language sql immutable
set search_path = public
as $$
  select case when p = trunc(p) then to_char(p, 'FM999,999,990') else to_char(p, 'FM999,999,990.00') end;
$$;

alter table public.recycling_listings
  add column if not exists material text,
  add column if not exists governorate text,
  add column if not exists area text,
  add column if not exists lat double precision,
  add column if not exists lng double precision;

alter table public.recycling_listings drop constraint if exists recycling_listings_material_check;
alter table public.recycling_listings add constraint recycling_listings_material_check
  check (material is null or material in ('iron', 'copper', 'aluminum', 'paper_cardboard', 'plastic', 'electronics', 'furniture', 'other'));
alter table public.recycling_listings drop constraint if exists recycling_listings_place_check;
alter table public.recycling_listings add constraint recycling_listings_place_check
  check ((governorate is null or length(governorate) <= 40)
     and (area is null or length(area) <= 80)
     and (lat is null or lat between -90 and 90)
     and (lng is null or lng between -180 and 180)
     and ((lat is null) = (lng is null)));

create index if not exists recycling_listings_active_place
  on public.recycling_listings (governorate, created_at desc) where status = 'active';

-- Old rows keep material null (they match their category group).
-- New rows: the category follows the material; blank text becomes null.
create or replace function public.set_recycling_listing_material() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if new.material is not null then
    new.category := public.recycling_material_category(new.material);
  end if;
  new.governorate := nullif(trim(new.governorate), '');
  new.area := nullif(trim(new.area), '');
  return new;
end;
$$;

drop trigger if exists set_recycling_listing_material on public.recycling_listings;
create trigger set_recycling_listing_material
  before insert on public.recycling_listings
  for each row execute function public.set_recycling_listing_material();

-- A bidder can still open a lot they bid on once it has ended (to see
-- the result and reach the seller if they won).
drop policy if exists "recycling_listings: bidders view" on public.recycling_listings;
create policy "recycling_listings: bidders view" on public.recycling_listings
  for select to authenticated using (
    exists (select 1 from public.recycling_bids b
            where b.listing_id = recycling_listings.id and b.bidder_id = auth.uid()));

-- ------------------------------------------------------------- dealers
create table if not exists public.scrap_dealers (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  business_name text not null check (length(trim(business_name)) between 2 and 80),
  whatsapp text not null check (whatsapp ~ '^01[0125][0-9]{8}$'),
  materials text[] not null check (
    cardinality(materials) >= 1
    and materials <@ array['iron', 'copper', 'aluminum', 'paper_cardboard', 'plastic', 'electronics', 'furniture', 'other']::text[]),
  governorate text check (governorate is null or length(governorate) <= 40),
  -- District names inside the governorate; empty = the whole governorate.
  areas text[] not null default '{}' check (cardinality(areas) <= 30),
  -- Alternative / extra: everything within radius_km of the dealer's base.
  radius_km numeric(6,1) check (radius_km is null or (radius_km > 0 and radius_km <= 200)),
  base_lat double precision check (base_lat is null or base_lat between -90 and 90),
  base_lng double precision check (base_lng is null or base_lng between -180 and 180),
  -- Optional commercial register / shop photo (private-documents bucket).
  doc_path text check (doc_path is null or length(doc_path) <= 300),
  status text not null default 'pending' check (status in ('pending', 'verified', 'rejected')),
  review_note text check (review_note is null or length(review_note) <= 500),
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint scrap_dealers_where check (
    governorate is not null
    or (radius_km is not null and base_lat is not null and base_lng is not null)),
  constraint scrap_dealers_radius_base check (
    radius_km is null or (base_lat is not null and base_lng is not null))
);

create index if not exists scrap_dealers_governorate on public.scrap_dealers (governorate) where status <> 'rejected';
create index if not exists scrap_dealers_status on public.scrap_dealers (status, created_at);

alter table public.scrap_dealers enable row level security;
revoke all on public.scrap_dealers from anon, authenticated;
-- Rows: own row only (a super admin reads all). Columns: a dealer can
-- never write status / review_note / reviewed_at / user_id.
grant select, delete on public.scrap_dealers to authenticated;
grant insert (user_id, business_name, whatsapp, materials, governorate, areas, radius_km, base_lat, base_lng, doc_path)
  on public.scrap_dealers to authenticated;
grant update (business_name, whatsapp, materials, governorate, areas, radius_km, base_lat, base_lng, doc_path)
  on public.scrap_dealers to authenticated;

drop policy if exists "scrap_dealers: own row or admin reads" on public.scrap_dealers;
create policy "scrap_dealers: own row or admin reads" on public.scrap_dealers
  for select to authenticated using (user_id = auth.uid() or public.is_super_admin());
drop policy if exists "scrap_dealers: register self" on public.scrap_dealers;
create policy "scrap_dealers: register self" on public.scrap_dealers
  for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "scrap_dealers: edit own" on public.scrap_dealers;
create policy "scrap_dealers: edit own" on public.scrap_dealers
  for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "scrap_dealers: delete own" on public.scrap_dealers;
create policy "scrap_dealers: delete own" on public.scrap_dealers
  for delete to authenticated using (user_id = auth.uid());

-- Clean the input, keep the review fields out of the dealer's hands
-- (belt and braces on top of the column grants), and send a renamed /
-- re-documented dealer back to review.
create or replace function public.guard_scrap_dealer() returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_areas text[];
begin
  new.business_name := trim(new.business_name);
  new.governorate := nullif(trim(new.governorate), '');
  new.doc_path := nullif(trim(new.doc_path), '');
  select coalesce(array_agg(distinct left(trim(a), 60)), '{}') into v_areas
  from unnest(coalesce(new.areas, '{}')) a where trim(a) <> '';
  new.areas := v_areas;
  select array_agg(distinct m order by m) into new.materials from unnest(new.materials) m;
  if new.radius_km is null then
    new.base_lat := null;
    new.base_lng := null;
  end if;

  if current_user in ('authenticated', 'anon') then
    if new.doc_path is not null and new.doc_path not like auth.uid()::text || '/%' then
      raise exception 'مستند غير صالح';
    end if;
    if tg_op = 'INSERT' then
      new.status := 'pending';
      new.review_note := null;
      new.reviewed_at := null;
      new.created_at := now();
    else
      new.status := old.status;
      new.review_note := old.review_note;
      new.reviewed_at := old.reviewed_at;
      new.created_at := old.created_at;
      if new.business_name is distinct from old.business_name
         or new.doc_path is distinct from old.doc_path then
        new.status := 'pending';
      end if;
    end if;
  end if;
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists guard_scrap_dealer on public.scrap_dealers;
create trigger guard_scrap_dealer
  before insert or update on public.scrap_dealers
  for each row execute function public.guard_scrap_dealer();

-- Does dealer d want to hear about lot l?
create or replace function public.scrap_dealer_matches_lot(d public.scrap_dealers, l public.recycling_listings)
returns boolean
language sql stable
set search_path = public
as $$
  select d.status <> 'rejected'
    and d.user_id <> l.seller_id
    and (
      (l.material is not null and l.material = any(d.materials))
      or (l.material is null and exists (
            select 1 from unnest(d.materials) m where public.recycling_material_category(m) = l.category))
    )
    and (
      (d.governorate is not null and l.governorate is not null and d.governorate = l.governorate
        and (cardinality(d.areas) = 0
             or (l.area is not null and exists (
                   select 1 from unnest(d.areas) a where public.scrap_norm_area(a) = public.scrap_norm_area(l.area)))))
      or (d.radius_km is not null and d.base_lat is not null and d.base_lng is not null
          and l.lat is not null and l.lng is not null
          and public.scrap_distance_km(d.base_lat, d.base_lng, l.lat, l.lng) <= d.radius_km)
    );
$$;

-- New lot → every matching dealer gets «مزاد نحاس جديد في مدينة نصر — حوالي 40 كيلو».
create or replace function public.notify_scrap_dealers_new_lot() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_body text;
begin
  if new.status <> 'active' then
    return new;
  end if;
  v_body := 'مزاد ' || public.recycling_material_label(new.material, new.category::text) || ' جديد'
    || coalesce(' في ' || coalesce(new.area, new.governorate), '')
    || case when new.estimated_weight_kg is not null and new.estimated_weight_kg > 0
            then ' — حوالي ' || public.scrap_money(round(new.estimated_weight_kg)) || ' كيلو' else '' end;
  insert into public.notifications (user_id, title, body, deep_link)
  select d.user_id, 'مزاد خردة جديد يناسبك', v_body, '/#/recycling/' || new.id
  from public.scrap_dealers d
  where public.scrap_dealer_matches_lot(d, new);
  return new;
end;
$$;

drop trigger if exists notify_scrap_dealers_new_lot on public.recycling_listings;
create trigger notify_scrap_dealers_new_lot
  after insert on public.recycling_listings
  for each row execute function public.notify_scrap_dealers_new_lot();

-- ------------------------------------------------------------- reviews
create or replace function public.review_scrap_dealer(p_user uuid, p_approve boolean, p_note text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_note text := nullif(trim(coalesce(p_note, '')), '');
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  update public.scrap_dealers
  set status = case when p_approve then 'verified' else 'rejected' end,
      review_note = left(v_note, 500),
      reviewed_at = now()
  where user_id = p_user;
  if not found then
    raise exception 'التاجر مش موجود';
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (
    p_user,
    case when p_approve then 'مبروك! حسابك كتاجر خردة اتوثّق ✓' else 'طلب تسجيلك كتاجر خردة اترفض' end,
    case when p_approve then 'علامة «تاجر موثّق ✓» هتظهر جنب عروضك في المزادات.'
         else coalesce(v_note, 'راجع بياناتك وابعت الطلب تاني.') end,
    '/#/scrap-dealer');
end;
$$;

create or replace function public.admin_list_scrap_dealers(p_status text default null)
returns table (
  user_id uuid, full_name text, phone text, business_name text, whatsapp text, materials text[],
  governorate text, areas text[], radius_km numeric, base_lat double precision, base_lng double precision,
  doc_path text, status text, review_note text, reviewed_at timestamptz, created_at timestamptz, updated_at timestamptz)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  return query
  select d.user_id, p.full_name, p.phone, d.business_name, d.whatsapp, d.materials,
         d.governorate, d.areas, d.radius_km, d.base_lat, d.base_lng,
         d.doc_path, d.status, d.review_note, d.reviewed_at, d.created_at, d.updated_at
  from public.scrap_dealers d
  join public.profiles p on p.id = d.user_id
  where p_status is null or d.status = p_status
  order by (d.status = 'pending') desc, d.updated_at desc
  limit 300;
end;
$$;

-- Public: which of these users are VERIFIED dealers (for the badge on bids).
create or replace function public.scrap_dealer_badges(p_user_ids uuid[])
returns table (user_id uuid, business_name text, materials text[], governorate text)
language sql
stable
security definer
set search_path = public
as $$
  select d.user_id, d.business_name, d.materials, d.governorate
  from public.scrap_dealers d
  where d.user_id = any(p_user_ids) and d.status = 'verified'
  limit 500;
$$;

-- ------------------------------------------------------- dealer screens
-- «مزادات مطابقة ليك»: active lots matching the caller's dealer profile.
create or replace function public.scrap_dealer_matching_lots()
returns table (
  id uuid, title text, material text, category text, governorate text, area text,
  estimated_weight_kg numeric, auction_ends_at timestamptz, created_at timestamptz,
  top_amount numeric, bid_count integer, my_amount numeric, distance_km double precision)
language sql
stable
security definer
set search_path = public
as $$
  select l.id, l.title, l.material, l.category::text, l.governorate, l.area,
         l.estimated_weight_kg, l.auction_ends_at, l.created_at,
         (select max(b.amount) from public.recycling_bids b where b.listing_id = l.id),
         (select count(*)::int from public.recycling_bids b where b.listing_id = l.id),
         (select max(b.amount) from public.recycling_bids b where b.listing_id = l.id and b.bidder_id = d.user_id),
         case when d.base_lat is not null and l.lat is not null
              then public.scrap_distance_km(d.base_lat, d.base_lng, l.lat, l.lng) end
  from public.scrap_dealers d
  join public.recycling_listings l on l.status = 'active' and l.auction_ends_at > now()
  where d.user_id = auth.uid()
    and public.scrap_dealer_matches_lot(d, l)
  order by l.auction_ends_at
  limit 100;
$$;

-- «عروضي»: every lot the caller bid on, with their best bid vs the top.
create or replace function public.recycling_my_bids()
returns table (
  listing_id uuid, title text, material text, category text, governorate text, area text,
  status text, auction_ends_at timestamptz, my_amount numeric, top_amount numeric,
  bid_count integer, won boolean, last_bid_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select l.id, l.title, l.material, l.category::text, l.governorate, l.area,
         l.status::text, l.auction_ends_at, mine.amount,
         (select max(b.amount) from public.recycling_bids b where b.listing_id = l.id),
         (select count(*)::int from public.recycling_bids b where b.listing_id = l.id),
         exists (select 1 from public.recycling_bids w where w.id = l.winning_bid_id and w.bidder_id = auth.uid()),
         mine.last_at
  from (
    select b.listing_id, max(b.amount) as amount, max(b.created_at) as last_at
    from public.recycling_bids b
    where b.bidder_id = auth.uid()
    group by b.listing_id
  ) mine
  join public.recycling_listings l on l.id = mine.listing_id
  order by mine.last_at desc
  limit 200;
$$;

-- The seller's phone — only to the winning bidder, only after acceptance.
create or replace function public.recycling_seller_contact(p_listing uuid)
returns table (full_name text, phone text)
language sql
stable
security definer
set search_path = public
as $$
  select p.full_name, p.phone
  from public.recycling_listings l
  join public.recycling_bids w on w.id = l.winning_bid_id
  join public.profiles p on p.id = l.seller_id
  where l.id = p_listing
    and l.status in ('ended', 'collected')
    and auth.uid() is not null
    and w.bidder_id = auth.uid();
$$;

-- The winner's contact — only to the seller, only after acceptance
-- (a verified-or-not dealer's WhatsApp is shared too).
create or replace function public.recycling_winner_contact(p_listing uuid)
returns table (user_id uuid, full_name text, phone text, business_name text, whatsapp text, amount numeric)
language sql
stable
security definer
set search_path = public
as $$
  select w.bidder_id, p.full_name, p.phone, d.business_name, d.whatsapp, w.amount
  from public.recycling_listings l
  join public.recycling_bids w on w.id = l.winning_bid_id
  join public.profiles p on p.id = w.bidder_id
  left join public.scrap_dealers d on d.user_id = w.bidder_id and d.status <> 'rejected'
  where l.id = p_listing
    and l.status in ('ended', 'collected')
    and auth.uid() is not null
    and l.seller_id = auth.uid();
$$;

-- ---------------------------------------------- bids: outbid + accepted
-- Same checks as 0046; now also tells the previous top bidder they were
-- outbid, and every notification deep-links to the lot.
create or replace function public.place_recycling_bid(p_listing_id uuid, p_amount numeric) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_listing record;
  v_top numeric;
  v_prev_bidder uuid;
  v_id uuid;
  v_link text := '/#/recycling/' || p_listing_id;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_listing from public.recycling_listings where id = p_listing_id for update;
  if not found then
    raise exception 'المزاد غير موجود';
  end if;
  if v_listing.status <> 'active' or v_listing.auction_ends_at <= now() then
    raise exception 'انتهى هذا المزاد';
  end if;
  if v_listing.seller_id = auth.uid() then
    raise exception 'لا يمكنك المزايدة على مزادك';
  end if;
  if p_amount is null or p_amount <= 0 or p_amount > 1000000 then
    raise exception 'قيمة المزايدة غير صحيحة';
  end if;

  select amount, bidder_id into v_top, v_prev_bidder from public.recycling_bids
    where listing_id = p_listing_id
    order by amount desc, created_at asc
    limit 1;
  if v_top is not null and p_amount <= v_top then
    raise exception 'يجب أن تكون المزايدة أعلى من % ج.م', v_top;
  end if;

  insert into public.recycling_bids (listing_id, bidder_id, amount)
  values (p_listing_id, auth.uid(), round(p_amount, 2))
  returning id into v_id;

  insert into public.notifications (user_id, title, body, deep_link)
  values (v_listing.seller_id, 'مزايدة جديدة على: ' || v_listing.title,
          'وصلت أعلى مزايدة الآن إلى ' || public.scrap_money(round(p_amount, 2)) || ' ج.م.', v_link);

  if v_prev_bidder is not null and v_prev_bidder <> auth.uid() then
    insert into public.notifications (user_id, title, body, deep_link)
    values (v_prev_bidder, 'عرضك اتعدّى',
            'عرضك على مزاد «' || v_listing.title || '» اتعدّى، أعلى عرض دلوقتي '
              || public.scrap_money(round(p_amount, 2)) || ' ج.م',
            v_link);
  end if;

  return v_id;
end;
$$;

create or replace function public.accept_recycling_top_bid(p_listing_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_listing record;
  v_top record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_listing from public.recycling_listings where id = p_listing_id for update;
  if not found or v_listing.seller_id <> auth.uid() then
    raise exception 'غير مصرح لك بإنهاء هذا المزاد';
  end if;
  if v_listing.status <> 'active' then
    raise exception 'هذا المزاد منتهي بالفعل';
  end if;

  select id, bidder_id, amount into v_top from public.recycling_bids
    where listing_id = p_listing_id
    order by amount desc, created_at asc
    limit 1;

  update public.recycling_listings
  set status = 'ended', winning_bid_id = v_top.id
  where id = p_listing_id;

  if v_top.id is not null then
    insert into public.notifications (user_id, title, body, deep_link)
    values (v_top.bidder_id, 'مبروك! البائع قبل عرضك',
            'على «' || v_listing.title || '» بـ ' || public.scrap_money(v_top.amount)
              || ' ج.م — افتح المزاد وكلّم البائع عشان تتفقوا على الاستلام.',
            '/#/recycling/' || p_listing_id);
  end if;
end;
$$;

-- --------------------------------------------------------------- grants
revoke execute on function public.place_recycling_bid(uuid, numeric) from public, anon;
revoke execute on function public.accept_recycling_top_bid(uuid) from public, anon;
grant execute on function public.place_recycling_bid(uuid, numeric) to authenticated;
grant execute on function public.accept_recycling_top_bid(uuid) to authenticated;

revoke execute on function public.review_scrap_dealer(uuid, boolean, text) from public, anon;
revoke execute on function public.admin_list_scrap_dealers(text) from public, anon;
revoke execute on function public.scrap_dealer_matching_lots() from public, anon;
revoke execute on function public.recycling_my_bids() from public, anon;
revoke execute on function public.recycling_seller_contact(uuid) from public, anon;
revoke execute on function public.recycling_winner_contact(uuid) from public, anon;
grant execute on function public.review_scrap_dealer(uuid, boolean, text) to authenticated;
grant execute on function public.admin_list_scrap_dealers(text) to authenticated;
grant execute on function public.scrap_dealer_matching_lots() to authenticated;
grant execute on function public.recycling_my_bids() to authenticated;
grant execute on function public.recycling_seller_contact(uuid) to authenticated;
grant execute on function public.recycling_winner_contact(uuid) to authenticated;

revoke execute on function public.scrap_dealer_badges(uuid[]) from public;
grant execute on function public.scrap_dealer_badges(uuid[]) to anon, authenticated;
