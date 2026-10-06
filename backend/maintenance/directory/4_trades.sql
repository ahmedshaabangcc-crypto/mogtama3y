-- Sets directory_places.trade (migration 0064) for maintenance businesses,
-- from Overture's detailed category. Run through load.sh-style attach:
--   ./load_trades.sh duckdb egypt.db   (needs egypt_places.parquet next to egypt.db)
CREATE OR REPLACE TEMP TABLE trades AS
SELECT id,
  CASE
    WHEN category IN ('plumbing', 'well_drilling') THEN 'سباكة'
    WHEN category IN ('electrician', 'solar_installation', 'home_security', 'fire_protection_service') THEN 'كهرباء'
    WHEN category IN ('hvac_service', 'commercial_refrigeration', 'appliance_repair_service') THEN 'تكييف وتبريد'
    WHEN category IN ('carpenter', 'furniture_assembly', 'windows_installation', 'countertop_installation') THEN 'نجارة'
    WHEN category IN ('painting', 'interior_design') THEN 'دهانات'
    WHEN category IN ('contractor', 'building_or_construction_service', 'home_service', 'mover', 'home_cleaning',
                      'glass_and_mirror_sales_service', 'elevator_service', 'pest_control_service', 'masonry_concrete',
                      'landscaping', 'pool_cleaning', 'carpet_cleaning', 'tv_mounting', 'it_service_and_computer_repair') THEN 'أخرى'
  END AS trade
FROM 'egypt_places.parquet'
WHERE basic_category IN ('home_service', 'building_or_construction_service', 'technical_service');
DELETE FROM trades WHERE trade IS NULL;
CREATE OR REPLACE TABLE pg.public._trades AS SELECT id, trade FROM trades;
CALL postgres_execute('pg', 'update public.directory_places d set trade = t.trade from public._trades t where t.id = d.id; drop table public._trades;');
SELECT trade, count(*) AS n FROM trades GROUP BY 1 ORDER BY 2 DESC;
