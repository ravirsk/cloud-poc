terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  
  use_msi = true
  subscription_id = "0d96d832-09f1-4095-ba73-c796453c9a39"
  tenant_id = "3f0bdd77-1711-49bc-9b8c-6f2ba3e1c085"
  
  #client_id = "4433537d7-1afe-415f-a6c6-e6d60741997e"
  # cleint id of MI es eks agent pool
  #client_id = "f46e2ba7-84ff-49ae-a4e7-cbe4964685db"
  #client id for MI harnessdelegateid
}