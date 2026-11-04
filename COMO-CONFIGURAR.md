# FitPlan Elite + Supabase — passo a passo

## Arquivos
| Arquivo | Para que serve |
|---|---|
| `index.html` | O site, agora salvando cada consulta no Supabase (com caixa de consentimento LGPD) |
| `admin.html` | Painel só seu: lista os clientes, busca, apaga e exporta CSV |
| `config.js` | Onde você cola a URL e a chave do Supabase |
| `supabase.sql` | Cria a tabela e as regras de segurança |

## 1. Criar o projeto no Supabase (≈5 min)
1. Entre em **supabase.com** → *Start your project* → crie uma conta grátis.
2. *New project* → dê um nome (ex: `fitplan`), crie uma senha do banco e escolha a região **South America (São Paulo)**.

## 2. Criar a tabela
1. Abra `supabase.sql` e troque **as duas** ocorrências de `SEU_EMAIL@exemplo.com` pelo e-mail que você vai usar no painel.
2. No Supabase: **SQL Editor** → *New query* → cole o conteúdo → **Run**.

## 3. Criar seu usuário admin
1. **Authentication → Users → Add user → Create new user**.
2. Use o **mesmo e-mail** do passo 2, defina uma senha e marque *Auto Confirm User*.
3. Recomendado: **Authentication → Sign In / Providers** → desligue *Allow new users to sign up*, assim ninguém mais cria conta.

## 4. Preencher o config.js
1. No Supabase: **Project Settings → API Keys** (ou botão *Connect*).
2. Copie a **Project URL** e a chave **anon / publishable** para o `config.js`.
3. ⚠️ Nunca use a chave `service_role` / `secret` — o arquivo fica público.

## 5. Atualizar o site no GitHub
O site já está publicado no repositório `rafaelgandrades-del/fit-plan`. Depois de preencher o `config.js`, edite-o direto no GitHub (abra o arquivo → ícone de lápis → cole a URL e a chave → *Commit changes*).

Depois de 1–2 minutos:
- Site dos clientes: `https://rafaelgandrades-del.github.io/fit-plan/`
- Seu painel: `https://rafaelgandrades-del.github.io/fit-plan/admin.html`

## 6. Código de acesso do cliente
Rode `supabase-codigo.sql` no SQL Editor (uma vez). A partir daí, cada cliente recebe um código `FIT-XXXX-XXXX` no plano e pode abrir suas consultas em qualquer aparelho pelo link **"Entrar com código"**. O código também aparece no painel admin, caso o cliente perca.

## Segurança, em resumo
- Visitantes do site **só conseguem inserir** consultas — não leem nem apagam nada.
- Só o seu e-mail logado no painel consegue **ver e apagar**.
- Se um cliente pedir exclusão dos dados (LGPD), apague pelo botão *Apagar* no painel.
