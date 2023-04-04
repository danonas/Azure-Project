resource "azurerm_resource_group" "wordpress" {
  name     = "example-resources"
  location = var.location
}

