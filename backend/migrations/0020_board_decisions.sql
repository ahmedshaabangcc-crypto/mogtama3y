-- =====================================================================
-- Migration 0020 — real board-of-directors decisions (distinct from the
-- president/board election in union_elections/union_candidates/
-- union_votes, which schema.sql already defines but nothing uses yet —
-- this is the separate "approve this expense/appointment" governance
-- layer board_decisions_screen.dart was mocking). Run after 0002-0019,
-- in order, in the Supabase SQL editor.
--
-- Design: eligible_voters is snapshotted on the decision at proposal
-- time (same pattern as union_elections.eligible_voters), so a board
-- membership change mid-vote can't retroactively change the threshold
-- for a vote already in progress. A decision needing simple majority
-- resolves once one side has strictly more than half of ALL eligible
-- voters (not just those who've voted so far, since undecided votes
-- can no longer flip it); one needing unanimity resolves rejected on
-- the first reject, approved only once every eligible voter approved.
-- =====================================================================

create type board_decision_status as enum ('open', 'approved', 'rejected');
create type board_vote_choice as enum ('approve', 'reject');

create table public.board_decisions (
  id uuid primary key default gen_random_uuid(),
  building_id uuid not null references public.buildings(id) on delete cascade,
  proposed_by uuid not null references public.profiles(id),
  title text not null,
  description text,
  requires_unanimous boolean not null default false,
  eligible_voters int not null,
  status board_decision_status not null default 'open',
  closed_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.board_decision_votes (
  id uuid primary key default gen_random_uuid(),
  decision_id uuid not null references public.board_decisions(id) on delete cascade,
  voter_id uuid not null references public.profiles(id),
  choice board_vote_choice not null,
  cast_at timestamptz not null default now(),
  unique (decision_id, voter_id)
);

grant select on public.board_decisions to authenticated;
grant select on public.board_decision_votes to authenticated;

-- any verified building member can see board decisions (transparency),
-- but only board members can propose/vote (enforced in the RPCs below).
create policy "board_decisions: building members can view" on public.board_decisions
  for select using (public.is_verified_member_of(building_id));

create policy "board_decision_votes: building members can view" on public.board_decision_votes
  for select using (
    exists (
      select 1 from public.board_decisions d
      where d.id = board_decision_votes.decision_id and public.is_verified_member_of(d.building_id)
    )
  );

create or replace function public.propose_board_decision(
  p_title text,
  p_description text,
  p_requires_unanimous boolean
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
    raise exception 'غير مصرح لك باقتراح قرار مجلس';
  end if;

  select count(*) into v_eligible from public.union_members
    where building_id = v_building_id and status = 'verified' and role in ('president', 'board_member');

  insert into public.board_decisions (building_id, proposed_by, title, description, requires_unanimous, eligible_voters)
  values (v_building_id, auth.uid(), p_title, p_description, p_requires_unanimous, v_eligible)
  returning id into v_id;

  return v_id;
end;
$$;

grant execute on function public.propose_board_decision(text, text, boolean) to authenticated;

create or replace function public.cast_board_vote(p_decision_id uuid, p_choice text) returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_decision record;
  v_is_authorized boolean;
  v_approve_count int;
  v_reject_count int;
begin
  if auth.uid() is null then
    raise exception 'يجب تسجيل الدخول أولاً';
  end if;
  if p_choice not in ('approve', 'reject') then
    raise exception 'قيمة تصويت غير صحيحة';
  end if;

  select * into v_decision from public.board_decisions where id = p_decision_id for update;
  if not found then
    raise exception 'القرار غير موجود';
  end if;
  if v_decision.status <> 'open' then
    raise exception 'تم إغلاق التصويت على هذا القرار بالفعل';
  end if;

  select exists(
    select 1 from public.union_members m
    where m.building_id = v_decision.building_id and m.user_id = auth.uid()
      and m.status = 'verified' and m.role in ('president', 'board_member')
  ) into v_is_authorized;

  if not v_is_authorized then
    raise exception 'غير مصرح لك بالتصويت على قرارات هذا المجلس';
  end if;

  insert into public.board_decision_votes (decision_id, voter_id, choice)
  values (p_decision_id, auth.uid(), p_choice::board_vote_choice)
  on conflict (decision_id, voter_id) do update set choice = excluded.choice, cast_at = now();

  select count(*) filter (where choice = 'approve'), count(*) filter (where choice = 'reject')
    into v_approve_count, v_reject_count
    from public.board_decision_votes where decision_id = p_decision_id;

  if v_decision.requires_unanimous then
    if v_reject_count >= 1 then
      update public.board_decisions set status = 'rejected', closed_at = now() where id = p_decision_id;
    elsif v_approve_count = v_decision.eligible_voters then
      update public.board_decisions set status = 'approved', closed_at = now() where id = p_decision_id;
    end if;
  else
    if v_approve_count * 2 > v_decision.eligible_voters then
      update public.board_decisions set status = 'approved', closed_at = now() where id = p_decision_id;
    elsif v_reject_count * 2 > v_decision.eligible_voters then
      update public.board_decisions set status = 'rejected', closed_at = now() where id = p_decision_id;
    end if;
  end if;
end;
$$;

grant execute on function public.cast_board_vote(uuid, text) to authenticated;
