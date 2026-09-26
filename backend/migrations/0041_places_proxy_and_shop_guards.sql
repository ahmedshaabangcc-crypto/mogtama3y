-- =====================================================================
-- Migration 0041 — Google Places moves behind the `places` Edge
-- Function (backend/functions/places), and shops stop trusting the
-- client.
--
-- Before this:
--   * The Google API key shipped in the web bundle and was also stored
--     inside shops.cover_image_url (a publicly readable column), so
--     anyone could copy it and run up the bill.
--   * Any signed-in user could insert shops rows with made-up
--     source='google_imported', ratings, discounts and phone-less
--     addresses ("shops: authenticated inserts unclaimed").
--   * A claimed shop's owner could edit its rating, source, ownership.
--
-- Now:
--   * Only the Edge Function (service role) inserts imported shops.
--   * places_usage + bump_places_usage() give the function a per-user /
--     per-IP daily quota.
--   * cover_image_url values that embedded the key are cleared (the
--     function now stores Google's key-less photo URL instead).
--   * A guard trigger keeps rating / source / ownership columns
--     server-controlled.
--
-- Run after 0040 in the Supabase SQL editor, then deploy the function
-- and set its GOOGLE_MAPS_API_KEY secret (see backend/functions/README.md).
-- =====================================================================

-- ---- 1. Daily quota for the Edge Function ----

create table if not exists public.places_usage (
  bucket text not null,          -- 'user:<uuid>' or 'ip:<address>'
  day date not null default current_date,
  count int not null default 0,
  primary key (bucket, day)
);
revoke all on public.places_usage from anon, authenticated;

-- Increments today's counter for p_bucket and returns whether the call
-- is still within p_limit. Only the Edge Function (service role) calls it.
create or replace function public.bump_places_usage(p_bucket text, p_limit int) returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
  v_count int;
begin
  insert into public.places_usage (bucket, day, count)
  values (p_bucket, current_date, 1)
  on conflict (bucket, day) do update set count = public.places_usage.count + 1
  returning count into v_count;
  return v_count <= p_limit;
end;
$$;

revoke execute on function public.bump_places_usage(text, int) from public, anon, authenticated;
grant execute on function public.bump_places_usage(text, int) to service_role;

-- ---- 2. Shops: imports are server-side only ----

drop policy if exists "shops: authenticated inserts unclaimed" on public.shops;
revoke insert on public.shops from authenticated, anon;

-- Remove the API key that was baked into stored photo URLs.
update public.shops
set cover_image_url = null
where cover_image_url like '%key=%';

create or replace function public.guard_shop_protected_columns() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if new.owner_id is distinct from old.owner_id
       or new.source is distinct from old.source
       or new.google_place_id is distinct from old.google_place_id
       or new.rating is distinct from old.rating
       or new.rating_count is distinct from old.rating_count
       or new.is_claimed is distinct from old.is_claimed
       or new.claimed_at is distinct from old.claimed_at then
      raise exception 'لا يمكن تعديل هذه البيانات' using errcode = '42501';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists guard_shop_protected_columns on public.shops;
create trigger guard_shop_protected_columns
  before update on public.shops
  for each row execute function public.guard_shop_protected_columns();
