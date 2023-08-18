variable "resource_group_location" {
  type        = string
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "az_resource_group" {
  type        = string
  description = "Resource Group Within Subscription"
}

variable "az_subnet" {
  type        = string
  description = "Subnet Within Vnet
}

variable "az_vnet" {
  type        = string
  description = "Vnet Within Resource Group"
}

variable "vm_boot_storage_acct" {
  type        = string
  description = "To store boot diagnostics"
}

variable "prefix" {
  type        = string
  description = "Prefix of the resource name"
}

variable "windows_vm_name" {
  type        = string
  description = "Vm Name"
}

variable "vm_size" {
  type        = string
  description = "Vm Size"
  default = "Standard_DS1_v2"
}
