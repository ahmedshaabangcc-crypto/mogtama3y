-- =====================================================================
-- Migration 0107 — the super admin can suspend a store (owner,
-- 2026-10-30: «إيقاف متجر مخالف»).
--
--   * shops.suspended_at / suspended_reason / suspended_by.
--   * admin_set_shop_suspended(p_shop, p_suspend, p_reason): super admins
--     only; tells the owner (notification) and logs it.
--   * A suspended store takes no orders: a trigger on shop_orders refuses
--     any new order for it (covers place_store_order, place_shop_order and
--     anything later), with the reason the storefront shows.
--   * Owners can't lift it themselves: a guard trigger refuses changes to
--     the suspension columns from anyone but a super admin (owners have
--     table UPDATE on their shop since 0012).
--   * admin_shops() returns the suspension fields.
-- Run after 0106. Safe to re-run.
-- =====================================================================

alter table public.shops add column if not exists suspended_at timestamptz;
alter table public.shops add column if not exists suspended_reason text;
alter table public.shops add column if not exists suspended_by uuid references public.profiles(id) on delete set null;

-- Not security definer: current_user must stay the caller's role.
create or replace function public._shop_suspension_guard() returns trigger
language plpgsql
set search_path = public
as $$
begin
  if (new.suspended_at is distinct from old.suspended_at
      or new.suspended_reason is distinct from old.suspended_reason
      or new.suspended_by is distinct from old.suspended_by)
     and current_user in ('authenticated', 'anon')
     and not public.is_super_admin() then
    raise exception 'إيقاف المتجر بيتشال من إدارة مُجتمعي بس' using errcode = '42501';
  end if;
  return new;
end;
$$;
drop trigger if exists shop_suspension_guard on public.shops;
create trigger shop_suspension_guard before update on public.shops
  for each row execute function public._shop_suspension_guard();

create or replace function public._shop_order_suspended_guard() returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_reason text;
  v_at timestamptz;
begin
  select suspended_at, suspended_reason into v_at, v_reason from public.shops where id = new.shop_id;
  if v_at is not null then
    raise exception 'المتجر ده موقوف مؤقتاً ومش بيستقبل طلبات%', coalesce(' — ' || nullif(v_reason, ''), '');
  end if;
  return new;
end;
$$;
drop trigger if exists shop_order_suspended_guard on public.shop_orders;
create trigger shop_order_suspended_guard before insert on public.shop_orders
  for each row execute function public._shop_order_suspended_guard();

create or replace function public.admin_set_shop_suspended(p_shop uuid, p_suspend boolean, p_reason text default null) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  s record;
  v_reason text := nullif(left(btrim(coalesce(p_reason, '')), 300), '');
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  select id, name, owner_id, suspended_at into s from public.shops where id = p_shop for update;
  if not found then
    raise exception 'المتجر غير موجود';
  end if;
  if coalesce(p_suspend, false) then
    if v_reason is null then
      raise exception 'اكتب سبب الإيقاف — بيوصل لصاحب المتجر';
    end if;
    update public.shops set suspended_at = now(), suspended_reason = v_reason, suspended_by = auth.uid() where id = p_shop;
    if s.owner_id is not null then
      insert into public.notifications (user_id, title, body)
      values (s.owner_id, '⛔ متجرك «' || s.name || '» اتوقف مؤقتاً',
              'السبب: ' || v_reason || '. المتجر مش هيستقبل طلبات لحد ما المشكلة تتحل — كلّم دعم مُجتمعي.');
    end if;
  else
    update public.shops set suspended_at = null, suspended_reason = null, suspended_by = null where id = p_shop;
    if s.owner_id is not null and s.suspended_at is not null then
      insert into public.notifications (user_id, title, body)
      values (s.owner_id, '✅ متجرك «' || s.name || '» رجع يشتغل', 'تقدر تستقبل طلبات تاني من دلوقتي.');
    end if;
  end if;
  return jsonb_build_object('id', p_shop, 'suspended', coalesce(p_suspend, false), 'reason', case when p_suspend then v_reason end);
end;
$$;
revoke execute on function public.admin_set_shop_suspended(uuid, boolean, text) from public, anon;
grant execute on function public.admin_set_shop_suspended(uuid, boolean, text) to authenticated;

-- 0106's stores table + the suspension.
create or replace function public.admin_shops(p_q text default null, p_offset int default 0, p_limit int default 50) returns jsonb
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  v_q text := nullif(btrim(coalesce(p_q, '')), '');
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك بالوصول لهذه اللوحة' using errcode = '42501';
  end if;
  return jsonb_build_object(
    'total', (select count(*) from public.shops s
               where v_q is null or s.name ilike '%' || v_q || '%' or s.slug ilike '%' || v_q || '%'),
    'rows', coalesce((
      select jsonb_agg(r order by r.created_at desc) from (
        select s.id, s.name, s.slug, s.category, coalesce(s.country, 'EG') country, coalesce(s.currency, 'EGP') currency,
               s.source, s.is_claimed, s.created_at, s.whatsapp, s.suspended_at, s.suspended_reason,
               o.full_name as owner_name, o.phone as owner_phone,
               (select count(*) from public.shop_products sp where sp.shop_id = s.id) as products,
               (select count(*) from public.shop_orders so where so.shop_id = s.id and so.status <> 'cart') as orders,
               (select coalesce(sum(so.total_amount), 0) from public.shop_orders so
                 where so.shop_id = s.id and so.status not in ('cart', 'cancelled')) as sales,
               (select max(so.created_at) from public.shop_orders so where so.shop_id = s.id and so.status <> 'cart') as last_order_at,
               (select g.provider from public.shop_payment_gateways g
                 where g.shop_id = s.id and g.enabled and g.status = 'connected' limit 1) as gateway
          from public.shops s
          left join public.profiles o on o.id = s.owner_id
         where v_q is null or s.name ilike '%' || v_q || '%' or s.slug ilike '%' || v_q || '%'
         order by s.created_at desc
         offset greatest(coalesce(p_offset, 0), 0)
         limit least(greatest(coalesce(p_limit, 50), 1), 200)) r), '[]'::jsonb));
end;
$$;
