resource "azurerm_public_ip" "wordpress" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "wordpress" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.wordpress.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.wordpress.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.wordpress.id
  name                           = "httpd"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.wordpress.id
}

resource "azurerm_lb_rule" "wordpress" {
  loadbalancer_id                = azurerm_lb.wordpress.id
  name                           = "ssh"
  protocol                       = "Tcp"
  frontend_port                  = var.ssh_port
  backend_port                   = var.ssh_port
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id]
  probe_id                       = azurerm_lb_probe.wordpress.id
}

resource "azurerm_lb_probe" "wordpress" {
  loadbalancer_id     = azurerm_lb.wordpress.id
  name                = "ssh-running-probe"
  port                = var.application_port 
}