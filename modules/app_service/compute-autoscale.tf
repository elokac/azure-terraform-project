resource "azurerm_availability_set" "app_availabilty_set" {
  name                = "app_availabilty_set"
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

resource "azurerm_linux_virtual_machine_scale_set" "vm-scale-set" {
  name                = "app-vmss"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Standard_D2s_v3"
  instances           = 2  # Specify the number of instances you want in each zone
  
  admin_username      = var.app_username
  admin_password = var.app_admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "network_interface"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.appsubnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.BackEndAddressPool.id]
    }
  }

  
  zones = [1]  # Multiple zones can be added, up to 3. zones = [1, 2, 3]

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}


resource "azurerm_monitor_autoscale_setting" "autoscale_monitor" {
  name                = "myAutoscaleSetting"
  resource_group_name = var.resource_group
  location            = var.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vm-scale-set.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vm-scale-set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vm-scale-set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  predictive {
    scale_mode      = "Enabled"
    look_ahead_time = "PT5M"
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["elokachiejina@gmail.com"]
    }
  }

  tags = {
    project = var.project
    environment = var.environment
    createdby = var.createdby
  }
}