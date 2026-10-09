# Capstone part 2: a small "prod" footprint, then someone makes manual changes (drift) with inject-drift.sh.
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
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-capstone-prod"
  location = var.location
  tags     = { env = "prod", owner = "platform-team" }
}

resource "azurerm_storage_account" "data" {
  name                            = "capstone${random_string.s.result}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = { env = "prod", owner = "platform-team" }
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "https-in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

output "storage_account" { value = azurerm_storage_account.data.name }
output "nsg" { value = azurerm_network_security_group.app.name }
