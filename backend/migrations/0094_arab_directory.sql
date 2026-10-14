-- =====================================================================
-- Migration 0094 — the Arab world, phase 6: the business directory
-- outside Egypt.
--
-- public.directory_places (0058) is ~300k Egyptian places from Overture.
-- Owner decision: no bulk import for the other 21 states. Instead:
--
--   * directory_places: + country (ISO2; every existing row EG), source
--     ('overture' | 'osm' | 'user' | 'merchant'; existing rows overture),
--     osm_type / osm_id (unique per OpenStreetMap object), opening_hours.
--     A small partial index (country, category) where country <> 'EG'
--     serves «does this country have places» (dalil hubs) without
--     touching the Egyptian rows.
--   * directory_import_osm(): a shop / amenity the app found on
--     OpenStreetMap (lib/core/places/osm_places.dart) becomes one of ours
--     when someone opens or orders from it — once per OSM object; a place
--     we already have within ~30 m with a similar name gets the OSM id
--     instead of a duplicate. Arab world only, signed-in, 60 new rows a
--     day per user. The country comes from the coordinates.
--   * directory_add_place(): «ضيف محل» — name, category, the user's
--     current position, phone / WhatsApp (any of the 22 states, 0089),
--     hours. Visible right away like masjid_add_mosque (0080/0087):
--     signed-in, Arab world only, 5 a day per user, the same name within
--     ~30 m returns the existing place.
--   * Merchants: a shop with an owner and a location (set_my_shop_location
--     or an owner update of shops.lat/lng) links the unclaimed directory
--     place at the same spot with a similar name (claimed_shop_id), else
--     gets its own «merchant» directory place — so it shows in «اكتشف
--     اللي حواليك» and the home rail, and opens the real store. Deleting
--     the shop removes a merchant place (a linked Overture / OSM place
--     just loses the link).
--   * Who added what is kept in private.directory_contributions (rate
--     limits), not on the public rows.
--
-- nearby_directory / nearby_services / search_directory are unchanged:
-- they were never Egypt-bound (plain coordinates), so they already serve
-- a Riyadh point once places exist there.
--
-- Run after 0093. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ============================================================ columns

alter table public.directory_places add column if not exists country text not null default 'EG';
alter table public.directory_places add column if not exists source text not null default 'overture';
alter table public.directory_places add column if not exists osm_type text;
alter table public.directory_places add column if not exists osm_id bigint;
alter table public.directory_places add column if not exists opening_hours text;

alter table public.directory_places drop constraint if exists directory_places_country_iso;
alter table public.directory_places add constraint directory_places_country_iso check (country ~ '^[A-Z]{2}$');
alter table public.directory_places drop constraint if exists directory_places_source_valid;
alter table public.directory_places add constraint directory_places_source_valid
  check (source in ('overture', 'osm', 'user', 'merchant'));
alter table public.directory_places drop constraint if exists directory_places_osm_valid;
alter table public.directory_places add constraint directory_places_osm_valid
  check ((osm_type is null and osm_id is null) or (osm_type in ('node', 'way', 'relation') and osm_id > 0));
alter table public.directory_places drop constraint if exists directory_places_hours_len;
alter table public.directory_places add constraint directory_places_hours_len
  check (opening_hours is null or char_length(opening_hours) <= 200);

create unique index if not exists directory_places_osm on public.directory_places (osm_type, osm_id) where osm_id is not null;
-- Non-Egyptian places only (tiny): dalil's per-country checks, country feeds.
create index if not exists directory_places_country_category on public.directory_places (country, category) where country <> 'EG';
create index if not exists directory_places_claimed on public.directory_places (claimed_shop_id) where claimed_shop_id is not null;

-- Who added / imported which place (rate limits). Never public.
create table if not exists private.directory_contributions (
  user_id uuid not null,
  place_id text not null,
  kind text not null check (kind in ('osm', 'user')),
  created_at timestamptz not null default now()
);
create index if not exists directory_contributions_user on private.directory_contributions (user_id, kind, created_at desc);

-- ============================================================ helpers

-- The directory's Arabic groups (backend/maintenance/directory/2_clean.sql,
-- seo/dalil/server.mjs CATEGORIES, the app's discover chips).
create or replace function private.dir_categories() returns text[]
language sql immutable as $$
  select array['سوبر ماركت وبقالة', 'صيدليات', 'مطاعم', 'كافيهات', 'حلويات ومخبوزات', 'صحة وعيادات',
               'ملابس وأزياء', 'إلكترونيات وموبايلات', 'أدوات منزلية وأثاث', 'تجميل وعناية',
               'صيانة وخدمات منزلية', 'سيارات', 'هدايا ومكتبات', 'رياضة', 'تعليم', 'عقارات', 'سفر وفنادق',
               'مناسبات وتصوير', 'خدمات وشركات', 'مصانع وموردين', 'بنوك وصرافات', 'محلات متنوعة']
