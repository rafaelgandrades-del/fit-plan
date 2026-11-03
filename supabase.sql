-- FitPlan Elite — rode este script no Supabase: SQL Editor > New query > Run.
-- ANTES de rodar, troque 'SEU_EMAIL@exemplo.com' pelo e-mail que você vai
-- usar para entrar no painel admin (admin.html).

create table if not exists public.consultas (
    id            bigint generated always as identity primary key,
    criado_em     timestamptz not null default now(),
    nome          text    not null check (char_length(nome) between 1 and 120),
    genero        text    not null check (genero in ('m', 'f')),
    peso          numeric not null check (peso between 20 and 400),
    altura        numeric not null check (altura between 80 and 260),
    idade         int     not null check (idade between 10 and 120),
    objetivo      text    not null check (objetivo in ('emagrecer', 'manter', 'ganhar')),
    restricao     text    not null check (restricao in ('nenhuma', 'vegano', 'lactose', 'gluten')),
    preferencias  text    check (char_length(preferencias) <= 1000),
    agenda        jsonb,
    kcal          int,
    proteina_g    int,
    carbo_g       int,
    consentimento boolean not null check (consentimento = true)
);

-- Segurança (RLS): sem isso, qualquer pessoa com a chave anon leria tudo.
alter table public.consultas enable row level security;

-- Visitantes do site (anônimos) podem APENAS inserir. Não leem, não editam, não apagam.
drop policy if exists "site pode inserir" on public.consultas;
create policy "site pode inserir" on public.consultas
    for insert to anon
    with check (true);

-- Só o seu e-mail, logado no admin.html, pode ler e apagar.
drop policy if exists "admin pode ler" on public.consultas;
create policy "admin pode ler" on public.consultas
    for select to authenticated
    using ((auth.jwt() ->> 'email') = 'SEU_EMAIL@exemplo.com');

drop policy if exists "admin pode apagar" on public.consultas;
create policy "admin pode apagar" on public.consultas
    for delete to authenticated
    using ((auth.jwt() ->> 'email') = 'SEU_EMAIL@exemplo.com');

grant insert on public.consultas to anon;
grant select, delete on public.consultas to authenticated;
