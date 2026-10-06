-- =====================================================================
-- 0069 — Private tutoring ("دروس خصوصية").
--
-- Teachers and tutors post a listing: subjects, stages, curriculum, where
-- they teach (student's home, their place, a centre, online), a price per
-- session or per month, place, experience, a short bio, photos and a
-- phone / WhatsApp. Students and parents browse the active listings
-- (guests too); signed-in users post and manage their own.
--
-- Access:
--   * public (anon + authenticated) read of ACTIVE rows; owners also see
--     their own inactive rows (for "إعلاناتي");
--   * owners insert/update/delete only their own rows (owner_id = auth.uid());
--   * a super admin can moderate (read / edit / delete) everything;
--   * tutor_name / tutor_avatar always come from the owner's profile (a
--     trigger fills them), so nobody can post under someone else's name;
--   * express_interest_in_tutor() lets a signed-in user tell the tutor
--     "عايز أحجز" through a notification.
-- =====================================================================

create table if not exists public.tutor_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  tutor_name text not null default '',
  tutor_avatar text,
  subjects text[] not null check (
    cardinality(subjects) between 1 and 15
    and subjects <@ array['arabic', 'english', 'math', 'science', 'physics', 'chemistry', 'biology',
                          'social_studies', 'french', 'german', 'quran', 'programming', 'music', 'drawing', 'other']),
  stages text[] not null check (
    cardinality(stages) between 1 and 5
    and stages <@ array['primary', 'preparatory', 'secondary', 'university', 'adults']),
  curricula text[] not null default '{}' check (
    curricula <@ array['arabic', 'languages', 'ig', 'american', 'ib']),
  modes text[] not null check (
    cardinality(modes) between 1 and 4
    and modes <@ array['student_home', 'tutor_place', 'center', 'online']),
  price numeric(10,2) not null check (price > 0 and price <= 100000),
  price_unit text not null default 'session' check (price_unit in ('session', 'month')),
  governorate text check (governorate is null or length(governorate) <= 40),
  area text check (area is null or length(area) <= 80),
  experience_years int check (experience_years between 0 and 60),
  bio text check (bio is null or length(bio) <= 1500),
  images text[] not null default '{}' check (cardinality(images) <= 6),
  phone text check (phone is null or phone ~ '^01[0125][0-9]{8}$'),
  whatsapp text check (whatsapp is null or whatsapp ~ '^01[0125][0-9]{8}$'),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- Students need a way to reach the tutor.
  constraint tutor_listings_contact_required check (phone is not null or whatsapp is not null)
);

create index if not exists tutor_listings_browse
  on public.tutor_listings (is_active, created_at desc);
create index if not exists tutor_listings_subjects
  on public.tutor_listings using gin (subjects);
create index if not exists tutor_listings_owner
  on public.tutor_listings (owner_id, created_at desc);

alter table public.tutor_listings enable row level security;
revoke all on public.tutor_listings from anon, authenticated;
grant select on public.tutor_listings to anon, authenticated;
grant insert, update, delete on public.tutor_listings to authenticated;

drop policy if exists "tutor_listings: public reads active" on public.tutor_listings;
create policy "tutor_listings: public reads active" on public.tutor_listings
  for select to anon, authenticated using (is_active);

drop policy if exists "tutor_listings: owner reads own" on public.tutor_listings;
create policy "tutor_listings: owner reads own" on public.tutor_listings
  for select to authenticated using (owner_id = auth.uid());

drop policy if exists "tutor_listings: owner inserts" on public.tutor_listings;
create policy "tutor_listings: owner inserts" on public.tutor_listings
  for insert to authenticated with check (owner_id = auth.uid());

drop policy if exists "tutor_listings: owner updates" on public.tutor_listings;
create policy "tutor_listings: owner updates" on public.tutor_listings
  for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "tutor_listings: owner deletes" on public.tutor_listings;
create policy "tutor_listings: owner deletes" on public.tutor_listings
  for delete to authenticated using (owner_id = auth.uid());

drop policy if exists "tutor_listings: super_admin manages all" on public.tutor_listings;
create policy "tutor_listings: super_admin manages all" on public.tutor_listings
  for all to authenticated using (public.is_super_admin()) with check (public.is_super_admin());

-- The name and photo shown on a listing are the owner's profile ones —
-- whatever the client sends is replaced. Also keeps updated_at fresh.
create or replace function public.fill_tutor_listing_profile() returns trigger
language plpgsql security definer
set search_path = public
as $$
begin
  select coalesce(nullif(trim(p.full_name), ''), 'مدرس'), p.avatar_url
    into new.tutor_name, new.tutor_avatar
  from public.profiles p where p.id = new.owner_id;
  new.tutor_name := coalesce(new.tutor_name, 'مدرس');
  if tg_op = 'UPDATE' then
    new.created_at := old.created_at;
    new.updated_at := now();
  end if;
  return new;
end;
$$;

revoke execute on function public.fill_tutor_listing_profile() from public, anon, authenticated;

drop trigger if exists fill_tutor_listing_profile on public.tutor_listings;
create trigger fill_tutor_listing_profile
  before insert or update on public.tutor_listings
  for each row execute function public.fill_tutor_listing_profile();

-- ---------------------------------------------------------------- interest
-- "عايز أحجز": notify the tutor with the interested user's name.
create or replace function public.express_interest_in_tutor(p_listing_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_owner uuid;
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select owner_id into v_owner
  from public.tutor_listings where id = p_listing_id and is_active;
  if v_owner is null then raise exception 'الإعلان مش موجود'; end if;
  if v_owner = auth.uid() then raise exception 'ده إعلانك'; end if;
  select coalesce(nullif(trim(full_name), ''), 'حد') into v_name from public.profiles where id = auth.uid();
  v_name := coalesce(v_name, 'حد') || ' مهتم بدروسك وعايز يحجز معاك';
  -- Tapping twice in a row doesn't spam the tutor.
  if exists (select 1 from public.notifications
             where user_id = v_owner and deep_link = '/#/tutoring/' || p_listing_id
               and body = v_name and created_at > now() - interval '1 day') then
    return;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (v_owner, 'طالب مهتم بدروسك', v_name, '/#/tutoring/' || p_listing_id);
end;
$$;

revoke execute on function public.express_interest_in_tutor(uuid) from public, anon;
grant execute on function public.express_interest_in_tutor(uuid) to authenticated;
