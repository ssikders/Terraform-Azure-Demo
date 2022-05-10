
variable "rgname" {
  type        = string
  description = "Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure location of network components"
  default     = "westus2"
}

# NEW Section-Delete if Any Error Encounterd
variable "vnetname" {
  type = string
  description = "The name of the Vnet"
}

variable "subnetname" {
  type = string
  description = "The name of the Subnet"
}

variable "vnet_address_space" {
  type        = list(any)
  description = "Address space for Virtual Network"
  default     = ["10.10.0.0/16"]
}

variable "snet_address_space" {
  type        = list(any)
  description = "Address space for Subnet"
  default     = ["10.10.1.0/24"]
}

variable "admin_username" {
    type = string
    description = "Administrator username for server"
}

variable "admin_password" {
    type = string
    description = "Administrator password for server"
    sensitive   = true
}


variable "storage_account_type" { 
    type = map
    description = "Disk type Premium in Primary location Standard in DR location"

    default = {
        westus2 = "Premium_LRS"
        eastus = "Standard_LRS"
    }
}

variable "vmname" {
  type = string
  description = "The name of the VM"
}

variable "vm_size" {
    type = string
    description = "Size of VM"
    default = "Standard_B1s"
}

variable "os" {
    description = "OS image to deploy"
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
  })
}