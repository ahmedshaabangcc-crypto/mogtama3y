-- =====================================================================
-- Migration 0093 — the Arab world, phase 3: geography.
--
-- Until now reports, digital addresses, chat rooms, scrap dealers, the
-- SOS text and new buildings assumed Egypt. This migration:
--
--   * private.country_at(lat, lng): the ISO country of a point — Egypt by
--     its polygon (private.in_egypt, 0087), else the smallest containing
--     box: the SQL twin of the app's countryAt()
--     (lib/core/geo/world_time.dart + countryBoxes in world_places.dart).
--     private.arab_country_at() keeps only the 22 states.
--     private.in_arab_world(lat, lng): the sane-location check that
--     replaces the old Egypt boxes (Mauritania to Oman, Comoros to Syria).
--   * reports (0060): the Egypt-only lat/lng check constraints are gone
--     (any valid point inside the Arab world). + country (existing rows EG),
--     set from the coordinates (else the reporter's country) by a trigger.
--     list_reports / admin_list_reports take p_country (feeds filter like
--     0092); the public JSON carries the country.
--   * e_addresses (0048/0049): + country (existing rows EG); a map pin
--     anywhere in the Arab world (no more «لازم يكون جوه مصر»); the
--     country comes from the pin, else what the app sends, else the
--     owner's country.
--   * chat_rooms (0078): + country (existing rooms EG; null = every Arab
--     country). A general room and capital / big-city rooms for each of
--     the 21 other states, and «الوطن العربي» for everybody.
--     list_chat_rooms(p_country) lists the rooms of the caller's country
--     (or p_country — the app's country chip) plus the shared ones; the
--     «near» hint only matches addresses in the room's country.
--     admin_save_chat_room takes p_country ('' / 'ALL' = every country).
--   * scrap_dealers (0075): + country (from the dealer's base point, else
--     their profile); matching by governorate requires the same country
--     (an Egyptian «القاهرة» dealer never hears of a lot elsewhere).
--   * SOS (0039): the notification's emergency numbers are the building's
--     country's (private.sos_emergency_hint; Egypt's text unchanged).
--   * buildings: found_building_in(p_country, …) founds a building in a
--     chosen country (else: the place's coordinates, else the founder's
--     profile country, as in 0092); the currency follows the country.
--
-- Run after 0092. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ============================================================ geography

-- ISO country of a point, or null (open sea / unknown). Same rules and
-- boxes as the app's countryAt(): Egypt's polygon first, then the
-- smallest box that contains the point.
create or replace function private.country_at(p_lat double precision, p_lng double precision) returns text
language sql immutable as $$
  select case
    when p_lat is null or p_lng is null then null
    when private.in_egypt(p_lat, p_lng) then 'EG'
    else (
      select b.iso from (values
        ('SA',16.3,32.2,34.5,55.7), ('AE',22.6,26.1,51.5,56.4), ('OM',16.6,26.4,52.0,59.9),
        ('QA',24.4,26.2,50.7,51.7), ('BH',25.5,26.4,50.3,50.8), ('KW',28.5,30.1,46.5,48.5),
        ('IQ',29.0,37.4,38.8,48.6), ('JO',29.2,33.4,34.9,39.3), ('SY',32.3,37.3,35.7,42.4),
        ('LB',33.0,34.7,35.1,36.6), ('IL',29.4,33.3,34.2,35.9), ('PS',31.2,31.6,34.2,34.6),
        ('PS',31.3,32.6,34.9,35.6), ('YE',12.1,19.0,42.5,54.6), ('TR',35.8,42.1,25.6,44.8),
        ('CY',34.5,35.7,32.2,34.6), ('IR',25.0,39.8,44.0,63.4), ('AF',29.3,38.5,60.5,75.0),
        ('PK',23.6,37.1,60.8,77.9), ('IN',6.7,35.7,68.1,97.4), ('BD',20.6,26.7,88.0,92.7),
        ('LK',5.9,9.9,79.6,82.0), ('MV',-0.7,7.1,72.6,73.8), ('NP',26.3,30.5,80.0,88.3), ('MY',1.2,6.8,99.6,104.5),
        ('MY',0.8,7.4,109.6,119.3), ('SG',1.15,1.48,103.6,104.1), ('BN',4.0,5.1,114.0,115.4),
        ('ID',-11.0,6.1,95.0,141.0), ('PH',4.5,21.2,116.9,126.7), ('TH',5.6,20.5,97.3,105.7),
        ('MM',9.6,28.6,92.2,101.2), ('CN',18.0,53.6,73.5,135.0), ('JP',24.0,45.6,122.9,146.0),
        ('KR',33.0,38.7,124.5,131.0), ('KZ',40.5,55.5,46.5,87.4), ('UZ',37.2,45.6,56.0,73.2),
        ('TM',35.1,42.8,52.4,66.7), ('TJ',36.7,41.0,67.3,75.2), ('KG',39.2,43.3,69.3,80.3),
        ('AZ',38.4,41.9,44.8,50.4), ('RU',41.2,82.0,19.6,180.0), ('GB',49.9,60.9,-8.2,1.8),
        ('IE',51.4,55.4,-10.5,-6.0), ('FR',41.3,51.1,-5.2,9.6), ('DE',47.3,55.1,5.9,15.0),
        ('NL',50.75,53.6,3.3,7.2), ('BE',49.5,51.5,2.5,6.4), ('ES',36.0,43.8,-9.3,3.3), ('PT',36.9,42.2,-9.5,-6.2),
        ('IT',36.6,47.1,6.6,18.5), ('CH',45.8,47.8,5.9,10.5), ('AT',46.4,49.0,9.5,17.2),
        ('SE',55.3,69.1,11.0,24.2), ('NO',58.0,71.2,4.6,31.1), ('DK',54.5,57.8,8.0,12.7),
        ('PL',49.0,54.8,14.1,24.2), ('GR',34.8,41.8,19.4,28.3), ('BA',42.5,45.3,15.7,19.7),
        ('AL',39.6,42.7,19.2,21.1), ('XK',41.8,43.3,20.0,21.8), ('MK',40.8,42.4,20.4,23.1),
        ('BG',41.2,44.2,22.3,28.6), ('RO',43.6,48.3,20.2,29.7), ('US',24.5,49.4,-125.0,-66.9),
        ('US',51.0,71.5,-170.0,-130.0), ('US',18.9,22.3,-160.3,-154.8), ('CA',41.7,83.0,-141.0,-52.6),
        ('CA',43.4,44.2,-80.2,-78.8), ('CA',45.3,45.8,-74.1,-73.4), ('CA',45.2,45.6,-76.0,-75.4),
        ('CA',49.0,49.4,-123.4,-122.2), ('MX',14.5,32.7,-117.2,-86.7), ('BR',-33.8,5.3,-74.0,-34.8),
        ('AR',-55.0,-21.8,-73.6,-53.6), ('AU',-43.7,-10.7,113.0,153.7), ('NZ',-47.3,-34.4,166.4,178.6),
        ('ZA',-34.9,-22.1,16.4,32.9), ('LY',19.5,33.2,9.3,25.2), ('TN',30.2,37.6,7.5,11.6),
        ('DZ',18.9,37.1,-8.7,12.0), ('MA',27.6,35.9,-13.2,-1.0), ('MA',20.7,27.7,-17.1,-8.7),
        ('MR',14.7,27.3,-17.1,-4.8), ('SD',8.6,22.3,21.8,38.6), ('SS',3.5,12.3,23.4,36.0),
        ('ET',3.4,14.9,33.0,48.0), ('SO',-1.7,12.0,40.9,51.4), ('DJ',10.9,12.7,41.7,43.4),
        ('KM',-12.5,-11.3,43.2,44.6), ('ER',12.3,18.0,36.4,43.2), ('KE',-4.7,5.0,33.9,41.9),
        ('TZ',-11.8,-1.0,29.3,40.4), ('NG',4.2,13.9,2.7,14.7), ('NE',11.7,23.5,0.2,16.0),
        ('TD',7.4,23.5,13.5,24.0), ('ML',10.1,25.0,-12.3,4.3), ('SN',12.3,16.7,-17.6,-11.3),
        ('GM',13.0,13.9,-16.9,-13.8), ('GN',7.2,12.7,-15.1,-7.6), ('CI',4.3,10.8,-8.6,-2.5),
        ('GH',4.7,11.2,-3.3,1.2), ('BF',9.4,15.1,-5.5,2.4), ('CM',1.6,13.1,8.4,16.2)
      ) b(iso, a, z, c, d)
      where p_lat between b.a and b.z and p_lng between b.c and b.d
      order by (b.z - b.a) * (b.d - b.c), b.iso
      limit 1)
  end
$$;

-- The point's country when it is one of the 22 states, else null. When a
-- neighbour's (rough) box wins — Iran's box covers Dammam and the Saudi
-- Eastern Province — the smallest Arab box that contains the point.
-- Same as the app's arabCountryAt() (lib/core/geo/admin_areas.dart).
create or replace function private.arab_country_at(p_lat double precision, p_lng double precision) returns text
language sql immutable as $$
  select coalesce(
    (select case when private.is_arab_country(c) then c end from (select private.country_at(p_lat, p_lng) c) x),
    (select b.iso from (values
        ('SA',16.3,32.2,34.5,55.7), ('AE',22.6,26.1,51.5,56.4), ('OM',16.6,26.4,52.0,59.9),
        ('QA',24.4,26.2,50.7,51.7), ('BH',25.5,26.4,50.3,50.8), ('KW',28.5,30.1,46.5,48.5),
        ('IQ',29.0,37.4,38.8,48.6), ('JO',29.2,33.4,34.9,39.3), ('SY',32.3,37.3,35.7,42.4),
        ('LB',33.0,34.7,35.1,36.6), ('PS',31.2,31.6,34.2,34.6), ('PS',31.3,32.6,34.9,35.6),
        ('YE',12.1,19.0,42.5,54.6), ('LY',19.5,33.2,9.3,25.2), ('TN',30.2,37.6,7.5,11.6),
        ('DZ',18.9,37.1,-8.7,12.0), ('MA',27.6,35.9,-13.2,-1.0), ('MA',20.7,27.7,-17.1,-8.7),
        ('MR',14.7,27.3,-17.1,-4.8), ('SD',8.6,22.3,21.8,38.6), ('SO',-1.7,12.0,40.9,51.4),
        ('DJ',10.9,12.7,41.7,43.4), ('KM',-12.5,-11.3,43.2,44.6)
      ) b(iso, a, z, c, d)
      where p_lat between b.a and b.z and p_lng between b.c and b.d
      order by (b.z - b.a) * (b.d - b.c), b.iso
      limit 1))
$$;

-- A sane location for the platform: inside the Arab world's bounding area
-- (Mauritania / Morocco to Oman, the Comoros to Syria / Iraq).
create or replace function private.in_arab_world(p_lat double precision, p_lng double precision) returns boolean
language sql immutable as $$
  select p_lat is not null and p_lng is not null and p_lat between -13 and 38 and p_lng between -18 and 60.5
$$;

-- Country of a user's profile (EG for none).
create or replace function private.user_country(p_uid uuid) returns text
language sql stable security definer set search_path = public as $$
  select coalesce((select p.country from public.profiles p where p.id = p_uid), 'EG')
$$;
revoke execute on function private.user_country(uuid) from public, anon, authenticated;

-- A valid ISO of the 22 states from client input, else null.
create or replace function private.arab_iso(p text) returns text
language sql immutable as $$
  select case when private.is_arab_country(upper(btrim(coalesce(p, '')))) then upper(btrim(p)) end
$$;

-- ============================================================== reports

do $$
declare
  c record;
begin
  -- 0060's «inside Egypt» boxes (lat 21–32.5 / lng 24–37.5) go.
  for c in select con.conname from pg_constraint con
            where con.conrelid = 'public.reports'::regclass and con.contype = 'c'
              and pg_get_constraintdef(con.oid) ~ '(lat|lng) >= '
              and con.conname <> 'reports_lat_lng_valid' loop
    execute format('alter table public.reports drop constraint %I', c.conname);
  end loop;
  if not exists (select 1 from information_schema.columns
                  where table_schema = 'public' and table_name = 'reports' and column_name = 'country') then
    alter table public.reports add column country text not null default 'EG';
  end if;
end;
$$;
alter table public.reports drop constraint if exists reports_lat_lng_valid;
alter table public.reports add constraint reports_lat_lng_valid check (lat between -90 and 90 and lng between -180 and 180);
alter table public.reports drop constraint if exists reports_country_iso;
alter table public.reports add constraint reports_country_iso check (country ~ '^[A-Z]{2}$');
create index if not exists reports_country_created on public.reports (country, created_at desc);

-- Where is the report? Anywhere in the Arab world; the country from the
-- point, else the reporter's.
create or replace function public._report_geo() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if not private.in_arab_world(new.lat, new.lng) then
    raise exception 'حدد مكان المشكلة على الخريطة (جوه دولة عربية)';
  end if;
  new.country := coalesce(private.arab_country_at(new.lat, new.lng), private.user_country(new.user_id));
  return new;
end;
$$;
revoke execute on function public._report_geo() from public, anon, authenticated;
drop trigger if exists report_geo on public.reports;
create trigger report_geo before insert or update of lat, lng on public.reports
  for each row execute function public._report_geo();

create or replace function public.report_public_json(r public.reports) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'id', r.id, 'category', r.category, 'description', r.description, 'photos', to_jsonb(r.photos),
    'video_url', r.video_url, 'video_link', r.video_link,
    'lat', r.lat, 'lng', r.lng, 'governorate', r.governorate, 'district', r.district, 'country', r.country,
    'status', r.status, 'status_note', r.status_note, 'routed_to', r.routed_to,
    'routed_at', r.routed_at, 'resolved_at', r.resolved_at, 'after_photo', r.after_photo,
    'votes_count', r.votes_count, 'created_at', r.created_at,
    'reporter', case when r.hide_identity then null else (select full_name from public.profiles where id = r.user_id) end,
    'is_mine', r.user_id = auth.uid(),
    'voted', exists (select 1 from public.report_votes v where v.report_id = r.id and v.user_id = auth.uid())
  );
