# Agentforce — how and when (you own this)

This repo **does not** include Agentforce metadata (agents, topics, prompt templates, bots). Those artifacts need an org with Einstein/Agentforce and they break `scripts/deploy.sh` on a plain Developer Edition.

The Apex hooks are already in the default package:

- `PortfolioProjectInvocable` (`Get Portfolio Projects`) — filter by Cloud and/or Status
- `GitHubReposInvocable` (`Get GitHub Repositories`) — same callout as the LWC

## When

Do this **after** Fase 2 is green in your org:

1. Custom objects and sample data are loaded.
2. LWC `githubRepos` renders real repos (set `GitHub_Config__mdt.Default.Username__c` to your GitHub user).
3. Invocable Apex tests pass (`sf apex run test --code-coverage`).

Do this **before** screenshots, the demo video, and sending the updated CV. A CV bullet about Agentforce without a working agent is a liability in interview.

## Org

Use a **Developer Edition (or Partner DE) with Agentforce enabled**. Do not rely on the generic scratch def in `config/project-scratch-def.json`.

Keep Agentforce metadata **out of** `force-app/main/default`. When you retrieve it, put it in a separate folder, for example `force-app-agentforce/`, and do **not** add that folder to the default packageDirectory until you have a dedicated Agentforce org for CI.

## What “strong” looks like (pleno, not a 5-minute toy)

Create an **Employee / internal agent** grounded on **this app’s records**, not generic Knowledge.

Minimum three topics:

1. **Projects** — action: `Get Portfolio Projects`. Sample: “Which projects used Experience Cloud?” → Micromed. “List published projects.”
2. **Experience and certifications** — start with record queries on `Experience__c` and `Certification__c` (standard Retriever / Query Records). You can add a small invocable later if the answers are too thin.
3. **GitHub** — action: `Get GitHub Repositories`. Sample: “What are my public repositories?”

Topic instructions (copy and adapt):

- Answer only from Salesforce data returned by actions or queries.
- If nothing matches, say you do not have that project — do not invent client names, SLAs or metrics.
- Never quote internal IDs as if they were business facts.
- Keep answers short enough for a 30-second interview demo.

## Setup sequence

1. Setup → Agentforce → enable the product (and Einstein if the wizard asks).
2. New agent → Employee/internal.
3. Add topics with the instructions above.
4. Add actions: Apex `PortfolioProjectInvocable` and `GitHubReposInvocable` (labels: Get Portfolio Projects / Get GitHub Repositories).
5. Grant the agent’s running user `Portfolio_Admin` plus Agentforce permissions.
6. Test in the agent preview with the sample questions.
7. Record video + screenshots **before** the org goes idle.

## Evidence

- Home page with the LWC **and** the agent answering a project question.
- Flow canvas is not Agentforce — do not substitute it.
- Dogfood: this app is already a Published `Salesforce_Project__c` in `data/Salesforce_Project__c.json`. After Agentforce works, mention it in Architecture__c if you want the agent to describe itself.

## What not to do

- Do not commit GenAI/Bot XML into `force-app` until deploy to a vanilla DE still succeeds.
- Do not enable Agentforce only on a scratch org you will throw away without prints.
- Do not add Agentforce to the CV until the preview answers the Experience Cloud question correctly.
