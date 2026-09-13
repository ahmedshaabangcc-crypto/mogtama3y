-- =====================================================================
-- Migration 0036 — real job-application review loop.
--
-- job_applications has existed since the schema was written, and
-- applying already worked (JobsService.apply() inserted a real row),
-- but nothing anywhere ever read it back: no employer screen existed
-- for it (job_applicants_dashboard_screen.dart was a fully mocked ATS
-- UI with fabricated names/CVs/ratings, unreachable from anywhere real),
-- and job_application_confirm_screen.dart told every applicant
-- "you'll be notified when reviewed" — a promise nothing could ever
-- fulfill, since there was no reviewing mechanism and no notification
-- at all. This wires the other half for real: employers see actual
-- applicants and move them through the real application_status
-- pipeline, and the applicant gets a real notification on every change.
-- =====================================================================

grant select on public.job_applications to authenticated;

create policy "job_applications: applicant views own" on public.job_applications
  for select using (auth.uid() = applicant_id);

create policy "job_applications: poster views applicants to own jobs" on public.job_applications
  for select using (
    exists (select 1 from public.job_postings p where p.id = job_applications.job_id and p.poster_id = auth.uid())
  );

create or replace function public.apply_to_job(p_job_id uuid, p_intro_message text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_poster_id uuid;
  v_title text;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select poster_id, title into v_poster_id, v_title from public.job_postings where id = p_job_id;
  if v_poster_id is null then
    raise exception 'الوظيفة غير موجودة';
  end if;
  if v_poster_id = auth.uid() then
    raise exception 'لا يمكنك التقديم على وظيفتك الخاصة';
  end if;

  insert into public.job_applications (job_id, applicant_id, intro_message)
  values (p_job_id, auth.uid(), nullif(trim(coalesce(p_intro_message, '')), ''))
  on conflict (job_id, applicant_id) do update set intro_message = excluded.intro_message
  returning id into v_id;

  insert into public.notifications (user_id, title, body)
  values (v_poster_id, 'طلب توظيف جديد', 'تقدّم أحد الجيران لوظيفة "' || v_title || '" — راجع طلبه من لوحة وظائفك.');

  return v_id;
end;
$$;

grant execute on function public.apply_to_job(uuid, text) to authenticated;

create or replace function public.review_job_application(p_application_id uuid, p_status text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_app record;
  v_status_label text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_status not in ('shortlisted', 'interview', 'offered', 'rejected', 'hired') then
    raise exception 'حالة غير صحيحة';
  end if;

  select ja.id, ja.applicant_id, jp.title, jp.poster_id
    into v_app
    from public.job_applications ja
    join public.job_postings jp on jp.id = ja.job_id
    where ja.id = p_application_id;

  if v_app is null then
    raise exception 'الطلب غير موجود';
  end if;
  if v_app.poster_id <> auth.uid() then
    raise exception 'غير مصرح لك بتحديث هذا الطلب';
  end if;

  update public.job_applications set status = p_status::application_status where id = p_application_id;

  v_status_label := case p_status
    when 'shortlisted' then 'تم ترشيح طلبك للمرحلة التالية'
    when 'interview' then 'تمت دعوتك لمقابلة عمل'
    when 'offered' then 'حصلت على عرض عمل!'
    when 'rejected' then 'تم رفض طلبك'
    when 'hired' then 'تهانينا! تم قبولك للوظيفة'
    else p_status
  end;

  insert into public.notifications (user_id, title, body)
  values (v_app.applicant_id, v_status_label, 'تحديث على طلبك لوظيفة "' || v_app.title || '"');
end;
$$;

grant execute on function public.review_job_application(uuid, text) to authenticated;