$$;
revoke execute on function public.report_public_json(public.reports) from public, anon, authenticated;

-- + p_country: without a location the feed shows one country's reports.
drop function if exists public.list_reports(double precision, double precision, double precision, text, text, boolean, int);
create or replace function public.list_reports(
  p_lat double precision default null, p_lng double precision default null, p_km double precision default 5,
  p_category text default null, p_status text default null, p_mine boolean default false, p_limit int default 50,
  p_country text default null
) returns setof jsonb
language sql stable security definer set search_path = public as $$
  select public.report_public_json(r)
  from public.reports r
  where not r.is_hidden
    and (not coalesce(p_mine, false) or r.user_id = auth.uid())
    and (p_category is null or r.category = p_category)
    and (p_status is null or r.status = p_status)
    and (coalesce(p_mine, false) or private.arab_iso(p_country) is null or r.country = private.arab_iso(p_country))
    and (p_lat is null or p_lng is null or coalesce(p_mine, false) or (
      r.lat between p_lat - least(greatest(p_km, 0.5), 50) / 111.0 and p_lat + least(greatest(p_km, 0.5), 50) / 111.0
      and r.lng between p_lng - least(greatest(p_km, 0.5), 50) / (111.0 * greatest(cos(radians(p_lat)), 0.2))
                    and p_lng + least(greatest(p_km, 0.5), 50) / (111.0 * greatest(cos(radians(p_lat)), 0.2))))
  order by r.created_at desc
  limit least(greatest(coalesce(p_limit, 50), 1), 200);
