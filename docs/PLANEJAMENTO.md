# Planejamento Completo — Salesforce Portfolio App

> Projeto pessoal para portfólio de Rodrigo Moreira.
> Base: tutorial "Projeto_Portfólio.pdf" (Fase 1, declarativa) + extensões de
> desenvolvimento (Fase 2) que sustentam as alegações do currículo
> (Apex, LWC, REST, Flows, Custom Metadata, testes >90%, Salesforce CLI + Git).

---

## 1. Objetivo estratégico

O projeto existe para provar, com evidência pública e demonstrável, cada linha do
currículo:

| Alegação no currículo                | Prova no projeto                                          |
| ------------------------------------ | --------------------------------------------------------- |
| Apex                                 | Classes de serviço, trigger, callout REST                 |
| LWC                                  | Componente `githubRepos` consumindo API real              |
| Flow Builder                         | Record-Triggered Flow + Screen Flow                       |
| Custom Metadata Types                | Configuração do endpoint GitHub em CMT                    |
| Integrações REST (Named Credentials) | Callout à API pública do GitHub                           |
| Testes com cobertura >90%            | Suite de testes com `HttpCalloutMock`, print do resultado |
| Salesforce CLI, Git, VS Code         | Repositório SFDX + CI no GitHub Actions                   |
| Reports/dashboards                   | Dashboard do portfólio (Fase 1)                           |

Regra de ouro: **o artefato durável é o repositório + vídeo + prints, não a org.**
Se a org expirar, tudo se redeploya com um comando (isso vira argumento de venda).

---

## 2. Escopo por fases

### Fase 1 — Base declarativa (seguir o PDF, ~6-8h)

Exatamente o tutorial, com estas correções/melhorias:

1. **NÃO nomear o objeto de contato como "Contact"** — conflita com o objeto
   standard. Usar Label `Contact Info` / API `Contact_Info__c`.
2. Org em inglês (facilita prints universais e segue o tutorial).
3. Objetos: `Salesforce_Project__c`, `About_Me__c`, `Experience__c`,
   `Certification__c`, `Skill__c`, `Contact_Info__c` — com os campos do PDF.
4. App "Salesforce Portfolio" + tabs + Home Page (Lightning App Builder,
   template Header and Three Regions).
5. Reports (5) na pasta `Portfolio Reports` + Dashboard `Salesforce Portfolio
Dashboard` (métricas: Total Projects/Certifications/Skills; gráficos:
   Projects by Status, by Cloud, Certifications by Status, Skills by Category;
   tabela: Professional Experience).
6. Preencher com dados reais: 3 projetos profissionais (Unisanta, Real
   Grandeza, Micromed — descritos sem dados confidenciais do cliente),
   certificação PD I, skills do currículo, experiência Dantas + freelancer.

### Fase 2 — Extensões de desenvolvimento (o diferencial, ~10-15h)

**2.1 Integração REST — LWC `githubRepos` + Apex callout**

- Named Credential `GitHub_API` → `https://api.github.com` (sem auth; API pública).
- Custom Metadata Type `GitHub_Config__mdt` com campos `Username__c` e
  `Max_Repos__c` (prova CMT como configuração, igual ao que fez na Unisanta).
- Classe `GitHubService.cls`: callout GET `/users/{username}/repos`,
  parse JSON em wrapper tipado, tratamento de erro.
- Classe `GitHubReposController.cls`: `@AuraEnabled(cacheable=true)`.
- LWC `githubRepos`: lista cards com nome do repo, descrição, linguagem,
  estrelas e link — colocado na Home Page do app.
- Resultado: a home do portfólio mostra os repositórios reais do seu GitHub,
  ao vivo. Integração de verdade, demonstrável em vídeo.

**2.2 Automação — Flows**

- **Record-Triggered Flow** em `Salesforce_Project__c`: quando `Status__c`
  muda para `Published`, cria uma Task "Divulgar projeto no LinkedIn" e
  valida que `GitHub_Repository__c` e `Demo_URL__c` estão preenchidos
  (com Validation Rule de apoio).
