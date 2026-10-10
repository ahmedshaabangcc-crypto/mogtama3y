-- =====================================================================
-- Migration 0088 — «كلّمنا»: the floating feedback button on every
-- screen of every app.
--
-- * support_tickets can now hold messages from guests (user_id null) —
--   anonymous suggestions are valuable. A guest may leave a phone /
--   WhatsApp number in `contact`.
-- * `kind` is what the user picked in the sheet ('suggestion' | 'bug' |
--   'question'); `category` keeps the existing enum (suggestion /
--   technical / other) so older screens and reports keep working.
-- * `source` is the context the app attaches automatically: app
--   (flavour), page path (never the query string), version, short
--   browser user agent — so the admin knows where it came from.
-- * submit_feedback() is the only way in for both guests and signed-in
--   users. Guests can't be rate-limited per IP from SQL, so they share a
--   global daily budget (200/day) plus 3/day per contact number, no
--   links, no repeated text. Signed-in users: 10/day each.
-- * resolve_support_ticket() closes a guest ticket without trying to
--   notify a user that doesn't exist (the admin answers on WhatsApp).
--
-- Run after 0087, in order, in the Supabase SQL editor.
-- =====================================================================

alter table public.support_tickets alter column user_id drop not null;

alter table public.support_tickets
  add column if not exists kind text check (kind in ('suggestion', 'bug', 'question')),
  add column if not exists contact text check (contact is null or contact ~ '^\+?[0-9]{8,15}$'),
  add column if not exists source jsonb;

create index if not exists support_tickets_guest_recent_idx
  on public.support_tickets (created_at) where user_id is null;

create or replace function public.submit_feedback(
  p_kind text,
  p_body text,
  p_contact text default null,
  p_source jsonb default null
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid uuid := auth.uid();
  v_body text;
  v_contact text;
  v_source jsonb;
  v_category ticket_category;
  v_label text;
  v_id uuid;
  v_key text;
begin
  if p_kind is null or p_kind not in ('suggestion', 'bug', 'question') then
    raise exception 'اختار نوع الرسالة';
  end if;

  -- Control characters out, whitespace runs collapsed, then the length.
  v_body := regexp_replace(coalesce(p_body, ''), '[\x01-\x08\x0B\x0C\x0E-\x1F\x7F]', '', 'g');
  v_body := trim(regexp_replace(v_body, '[ \t]{2,}', ' ', 'g'));
  v_body := regexp_replace(v_body, '\n{3,}', E'\n\n', 'g');
  if char_length(v_body) < 10 then
    raise exception 'اكتب رسالتك في 10 حروف على الأقل';
  end if;
  if char_length(v_body) > 2000 then
    raise exception 'الرسالة طويلة — 2000 حرف بحد أقصى';
  end if;

  v_contact := nullif(regexp_replace(coalesce(p_contact, ''), '[^0-9+]', '', 'g'), '');
  if v_contact is not null and v_contact !~ '^\+?[0-9]{8,15}$' then
    raise exception 'رقم التواصل مش صحيح';
  end if;

  -- Only the known context keys, each cut short.
  v_source := '{}'::jsonb;
  if p_source is not null and jsonb_typeof(p_source) = 'object' then
    foreach v_key in array array['app', 'path', 'version', 'ua'] loop
      if jsonb_typeof(p_source -> v_key) = 'string' then
        v_source := v_source || jsonb_build_object(v_key, left(p_source ->> v_key, case when v_key = 'ua' then 160 else 120 end));
      end if;
    end loop;
  end if;

  if v_uid is null then
    -- Guests: no links (spam), a shared daily budget, per-contact limit,
    -- no repeats of the same text.
    if v_body ~* '(https?://|www\.|\m[a-z0-9-]+\.(com|net|org|io|xyz|ru|info|me|link)\M)' then
      raise exception 'من غير روابط من فضلك — سجّل دخولك لو محتاج تبعت رابط';
    end if;
    if (select count(*) from public.support_tickets where user_id is null and created_at > now() - interval '1 day') >= 200 then
      raise exception 'وصلنا رسائل كتير النهارده — حاول بكرة أو سجّل دخولك';
    end if;
    if v_contact is not null and (select count(*) from public.support_tickets
          where user_id is null and contact = v_contact and created_at > now() - interval '1 day') >= 3 then
      raise exception 'بعتّ رسايل كتير النهارده — هنرد عليك قريب';
    end if;
    if exists (select 1 from public.support_tickets
          where user_id is null and body = v_body and created_at > now() - interval '1 day') then
      raise exception 'الرسالة دي وصلتنا قبل كده';
    end if;
  else
    if (select count(*) from public.support_tickets where user_id = v_uid and created_at > now() - interval '1 day') >= 10 then
      raise exception 'بعتّ رسايل كتير النهارده — هنرد عليك قريب';
    end if;
  end if;

  v_category := case p_kind when 'suggestion' then 'suggestion' when 'bug' then 'technical' else 'other' end;
  v_label := case p_kind when 'suggestion' then 'اقتراح' when 'bug' then 'مشكلة' else 'سؤال' end;

  insert into public.support_tickets (user_id, category, subject, body, kind, contact, source)
  values (
    v_uid,
    v_category,
    v_label || ': ' || left(regexp_replace(v_body, '\s+', ' ', 'g'), 60),
    v_body,
    p_kind,
    v_contact,
    v_source
  )
  returning id into v_id;
  return v_id;
end;
$$;

revoke execute on function public.submit_feedback(text, text, text, jsonb) from public;
grant execute on function public.submit_feedback(text, text, text, jsonb) to anon, authenticated;

-- Guest tickets have nobody to notify in-app: close them (the admin
-- answers on WhatsApp / phone).
create or replace function public.resolve_support_ticket(p_ticket_id uuid, p_reply text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_ticket record;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالرد على التذاكر';
  end if;

  select * into v_ticket from public.support_tickets where id = p_ticket_id for update;
  if not found then
    raise exception 'التذكرة غير موجودة';
  end if;
  if v_ticket.status in ('resolved', 'closed') then
    raise exception 'تم الرد على هذه التذكرة بالفعل';
  end if;
  if v_ticket.user_id is not null and (p_reply is null or length(trim(p_reply)) = 0) then
    raise exception 'اكتب الرد أولاً';
  end if;

  update public.support_tickets set status = 'resolved' where id = p_ticket_id;

  if v_ticket.user_id is not null then
    insert into public.notifications (user_id, title, body)
    values (v_ticket.user_id, 'رد الدعم على: ' || v_ticket.subject, trim(p_reply));
  end if;
end;
$$;

revoke execute on function public.resolve_support_ticket(uuid, text) from public, anon;
grant execute on function public.resolve_support_ticket(uuid, text) to authenticated;
