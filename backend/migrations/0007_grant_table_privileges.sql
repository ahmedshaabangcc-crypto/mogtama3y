-- =====================================================================
-- Migration 0007 — CRITICAL FIX. Every migration so far (0002-0006)
-- only added Row Level Security *policies*. RLS policies are a second
-- gate that only applies *after* Postgres's coarser table-level GRANT
-- check — and because this project has "Automatically expose new
-- tables" turned off (see backend/supabase-project.md), the
-- `authenticated` role was never granted basic SELECT/INSERT/UPDATE
-- privileges on ANY of these tables in the first place. Every query
-- from the app has been failing with "permission denied for table X"
-- (Postgres error 42501) regardless of RLS — confirmed live via the
-- REST API on 2026-09-11 testing sign-in.
--
-- Run this now, before anything else. It's the reason auth, wallet,
-- marketplace, union/building, lost & found, and visitor passes have
-- all been silently broken since they were first wired.
--
-- IMPORTANT for future migrations: every new table wired to the app
-- from now on needs its own GRANT statement here or in its own
-- migration — RLS policies alone are not enough on this project.
-- =====================================================================

grant usage on schema public to authenticated;

grant select, insert, update on public.profiles to authenticated;
grant select, insert, update on public.wallets to authenticated;
grant select, insert on public.wallet_transactions to authenticated;

grant select, insert, update on public.marketplace_listings to authenticated;

grant select, insert on public.buildings to authenticated;
grant select, insert on public.units to authenticated;
grant select, insert on public.unit_residents to authenticated;
grant select, insert, update on public.union_members to authenticated;
-- union_invite_codes intentionally has no grant here — it's only ever
-- touched inside the SECURITY DEFINER functions (found_building,
-- join_building_with_code), which run as their owner and don't need
-- the caller's role to have table privileges.

grant select, insert, update on public.lost_found_items to authenticated;

grant select, insert, update on public.visitor_passes to authenticated;

grant select, insert on public.posts to authenticated;
