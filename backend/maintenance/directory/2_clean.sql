CREATE OR REPLACE TABLE clean AS
WITH b AS (
  SELECT *, coalesce(basic_category, '') AS bc,
         regexp_replace(coalesce(phones[1], ''), '[^0-9+]', '', 'g') AS ph
  FROM 'egypt_places.parquet'
  WHERE name IS NOT NULL AND length(trim(name)) >= 2
    AND coalesce(basic_category, '') NOT IN ('geographic_entities', 'waterfall', 'island', 'hot_springs', 'built_feature', 'public_restroom', 'utility_energy_infrastructure', 'river', 'mountain', 'lake', 'forest', 'desert', 'cave')
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
  CASE WHEN regexp_matches(ph, '^(\+20|0020|20)?0?1[0125][0-9]{8}$')
       THEN '0' || right(ph, 10) END AS whatsapp,
  websites[1] AS website,
  socials[1] AS social,
  nullif(trim(coalesce(address, '')), '') AS address,
  round(lat, 6) AS lat, round(lng, 6) AS lng,
  round(confidence, 3)::REAL AS confidence
FROM b;
SELECT count(*) AS total, count(whatsapp) wa FROM clean;
SELECT category, count(*) c FROM clean GROUP BY 1 ORDER BY 2 DESC;
SELECT kind, count(*) c FROM clean WHERE category = 'أخرى' GROUP BY 1 ORDER BY 2 DESC LIMIT 25;
COPY clean TO 'directory.csv' (HEADER, DELIMITER ',');
