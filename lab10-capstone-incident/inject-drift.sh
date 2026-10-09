#!/usr/bin/env bash
# Simulates a well-meaning engineer "hotfixing" in the Portal/CLI. Run AFTER terraform apply. Then run: terraform plan
set -euo pipefail
RG=rg-capstone-prod
SA=$(az storage account list -g $RG --query "[0].name" -o tsv)
az network nsg rule create -g $RG --nsg-name nsg-app-prod -n temp-debug-ssh --priority 120 \
  --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 22 --source-address-prefixes '*' -o none
az storage account update -g $RG -n "$SA" --allow-blob-public-access true -o none
az storage account update -g $RG -n "$SA" --tags env=prod owner=platform-team hotfix=INC-4411 -o none
echo "Drift injected. Now: terraform plan. What changed, who is right, what do you do?"
