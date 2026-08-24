# Salesforce Portfolio App

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml/badge.svg)](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml)

App Salesforce: portfólio de projetos, experiências,
certificações e skills. Apex no padrão fflib-style (selector / domain /
service), LWC na Home (perfil, métricas, GitHub) e callout REST na API
do GitHub.

## O que tem no app

| Área       | Detalhe                                                       |
| ---------- | ------------------------------------------------------------- |
| Dados      | 6 objetos customizados + app Lightning `Salesforce_Portfolio` |
| Home       | LWC `portfolioHome` + `githubRepos` + dashboard embutido      |
| Publicação | Validation Rule, domain no trigger, Flow de Task no LinkedIn  |
| GitHub     | Named Credential `GitHub_API` + CMT `GitHub_Config__mdt`      |
| Qualidade  | Testes Apex (mock de callout, bulk) + Jest + GitHub Actions   |

## Como subir

```bash
sf org login web --alias portfolio-app
./scripts/deploy.sh portfolio-app
sf org open --target-org portfolio-app
```

Permission set: `Portfolio_Admin`. Username do GitHub: `GitHub_Config__mdt.Default`.


## Autor

**Rodrigo Moreira** — Salesforce Developer
[LinkedIn](https://www.linkedin.com/in/rodmoreira1312/) ·
[GitHub](https://github.com/RuntimeRod) ·
[Trailhead](https://www.salesforce.com/trailblazer/rodmoreira)
