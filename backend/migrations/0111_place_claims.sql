-- 0111 — «استلم محلك جاهز»: the owner of a place in the directory (dalil)
-- turns it into a store in one step, with its name, address, location and
-- number already filled in.
--
--   place_claim_info(place)  — anyone: what the claim page shows.
--   claim_place_as_shop(place, slug, whatsapp, name?, category?)
--       creates the caller's store (create_my_shop's rules) and then:
--       * the caller's SMS-verified number is the place's number →
--         approved at once: the place points at the store
--         (claimed_shop_id; dalil's /p/<id> then redirects to the store)
--         and the store takes the place's location;
--       * otherwise → a pending claim for the admins; the store works
--         meanwhile, the place stays unlinked until approved.
--   my_place_claims()                    — the caller's claims.
--   admin_place_claims(status)           — super admin list.
--   admin_place_claim_review(id, approve, note) — approve / reject;
--       approving links the place (and drops the store's own «merchant»
--       directory row, if it pinned one meanwhile); the owner is told.

create table if not exists public.place_claims (
  id uuid primary key default gen_random_uuid(),
  place_id text not null references public.directory_places (id) on delete cascade,
  shop_id uuid not null references public.shops (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  auto boolean not null default false,
  note text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users (id) on delete set null
);
create index if not exists place_claims_status on public.place_claims (status, created_at desc);
create unique index if not exists place_claims_one_pending
  on public.place_claims (place_id, user_id) where status = 'pending';

alter table public.place_claims enable row level security;
drop policy if exists "place_claims: own" on public.place_claims;
create policy "place_claims: own" on public.place_claims for select to authenticated using (user_id = auth.uid());
revoke all on public.place_claims from anon, authenticated;
grant select on public.place_claims to authenticated;

-- A directory category → the store activity the merchant picks from.
create or replace function private.shop_category_of_dir(p text) returns text
language sql immutable as $$
  select case p
    when 'صيدليات' then 'صيدلية / مستحضرات'
    when 'سوبر ماركت وبقالة' then 'سوبر ماركت / بقالة'
    when 'مطاعم' then 'مطعم / كافيه'
    when 'كافيهات' then 'مطعم / كافيه'
    when 'ملابس وأزياء' then 'ملابس وأحذية'
    when 'إلكترونيات وموبايلات' then 'موبايلات وإكسسوارات'
    when 'أدوات منزلية وأثاث' then 'أدوات منزلية'
    else coalesce(nullif(trim(p), ''), 'نشاط تاني')
  end
$$;

create or replace function public.place_claim_info(p_place text) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'id', d.id, 'name', d.name, 'category', d.category,
    'shop_category', private.shop_category_of_dir(d.category),
    'address', d.address, 'phone', coalesce(nullif(d.whatsapp, ''), d.phone), 'country', d.country,
    'lat', d.lat, 'lng', d.lng,
    'claimed', d.claimed_shop_id is not null,
    'store_slug', (select s.slug from public.shops s where s.id = d.claimed_shop_id))
  from public.directory_places d
  where d.id = p_place and not d.hidden
$$;
revoke execute on function public.place_claim_info(text) from public;
grant execute on function public.place_claim_info(text) to anon, authenticated;

-- Links a place to a store: the store takes the place's location (the
-- shop trigger then finds the link and leaves the place's data alone).
create or replace function private.place_claim_link(p_place text, p_shop uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  d record;
begin
  select * into d from public.directory_places where id = p_place for update;
  if d.claimed_shop_id is not null and d.claimed_shop_id <> p_shop then
    raise exception 'المحل ده اتربط بمتجر تاني';
  end if;
  -- A row the store made for itself (it pinned its location meanwhile).
  delete from public.directory_places where claimed_shop_id = p_shop and source = 'merchant' and id <> p_place;
  update public.directory_places set claimed_shop_id = p_shop where id = p_place;
  update public.shops
     set lat = round(d.lat::numeric, 6), lng = round(d.lng::numeric, 6),
         address = coalesce(address, left(d.address, 300))
   where id = p_shop;
end;
$$;
revoke execute on function private.place_claim_link(text, uuid) from public, anon, authenticated;

create or replace function public.claim_place_as_shop(
  p_place text, p_slug text, p_whatsapp text, p_name text default null, p_category text default null
) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  d record;
  v_shop uuid;
  v_mine text;
  v_auto boolean;
  v_claim uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  select * into d from public.directory_places where id = p_place and not hidden;
  if not found then
    raise exception 'المحل ده مش موجود في الدليل';
  end if;
  if d.claimed_shop_id is not null then
    raise exception 'المحل ده ليه متجر بالفعل';
  end if;
  if exists (select 1 from public.place_claims where place_id = p_place and user_id = auth.uid() and status = 'pending') then
    raise exception 'طلبك للمحل ده لسه بيتراجع';
  end if;

  v_shop := public.create_my_shop(
    coalesce(nullif(trim(p_name), ''), d.name),
    coalesce(nullif(trim(p_category), ''), private.shop_category_of_dir(d.category)),
    p_slug, p_whatsapp, d.address);

  -- The proof: the caller's SMS-verified number is the place's number.
  select private.phone_store(phone, d.country) into v_mine
    from public.profiles where id = auth.uid() and phone_verified_at is not null;
  v_auto := v_mine is not null and v_mine in (
    private.phone_store(d.phone, d.country), private.phone_store(d.whatsapp, d.country));

  insert into public.place_claims (place_id, shop_id, user_id, status, auto, reviewed_at)
  values (p_place, v_shop, auth.uid(), case when v_auto then 'approved' else 'pending' end, v_auto,
          case when v_auto then now() end)
  returning id into v_claim;

  if v_auto then
    perform private.place_claim_link(p_place, v_shop);
  else
    insert into public.notifications (user_id, title, body)
    select p.id, '🏪 طلب استلام محل', left(d.name, 80) || ' — محتاج مراجعة في لوحة الأدمن.'
      from public.profiles p where p.role = 'super_admin';
  end if;
  return jsonb_build_object('shop_id', v_shop, 'claim_id', v_claim, 'status', case when v_auto then 'approved' else 'pending' end);
end;
$$;
revoke execute on function public.claim_place_as_shop(text, text, text, text, text) from public, anon;
grant execute on function public.claim_place_as_shop(text, text, text, text, text) to authenticated;

create or replace function public.my_place_claims() returns jsonb
language sql stable security definer set search_path = public as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', c.id, 'place_id', c.place_id, 'place_name', d.name, 'shop_id', c.shop_id,
    'status', c.status, 'note', c.note, 'created_at', c.created_at) order by c.created_at desc), '[]'::jsonb)
  from public.place_claims c join public.directory_places d on d.id = c.place_id
  where c.user_id = auth.uid()
