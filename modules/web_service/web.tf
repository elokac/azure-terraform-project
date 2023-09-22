resource "azurerm_availability_set" "web_availabilty_set" {
  name                = "web_availabilty_set"
  location            = var.location
  resource_group_name = var.resource_group
  platform_fault_domain_count = 2
  platform_update_domain_count = 2

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}

resource "azurerm_public_ip" "web-ip" {
  name                = "PublicIPForWeb"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard" 

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}

resource "azurerm_network_interface" "web-net-interface" {
    name = "web-network"
    resource_group_name = var.resource_group
    location = var.location

    ip_configuration{
        name = "web-webserver"
        subnet_id = var.web_subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.web-ip.id
    }

    tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}

resource "azurerm_virtual_machine" "web-vm" {
  name = "web-vm"
  location = var.location
  resource_group_name = var.resource_group
  network_interface_ids = [ azurerm_network_interface.web-net-interface.id ]
  availability_set_id = azurerm_availability_set.web_availabilty_set.id
  vm_size = "Standard_D2s_v3"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name = "web-disk"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = var.web_host_name
    admin_username = var.web_username
    admin_password = var.web_os_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }

}

resource "azurerm_virtual_machine_extension" "install-nginx" {
  name                 = "install-nginx"
  virtual_machine_id   = azurerm_virtual_machine.web-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROTECTED_SETTINGS
  {
      "script": "${base64encode(file("${path.module}/apt.sh"))}"
  }
  PROTECTED_SETTINGS

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}