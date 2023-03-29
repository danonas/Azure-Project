output "VNet_location" {
  description = "The location of the newly created VNet"
  value       = azurerm_resource_group.res_Gr_Ex.location
}

output "VNet_name" {
  description = "The Name of the newly created VNet"
  value       = azurerm_virtual_network.vnet.name
  # value       = azurerm_resource_group.res_Gr_Ex.name
}

output "ResourceGrs_name" {
  description = "The Name of the Security Group"
  value       = var.resource_group_name
}

output "SecurityGr_name" {
  description = "The Name of the Security Group"
  value       = azurerm_network_security_group.vnet.name
}