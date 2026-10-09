# Lab 07 — Observability, SLAs/SLOs, resource optimization
Time: 5-6 h. Prereq: orders deployed in `orders-dev` (via Argo CD or manually).
JD: "Monitoring the SLAs and provide recommendation on resource optimization", "measure system performance and recommend modifications".

## Setup
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install kps prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f values-kps.yaml
kubectl apply -f orders-monitoring.yaml
kubectl -n monitoring port-forward svc/kps-grafana 3000:80
```
## Tasks
1. Define SLIs/SLOs for orders in writing: availability 99.5% / 30 days, p95 latency < 300 ms. Compute the **error budget** in minutes and in requests. Explain SLI vs SLO vs SLA.
2. Build a Grafana dashboard: RED metrics (rate, errors, duration) + saturation (CPU/memory vs requests/limits) + pod restarts. Export JSON to your repo.
3. Add a latency alert (histogram_quantile) and a **burn-rate** alert (fast 1h/5m and slow 6h/30m windows). Why multi-window?
4. Inject failures: `kubectl -n orders-dev set env deploy/orders ERROR_RATE=0.3`. Time to detect? Did the alert fire, route to Alertmanager, and do you know where it went? Configure a receiver (email/Slack webhook) and an inhibition or grouping rule.
5. Azure side: Container Insights is enabled by the platform. Write KQL (Log Analytics) for: (a) pods restarted in last hour, (b) top 10 pods by memory, (c) node CPU > 80%, (d) `KubeEvents` Warning reasons. Create one Azure Monitor alert rule from KQL.
6. **Right-sizing exercise**: run a load (`kubectl run -it --rm hey --image=williamyeh/hey -- -z 3m -c 20 http://orders.orders-dev/`). Compare `kubectl top` / Grafana usage to requests/limits in `sample-app/deploy/base/deployment.yaml`. Produce a recommendation table: current vs observed p95 vs proposed request/limit, plus HPA settings, plus estimated node count and cost impact. Install VPA in recommend-only mode and compare its numbers with yours.
7. Break it: set the memory limit to 40Mi, load test, observe OOMKilled in Grafana + Container Insights. Write the incident report.

## Teardown
`helm uninstall kps -n monitoring && kubectl delete ns monitoring` (CRDs remain: delete them, list with `kubectl get crd | grep monitoring.coreos`).

## Deliverables
`slo.md`, dashboard JSON, alert rules, `rightsizing-recommendation.md`.