$$;

-- A shop's activity (StoreService.categories in the app, or typed) → a
-- directory group.
create or replace function private.dir_category_of_shop(p text) returns text
language sql immutable as $$
  select case
    when p = any(private.dir_categories()) then p
    when p ~ 'سوبر|بقال|ألبان|أجبان|لحوم|دواجن|جزار|منظفات|عطار|خضار|فاكهة|خضروات' then 'سوبر ماركت وبقالة'
    when p ~ 'صيدل' then 'صيدليات'
    when p ~ 'كافيه|قهوة' and p !~ 'مطعم' then 'كافيهات'
    when p ~ 'مطعم|مأكولات|أكل' then 'مطاعم'
    when p ~ 'حلويات|مخبوزات|مخبز|فرن' then 'حلويات ومخبوزات'
    when p ~ 'ملابس|أحذية|أزياء|شنط' then 'ملابس وأزياء'
    when p ~ 'موبايل|إلكترون|كمبيوتر' then 'إلكترونيات وموبايلات'
    when p ~ 'أدوات منزلية|أثاث|مفروشات' then 'أدوات منزلية وأثاث'
    when p ~ 'تجميل|كوافير|حلاق|عطور' then 'تجميل وعناية'
    when p ~ 'مكتب|هدايا|ورد|ألعاب' then 'هدايا ومكتبات'
    else 'محلات متنوعة'
  end
$$;

-- A name for matching: lower case, alef / taa marbuta / yaa folded,
-- spaces and punctuation dropped.
create or replace function private.place_name_key(p text) returns text
language sql immutable as $$
  select regexp_replace(translate(lower(coalesce(p, '')), 'أإآٱةى', 'ااااهي'), '[^[:alnum:]]', '', 'g')
$$;

create or replace function private.place_names_similar(a text, b text) returns boolean
language sql immutable as $$
  select ka <> '' and kb <> '' and (ka = kb
         or (char_length(ka) >= 3 and strpos(kb, ka) > 0)
         or (char_length(kb) >= 3 and strpos(ka, kb) > 0))
  from (select private.place_name_key(a) ka, private.place_name_key(b) kb) x
$$;

-- The unclaimed-or-any place within [p_m] metres of a point with a
-- similar name (nearest first), else null.
create or replace function private.dir_same_place(p_name text, p_lat double precision, p_lng double precision, p_m double precision default 30)
returns text
language sql stable security definer set search_path = public as $$
  select d.id from public.directory_places d
  where d.lat between p_lat - p_m / 111195.0 and p_lat + p_m / 111195.0
    and d.lng between p_lng - p_m / (111195.0 * greatest(cos(radians(p_lat)), 0.2))
                  and p_lng + p_m / (111195.0 * greatest(cos(radians(p_lat)), 0.2))
    and 111195.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) <= p_m
    and private.place_names_similar(d.name, p_name)
  order by power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)
  limit 1
$$;
revoke execute on function private.dir_same_place(text, double precision, double precision, double precision) from public, anon, authenticated;

-- A published phone as we show it: digits and a leading «+», 6–16 long;
-- a mobile of the 22 states in the stored form (01… / +9665…).
create or replace function private.dir_phone(p text, p_country text) returns text
language sql immutable as $$
  select coalesce(private.phone_store(p, p_country),
                  case when private.phone_clean(p) ~ '^\+?[0-9]{6,16}$' then private.phone_clean(p) end)
$$;

create or replace function private.dir_text(p text, p_max int) returns text
language sql immutable as $$
  select left(nullif(btrim(regexp_replace(coalesce(p, ''), '\s+', ' ', 'g')), ''), p_max)
$$;

-- ============================================== OpenStreetMap → ours

