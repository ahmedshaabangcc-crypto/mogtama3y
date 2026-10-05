INSTALL httpfs; LOAD httpfs; LOAD spatial;
SET s3_region='us-west-2';
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
  WHERE bbox.xmin BETWEEN 24.6 AND 37.0 AND bbox.ymin BETWEEN 21.9 AND 31.8
    AND addresses[1].country = 'EG'
) TO 'egypt_places.parquet' (FORMAT parquet, COMPRESSION zstd);
