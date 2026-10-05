-- =====================================================================
-- 0060 — Community reports ("بلّغ عن مشكلة").
--
-- Residents report street problems (trash, potholes, encroachments…)
-- with photos and a location. The مُجتمعي team routes each report to the
-- responsible body by hand (phase 1) and updates its status; reporters and
-- everyone who tapped "وأنا كمان" get a notification on every change.
-- مُجتمعي is not a government body — it relays and follows up.
--
-- Access: all reads and writes go through the RPCs below (the tables are
-- not exposed), so a reporter who chose to hide their identity is never
-- revealed publicly, and hidden (abusive) reports never leak.
-- =====================================================================

create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category text not null check (category in
    ('نظافة وقمامة', 'إشغالات طريق', 'حفر ورصف', 'مياه وصرف', 'إنارة وكهرباء',
     'مخالفات بناء', 'مرور وتوكتوك', 'حيوانات ضالة', 'مخالفة خطرة', 'مخالفة شديدة الخطورة', 'أخرى')),
  description text not null check (length(trim(description)) between 5 and 1000),
  photos text[] not null default '{}' check (cardinality(photos) <= 4),
  lat double precision not null check (lat between 21 and 32.5),
  lng double precision not null check (lng between 24 and 37.5),
  governorate text,
  district text,
  status text not null default 'new' check (status in ('new', 'reviewing', 'routed', 'resolved', 'rejected')),
  status_note text,
  routed_to text,
  routed_note text,          -- admin-only: how it was sent (e.g. the district's WhatsApp line)
  routed_at timestamptz,
  resolved_at timestamptz,
  after_photo text,
  votes_count int not null default 0,
  hide_identity boolean not null default false,
  is_hidden boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists reports_lat_lng on public.reports (lat, lng);
create index if not exists reports_status_created on public.reports (status, created_at desc);
create index if not exists reports_user_created on public.reports (user_id, created_at desc);

create table if not exists public.report_votes (
  report_id uuid not null references public.reports(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (report_id, user_id)
);

create table if not exists public.report_events (
  id uuid primary key default gen_random_uuid(),
  report_id uuid not null references public.reports(id) on delete cascade,
  status text not null,
  note text,
  actor_id uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now()
);
create index if not exists report_events_report on public.report_events (report_id, created_at);

alter table public.reports enable row level security;
alter table public.report_votes enable row level security;
alter table public.report_events enable row level security;
revoke all on public.reports, public.report_votes, public.report_events from anon, authenticated;

-- Arabic label of a status, for notifications.
create or replace function public.report_status_label(p_status text) returns text
language sql immutable as $$
  select case p_status
    when 'new' then 'جديد'
    when 'reviewing' then 'قيد المراجعة'
    when 'routed' then 'اتبعت للجهة المختصة'
    when 'resolved' then 'اتحلّ'
    when 'rejected' then 'مرفوض'
    else p_status end;
$$;

-- The public shape of a report (identity masked when asked, admin notes out).
create or replace function public.report_public_json(r public.reports) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'id', r.id, 'category', r.category, 'description', r.description, 'photos', to_jsonb(r.photos),
    'lat', r.lat, 'lng', r.lng, 'governorate', r.governorate, 'district', r.district,
    'status', r.status, 'status_note', r.status_note, 'routed_to', r.routed_to,
    'routed_at', r.routed_at, 'resolved_at', r.resolved_at, 'after_photo', r.after_photo,
    'votes_count', r.votes_count, 'created_at', r.created_at,
    'reporter', case when r.hide_identity then null else (select full_name from public.profiles where id = r.user_id) end,
    'is_mine', r.user_id = auth.uid(),
    'voted', exists (select 1 from public.report_votes v where v.report_id = r.id and v.user_id = auth.uid())
  );
$$;
revoke execute on function public.report_public_json(public.reports) from public, anon, authenticated;

-- ---------------------------------------------------------------- submit
create or replace function public.submit_report(
  p_category text, p_description text, p_photos text[], p_lat double precision, p_lng double precision,
  p_governorate text default null, p_district text default null, p_hide_identity boolean default false
) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول عشان تبلّغ'; end if;
  if (select count(*) from public.reports where user_id = auth.uid() and created_at > now() - interval '1 day') >= 5 then
    raise exception 'وصلت لحد 5 بلاغات في اليوم، كمّل بكرة';
  end if;
  insert into public.reports (user_id, category, description, photos, lat, lng, governorate, district, hide_identity)
  values (auth.uid(), p_category, trim(p_description), coalesce(p_photos, '{}'), p_lat, p_lng,
          nullif(trim(coalesce(p_governorate, '')), ''), nullif(trim(coalesce(p_district, '')), ''), coalesce(p_hide_identity, false))
  returning id into v_id;
  insert into public.report_events (report_id, status, actor_id) values (v_id, 'new', auth.uid());
  return v_id;
end;
$$;

-- ---------------------------------------------------------------- read
create or replace function public.list_reports(
  p_lat double precision default null, p_lng double precision default null, p_km double precision default 5,
  p_category text default null, p_status text default null, p_mine boolean default false, p_limit int default 50
) returns setof jsonb
language sql stable security definer set search_path = public as $$
  select public.report_public_json(r)
  from public.reports r
  where not r.is_hidden
    and (not coalesce(p_mine, false) or r.user_id = auth.uid())
    and (p_category is null or r.category = p_category)
    and (p_status is null or r.status = p_status)
    and (p_lat is null or p_lng is null or coalesce(p_mine, false) or (
      r.lat between p_lat - least(greatest(p_km, 0.5), 50) / 111.0 and p_lat + least(greatest(p_km, 0.5), 50) / 111.0
      and r.lng between p_lng - least(greatest(p_km, 0.5), 50) / (111.0 * greatest(cos(radians(p_lat)), 0.2))
                    and p_lng + least(greatest(p_km, 0.5), 50) / (111.0 * greatest(cos(radians(p_lat)), 0.2))))
  order by r.created_at desc
  limit least(greatest(coalesce(p_limit, 50), 1), 200);
$$;

create or replace function public.get_report(p_id uuid) returns jsonb
language sql stable security definer set search_path = public as $$
  select public.report_public_json(r) || jsonb_build_object('events', coalesce((
    select jsonb_agg(jsonb_build_object('status', e.status, 'note', e.note, 'at', e.created_at) order by e.created_at)
    from public.report_events e where e.report_id = r.id), '[]'::jsonb))
  from public.reports r
  where r.id = p_id and (not r.is_hidden or public.is_super_admin());
$$;

-- ---------------------------------------------------------------- vote
create or replace function public.toggle_report_vote(p_id uuid) returns boolean
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if not exists (select 1 from public.reports where id = p_id and not is_hidden) then raise exception 'البلاغ مش موجود'; end if;
  if exists (select 1 from public.report_votes where report_id = p_id and user_id = auth.uid()) then
    delete from public.report_votes where report_id = p_id and user_id = auth.uid();
    update public.reports set votes_count = greatest(votes_count - 1, 0) where id = p_id;
    return false;
  end if;
  insert into public.report_votes (report_id, user_id) values (p_id, auth.uid());
  update public.reports set votes_count = votes_count + 1 where id = p_id;
  return true;
end;
$$;

-- ---------------------------------------------------------------- admin
create or replace function public.admin_list_reports(
  p_status text default null, p_category text default null, p_governorate text default null, p_limit int default 200
) returns setof jsonb
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select public.report_public_json(r) || jsonb_build_object(
      'routed_note', r.routed_note, 'is_hidden', r.is_hidden, 'hide_identity', r.hide_identity,
      'reporter_admin', (select jsonb_build_object('name', p.full_name, 'phone', p.phone) from public.profiles p where p.id = r.user_id))
    from public.reports r
    where (p_status is null or r.status = p_status)
      and (p_category is null or r.category = p_category)
      and (p_governorate is null or r.governorate = p_governorate)
    order by (r.status in ('new', 'reviewing')) desc, r.votes_count desc, r.created_at desc
    limit least(greatest(coalesce(p_limit, 200), 1), 500);
end;
$$;

create or replace function public.admin_update_report(
  p_id uuid, p_status text, p_status_note text default null, p_routed_to text default null,
  p_routed_note text default null, p_after_photo text default null, p_is_hidden boolean default null
) returns void
language plpgsql security definer set search_path = public as $$
declare
  r public.reports;
  v_changed boolean;
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  if p_status not in ('new', 'reviewing', 'routed', 'resolved', 'rejected') then raise exception 'حالة غير معروفة'; end if;
  select * into r from public.reports where id = p_id for update;
  if not found then raise exception 'البلاغ مش موجود'; end if;
  v_changed := r.status is distinct from p_status;
  update public.reports set
    status = p_status,
    status_note = coalesce(nullif(trim(coalesce(p_status_note, '')), ''), status_note),
    routed_to = coalesce(nullif(trim(coalesce(p_routed_to, '')), ''), routed_to),
    routed_note = coalesce(nullif(trim(coalesce(p_routed_note, '')), ''), routed_note),
    routed_at = case when p_status = 'routed' and routed_at is null then now() else routed_at end,
    resolved_at = case when p_status = 'resolved' then coalesce(resolved_at, now()) else null end,
    after_photo = coalesce(nullif(trim(coalesce(p_after_photo, '')), ''), after_photo),
    is_hidden = coalesce(p_is_hidden, is_hidden),
    updated_at = now()
  where id = p_id;
  if v_changed then
    insert into public.report_events (report_id, status, note, actor_id)
    values (p_id, p_status, nullif(trim(coalesce(p_status_note, '')), ''), auth.uid());
    -- Tell the reporter and everyone who voted (push goes out via notifications_push).
    insert into public.notifications (user_id, title, body, deep_link)
    select distinct u, 'تحديث على بلاغ ' || r.category,
           'الحالة: ' || public.report_status_label(p_status)
             || case when p_status = 'routed' and coalesce(nullif(trim(coalesce(p_routed_to, '')), ''), r.routed_to) is not null
                     then ' — ' || coalesce(nullif(trim(coalesce(p_routed_to, '')), ''), r.routed_to) else '' end,
           '/#/r/' || p_id
    from (select r.user_id as u union select v.user_id from public.report_votes v where v.report_id = p_id) t;
  end if;
end;
$$;

revoke execute on function public.submit_report(text, text, text[], double precision, double precision, text, text, boolean) from public, anon;
revoke execute on function public.toggle_report_vote(uuid) from public, anon;
revoke execute on function public.admin_list_reports(text, text, text, int) from public, anon;
revoke execute on function public.admin_update_report(uuid, text, text, text, text, text, boolean) from public, anon;
grant execute on function public.submit_report(text, text, text[], double precision, double precision, text, text, boolean) to authenticated;
grant execute on function public.toggle_report_vote(uuid) to authenticated;
grant execute on function public.admin_list_reports(text, text, text, int) to authenticated;
grant execute on function public.admin_update_report(uuid, text, text, text, text, text, boolean) to authenticated;
grant execute on function public.list_reports(double precision, double precision, double precision, text, text, boolean, int) to anon, authenticated;
grant execute on function public.get_report(uuid) to anon, authenticated;
