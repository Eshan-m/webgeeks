output "app_service_url" {
  description = "URL of the deployed App Service"
  value       = azurerm_windows_web_app.app_service.default_hostname
}
