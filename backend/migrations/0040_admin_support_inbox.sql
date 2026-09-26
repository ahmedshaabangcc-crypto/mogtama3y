-- =====================================================================
-- Migration 0040 — support tickets actually reach someone, and the
-- admin panel can see who it is reviewing.
--
-- * support_tickets were insert-only: users filed them (support screen,
--   and now real-estate listing reports) but nothing in the app could
--   read them. The super admin can now list them and reply; the reply
--   is delivered to the user as an in-app notification and the ticket
--   is marked resolved.
-- * profiles had no super-admin read policy, so every requester name
--   embedded in the admin panel (shop claims, token top-ups, disputes)
--   silently came back null unless the admin happened to share a
--   building with that user.
--
-- Run after 0039, in order, in the Supabase SQL editor.
-- =====================================================================

create policy "profiles: super_admin views all" on public.profiles
  for select using (public.is_super_admin());

create policy "support_tickets: super_admin views all" on public.support_tickets
  for select using (public.is_super_admin());

create or replace function public.resolve_support_ticket(p_ticket_id uuid, p_reply text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_ticket record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالرد على التذاكر';
  end if;
  if p_reply is null or length(trim(p_reply)) = 0 then
    raise exception 'اكتب الرد أولاً';
  end if;

  select * into v_ticket from public.support_tickets where id = p_ticket_id for update;
  if not found then
    raise exception 'التذكرة غير موجودة';
  end if;
  if v_ticket.status in ('resolved', 'closed') then
    raise exception 'تم الرد على هذه التذكرة بالفعل';
  end if;

  update public.support_tickets set status = 'resolved' where id = p_ticket_id;

  insert into public.notifications (user_id, title, body)
  values (v_ticket.user_id, 'رد الدعم على: ' || v_ticket.subject, trim(p_reply));
end;
$$;

revoke execute on function public.resolve_support_ticket(uuid, text) from public, anon;
grant execute on function public.resolve_support_ticket(uuid, text) to authenticated;
