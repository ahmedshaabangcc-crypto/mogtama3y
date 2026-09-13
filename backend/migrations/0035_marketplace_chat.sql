-- =====================================================================
-- Migration 0035 — real buyer/seller chat for سوق المستعمل.
--
-- Ahmed's call after the fake-escrow/chat cleanup (item_details_screen
-- had a dead 'محادثة آمنة مع الجار' button with no backing at all): a
-- real phone-number contact is fine as long as there's also a real
-- chat between buyer and seller. This adds that chat.
--
-- CORRECTED: `marketplace_messages` already existed in schema.sql from
-- the very start of the project (never wired to anything), with a
-- shape that can't support a private 1:1 thread — no buyer_id column
-- at all, just (id, listing_id, sender_id, body, created_at). The
-- first version of this migration tried to CREATE TABLE it fresh and
-- collided outright ("relation already exists"), so nothing in it
-- actually applied. This version adds what's missing to the existing
-- table instead.
--
-- A "conversation" is (listing_id, buyer_id) — no separate
-- conversations table needed. The seller is always derivable as
-- marketplace_listings.seller_id, so a listing can have many buyer
-- conversations but each buyer only ever has one thread per listing.
-- =====================================================================

-- The table has never been written to by any part of the app before
-- this feature (confirmed: nothing anywhere calls
-- .from('marketplace_messages')), so it's empty — safe to add a NOT
-- NULL column with no default.
alter table public.marketplace_messages
  add column if not exists buyer_id uuid references public.profiles(id);

alter table public.marketplace_messages
  alter column buyer_id set not null;

grant select, insert on public.marketplace_messages to authenticated;

create policy "marketplace_messages: buyer or seller can view" on public.marketplace_messages
  for select using (
    auth.uid() = buyer_id
    or auth.uid() = (select seller_id from public.marketplace_listings where id = listing_id)
  );

create policy "marketplace_messages: buyer or seller can send" on public.marketplace_messages
  for insert with check (
    auth.uid() = sender_id
    and (
      auth.uid() = buyer_id
      or auth.uid() = (select seller_id from public.marketplace_listings where id = listing_id)
    )
  );

-- One row per (listing, buyer) conversation the caller is part of
-- (either as the buyer or as the listing's seller), with the other
-- party's name and the last message — powers the "المحادثات" inbox.
-- A plain function rather than a PostgREST embed: marketplace_messages
-- has two FKs to profiles (buyer_id, sender_id), same ambiguity class
-- fixed everywhere else today, sidestepped here with explicit joins.
create or replace function public.fetch_marketplace_conversations()
returns table (
  listing_id uuid, buyer_id uuid, listing_title text,
  other_party_name text, last_message text, last_message_at timestamptz
)
language sql
stable
security invoker
set search_path = public
as $$
  select distinct on (m.listing_id, m.buyer_id)
    m.listing_id, m.buyer_id, l.title,
    case when auth.uid() = m.buyer_id then seller_p.full_name else buyer_p.full_name end,
    m.body, m.created_at
  from public.marketplace_messages m
  join public.marketplace_listings l on l.id = m.listing_id
  join public.profiles buyer_p on buyer_p.id = m.buyer_id
  join public.profiles seller_p on seller_p.id = l.seller_id
  where auth.uid() = m.buyer_id or auth.uid() = l.seller_id
  order by m.listing_id, m.buyer_id, m.created_at desc;
$$;

grant execute on function public.fetch_marketplace_conversations() to authenticated;