$$;
grant execute on function public.list_reports(double precision, double precision, double precision, text, text, boolean, int, text) to anon, authenticated;

drop function if exists public.admin_list_reports(text, text, text, int);
create or replace function public.admin_list_reports(
  p_status text default null, p_category text default null, p_governorate text default null, p_limit int default 200,
  p_country text default null
) returns setof jsonb
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select public.report_public_json(r) || jsonb_build_object(
      'routed_note', r.routed_note, 'is_hidden', r.is_hidden, 'hide_identity', r.hide_identity,
      'reporter_admin', (select jsonb_build_object('name', p.full_name, 'phone', p.phone) from public.profiles p where p.id = r.user_id))
    from public.reports r
    where (p_status is null or r.status = p_status)
      and (p_category is null or r.category = p_category)
      and (p_governorate is null or r.governorate = p_governorate)
      and (private.arab_iso(p_country) is null or r.country = private.arab_iso(p_country))
    order by (r.status in ('new', 'reviewing')) desc, r.votes_count desc, r.created_at desc
    limit least(greatest(coalesce(p_limit, 200), 1), 500);
end;
$$;
revoke execute on function public.admin_list_reports(text, text, text, int, text) from public, anon;
grant execute on function public.admin_list_reports(text, text, text, int, text) to authenticated;

-- ========================================================= e-addresses

alter table public.e_addresses add column if not exists country text not null default 'EG';
alter table public.e_addresses drop constraint if exists e_addresses_country_iso;
alter table public.e_addresses add constraint e_addresses_country_iso check (country ~ '^[A-Z]{2}$');

