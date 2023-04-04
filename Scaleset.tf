resource "azurerm_linux_virtual_machine_scale_set" "wordpress" {
  name                            = "vmscaleset"
  resource_group_name             = azurerm_resource_group.wordpress.name
  location                        = azurerm_resource_group.wordpress.location
  sku                             = "Standard_F4"
  instances                       = 1
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  user_data                       = filebase64("customdata.tpl") #every instance will install the apache and other staff. If one of web server goes down, the other web serves will be available 

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS" # Updated from 16 to 18
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name = "NetworkInterface"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.wordpress.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id] # Every VM thats craeted within Scale set , will get IP configuration that assigns it to that load balancer's back-end pool that we create
    }
  }

  network_interface {
    name = "NetworkInterface2"

    ip_configuration {
      name                                   = "internal"
      primary                                = false
      subnet_id                              = azurerm_subnet.wordpress2.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id] 
    }
  }

  network_interface {
    name = "NetworkInterface3"

    ip_configuration {
      name                                   = "internal"
      primary                                = false
      subnet_id                              = azurerm_subnet.wordpress3.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id] 
    }
  }

}