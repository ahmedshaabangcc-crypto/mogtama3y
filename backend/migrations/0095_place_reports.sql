-- =====================================================================
-- Migration 0095 — «بلّغ عن محل غلط»: reports on directory places,
-- auto-hide, and the super-admin review queue.
--
--   * directory_places: + hidden (default false), hidden_by ('auto' |
--     'admin'), hidden_at. A hidden place is out of everything public:
--     the RLS read policy is now `not hidden` (the app's place page, dalil
--     via REST), and nearby_directory / nearby_services / search_directory
--     are redefined (latest bodies: 0058 / 0064 box scans, 0067 PostGIS
--     KNN where available) with an explicit `not d.hidden`.
--     private.dir_same_place (0094) skips hidden places too, so «ضيف محل»
--     / a merchant's shop never lands on a hidden row.
--   * directory_place_reports: who reported which place, why
--     (closed | wrong_location | wrong_info | duplicate | fake | other),
--     an optional note (≤ 500) and, for wrong_info, a suggested name /
--     phone / category. RLS on, no grants: only the RPCs below.
--   * report_directory_place(): signed-in, 10 reports a day per user,
--     one open report per user per place (reporting again returns the
--     open one). Super admins get a notification (at most one an hour
--     each).
--   * Auto-hide: when 3 distinct eligible reporters (account ≥ 3 days
--     old, or a verified phone — 0074) have an open closed / fake /
--     duplicate report on a place added by a user or imported from
--     OpenStreetMap (source user / osm), it is hidden right away.
--     Overture and merchant places are never auto-hidden — only an admin
--     hides them.
--   * Super admin: admin_list_place_reports, admin_resolve_place_report,
--     admin_update_directory_place, admin_set_place_hidden,
--     admin_delete_directory_place (user / osm places only). Resolving
--     thanks the reporters (one thank-you a day per user).
--
-- Run after 0094. Safe to re-run.
-- =====================================================================

-- ============================================================ columns

alter table public.directory_places add column if not exists hidden boolean not null default false;
alter table public.directory_places add column if not exists hidden_by text;
alter table public.directory_places add column if not exists hidden_at timestamptz;
alter table public.directory_places drop constraint if exists directory_places_hidden_by_valid;
alter table public.directory_places add constraint directory_places_hidden_by_valid
  check (hidden_by is null or hidden_by in ('auto', 'admin'));
-- Tiny: the admin's «hidden» list.
create index if not exists directory_places_hidden on public.directory_places (hidden_at desc) where hidden;

drop policy if exists "directory_places: public read" on public.directory_places;
create policy "directory_places: public read" on public.directory_places for select using (not hidden);

-- ============================================================ reports

create table if not exists public.directory_place_reports (
  id uuid primary key default gen_random_uuid(),
  place_id text not null references public.directory_places(id) on delete cascade,
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null check (reason in ('closed', 'wrong_location', 'wrong_info', 'duplicate', 'fake', 'other')),
  note text check (note is null or char_length(note) <= 500),
  suggestion jsonb,
  status text not null default 'open' check (status in ('open', 'resolved', 'dismissed')),
  created_at timestamptz not null default now(),
  resolved_by uuid references public.profiles(id) on delete set null,
  resolved_at timestamptz
);
create unique index if not exists directory_place_reports_one_open
  on public.directory_place_reports (place_id, reporter_id) where status = 'open';
create index if not exists directory_place_reports_reporter on public.directory_place_reports (reporter_id, created_at desc);
create index if not exists directory_place_reports_open on public.directory_place_reports (created_at desc) where status = 'open';
create index if not exists directory_place_reports_place on public.directory_place_reports (place_id, created_at desc);

alter table public.directory_place_reports enable row level security;
revoke all on public.directory_place_reports from public, anon, authenticated;

-- ============================================ public reads exclude hidden

