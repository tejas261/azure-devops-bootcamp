# Lab 06 solutions
| App | Symptom | Cause | Fix |
|---|---|---|---|
| app-1 | `ComparisonError: app path does not exist` | `overlay` vs `overlays` | fix path |
| app-2 | `Unable to resolve 'release' to a commit SHA` | branch doesn't exist | create branch or point to `main`/tag |
| app-3 | `InvalidSpecError: ... project platform-team not found` | AppProject missing | create AppProject (with allowed repo + destination) or use correct one |
| app-4 | Degraded / SyncFailed: `namespaces "does-not-exist" not found`, also ImagePullBackOff | no namespace; base image still `REPLACE_ACR` | `syncOptions: [CreateNamespace=true]`; point at an overlay, not base |
| app-5 | Perpetually OutOfSync / replicas flapping, manual scale reverted | HPA changes replicas, git says 2; selfHeal reverts manual edits | `ignoreDifferences` on `/spec/replicas` (+ `RespectIgnoreDifferences=true`); remove `replicas` from git when HPA owns it |
Bonus: app-3 and app-5 both render the prod overlay into `orders-prod` -> `SharedResourceWarning` (two Applications own the same resources). One owner per resource.
Finalizer drill: without `resources-finalizer.argocd.argoproj.io` deleting the Application leaves the workload orphaned; with it, children are deleted (cascade).
