# main.tf

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = "foodrescuesqlserver"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "food_rescue_db" {
  name                = "DevTest"
  server_id           = azurerm_mssql_server.sql_server.id
  sku_name            = "Basic"
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name       = "AllowAzure"
  server_id  = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Provisioner to execute SQL scripts
resource "null_resource" "execute_sql_scripts" {
  depends_on = [azurerm_mssql_database.food_rescue_db]

  provisioner "local-exec" {
    command = <<EOT
      sqlcmd -S ${azurerm_mssql_server.sql_server.fully_qualified_domain_name} -d DevTest -U ${var.sql_admin_username} -P "${var.sql_admin_password}" -i "C:\\Users\\VKUMAR\\Downloads\\webgeeks-v1\\sql\\Tables.sql"
      sqlcmd -S ${azurerm_mssql_server.sql_server.fully_qualified_domain_name} -d DevTest -U ${var.sql_admin_username} -P "${var.sql_admin_password}" -i "C:\\Users\\VKUMAR\\Downloads\\webgeeks-v1\\sql\\Stored_procedures.sql"
      sqlcmd -S ${azurerm_mssql_server.sql_server.fully_qualified_domain_name} -d DevTest -U ${var.sql_admin_username} -P "${var.sql_admin_password}" -i "C:\\Users\\VKUMAR\\Downloads\\webgeeks-v1\\sql\\GetFoodItems.sql"
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
}
