# Lab 02 — Terraform on Azure from scratch (setup lab)
Time: 4-6 h. Cost: ~0 until step 6.

The JD says "expertise in Terraform for deploying stage and production". Copy-pasting the `platform/` folder is not expertise. Write it yourself.

## Tasks
1. Install Terraform >= 1.6, `az login`, set `ARM_SUBSCRIPTION_ID`.
2. **Remote state first.** Create (by `az` CLI, one-off) a storage account + container for state. Configure the `azurerm` backend with Entra ID auth (`use_azuread_auth = true`), not access keys. Explain why state must be remote and locked.
3. Write a **module** `modules/network` (VNet, 2 subnets, NSG with deny-by-default thinking) and call it from two environments `envs/stage` and `envs/prod` with different tfvars. No copy-paste between envs.
4. Add ACR, Log Analytics, Key Vault (RBAC authorization mode, soft-delete + purge protection on).
5. Add AKS in your VNet subnet (Azure CNI overlay), system + a separate user node pool with a taint. Compare with `../platform/main.tf` afterwards.
6. `terraform plan` in CI (GitHub Actions, Lab 04): plan on PR, apply on merge to main with a manual approval environment.

## Break/fix drills (do each, write 3 lines per drill)
- D1: Run `terraform apply` from two terminals at once -> state lock. How do you release a stuck lock safely? (`force-unlock` and when NOT to.)
- D2: Change a tag on a resource in the Portal. `plan` shows drift. Decide: import the change into code, or revert it with apply?
- D3: `terraform state rm` an existing resource, then `plan`: it wants to create a duplicate. Fix with `terraform import` (also try an `import {}` block).
- D4: Rename a resource label in code. `plan` wants destroy+create. Fix with a `moved {}` block.
- D5: Apply fails with `AuthorizationFailed` / `QuotaExceeded` / `SubscriptionNotRegistered` (register `Microsoft.ContainerService`). Know how each looks.
- D6: A variable contains a secret; find where it leaks (plan output, state file, logs). Mitigate: `sensitive`, Key Vault data sources, secure state backend.

## Deliverables
Repo with modules/envs, a README, and a "state & drift" notes file covering D1-D6.

## Must-answer questions
State file contents and risks; `count` vs `for_each` (and the index-shift problem); `depends_on` vs implicit deps; `lifecycle` (`prevent_destroy`, `ignore_changes`, `create_before_destroy`); workspaces vs separate state; provider version pinning and `.terraform.lock.hcl`; `plan -out` + apply of saved plan.
