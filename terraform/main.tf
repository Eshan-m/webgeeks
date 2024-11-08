provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "resource_group" {
  name     = "foodrescueapp-rg"
  location = "East US"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "appServicePlan"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = "Windows"
  sku_name            = "B1"
}

resource "azurerm_windows_web_app" "app_service" {
  name                = "foodrescueapp"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    application_stack {
      dotnet_version = "v6.0"  # Corrected version format
    }
  }
}


resource "azurerm_mssql_server" "sql_server" {
  name                         = "foodrescuesqlserver"
  resource_group_name          = azurerm_resource_group.resource_group.name
  location                     = azurerm_resource_group.resource_group.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "sql_database" {
  name      = "foodrescuedb"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "S0"
}