-- A shop / amenity the app found on OpenStreetMap → ours (once). Returns
-- the directory id to open. p_kind: the OSM tag it was mapped from
-- (e.g. 'shop=bakery', 'craft=plumber' — the latter also gets a trade, so
-- it shows in the technicians market).
create or replace function public.directory_import_osm(
  p_osm_type text, p_osm_id bigint, p_name text, p_category text,
  p_lat double precision, p_lng double precision,
  p_phone text default null, p_website text default null, p_opening_hours text default null,
  p_kind text default null, p_address text default null
) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id text;
  v_name text := private.dir_text(p_name, 120);
  v_country text;
  v_category text := case when p_category = any(private.dir_categories()) then p_category else 'محلات متنوعة' end;
  v_kind text := case when p_kind ~ '^[a-z_]{2,20}=[a-z0-9_;]{2,40}$' then p_kind end;
  v_phone text;
  v_trade text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_osm_type is null or p_osm_type not in ('node', 'way', 'relation') or p_osm_id is null or p_osm_id <= 0 then
    raise exception 'مكان غير صالح';
  end if;
  if char_length(coalesce(v_name, '')) < 2 then
    raise exception 'مكان غير صالح';
  end if;
  if p_lat is null or p_lng is null or not private.in_arab_world(p_lat, p_lng) then
    raise exception 'المكان ده برّه الدول العربية';
  end if;
  v_country := private.arab_country_at(p_lat, p_lng);
  if v_country is null then
    raise exception 'المكان ده برّه الدول العربية';
  end if;

  select id into v_id from public.directory_places where osm_type = p_osm_type and osm_id = p_osm_id;
  if v_id is not null then
    return v_id;
  end if;

  -- Already have it (Overture / added by someone) at the same spot?
  v_id := private.dir_same_place(v_name, p_lat, p_lng, 30);
  if v_id is not null then
    update public.directory_places set osm_type = p_osm_type, osm_id = p_osm_id
    where id = v_id and osm_id is null;
    return v_id;
  end if;

  if (select count(*) from private.directory_contributions
      where user_id = auth.uid() and kind = 'osm' and created_at > now() - interval '1 day') >= 60 then
    raise exception 'فتحت أماكن جديدة كتير النهارده، جرّب بكرة';
  end if;

  v_phone := private.dir_phone(p_phone, v_country);
  v_trade := case v_kind
    when 'craft=plumber' then 'سباكة' when 'craft=electrician' then 'كهرباء' when 'craft=hvac' then 'تكييف وتبريد'
    when 'craft=carpenter' then 'نجارة' when 'craft=painter' then 'دهانات' end;
  v_id := 'osm-' || p_osm_type || '-' || p_osm_id;
  insert into public.directory_places (id, name, category, kind, phone, whatsapp, website, address, lat, lng,
                                       country, source, osm_type, osm_id, opening_hours, trade)
  values (v_id, v_name, v_category, v_kind, v_phone, private.phone_store(v_phone, v_country),
          case when p_website ~* '^https?://[^\s]{3,}$' then left(p_website, 200) end,
          private.dir_text(p_address, 300), round(p_lat::numeric, 6), round(p_lng::numeric, 6),
          v_country, 'osm', p_osm_type, p_osm_id, private.dir_text(p_opening_hours, 200), v_trade)
  on conflict do nothing;
  if found then
    insert into private.directory_contributions (user_id, place_id, kind) values (auth.uid(), v_id, 'osm');
  else
    select id into v_id from public.directory_places where osm_type = p_osm_type and osm_id = p_osm_id;
  end if;
  return v_id;
end;
$$;
revoke execute on function public.directory_import_osm(text, bigint, text, text, double precision, double precision, text, text, text, text, text) from public, anon;
grant execute on function public.directory_import_osm(text, bigint, text, text, double precision, double precision, text, text, text, text, text) to authenticated;

-- ======================================================= «ضيف محل»

create or replace function public.directory_add_place(
  p_name text, p_category text, p_lat double precision, p_lng double precision,
  p_phone text default null, p_whatsapp text default null, p_opening_hours text default null,
  p_address text default null
) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id text;
  v_name text := private.dir_text(p_name, 120);
  v_country text;
  v_phone text;
  v_wa text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if char_length(coalesce(v_name, '')) < 2 then
    raise exception 'اكتب اسم المحل';
  end if;
  if p_category is null or not (p_category = any(private.dir_categories())) then
    raise exception 'اختار نشاط المحل';
  end if;
  if p_lat is null or p_lng is null or (abs(p_lat) < 0.001 and abs(p_lng) < 0.001) then
    raise exception 'حدد مكان المحل';
  end if;
  v_country := case when private.in_arab_world(p_lat, p_lng) then private.arab_country_at(p_lat, p_lng) end;
  if v_country is null then
    raise exception 'الدليل للدول العربية بس — المكان ده برّه';
  end if;
  if nullif(btrim(coalesce(p_whatsapp, '')), '') is not null then
    v_wa := private.phone_store(p_whatsapp, v_country);
    if v_wa is null then
      raise exception 'رقم الواتساب مش صحيح';
    end if;
  end if;
  if nullif(btrim(coalesce(p_phone, '')), '') is not null then
    v_phone := private.dir_phone(p_phone, v_country);
    if v_phone is null then
      raise exception 'رقم التليفون مش صحيح';
    end if;
  end if;
  v_wa := coalesce(v_wa, private.phone_store(v_phone, v_country));
  v_phone := coalesce(v_phone, v_wa);

  -- Already there (anyone's / the directory's)? Open that one.
  v_id := private.dir_same_place(v_name, p_lat, p_lng, 30);
  if v_id is not null then
    return v_id;
  end if;

  if (select count(*) from private.directory_contributions
      where user_id = auth.uid() and kind = 'user' and created_at > now() - interval '1 day') >= 5 then
    raise exception 'ضفت محلات كتير النهارده، جرّب بكرة';
  end if;

  v_id := 'usr-' || replace(gen_random_uuid()::text, '-', '');
  insert into public.directory_places (id, name, category, phone, whatsapp, address, lat, lng, country, source, opening_hours)
  values (v_id, v_name, p_category, v_phone, v_wa, private.dir_text(p_address, 300),
          round(p_lat::numeric, 6), round(p_lng::numeric, 6), v_country, 'user', private.dir_text(p_opening_hours, 200));
  insert into private.directory_contributions (user_id, place_id, kind) values (auth.uid(), v_id, 'user');
  return v_id;
