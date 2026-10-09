-- =====================================================================
-- Migration 0083 — «شات المسجد»: nicknames, verified phones, 30-day retention.
--
--   * Name: the chat shows the member's real profile name by default. A
--     member may set a per-mosque nickname («اسم مستعار في الشات»):
--     2–30 chars (Arabic / English letters, digits, space . _ -), at
--     least one letter, no banned words (0078 list), nothing that looks
--     like the mosque's staff («إمام / أدمن / مشرف / الإدارة» …), unique
--     within the mosque. Changing it (or going back to the real name) is
--     allowed once a day; the first nickname is free. The nickname lives
--     in mosque_chat_nicknames, so leaving and re-joining doesn't reset
--     the limit. It applies to the whole history of that mosque's chat.
--   * Who sees what: masjid_chat_messages returns the display name only
--     and gives the author's account id to moderators only (the mosque's
--     owner / helpers with «chat», the super admin); regular members get
--     author_id = null. Moderators map ids to nicknames with
--     masjid_chat_identities; masjid_members (moderators) and
--     admin_mosque_chat_reports (super admin) keep showing real names.
--     Return types of 0081's functions are unchanged, so 0081 can still
--     be re-run (followed by 0083).
--   * Posting needs a verified mobile number (profiles.phone_verified_at,
--     0074): masjid_chat_send refuses with HINT 'phone_unverified'.
--     Moderators too; only the super admin is exempt. Reading, reporting
--     and the rest are unchanged.
--   * Retention: masjid_chat_purge() deletes messages older than 30 days
--     (their reports go with them) and reports / mod-log rows older than
--     90 days — daily with pg_cron when the extension exists (like 0078 /
--     0082), otherwise the super admin can call it.
--
-- 0081 is applied in production and untouched; the functions below
-- replace its versions. Run after 0082. Safe to re-run.
-- =====================================================================

