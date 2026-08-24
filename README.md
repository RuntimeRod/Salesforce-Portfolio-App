# Salesforce Portfolio App

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml/badge.svg)](https://github.com/RuntimeRod/salesforce-portfolio-app/actions/workflows/ci.yml)

A native Salesforce application that showcases a professional portfolio —
projects, experience, certifications and skills — built on the Salesforce
Platform with custom objects, Flows, Apex Enterprise Patterns (fflib-style
selector / domain / service), LWC and a live REST integration with the GitHub API.

Agentforce is **not** in this package. Apex invocables are ready for it;
see [docs/AGENTFORCE.md](docs/AGENTFORCE.md).

<!-- Hero GIF goes here (docs/img/home.gif) -->

## Demo

- 🎥 Video walkthrough: _coming soon_ (record after Agentforce, see the Agentforce guide)
- 📸 Screenshots: [docs/img](docs/img)

## Features

| Feature                  | Technology                                                                        |
| ------------------------ | --------------------------------------------------------------------------------- |
| Portfolio data model     | 6 custom objects, validation rules, Lightning app                                 |
| Publication rules        | Validation Rule (links) + domain in before trigger (description + published date) |
| LinkedIn follow-up task  | Record-Triggered Flow                                                             |
| Guided create            | Screen Flow `New Project Wizard`                                                  |
| Live GitHub widget       | LWC `githubRepos` + Apex callout + Named Credential + Custom Metadata             |
| Agentforce-ready actions | `PortfolioProjectInvocable`, `GitHubReposInvocable`                               |
| Quality gate             | Apex tests (callout mocks, bulk 200) + GitHub Actions                             |

## Architecture

```
LWC (githubRepos) ──> Controller ──> GitHubService ──> Named Credential ──> GitHub REST API
Trigger ──> Handler ──> Domain          (record rules)
Invocable ──> Service ──> Selector      (SOQL)
```

GitHub username and repo limit live in `GitHub_Config__mdt` (record `Default`).
Change `Username__c` from `RuntimeRod` only if your GitHub user changes.

Full notes: [docs/architecture.md](docs/architecture.md).

## Getting started

Prerequisites: [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli),
a Developer Edition org.

```bash
# authenticate your org (once)
sf org login web --alias portfolio-app

# deploy everything, assign permissions, import sample data, run tests
./scripts/deploy.sh portfolio-app

# open the org
sf org open --target-org portfolio-app
```

The app deploys to a fresh org in minutes. Assign permission set
`Portfolio_Admin` if you skip the script.

## Tests

```bash
sf apex run test --code-coverage --result-format human --target-org portfolio-app
npm run test:unit
```

<!-- Coverage screenshot goes here (docs/img/coverage.png) -->

## GitHub Actions (CI)

Org validation uses a **repository secret**, never a file in git.

After the GitHub repo exists:

1. Locally: `sf org display --verbose --target-org portfolio-app`
2. Copy the **Sfdx Auth Url** value (`force://…`)
3. GitHub: **Settings → Secrets and variables → Actions → New repository secret**
4. Name: `SFDX_AUTH_URL` — paste the URL

Until that secret is set, CI checks out the code and **skips** org validation so the first push does not fail. Do not put the URL in README, `.env`, or `auth-url.txt`.

## Project docs

- [Architecture](docs/architecture.md)
- [Agentforce — how and when](docs/AGENTFORCE.md)
- [Full project plan (PT-BR)](docs/PLANEJAMENTO.md)

## Author

**Rodrigo Moreira** — Salesforce Developer
[LinkedIn](https://www.linkedin.com/in/rodmoreira1312/) ·
[GitHub](https://github.com/RuntimeRod) ·
[Trailhead](https://www.salesforce.com/trailblazer/rodmoreira)
