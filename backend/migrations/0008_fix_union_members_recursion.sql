-- =====================================================================
-- Migration 0008 — fix "infinite recursion detected in policy for
-- relation union_members" (Postgres error 42P17), found live-testing
-- the visitor pass flow on 2026-09-11.
--
-- The "building members can view roster" policy from 0003 queries
-- union_members from *inside* union_members' own USING clause. Any
-- query that touches union_members — including from another table's
-- policy, like lost_found_items' or visitor_passes' insert checks —
-- forces Postgres to re-evaluate union_members' own RLS policies,
-- which re-runs that same self-referencing subquery, forever.
--
-- Fix: move the "am I a verified member of this building" check into
-- a SECURITY DEFINER function. Functions created by the table owner
-- bypass RLS entirely when they query the table internally, so the
-- check no longer triggers a fresh policy evaluation on union_members.
-- This is the standard Postgres/Supabase pattern for self-referencing
-- "team roster" policies — run after 0002-0007, in order.
-- =====================================================================

create or replace function public.is_verified_member_of(p_building_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.union_members m
    where m.building_id = p_building_id
      and m.user_id = auth.uid()
      and m.status = 'verified'
  );
$$;

grant execute on function public.is_verified_member_of(uuid) to authenticated;

drop policy if exists "union_members: building members can view roster" on public.union_members;

create policy "union_members: building members can view roster" on public.union_members
  for select using (public.is_verified_member_of(union_members.building_id));
