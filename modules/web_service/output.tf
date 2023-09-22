output "azurerm_network_interface" {
    value = azurerm_network_interface.web-net-interface.private_ip_address
}