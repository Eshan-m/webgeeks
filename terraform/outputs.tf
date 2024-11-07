# outputs.tf

output "frontend_app_service_url" {
  description = "URL of the Frontend App Service"
  value       = azurerm_app_service.frontend.default_site_hostname
}

output "backend_app_service_url" {
  description = "URL of the Backend App Service"
  value       = azurerm_app_service.backend.default_site_hostname
}

output "sql_server_name" {
  description = "Name of the Azure SQL Server"
  value       = azurerm_sql_server.sql_server.name
}

output "sql_database_name" {
  description = "Name of the Azure SQL Database"
  value       = azurerm_sql_database.sql_database.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation Key for Application Insights"
  value       = azurerm_application_insights.app_insights.instrumentation_key
}
