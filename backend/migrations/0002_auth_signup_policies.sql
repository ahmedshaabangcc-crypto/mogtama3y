-- =====================================================================
-- Migration 0002 — allow a newly-signed-up user to create their own
-- profile + wallet rows client-side (needed by lib/core/auth/auth_service.dart).
-- Run this once in the Supabase SQL editor for the mogtama3y project.
-- =====================================================================

-- profiles: schema.sql only had "select own" and "update own" — add insert.
create policy "profiles: user can insert own" on public.profiles
  for insert with check (auth.uid() = id);

-- wallets: existing "for all using (auth.uid() = user_id)" policy has no
-- WITH CHECK, so Postgres reuses the USING expression for inserts too —
-- this already covers insert. Nothing to add here; kept as a note.
