-- =====================================================================
-- Migration 0005 — lost & found, scoped to a resident's own building.
-- lost_found_items had RLS enabled with no policies (default deny),
-- same as every other table not covered in 0002/0003/0004. Run this
-- after 0002, 0003, and 0004, in order, in the Supabase SQL editor.
-- =====================================================================

create policy "lost_found_items: building members can view" on public.lost_found_items
  for select using (
    exists (
      select 1 from public.union_members m
      where m.building_id = lost_found_items.building_id
        and m.user_id = auth.uid()
        and m.status = 'verified'
    )
  );

create policy "lost_found_items: verified member reports for own building" on public.lost_found_items
  for insert with check (
    auth.uid() = reporter_id
    and exists (
      select 1 from public.union_members m
      where m.building_id = lost_found_items.building_id
        and m.user_id = auth.uid()
        and m.status = 'verified'
    )
  );

create policy "lost_found_items: reporter can mark resolved" on public.lost_found_items
  for update using (auth.uid() = reporter_id)
  with check (auth.uid() = reporter_id);
