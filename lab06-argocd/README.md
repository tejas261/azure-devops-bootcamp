# Lab 06 — GitOps with Argo CD (setup + debug)
Time: 5-6 h. Prereq: platform AKS up, ACR with an `orders` image (from Lab 03 or 04), your own Git repo.

## Part A — Setup
1. Install Argo CD with **Helm** (not `kubectl apply` of the quickstart), pinned chart version, into namespace `argocd`. Access via `kubectl port-forward`. Change the admin password, then delete the initial secret.
2. Push `../sample-app/deploy/` to a repo `gitops-orders`. Fix the `REPLACE_ACR` image in the overlays.
3. Create an `AppProject` limiting source repos + destination namespaces. Create one `Application` for `overlays/dev` with automated sync, `prune`, `selfHeal`, and `CreateNamespace=true`.
4. Create an **app-of-apps** (or `ApplicationSet` with a list generator) producing dev + prod Applications.
5. Wire CI -> GitOps: your pipeline (Jenkins or GH Actions) should NOT `kubectl set image`. It should commit the new tag to the gitops repo (`kustomize edit set image`), and Argo does the deploy. Explain why this is better (audit trail, drift detection, rollback = git revert).
6. Rollback drill: ship a bad image tag, watch it fail, roll back with git revert (not the Argo UI).
7. Add a private-repo credential (GitHub deploy key/PAT as a Secret) and an Argo CD notification (Slack webhook or email) on sync failure.

## Part B — Debug `broken-apps/`
`broken-apps/applications.yaml` contains 5 Applications that each fail differently. Replace `REPLACE_ME_REPO_URL` with your repo and apply. For each: status shown in UI/CLI (`argocd app get`, `kubectl -n argocd describe application ...`) -> cause -> fix. Include `OutOfSync` that never converges, `Unknown` health/comparison error, `SyncFailed`, and "keeps reverting my manual change".

Extra drills:
- Manual `kubectl scale deploy/orders --replicas=5` on a self-healing app. What happens? And with HPA present and `replicas` in git? (Explain why `ignoreDifferences` on `/spec/replicas` is the usual fix.)
- Delete an Application with and without the `resources-finalizer.argocd.argoproj.io` finalizer. What happens to the workload?
- Secrets in Git: why not? Name two solutions (External Secrets Operator / Sealed Secrets / CSI + Key Vault).

## Teardown
`kubectl delete -n argocd applications --all` first (so finalizers run), then `helm uninstall argocd -n argocd`, then `kubectl delete ns orders-dev orders-prod argocd`.

## Deliverable
Gitops repo, diagram of the flow (code -> CI -> image -> gitops commit -> Argo -> cluster), 1 incident report (bad rollout + rollback).
