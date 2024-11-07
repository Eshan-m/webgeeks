# CAA900-Capstone-Project-WebGeeks-FoodRescueApp-Deployment
Terraform deployment configuration for the Food Rescue App on Azure.
```markdown

This repository contains the Terraform code for deploying the **Food Rescue App** on **Azure**. The deployment uses Azure App Services to host both the frontend and backend applications, along with an Azure SQL Database for data storage.

## Prerequisites

- [Azure account](https://azure.microsoft.com/free/)
- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Azure CLI installed](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

Ensure you are logged into Azure using the Azure CLI before running any Terraform commands:

```bash
az login
```

## Configuration

1. **Clone this repository**:

    ```bash
    git clone https://github.com/booleandigit/CAA900-Capstone-Project-WebGeeks-FoodRescueApp-Deployment.git
    cd CAA900-Capstone-Project-WebGeeks-FoodRescueApp-Deployment
    ```

2. **Create a `terraform.tfvars` file**:

   Copy the `terraform.tfvars.example` file and update it with your own values. This file will hold your configurable values, such as resource names and Azure locations.

    ```bash
    cp terraform.tfvars.example terraform.tfvars
    ```

   Edit `terraform.tfvars` to specify your resource names and other details.

3. **Initialize Terraform**:

   Run this command to initialize the Terraform directory and download necessary providers.

    ```bash
    terraform init
    ```

## Usage

1. **Preview the deployment**:

   Use `terraform plan` to view the resources that will be created on Azure.

    ```bash
    terraform plan
    ```

2. **Deploy the infrastructure**:

   Run `terraform apply` to deploy the resources. Review the output and type `yes` when prompted to confirm.

    ```bash
    terraform apply
    ```

3. **Output**:

   After deployment, relevant resource details (e.g., App Service URLs) will be displayed. These details are also configured in the `outputs.tf` file for reference.

## Cleaning Up Resources

To remove all resources created by this Terraform configuration, use the following command:

```bash
terraform destroy
```

## Files in This Repository

- **main.tf**: Contains the primary Terraform configuration for Azure resources.
- **variables.tf**: Defines the input variables for the Terraform configuration.
- **outputs.tf**: Specifies output values like URLs for deployed services.
- **terraform.tfvars.example**: Example variable values that should be copied to `terraform.tfvars`.
- **README.md**: Documentation on using this Terraform configuration.
- **.gitignore**: Specifies files to ignore in the repository, such as `terraform.tfvars`.

## Additional Notes

- Ensure you have sufficient permissions on Azure to create resources.
- If using sensitive information in `terraform.tfvars`, do not commit it directly to the repository.
- For further customization, update the variables in `variables.tf` as needed.

## Troubleshooting

- **Authentication Issues**: If you encounter issues with Azure authentication, make sure to run `az login` and verify permissions.
- **Permission Errors**: Ensure your Azure account has permission to create resources like App Services and SQL databases.

---