-- 0058 box scan (+ not hidden).
create or replace function public.nearby_directory(
  p_lat double precision,
  p_lng double precision,
  p_km double precision default 3,
  p_category text default null,
  p_limit int default 50
) returns table (
  id text, name text, category text, phone text, whatsapp text, website text, social text,
  address text, lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  with box as (
    select least(greatest(coalesce(p_km, 3), 0.2), 30) / 111.0 as dlat,
           least(greatest(coalesce(p_km, 3), 0.2), 30) / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng
  )
  select d.id, d.name, d.category, d.phone, d.whatsapp, d.website, d.social, d.address, d.lat, d.lng, d.claimed_shop_id,
         111.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) as distance_km
  from public.directory_places d, box
  where d.lat between p_lat - box.dlat and p_lat + box.dlat
    and d.lng between p_lng - box.dlng and p_lng + box.dlng
    and (p_category is null or d.category = p_category)
    and not d.hidden
  order by distance_km, d.confidence desc nulls last
  limit least(greatest(coalesce(p_limit, 50), 1), 200);
$$;

-- 0058 (+ not hidden).
create or replace function public.search_directory(
  p_query text,
  p_lat double precision default null,
  p_lng double precision default null,
  p_limit int default 30
) returns table (
  id text, name text, category text, phone text, whatsapp text, address text,
  lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  select d.id, d.name, d.category, d.phone, d.whatsapp, d.address, d.lat, d.lng, d.claimed_shop_id,
         case when p_lat is null or p_lng is null then null
              else 111.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) end as distance_km
  from public.directory_places d
  where length(trim(coalesce(p_query, ''))) >= 2
    and d.name ilike '%' || replace(replace(trim(p_query), '%', ''), '_', '') || '%'
    and not d.hidden
  order by distance_km nulls last, d.confidence desc nulls last
  limit least(greatest(coalesce(p_limit, 30), 1), 100);
$$;

-- 0064 box scan (+ not hidden).
create or replace function public.nearby_services(
  p_lat double precision,
  p_lng double precision,
  p_trade text default null,
  p_km double precision default 10,
  p_limit int default 60
) returns table (
  id text, name text, trade text, phone text, whatsapp text, address text,
  lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  with box as (
    select least(greatest(coalesce(p_km, 10), 1), 60) / 111.0 as dlat,
           least(greatest(coalesce(p_km, 10), 1), 60) / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng
  )
  select d.id, d.name, d.trade, d.phone, d.whatsapp, d.address, d.lat, d.lng, d.claimed_shop_id,
         111.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) as distance_km
  from public.directory_places d, box
  where d.trade is not null
    and (p_trade is null or d.trade = p_trade)
    and d.lat between p_lat - box.dlat and p_lat + box.dlat
    and d.lng between p_lng - box.dlng and p_lng + box.dlng
    and not d.hidden
  order by (d.whatsapp is not null) desc, distance_km
  limit least(greatest(coalesce(p_limit, 60), 1), 150);
$$;

-- 0067 PostGIS KNN versions (+ not hidden), where PostGIS is installed
-- (production). The test harness keeps the box scans above.
do $$
begin
  if not exists (select 1 from pg_extension where extname = 'postgis') then
    return;
  end if;

  execute $sql$
    create or replace function public.nearby_directory(
      p_lat double precision, p_lng double precision, p_km double precision default 3,
      p_category text default null, p_limit int default 50
    ) returns table (
      id text, name text, category text, phone text, whatsapp text, website text, social text,
      address text, lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
    )
    language sql stable set search_path = public, extensions as $f$
      select d.id, d.name, d.category, d.phone, d.whatsapp, d.website, d.social, d.address, d.lat, d.lng, d.claimed_shop_id,
             extensions.st_distance(
               extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
               extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
             ) / 1000.0 as distance_km
      from public.directory_places d
      where (p_category is null or d.category = p_category)
        and not d.hidden
        and extensions.st_dwithin(
              extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
              extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography,
              least(greatest(coalesce(p_km, 3), 0.2), 30) * 1000)
      order by extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography
           operator(extensions.<->) extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
      limit least(greatest(coalesce(p_limit, 50), 1), 200);
    $f$
  $sql$;

  execute $sql$
    create or replace function public.nearby_services(
      p_lat double precision, p_lng double precision, p_trade text default null,
      p_km double precision default 10, p_limit int default 60
    ) returns table (
      id text, name text, trade text, phone text, whatsapp text, address text,
      lat double precision, lng double precision, claimed_shop_id uuid, distance_km double precision
    )
    language sql stable set search_path = public, extensions as $f$
      with near as (
        select d.id, d.name, d.trade, d.phone, d.whatsapp, d.address, d.lat, d.lng, d.claimed_shop_id,
               extensions.st_distance(
                 extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
                 extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
               ) / 1000.0 as distance_km
        from public.directory_places d
        where d.trade is not null
          and (p_trade is null or d.trade = p_trade)
          and not d.hidden
          and extensions.st_dwithin(
                extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography,
                extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography,
                least(greatest(coalesce(p_km, 10), 1), 60) * 1000)
        order by extensions.st_setsrid(extensions.st_makepoint(d.lng, d.lat), 4326)::extensions.geography
             operator(extensions.<->) extensions.st_setsrid(extensions.st_makepoint(p_lng, p_lat), 4326)::extensions.geography
        limit least(greatest(coalesce(p_limit, 60), 1), 150) * 3
      )
      -- WhatsApp-reachable first, within the nearest few hundred.
      select * from near order by (whatsapp is not null) desc, distance_km
      limit least(greatest(coalesce(p_limit, 60), 1), 150);
    $f$
  $sql$;
