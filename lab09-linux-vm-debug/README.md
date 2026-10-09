# Lab 09 — Linux VM troubleshooting + Ansible
Time: 4-5 h. Cost: one B2s VM (auto-shutdown 19:00 IST). JD: "Proficiency in Linux administration, scripting, and troubleshooting", "Ansible".

```bash
cd terraform
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
terraform init && terraform apply -var "my_ip_cidr=$(curl -s ifconfig.me)/32"
# wait ~3 min, then:
ssh azureuser@$(terraform output -raw public_ip)
```
## Ticket you received (symptoms only)
1. "The shop website (port 80) is down. Hit it from your laptop: `curl http://<ip>`."
2. "The box feels slow and the fan is screaming (CPU alert since boot)."
3. "Writes to the app log mount fail / df says it is nearly full, but nobody can find the big files."
4. "The payments worker never stays up, ops says it was deployed yesterday."

## Rules
No reboot as a fix. No `chmod -R 777`. Record the commands you ran. For each fault: symptom -> evidence command -> root cause -> fix -> prevention. Then write one incident report covering all four (a "multiple concurrent faults" report: how did you prioritize?).

## Tools you should reach for
`systemctl status/--failed`, `journalctl -u X -b`, `nginx -t`, `ss -tlnp`, `top/htop/pidstat`, `df -h`, `du -xh --max-depth=1`, `lsof +L1`, `ls -l`, `namei`, `dmesg`, `mount`, `free -m`, `iostat`.

## Part B — Ansible (setup)
Fix everything by hand first. Then complete `ansible/harden.yml` so that destroying and re-creating the VM + running the playbook gives a healthy box. Run it twice: the second run must report `changed=0` (idempotency). Add a `--check --diff` run to your notes.

## Part C — Scripting
Write a bash (or Python) script `healthcheck.sh` that checks: disk >80%, deleted-but-open files, failed systemd units, top CPU process, nginx config validity; exits non-zero on problems. Put it in cron or a systemd timer.

## Teardown
`terraform destroy -var "my_ip_cidr=0.0.0.0/32"`
