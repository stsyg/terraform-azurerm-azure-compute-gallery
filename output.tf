output "location" {
  description = "The Azure region"
  value       = azurerm_resource_group.acgrg.location
}

output "compute_gallery" {
  description = "Azure Compute Gallery"
  value       = azurerm_shared_image_gallery.acg.name
}

output "current_subscription_id" {
  description = "Subscription ID"
  value = data.azurerm_subscription.current.id
}

output "id" {
  description = "VMSS Reource Group ID"
  value = data.azurerm_resource_group.vmssrg.id
}

output "account_object_id" {
  description = "AIB managed identity Object (Principal) ID"
  value = data.azurerm_user_assigned_identity.aibfetch.principal_id
}

output "account_client_id" {
  description = "AIB managed identity Client ID"
  value = data.azurerm_user_assigned_identity.aibfetch.client_id
}

output "storage_account_blob_url" {
  description = "Storage Account Blob URL"
  value = azurerm_storage_blob.imageblob.url
}