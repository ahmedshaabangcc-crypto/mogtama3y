-- =====================================================================
-- Migration 0029 — real union community feed (posts/comments/
-- reactions). Found via a real trust problem, not just an incomplete
-- feature: union_feed_screen.dart was reachable straight from the home
-- screen's "اتحاد الملاك" tile with NO auth or membership check at
-- all, and showed 100% fabricated content — a fake building ("برج
-- الياسمين"), fake residents, a fake "100% موثق" stat, fake posts with
-- fake engagement counts — to literally any visitor, signed in or not.
-- In an app whose whole pitch is trust/anti-fraud, presenting invented
-- social proof as if it were real is a real integrity problem, not
-- just unfinished work — fixed as a priority rather than left for
-- later. Run after 0002-0028, in order, in the Supabase SQL editor.
--
-- posts itself already had a real GRANT + RLS (0007, schema.sql) that
-- nothing ever used. post_comments/post_reactions had RLS enabled with
-- no policies and no grants — this migration finishes wiring the trio
-- as one real feature.
-- =====================================================================

grant select, insert on public.post_comments to authenticated;
grant select, insert, delete on public.post_reactions to authenticated;

create policy "post_comments: building members read" on public.post_comments
  for select using (
    exists (select 1 from public.posts p where p.id = post_comments.post_id and public.is_verified_member_of(p.building_id))
  );

create policy "post_comments: building members write" on public.post_comments
  for insert with check (
    auth.uid() = author_id
    and exists (select 1 from public.posts p where p.id = post_comments.post_id and public.is_verified_member_of(p.building_id))
  );

create policy "post_reactions: building members read" on public.post_reactions
  for select using (
    exists (select 1 from public.posts p where p.id = post_reactions.post_id and public.is_verified_member_of(p.building_id))
  );

create policy "post_reactions: building members react" on public.post_reactions
  for insert with check (
    auth.uid() = user_id
    and exists (select 1 from public.posts p where p.id = post_reactions.post_id and public.is_verified_member_of(p.building_id))
  );

create policy "post_reactions: user unreacts own" on public.post_reactions
  for delete using (auth.uid() = user_id);

-- real, count-only feed query — avoids the ambiguous ordering/embed
-- pitfalls hit earlier this session by returning flat counts directly.
create or replace function public.fetch_building_posts(p_building_id uuid)
returns table (
  id uuid, author_id uuid, author_name text, type text, body text,
  images text[], is_pinned boolean, created_at timestamptz,
  comment_count bigint, reaction_count bigint
)
language sql
stable
security invoker
set search_path = public
as $$
  select
    p.id, p.author_id, pr.full_name, p.type::text, p.body, p.images, p.is_pinned, p.created_at,
    (select count(*) from public.post_comments c where c.post_id = p.id),
    (select count(*) from public.post_reactions r where r.post_id = p.id)
  from public.posts p
  join public.profiles pr on pr.id = p.author_id
  where p.building_id = p_building_id
  order by p.is_pinned desc, p.created_at desc;
$$;

grant execute on function public.fetch_building_posts(uuid) to authenticated;
