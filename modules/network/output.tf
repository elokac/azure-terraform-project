output "network_name" {
  value = azurerm_virtual_network.vnet.name
  description = "Name of the Virtual network"
}

output "network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "websubnet_id" {
  value = azurerm_subnet.web-subnet.id
  description = "Id of websubnet in the network"
}

output "appsubnet_id" {
  value = azurerm_subnet.app-subnet.id
  description = "Id of appsubnet in the network"
}

output "dbsubnet_id" {
  value = azurerm_subnet.db-subnet.id
  description = "Id of dbsubnet in the network"
}
output "resource_group_name" {
    value = azurerm_resource_group.azure-rg.name
    description = "Name of the resource group."
}

output "location_id" {
    value = azurerm_resource_group.azure-rg.location
    description = "Location id of the resource group"
}