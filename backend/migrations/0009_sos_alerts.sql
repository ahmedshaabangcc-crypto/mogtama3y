-- =====================================================================
-- Migration 0009 — SOS emergency alerts, scoped to the triggerer's own
-- unit/building. Run after 0002-0008, in order, in the Supabase SQL
-- editor. Includes the GRANT alongside the RLS policies this time
-- (see 0007's postmortem — RLS alone is not enough on this project),
-- and reuses is_verified_member_of() from 0008 rather than a raw
-- correlated subquery, to avoid the same recursion class of bug.
-- =====================================================================

grant select, insert, update on public.sos_alerts to authenticated;

create policy "sos_alerts: view own or same building" on public.sos_alerts
  for select using (
    auth.uid() = triggered_by
    or public.is_verified_member_of((select building_id from public.units where id = sos_alerts.unit_id))
  );

create policy "sos_alerts: member triggers for own unit" on public.sos_alerts
  for insert with check (
    auth.uid() = triggered_by
    and exists (
      select 1 from public.union_members m
      where m.user_id = auth.uid() and m.unit_id = sos_alerts.unit_id
    )
  );

create policy "sos_alerts: triggerer can update own (e.g. cancel)" on public.sos_alerts
  for update using (auth.uid() = triggered_by) with check (auth.uid() = triggered_by);
