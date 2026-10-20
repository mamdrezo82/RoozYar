-- Run this in Supabase Dashboard > SQL Editor for your RoozYar project.
create table if not exists public.roozyar_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.roozyar_user_data enable row level security;

-- Users may only read their own row.
drop policy if exists "Users can read own RoozYar data" on public.roozyar_user_data;
create policy "Users can read own RoozYar data"
  on public.roozyar_user_data for select
  to authenticated
  using (auth.uid() = user_id);

-- Users may only create their own row.
drop policy if exists "Users can insert own RoozYar data" on public.roozyar_user_data;
create policy "Users can insert own RoozYar data"
  on public.roozyar_user_data for insert
  to authenticated
  with check (auth.uid() = user_id);

-- Users may only update their own row.
drop policy if exists "Users can update own RoozYar data" on public.roozyar_user_data;
create policy "Users can update own RoozYar data"
  on public.roozyar_user_data for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- No anonymous access policies are created.