-- 0049's save, with the Arab-world pin check and the country.
create or replace function public.save_my_e_address(p_id uuid, p jsonb) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_lat double precision := nullif(p->>'lat', '')::double precision;
  v_lng double precision := nullif(p->>'lng', '')::double precision;
  v_code text;
  v_handle text;
  v_country text;
  v_phone_lookup boolean := coalesce((p->>'phone_lookup')::boolean, false);
  f_label text := left(nullif(trim(coalesce(p->>'label', '')), ''), 40);
  f_gov text := left(nullif(trim(coalesce(p->>'governorate', '')), ''), 60);
  f_city text := left(nullif(trim(coalesce(p->>'city', '')), ''), 80);
  f_district text := left(nullif(trim(coalesce(p->>'district', '')), ''), 120);
  f_street text := left(nullif(trim(coalesce(p->>'street', '')), ''), 160);
  f_building text := left(nullif(trim(coalesce(p->>'building', '')), ''), 40);
  f_floor text := left(nullif(trim(coalesce(p->>'floor', '')), ''), 20);
  f_apartment text := left(nullif(trim(coalesce(p->>'apartment', '')), ''), 20);
  f_landmark text := left(nullif(trim(coalesce(p->>'landmark', '')), ''), 200);
  f_notes text := left(nullif(trim(coalesce(p->>'notes', '')), ''), 500);
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_id is not null and not exists (select 1 from public.e_addresses where id = p_id and owner_id = auth.uid()) then
    raise exception 'العنوان ده مش موجود';
  end if;
  if f_gov is null or f_city is null then
    raise exception 'اختار المحافظة واكتب المدينة أو الحي';
  end if;
  if f_building is null and f_landmark is null then
    raise exception 'اكتب رقم العمارة أو علامة مميزة جنب العنوان';
  end if;
  if (v_lat is null) <> (v_lng is null)
     or (v_lat is not null and not private.in_arab_world(v_lat, v_lng)) then
    raise exception 'الموقع على الخريطة لازم يكون جوه دولة عربية';
  end if;
  v_country := coalesce(private.arab_country_at(v_lat, v_lng), private.arab_iso(p->>'country'),
                        (select a.country from public.e_addresses a where a.id = p_id), private.user_country(auth.uid()));
  v_handle := public._clean_e_address_handle(p->>'handle', p_id);
  if v_phone_lookup and coalesce((select phone from public.profiles where id = auth.uid()), '') = '' then
    raise exception 'ضيف رقم موبايلك في حسابك الأول عشان تفتح العنوان بيه';
  end if;

  if p_id is null then
    if (select count(*) from public.e_addresses where owner_id = auth.uid()) >= 5 then
      raise exception 'وصلت للحد الأقصى (5 عناوين لكل حساب)';
    end if;
    if v_phone_lookup then
      update public.e_addresses set phone_lookup = false where owner_id = auth.uid() and phone_lookup;
    end if;
    v_code := public._new_e_address_code();
    insert into public.e_addresses (owner_id, code, handle, phone_lookup, label, governorate, city, district, street,
                                    building, floor, apartment, landmark, notes, lat, lng, show_name, show_phone, country)
    values (auth.uid(), v_code, v_handle, v_phone_lookup, coalesce(f_label, 'البيت'), f_gov, f_city, f_district, f_street,
            f_building, f_floor, f_apartment, f_landmark, f_notes, v_lat, v_lng,
            coalesce((p->>'show_name')::boolean, true), coalesce((p->>'show_phone')::boolean, false), v_country);
    return v_code;
  end if;

  if v_phone_lookup then
    update public.e_addresses set phone_lookup = false where owner_id = auth.uid() and phone_lookup and id <> p_id;
  end if;
  update public.e_addresses set
    label = coalesce(f_label, label),
    handle = v_handle,
    phone_lookup = v_phone_lookup,
    governorate = f_gov, city = f_city, district = f_district, street = f_street, building = f_building,
    floor = f_floor, apartment = f_apartment, landmark = f_landmark, notes = f_notes,
    lat = v_lat, lng = v_lng, country = v_country,
    show_name = coalesce((p->>'show_name')::boolean, show_name),
    show_phone = coalesce((p->>'show_phone')::boolean, show_phone),
    is_active = coalesce((p->>'is_active')::boolean, is_active),
    updated_at = now()
  where id = p_id and owner_id = auth.uid()
  returning code into v_code;
  return v_code;
end;
$$;
revoke execute on function public.save_my_e_address(uuid, jsonb) from public, anon;
grant execute on function public.save_my_e_address(uuid, jsonb) to authenticated;

-- ========================================================== chat rooms

do $$
begin
  if not exists (select 1 from information_schema.columns
                  where table_schema = 'public' and table_name = 'chat_rooms' and column_name = 'country') then
    alter table public.chat_rooms add column country text;
    update public.chat_rooms set country = 'EG';   -- every room so far is Egyptian
  end if;
end;
$$;
alter table public.chat_rooms drop constraint if exists chat_rooms_country_iso;
alter table public.chat_rooms add constraint chat_rooms_country_iso check (country is null or country ~ '^[A-Z]{2}$');
grant select (country) on public.chat_rooms to anon, authenticated;
create index if not exists chat_rooms_country on public.chat_rooms (country) where is_active;

