-- =====================================================================
-- 0064 — Maintenance businesses from the directory in the technicians
-- market.
--
-- ~11k plumbers, electricians, AC shops, carpenters, painters, contractors…
-- from the Egypt directory get a `trade` matching the market's categories
-- (set by backend/maintenance/directory/4_trades.sql). The market lists them
-- under the registered technicians as "غير موثّق": contact only — booking
-- with escrow and the verified badge come once they register with us.
-- =====================================================================

alter table public.directory_places add column if not exists trade text
  check (trade is null or trade in ('سباكة', 'كهرباء', 'تكييف وتبريد', 'نجارة', 'دهانات', 'أخرى'));
create index if not exists directory_places_trade on public.directory_places (trade, lat, lng) where trade is not null;

create or replace function public.nearby_services(
  p_lat double precision,
  p_lng double precision,
  p_trade text default null,
  p_km double precision default 10,
  p_limit int default 60
) returns table (
  id text, name text, trade text, phone text, whatsapp text, address text,
  lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  with box as (
    select least(greatest(coalesce(p_km, 10), 1), 60) / 111.0 as dlat,
           least(greatest(coalesce(p_km, 10), 1), 60) / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng
  )
  select d.id, d.name, d.trade, d.phone, d.whatsapp, d.address, d.lat, d.lng, d.claimed_shop_id,
         111.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) as distance_km
  from public.directory_places d, box
  where d.trade is not null
    and (p_trade is null or d.trade = p_trade)
    and d.lat between p_lat - box.dlat and p_lat + box.dlat
    and d.lng between p_lng - box.dlng and p_lng + box.dlng
  order by (d.whatsapp is not null) desc, distance_km
  limit least(greatest(coalesce(p_limit, 60), 1), 150);
$$;
grant execute on function public.nearby_services(double precision, double precision, text, double precision, int) to anon, authenticated;
