-- =====================================================================
-- Migration 0043 — chats update instantly (Supabase Realtime) instead
-- of every screen polling the database every 4 seconds.
--
-- Adds the three chat tables to the `supabase_realtime` publication.
-- Realtime still enforces each table's RLS per subscriber, so a user only
-- receives messages they could already SELECT (verified building
-- members, neighbourhood members, the two sides of a marketplace chat).
-- The app keeps a slow 30s poll as a fallback.
--
-- Run after 0042, in order, in the Supabase SQL editor.
-- =====================================================================

do $$
declare
  t text;
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    raise notice 'supabase_realtime publication not found — skipping (not a Supabase database)';
    return;
  end if;
  foreach t in array array['building_chat_messages', 'neighborhood_chat_messages', 'marketplace_messages'] loop
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t
    ) then
      execute format('alter publication supabase_realtime add table public.%I', t);
    end if;
  end loop;
end;
$$;
