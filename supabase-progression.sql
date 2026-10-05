-- Le Cabinet des Énigmes : progression enregistrée sur le compte du joueur.
-- À exécuter une fois dans Supabase : SQL Editor > New query > coller > Run.

create table if not exists public.progression (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.progression enable row level security;

-- Chaque joueur ne voit et ne modifie que sa propre ligne.
drop policy if exists "progression_lire"     on public.progression;
drop policy if exists "progression_creer"    on public.progression;
drop policy if exists "progression_modifier" on public.progression;
drop policy if exists "progression_effacer"  on public.progression;

create policy "progression_lire"     on public.progression for select to authenticated using (auth.uid() = user_id);
create policy "progression_creer"    on public.progression for insert to authenticated with check (auth.uid() = user_id);
create policy "progression_modifier" on public.progression for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "progression_effacer"  on public.progression for delete to authenticated using (auth.uid() = user_id);

revoke all on public.progression from anon;
grant select, insert, update, delete on public.progression to authenticated;
