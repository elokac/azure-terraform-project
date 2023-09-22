module "network" {
  source         = "./modules/network"
  rg_name        = var.rg_name
  location       = var.location
  bastioncidr    = var.bastioncidr
  resource_group = var.rg_name
  vnetcidr       = var.vnetcidr
  websubnetcidr  = var.websubnetcidr
  appsubnetcidr  = var.appsubnetcidr
  dbsubnetcidr   = var.dbsubnetcidr
  project        = var.project
  createdby      = var.createdby
  environment    = var.environment
}

module "security-group" {
  source         = "./modules/security-group"
  location       = module.network.location_id
  resource_group = module.network.resource_group_name
  web_subnet_id  = module.network.websubnet_id
  app_subnet_id  = module.network.appsubnet_id
  db_subnet_id   = module.network.dbsubnet_id
  project        = var.project
  createdby      = var.createdby
  environment    = var.environment
}

module "web_service" {
  source             = "./modules/web_service"
  location           = module.network.location_id
  resource_group     = module.network.resource_group_name
  web_subnet_id      = module.network.websubnet_id
  virtual_network_id = module.network.network_id
  web_host_name   = var.web_host_name
  web_username    = var.web_username
  web_os_password = var.web_os_password
  project         = var.project
  createdby       = var.createdby
  environment     = var.environment

}

# module "app_service" {
#   source             = "./modules/app_service"
#   location           = module.network.location_id
#   resource_group     = module.network.resource_group_name
#   virtual_network_id = module.network.network_id
#   appsubnet_id       = module.network.appsubnet_id
#   app_username       = var.app_username
#   app_admin_password = var.app_admin_password
#   project            = var.project
#   createdby          = var.createdby
#   environment        = var.environment
# }

# module "db_service" {
#   source           = "./modules/db_service"
#   location         = module.network.location_id
#   resource_group   = module.network.resource_group_name
#   sqladminuser      = var.sqladminuser
#   sqladminpw       = var.sqladminpw
#   admin-mgt-ip     = var.admin-mgt-ip
# }