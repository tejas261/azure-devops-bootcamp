# Lab 05 — Kubernetes debugging (8 scenarios)
Time: 5-7 h. Prereq: platform AKS up. s2 additionally needs `terraform/` applied.

```bash
./scripts/apply.sh s1                      # deploy a broken scenario
./scripts/apply.sh s2 $(cd terraform && terraform output -raw acr_login_server)
./scripts/reset.sh                         # teardown all namespaces
cd terraform && terraform destroy          # remove the extra ACR
```
Rules: only `kubectl get/describe/logs/events/exec/top` to diagnose. Write the cause down BEFORE you fix. Time yourself. For **s2, s6 and s7** write a full incident report from `../templates/`. For the others, write a 3-line note: symptom, root cause, fix.

## Symptoms only (no spoilers)
| ID | What the "customer" says |
|---|---|
| s1 | "Deployment never becomes ready. Pods show an image error." |
| s2 | "Same image works from MCR but we moved it to our own registry and pods won't start. Registry is up, image exists." |
| s3 | "Worker pod keeps restarting every few seconds." |
| s4 | "Pods are Running 1/1, but hitting the service by name from another pod times out / refuses." |
| s5 | "3 replicas requested, none scheduled. Nothing crashes, nothing runs." (There is more than one cause.) |
| s6 | "Pods are Running but `READY 0/1`, Service has no endpoints, site returns errors." |
| s7 | "Pod restarts, `kubectl logs` looks empty/clean, no error message in the app." |
| s8 | "Pods stuck in ContainerCreating / CreateContainerConfigError." |

## Then extend (setup tasks)
1. For s3/s8 write correct ConfigMap/Secret objects; then move the secret to Azure Key Vault + the Secrets Store CSI driver add-on (`az aks enable-addons --addons azure-keyvault-secrets-provider`) with workload identity.
2. For s5 add `ResourceQuota` + `LimitRange` to a namespace and show a deployment being rejected. Add a PodDisruptionBudget and show what it does during `kubectl drain`.
3. Add a NetworkPolicy default-deny + one allow rule, and prove it with a `curlimages/curl` pod.
4. Rolling update + `kubectl rollout undo`; know `maxSurge/maxUnavailable`.

## Command muscle memory (be able to type these without Googling)
`kubectl get events --sort-by=.lastTimestamp -A`, `describe pod`, `logs --previous`, `get endpoints`, `auth can-i`, `debug` (ephemeral container), `top pod/node`, `rollout status/undo/history`, `get pod -o jsonpath`, `port-forward`, `exec`, `cordon/drain`.
