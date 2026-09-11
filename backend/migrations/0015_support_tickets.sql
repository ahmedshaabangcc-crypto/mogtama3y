-- =====================================================================
-- Migration 0015 — support tickets. Had RLS enabled with no policies
-- and no grants. Run after 0002-0014, in order, in the Supabase SQL
-- editor.
-- =====================================================================

grant select, insert on public.support_tickets to authenticated;

create policy "support_tickets: user manages own" on public.support_tickets
  for all using (auth.uid() = user_id);
