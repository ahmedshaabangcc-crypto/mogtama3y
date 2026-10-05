-- =====================================================================
-- 0063 — Reports: as many photos as needed, plus video.
--
-- * Photos: the 4-photo cap is lifted (a safety ceiling of 30 stays, so a
--   broken client can't store thousands of URLs; photos are resized to
--   1280 px before upload).
-- * Video, two ways:
--     video_url  — a short clip uploaded to our VPS (dalil.mogtama3y.com/
--                  media/…; Supabase's free tier can't carry video);
--     video_link — a TikTok / YouTube / Facebook / Instagram link.
-- =====================================================================

alter table public.reports drop constraint if exists reports_photos_check;
alter table public.reports add constraint reports_photos_check check (cardinality(photos) <= 30);

alter table public.reports add column if not exists video_url text
  check (video_url is null or video_url ~ '^https://dalil\.mogtama3y\.com/media/v/[A-Za-z0-9/_.-]+$');
alter table public.reports add column if not exists video_link text
  check (video_link is null or video_link ~* '^https://([a-z0-9-]+\.)*(tiktok\.com|youtube\.com|youtu\.be|facebook\.com|fb\.watch|instagram\.com)/');

-- Public JSON now carries the video fields.
create or replace function public.report_public_json(r public.reports) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'id', r.id, 'category', r.category, 'description', r.description, 'photos', to_jsonb(r.photos),
    'video_url', r.video_url, 'video_link', r.video_link,
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

-- submit_report gains the two video parameters (old signature replaced).
drop function if exists public.submit_report(text, text, text[], double precision, double precision, text, text, boolean);
create or replace function public.submit_report(
  p_category text, p_description text, p_photos text[], p_lat double precision, p_lng double precision,
  p_governorate text default null, p_district text default null, p_hide_identity boolean default false,
  p_video_url text default null, p_video_link text default null
) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول عشان تبلّغ'; end if;
  if (select count(*) from public.reports where user_id = auth.uid() and created_at > now() - interval '1 day') >= 5 then
    raise exception 'وصلت لحد 5 بلاغات في اليوم، كمّل بكرة';
  end if;
  -- An uploaded video must be the caller's own file (path starts with their id).
  if nullif(trim(coalesce(p_video_url, '')), '') is not null
     and p_video_url not like 'https://dalil.mogtama3y.com/media/v/' || auth.uid() || '/%' then
    raise exception 'الفيديو ده مش بتاعك';
  end if;
  insert into public.reports (user_id, category, description, photos, lat, lng, governorate, district, hide_identity, video_url, video_link)
  values (auth.uid(), p_category, trim(p_description), coalesce(p_photos, '{}'), p_lat, p_lng,
          nullif(trim(coalesce(p_governorate, '')), ''), nullif(trim(coalesce(p_district, '')), ''), coalesce(p_hide_identity, false),
          nullif(trim(coalesce(p_video_url, '')), ''), nullif(trim(coalesce(p_video_link, '')), ''))
  returning id into v_id;
  insert into public.report_events (report_id, status, actor_id) values (v_id, 'new', auth.uid());
  return v_id;
end;
$$;
revoke execute on function public.submit_report(text, text, text[], double precision, double precision, text, text, boolean, text, text) from public, anon;
grant execute on function public.submit_report(text, text, text[], double precision, double precision, text, text, boolean, text, text) to authenticated;
