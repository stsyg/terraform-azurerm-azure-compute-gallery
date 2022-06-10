# Terraform Cloud configuration
terraform {
        backend "remote" {
            organization = "The38Dev"
            workspaces {
                name = "AzureComputeGallery"
            }
        }
}

# Create resource group
resource "azurerm_resource_group" "acgrg" {
  location = var.deploy_location
  name     = var.rg_shared_name

    tags = {
    environment = "Dev"
    app         = "Azure Compute Gallery"
    provisioner = "Terraform"
  }
}

# Generate a random string (consisting of four characters)
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "random" {
  length  = 4
  upper   = false
  special = false
}


# Create Azure Compute Gallery (formerly Shared Image Gallery)
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
resource "azurerm_shared_image_gallery" "acg" {
  name                = "image_gallery_${random_string.random.id}"
  resource_group_name = azurerm_resource_group.acgrg.name
  location            = azurerm_resource_group.acgrg.location
  description         = "VM images"

  tags = {
    environment = "Dev"
    app         = "Azure Compute Gallery"
    provisioner = "Terraform"
  }
}

# # Create image definition
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
# resource "azurerm_shared_image" "vmssimg" {
#   name                = "vmss-image"
#   gallery_name        = azurerm_shared_image_gallery.acg.name
#   resource_group_name = azurerm_resource_group.acgrg.name
#   location            = azurerm_resource_group.acgrg.location
#   os_type             = "Windows"
# 
#   identifier {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-Datacenter"
#   }
# 
#   tags = {
#     environment = "Dev"
#     provisioner = "Terraform"
#   }
# }

# # Create image
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/image
# resource "azurerm_image" "vmss" {
#   name                = "vmss-win2019"
#   location            = azurerm_resource_group.acgrg.location
#   resource_group_name = azurerm_resource_group.acgrg.name
# 
#   os_disk {
#     os_type  = "Windows"
#     os_state = "Generalized"
#     blob_uri = "{blob_uri}"
#     size_gb  = 30
#   }
# }