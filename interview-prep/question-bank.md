# Question bank (answer out loud, 90 seconds each, then check yourself)
## Docker / containers
1. What happens on `docker run`? (namespaces, cgroups, union fs, runtime). 2. Why is running as root in a container bad? 3. Multi-stage builds: why? 4. How do you reduce image CVEs? 5. CMD vs ENTRYPOINT, exec vs shell form. 6. A container exits immediately. Debug it.
## Kubernetes
7. Walk through what happens on `kubectl apply -f deployment.yaml`. 8. Pod stuck Pending / CrashLoopBackOff / ImagePullBackOff / OOMKilled: your first 3 commands each. 9. Requests vs limits; QoS classes; what CPU throttling looks like. 10. Liveness vs readiness vs startup probes — when does a wrong liveness probe cause an outage? 11. Service types, Ingress vs Gateway API. 12. How does a rolling update work? Rollback? 13. HPA vs VPA vs cluster autoscaler. 14. NetworkPolicy basics. 15. RBAC: Role vs ClusterRole, how to audit. 16. How do you upgrade AKS safely? 17. etcd/control plane: what's managed on AKS and what isn't? 18. How do you handle secrets in k8s properly?
## Terraform / IaC
19. State: what, where, risks, locking. 20. `count` vs `for_each`. 21. Import, `moved`, `state mv`. 22. How do you structure repos/envs/modules? 23. Detect and handle drift. 24. How do you manage secrets in Terraform? 25. Terraform vs Bicep vs Ansible: what each is for. 26. A plan wants to destroy your database. What do you do?
## CI/CD (Jenkins / GHA / Azure DevOps)
27. Design a pipeline for a microservice to prod with approvals. 28. Controller vs agent; ephemeral agents. 29. How do you keep secrets out of pipelines? OIDC vs service principal secret. 30. How do you speed up a 40-min pipeline? 31. Pipeline-as-code benefits; shared libraries/reusable workflows. 32. Blue/green vs canary vs rolling. 33. How do you roll back? DB migrations? 34. Branching strategies (trunk-based vs GitFlow) and how they affect CI/CD. 35. Flaky tests: policy?
## GitOps
36. Push vs pull deployment. 37. What does Argo CD's selfHeal/prune do and risk? 38. How do you promote across environments? 39. Secrets in GitOps.
## Cloud / Azure
40. Entra ID, RBAC, managed identity vs service principal. 41. VNet, NSG, UDR, private endpoint, service endpoint — differences. 42. Load Balancer vs App Gateway vs Front Door. 43. Availability zones vs sets vs regions. 44. Cost optimization: five concrete levers. 45. How do you secure an AKS cluster end to end?
## Reliability / incident
46. SLI/SLO/SLA/error budget. 47. Describe your last major incident (use lab incidents honestly). 48. Run an incident as commander: first 5 minutes. 49. Blameless postmortem: what makes a good action item? 50. Alert fatigue: how to fix. 51. Disk full but `du` shows nothing. 52. Server load is high: step-by-step. 53. DNS resolution fails in a pod.
## DevSecOps / compliance
54. Shift-left: what do you scan and where? 55. SBOM, provenance, image signing (cosign), admission control. 56. SOC 2 Type 1 vs 2; what evidence for change management? 57. CVE appears in prod image: process and SLA.
## Delivery / stakeholder (JD 1)
58. A customer wants to skip approvals "just this once". 59. How do you report status when you're RED? 60. DORA metrics and their misuse. 61. Incident vs problem vs change (ITIL). 62. How do you say no to a senior stakeholder?
