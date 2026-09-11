-- =====================================================================
-- Migration 0012 — shops directory, real Google Places imports.
-- shops had RLS enabled with no policies and no grants (same
-- default-deny baseline as everything else). Run after 0002-0011, in
-- order, in the Supabase SQL editor.
-- =====================================================================

grant select, insert, update on public.shops to authenticated;

create policy "shops: public read" on public.shops
  for select using (true);

-- Anyone signed in can import a shop found via Google Places (owner_id
-- stays null until claimed) or claim an unclaimed one for themselves.
create policy "shops: authenticated inserts unclaimed" on public.shops
  for insert with check (owner_id is null);

create policy "shops: owner manages own" on public.shops
  for update using (auth.uid() = owner_id);
