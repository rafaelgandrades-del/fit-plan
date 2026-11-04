-- FitPlan Elite — Código de acesso do cliente
-- Rode no Supabase: SQL Editor > New query > cole tudo > Run.
-- Pode rodar mais de uma vez sem problema. Não apaga nenhum dado.

-- 1) Novas colunas: o código do cliente e os dados completos do formulário
--    (inclui rotina semanal e "rotina diária", para reabrir o plano igualzinho).
alter table public.consultas add column if not exists codigo text
    check (codigo is null or codigo ~ '^FIT-[A-Z0-9]{4}-[A-Z0-9]{4}$');
alter table public.consultas add column if not exists dados jsonb;

create index if not exists consultas_codigo_idx on public.consultas (codigo);

-- 2) Função que devolve as consultas de UM código.
--    O site (anônimo) continua sem poder listar a tabela: só consegue
--    buscar quando sabe o código exato, e recebe no máximo 10 consultas.
create or replace function public.buscar_consultas(p_codigo text)
returns table (criado_em timestamptz, peso numeric, kcal int, dados jsonb)
language sql
security definer
set search_path = public
as $$
    select c.criado_em, c.peso, c.kcal, c.dados
    from public.consultas c
    where c.codigo = upper(trim(p_codigo))
      and c.dados is not null
    order by c.criado_em desc
    limit 10;
$$;

revoke all on function public.buscar_consultas(text) from public;
grant execute on function public.buscar_consultas(text) to anon, authenticated;