$$;
revoke execute on function public.my_place_claims() from public, anon;
grant execute on function public.my_place_claims() to authenticated;

create or replace function public.admin_place_claims(p_status text default 'pending') returns jsonb
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  return coalesce((select jsonb_agg(r order by r->>'created_at' desc) from (
    select jsonb_build_object(
      'id', c.id, 'status', c.status, 'auto', c.auto, 'note', c.note, 'created_at', c.created_at,
      'place_id', d.id, 'place_name', d.name, 'place_category', d.category, 'place_address', d.address,
      'place_phone', coalesce(nullif(d.whatsapp, ''), d.phone),
      'shop_id', s.id, 'shop_name', s.name, 'shop_slug', s.slug, 'shop_whatsapp', s.whatsapp,
      'user_name', p.full_name, 'user_phone', p.phone, 'user_phone_verified', p.phone_verified_at is not null) r
    from public.place_claims c
    join public.directory_places d on d.id = c.place_id
    join public.shops s on s.id = c.shop_id
    left join public.profiles p on p.id = c.user_id
    where p_status is null or c.status = p_status
    order by c.created_at desc limit 200) x), '[]'::jsonb);
end;
$$;
revoke execute on function public.admin_place_claims(text) from public, anon;
grant execute on function public.admin_place_claims(text) to authenticated;

create or replace function public.admin_place_claim_review(p_claim uuid, p_approve boolean, p_note text default null) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  c record;
  v_name text;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  select * into c from public.place_claims where id = p_claim for update;
  if not found or c.status <> 'pending' then
    raise exception 'الطلب ده مش مستني مراجعة';
  end if;
  if not p_approve and length(trim(coalesce(p_note, ''))) < 3 then
    raise exception 'اكتب سبب الرفض';
  end if;
  select name into v_name from public.directory_places where id = c.place_id;
  if p_approve then
    perform private.place_claim_link(c.place_id, c.shop_id);
    -- Other people's pending claims for the same place lose.
    update public.place_claims set status = 'rejected', note = 'اتربط المحل بصاحب تاني', reviewed_at = now(), reviewed_by = auth.uid()
     where place_id = c.place_id and status = 'pending' and id <> c.id;
  end if;
  update public.place_claims
     set status = case when p_approve then 'approved' else 'rejected' end,
         note = nullif(trim(coalesce(p_note, '')), ''), reviewed_at = now(), reviewed_by = auth.uid()
   where id = c.id;
  insert into public.notifications (user_id, title, body)
  values (c.user_id,
          case when p_approve then '✅ محلك اتربط بمتجرك' else '❌ طلب استلام المحل اترفض' end,
          case when p_approve
               then left(v_name, 80) || ': صفحته في الدليل وفي جوجل بقت بتفتح متجرك.'
               else left(v_name, 80) || ': ' || trim(p_note) || ' — متجرك شغال عادي.' end);
  return jsonb_build_object('id', c.id, 'status', case when p_approve then 'approved' else 'rejected' end);
end;
$$;
revoke execute on function public.admin_place_claim_review(uuid, boolean, text) from public, anon;
grant execute on function public.admin_place_claim_review(uuid, boolean, text) to authenticated;
