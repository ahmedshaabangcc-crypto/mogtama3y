-- =====================================================================
-- Migration 0087 — «مسجدي» worldwide.
--
-- Until now mosques, reminders and prices assumed Egypt (a user in the
-- UAE found nothing worked). This migration:
--
--   * mosques: + country (ISO 3166 alpha-2), tz (IANA zone), currency
--     (ISO 4217), osm_type / osm_id (OpenStreetMap object it came from).
--     Existing rows (all from the Egyptian directory) → EG / Africa/Cairo
--     / EGP. A BEFORE INSERT trigger fills them for new rows: inside
--     Egypt (private.in_egypt — the same polygon as the app's
--     lib/core/masjid/world_places.dart) always EG / Africa/Cairo; else
--     the country the app sent, a valid tz (pg_timezone_names) or one
--     from the longitude, and the country's currency.
--   * masjid_add_mosque: anywhere on Earth (sane lat/lng, same limits),
--     + p_tz / p_country. masjid_import_osm(): a mosque the app found on
--     OpenStreetMap becomes ours once (unique per OSM object; matched to
--     an existing mosque within ~40 m with a similar name instead of a
--     duplicate), then the caller joins it.
--   * Verified phone (0083 chat, 0085 hand / speaking) is required only
--     for mosques in Egypt (owner decision): masjid_phone_required().
--     masjid_my_chat_profile's needs_phone follows it.
--   * Prayer reminders (0082) anywhere: set_prayer_reminders takes an
--     IANA tz + method / Asr / high-latitude rule; the SQL calculator
--     (private.mt_prayer_times) is the port of the app's methods
--     (lib/core/masjid/prayer_times.dart) and the clock is Postgres'
--     AT TIME ZONE instead of the Egypt summer-time rules.
--   * Money texts (notifications) in the mosque's currency; contact
--     WhatsApp, claim and competition phones accept international
--     numbers (+…); dates «today» in the mosque's zone.
--
-- profiles.phone / confirm_phone_verified (0074) stay Egypt-only on
-- purpose: SMS verification is only offered in Egypt, and only Egyptian
-- mosques require it. Run after 0086. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ============================================================ geography

-- Inside Egypt (Sinai and the Halaib triangle included, a little sea)?
create or replace function private.in_egypt(p_lat double precision, p_lng double precision) returns boolean
language plpgsql immutable as $$
declare
  ys double precision[] := array[22.0, 30.0, 31.6, 31.8, 31.8, 31.36, 29.49, 29.0, 28.5, 27.95, 27.2, 26.0, 24.0, 22.0];
  xs double precision[] := array[25.0, 25.0, 25.15, 25.2, 32.5, 34.2, 34.9, 34.75, 34.62, 34.47, 34.8, 35.3, 36.4, 37.3];
  j int := 14;
  v_in boolean := false;
begin
  if p_lat is null or p_lng is null then
    return false;
  end if;
  for i in 1..14 loop
    if ((ys[i] > p_lat) <> (ys[j] > p_lat))
       and p_lng < (xs[j] - xs[i]) * (p_lat - ys[i]) / (ys[j] - ys[i]) + xs[i] then
      v_in := not v_in;
    end if;
    j := i;
  end loop;
  return v_in;
end;
$$;

create or replace function private.valid_tz(p text) returns boolean
language sql stable as $$
  select p is not null and char_length(p) <= 64 and exists (select 1 from pg_timezone_names where name = p)
$$;

-- A whole-hour zone from the longitude (when nothing better is known).
create or replace function private.tz_from_lng(p_lng double precision) returns text
language sql immutable as $$
  select case when h = 0 then 'Etc/GMT' when h > 0 then 'Etc/GMT-' || h else 'Etc/GMT+' || (-h) end
  from (select greatest(-12, least(14, round(coalesce(p_lng, 0) / 15)::int)) as h) x
$$;

create or replace function private.country_currency(p text) returns text
language sql immutable as $$
  select case upper(coalesce(p, ''))
    when 'EG' then 'EGP' when 'SA' then 'SAR' when 'AE' then 'AED' when 'KW' then 'KWD' when 'QA' then 'QAR'
    when 'BH' then 'BHD' when 'OM' then 'OMR' when 'JO' then 'JOD' when 'IQ' then 'IQD' when 'LB' then 'LBP'
    when 'SY' then 'SYP' when 'YE' then 'YER' when 'PS' then 'ILS' when 'IL' then 'ILS' when 'LY' then 'LYD'
    when 'TN' then 'TND' when 'DZ' then 'DZD' when 'MA' then 'MAD' when 'SD' then 'SDG' when 'MR' then 'MRU'
    when 'TR' then 'TRY' when 'IR' then 'IRR' when 'PK' then 'PKR' when 'IN' then 'INR' when 'BD' then 'BDT'
    when 'AF' then 'AFN' when 'MY' then 'MYR' when 'SG' then 'SGD' when 'BN' then 'BND' when 'ID' then 'IDR'
    when 'GB' then 'GBP' when 'CA' then 'CAD' when 'AU' then 'AUD' when 'ZA' then 'ZAR' when 'NG' then 'NGN'
    when 'KE' then 'KES' when 'CH' then 'CHF' when 'SE' then 'SEK' when 'NO' then 'NOK' when 'DK' then 'DKK'
    when 'RU' then 'RUB' when 'BA' then 'BAM' when 'AL' then 'ALL'
    when 'FR' then 'EUR' when 'DE' then 'EUR' when 'NL' then 'EUR' when 'BE' then 'EUR' when 'IT' then 'EUR'
    when 'ES' then 'EUR' when 'AT' then 'EUR' when 'IE' then 'EUR' when 'PT' then 'EUR' when 'GR' then 'EUR'
    when 'CY' then 'EUR' when 'FI' then 'EUR' when 'LU' then 'EUR' when 'XK' then 'EUR'
    else 'USD' end
$$;

