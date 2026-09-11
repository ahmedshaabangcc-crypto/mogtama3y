-- =====================================================================
-- Migration 0010 — jobs board: real postings + applications.
-- job_postings/job_applications had RLS enabled with no policies and
-- no grants (same default-deny baseline as everything else). Run
-- after 0002-0009, in order, in the Supabase SQL editor.
-- =====================================================================

grant select, insert, update on public.job_postings to authenticated;
grant select, insert on public.job_applications to authenticated;

create policy "job_postings: public read active" on public.job_postings
  for select using (is_active = true);

create policy "job_postings: poster manages own" on public.job_postings
  for all using (auth.uid() = poster_id);

create policy "job_applications: applicant manages own" on public.job_applications
  for all using (auth.uid() = applicant_id);
