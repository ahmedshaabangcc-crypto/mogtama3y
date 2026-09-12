-- =====================================================================
-- Migration 0031 — real periodic-maintenance schedule.
-- union_dashboard_screen.dart's whole top section was fully mocked with
-- no backing schema at all: a fake "الجمعية العمومية نشطة" claim, a
-- fake building code/unit count, a fake treasury balance with a fake
-- month-over-month trend, a fake live proposal card showing invented
-- vote percentages and "quorum met" with buttons that did nothing, a
-- fake upcoming-maintenance schedule (two hardcoded vendor visits), and
-- a fake board announcement from a made-up board member. This migration
-- adds the one piece with no existing table anywhere — a real
-- maintenance schedule the board can post to and members can read.
-- The treasury card is wired to the existing union_financial_reports
-- (0030) instead of new schema; the fake proposal card and board
-- message are removed outright since board_decisions (0020) is already
-- the real version of "the board proposes something, members vote."
-- =====================================================================

create table public.union_maintenance_schedule (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  title text not null,
  vendor text,
  scheduled_for timestamptz not null,
  is_urgent boolean not null default false,
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now()
);

grant select, insert, delete on public.union_maintenance_schedule to authenticated;

create policy "union_maintenance_schedule: building members read" on public.union_maintenance_schedule
  for select using (public.is_verified_member_of(building_id));

create policy "union_maintenance_schedule: board schedules" on public.union_maintenance_schedule
  for insert with check (
    auth.uid() = created_by
    and exists (
      select 1 from public.union_members m
      where m.building_id = union_maintenance_schedule.building_id
        and m.user_id = auth.uid() and m.status = 'verified' and m.role in ('president', 'board_member')
    )
  );

create policy "union_maintenance_schedule: board removes" on public.union_maintenance_schedule
  for delete using (
    exists (
      select 1 from public.union_members m
      where m.building_id = union_maintenance_schedule.building_id
        and m.user_id = auth.uid() and m.status = 'verified' and m.role in ('president', 'board_member')
    )
  );
