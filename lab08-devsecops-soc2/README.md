# Lab 08 — DevSecOps + SOC 2 readiness
Time: 5-6 h. Mostly static scanning, near-zero cost.
JD: "Knowledge of DevSecOps practices, security, compliance, vulnerability management" / "Getting the product SOC 2 readiness".

## Part A — Shift-left scanning (debug/fix)
1. In `insecure-terraform/` run: `checkov -d .` and `trivy config .` (install either via pip/brew/docker). Do **not** apply. Triage the findings into: real risk / acceptable with justification / false positive. Fix the code until the scan passes, or add a justified `#checkov:skip=ID:reason`. Explain why blind skips are an audit failure.
2. Secrets: plant a fake key in a commit of your repo, detect it with `gitleaks`, then remove it from history (`git filter-repo`) and explain why rotating beats deleting.
3. Images: scan your `orders` image with Trivy (`--severity HIGH,CRITICAL --exit-code 1`). Pick an old base image on purpose, show failures, upgrade, show pass. Generate an SBOM (`syft` or `trivy --format cyclonedx`), explain what you'd do when a new CVE drops in an already-deployed image.
4. Add these as gates in your Jenkins and GH Actions pipelines (lab 03/04). Decide what blocks the build and what only warns, and justify.

## Part B — Cluster/cloud controls (setup)
5. Enable the Azure Policy add-on on AKS and assign the built-in "Kubernetes cluster pod security baseline standards for Linux-based workloads" in **audit** mode, then deny. Deploy a privileged pod and see it rejected. (Write the Terraform for the assignment.)
6. Key Vault with RBAC, soft delete, purge protection; read a secret from a pod with workload identity + CSI driver (builds on Lab 05 step 1). No secret in env vars in YAML.
7. Diagnostic settings: send AKS control-plane audit logs + Key Vault logs to Log Analytics. Write KQL to answer: "who deleted X in the last 24h?"
8. RBAC review: list who has Owner/Contributor on the subscription and justify each; apply least privilege to your GH Actions SP.

## Part C — SOC 2 mapping (the part candidates skip, and interviewers ask)
Fill `soc2-evidence-matrix.md`: for each control, what you built in these labs, and what **evidence** an auditor would be shown (screenshot/log/export/ticket), who owns it, and how often it is collected. Be honest about gaps. Also write a 1-page answer to: "What's the difference between SOC 2 Type 1 and Type 2, and what does 'readiness' actually mean?"

## Deliverables
Clean scans (before/after), `soc2-evidence-matrix.md`, policy Terraform, incident report: "leaked credential in git" (Part A step 2).