-- ------------------------------------------------------------- table
create table if not exists public.mosque_chat_nicknames (
  mosque_id uuid not null references public.mosques(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  nickname text check (nickname is null or char_length(nickname) between 2 and 30),
  changed_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  primary key (mosque_id, user_id)
);
create unique index if not exists mosque_chat_nicknames_unique
  on public.mosque_chat_nicknames (mosque_id, public.chat_normalize(nickname)) where nickname is not null;
alter table public.mosque_chat_nicknames enable row level security;
revoke all on public.mosque_chat_nicknames from public, anon, authenticated;

-- ---------------------------------------------------------- nickname
-- Sets (or, with null / empty, clears) the caller's nickname in one
-- mosque's chat. Returns the new nickname (null = the real name).
create or replace function public.masjid_chat_set_nickname(p_mosque uuid, p_nickname text) returns text
language plpgsql security definer set search_path = public as $$
declare
  v_nick text := nullif(regexp_replace(btrim(coalesce(p_nickname, '')), '\s+', ' ', 'g'), '');
  v_norm text;
  v_row public.mosque_chat_nicknames;
  v_reserved text;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  if not public.masjid_is_member(p_mosque) then
    raise exception 'انضم للمسجد الأول';
  end if;

  if v_nick is not null then
    if char_length(v_nick) < 2 or char_length(v_nick) > 30 then
      raise exception 'الاسم لازم يكون من 2 لـ 30 حرف';
    end if;
    if v_nick !~ '^[A-Za-z0-9_ .\-ء-غف-ي٠-٩]+$' then
      raise exception 'الاسم يكون حروف عربي أو إنجليزي أو أرقام بس';
    end if;
    if v_nick !~ '[A-Za-zء-غف-ي]' then
      raise exception 'الاسم لازم يكون فيه حروف';
    end if;
    v_norm := replace(public.chat_normalize(v_nick), ' ', '');
    foreach v_reserved in array array[
      'امام', 'ادمن', 'مشرف', 'اداره', 'مدير', 'مسؤول', 'مجتمعي', 'مسجدي', 'رسمي', 'الدعم',
      'admin', 'moderator', 'imam', 'support', 'official', 'owner', 'system', 'mogtama3y', 'masjidi'] loop
      if position(public.chat_normalize(v_reserved) in v_norm) > 0 then
        raise exception 'الاسم ده ممكن يتلخبط مع إدارة المسجد، اختار اسم تاني';
      end if;
    end loop;
    if public.chat_has_banned_word(replace(replace(replace(v_nick, '_', ' '), '.', ' '), '-', ' ')) then
      raise exception 'الاسم فيه كلمة مش لطيفة، اختار اسم تاني';
    end if;
  end if;

  select * into v_row from public.mosque_chat_nicknames where mosque_id = p_mosque and user_id = auth.uid();
  if v_row.user_id is not null and v_row.nickname is not distinct from v_nick then
    return v_nick;
  end if;
  if v_row.user_id is null and v_nick is null then
    return null;
  end if;
  if v_row.user_id is not null and v_row.changed_at > now() - interval '1 day' then
    raise exception 'تقدر تغيّر اسمك في الشات مرة واحدة في اليوم';
  end if;
  if v_nick is not null and exists (
       select 1 from public.mosque_chat_nicknames
       where mosque_id = p_mosque and user_id <> auth.uid() and nickname is not null
         and public.chat_normalize(nickname) = public.chat_normalize(v_nick)) then
    raise exception 'الاسم ده واخده حد تاني في المسجد، جرّب اسم تاني';
  end if;

  insert into public.mosque_chat_nicknames (mosque_id, user_id, nickname, changed_at)
  values (p_mosque, auth.uid(), v_nick, now())
  on conflict (mosque_id, user_id) do update set nickname = excluded.nickname, changed_at = excluded.changed_at;
  return v_nick;
end;
$$;

-- The caller's chat identity in one mosque: nickname, real name, when
-- the nickname can change again, and whether they may post (phone).
create or replace function public.masjid_my_chat_profile(p_mosque uuid) returns jsonb
language plpgsql stable security definer set search_path = public as $$
declare
  v_row public.mosque_chat_nicknames;
  p public.profiles;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  select * into p from public.profiles where id = auth.uid();
  select * into v_row from public.mosque_chat_nicknames where mosque_id = p_mosque and user_id = auth.uid();
  return jsonb_build_object(
    'nickname', v_row.nickname,
    'real_name', p.full_name,
    'can_change_at', case when v_row.user_id is not null and v_row.changed_at > now() - interval '1 day'
                          then v_row.changed_at + interval '1 day' end,
    'phone_verified', p.phone_verified_at is not null,
    'needs_phone', p.phone_verified_at is null and not public.is_super_admin());
end;
$$;

-- ======================================================= the chat, again

-- Same columns as 0081. author_name is the display name (nickname, else
-- the real name); author_id only for the mosque's moderators (null for
-- everyone else, so a nickname can't be traced back to a profile).
create or replace function public.masjid_chat_messages(
  p_mosque uuid, p_after timestamptz default null, p_before timestamptz default null, p_limit int default 60
) returns table (
  id uuid, author_id uuid, author_name text, author_is_admin boolean, body text,
  reply_to uuid, reply_name text, reply_body text, created_at timestamptz, mine boolean
)
language plpgsql stable security definer set search_path = public as $$
declare
  v_mod boolean;
begin
  if not public.masjid_chat_can_read(p_mosque) then
    raise exception 'انضم للمسجد عشان تشوف الشات وتشارك';
  end if;
  v_mod := public.masjid_chat_can_moderate(p_mosque);
  return query
  select x.id, x.author_id, x.author_name, x.author_is_admin, x.body,
         x.reply_to, x.reply_name, x.reply_body, x.created_at, x.mine
  from (
    select c.id,
           case when v_mod then c.user_id end as author_id,
           coalesce(n.nickname, p.full_name, 'عضو') as author_name,
           exists (select 1 from public.mosque_admins a join public.mosques mq on mq.id = a.mosque_id
                   where a.mosque_id = c.mosque_id and a.user_id = c.user_id and mq.verified) as author_is_admin,
           c.body, c.reply_to,
           case when r.id is not null then coalesce(rn.nickname, rp.full_name, 'عضو') end as reply_name,
           left(r.body, 140) as reply_body, c.created_at,
           c.user_id = auth.uid() as mine
    from public.mosque_chat_messages c
    join public.profiles p on p.id = c.user_id
    left join public.mosque_chat_nicknames n on n.mosque_id = c.mosque_id and n.user_id = c.user_id
    left join public.mosque_chat_messages r on r.id = c.reply_to and not r.is_hidden
    left join public.profiles rp on rp.id = r.user_id
    left join public.mosque_chat_nicknames rn on rn.mosque_id = r.mosque_id and rn.user_id = r.user_id
    where c.mosque_id = p_mosque
      and not c.is_hidden
      and (p_after is null or c.created_at > p_after)
      and (p_before is null or c.created_at < p_before)
      and not public.is_blocked_between(auth.uid(), c.user_id)
    order by case when p_after is null then c.created_at end desc, c.created_at asc
    limit least(greatest(coalesce(p_limit, 60), 1), 200)
  ) x
  order by x.created_at;
end;
$$;

-- 0081's send + a verified phone (super admin exempt).
create or replace function public.masjid_chat_send(p_mosque uuid, p_body text, p_reply_to uuid default null) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_body text := btrim(coalesce(p_body, ''));
  v_flat text;
  v_mod boolean;
  v_kind text;
  v_until timestamptz;
  v_last timestamptz;
  v_reply public.mosque_chat_messages;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'سجّل دخول الأول';
  end if;
  if not exists (select 1 from public.mosques where id = p_mosque) then
    raise exception 'المسجد مش موجود';
  end if;
  v_mod := public.masjid_chat_can_moderate(p_mosque);
  if not public.masjid_is_member(p_mosque) and not public.masjid_can(p_mosque, 'chat') then
    raise exception 'انضم للمسجد عشان تشارك في الشات';
  end if;
  if not public.is_super_admin()
     and (select phone_verified_at from public.profiles where id = auth.uid()) is null then
    raise exception 'لازم توثّق رقم موبايلك عشان تكتب في الشات' using hint = 'phone_unverified';
  end if;

  select s.kind, s.until into v_kind, v_until from public.masjid_chat_active_sanction(auth.uid(), p_mosque) s;
  if v_kind = 'ban' then
    raise exception '%', case when v_until is null then 'إنت ممنوع من الكتابة في شات المسجد ده'
                              else 'إنت ممنوع من الكتابة في شات المسجد لحد ' || to_char(v_until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI') end;
  end if;
  if v_kind = 'mute' then
    raise exception 'إنت مكتوم مؤقتاً في شات المسجد لحد %', to_char(v_until at time zone 'Africa/Cairo', 'YYYY/MM/DD HH24:MI');
  end if;

  if char_length(v_body) < 1 then
    raise exception 'اكتب رسالة الأول';
  end if;
  if char_length(v_body) > 1000 then
    raise exception 'الرسالة طويلة، الحد 1000 حرف';
  end if;

  select max(created_at) into v_last from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque;
  if v_last is not null and v_last > now() - interval '3 seconds' then
    raise exception 'استنى ثانيتين قبل الرسالة الجاية';
  end if;
  if (select count(*) from public.mosque_chat_messages
      where user_id = auth.uid() and mosque_id = p_mosque and created_at > now() - interval '1 hour') >= 60 then
    raise exception 'كتبت رسايل كتير الساعة دي، استنى شوية';
  end if;
  if exists (select 1 from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque
             and body = v_body and created_at > now() - interval '1 minute') then
    raise exception 'إنت لسه باعت نفس الرسالة';
  end if;

  if public.chat_has_banned_word(v_body) then
    raise exception 'الرسالة فيها كلام مش لطيف، عدّلها وابعت تاني';
  end if;

  if not v_mod then
    v_flat := regexp_replace(public._masjid_ascii_digits(v_body), '[\s\-\.()]', '', 'g');
    if v_flat ~ '(\+?20|0)1[0125][0-9]{8}' then
      raise exception 'ممنوع أرقام الموبايل في شات المسجد — اتواصلوا خاص';
    end if;
    if lower(v_body) ~ '(https?://|www\.|t\.me/|wa\.me/|bit\.ly|[a-z0-9-]+\.(com|net|org|eg|io|me|ly|co|info|xyz|link|app|site|online|store|shop|tk|biz)([^a-z0-9]|$))' then
      if (select created_at from public.profiles where id = auth.uid()) > now() - interval '7 days'
         or (select count(*) from public.mosque_chat_messages where user_id = auth.uid() and mosque_id = p_mosque) < 20 then
        raise exception 'اللينكات مسموحة بعد ما يعدّي على حسابك أسبوع وتكتب 20 رسالة في شات المسجد';
      end if;
    end if;
  end if;

  if p_reply_to is not null then
    select * into v_reply from public.mosque_chat_messages where id = p_reply_to;
    if v_reply.id is null or v_reply.mosque_id <> p_mosque or v_reply.is_hidden then
      raise exception 'الرسالة اللي بترد عليها مش موجودة';
    end if;
  end if;

  insert into public.mosque_chat_messages (mosque_id, user_id, body, reply_to)
  values (p_mosque, auth.uid(), v_body, p_reply_to)
  returning id into v_id;
  update public.mosque_members set last_read_at = now() where mosque_id = p_mosque and user_id = auth.uid();
  return v_id;
end;
$$;

-- Moderators: who is behind each nickname in this mosque (the members
-- sheet and the message actions match it on user_id). masjid_members and
-- admin_mosque_chat_reports (0081) already show the real name / phone.
create or replace function public.masjid_chat_identities(p_mosque uuid)
returns table (user_id uuid, nickname text, full_name text)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.masjid_chat_can_moderate(p_mosque) then
    raise exception 'غير مصرح';
  end if;
  return query
  select n.user_id, n.nickname, p.full_name
  from public.mosque_chat_nicknames n
  join public.profiles p on p.id = n.user_id
  where n.mosque_id = p_mosque and n.nickname is not null
  order by n.nickname
  limit 2000;
end;
$$;

-- ========================================================== retention
-- Messages older than 30 days (their reports cascade), reports and
-- mod-log rows older than 90 days. pg_cron / service: no auth.uid();
-- from the app: super admin only. Returns the number of messages deleted.
create or replace function public.masjid_chat_purge() returns int
language plpgsql security definer set search_path = public as $$
declare
  v_n int;
begin
  if auth.uid() is not null and not public.is_super_admin() then
    raise exception 'غير مصرح';
  end if;
  delete from public.mosque_chat_messages where created_at < now() - interval '30 days';
  get diagnostics v_n = row_count;
  delete from public.mosque_chat_reports where created_at < now() - interval '90 days';
  delete from public.mosque_chat_mod_log where created_at < now() - interval '90 days';
  return v_n;
end;
$$;

do $$
begin
  create extension if not exists pg_cron;
exception when others then
  raise notice 'pg_cron not available — the super admin can call masjid_chat_purge(): %', sqlerrm;
end;
$$;

do $$
begin
  if not exists (select 1 from pg_extension where extname = 'pg_cron') then
    return;
  end if;
  execute $sql$select cron.schedule('masjid-chat-purge', '45 1 * * *', 'select public.masjid_chat_purge()')$sql$;
exception when others then
  raise notice 'could not schedule masjid_chat_purge: %', sqlerrm;
end;
$$;

-- -------------------------------------------------------------- grants
do $$
declare f text;
begin
  foreach f in array array[
    'masjid_chat_set_nickname(uuid, text)', 'masjid_my_chat_profile(uuid)',
    'masjid_chat_messages(uuid, timestamptz, timestamptz, int)', 'masjid_chat_send(uuid, text, uuid)',
    'masjid_chat_identities(uuid)', 'masjid_chat_purge()'
  ] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end;
$$;
