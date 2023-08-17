data "azurerm_resource_group"  "rg14" {
	#name = var.resource_group_name.name
	name = "ssc-ccoe-ea-innolab-rg-14"
} 

data "azurerm_subnet" "reg14DefaultSubnet" {
  name                 = "rg-14-default-01"
  virtual_network_name = "ssc-core-ea-innolab-rg-14-vnet"
  resource_group_name  = "ssc-ccoe-ea-innolab-rg-14"
}

output "subnet_id" {
  value = data.azurerm_subnet.reg14DefaultSubnet.id
}