-- =====================================================================
-- Migration 0011 — recycling/بيكيا auction marketplace.
-- recycling_listings/recycling_bids had RLS enabled with no policies
-- and no grants (same default-deny baseline as everything else). Run
-- after 0002-0010, in order, in the Supabase SQL editor.
-- =====================================================================

grant select, insert, update on public.recycling_listings to authenticated;
grant select, insert on public.recycling_bids to authenticated;

create policy "recycling_listings: public read active" on public.recycling_listings
  for select using (status = 'active');

create policy "recycling_listings: seller manages own" on public.recycling_listings
  for all using (auth.uid() = seller_id);

create policy "recycling_bids: public read" on public.recycling_bids
  for select using (true);

create policy "recycling_bids: bidder creates own" on public.recycling_bids
  for insert with check (auth.uid() = bidder_id);
