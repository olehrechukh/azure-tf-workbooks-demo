terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-workbook"
  location = "eastus2"
}

resource "azurerm_storage_account" "sa" {
  name                     = "saexampleworkbook"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "law-workbook"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights_workbook" "monitoring" {
  name                = "85b3e8bb-fc93-40be-83f2-98f6bec18ba0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  display_name        = "Monitoring"
  source_id           = lower(azurerm_log_analytics_workspace.log_analytics.id)

  data_json = jsonencode(templatefile("${path.module}/workbook.json", {
    storageAccountId = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourcegroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.sa.name}",
    fallbackResourceId  = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourcegroups/${azurerm_resource_group.rg.name}/providers/microsoft.operationalinsights/workspaces/${azurerm_log_analytics_workspace.log_analytics.name}"
  }))

  tags = {
    "hidden-link:" = "Resource"
  }
}