# Lab 04 — GitHub Actions + Azure OIDC: setup + debug
Time: 5-7 h. Prereq: platform (ACR+AKS) up, your sample-app in your own GitHub repo.

## Part A — Setup
1. Apply `terraform/` (needs `github_org`, `github_repo`, ACR/AKS names from the platform outputs). Add the 3 outputs as repo **variables/secrets**.
2. Write `.github/workflows/ci.yml` from scratch: on PR -> lint (ruff), test with coverage, build image, Trivy scan, **no push**. 
3. Write `cd.yml`: on push to main -> build, push to ACR via OIDC (`azure/login`), deploy to `orders-dev`, then `environment: production` with required reviewers -> `orders-prod`.
4. Add caching (pip + Docker layer cache), concurrency group (cancel superseded runs), least-privilege `permissions:` per job.
5. Convert one step into a **reusable workflow** (`workflow_call`) and one into a **composite action**.
6. Add `terraform-plan.yml` for Lab 02 code: plan comment on PR.
7. Bonus (JD lists Azure DevOps): rebuild the CI part as `azure-pipelines.yml` in a free Azure DevOps org. Know the vocabulary map: stages/jobs/steps, service connections, variable groups, environments/approvals.

## Part B — Debug `broken-workflow/deploy.broken.yml`
There are 9+ defects: YAML/semantic bugs, OIDC errors, job-graph and expression mistakes, security issues. Use real error text from the logs. Two of them are classic OIDC failures that interviewers love: one is `Error: Login failed ... id-token` style, the other is an `AADSTS70021: No matching federated identity record found`. Reproduce **each** deliberately, read the exact error, and explain how the `sub` claim is built for branch / PR / environment runs.

Then break it from the Azure side: delete the AcrPush role assignment -> what error does `docker push` give? Remove `Cluster User Role` -> what does `aks-set-context` say?

## Teardown
`terraform destroy` (app registration + role assignments).

## Deliverable
Working pipelines + `oidc-notes.md` + incident report for "deploy broke prod because X".
