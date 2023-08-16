# Create storage account
resource "azurerm_storage_account" "astga" {
  name                     = var.storage_account_name
  location                 = data.azurerm_resource_group.rg14.location
  resource_group_name      = data.azurerm_resource_group.rg14.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

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

resource "azurerm_storage_blob" "rg-14-tfstateblob" {
  name                   = "rg-14-tfstate"
  storage_account_name   = azurerm_storage_account.astga.name
  storage_container_name = azurerm_storage_container.astc.name
  type                   = "Block"
  #source                 = "some-local-file.zip"
  
  tags = {
    environment = "innolab-rg-14"
  }
}