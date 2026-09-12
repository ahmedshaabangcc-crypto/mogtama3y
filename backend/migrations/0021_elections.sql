-- =====================================================================
-- Migration 0021 — real president/board elections. union_elections,
-- union_candidates, and union_votes have existed in schema.sql since
-- the very first migration but were never wired to anything — RLS was
-- enabled with no policies (default deny) and no GRANTs. Run after
-- 0002-0020, in order, in the Supabase SQL editor.
--
-- Design: unlike founding a building (found_building() makes the
-- founder president immediately, no vote), this is for an EXISTING
-- building running a real succession election. eligible_voters is
-- snapshotted at creation (same pattern as board_decisions). A vote is
-- changeable while the election is open (one row per voter via the
-- existing unique(election_id, voter_id), upserted). Finalizing checks
-- real quorum (total votes / eligible_voters vs legal_quorum_pct) and,
-- if met, actually hands over the union_members.role — demotes the
-- current president to board_member and promotes the winner — so this
-- is a real leadership change, not just a cosmetic result screen.
-- =====================================================================

alter table public.union_candidates add constraint union_candidates_election_user_key unique (election_id, user_id);

grant select on public.union_elections to authenticated;
grant select on public.union_candidates to authenticated;
grant select on public.union_votes to authenticated;

create policy "union_elections: building members view" on public.union_elections
  for select using (public.is_verified_member_of(building_id));

create policy "union_candidates: building members view" on public.union_candidates
  for select using (
    exists (select 1 from public.union_elections e where e.id = union_candidates.election_id and public.is_verified_member_of(e.building_id))
  );

-- ballots stay private: a voter can only see their own vote row, never
-- anyone else's — the public number is union_candidates.vote_count.
create policy "union_votes: voter views own" on public.union_votes
  for select using (auth.uid() = voter_id);

create or replace function public.create_election(
  p_title text,
  p_closes_at timestamptz,
  p_legal_quorum_pct numeric default 65.00
) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_building_id uuid;
  v_eligible int;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select building_id into v_building_id from public.union_members
    where user_id = auth.uid() and status = 'verified' and role in ('president', 'board_member')
    limit 1;
  if v_building_id is null then
    raise exception 'غير مصرح لك بإنشاء انتخابات لهذه العمارة';
  end if;

  select count(*) into v_eligible from public.union_members
    where building_id = v_building_id and status = 'verified';

  insert into public.union_elections (building_id, title, legal_quorum_pct, eligible_voters, closes_at)
  values (v_building_id, p_title, p_legal_quorum_pct, v_eligible, p_closes_at)
  returning id into v_id;

  return v_id;
end;
$$;

grant execute on function public.create_election(text, timestamptz, numeric) to authenticated;

create or replace function public.nominate_self(p_election_id uuid, p_pledge text) returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized or v_election.closes_at < now() then
    raise exception 'انتهت فترة الترشح لهذه الانتخابات';
  end if;
  if not public.is_verified_member_of(v_election.building_id) then
    raise exception 'غير مصرح لك بالترشح في هذه الانتخابات';
  end if;

  insert into public.union_candidates (election_id, user_id, pledge)
  values (p_election_id, auth.uid(), p_pledge)
  on conflict (election_id, user_id) do update set pledge = excluded.pledge
  returning id into v_id;

  return v_id;
end;
$$;

grant execute on function public.nominate_self(uuid, text) to authenticated;

create or replace function public.cast_election_vote(p_election_id uuid, p_candidate_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_previous_candidate_id uuid;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id for update;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized or v_election.closes_at < now() then
    raise exception 'انتهت فترة التصويت لهذه الانتخابات';
  end if;
  if not public.is_verified_member_of(v_election.building_id) then
    raise exception 'غير مصرح لك بالتصويت في هذه الانتخابات';
  end if;
  if not exists (select 1 from public.union_candidates c where c.id = p_candidate_id and c.election_id = p_election_id) then
    raise exception 'المرشح غير موجود في هذه الانتخابات';
  end if;

  select candidate_id into v_previous_candidate_id from public.union_votes
    where election_id = p_election_id and voter_id = auth.uid();

  if v_previous_candidate_id is not null and v_previous_candidate_id = p_candidate_id then
    return;
  end if;

  insert into public.union_votes (election_id, candidate_id, voter_id)
  values (p_election_id, p_candidate_id, auth.uid())
  on conflict (election_id, voter_id) do update set candidate_id = excluded.candidate_id, cast_at = now();

  if v_previous_candidate_id is not null then
    update public.union_candidates set vote_count = greatest(vote_count - 1, 0) where id = v_previous_candidate_id;
  end if;
  update public.union_candidates set vote_count = vote_count + 1 where id = p_candidate_id;
end;
$$;

grant execute on function public.cast_election_vote(uuid, uuid) to authenticated;

create or replace function public.finalize_election(p_election_id uuid) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_election record;
  v_is_authorized boolean;
  v_total_votes int;
  v_winner record;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;

  select * into v_election from public.union_elections where id = p_election_id for update;
  if not found then
    raise exception 'الانتخابات غير موجودة';
  end if;
  if v_election.is_finalized then
    raise exception 'تم إغلاق هذه الانتخابات بالفعل';
  end if;

  select exists(
    select 1 from public.union_members m
    where m.building_id = v_election.building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
  ) into v_is_authorized;
  if not v_is_authorized then
    raise exception 'غير مصرح لك بإغلاق هذه الانتخابات';
  end if;

  select count(*) into v_total_votes from public.union_votes where election_id = p_election_id;

  update public.union_elections set
    is_finalized = true,
    result_pct = case when v_election.eligible_voters > 0 then round(v_total_votes::numeric / v_election.eligible_voters * 100, 2) else 0 end
  where id = p_election_id;

  if v_election.eligible_voters = 0 or (v_total_votes::numeric / v_election.eligible_voters * 100) < v_election.legal_quorum_pct then
    return;
  end if;

  select * into v_winner from public.union_candidates
    where election_id = p_election_id order by vote_count desc limit 1;
  if v_winner is null then
    return;
  end if;

  update public.union_members set role = 'board_member'
    where building_id = v_election.building_id and role = 'president' and user_id <> v_winner.user_id;

  update public.union_members set role = 'president'
    where building_id = v_election.building_id and user_id = v_winner.user_id;
end;
$$;

grant execute on function public.finalize_election(uuid) to authenticated;
