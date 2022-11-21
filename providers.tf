terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }

    backend "azurerm" {
    resource_group_name  = "infra-storage-rg"
    storage_account_name = "infrastoraged103"
    container_name       = "infrastoragetfstate"
    key                  = "lab.tfazurmazurecomputegallery.tfstate"
  }
}

provider "azurerm" {
  features {}
}