-- =====================================================================
-- Migration 0035 — real buyer/seller chat for سوق المستعمل.
--
-- Ahmed's call after the fake-escrow/chat cleanup (item_details_screen
-- had a dead 'محادثة آمنة مع الجار' button with no backing at all): a
-- real phone-number contact is fine as long as there's also a real
-- chat between buyer and seller. This adds that chat.
--
-- A "conversation" is just (listing_id, buyer_id) — no separate
-- conversations table needed. The seller is always derivable as
-- marketplace_listings.seller_id, so a listing can have many buyer
-- conversations but each buyer only ever has one thread per listing.
-- =====================================================================

create table public.marketplace_messages (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.marketplace_listings(id) on delete cascade,
  buyer_id uuid not null references public.profiles(id),
  sender_id uuid not null references public.profiles(id),
  body text not null,
  created_at timestamptz not null default now()
);

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
