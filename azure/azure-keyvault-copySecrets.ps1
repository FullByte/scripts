function copyKV{
    Param(
        [Parameter(Mandatory)]
        [string]$sourceKeyVault,

        [Parameter(Mandatory)]
        [string]$destKeyVault
    )

    $secretNames = (Get-AzKeyVaultSecret -VaultName $sourceKeyVault).Name
    $secretNames.foreach{
        Set-AzKeyVaultSecret -VaultName $destKeyVault -Name $_ -SecretValue (Get-AzKeyVaultSecret -VaultName $sourceKeyVault -Name $_).SecretValue
    }
}

copyKV "kv-old" "kv-new"