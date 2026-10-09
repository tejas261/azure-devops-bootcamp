# Lab 09 solutions
| # | Evidence | Root cause | Fix | Prevention |
|---|---|---|---|---|
| 1 nginx down | `systemctl status nginx` failed; `nginx -t`: `unexpected "server_name"` in `shop.conf:3`/missing `;` | Missing semicolon after `listen 80 default_server` | add `;`, `nginx -t`, `systemctl restart nginx` | `nginx -t` as a CI/deploy gate; Ansible `validate:` on copy |
| 2 CPU pegged | `top`: `sh -c 'while :; do :; done'`; `systemctl status reportgen`; killing the process just respawns | `reportgen.service` busy loop with `Restart=always` | `systemctl disable --now reportgen` (or `mask`) — kill alone is wrong | CPU alert, `CPUQuota=`, review unit files |
| 3 disk "full" | `df -h` /var/log/app ~92%; `du` shows ~0; `lsof +L1` shows `big.log (deleted)` held by leak.sh | Deleted-but-open file; space not released until process closes it | stop/disable the service (`systemctl disable --now leaky`) — or truncate via `: > /proc/<pid>/fd/3` as emergency | logrotate with proper reopen/copytruncate, disk usage alert at 80%, separate fs with quotas |
| 4 worker down | `systemctl status payments-worker`: `status=203/EXEC`; `ls -l /opt/payments/worker.sh` = 0644 | No exec bit | `chmod 755`, `systemctl reset-failed && restart` | deploy artifacts with explicit modes (Ansible `mode:`), CI check |
Prioritization (for the combined report): 1 nginx (customer-facing) -> 2 CPU (affects everything, quick) -> 3 disk (will cause outage soon) -> 4 payments worker (check if business-critical! if payments are down, it may be #1 — ask).
Reference: `ansible/harden.yml` TODOs are the answer to part B.
