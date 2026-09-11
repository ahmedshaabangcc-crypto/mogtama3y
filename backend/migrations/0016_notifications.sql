-- =====================================================================
-- Migration 0016 — real notifications, populated by actual app events
-- rather than sitting empty forever. Had RLS enabled with no policies
-- and no grants. Run after 0002-0015, in order, in the Supabase SQL
-- editor.
--
-- No INSERT policy is added for the `authenticated` role on purpose —
-- notifications are only ever created from inside the existing
-- SECURITY DEFINER functions below (which bypass RLS as their owner),
-- never directly by a client, so one user can't forge a notification
-- to another.
-- =====================================================================

grant select, update on public.notifications to authenticated;

create policy "notifications: user manages own" on public.notifications
  for all using (auth.uid() = user_id);

-- ---- extend review_union_member() to notify the applicant ----

create or replace function public.review_union_member(
  p_member_id uuid,
  p_approve boolean
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_member record;
  v_is_authorized boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_member from public.union_members where id = p_member_id;
  if not found then
    raise exception 'الطلب غير موجود';
  end if;

  select exists(
    select 1 from public.union_members m
    where m.building_id = v_member.building_id
      and m.user_id = auth.uid()
      and m.status = 'verified'
      and m.role in ('president', 'board_member')
  ) into v_is_authorized;

  if not v_is_authorized then
    raise exception 'غير مصرح لك بمراجعة طلبات الانضمام لهذه العمارة';
  end if;

  update public.union_members
  set status = case when p_approve then 'verified'::union_member_status else 'rejected'::union_member_status end,
      verified_by = auth.uid(),
      verified_at = now()
  where id = p_member_id;

  insert into public.notifications (user_id, title, body)
  values (
    v_member.user_id,
    case when p_approve then 'تم قبول طلب انضمامك' else 'تم رفض طلب انضمامك' end,
    case when p_approve then 'تهانينا! تمت الموافقة على طلب انضمامك لاتحاد الملاك.'
         else 'للأسف تم رفض طلب انضمامك لاتحاد الملاك، تواصل مع رئيس الاتحاد لمزيد من التفاصيل.' end
  );
end;
$$;

-- ---- extend create_union_due() to notify every affected resident ----

create or replace function public.create_union_due(
  p_period_label text,
  p_amount numeric,
  p_due_date date
) returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_is_authorized boolean;
  v_count integer;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select building_id into v_building_id from public.union_members
    where user_id = auth.uid() and status = 'verified' and role in ('president', 'board_member')
    limit 1;

  if v_building_id is null then
    raise exception 'غير مصرح لك بإصدار مستحقات صيانة';
  end if;

  insert into public.union_dues (building_id, unit_id, period_label, amount, due_date)
  select v_building_id, u.id, p_period_label, p_amount, p_due_date
  from public.units u
  where u.building_id = v_building_id;

  get diagnostics v_count = row_count;

  insert into public.notifications (user_id, title, body)
  select m.user_id,
         'مستحق صيانة جديد',
         p_period_label || ' - ' || p_amount || ' ج.م، تاريخ الاستحقاق ' || p_due_date
  from public.union_members m
  where m.building_id = v_building_id and m.status = 'verified';

  return v_count;
end;
$$;
