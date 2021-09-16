function UploadToBLOB ($file, $storage, $container, $sastoken) {
    $filename = (Get-Item $file).Name
    $uri = "https://$($storage).blob.core.windows.net/$($container)/$($filename)$($sastoken)"

    # Define required Headers
    $headers = @{
        'x-ms-blob-type' = 'BlockBlob'
    }

    Write-Host($uri)

    # Upload File
    Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -InFile $file
}

UploadToBLOB "D:\file\path\content.txt" "storage-account-name" "container-name" "?valid-write-sas-token"
