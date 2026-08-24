# Salesforce Portfolio App

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml/badge.svg)](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml)

Este App Salesforce funciona como portfólio profissional:
projetos, experiência, certificações e skills. O modelo é metadata (objetos
customizados, app Lightning, Flows). A lógica de negócio está em Apex com
padrões enterprise (fflib-style: selector / domain / service). A Home mostra
um LWC com repositórios reais da API do GitHub.

<!-- Hero GIF goes here (docs/img/home.gif) -->

## Demo

- 🎥 Vídeo: _em breve_

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


## Arquitetura

```
LWC (githubRepos) ──> Controller ──> GitHubService ──> Named Credential ──> GitHub REST API
Trigger ──> Handler ──> Domain          (regras do registro)
Invocable ──> Service ──> Selector      (SOQL)
```

## Autor

**Rodrigo Moreira** — Salesforce Developer
[LinkedIn](https://www.linkedin.com/in/rodmoreira1312/) ·
[GitHub](https://github.com/RuntimeRod) ·
[Trailhead](https://www.salesforce.com/trailblazer/rodmoreira)
