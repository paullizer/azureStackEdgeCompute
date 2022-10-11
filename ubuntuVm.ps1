$urn = "Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:20.04.202210100"
$diskName = "ubuntu"
$diskRG = "resource_group_name"

az disk create -g $diskRG -n $diskName --image-reference $urn
$sas = az disk grant-access --duration-in-seconds 36000 --access-level Read --name $diskName --resource-group $diskRG
$diskAccessSAS = ($sas | ConvertFrom-Json)[0].accessSas


$storageAccountName = "azure_proper_storage_account_name"
$containerName = "azure_proper_container_name"
$destBlobName = "ubuntu.vhd"
$storageAccountKey = "azure_proper_storage_account_key"

$destContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
Start-AzureStorageBlobCopy -AbsoluteUri $diskAccessSAS -DestContainer $containerName -DestContext $destContext -DestBlob $destBlobName

Get-AzureStorageBlobCopyState –Container $containerName –Context $destContext -Blob $destBlobName