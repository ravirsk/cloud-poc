terraform {

	backend "azurerm" {
		storage_account_name = "tfblobstateacct"
		container_name 		= "blobstatecontainer"
		key					= "terraform-state-storeage-blob.tfstate"
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
    
  tags = {
    environment = "innolab-rg-14"
  }
}

