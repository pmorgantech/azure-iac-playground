terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.62.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }

  required_version = "1.14.3"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  storage_use_azuread             = true
  features {}
}