terraform {
	backend "azurerm" {
		resource_group_name	= "ssc-ccoe-ea-innolab-rg-14"
		storage_account_name = "tfblobstateacct"
		container_name 		= "blobstatecontainer"
		key					= "lab.terraform-storeage-blob.tfstate"

		use_msi = true
 		subscription_id = "0d96d832-09f1-4095-ba73-c796453c9a39"
		tenant_id = "3f0bdd77-1711-49bc-9b8c-6f2ba3e1c085"
	}
}

module "storage" {
  source = "../../azure-modules/storage"
  
  az_resource_group 	= "ssc-ccoe-ea-innolab-rg-14"
  storage_account_name = "rg14tfstorageaccount"
  storage_container_name = "rg14tfstatecontainer"

}
