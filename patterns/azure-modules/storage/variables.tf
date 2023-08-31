variable "az_resource_group" {
  type        = string
  description = "Resource Group Within Subscription"
}

variable "storage_account_name" {
  type        = string
  description = "rg-14-tf-storageaccount"
}

variable "storage_container_name" {
  type        = string
  description = "rg-14-tfstate-container"
}
