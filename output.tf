output "location" {
  description = "The Azure region"
  value       = azurerm_resource_group.acgrg.location
}

output "compute_gallery" {
  description = "Azure Compute Gallery"
  value       = azurerm_shared_image_gallery.acg.name
}

# output "current_subscription_display_name" {
#   value = data.azurerm_subscription.current.display_name
# }

output "current_subscription_id" {
  description = "Subscription ID"
  value = data.azurerm_subscription.current.id
}

output "id" {
  description = "VMSS Reource Group ID"
  value = data.azurerm_resource_group.vmssrg.id
}