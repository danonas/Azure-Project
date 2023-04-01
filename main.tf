resource "azurerm_resource_group" "wordpress" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "wordpress" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
}

resource "azurerm_subnet" "wordpress" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "wordpress2" {
  name                 = "internal2"
  address_prefixes     = ["10.0.3.0/24"]
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
}

resource "azurerm_subnet" "wordpress3" {
  name                 = "internal3"
  address_prefixes     = ["10.0.4.0/24"]
  resource_group_name  = azurerm_resource_group.wordpress.name
  virtual_network_name = azurerm_virtual_network.wordpress.name
}
