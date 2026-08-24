# Salesforce Portfolio App

<!-- CI badge: uncomment after pushing to GitHub and configuring the SFDX_AUTH_URL secret
![CI](https://github.com/USERNAME/salesforce-portfolio-app/actions/workflows/ci.yml/badge.svg)
-->

A native Salesforce application that showcases my professional portfolio —
projects, experience, certifications and skills — built entirely on the
Salesforce Platform with custom objects, Flows, Apex, LWC and a live REST
integration with the GitHub API.

<!-- Hero GIF goes here (docs/img/home.gif) -->

## Demo

- 🎥 Video walkthrough: _coming soon_
- 📸 Screenshots: [docs/img](docs/img)

## Features

| Feature | Technology |
|---|---|
| Portfolio data model (Projects, Experience, Certifications, Skills, About Me, Contact Info) | 6 custom objects, validation rules |
| Custom Lightning app with dashboard home page | Lightning App Builder, Reports & Dashboards |
| Live GitHub repositories widget | LWC + Apex callout + Named Credential + Custom Metadata |
| Project publication lifecycle | Record-Triggered Flow + Apex trigger (handler pattern) |
| Guided project creation | Screen Flow |
| Quality gate | Apex tests with 90%+ coverage, CI via GitHub Actions |

## Architecture

```
LWC (githubRepos) ──> Apex Controller ──> GitHubService ──> Named Credential ──> GitHub REST API
Flows / Trigger ──> Custom Objects ──> Reports ──> Dashboard
```

Configuration (GitHub username, repo limit) lives in the
`GitHub_Config__mdt` Custom Metadata Type — no hardcoded values.

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

The whole app deploys to a fresh org in minutes.

## Tests

```bash
sf apex run test --code-coverage --result-format human --target-org portfolio-app
```

<!-- Coverage screenshot goes here (docs/img/coverage.png) -->

## Project docs

- [Full project plan (PT-BR)](docs/PLANEJAMENTO.md)

## Author

**Rodrigo Moreira** — Salesforce Developer
[LinkedIn](https://www.linkedin.com/in/rodmoreira1312/) ·
[Trailhead](https://www.salesforce.com/trailblazer/rodmoreira)
