-- 0112 — «جهّزنالك متجرك»: the team builds a store for a directory place
-- on the owner's behalf (after a phone call: the owner agrees and gives the
-- prices), then the owner claims it with everything already in it.
--
--   admin_prepare_place_store(place, slug, whatsapp, category, products)
--       super admin: a store with no owner yet (prepared_at), the place's
--       name / address / location, and the priced products; the place
--       points at it at once, so its dalil / Google page shows the products.
--       Orders wait until the owner claims it (no owner → place_shop_order
--       refuses, as for any unclaimed store).
--   claim_place_as_shop (0111) on a prepared store: no new store — the
--       claimant takes this one. Proof = their SMS-verified number is the
--       place's number or the number the owner gave the team (the store's
--       WhatsApp); otherwise a pending claim, and approving it hands the
--       store over.
--   place_claim_info: + prepared, products; «claimed» only once owned.
--   admin_prepared_stores(): the stores still waiting for their owner.

alter table public.shops add column if not exists prepared_at timestamptz;
alter table public.shops add column if not exists prepared_by uuid references auth.users (id) on delete set null;

create or replace function public.place_claim_info(p_place text) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'id', d.id, 'name', d.name, 'category', d.category,
    'shop_category', coalesce(s.category, private.shop_category_of_dir(d.category)),
    'address', d.address, 'phone', coalesce(nullif(d.whatsapp, ''), d.phone), 'country', d.country,
    'lat', d.lat, 'lng', d.lng,
    'claimed', s.owner_id is not null,
    'store_slug', s.slug,
    'prepared', s.id is not null and s.owner_id is null,
    'products', (select count(*) from public.shop_products sp where sp.shop_id = s.id and sp.price > 0 and sp.is_available))
  from public.directory_places d
  left join public.shops s on s.id = d.claimed_shop_id
  where d.id = p_place and not d.hidden
$$;

