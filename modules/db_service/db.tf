resource "azurerm_mssql_server" "db_server" {
  name                         = "appserver6008089"
  resource_group_name          = var.resource_group
  location                     = var.location  
  version             = "12.0"
  administrator_login          = var.sqladminuser
  administrator_login_password = var.sqladminpw
}

resource "azurerm_mssql_database" "app_db" {
  name                = "appdb"
  server_id         = azurerm_mssql_server.db_server.id
  max_size_gb    = 2
  sku_name       = "Basic"

  depends_on = [
     azurerm_mssql_server.db_server
   ]
}

resource "azurerm_mssql_firewall_rule" "app_server_firewall_rule" {
  name                = "app-server-firewall-rule"
  server_id        = azurerm_mssql_server.db_server.id
  start_ip_address    = var.admin-mgt-ip
  end_ip_address      = var.admin-mgt-ip
}