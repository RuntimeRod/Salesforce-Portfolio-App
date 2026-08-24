# Salesforce Portfolio App

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml/badge.svg)](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml)

App nativo na Salesforce Platform que funciona como portfólio profissional:
projetos, experiência, certificações e skills. O modelo é metadata (objetos
customizados, app Lightning, Flows). A lógica de negócio está em Apex com
padrões enterprise (fflib-style: selector / domain / service). A Home mostra
um LWC com repositórios reais da API do GitHub.

**Agentforce não entra neste pacote** — metadata de agente quebra o deploy numa
Developer Edition comum. Os invocáveis Apex já estão prontos para o agente;
o passo a passo está em [docs/AGENTFORCE.md](docs/AGENTFORCE.md).

<!-- Hero GIF goes here (docs/img/home.gif) -->

## Demo

- 🎥 Vídeo: _em breve_ (gravar **depois** do Agentforce, ver o guia)
- 📸 Prints: [docs/img](docs/img)

## O que o app faz

| Funcionalidade        | Tecnologia                                                            |
| --------------------- | --------------------------------------------------------------------- |
| Modelo de portfólio   | 6 objetos customizados, validation rules, app Lightning               |
| Regras de publicação  | Validation Rule (links) + domain no before trigger (descrição + data) |
| Follow-up no LinkedIn | Record-Triggered Flow cria Task ao publicar                           |
| Cadastro guiado       | Screen Flow `New Project Wizard`                                      |
| Widget GitHub ao vivo | LWC `githubRepos` + callout Apex + Named Credential + CMT             |
| Ações para Agentforce | `PortfolioProjectInvocable`, `GitHubReposInvocable`                   |
| Qualidade             | Testes Apex (mock de callout, bulk 200) + GitHub Actions              |

Objetos: `Salesforce_Project__c`, `About_Me__c`, `Experience__c`,
`Certification__c`, `Skill__c` e `Contact_Info__c` (não é o Contact padrão).
Config da integração: `GitHub_Config__mdt`.

## LWC

O componente `githubRepos` fica só na App Page `Portfolio_Home` (não nas record
pages). Ele chama `GitHubReposController.getRepos` via `@wire` e trata
loading, vazio e erro (toast). Não há regra de negócio no browser: o Apex
faz o callout.

O username e o limite de repos vêm de `GitHub_Config__mdt` (registro
`Default`). O host da API é o Named Credential `GitHub_API`
(`https://api.github.com`, sem autenticação — só repos públicos).
Altere `Username__c` de `RuntimeRod` só se o usuário do GitHub mudar.

Há teste Jest em `force-app/main/default/lwc/githubRepos/__tests__/`.

## Apex

As camadas seguem **Apex Enterprise Patterns** (Andrew Fawcett / fflib):
handler, domain, selector, service e uma factory `Application`. O pacote
unmanaged `fflib-apex-common` **não** está no repositório — as classes estão
neste app para uma Developer Edition subir sem dependência extra.

- **Selector** (`SalesforceProjectSelector`) — SOQL de projetos. Quem precisa
  da query não copia a query.
- **Domain** (`SalesforceProjectDomain`) — regras no trigger: descrição
  obrigatória para publicar e carimbo de `Published_Date__c`. Sem SOQL aqui.
- **Service** (`SalesforceProjectService`) — orquestra para Flow / LWC /
  invocável (buscar + resumir). Sem regra de trigger aqui.
- **Handler** (`SalesforceProjectTriggerHandler`) — só roteia o contexto do
  trigger. Um trigger por objeto.
- **GitHubService** — gateway de callout (não é selector; selector é SOQL).
  Mock de HTTP nos testes (sucesso, 404, JSON inválido).

Os invocáveis são adaptadores finos: `PortfolioProjectInvocable` filtra
projetos por Cloud e/ou Status; `GitHubReposInvocable` devolve o mesmo
resumo de repos que o LWC usa.

## Agentforce

Este repo **não versiona** agente, tópicos nem prompt templates. Isso exige
org com Einstein/Agentforce e, se cair em `force-app`, o
`scripts/deploy.sh` falha numa DE sem licença.

O que já está no pacote (ganchos):

- `Get Portfolio Projects` → `PortfolioProjectInvocable` — ex.: “quais
  projetos usaram Experience Cloud?”
- `Get GitHub Repositories` → `GitHubReposInvocable` — ex.: “quais são
  meus repositórios públicos?”

Fazer o agente **depois** da Fase 2 verde (dados + LWC + testes Apex) e
**antes** de prints, vídeo e currículo. Guia completo:
[docs/AGENTFORCE.md](docs/AGENTFORCE.md). Ao recuperar metadata GenAI,
guardar fora de `force-app/main/default` (por exemplo `force-app-agentforce/`).

## Arquitetura

```
LWC (githubRepos) ──> Controller ──> GitHubService ──> Named Credential ──> GitHub REST API
Trigger ──> Handler ──> Domain          (regras do registro)
Invocable ──> Service ──> Selector      (SOQL)
```

Notas completas: [docs/architecture.md](docs/architecture.md).

## Como começar

Pré-requisitos: [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli)
e uma org Developer Edition.

```bash
# autenticar a org (uma vez)
sf org login web --alias portfolio-app

# deploy, permission set, dados de exemplo e testes
./scripts/deploy.sh portfolio-app

# abrir a org
sf org open --target-org portfolio-app
```

O app sobe em org nova em minutos. Se pular o script, atribua o permission
set `Portfolio_Admin`.

## Testes

```bash
sf apex run test --code-coverage --result-format human --target-org portfolio-app
npm run test:unit
```

<!-- Coverage screenshot goes here (docs/img/coverage.png) -->

## GitHub Actions (CI)

A validação na org usa um **secret do repositório**, nunca um arquivo no git.

Com o repo já no GitHub:

1. Local: `sf org display --verbose --target-org portfolio-app`
2. Copie o valor **Sfdx Auth Url** (`force://…`)
3. GitHub: **Settings → Secrets and variables → Actions → New repository secret**
4. Nome: `SFDX_AUTH_URL` — cole a URL

Enquanto o secret não existir, o CI só faz checkout e **pula** a validação
na org, para o primeiro push não falhar. Não coloque essa URL no README,
no `.env` nem em `auth-url.txt`.

## Documentação

- [Arquitetura](docs/architecture.md)
- [Agentforce — como e quando](docs/AGENTFORCE.md)
- [Planejamento completo](docs/PLANEJAMENTO.md)

## Autor

**Rodrigo Moreira** — Salesforce Developer
[LinkedIn](https://www.linkedin.com/in/rodmoreira1312/) ·
[GitHub](https://github.com/RuntimeRod) ·
[Trailhead](https://www.salesforce.com/trailblazer/rodmoreira)
