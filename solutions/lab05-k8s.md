# Lab 05 solutions
| ID | Evidence | Root cause | Fix |
|---|---|---|---|
| s1 | `describe pod`: `ErrImagePull ... manifest unknown` | Tag typo `1.27-alpne` | correct tag |
| s2 | Events: `401 Unauthorized` pulling from the debug ACR | Kubelet managed identity has no `AcrPull` on that registry | `az aks update -g rg-bootcamp-platform -n aks-bootcamp --attach-acr <acr>` or a Terraform `azurerm_role_assignment` (AcrPull -> kubelet identity). Wait for propagation, delete pods |
| s3 | `logs --previous`: `fatal: DB_HOST not set`; CrashLoopBackOff, exit 1 | Missing env var | add `env`/`envFrom` ConfigMap; don't "fix" with sleep |
| s4 | `get endpoints web -n s4` is `<none>` | Selector `webapp` != label `web`; AND `targetPort 8080` != container port 80 | fix both. (First fix alone yields connection refused) |
| s5 | Events: `didn't match Pod's node selector`, then after removing it `Insufficient cpu/memory` | `disktype=ssd` label absent on nodes; 4 CPU/16Gi request > node allocatable (2 vCPU / ~8Gi on B2ms, less allocatable) | remove/label properly; right-size requests; or add bigger node pool |
| s6 | `get pods` 0/1; `describe`: `Readiness probe failed: HTTP probe failed with statuscode: 404` | nginx has no `/healthz` | probe a path the app serves (`/`), or add health endpoint. Endpoints empty because pods aren't Ready |
| s7 | `describe`: `Last State: Terminated, Reason: OOMKilled, Exit Code: 137`; logs empty | Process allocates 200M, limit 100Mi | raise limit/fix leak; right-size; cgroup OOM kills don't write app logs |
| s8 | `FailedMount: configmap "portal-config" not found`; `Error: secret "portal-secrets" not found` | Referenced objects don't exist (ordering/missing in release) | create them (or mark `optional: true` knowingly); deploy config before workload |

---
# Full reference incident report — s2 (image pull from private ACR)
**Severity:** SEV2 (new release could not start; existing pods unaffected)
**Impact:** `orders` v1 rollout stuck at 0/2 for 40 min after registry migration; no customer traffic loss because old Deployment remained.
**Timeline:** 10:00 deploy; 10:03 pods `ErrImagePull`; 10:10 confirmed image exists with `az acr repository show-tags`; 10:20 events show `401 Unauthorized`; 10:28 `az role assignment list --scope <acr>` shows no AcrPull for kubelet identity; 10:35 attached ACR; 10:40 pods Running.
**Root cause:** New registry was provisioned in a separate Terraform stack that did not grant the AKS kubelet identity `AcrPull`. Contributing: no pre-deploy check of registry access; the pipeline pushed fine (pipeline identity has AcrPush) so nobody saw the pull path break.
**Resolution:** `az aks update --attach-acr`, then `kubectl rollout restart`.
**Next steps:** (1) Put the role assignment in the same Terraform module as the ACR (prevent). (2) Pipeline smoke step: `kubectl run` a canary pod from the new registry before rollout (detect). (3) Alert on `ErrImagePull`/`ImagePullBackOff` events >5 min (detect). (4) Document "registry checklist" (mitigate).

# Full reference incident report — s6 (readiness probe 404)
**Severity:** SEV2. **Impact:** Service had 0 endpoints; 100% of requests failed for 12 min after rollout of `api`.
**Timeline:** 14:00 deploy; 14:01 alert: 5xx 100%; 14:03 `get endpoints api` empty; 14:05 pods 0/1 Ready, Running; 14:06 `describe pod` -> probe 404 on `/healthz`; 14:09 chart changed probe to `/`; 14:12 recovered.
**Root cause:** Probe path `/healthz` isn't served by the container. Contributing: no staging with the same probe; reviewers didn't test health endpoints; `maxUnavailable: 0` meant old pods should have kept serving — verify why they were gone (here: the first deploy, no old ReplicaSet).
**Resolution:** corrected path. **Next steps:** (1) contract test: CI curls the probe path in the built image (prevent); (2) `kubectl rollout status --timeout` in pipeline fails fast and triggers `rollout undo` (mitigate); (3) alert on `kube_deployment_status_replicas_unavailable > 0 for 3m` (detect); (4) template probes in Helm/Kustomize base (prevent).

# Full reference incident report — s7 (OOMKilled)
**Severity:** SEV3. **Impact:** `cruncher` restarted every ~10s; throughput degraded ~50%.
**Timeline:** 16:10 restarts noticed; 16:15 `logs` empty (no clue); 16:18 `describe pod` -> `OOMKilled` / 137; 16:25 `kubectl top` shows RSS climbing to limit; 16:40 limit raised to 256Mi as mitigation; follow-up: profile.
**Root cause:** Working set (~200Mi) exceeds the 100Mi limit; limits were guessed, never load-tested. Contributing: no memory saturation alert; logs don't show kernel OOM kills.
**Next steps:** (1) Measure p95 working set under load and set requests ≈ p95, limit ≈ p99 + headroom (prevent). (2) Alert on `container_oom_events_total`/`kube_pod_container_status_last_terminated_reason{reason="OOMKilled"}` (detect). (3) Add VPA recommender dashboard (detect). (4) Runbook: how to confirm OOM (mitigate).