end;
$$;

grant execute on function public.nearby_directory(double precision, double precision, double precision, text, int) to anon, authenticated;
grant execute on function public.nearby_services(double precision, double precision, text, double precision, int) to anon, authenticated;
grant execute on function public.search_directory(text, double precision, double precision, int) to anon, authenticated;

-- 0094 (+ not hidden): adding / linking never lands on a hidden place.
create or replace function private.dir_same_place(p_name text, p_lat double precision, p_lng double precision, p_m double precision default 30)
returns text
language sql stable security definer set search_path = public as $$
  select d.id from public.directory_places d
  where d.lat between p_lat - p_m / 111195.0 and p_lat + p_m / 111195.0
    and d.lng between p_lng - p_m / (111195.0 * greatest(cos(radians(p_lat)), 0.2))
                  and p_lng + p_m / (111195.0 * greatest(cos(radians(p_lat)), 0.2))
    and 111195.0 * sqrt(power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)) <= p_m
    and not d.hidden
    and private.place_names_similar(d.name, p_name)
  order by power(d.lat - p_lat, 2) + power((d.lng - p_lng) * cos(radians(p_lat)), 2)
  limit 1
$$;
revoke execute on function private.dir_same_place(text, double precision, double precision, double precision) from public, anon, authenticated;

-- ============================================================ helpers

create or replace function private.place_report_reason_label(p text) returns text
language sql immutable as $$
  select case p
    when 'closed' then 'المحل مقفول نهائياً'
    when 'wrong_location' then 'المكان غلط على الخريطة'
    when 'wrong_info' then 'الاسم أو الرقم غلط'
    when 'duplicate' then 'مكرر'
    when 'fake' then 'مش محل / إعلان مزيف أو مسيء'
    else 'حاجة تانية'
  end
$$;

-- A reporter whose word counts toward auto-hide: an account at least
-- 3 days old, or one with a verified phone.
create or replace function private.place_reporter_eligible(p_user uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles p
                 where p.id = p_user
                   and (p.phone_verified_at is not null or p.created_at <= now() - interval '3 days'))
$$;
revoke execute on function private.place_reporter_eligible(uuid) from public, anon, authenticated;

-- Close every open report on a place; 'resolved' thanks the reporters
-- (at most one thank-you a day per user). Returns how many were closed.
create or replace function private.close_place_reports(p_place text, p_status text, p_report uuid default null)
returns int
language plpgsql security definer set search_path = public as $$
declare
  v_name text;
  v_n int;
