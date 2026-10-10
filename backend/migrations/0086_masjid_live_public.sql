-- =====================================================================
-- Migration 0086 — «دروس أونلاين» open to everyone on the app.
--
-- Owner decision: any signed-in user can watch a lesson, not just the
-- mosque's members. New lessons default to 'public' (the mosque can still
-- pick «لأعضاء المسجد»), and the live/upcoming feed now lists public
-- lessons from every mosque — nearby and the caller's own mosques first.
-- Safe to re-run.
-- =====================================================================

alter table public.mosque_live_sessions alter column visibility set default 'public';

create or replace function public.masjid_live_feed(
  p_lat double precision default null, p_lng double precision default null, p_km double precision default 10, p_limit int default 20
) returns setof jsonb
language sql stable security definer set search_path = public as $$
  with box as (
    select least(greatest(coalesce(p_km, 10), 0.5), 50) as km
  ), ms as (
    select m.id, m.name,
           case when p_lat is not null and p_lng is not null
                then 111.195 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) end as dist,
           auth.uid() is not null and (
             exists (select 1 from public.mosque_members x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_follows x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_admins x where x.mosque_id = m.id and x.user_id = auth.uid())) as mine
    from public.mosques m, box
    where m.id in (select s.mosque_id from public.mosque_live_sessions s where s.status in ('scheduled', 'live'))
      and ((p_lat is not null and p_lng is not null
            and m.lat between p_lat - box.km / 111.0 and p_lat + box.km / 111.0
            and m.lng between p_lng - box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2))
                          and p_lng + box.km / (111.0 * greatest(cos(radians(p_lat)), 0.2)))
           or (auth.uid() is not null and (
             exists (select 1 from public.mosque_members x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_follows x where x.mosque_id = m.id and x.user_id = auth.uid())
             or exists (select 1 from public.mosque_admins x where x.mosque_id = m.id and x.user_id = auth.uid())))
           or m.id in (select s2.mosque_id from public.mosque_live_sessions s2
                       where s2.visibility = 'public' and s2.status in ('scheduled', 'live')))
  )
  select public._masjid_live_json(s, ms.name) || jsonb_build_object(
           'distance_km', ms.dist, 'my_mosque', ms.mine,
           'can_join', auth.uid() is not null,
           'is_host', public.masjid_can(s.mosque_id, 'lessons'))
  from public.mosque_live_sessions s
  join ms on ms.id = s.mosque_id
  where s.status in ('scheduled', 'live')
    and not public._masjid_live_stale(s)
    and (s.status = 'live' or s.scheduled_at < now() + interval '7 days')
    and (s.visibility = 'public'
         or (auth.uid() is not null and (public.masjid_is_member(s.mosque_id) or public.masjid_can(s.mosque_id, 'lessons'))))
  order by (s.status = 'live') desc, ms.mine desc, (ms.dist is not null and ms.dist <= (select km from box)) desc, s.scheduled_at, ms.dist nulls last
  limit least(greatest(coalesce(p_limit, 20), 1), 50);
$$;

revoke execute on function public.masjid_live_feed(double precision, double precision, double precision, int) from public;
grant execute on function public.masjid_live_feed(double precision, double precision, double precision, int) to anon, authenticated;
