# Architecture

This app is a native Salesforce professional summary: profile, experience,
certifications, skills and projects. Sample records live in `data/`.

Apex follows **Apex Enterprise Patterns** (Andrew Fawcett / fflib) for the
project object: trigger handler, domain, selector, plus a small `Application`
factory. The unmanaged `fflib-apex-common` package is **not** vendored.

## Layers

```
LWC githubRepos
  → GitHubReposController (@AuraEnabled)
    → GitHubService (callout gateway)
      → GitHub_Config__mdt
      → Named Credential GitHub_API → GitHub REST API

LWC portfolioHome
  → PortfolioHomeController
    → Application.selector() → SalesforceProjectSelector (published projects)

SalesforceProjectTrigger (before insert/update)
  → SalesforceProjectTriggerHandler
    → Application.domain() → SalesforceProjectDomain (publish rules)
```

## Why these splits

- **Selector** owns SOQL for the Home project cards.
- **Domain** owns record behaviour in the trigger (`addError`, `Published_Date__c`).
- **Handler** only routes Trigger context. One trigger per object.
- **Application** is the fflib-style factory so tests can stub selector/domain.
- **GitHubService** is a callout **gateway**, not a selector.
- **Validation Rule** owns Published URLs.

## Objects

| Object                  | Role                                                  |
| ----------------------- | ----------------------------------------------------- |
| `Salesforce_Project__c` | Case studies (problem, solution, architecture, links) |
| `About_Me__c`           | Profile                                               |
| `Experience__c`         | Roles                                                 |
| `Certification__c`      | Credentials                                           |
| `Skill__c`              | Skills by category                                    |
| `Contact_Info__c`       | Public contact (not the standard Contact object)      |
| `GitHub_Config__mdt`    | GitHub username and repo limit                        |

The Lightning app `Salesforce_Portfolio` uses App Page `Portfolio_Home` with LWCs `portfolioHome` and `githubRepos`, plus an embedded dashboard. Sample data is only this app’s own Published project.