end;
$$;
revoke execute on function public.directory_add_place(text, text, double precision, double precision, text, text, text, text) from public, anon;
grant execute on function public.directory_add_place(text, text, double precision, double precision, text, text, text, text) to authenticated;

-- ============================================= merchants (tajer shops)

-- A shop with an owner and a location ↔ its directory place.
create or replace function public._shop_directory_link() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lat double precision := new.lat::double precision;
  v_lng double precision := new.lng::double precision;
  v_country text;
  v_id text;
begin
  if new.owner_id is null or new.lat is null or new.lng is null or not private.in_arab_world(v_lat, v_lng) then
    return new;
  end if;
  v_country := private.arab_country_at(v_lat, v_lng);
  if v_country is null then
    return new;
  end if;

  select id into v_id from public.directory_places where claimed_shop_id = new.id limit 1;
  if v_id is not null then
    -- Our own merchant row follows the shop; an Overture / OSM row keeps its data.
    update public.directory_places
       set name = left(new.name, 120), lat = v_lat, lng = v_lng, country = v_country,
           category = private.dir_category_of_shop(new.category),
           whatsapp = coalesce(new.whatsapp, whatsapp), phone = coalesce(new.whatsapp, phone),
           address = coalesce(left(new.address, 300), address)
     where id = v_id and source = 'merchant';
    return new;
  end if;

  select d.id into v_id from public.directory_places d
  where d.id = private.dir_same_place(new.name, v_lat, v_lng, 30) and d.claimed_shop_id is null;
  if v_id is not null then
    update public.directory_places set claimed_shop_id = new.id where id = v_id;
    return new;
  end if;

  insert into public.directory_places (id, name, category, phone, whatsapp, address, lat, lng, country, source, claimed_shop_id)
  values ('shop-' || replace(new.id::text, '-', ''), left(new.name, 120), private.dir_category_of_shop(new.category),
          new.whatsapp, new.whatsapp, left(new.address, 300), v_lat, v_lng, v_country, 'merchant', new.id)
  on conflict (id) do update set claimed_shop_id = excluded.claimed_shop_id, lat = excluded.lat, lng = excluded.lng;
  return new;
end;
$$;
revoke execute on function public._shop_directory_link() from public, anon, authenticated;

drop trigger if exists shop_directory_link on public.shops;
create trigger shop_directory_link after insert or update of lat, lng, name, owner_id on public.shops
  for each row execute function public._shop_directory_link();

create or replace function public._shop_directory_unlink() returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from public.directory_places where claimed_shop_id = old.id and source = 'merchant';
  return old;
end;
$$;
revoke execute on function public._shop_directory_unlink() from public, anon, authenticated;

drop trigger if exists shop_directory_unlink on public.shops;
create trigger shop_directory_unlink before delete on public.shops
  for each row execute function public._shop_directory_unlink();

-- «محلي هنا»: the owner pins the shop at a point (their current position).
-- Returns the directory place it is now listed as.
create or replace function public.set_my_shop_location(p_shop uuid, p_lat double precision, p_lng double precision)
returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not exists (select 1 from public.shops where id = p_shop and owner_id = auth.uid()) then
    raise exception 'المحل ده مش بتاعك';
  end if;
  if p_lat is null or p_lng is null or not private.in_arab_world(p_lat, p_lng) or private.arab_country_at(p_lat, p_lng) is null then
    raise exception 'مكان المحل لازم يكون في دولة عربية';
  end if;
  update public.shops set lat = round(p_lat::numeric, 6), lng = round(p_lng::numeric, 6) where id = p_shop;
  return (select id from public.directory_places where claimed_shop_id = p_shop order by (source = 'merchant') limit 1);
end;
$$;
revoke execute on function public.set_my_shop_location(uuid, double precision, double precision) from public, anon;
grant execute on function public.set_my_shop_location(uuid, double precision, double precision) to authenticated;

-- Shops that already have an owner and a location get their place now.
update public.shops set lat = lat where owner_id is not null and lat is not null and lng is not null
  and not exists (select 1 from public.directory_places d where d.claimed_shop_id = shops.id);
