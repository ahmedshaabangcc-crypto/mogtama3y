-- =====================================================================
-- 0070 — Event venues ("قاعات المناسبات").
--
-- Venue owners list a hall (wedding hall, party hall, conference room,
-- rooftop / garden, hotel ballroom, club, café for small events, boat):
-- what it suits (فرح، خطوبة، كتب كتاب…), capacity, a starting price per
-- event or per person, what's included, place, photos and a contact
-- phone / WhatsApp. No booking — listings + contact only.
--
-- Access (same pattern as car_listings, 0066):
--   * public (anon + authenticated) read of ACTIVE rows; owners also see
--     their own hidden rows (for "إعلاناتي");
--   * owners insert/update/delete only their own rows (owner_id = auth.uid());
--   * super admins moderate everything; is_featured is theirs only — a
--     trigger keeps it unchanged for everyone else;
--   * express_interest_in_hall() lets a signed-in user tell the owner
--     "أنا مهتم" through an in-app notification.
-- =====================================================================

create table if not exists public.event_halls (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  name text not null check (length(trim(name)) between 3 and 120),
  hall_type text not null check (hall_type in (
    'wedding', 'events', 'conference', 'rooftop_garden', 'hotel', 'club', 'cafe_restaurant', 'boat')),
  occasions text[] not null default '{}' check (occasions <@ array[
    'wedding', 'engagement', 'katb_ketab', 'birthday', 'condolence', 'conference', 'graduation']::text[]),
  capacity_min int check (capacity_min is null or capacity_min >= 1),
  capacity_max int not null check (capacity_max between 1 and 20000),
  price_from numeric(12,2) check (price_from is null or price_from > 0),
  price_per_person boolean not null default false,
  included text[] not null default '{}' check (included <@ array[
    'buffet', 'dj', 'photography', 'kosha_decor', 'air_conditioned', 'parking', 'prayer_room', 'bride_room']::text[]),
  description text check (description is null or length(description) <= 3000),
  governorate text not null check (length(trim(governorate)) > 0),
  area text check (area is null or length(area) <= 80),
  address text check (address is null or length(address) <= 300),
  -- Egyptian mobile or landline (digits only, 8–11 long, starts with 0).
  phone text not null check (phone ~ '^0[0-9]{7,10}$'),
  whatsapp text check (whatsapp is null or whatsapp ~ '^01[0125][0-9]{8}$'),
  images text[] not null default '{}' check (cardinality(images) <= 20),
  is_active boolean not null default true,
  is_featured boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint event_halls_capacity_range check (capacity_min is null or capacity_min <= capacity_max)
);

create index if not exists event_halls_browse
  on public.event_halls (is_active, hall_type, is_featured desc, created_at desc);
create index if not exists event_halls_governorate
  on public.event_halls (governorate, created_at desc) where is_active;
create index if not exists event_halls_occasions
  on public.event_halls using gin (occasions);
create index if not exists event_halls_owner
  on public.event_halls (owner_id, created_at desc);

alter table public.event_halls enable row level security;
revoke all on public.event_halls from anon, authenticated;
grant select on public.event_halls to anon, authenticated;
grant insert, update, delete on public.event_halls to authenticated;

drop policy if exists "event_halls: public reads active" on public.event_halls;
create policy "event_halls: public reads active" on public.event_halls
  for select to anon, authenticated using (is_active);

drop policy if exists "event_halls: owner reads own" on public.event_halls;
create policy "event_halls: owner reads own" on public.event_halls
  for select to authenticated using (owner_id = auth.uid());

drop policy if exists "event_halls: owner inserts" on public.event_halls;
create policy "event_halls: owner inserts" on public.event_halls
  for insert to authenticated with check (owner_id = auth.uid());

drop policy if exists "event_halls: owner updates" on public.event_halls;
create policy "event_halls: owner updates" on public.event_halls
  for update to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "event_halls: owner deletes" on public.event_halls;
create policy "event_halls: owner deletes" on public.event_halls
  for delete to authenticated using (owner_id = auth.uid());

drop policy if exists "event_halls: super_admin manages all" on public.event_halls;
create policy "event_halls: super_admin manages all" on public.event_halls
  for all to authenticated using (public.is_super_admin()) with check (public.is_super_admin());

-- Featured placement is decided by the team, never by the owner; also
-- stamps updated_at.
create or replace function public.guard_event_hall() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if current_user = 'anon'
     or (current_user = 'authenticated' and not public.is_super_admin()) then
    if tg_op = 'INSERT' then
      new.is_featured := false;
    else
      new.is_featured := old.is_featured;
    end if;
  end if;
  if tg_op = 'UPDATE' then
    new.updated_at := now();
  end if;
  return new;
end;
$$;

drop trigger if exists guard_event_hall on public.event_halls;
create trigger guard_event_hall
  before insert or update on public.event_halls
  for each row execute function public.guard_event_hall();

-- ---------------------------------------------------------------- interest
-- "أنا مهتم": notify the owner with the interested user's name.
create or replace function public.express_interest_in_hall(p_hall_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_owner uuid;
  v_name_hall text;
  v_body text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  select owner_id, name into v_owner, v_name_hall
  from public.event_halls where id = p_hall_id and is_active;
  if v_owner is null then raise exception 'القاعة مش موجودة'; end if;
  if v_owner = auth.uid() then raise exception 'دي قاعتك'; end if;
  select coalesce(nullif(trim(full_name), ''), 'حد') into v_body from public.profiles where id = auth.uid();
  v_body := coalesce(v_body, 'حد') || ' مهتم بـ «' || v_name_hall || '»';
  -- Tapping twice in a row doesn't spam the owner.
  if exists (select 1 from public.notifications
             where user_id = v_owner and deep_link = '/#/halls/' || p_hall_id
               and body = v_body and created_at > now() - interval '1 day') then
    return;
  end if;
  insert into public.notifications (user_id, title, body, deep_link)
  values (v_owner, 'في حد مهتم بقاعتك', v_body, '/#/halls/' || p_hall_id);
end;
$$;

revoke execute on function public.express_interest_in_hall(uuid) from public, anon;
grant execute on function public.express_interest_in_hall(uuid) to authenticated;