- **Screen Flow** "New Project Wizard": passos guiados para cadastrar projeto
  (dados básicos → problema/solução → links), exposto como botão na tab.

**2.3 Apex Enterprise Patterns (fflib-style)**

- Trigger `SalesforceProjectTrigger` → `SalesforceProjectTriggerHandler` →
  `Application.domain()` → `SalesforceProjectDomain` (descrição + Published Date).
- SOQL em `SalesforceProjectSelector`; orquestração em `SalesforceProjectService`.
- Factory `Application` (sem pacote unmanaged fflib-apex-common).
- Callout GitHub em `GitHubService` (gateway; selector é só SOQL).

**2.4 Testes (>90%)**

- `GitHubServiceTest` com `HttpCalloutMock` (sucesso, erro 404, JSON inválido).
- `SalesforceProjectTriggerHandlerTest` (bulk 200 registros, cenários
  positivo/negativo).
- Meta: >90% em todas as classes. Print do resultado
  (`sf apex run test --code-coverage`) vai para o README.

**2.5 DevOps**

- Projeto no formato **SFDX** (source format) desde o primeiro commit.
- **GitHub Actions** (`.github/workflows/ci.yml`): a cada push/PR, roda
  `sf project deploy validate` + testes contra a org (auth via
  `SFDX_AUTH_URL` em secret). Badge de status no README.
- Script `scripts/deploy.sh` para subir tudo em org nova em minutos
  (o antídoto para org expirada).

**2.6 Apex invocável (gancho Agentforce)**

- `PortfolioProjectInvocable` e `GitHubReposInvocable` reutilizam os serviços.
- Não inclui metadata de Agentforce neste pacote.

### Fase 3 — Apresentação (detalhada nas seções 4-7)

### Fase 4 — Agentforce (você; ver `docs/AGENTFORCE.md`)

---

## 3. Repositório GitHub — o que versiona e o que não

**Nome sugerido:** `salesforce-portfolio-app`

```
salesforce-portfolio-app/
├── README.md                  ← landing page do projeto (seção 4)
├── LICENSE                    ← MIT
├── .gitignore                 ← padrão SFDX (.sfdx, .sf, etc.)
├── sfdx-project.json
├── config/project-scratch-def.json   (opcional, se usar scratch orgs)
├── scripts/
│   ├── deploy.sh              ← auth + deploy + assign permset + import data
│   └── export-data.sh         ← sf data tree export dos registros de exemplo
├── data/                      ← registros de exemplo (JSON do data tree)
│   ├── Salesforce_Project__c.json
│   ├── Skill__c.json
│   └── ...
├── docs/
│   ├── architecture.md        ← diagrama + decisões
│   └── img/                   ← prints usados no README
├── .github/workflows/ci.yml
└── force-app/main/default/
    ├── applications/          ← Salesforce_Portfolio.app-meta.xml
    ├── objects/               ← todos os objetos + campos + validation rules
    ├── tabs/
    ├── flexipages/            ← Portfolio_Home.flexipage-meta.xml
    ├── flows/                 ← os 2 Flows
    ├── classes/               ← GitHubService, controller, handler + testes
    ├── triggers/
    ├── lwc/githubRepos/
    ├── customMetadata/        ← GitHub_Config.md-meta.xml (registro)
    ├── namedCredentials/
    ├── permissionsets/        ← Portfolio_Admin.permissionset-meta.xml
    ├── reports/  + reportFolders/
    └── dashboards/ + dashboardFolders/
```

**Versiona:** todo o metadata acima — inclusive reports, dashboards e a
flexipage (são recuperáveis via `sf project retrieve start`).

**NÃO versiona:**

- Dados de registros com informação pessoal sensível (telefone → usar
  placeholder nos JSONs de `data/`).
- Credenciais, auth files, `.sfdx/`, `.sf/`.
- Profiles (usar Permission Set `Portfolio_Admin` — mais limpo e portátil).

**Higiene de Git que vira vitrine:**

