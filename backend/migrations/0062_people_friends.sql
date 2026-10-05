-- =====================================================================
-- 0062 — People nearby, friends and private chat.
--
-- * Opt-in only: nobody appears in "ناس حواليك" until they switch
--   "اظهر للناس اللي حواليك" on. Turning it off erases their position.
-- * Positions are stored rounded to a ~550 m grid and shown only as a
--   rough distance ("أقل من 1 كم"), never the exact spot.
-- * Signed-in users only; blocking hides both people from each other and
--   ends any friendship; anyone can be reported to the admins.
-- * Chat is between friends only. Everything goes through RPCs — the
--   tables themselves are not exposed.
-- =====================================================================

create table if not exists public.people_presence (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  discoverable boolean not null default false,
  lat_grid double precision,
  lng_grid double precision,
  area text,
  updated_at timestamptz not null default now()
);
create index if not exists people_presence_grid on public.people_presence (lat_grid, lng_grid) where discoverable;

create table if not exists public.friendships (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references public.profiles(id) on delete cascade,
  addressee_id uuid not null references public.profiles(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'accepted')),
  created_at timestamptz not null default now(),
  responded_at timestamptz,
  check (requester_id <> addressee_id)
);
create unique index if not exists friendships_pair on public.friendships (least(requester_id, addressee_id), greatest(requester_id, addressee_id));
create index if not exists friendships_addressee on public.friendships (addressee_id, status);

create table if not exists public.user_blocks (
  blocker_id uuid not null references public.profiles(id) on delete cascade,
  blocked_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id)
);

create table if not exists public.user_flags (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reported_id uuid not null references public.profiles(id) on delete cascade,
  reason text not null check (length(trim(reason)) between 2 and 500),
  created_at timestamptz not null default now()
);

create table if not exists public.direct_messages (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references public.profiles(id) on delete cascade,
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (length(trim(body)) between 1 and 2000),
  created_at timestamptz not null default now(),
  read_at timestamptz
);
create index if not exists direct_messages_pair on public.direct_messages (least(sender_id, recipient_id), greatest(sender_id, recipient_id), created_at desc);
create index if not exists direct_messages_unread on public.direct_messages (recipient_id) where read_at is null;

alter table public.people_presence enable row level security;
alter table public.friendships enable row level security;
alter table public.user_blocks enable row level security;
alter table public.user_flags enable row level security;
alter table public.direct_messages enable row level security;
revoke all on public.people_presence, public.friendships, public.user_blocks, public.user_flags, public.direct_messages from anon, authenticated;

-- ---------------------------------------------------------------- helpers
create or replace function public.is_blocked_between(a uuid, b uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.user_blocks where (blocker_id = a and blocked_id = b) or (blocker_id = b and blocked_id = a));
$$;
create or replace function public.are_friends(a uuid, b uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.friendships where status = 'accepted'
                 and least(requester_id, addressee_id) = least(a, b) and greatest(requester_id, addressee_id) = greatest(a, b));
$$;
revoke execute on function public.is_blocked_between(uuid, uuid) from public, anon, authenticated;
revoke execute on function public.are_friends(uuid, uuid) from public, anon, authenticated;

-- 'none' | 'sent' | 'received' | 'friends' from the caller's point of view.
create or replace function public.friend_state(p_other uuid) returns text
language sql stable security definer set search_path = public as $$
  select coalesce((
    select case when f.status = 'accepted' then 'friends'
                when f.requester_id = auth.uid() then 'sent' else 'received' end
    from public.friendships f
    where least(f.requester_id, f.addressee_id) = least(auth.uid(), p_other)
      and greatest(f.requester_id, f.addressee_id) = greatest(auth.uid(), p_other)
  ), 'none');
$$;
revoke execute on function public.friend_state(uuid) from public, anon;
grant execute on function public.friend_state(uuid) to authenticated;

