resource "azurerm_public_ip" "lb-ip" {
  name                = "PublicIPForLB"
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

resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb-ip.id
  }

  depends_on = [ azurerm_public_ip.lb-ip ]

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}

resource "azurerm_lb_backend_address_pool" "BackEndAddressPool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"

  depends_on = [ azurerm_lb.lb ]

}

resource "azurerm_lb_backend_address_pool_address" "address-pool" {
  name                    = "address-pool"
  backend_address_pool_id = azurerm_lb_backend_address_pool.BackEndAddressPool.id
  virtual_network_id      = var.virtual_network_id
  ip_address              = azurerm_network_interface.web-net-interface.private_ip_address

}

resource "azurerm_lb_rule" "rule1" {
  name                        = "http-rule-1"
  loadbalancer_id             = azurerm_lb.lb.id
  frontend_port               = 80
  backend_port                = 80
  protocol                    = "Tcp"
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.BackEndAddressPool.id ]

}