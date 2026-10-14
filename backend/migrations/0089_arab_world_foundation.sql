-- =====================================================================
-- Migration 0089 — the Arab world, phase 0 + 1: geo foundation and phone
-- numbers everywhere.
--
-- The platform must work in all 22 Arab League states (EG SA AE KW QA BH
-- OM YE JO PS LB SY IQ SD LY TN DZ MA MR SO DJ KM) the way it works in
-- Egypt. This migration:
--
--   * private.arab_phone_plan(): dial code + national mobile pattern of
--     the 22 states (the app's lib/core/geo/arab_countries.dart).
--   * private.norm_phone(raw, country) → E.164 or null: local input in
--     the given country (trunk 0 optional), +/00 international input,
--     a country code without "+", spaces/dashes, Arabic-Indic digits.
--     Numbers of the 22 states must be mobiles of that state; other
--     countries' numbers are accepted when they look like E.164.
--     phone_store / phone_country / is_mobile / wa_digits / phone_ok /
--     has_phone_number build on it.
--
--   STORAGE DECISION: Egyptian mobiles keep their historic local form
--   «01xxxxxxxxx» (every existing row, the profiles.phone unique index,
--   confirm_phone_verified, lookups and the verify-phone Edge Function
--   use it — nothing existing is rewritten); every other number is stored
--   in E.164 («+9665xxxxxxxx»). private.phone_store() gives that form.
--   This is exactly 0087's mosque convention, now platform-wide.
--
--   * profiles.country (ISO2, existing rows 'EG'), profiles.tz, and
--     profiles.currency (derived from the country by a trigger). Set at sign-up from
--     the metadata (country / tz the app sends), else the phone's dial
--     code, else the zone, else EG; set_my_country() changes it.
--     profiles.phone is normalised to the stored form on write.
--   * Every Egypt-only phone check accepts any of the 22 states' mobiles
--     (constraints: shops, tutors, halls, pets, kids, scrap dealers;
--     RPCs: wallet & union-fund payout, store checkout (both), shop
--     sign-up, e-address lookup, admin address search, mosque helpers).
--   * Verified phone (SMS, Egypt only) is required in chat rooms only for
--     Egyptian users — private.phone_required_for(uid): an Egyptian
--     number, or no foreign number and profiles.country = 'EG'. Mosques
--     keep 0087's rule (by mosque country). Rooms reports count reporters
--     who are verified or (outside Egypt) whose account is 3+ days old.
--     The e-address mobile lookup matches non-Egyptian numbers without
--     verification (they can't be verified yet — see the report).
--   * Chat phone-number filter (rooms + mosque chat) detects the 22
--     states' local and international numbers: private.has_phone_number.
--   * private.money_text(amount, currency) for phase 2.
--
-- Run after 0088. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

-- ============================================================ geography

-- (iso, dial, mobile national significant number regex)
create or replace function private.arab_phone_plan()
returns table (iso text, dial text, mobile text)
language sql immutable as $$
  values
    ('EG', '20',  '1[0125][0-9]{8}'),
    ('SA', '966', '5[0-9]{8}'),
    ('AE', '971', '5[0-9][0-9]{7}'),
    ('KW', '965', '[4569][0-9]{7}'),
    ('QA', '974', '[3567][0-9]{7}'),
    ('BH', '973', '[36][0-9]{7}'),
    ('OM', '968', '[79][0-9]{7}'),
    ('YE', '967', '7[0-9]{8}'),
    ('JO', '962', '7[789][0-9]{7}'),
    ('PS', '970', '5[69][0-9]{7}'),
    ('LB', '961', '3[0-9]{6}|7[0-9][0-9]{6}|8[01][0-9]{6}'),
    ('SY', '963', '9[0-9]{8}'),
    ('IQ', '964', '7[3-9][0-9]{8}'),
    ('SD', '249', '[19][0-9]{8}'),
    ('LY', '218', '9[1-6][0-9]{7}'),
    ('TN', '216', '[2459][0-9]{7}'),
    ('DZ', '213', '[567][0-9]{8}'),
    ('MA', '212', '[67][0-9]{8}'),
    ('MR', '222', '[234][0-9]{7}'),
    ('SO', '252', '[679][0-9]{7,8}'),
    ('DJ', '253', '77[0-9]{6}'),
    ('KM', '269', '[34][0-9]{6}')
$$;

create or replace function private.is_arab_country(p text) returns boolean
language sql immutable as $$
  select exists (select 1 from private.arab_phone_plan() a where a.iso = upper(coalesce(p, '')))
$$;

-- 0087's table + the three it lacked (SO, DJ, KM).
create or replace function private.country_currency(p text) returns text
language sql immutable as $$
  select case upper(coalesce(p, ''))
    when 'EG' then 'EGP' when 'SA' then 'SAR' when 'AE' then 'AED' when 'KW' then 'KWD' when 'QA' then 'QAR'
    when 'BH' then 'BHD' when 'OM' then 'OMR' when 'JO' then 'JOD' when 'IQ' then 'IQD' when 'LB' then 'LBP'
    when 'SY' then 'SYP' when 'YE' then 'YER' when 'PS' then 'ILS' when 'IL' then 'ILS' when 'LY' then 'LYD'
    when 'TN' then 'TND' when 'DZ' then 'DZD' when 'MA' then 'MAD' when 'SD' then 'SDG' when 'MR' then 'MRU'
    when 'SO' then 'SOS' when 'DJ' then 'DJF' when 'KM' then 'KMF'
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

-- Same as 0087 + ₪ and the three new ones (same as the app's currencyLabel).
create or replace function private.currency_label(p text) returns text
language sql immutable as $$
  select case upper(coalesce(p, 'EGP'))
    when 'EGP' then 'ج.م' when 'AED' then 'د.إ' when 'SAR' then 'ر.س' when 'KWD' then 'د.ك' when 'QAR' then 'ر.ق'
    when 'BHD' then 'د.ب' when 'OMR' then 'ر.ع' when 'JOD' then 'د.أ' when 'IQD' then 'د.ع' when 'LBP' then 'ل.ل'
    when 'SYP' then 'ل.س' when 'YER' then 'ر.ي' when 'LYD' then 'د.ل' when 'TND' then 'د.ت' when 'DZD' then 'د.ج'
    when 'MAD' then 'د.م' when 'SDG' then 'ج.س' when 'USD' then '$' when 'EUR' then '€' when 'GBP' then '£'
    when 'TRY' then '₺' when 'ILS' then '₪' when 'MRU' then 'أ.م' when 'SOS' then 'ش.ص' when 'DJF' then 'ف.ج'
    when 'KMF' then 'ف.ق' else upper(p) end
$$;

-- «150 ج.م», «1,250.5 د.إ», «3.125 د.ك» (3 decimals for KWD/BHD/OMR/JOD/
-- IQD/LYD/TND, trailing zeros dropped) — the app's money().
create or replace function private.money_text(p_amount numeric, p_currency text default 'EGP') returns text
language plpgsql immutable as $$
declare
  v_code text := upper(coalesce(nullif(p_currency, ''), 'EGP'));
  v_places int := case when v_code in ('KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'LYD', 'TND') then 3 else 2 end;
  v_txt text;
  v_whole text;
  v_frac text;
begin
  if p_amount is null then
    return null;
  end if;
  v_txt := round(abs(p_amount), v_places)::text;
  if position('.' in v_txt) > 0 then
    v_txt := regexp_replace(regexp_replace(v_txt, '0+$', ''), '\.$', '');
  end if;
  v_whole := split_part(v_txt, '.', 1);
  v_frac := split_part(v_txt, '.', 2);
  v_whole := reverse(regexp_replace(reverse(v_whole), '([0-9]{3})(?=[0-9])', '\1,', 'g'));
  return case when p_amount < 0 then '-' else '' end || v_whole
         || case when v_frac <> '' then '.' || v_frac else '' end || ' ' || private.currency_label(v_code);
end;
$$;

-- Country of a time zone of the 22 states (null otherwise).
create or replace function private.tz_country(p_tz text) returns text
language sql immutable as $$
  select case p_tz
    when 'Africa/Cairo' then 'EG' when 'Asia/Riyadh' then 'SA' when 'Asia/Dubai' then 'AE' when 'Asia/Kuwait' then 'KW'
    when 'Asia/Qatar' then 'QA' when 'Asia/Bahrain' then 'BH' when 'Asia/Muscat' then 'OM' when 'Asia/Aden' then 'YE'
    when 'Asia/Amman' then 'JO' when 'Asia/Gaza' then 'PS' when 'Asia/Hebron' then 'PS' when 'Asia/Beirut' then 'LB'
    when 'Asia/Damascus' then 'SY' when 'Asia/Baghdad' then 'IQ' when 'Africa/Khartoum' then 'SD'
    when 'Africa/Tripoli' then 'LY' when 'Africa/Tunis' then 'TN' when 'Africa/Algiers' then 'DZ'
    when 'Africa/Casablanca' then 'MA' when 'Africa/El_Aaiun' then 'MA' when 'Africa/Nouakchott' then 'MR'
    when 'Africa/Mogadishu' then 'SO' when 'Africa/Djibouti' then 'DJ' when 'Indian/Comoro' then 'KM'
  end
$$;

-- ============================================================== phones
-- None of these are revoked from PUBLIC on purpose: check constraints call
-- them as the writing user (the private schema itself stays unusable).

-- Arabic-Indic digits → ASCII; spaces / dashes / dots / brackets / slashes
-- and direction marks dropped. Letters are kept (so the result is invalid).
create or replace function private.phone_clean(p text) returns text
language sql immutable as $$
  select regexp_replace(
    translate(btrim(coalesce(p, '')), '٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹', '01234567890123456789'),
    '[\s\-\.()/ ‎‏‪‬]', '', 'g')
$$;

-- Digits after a country code → E.164 (an Arab code needs a valid mobile).
create or replace function private._phone_from_intl(p_digits text, p_arab_only boolean) returns text
language plpgsql immutable as $$
declare
  r record;
  n text;
begin
  for r in select * from private.arab_phone_plan() a order by length(a.dial) desc loop
    if p_digits like r.dial || '%' then
      n := regexp_replace(substr(p_digits, length(r.dial) + 1), '^0', '');
      if n ~ ('^(' || r.mobile || ')$') then
        return '+' || r.dial || n;
      end if;
      return null;
    end if;
  end loop;
  if not p_arab_only and p_digits ~ '^[1-9][0-9]{7,14}$' then
    return '+' || p_digits;
  end if;
  return null;
end;
$$;

-- E.164 mobile or null. p_country (ISO2) reads local input; default Egypt.
create or replace function private.norm_phone(p text, p_country text default null) returns text
language plpgsql immutable as $$
declare
  v text := private.phone_clean(p);
  n text;
  r record;
begin
  if v = '' then
    return null;
  end if;
  if v ~ '^\+[0-9]+$' then
    return private._phone_from_intl(substr(v, 2), false);
  end if;
  if v !~ '^[0-9]+$' then
    return null;
  end if;
  if v like '00%' then
    return private._phone_from_intl(substr(v, 3), false);
  end if;
  select * into r from private.arab_phone_plan() a where a.iso = upper(coalesce(nullif(p_country, ''), 'EG'));
  if r.iso is null then
    select * into r from private.arab_phone_plan() a where a.iso = 'EG';
  end if;
  n := regexp_replace(v, '^0', '');
  if n ~ ('^(' || r.mobile || ')$') then
    return '+' || r.dial || n;
  end if;
  -- A country code typed without "+" (2010…, 9665…).
  return private._phone_from_intl(v, true);
end;
$$;

-- The stored form: 01xxxxxxxxx for Egypt, E.164 for everyone else.
create or replace function private.phone_store(p text, p_country text default null) returns text
language sql immutable as $$
  select case when e like '+20%' then '0' || substr(e, 4) else e end
  from (select private.norm_phone(p, p_country) as e) x
$$;

-- ISO country (one of the 22) of a stored / E.164 number, else null.
create or replace function private.phone_country(p text) returns text
language sql immutable as $$
  select (select a.iso from private.arab_phone_plan() a
           where substr(e, 2) like a.dial || '%' order by length(a.dial) desc limit 1)
  from (select private.norm_phone(p, 'EG') as e) x
  where e is not null
$$;

create or replace function private.is_mobile(p text) returns boolean
language sql immutable as $$
  select private.norm_phone(p, 'EG') is not null
$$;

-- Digits for wa.me: 01… → 201…, +971… → 971…; other text → its digits.
create or replace function private.wa_digits(p text) returns text
language sql immutable as $$
  select coalesce(substr(private.norm_phone(p, 'EG'), 2), nullif(regexp_replace(coalesce(p, ''), '[^0-9]', '', 'g'), ''))
$$;

-- Already in the stored form and valid (for check constraints).
-- Security definer: the body names private.* and a check constraint runs
-- it as the writing user (who has no usage on the private schema).
create or replace function private.phone_ok(p text) returns boolean
language sql immutable security definer set search_path = public as $$
  select p is not null and coalesce(private.phone_store(p, 'EG') = p, false)
$$;

-- Halls' contact phone also allowed an Egyptian landline (0…, 8–11 digits).
create or replace function private.phone_or_landline_ok(p text) returns boolean
language sql immutable security definer set search_path = public as $$
  select p is not null and (p ~ '^0[0-9]{7,10}$' or coalesce(private.phone_ok(p), false))
$$;

-- Is there a phone number in a chat message? Egyptian, +/00 international,
-- a 22-state code without "+", or a local trunk-0 mobile of 9–11 digits.
create or replace function private.has_phone_number(p text) returns boolean
language sql immutable as $$
  select f ~ '(\+?20|0)1[0125][0-9]{8}'
      or f ~ '(\+|00)[1-9][0-9]{7,14}'
      or f ~ '(^|[^0-9])(20|21[2368]|222|249|25[23]|269|96[1-8]|97[0134])[0-9]{7,10}([^0-9]|$)'
      or f ~ '(^|[^0-9])0[1-9][0-9]{7,9}([^0-9]|$)'
  from (select regexp_replace(translate(coalesce(p, ''), '٠١٢٣٤٥٦٧٨٩۰۱۲۳۴۵۶۷۸۹', '01234567890123456789'),
                              '[\s\-\.()]', '', 'g') as f) x
$$;

-- ============================================================ profiles

alter table public.profiles add column if not exists country text;
alter table public.profiles add column if not exists tz text;
update public.profiles set country = 'EG' where country is null;
alter table public.profiles alter column country set default 'EG';
alter table public.profiles alter column country set not null;
alter table public.profiles drop constraint if exists profiles_country_format;
alter table public.profiles add constraint profiles_country_format check (country ~ '^[A-Z]{2}$');
alter table public.profiles drop constraint if exists profiles_tz_len;
alter table public.profiles add constraint profiles_tz_len check (tz is null or char_length(tz) <= 64);
-- Derived from the country (kept by the trigger below; not a generated
-- column because private.country_currency isn't executable by users).
alter table public.profiles add column if not exists currency text;
update public.profiles set currency = private.country_currency(country)
 where currency is distinct from private.country_currency(country);
alter table public.profiles alter column currency set default 'EGP';
grant select (country, tz, currency) on public.profiles to authenticated;

-- Phones are kept in the stored form (01… / E.164) whenever they parse;
-- old free-text values that don't are left alone. currency follows country.
create or replace function public.profiles_phone_norm() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  v text;
begin
  new.currency := private.country_currency(new.country);
  if new.phone is not null then
    v := private.phone_store(new.phone, new.country);
    if v is not null then
      new.phone := v;
    end if;
  end if;
  return new;
end;
$$;
revoke execute on function public.profiles_phone_norm() from public, anon, authenticated;
drop trigger if exists profiles_phone_norm on public.profiles;
create trigger profiles_phone_norm before insert or update of phone, country on public.profiles
  for each row execute function public.profiles_phone_norm();

-- 0037's sign-up profile + wallet, now with the country (metadata
-- 'country' → the phone's dial code → metadata 'tz' → EG) and the zone.
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
  v_country text;
  v_tz text;
begin
  select coalesce(raw_user_meta_data, '{}'::jsonb) into v_meta from auth.users where id = p_user_id;
  if not found then
    return;
  end if;

  v_name := nullif(trim(coalesce(v_meta->>'full_name', v_meta->>'name', '')), '');
  v_phone := nullif(trim(coalesce(v_meta->>'phone', '')), '');
  v_avatar := coalesce(v_meta->>'avatar_url', v_meta->>'picture');
  v_tz := nullif(left(trim(coalesce(v_meta->>'tz', '')), 64), '');
  v_country := upper(nullif(trim(coalesce(v_meta->>'country', '')), ''));
  if not private.is_arab_country(v_country) then
    v_country := null;
  end if;
  if v_country is null and v_phone is not null and private.phone_clean(v_phone) ~ '^(\+|00)' then
    v_country := private.phone_country(v_phone);
  end if;
  v_country := coalesce(v_country, private.tz_country(v_tz), 'EG');
  if v_phone is not null then
    v_phone := coalesce(private.phone_store(v_phone, v_country), v_phone);
  end if;

  begin
    insert into public.profiles (id, full_name, phone, avatar_url, country, tz)
    values (p_user_id, coalesce(v_name, 'عضو مُجتمعي'), v_phone, v_avatar, v_country, v_tz)
    on conflict (id) do nothing;
  exception when unique_violation then
    -- profiles.phone is unique: if the sign-up phone is already taken,
    -- still create the account, just without the phone.
    insert into public.profiles (id, full_name, avatar_url, country, tz)
    values (p_user_id, coalesce(v_name, 'عضو مُجتمعي'), v_avatar, v_country, v_tz)
    on conflict (id) do nothing;
  end;

  insert into public.wallets (user_id) values (p_user_id)
  on conflict (user_id) do nothing;
end;
$$;
revoke execute on function public._create_profile_and_wallet(uuid) from public, anon, authenticated;

-- The user picks their country (profile settings). Optional zone.
create or replace function public.set_my_country(p_country text, p_tz text default null) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  v text := upper(btrim(coalesce(p_country, '')));
  p public.profiles;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  if not private.is_arab_country(v) then
    raise exception 'اختار دولة من القائمة';
  end if;
  if p_tz is not null and not private.valid_tz(p_tz) then
    raise exception 'المنطقة الزمنية مش معروفة';
  end if;
  update public.profiles set country = v, tz = coalesce(p_tz, tz), updated_at = now()
   where id = auth.uid() returning * into p;
  if p.id is null then
    raise exception 'الحساب مش موجود';
  end if;
  return jsonb_build_object('country', p.country, 'currency', p.currency, 'tz', p.tz);
end;
$$;
revoke execute on function public.set_my_country(text, text) from public, anon;
grant execute on function public.set_my_country(text, text) to authenticated;

-- Verified phone needed (chat rooms)? Only for Egyptian users: an
-- Egyptian number, or — without a foreign number — country EG.
create or replace function private.phone_required_for(p_uid uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((
    select case
             when private.phone_country(p.phone) = 'EG' then true
             when private.is_mobile(p.phone) then false
             else p.country = 'EG'
           end
      from public.profiles p where p.id = p_uid), true)
$$;
revoke execute on function private.phone_required_for(uuid) from public, anon, authenticated;

-- Called by the verify-phone Edge Function (service role); SMS is Egypt
-- only, so p_phone must be Egyptian — any input form (01…, +20…, 0020…).
create or replace function public.confirm_phone_verified(p_user uuid, p_phone text) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_phone text := private.phone_store(p_phone, 'EG');
begin
  if v_phone is null or v_phone !~ '^01[0125][0-9]{8}$' then
    raise exception 'رقم موبايل مش صحيح';
  end if;
  update public.profiles set phone = null, phone_verified_at = null
   where phone = v_phone and id <> p_user;
  update public.profiles set phone = v_phone, phone_verified_at = now(), updated_at = now()
   where id = p_user;
  if not found then
    raise exception 'الحساب مش موجود';
  end if;
end;
$$;
revoke execute on function public.confirm_phone_verified(uuid, text) from public, anon, authenticated;
grant execute on function public.confirm_phone_verified(uuid, text) to service_role;

-- The caller's country (EG for guests) — reads local phone input.
create or replace function private.my_country() returns text
language sql stable security definer set search_path = public as $$
  select coalesce((select country from public.profiles where id = auth.uid()), 'EG')
$$;
revoke execute on function private.my_country() from public, anon, authenticated;

-- ======================================================== constraints

alter table public.shops drop constraint if exists shops_whatsapp_format;
alter table public.shops add constraint shops_whatsapp_format
  check (whatsapp is null or private.phone_ok(whatsapp));

alter table public.tutor_listings drop constraint if exists tutor_listings_phone_check;
alter table public.tutor_listings drop constraint if exists tutor_listings_whatsapp_check;
alter table public.tutor_listings drop constraint if exists tutor_listings_phone_intl;
alter table public.tutor_listings drop constraint if exists tutor_listings_whatsapp_intl;
alter table public.tutor_listings add constraint tutor_listings_phone_intl check (phone is null or private.phone_ok(phone));
alter table public.tutor_listings add constraint tutor_listings_whatsapp_intl check (whatsapp is null or private.phone_ok(whatsapp));

alter table public.event_halls drop constraint if exists event_halls_phone_check;
alter table public.event_halls drop constraint if exists event_halls_whatsapp_check;
alter table public.event_halls drop constraint if exists event_halls_phone_intl;
alter table public.event_halls drop constraint if exists event_halls_whatsapp_intl;
alter table public.event_halls add constraint event_halls_phone_intl check (private.phone_or_landline_ok(phone));
alter table public.event_halls add constraint event_halls_whatsapp_intl check (whatsapp is null or private.phone_ok(whatsapp));

alter table public.pet_listings drop constraint if exists pet_listings_phone_check;
alter table public.pet_listings drop constraint if exists pet_listings_phone_intl;
alter table public.pet_listings add constraint pet_listings_phone_intl check (private.phone_ok(phone));

alter table public.kids_listings drop constraint if exists kids_listings_phone_check;
alter table public.kids_listings drop constraint if exists kids_listings_phone_intl;
alter table public.kids_listings add constraint kids_listings_phone_intl check (private.phone_ok(phone));

alter table public.scrap_dealers drop constraint if exists scrap_dealers_whatsapp_check;
alter table public.scrap_dealers drop constraint if exists scrap_dealers_whatsapp_intl;
alter table public.scrap_dealers add constraint scrap_dealers_whatsapp_intl check (private.phone_ok(whatsapp));

-- ================================================================ RPCs

-- 0045: the payout number may be any of the 22 states' mobiles.
create or replace function public.request_wallet_withdrawal(p_amount numeric, p_payout_phone text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_wallet record;
  v_phone text;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_amount is null or p_amount < 10 then
    raise exception 'أقل مبلغ للسحب 10 ج.م';
  end if;
  v_phone := private.phone_store(p_payout_phone, private.my_country());
  if v_phone is null then
    raise exception 'رقم المحفظة مش صحيح';
  end if;

  select * into v_wallet from public.wallets where user_id = auth.uid() for update;
  if not found or v_wallet.available_balance < p_amount then
    raise exception 'رصيدك المتاح غير كافٍ لهذا المبلغ';
  end if;

  insert into public.wallet_withdrawal_requests (user_id, amount_egp, payout_phone)
  values (auth.uid(), round(p_amount, 2), v_phone)
  returning id into v_id;

  update public.wallets set available_balance = available_balance - round(p_amount, 2), updated_at = now()
    where id = v_wallet.id;
  insert into public.wallet_transactions (wallet_id, type, status, amount, reference_table, reference_id)
    values (v_wallet.id, 'withdrawal', 'pending', -round(p_amount, 2), 'wallet_withdrawal_requests', v_id);

  return v_id;
end;
$$;
revoke execute on function public.request_wallet_withdrawal(numeric, text) from public, anon;
grant execute on function public.request_wallet_withdrawal(numeric, text) to authenticated;

-- 0047: shop sign-up with any of the 22 states' WhatsApp numbers.
create or replace function public.create_my_shop(
  p_name text,
  p_category text,
  p_slug text,
  p_whatsapp text,
  p_address text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_slug text := lower(trim(coalesce(p_slug, '')));
  v_phone text := private.phone_store(p_whatsapp, private.my_country());
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_name is null or length(trim(p_name)) < 2 then
    raise exception 'اكتب اسم المحل';
  end if;
  if v_slug !~ '^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$' then
    raise exception 'اسم الرابط لازم يكون بالإنجليزي (حروف وأرقام وشرطة) من 3 لـ 40 حرف';
  end if;
  if exists (select 1 from public.shops where slug = v_slug) then
    raise exception 'اسم الرابط ده مستخدم، جرّب اسم تاني';
  end if;
  if v_phone is null then
    raise exception 'رقم الواتساب مش صحيح';
  end if;
  if (select count(*) from public.shops where owner_id = auth.uid()) >= 3 then
    raise exception 'وصلت للحد الأقصى (3 محلات لكل حساب)';
  end if;

  insert into public.shops (owner_id, source, name, category, slug, whatsapp, address, is_claimed, claimed_at)
  values (auth.uid(), 'claimed', trim(p_name), p_category, v_slug, v_phone, nullif(trim(coalesce(p_address, '')), ''), true, now())
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.create_my_shop(text, text, text, text, text) from public, anon;
grant execute on function public.create_my_shop(text, text, text, text, text) to authenticated;

-- 0047's in-app order: any of the 22 states' mobiles.
create or replace function public.place_shop_order(
  p_shop_id uuid,
  p_items jsonb,
  p_customer_phone text,
  p_note text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop record;
  v_phone text := private.phone_store(p_customer_phone, private.my_country());
  v_order_id uuid;
  v_item jsonb;
  v_product record;
  v_qty int;
  v_total numeric(12,2) := 0;
  v_count int := 0;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول عشان تقدر تطلب';
  end if;
  select * into v_shop from public.shops where id = p_shop_id;
  if not found or v_shop.owner_id is null then
    raise exception 'المحل ده مش مستقبل طلبات حالياً';
  end if;
  if v_shop.owner_id = auth.uid() then
    raise exception 'مينفعش تطلب من محلك';
  end if;
  if v_phone is null then
    raise exception 'اكتب رقم موبايل صحيح عشان المحل يتواصل معاك';
  end if;
  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'السلة فاضية';
  end if;
  if jsonb_array_length(p_items) > 50 then
    raise exception 'الطلب فيه منتجات كتير، قسّمه على أكتر من طلب';
  end if;
  if (select count(*) from public.shop_orders where buyer_id = auth.uid() and created_at > now() - interval '1 hour') >= 10 then
    raise exception 'طلبات كتير في وقت قصير، جرّب بعد شوية';
  end if;

  insert into public.shop_orders (shop_id, buyer_id, status, total_amount, customer_phone, note)
  values (p_shop_id, auth.uid(), 'placed', 0, v_phone, nullif(left(trim(coalesce(p_note, '')), 500), ''))
  returning id into v_order_id;

  for v_item in select * from jsonb_array_elements(p_items) loop
    v_qty := coalesce((v_item->>'quantity')::int, 0);
    if v_qty < 1 or v_qty > 99 then
      raise exception 'الكمية غير صحيحة';
    end if;
    select * into v_product from public.shop_products
      where id = (v_item->>'product_id')::uuid and shop_id = p_shop_id and is_available;
    if not found then
      raise exception 'فيه منتج في السلة مبقاش متاح، حدّث الصفحة';
    end if;
    insert into public.shop_order_items (order_id, product_id, quantity, unit_price)
    values (v_order_id, v_product.id, v_qty, v_product.price);
    v_total := v_total + v_product.price * v_qty;
    v_count := v_count + v_qty;
  end loop;

  update public.shop_orders set total_amount = v_total where id = v_order_id;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد لمحل ' || v_shop.name,
          v_count || ' منتج بإجمالي ' || v_total || ' ج.م — موبايل العميل ' || v_phone || '. افتح لوحة التاجر لتفاصيل الطلب.');

  return v_order_id;
end;
$$;
revoke execute on function public.place_shop_order(uuid, jsonb, text, text) from public, anon;
grant execute on function public.place_shop_order(uuid, jsonb, text, text) to authenticated;

-- 0057's store checkout (guests too): any of the 22 states' mobiles. Local
-- input is read in the caller's country (EG for guests); the app sends
-- E.164 for other countries.
create or replace function public.place_store_order(
  p_shop_id uuid,
  p_items jsonb,
  p_customer_name text,
  p_customer_phone text,
  p_address text,
  p_note text default null
) returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_shop record;
  v_phone text := private.phone_store(p_customer_phone, private.my_country());
  v_name text := left(trim(coalesce(p_customer_name, '')), 80);
  v_address text := left(trim(coalesce(p_address, '')), 400);
  v_order_id uuid;
  v_code text;
  v_item jsonb;
  v_product record;
  v_qty int;
  v_opts text;
  v_total numeric(12,2) := 0;
  v_delivery numeric(10,2) := 0;
  v_count int := 0;
  v_bytes bytea;
  v_idx int;
begin
  select * into v_shop from public.shops where id = p_shop_id;
  if not found or v_shop.owner_id is null then
    raise exception 'المحل ده مش مستقبل طلبات حالياً';
  end if;
  if auth.uid() is not null and v_shop.owner_id = auth.uid() then
    raise exception 'مينفعش تطلب من محلك';
  end if;
  if length(v_name) < 2 then
    raise exception 'اكتب اسمك';
  end if;
  if v_phone is null then
    raise exception 'رقم موبايل مش صحيح';
  end if;
  if length(v_address) < 8 then
    raise exception 'اكتب العنوان بالتفصيل عشان الطلب يوصلك';
  end if;
  if p_items is null or jsonb_typeof(p_items) <> 'array' or jsonb_array_length(p_items) = 0 then
    raise exception 'السلة فاضية';
  end if;
  if jsonb_array_length(p_items) > 50 then
    raise exception 'الطلب فيه منتجات كتير، قسّمه على أكتر من طلب';
  end if;
  if (select count(*) from public.shop_orders where customer_phone = v_phone and shop_id = p_shop_id and created_at > now() - interval '1 hour') >= 5
     or (select count(*) from public.shop_orders where customer_phone = v_phone and created_at > now() - interval '1 day') >= 20 then
    raise exception 'طلبات كتير من الرقم ده في وقت قصير، جرّب بعد شوية';
  end if;

  loop
    v_bytes := uuid_send(gen_random_uuid());
    v_code := 'T';
    foreach v_idx in array array[0, 1, 2, 3, 4, 5, 10] loop
      v_code := v_code || substr('23456789ABCDEFGHJKLMNPQRSTUVWXYZ', (get_byte(v_bytes, v_idx) % 32) + 1, 1);
    end loop;
    exit when not exists (select 1 from public.shop_orders where order_code = v_code);
  end loop;

  insert into public.shop_orders (shop_id, buyer_id, status, total_amount, customer_name, customer_phone, delivery_address, note, order_code)
  values (p_shop_id, auth.uid(), 'placed', 0, v_name, v_phone, v_address, nullif(left(trim(coalesce(p_note, '')), 500), ''), v_code)
  returning id into v_order_id;

  for v_item in select * from jsonb_array_elements(p_items) loop
    v_qty := coalesce((v_item->>'quantity')::int, 0);
    if v_qty < 1 or v_qty > 99 then
      raise exception 'الكمية غير صحيحة';
    end if;
    select * into v_product from public.shop_products
      where id = (v_item->>'product_id')::uuid and shop_id = p_shop_id and is_available
      for update;
    if not found then
      raise exception 'فيه منتج في السلة مبقاش متاح، حدّث الصفحة';
    end if;
    if v_product.stock is not null then
      if v_product.stock < v_qty then
        raise exception 'الكمية المتاحة من «%» هي % بس', v_product.name, v_product.stock;
      end if;
      update public.shop_products set stock = stock - v_qty where id = v_product.id;
    end if;
    v_opts := nullif(left(trim(coalesce(v_item->>'options', '')), 120), '');
    insert into public.shop_order_items (order_id, product_id, quantity, unit_price, chosen_options)
    values (v_order_id, v_product.id, v_qty, v_product.price, v_opts);
    v_total := v_total + v_product.price * v_qty;
    v_count := v_count + v_qty;
  end loop;

  v_delivery := coalesce(v_shop.delivery_fee, 0);
  if v_shop.free_delivery_over is not null and v_total >= v_shop.free_delivery_over then
    v_delivery := 0;
  end if;
  update public.shop_orders set delivery_fee = v_delivery, total_amount = v_total + v_delivery where id = v_order_id;

  insert into public.notifications (user_id, title, body)
  values (v_shop.owner_id, '🛒 طلب جديد ' || v_code || ' — ' || v_shop.name,
          v_name || ' طلب ' || v_count || ' منتج بإجمالي ' || (v_total + v_delivery) || ' ج.م (شامل التوصيل). افتح «الطلبات» في متجري.');

  return v_code;
end;
$$;
revoke execute on function public.place_store_order(uuid, jsonb, text, text, text, text) from public;
grant execute on function public.place_store_order(uuid, jsonb, text, text, text, text) to anon, authenticated;

-- 0074's address opening: a mobile number of any of the 22 states.
-- Egyptian numbers still need the owner's SMS verification; others can't
-- be verified yet, so the owner's opt-in (phone_lookup) is enough.
create or replace function public.get_e_address(p_code text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_raw text := trim(coalesce(p_code, ''));
  v_code text := upper(regexp_replace(v_raw, '[^A-Za-z0-9]', '', 'g'));
  v_phone text;
  v_id uuid;
  r public.e_addresses;
  v_name text;
  v_owner_phone text;
begin
  -- 1) Mobile number (local in the caller's country, or international).
  if private.phone_clean(v_raw) ~ '^\+?[0-9]+$' then
    v_phone := private.phone_store(v_raw, private.my_country());
    if v_phone is null and private.my_country() <> 'EG' then
      v_phone := private.phone_store(v_raw, 'EG');
    end if;
    if v_phone is not null then
      select a.id into v_id
        from public.e_addresses a join public.profiles pr on pr.id = a.owner_id
       where pr.phone = v_phone
         and (pr.phone_verified_at is not null or v_phone !~ '^01')
         and a.phone_lookup and a.is_active;
    end if;
  end if;

  -- 2) Random code, with or without the MG- prefix.
  if v_id is null then
    if v_code like 'MG%' and length(v_code) = 10 then
      v_code := substr(v_code, 3);
    end if;
    if length(v_code) = 8 then
      select id into v_id from public.e_addresses where code = v_code and is_active;
    end if;
  end if;

  -- 3) Handle.
  if v_id is null then
    select id into v_id from public.e_addresses where handle = lower(v_raw) and is_active;
  end if;

  if v_id is null then
    return null;
  end if;

  update public.e_addresses set scan_count = scan_count + 1 where id = v_id returning * into r;
  insert into public.e_address_views (address_id, viewer_id) values (v_id, auth.uid());

  select full_name, phone into v_name, v_owner_phone from public.profiles where id = r.owner_id;
  return jsonb_build_object(
    'code', r.code,
    'handle', r.handle,
    'label', r.label,
    'governorate', r.governorate,
    'city', r.city,
    'district', r.district,
    'street', r.street,
    'building', r.building,
    'floor', r.floor,
    'apartment', r.apartment,
    'landmark', r.landmark,
    'notes', r.notes,
    'lat', r.lat,
    'lng', r.lng,
    'owner_name', case when r.show_name then v_name end,
    'owner_phone', case when r.show_phone then v_owner_phone end
  );
end;
$$;
grant execute on function public.get_e_address(text) to anon, authenticated;

-- 0051's admin search: by any of the 22 states' mobiles too.
create or replace function public.admin_find_e_addresses(p_query text) returns table (
  id uuid, code text, handle text, label text, city text, owner_name text, owner_phone text
)
language plpgsql
security definer
stable
set search_path = public
as $$
declare
  v_q text := trim(coalesce(p_query, ''));
  v_phone text := private.phone_store(v_q, 'EG');
  v_code text := upper(regexp_replace(v_q, '[^A-Za-z0-9]', '', 'g'));
begin
  if not public.is_super_admin() then
    raise exception 'غير مسموح';
  end if;
  if v_code like 'MG%' and length(v_code) = 10 then
    v_code := substr(v_code, 3);
  end if;
  return query
    select a.id, a.code, a.handle, a.label, a.city, p.full_name, p.phone
      from public.e_addresses a join public.profiles p on p.id = a.owner_id
     where (v_phone is not null and p.phone = v_phone)
        or a.code = v_code
        or a.handle = lower(v_q)
     order by a.created_at
     limit 20;
end;
$$;
revoke execute on function public.admin_find_e_addresses(text) from public, anon;
grant execute on function public.admin_find_e_addresses(text) to authenticated;

-- 0076: the union fund payout number may be any of the 22 states' mobiles.
create or replace function public.request_fund_withdrawal(
  p_building uuid,
  p_amount numeric,
  p_note text,
  p_payout_phone text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_balance numeric;
  v_pending numeric;
  v_raw text := nullif(private.phone_clean(p_payout_phone), '');
  v_phone text;
  v_name text;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not public.is_union_fund_manager(p_building) then
    raise exception 'طلب السحب من الصندوق لأمين الصندوق (أو الرئيس لو مفيش أمين صندوق) بس';
  end if;
  if p_amount is null or p_amount < 10 then
    raise exception 'أقل مبلغ للسحب 10 ج.م';
  end if;
  if p_note is null or length(trim(p_note)) < 3 then
    raise exception 'اكتب سبب السحب';
  end if;
  if v_raw is not null then
    v_phone := private.phone_store(v_raw, private.my_country());
    if v_phone is null then
      raise exception 'رقم المحفظة مش صحيح';
    end if;
  end if;

  insert into public.union_funds (building_id) values (p_building) on conflict (building_id) do nothing;
  select balance into v_balance from public.union_funds where building_id = p_building for update;
  select coalesce(sum(amount_egp), 0) into v_pending from public.union_fund_withdrawal_requests
   where building_id = p_building and status = 'pending';
  if v_balance - v_pending < p_amount then
    raise exception 'رصيد الصندوق المتاح مش كفاية (المتاح بعد الطلبات المعلّقة % ج.م)', v_balance - v_pending;
  end if;

  insert into public.union_fund_withdrawal_requests (building_id, requested_by, amount_egp, destination, payout_phone, note)
  values (p_building, auth.uid(), round(p_amount, 2), case when v_phone is null then 'wallet' else 'payout' end, v_phone, trim(p_note))
  returning id into v_id;

  select name into v_name from public.buildings where id = p_building;
  insert into public.notifications (user_id, title, body, deep_link)
  select p.id, '🏦 طلب سحب من صندوق عمارة',
         round(p_amount, 2) || ' ج.م من صندوق «' || coalesce(v_name, '') || '» محتاج مراجعتك.', '/#/admin'
    from public.profiles p where p.role = 'super_admin';

  return v_id;
end;
$$;
revoke execute on function public.request_fund_withdrawal(uuid, numeric, text, text) from public, anon;
grant execute on function public.request_fund_withdrawal(uuid, numeric, text, text) to authenticated;

-- 0081's mosque helpers: found by any of the 22 states' mobiles.
create or replace function public.masjid_add_helper(p_mosque uuid, p_phone text, p_permissions text[], p_title text default null)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_phone text := coalesce(private.phone_store(p_phone, private.my_country()), private.phone_store(p_phone, 'EG'));
  v_user uuid;
  v_name text;
  v_perms text[];
begin
  if not public.masjid_can(p_mosque, 'team') then
    raise exception 'غير مصرح';
  end if;
  if v_phone is not null then
    select id, full_name into v_user, v_name from public.profiles where phone = v_phone;
  end if;
  if v_user is null then
    raise exception 'مفيش حساب على مُجتمعي بالرقم ده — خلّيه يعمل حساب الأول';
  end if;
  if v_user = auth.uid() then
    raise exception 'إنت بالفعل مسؤول';
  end if;
  select coalesce(array_agg(distinct p), '{}') into v_perms
  from unnest(coalesce(p_permissions, '{}')) p
  where p in ('posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings', 'chat');
  if cardinality(v_perms) = 0 then
    raise exception 'اختار صلاحية واحدة على الأقل';
  end if;
  if exists (select 1 from public.mosque_admins where mosque_id = p_mosque and user_id = v_user and role = 'owner') then
    raise exception 'الشخص ده مسؤول أساسي بالفعل';
  end if;
  if (select count(*) from public.mosque_admins where mosque_id = p_mosque) >= 30 then
    raise exception 'وصلت لأقصى عدد مساعدين';
  end if;
  insert into public.mosque_admins (mosque_id, user_id, role, title, permissions, added_by)
  values (p_mosque, v_user, 'helper', left(nullif(btrim(p_title), ''), 40), v_perms, auth.uid())
  on conflict (mosque_id, user_id) do update set permissions = excluded.permissions, title = excluded.title;
  insert into public.notifications (user_id, title, body, deep_link)
  select v_user, 'بقيت من فريق «' || m.name || '»', 'تقدر تساعد في إدارة صفحة المسجد على مسجدي.', '/#/masjid/' || m.id
  from public.mosques m where m.id = p_mosque;
  return v_name;
end;
$$;
revoke execute on function public.masjid_add_helper(uuid, text, text[], text) from public, anon;
grant execute on function public.masjid_add_helper(uuid, text, text[], text) to authenticated;

-- 0087's mosque chat send, with the phone-number filter of the 22 states.
create or replace function public.masjid_chat_send(p_mosque uuid, p_body text, p_reply_to uuid default null) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_body text := btrim(coalesce(p_body, ''));
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
    if private.has_phone_number(v_body) then
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
revoke execute on function public.masjid_chat_send(uuid, text, uuid) from public, anon;
grant execute on function public.masjid_chat_send(uuid, text, uuid) to authenticated;

-- ========================================================= chat rooms
-- 0078, with the verified phone only for Egyptian users.

create or replace function public.get_chat_room(p_room uuid) returns jsonb
language plpgsql stable security definer set search_path = public as $$
declare
  r public.chat_rooms;
  v_verified boolean := false;
  v_required boolean := true;
  v_cp public.chat_profiles;
  v_kind text;
  v_until timestamptz;
  v_reason text;
  v_admin boolean := false;
begin
  select * into r from public.chat_rooms where id = p_room;
  if r.id is null or (not r.is_active and not public.is_super_admin()) then return null; end if;
  if auth.uid() is not null then
    select p.phone_verified_at is not null into v_verified from public.profiles p where p.id = auth.uid();
    v_required := private.phone_required_for(auth.uid());
    select * into v_cp from public.chat_profiles where user_id = auth.uid();
    select s.kind, s.until into v_kind, v_until from public.chat_active_sanction(auth.uid(), p_room) s;
    v_admin := public.is_super_admin();
  end if;
  v_reason := case
    when auth.uid() is null then 'guest'
    when v_required and not coalesce(v_verified, false) then 'no_phone'
    when v_cp.user_id is null then 'no_nickname'
    when v_kind = 'ban' then 'banned'
    when v_kind = 'mute' then 'muted'
    when not r.is_active then 'archived'
  end;
  return jsonb_build_object(
    'id', r.id, 'name', r.name, 'description', r.description, 'kind', r.kind,
    'governorate', r.governorate, 'area', r.area, 'icon', r.icon, 'is_active', r.is_active,
    'online_count', (select count(*) from public.chat_room_presence p where p.room_id = r.id and p.last_seen > now() - interval '90 seconds'),
    'signed_in', auth.uid() is not null,
    'phone_verified', coalesce(v_verified, false),
    'phone_required', v_required,
    'nickname', v_cp.nickname,
    'public_id', v_cp.public_id,
    'can_write', v_reason is null,
    'blocked_reason', v_reason,
    'sanction_until', v_until,
    'is_admin', v_admin,
    'can_moderate', v_admin or (auth.uid() is not null and public.chat_is_room_moderator(auth.uid(), r.id))
  );
end;
$$;

create or replace function public.my_chat_profile() returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'signed_in', auth.uid() is not null,
    'phone_verified', v.verified,
    'phone_required', v.required,
    'needs_phone', auth.uid() is not null and v.required and not v.verified,
    'nickname', cp.nickname,
    'public_id', cp.public_id,
    'can_change_at', case when cp.user_id is not null then cp.nickname_changed_at + interval '7 days' end
  )
  from (select coalesce((select phone_verified_at is not null from public.profiles where id = auth.uid()), false) as verified,
               auth.uid() is null or private.phone_required_for(auth.uid()) as required) v
  left join public.chat_profiles cp on cp.user_id = auth.uid();
$$;

create or replace function public.send_room_message(p_room uuid, p_body text, p_reply_to uuid default null) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_body text := trim(coalesce(p_body, ''));
  v_room public.chat_rooms;
  v_cp public.chat_profiles;
  v_prof public.profiles;
  v_kind text;
  v_until timestamptz;
  v_last timestamptz;
  v_id uuid;
  v_reply public.chat_room_messages;
  v_target uuid;
  v_tz text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول عشان تكتب في الغرف'; end if;
  select * into v_room from public.chat_rooms where id = p_room;
  if v_room.id is null or not v_room.is_active then raise exception 'الغرفة دي مش متاحة'; end if;
  select * into v_prof from public.profiles where id = auth.uid();
  if v_prof.phone_verified_at is null and private.phone_required_for(auth.uid()) then
    raise exception 'أكّد رقمك عشان تكتب في الغرف';
  end if;
  select * into v_cp from public.chat_profiles where user_id = auth.uid();
  if v_cp.user_id is null then raise exception 'اختار اسمك في الغرف الأول'; end if;
  v_tz := case when private.valid_tz(v_prof.tz) then v_prof.tz else 'Africa/Cairo' end;

  select s.kind, s.until into v_kind, v_until from public.chat_active_sanction(auth.uid(), p_room) s;
  if v_kind = 'ban' then
    raise exception '%', case when v_until is null then 'إنت ممنوع من الكتابة في الغرف'
                              else 'إنت ممنوع من الكتابة في الغرف لحد ' || to_char(v_until at time zone v_tz, 'YYYY/MM/DD HH24:MI') end;
  end if;
  if v_kind = 'mute' then
    raise exception 'إنت مكتوم مؤقتاً لحد %', to_char(v_until at time zone v_tz, 'YYYY/MM/DD HH24:MI');
  end if;

  if length(v_body) < 1 then raise exception 'اكتب رسالة الأول'; end if;
  if length(v_body) > 500 then raise exception 'الرسالة طويلة، الحد 500 حرف'; end if;

  select max(created_at) into v_last from public.chat_room_messages where author_pid = v_cp.public_id;
  if v_last is not null and v_last > now() - interval '3 seconds' then
    raise exception 'استنى ثانيتين قبل الرسالة الجاية';
  end if;
  if (select count(*) from public.chat_room_messages where author_pid = v_cp.public_id and created_at > now() - interval '1 minute') >= 20 then
    raise exception 'بتكتب بسرعة، استنى دقيقة';
  end if;
  if exists (select 1 from public.chat_room_messages where author_pid = v_cp.public_id and room_id = p_room
             and body = v_body and created_at > now() - interval '1 minute') then
    raise exception 'إنت لسه باعت نفس الرسالة';
  end if;

  if public.chat_has_banned_word(v_body) then
    raise exception 'الرسالة فيها كلام مش لطيف، عدّلها وابعت تاني';
  end if;

  -- Links and (new since 0089) phone numbers: only for settled accounts.
  if lower(v_body) ~ '(https?://|www\.|t\.me/|wa\.me/|bit\.ly|[a-z0-9-]+\.(com|net|org|eg|io|me|ly|co|info|xyz|link|app|site|online|store|shop|tk|biz)([^a-z0-9]|$))'
     or private.has_phone_number(v_body) then
    if v_prof.created_at > now() - interval '7 days'
       or (select count(*) from public.chat_room_messages where author_pid = v_cp.public_id) < 20 then
      raise exception 'اللينكات وأرقام الموبايل مسموحة بعد ما يعدّي على حسابك أسبوع وتكتب 20 رسالة في الغرف';
    end if;
  end if;

  if p_reply_to is not null then
    select * into v_reply from public.chat_room_messages where id = p_reply_to;
    if v_reply.id is null or v_reply.room_id <> p_room or v_reply.is_hidden then
      raise exception 'الرسالة اللي بترد عليها مش موجودة';
    end if;
  end if;

  insert into public.chat_room_messages (room_id, author_pid, nickname, body, reply_to)
  values (p_room, v_cp.public_id, v_cp.nickname, v_body, p_reply_to)
  returning id into v_id;

  if v_reply.id is not null then
    select cp.user_id into v_target from public.chat_profiles cp where cp.public_id = v_reply.author_pid;
    if v_target is not null and v_target <> auth.uid()
       and not public.is_blocked_between(auth.uid(), v_target)
       and not exists (select 1 from public.chat_ignores i where i.user_id = v_target and i.ignored_pid = v_cp.public_id)
       and not exists (select 1 from public.notifications n where n.user_id = v_target
                        and n.deep_link = '/#/rooms/' || p_room and n.created_at > now() - interval '10 minutes') then
      insert into public.notifications (user_id, title, body, deep_link)
      values (v_target, v_cp.nickname || ' ردّ عليك في غرفة ' || v_room.name, left(v_body, 120), '/#/rooms/' || p_room);
    end if;
  end if;
  return v_id;
end;
$$;

-- Reports that count toward auto-hiding: verified reporters, or — outside
-- Egypt, where SMS verification isn't offered — accounts 3+ days old.
create or replace function public.report_room_message(p_message uuid, p_reason text default null) returns boolean
language plpgsql security definer set search_path = public as $$
declare
  v_msg public.chat_room_messages;
  v_count int;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select * into v_msg from public.chat_room_messages where id = p_message;
  if v_msg.id is null then raise exception 'الرسالة مش موجودة'; end if;
  if public.chat_message_author(p_message) = auth.uid() then raise exception 'مينفعش تبلّغ عن رسالتك'; end if;
  if exists (select 1 from public.chat_room_reports where message_id = p_message and reporter_id = auth.uid()) then
    raise exception 'بلّغت عن الرسالة دي قبل كده';
  end if;
  if (select count(*) from public.chat_room_reports where reporter_id = auth.uid() and created_at > now() - interval '1 day') >= 30 then
    raise exception 'بلّغت كتير النهارده';
  end if;
  insert into public.chat_room_reports (message_id, reporter_id, reason)
  values (p_message, auth.uid(), coalesce(nullif(trim(coalesce(p_reason, '')), ''), 'إساءة'));
  select count(*) into v_count from public.chat_room_reports rr join public.profiles p on p.id = rr.reporter_id
  where rr.message_id = p_message
    and (p.phone_verified_at is not null
         or (not private.phone_required_for(p.id) and p.created_at < now() - interval '3 days'));
  update public.chat_room_messages set reports_count = (select count(*) from public.chat_room_reports where message_id = p_message)
  where id = p_message;
  if v_count >= 3 and not v_msg.is_hidden then
    update public.chat_room_messages set is_hidden = true, hidden_reason = 'auto_reports', hidden_at = now() where id = p_message;
    insert into public.chat_mod_log (actor_id, action, room_id, message_id, target_user, detail)
    values (null, 'auto_hide', v_msg.room_id, p_message, public.chat_message_author(p_message), jsonb_build_object('reports', v_count));
    return true;
  end if;
  return v_msg.is_hidden;
end;
$$;

do $$
declare f text;
begin
  foreach f in array array['get_chat_room(uuid)'] loop
    execute format('revoke execute on function public.%s from public', f);
    execute format('grant execute on function public.%s to anon, authenticated', f);
  end loop;
  foreach f in array array['my_chat_profile()', 'send_room_message(uuid, text, uuid)', 'report_room_message(uuid, text)'] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end $$;
