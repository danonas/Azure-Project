
# Define the Terraform output to return the MySQL instance hostname and database name:
output "mysql_hostname" {
  value = azurerm_mysql_server.azureproject_server.fqdn
}

output "mysql_database_name" {
  value = azurerm_mysql_database.wordpress_db.name
}