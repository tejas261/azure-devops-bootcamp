# INTENTIONALLY INSECURE. DO NOT APPLY. Scan only: checkov -d . / tfsec . / trivy config .
terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-insecure"
  location = "centralindia"
}

resource "azurerm_storage_account" "sa" {
  name                            = "insecurestorage123"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = true
  min_tls_version                 = "TLS1_0"
  https_traffic_only_enabled      = false
  public_network_access_enabled   = true
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-open"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "ssh-any"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "rdp-any"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_key_vault" "kv" {
  name                       = "insecure-kv-123"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = "00000000-0000-0000-0000-000000000000"
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  rbac_authorization_enabled = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-insecure"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "insecure"
  sku_tier            = "Free"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
  identity { type = "SystemAssigned" }

  role_based_access_control_enabled = false
  api_server_access_profile {
    authorized_ip_ranges = ["0.0.0.0/0"]
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "insecureacr123"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

variable "db_password" {
  type    = string
  default = "Winter2026!"
}