-- ---------------------------------------------------------------- presence
create or replace function public.get_my_presence() returns jsonb
language sql stable security definer set search_path = public as $$
  select coalesce((select jsonb_build_object('discoverable', discoverable, 'area', area, 'updated_at', updated_at)
                   from public.people_presence where user_id = auth.uid()),
                  jsonb_build_object('discoverable', false));
$$;

-- Switch visibility. With p_on the position is stored rounded; off erases it.
create or replace function public.set_discoverable(
  p_on boolean, p_lat double precision default null, p_lng double precision default null, p_area text default null
) returns void
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if p_on and (p_lat is null or p_lng is null) then raise exception 'محتاجين موقعك عشان تظهر للي حواليك'; end if;
  insert into public.people_presence (user_id, discoverable, lat_grid, lng_grid, area, updated_at)
  values (auth.uid(), p_on,
          case when p_on then round(p_lat / 0.005) * 0.005 end,
          case when p_on then round(p_lng / 0.005) * 0.005 end,
          case when p_on then nullif(trim(coalesce(p_area, '')), '') end, now())
  on conflict (user_id) do update set
    discoverable = excluded.discoverable, lat_grid = excluded.lat_grid, lng_grid = excluded.lng_grid,
    area = coalesce(excluded.area, case when excluded.discoverable then people_presence.area end), updated_at = now();
end;
$$;

-- People who opted in, around a point (signed-in only), nearest first.
create or replace function public.nearby_people(
  p_lat double precision, p_lng double precision, p_km double precision default 3, p_limit int default 50
) returns table (user_id uuid, full_name text, avatar_url text, is_verified boolean, area text, distance_label text, state text)
language plpgsql stable security definer set search_path = public as $$
declare
  v_km double precision := least(greatest(coalesce(p_km, 3), 1), 20);
  v_lat double precision := round(p_lat / 0.005) * 0.005;
  v_lng double precision := round(p_lng / 0.005) * 0.005;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  return query
    select p.id, p.full_name, p.avatar_url, p.is_verified, pp.area,
           case when d.km < 1 then 'أقل من 1 كم' when d.km < 2 then 'حوالي 1 كم' when d.km < 5 then 'حوالي ' || round(d.km)::int || ' كم'
                else 'أكتر من 5 كم' end,
           public.friend_state(p.id)
    from public.people_presence pp
    join public.profiles p on p.id = pp.user_id
    cross join lateral (select 111.0 * sqrt(power(pp.lat_grid - v_lat, 2) + power((pp.lng_grid - v_lng) * cos(radians(v_lat)), 2)) as km) d
    where pp.discoverable
      and pp.user_id <> auth.uid()
      and pp.updated_at > now() - interval '30 days'
      and pp.lat_grid between v_lat - v_km / 111.0 and v_lat + v_km / 111.0
      and pp.lng_grid between v_lng - v_km / (111.0 * greatest(cos(radians(v_lat)), 0.2)) and v_lng + v_km / (111.0 * greatest(cos(radians(v_lat)), 0.2))
      and not public.is_blocked_between(auth.uid(), pp.user_id)
    order by d.km, pp.updated_at desc
    limit least(greatest(coalesce(p_limit, 50), 1), 100);
end;
$$;

-- ---------------------------------------------------------------- friends
create or replace function public.send_friend_request(p_user uuid) returns text
language plpgsql security definer set search_path = public as $$
declare
  v_state text;
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if p_user = auth.uid() then raise exception 'مينفعش تضيف نفسك'; end if;
  if not exists (select 1 from public.profiles where id = p_user) then raise exception 'المستخدم مش موجود'; end if;
  if public.is_blocked_between(auth.uid(), p_user) then raise exception 'مينفعش تبعت طلب للشخص ده'; end if;
  v_state := public.friend_state(p_user);
  if v_state = 'friends' or v_state = 'sent' then return v_state; end if;
  select full_name into v_name from public.profiles where id = auth.uid();
  if v_state = 'received' then
    -- They already asked: sending back accepts.
    update public.friendships set status = 'accepted', responded_at = now()
    where requester_id = p_user and addressee_id = auth.uid();
    insert into public.notifications (user_id, title, body, deep_link)
    values (p_user, 'بقيتوا أصحاب', coalesce(v_name, 'حد') || ' قبل طلب الصداقة', '/#/friends');
    return 'friends';
  end if;
  if (select count(*) from public.friendships where requester_id = auth.uid() and created_at > now() - interval '1 day') >= 30 then
    raise exception 'بعت طلبات كتير النهارده، كمّل بكرة';
  end if;
  insert into public.friendships (requester_id, addressee_id) values (auth.uid(), p_user);
  insert into public.notifications (user_id, title, body, deep_link)
  values (p_user, 'طلب صداقة جديد', coalesce(v_name, 'حد') || ' عايز يضيفك على مُجتمعي', '/#/friends');
  return 'sent';
