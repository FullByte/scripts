$keyVaultName = "kvVMencyption"
$resourceGroupName = "rg-VM-encyption"
$keyEncryptionKeyName = "VMencyptionKey"
$location = "westeurope"

Write-Host "Creating new resource group: ($resourceGroupName)";
$resGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue;
if (-not $resGroup) { $resGroup = New-AzResourceGroup -Name $resourceGroupName -Location $location; }

Write-Host "Creating a new KeyVault named $keyVaultName to store encryption keys";
$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ErrorAction SilentlyContinue;
if (-not $keyVault) { $keyVault = New-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroupName -Sku Standard -Location $location; }

Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -EnabledForDiskEncryption;

Write-Host "Enabling Soft Delete on KeyVault $keyVaultName";
$resource = Get-AzResource -ResourceId $keyVault.ResourceId;
$resource.Properties | Add-Member -MemberType "NoteProperty" -Name "enableSoftDelete" -Value "true" -Force;
Set-AzResource -resourceid $resource.ResourceId -Properties $resource.Properties -Force;

Write-Host "Adding resource lock on  KeyVault $keyVaultName";
$lockNotes = "KeyVault may contain AzureDiskEncryption secrets required to boot encrypted VMs";
New-AzResourceLock -LockLevel CanNotDelete -LockName "LockKeyVault" -ResourceName $resource.Name -ResourceType $resource.ResourceType -ResourceGroupName $resource.ResourceGroupName -LockNotes $lockNotes -Force;

Write-Host "Creating key encryption key named:$keyEncryptionKeyName in Key Vault: $keyVaultName";
$kek = Add-AzKeyVaultKey -VaultName $keyVaultName -Name $keyEncryptionKeyName -Destination Software -ErrorAction SilentlyContinue;
$keyEncryptionKeyUrl = $kek.Key.Kid;

foreach($vm in Get-AzVm)
{
    if($vm.Location.replace(' ','').ToLower() -ne $keyVault.Location.replace(' ','').ToLower())
    {
        Write-Error "To enable AzureDiskEncryption, VM and KeyVault must belong to same subscription and same region. vm Location:  $($vm.Location.ToLower()) , keyVault Location: $($keyVault.Location.ToLower())";
        return;
    }

    Write-Host "Encrypting VM: $($vm.Name) in ResourceGroup: $($vm.ResourceGroupName) " -foregroundcolor Green;
    Set-AzVMDiskEncryptionExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $keyVaultResourceId -KeyEncryptionKeyUrl $keyEncryptionKeyUrl -KeyEncryptionKeyVaultId $keyVaultResourceId -VolumeType 'All';

    Get-AzVmDiskEncryptionStatus -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name;
}