# Creates an Entra ID app + federated credentials so GitHub Actions can log in to Azure with OIDC (no stored secrets).
# Requires permission to create app registrations in your tenant. If this fails with Authorization_RequestDenied,
# that IS the lesson: ask your tenant admin, or use a personal/free tenant.
terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
    azuread = { source = "hashicorp/azuread", version = "~> 3.0" }
  }
}

provider "azurerm" {
  features {}
}
provider "azuread" {}

variable "github_org" { type = string }
variable "github_repo" { type = string }
variable "acr_name" { type = string }
variable "acr_rg" { type = string }
variable "aks_name" { type = string }
variable "aks_rg" { type = string }

data "azurerm_client_config" "current" {}
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_rg
}
data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.aks_rg
}

resource "azuread_application" "gh" {
  display_name = "gh-actions-${var.github_repo}"
}

resource "azuread_service_principal" "gh" {
  client_id = azuread_application.gh.client_id
}

resource "azuread_application_federated_identity_credential" "main_branch" {
  application_id = azuread_application.gh.id
  display_name   = "main-branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}

resource "azuread_application_federated_identity_credential" "pull_request" {
  application_id = azuread_application.gh.id
  display_name   = "pull-request"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:pull_request"
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.gh.object_id
}

resource "azurerm_role_assignment" "aks_user" {
  scope                = data.azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_service_principal.gh.object_id
}

output "AZURE_CLIENT_ID" { value = azuread_application.gh.client_id }
output "AZURE_TENANT_ID" { value = data.azurerm_client_config.current.tenant_id }
output "AZURE_SUBSCRIPTION_ID" { value = data.azurerm_client_config.current.subscription_id }