end;
$$;

create or replace function public.respond_friend_request(p_user uuid, p_accept boolean) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if not exists (select 1 from public.friendships where requester_id = p_user and addressee_id = auth.uid() and status = 'pending') then
    raise exception 'مفيش طلب صداقة';
  end if;
  if p_accept then
    update public.friendships set status = 'accepted', responded_at = now() where requester_id = p_user and addressee_id = auth.uid();
    select full_name into v_name from public.profiles where id = auth.uid();
    insert into public.notifications (user_id, title, body, deep_link)
    values (p_user, 'بقيتوا أصحاب', coalesce(v_name, 'حد') || ' قبل طلب الصداقة', '/#/friends');
  else
    delete from public.friendships where requester_id = p_user and addressee_id = auth.uid();
  end if;
end;
$$;

-- Unfriend, or cancel a request either way.
create or replace function public.remove_friend(p_user uuid) returns void
language sql security definer set search_path = public as $$
  delete from public.friendships
  where least(requester_id, addressee_id) = least(auth.uid(), p_user)
    and greatest(requester_id, addressee_id) = greatest(auth.uid(), p_user);
$$;

-- Friends + pending requests, each with the last message and unread count.
create or replace function public.my_friends() returns table (
  user_id uuid, full_name text, avatar_url text, is_verified boolean, state text,
  last_message text, last_message_at timestamptz, unread int
)
language sql stable security definer set search_path = public as $$
  select p.id, p.full_name, p.avatar_url, p.is_verified,
         case when f.status = 'accepted' then 'friends' when f.requester_id = auth.uid() then 'sent' else 'received' end,
         lm.body, lm.created_at,
         (select count(*)::int from public.direct_messages m where m.sender_id = p.id and m.recipient_id = auth.uid() and m.read_at is null)
  from public.friendships f
  join public.profiles p on p.id = case when f.requester_id = auth.uid() then f.addressee_id else f.requester_id end
  left join lateral (
    select m.body, m.created_at from public.direct_messages m
    where least(m.sender_id, m.recipient_id) = least(auth.uid(), p.id) and greatest(m.sender_id, m.recipient_id) = greatest(auth.uid(), p.id)
    order by m.created_at desc limit 1
  ) lm on true
  where auth.uid() in (f.requester_id, f.addressee_id)
  order by (f.status = 'pending' and f.addressee_id = auth.uid()) desc, coalesce(lm.created_at, f.created_at) desc;
$$;

