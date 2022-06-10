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

## Check Azure Marketplace images

Search for Publusher name. Look for MicrosoftWindowsServer for Microsoft based OS

```
Get-AzVMImagePublisher -Location canadacentral
```

## Check for Image Offer

Choose WindowsServer for Microsoft Windows Server offers
```
Get-AzVMImageOffer -Location canadacentral -PublisherName MicrosoftWindowsServer
```

## Check Image SKU

Choose required image SKU, e.g. 2019-Datacenter
```
Get-AzVMImageSku -Location canadacentral -PublisherName MicrosoftWindowsServer -Offer WindowsServer
```
