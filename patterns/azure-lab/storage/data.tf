data "azurerm_resource_group"  "rg14" {
	name = "ssc-core-ea-innolab-rg-14"
} 

data "azurerm_subnet" "example" {
  name                 = "rg-14-default-01"
  virtual_network_name = "ssc-core-ea-innolab-rg-14-vnet"
  resource_group_name  = "ssc-core-ea-innolab-rg-14"
}
