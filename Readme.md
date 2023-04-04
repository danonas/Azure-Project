# Terraform Project on Azure (Team 2)

Use Terraform to build a three-tier application on Azure to host WordPress.


## Prerequisites:

* [Terraform](https://www.terraform.io) 
* Azure subscription: If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/en-us/free)
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


* Login to your Azure Cloud Provider  
* Select Cost Management/ Billing Account under the hamburger menu 
* Create a Billing Account


## Reusability 
  This project is partially reusably. To make modifications to variable see <b>Variables.tf</b> file and set the desired values.


# Github 

Go to Github and create a repo for your project, dont forget to add .gitignore and README.md files 

This is group project, so add your collaborators into your project with their github names 

After adding them as collaborator, users will be able to add their SSH public keys to github successfully 

Users will be able to clone the project into their locals with git clone command 


# Documentation for .tf files

# RESOURCE GROUP + PROVIDER 
Create a resource group. 
Configure the Microsoft Azure Provider. 
Steps: 
Create Azure-Project folder with .gitignore and README.md files
Under Azure-Project Create a file  provider.tf and RG.tf 
Use resource "azurerm_resource_group" "wordpress"  to create resource group
Use resource provider "azurerm" features to create provider resource

```
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

```


# VARIABLE.TF  
In this project we used variables to make our code more dynamic. Create a file variables.tf 
```
variable mysql
variable "database_admin_login" {
  default = "mysqladminun"
}

variable "database_admin_password" {
  default = "W0rdpr3ss@p4ss"
}

#Mysql database name
variable "dbname" {
  default = "db-wordpress"
}

#lb http rule and lb_probe
variable "application_port" {
  default = 80
}


variable "ssh_port" {
  default = 22
}

#VM username and password
variable "admin_username" {
  default = "wordpress"
}

variable "admin_password" {
  description = "Default password for admin account"
  default     = "W0rdpr3ss@p4ss"
}




```

 

# Vnet 
Next we created vnet.tf configuration file. Vnet is the Virtual Network which will include 3 Subnets. 

Steps:

```
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

```


# LB.tf & Scaleset.tf  

When setting up an Azure Load Balancer, you configure a health probe that your load balancer can use to determine if your instance is healthy.
Use resource "resource "azurerm_lb_rule" "wordpress" to create load balancer Rule 

The backend pool is a critical component of the load balancer. The backend pool defines the group of resources that will serve traffic for a given load-balancing rule.
Use resource https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool to create backend pool . 
Also we are allocating PublicIP for our load balancer , that IP address we will use to run the webpage (wordpress) on the browser. To create Scale Set use resource
"azurerm_linux_virtual_machine_scale_set" , we attached 3 subnets in our Scale set


```
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



```

 
# DATABASE.TF  

We used Azure Database for MySQL it's a fully managed database service, which means that Microsoft automates the management and maintenance of your infrastructure and database server, including routine updates, backups and security.
Azure Database for MySQL is easy to set up, operate, and scale.
Use resource https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server to create Database. 

```
# Create MySQL Server

resource "azurerm_mysql_server" "wordpress" {
  name                = "team2mysql-wordpress"
  location            = azurerm_resource_group.wordpress.location
  resource_group_name = azurerm_resource_group.wordpress.name

  administrator_login          = var.database_admin_login
  administrator_login_password = var.database_admin_password

  sku_name   = "GP_Gen5_4"
  storage_mb = "102400"
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  #ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "wordpress" {
  name                = var.dbname
  resource_group_name = azurerm_resource_group.wordpress.name
  server_name         = azurerm_mysql_server.wordpress.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "wordpress" {
  name                = "wordpress-mysql-firewall-rule"
  resource_group_name = azurerm_resource_group.wordpress.name
  server_name         = azurerm_mysql_server.wordpress.name
  start_ip_address    = azurerm_public_ip.wordpress.ip_address
  end_ip_address      = azurerm_public_ip.wordpress.ip_address
}

data "azurerm_mysql_server" "wordpress" {
  name                = azurerm_mysql_server.wordpress.name
  resource_group_name = azurerm_resource_group.wordpress.name
}

  


#CUTOMDATA.TPL
Customdata installing httpd and wordpress to our instances so in siple terms with using customdata(userdata) for BOOTSTRAPING
#!/bin/bash

sudo apt-get update 
sudo apt-get install apache2 -y
sudo apt-get install php libapache2-mod-php -y
sudo systemctl restart apache2
sudo apt-get install wget -y
wget https://wordpress.org/latest.tar.gz
sudo tar -xf latest.tar.gz -C /var/www/html/
sudo mv /var/www/html/wordpress/* /var/www/html/
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed 's/database_name_here/db-wordpress/g' /var/www/html/wp-config.php -i
sudo sed 's/username_here/mysqladminun@team2mysql-wordpress/g' /var/www/html/wp-config.php -i
sudo sed 's/password_here/W0rdpr3ss@p4ss/g' /var/www/html/wp-config.php -i
sudo sed 's/localhost/team2mysql-wordpress.mysql.database.azure.com/g' /var/www/html/wp-config.php -i
DBNAME="db-wordpress"
sudo apt-get install mysql-server -y
sudo apt-get install php-mysql -y
sudo ufw allow in "Apache Full"
sudo chown -R www-data:www-data /var/www/html/
sudo rm -f /var/www/html/index.html 
sudo systemctl restart apache2

```