begin
  select name into v_name from public.directory_places where id = p_place;
  if p_status = 'resolved' then
    insert into public.notifications (user_id, title, body)
    select distinct r.reporter_id, 'شكراً على بلاغك 🙏',
           'راجعنا بلاغك عن «' || coalesce(v_name, 'المكان') || '» وظبطنا الدليل. شكراً إنك بتساعد جيرانك.'
      from public.directory_place_reports r
     where r.place_id = p_place and r.status = 'open' and (p_report is null or r.id = p_report)
       and not exists (select 1 from public.notifications n
                        where n.user_id = r.reporter_id and n.title = 'شكراً على بلاغك 🙏'
                          and n.created_at > now() - interval '1 day');
  end if;
  update public.directory_place_reports
     set status = p_status, resolved_by = auth.uid(), resolved_at = now()
   where place_id = p_place and status = 'open' and (p_report is null or id = p_report);
  get diagnostics v_n = row_count;
  return v_n;
end;
$$;
revoke execute on function private.close_place_reports(text, text, uuid) from public, anon, authenticated;

-- ============================================================ reporting

create or replace function public.report_directory_place(
  p_place_id text,
  p_reason text,
  p_note text default null,
  p_suggestion jsonb default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_place public.directory_places;
  v_note text;
  v_sugg jsonb;
  v_val text;
  v_id uuid;
  v_n int;
begin
  if v_uid is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_reason is null or p_reason not in ('closed', 'wrong_location', 'wrong_info', 'duplicate', 'fake', 'other') then
    raise exception 'اختار سبب البلاغ';
  end if;

  -- Locked so concurrent reports count each other (auto-hide).
  select * into v_place from public.directory_places where id = p_place_id for update;
  if not found or v_place.hidden then
    raise exception 'المكان ده مش موجود في الدليل';
  end if;

  -- Already reported by me and still open: that one.
  select id into v_id from public.directory_place_reports
   where place_id = p_place_id and reporter_id = v_uid and status = 'open';
  if v_id is not null then
    return v_id;
  end if;

  if (select count(*) from public.directory_place_reports
       where reporter_id = v_uid and created_at > now() - interval '1 day') >= 10 then
    raise exception 'بلّغت عن أماكن كتير النهارده، جرّب بكرة';
  end if;

  v_note := regexp_replace(coalesce(p_note, ''), '[\x01-\x08\x0B\x0C\x0E-\x1F\x7F]', '', 'g');
  v_note := nullif(btrim(regexp_replace(v_note, '\n{3,}', E'\n\n', 'g')), '');
  if char_length(coalesce(v_note, '')) > 500 then
    raise exception 'الملاحظة طويلة — 500 حرف بحد أقصى';
  end if;
  if p_reason = 'other' and v_note is null then
    raise exception 'اكتب لنا إيه الغلط';
  end if;

  -- Suggested correction (wrong name / number only).
  if p_reason = 'wrong_info' and p_suggestion is not null and jsonb_typeof(p_suggestion) = 'object' then
    v_sugg := '{}'::jsonb;
    v_val := private.dir_text(p_suggestion ->> 'name', 200);
    if v_val is not null then
      if char_length(v_val) < 2 or char_length(v_val) > 120 then
        raise exception 'الاسم المقترح مش صحيح';
      end if;
      v_sugg := v_sugg || jsonb_build_object('name', v_val);
    end if;
    v_val := nullif(btrim(coalesce(p_suggestion ->> 'phone', '')), '');
    if v_val is not null then
      v_val := private.dir_phone(left(v_val, 40), v_place.country);
      if v_val is null then
        raise exception 'الرقم المقترح مش صحيح';
      end if;
      v_sugg := v_sugg || jsonb_build_object('phone', v_val);
    end if;
    v_val := nullif(btrim(coalesce(p_suggestion ->> 'category', '')), '');
    if v_val is not null then
      if not (v_val = any(private.dir_categories())) then
        raise exception 'النشاط المقترح مش صحيح';
      end if;
      v_sugg := v_sugg || jsonb_build_object('category', v_val);
    end if;
    if v_sugg = '{}'::jsonb then
      v_sugg := null;
    end if;
  end if;

  insert into public.directory_place_reports (place_id, reporter_id, reason, note, suggestion)
  values (p_place_id, v_uid, p_reason, v_note, v_sugg)
  returning id into v_id;

  -- Auto-hide a user / OSM place 3 eligible people say is gone or fake.
  if p_reason in ('closed', 'fake', 'duplicate') and v_place.source in ('user', 'osm') then
    select count(distinct r.reporter_id) into v_n
      from public.directory_place_reports r
     where r.place_id = p_place_id and r.status = 'open' and r.reason in ('closed', 'fake', 'duplicate')
       and private.place_reporter_eligible(r.reporter_id);
    if v_n >= 3 then
      update public.directory_places set hidden = true, hidden_by = 'auto', hidden_at = now() where id = p_place_id;
      insert into public.notifications (user_id, title, body, deep_link)
      select p.id, '🙈 مكان اتخفى من الدليل تلقائياً',
             '«' || v_place.name || '» — ' || v_n || ' بلّغوا إنه ' || private.place_report_reason_label(p_reason) || '. راجعه في «بلاغات الأماكن».',
             '/#/admin'
        from public.profiles p where p.role = 'super_admin';
      return v_id;
    end if;
  end if;

  -- Tell the super admins (at most once an hour each).
  insert into public.notifications (user_id, title, body, deep_link)
  select p.id, '📍 بلاغ عن مكان في الدليل',
         '«' || v_place.name || '»: ' || private.place_report_reason_label(p_reason) || '. راجع «بلاغات الأماكن».',
         '/#/admin'
    from public.profiles p
   where p.role = 'super_admin'
     and not exists (select 1 from public.notifications n
                      where n.user_id = p.id and n.title = '📍 بلاغ عن مكان في الدليل'
                        and n.created_at > now() - interval '1 hour');
  return v_id;
end;
$$;
revoke execute on function public.report_directory_place(text, text, text, jsonb) from public, anon;
grant execute on function public.report_directory_place(text, text, text, jsonb) to authenticated;

-- ============================================================ super admin

-- Places with reports, one row each. p_filter: 'open' (places with open
-- reports, most reporters first) or 'hidden' (hidden places, newest first).
create or replace function public.admin_list_place_reports(p_filter text default 'open')
returns table (
  place_id text, name text, category text, phone text, whatsapp text, address text,
  source text, country text, lat double precision, lng double precision,
  hidden boolean, hidden_by text, hidden_at timestamptz, claimed_shop_id uuid,
  reporters int, reasons jsonb, reports jsonb, last_report_at timestamptz
)
language plpgsql
stable
security definer
set search_path = public
as $$
#variable_conflict use_column
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  return query
  with places as (
    select d.* from public.directory_places d
     where case when coalesce(p_filter, 'open') = 'hidden' then d.hidden
                else exists (select 1 from public.directory_place_reports r where r.place_id = d.id and r.status = 'open') end
  ), reps as (
    select r.*, pr.full_name, private.place_reporter_eligible(r.reporter_id) as eligible
      from public.directory_place_reports r
      join places pl on pl.id = r.place_id
      left join public.profiles pr on pr.id = r.reporter_id
     where r.status = 'open' or coalesce(p_filter, 'open') = 'hidden'
  )
  select pl.id, pl.name, pl.category, pl.phone, pl.whatsapp, pl.address,
         pl.source, pl.country, pl.lat, pl.lng,
         pl.hidden, pl.hidden_by, pl.hidden_at, pl.claimed_shop_id,
         coalesce((select count(distinct x.reporter_id) from reps x where x.place_id = pl.id), 0)::int,
         coalesce((select jsonb_object_agg(g.reason, g.n) from (select x.reason, count(*) n from reps x where x.place_id = pl.id group by x.reason) g), '{}'::jsonb),
         coalesce((select jsonb_agg(jsonb_build_object(
                     'id', x.id, 'reason', x.reason, 'note', x.note, 'suggestion', x.suggestion, 'status', x.status,
                     'created_at', x.created_at, 'reporter', x.full_name, 'eligible', x.eligible) order by x.created_at desc)
                   from (select * from reps y where y.place_id = pl.id order by y.created_at desc limit 30) x), '[]'::jsonb),
         (select max(x.created_at) from reps x where x.place_id = pl.id)
    from places pl
   order by case when coalesce(p_filter, 'open') = 'hidden' then extract(epoch from pl.hidden_at) end desc nulls last,
            15 desc,
            18 desc nulls last
   limit 200;
end;
$$;
revoke execute on function public.admin_list_place_reports(text) from public, anon;
grant execute on function public.admin_list_place_reports(text) to authenticated;

-- «تجاهل البلاغ» (dismissed) / mark handled (resolved): one report, or
-- every open report on the place. Returns how many were closed.
create or replace function public.admin_resolve_place_report(
  p_place_id text, p_status text default 'dismissed', p_report_id uuid default null
) returns int
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  if p_status is null or p_status not in ('resolved', 'dismissed') then
    raise exception 'حالة غير صالحة';
  end if;
  return private.close_place_reports(p_place_id, p_status, p_report_id);
end;
$$;
revoke execute on function public.admin_resolve_place_report(text, text, uuid) from public, anon;
grant execute on function public.admin_resolve_place_report(text, text, uuid) to authenticated;

-- «تعديل البيانات»: name / phone / category (null = keep; '' phone =
-- remove). The WhatsApp follows the phone. Resolves the open reports.
create or replace function public.admin_update_directory_place(
  p_place_id text, p_name text default null, p_phone text default null, p_category text default null
) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_place public.directory_places;
  v_name text;
  v_phone text;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  select * into v_place from public.directory_places where id = p_place_id for update;
  if not found then
    raise exception 'المكان مش موجود';
  end if;
  if p_name is not null then
    v_name := private.dir_text(p_name, 200);
    if char_length(coalesce(v_name, '')) < 2 or char_length(v_name) > 120 then
      raise exception 'اكتب اسم المحل';
    end if;
  end if;
  if p_category is not null and not (p_category = any(private.dir_categories())) then
    raise exception 'نشاط غير صالح';
  end if;
  if p_phone is not null and btrim(p_phone) <> '' then
    v_phone := private.dir_phone(left(p_phone, 40), v_place.country);
    if v_phone is null then
      raise exception 'رقم التليفون مش صحيح';
    end if;
  end if;

  update public.directory_places set
    name = coalesce(v_name, name),
    category = coalesce(p_category, category),
    phone = case when p_phone is null then phone else v_phone end,
    whatsapp = case when p_phone is null then whatsapp else private.phone_store(v_phone, v_place.country) end
  where id = p_place_id;
  perform private.close_place_reports(p_place_id, 'resolved');
end;
$$;
revoke execute on function public.admin_update_directory_place(text, text, text, text) from public, anon;
grant execute on function public.admin_update_directory_place(text, text, text, text) to authenticated;

-- «إخفاء المكان» (resolves the open reports) / «إظهار تاني» (the place
-- is fine: dismisses them, so auto-hide starts counting from zero).
create or replace function public.admin_set_place_hidden(p_place_id text, p_hidden boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  if p_hidden is null then
    raise exception 'قيمة غير صالحة';
  end if;
  update public.directory_places set
    hidden = p_hidden,
    hidden_by = case when p_hidden then 'admin' end,
    hidden_at = case when p_hidden then now() end
  where id = p_place_id;
  if not found then
    raise exception 'المكان مش موجود';
  end if;
  perform private.close_place_reports(p_place_id, case when p_hidden then 'resolved' else 'dismissed' end);
end;
$$;
revoke execute on function public.admin_set_place_hidden(text, boolean) from public, anon;
grant execute on function public.admin_set_place_hidden(text, boolean) to authenticated;

-- «مسح المكان»: only places a user added or imported from OSM (an
-- Overture / merchant place is only hidden). Thanks the reporters first.
create or replace function public.admin_delete_directory_place(p_place_id text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_place public.directory_places;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  select * into v_place from public.directory_places where id = p_place_id for update;
  if not found then
    raise exception 'المكان مش موجود';
  end if;
  if v_place.source not in ('user', 'osm') then
    raise exception 'الأماكن دي بتتخفي بس، مش بتتمسح';
  end if;
  if v_place.claimed_shop_id is not null then
    raise exception 'المكان ده مربوط بمتجر — اخفيه بدل ما تمسحه';
  end if;
  perform private.close_place_reports(p_place_id, 'resolved');
  delete from public.directory_places where id = p_place_id;
end;
$$;
revoke execute on function public.admin_delete_directory_place(text) from public, anon;
grant execute on function public.admin_delete_directory_place(text) to authenticated;
