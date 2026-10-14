-- Clean places.parquet (from 1_extract_overture.sql) for one country:
--   DIR_COUNTRY=SA duckdb sa.db -c ".read 2_clean.sql"     (default EG)
-- WhatsApp: a mobile of any of the 22 states (the dial codes and mobile
-- patterns of private.arab_phone_plan, migration 0089), written the way the
-- backend stores phones: 01xxxxxxxxx for Egypt, E.164 (+9665…) otherwise.
-- Local numbers (0…) are read in the country being cleaned.
SET VARIABLE iso = upper(coalesce(nullif(getenv('DIR_COUNTRY'), ''), 'EG'));
CREATE OR REPLACE TABLE arab_phone_plan AS SELECT * FROM (VALUES
  ('EG', '20', '1[0125][0-9]{8}'), ('SA', '966', '5[0-9]{8}'), ('AE', '971', '5[0-9][0-9]{7}'),
  ('KW', '965', '[4569][0-9]{7}'), ('QA', '974', '[3567][0-9]{7}'), ('BH', '973', '[36][0-9]{7}'),
  ('OM', '968', '[79][0-9]{7}'), ('YE', '967', '7[0-9]{8}'), ('JO', '962', '7[789][0-9]{7}'),
  ('PS', '970', '5[69][0-9]{7}'), ('LB', '961', '3[0-9]{6}|7[0-9][0-9]{6}|8[01][0-9]{6}'),
  ('SY', '963', '9[0-9]{8}'), ('IQ', '964', '7[3-9][0-9]{8}'), ('SD', '249', '[19][0-9]{8}'),
  ('LY', '218', '9[1-6][0-9]{7}'), ('TN', '216', '[2459][0-9]{7}'), ('DZ', '213', '[567][0-9]{8}'),
  ('MA', '212', '[67][0-9]{8}'), ('MR', '222', '[234][0-9]{7}'), ('SO', '252', '[679][0-9]{7,8}'),
  ('DJ', '253', '77[0-9]{6}'), ('KM', '269', '[34][0-9]{6}')
) t(iso, dial, mobile);
SET VARIABLE home_dial = (SELECT dial FROM arab_phone_plan WHERE iso = getvariable('iso'));
SET VARIABLE home_mobile = (SELECT mobile FROM arab_phone_plan WHERE iso = getvariable('iso'));
SELECT CASE WHEN getvariable('home_dial') IS NULL THEN error('DIR_COUNTRY must be one of the 22 Arab states') END;

