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

# Fetch VMSS RG details
data "azurerm_resource_group" "vmssrg" {
  name = "st-vmss-rg"
}

# Fetch subscription details
data "azurerm_subscription" "current" {
#    subscription_id = subscription_id
}

data "azurerm_client_config" "example" {
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

# Create image definition
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
resource "azurerm_shared_image" "vmssimg" {
  description           = "VMSS image definition"
  eula                  = "https://contoso.com/license"
  privacy_statement_uri = "https://contoso.com/privacy"
  release_note_uri      = "https://contoso.com/releasenotes"
  name                  = "vmss-image"
  gallery_name          = azurerm_shared_image_gallery.acg.name
  resource_group_name   = azurerm_resource_group.acgrg.name
  location              = azurerm_resource_group.acgrg.location
  os_type               = "Windows"

  identifier {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
  }

  tags = {
    environment = "Dev"
    provisioner = "Terraform"
  }
}

# Create an Azure user-assigned managed identity
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
# aibIdentity = Azure Image Builder Identity
resource "azurerm_user_assigned_identity" "aib" {
  name = "aibIdentity"
  resource_group_name = azurerm_resource_group.acgrg.name
  location            = azurerm_resource_group.acgrg.location
  tags = {
    environment = "Dev"
    provisioner = "Terraform"
  }
}

# Create an Azure role definition
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition
resource "azurerm_role_definition" "aibIdentity" {
  name        = "aibIdentityRole"
	scope 			= data.azurerm_resource_group.vmssrg.id	
#  scope       = azurerm_resource_group.acgrg.id
#  scope       = data.azurerm_subscription.current.id
  description = "Azure Image Builder Image Definition Dev"

  permissions {
#     actions     = ["Microsoft.Compute/locations/usages/read"]
    actions     = ["Microsoft.Compute/images/write",
                   "Microsoft.Compute/images/read",
                   "Microsoft.Compute/images/delete",
									 "Microsoft.Compute/galleries/read", 
									 "Microsoft.Compute/galleries/images/read", 
									 "Microsoft.Compute/galleries/images/versions/read", 
									 "Microsoft.Compute/galleries/images/versions/write"]
    not_actions = []
  }

  assignable_scopes = [
		data.azurerm_resource_group.vmssrg.id,
    azurerm_resource_group.acgrg.id,
    data.azurerm_subscription.current.id, # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}

# Assign previously created role definition to the adintified scope
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment

data "azurerm_user_assigned_identity" "aibfetch" {
  name                = "aibIdentity"
#  name                = azurerm_user_assigned_identity.aib.name
  resource_group_name =  "azure-compute-gallery-rg"
#  resource_group_name = azurerm_resource_group.acgrg.name
}

#resource "azurerm_role_assignment" "aibIdentityAssignment" {
##  name               = "00000000-0000-0000-0000-000000000000"
#  scope              = data.azurerm_subscription.current.id
#  role_definition_id = azurerm_role_definition.aibIdentity.role_definition_resource_id
##  principal_id       = data.azurerm_client_config.example.object_id
#  principal_id       = data.azurerm_user_assigned_identity.aibfetch.object_id
#}

# # Update image definition version
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_version
# resource "azurerm_shared_image_version" "vmssimg" {
#   name                = "0.0.1"
#   gallery_name        = data.azurerm_shared_image.vmssimg.gallery_name
#   image_name          = data.azurerm_shared_image.vmssimg.name
#   resource_group_name = data.azurerm_shared_image.vmssimg.resource_group_name
#   location            = data.azurerm_shared_image.vmssimg.location
#   managed_image_id    = data.azurerm_image.vmssimg.id
# 
#   target_region {
#     name                   = data.azurerm_shared_image.vmssimg.location
#     regional_replica_count = 5
#     storage_account_type   = "Standard_LRS"
#   }
# }

# Create image
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/image
# resource "azurerm_image" "vmss" {
#   name                = "vmss-win2019"
#   location            = azurerm_resource_group.acgrg.location
#   resource_group_name = azurerm_resource_group.acgrg.name
# 
#   os_disk {
#     os_type  = "Windows"
#     os_state = "Generalized"
#     size_gb  = 128
#   }
# }