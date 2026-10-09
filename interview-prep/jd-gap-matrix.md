# JD requirement -> where you prove it
| JD requirement | Lab | Proof you can show |
|---|---|---|
| CI/CD pipelines from scratch (Jenkins) | 03 | Your own Jenkinsfile + JCasC + debug log |
| GitHub Actions / GitLab / Azure DevOps | 04 (+bonus az pipelines) | Working CI/CD, reusable workflow, OIDC notes |
| Terraform for stage/prod | 02, 10 | Modules + envs + remote state + drift notes |
| Docker | 01 | Hardened Dockerfile + bug log |
| Kubernetes | 05, 10 | 8 scenario notes + capstone timeline |
| GitOps / Argo CD (in demand even if not in these JDs) | 06 | Gitops repo + rollback drill |
| Monitoring, SLAs, resource optimization | 07 | slo.md + rightsizing recommendation |
| DevSecOps, compliance, vuln mgmt, SOC 2 readiness | 08 | Clean scans + evidence matrix |
| Linux admin, scripting, troubleshooting | 09 | healthcheck script + 4-fault report |
| Ansible / config management | 09 part B | Idempotent playbook |
| Incident mgmt, RCA, risk mitigation | 03-10 | 6+ incident reports |
| Stakeholder mgmt, status reports, KPIs, governance, ITIL | 11 | Status report, DORA numbers, change request |
| Load balancers, distributed systems, large-scale prod | 10 (partial) | **Gap**: labs can't give you scale. Read about it (see below) and be honest |
| Cyber security domain (plus) | 08 | |

## Honest gaps the labs can't close
- "Large scale production systems": you will not have this from labs. Say so, then show how you reason about it (SLOs, capacity, failure domains, blast radius, rollbacks).
- "Strong stakeholder management": only real customer-facing work builds this. Lab 11 gives you vocabulary and artifacts, not experience.
- Azure DevOps Pipelines, GitLab CI: you'll have used GH Actions + Jenkins. Be able to translate concepts, don't claim hands-on if you haven't.
- AWS/GCP: JD says "AWS/Azure/GCP" or "AWS and Azure". If you only did Azure, learn the service mapping (VNet=VPC, AKS=EKS, ACR=ECR, Key Vault=Secrets Manager/KMS, Entra ID=IAM, Log Analytics=CloudWatch Logs) and ideally do Lab 02 once on AWS.
