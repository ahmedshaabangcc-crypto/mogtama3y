-- =====================================================================
-- Migration 0030 — real union financial report.
-- financial_report_screen.dart was reachable from union_dashboard_screen
-- (twice) and showed a 100% fabricated "official audited financial
-- document": invented collection totals, invented expense ledger with
-- fake invoice numbers, invented board-member names with fake digital
-- signature IDs, and a fake municipal registration number — while
-- naming a fake building ("برج الياسمين"). This is the same trust bug
-- class as 0029 (fetch_building_posts) applied to money specifically.
--
-- union_financial_reports / union_expense_items already existed in
-- schema.sql (RLS enabled by the baseline loop, zero policies, zero
-- grants) but nothing ever wired them. This migration adds read-only
-- access scoped to verified members of the report's building — reports
-- themselves are entered by the union president/board through Supabase
-- directly for now; no in-app authoring UI exists yet.
-- =====================================================================

grant select on public.union_financial_reports to authenticated;
grant select on public.union_expense_items to authenticated;

create policy "union_financial_reports: building members read" on public.union_financial_reports
  for select using (public.is_verified_member_of(building_id));

create policy "union_expense_items: building members read" on public.union_expense_items
  for select using (
    exists (
      select 1 from public.union_financial_reports r
      where r.id = union_expense_items.report_id
      and public.is_verified_member_of(r.building_id)
    )
  );
