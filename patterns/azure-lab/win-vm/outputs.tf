output "public_ip_address" {
  value = module.win-vm.public_ip_address
}

output "admin_password" {
  sensitive = false
  value     = module.win-vm..admin_password
}

output "subnet_id" {
  value = module.win-vm.subnet_id
}