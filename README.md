# Azure Compute Gallery (formerly Shared Image Gallery)
Terraform used to configure Azure Compute Gallery. It also creates image definition.

## Pre-requsites

Register for Azure Image Builder Feature. Wait until RegistrationState is set to 'Registered'

PowerShell
```
Register-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages
Get-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages
```
Azure CLI
```
az feature register --namespace Microsoft.VirtualMachineImages --name VirtualMachineTemplatePreview
az feature show --namespace Microsoft.VirtualMachineImages --name VirtualMachineTemplatePreview

```

Check you are registered for the providers, ensure RegistrationState is set to 'Registered'.

```
Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Get-AzResourceProvider -ProviderNamespace Microsoft.Storage 
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute
Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
```

If they do not saw registered, run the commented out code below.

```
Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
```

## Assign Azure role to deployment SPN

In order to distribute or customize exisiting images, Azure Image Builder service must be allowed to inject the images into these resource groups. The role that needs to be assigned to the deployment Azure SPN that has permissions Microsoft.Authorization/roleAssignments/write permissions, such as User Access Administrator or Owner. [The more informaiton can be found here.](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-cli) 

The script below 
```
az role assignment create --assignee "{Azure SPN object ID}" \
--role "User Access Administrator" \
--subscription "{subscriptionNameOrId}"
```

## Check Azure Marketplace images
In order to used Azure MArketplace Images in the Image Builder templates, Publisher, Offer and SKU need to be specified. The section below describes how to get required information.
## Check Publisher name

Search for Publusher name. Look for MicrosoftWindowsServer for Microsoft based OS

```
Get-AzVMImagePublisher -Location canadacentral
```

### Check for Image Offer

Choose WindowsServer for Microsoft Windows Server offers

```
Get-AzVMImageOffer -Location canadacentral -PublisherName MicrosoftWindowsServer
```

### Check Image SKU

Choose required image SKU, e.g. 2019-Datacenter

```
Get-AzVMImageSku -Location canadacentral -PublisherName MicrosoftWindowsServer -Offer WindowsServer
```
## Network requirements

There are several options to use Azure networking for Azure Image Builder Service. For more details, go to https://docs.microsoft.com/en-us/azure/virtual-machines/linux/image-builder-networking.
### Private Link policy

Private Endpoint Network Policy needs to be disabled for the target subnet. For more details, go to https://aka.ms/azvmimagebuildervnet.

Disable Private Service Policy on subnet
```
az network vnet subnet update \
  --name $subnetName \
  --resource-group $vnetRgName \
  --vnet-name $vnetName \
  --disable-private-link-service-network-policies true
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.acgrg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aibIdentityAssignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.aibIdentity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_shared_image.vmssimg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image) | resource |
| [azurerm_shared_image_gallery.acg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery) | resource |
| [azurerm_storage_account.imagesa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_blob.imageblob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.imageco](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_user_assigned_identity.aib](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_resource_group.vmssrg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.aibfetch](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deploy_location"></a> [deploy\_location](#input\_deploy\_location) | The Azure Region in which all resources in this example should be created. | `string` | `"canadacentral"` | no |
| <a name="input_rg_shared_name"></a> [rg\_shared\_name](#input\_rg\_shared\_name) | Name of the Resource group in which to deploy shared resources | `string` | `"azure-compute-gallery-rg"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_client_id"></a> [account\_client\_id](#output\_account\_client\_id) | AIB managed identity Client ID |
| <a name="output_account_object_id"></a> [account\_object\_id](#output\_account\_object\_id) | AIB managed identity Object (Principal) ID |
| <a name="output_compute_gallery"></a> [compute\_gallery](#output\_compute\_gallery) | Azure Compute Gallery |
| <a name="output_current_subscription_id"></a> [current\_subscription\_id](#output\_current\_subscription\_id) | Subscription ID |
| <a name="output_id"></a> [id](#output\_id) | VMSS Reource Group ID |
| <a name="output_location"></a> [location](#output\_location) | The Azure region |
| <a name="output_storage_account_blob_url"></a> [storage\_account\_blob\_url](#output\_storage\_account\_blob\_url) | Storage Account Blob URL |
<!-- END_TF_DOCS -->