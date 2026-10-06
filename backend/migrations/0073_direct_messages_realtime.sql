-- =====================================================================
-- 0073 — Live private chat.
--
-- The friends chat polled fetch_direct_messages every 5 s while open.
-- Supabase Realtime can push new rows instead, but it only delivers rows
-- the subscriber may SELECT under RLS — and direct_messages was RPC-only.
-- A recipient may now read the messages sent *to them* (nothing else);
-- sending and reading conversations still go through the RPCs.
-- Safe to re-run.
-- =====================================================================

drop policy if exists direct_messages_recipient_read on public.direct_messages;
create policy direct_messages_recipient_read on public.direct_messages
  for select to authenticated
  using (recipient_id = auth.uid());

grant select on public.direct_messages to authenticated;

do $$
begin
  if not exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    raise notice 'supabase_realtime publication not found — skipping (not a Supabase database)';
    return;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'direct_messages'
  ) then
    alter publication supabase_realtime add table public.direct_messages;
  end if;
end;
$$;
