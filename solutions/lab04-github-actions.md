# Lab 04 solutions — deploy.broken.yml defects
1. `python: [3.10, ...]` — YAML parses 3.10 as float 3.1 -> wrong/missing Python. Quote versions: `"3.10"`.
2. `test` job has no `actions/checkout` -> `requirements-dev.txt` not found.
3. `needs: tests` (job is `test`) -> workflow invalid: "Job 'build' depends on unknown job 'tests'". Whole workflow doesn't start.
4. No `permissions: id-token: write` (+ `contents: read`) -> `azure/login` fails: cannot get `ACTIONS_ID_TOKEN_REQUEST_URL`.
5. `build` runs on `pull_request` and pushes images: untrusted code gets registry write. Also PR runs use `sub = repo:ORG/REPO:pull_request`; without a federated credential for it you get `AADSTS70021: No matching federated identity record found`. Gate pushes with `if: github.event_name == 'push'` and keep PR runs to build-only.
6. `if: github.ref == 'main'` is never true. `github.ref` is `refs/heads/main`.
7. `deploy` has `environment: production`: OIDC `sub` becomes `repo:ORG/REPO:environment:production` — no federated credential matches -> AADSTS70021 again. Add a credential for that subject.
8. `deploy` has no `actions/checkout`, no `azure/login` before `aks-set-context` (and no `kubelogin` if AAD-integrated).
9. Hygiene: no `concurrency`, no `timeout-minutes`, actions pinned to tags not SHAs, `needs` allows deploy even when tests are skipped, no rollback on failed `rollout status`.
Azure-side drills: no AcrPush -> `denied: requested access to the resource is denied` / 403; no AKS Cluster User -> `AuthorizationFailed ... listClusterUserCredential`.

## sub claim cheat-sheet
branch: `repo:O/R:ref:refs/heads/main` | tag: `...:ref:refs/tags/v1` | PR: `...:pull_request` | environment: `...:environment:NAME` (environment overrides branch).
