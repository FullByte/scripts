# Encrypt or Decrypt a File with Powershell and PFX Cert 

$path = "D:\test.txt"
$pwcert = "password"

$hascert=Read-Host -Prompt 'Do you have a certificate for file encryption? (Y/N)?'
If ($hascert -eq 'Y') {
    Write-Host 'Select Certificate.' 
    $mycert=Get-Childitem Cert:\CurrentUser\My
    $cert=$mycert | Where-Object hasprivatekey -eq 'true' | Select-Object -Property Issuer,Subject,HasPrivateKey | Out-GridView -Title 'Select Certificate' -PassThru
}
If ($hascert -eq 'N') {
    Write-Host 'This section creates a new self signed certificate. Provide certificate name.'
    $newcert=Read-Host 'Enter Certificate Name'
    New-SelfSignedCertificate -DnsName $newcert -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage KeyEncipherment,DataEncipherment,KeyAgreement -Type DocumentEncryptionCert
    $cert=Get-ChildItem -Path Cert:\CurrentUser\My\ | Where-Object subject -like "*$newcert*"
    $thumb=$cert.thumbprint
    Export-PfxCertificate -Cert Cert:\CurrentUser\My\$thumb -FilePath $home\"cert_"$env:username".pfx" -Password $pwcert 
}

$enc=Read-Host -Prompt 'Do you want to [e]ncrypt or [d]ecrypt the file? (E/D)?'
If ($enc -eq 'E') {
    Get-Content $path | Protect-CmsMessage -To $cert.Subject -OutFile $path
}
If ($enc -eq 'D') {
    $message = Unprotect-CmsMessage -Path $path -To $cert.Subject
    Set-Content -Path $path -Value $message
}

Write-Host "Done"
