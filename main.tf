terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# resource group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.infix}-wordpress-${var.env}"
  location = "West Europe"

  tags = {
    "managed_by" = "terraform"
  }
}