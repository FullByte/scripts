#Requires -RunAsAdministrator

# Install Scoop and wget
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
scoop install wget

# Add StevenBlacks hosts list to local host file
$LocalHostPath = "C:\Windows\System32\drivers\etc\"
$LocalHostFilePath = $LocalHostPath + "hosts"
$SaveFilePath = $PSScriptRoot + "\hosts"
$oldHostFileName = "hosts_old_" + (Get-Date -Format o | ForEach-Object {$_ -replace ":", "."}).ToString()
$downloadCommand = "wget " + "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" + " -O " + $SaveFilePath 
invoke-expression $downloadCommand # Download Host File 
Rename-Item -Path $LocalHostFilePath -NewName $oldHostFileName # Rename current host file
Move-Item -Path $SaveFilePath -Destination $LocalHostPath -Force # Move new host file into place