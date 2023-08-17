variable "resource_group_location" {
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default     = "ssc-ccoe-ea-innolab-rg-14"
  description = "ccoe rg name"
}

variable "storage_account_name" {
  default     = "rg14tfstorageaccount"
  description = "rg-14-tf-storageaccount"
}

variable "storage_container_name" {
  default     = "rg14tfstatecontainer"
  description = "rg-14-tfstate-container"
}

variable "prefix" {
  type        = string
  default     = "rg14WinVmIIS"
  description = "Prefix of the resource name"
}

variable "windows_vm_name" {
  type        = string
  default     = "rg14WinVmIIS"
  description = "Vm Name"
}