- Conventional Commits (`feat:`, `fix:`, `test:`, `docs:`).
- Branches `feature/*` + Pull Requests para `main` (mesmo sozinho — o
  histórico de PRs bem descritos é evidência de fluxo profissional).
- Releases taggeadas: `v1.0-declarative` (fim da Fase 1), `v2.0-dev-features`.

---

## 4. README (a landing page do projeto)

Ordem das seções:

1. **Título + badges** (CI status, coverage, licença).
2. **GIF de 10-15s** da home do app (primeira coisa que o recrutador vê).
3. **O que é** — 3 linhas.
4. **Demo** — link do vídeo YouTube + link de prints.
5. **Arquitetura** — diagrama (Mermaid ou draw.io exportado):
   `LWC → Apex Controller → GitHubService → Named Credential → GitHub API`
   e `Flows/Trigger → Objects → Reports → Dashboard`.
6. **Features** — tabela feature × tecnologia.
7. **Como rodar** — pré-requisitos (sf CLI), `scripts/deploy.sh`, tempo estimado
   ("suba em uma org nova em ~10 minutos").
8. **Testes** — comando + print da cobertura.
9. **Decisões técnicas** — por que CMT para config, por que permission set,
   por que trigger handler pattern (mostra que você pensa, não só executa).
10. **Autor** — links LinkedIn, Trailhead, currículo.

README em **inglês** (audiência técnica global); vídeo pode ser em português
com legendas/versão EN se mirar vagas internacionais.

---

## 5. Prints — lista exata do que fotografar

Guardar em `docs/img/` (usados no README) e no portfólio. Sempre em tela
cheia, org em inglês, dados reais cadastrados, zoom 100%:

| #   | Print                                                 | Onde usa                     |
| --- | ----------------------------------------------------- | ---------------------------- |
| 1   | Home Page completa do app (hero shot)                 | README topo + LinkedIn       |
| 2   | Dashboard com os 8 widgets preenchidos                | README + currículo/portfólio |
| 3   | Record page de um projeto real (Unisanta) preenchido  | README                       |
| 4   | LWC `githubRepos` renderizado na home com repos reais | README (seção integração)    |
| 5   | Canvas do Record-Triggered Flow no Flow Builder       | README (seção automação)     |
| 6   | Screen Flow em execução (wizard, passo 2)             | README                       |
| 7   | Terminal: `sf apex run test --code-coverage` com >90% | README (seção testes)        |
| 8   | GitHub Actions com pipeline verde                     | README (seção CI)            |
| 9   | Estrutura do projeto no VS Code (árvore force-app)    | README (seção como rodar)    |
| 10  | App Launcher mostrando o app instalado                | reserva                      |

GIF animado (ScreenToGif/LICEcap): navegação home → projeto → dashboard, 10-15s.

---

## 6. Vídeo de demo — roteiro cena a cena (alvo: 3 min)

Ferramentas: OBS Studio (1080p, 30fps), microfone a 10-15cm, org em inglês,
navegação ensaiada 2x antes de gravar. Hospedar no YouTube (unlisted ou
público) e linkar no README, currículo e LinkedIn.

| Tempo     | Cena                | O que mostrar                                                                                                 | O que falar                                                                                                                                                                 |
| --------- | ------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0:00–0:15 | Abertura            | Home do app já aberta                                                                                         | "Sou Rodrigo, dev Salesforce. Este é meu portfólio construído como app nativo na plataforma — objetos, automação, código e integração real."                                |
| 0:15–0:45 | Tour declarativo    | Tabs: About Me → Experience → Certifications; abrir o registro do projeto Unisanta                            | "Modelei 6 objetos customizados para representar o portfólio; cada projeto documenta problema de negócio, solução e arquitetura."                                           |
| 0:45–1:15 | Dashboard           | Dashboard completo, apontar métricas                                                                          | "Reports agrupados alimentam o dashboard — a mesma estrutura de relatórios que entrego em projetos de clientes."                                                            |
| 1:15–1:50 | Integração (clímax) | Home → LWC githubRepos; clicar num repo e abrir o GitHub                                                      | "Este componente LWC consome a API do GitHub via Apex com Named Credential; o endpoint e os parâmetros ficam em Custom Metadata — mostra integração REST de ponta a ponta." |
| 1:50–2:20 | Automação           | Mudar Status de um projeto para Published; mostrar a Task criada e a validação bloqueando publicação sem link | "Um Record-Triggered Flow e um trigger Apex controlam o ciclo de publicação."                                                                                               |
| 2:20–2:50 | Código + DevOps     | VS Code: árvore SFDX, classe de teste; terminal rodando testes com >90%; aba do GitHub Actions verde          | "Tudo versionado em formato SFDX com CI no GitHub Actions — o projeto inteiro sobe numa org nova com um script, em minutos."                                                |
| 2:50–3:00 | Fechamento          | README na tela                                                                                                | "Código, prints e instruções no repositório — link na descrição. Obrigado!"                                                                                                 |

