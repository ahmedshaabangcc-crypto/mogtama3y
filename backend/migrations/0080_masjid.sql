-- =====================================================================
-- Migration 0080 — «مسجدي» (masjid): mosques, their admins, and what a
-- mosque shares with its neighbourhood. Phase 1 (core).
--
--   * mosques: seeded from directory_places (names with مسجد / جامع /
--     mosque — «جامعة» excluded), keeping the directory id. Public read.
--     Users may add a missing mosque (unverified). Nearest + search RPCs.
--   * mosque_claims → super admin reviews → mosque_admins (owner). An
--     owner adds helpers (by phone) with permissions:
--     posts / lessons / needs / orphans / competitions / settings / team.
--     Only a VERIFIED mosque's admins can post or edit anything.
--   * Content (public read, admin write through RLS + column grants):
--     mosque_posts (announcements, pinned, urgent / janaza), mosque_lessons
--     (lessons & Quran circles), mosque_needs, mosque_orphan_programs,
--     mosque_competitions + levels.
--   * MONEY IS NEVER COLLECTED. Needs: people register a pledge
--     («هساهم بـ X»), the mosque admin confirms what actually arrived (or
--     adds a cash contribution); progress counts CONFIRMED amounts only
--     and a contribution is confirmed once. Orphan sponsorship is
--     record-keeping of anonymised programs (no child data is stored at
--     all) + monthly sponsor pledges confirmed by the admin.
--   * Competitions: registration per level, results published by the admin.
--   * mosque_follows: «تابع المسجد» → notifications (and phone push via
--     the 0055 trigger) for announcements / lessons / needs, rate-limited
--     per mosque (urgent posts like a جنازة have their own, shorter limit).
--   * tutorial_videos.app may now be 'masjid'.
--
-- Contributions, sponsorships, entries, claims and follows have NO table
-- grants: only the SECURITY DEFINER RPCs below read or write them.
-- Run after 0079, in order, in the Supabase SQL editor. Safe to re-run.
-- =====================================================================

-- ------------------------------------------------------------ tutorials
alter table public.tutorial_videos drop constraint if exists tutorial_videos_app_check;
alter table public.tutorial_videos add constraint tutorial_videos_app_check
  check (app in ('ittihad', 'tajer', 'mogtama3y', 'masjid'));

