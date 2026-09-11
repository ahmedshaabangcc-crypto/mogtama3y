-- =====================================================================
-- Migration 0004 — let a union president/board member approve or
-- reject pending join requests. Run after 0002 and 0003, in order,
-- in the Supabase SQL editor.
--
-- union_members has no UPDATE policy at all (see 0003's notes on the
-- default-deny baseline), and reviewing someone else's membership row
-- is exactly the kind of action that should go through a checked
-- function rather than a blanket "building members can update" policy
-- — this verifies the caller is actually a verified president/board
-- member of THAT building before touching the row.
-- =====================================================================

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
end;
$$;

grant execute on function public.review_union_member(uuid, boolean) to authenticated;
