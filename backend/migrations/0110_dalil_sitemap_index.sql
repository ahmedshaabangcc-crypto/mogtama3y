-- 0110 — the dalil server's places sitemap lists only the places most
-- likely to be indexed (phone, address, a real category, confidence ≥ 0.7;
-- ~55k of ~298k). Keyset-paging that filter by id read ~5 rows per match
-- from the heap, so a cold page took ~3 s against the anon role's 3 s
-- statement_timeout. This partial index holds exactly those ids, written the
-- way PostgREST sends the filter (hidden=is.false, phone=neq., …,
-- confidence=gte.0.7 on a real column) so the planner can use it.

create index if not exists directory_places_sitemap
  on public.directory_places (id)
  where hidden is false
    and phone <> ''
    and address <> ''
    and category <> 'أخرى'
    and confidence >= '0.7'::real;
