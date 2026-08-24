# Architecture

This app is a native Salesforce portfolio. Configuration is metadata; sample records live in `data/`. Agentforce is **not** packaged here — see [AGENTFORCE.md](AGENTFORCE.md).

Apex follows **Apex Enterprise Patterns** (Andrew Fawcett / fflib): trigger handler, domain, selector, service, plus a small `Application` factory. The unmanaged `fflib-apex-common` package is **not** vendored — the layers are implemented in this repo so a Developer Edition deploys without extra packages.

## Layers

```
LWC githubRepos
  → GitHubReposController (@AuraEnabled)
    → GitHubService (callout gateway)
      → GitHub_Config__mdt
      → Named Credential GitHub_API → GitHub REST API

Screen Flow New Project Wizard → Salesforce_Project__c (Draft / In Progress)

Record-Triggered Flow Publish Project Task → Task
  only when Status becomes Published

SalesforceProjectTrigger (before insert/update)
  → SalesforceProjectTriggerHandler
    → Application.domain() → SalesforceProjectDomain (publish rules)

PortfolioProjectInvocable
  → SalesforceProjectService
    → Application.selector() → SalesforceProjectSelector (SOQL)

GitHubReposInvocable → GitHubService
```

## Why these splits

- **Selector** owns SOQL. If a second caller needs projects, it does not copy a query.
- **Domain** owns record behaviour in the trigger (`addError`, `Published_Date__c`). No SOQL there.
- **Service** orchestrates for LWC/Flow/Agentforce (get + summarize). No trigger rules there.
- **Handler** only routes Trigger context. One trigger per object (PD I).
- **Application** is the fflib-style factory so tests can stub selector/domain.
- **GitHubService** is a callout **gateway**, not a selector (selectors are SOQL).
- **Validation Rule** still owns Published URLs (declarative where it is enough).
- **Flow** only creates the LinkedIn Task.

## Objects

| Object                  | Role                                                  |
| ----------------------- | ----------------------------------------------------- |
| `Salesforce_Project__c` | Case studies (problem, solution, architecture, links) |
| `About_Me__c`           | Profile                                               |
| `Experience__c`         | Roles                                                 |
| `Certification__c`      | Credentials                                           |
| `Skill__c`              | Skills by category                                    |
| `Contact_Info__c`       | Public contact (not the standard Contact object)      |
| `GitHub_Config__mdt`    | Integration config                                    |

The Lightning app `Salesforce_Portfolio` uses App Page `Portfolio_Home` with LWCs `portfolioHome` and `githubRepos`, plus an embedded dashboard. Sample data in `data/` is only this app’s own Published project — do not load named client case studies. Each custom object has a page layout and a Lightning record page.
