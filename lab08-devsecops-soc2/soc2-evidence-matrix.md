# SOC 2 evidence matrix (Security / Common Criteria) — fill in
| Criteria | Control you implemented | Where (repo/tool) | Evidence an auditor sees | Owner | Frequency | Gap? |
|---|---|---|---|---|---|---|
| CC6.1 Logical access | Entra ID SSO, RBAC least privilege, no shared accounts | | Role assignment export, access review ticket | | Quarterly | |
| CC6.2/6.3 Provisioning & removal | Joiner/mover/leaver process | | Tickets + removal logs | | Per event | |
| CC6.6 Boundary protection | NSGs, private endpoints, API server IP allow-list | | Terraform + NSG rule export | | Continuous | |
| CC6.7 Data in transit/at rest | TLS min 1.2, storage encryption, Key Vault | | Policy compliance report | | Continuous | |
| CC7.1 Vulnerability mgmt | Trivy/Checkov in CI, patch SLAs | | Pipeline logs, SLA report | | Per build | |
| CC7.2 Monitoring | Prometheus/Alertmanager, Log Analytics, audit logs | | Alert rules, log retention config | | Continuous | |
| CC7.3/7.4 Incident response | Incident template, on-call, postmortems | | Past incident reports | | Per incident | |
| CC8.1 Change management | PR reviews, protected branches, approvals, GitOps history | | PR approvals, deploy history | | Per change | |
| CC9.1 Risk mitigation / BCP | Backups, DR test, IaC rebuild | | Restore test record | | Annual | |
| A1.2 Availability | SLOs, HPA, PDB, multi-node | | SLO dashboard | | Monthly | |
