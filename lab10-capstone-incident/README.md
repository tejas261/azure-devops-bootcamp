# Lab 10 — Capstone: multi-fault outage + Terraform drift (timed, 2.5 h)
Do this LAST, with a timer. Pretend you were paged: "shop.example.com is down" (you'll use port-forward / ingress IP).

## Part A — Kubernetes outage
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
kubectl apply -f manifests/shop.yaml
kubectl -n ingress-nginx get svc ingress-nginx-controller   # wait for EXTERNAL-IP; test: curl http://<ip>/
```
Goal: `curl http://<ingress-ip>/` returns `200` with a welcome page, 3 healthy replicas, HPA working, and a node drain doesn't hang. There are 6 independent faults. You may not change the deployment image or rebuild the namespace.
Hand in: a **timeline** (minute by minute), root causes list, fixes, and an incident report from `../templates/` (SEV2). Include "what I'd put in monitoring so we'd have caught each one before a customer did".

## Part B — Terraform drift incident
```bash
cd terraform && terraform init && terraform apply
../inject-drift.sh
terraform plan          # read it carefully
```
Questions to answer in writing:
1. What drifted? Which of those changes are **security regressions** and which are benign?
2. A ticket says the SSH rule `temp-debug-ssh` is "needed for INC-4411". Do you `apply` (reverting it) or update code? Defend your answer, including who you'd ask first. (There is no single right answer. A bad answer is "just apply".)
3. Show how you'd detect drift **automatically** (scheduled `terraform plan -detailed-exitcode` in CI) and what policy would have prevented the portal change (Azure Policy deny / RBAC with no write access for humans).

## Teardown
`kubectl delete ns shop; helm uninstall ingress-nginx -n ingress-nginx; kubectl delete ns ingress-nginx; cd terraform && terraform destroy`
