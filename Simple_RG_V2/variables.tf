
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