-- One shared room, then a general room + the capital / big cities of each
-- state (governorate = the division name of lib/core/geo/admin_areas.dart,
-- area = the city when it isn't the division's own name).
insert into public.chat_rooms (name, description, kind, governorate, area, icon, sort_order, country) values
  ('الوطن العربي', 'دردشة مفتوحة لكل العرب من المحيط للخليج', 'topic', null, null, '🌍', 2, null),
  ('دردشة السعودية', 'اتكلم في أي حاجة مع ناس من كل السعودية', 'topic', null, null, '🇸🇦', 1, 'SA'),
  ('الرياض', 'غرفة أهل الرياض', 'area', 'الرياض', null, '🏙️', 10, 'SA'),
  ('جدة', 'غرفة أهل جدة', 'area', 'مكة المكرمة', 'جدة', '🌊', 11, 'SA'),
  ('مكة المكرمة', 'غرفة أهل مكة', 'area', 'مكة المكرمة', 'مكة', '🕋', 12, 'SA'),
  ('المدينة المنورة', 'غرفة أهل المدينة', 'area', 'المدينة المنورة', null, '🕌', 13, 'SA'),
  ('الدمام والخبر', 'غرفة أهل الشرقية', 'area', 'المنطقة الشرقية', null, '🏙️', 14, 'SA'),
  ('دردشة الإمارات', 'اتكلم في أي حاجة مع ناس من كل الإمارات', 'topic', null, null, '🇦🇪', 1, 'AE'),
  ('أبوظبي', 'غرفة أهل أبوظبي', 'area', 'أبوظبي', null, '🏙️', 10, 'AE'),
  ('دبي', 'غرفة أهل دبي', 'area', 'دبي', null, '🏙️', 11, 'AE'),
  ('الشارقة', 'غرفة أهل الشارقة', 'area', 'الشارقة', null, '🏙️', 12, 'AE'),
  ('دردشة الكويت', 'اتكلم في أي حاجة مع ناس من كل الكويت', 'topic', null, null, '🇰🇼', 1, 'KW'),
  ('مدينة الكويت', 'غرفة أهل العاصمة', 'area', 'العاصمة', null, '🏙️', 10, 'KW'),
  ('حولي', 'غرفة أهل حولي', 'area', 'حولي', null, '📍', 11, 'KW'),
  ('دردشة قطر', 'اتكلم في أي حاجة مع ناس من كل قطر', 'topic', null, null, '🇶🇦', 1, 'QA'),
  ('الدوحة', 'غرفة أهل الدوحة', 'area', 'الدوحة', null, '🏙️', 10, 'QA'),
  ('دردشة البحرين', 'اتكلم في أي حاجة مع ناس من كل البحرين', 'topic', null, null, '🇧🇭', 1, 'BH'),
  ('المنامة', 'غرفة أهل المنامة', 'area', 'العاصمة', null, '🏙️', 10, 'BH'),
  ('دردشة عمان', 'اتكلم في أي حاجة مع ناس من كل عُمان', 'topic', null, null, '🇴🇲', 1, 'OM'),
  ('مسقط', 'غرفة أهل مسقط', 'area', 'مسقط', null, '🏙️', 10, 'OM'),
  ('دردشة اليمن', 'اتكلم في أي حاجة مع ناس من كل اليمن', 'topic', null, null, '🇾🇪', 1, 'YE'),
  ('صنعاء', 'غرفة أهل صنعاء', 'area', 'أمانة العاصمة', null, '🏙️', 10, 'YE'),
  ('عدن', 'غرفة أهل عدن', 'area', 'عدن', null, '⚓', 11, 'YE'),
  ('تعز', 'غرفة أهل تعز', 'area', 'تعز', null, '📍', 12, 'YE'),
  ('دردشة الأردن', 'اتكلم في أي حاجة مع ناس من كل الأردن', 'topic', null, null, '🇯🇴', 1, 'JO'),
  ('عمّان', 'غرفة أهل عمّان', 'area', 'العاصمة', null, '🏙️', 10, 'JO'),
  ('إربد', 'غرفة أهل إربد', 'area', 'إربد', null, '📍', 11, 'JO'),
  ('الزرقاء', 'غرفة أهل الزرقاء', 'area', 'الزرقاء', null, '📍', 12, 'JO'),
  ('دردشة فلسطين', 'اتكلم في أي حاجة مع ناس من كل فلسطين', 'topic', null, null, '🇵🇸', 1, 'PS'),
  ('القدس', 'غرفة أهل القدس', 'area', 'القدس', null, '🕌', 10, 'PS'),
  ('غزة', 'غرفة أهل غزة', 'area', 'غزة', null, '📍', 11, 'PS'),
  ('رام الله', 'غرفة أهل رام الله والبيرة', 'area', 'رام الله والبيرة', null, '📍', 12, 'PS'),
  ('نابلس', 'غرفة أهل نابلس', 'area', 'نابلس', null, '📍', 13, 'PS'),
  ('الخليل', 'غرفة أهل الخليل', 'area', 'الخليل', null, '📍', 14, 'PS'),
  ('دردشة لبنان', 'اتكلم في أي حاجة مع ناس من كل لبنان', 'topic', null, null, '🇱🇧', 1, 'LB'),
  ('بيروت', 'غرفة أهل بيروت', 'area', 'بيروت', null, '🏙️', 10, 'LB'),
  ('طرابلس لبنان', 'غرفة أهل طرابلس والشمال', 'area', 'الشمال', null, '📍', 11, 'LB'),
  ('دردشة سوريا', 'اتكلم في أي حاجة مع ناس من كل سوريا', 'topic', null, null, '🇸🇾', 1, 'SY'),
  ('دمشق', 'غرفة أهل الشام', 'area', 'دمشق', null, '🏙️', 10, 'SY'),
  ('حلب', 'غرفة أهل حلب', 'area', 'حلب', null, '🏰', 11, 'SY'),
  ('حمص', 'غرفة أهل حمص', 'area', 'حمص', null, '📍', 12, 'SY'),
  ('اللاذقية', 'غرفة أهل اللاذقية', 'area', 'اللاذقية', null, '🌊', 13, 'SY'),
  ('دردشة العراق', 'اتكلم في أي حاجة مع ناس من كل العراق', 'topic', null, null, '🇮🇶', 1, 'IQ'),
  ('بغداد', 'غرفة أهل بغداد', 'area', 'بغداد', null, '🏙️', 10, 'IQ'),
  ('البصرة', 'غرفة أهل البصرة', 'area', 'البصرة', null, '⚓', 11, 'IQ'),
  ('الموصل', 'غرفة أهل الموصل ونينوى', 'area', 'نينوى', null, '📍', 12, 'IQ'),
  ('أربيل', 'غرفة أهل أربيل', 'area', 'أربيل', null, '📍', 13, 'IQ'),
  ('النجف وكربلاء', 'غرفة أهل النجف وكربلاء', 'area', 'النجف', null, '🕌', 14, 'IQ'),
  ('دردشة السودان', 'اتكلم في أي حاجة مع ناس من كل السودان', 'topic', null, null, '🇸🇩', 1, 'SD'),
  ('الخرطوم', 'غرفة أهل الخرطوم', 'area', 'الخرطوم', null, '🏙️', 10, 'SD'),
  ('بورتسودان', 'غرفة أهل بورتسودان', 'area', 'البحر الأحمر', 'بورتسودان', '⚓', 11, 'SD'),
  ('دردشة ليبيا', 'اتكلم في أي حاجة مع ناس من كل ليبيا', 'topic', null, null, '🇱🇾', 1, 'LY'),
  ('طرابلس', 'غرفة أهل طرابلس', 'area', 'طرابلس', null, '🏙️', 10, 'LY'),
  ('بنغازي', 'غرفة أهل بنغازي', 'area', 'بنغازي', null, '📍', 11, 'LY'),
  ('مصراتة', 'غرفة أهل مصراتة', 'area', 'مصراتة', null, '📍', 12, 'LY'),
  ('دردشة تونس', 'اتكلم في أي حاجة مع ناس من كل تونس', 'topic', null, null, '🇹🇳', 1, 'TN'),
  ('تونس العاصمة', 'غرفة أهل تونس العاصمة', 'area', 'تونس', null, '🏙️', 10, 'TN'),
  ('صفاقس', 'غرفة أهل صفاقس', 'area', 'صفاقس', null, '📍', 11, 'TN'),
  ('سوسة', 'غرفة أهل سوسة', 'area', 'سوسة', null, '🌊', 12, 'TN'),
  ('دردشة الجزائر', 'اتكلم في أي حاجة مع ناس من كل الجزائر', 'topic', null, null, '🇩🇿', 1, 'DZ'),
  ('الجزائر العاصمة', 'غرفة أهل العاصمة', 'area', 'الجزائر', null, '🏙️', 10, 'DZ'),
  ('وهران', 'غرفة أهل وهران', 'area', 'وهران', null, '🌊', 11, 'DZ'),
  ('قسنطينة', 'غرفة أهل قسنطينة', 'area', 'قسنطينة', null, '🌉', 12, 'DZ'),
  ('دردشة المغرب', 'اتكلم في أي حاجة مع ناس من كل المغرب', 'topic', null, null, '🇲🇦', 1, 'MA'),
  ('الرباط', 'غرفة أهل الرباط وسلا', 'area', 'الرباط سلا القنيطرة', 'الرباط', '🏙️', 10, 'MA'),
  ('الدار البيضاء', 'غرفة أهل كازا', 'area', 'الدار البيضاء سطات', 'الدار البيضاء', '🏙️', 11, 'MA'),
  ('مراكش', 'غرفة أهل مراكش', 'area', 'مراكش آسفي', 'مراكش', '🕌', 12, 'MA'),
  ('فاس', 'غرفة أهل فاس', 'area', 'فاس مكناس', 'فاس', '📍', 13, 'MA'),
  ('طنجة', 'غرفة أهل طنجة', 'area', 'طنجة تطوان الحسيمة', 'طنجة', '⚓', 14, 'MA'),
  ('دردشة موريتانيا', 'اتكلم في أي حاجة مع ناس من كل موريتانيا', 'topic', null, null, '🇲🇷', 1, 'MR'),
  ('نواكشوط', 'غرفة أهل نواكشوط', 'area', 'نواكشوط', null, '🏙️', 10, 'MR'),
  ('دردشة الصومال', 'اتكلم في أي حاجة مع ناس من كل الصومال', 'topic', null, null, '🇸🇴', 1, 'SO'),
  ('مقديشو', 'غرفة أهل مقديشو', 'area', 'بنادر', null, '🏙️', 10, 'SO'),
  ('دردشة جيبوتي', 'اتكلم في أي حاجة مع ناس من كل جيبوتي', 'topic', null, null, '🇩🇯', 1, 'DJ'),
  ('مدينة جيبوتي', 'غرفة أهل العاصمة', 'area', 'جيبوتي', null, '🏙️', 10, 'DJ'),
  ('دردشة جزر القمر', 'اتكلم في أي حاجة مع ناس من كل جزر القمر', 'topic', null, null, '🇰🇲', 1, 'KM'),
  ('موروني', 'غرفة أهل موروني والقمر الكبرى', 'area', 'القمر الكبرى', null, '🏝️', 10, 'KM')
