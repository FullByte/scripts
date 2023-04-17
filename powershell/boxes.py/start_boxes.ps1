#Requires -RunAsAdministrator

<#
.SYNOPSIS
Run Boxes.py on Windows

.EXAMPLE
Run locally:
PS C:\> .\Start-Boxes.ps1

Run online:
iex ((New-Object System.Net.WebClient).DownloadString(''))

.NOTES
Source:
Website: https://www.festi.info/boxes.py/BurnTest
Github: https://github.com/florianfesti/boxes
#>

function Start-Boxes {
    # Install/Update tools
    if (!(Test-Path "$($env:ProgramData)\chocolatey\choco.exe")) { Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) }
    choco install -y python git

    # Install/Update boxes
    $boxes = "${PSScriptRoot}\boxes" 
    if (Test-Path $boxes) { git --work-tree=$boxes --git-dir=$boxes\.git pull }
    else { git clone https://github.com/florianfesti/boxes.git $boxes } 

    # Install dependencies
    python -m pip install --upgrade pip 
    pip install -r $boxes\requirements.txt

    # Run Boxes
    Start-Process python $boxes\scripts\boxesserver
    Start-Process http://localhost:8000
}

Start-Boxes
