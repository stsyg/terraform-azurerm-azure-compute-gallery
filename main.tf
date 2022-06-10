# Terraform Cloud configuration
terraform {
        backend "remote" {
            organization = "The38Dev"
            workspaces {
                name = "AzureComputeGallery"
            }
        }
}

# Creates resource group
resource "azurerm_resource_group" "acgrg" {
  location = var.deploy_location
  name     = var.rg_shared_name
}

# Generates a random string (consisting of four characters)
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}


# Creates Azure Compute Gallery (formerly Shared Image Gallery)
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
resource "azurerm_shared_image_gallery" "acg" {
  name                = "acg${random_string.random.id}"
  resource_group_name = azurerm_resource_group.acgrg.name
  location            = azurerm_resource_group.acgrg.location
  description         = "VM images"

  tags = {
    Environment = "Dev"
    App         = "Azure Compute Gallery"
  }
}

# Creates image definition
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
resource "azurerm_shared_image" "example" {
  name                = "vmss-image"
  gallery_name        = azurerm_shared_image_gallery.acg.name
  resource_group_name = azurerm_resource_group.acgrg.name
  location            = azurerm_resource_group.acgrg.location
  os_type             = "Windows"

  identifier {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "office-365"
    sku       = "20h2-evd-o365pp"
  }
}