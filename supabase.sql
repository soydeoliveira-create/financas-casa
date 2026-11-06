-- Finanças da casa: uma linha por conta, com todos os dados em JSON.
-- Só o dono lê e altera a própria linha. Visitante sem login não acessa nada.
create table public.financas (
  dono uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  dados jsonb not null,
  versao integer not null default 1,
  atualizado_em timestamptz not null default now()
);

alter table public.financas enable row level security;

revoke all on public.financas from anon, public;
grant select, insert, update on public.financas to authenticated;

create policy "cada um com o seu" on public.financas
  for all to authenticated
  using (dono = (select auth.uid()))
  with check (dono = (select auth.uid()));
