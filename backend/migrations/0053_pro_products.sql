-- =====================================================================
-- Migration 0053 — professional store products.
--
--   * images: up to 6 photos per product (the first is the cover; the
--     old image_url column keeps mirroring it for older app builds and
--     the instant store page).
--   * old_price: the price before a discount (shown struck through).
--   * highlights: up to 6 short selling points ("قطن 100%"، "ضمان سنة").
-- The AI writer (Edge Function product-ai) reuses bump_places_usage()
-- with an "ai:<user>" bucket for its daily quota — no new table.
-- =====================================================================

alter table public.shop_products add column if not exists images text[] not null default '{}';
alter table public.shop_products add column if not exists old_price numeric(12,2);
alter table public.shop_products add column if not exists highlights text[] not null default '{}';

update public.shop_products set images = array[image_url]
 where image_url is not null and cardinality(images) = 0;

alter table public.shop_products drop constraint if exists shop_products_images_max;
alter table public.shop_products add constraint shop_products_images_max check (cardinality(images) <= 6);
alter table public.shop_products drop constraint if exists shop_products_highlights_max;
alter table public.shop_products add constraint shop_products_highlights_max check (cardinality(highlights) <= 6);
alter table public.shop_products drop constraint if exists shop_products_old_price_valid;
alter table public.shop_products add constraint shop_products_old_price_valid check (old_price is null or old_price > price);
alter table public.shop_products drop constraint if exists shop_products_description_len;
alter table public.shop_products add constraint shop_products_description_len check (description is null or length(description) <= 2000);
