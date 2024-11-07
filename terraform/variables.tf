# variables.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "food-rescue-app-rg"
}

variable "location" {
  description = "Azure location for the resources"
  type        = string
  default     = "East US"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "food-rescue-app-service-plan"
}

variable "frontend_app_service_name" {
  description = "Name of the Frontend App Service"
  type        = string
  default     = "food-rescue-frontend"
}

variable "backend_app_service_name" {
  description = "Name of the Backend App Service"
  type        = string
  default     = "food-rescue-backend"
}

variable "sql_server_name" {
  description = "Name of the Azure SQL Server"
  type        = string
  default     = "foodrescuesqlserver"
}

variable "sql_database_name" {
  description = "Name of the Azure SQL Database"
  type        = string
  default     = "foodrescuedb"
}

variable "sql_admin_username" {
  description = "Admin username for SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Admin password for SQL Server"
  type        = string
  sensitive   = true
}

variable "app_insights_name" {
  description = "Name of the Application Insights resource"
  type        = string
  default     = "food-rescue-insights"
}
