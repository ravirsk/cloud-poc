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

# Create storage account
resource "azurerm_storage_account" "astga" {
  name                     = var.storage_account_name
  location                 = data.azurerm_resource_group.rg14.location
  resource_group_name      = data.azurerm_resource_group.rg14.name
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "innolab-rg-14"
  }
}

resource "azurerm_storage_container" "astc" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.astga.name
  container_access_type = "private"
    

}

