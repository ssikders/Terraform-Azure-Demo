
variable "rgname" {
  type        = string
  description = "Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure location of network components"
  default     = "westus2"
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

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