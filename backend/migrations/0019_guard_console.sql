-- =====================================================================
-- Migration 0019 — real guard console. Run after 0002-0018, in order,
-- in the Supabase SQL editor.
--
-- Design: a guard is NOT a union_role (avoids an enum change, which
-- Postgres refuses to let you use in the same transaction it was added
-- in — a real risk given the Supabase SQL editor runs a pasted script
-- as one block). Instead a new building_guards table marks a profile as
-- an active guard for a building, appointed/revoked by that building's
-- president/board through two new SECURITY DEFINER RPCs. A guard does
-- NOT need to be a resident/union_member — appointed staff with no
-- unit of their own can be guards.
--
-- The console reuses existing tables rather than inventing new ones:
--   * "delivery" is already a visitor_passes.pass_type — no separate
--     deliveries table needed, verified deliveries just show up in the
--     same recent-passes list.
--   * "custody" is just this building's unresolved lost_found_items of
--     type 'found' — the guard gets a new policy to resolve them
--     (hand them back), same table residents already use.
--   * "scan to verify" is manual code entry (the visitor reads/shows
--     their PASS-XXXXXX code) rather than a camera QR scanner — adding
--     camera scanning is a real future upgrade, not done here.
-- =====================================================================

create table public.building_guards (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  appointed_by uuid not null references public.profiles(id),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (building_id, user_id)
);

grant select on public.building_guards to authenticated;

create or replace function public.is_active_guard_of(p_building_id uuid) returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.building_guards
    where building_id = p_building_id and user_id = auth.uid() and is_active = true
  );
$$;

create policy "building_guards: guard views own" on public.building_guards
  for select using (auth.uid() = user_id);

create policy "building_guards: admin views building" on public.building_guards
  for select using (
    exists (
      select 1 from public.union_members m
      where m.building_id = building_guards.building_id
        and m.user_id = auth.uid()
        and m.status = 'verified'
        and m.role in ('president', 'board_member')
    )
  );

-- ---- appoint_guard() / revoke_guard(): president/board only ----

create or replace function public.appoint_guard(p_building_id uuid, p_user_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_is_authorized boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select exists(
    select 1 from public.union_members m
    where m.building_id = p_building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
  ) into v_is_authorized;

  if not v_is_authorized then
    raise exception 'غير مصرح لك بتعيين حارس لهذه العمارة';
  end if;

  insert into public.building_guards (building_id, user_id, appointed_by, is_active)
  values (p_building_id, p_user_id, auth.uid(), true)
  on conflict (building_id, user_id) do update set is_active = true, appointed_by = auth.uid();
end;
$$;

grant execute on function public.appoint_guard(uuid, uuid) to authenticated;

create or replace function public.revoke_guard(p_building_id uuid, p_user_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_is_authorized boolean;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select exists(
    select 1 from public.union_members m
    where m.building_id = p_building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
  ) into v_is_authorized;

  if not v_is_authorized then
    raise exception 'غير مصرح لك بإدارة حراس هذه العمارة';
  end if;

  update public.building_guards set is_active = false
    where building_id = p_building_id and user_id = p_user_id;
end;
$$;

grant execute on function public.revoke_guard(uuid, uuid) to authenticated;

-- ---- visitor_passes: let an active guard see (not just issue) passes for their building ----

create policy "visitor_passes: guard views building" on public.visitor_passes
  for select using (
    exists (
      select 1 from public.units u
      where u.id = visitor_passes.unit_id and public.is_active_guard_of(u.building_id)
    )
  );

create or replace function public.verify_visitor_pass(p_qr_code text) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_pass record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select vp.id, vp.status, vp.valid_until, vp.visitor_name, vp.pass_type,
         u.building_id, u.unit_number, u.floor_label
  into v_pass
  from public.visitor_passes vp
  join public.units u on u.id = vp.unit_id
  where vp.qr_code = p_qr_code
  for update of vp;

  if not found then
    raise exception 'كود التصريح غير صحيح';
  end if;

  if not public.is_active_guard_of(v_pass.building_id) then
    raise exception 'غير مصرح لك بالتحقق من تصاريح هذه العمارة';
  end if;

  if v_pass.valid_until < now() and v_pass.status = 'active' then
    update public.visitor_passes set status = 'expired' where id = v_pass.id;
    raise exception 'انتهت صلاحية هذا التصريح';
  end if;

  if v_pass.status <> 'active' then
    raise exception 'هذا التصريح غير نشط (تم استخدامه أو إلغاؤه بالفعل)';
  end if;

  update public.visitor_passes set status = 'used' where id = v_pass.id;

  return jsonb_build_object(
    'visitor_name', v_pass.visitor_name,
    'pass_type', v_pass.pass_type,
    'unit_number', v_pass.unit_number,
    'floor_label', v_pass.floor_label
  );
end;
$$;

grant execute on function public.verify_visitor_pass(text) to authenticated;

-- security invoker (default) on purpose — relies on the SELECT policy
-- just above, so a non-guard calling this simply gets an empty result
-- instead of needing its own authorization check.
create or replace function public.fetch_guard_recent_passes(p_building_id uuid, p_limit int default 20)
returns table (id uuid, visitor_name text, pass_type pass_type, status pass_status, unit_number text, floor_label text, created_at timestamptz)
language sql
stable
set search_path = public
as $$
  select vp.id, vp.visitor_name, vp.pass_type, vp.status, u.unit_number, u.floor_label, vp.created_at
  from public.visitor_passes vp
  join public.units u on u.id = vp.unit_id
  where u.building_id = p_building_id and vp.status in ('used', 'expired')
  order by vp.created_at desc
  limit p_limit;
$$;

grant execute on function public.fetch_guard_recent_passes(uuid, int) to authenticated;

-- ---- lost_found_items: guard can see & close out custody for their building ----

create policy "lost_found_items: guard views building" on public.lost_found_items
  for select using (public.is_active_guard_of(building_id));

create policy "lost_found_items: guard can mark resolved" on public.lost_found_items
  for update using (public.is_active_guard_of(building_id))
  with check (public.is_active_guard_of(building_id));
