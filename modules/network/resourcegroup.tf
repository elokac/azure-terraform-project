resource "azurerm_resource_group" "azure-rg" {
  name     = var.rg_name
  location = var.location

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}