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
  name     = "RG-TF-DEMO"
  location = "West us2"

tags = {
    "environment" = "Dev"
    "CostCenter" = "IT"
    

  }
}

# Virtual Network
resource "azurerm_virtual_network" "vm_vnet" {
  name                = "VNET-DEMO"
  address_space       = ["10.10.0.0/21"]
  location            = azurerm_resource_group.vm_resource_group.location
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  depends_on = [
    azurerm_resource_group.vm_resource_group
  ]

tags = {
    "environment" = "Dev"
    "CostCenter" = "IT"
    

  }
}

# Subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = "SNET-PUBLIC"
  resource_group_name  = azurerm_resource_group.vm_resource_group.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = ["10.10.1.0/24"]
  depends_on = [
    azurerm_virtual_network.vm_vnet
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
    "environment" = "Dev"
    "CostCenter" = "IT"
    

  }
}

resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.vm_subnet_nsg.id
  depends_on = [
    azurerm_network_security_group.vm_subnet_nsg
  ]
}
