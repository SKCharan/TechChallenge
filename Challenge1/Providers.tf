terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.8.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "XXXXX-XXXXX-XXXXXX-XXXXXX"
  client_id       = "XXXXX-XXXXX-XXXXXX-XXXXXX"
  client_secret   = "XXXXXXXXXxxXXXxxxXXXXXXXX"
  tenant_id       = "XXXXXXxxxxxxXXXXxxxxXXXXX"
  features {}
}