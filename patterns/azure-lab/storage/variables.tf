variable "resource_group_location" {
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default     = "ssc-ccoe-ea-innolab-rg-14"
  description = "ccoe rg name"
}

variable "storage_account_name" {
  default     = "rg-14-tf-storageaccount"
  description = "rg-14-tf-storageaccount"
}

variable "storage_container_name" {
  default     = "rg-14-tfstate-container"
  description = "rg-14-tfstate-container"
}

variable "blob_name" {
  default     = "rg-14-tfstate"
  description = "rg-14-tfstate"
}
