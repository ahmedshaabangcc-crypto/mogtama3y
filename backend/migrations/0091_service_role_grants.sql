-- =====================================================================
-- Migration 0091 — service_role can reach the tables again.
--
-- This project has "Automatically expose new tables" turned off, so no API
-- role gets table privileges unless a migration grants them — and none ever
-- granted service_role (Supabase's server-only admin key; it bypasses RLS by
-- design and never reaches the browser). Verified on production: service_role
-- had no SELECT on notifications, push_subscriptions, shops, profiles or
-- support_tickets, so every Edge Function that reads or writes tables with
-- the service key (send-push, places, assistant) got "permission denied".
-- 0090 fixed push only; this restores Supabase's default for every table.
-- Owner approved (2026-10-14). Safe to re-run.
-- =====================================================================

grant usage on schema public to service_role;
grant all on all tables in schema public to service_role;
grant all on all sequences in schema public to service_role;
grant execute on all functions in schema public to service_role;
alter default privileges in schema public grant all on tables to service_role;
alter default privileges in schema public grant all on sequences to service_role;
alter default privileges in schema public grant execute on functions to service_role;
