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
  name     = var.rgname
  location = var.location

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
  name                 = var.subnetname
  virtual_network_name = var.vnetname
  resource_group_name  = var.vnetrg
}

# Network interface
resource "azurerm_network_interface" "vm_nic" {
  name                      = "NIC-${var.vmname}"
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
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            = azurerm_resource_group.vm_resource_group.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.os.publisher
    offer     = var.os.offer
    sku       = var.os.sku
    version   = var.os.version
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
