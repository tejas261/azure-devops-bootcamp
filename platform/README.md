# Reference platform (ACR + AKS + Log Analytics)

```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
terraform init && terraform apply
$(terraform output -raw get_credentials)

# cost control when not studying:
az aks stop  -g rg-bootcamp-platform -n aks-bootcamp     # az aks start to resume
# end of study session / week:
terraform destroy
```
Approx running cost for 2x B2ms is a few USD/day. Verify in the Azure pricing calculator. A forgotten cluster is the #1 way people burn credits.