on conflict (name) do nothing;

-- The rooms of one country (the caller's, or p_country — the app's
-- country chip) plus the rooms shared by every country. near: 1 = your
-- district/city room, 2 = your governorate room (digital addresses in the
-- room's country, or your «ناس حواليك» area), 0 otherwise.
drop function if exists public.list_chat_rooms();
drop function if exists public.list_chat_rooms(text);
create or replace function public.list_chat_rooms(p_country text default null) returns table (
  id uuid, name text, description text, kind text, governorate text, area text, icon text, sort_order int,
  online_count int, recent_count int, last_message_at timestamptz, near int, country text
)
language sql stable security definer set search_path = public as $$
  with me as (
    select coalesce(private.arab_iso(p_country), private.user_country(auth.uid())) as c
  ), mine as (
    select public.chat_normalize(coalesce(a.district, '') || ' ' || coalesce(a.city, '')) as place,
           public.chat_normalize(a.governorate) as gov, a.country
    from public.e_addresses a where auth.uid() is not null and a.owner_id = auth.uid() and a.is_active
    union all
    select public.chat_normalize(pp.area), null, (select me.c from me) from public.people_presence pp
    where auth.uid() is not null and pp.user_id = auth.uid() and pp.discoverable and pp.area is not null
  )
  select r.id, r.name, r.description, r.kind, r.governorate, r.area, r.icon, r.sort_order,
         (select count(*)::int from public.chat_room_presence p where p.room_id = r.id and p.last_seen > now() - interval '90 seconds'),
         (select count(*)::int from public.chat_room_messages m where m.room_id = r.id and not m.is_hidden and m.created_at > now() - interval '1 hour'),
         (select max(m.created_at) from public.chat_room_messages m where m.room_id = r.id and not m.is_hidden),
         case
           when r.kind = 'area' and r.area is not null and exists (
             select 1 from mine where mine.country = r.country and position(public.chat_normalize(r.area) in mine.place) > 0) then 1
           when r.kind = 'area' and r.area is null and r.governorate is not null and exists (
             select 1 from mine where mine.country = r.country and (mine.gov = public.chat_normalize(r.governorate)
                                   or position(public.chat_normalize(r.governorate) in mine.place) > 0)) then 2
           else 0
         end,
         r.country
  from public.chat_rooms r, me
  where r.is_active and (r.country is null or r.country = me.c)
  order by 9 desc, 10 desc, r.sort_order, r.name;
$$;
grant execute on function public.list_chat_rooms(text) to anon, authenticated;

-- + p_country: the room's country; '' / 'ALL' = every country.
drop function if exists public.admin_save_chat_room(uuid, text, text, text, text, text, text, int, boolean);
drop function if exists public.admin_save_chat_room(uuid, text, text, text, text, text, text, int, boolean, text);
create or replace function public.admin_save_chat_room(
  p_id uuid, p_name text, p_description text, p_kind text, p_governorate text default null, p_area text default null,
  p_icon text default null, p_sort_order int default 100, p_is_active boolean default true, p_country text default 'EG'
) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid;
  v_country text := upper(btrim(coalesce(p_country, 'EG')));
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  if p_kind not in ('area', 'topic') then raise exception 'نوع الغرفة لازم يكون منطقة أو موضوع'; end if;
  if v_country in ('', 'ALL') then
    v_country := null;
  elsif not private.is_arab_country(v_country) then
    raise exception 'الدولة لازم تكون من الدول العربية';
  end if;
  if p_id is null then
    insert into public.chat_rooms (name, description, kind, governorate, area, icon, sort_order, is_active, country)
    values (trim(p_name), nullif(trim(coalesce(p_description, '')), ''), p_kind,
            nullif(trim(coalesce(p_governorate, '')), ''), nullif(trim(coalesce(p_area, '')), ''),
            nullif(trim(coalesce(p_icon, '')), ''), coalesce(p_sort_order, 100), coalesce(p_is_active, true), v_country)
    returning id into v_id;
    perform public.chat_log('room_create', v_id, null, null, jsonb_build_object('name', p_name));
  else
    update public.chat_rooms set name = trim(p_name), description = nullif(trim(coalesce(p_description, '')), ''), kind = p_kind,
      governorate = nullif(trim(coalesce(p_governorate, '')), ''), area = nullif(trim(coalesce(p_area, '')), ''),
      icon = nullif(trim(coalesce(p_icon, '')), ''), sort_order = coalesce(p_sort_order, 100),
      is_active = coalesce(p_is_active, true), country = v_country, updated_at = now()
    where id = p_id returning id into v_id;
    if v_id is null then raise exception 'الغرفة مش موجودة'; end if;
    perform public.chat_log('room_update', v_id, null, null, jsonb_build_object('name', p_name, 'is_active', p_is_active));
  end if;
  return v_id;
end;
$$;
revoke execute on function public.admin_save_chat_room(uuid, text, text, text, text, text, text, int, boolean, text) from public, anon;
grant execute on function public.admin_save_chat_room(uuid, text, text, text, text, text, text, int, boolean, text) to authenticated;

-- ======================================================== scrap dealers

alter table public.scrap_dealers add column if not exists country text not null default 'EG';
alter table public.scrap_dealers drop constraint if exists scrap_dealers_country_iso;
alter table public.scrap_dealers add constraint scrap_dealers_country_iso check (country ~ '^[A-Z]{2}$');
grant select (country) on public.scrap_dealers to authenticated;

-- The dealer's country: their base point's, else their profile's (the
-- client can't choose it — the column isn't granted).
create or replace function public._scrap_dealer_country() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  new.country := coalesce(private.arab_country_at(new.base_lat, new.base_lng), private.user_country(new.user_id));
  return new;
