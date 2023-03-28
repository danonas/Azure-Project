
#Define the resource group that will contain your MySQL instance:
resource "azurerm_resource_group" "mysql_rg" {
  name     = "mysql-rg"
  location = "eastus"
}
#Define the Azure MySQL server and specify the version and location:
resource "azurerm_mysql_server" "azureproject_server" {
  name                = "mysql-server"
  location            = azurerm_resource_group.mysql_rg.location
  resource_group_name = azurerm_resource_group.mysql_rg.name
  sku_name            = "B_Gen5_2"
  version             = "5.7"
  storage_mb          = 5120
  administrator_login = "mysqladmin"
  administrator_login_password = "P@ssword1234!"
}
#Create a firewall rule to allow traffic from your application to your MySQL instance:
resource "azurerm_mysql_firewall_rule" "azureproject_fw" {
  name                = "mysql-fw-rule"
  resource_group_name = azurerm_resource_group.mysql_rg.name
  server_name         = azurerm_mysql_server.azureproject_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
#Create a MySQL database:
resource "azurerm_mysql_database" "wordpress_db" {
  name                = "wordpress-db"
  resource_group_name = azurerm_resource_group.mysql_rg.name
  server_name         = azurerm_azureproject.azureproject_server.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}
