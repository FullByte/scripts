Get-AzureADUser -All $true | Select-Object UserprincipalName,@{ N="PasswordNeverExpires";E={$_.PasswordPolicies -contains "DisablePasswordExpiration"} }
 
Set-AzureADUser -ObjectId $objectID -PasswordPolicies DisablePasswordExpiration
Set-AzureADUser -ObjectId $objectID -PasswordPolicies PasswordNeverExpires
Set-AzureADUser -ObjectId $objectID -PasswordPolicies None