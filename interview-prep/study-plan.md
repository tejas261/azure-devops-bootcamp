# 5-week plan (assumes ~2 h weekdays + 4-5 h on a weekend day; adjust honestly)
| Week | Labs | Goal |
|---|---|---|
| 1 | 01, 02 | Containers + Terraform from scratch. Remote state. |
| 2 | 03, 04 | Jenkins + GH Actions pipelines; both deploy the same app to AKS. |
| 3 | 05, 06 | K8s debugging fluency + GitOps. Aim for each scenario < 10 min the second time. |
| 4 | 07, 08, 09 | SLOs, security gates, Linux + Ansible. |
| 5 | 10, 11 + interview prep | Timed capstone, then mock interviews: explain each lab to a friend/recorder without notes. |

## How to know you're ready (be strict)
- You can redo any debug scenario in a fresh cluster faster than the first time and explain the cause in two sentences.
- You can draw the full pipeline (commit -> prod) from memory and name every failure point and how you'd detect it.
- You can answer 80% of `question-bank.md` without notes. Record yourself; listen back; count filler/vagueness.
- Your repos are public (without secrets) with READMEs a stranger can follow. Interviewers do open them.

## Weekly cost hygiene
`az aks stop` after every session. `terraform destroy` Fri night for Jenkins/Linux VMs. Set a budget alert (Azure Cost Management -> Budgets) at a small amount BEFORE Lab 02 step 6. Check "Cost analysis" every weekend. Look at `az resource list -o table` for orphans (public IPs, disks, load balancers).

## Resume honesty
Write "Built X in a personal Azure lab" not "Production experience". Interviewers can tell, and depth questions will expose it. The labs make you *capable*; claiming more than you did is the fastest way to fail an interview you were otherwise ready for.
