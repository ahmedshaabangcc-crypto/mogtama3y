-- =====================================================================
-- Migration 0044 — the shops directory is readable without signing in.
--
-- Decision by the project owner: visitors browsing مُجتمعي as guests
-- should see the neighbourhood shops directory (public business data
-- imported from Google Maps). "shops: public read" (0012) already
-- allowed every row; only the `anon` role lacked the table grant, so
-- guests got a load error. Read-only: importing shops still requires a
-- signed-in user via the `places` Edge Function, and only the service
-- role can insert.
--
-- Run after 0043 in the Supabase SQL editor.
-- =====================================================================

grant select on public.shops to anon;
