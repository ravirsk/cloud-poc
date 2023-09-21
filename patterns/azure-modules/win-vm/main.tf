
# Use existing subnet through data
#resource "azurerm_resource_group" "usecase_rg" {
#  location = var.resource_group_location
#  name     = "ssc-ccoe-ea-innolab-rg-14"
#}

# Create virtual network / or use existing through data
#resource "azurerm_virtual_network" "my_terraform_network" {
#  name                = "ssc-core-ea-innolab-rg-14-vnet"
#  address_space       = ["172.20.0.0/23"]
#  location            = azurerm_resource_group.usecase_rg.location
#  resource_group_name = azurerm_resource_group.usecase_rg.name
#}

# Create subnet
#resource "azurerm_subnet" "reg14DefaultSubnet" {
#  name                 = "ssc-core-ea-innolab-14-subnet"
#  resource_group_name  = azurerm_resource_group.usecase_rg.name
#  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
#  address_prefixes     = ["172.20.0.0/24"]
#}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "${var.prefix}-public-ip"
  location            = data.azurerm_resource_group.usecase_rg.location
  resource_group_name = data.azurerm_resource_group.usecase_rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "${var.prefix}-nsg"
  location            = data.azurerm_resource_group.usecase_rg.location
  resource_group_name = data.azurerm_resource_group.usecase_rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web1"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "web2"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "${var.prefix}-nic"
  location            = data.azurerm_resource_group.usecase_rg.location
  resource_group_name = data.azurerm_resource_group.usecase_rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = data.azurerm_subnet.reg14DefaultSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "my_storage_account" {
  name                     = var.vm_boot_storage_acct
  location                 = data.azurerm_resource_group.usecase_rg.location
  resource_group_name      = data.azurerm_resource_group.usecase_rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create virtual machine
#random_password.password.result
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.windows_vm_name}"
  admin_username        = "azureuser"
  admin_password        = "Admin@123"
  location              = data.azurerm_resource_group.usecase_rg.location
  resource_group_name   = data.azurerm_resource_group.usecase_rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = var.vm_size

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }


  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}

#"commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
#-Domain_DNSName ${data.template_file.USERDATA.vars.Domain_DNSName}
# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
	name                       = "${var.prefix}-wsi"
	virtual_machine_id         = azurerm_windows_virtual_machine.main.id
	publisher                 = "Microsoft.Compute"
	#publisher                 = "Microsoft.Powershell"
	type                      = "CustomScriptExtension"
	#type                      = "DSC"	
	type_handler_version       = "1.8"
	auto_upgrade_minor_version = true

	settings = <<SETTINGS
    {

	  "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.USERDATA.rendered)}')) | Out-File -filepath user_data.ps1\" && powershell -ExecutionPolicy Unrestricted -File user_data.ps1"

    }
	SETTINGS
	tags = {
		environment = "PreDEV"
	}
	timeouts {
		create =  "1h30m"
		update =  "1h30m"
		delete =  "20m"
	}

}

#Variable input for the user_data.ps1 script
data "template_file" "USERDATA" {
    template = "${file("user_data.ps1")}"
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = data.azurerm_resource_group.usecase_rg.name
  }

  byte_length = 8
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

#resource "random_pet" "prefix" {
#  prefix = var.prefix
#  length = 1
#}