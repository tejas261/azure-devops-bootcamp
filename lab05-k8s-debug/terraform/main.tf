# Creates a SECOND ACR that the AKS kubelet identity has NO permission on (scenario s2),
# and imports a public image into it. Needs Azure CLI logged in (terraform_data runs `az`).
terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
    random  = { source = "hashicorp/random", version = "~> 3.6" }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  type    = string
  default = "centralindia"
}

resource "random_string" "s" {
  length  = 5
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-k8sdebug"
  location = var.location
}

resource "azurerm_container_registry" "private" {
  name                = "debugacr${random_string.s.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
}

resource "terraform_data" "import_image" {
  triggers_replace = [azurerm_container_registry.private.id]
  provisioner "local-exec" {
    command = "az acr import --name ${azurerm_container_registry.private.name} --source mcr.microsoft.com/azuredocs/aks-helloworld:v1 --image orders:v1"
  }
}

output "acr_login_server" { value = azurerm_container_registry.private.login_server }
