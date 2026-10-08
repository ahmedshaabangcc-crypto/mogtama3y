-- =====================================================================
-- Migration 0079 — فيديوهات الشرح (in-app tutorial videos, YouTube Shorts)
--
--   * tutorial_videos: one row per YouTube Short, per app (flavor).
--     `screen_key` ties a video to a screen's «شوف الشرح» button
--     (ittihad: found, join, tenants, elections, visitor_pass, sos…). It
--     is free text with a charset/length check, not a closed list, so
--     new keys (e.g. for tajer) need no migration.
--   * Everyone (anon included) reads the ACTIVE rows — the «المزيد»
--     list and the help buttons show before sign-in too. The platform
--     admin reads every row and is the only one who can write (RLS on
--     is_super_admin(); no self-service way to become one).
--   * Nothing is seeded: the owner adds the IDs from the admin panel.
--
-- Run after 0078, in order, in the Supabase SQL editor.
-- =====================================================================

create table if not exists public.tutorial_videos (
  id          uuid primary key default gen_random_uuid(),
  app         text not null check (app in ('ittihad', 'tajer', 'mogtama3y')),
  youtube_id  text not null check (youtube_id ~ '^[A-Za-z0-9_-]{11}$'),
  title       text not null check (char_length(btrim(title)) between 1 and 80),
  sort        int not null default 0,
  screen_key  text null check (screen_key is null or screen_key ~ '^[a-z][a-z0-9_]{0,39}$'),
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index if not exists tutorial_videos_app_idx on public.tutorial_videos (app, is_active, sort);

alter table public.tutorial_videos enable row level security;

-- Keep updated_at honest whoever edits the row.
create or replace function public._tutorial_videos_touch() returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

revoke execute on function public._tutorial_videos_touch() from public, anon, authenticated;

drop trigger if exists tutorial_videos_touch on public.tutorial_videos;
create trigger tutorial_videos_touch before update on public.tutorial_videos
  for each row execute function public._tutorial_videos_touch();

-- ---- grants (RLS decides which rows) ----
revoke all on public.tutorial_videos from public, anon, authenticated;
grant select on public.tutorial_videos to anon, authenticated;
grant insert (app, youtube_id, title, sort, screen_key, is_active),
      update (app, youtube_id, title, sort, screen_key, is_active),
      delete
   on public.tutorial_videos to authenticated;

-- ---- policies ----
drop policy if exists "tutorial_videos: active are public" on public.tutorial_videos;
create policy "tutorial_videos: active are public" on public.tutorial_videos
  for select to anon, authenticated using (is_active);

drop policy if exists "tutorial_videos: admin reads all" on public.tutorial_videos;
create policy "tutorial_videos: admin reads all" on public.tutorial_videos
  for select to authenticated using (public.is_super_admin());

drop policy if exists "tutorial_videos: admin inserts" on public.tutorial_videos;
create policy "tutorial_videos: admin inserts" on public.tutorial_videos
  for insert to authenticated with check (public.is_super_admin());

drop policy if exists "tutorial_videos: admin updates" on public.tutorial_videos;
create policy "tutorial_videos: admin updates" on public.tutorial_videos
  for update to authenticated using (public.is_super_admin()) with check (public.is_super_admin());

drop policy if exists "tutorial_videos: admin deletes" on public.tutorial_videos;
create policy "tutorial_videos: admin deletes" on public.tutorial_videos
  for delete to authenticated using (public.is_super_admin());
