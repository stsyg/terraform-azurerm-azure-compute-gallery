# Azure Compute Gallery (formerly Shared Image Gallery)
Terraform used to configure Azure Compute Gallery. It also creates image definition.

## Pre-requsites

Register for Azure Image Builder Feature. Wait until RegistrationState is set to 'Registered'

```
Register-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages
Get-AzProviderFeature -FeatureName VirtualMachineTemplatePreview -ProviderNamespace Microsoft.VirtualMachineImages
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
## Private Link policy

Private Endpoint Network Policy needs to be disabled for the target subnet. For more details, go to https://aka.ms/azvmimagebuildervnet.