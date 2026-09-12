-- =====================================================================
-- Migration 0025 — real building-wide neighbor chat. No schema existed
-- for this; chat_list_screen.dart was a unified inbox mockup mixing
-- four unrelated fake conversation types (technician, marketplace
-- seller, union board, shop delivery) with zero backing. Run after
-- 0002-0024, in order, in the Supabase SQL editor.
--
-- Scope: this migration only builds the one genuinely new thing — a
-- flat, building-scoped group chat any verified member can read and
-- post to (reuses is_verified_member_of() from 0008, no new helper
-- needed). The technician 1:1 threads from 0022's maintenance_messages
-- are real too and get folded into the same inbox screen, but that
-- table needs no changes here. The marketplace-seller and
-- shop-delivery "chats" in the old mock still have no backing schema
-- and are dropped from the inbox rather than carried over fake.
-- =====================================================================

create table public.building_chat_messages (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  sender_id uuid not null references public.profiles(id),
  body text not null,
  created_at timestamptz not null default now()
);

grant select, insert on public.building_chat_messages to authenticated;

create policy "building_chat_messages: building members read" on public.building_chat_messages
  for select using (public.is_verified_member_of(building_id));

create policy "building_chat_messages: building members send" on public.building_chat_messages
  for insert with check (auth.uid() = sender_id and public.is_verified_member_of(building_id));
