output "location" {
  description = "The Azure region"
  value       = azurerm_resource_group.acgrg.location
}

output "Compute_Gallery" {
  description = "Azure Compute Gallery"
  value       = azurerm_shared_image_gallery.acg.name
}