-- ---------------------------------------------------------------- block / report
create or replace function public.block_user(p_user uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null or p_user = auth.uid() then raise exception 'غير مسموح'; end if;
  insert into public.user_blocks (blocker_id, blocked_id) values (auth.uid(), p_user) on conflict do nothing;
  perform public.remove_friend(p_user);
end;
$$;
create or replace function public.unblock_user(p_user uuid) returns void
language sql security definer set search_path = public as $$
  delete from public.user_blocks where blocker_id = auth.uid() and blocked_id = p_user;
$$;
create or replace function public.flag_user(p_user uuid, p_reason text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null or p_user = auth.uid() then raise exception 'غير مسموح'; end if;
  if (select count(*) from public.user_flags where reporter_id = auth.uid() and created_at > now() - interval '1 day') >= 10 then
    raise exception 'بلّغت كتير النهارده';
  end if;
  insert into public.user_flags (reporter_id, reported_id, reason) values (auth.uid(), p_user, trim(p_reason));
end;
$$;
create or replace function public.admin_list_user_flags() returns table (
  id uuid, reporter text, reported_id uuid, reported text, reason text, created_at timestamptz, reported_count int
)
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then raise exception 'غير مسموح'; end if;
  return query
    select f.id, rp.full_name, f.reported_id, dp.full_name, f.reason, f.created_at,
           (select count(*)::int from public.user_flags x where x.reported_id = f.reported_id)
    from public.user_flags f
    join public.profiles rp on rp.id = f.reporter_id
    join public.profiles dp on dp.id = f.reported_id
    order by f.created_at desc limit 300;
end;
$$;

-- ---------------------------------------------------------------- chat
create or replace function public.send_direct_message(p_to uuid, p_body text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  v_id uuid;
  v_name text;
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  if not public.are_friends(auth.uid(), p_to) then raise exception 'الشات للأصحاب بس'; end if;
  if public.is_blocked_between(auth.uid(), p_to) then raise exception 'مينفعش تبعت للشخص ده'; end if;
  if (select count(*) from public.direct_messages where sender_id = auth.uid() and created_at > now() - interval '1 minute') >= 20 then
    raise exception 'استنى شوية قبل ما تبعت تاني';
  end if;
  insert into public.direct_messages (sender_id, recipient_id, body) values (auth.uid(), p_to, trim(p_body)) returning id into v_id;
  -- One notification per burst: only when nothing from me is still unread.
  if not exists (select 1 from public.direct_messages where sender_id = auth.uid() and recipient_id = p_to and read_at is null and id <> v_id) then
    select full_name into v_name from public.profiles where id = auth.uid();
    insert into public.notifications (user_id, title, body, deep_link)
    values (p_to, 'رسالة من ' || coalesce(v_name, 'صاحبك'), left(trim(p_body), 120), '/#/chat/' || auth.uid());
  end if;
  return v_id;
end;
$$;

-- The conversation with p_user (newest last) and marks it read.
create or replace function public.fetch_direct_messages(p_user uuid, p_before timestamptz default null, p_limit int default 60)
returns table (id uuid, mine boolean, body text, created_at timestamptz, read_at timestamptz)
language plpgsql security definer set search_path = public as $$
begin
  if auth.uid() is null then raise exception 'سجّل دخول الأول'; end if;
  update public.direct_messages dm set read_at = now() where dm.sender_id = p_user and dm.recipient_id = auth.uid() and dm.read_at is null;
  return query
    select x.id, x.mine, x.body, x.created_at, x.read_at from (
      select m.id, m.sender_id = auth.uid() as mine, m.body, m.created_at, m.read_at
      from public.direct_messages m
      where least(m.sender_id, m.recipient_id) = least(auth.uid(), p_user)
        and greatest(m.sender_id, m.recipient_id) = greatest(auth.uid(), p_user)
        and (p_before is null or m.created_at < p_before)
      order by m.created_at desc
      limit least(greatest(coalesce(p_limit, 60), 1), 200)
    ) x order by x.created_at;
end;
$$;

do $$
declare f text;
begin
  foreach f in array array[
    'get_my_presence()', 'set_discoverable(boolean, double precision, double precision, text)',
    'nearby_people(double precision, double precision, double precision, int)', 'send_friend_request(uuid)',
    'respond_friend_request(uuid, boolean)', 'remove_friend(uuid)', 'my_friends()', 'block_user(uuid)',
    'unblock_user(uuid)', 'flag_user(uuid, text)', 'admin_list_user_flags()', 'send_direct_message(uuid, text)',
    'fetch_direct_messages(uuid, timestamptz, int)'
  ] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
end;
$$;
