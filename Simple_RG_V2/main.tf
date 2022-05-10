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

  tags = var.tags
}
