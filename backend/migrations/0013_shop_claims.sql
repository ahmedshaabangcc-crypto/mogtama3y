-- =====================================================================
-- Migration 0013 — shop ownership claims go through a review queue
-- (shop_claim_requests already existed in the schema for exactly this,
-- unused until now) rather than an instant/unverified claim. Had RLS
-- enabled with no policies and no grants. Run after 0002-0012, in
-- order, in the Supabase SQL editor.
-- =====================================================================

grant select, insert on public.shop_claim_requests to authenticated;

create policy "shop_claim_requests: requester manages own" on public.shop_claim_requests
  for all using (auth.uid() = requester_id);
