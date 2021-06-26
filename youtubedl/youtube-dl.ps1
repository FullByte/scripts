<#
.SYNOPSIS
Use youtube-dl and some helpers to get done what I need

.EXAMPLE
Run locally: .\youtube-dl.ps1
Run online: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/FullByte/scripts/main/youtubedl/youtube-dl.ps1'))

.NOTES
Website: https://youtube-dl.org/
Docs: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
Github: https://github.com/ytdl-org/youtube-dl
#>

# Check if youtube-dl is available and install it if required
Function CheckYoutubeDL {
    if ($null -ne (Get-Command -Name youtube-dl.exe -ErrorAction SilentlyContinue)) {
        Write-Host("youtube-dl version found on system :)")
        Write-Host("Using youtube-dl version " + (Get-Command youtube-dl).Version + " from source: " + (Get-Command youtube-dl).Source) 
    }    
    else {
        # Check if choco is installed, else try python, else download directly
        Write-Host(" youtube-dl not found... trying to install youtube-dl now...")
        
        if ($null -ne (Get-Command -Name choco.exe -ErrorAction SilentlyContinue)) {
            Write-Host("Installing youtube-dl with chocolatey...")
            choco.exe install -y youtube-dl 
        }
        else {
            Write-Host("Chocolatey not found to install youtube-dl.")
            Write-Host("What would you like to do?")
            Write-Host("1) Install Chocolatey and youtube-dl")
            Write-Host("2) Try other install methods")
            $action = Read-Host "Your input:"    
            if ($action -eq "1"){ 
                Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
                choco.exe install -y youtube-dl
            }
            else {
                if ($null -ne (Get-Command -Name python3.ex -ErrorAction SilentlyContinue)) {
                    Write-Host("Installing youtube-dl with pip...")
                    python3.exe -m pip install --upgrade youtube-dl
                }
                else {
                    #vc_redist.x64.exe
                    $source = "https://aka.ms/vs/16/release/vc_redist.x64.exe" # Source file location            
                    Write-Host("Installing required MSVCP100.DLL from latest latest supported Visual C++ downloads from URL: " + $source)
                    $destination = ((Get-Location).Path + "\vc_redist.x64.exe") # Destination to save the file
                    Invoke-WebRequest -Uri $source -OutFile $destination
                    Start-Process -FilePath $destination

                    Write-Host("Follow the install instructions of vc_redist.x64.exe.")
                    Read-Host "Press the 'any' key once done ("
        
                    #youtube-dl.exe
                    $source = "https://yt-dl.org/latest/youtube-dl.exe" # Source file location            
                    Write-Host("Installing latest youtube-dl from URL: " + $source)
                    $destination = ((Get-Location).Path + "\youtube-dl.exe") # Destination to save the file
                    Invoke-WebRequest -Uri $source -OutFile $destination
                    Start-Process -FilePath $destination

                    Write-Host("Follow the install instructions of youtube-dl.exe.")
                    Read-Host "Press the 'any' key once done ("
                }
            }
        }
        Write-Host("youtube-dl installed :)")
        Write-Host("Using youtube-dl version " + (Get-Command youtube-dl).Version + " from source: " + (Get-Command youtube-dl).Source)
    }
}

Function DownloadHoerbert{
    $source = 'https://k2d8k6u5.rocketcdn.me/downloads/2.1.5/hoerbert-installer.exe' # Source file location
    $destination = (Get-Location).Path + '\hoerbert-installer.exe' # Destination to save the file
    
    Invoke-WebRequest -Uri $source -OutFile $destination #Download the file
    Start-Process -FilePath $destination

    Write-Host("Follow the install instructions in the install dialog to install Hoerbert.")
    Read-Host "Press the 'any' key once done ("
    Menu # back to the menu
}

Function GetVideo
{
    # Get URL
    Write-Host("# Please enter a youtube video or playlist e.g.:")
    $downloadurl = Read-Host "# Your link"
    Write-Host("# Downloading $downloadurl") -ForegroundColor Green

    # Download files
    if ($null -ne ('list' | Where-Object { $s -match $_ })) {
        youtube-dl.exe -f best -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' -i "$downloadurl" }
    else {
        mkdir (((Get-Location).Path) + "\Youtube")
        youtube-dl.exe -f best -o 'Youtube/%(title)s.%(ext)s' -i "$downloadurl" }
    
    Menu # back to the menu
}

# Download music with youtube-dl as mp3 file
Function GetMusic
{
    # Get URL
    $now = Get-Date    
    Write-Host("# Please enter a youtube song or playlist e.g.:")
    $downloadurl = Read-Host "# Your link"
    Write-Host("# Downloading $downloadurl") -ForegroundColor Green
    
    # Download files
    if ($null -ne ('list' | Where-Object { $s -match $_ })) {
        youtube-dl.exe -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' -i --extract-audio --audio-format mp3 --audio-quality 2 "$downloadurl" }
    else { 
        mkdir (((Get-Location).Path) + "\Singles")
        youtube-dl.exe -o 'Singles/%(title)s.%(ext)s' -i --extract-audio --audio-format mp3 --audio-quality 2 "$downloadurl" }
    
    # Rename files
    Set-Location -Path ((Get-Location).Path + "\" + (Get-ChildItem -Directory | Sort-Object LastWriteTime | Select-Object -last 1).Name)    
    Get-ChildItem -File -Path * -Include *.mp3 | Rename-Item -NewName { ($_.BaseName -replace '[^a-zA-Z]', ' ') + '  .mp3' }
    Get-ChildItem -File -Path * -Include *.mp3 | Rename-Item -NewName { ($_.BaseName -replace '\s+', ' ') + '.mp3' }
    Get-ChildItem -File -Path * -Include *.mp3 | Rename-Item -NewName { ($_.Name -replace ' .mp3', '.mp3')}

    # Show files
    Write-Host("# All files downloaded") -ForegroundColor Green
    Get-ChildItem -File -Path * -Include *.mp3 | Select-Object Name, LastAccessTime | Where-Object -FilterScript {($_.LastAccessTime.AddMinutes(2) -gt $now)}
    Set-Location -Path -

    Menu # back to the menu
}

Function Menu{
    Write-Host("# Welcome to my YouTube-DL helper :)")
    Write-Host("# What would you like to do?")
    Write-Host("# 0) Download Hoerbert")
    Write-Host("# 1) Download Music")
    Write-Host("# 2) Download Video")
    Write-Host("# 9) Exit")
    $action = Read-Host "# Your input"    
    if ($action -eq "0"){ DownloadHoerbert }
    elseif ($action -eq "1"){ GetMusic $playlist }
    elseif ($action -eq "2"){ GetVideo $playlist }
    else { Write-Host("Bye...") }
}

# Start here
CheckYoutubeDL
Menu
