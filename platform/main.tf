# Reference platform: RG + ACR + Log Analytics + AKS.
# Lab 02 asks you to write this yourself FIRST. Use this only to unblock later labs.
terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
    random  = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

# Needs: export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
provider "azurerm" {
  features {}
}

variable "prefix" {
  type    = string
  default = "bootcamp"
}
variable "location" {
  type    = string
  default = "centralindia" # change if your subscription/quota blocks it
}
variable "node_vm_size" {
  type    = string
  default = "Standard_B2ms" # 2 vCPU / 8 GiB. Check quota: az vm list-usage -l <region> -o table
}
variable "node_count" {
  type    = number
  default = 2
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-platform"
  location = var.location
  tags     = { purpose = "devops-bootcamp", owner = "me", delete_after = "yes" }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.prefix}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "aks-${var.prefix}"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  dns_prefix                = "aks-${var.prefix}-${random_string.suffix.result}"
  sku_tier                  = "Free"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  default_node_pool {
    name       = "system"
    node_count = var.node_count
    vm_size    = var.node_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

output "rg_name" { value = azurerm_resource_group.rg.name }
output "acr_name" { value = azurerm_container_registry.acr.name }
output "acr_login_server" { value = azurerm_container_registry.acr.login_server }
output "aks_name" { value = azurerm_kubernetes_cluster.aks.name }
output "oidc_issuer_url" { value = azurerm_kubernetes_cluster.aks.oidc_issuer_url }
output "get_credentials" {
  value = "az aks get-credentials -g ${azurerm_resource_group.rg.name} -n ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
}
