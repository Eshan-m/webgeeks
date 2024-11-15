# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}

# Create Resource Group
resource "azurerm_resource_group" "food_rescue_rg" {
  name     = "FoodRescueAppRG"
  location = "Canada Central"
}

# Create App Service Plan
resource "azurerm_service_plan" "food_rescue_plan" {
  name                = "FoodRescueAppServicePlan"
  location            = azurerm_resource_group.food_rescue_rg.location
  resource_group_name = azurerm_resource_group.food_rescue_rg.name
  os_type             = "Windows"
  sku_name            = "F1"
}

# Create Backend Windows Web App for .NET 6 API
resource "azurerm_windows_web_app" "food_rescue_api" {
  name                = "FoodRescueApp-API"
  location            = azurerm_resource_group.food_rescue_rg.location
  resource_group_name = azurerm_resource_group.food_rescue_rg.name
  service_plan_id     = azurerm_service_plan.food_rescue_plan.id

  site_config {
    ftps_state = "Disabled"  # Optional config if FTP access is not needed
    always_on  = false       # Required for Free tier
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  connection_string {
    name  = "DatabaseConnectionString"
    type  = "SQLAzure"
    value = format("Server=tcp:%s.database.windows.net,1433;Initial Catalog=%s;Persist Security Info=False;User ID=%s;Password=%s;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
      azurerm_mssql_server.food_rescue_sql_server.name,
      azurerm_mssql_database.food_rescue_db.name,
      var.sql_admin_username,
      var.sql_admin_password
    )
  }
}

# Create Frontend Windows Web App for Angular App
resource "azurerm_windows_web_app" "food_rescue_client" {
  name                = "FoodRescueApp-Client"
  location            = azurerm_resource_group.food_rescue_rg.location
  resource_group_name = azurerm_resource_group.food_rescue_rg.name
  service_plan_id     = azurerm_service_plan.food_rescue_plan.id

  site_config {
    ftps_state = "Disabled"  # Optional config if FTP access is not needed
    always_on  = false       # Required for Free tier
  }
}

# SQL Server
resource "azurerm_mssql_server" "food_rescue_sql_server" {
  name                         = "foodrescuesqlserver"
  resource_group_name          = azurerm_resource_group.food_rescue_rg.name
  location                     = azurerm_resource_group.food_rescue_rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

# SQL Database
resource "azurerm_mssql_database" "food_rescue_db" {
  name      = "FoodRescueDB"
  server_id = azurerm_mssql_server.food_rescue_sql_server.id
  sku_name  = "Basic"
}