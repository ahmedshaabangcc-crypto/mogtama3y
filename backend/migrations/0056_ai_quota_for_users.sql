-- =====================================================================
-- Migration 0056 — the AI copywriter's daily quota, callable as the user.
--
-- product-ai used the service-role key for its quota and shop check; on
-- projects where that key isn't exposed to Edge Functions the check
-- failed and every merchant got "الخدمة دي للتجار اللي مسجلين محل".
-- The function now runs with the merchant's own session: this RPC checks
-- they own a shop and counts today's suggestions for auth.uid() only.
-- =====================================================================

create or replace function public.bump_my_ai_usage() returns text
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    return 'signed_out';
  end if;
  if not exists (select 1 from public.shops where owner_id = auth.uid()) then
    return 'no_shop';
  end if;
  if not public.bump_places_usage('ai:' || auth.uid()::text, 30) then
    return 'over_quota';
  end if;
  return 'ok';
end;
$$;

revoke execute on function public.bump_my_ai_usage() from public, anon;
grant execute on function public.bump_my_ai_usage() to authenticated;
