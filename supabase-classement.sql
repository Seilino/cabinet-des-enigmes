-- Classement du Cabinet des Énigmes
-- À exécuter une seule fois dans Supabase : SQL Editor > New query > coller > Run

create extension if not exists pgcrypto with schema extensions;

create table if not exists public.leaderboard (
  id          uuid primary key default gen_random_uuid(),
  secret_hash text not null,
  name        text not null check (char_length(name) between 2 and 20),
  stars       int  not null default 0 check (stars   between 0 and 2000),
  levels      int  not null default 0 check (levels  between 0 and 600),
  drawers     int  not null default 0 check (drawers between 0 and 25),
  updated_at  timestamptz not null default now()
);
create unique index if not exists leaderboard_name_unique on public.leaderboard (lower(name));

-- Personne ne lit ni n'écrit la table directement : tout passe par les deux fonctions ci-dessous.
alter table public.leaderboard enable row level security;
revoke all on public.leaderboard from anon, authenticated;

-- Enregistrer ou mettre à jour son score (le secret reste dans le navigateur du joueur)
create or replace function public.lb_submit(
  p_id uuid, p_secret text, p_name text, p_stars int, p_levels int, p_drawers int)
returns uuid
language plpgsql security definer
set search_path = public, extensions
as $$
declare v_id uuid; v_name text := trim(p_name);
begin
  if char_length(v_name) < 2 or char_length(v_name) > 20 then raise exception 'nom invalide'; end if;
  if p_secret is null or char_length(p_secret) < 20 then raise exception 'secret invalide'; end if;
  if p_stars not between 0 and 2000 or p_levels not between 0 and 600 or p_drawers not between 0 and 25 then
    raise exception 'score invalide';
  end if;
  if p_id is null then
    insert into leaderboard (secret_hash, name, stars, levels, drawers)
    values (encode(digest(p_secret, 'sha256'), 'hex'), v_name, p_stars, p_levels, p_drawers)
    returning id into v_id;
    return v_id;
  end if;
  update leaderboard
     set name = v_name, stars = p_stars, levels = p_levels, drawers = p_drawers, updated_at = now()
   where id = p_id and secret_hash = encode(digest(p_secret, 'sha256'), 'hex')
  returning id into v_id;
  if v_id is null then raise exception 'joueur inconnu'; end if;
  return v_id;
end $$;

-- Lire le classement (les secrets ne sont jamais renvoyés)
create or replace function public.lb_top(p_limit int default 50)
returns table (id uuid, name text, stars int, levels int, drawers int, updated_at timestamptz)
language sql stable security definer
set search_path = public
as $$
  select id, name, stars, levels, drawers, updated_at
    from leaderboard
   order by stars desc, levels desc, updated_at asc
   limit least(greatest(coalesce(p_limit, 50), 1), 100);
$$;

revoke all on function public.lb_submit(uuid, text, text, int, int, int) from public;
revoke all on function public.lb_top(int) from public;
grant execute on function public.lb_submit(uuid, text, text, int, int, int) to anon, authenticated;
grant execute on function public.lb_top(int) to anon, authenticated;
