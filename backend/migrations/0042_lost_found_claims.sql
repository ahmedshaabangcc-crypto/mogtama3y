-- =====================================================================
-- Migration 0042 — the lost & found "secret mark" actually protects
-- anything.
--
-- Before this:
--   * The app stored an unsalted SHA-256 of the mark, and every building
--     member (and guard) could SELECT secret_mark_hash — a short phrase
--     like "محفظة سوداء" can be brute-forced offline in seconds.
--   * Nothing ever checked the mark: "this item is mine" / "I know where
--     it is" were "coming soon" snackbars.
--
-- Now:
--   * secret_mark_hash is no longer selectable by clients (column grant);
--     has_secret_mark tells the app whether a mark exists.
--   * Items are reported through report_lost_found_item(), which stores
--     a salted bcrypt hash of the NORMALISED mark (case, spaces, Arabic
--     alef/yaa/taa-marbuta variants and diacritics don't matter).
--   * claim_lost_found_item() checks an answer server-side, max 3 wrong
--     attempts per person per item, and notifies both sides on success.
--     For a LOST item the button means "I know where it is" — no mark
--     needed, the owner is simply notified.
--
-- Run after 0041, in order, in the Supabase SQL editor.
-- =====================================================================

-- pgcrypto lives in the `extensions` schema on Supabase.
create extension if not exists pgcrypto;

-- ---- 1. Hide the hash; expose only whether a mark exists ----

alter table public.lost_found_items
  add column if not exists has_secret_mark boolean generated always as (secret_mark_hash is not null) stored;

revoke select, insert on public.lost_found_items from authenticated, anon;
grant select (
  id, building_id, reporter_id, type, category, title, description, image_url,
  location_note, is_resolved, reward_amount, created_at, has_secret_mark
) on public.lost_found_items to authenticated;

-- ---- 2. Normalisation shared by reporting and checking ----

create or replace function public.normalize_secret_mark(p_text text) returns text
language sql
immutable
as $$
  select regexp_replace(
    translate(
      lower(coalesce(p_text, '')),
      'أإآٱىةًٌٍَُِّْـ',
      'اااايه'
    ),
    '\s+', '', 'g'
  );
$$;

-- ---- 3. Reporting ----

create or replace function public.report_lost_found_item(
  p_type text,
  p_category text,
  p_title text,
  p_location_note text,
  p_secret_mark text default null,
  p_reward_amount numeric default null,
  p_image_url text default null
) returns uuid
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_building_id uuid;
  v_mark text;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_type not in ('lost', 'found') then
    raise exception 'نوع البلاغ غير صحيح';
  end if;
  if p_title is null or length(trim(p_title)) = 0 then
    raise exception 'اكتب اسم الغرض';
  end if;
  if p_reward_amount is not null and p_reward_amount < 0 then
    raise exception 'قيمة المكافأة غير صحيحة';
  end if;

  select building_id into v_building_id from public.union_members
    where user_id = auth.uid() and status = 'verified'
    order by created_at desc
    limit 1;
  if v_building_id is null then
    raise exception 'يجب الانضمام لعمارتك أولاً قبل نشر بلاغ';
  end if;

  v_mark := nullif(public.normalize_secret_mark(p_secret_mark), '');

  insert into public.lost_found_items (building_id, reporter_id, type, category, title, location_note, secret_mark_hash, reward_amount, image_url)
  values (
    v_building_id, auth.uid(), p_type::lost_found_type, p_category, trim(p_title), p_location_note,
    case when v_mark is null then null else crypt(v_mark, gen_salt('bf')) end,
    p_reward_amount, p_image_url
  )
  returning id into v_id;

  return v_id;
end;
$$;

revoke execute on function public.report_lost_found_item(text, text, text, text, text, numeric, text) from public, anon;
grant execute on function public.report_lost_found_item(text, text, text, text, text, numeric, text) to authenticated;

-- ---- 4. Claiming ----

create table if not exists public.lost_found_claims (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.lost_found_items(id) on delete cascade,
  claimant_id uuid not null references public.profiles(id) on delete cascade,
  succeeded boolean not null,
  created_at timestamptz not null default now()
);
revoke all on public.lost_found_claims from anon, authenticated;

-- Returns one of:
--   'verified'  — found item, correct mark: both sides notified
--   'notified'  — found item without a mark, or a lost item ("I know
--                 where it is"): the reporter was notified
--   'wrong'     — wrong mark (attempts remain)
--   'locked'    — 3 wrong attempts on this item: no more tries
create or replace function public.claim_lost_found_item(p_item_id uuid, p_answer text default null) returns text
language plpgsql
security definer
set search_path = public, extensions
as $$
declare
  v_item record;
  v_failed int;
  v_answer text;
  v_ok boolean;
  v_claimant_name text;
  v_claimant_unit text;
  v_reporter_name text;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_item from public.lost_found_items where id = p_item_id;
  if not found or v_item.is_resolved then
    raise exception 'البلاغ غير موجود أو تم حله';
  end if;
  if not public.is_verified_member_of(v_item.building_id) then
    raise exception 'غير مصرح لك';
  end if;
  if v_item.reporter_id = auth.uid() then
    raise exception 'هذا بلاغك أنت';
  end if;

  select p.full_name, u.unit_number into v_claimant_name, v_claimant_unit
  from public.profiles p
  left join public.union_members m on m.user_id = p.id and m.building_id = v_item.building_id
  left join public.units u on u.id = m.unit_id
  where p.id = auth.uid();
  select full_name into v_reporter_name from public.profiles where id = v_item.reporter_id;

  -- Lost item: "I know where it is" — just tell the owner.
  -- Found item without a mark: nothing to verify, tell the finder.
  if v_item.type = 'lost' or v_item.secret_mark_hash is null then
    insert into public.lost_found_claims (item_id, claimant_id, succeeded) values (p_item_id, auth.uid(), true);
    insert into public.notifications (user_id, title, body)
    values (
      v_item.reporter_id,
      case when v_item.type = 'lost' then 'أحد جيرانك يعرف مكان: ' else 'أحد جيرانك يقول إن هذا يخصه: ' end || v_item.title,
      coalesce(v_claimant_name, 'أحد الجيران') || coalesce(' (شقة ' || v_claimant_unit || ')', '')
        || case when v_item.type = 'lost' then ' يقول إنه يعرف مكان غرضك. تواصل معه داخل العمارة.'
                else ' يقول إن الغرض الذي وجدته يخصه. لم تضع علامة سرية، فتأكد منه بنفسك قبل التسليم.' end
    );
    return 'notified';
  end if;

  select count(*) into v_failed from public.lost_found_claims
    where item_id = p_item_id and claimant_id = auth.uid() and not succeeded;
  if v_failed >= 3 then
    return 'locked';
  end if;

  v_answer := public.normalize_secret_mark(p_answer);
  if v_answer = '' then
    raise exception 'اكتب العلامة السرية';
  end if;

  if v_item.secret_mark_hash like '$2%' then
    v_ok := crypt(v_answer, v_item.secret_mark_hash) = v_item.secret_mark_hash;
  else
    -- Legacy rows: unsalted SHA-256 of the trimmed (not normalised) text.
    v_ok := encode(digest(trim(coalesce(p_answer, '')), 'sha256'), 'hex') = v_item.secret_mark_hash;
  end if;

  insert into public.lost_found_claims (item_id, claimant_id, succeeded) values (p_item_id, auth.uid(), v_ok);

  if not v_ok then
    return case when v_failed + 1 >= 3 then 'locked' else 'wrong' end;
  end if;

  insert into public.notifications (user_id, title, body)
  values
    (
      v_item.reporter_id,
      'تم التحقق من صاحب: ' || v_item.title,
      coalesce(v_claimant_name, 'أحد الجيران') || coalesce(' (شقة ' || v_claimant_unit || ')', '')
        || ' أجاب العلامة السرية بشكل صحيح. تواصل معه لتسليم الأمانة.'
    ),
    (
      auth.uid(),
      'تم التحقق من ملكيتك: ' || v_item.title,
      'إجابتك صحيحة، وتم إبلاغ ' || coalesce(v_reporter_name, 'من وجد الغرض') || ' للتواصل معك وتسليمه.'
    );
  return 'verified';
end;
$$;

revoke execute on function public.claim_lost_found_item(uuid, text) from public, anon;
grant execute on function public.claim_lost_found_item(uuid, text) to authenticated;
