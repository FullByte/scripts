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
    # Install Chocolatey if needed
    if (!(Test-Path "$($env:ProgramData)\chocolatey\choco.exe")) {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) # Download and Install Chocolatey
    }
        
    # Install/Update tools
    choco install -y python # Install python
    choco install -y git # Install git      
    python -m pip install --upgrade pip # Update PIP
    pip install Markdown lxml affine # Install/upgrade pip tools
        
    # Install/Update boxes.py
    $boxes = "${PSScriptRoot}\boxes" # Boxes will be copied to this path
    if (Test-Path $boxes) {
        Write-Host "Pulling Boxes updates"
        git --work-tree=$boxes --git-dir=$boxes\.git pull # Download latest version of boxes
    }
    else {
        Write-Host "Not found... cloning Boxes"        
        git clone https://github.com/florianfesti/boxes.git $boxes # Download latest version of boxes
    } 
            
    # Run Boxes
    Start-Process python $boxes\scripts\boxesserver # run boxes webserver
    Start-Process http://localhost:8000 # open browser
}

Start-Boxes