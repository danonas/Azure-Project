resource "azurerm_resource_group" "res_Gr_Ex" {
  name     = "${var.resource_group_name}_ResourceGr"
  location = var.vnet_location

    tags = {
            DecDevop22 = "AzureProject"
    }
}

resource "azurerm_network_security_group" "vnet" {
  name                = "${var.resource_group_name}_SecurityGr"
  location            = azurerm_resource_group.res_Gr_Ex.location
  resource_group_name = azurerm_resource_group.res_Gr_Ex.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}_VNet"
  location            = azurerm_resource_group.res_Gr_Ex.location
  resource_group_name = azurerm_resource_group.res_Gr_Ex.name
  address_space       = var.address_space
    dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.vnet.id
  }

    subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }

  tags = {
    DecDevop22 = "AzureProject"
  }
}