Regras: nunca passar de 4 min; sem música de fundo alta; cortar pausas na
edição (CapCut/DaVinci gratuitos); primeiro take é ensaio.

---

## 7. Divulgação e amarração com o currículo

1. **Cabeçalho do currículo** ganha: `LinkedIn | GitHub | Trailhead`
   (GitHub apontando para o perfil, com o repo fixado/pinned).
2. **Seção Projetos no currículo** (troca já planejada: freelancer comprime
   para 1 bullet). Bullet XYZ pronto:
   - PT: "Construí aplicativo de portfólio nativo em Salesforce com 6 objetos
     customizados, LWC integrado à API do GitHub (Apex + Named Credentials),
     Flows de publicação e cobertura de testes acima de 90%, com CI/CD via
     GitHub Actions — código público no GitHub."
   - EN: "Built a native Salesforce portfolio app with 6 custom objects, an
     LWC integrated with the GitHub API (Apex + Named Credentials),
     publication Flows and 90%+ test coverage, with CI/CD via GitHub Actions —
     public source on GitHub."
3. **Post no LinkedIn** no lançamento: GIF + 3 parágrafos (por que fiz, o que
   tem dentro, link do repo e vídeo). Marcar #Salesforce #Trailblazer.
4. **Dogfooding**: cadastrar o próprio Portfolio App como registro de
   `Salesforce Project` dentro dele mesmo, status Published.
5. **Trailhead**: manter badges relacionados visíveis no perfil linkado.

---

## 8. Cronograma sugerido

| Semana | Entrega                                                                                                      |
| ------ | ------------------------------------------------------------------------------------------------------------ |
| 1      | Fase 1 completa (app declarativo + dados reais) + repo SFDX inicial com retrieve do metadata + primeiro push |
| 2      | GitHubService + LWC + CMT + Named Credential funcionando                                                     |
| 3      | Flows + trigger/handler + testes >90% + CI verde                                                             |
| 4      | Prints, GIF, vídeo, README final, release v1.0, post LinkedIn, atualização do currículo                      |

Manutenção: logar na Developer Edition ao menos 1x/mês (orgs DE expiram por
inatividade prolongada, não por prazo fixo).

---

## 9. Riscos e cuidados

- **Conflito de nome "Contact"**: usar `Contact_Info__c` (correção sobre o PDF).
- **Dados pessoais**: telefone/e-mail nos registros de exemplo do repo →
  placeholders; no app da org pode usar dados reais (a org não é pública).
- **Descrições dos projetos de clientes**: sem números internos nem dados
  confidenciais — descrever solução técnica genérica, como já está no currículo.
- **API do GitHub sem auth**: limite de 60 requisições/hora por IP — suficiente
  para demo; tratar erro 403 no Apex com mensagem amigável (vira caso de teste).
- **Agentforce**: **Fase 4, feita por você**, fora do `force-app` principal.
  Os ganchos Apex já existem (`PortfolioProjectInvocable`,
  `GitHubReposInvocable`). Siga `docs/AGENTFORCE.md`: só depois da Fase 2
  verde, numa DE com Agentforce, **antes** de prints/vídeo/CV. Não versionar
  metadata GenAI no pacote padrão (quebra o deploy em org sem licença).
