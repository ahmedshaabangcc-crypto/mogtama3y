-- =====================================================================
-- Migration 0006 — visitor QR passes, scoped to the issuer's own unit.
-- visitor_passes had RLS enabled with no policies (default deny), same
-- as the rest of the still-unwired tables. Run after 0002-0005, in
-- order, in the Supabase SQL editor.
-- =====================================================================

create policy "visitor_passes: issuer can view own" on public.visitor_passes
  for select using (auth.uid() = issued_by);

create policy "visitor_passes: member issues for own unit" on public.visitor_passes
  for insert with check (
    auth.uid() = issued_by
    and exists (
      select 1 from public.union_members m
      where m.user_id = auth.uid() and m.unit_id = visitor_passes.unit_id
    )
  );

create policy "visitor_passes: issuer can update own (e.g. revoke)" on public.visitor_passes
  for update using (auth.uid() = issued_by) with check (auth.uid() = issued_by);
