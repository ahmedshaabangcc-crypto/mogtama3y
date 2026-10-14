-- Extract one Arab country's places from the Overture release (DuckDB).
-- The country is the DIR_COUNTRY environment variable (ISO2, default EG):
--   DIR_COUNTRY=SA duckdb sa.db -c ".read 1_extract_overture.sql"
-- Its bounding box comes from the table below (rough boxes, the same as
-- private.arab_country_at in migration 0093 — Egypt's is the one used for
-- the original import); addresses[1].country keeps only that country.
-- Writes places.parquet (one database / folder per country).
INSTALL httpfs; LOAD httpfs; LOAD spatial;
SET s3_region='us-west-2';

CREATE OR REPLACE TABLE country_boxes AS SELECT * FROM (VALUES
  ('EG', 24.6, 37.0, 21.9, 31.8), ('SA', 34.5, 55.7, 16.3, 32.2), ('AE', 51.5, 56.4, 22.6, 26.1),
  ('OM', 52.0, 59.9, 16.6, 26.4), ('QA', 50.7, 51.7, 24.4, 26.2), ('BH', 50.3, 50.8, 25.5, 26.4),
  ('KW', 46.5, 48.5, 28.5, 30.1), ('IQ', 38.8, 48.6, 29.0, 37.4), ('JO', 34.9, 39.3, 29.2, 33.4),
  ('SY', 35.7, 42.4, 32.3, 37.3), ('LB', 35.1, 36.6, 33.0, 34.7), ('PS', 34.2, 35.6, 31.2, 32.6),
  ('YE', 42.5, 54.6, 12.1, 19.0), ('LY', 9.3, 25.2, 19.5, 33.2), ('TN', 7.5, 11.6, 30.2, 37.6),
  ('DZ', -8.7, 12.0, 18.9, 37.1), ('MA', -17.1, -1.0, 20.7, 35.9), ('MR', -17.1, -4.8, 14.7, 27.3),
  ('SD', 21.8, 38.6, 8.6, 22.3), ('SO', 40.9, 51.4, -1.7, 12.0), ('DJ', 41.7, 43.4, 10.9, 12.7),
  ('KM', 43.2, 44.6, -12.5, -11.3)
) t(iso, xmin, xmax, ymin, ymax);

SET VARIABLE iso = upper(coalesce(nullif(getenv('DIR_COUNTRY'), ''), 'EG'));
SET VARIABLE xmin = (SELECT xmin FROM country_boxes WHERE iso = getvariable('iso'));
SET VARIABLE xmax = (SELECT xmax FROM country_boxes WHERE iso = getvariable('iso'));
SET VARIABLE ymin = (SELECT ymin FROM country_boxes WHERE iso = getvariable('iso'));
SET VARIABLE ymax = (SELECT ymax FROM country_boxes WHERE iso = getvariable('iso'));
-- Unknown country → stop here (no box).
SELECT CASE WHEN getvariable('xmin') IS NULL THEN error('DIR_COUNTRY must be one of the 22 Arab states') END;

COPY (
  SELECT id,
         names.primary AS name,
         names.common['ar'] AS name_ar,
         basic_category,
         taxonomy.primary AS category,
         confidence,
         phones,
         websites,
         socials,
         addresses[1].freeform AS address,
         addresses[1].locality AS locality,
         addresses[1].region AS region,
         ST_Y(geometry) AS lat, ST_X(geometry) AS lng,
         operating_status,
         list_distinct([s.dataset FOR s IN sources]) AS datasets,
         list_distinct([s.license FOR s IN sources]) AS licenses
  FROM read_parquet('s3://overturemaps-us-west-2/release/2026-09-23.1/theme=places/type=place/*', hive_partitioning=1)
  WHERE bbox.xmin BETWEEN getvariable('xmin') AND getvariable('xmax')
    AND bbox.ymin BETWEEN getvariable('ymin') AND getvariable('ymax')
    AND addresses[1].country = getvariable('iso')
) TO 'places.parquet' (FORMAT parquet, COMPRESSION zstd);
