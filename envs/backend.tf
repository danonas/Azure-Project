terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-eastus"
    storage_account_name = "cs21003200285d9a13c"
    container_name       = "tfstate"
    key                  = "Azure-Project.terraform.tfstate"
  }
}