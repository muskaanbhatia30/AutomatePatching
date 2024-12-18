terraform {
  backend "azurerm" {
    resource_group_name  = "<resourcegroupname>"
    storage_account_name = "<storageaccountname>"
    container_name       = "<containername>"
    key                  = "terraform.tfstate"
  }
}