end;
$$;
revoke execute on function public._scrap_dealer_country() from public, anon, authenticated;
drop trigger if exists scrap_dealer_country on public.scrap_dealers;
create trigger scrap_dealer_country before insert or update of base_lat, base_lng, user_id on public.scrap_dealers
  for each row execute function public._scrap_dealer_country();

-- 0075's matching + the country: «الجيزة» in Egypt is not a Saudi lot.
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
        and d.country = l.country
        and (cardinality(d.areas) = 0
             or (l.area is not null and exists (
                   select 1 from unnest(d.areas) a where public.scrap_norm_area(a) = public.scrap_norm_area(l.area)))))
      or (d.radius_km is not null and d.base_lat is not null and d.base_lng is not null
          and l.lat is not null and l.lng is not null
          and public.scrap_distance_km(d.base_lat, d.base_lng, l.lat, l.lng) <= d.radius_km)
    );
$$;

-- ================================================================== SOS

-- «اتصل بالإسعاف 123 أو المطافئ 180» in the building's country (the app's
-- lib/core/geo/emergency_numbers.dart). Egypt's wording is unchanged.
create or replace function private.sos_emergency_hint(p_country text) returns text
language sql immutable as $$
  select case upper(coalesce(p_country, 'EG'))
    when 'EG' then 'اتصل بالإسعاف 123 أو المطافئ 180'
    when 'SA' then 'اتصل بالإسعاف 997 أو الدفاع المدني 998 (أو 911)'
    when 'AE' then 'اتصل بالإسعاف 998 أو الدفاع المدني 997'
    when 'KW' then 'اتصل بالطوارئ 112'
    when 'QA' then 'اتصل بالطوارئ 999'
    when 'BH' then 'اتصل بالطوارئ 999'
    when 'OM' then 'اتصل بالطوارئ 9999'
    when 'YE' then 'اتصل بالإسعاف 191 أو الشرطة 194'
    when 'JO' then 'اتصل بالطوارئ 911'
    when 'PS' then 'اتصل بالإسعاف 101 أو الدفاع المدني 102'
    when 'LB' then 'اتصل بالصليب الأحمر 140 أو الدفاع المدني 125'
    when 'SY' then 'اتصل بالإسعاف 110 أو المطافئ 113'
    when 'IQ' then 'اتصل بالإسعاف 122 أو الدفاع المدني 115 (أو 911)'
    when 'SD' then 'اتصل بالشرطة 999'
    when 'LY' then 'اتصل بالإسعاف 193 أو الشرطة 1515'
    when 'TN' then 'اتصل بالإسعاف 190 أو الحماية المدنية 198'
    when 'DZ' then 'اتصل بالحماية المدنية 14'
    when 'MA' then 'اتصل بالوقاية المدنية 15'
    when 'MR' then 'اتصل بالإسعاف 101 أو المطافئ 118'
    when 'SO' then 'اتصل بالإسعاف 999 أو المطافئ 555'
    when 'DJ' then 'اتصل بالإسعاف 19 أو المطافئ 18'
    when 'KM' then 'اتصل بالمطافئ 18 أو الشرطة 17'
    else 'اتصل بالطوارئ 112'
  end