-- «ج.م» / «د.إ» / «$»… else the ISO code (same as the app's currencyLabel).
create or replace function private.currency_label(p text) returns text
language sql immutable as $$
  select case upper(coalesce(p, 'EGP'))
    when 'EGP' then 'ج.م' when 'AED' then 'د.إ' when 'SAR' then 'ر.س' when 'KWD' then 'د.ك' when 'QAR' then 'ر.ق'
    when 'BHD' then 'د.ب' when 'OMR' then 'ر.ع' when 'JOD' then 'د.أ' when 'IQD' then 'د.ع' when 'LBP' then 'ل.ل'
    when 'SYP' then 'ل.س' when 'YER' then 'ر.ي' when 'LYD' then 'د.ل' when 'TND' then 'د.ت' when 'DZD' then 'د.ج'
    when 'MAD' then 'د.م' when 'SDG' then 'ج.س' when 'USD' then '$' when 'EUR' then '€' when 'GBP' then '£'
    when 'TRY' then '₺' else upper(p) end
$$;

-- 01xxxxxxxxx (Egypt) or +<country><number> (E.164); null when invalid.
create or replace function public._masjid_norm_phone(p text) returns text
language plpgsql stable as $$
declare
  v text := regexp_replace(public._masjid_ascii_digits(btrim(coalesce(p, ''))), '[^0-9+]', '', 'g');
  v_intl boolean := v like '+%' or v like '00%';
  d text := regexp_replace(v, '[^0-9]', '', 'g');
begin
  if v_intl then
    d := regexp_replace(d, '^00', '');
  end if;
  if d ~ '^201[0-9]{9}$' then
    return '0' || substr(d, 3);
  end if;
  if not v_intl and d ~ '^01[0-9]{9}$' then
    return d;
  end if;
  if v_intl and d ~ '^[1-9][0-9]{6,14}$' then
    return '+' || d;
  end if;
  return null;
end;
$$;

-- ============================================================== mosques

alter table public.mosques add column if not exists country text;
alter table public.mosques add column if not exists tz text;
alter table public.mosques add column if not exists currency text;
alter table public.mosques add column if not exists osm_type text;
alter table public.mosques add column if not exists osm_id bigint;

update public.mosques
   set country = coalesce(country, 'EG'), tz = coalesce(tz, 'Africa/Cairo'), currency = coalesce(currency, 'EGP')
 where tz is null or currency is null;

alter table public.mosques alter column tz set not null;
alter table public.mosques alter column currency set not null;
alter table public.mosques drop constraint if exists mosques_country_iso;
alter table public.mosques add constraint mosques_country_iso check (country is null or country ~ '^[A-Z]{2}$');
alter table public.mosques drop constraint if exists mosques_currency_iso;
alter table public.mosques add constraint mosques_currency_iso check (currency ~ '^[A-Z]{3}$');
alter table public.mosques drop constraint if exists mosques_tz_len;
alter table public.mosques add constraint mosques_tz_len check (char_length(tz) between 1 and 64);
alter table public.mosques drop constraint if exists mosques_osm_ref;
alter table public.mosques add constraint mosques_osm_ref check (
  (osm_type is null and osm_id is null) or (osm_type in ('node', 'way', 'relation') and osm_id > 0));
create unique index if not exists mosques_osm_unique on public.mosques (osm_type, osm_id) where osm_id is not null;

-- WhatsApp: Egyptian 01x or international +…
alter table public.mosques drop constraint if exists mosques_contact_whatsapp_check;
alter table public.mosques drop constraint if exists mosques_contact_whatsapp_intl;
alter table public.mosques add constraint mosques_contact_whatsapp_intl
  check (contact_whatsapp is null or contact_whatsapp ~ '^(01[0-9]{9}|\+[1-9][0-9]{6,14})$');
alter table public.mosque_claims drop constraint if exists mosque_claims_phone_check;
alter table public.mosque_claims drop constraint if exists mosque_claims_phone_intl;
alter table public.mosque_claims add constraint mosque_claims_phone_intl
  check (phone ~ '^(01[0-9]{9}|\+[1-9][0-9]{6,14})$');
alter table public.mosque_competition_entries drop constraint if exists mosque_competition_entries_phone_check;
alter table public.mosque_competition_entries drop constraint if exists mosque_competition_entries_phone_intl;
alter table public.mosque_competition_entries add constraint mosque_competition_entries_phone_intl
  check (phone is null or phone ~ '^(01[0-9]{9}|\+[1-9][0-9]{6,14})$');

grant select (country, tz, currency, osm_type, osm_id) on public.mosques to anon, authenticated;

-- "1,000 د.إ" for an amount in a mosque's currency.
create or replace function public._masjid_money(p_amount numeric, p_mosque uuid) returns text
language sql stable security definer set search_path = public as $$
  select trim(to_char(coalesce(p_amount, 0), 'FM999G999G990')) || ' ' ||
         private.currency_label((select currency from public.mosques where id = p_mosque))
$$;


-- New rows: where they are decides country / zone / currency.
create or replace function public._masjid_mosque_place() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if private.in_egypt(new.lat, new.lng) then
    new.country := 'EG';
    new.tz := 'Africa/Cairo';
  else
    new.country := case when upper(btrim(coalesce(new.country, ''))) ~ '^[A-Z]{2}$' then upper(btrim(new.country)) end;
    if not private.valid_tz(new.tz) then
      new.tz := private.tz_from_lng(new.lng);
    end if;
  end if;
  new.currency := case when upper(coalesce(new.currency, '')) ~ '^[A-Z]{3}$' then upper(new.currency)
                       else private.country_currency(new.country) end;
  return new;
end;
$$;
revoke execute on function public._masjid_mosque_place() from public, anon, authenticated;
drop trigger if exists masjid_mosque_place on public.mosques;
create trigger masjid_mosque_place before insert on public.mosques
  for each row execute function public._masjid_mosque_place();

-- Verified phone needed to post / speak? Only in Egyptian mosques.
create or replace function public.masjid_phone_required(p_mosque uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((select coalesce(m.country, '') = 'EG' from public.mosques m where m.id = p_mosque), true)
$$;

-- get_mosque (0081) + country, tz, currency, osm, phone_required.
create or replace function public.get_mosque(p_id uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  m public.mosques;
  a public.mosque_admins;
  f public.mosque_follows;
  mm public.mosque_members;
  v_perms text[];
begin
  select * into m from public.mosques where id = p_id;
  if not found then
    return null;
  end if;
  if auth.uid() is not null then
    select * into a from public.mosque_admins where mosque_id = p_id and user_id = auth.uid();
    select * into f from public.mosque_follows where mosque_id = p_id and user_id = auth.uid();
    select * into mm from public.mosque_members where mosque_id = p_id and user_id = auth.uid();
  end if;
  v_perms := case
    when a.user_id is null or not m.verified then '{}'::text[]
    when a.role = 'owner' then array['posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings', 'chat', 'team']
    else a.permissions end;
  return jsonb_build_object(
    'id', m.id, 'name', m.name, 'lat', m.lat, 'lng', m.lng, 'address', m.address,
    'governorate', m.governorate, 'area', m.area, 'verified', m.verified,
    'country', m.country, 'tz', m.tz, 'currency', m.currency,
    'osm', case when m.osm_id is not null then m.osm_type || '/' || m.osm_id end,
    'phone_required', coalesce(m.country, '') = 'EG',
    'contact_phone', m.contact_phone, 'contact_whatsapp', m.contact_whatsapp, 'payment_note', m.payment_note,
    'friday_khutba_time', m.friday_khutba_time, 'khatib', m.khatib,
    'iqama', jsonb_build_object('fajr', m.iqama_fajr, 'dhuhr', m.iqama_dhuhr, 'asr', m.iqama_asr,
                                'maghrib', m.iqama_maghrib, 'isha', m.iqama_isha),
    'followers', (select count(*) from public.mosque_follows x where x.mosque_id = m.id),
    'members', (select count(*) from public.mosque_members x where x.mosque_id = m.id),
    'is_member', mm.user_id is not null,
    'is_primary', coalesce(mm.is_primary, false),
    'chat_messages', (select count(*) from public.mosque_chat_messages c where c.mosque_id = m.id and not c.is_hidden),
    'chat_today', (select count(*) from public.mosque_chat_messages c
                   where c.mosque_id = m.id and not c.is_hidden and c.created_at > now() - interval '24 hours'),
    'can_moderate_chat', auth.uid() is not null and public.masjid_chat_can_moderate(m.id),
    'is_following', f.user_id is not null,
    'notify', coalesce(f.notify, false),
    'my_role', a.role,
    'my_permissions', to_jsonb(v_perms),
    'my_pending_claim', auth.uid() is not null and exists (
      select 1 from public.mosque_claims c where c.mosque_id = m.id and c.user_id = auth.uid() and c.status = 'pending'));
end;
$$;
grant execute on function public.get_mosque(uuid) to anon, authenticated;

-- «مسجدي مش موجود؟ ضيفه» — anywhere now. The creator joins it.
drop function if exists public.masjid_add_mosque(text, double precision, double precision, text, text, text);
create or replace function public.masjid_add_mosque(
  p_name text, p_lat double precision, p_lng double precision,
  p_address text default null, p_area text default null, p_governorate text default null,
  p_tz text default null, p_country text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_name text := btrim(coalesce(p_name, ''));
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if char_length(v_name) < 3 then
    raise exception 'اكتب اسم المسجد';
  end if;
  if p_lat is null or p_lng is null or p_lat not between -90 and 90 or p_lng not between -180 and 180
     or (abs(p_lat) < 0.001 and abs(p_lng) < 0.001) then
    raise exception 'حدد مكان المسجد على الخريطة';
  end if;
  select id into v_id from public.mosques
  where name = v_name and abs(lat - p_lat) < 0.002 and abs(lng - p_lng) < 0.002 limit 1;
  if v_id is null then
    if (select count(*) from public.mosques where added_by = auth.uid() and created_at > now() - interval '1 day') >= 3 then
      raise exception 'ضفت مساجد كتير النهارده، جرّب بكرة';
    end if;
    insert into public.mosques (name, lat, lng, address, area, governorate, added_by, tz, country)
    values (left(v_name, 120), p_lat, p_lng, left(nullif(btrim(p_address), ''), 300),
            left(nullif(btrim(p_area), ''), 80), left(nullif(btrim(p_governorate), ''), 60), auth.uid(),
            nullif(btrim(p_tz), ''), nullif(btrim(p_country), ''))
    returning id into v_id;
  end if;
  -- Best effort: someone already in 20 mosques still gets the mosque added.
  begin
    perform public.masjid_join(v_id);
  exception when others then
    null;
  end;
  return v_id;
end;
$$;
revoke execute on function public.masjid_add_mosque(text, double precision, double precision, text, text, text, text, text) from public, anon;
grant execute on function public.masjid_add_mosque(text, double precision, double precision, text, text, text, text, text) to authenticated;

-- Name without «مسجد / جامع / mosque…», spaces and punctuation, for matching.
create or replace function private.mosque_name_key(p text) returns text
language sql immutable as $$
  select regexp_replace(
           regexp_replace(lower(coalesce(p, '')), '(مسجد|جامع|زاوية|masjid|masjed|mosque|jami|camii|cami|mescidi|the|al-|el-)', '', 'g'),
           '[^[:alnum:]]', '', 'g')
$$;

-- A mosque found on OpenStreetMap → ours (once), then joined [p_join].
create or replace function public.masjid_import_osm(
  p_osm_type text, p_osm_id bigint, p_name text, p_lat double precision, p_lng double precision,
  p_tz text default null, p_country text default null, p_join boolean default true
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_name text := left(btrim(regexp_replace(coalesce(p_name, ''), '\s+', ' ', 'g')), 120);
  v_key text;
  r record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_osm_type is null or p_osm_type not in ('node', 'way', 'relation') or p_osm_id is null or p_osm_id <= 0 then
    raise exception 'مسجد غير صالح';
  end if;
  if p_lat is null or p_lng is null or p_lat not between -90 and 90 or p_lng not between -180 and 180
     or (abs(p_lat) < 0.001 and abs(p_lng) < 0.001) then
    raise exception 'مكان المسجد غير صالح';
  end if;
  if char_length(v_name) < 2 then
    v_name := 'مسجد';
  end if;

  select id into v_id from public.mosques where osm_type = p_osm_type and osm_id = p_osm_id;
  if v_id is null then
    -- Already have it (directory / added by someone) within ~40 m with a similar name?
    v_key := private.mosque_name_key(v_name);
    for r in
      select m.id, m.name, m.osm_id,
             111195.0 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) as dist
      from public.mosques m
      where m.lat between p_lat - 0.0005 and p_lat + 0.0005
        and m.lng between p_lng - 0.0005 / greatest(cos(radians(p_lat)), 0.2) and p_lng + 0.0005 / greatest(cos(radians(p_lat)), 0.2)
      order by dist
    loop
      continue when r.dist > 40;
      if v_key = '' or private.mosque_name_key(r.name) = ''
         or private.mosque_name_key(r.name) = v_key
         or (char_length(v_key) >= 3 and strpos(private.mosque_name_key(r.name), v_key) > 0)
         or (char_length(private.mosque_name_key(r.name)) >= 3 and strpos(v_key, private.mosque_name_key(r.name)) > 0) then
        v_id := r.id;
        if r.osm_id is null then
          update public.mosques set osm_type = p_osm_type, osm_id = p_osm_id, updated_at = now() where id = r.id;
        end if;
        exit;
      end if;
    end loop;
  end if;

  if v_id is null then
    if (select count(*) from public.mosques
        where added_by = auth.uid() and osm_id is not null and created_at > now() - interval '1 day') >= 30 then
      raise exception 'فتحت مساجد جديدة كتير النهارده، جرّب بكرة';
    end if;
    insert into public.mosques (name, lat, lng, added_by, tz, country, osm_type, osm_id)
    values (v_name, p_lat, p_lng, auth.uid(), nullif(btrim(p_tz), ''), nullif(btrim(p_country), ''), p_osm_type, p_osm_id)
    on conflict (osm_type, osm_id) where osm_id is not null do nothing
    returning id into v_id;
    if v_id is null then
      select id into v_id from public.mosques where osm_type = p_osm_type and osm_id = p_osm_id;
    end if;
  end if;

  if coalesce(p_join, true) then
    begin
      perform public.masjid_join(v_id);
    exception when others then
      null;
    end;
  end if;
  return v_id;
end;
$$;
revoke execute on function public.masjid_import_osm(text, bigint, text, double precision, double precision, text, text, boolean) from public, anon;
grant execute on function public.masjid_import_osm(text, bigint, text, double precision, double precision, text, text, boolean) to authenticated;

-- Settings (0080) + currency; WhatsApp may be international.
create or replace function public.masjid_update_settings(p_mosque uuid, p jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_wa_raw text := nullif(btrim(coalesce(p->>'contact_whatsapp', '')), '');
  v_wa text := public._masjid_norm_phone(v_wa_raw);
  v_phone text := nullif(regexp_replace(coalesce(p->>'contact_phone', ''), '[^0-9+]', '', 'g'), '');
  v_cur text := upper(nullif(btrim(coalesce(p->>'currency', '')), ''));
begin
  if not public.masjid_can(p_mosque, 'settings') then
    raise exception 'غير مصرح';
  end if;
  if v_wa_raw is not null and v_wa is null then
    raise exception 'رقم الواتساب: 01xxxxxxxxx أو بالمفتاح الدولي زي +9715xxxxxxxx';
  end if;
  if v_cur is not null and v_cur !~ '^[A-Z]{3}$' then
    raise exception 'العملة غير صحيحة';
  end if;
  update public.mosques set
    address = left(nullif(btrim(p->>'address'), ''), 300),
    area = left(nullif(btrim(p->>'area'), ''), 80),
    governorate = left(nullif(btrim(p->>'governorate'), ''), 60),
    contact_phone = v_phone,
    contact_whatsapp = v_wa,
    payment_note = left(nullif(btrim(p->>'payment_note'), ''), 300),
    friday_khutba_time = nullif(p->>'friday_khutba_time', '')::time,
    khatib = left(nullif(btrim(p->>'khatib'), ''), 80),
    iqama_fajr = nullif(p->>'iqama_fajr', '')::smallint,
    iqama_dhuhr = nullif(p->>'iqama_dhuhr', '')::smallint,
    iqama_asr = nullif(p->>'iqama_asr', '')::smallint,
    iqama_maghrib = nullif(p->>'iqama_maghrib', '')::smallint,
    iqama_isha = nullif(p->>'iqama_isha', '')::smallint,
    currency = coalesce(v_cur, currency),
    updated_at = now()
  where id = p_mosque;
end;
$$;
revoke execute on function public.masjid_update_settings(uuid, jsonb) from public, anon;
grant execute on function public.masjid_update_settings(uuid, jsonb) to authenticated;

-- ================================================== claims & competitions

create or replace function public.masjid_claim(
  p_mosque uuid, p_role text, p_phone text, p_doc_path text default null, p_note text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_phone text := public._masjid_norm_phone(p_phone);
  v_doc text := nullif(btrim(coalesce(p_doc_path, '')), '');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not exists (select 1 from public.mosques where id = p_mosque) then
    raise exception 'المسجد مش موجود';
  end if;
  if p_role is null or p_role not in ('imam', 'khatib', 'amin', 'board') then
    raise exception 'اختار صفتك في المسجد';
  end if;
  if v_phone is null then
    raise exception 'اكتب رقم موبايل صحيح: 01xxxxxxxxx أو بالمفتاح الدولي زي +9715xxxxxxxx';
  end if;
  if v_doc is not null and v_doc not like auth.uid()::text || '/%' then
    raise exception 'مستند غير صالح';
  end if;
  if exists (select 1 from public.mosque_admins a where a.mosque_id = p_mosque and a.user_id = auth.uid() and a.role = 'owner') then
    raise exception 'إنت بالفعل مسؤول عن المسجد ده';
  end if;
  if exists (select 1 from public.mosque_claims where mosque_id = p_mosque and user_id = auth.uid() and status = 'pending') then
    raise exception 'طلبك قيد المراجعة بالفعل';
  end if;
  if (select count(*) from public.mosque_claims where user_id = auth.uid() and status = 'pending') >= 3 then
    raise exception 'عندك طلبات كتير قيد المراجعة';
  end if;
  insert into public.mosque_claims (mosque_id, user_id, role_title, phone, doc_path, note)
  values (p_mosque, auth.uid(), p_role, v_phone, v_doc, left(nullif(btrim(p_note), ''), 500))
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.masjid_claim(uuid, text, text, text, text) from public, anon;
grant execute on function public.masjid_claim(uuid, text, text, text, text) to authenticated;

create or replace function public.masjid_register_competition(
  p_competition uuid, p_level uuid, p_name text, p_age int default null, p_phone text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_competitions;
  v_id uuid;
  v_raw text := nullif(btrim(coalesce(p_phone, '')), '');
  v_phone text := public._masjid_norm_phone(p_phone);
  v_tz text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into c from public.mosque_competitions where id = p_competition;
  if not found then
    raise exception 'المسابقة مش موجودة';
  end if;
  select tz into v_tz from public.mosques where id = c.mosque_id;
  if c.status <> 'open' or (c.registration_deadline is not null
                            and c.registration_deadline < (now() at time zone coalesce(v_tz, 'Africa/Cairo'))::date) then
    raise exception 'التسجيل في المسابقة دي اتقفل';
  end if;
  if not exists (select 1 from public.mosque_competition_levels l where l.id = p_level and l.competition_id = p_competition) then
    raise exception 'اختار المستوى';
  end if;
  if char_length(btrim(coalesce(p_name, ''))) < 2 then
    raise exception 'اكتب اسم المتسابق';
  end if;
  if v_raw is not null and v_phone is null then
    raise exception 'اكتب رقم موبايل صحيح: 01xxxxxxxxx أو بالمفتاح الدولي زي +9715xxxxxxxx';
  end if;
  if (select count(*) from public.mosque_competition_entries
      where competition_id = p_competition and user_id = auth.uid() and status = 'registered') >= 6 then
    raise exception 'سجلت عدد كبير في المسابقة دي';
  end if;
  insert into public.mosque_competition_entries (competition_id, level_id, mosque_id, user_id, contestant_name, contestant_age, phone)
  values (p_competition, p_level, c.mosque_id, auth.uid(), left(btrim(p_name), 80), p_age, v_phone)
  on conflict (competition_id, user_id, contestant_name) do update
    set level_id = excluded.level_id, contestant_age = excluded.contestant_age, phone = excluded.phone, status = 'registered'
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.masjid_register_competition(uuid, uuid, text, int, text) from public, anon;
grant execute on function public.masjid_register_competition(uuid, uuid, text, int, text) to authenticated;

-- ===================================================== money in texts

create or replace function public._masjid_content_notify() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
begin
  select name into v_name from public.mosques where id = new.mosque_id;
  if tg_table_name = 'mosque_posts' then
    perform public._masjid_notify_followers(new.mosque_id, new.kind in ('urgent', 'janaza'),
      case new.kind when 'janaza' then 'صلاة جنازة — ' || v_name
                    when 'urgent' then 'تنبيه عاجل — ' || v_name
                    else 'إعلان جديد — ' || v_name end,
      new.title);
  elsif tg_table_name = 'mosque_lessons' then
    perform public._masjid_notify_followers(new.mosque_id, false,
      case new.kind when 'quran_circle' then 'حلقة قرآن جديدة — ' else 'درس جديد — ' end || v_name,
      new.title || coalesce(' مع ' || new.sheikh, ''));
  elsif tg_table_name = 'mosque_needs' then
    perform public._masjid_notify_followers(new.mosque_id, false, 'احتياج جديد للمسجد — ' || v_name,
      new.title || ' — المطلوب ' || public._masjid_money(new.target_amount, new.mosque_id));
  end if;
  return new;
end;
$$;
revoke execute on function public._masjid_content_notify() from public, anon, authenticated;

create or replace function public.masjid_pledge(p_need uuid, p_amount numeric, p_note text default null, p_anonymous boolean default false)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  n public.mosque_needs;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into n from public.mosque_needs where id = p_need;
  if not found then
    raise exception 'الاحتياج مش موجود';
  end if;
  if n.status <> 'open' then
    raise exception 'الاحتياج ده اكتمل واتقفل — جزاك الله خيراً';
  end if;
  if p_amount is null or p_amount < 1 or p_amount > 10000000 then
    raise exception 'اكتب مبلغ صحيح';
  end if;
  if (select count(*) from public.mosque_need_contributions
      where user_id = auth.uid() and created_at > now() - interval '1 day') >= 10 then
    raise exception 'سجلت مساهمات كتير النهارده';
  end if;
  insert into public.mosque_need_contributions (need_id, mosque_id, user_id, anonymous, kind, amount, note, status)
  values (p_need, n.mosque_id, auth.uid(), coalesce(p_anonymous, false), 'pledge', round(p_amount, 2),
          left(nullif(btrim(p_note), ''), 300), 'pledged')
  returning id into v_id;
  insert into public.notifications (user_id, title, body, deep_link)
  select a.user_id, 'تعهد جديد بـ ' || public._masjid_money(p_amount, n.mosque_id),
         'على «' || n.title || '» — أكّد لما المبلغ يوصلك.', '/#/masjid/' || n.mosque_id
  from public.mosque_admins a
  where a.mosque_id = n.mosque_id and (a.role = 'owner' or 'needs' = any(a.permissions))
    and a.user_id <> auth.uid();
  return v_id;
end;
$$;
revoke execute on function public.masjid_pledge(uuid, numeric, text, boolean) from public, anon;
grant execute on function public.masjid_pledge(uuid, numeric, text, boolean) to authenticated;

create or replace function public.masjid_confirm_contribution(p_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_need_contributions;
  v_title text;
begin
  select * into c from public.mosque_need_contributions where id = p_id for update;
  if not found then
    raise exception 'المساهمة مش موجودة';
  end if;
  if not public.masjid_can(c.mosque_id, 'needs') then
    raise exception 'غير مصرح';
  end if;
  if c.status <> 'pledged' then
    raise exception 'المساهمة دي اتأكدت أو اتلغت قبل كده';
  end if;
  update public.mosque_need_contributions set status = 'confirmed', confirmed_by = auth.uid(), confirmed_at = now() where id = p_id;
  if c.user_id is not null and c.user_id <> auth.uid() then
    select title into v_title from public.mosque_needs where id = c.need_id;
    insert into public.notifications (user_id, title, body, deep_link)
    values (c.user_id, 'مساهمتك وصلت ✓ جزاك الله خيراً',
            'المسجد أكّد استلام ' || public._masjid_money(c.amount, c.mosque_id) || ' لـ «' || v_title || '».',
            '/#/masjid/' || c.mosque_id);
  end if;
end;
$$;
revoke execute on function public.masjid_confirm_contribution(uuid) from public, anon;
grant execute on function public.masjid_confirm_contribution(uuid) to authenticated;

create or replace function public.masjid_sponsor(p_program uuid, p_monthly_amount numeric, p_note text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  o public.mosque_orphan_programs;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into o from public.mosque_orphan_programs where id = p_program;
  if not found or o.status <> 'open' then
    raise exception 'البرنامج ده مش متاح دلوقتي';
  end if;
  if p_monthly_amount is null or p_monthly_amount < 1 or p_monthly_amount > 1000000 then
    raise exception 'اكتب مبلغ شهري صحيح';
  end if;
  if exists (select 1 from public.mosque_orphan_sponsorships
             where program_id = p_program and user_id = auth.uid() and status in ('pledged', 'active')) then
    raise exception 'إنت مسجّل بالفعل في البرنامج ده';
  end if;
  insert into public.mosque_orphan_sponsorships (program_id, mosque_id, user_id, monthly_amount, note)
  values (p_program, o.mosque_id, auth.uid(), round(p_monthly_amount, 2), left(nullif(btrim(p_note), ''), 300))
  returning id into v_id;
  insert into public.notifications (user_id, title, body, deep_link)
  select a.user_id, 'كفيل جديد بـ ' || public._masjid_money(p_monthly_amount, o.mosque_id) || ' شهرياً',
         'على «' || o.title || '» — تواصل معاه وأكّد لما يبدأ.', '/#/masjid/' || o.mosque_id
  from public.mosque_admins a
  where a.mosque_id = o.mosque_id and (a.role = 'owner' or 'orphans' = any(a.permissions)) and a.user_id <> auth.uid();
  return v_id;
end;
$$;
revoke execute on function public.masjid_sponsor(uuid, numeric, text) from public, anon;
grant execute on function public.masjid_sponsor(uuid, numeric, text) to authenticated;

-- + currency (return type changes → drop / create).
drop function if exists public.masjid_my_sponsorships();
create function public.masjid_my_sponsorships()
returns table (id uuid, program_id uuid, mosque_id uuid, mosque_name text, title text, monthly_amount numeric,
               status text, created_at timestamptz, currency text)
language sql
stable
security definer
set search_path = public
as $$
  select s.id, s.program_id, s.mosque_id, m.name, o.title, s.monthly_amount, s.status, s.created_at, m.currency
  from public.mosque_orphan_sponsorships s
  join public.mosque_orphan_programs o on o.id = s.program_id
  join public.mosques m on m.id = s.mosque_id
  where s.user_id = auth.uid()
  order by s.created_at desc;
$$;
revoke execute on function public.masjid_my_sponsorships() from public, anon;
grant execute on function public.masjid_my_sponsorships() to authenticated;

-- «قريب منك» (0081): «today» in each mosque's own zone; needs carry the currency.
create or replace function public.masjid_nearby_feed(
  p_lat double precision default null, p_lng double precision default null, p_km double precision default 3, p_limit int default 30
) returns table (
  kind text, item_id uuid, mosque_id uuid, mosque_name text, distance_km double precision,
  title text, subtitle text, extra jsonb, at timestamptz
)
language sql stable security definer set search_path = public as $$
  with box as (
    select least(greatest(coalesce(p_km, 3), 0.5), 15) as km
  ), ms as (
    select m.id, m.name, m.currency,
           extract(isodow from (now() at time zone m.tz))::smallint as d,
           (now() at time zone m.tz)::date as day,
           case when p_lat is not null and p_lng is not null
                then 111.195 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) end as dist
    from public.mosques m, box
    where (p_lat is not null and p_lng is not null
           and m.lat between p_lat - box.km / 111.0 and p_lat + box.km / 111.0
           and m.lng between p_lng - box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2))
                         and p_lng + box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2)))
       or (auth.uid() is not null and exists (select 1 from public.mosque_members mm where mm.mosque_id = m.id and mm.user_id = auth.uid()))
  ), items as (
    (select 'urgent'::text as kind, p.id, ms.id as mosque_id, ms.name, ms.dist, p.title, p.body as subtitle,
            jsonb_build_object('post_kind', p.kind) as extra, p.created_at as at, 0 as prio
     from public.mosque_posts p join ms on ms.id = p.mosque_id
     where p.kind in ('urgent', 'janaza') and p.created_at > now() - interval '2 days'
     order by p.created_at desc limit 6)
    union all
    (select 'lesson', l.id, ms.id, ms.name, ms.dist, l.title, l.sheikh,
            jsonb_build_object('lesson_kind', l.kind, 'weekdays', to_jsonb(l.weekdays), 'after_prayer', l.after_prayer,
                               'start_time', l.start_time, 'audience', l.audience,
                               'today', ms.d = any(l.weekdays)),
            null::timestamptz, 1
     from public.mosque_lessons l join ms on ms.id = l.mosque_id
     where l.active and (cardinality(l.weekdays) = 0
                         or ms.d = any(l.weekdays)
                         or (ms.d % 7 + 1)::smallint = any(l.weekdays))
     order by (ms.d = any(l.weekdays)) desc, ms.dist nulls last limit 10)
    union all
    (select 'need', n.id, ms.id, ms.name, ms.dist, n.title, n.description,
            jsonb_build_object('target_amount', n.target_amount, 'currency', ms.currency,
                               'confirmed_amount', coalesce((select sum(c.amount) from public.mosque_need_contributions c
                                                             where c.need_id = n.id and c.status = 'confirmed'), 0)),
            n.created_at, 2
     from public.mosque_needs n join ms on ms.id = n.mosque_id
     where n.status = 'open'
     order by ms.dist nulls last, n.created_at desc limit 8)
    union all
    (select 'competition', c.id, ms.id, ms.name, ms.dist, c.title, c.description,
            jsonb_build_object('registration_deadline', c.registration_deadline, 'starts_on', c.starts_on),
            c.created_at, 3
     from public.mosque_competitions c join ms on ms.id = c.mosque_id
     where c.status = 'open' and (c.registration_deadline is null or c.registration_deadline >= ms.day)
     order by ms.dist nulls last, c.created_at desc limit 6)
  )
  select i.kind, i.id, i.mosque_id, i.name, i.dist, i.title, left(i.subtitle, 200), i.extra, i.at
  from items i
  order by i.prio, i.dist nulls last, i.at desc nulls last
  limit least(greatest(coalesce(p_limit, 30), 1), 60);
$$;
revoke execute on function public.masjid_nearby_feed(double precision, double precision, double precision, int) from public;
grant execute on function public.masjid_nearby_feed(double precision, double precision, double precision, int) to anon, authenticated;

-- ============================================ verified phone: Egypt only

create or replace function public.masjid_my_chat_profile(p_mosque uuid) returns jsonb
language plpgsql stable security definer set search_path = public as $$
declare
  v_row public.mosque_chat_nicknames;
  p public.profiles;
  v_req boolean := public.masjid_phone_required(p_mosque);
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into p from public.profiles where id = auth.uid();
  select * into v_row from public.mosque_chat_nicknames where mosque_id = p_mosque and user_id = auth.uid();
  return jsonb_build_object(
    'nickname', v_row.nickname,
    'real_name', p.full_name,
    'can_change_at', case when v_row.user_id is not null and v_row.changed_at > now() - interval '1 day'
                          then v_row.changed_at + interval '1 day' end,
    'phone_verified', p.phone_verified_at is not null,
    'phone_required', v_req,
    'needs_phone', v_req and p.phone_verified_at is null and not public.is_super_admin());
end;
$$;

-- 0083's send: the verified phone only in Egyptian mosques; sanction
-- times in the mosque's zone; international numbers count as numbers.
create or replace function public.masjid_chat_send(p_mosque uuid, p_body text, p_reply_to uuid default null) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_body text := btrim(coalesce(p_body, ''));
  v_flat text;
  v_mod boolean;
  v_kind text;
  v_until timestamptz;
  v_last timestamptz;
  v_reply public.mosque_chat_messages;
  v_id uuid;
  v_tz text;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select tz into v_tz from public.mosques where id = p_mosque;
  if v_tz is null then
    raise exception 'المسجد مش موجود';
  end if;
  v_mod := public.masjid_chat_can_moderate(p_mosque);
  if not public.masjid_is_member(p_mosque) and not public.masjid_can(p_mosque, 'chat') then
    raise exception 'انضم للمسجد عشان تشارك في الشات';
  end if;
  if public.masjid_phone_required(p_mosque) and not public.is_super_admin()
     and (select phone_verified_at from public.profiles where id = auth.uid()) is null then
    raise exception 'لازم توثّق رقم موبايلك عشان تكتب في الشات' using hint = 'phone_unverified';
  end if;

  select s.kind, s.until into v_kind, v_until from public.masjid_chat_active_sanction(auth.uid(), p_mosque) s;
  if v_kind = 'ban' then
    raise exception '%', case when v_until is null then 'إنت ممنوع من الكتابة في شات المسجد ده'
                              else 'إنت ممنوع من الكتابة في شات المسجد لحد ' || to_char(v_until at time zone v_tz, 'YYYY/MM/DD HH24:MI') end;
  end if;
  if v_kind = 'mute' then
    raise exception 'إنت مكتوم مؤقتاً في شات المسجد لحد %', to_char(v_until at time zone v_tz, 'YYYY/MM/DD HH24:MI');
  end if;

  if char_length(v_body) < 1 then
    raise exception 'اكتب رسالة الأول';
  end if;
  if char_length(v_body) > 1000 then
    raise exception 'الرسالة طويلة، الحد 1000 حرف';
  end if;

  select max(created_at) into v_last from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque;
  if v_last is not null and v_last > now() - interval '3 seconds' then
    raise exception 'استنى ثانيتين قبل الرسالة الجاية';
  end if;
  if (select count(*) from public.mosque_chat_messages
      where user_id = auth.uid() and mosque_id = p_mosque and created_at > now() - interval '1 hour') >= 60 then
    raise exception 'كتبت رسايل كتير الساعة دي، استنى شوية';
  end if;
  if exists (select 1 from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque
             and body = v_body and created_at > now() - interval '1 minute') then
    raise exception 'إنت لسه باعت نفس الرسالة';
  end if;

  if public.chat_has_banned_word(v_body) then
    raise exception 'الرسالة فيها كلام مش لطيف، عدّلها وابعت تاني';
  end if;

  if not v_mod then
    v_flat := regexp_replace(public._masjid_ascii_digits(v_body), '[\s\-\.()]', '', 'g');
    if v_flat ~ '(\+?20|0)1[0125][0-9]{8}' or v_flat ~ '(\+|00)[1-9][0-9]{7,14}' or v_flat ~ '(^|[^0-9])05[0-9]{8}([^0-9]|$)' then
      raise exception 'ممنوع أرقام الموبايل في شات المسجد — اتواصلوا خاص';
    end if;
    if lower(v_body) ~ '(https?://|www\.|t\.me/|wa\.me/|bit\.ly|[a-z0-9-]+\.(com|net|org|eg|io|me|ly|co|info|xyz|link|app|site|online|store|shop|tk|biz)([^a-z0-9]|$))' then
      if (select created_at from public.profiles where id = auth.uid()) > now() - interval '7 days'
         or (select count(*) from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque) < 20 then
        raise exception 'اللينكات مسموحة بعد ما يعدّي على حسابك أسبوع وتكتب 20 رسالة في شات المسجد';
      end if;
    end if;
  end if;

  if p_reply_to is not null then
    select * into v_reply from public.mosque_chat_messages where id = p_reply_to;
    if v_reply.id is null or v_reply.mosque_id <> p_mosque or v_reply.is_hidden then
      raise exception 'الرسالة اللي بترد عليها مش موجودة';
    end if;
  end if;

  insert into public.mosque_chat_messages (mosque_id, user_id, body, reply_to)
  values (p_mosque, auth.uid(), v_body, p_reply_to)
  returning id into v_id;
  update public.mosque_members set last_read_at = now() where mosque_id = p_mosque and user_id = auth.uid();
  return v_id;
end;
$$;

-- 0085's join check: can_speak without a verified phone outside Egypt.
create or replace function public.masjid_live_join_check(p_session uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_mosque text;
  v_host boolean;
  v_p public.mosque_live_participants;
  v_name text;
  v_verified boolean;
  v_role text;
  v_info jsonb;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null then
    return jsonb_build_object('ok', false, 'reason', 'not_found', 'message', 'الدرس ده مش موجود');
  end if;
  select name into v_mosque from public.mosques where id = s.mosque_id;
  v_info := public._masjid_live_json(s, v_mosque);
  if auth.uid() is null then
    return jsonb_build_object('ok', false, 'reason', 'sign_in', 'message', 'سجّل دخول الأول عشان تحضر الدرس', 'session', v_info);
  end if;
  v_host := public.masjid_can(s.mosque_id, 'lessons');
  if s.status = 'cancelled' then
    return jsonb_build_object('ok', false, 'reason', 'cancelled', 'message', 'الدرس ده اتلغى', 'session', v_info);
  end if;
  if s.status = 'ended' or public._masjid_live_stale(s) then
    return jsonb_build_object('ok', false, 'reason', 'ended', 'message', 'الدرس خلص — الدروس المباشرة مش بتتسجّل', 'session', v_info);
  end if;
  if not v_host and s.visibility = 'members' and not public.masjid_is_member(s.mosque_id) then
    return jsonb_build_object('ok', false, 'reason', 'members_only', 'message', 'الدرس ده لأعضاء المسجد بس — انضم للمسجد الأول', 'session', v_info);
  end if;
  if s.status = 'scheduled' then
    return jsonb_build_object('ok', false, 'reason', 'not_live',
      'message', case when v_host then 'الدرس لسه مابدأش — اضغط «ابدأ الدرس»' else 'الدرس لسه مابدأش' end,
      'is_host', v_host, 'session', v_info);
  end if;

  select * into v_p from public.mosque_live_participants where session_id = s.id and user_id = auth.uid();
  if v_p.removed_at is not null and not v_host then
    return jsonb_build_object('ok', false, 'reason', 'removed', 'message', 'إدارة المسجد طلّعتك من الدرس ده', 'session', v_info);
  end if;
  if v_p.id is null then
    if not v_host and (select count(*) from public.mosque_live_participants
                       where user_id = auth.uid() and joined_at > now() - interval '1 hour') >= 30 then
      return jsonb_build_object('ok', false, 'reason', 'rate', 'message', 'دخلت دروس كتير في وقت قليل، استنى شوية', 'session', v_info);
    end if;
    insert into public.mosque_live_participants (session_id, user_id, is_host)
    values (s.id, auth.uid(), v_host)
    on conflict (session_id, user_id) do update set last_join_at = now()
    returning * into v_p;
  else
    update public.mosque_live_participants set last_join_at = now(), is_host = v_host,
           removed_at = case when v_host then null else removed_at end
     where id = v_p.id returning * into v_p;
  end if;

  select (p.phone_verified_at is not null or public.is_super_admin() or not public.masjid_phone_required(s.mosque_id)),
         case when v_host then coalesce(nullif(btrim(p.full_name), ''), 'إدارة المسجد')
              else coalesce(n.nickname, nullif(btrim(p.full_name), ''), 'مستمع') end
    into v_verified, v_name
  from public.profiles p
  left join public.mosque_chat_nicknames n on n.mosque_id = s.mosque_id and n.user_id = p.id
  where p.id = auth.uid();

  v_role := case when v_host then 'host' when v_p.is_speaker and v_verified then 'speaker' else 'listener' end;
  return jsonb_build_object(
    'ok', true, 'role', v_role, 'identity', v_p.id::text, 'name', left(coalesce(v_name, 'مستمع'), 60),
    'room', s.room_name, 'can_speak', v_verified, 'hand_raised', v_p.hand_raised_at is not null,
    'phone_required', public.masjid_phone_required(s.mosque_id),
    'session', v_info);
end;
$$;

create or replace function public.masjid_live_hand(p_session uuid, p_raise boolean) returns boolean
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_p public.mosque_live_participants;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or s.status <> 'live' or public._masjid_live_stale(s) then
    raise exception 'الدرس مش شغال دلوقتي';
  end if;
  select * into v_p from public.mosque_live_participants where session_id = p_session and user_id = auth.uid() for update;
  if v_p.id is null or v_p.removed_at is not null then
    raise exception 'ادخل الدرس الأول';
  end if;
  if not coalesce(p_raise, false) then
    update public.mosque_live_participants set hand_raised_at = null where id = v_p.id;
    return false;
  end if;
  if public.masjid_phone_required(s.mosque_id) and not public.is_super_admin()
     and (select phone_verified_at from public.profiles where id = auth.uid()) is null then
    raise exception 'لازم توثّق رقم موبايلك عشان ترفع إيدك وتتكلم' using hint = 'phone_unverified';
  end if;
  if v_p.is_speaker then
    return true;
  end if;
  if v_p.hand_count >= 20 then
    raise exception 'رفعت إيدك كتير في الدرس ده';
  end if;
  update public.mosque_live_participants
     set hand_raised_at = coalesce(hand_raised_at, now()), hand_count = hand_count + 1
   where id = v_p.id;
  return true;
end;
$$;

create or replace function public.masjid_live_hands(p_session uuid)
returns table (participant_id uuid, name text, hand_raised_at timestamptz, is_speaker boolean, can_speak boolean)
language plpgsql stable security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_req boolean;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  v_req := public.masjid_phone_required(s.mosque_id);
  return query
  select x.id, coalesce(n.nickname, nullif(btrim(p.full_name), ''), 'مستمع'), x.hand_raised_at, x.is_speaker,
         p.phone_verified_at is not null or not v_req
  from public.mosque_live_participants x
  join public.profiles p on p.id = x.user_id
  left join public.mosque_chat_nicknames n on n.mosque_id = s.mosque_id and n.user_id = x.user_id
  where x.session_id = p_session and x.removed_at is null and not x.is_host
    and (x.hand_raised_at is not null or x.is_speaker)
  order by x.is_speaker desc, x.hand_raised_at
  limit 200;
end;
$$;

create or replace function public.masjid_live_set_speaker(p_session uuid, p_participant uuid, p_speaker boolean) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  s public.mosque_live_sessions;
  v_p public.mosque_live_participants;
begin
  select * into s from public.mosque_live_sessions where id = p_session;
  if s.id is null or not public.masjid_can(s.mosque_id, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  if s.status <> 'live' then
    raise exception 'الدرس مش شغال دلوقتي';
  end if;
  select * into v_p from public.mosque_live_participants where id = p_participant and session_id = p_session for update;
  if v_p.id is null or v_p.removed_at is not null then
    raise exception 'الشخص ده مش في الدرس';
  end if;
  if v_p.is_host then
    raise exception 'ده من إدارة المسجد بالفعل';
  end if;
  if coalesce(p_speaker, false) then
    if public.masjid_phone_required(s.mosque_id)
       and (select phone_verified_at from public.profiles where id = v_p.user_id) is null then
      raise exception 'الشخص ده لسه ماوثّقش رقم موبايله — مينفعش يتكلم';
    end if;
    if not v_p.is_speaker and (select count(*) from public.mosque_live_participants
                               where session_id = p_session and is_speaker and removed_at is null) >= 6 then
      raise exception 'فيه 6 متكلمين — رجّع حد منهم مستمع الأول';
    end if;
  end if;
  update public.mosque_live_participants set is_speaker = coalesce(p_speaker, false), hand_raised_at = null where id = v_p.id;
  return jsonb_build_object('room', s.room_name, 'identity', v_p.id::text, 'speaker', coalesce(p_speaker, false), 'mode', s.mode);
end;
$$;

-- 0085's create: the «new lesson» notification in the mosque's zone.
create or replace function public.masjid_live_create(p_mosque uuid, p jsonb) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  f record;
  v_id uuid;
  v_name text;
  v_tz text;
begin
  if not public.masjid_can(p_mosque, 'lessons') then
    raise exception 'غير مصرح';
  end if;
  select * into f from public._masjid_live_fields(coalesce(p, '{}'::jsonb), true);
  if (select count(*) from public.mosque_live_sessions
      where mosque_id = p_mosque and created_at > now() - interval '24 hours') >= 10 then
    raise exception 'ضفت دروس كتير النهارده، كمّل بكرة';
  end if;
  if (select count(*) from public.mosque_live_sessions
      where mosque_id = p_mosque and status in ('scheduled', 'live')) >= 20 then
    raise exception 'عندك 20 درس جاي — استنى لما يخلصوا أو الغي حاجة';
  end if;
  insert into public.mosque_live_sessions (mosque_id, title, sheikh, description, audience, scheduled_at, duration_minutes,
                                           mode, visibility, max_participants, room_name, created_by)
  values (p_mosque, f.title, f.sheikh, f.description, f.audience, f.scheduled_at, f.duration_minutes,
          f.mode, f.visibility, f.max_participants, 'mlive_' || replace(gen_random_uuid()::text, '-', ''), auth.uid())
  returning id into v_id;
  if f.scheduled_at > now() + interval '15 minutes' then
    select name, tz into v_name, v_tz from public.mosques where id = p_mosque;
    perform public._masjid_notify_followers(p_mosque, false, 'درس أونلاين جديد — ' || v_name,
      f.title || coalesce(' مع ' || f.sheikh, '') || ' — ' ||
      to_char(f.scheduled_at at time zone coalesce(v_tz, 'Africa/Cairo'), 'YYYY/MM/DD HH24:MI'));
  end if;
  return v_id;
end;
$$;

-- ==================================================== prayer reminders

alter table public.prayer_reminder_prefs drop constraint if exists prayer_reminder_prefs_in_egypt;
alter table public.prayer_reminder_prefs drop constraint if exists prayer_reminder_prefs_on_earth;
alter table public.prayer_reminder_prefs add constraint prayer_reminder_prefs_on_earth
  check (lat between -90 and 90 and lng between -180 and 180);
alter table public.prayer_reminder_prefs add column if not exists tz text not null default 'Africa/Cairo';
alter table public.prayer_reminder_prefs add column if not exists method text not null default 'egypt';
alter table public.prayer_reminder_prefs add column if not exists asr_factor smallint not null default 1;
alter table public.prayer_reminder_prefs add column if not exists high_lat text not null default 'angle';
alter table public.prayer_reminder_prefs drop constraint if exists prayer_reminder_prefs_method_ok;
alter table public.prayer_reminder_prefs add constraint prayer_reminder_prefs_method_ok check (
  method in ('egypt', 'umm_al_qura', 'uae', 'kuwait', 'qatar', 'gulf', 'mwl', 'isna', 'karachi', 'turkey',
             'singapore', 'jakim', 'kemenag', 'tehran')
  and asr_factor in (1, 2) and high_lat in ('angle', 'seventh', 'middle') and char_length(tz) between 1 and 64);

-- The app's methods (lib/core/masjid/prayer_times.dart → prayerMethods).
create or replace function private.mt_method(p text,
  out fajr double precision, out isha double precision, out isha_min int, out ramadan_isha_min int,
  out maghrib_angle double precision, out t_sunrise int, out t_dhuhr int, out t_asr int, out t_maghrib int)
language plpgsql immutable as $$
begin
  t_sunrise := 0; t_dhuhr := 0; t_asr := 0; t_maghrib := 0;
  case p
    when 'egypt' then fajr := 19.5; isha := 17.5; t_dhuhr := 1;
    when 'umm_al_qura' then fajr := 18.5; isha_min := 90; ramadan_isha_min := 120;
    when 'uae' then fajr := 18.2; isha := 18.2; t_dhuhr := 3; t_maghrib := 3;
    when 'kuwait' then fajr := 18; isha := 17.5;
    when 'qatar' then fajr := 18; isha_min := 90;
    when 'gulf' then fajr := 19.5; isha_min := 90;
    when 'isna' then fajr := 15; isha := 15;
    when 'karachi' then fajr := 18; isha := 18;
    when 'turkey' then fajr := 18; isha := 17; t_sunrise := -7; t_dhuhr := 5; t_asr := 4; t_maghrib := 7;
    when 'singapore' then fajr := 20; isha := 18;
    when 'jakim' then fajr := 20; isha := 18;
    when 'kemenag' then fajr := 20; isha := 18;
    when 'tehran' then fajr := 17.7; isha := 14; maghrib_angle := 4.5;
    else fajr := 18; isha := 17; -- mwl
  end case;
end;
$$;

-- Ramadan (Umm al-Qura) — Isha +120 min for that method.
create or replace function private.mt_is_ramadan(p_day date) returns boolean
language sql immutable as $$
  select exists (select 1 from (values
    ('2024-03-11'::date, '2024-04-10'::date), ('2025-03-01', '2025-03-30'), ('2026-02-18', '2026-03-20'),
    ('2027-02-08', '2027-03-09'), ('2028-01-28', '2028-02-26'), ('2029-01-16', '2029-02-14'),
    ('2030-01-05', '2030-02-04'), ('2030-12-26', '2031-01-24'), ('2031-12-15', '2032-01-14'),
    ('2032-12-04', '2033-01-02'), ('2033-11-23', '2033-12-23'), ('2034-11-12', '2034-12-12'),
    ('2035-11-01', '2035-12-01'), ('2036-10-20', '2036-11-19'), ('2037-10-10', '2037-11-08'),
    ('2038-09-30', '2038-10-29'), ('2039-09-19', '2039-10-19'), ('2040-09-07', '2040-10-07')
  ) r(s, e) where p_day >= r.s and p_day < r.e)
$$;

-- Like mt_angle_time, but NaN when the sun never reaches the angle.
create or replace function private.mt_angle_time_n(jdate double precision, lat double precision, angle double precision, t double precision, ccw boolean)
returns double precision
language plpgsql immutable as $$
declare
  decl double precision := (private.mt_sun(jdate + t)).decl;
  noon double precision := private.mt_midday(jdate, t);
  cos_t double precision := (-sind(angle) - sind(decl) * sind(lat)) / (cosd(decl) * cosd(lat));
  tt double precision;
begin
  if cos_t < -1 or cos_t > 1 then
    return 'NaN'::double precision;
  end if;
  tt := acosd(cos_t) / 15;
  return case when ccw then noon - tt else noon + tt end;
end;
$$;

create or replace function private.mt_asr_f(jdate double precision, lat double precision, t double precision, factor int)
returns double precision
language plpgsql immutable as $$
declare
  decl double precision := (private.mt_sun(jdate + t)).decl;
begin
  return private.mt_angle_time(jdate, lat, -atand(1 / (factor + tand(abs(lat - decl)))), t, false);
end;
$$;

create or replace function private.mt_nn(x double precision, d double precision) returns double precision
language sql immutable as $$ select case when x = 'NaN'::double precision then d else x end $$;

-- Prayer times for a LOCAL calendar day at lat/lng with a method, Asr
-- factor (1/2) and high-latitude rule ('angle' | 'seventh' | 'middle'):
-- the same algorithm and rounding as PrayerCalculator.compute (Dart).
create or replace function private.mt_prayer_times(p_day date, p_lat double precision, p_lng double precision,
  p_method text default 'egypt', p_asr int default 1, p_high_lat text default 'angle')
returns table (prayer text, prayer_at timestamptz)
language plpgsql immutable as $$
declare
  mp record;
  y int := extract(year from p_day);
  m int := extract(month from p_day);
  dd int := extract(day from p_day);
  a int;
  b int;
  jdate double precision;
  g double precision[] := array[5, 6, 12, 13, 18, 18];
  t double precision[] := array[5, 6, 12, 13, 18, 18];
  p double precision[];
  names text[] := array['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];
  tune int[];
  v_sunset double precision;
  v_night double precision;
  v_frac double precision := case p_high_lat when 'seventh' then 1.0 / 7 when 'middle' then 0.5 end;
  v_cap double precision;
  v double precision;
  base timestamptz := p_day::timestamp at time zone 'UTC';
begin
  select * into mp from private.mt_method(coalesce(p_method, 'mwl'));
  tune := array[0, mp.t_sunrise, mp.t_dhuhr, mp.t_asr, mp.t_maghrib, 0];
  if m <= 2 then
    y := y - 1;
    m := m + 12;
  end if;
  a := floor(y / 100.0);
  b := 2 - a + floor(a / 4.0);
  jdate := floor(365.25 * (y + 4716)) + floor(30.6001 * (m + 1)) + dd + b - 1524.5 - p_lng / (15 * 24);
  for i in 1..2 loop
    p := array[private.mt_nn(t[1], g[1]) / 24, private.mt_nn(t[2], g[2]) / 24, private.mt_nn(t[3], g[3]) / 24,
               private.mt_nn(t[4], g[4]) / 24, private.mt_nn(t[5], g[5]) / 24, private.mt_nn(t[6], g[6]) / 24];
    t := array[
      private.mt_angle_time_n(jdate, p_lat, mp.fajr, p[1], true),
      private.mt_angle_time(jdate, p_lat, 0.833, p[2], true),
      private.mt_midday(jdate, p[3]),
      private.mt_asr_f(jdate, p_lat, p[4], case when p_asr = 2 then 2 else 1 end),
      case when mp.maghrib_angle is null then private.mt_angle_time(jdate, p_lat, 0.833, p[5], false)
           else private.mt_angle_time_n(jdate, p_lat, mp.maghrib_angle, p[5], false) end,
      case when mp.isha is null then 'NaN'::double precision
           else private.mt_angle_time_n(jdate, p_lat, mp.isha, p[6], false) end
    ];
  end loop;

  -- High latitudes: cap Fajr / Isha (/ an angle Maghrib) at a portion of the night.
  v_sunset := private.mt_angle_time(jdate, p_lat, 0.833, private.mt_nn(t[5], 18) / 24, false);
  v_night := private.mt_fix(t[2] - v_sunset, 24);
  v_cap := v_night * coalesce(v_frac, mp.fajr / 60);
  if t[1] = 'NaN'::double precision or private.mt_fix(t[2] - t[1], 24) > v_cap then
    t[1] := t[2] - v_cap;
  end if;
  if mp.isha is not null then
    v_cap := v_night * coalesce(v_frac, mp.isha / 60);
    if t[6] = 'NaN'::double precision or private.mt_fix(t[6] - v_sunset, 24) > v_cap then
      t[6] := v_sunset + v_cap;
    end if;
  end if;
  if mp.maghrib_angle is not null then
    v_cap := v_night * coalesce(v_frac, mp.maghrib_angle / 60);
    if t[5] = 'NaN'::double precision or private.mt_fix(t[5] - v_sunset, 24) > v_cap then
      t[5] := v_sunset + v_cap;
    end if;
  end if;
  if mp.isha is null then
    t[6] := t[5] + (case when mp.ramadan_isha_min is not null and private.mt_is_ramadan(p_day) then mp.ramadan_isha_min
                         else coalesce(mp.isha_min, 90) end) / 60.0;
  end if;

  for k in 1..6 loop
    v := private.mt_nn(t[k], g[k]) - p_lng / 15 + tune[k] / 60.0;
    prayer := names[k];
    prayer_at := base + make_interval(mins => round((v * 60)::numeric)::int);
    return next;
  end loop;
end;
$$;

-- 0082's Egyptian calculator, now through the general one (same results).
create or replace function private.egypt_prayer_times(p_day date, p_lat double precision, p_lng double precision)
returns table (prayer text, prayer_at timestamptz)
language sql immutable as $$
  select * from private.mt_prayer_times(p_day, p_lat, p_lng, 'egypt', 1, 'angle')
$$;

-- "4:08 ص" for an instant, on [p_tz]'s clock.
create or replace function private.mt_time12(p_at timestamptz, p_tz text) returns text
language sql stable as $$
  select (case when extract(hour from w)::int % 12 = 0 then 12 else extract(hour from w)::int % 12 end)::text
         || ':' || lpad(extract(minute from w)::int::text, 2, '0')
         || case when extract(hour from w) < 12 then ' ص' else ' م' end
  from (select p_at at time zone coalesce(p_tz, 'Africa/Cairo') as w) x
$$;

-- Queues today's and tomorrow's reminders (each user's local dates).
create or replace function private.prayer_reminders_fill(p_user uuid default null, p_now timestamptz default now())
returns int
language plpgsql security definer set search_path = public as $$
declare
  r record;
  t record;
  v_today date;
  v_day date;
  v_n int := 0;
begin
  for r in
    select pr.* from public.prayer_reminder_prefs pr
    where (p_user is null or pr.user_id = p_user)
      and pr.offsets <> '{}'::jsonb
      and exists (select 1 from public.push_subscriptions s where s.user_id = pr.user_id)
      and (p_user is not null or not exists (
        select 1 from public.prayer_reminder_queue q
        where q.user_id = pr.user_id and q.day = (p_now at time zone pr.tz)::date + 1))
  loop
    v_today := (p_now at time zone r.tz)::date;
    for g in 0..1 loop
      v_day := v_today + g;
      for t in select * from private.mt_prayer_times(v_day, r.lat, r.lng, r.method, r.asr_factor, r.high_lat) e
               where r.offsets ? e.prayer loop
        insert into public.prayer_reminder_queue (user_id, day, prayer, adhan_at, due_at, minutes_before)
        values (r.user_id, v_day, t.prayer, t.prayer_at, t.prayer_at - make_interval(mins => (r.offsets ->> t.prayer)::int), (r.offsets ->> t.prayer)::int)
        on conflict (user_id, day, prayer) do update
          set adhan_at = excluded.adhan_at, due_at = excluded.due_at, minutes_before = excluded.minutes_before
          where public.prayer_reminder_queue.sent_at is null;
        v_n := v_n + 1;
      end loop;
    end loop;
  end loop;
  return v_n;
end;
$$;

create or replace function private.prayer_reminders_tick(p_now timestamptz default now())
returns int
language plpgsql security definer set search_path = public as $$
declare
  q record;
  v_n int := 0;
begin
  perform private.prayer_reminders_fill(null, p_now);

  for q in
    select * from public.prayer_reminder_queue
    where sent_at is null and due_at <= p_now
    order by due_at
    limit 5000
    for update skip locked
  loop
    update public.prayer_reminder_queue set sent_at = p_now
     where user_id = q.user_id and day = q.day and prayer = q.prayer;
    if q.due_at > p_now - interval '10 minutes'
       and exists (select 1 from public.push_subscriptions s where s.user_id = q.user_id) then
      insert into public.notifications (user_id, title, body, deep_link)
      values (
        q.user_id,
        case when q.minutes_before = 0 then 'حان الآن موعد أذان ' || private.prayer_name_ar(q.prayer)
             else private.prayer_name_ar(q.prayer) || ' بعد ' || q.minutes_before || case when q.minutes_before <= 10 then ' دقايق' else ' دقيقة' end end,
        'أذان ' || private.prayer_name_ar(q.prayer) || ' ' ||
          private.mt_time12(q.adhan_at, (select pr.tz from public.prayer_reminder_prefs pr where pr.user_id = q.user_id)),
        '/masjid/tools/reminders'
      );
      v_n := v_n + 1;
    end if;
  end loop;

  delete from public.prayer_reminder_queue where day < (p_now at time zone 'UTC')::date - 2;
  delete from public.notifications where deep_link = '/masjid/tools/reminders' and created_at < p_now - interval '12 hours';
  return v_n;
end;
$$;

drop function if exists public.set_prayer_reminders(double precision, double precision, jsonb, text);
create or replace function public.set_prayer_reminders(
  p_lat double precision, p_lng double precision, p_offsets jsonb, p_label text default null,
  p_tz text default null, p_method text default null, p_asr int default 1, p_high_lat text default 'angle'
) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_clean jsonb;
  v_keys int;
  v_egypt boolean := private.in_egypt(p_lat, p_lng);
  v_tz text := nullif(btrim(coalesce(p_tz, '')), '');
  v_method text := coalesce(nullif(btrim(coalesce(p_method, '')), ''), case when private.in_egypt(p_lat, p_lng) then 'egypt' else 'mwl' end);
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_lat is null or p_lng is null or p_lat not between -90 and 90 or p_lng not between -180 and 180 then
    raise exception 'حدد مكان صحيح لتنبيه الصلاة';
  end if;
  if v_tz is null then
    v_tz := case when v_egypt then 'Africa/Cairo' else private.tz_from_lng(p_lng) end;
  end if;
  if not private.valid_tz(v_tz) then
    raise exception 'المنطقة الزمنية مش معروفة';
  end if;
  if v_method not in ('egypt', 'umm_al_qura', 'uae', 'kuwait', 'qatar', 'gulf', 'mwl', 'isna', 'karachi', 'turkey',
                      'singapore', 'jakim', 'kemenag', 'tehran')
     or coalesce(p_asr, 1) not in (1, 2) or coalesce(p_high_lat, 'angle') not in ('angle', 'seventh', 'middle') then
    raise exception 'طريقة الحساب غير صحيحة';
  end if;
  if p_offsets is null or jsonb_typeof(p_offsets) <> 'object' then
    raise exception 'إعدادات التنبيه غير صحيحة';
  end if;
  select count(*) into v_keys from jsonb_object_keys(p_offsets);
  select coalesce(jsonb_object_agg(key, value::int), '{}'::jsonb) into v_clean
    from jsonb_each_text(p_offsets)
   where key in ('fajr', 'dhuhr', 'asr', 'maghrib', 'isha') and value in ('0', '5', '10', '15');
  if (select count(*) from jsonb_object_keys(v_clean)) <> v_keys then
    raise exception 'إعدادات التنبيه غير صحيحة';
  end if;

  delete from public.prayer_reminder_queue where user_id = auth.uid() and sent_at is null;
  if v_clean = '{}'::jsonb then
    delete from public.prayer_reminder_prefs where user_id = auth.uid();
    return;
  end if;
  insert into public.prayer_reminder_prefs (user_id, lat, lng, offsets, label, updated_at, tz, method, asr_factor, high_lat)
  values (auth.uid(), p_lat, p_lng, v_clean, left(nullif(trim(p_label), ''), 80), now(), v_tz, v_method,
          coalesce(p_asr, 1), coalesce(p_high_lat, 'angle'))
  on conflict (user_id) do update
    set lat = excluded.lat, lng = excluded.lng, offsets = excluded.offsets, label = excluded.label, updated_at = now(),
        tz = excluded.tz, method = excluded.method, asr_factor = excluded.asr_factor, high_lat = excluded.high_lat;
  perform private.prayer_reminders_fill(auth.uid());
end;
$$;

drop function if exists public.my_prayer_reminders();
create function public.my_prayer_reminders()
returns table (lat double precision, lng double precision, offsets jsonb, label text, updated_at timestamptz,
               tz text, method text, asr_factor smallint, high_lat text)
language sql stable security definer set search_path = public as $$
  select lat, lng, offsets, label, updated_at, tz, method, asr_factor, high_lat
  from public.prayer_reminder_prefs where user_id = auth.uid()
$$;

-- ---------------------------------------------------------------- grants
do $$
declare f text;
begin
  foreach f in array array[
    'private.in_egypt(double precision, double precision)', 'private.valid_tz(text)', 'private.tz_from_lng(double precision)',
    'private.country_currency(text)', 'private.currency_label(text)', 'private.mosque_name_key(text)',
    'private.mt_method(text)', 'private.mt_is_ramadan(date)',
    'private.mt_angle_time_n(double precision, double precision, double precision, double precision, boolean)',
    'private.mt_asr_f(double precision, double precision, double precision, int)',
    'private.mt_nn(double precision, double precision)',
    'private.mt_prayer_times(date, double precision, double precision, text, int, text)',
    'private.egypt_prayer_times(date, double precision, double precision)', 'private.mt_time12(timestamptz, text)',
    'private.prayer_reminders_fill(uuid, timestamptz)', 'private.prayer_reminders_tick(timestamptz)',
    'public._masjid_money(numeric, uuid)', 'public._masjid_norm_phone(text)'
  ] loop
    execute format('revoke execute on function %s from public, anon, authenticated', f);
  end loop;
  foreach f in array array[
    'public.set_prayer_reminders(double precision, double precision, jsonb, text, text, text, int, text)',
    'public.my_prayer_reminders()', 'public.masjid_phone_required(uuid)',
    'public.masjid_my_chat_profile(uuid)', 'public.masjid_chat_send(uuid, text, uuid)',
    'public.masjid_live_join_check(uuid)', 'public.masjid_live_hand(uuid, boolean)', 'public.masjid_live_hands(uuid)',
    'public.masjid_live_set_speaker(uuid, uuid, boolean)', 'public.masjid_live_create(uuid, jsonb)'
  ] loop
    execute format('revoke execute on function %s from public, anon', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end;
$$;