CREATE OR REPLACE TABLE clean AS
WITH b AS (
  SELECT *, coalesce(basic_category, '') AS bc,
         regexp_replace(coalesce(phones[1], ''), '[^0-9+]', '', 'g') AS ph
  FROM 'places.parquet'
  WHERE name IS NOT NULL AND length(trim(name)) >= 2
    AND coalesce(basic_category, '') NOT IN ('geographic_entities', 'waterfall', 'island', 'hot_springs', 'built_feature', 'public_restroom', 'utility_energy_infrastructure', 'river', 'mountain', 'lake', 'forest', 'desert', 'cave')
),
-- The phone as international digits: +… / 00… as given, a local 0… or a
-- bare local mobile in the cleaned country, else digits that may already
-- start with a dial code (2010…, 9665…).
intl AS (
  SELECT id,
    CASE
      WHEN ph LIKE '+%' THEN substr(ph, 2)
      WHEN ph LIKE '00%' THEN substr(ph, 3)
      WHEN ph LIKE '0%' THEN getvariable('home_dial') || substr(ph, 2)
      WHEN regexp_full_match(ph, getvariable('home_mobile')) THEN getvariable('home_dial') || ph
      ELSE ph
    END AS d
  FROM b WHERE ph <> ''
),
-- National number after a dial code (a trunk 0 dropped, as private._phone_from_intl).
split AS (
  SELECT i.id, p.iso, p.dial, p.mobile, regexp_replace(substr(i.d, length(p.dial) + 1), '^0', '') AS n
  FROM intl i JOIN arab_phone_plan p ON starts_with(i.d, p.dial)
),
-- No dial code of the 22 is a prefix of another, so at most one row per place.
wa AS (
  SELECT id, any_value(CASE WHEN iso = 'EG' THEN '0' || n ELSE '+' || dial || n END) AS whatsapp
  FROM split WHERE regexp_full_match(n, mobile)
  GROUP BY id
)
SELECT id, trim(name) AS name,
  CASE
    WHEN regexp_matches(bc, 'place_of_worship|mosque|church') THEN 'مساجد وكنائس'
    WHEN regexp_matches(bc, 'pharmacy|drug') THEN 'صيدليات'
    WHEN regexp_matches(bc, 'dental|clinic|hospital|doctor|medical|diagnostic|health|physician|optometr|veterinar|wellness|surgery|womens_care|outpatient|rehabilitation|nursing|therap') THEN 'صحة وعيادات'
    WHEN regexp_matches(bc, 'bakery|dessert|sweet|pastry|ice_cream|candy') THEN 'حلويات ومخبوزات'
    WHEN regexp_matches(bc, 'cafe|coffee|tea|juice') THEN 'كافيهات'
    WHEN regexp_matches(bc, 'restaurant|eatery|fast_food|food_court|grill|pizza|bar$') THEN 'مطاعم'
    WHEN regexp_matches(bc, 'grocery|supermarket|food_and_beverage|convenience|butcher|market|dairy|meat|fish|produce') THEN 'سوبر ماركت وبقالة'
    WHEN regexp_matches(bc, 'fashion|apparel|clothing|shoe|jewel|accessor|bag|textile|tailor') THEN 'ملابس وأزياء'
    WHEN regexp_matches(bc, 'electronic|mobile|phone|computer|appliance') THEN 'إلكترونيات وموبايلات'
    WHEN regexp_matches(bc, 'hardware|home_and_garden|furniture|home_goods|kitchen|lighting|paint|flooring') THEN 'أدوات منزلية وأثاث'
    WHEN regexp_matches(bc, 'beauty|salon|barber|spa|personal|cosmetic|nail|hair') THEN 'تجميل وعناية'
    WHEN regexp_matches(bc, 'automotive|car_|auto_|gas_station|fuel|tire|motorcycle|parking') THEN 'سيارات'
    WHEN regexp_matches(bc, 'home_service|plumb|electrician|contractor|repair|cleaning|pest|moving') THEN 'صيانة وخدمات منزلية'
    WHEN regexp_matches(bc, 'real_estate|housing|apartment|property') THEN 'عقارات'
    WHEN regexp_matches(bc, 'hotel|travel|tour|lodging|resort|hostel') THEN 'سفر وفنادق'
    WHEN regexp_matches(bc, 'learning|school|education|university|college|academy|tutor|training|kindergarten|library') THEN 'تعليم'
    WHEN regexp_matches(bc, 'gym|fitness|sport|stadium|yoga|swim|club') THEN 'رياضة'
    WHEN regexp_matches(bc, 'event|party|wedding|photograph|venue') THEN 'مناسبات وتصوير'
    WHEN regexp_matches(bc, 'book|stationer|toy|gift|florist|flower|pet|art_supply|music') THEN 'هدايا ومكتبات'
    WHEN regexp_matches(bc, 'manufactur|supplier|distributor|wholesale|factory|b2b') THEN 'مصانع وموردين'
    WHEN regexp_matches(bc, 'government|civic|community|social_or_community|embassy|police|post_office') THEN 'جهات حكومية وخدمية'
    WHEN regexp_matches(bc, 'historic|museum|beach|park|attraction|landmark|zoo|aquarium') THEN 'أماكن وسياحة'
    WHEN regexp_matches(bc, 'atm|bank') THEN 'بنوك وصرافات'
    WHEN regexp_matches(bc, 'professional|attorney|law_firm|technical|construction|printing|design|media|business|office|legal|lawyer|financ|bank|insurance|account|consult|advertis|marketing|agency') THEN 'خدمات وشركات'
    WHEN regexp_matches(bc, 'shopping|store|shop|retail|mall') THEN 'محلات متنوعة'
    ELSE 'أخرى'
  END AS category,
  nullif(bc, '') AS kind,
  nullif(ph, '') AS phone,
  wa.whatsapp,
  websites[1] AS website,
  socials[1] AS social,
  nullif(trim(coalesce(address, '')), '') AS address,
  round(lat, 6) AS lat, round(lng, 6) AS lng,
  round(confidence, 3)::REAL AS confidence,
  getvariable('iso') AS country
FROM b LEFT JOIN wa USING (id);
SELECT count(*) AS total, count(whatsapp) wa FROM clean;
SELECT category, count(*) c FROM clean GROUP BY 1 ORDER BY 2 DESC;
SELECT kind, count(*) c FROM clean WHERE category = 'أخرى' GROUP BY 1 ORDER BY 2 DESC LIMIT 25;
COPY clean TO 'directory.csv' (HEADER, DELIMITER ',');
