# Terraform Cloud configuration
terraform {
        backend "remote" {
            organization = "The38Dev"
            workspaces {
                name = "terraform-azurerm-azure-compute-gallery"
            }
        }
}