-- =====================================================================
-- Migration 0105 — keep pg_cron's run history small (Disk IO, 2026-10-30).
--
-- cron.job_run_details gets a row for every run — the prayer reminders
-- alone run every minute (1 440 rows a day) — and nothing ever deleted
-- them (31k rows by now). A nightly job keeps the last 3 days.
-- Run after 0104. Safe to re-run (cron.schedule replaces a job by name).
-- =====================================================================

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    return;
  end if;
  execute $sql$select cron.schedule('purge-cron-history', '20 2 * * *',
    $job$delete from cron.job_run_details where end_time < now() - interval '3 days'$job$)$sql$;
  execute $sql$delete from cron.job_run_details where end_time < now() - interval '3 days'$sql$;
exception when others then
  raise notice 'could not schedule purge-cron-history: %', sqlerrm;
end;
$$;
