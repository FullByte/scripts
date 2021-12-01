function appRegistrationPrivileges{
    # Remove all rights
    $objectId = (Get-AzADServicePrincipal -DisplayName "appRegistration").id

    foreach ($RoleAssignment in Get-AzRoleAssignment -ObjectId $objectId) {
        Remove-AzRoleAssignment -InputObject $RoleAssignment
    }

    # Subscription
    $Role = "Contributor"
    New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $Role

    # ResourceGroup
    $ResourceGroup = "RGNAME"
    $Role = "Contributor"
    New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $Role -ResourceGroupName $ResourceGroup 

    # Key Vault
    $KeyVault = "KeyVaultName"
    Set-AzKeyVaultAccessPolicy -VaultName $KeyVault -ObjectId $objectId -PermissionsToSecrets get,list

    #Resource
    $resource = "/subscriptions/<subscriptionID>/resourceGroups/<RGNAME>/providers/Microsoft.Storage/storageAccounts/<storageaccountname>"
    $Role = "Contributor"

    New-AzRoleAssignment -ObjectId $objectId -RoleDefinitionName $Role -Scope $resource
}
