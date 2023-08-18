terraform {
	backend "azurerm" {
		resource_group_name	= "ssc-ccoe-ea-innolab-rg-14"
		storage_account_name = "rg14tfstorageaccount"
		container_name 		= "rg14tfstatecontainer"
		key					= "lab.win-vm-iis.tfstate"

		use_msi = true
 		subscription_id = "0d96d832-09f1-4095-ba73-c796453c9a39"
		tenant_id = "3f0bdd77-1711-49bc-9b8c-6f2ba3e1c085"
	}
}

module "win-vm" {
	source = "../../azure-modules/win-vm"
  
	az_resource_group 	= "ssc-ccoe-ea-innolab-rg-14"
	az_subnet          	= "rg-14-default-01"
	az_vnet 			= "ssc-core-ea-innolab-rg-14-vnet"
	resource_group_location = "eastus2"

	vm_boot_storage_acct 	= "vmbootstorageacct"
	prefix 					= "rg14WinVM01"
	windows_vm_name 		= "rg14WinVmIIS01"
	vm_size					= "Standard_DS1_v2"
 
}
