terraform {
	backend "azurerm" {
		resource_group_name	= "ssc-ccoe-ea-innolab-rg-14"
		storage_account_name = "rg14tfstorageaccount"
		container_name 		= "rg14tfstatecontainer"
		key					= "lab.win-vm-iis.tfstate"

		use_msi = true
 		subscription_id = "0d96d832-09f1-4095-ba73-c796453c9a39"
		tenant_id = "3f0bdd77-1711-49bc-9b8c-6f2ba3e1c085"
	}
}

# Use existing subnet through data
#resource "azurerm_resource_group" "rg14" {
#  location = var.resource_group_location
#  name     = "ssc-ccoe-ea-innolab-rg-14"
#}

# Create virtual network / or use existing through data
#resource "azurerm_virtual_network" "my_terraform_network" {
#  name                = "ssc-core-ea-innolab-rg-14-vnet"
#  address_space       = ["172.20.0.0/23"]
#  location            = azurerm_resource_group.rg14.location
#  resource_group_name = azurerm_resource_group.rg14.name
#}

# Create subnet
#resource "azurerm_subnet" "reg14DefaultSubnet" {
#  name                 = "ssc-core-ea-innolab-14-subnet"
#  resource_group_name  = azurerm_resource_group.rg14.name
#  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
#  address_prefixes     = ["172.20.0.0/24"]
#}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "${var.prefix}-public-ip"
  location            = data.azurerm_resource_group.rg14.location
  resource_group_name = data.azurerm_resource_group.rg14.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "${var.prefix}-nsg"
  location            = data.azurerm_resource_group.rg14.location
  resource_group_name = data.azurerm_resource_group.rg14.name

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
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "${var.prefix}-nic"
  location            = data.azurerm_resource_group.rg14.location
  resource_group_name = data.azurerm_resource_group.rg14.name

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
  name                     = "vmbootstorageacct"
  location                 = data.azurerm_resource_group.rg14.location
  resource_group_name      = data.azurerm_resource_group.rg14.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.windows_vm_name}"
  admin_username        = "azureuser"
  admin_password        = random_password.password.result
  location              = data.azurerm_resource_group.rg14.location
  resource_group_name   = data.azurerm_resource_group.rg14.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

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

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "${var.prefix}-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = data.azurerm_resource_group.rg14.name
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

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}