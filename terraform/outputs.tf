# outputs.tf

output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}

output "database_connection_string" {
  value = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}
