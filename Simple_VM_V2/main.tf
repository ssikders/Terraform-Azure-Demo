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
}

# Virtual Network
resource "azurerm_virtual_network" "vm_vnet" {
  name                = var.vnetname
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.vm_resource_group.location
  resource_group_name = azurerm_resource_group.vm_resource_group.name
#  location            = azurerm_resource_group.vm_resource_group.location
#  resource_group_name = azurerm_resource_group.vm_resource_group.name
  depends_on = [
    azurerm_resource_group.vm_resource_group
  ]
}

# Subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.subnetname
  resource_group_name  = azurerm_resource_group.vm_resource_group.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = var.snet_address_space
  depends_on = [
    azurerm_virtual_network.vm_vnet
  ]
}

# Network Interface
resource "azurerm_network_interface" "vm_nic" {
  name                = "NIC-VM-01"
  location            = azurerm_resource_group.vm_resource_group.location
  resource_group_name = azurerm_resource_group.vm_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.vm_subnet
  ]
}

# Network Security Group
resource "azurerm_network_security_group" "vm_subnet_nsg" {
  name                = "NSG-SNET-PUBLIC"
  location            = azurerm_resource_group.vm_resource_group.location
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  depends_on = [
    azurerm_subnet.vm_subnet
  ]

  security_rule {
    name                       = "AllowRDPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.vm_subnet_nsg.id
  depends_on = [
    azurerm_network_security_group.vm_subnet_nsg
  ]
}

# Virtual Machine
resource "azurerm_windows_virtual_machine" "vm_01" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            = azurerm_resource_group.vm_resource_group.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  depends_on = [
    azurerm_subnet.vm_subnet,azurerm_subnet_network_security_group_association.vm_subnet_nsg_association
  ]
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

}