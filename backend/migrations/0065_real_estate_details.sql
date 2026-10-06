-- =====================================================================
-- 0065 — Real estate: the full split people search by.
--
-- offer_type   تمليك / إيجار / إيجار مفروش / إيجار قديم / إيجار يومي-مصيفي
-- property_type  شقة، دوبلكس، بنتهاوس، ستوديو، روف، فيلا، تاون هاوس، شاليه،
--                عمارة كاملة، أراضي (سكني/زراعي/تجاري/صناعي)، محل، مكتب،
--                عيادة، مخزن، جراج
-- plus floor, finishing, furnished, payment, governorate and area.
-- deal_type (sale/rent, used by older builds) is kept in step by a trigger.
-- =====================================================================

alter table public.real_estate_listings
  add column if not exists offer_type text,
  add column if not exists property_type text,
  add column if not exists floor int,
  add column if not exists finishing text,
  add column if not exists furnished boolean not null default false,
  add column if not exists payment text,
  add column if not exists governorate text,
  add column if not exists area_name text;

update public.real_estate_listings set offer_type = case when deal_type = 'sale' then 'sale' else 'rent' end where offer_type is null;
update public.real_estate_listings set property_type = 'apartment' where property_type is null;

alter table public.real_estate_listings alter column offer_type set not null;
alter table public.real_estate_listings alter column property_type set not null;
alter table public.real_estate_listings alter column offer_type set default 'sale';
alter table public.real_estate_listings alter column property_type set default 'apartment';

alter table public.real_estate_listings drop constraint if exists real_estate_offer_type_check;
alter table public.real_estate_listings add constraint real_estate_offer_type_check
  check (offer_type in ('sale', 'rent', 'rent_furnished', 'rent_old', 'rent_daily'));
alter table public.real_estate_listings drop constraint if exists real_estate_property_type_check;
alter table public.real_estate_listings add constraint real_estate_property_type_check
  check (property_type in ('apartment', 'duplex', 'penthouse', 'studio', 'roof', 'villa', 'townhouse', 'chalet', 'building',
                           'land_residential', 'land_agricultural', 'land_commercial', 'land_industrial',
                           'shop', 'office', 'clinic', 'warehouse', 'garage'));
alter table public.real_estate_listings drop constraint if exists real_estate_finishing_check;
alter table public.real_estate_listings add constraint real_estate_finishing_check
  check (finishing is null or finishing in ('super_lux', 'lux', 'semi', 'bare'));
alter table public.real_estate_listings drop constraint if exists real_estate_payment_check;
alter table public.real_estate_listings add constraint real_estate_payment_check
  check (payment is null or payment in ('cash', 'installments', 'both'));
alter table public.real_estate_listings drop constraint if exists real_estate_floor_check;
alter table public.real_estate_listings add constraint real_estate_floor_check check (floor is null or floor between -2 and 80);

create index if not exists real_estate_browse on public.real_estate_listings (status, offer_type, property_type, created_at desc);

-- deal_type follows offer_type (sale → sale, every rental → rent).
create or replace function public.real_estate_sync_deal_type() returns trigger
language plpgsql as $$
begin
  new.deal_type := case when new.offer_type = 'sale' then 'sale'::real_estate_deal_type else 'rent'::real_estate_deal_type end;
  return new;
end;
$$;
drop trigger if exists real_estate_sync_deal_type on public.real_estate_listings;
create trigger real_estate_sync_deal_type before insert or update of offer_type, deal_type on public.real_estate_listings
  for each row execute function public.real_estate_sync_deal_type();
