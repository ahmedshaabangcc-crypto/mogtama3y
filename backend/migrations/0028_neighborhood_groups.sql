-- =====================================================================
-- Migration 0028 — real "جروب الحي" (neighborhood group), a tier above
-- the building union. Per Ahmed's explicit answers when asked to
-- clarify scope (2026-09-12):
--   * Content: BOTH a posts feed AND a live chat, same shape as the
--     union feed / building chat, just scoped one level broader.
--   * Data model: a real dedicated `neighborhoods` table (name +
--     google_place_id), same dedup pattern as buildings in
--     0017_buildings_registry.sql — NOT a free-text grouping off
--     buildings.district.
--   * Membership: self-declared, NO verification step — joining is
--     just "I live in this area", instant, no review queue.
-- Run after 0002-0027, in order, in the Supabase SQL editor.
-- =====================================================================

create table public.neighborhoods (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  google_place_id text unique,
  city text,
  governorate text,
  lat numeric(9,6),
  lng numeric(9,6),
  created_at timestamptz not null default now()
);

create table public.neighborhood_members (
  id uuid primary key default gen_random_uuid(),
  neighborhood_id uuid not null references public.neighborhoods(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  unique (neighborhood_id, user_id)
);

create table public.neighborhood_posts (
  id uuid primary key default gen_random_uuid(),
  neighborhood_id uuid not null references public.neighborhoods(id) on delete cascade,
  author_id uuid not null references public.profiles(id),
  body text not null,
  images text[] default '{}',
  created_at timestamptz not null default now()
);

create table public.neighborhood_chat_messages (
  id uuid primary key default gen_random_uuid(),
  neighborhood_id uuid not null references public.neighborhoods(id) on delete cascade,
  sender_id uuid not null references public.profiles(id),
  body text not null,
  created_at timestamptz not null default now()
);

grant select, insert on public.neighborhoods to authenticated;
grant select, insert, delete on public.neighborhood_members to authenticated;
grant select, insert on public.neighborhood_posts to authenticated;
grant select, insert on public.neighborhood_chat_messages to authenticated;

create policy "neighborhoods: public read" on public.neighborhoods
  for select using (true);

create or replace function public.is_neighborhood_member(p_neighborhood_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.neighborhood_members
    where neighborhood_id = p_neighborhood_id and user_id = auth.uid()
  );
$$;

create policy "neighborhood_members: user views own" on public.neighborhood_members
  for select using (auth.uid() = user_id);

create policy "neighborhood_members: self join" on public.neighborhood_members
  for insert with check (auth.uid() = user_id);

create policy "neighborhood_members: self leave" on public.neighborhood_members
  for delete using (auth.uid() = user_id);

create policy "neighborhood_posts: members read" on public.neighborhood_posts
  for select using (public.is_neighborhood_member(neighborhood_id));

create policy "neighborhood_posts: members write" on public.neighborhood_posts
  for insert with check (auth.uid() = author_id and public.is_neighborhood_member(neighborhood_id));

create policy "neighborhood_chat_messages: members read" on public.neighborhood_chat_messages
  for select using (public.is_neighborhood_member(neighborhood_id));

create policy "neighborhood_chat_messages: members write" on public.neighborhood_chat_messages
  for insert with check (auth.uid() = sender_id and public.is_neighborhood_member(neighborhood_id));

-- ---- join_or_create_neighborhood(): dedupe by google_place_id, same pattern as found_building() ----

create or replace function public.join_or_create_neighborhood(
  p_name text,
  p_google_place_id text,
  p_city text,
  p_governorate text,
  p_lat numeric,
  p_lng numeric
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  if p_google_place_id is not null then
    select id into v_id from public.neighborhoods where google_place_id = p_google_place_id;
  end if;

  if v_id is null then
    insert into public.neighborhoods (name, google_place_id, city, governorate, lat, lng)
    values (p_name, p_google_place_id, p_city, p_governorate, p_lat, p_lng)
    returning id into v_id;
  end if;

  insert into public.neighborhood_members (neighborhood_id, user_id)
  values (v_id, auth.uid())
  on conflict (neighborhood_id, user_id) do nothing;

  return v_id;
end;
$$;

grant execute on function public.join_or_create_neighborhood(text, text, text, text, numeric, numeric) to authenticated;
