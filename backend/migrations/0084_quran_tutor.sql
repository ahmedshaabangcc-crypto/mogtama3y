-- =====================================================================
-- Migration 0084 — «المحفّظ»: memorisation progress, synced.
--
-- The tutor itself runs on the phone (speech recognition in the browser,
-- nothing recorded is uploaded). Only the user's progress is mirrored here
-- so it follows them to another device:
--
--   * quran_tutor_progress: one row per user per ayah — status
--     ('learning' / 'memorized'), perfect recitations in a row, and when the
--     device last changed it. Owners read their own rows; nobody writes
--     the table directly.
--   * quran_tutor_save(p_rows jsonb): upserts up to 300 rows per call,
--     each checked (real surah/ayah, known status, 0..100 count, a time not
--     in the future); an older copy never overwrites a newer one.
--   * quran_tutor_reset(p_surah): clears a surah (or everything with null).
--
-- Run after 0083. Safe to re-run.
-- =====================================================================

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table if not exists public.quran_tutor_progress (
  user_id uuid not null references public.profiles(id) on delete cascade,
  surah smallint not null check (surah between 1 and 114),
  ayah smallint not null check (ayah between 1 and 286),
  status text not null check (status in ('learning', 'memorized')),
  perfect_count smallint not null default 0 check (perfect_count between 0 and 100),
  updated_at timestamptz not null default now(),
  primary key (user_id, surah, ayah)
);
alter table public.quran_tutor_progress enable row level security;
revoke all on public.quran_tutor_progress from anon, authenticated;
grant select on public.quran_tutor_progress to authenticated;
drop policy if exists "quran_tutor_progress: owner reads own" on public.quran_tutor_progress;
create policy "quran_tutor_progress: owner reads own" on public.quran_tutor_progress
  for select to authenticated using (user_id = auth.uid());

-- Ayahs per surah (Tanzil quran-data, Hafs numbering).
create or replace function private.qtut_ayah_count(p_surah int) returns int
language sql immutable as $$
  select (array[7,286,200,176,120,165,206,75,129,109,123,111,43,52,99,128,111,110,98,135,112,78,118,64,77,227,93,88,69,60,
                34,30,73,54,45,83,182,88,75,85,54,53,89,59,37,35,38,29,18,45,60,49,62,55,78,96,29,22,24,13,14,11,11,18,12,12,
                30,52,52,44,28,28,20,56,40,31,50,40,46,42,29,19,36,25,22,17,19,26,30,20,15,21,11,8,8,19,5,8,8,11,11,8,3,9,5,
                4,7,3,6,3,5,4,5,6])[p_surah]
$$;

create or replace function public.quran_tutor_save(p_rows jsonb) returns int
language plpgsql security definer set search_path = public as $$
declare
  v_uid uuid := auth.uid();
  v_row jsonb;
  v_surah int;
  v_ayah int;
  v_status text;
  v_count int;
  v_at timestamptz;
  v_n int := 0;
begin
  if v_uid is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_rows is null or jsonb_typeof(p_rows) <> 'array' then
    raise exception 'بيانات الحفظ غير صحيحة';
  end if;
  if jsonb_array_length(p_rows) > 300 then
    raise exception 'كتير مرة واحدة — ابعت 300 آية بالكتير';
  end if;
  for v_row in select * from jsonb_array_elements(p_rows) loop
    begin
      v_surah := (v_row->>'surah')::int;
      v_ayah := (v_row->>'ayah')::int;
      v_status := v_row->>'status';
      v_count := coalesce((v_row->>'perfect_count')::int, 0);
      v_at := coalesce((v_row->>'updated_at')::timestamptz, now());
    exception when others then
      raise exception 'بيانات الحفظ غير صحيحة';
    end;
    if v_surah is null or v_surah not between 1 and 114 or v_ayah is null or v_ayah < 1 or v_ayah > private.qtut_ayah_count(v_surah) then
      raise exception 'رقم السورة أو الآية غير صحيح';
    end if;
    if v_status is null or v_status not in ('learning', 'memorized') then
      raise exception 'حالة الحفظ غير صحيحة';
    end if;
    if v_count not between 0 and 100 then
      raise exception 'عدد التسميعات غير صحيح';
    end if;
    -- The device's clock may be a little ahead; never in the future here.
    v_at := least(v_at, now());
    insert into public.quran_tutor_progress as p (user_id, surah, ayah, status, perfect_count, updated_at)
    values (v_uid, v_surah, v_ayah, v_status, v_count, v_at)
    on conflict (user_id, surah, ayah) do update
      set status = excluded.status, perfect_count = excluded.perfect_count, updated_at = excluded.updated_at
      where p.updated_at < excluded.updated_at;
    v_n := v_n + 1;
  end loop;
  return v_n;
end;
$$;

create or replace function public.quran_tutor_reset(p_surah int default null) returns void
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  delete from public.quran_tutor_progress where user_id = auth.uid() and (p_surah is null or surah = p_surah);
end;
$$;

revoke all on function public.quran_tutor_save(jsonb) from public, anon;
revoke all on function public.quran_tutor_reset(int) from public, anon;
grant execute on function public.quran_tutor_save(jsonb) to authenticated;
grant execute on function public.quran_tutor_reset(int) to authenticated;
