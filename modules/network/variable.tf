variable "rg_name" {}
variable "location" {
  default = "West Europe"
}
variable "bastioncidr" {}
variable "resource_group" {}
variable "vnetcidr" {}
variable "websubnetcidr" {}
variable "appsubnetcidr" {}
variable "dbsubnetcidr" {}
variable "environment" {}
variable "project" {}
variable "createdby" {}