$$;

create or replace function public.notify_building_of_sos() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_unit_number text;
  v_type_label text;
  v_country text;
begin
  select u.building_id, u.unit_number into v_building_id, v_unit_number
  from public.units u where u.id = new.unit_id;
  select b.country into v_country from public.buildings b where b.id = v_building_id;

  if tg_op = 'INSERT' then
    v_type_label := case new.type
      when 'medical' then 'طارئ طبي'
      when 'fire' then 'حريق'
      when 'gas_electric' then 'تسرب غاز / كهرباء'
      when 'security' then 'طارئ أمني'
      else 'طارئ'
    end;

    insert into public.notifications (user_id, title, body)
    select recipient, '🚨 استغاثة من شقة ' || coalesce(v_unit_number, ''),
           v_type_label || ' — أحد جيرانك طلب المساعدة الآن من شقة ' || coalesce(v_unit_number, '') || '. إذا استطعت المساعدة توجّه فوراً، وفي الحالات الخطيرة '
             || private.sos_emergency_hint(v_country) || '.'
    from (
      select m.user_id as recipient from public.union_members m
      where m.building_id = v_building_id and m.status = 'verified'
      union
      select g.user_id from public.building_guards g
      where g.building_id = v_building_id and g.is_active
    ) r
    where recipient <> new.triggered_by;

  elsif tg_op = 'UPDATE' and old.status = 'active' and new.status = 'false_alarm' then
    insert into public.notifications (user_id, title, body)
    select recipient, 'تم إلغاء الاستغاثة من شقة ' || coalesce(v_unit_number, ''),
           'قام صاحب الاستغاثة بإلغائها (إنذار غير مقصود). شكراً لاهتمامك.'
    from (
      select m.user_id as recipient from public.union_members m
      where m.building_id = v_building_id and m.status = 'verified'
      union
      select g.user_id from public.building_guards g
      where g.building_id = v_building_id and g.is_active
    ) r
    where recipient <> new.triggered_by;
  end if;

  return new;
end;
$$;

-- ============================================================ buildings

-- After 0092's defaults (trigger order is by name): a country chosen in
-- the app (found_building_in) wins, else the place's coordinates; the
-- currency follows whenever the country changes here.
create or replace function public._building_country() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  v text := private.arab_iso(nullif(current_setting('mogtama3y.building_country', true), ''));
begin
  v := coalesce(v, private.arab_country_at(new.lat::double precision, new.lng::double precision));
  if v is not null and v is distinct from new.country then
    new.country := v;
    new.currency := private.country_currency(v);
  end if;
  return new;
end;
$$;
revoke execute on function public._building_country() from public, anon, authenticated;
drop trigger if exists zz_building_country on public.buildings;
create trigger zz_building_country before insert on public.buildings
  for each row execute function public._building_country();

-- found_building (0051) in a chosen country.
create or replace function public.found_building_in(
  p_country text,
  p_name text,
  p_district text,
  p_city text,
  p_governorate text,
  p_unit_number text,
  p_floor_label text,
  p_google_place_id text default null,
  p_lat numeric default null,
  p_lng numeric default null,
  p_as_president boolean default true,
  p_existing_building_id uuid default null
) returns text
language plpgsql security definer set search_path = public as $$
begin
  perform set_config('mogtama3y.building_country', coalesce(private.arab_iso(p_country), ''), true);
  return public.found_building(p_name, p_district, p_city, p_governorate, p_unit_number, p_floor_label,
                               p_google_place_id, p_lat, p_lng, p_as_president, p_existing_building_id);
end;
$$;
revoke execute on function public.found_building_in(text, text, text, text, text, text, text, text, numeric, numeric, boolean, uuid) from public, anon;
grant execute on function public.found_building_in(text, text, text, text, text, text, text, text, numeric, numeric, boolean, uuid) to authenticated;

-- private.* helpers are internal.
revoke execute on function private.country_at(double precision, double precision) from public, anon, authenticated;
revoke execute on function private.arab_country_at(double precision, double precision) from public, anon, authenticated;
revoke execute on function private.in_arab_world(double precision, double precision) from public, anon, authenticated;
revoke execute on function private.arab_iso(text) from public, anon, authenticated;
revoke execute on function private.sos_emergency_hint(text) from public, anon, authenticated;
