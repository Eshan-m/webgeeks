# variables.tf

# SQL Admin Username
variable "sql_admin_username" {
  description = "The username for the SQL administrator"
  type        = string
}

# SQL Admin Password
variable "sql_admin_password" {
  description = "The password for the SQL administrator"
  type        = string
  sensitive   = true
}

# Azure Subscription ID
variable "azure_subscription_id" {
  description = "The Azure Subscription ID where resources will be deployed"
  type        = string
}
