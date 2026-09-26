// Local Supabase-like Postgres (PGlite) with the project's schema + all
// migrations applied, plus helpers to run SQL as a given signed-in user
// through the same role/RLS path PostgREST uses.
const fs = require('fs');
const path = require('path');
const { PGlite } = require('@electric-sql/pglite');
const { pgcrypto } = require('@electric-sql/pglite/contrib/pgcrypto');

const BACKEND = path.join(__dirname, '..');

const BOOTSTRAP = `
create role anon nologin;
create role authenticated nologin;
create role service_role nologin bypassrls;

create schema auth;
create table auth.users (
  id uuid primary key default gen_random_uuid(),
  email text,
  raw_user_meta_data jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);
create function auth.uid() returns uuid language sql stable as $$
  select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid
$$;
grant usage on schema auth to anon, authenticated;
grant execute on function auth.uid() to anon, authenticated;

create schema storage;
create table storage.buckets (id text primary key, name text, public boolean default false);
create table storage.objects (
  id uuid primary key default gen_random_uuid(),
  bucket_id text references storage.buckets(id),
  name text,
  owner uuid,
  created_at timestamptz default now()
);
alter table storage.objects enable row level security;
create function storage.foldername(name text) returns text[] language sql immutable as $$
  select string_to_array(name, '/')
$$;
grant usage on schema storage to anon, authenticated;
grant select, insert, delete on storage.objects to authenticated;

-- Supabase "Enable automatic RLS": every new public table gets RLS on.
create function public._auto_rls() returns event_trigger language plpgsql as $$
declare r record;
begin
  for r in select * from pg_event_trigger_ddl_commands() where command_tag in ('CREATE TABLE', 'CREATE TABLE AS') loop
    if r.schema_name = 'public' then
      execute format('alter table %s enable row level security', r.object_identity);
    end if;
  end loop;
end $$;
create event trigger _auto_rls on ddl_command_end execute function public._auto_rls();
`;

async function createDb() {
  const db = new PGlite({ extensions: { pgcrypto } });
  await db.exec(BOOTSTRAP);
  const files = ['schema.sql', ...fs.readdirSync(path.join(BACKEND, 'migrations')).filter((f) => f.endsWith('.sql')).sort().map((f) => 'migrations/' + f)];
  for (const f of files) {
    const sql = fs.readFileSync(path.join(BACKEND, f), 'utf8');
    try {
      await db.exec(sql);
    } catch (e) {
      throw new Error(`Applying ${f} failed: ${e.message}`);
    }
  }
  return db;
}

// Create an auth user (like Supabase Auth sign-up; the 0037 trigger
// makes their profile + wallet).
async function signUp(db, name, phone) {
  const r = await db.query(
    `insert into auth.users (email, raw_user_meta_data) values ($1, $2) returning id`,
    [`${name}@test.local`, JSON.stringify({ full_name: name, phone })]
  );
  return r.rows[0].id;
}

// Run one statement as a signed-in user (role authenticated + jwt sub),
// exactly like a PostgREST request. Returns { rows } or { error }.
async function as(db, userId, sql, params = []) {
  await db.exec('begin');
  try {
    await db.query(`select set_config('request.jwt.claim.sub', $1, true)`, [userId ?? '']);
    await db.exec(`set local role ${userId ? 'authenticated' : 'anon'}`);
    const r = await db.query(sql, params);
    await db.exec('commit');
    return { rows: r.rows, affected: r.affectedRows };
  } catch (e) {
    await db.exec('rollback');
    return { error: e.message };
  }
}

// Run as postgres (SQL editor / service).
async function admin(db, sql, params = []) {
  const r = await db.query(sql, params);
  return r.rows;
}

module.exports = { createDb, signUp, as, admin };
