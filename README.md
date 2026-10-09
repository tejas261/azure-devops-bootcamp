# Azure DevOps / Cloud Bootcamp (11 labs)
Built from the JDs you shared: CI/CD (Jenkins, GitHub Actions, Azure DevOps), Terraform, Docker, Kubernetes (AKS), Argo CD, DevSecOps/SOC 2, observability/SLAs, Linux, Ansible, incident management, delivery/governance.

## Layout
| Folder | What |
|---|---|
| `platform/` | Reference Terraform: RG + ACR + Log Analytics + AKS. Lab 02 asks you to write your own first |
| `sample-app/` | Flask app, tests, hardened Dockerfile, Kustomize base + dev/prod overlays (used by Labs 03-07) |
| `lab01-docker` | Broken Dockerfile/app (debug + harden). No cloud |
| `lab02-terraform` | Write Azure IaC from scratch + 6 break/fix drills |
| `lab03-jenkins` | **TF**: Jenkins VM. Setup pipeline from scratch + broken Jenkinsfile (13 defects) |
| `lab04-github-actions` | **TF**: Entra OIDC for GH Actions. Setup + broken workflow |
| `lab05-k8s-debug` | **TF**: private ACR (pull-auth failure). 8 broken scenarios, apply/reset scripts |
| `lab06-argocd` | Helm install, app-of-apps, 5 broken Applications |
| `lab07-observability` | kube-prometheus-stack, SLOs, burn-rate alerts, KQL, right-sizing |
| `lab08-devsecops-soc2` | Insecure TF to scan/fix (never applied), SOC 2 evidence matrix |
| `lab09-linux-vm-debug` | **TF**: VM with 4 hidden faults, Ansible starter |
| `lab10-capstone-incident` | **TF**: drift scenario + 6-fault K8s outage, timed |
| `lab11-delivery-governance` | Status reports, DORA, ITIL change request, governance call |
| `templates/` | Incident report template |
| `solutions/` | Answer keys + filled-in reference incident reports. Open last |
| `interview-prep/` | JD gap matrix, 62 questions, 5-week plan |

## Prerequisites
Azure subscription (free credits are fine, but check vCPU quota in your region), `az`, Terraform >= 1.6, `kubectl`, `helm`, Docker, Git, a GitHub account, Python 3. Run `az login` and `export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)`.

## Order
01 -> 02 -> (platform up) 03 -> 04 -> 05 -> 06 -> 07 -> 08 -> 09 -> 10 -> 11. Labs 01, 08 (part A), 11 need no cloud spend.

## Working rules
1. Attempt first, write your diagnosis, then compare to `solutions/`.
2. Every debugging lab: symptom -> evidence command -> root cause -> fix -> prevention. Use `templates/incident-report-template.md` for the labs that call for it.
3. Tear down after each session (see each README). Region defaults to `centralindia`; change `location` if quota/policy blocks it.
4. Public GitHub repo per lab with a README. That's your portfolio.

## Limits of this package (read this)
- The Terraform and scenarios were written carefully but **not executed or `terraform validate`d** in the environment that built them (no network/Azure access). Expect small provider/version, quota, or naming issues. Fixing those is part of the job; if a TF file is wrong in a way that blocks you, fix it and note what you changed.
- Azure Terraform provider and AKS defaults change. The `~> 4.0` azurerm constraint and attribute names (e.g. Key Vault `rbac_authorization_enabled`) may need adjusting with `terraform init -upgrade` and the provider docs.
- Labs can't replace production experience at scale or real stakeholder work.
