# Lab 11 — Delivery, governance, KPIs, ITIL (the non-coding half of the first JD)
Time: 3-4 h. No cloud cost. Do not skip: the first JD lists status reports, CI/CD governance calls, KPI tracking and ITIL. Technical candidates often fail here.

## Tasks
1. **DORA metrics**: from `deployments.csv` compute deployment frequency, lead time for changes, change failure rate, and MTTR (script in any language). Present a weekly report (half a page) with trend + one recommendation. Know the 4 definitions cold and how you'd collect them automatically (pipeline events -> Log Analytics/Grafana).
2. **Status report**: write a weekly status for a fictional "CI/CD onboarding for customer X" project: RAG status, milestones, risks/issues/dependencies, decisions needed, next week. Max 1 page. Template below.
3. **CI/CD governance call**: write the agenda and talking points for a 30-minute call with a customer who wants to deploy to prod directly from a developer laptop. Include: your positions (approvals, environments, rollback, change windows), what you'd concede, and the 3 asks you'd close the call with.
4. **ITIL/change**: write a change request for "upgrade AKS from N to N+1 in prod": risk assessment, impact, test evidence, rollback plan, maintenance window, comms plan. Classify it (standard/normal/emergency) and justify. Then write the post-implementation review.
5. **Incident vs problem vs change** — one paragraph each in your own words with an example from your earlier labs.
6. Pick the two worst incidents from labs 03-10 and write one **executive summary** (5 lines, non-technical) for each.

## Status report template
```
Project / Week of:
Overall: GREEN | AMBER | RED  (one sentence why)
Done this week:
Planned next week:
Milestones: | name | due | forecast | status |
Risks/Issues: | id | description | impact | owner | mitigation | due |
Decisions / help needed from leadership:
KPIs: deploy freq, lead time, CFR, MTTR, pipeline success %, avg build time
```
