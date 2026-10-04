-- =====================================================================
-- Migration 0055 — phone notifications (Web Push).
--
-- Every in-app notification (new shop order, join approved, SOS, …) is
-- also pushed to the user's phone/browser when they turned it on — even
-- with the app closed (installed apps on Android, and iPhone 16.4+ when
-- added to the home screen).
--
--   * push_subscriptions: one row per device; written only through
--     save_push_subscription / delete_push_subscription.
--   * After each notifications INSERT, a trigger posts {notification_id}
--     to the Edge Function `send-push` through pg_net, signed with a
--     shared secret kept in private.push_settings (set once from the SQL
--     editor — never committed). Without pg_net or the setting the
--     trigger does nothing, so notifications keep working as before.
-- =====================================================================

do $$
begin
  create extension if not exists pg_net;
exception when others then
  raise notice 'pg_net not available — phone push stays off';
end;
$$;

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table if not exists private.push_settings (
  id boolean primary key default true check (id),
  function_url text not null,
  secret text not null
);
revoke all on private.push_settings from public, anon, authenticated;

create table if not exists public.push_subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  endpoint text not null unique,
  p256dh text not null,
  auth text not null,
  app text,
  created_at timestamptz not null default now()
);
create index if not exists push_subscriptions_user_idx on public.push_subscriptions (user_id);
alter table public.push_subscriptions enable row level security;
revoke all on public.push_subscriptions from anon, authenticated;
grant select on public.push_subscriptions to authenticated;
create policy "push_subscriptions: owner reads own" on public.push_subscriptions
  for select to authenticated using (user_id = auth.uid());

create or replace function public.save_push_subscription(p_endpoint text, p_p256dh text, p_auth text, p_app text default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_endpoint !~ '^https://' or length(p_endpoint) > 1000 or coalesce(p_p256dh, '') = '' or coalesce(p_auth, '') = '' then
    raise exception 'اشتراك إشعارات غير صحيح';
  end if;
  if (select count(*) from public.push_subscriptions where user_id = auth.uid()) >= 10 then
    delete from public.push_subscriptions
     where id = (select id from public.push_subscriptions where user_id = auth.uid() order by created_at limit 1);
  end if;
  -- A device that moved to another account follows the new account.
  insert into public.push_subscriptions (user_id, endpoint, p256dh, auth, app)
  values (auth.uid(), p_endpoint, p_p256dh, p_auth, left(p_app, 20))
  on conflict (endpoint) do update
    set user_id = excluded.user_id, p256dh = excluded.p256dh, auth = excluded.auth, app = excluded.app, created_at = now();
end;
$$;

create or replace function public.delete_push_subscription(p_endpoint text) returns void
language sql
security definer
set search_path = public
as $$
  delete from public.push_subscriptions where endpoint = p_endpoint and user_id = auth.uid();
$$;

-- Hand each new notification to the push function (fire-and-forget).
create or replace function public.notify_push() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  s record;
begin
  if not exists (select 1 from public.push_subscriptions where user_id = new.user_id) then
    return new;
  end if;
  if not exists (select 1 from pg_namespace where nspname = 'net') then
    return new;
  end if;
  select * into s from private.push_settings where id;
  if not found then
    return new;
  end if;
  execute 'select net.http_post(url := $1, body := $2, headers := $3)'
    using s.function_url,
          jsonb_build_object('notification_id', new.id),
          jsonb_build_object('Content-Type', 'application/json', 'x-push-secret', s.secret);
  return new;
exception when others then
  return new; -- a push problem must never block the notification itself
end;
$$;

drop trigger if exists notifications_push on public.notifications;
create trigger notifications_push after insert on public.notifications
  for each row execute function public.notify_push();

revoke execute on function public.notify_push() from public, anon, authenticated;
revoke execute on function public.save_push_subscription(text, text, text, text) from public, anon;
grant execute on function public.save_push_subscription(text, text, text, text) to authenticated;
revoke execute on function public.delete_push_subscription(text) from public, anon;
grant execute on function public.delete_push_subscription(text) to authenticated;
