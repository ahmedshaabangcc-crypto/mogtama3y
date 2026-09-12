-- =====================================================================
-- Migration 0027 — real file/image/video upload, app-wide, plus real
-- technician identity verification (ID card photo + face video,
-- reviewed by Ahmed personally before a technician shows as verified).
-- Run after 0002-0026, in order, in the Supabase SQL editor.
--
-- Two Storage buckets:
--   * public-photos — public read (listing/lost-found photos need to
--     load directly via Image.network for anyone). Every object path
--     starts with the uploader's own user id as the first folder
--     segment (storage.foldername(name)[1]), which is what the write
--     policies check — nobody can write into another user's folder,
--     anyone can read any object once uploaded.
--   * private-documents — NOT public. Technician ID cards/verification
--     videos and shop-claim proof documents live here. Only the
--     uploader and a super_admin can ever read them; the client must
--     call storage.createSignedUrl(), which itself re-checks this RLS.
--
-- Technician verification: id_card_url/verification_video_url are
-- deliberately excluded from the authenticated column GRANT on
-- technicians (same column-level-GRANT-not-RLS trick as
-- maintenance_requests.handshake_otp in 0022) — a technician's row is
-- publicly readable for the directory, but nobody can read these two
-- path strings directly, only through fetch_technician_verification(),
-- which checks (caller = owner) or is_super_admin().
-- =====================================================================

insert into storage.buckets (id, name, public) values ('public-photos', 'public-photos', true) on conflict (id) do nothing;
insert into storage.buckets (id, name, public) values ('private-documents', 'private-documents', false) on conflict (id) do nothing;

create policy "public-photos: anyone can read" on storage.objects
  for select using (bucket_id = 'public-photos');

create policy "public-photos: owner uploads own folder" on storage.objects
  for insert with check (bucket_id = 'public-photos' and auth.uid()::text = (storage.foldername(name))[1]);

create policy "public-photos: owner deletes own" on storage.objects
  for delete using (bucket_id = 'public-photos' and auth.uid()::text = (storage.foldername(name))[1]);

create policy "private-documents: owner reads own" on storage.objects
  for select using (bucket_id = 'private-documents' and auth.uid()::text = (storage.foldername(name))[1]);

create policy "private-documents: super_admin reads all" on storage.objects
  for select using (bucket_id = 'private-documents' and public.is_super_admin());

create policy "private-documents: owner uploads own folder" on storage.objects
  for insert with check (bucket_id = 'private-documents' and auth.uid()::text = (storage.foldername(name))[1]);

-- ---- technician identity verification ----

alter table public.technicians add column if not exists id_card_url text;
alter table public.technicians add column if not exists verification_video_url text;
alter table public.technicians add column if not exists verification_status text not null default 'unsubmitted';

-- narrow the existing "technicians: public read" (schema-wide select
-- grant from earlier migrations) down to a safe column list — the two
-- document paths must never be selectable directly by the
-- `authenticated` role, only through fetch_technician_verification().
revoke select on public.technicians from authenticated;
grant select (
  id, user_id, category, bio, rating, rating_count, is_verified,
  escrow_supported, service_area, created_at, verification_status
) on public.technicians to authenticated;

create or replace function public.submit_technician_verification(
  p_technician_id uuid,
  p_id_card_url text,
  p_verification_video_url text
) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  update public.technicians set
    id_card_url = p_id_card_url,
    verification_video_url = p_verification_video_url,
    verification_status = 'pending'
  where id = p_technician_id and user_id = auth.uid();

  if not found then
    raise exception 'غير مصرح لك بتوثيق هذا الملف';
  end if;
end;
$$;

grant execute on function public.submit_technician_verification(uuid, text, text) to authenticated;

create or replace function public.fetch_technician_verification(p_technician_id uuid) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_technician record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_technician from public.technicians where id = p_technician_id;
  if not found then
    raise exception 'الملف غير موجود';
  end if;
  if v_technician.user_id <> auth.uid() and not public.is_super_admin() then
    raise exception 'غير مصرح لك بعرض مستندات التوثيق';
  end if;

  return jsonb_build_object(
    'id_card_url', v_technician.id_card_url,
    'verification_video_url', v_technician.verification_video_url,
    'verification_status', v_technician.verification_status
  );
end;
$$;

grant execute on function public.fetch_technician_verification(uuid) to authenticated;

create or replace function public.fetch_pending_technician_verifications() returns table (
  id uuid, user_id uuid, category text, bio text, service_area text, full_name text, phone text
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة';
  end if;

  return query
    select t.id, t.user_id, t.category, t.bio, t.service_area, p.full_name, p.phone
    from public.technicians t
    join public.profiles p on p.id = t.user_id
    where t.verification_status = 'pending'
    order by t.created_at asc;
end;
$$;

grant execute on function public.fetch_pending_technician_verifications() to authenticated;

create or replace function public.review_technician_verification(p_technician_id uuid, p_approve boolean) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بمراجعة توثيق الفنيين';
  end if;

  select user_id into v_user_id from public.technicians where id = p_technician_id;
  if v_user_id is null then
    raise exception 'الملف غير موجود';
  end if;

  update public.technicians set
    is_verified = p_approve,
    verification_status = case when p_approve then 'approved' else 'rejected' end
  where id = p_technician_id;

  insert into public.notifications (user_id, title, body)
  values (
    v_user_id,
    case when p_approve then 'تم توثيق حسابك كفني' else 'تعذر توثيق حسابك كفني' end,
    case when p_approve then 'تهانينا! ظهر شارة التوثيق على ملفك في سوق الفنيين.'
         else 'راجع بيانات الهوية المرفوعة وحاول التوثيق مرة أخرى، أو تواصل مع الدعم.' end
  );
end;
$$;

grant execute on function public.review_technician_verification(uuid, boolean) to authenticated;
