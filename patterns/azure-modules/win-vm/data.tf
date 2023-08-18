data "azurerm_resource_group"  "usecase_rg" {
	name = var.az_resource_group
	#name = "ssc-ccoe-ea-innolab-rg-14"
} 

data "azurerm_subnet" "reg14DefaultSubnet" {
  name                 = var.az_subnet
  virtual_network_name = var.az_vnet
  resource_group_name  = var.az_resource_group
}