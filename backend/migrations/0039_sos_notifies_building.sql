-- =====================================================================
-- Migration 0039 — an SOS alert actually reaches someone.
--
-- Until now sos_alerts rows were written and nothing ever read them: no
-- screen, no trigger, no notification — while the app told the user
-- their neighbours and the guard room had been alerted. This sends an
-- in-app notification (the existing notifications table / bell) to every
-- verified member of the building and every active guard, and another
-- when the alert is cancelled as a false alarm.
--
-- This is in-app only (no push/SMS yet): people see it the next time
-- they open مُجتمعي. The app's wording says exactly that and points to
-- the national emergency numbers for anything urgent.
--
-- Run after 0038, in order, in the Supabase SQL editor.
-- =====================================================================

create or replace function public.notify_building_of_sos() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_unit_number text;
  v_type_label text;
begin
  select u.building_id, u.unit_number into v_building_id, v_unit_number
  from public.units u where u.id = new.unit_id;

  if tg_op = 'INSERT' then
    v_type_label := case new.type
      when 'medical' then 'طارئ طبي'
      when 'fire' then 'حريق'
      when 'gas_electric' then 'تسرب غاز / كهرباء'
      when 'security' then 'طارئ أمني'
      else 'طارئ'
    end;

    insert into public.notifications (user_id, title, body)
    select recipient, '🚨 استغاثة من شقة ' || coalesce(v_unit_number, ''),
           v_type_label || ' — أحد جيرانك طلب المساعدة الآن من شقة ' || coalesce(v_unit_number, '') || '. إذا استطعت المساعدة توجّه فوراً، وفي الحالات الخطيرة اتصل بالإسعاف 123 أو المطافئ 180.'
    from (
      select m.user_id as recipient from public.union_members m
      where m.building_id = v_building_id and m.status = 'verified'
      union
      select g.user_id from public.building_guards g
      where g.building_id = v_building_id and g.is_active
    ) r
    where recipient <> new.triggered_by;

  elsif tg_op = 'UPDATE' and old.status = 'active' and new.status = 'false_alarm' then
    insert into public.notifications (user_id, title, body)
    select recipient, 'تم إلغاء الاستغاثة من شقة ' || coalesce(v_unit_number, ''),
           'قام صاحب الاستغاثة بإلغائها (إنذار غير مقصود). شكراً لاهتمامك.'
    from (
      select m.user_id as recipient from public.union_members m
      where m.building_id = v_building_id and m.status = 'verified'
      union
      select g.user_id from public.building_guards g
      where g.building_id = v_building_id and g.is_active
    ) r
    where recipient <> new.triggered_by;
  end if;

  return new;
end;
$$;

drop trigger if exists notify_building_of_sos on public.sos_alerts;
create trigger notify_building_of_sos
  after insert or update on public.sos_alerts
  for each row execute function public.notify_building_of_sos();