-- Hands a prepared store to its owner.
create or replace function private.prepared_store_handover(p_shop uuid, p_user uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if (select count(*) from public.shops where owner_id = p_user) >= 3 then
    raise exception 'وصلت للحد الأقصى (3 محلات لكل حساب)';
  end if;
  update public.shops set owner_id = p_user, is_claimed = true, claimed_at = now()
   where id = p_shop and owner_id is null;
  if not found then
    raise exception 'المتجر ده اتسلّم بالفعل';
  end if;
end;
$$;
revoke execute on function private.prepared_store_handover(uuid, uuid) from public, anon, authenticated;

create or replace function public.admin_prepare_place_store(
  p_place text, p_slug text, p_whatsapp text, p_category text, p_products jsonb
) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  d record;
  v_slug text := lower(trim(coalesce(p_slug, '')));
  v_phone text;
  v_shop uuid;
  v_n int;
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  select * into d from public.directory_places where id = p_place and not hidden for update;
  if not found then
    raise exception 'المحل ده مش موجود في الدليل';
  end if;
  if d.claimed_shop_id is not null then
    raise exception 'المحل ده ليه متجر بالفعل';
  end if;
  if v_slug !~ '^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$' then
    raise exception 'اسم الرابط لازم يكون بالإنجليزي (حروف وأرقام وشرطة) من 3 لـ 40 حرف';
  end if;
  if exists (select 1 from public.shops where slug = v_slug) then
    raise exception 'اسم الرابط ده مستخدم، جرّب اسم تاني';
  end if;
  v_phone := private.phone_store(p_whatsapp, d.country);
  if v_phone is null then
    raise exception 'رقم الواتساب مش صحيح';
  end if;
  if p_products is null or jsonb_typeof(p_products) <> 'array' or jsonb_array_length(p_products) not between 1 and 60 then
    raise exception 'ضيف من 1 لـ 60 منتج بأسعارهم';
  end if;
  if exists (select 1 from jsonb_array_elements(p_products) e
             where length(trim(coalesce(e->>'name', ''))) < 2
                or coalesce((e->>'price')::numeric, 0) <= 0) then
    raise exception 'كل منتج لازم يكون ليه اسم وسعر';
  end if;

  insert into public.shops (owner_id, source, name, category, slug, whatsapp, address, lat, lng, is_claimed, prepared_at, prepared_by)
  values (null, 'claimed', left(d.name, 120), coalesce(nullif(trim(p_category), ''), private.shop_category_of_dir(d.category)),
          v_slug, v_phone, left(d.address, 300), round(d.lat::numeric, 6), round(d.lng::numeric, 6), false, now(), auth.uid())
  returning id into v_shop;
  update public.directory_places set claimed_shop_id = v_shop where id = p_place;

  insert into public.shop_products (shop_id, name, category, description, highlights, images, image_url, options, price, is_available, status, position)
  select v_shop, left(trim(e->>'name'), 120), nullif(e->>'category', ''), nullif(e->>'description', ''),
         coalesce((select array_agg(x) from jsonb_array_elements_text(coalesce(e->'highlights', '[]'::jsonb)) x), '{}'),
         coalesce((select array_agg(x) from jsonb_array_elements_text(coalesce(e->'images', '[]'::jsonb)) x where x ~ '^https://'), '{}'),
         case when e->>'image_url' ~ '^https://' then e->>'image_url' end,
         coalesce(e->'options', '[]'::jsonb), (e->>'price')::numeric, true, 'active', i::int
  from jsonb_array_elements(p_products) with ordinality as t(e, i);
  get diagnostics v_n = row_count;

  return jsonb_build_object('shop_id', v_shop, 'slug', v_slug, 'products', v_n,
    'claim_url', 'https://tajer.mogtama3y.com/#/claim/' || p_place);
end;
$$;
revoke execute on function public.admin_prepare_place_store(text, text, text, text, jsonb) from public, anon;
grant execute on function public.admin_prepare_place_store(text, text, text, text, jsonb) to authenticated;

create or replace function public.claim_place_as_shop(
  p_place text, p_slug text, p_whatsapp text, p_name text default null, p_category text default null
) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  d record;
  v_prep uuid;
  v_prep_wa text;
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
    select id, whatsapp into v_prep, v_prep_wa from public.shops
     where id = d.claimed_shop_id and owner_id is null and prepared_at is not null;
    if v_prep is null then
      raise exception 'المحل ده ليه متجر بالفعل';
    end if;
  end if;
  if exists (select 1 from public.place_claims where place_id = p_place and user_id = auth.uid() and status = 'pending') then
    raise exception 'طلبك للمحل ده لسه بيتراجع';
  end if;

  -- The proof: the caller's SMS-verified number is the place's number (or,
  -- for a prepared store, the number the owner gave the team).
  select private.phone_store(phone, d.country) into v_mine
    from public.profiles where id = auth.uid() and phone_verified_at is not null;
  v_auto := coalesce(v_mine in (
    private.phone_store(d.phone, d.country), private.phone_store(d.whatsapp, d.country), v_prep_wa), false);

  if v_prep is not null then
    v_shop := v_prep;
    if v_auto then
      perform private.prepared_store_handover(v_shop, auth.uid());
    end if;
  else
    v_shop := public.create_my_shop(
      coalesce(nullif(trim(p_name), ''), d.name),
      coalesce(nullif(trim(p_category), ''), private.shop_category_of_dir(d.category)),
      p_slug, p_whatsapp, d.address);
  end if;

  insert into public.place_claims (place_id, shop_id, user_id, status, auto, reviewed_at)
  values (p_place, v_shop, auth.uid(), case when v_auto then 'approved' else 'pending' end, v_auto,
          case when v_auto then now() end)
  returning id into v_claim;

  if v_auto then
    perform private.place_claim_link(p_place, v_shop);
    -- Anyone else's pending claim for this place loses.
    update public.place_claims set status = 'rejected', note = 'صاحب المحل استلمه برقمه', reviewed_at = now()
     where place_id = p_place and status = 'pending' and id <> v_claim;
  else
    insert into public.notifications (user_id, title, body)
    select p.id, '🏪 طلب استلام محل', left(d.name, 80) || ' — محتاج مراجعة في لوحة الأدمن.'
      from public.profiles p where p.role = 'super_admin';
  end if;
  return jsonb_build_object('shop_id', v_shop, 'claim_id', v_claim, 'status', case when v_auto then 'approved' else 'pending' end,
    'prepared', v_prep is not null);
end;
$$;

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
    if exists (select 1 from public.shops where id = c.shop_id and owner_id is not null and owner_id <> c.user_id) then
      raise exception 'المتجر ده بقى بتاع حد تاني';
    end if;
    -- A prepared store changes hands; a store of their own gets the place.
    if exists (select 1 from public.shops where id = c.shop_id and owner_id is null) then
      perform private.prepared_store_handover(c.shop_id, c.user_id);
    end if;
    perform private.place_claim_link(c.place_id, c.shop_id);
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
               else left(v_name, 80) || ': ' || trim(p_note) || '.' end);
  return jsonb_build_object('id', c.id, 'status', case when p_approve then 'approved' else 'rejected' end);
end;
$$;

create or replace function public.admin_prepared_stores() returns jsonb
language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_super_admin() then
    raise exception 'غير مصرح لك' using errcode = '42501';
  end if;
  return coalesce((select jsonb_agg(jsonb_build_object(
      'shop_id', s.id, 'name', s.name, 'slug', s.slug, 'whatsapp', s.whatsapp, 'prepared_at', s.prepared_at,
      'place_id', d.id, 'claim_url', 'https://tajer.mogtama3y.com/#/claim/' || d.id,
      'products', (select count(*) from public.shop_products sp where sp.shop_id = s.id)) order by s.prepared_at desc)
    from public.shops s left join public.directory_places d on d.claimed_shop_id = s.id
    where s.prepared_at is not null and s.owner_id is null), '[]'::jsonb);
end;
$$;
revoke execute on function public.admin_prepared_stores() from public, anon;
grant execute on function public.admin_prepared_stores() to authenticated;
