# Lab 10 solutions
## Kubernetes faults (resolve in this order — each hides the next)
1. `ResourceQuota pods: 2` but replicas 3 -> ReplicaSet event `exceeded quota`. Raise quota/replicas properly.
2. Readiness probe port 8080 (container listens on 80) -> pods Running 0/1. Fix port.
3. `ingressClassName: nginx-internal` doesn't exist -> no ADDRESS / 404 from default backend. Use `nginx`.
4. Default-deny NetworkPolicy, no allow from `ingress-nginx` namespace -> 504/timeouts. Add allow policy (namespaceSelector on `kubernetes.io/metadata.name=ingress-nginx`).
5. HPA targets `storefront-deploy` -> `ScalingActive False: FailedGetScale`. Name should be `storefront`.
6. PDB `minAvailable: 3` with 3 replicas -> `kubectl drain` hangs (`Cannot evict ... disruption budget`). Use `minAvailable: 2` / `maxUnavailable: 1`.
## Terraform drift
Plan shows: NSG rule `temp-debug-ssh` to be destroyed (SSH open to the world = security regression), `allow_nested_items_to_be_public` back to false (security regression), tag `hotfix` removed (benign but it's the only ticket link). Right answer: don't blind-apply. Contact the owner of INC-4411, close the SSH hole immediately via apply of the SECURITY changes (or manual removal), and if the SSH access was truly needed, encode a scoped (source IP, time-limited, Just-in-Time/Bastion) rule in code. Prevention: Azure Policy deny public blob access/`*` inbound, human RBAC read-only on prod, scheduled `terraform plan -detailed-exitcode` (exit 2 = drift) alerting.
