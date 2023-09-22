# Steps to Reproduce Azure Infrastructure Setup

## Prerequisites:
1. Azure CLI is installed and configured with appropriate Azure credentials.
2. Terraform is installed on your local machine.

## Step 1: Set up the State Store
1. Navigate to the `0-tfstate` directory.

2. Initialize the Terraform configuration:
   ```bash
   terraform init
1. Review and modify the `main.tf` file as needed, including the Azure Blob Storage container and Azure Storage Account settings.

1. Create the backend resources for storing Terraform state:
```
terraform apply
```
1. Note down the Azure Blob Storage container name and Azure Storage Account name as they will be required in the main infrastructure configuration.

## Step 2: Provision the Infrastructure
1. Navigate to the root directory.
1. Initialize the Terraform configuration:
```
terraform init
```
1. Review and modify the `main.tf`, `vars.tf`, `terraform.tfvars` and `provider.tf` files to ensure all variables are correctly set, including the state store settings obtained from Step 1.
Review and modify the Terraform configuration files within the modules (e.g., `network`, `security-group`, `web_service`, `app_service`, `db_service`) to match your desired infrastructure settings based on your `main.tf` configuration.
1. Create an execution plan to preview the changes:
```
terraform plan
```
1. Confirm that the execution plan matches your expectations.

1. Apply the Terraform configuration to create the infrastructure:
```
terraform apply
```

## Step 3: Access and Test the Infrastructure
1. Wait for Terraform to finish provisioning the infrastructure. This may take several minutes.
1. After successful provisioning, check the Terraform output for important information, such as instance IPs, endpoint URLs, and other relevant details.
1. Access the infrastructure components as needed, following the documented architecture:
  - Application Resources: Access the application resources created by the app_service module.
  - Database: Connect to the database securely via the Azure SQL Database instance.
  - Virtual Machine Scale Set (VMSS): Access and manage VMSS resources as needed.
  - Bastion Host: Use the Bastion Host for secure access to private resources within Azure Virtual Network.
1. Verify the functionality and security of the infrastructure.

## Step 4: Cleanup (Optional)

If you want to tear down the infrastructure:
1. Navigate to the root directory.
1. Run the following command to destroy the resources:
```
terraform destroy
```
1. Confirm the destruction of resources when prompted.

## Step 5: State Store Cleanup (Optional)

If you no longer need the state store resources:
1. Navigate to the `0-tfstate` directory.
1. Run the following command to destroy the backend resources:
```
terraform destroy
```
1. Confirm the destruction of backend resources when prompted.

Following these steps will allow you to reproduce the infrastructure setup using Terraform. Be cautious when performing destroy operations to avoid accidental data loss or resource removal.