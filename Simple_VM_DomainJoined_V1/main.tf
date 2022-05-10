# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    
  }
}

# Provider Block
provider "azurerm" {
 features {}          
}

# Resource Group
resource "azurerm_resource_group" "vm_resource_group" {
  name     = "RG-VM-DEMO"
  location = "West us2"

# Tags (Optional)
  tags = {
      "Application Name" = "Dev RG"
      "Owner" = "IT Operations Team"
      "Business Unit" = "IT"
      "Subscription" = "IT Dev"
      "Platform" = "Azure"
      "Environment" = "Dev"
      "Department" = "IT"
      "CostCentre" = "IT"
  }
}
# Data Module (Reference to Exisiting Networking)
data "azurerm_subnet" "vmsubnet" {
  name                 = "SNET-INF"
  virtual_network_name = "VNET-WEST-US2-CORE"
  resource_group_name  = "RG-WEST-US2-CORE"
}

# Network interface
resource "azurerm_network_interface" "vm_nic" {
  name                      = "NIC-VM-01"
  # location                  = azurerm_resource_group.myrg.location
  # resource_group_name       = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.vm_resource_group.location
  resource_group_name = azurerm_resource_group.vm_resource_group.name

  ip_configuration {
    name                          = "Nicconfig-Internal"
    subnet_id                     = data.azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "vm_01" {
  name                = "VM-01"
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            = azurerm_resource_group.vm_resource_group.location
  size                = "Standard_D2s_v5"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  # Tags (Optional)
  tags = {
      "Application Name" = "Dev VM"
      "Owner" = "IT Operations Team"
      "Business Unit" = "IT"
      "Subscription" = "IT Dev"
      "Platform" = "Azure"
      "Environment" = "Dev"
      "Department" = "IT"
      "CostCentre" = "IT"
  }

}


# Domain Join
module "domain-join" {
source  = "kumarvna/domain-join/azurerm"
version = "1.1.0"

  virtual_machine_id        = azurerm_windows_virtual_machine.vm_01.id
  active_directory_domain   = "cloudchakra.co.uk"
  active_directory_username = "OpsAdmin"
  active_directory_password = "Changeme2022##"

}