-- --------------------------------------------------------------- mosques
create table if not exists public.mosques (
  id uuid primary key default gen_random_uuid(),
  directory_id text unique references public.directory_places(id) on delete set null,
  name text not null check (char_length(btrim(name)) between 2 and 120),
  lat double precision not null check (lat between -90 and 90),
  lng double precision not null check (lng between -180 and 180),
  address text check (address is null or char_length(address) <= 300),
  governorate text check (governorate is null or char_length(governorate) <= 60),
  area text check (area is null or char_length(area) <= 80),
  verified boolean not null default false,
  claimed_by uuid references public.profiles(id) on delete set null,
  added_by uuid references public.profiles(id) on delete set null,
  -- «إزاي تساهم»: the mosque's own contact (shown publicly by design).
  contact_phone text check (contact_phone is null or contact_phone ~ '^\+?[0-9]{6,15}$'),
  contact_whatsapp text check (contact_whatsapp is null or contact_whatsapp ~ '^01[0-9]{9}$'),
  payment_note text check (payment_note is null or char_length(payment_note) <= 300),
  friday_khutba_time time,
  khatib text check (khatib is null or char_length(khatib) <= 80),
  -- Minutes between the adhan and the iqama, set by the mosque admin.
  iqama_fajr smallint check (iqama_fajr is null or iqama_fajr between 0 and 90),
  iqama_dhuhr smallint check (iqama_dhuhr is null or iqama_dhuhr between 0 and 90),
  iqama_asr smallint check (iqama_asr is null or iqama_asr between 0 and 90),
  iqama_maghrib smallint check (iqama_maghrib is null or iqama_maghrib between 0 and 90),
  iqama_isha smallint check (iqama_isha is null or iqama_isha between 0 and 90),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists mosques_lat_lng on public.mosques (lat, lng);
create index if not exists mosques_verified on public.mosques (verified) where verified;

alter table public.mosques enable row level security;
revoke all on public.mosques from public, anon, authenticated;
grant select (id, directory_id, name, lat, lng, address, governorate, area, verified,
              contact_phone, contact_whatsapp, payment_note, friday_khutba_time, khatib,
              iqama_fajr, iqama_dhuhr, iqama_asr, iqama_maghrib, iqama_isha, created_at, updated_at)
  on public.mosques to anon, authenticated;
drop policy if exists "mosques: public read" on public.mosques;
create policy "mosques: public read" on public.mosques for select to anon, authenticated using (true);

-- Seed / top up from the business directory. Re-run after a directory
-- reload (postgres / service only); a mosque already present at the same
-- spot with the same name is not added twice.
create or replace function public.masjid_seed_from_directory() returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  n int;
begin
  insert into public.mosques (directory_id, name, lat, lng, address)
  select d.id, left(btrim(d.name), 120), d.lat, d.lng, left(d.address, 300)
  from public.directory_places d
  where (d.name ~* '(مسجد|mosque|masjid)' or d.name ~ 'جامع([^ة]|$)' or coalesce(d.kind, '') ~* 'mosque')
    and d.name !~ 'جامعة'
    and char_length(btrim(d.name)) >= 2
    and not exists (select 1 from public.mosques m where m.directory_id = d.id)
    and not exists (select 1 from public.mosques m
                    where m.name = left(btrim(d.name), 120)
                      and abs(m.lat - d.lat) < 0.0005 and abs(m.lng - d.lng) < 0.0005);
  get diagnostics n = row_count;
  return n;
end;
$$;
revoke execute on function public.masjid_seed_from_directory() from public, anon, authenticated;
select public.masjid_seed_from_directory();

-- ------------------------------------------------------- admins & claims
create table if not exists public.mosque_admins (
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null check (role in ('owner', 'helper')),
  title text check (title is null or char_length(title) <= 40),
  permissions text[] not null default '{}'
    check (permissions <@ array['posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings']::text[]),
  added_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  primary key (mosque_id, user_id)
);
create index if not exists mosque_admins_user on public.mosque_admins (user_id);
alter table public.mosque_admins enable row level security;
revoke all on public.mosque_admins from public, anon, authenticated;

-- Can the caller do [p_perm] on this mosque? Owners can do everything;
-- 'team' (adding/removing helpers) is owners only. Never on an
-- unverified mosque.
create or replace function public.masjid_can(p_mosque uuid, p_perm text) returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select auth.uid() is not null and exists (
    select 1
    from public.mosque_admins a
    join public.mosques m on m.id = a.mosque_id
    where a.mosque_id = p_mosque and a.user_id = auth.uid() and m.verified
      and (a.role = 'owner' or (p_perm <> 'team' and p_perm = any(a.permissions))));
$$;
grant execute on function public.masjid_can(uuid, text) to anon, authenticated;

create table if not exists public.mosque_claims (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role_title text not null check (role_title in ('imam', 'khatib', 'amin', 'board')),
  phone text not null check (phone ~ '^01[0-9]{9}$'),
  doc_path text check (doc_path is null or char_length(doc_path) <= 300),
  note text check (note is null or char_length(note) <= 500),
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  review_note text check (review_note is null or char_length(review_note) <= 500),
  reviewed_by uuid references public.profiles(id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);
create unique index if not exists mosque_claims_one_pending on public.mosque_claims (mosque_id, user_id) where status = 'pending';
create index if not exists mosque_claims_status on public.mosque_claims (status, created_at);
alter table public.mosque_claims enable row level security;
revoke all on public.mosque_claims from public, anon, authenticated;

-- ---------------------------------------------------------------- follows
create table if not exists public.mosque_follows (
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  notify boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (mosque_id, user_id)
);
create index if not exists mosque_follows_user on public.mosque_follows (user_id);
alter table public.mosque_follows enable row level security;
revoke all on public.mosque_follows from public, anon, authenticated;

create table if not exists public.mosque_notify_log (
  id bigint generated always as identity primary key,
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  urgent boolean not null,
  created_at timestamptz not null default now()
);
create index if not exists mosque_notify_log_mosque on public.mosque_notify_log (mosque_id, created_at);
alter table public.mosque_notify_log enable row level security;
revoke all on public.mosque_notify_log from public, anon, authenticated;

-- One notification batch to the mosque's followers, rate-limited per
-- mosque: regular news at most once every 2 hours and 4 times a day;
-- urgent (جنازة / تنبيه عاجل) at most once every 10 minutes.
-- Returns how many followers were notified (0 when limited).
create or replace function public._masjid_notify_followers(p_mosque uuid, p_urgent boolean, p_title text, p_body text)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  n int;
begin
  if p_urgent then
    if exists (select 1 from public.mosque_notify_log
               where mosque_id = p_mosque and urgent and created_at > now() - interval '10 minutes') then
      return 0;
    end if;
  else
    if exists (select 1 from public.mosque_notify_log
               where mosque_id = p_mosque and not urgent and created_at > now() - interval '2 hours')
       or (select count(*) from public.mosque_notify_log
           where mosque_id = p_mosque and not urgent and created_at > now() - interval '24 hours') >= 4 then
      return 0;
    end if;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  select f.user_id, left(p_title, 120), left(p_body, 300), '/#/masjid/' || p_mosque
  from public.mosque_follows f
  where f.mosque_id = p_mosque and f.notify
    and f.user_id is distinct from auth.uid();
  get diagnostics n = row_count;
  insert into public.mosque_notify_log (mosque_id, urgent) values (p_mosque, p_urgent);
  return n;
end;
$$;
revoke execute on function public._masjid_notify_followers(uuid, boolean, text, text) from public, anon, authenticated;

-- ---------------------------------------------------------------- content
create table if not exists public.mosque_posts (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  author_id uuid references public.profiles(id) on delete set null,
  kind text not null default 'announcement' check (kind in ('announcement', 'event', 'urgent', 'janaza')),
  title text not null check (char_length(btrim(title)) between 2 and 120),
  body text check (body is null or char_length(body) <= 2000),
  pinned boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists mosque_posts_mosque on public.mosque_posts (mosque_id, pinned desc, created_at desc);

create table if not exists public.mosque_lessons (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  kind text not null default 'lesson' check (kind in ('lesson', 'quran_circle')),
  title text not null check (char_length(btrim(title)) between 2 and 120),
  sheikh text check (sheikh is null or char_length(sheikh) <= 80),
  -- ISO weekdays: 1 = Monday … 5 = Friday, 6 = Saturday, 7 = Sunday.
  weekdays smallint[] not null default '{}' check (weekdays <@ array[1,2,3,4,5,6,7]::smallint[]),
  start_time time,
  after_prayer text check (after_prayer is null or after_prayer in ('fajr', 'dhuhr', 'asr', 'maghrib', 'isha')),
  audience text not null default 'all' check (audience in ('men', 'women', 'kids', 'all')),
  location text check (location is null or char_length(location) <= 80),
  notes text check (notes is null or char_length(notes) <= 500),
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create index if not exists mosque_lessons_mosque on public.mosque_lessons (mosque_id) where active;

create table if not exists public.mosque_needs (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 2 and 120),
  description text check (description is null or char_length(description) <= 1000),
  photo_url text check (photo_url is null or (photo_url ~ '^https://' and char_length(photo_url) <= 500)),
  target_amount numeric(12,2) not null check (target_amount > 0 and target_amount <= 10000000),
  status text not null default 'open' check (status in ('open', 'closed')),
  created_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  closed_at timestamptz
);
create index if not exists mosque_needs_mosque on public.mosque_needs (mosque_id, status, created_at desc);

-- Pledges («هساهم بـ X») and cash the admin recorded. Never money.
create table if not exists public.mosque_need_contributions (
  id uuid primary key default gen_random_uuid(),
  need_id uuid not null references public.mosque_needs(id) on delete cascade,
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete set null,
  donor_name text check (donor_name is null or char_length(donor_name) <= 80),
  anonymous boolean not null default false,
  kind text not null check (kind in ('pledge', 'cash')),
  amount numeric(12,2) not null check (amount > 0 and amount <= 10000000),
  note text check (note is null or char_length(note) <= 300),
  status text not null check (status in ('pledged', 'confirmed', 'cancelled')),
  confirmed_by uuid references public.profiles(id) on delete set null,
  confirmed_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists mosque_need_contrib_need on public.mosque_need_contributions (need_id, status);
create index if not exists mosque_need_contrib_user on public.mosque_need_contributions (user_id, created_at);
alter table public.mosque_need_contributions enable row level security;
revoke all on public.mosque_need_contributions from public, anon, authenticated;

-- كفالة الأيتام: anonymised programs only — there is deliberately no
-- column for a child's name, photo, age or address.
create table if not exists public.mosque_orphan_programs (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 2 and 120),
  description text check (description is null or char_length(description) <= 600),
  monthly_amount numeric(10,2) not null check (monthly_amount > 0 and monthly_amount <= 1000000),
  slots int check (slots is null or slots between 1 and 1000),
  status text not null default 'open' check (status in ('open', 'closed')),
  created_at timestamptz not null default now()
);
create index if not exists mosque_orphan_programs_mosque on public.mosque_orphan_programs (mosque_id, status);

create table if not exists public.mosque_orphan_sponsorships (
  id uuid primary key default gen_random_uuid(),
  program_id uuid not null references public.mosque_orphan_programs(id) on delete cascade,
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  monthly_amount numeric(10,2) not null check (monthly_amount > 0 and monthly_amount <= 1000000),
  note text check (note is null or char_length(note) <= 300),
  status text not null default 'pledged' check (status in ('pledged', 'active', 'ended', 'cancelled')),
  confirmed_by uuid references public.profiles(id) on delete set null,
  confirmed_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists mosque_orphan_sp_program on public.mosque_orphan_sponsorships (program_id, status);
create index if not exists mosque_orphan_sp_user on public.mosque_orphan_sponsorships (user_id);
alter table public.mosque_orphan_sponsorships enable row level security;
revoke all on public.mosque_orphan_sponsorships from public, anon, authenticated;

-- مسابقات القرآن
create table if not exists public.mosque_competitions (
  id uuid primary key default gen_random_uuid(),
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  title text not null check (char_length(btrim(title)) between 2 and 120),
  description text check (description is null or char_length(description) <= 1000),
  schedule text check (schedule is null or char_length(schedule) <= 500),
  registration_deadline date,
  starts_on date,
  status text not null default 'open' check (status in ('open', 'closed', 'finished')),
  results_published boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists mosque_competitions_mosque on public.mosque_competitions (mosque_id, created_at desc);

create table if not exists public.mosque_competition_levels (
  id uuid primary key default gen_random_uuid(),
  competition_id uuid not null references public.mosque_competitions(id) on delete cascade,
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  name text not null check (char_length(btrim(name)) between 1 and 80),   -- «جزء عمّ»، «5 أجزاء»…
  details text check (details is null or char_length(details) <= 300),
  age_group text check (age_group is null or char_length(age_group) <= 40),
  sort int not null default 0
);
create index if not exists mosque_competition_levels_comp on public.mosque_competition_levels (competition_id, sort);

create table if not exists public.mosque_competition_entries (
  id uuid primary key default gen_random_uuid(),
  competition_id uuid not null references public.mosque_competitions(id) on delete cascade,
  level_id uuid not null references public.mosque_competition_levels(id) on delete cascade,
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  contestant_name text not null check (char_length(btrim(contestant_name)) between 2 and 80),
  contestant_age smallint check (contestant_age is null or contestant_age between 3 and 100),
  phone text check (phone is null or phone ~ '^01[0-9]{9}$'),
  status text not null default 'registered' check (status in ('registered', 'withdrawn')),
  score numeric(5,2) check (score is null or score between 0 and 100),
  rank int check (rank is null or rank between 1 and 1000),
  result_note text check (result_note is null or char_length(result_note) <= 200),
  created_at timestamptz not null default now(),
  unique (competition_id, user_id, contestant_name)
);
create index if not exists mosque_competition_entries_comp on public.mosque_competition_entries (competition_id, level_id);
alter table public.mosque_competition_entries enable row level security;
revoke all on public.mosque_competition_entries from public, anon, authenticated;

-- ---- content: RLS (public read, mosque admins with the permission write)
alter table public.mosque_posts enable row level security;
alter table public.mosque_lessons enable row level security;
alter table public.mosque_needs enable row level security;
alter table public.mosque_orphan_programs enable row level security;
alter table public.mosque_competitions enable row level security;
alter table public.mosque_competition_levels enable row level security;

revoke all on public.mosque_posts, public.mosque_lessons, public.mosque_needs, public.mosque_orphan_programs,
              public.mosque_competitions, public.mosque_competition_levels from public, anon, authenticated;

grant select on public.mosque_posts, public.mosque_lessons, public.mosque_needs, public.mosque_orphan_programs,
                public.mosque_competitions, public.mosque_competition_levels to anon, authenticated;

grant insert (mosque_id, kind, title, body, pinned), update (kind, title, body, pinned), delete on public.mosque_posts to authenticated;
grant insert (mosque_id, kind, title, sheikh, weekdays, start_time, after_prayer, audience, location, notes, active),
      update (kind, title, sheikh, weekdays, start_time, after_prayer, audience, location, notes, active), delete
   on public.mosque_lessons to authenticated;
-- Needs: status changes only through masjid_set_need_status.
grant insert (mosque_id, title, description, photo_url, target_amount),
      update (title, description, photo_url, target_amount), delete on public.mosque_needs to authenticated;
grant insert (mosque_id, title, description, monthly_amount, slots, status),
      update (title, description, monthly_amount, slots, status), delete on public.mosque_orphan_programs to authenticated;
grant insert (mosque_id, title, description, schedule, registration_deadline, starts_on, status),
      update (title, description, schedule, registration_deadline, starts_on, status), delete on public.mosque_competitions to authenticated;
grant insert (competition_id, mosque_id, name, details, age_group, sort),
      update (name, details, age_group, sort), delete on public.mosque_competition_levels to authenticated;

do $$
declare
  t record;
begin
  for t in select * from (values
      ('mosque_posts', 'posts'), ('mosque_lessons', 'lessons'), ('mosque_needs', 'needs'),
      ('mosque_orphan_programs', 'orphans'), ('mosque_competitions', 'competitions'),
      ('mosque_competition_levels', 'competitions')) as v(tbl, perm)
  loop
    execute format('drop policy if exists "%1$s: public read" on public.%1$I', t.tbl);
    execute format('create policy "%1$s: public read" on public.%1$I for select to anon, authenticated using (true)', t.tbl);
    execute format('drop policy if exists "%1$s: admins insert" on public.%1$I', t.tbl);
    execute format('create policy "%1$s: admins insert" on public.%1$I for insert to authenticated with check (public.masjid_can(mosque_id, %2$L))', t.tbl, t.perm);
    execute format('drop policy if exists "%1$s: admins update" on public.%1$I', t.tbl);
    execute format('create policy "%1$s: admins update" on public.%1$I for update to authenticated using (public.masjid_can(mosque_id, %2$L)) with check (public.masjid_can(mosque_id, %2$L))', t.tbl, t.perm);
    execute format('drop policy if exists "%1$s: admins delete" on public.%1$I', t.tbl);
    execute format('create policy "%1$s: admins delete" on public.%1$I for delete to authenticated using (public.masjid_can(mosque_id, %2$L))', t.tbl, t.perm);
  end loop;
end;
$$;

-- A level belongs to its competition's mosque.
create or replace function public._masjid_level_guard() returns trigger
language plpgsql
set search_path = public
as $$
declare
  v_mosque uuid;
begin
  select c.mosque_id into v_mosque from public.mosque_competitions c where c.id = new.competition_id;
  if v_mosque is null then
    raise exception 'المسابقة مش موجودة';
  end if;
  new.mosque_id := v_mosque;
  return new;
end;
$$;
revoke execute on function public._masjid_level_guard() from public, anon, authenticated;
drop trigger if exists masjid_level_guard on public.mosque_competition_levels;
create trigger masjid_level_guard before insert on public.mosque_competition_levels
  for each row execute function public._masjid_level_guard();

-- Who wrote it, and keep timestamps honest.
create or replace function public._masjid_post_stamp() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    new.author_id := auth.uid();
    new.created_at := now();
  else
    new.author_id := old.author_id;
    new.created_at := old.created_at;
  end if;
  new.updated_at := now();
  return new;
end;
$$;
revoke execute on function public._masjid_post_stamp() from public, anon, authenticated;
drop trigger if exists masjid_post_stamp on public.mosque_posts;
create trigger masjid_post_stamp before insert or update on public.mosque_posts
  for each row execute function public._masjid_post_stamp();

create or replace function public._masjid_need_stamp() returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.created_by := auth.uid();
  new.created_at := now();
  new.status := 'open';
  new.closed_at := null;
  return new;
end;
$$;
revoke execute on function public._masjid_need_stamp() from public, anon, authenticated;
drop trigger if exists masjid_need_stamp on public.mosque_needs;
create trigger masjid_need_stamp before insert on public.mosque_needs
  for each row execute function public._masjid_need_stamp();

-- New post / lesson / need → the followers hear about it (rate-limited).
create or replace function public._masjid_content_notify() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_name text;
begin
  select name into v_name from public.mosques where id = new.mosque_id;
  if tg_table_name = 'mosque_posts' then
    perform public._masjid_notify_followers(new.mosque_id, new.kind in ('urgent', 'janaza'),
      case new.kind when 'janaza' then 'صلاة جنازة — ' || v_name
                    when 'urgent' then 'تنبيه عاجل — ' || v_name
                    else 'إعلان جديد — ' || v_name end,
      new.title);
  elsif tg_table_name = 'mosque_lessons' then
    perform public._masjid_notify_followers(new.mosque_id, false,
      case new.kind when 'quran_circle' then 'حلقة قرآن جديدة — ' else 'درس جديد — ' end || v_name,
      new.title || coalesce(' مع ' || new.sheikh, ''));
  elsif tg_table_name = 'mosque_needs' then
    perform public._masjid_notify_followers(new.mosque_id, false, 'احتياج جديد للمسجد — ' || v_name,
      new.title || ' — المطلوب ' || trim(to_char(new.target_amount, 'FM999G999G990')) || ' ج.م');
  end if;
  return new;
end;
$$;
revoke execute on function public._masjid_content_notify() from public, anon, authenticated;
drop trigger if exists masjid_post_notify on public.mosque_posts;
create trigger masjid_post_notify after insert on public.mosque_posts
  for each row execute function public._masjid_content_notify();
drop trigger if exists masjid_lesson_notify on public.mosque_lessons;
create trigger masjid_lesson_notify after insert on public.mosque_lessons
  for each row execute function public._masjid_content_notify();
drop trigger if exists masjid_need_notify on public.mosque_needs;
create trigger masjid_need_notify after insert on public.mosque_needs
  for each row execute function public._masjid_content_notify();

-- ============================================================ RPCs: browse

create or replace function public.nearby_mosques(
  p_lat double precision, p_lng double precision, p_km double precision default 5, p_limit int default 40
) returns table (
  id uuid, name text, address text, area text, governorate text,
  lat double precision, lng double precision, verified boolean, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  with box as (
    select least(greatest(coalesce(p_km, 5), 0.3), 50) / 111.0 as dlat,
           least(greatest(coalesce(p_km, 5), 0.3), 50) / (111.0 * greatest(cos(radians(p_lat)), 0.2)) as dlng
  )
  select m.id, m.name, m.address, m.area, m.governorate, m.lat, m.lng, m.verified,
         111.0 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) as distance_km
  from public.mosques m, box
  where m.lat between p_lat - box.dlat and p_lat + box.dlat
    and m.lng between p_lng - box.dlng and p_lng + box.dlng
  order by distance_km
  limit least(greatest(coalesce(p_limit, 40), 1), 100);
$$;
grant execute on function public.nearby_mosques(double precision, double precision, double precision, int) to anon, authenticated;

create or replace function public.search_mosques(
  p_query text, p_lat double precision default null, p_lng double precision default null, p_limit int default 30
) returns table (
  id uuid, name text, address text, area text, governorate text,
  lat double precision, lng double precision, verified boolean, distance_km double precision
)
language sql
stable
set search_path = public
as $$
  with q as (
    select '%' || replace(replace(replace(btrim(coalesce(p_query, '')), '\', '\\'), '%', '\%'), '_', '\_') || '%' as pat
  )
  select m.id, m.name, m.address, m.area, m.governorate, m.lat, m.lng, m.verified,
         case when p_lat is not null and p_lng is not null
              then 111.0 * sqrt(power(m.lat - p_lat, 2) + power((m.lng - p_lng) * cos(radians(p_lat)), 2)) end as distance_km
  from public.mosques m, q
  where char_length(btrim(coalesce(p_query, ''))) >= 2
    and (m.name ilike q.pat or m.area ilike q.pat or m.governorate ilike q.pat or m.address ilike q.pat)
  order by (m.name ilike q.pat) desc, m.verified desc, distance_km nulls last, m.name
  limit least(greatest(coalesce(p_limit, 30), 1), 60);
$$;
grant execute on function public.search_mosques(text, double precision, double precision, int) to anon, authenticated;

-- One mosque with the caller's relationship to it.
create or replace function public.get_mosque(p_id uuid) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  m public.mosques;
  a public.mosque_admins;
  f public.mosque_follows;
  v_perms text[];
begin
  select * into m from public.mosques where id = p_id;
  if not found then
    return null;
  end if;
  if auth.uid() is not null then
    select * into a from public.mosque_admins where mosque_id = p_id and user_id = auth.uid();
    select * into f from public.mosque_follows where mosque_id = p_id and user_id = auth.uid();
  end if;
  v_perms := case
    when a.user_id is null or not m.verified then '{}'::text[]
    when a.role = 'owner' then array['posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings', 'team']
    else a.permissions end;
  return jsonb_build_object(
    'id', m.id, 'name', m.name, 'lat', m.lat, 'lng', m.lng, 'address', m.address,
    'governorate', m.governorate, 'area', m.area, 'verified', m.verified,
    'contact_phone', m.contact_phone, 'contact_whatsapp', m.contact_whatsapp, 'payment_note', m.payment_note,
    'friday_khutba_time', m.friday_khutba_time, 'khatib', m.khatib,
    'iqama', jsonb_build_object('fajr', m.iqama_fajr, 'dhuhr', m.iqama_dhuhr, 'asr', m.iqama_asr,
                                'maghrib', m.iqama_maghrib, 'isha', m.iqama_isha),
    'followers', (select count(*) from public.mosque_follows x where x.mosque_id = m.id),
    'is_following', f.user_id is not null,
    'notify', coalesce(f.notify, false),
    'my_role', a.role,
    'my_permissions', to_jsonb(v_perms),
    'my_pending_claim', auth.uid() is not null and exists (
      select 1 from public.mosque_claims c where c.mosque_id = m.id and c.user_id = auth.uid() and c.status = 'pending'));
end;
$$;
grant execute on function public.get_mosque(uuid) to anon, authenticated;

-- «مسجدي مش موجود؟ ضيفه» — any signed-in user, unverified until claimed.
create or replace function public.masjid_add_mosque(
  p_name text, p_lat double precision, p_lng double precision,
  p_address text default null, p_area text default null, p_governorate text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_name text := btrim(coalesce(p_name, ''));
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if char_length(v_name) < 3 then
    raise exception 'اكتب اسم المسجد';
  end if;
  if p_lat is null or p_lng is null or p_lat not between 21 and 32.5 or p_lng not between 24 and 37.5 then
    raise exception 'حدد مكان المسجد على الخريطة (جوه مصر)';
  end if;
  if (select count(*) from public.mosques where added_by = auth.uid() and created_at > now() - interval '1 day') >= 3 then
    raise exception 'ضفت مساجد كتير النهارده، جرّب بكرة';
  end if;
  select id into v_id from public.mosques
  where name = v_name and abs(lat - p_lat) < 0.002 and abs(lng - p_lng) < 0.002 limit 1;
  if v_id is not null then
    return v_id;
  end if;
  insert into public.mosques (name, lat, lng, address, area, governorate, added_by)
  values (left(v_name, 120), p_lat, p_lng, left(nullif(btrim(p_address), ''), 300),
          left(nullif(btrim(p_area), ''), 80), left(nullif(btrim(p_governorate), ''), 60), auth.uid())
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.masjid_add_mosque(text, double precision, double precision, text, text, text) from public, anon;
grant execute on function public.masjid_add_mosque(text, double precision, double precision, text, text, text) to authenticated;

-- ============================================================ RPCs: follow

create or replace function public.masjid_follow(p_mosque uuid, p_follow boolean, p_notify boolean default true)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_follow then
    if not exists (select 1 from public.mosques where id = p_mosque) then
      raise exception 'المسجد مش موجود';
    end if;
    if (select count(*) from public.mosque_follows where user_id = auth.uid()) >= 50 then
      raise exception 'وصلت لأقصى عدد مساجد تتابعها';
    end if;
    insert into public.mosque_follows (mosque_id, user_id, notify)
    values (p_mosque, auth.uid(), coalesce(p_notify, true))
    on conflict (mosque_id, user_id) do update set notify = excluded.notify;
  else
    delete from public.mosque_follows where mosque_id = p_mosque and user_id = auth.uid();
  end if;
end;
$$;
revoke execute on function public.masjid_follow(uuid, boolean, boolean) from public, anon;
grant execute on function public.masjid_follow(uuid, boolean, boolean) to authenticated;

create or replace function public.my_followed_mosques()
returns table (id uuid, name text, address text, area text, lat double precision, lng double precision,
               verified boolean, notify boolean, my_role text)
language sql
stable
security definer
set search_path = public
as $$
  select m.id, m.name, m.address, m.area, m.lat, m.lng, m.verified, f.notify,
         (select a.role from public.mosque_admins a where a.mosque_id = m.id and a.user_id = auth.uid())
  from public.mosque_follows f
  join public.mosques m on m.id = f.mosque_id
  where f.user_id = auth.uid()
  order by f.created_at desc;
$$;
grant execute on function public.my_followed_mosques() to authenticated;

-- Mosques the caller manages (owner or helper).
create or replace function public.my_managed_mosques()
returns table (id uuid, name text, verified boolean, role text, permissions text[])
language sql
stable
security definer
set search_path = public
as $$
  select m.id, m.name, m.verified, a.role, a.permissions
  from public.mosque_admins a
  join public.mosques m on m.id = a.mosque_id
  where a.user_id = auth.uid()
  order by a.created_at;
$$;
grant execute on function public.my_managed_mosques() to authenticated;

-- ============================================================ RPCs: claims

create or replace function public.masjid_claim(
  p_mosque uuid, p_role text, p_phone text, p_doc_path text default null, p_note text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
  v_phone text := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
  v_doc text := nullif(btrim(coalesce(p_doc_path, '')), '');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if not exists (select 1 from public.mosques where id = p_mosque) then
    raise exception 'المسجد مش موجود';
  end if;
  if p_role is null or p_role not in ('imam', 'khatib', 'amin', 'board') then
    raise exception 'اختار صفتك في المسجد';
  end if;
  if v_phone ~ '^20' and char_length(v_phone) = 12 then
    v_phone := '0' || substr(v_phone, 3);
  end if;
  if v_phone !~ '^01[0-9]{9}$' then
    raise exception 'رقم الموبايل لازم يكون 11 رقم ويبدأ بـ 01';
  end if;
  if v_doc is not null and v_doc not like auth.uid()::text || '/%' then
    raise exception 'مستند غير صالح';
  end if;
  if exists (select 1 from public.mosque_admins a where a.mosque_id = p_mosque and a.user_id = auth.uid() and a.role = 'owner') then
    raise exception 'إنت بالفعل مسؤول عن المسجد ده';
  end if;
  if exists (select 1 from public.mosque_claims where mosque_id = p_mosque and user_id = auth.uid() and status = 'pending') then
    raise exception 'طلبك قيد المراجعة بالفعل';
  end if;
  if (select count(*) from public.mosque_claims where user_id = auth.uid() and status = 'pending') >= 3 then
    raise exception 'عندك طلبات كتير قيد المراجعة';
  end if;
  insert into public.mosque_claims (mosque_id, user_id, role_title, phone, doc_path, note)
  values (p_mosque, auth.uid(), p_role, v_phone, v_doc, left(nullif(btrim(p_note), ''), 500))
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.masjid_claim(uuid, text, text, text, text) from public, anon;
grant execute on function public.masjid_claim(uuid, text, text, text, text) to authenticated;

create or replace function public.masjid_my_claims()
returns table (id uuid, mosque_id uuid, mosque_name text, role_title text, status text, review_note text, created_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select c.id, c.mosque_id, m.name, c.role_title, c.status, c.review_note, c.created_at
  from public.mosque_claims c join public.mosques m on m.id = c.mosque_id
  where c.user_id = auth.uid()
  order by c.created_at desc
  limit 50;
$$;
grant execute on function public.masjid_my_claims() to authenticated;

create or replace function public.admin_list_mosque_claims(p_status text default 'pending')
returns table (id uuid, mosque_id uuid, mosque_name text, mosque_address text, mosque_verified boolean,
               lat double precision, lng double precision,
               user_id uuid, full_name text, account_phone text, role_title text, phone text,
               doc_path text, note text, status text, review_note text, created_at timestamptz,
               current_admins int)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  return query
  select c.id, m.id, m.name, m.address, m.verified, m.lat, m.lng,
         c.user_id, p.full_name, p.phone, c.role_title, c.phone,
         c.doc_path, c.note, c.status, c.review_note, c.created_at,
         (select count(*)::int from public.mosque_admins a where a.mosque_id = m.id)
  from public.mosque_claims c
  join public.mosques m on m.id = c.mosque_id
  join public.profiles p on p.id = c.user_id
  where p_status is null or c.status = p_status
  order by (c.status = 'pending') desc, c.created_at desc
  limit 300;
end;
$$;
grant execute on function public.admin_list_mosque_claims(text) to authenticated;

create or replace function public.admin_review_mosque_claim(p_claim uuid, p_approve boolean, p_note text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_claims;
  v_note text := left(nullif(btrim(coalesce(p_note, '')), ''), 500);
  v_name text;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  select * into c from public.mosque_claims where id = p_claim for update;
  if not found then
    raise exception 'الطلب مش موجود';
  end if;
  if c.status <> 'pending' then
    raise exception 'الطلب ده اتراجع قبل كده';
  end if;
  update public.mosque_claims
     set status = case when p_approve then 'approved' else 'rejected' end,
         review_note = v_note, reviewed_by = auth.uid(), reviewed_at = now()
   where id = p_claim;
  select name into v_name from public.mosques where id = c.mosque_id;
  if p_approve then
    update public.mosques set verified = true, claimed_by = coalesce(claimed_by, c.user_id), updated_at = now()
     where id = c.mosque_id;
    insert into public.mosque_admins (mosque_id, user_id, role, title, permissions, added_by)
    values (c.mosque_id, c.user_id, 'owner',
            case c.role_title when 'imam' then 'إمام المسجد' when 'khatib' then 'خطيب المسجد'
                              when 'amin' then 'أمين المسجد' else 'عضو مجلس إدارة المسجد' end,
            '{}', auth.uid())
    on conflict (mosque_id, user_id) do update set role = 'owner', title = excluded.title;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (c.user_id,
          case when p_approve then 'مبروك! بقيت مسؤول «' || v_name || '» على مسجدي ✓'
               else 'طلب إدارة «' || v_name || '» اترفض' end,
          case when p_approve then 'تقدر دلوقتي تنشر الإعلانات والدروس والاحتياجات وتضيف مساعدين.'
               else coalesce(v_note, 'راجع بياناتك وابعت الطلب تاني.') end,
          '/#/masjid/' || c.mosque_id);
end;
$$;
grant execute on function public.admin_review_mosque_claim(uuid, boolean, text) to authenticated;

-- Super admin: remove someone from a mosque's team, or un-verify a mosque.
create or replace function public.admin_remove_mosque_admin(p_mosque uuid, p_user uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  delete from public.mosque_admins where mosque_id = p_mosque and user_id = p_user;
  if not exists (select 1 from public.mosque_admins where mosque_id = p_mosque and role = 'owner') then
    update public.mosques set verified = false, updated_at = now() where id = p_mosque;
  end if;
end;
$$;
grant execute on function public.admin_remove_mosque_admin(uuid, uuid) to authenticated;

-- ============================================================ RPCs: team

create or replace function public.masjid_add_helper(p_mosque uuid, p_phone text, p_permissions text[], p_title text default null)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_phone text := regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g');
  v_user uuid;
  v_name text;
  v_perms text[];
begin
  if not public.masjid_can(p_mosque, 'team') then
    raise exception 'غير مصرح';
  end if;
  if v_phone ~ '^20' and char_length(v_phone) = 12 then
    v_phone := '0' || substr(v_phone, 3);
  end if;
  select id, full_name into v_user, v_name from public.profiles where phone = v_phone;
  if v_user is null then
    raise exception 'مفيش حساب على مُجتمعي بالرقم ده — خلّيه يعمل حساب الأول';
  end if;
  if v_user = auth.uid() then
    raise exception 'إنت بالفعل مسؤول';
  end if;
  select coalesce(array_agg(distinct p), '{}') into v_perms
  from unnest(coalesce(p_permissions, '{}')) p
  where p in ('posts', 'lessons', 'needs', 'orphans', 'competitions', 'settings');
  if cardinality(v_perms) = 0 then
    raise exception 'اختار صلاحية واحدة على الأقل';
  end if;
  if exists (select 1 from public.mosque_admins where mosque_id = p_mosque and user_id = v_user and role = 'owner') then
    raise exception 'الشخص ده مسؤول أساسي بالفعل';
  end if;
  if (select count(*) from public.mosque_admins where mosque_id = p_mosque) >= 30 then
    raise exception 'وصلت لأقصى عدد مساعدين';
  end if;
  insert into public.mosque_admins (mosque_id, user_id, role, title, permissions, added_by)
  values (p_mosque, v_user, 'helper', left(nullif(btrim(p_title), ''), 40), v_perms, auth.uid())
  on conflict (mosque_id, user_id) do update set permissions = excluded.permissions, title = excluded.title;
  insert into public.notifications (user_id, title, body, deep_link)
  select v_user, 'بقيت من فريق «' || m.name || '»', 'تقدر تساعد في إدارة صفحة المسجد على مسجدي.', '/#/masjid/' || m.id
  from public.mosques m where m.id = p_mosque;
  return v_name;
end;
$$;
revoke execute on function public.masjid_add_helper(uuid, text, text[], text) from public, anon;
grant execute on function public.masjid_add_helper(uuid, text, text[], text) to authenticated;

-- Owners remove helpers; anyone can leave a team (an owner can't be
-- removed this way — only by the platform admin).
create or replace function public.masjid_remove_helper(p_mosque uuid, p_user uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_user is distinct from auth.uid() and not public.masjid_can(p_mosque, 'team') then
    raise exception 'غير مصرح';
  end if;
  delete from public.mosque_admins where mosque_id = p_mosque and user_id = p_user and role = 'helper';
end;
$$;
revoke execute on function public.masjid_remove_helper(uuid, uuid) from public, anon;
grant execute on function public.masjid_remove_helper(uuid, uuid) to authenticated;

create or replace function public.masjid_team(p_mosque uuid)
returns table (user_id uuid, full_name text, phone text, role text, title text, permissions text[], created_at timestamptz)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not public.masjid_can(p_mosque, 'team') then
    raise exception 'غير مصرح';
  end if;
  return query
  select a.user_id, p.full_name, p.phone, a.role, a.title, a.permissions, a.created_at
  from public.mosque_admins a join public.profiles p on p.id = a.user_id
  where a.mosque_id = p_mosque
  order by (a.role = 'owner') desc, a.created_at;
end;
$$;
grant execute on function public.masjid_team(uuid) to authenticated;

-- Contact, khutba, iqama offsets, where the mosque is.
create or replace function public.masjid_update_settings(p_mosque uuid, p jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_wa text := nullif(regexp_replace(coalesce(p->>'contact_whatsapp', ''), '[^0-9]', '', 'g'), '');
  v_phone text := nullif(regexp_replace(coalesce(p->>'contact_phone', ''), '[^0-9+]', '', 'g'), '');
begin
  if not public.masjid_can(p_mosque, 'settings') then
    raise exception 'غير مصرح';
  end if;
  update public.mosques set
    address = left(nullif(btrim(p->>'address'), ''), 300),
    area = left(nullif(btrim(p->>'area'), ''), 80),
    governorate = left(nullif(btrim(p->>'governorate'), ''), 60),
    contact_phone = v_phone,
    contact_whatsapp = v_wa,
    payment_note = left(nullif(btrim(p->>'payment_note'), ''), 300),
    friday_khutba_time = nullif(p->>'friday_khutba_time', '')::time,
    khatib = left(nullif(btrim(p->>'khatib'), ''), 80),
    iqama_fajr = nullif(p->>'iqama_fajr', '')::smallint,
    iqama_dhuhr = nullif(p->>'iqama_dhuhr', '')::smallint,
    iqama_asr = nullif(p->>'iqama_asr', '')::smallint,
    iqama_maghrib = nullif(p->>'iqama_maghrib', '')::smallint,
    iqama_isha = nullif(p->>'iqama_isha', '')::smallint,
    updated_at = now()
  where id = p_mosque;
end;
$$;
revoke execute on function public.masjid_update_settings(uuid, jsonb) from public, anon;
grant execute on function public.masjid_update_settings(uuid, jsonb) to authenticated;

-- ============================================================ RPCs: needs

create or replace function public.masjid_needs(p_mosque uuid, p_include_closed boolean default true)
returns table (id uuid, title text, description text, photo_url text, target_amount numeric, status text,
               confirmed_amount numeric, pledged_amount numeric, contributors int, created_at timestamptz, closed_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select n.id, n.title, n.description, n.photo_url, n.target_amount, n.status,
         coalesce((select sum(c.amount) from public.mosque_need_contributions c where c.need_id = n.id and c.status = 'confirmed'), 0),
         coalesce((select sum(c.amount) from public.mosque_need_contributions c where c.need_id = n.id and c.status = 'pledged'), 0),
         (select count(*)::int from public.mosque_need_contributions c where c.need_id = n.id and c.status <> 'cancelled'),
         n.created_at, n.closed_at
  from public.mosque_needs n
  where n.mosque_id = p_mosque and (p_include_closed or n.status = 'open')
  order by (n.status = 'open') desc, n.created_at desc
  limit 100;
$$;
grant execute on function public.masjid_needs(uuid, boolean) to anon, authenticated;

create or replace function public.masjid_pledge(p_need uuid, p_amount numeric, p_note text default null, p_anonymous boolean default false)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  n public.mosque_needs;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into n from public.mosque_needs where id = p_need;
  if not found then
    raise exception 'الاحتياج مش موجود';
  end if;
  if n.status <> 'open' then
    raise exception 'الاحتياج ده اكتمل واتقفل — جزاك الله خيراً';
  end if;
  if p_amount is null or p_amount < 1 or p_amount > 10000000 then
    raise exception 'اكتب مبلغ صحيح';
  end if;
  if (select count(*) from public.mosque_need_contributions
      where user_id = auth.uid() and created_at > now() - interval '1 day') >= 10 then
    raise exception 'سجلت مساهمات كتير النهارده';
  end if;
  insert into public.mosque_need_contributions (need_id, mosque_id, user_id, anonymous, kind, amount, note, status)
  values (p_need, n.mosque_id, auth.uid(), coalesce(p_anonymous, false), 'pledge', round(p_amount, 2),
          left(nullif(btrim(p_note), ''), 300), 'pledged')
  returning id into v_id;
  -- The mosque's needs managers hear about it (to follow up and confirm).
  insert into public.notifications (user_id, title, body, deep_link)
  select a.user_id, 'تعهد جديد بـ ' || trim(to_char(p_amount, 'FM999G999G990')) || ' ج.م',
         'على «' || n.title || '» — أكّد لما المبلغ يوصلك.', '/#/masjid/' || n.mosque_id
  from public.mosque_admins a
  where a.mosque_id = n.mosque_id and (a.role = 'owner' or 'needs' = any(a.permissions))
    and a.user_id <> auth.uid();
  return v_id;
end;
$$;
revoke execute on function public.masjid_pledge(uuid, numeric, text, boolean) from public, anon;
grant execute on function public.masjid_pledge(uuid, numeric, text, boolean) to authenticated;

-- The admin received it → confirmed (once).
create or replace function public.masjid_confirm_contribution(p_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_need_contributions;
  v_title text;
begin
  select * into c from public.mosque_need_contributions where id = p_id for update;
  if not found then
    raise exception 'المساهمة مش موجودة';
  end if;
  if not public.masjid_can(c.mosque_id, 'needs') then
    raise exception 'غير مصرح';
  end if;
  if c.status <> 'pledged' then
    raise exception 'المساهمة دي اتأكدت أو اتلغت قبل كده';
  end if;
  update public.mosque_need_contributions set status = 'confirmed', confirmed_by = auth.uid(), confirmed_at = now() where id = p_id;
  if c.user_id is not null and c.user_id <> auth.uid() then
    select title into v_title from public.mosque_needs where id = c.need_id;
    insert into public.notifications (user_id, title, body, deep_link)
    values (c.user_id, 'مساهمتك وصلت ✓ جزاك الله خيراً',
            'المسجد أكّد استلام ' || trim(to_char(c.amount, 'FM999G999G990')) || ' ج.م لـ «' || v_title || '».',
            '/#/masjid/' || c.mosque_id);
  end if;
end;
$$;
revoke execute on function public.masjid_confirm_contribution(uuid) from public, anon;
grant execute on function public.masjid_confirm_contribution(uuid) to authenticated;

-- The pledger withdraws a pledge, or the admin marks it as never arrived.
create or replace function public.masjid_cancel_contribution(p_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_need_contributions;
begin
  select * into c from public.mosque_need_contributions where id = p_id for update;
  if not found then
    raise exception 'المساهمة مش موجودة';
  end if;
  if c.user_id is distinct from auth.uid() and not public.masjid_can(c.mosque_id, 'needs') then
    raise exception 'غير مصرح';
  end if;
  if c.status <> 'pledged' then
    raise exception 'المساهمة دي اتأكدت أو اتلغت قبل كده';
  end if;
  update public.mosque_need_contributions set status = 'cancelled' where id = p_id;
end;
$$;
revoke execute on function public.masjid_cancel_contribution(uuid) from public, anon;
grant execute on function public.masjid_cancel_contribution(uuid) to authenticated;

-- Cash handed to the mosque directly → recorded as confirmed.
create or replace function public.masjid_add_cash(p_need uuid, p_amount numeric, p_donor_name text default null,
                                                  p_note text default null, p_anonymous boolean default true)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  n public.mosque_needs;
  v_id uuid;
begin
  select * into n from public.mosque_needs where id = p_need;
  if not found then
    raise exception 'الاحتياج مش موجود';
  end if;
  if not public.masjid_can(n.mosque_id, 'needs') then
    raise exception 'غير مصرح';
  end if;
  if p_amount is null or p_amount < 1 or p_amount > 10000000 then
    raise exception 'اكتب مبلغ صحيح';
  end if;
  insert into public.mosque_need_contributions (need_id, mosque_id, user_id, donor_name, anonymous, kind, amount, note,
                                                status, confirmed_by, confirmed_at)
  values (p_need, n.mosque_id, null, left(nullif(btrim(p_donor_name), ''), 80),
          coalesce(p_anonymous, true) or nullif(btrim(p_donor_name), '') is null, 'cash', round(p_amount, 2),
          left(nullif(btrim(p_note), ''), 300), 'confirmed', auth.uid(), now())
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.masjid_add_cash(uuid, numeric, text, text, boolean) from public, anon;
grant execute on function public.masjid_add_cash(uuid, numeric, text, text, boolean) to authenticated;

create or replace function public.masjid_set_need_status(p_need uuid, p_status text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_mosque uuid;
begin
  select mosque_id into v_mosque from public.mosque_needs where id = p_need;
  if v_mosque is null or not public.masjid_can(v_mosque, 'needs') then
    raise exception 'غير مصرح';
  end if;
  if p_status not in ('open', 'closed') then
    raise exception 'حالة غير صحيحة';
  end if;
  update public.mosque_needs
     set status = p_status, closed_at = case when p_status = 'closed' then now() end
   where id = p_need;
end;
$$;
revoke execute on function public.masjid_set_need_status(uuid, text) from public, anon;
grant execute on function public.masjid_set_need_status(uuid, text) to authenticated;

-- Who contributed. An anonymous contribution shows «فاعل خير» to everyone
-- but the contributor and the mosque's needs managers. Notes are private
-- to them too.
create or replace function public.masjid_need_contributions(p_need uuid)
returns table (id uuid, amount numeric, status text, kind text, donor_label text, anonymous boolean,
               is_mine boolean, note text, created_at timestamptz, confirmed_at timestamptz)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_mosque uuid;
  v_manager boolean;
  v_me uuid := auth.uid();
begin
  select n.mosque_id into v_mosque from public.mosque_needs n where n.id = p_need;
  if v_mosque is null then
    return;
  end if;
  v_manager := coalesce(public.masjid_can(v_mosque, 'needs'), false);
  -- Every test below is NULL-safe: for a guest auth.uid() is null.
  return query
  select c.id, c.amount, c.status, c.kind,
         case
           when c.anonymous and not (v_manager or coalesce(c.user_id = v_me, false)) then 'فاعل خير'
           when c.user_id is not null then coalesce(p.full_name, 'فاعل خير')
           else coalesce(c.donor_name, 'فاعل خير')
         end,
         c.anonymous,
         coalesce(c.user_id = v_me, false),
         case when v_manager or coalesce(c.user_id = v_me, false) then c.note end,
         c.created_at, c.confirmed_at
  from public.mosque_need_contributions c
  left join public.profiles p on p.id = c.user_id
  where c.need_id = p_need and (c.status <> 'cancelled' or v_manager or coalesce(c.user_id = v_me, false))
  order by c.created_at desc
  limit 300;
end;
$$;
grant execute on function public.masjid_need_contributions(uuid) to anon, authenticated;

-- ============================================================ RPCs: orphans

create or replace function public.masjid_orphan_programs(p_mosque uuid)
returns table (id uuid, title text, description text, monthly_amount numeric, slots int, status text,
               active_sponsors int, pledged_sponsors int, my_status text, created_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select o.id, o.title, o.description, o.monthly_amount, o.slots, o.status,
         (select count(*)::int from public.mosque_orphan_sponsorships s where s.program_id = o.id and s.status = 'active'),
         (select count(*)::int from public.mosque_orphan_sponsorships s where s.program_id = o.id and s.status = 'pledged'),
         (select s.status from public.mosque_orphan_sponsorships s
           where s.program_id = o.id and s.user_id = auth.uid() and s.status in ('pledged', 'active')
           order by s.created_at desc limit 1),
         o.created_at
  from public.mosque_orphan_programs o
  where o.mosque_id = p_mosque
  order by (o.status = 'open') desc, o.created_at desc
  limit 100;
$$;
grant execute on function public.masjid_orphan_programs(uuid) to anon, authenticated;

create or replace function public.masjid_sponsor(p_program uuid, p_monthly_amount numeric, p_note text default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  o public.mosque_orphan_programs;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into o from public.mosque_orphan_programs where id = p_program;
  if not found or o.status <> 'open' then
    raise exception 'البرنامج ده مش متاح دلوقتي';
  end if;
  if p_monthly_amount is null or p_monthly_amount < 1 or p_monthly_amount > 1000000 then
    raise exception 'اكتب مبلغ شهري صحيح';
  end if;
  if exists (select 1 from public.mosque_orphan_sponsorships
             where program_id = p_program and user_id = auth.uid() and status in ('pledged', 'active')) then
    raise exception 'إنت مسجّل بالفعل في البرنامج ده';
  end if;
  insert into public.mosque_orphan_sponsorships (program_id, mosque_id, user_id, monthly_amount, note)
  values (p_program, o.mosque_id, auth.uid(), round(p_monthly_amount, 2), left(nullif(btrim(p_note), ''), 300))
  returning id into v_id;
  insert into public.notifications (user_id, title, body, deep_link)
  select a.user_id, 'كفيل جديد بـ ' || trim(to_char(p_monthly_amount, 'FM999G999G990')) || ' ج.م شهرياً',
         'على «' || o.title || '» — تواصل معاه وأكّد لما يبدأ.', '/#/masjid/' || o.mosque_id
  from public.mosque_admins a
  where a.mosque_id = o.mosque_id and (a.role = 'owner' or 'orphans' = any(a.permissions)) and a.user_id <> auth.uid();
  return v_id;
end;
$$;
revoke execute on function public.masjid_sponsor(uuid, numeric, text) from public, anon;
grant execute on function public.masjid_sponsor(uuid, numeric, text) to authenticated;

create or replace function public.masjid_set_sponsorship_status(p_id uuid, p_status text)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  s public.mosque_orphan_sponsorships;
  v_manager boolean;
begin
  select * into s from public.mosque_orphan_sponsorships where id = p_id for update;
  if not found then
    raise exception 'الكفالة مش موجودة';
  end if;
  v_manager := public.masjid_can(s.mosque_id, 'orphans');
  if p_status = 'active' then
    if not v_manager then
      raise exception 'غير مصرح';
    end if;
    if s.status <> 'pledged' then
      raise exception 'الكفالة دي اتأكدت أو اتلغت قبل كده';
    end if;
    update public.mosque_orphan_sponsorships set status = 'active', confirmed_by = auth.uid(), confirmed_at = now() where id = p_id;
  elsif p_status in ('ended', 'cancelled') then
    if not v_manager and s.user_id is distinct from auth.uid() then
      raise exception 'غير مصرح';
    end if;
    if s.status not in ('pledged', 'active') then
      raise exception 'الكفالة دي منتهية بالفعل';
    end if;
    update public.mosque_orphan_sponsorships
       set status = case when s.status = 'pledged' then 'cancelled' else 'ended' end
     where id = p_id;
  else
    raise exception 'حالة غير صحيحة';
  end if;
end;
$$;
revoke execute on function public.masjid_set_sponsorship_status(uuid, text) from public, anon;
grant execute on function public.masjid_set_sponsorship_status(uuid, text) to authenticated;

-- The mosque's orphans managers follow up with sponsors (sponsor data
-- only — there is no child data anywhere).
create or replace function public.masjid_orphan_sponsors(p_program uuid)
returns table (id uuid, full_name text, phone text, monthly_amount numeric, note text, status text,
               created_at timestamptz, confirmed_at timestamptz)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_mosque uuid;
begin
  select o.mosque_id into v_mosque from public.mosque_orphan_programs o where o.id = p_program;
  if v_mosque is null or not public.masjid_can(v_mosque, 'orphans') then
    raise exception 'غير مصرح';
  end if;
  return query
  select s.id, p.full_name, p.phone, s.monthly_amount, s.note, s.status, s.created_at, s.confirmed_at
  from public.mosque_orphan_sponsorships s join public.profiles p on p.id = s.user_id
  where s.program_id = p_program
  order by (s.status = 'pledged') desc, s.created_at desc
  limit 500;
end;
$$;
grant execute on function public.masjid_orphan_sponsors(uuid) to authenticated;

create or replace function public.masjid_my_sponsorships()
returns table (id uuid, program_id uuid, mosque_id uuid, mosque_name text, title text, monthly_amount numeric,
               status text, created_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select s.id, s.program_id, s.mosque_id, m.name, o.title, s.monthly_amount, s.status, s.created_at
  from public.mosque_orphan_sponsorships s
  join public.mosque_orphan_programs o on o.id = s.program_id
  join public.mosques m on m.id = s.mosque_id
  where s.user_id = auth.uid()
  order by s.created_at desc;
$$;
grant execute on function public.masjid_my_sponsorships() to authenticated;

-- ======================================================= RPCs: competitions

create or replace function public.masjid_register_competition(
  p_competition uuid, p_level uuid, p_name text, p_age int default null, p_phone text default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_competitions;
  v_id uuid;
  v_phone text := nullif(regexp_replace(coalesce(p_phone, ''), '[^0-9]', '', 'g'), '');
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into c from public.mosque_competitions where id = p_competition;
  if not found then
    raise exception 'المسابقة مش موجودة';
  end if;
  if c.status <> 'open' or (c.registration_deadline is not null and c.registration_deadline < (now() at time zone 'Africa/Cairo')::date) then
    raise exception 'التسجيل في المسابقة دي اتقفل';
  end if;
  if not exists (select 1 from public.mosque_competition_levels l where l.id = p_level and l.competition_id = p_competition) then
    raise exception 'اختار المستوى';
  end if;
  if char_length(btrim(coalesce(p_name, ''))) < 2 then
    raise exception 'اكتب اسم المتسابق';
  end if;
  if v_phone is not null and v_phone !~ '^01[0-9]{9}$' then
    raise exception 'رقم الموبايل لازم يكون 11 رقم ويبدأ بـ 01';
  end if;
  if (select count(*) from public.mosque_competition_entries
      where competition_id = p_competition and user_id = auth.uid() and status = 'registered') >= 6 then
    raise exception 'سجلت عدد كبير في المسابقة دي';
  end if;
  insert into public.mosque_competition_entries (competition_id, level_id, mosque_id, user_id, contestant_name, contestant_age, phone)
  values (p_competition, p_level, c.mosque_id, auth.uid(), left(btrim(p_name), 80), p_age, v_phone)
  on conflict (competition_id, user_id, contestant_name) do update
    set level_id = excluded.level_id, contestant_age = excluded.contestant_age, phone = excluded.phone, status = 'registered'
  returning id into v_id;
  return v_id;
end;
$$;
revoke execute on function public.masjid_register_competition(uuid, uuid, text, int, text) from public, anon;
grant execute on function public.masjid_register_competition(uuid, uuid, text, int, text) to authenticated;

create or replace function public.masjid_withdraw_entry(p_entry uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.mosque_competition_entries set status = 'withdrawn'
   where id = p_entry and user_id = auth.uid() and status = 'registered';
  if not found then
    raise exception 'التسجيل مش موجود';
  end if;
end;
$$;
revoke execute on function public.masjid_withdraw_entry(uuid) from public, anon;
grant execute on function public.masjid_withdraw_entry(uuid) to authenticated;

-- Managers see every entry (with the phone); others only their own.
create or replace function public.masjid_competition_entries(p_competition uuid)
returns table (id uuid, level_id uuid, level_name text, contestant_name text, contestant_age smallint, phone text,
               registered_by text, status text, score numeric, rank int, result_note text, is_mine boolean, created_at timestamptz)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_mosque uuid;
  v_manager boolean;
begin
  select c.mosque_id into v_mosque from public.mosque_competitions c where c.id = p_competition;
  if v_mosque is null then
    return;
  end if;
  v_manager := coalesce(public.masjid_can(v_mosque, 'competitions'), false);
  return query
  select e.id, e.level_id, l.name, e.contestant_name, e.contestant_age,
         case when v_manager or coalesce(e.user_id = auth.uid(), false) then e.phone end,
         case when v_manager then p.full_name end,
         e.status, e.score, e.rank, e.result_note, coalesce(e.user_id = auth.uid(), false), e.created_at
  from public.mosque_competition_entries e
  join public.mosque_competition_levels l on l.id = e.level_id
  join public.profiles p on p.id = e.user_id
  where e.competition_id = p_competition and (v_manager or e.user_id = auth.uid())
  order by l.sort, e.rank nulls last, e.created_at;
end;
$$;
grant execute on function public.masjid_competition_entries(uuid) to authenticated;

create or replace function public.masjid_set_entry_result(p_entry uuid, p_score numeric, p_rank int, p_note text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_mosque uuid;
begin
  select mosque_id into v_mosque from public.mosque_competition_entries where id = p_entry;
  if v_mosque is null or not public.masjid_can(v_mosque, 'competitions') then
    raise exception 'غير مصرح';
  end if;
  update public.mosque_competition_entries
     set score = p_score, rank = p_rank, result_note = left(nullif(btrim(p_note), ''), 200)
   where id = p_entry;
end;
$$;
revoke execute on function public.masjid_set_entry_result(uuid, numeric, int, text) from public, anon;
grant execute on function public.masjid_set_entry_result(uuid, numeric, int, text) to authenticated;

create or replace function public.masjid_publish_results(p_competition uuid, p_publish boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  c public.mosque_competitions;
begin
  select * into c from public.mosque_competitions where id = p_competition;
  if not found or not public.masjid_can(c.mosque_id, 'competitions') then
    raise exception 'غير مصرح';
  end if;
  update public.mosque_competitions
     set results_published = coalesce(p_publish, false),
         status = case when p_publish then 'finished' else status end
   where id = p_competition;
  if p_publish and not c.results_published then
    insert into public.notifications (user_id, title, body, deep_link)
    select distinct e.user_id, 'نتيجة «' || c.title || '» ظهرت', 'افتح صفحة المسجد وشوف النتيجة.', '/#/masjid/' || c.mosque_id
    from public.mosque_competition_entries e
    where e.competition_id = p_competition and e.status = 'registered';
  end if;
end;
$$;
revoke execute on function public.masjid_publish_results(uuid, boolean) from public, anon;
grant execute on function public.masjid_publish_results(uuid, boolean) to authenticated;

-- Public results: only once the admin published them, ranked entries only.
create or replace function public.masjid_competition_results(p_competition uuid)
returns table (level_name text, contestant_name text, rank int, score numeric, result_note text)
language sql
stable
security definer
set search_path = public
as $$
  select l.name, e.contestant_name, e.rank, e.score, e.result_note
  from public.mosque_competition_entries e
  join public.mosque_competition_levels l on l.id = e.level_id
  join public.mosque_competitions c on c.id = e.competition_id
  where e.competition_id = p_competition and c.results_published and e.status = 'registered' and e.rank is not null
  order by l.sort, e.rank
  limit 500;
$$;
grant execute on function public.masjid_competition_results(uuid) to anon, authenticated;

create or replace function public.masjid_competition_counts(p_mosque uuid)
returns table (competition_id uuid, registered int, my_entries int)
language sql
stable
security definer
set search_path = public
as $$
  select c.id,
         (select count(*)::int from public.mosque_competition_entries e where e.competition_id = c.id and e.status = 'registered'),
         (select count(*)::int from public.mosque_competition_entries e where e.competition_id = c.id and e.status = 'registered' and e.user_id = auth.uid())
  from public.mosque_competitions c
  where c.mosque_id = p_mosque;
$$;
grant execute on function public.masjid_competition_counts(uuid) to anon, authenticated;

-- Internal helpers are never callable from the app.
revoke execute on function public._masjid_post_stamp() from public, anon, authenticated;
revoke execute on function public._masjid_need_stamp() from public, anon, authenticated;
revoke execute on function public._masjid_content_notify() from public, anon, authenticated;

-- Signed-in-only RPCs: not for anon (functions are executable by PUBLIC by default).
revoke execute on function public.admin_list_mosque_claims(text) from public, anon;
revoke execute on function public.admin_review_mosque_claim(uuid, boolean, text) from public, anon;
revoke execute on function public.admin_remove_mosque_admin(uuid, uuid) from public, anon;
revoke execute on function public.masjid_team(uuid) from public, anon;
revoke execute on function public.masjid_orphan_sponsors(uuid) from public, anon;
revoke execute on function public.masjid_competition_entries(uuid) from public, anon;
revoke execute on function public.my_followed_mosques() from public, anon;
revoke execute on function public.my_managed_mosques() from public, anon;
revoke execute on function public.masjid_my_claims() from public, anon;
revoke execute on function public.masjid_my_sponsorships() from public, anon;
