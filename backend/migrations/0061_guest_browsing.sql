-- =====================================================================
-- 0061 — Guests can browse the marketplace, real estate and technicians.
--
-- These tables already had "public read" RLS policies (active listings,
-- technicians), but only the `authenticated` role was ever GRANTed SELECT,
-- so every guest request failed (401) and the screens showed "تعذر تحميل
-- البيانات". Launch traffic arrives mostly as guests, so give `anon` the
-- same read-only view signed-in users get — nothing more:
--   * rows are still filtered by the existing policies (active only);
--   * technicians: the same safe column list as authenticated (no ID
--     documents);
--   * profiles: name/verified columns only, and RLS shows a guest no
--     profile rows at all, so embeds simply come back empty (no phones);
--   * buildings: just the coordinates the real-estate list needs.
-- =====================================================================

grant select on public.marketplace_listings to anon;
grant select on public.real_estate_listings to anon;

grant select (
  id, user_id, category, bio, rating, rating_count, is_verified,
  escrow_supported, service_area, created_at, verification_status
) on public.technicians to anon;

grant select (id, full_name, is_verified) on public.profiles to anon;
grant select (id, lat, lng) on public.buildings to anon;

-- The co-member policy looks up union_members, which guests can't read:
-- evaluating it as anon errored ("permission denied"), breaking every
-- guest query that embeds a seller/owner name. It only ever matches
-- signed-in members anyway, so scope it to them.
alter policy "profiles: building co-members can view" on public.profiles to authenticated;
-- Same for the super-admin policy: guests can't execute is_super_admin().
alter policy "profiles: super_admin views all" on public.profiles to authenticated;
