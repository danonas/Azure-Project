variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  default     = "AzureProject" #Default Resoucre Group name
  # nullable    = false                           #Enter the value on the console
}

variable "vnet_location" {
  description = "The location of the vnet to create."
  type        = string
  default     = "Central US" #Default VNet location
  # nullable    = false                           #Enter the value on the console
}

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
  default     = "AzureProject" #Default VNET name
  # nullable    = false                           #Enter the value on the console
}


variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the VNet."
  default     = ["10.0.0.0/16"]
}
