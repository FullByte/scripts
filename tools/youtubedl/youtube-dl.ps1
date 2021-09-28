<#
.SYNOPSIS
Use youtube-dl and some helpers to get done what I need

.EXAMPLE
Run locally: .\youtube-dl.ps1
Run online: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/FullByte/scripts/main/youtubedl/youtube-dl.ps1'))

.NOTES
This script: https://github.com/FullByte/scripts/blob/main/youtubedl/youtube-dl.ps1
About youtube-dl:
- Website: https://youtube-dl.org/
- Docs: https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
- Github: https://github.com/ytdl-org/youtube-dl
#>

$path = (Get-Location).Path

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
            Write-Host("# Chocolatey not found to install youtube-dl.")
            Write-Host("# What would you like to do?")
            Write-Host("# 1) Install Chocolatey and youtube-dl")
            Write-Host("# 2) Try other install methods")
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

    # Check once more and return value
    return ($null -ne (Get-Command -Name youtube-dl.exe -ErrorAction SilentlyContinue))
}

Function DownloadHoerbert{
    # Get Variables
    $source = 'https://k2d8k6u5.rocketcdn.me/downloads/2.1.5/hoerbert-installer.exe' # Source file location
    $destination = (Get-Location).Path + '\hoerbert-installer.exe' # Destination to save the file

    # Download the file and run installer
    Invoke-WebRequest -Uri $source -OutFile $destination 
    Start-Process -FilePath $destination
    Write-Host("Follow the install instructions in the install dialog to install Hoerbert.")
    Read-Host "Press the 'any' key once done ("

    # Back to the menu
    Menu 
}

Function GetVideo ($downloadurl)
{
    # Donwload file(s)
    Write-Host("# Downloading $downloadurl") -ForegroundColor Green
    if ($null -ne ('list' | Where-Object { $s -match $_ })) {
        youtube-dl.exe -f best -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' -i "$downloadurl" }
    else {
        $VideoPath = (((Get-Location).Path) + "\Video")
        If (!(Test-Path -Path $VideoPath)) { New-Item -ItemType Directory -Force -Path $VideoPath }
        youtube-dl.exe -f best -o 'Video/%(title)s.%(ext)s' -i "$downloadurl" }
    
    # Reset File Path
    Set-Location -Path $path
}

# Download music with youtube-dl as mp3 file
Function GetMusic ($downloadurl)
{
    # Donwload file(s)
    $now = Get-Date    
    Write-Host("# Downloading $downloadurl") -ForegroundColor Green
    if ($null -ne ('list' | Where-Object { $s -match $_ })) {
        youtube-dl.exe -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' -i --extract-audio --audio-format mp3 --audio-quality 2 "$downloadurl" }
    else { 
        $SinglesPath = (((Get-Location).Path) + "\Singles")
        If (!(Test-Path -Path $SinglesPath)) { New-Item -ItemType Directory -Force -Path $SinglesPath }
        youtube-dl.exe -o 'Singles/%(title)s.%(ext)s' -i --extract-audio --audio-format mp3 --audio-quality 2 "$downloadurl" }
    
    # Rename and show files
    Set-Location -Path ((Get-Location).Path + "\" + (Get-ChildItem -Directory | Sort-Object LastWriteTime | Select-Object -last 1).Name)    
    Get-ChildItem -File -Path * -Include *.mp3 | Rename-Item -NewName { ($_.BaseName -replace '[^a-zA-Z]', ' ') + '  .mp3' }
    Get-ChildItem -File -Path * -Include *.mp3 | Rename-Item -NewName { ($_.BaseName -replace '\s+', ' ') + '.mp3' }
    Get-ChildItem -File -Path * -Include *.mp3 | Rename-Item -NewName { ($_.Name -replace ' .mp3', '.mp3')}
    Write-Host("# All files downloaded") -ForegroundColor Green
    Get-ChildItem -File -Path * -Include *.mp3 | Select-Object Name, LastAccessTime | Where-Object -FilterScript {($_.LastAccessTime.AddMinutes(2) -gt $now)}

    # Reset File Path
    Set-Location -Path $path
}

Function Menu{
    Set-Location -Path $path
    Write-Host("# What would you like to do?")
    Write-Host("`e[48;2;0;0;255m# 0) Download Hoerbert")
    Write-Host("`e[48;2;0;100;0m# 1) Download Audio")
    Write-Host("`e[48;2;255;0;0m# 2) Download Video")
    Write-Host("# 9) Exit")
    $action = Read-Host "# Your input"    
    if ($action -eq "0"){ DownloadHoerbert }
    elseif ($action -eq "1"){ # Audio
        Write-Host(" __  __  __  __  ___  ____   ___ ")
        Write-Host("(  \/  )(  )(  )/ __)(_  _) / __)")
        Write-Host(" )    (  )(__)( \__ \ _)(_ ( (__ ")
        Write-Host("(_/\/\_)(______)(___/(____) \___)")
        Write-Host("`e[48;2;0;100;0m# Do you have a URL or local list with URLs?")
        Write-Host("`e[48;2;0;100;0m# 1) URL")
        Write-Host("`e[48;2;0;100;0m# 2) Local list")
        Write-Host("`e[48;2;0;100;0m# 9) Back")
        $action = Read-Host "`e[48;2;0;100;0m# Your input"    
        if ($action -eq "1"){ 
            $url = Read-Host "`e[48;2;0;100;0m# Enter URL"  
            GetMusic $url
            Menu
        }
        elseif ($action -eq "2"){
            $AudioFilePath = Read-Host "`e[48;2;0;100;0m# Enter File Path"  
            foreach($audio in [System.IO.File]::ReadLines($AudioFilePath)) { GetMusic $audio }
            Menu
        }
        else { Menu }
    }
    elseif ($action -eq "2"){ # Video
        Write-Host(" _  _  ____  ____   ____  _____ ")
        Write-Host("( \/ )(_  _)(  _ \ ( ___)(  _  )")
        Write-Host(" \  /  _)(_  )(_) ) )__)  )(_)( ")
        Write-Host("  \/  (____)(____/ (____)(_____)")        
        Write-Host("`e[48;2;255;0;0m# Do you have a URL or local list with URLs?")
        Write-Host("`e[48;2;255;0;0m# 1) URL")
        Write-Host("`e[48;2;255;0;0m# 2) Local list")
        Write-Host("`e[48;2;255;0;0m# 9) Back")
        $action = Read-Host "`e[48;2;255;0;0m# Your input"    
        if ($action -eq "1"){ 
            $url = Read-Host "`e[48;2;255;0;0m# Enter URL"  
            GetVideo $url
            Menu
        }
        elseif ($action -eq "2"){
            $VideoFilePath = Read-Host "`e[48;2;255;0;0m# Enter File Path"  
            foreach($video in [System.IO.File]::ReadLines($VideoFilePath)) { GetVideo $video }
            Menu
        }
        else { Menu }
    }
    else { Write-Host("Bye...") }
}

# Start here
Write-Host(" _    _  ____  __     ___  _____  __  __  ____ ")
Write-Host("( \/\/ )( ___)(  )   / __)(  _  )(  \/  )( ___)")
Write-Host(" )    (  )__)  )(__ ( (__  )(_)(  )    (  )__) ")
Write-Host("(__/\__)(____)(____) \___)(_____)(_/\/\_)(____)")
Write-Host("# Welcome to my YouTube-DL helper :)")
if (CheckYoutubeDL) { Menu }
else {
    Write-Host("`e[38;2;255;0;0mCan not find or install YouTube-DL :(")
    Write-Host("`e[38;2;255;0;0mPlease install youtube-dl manually!")
    Write-Host("These links may help:")
    Write-Host("-> Official Page: https://youtube-dl.org")
    Write-Host("-> Source https://github.com/ytdl-org/youtube-dl")
    Write-Host("-> Download https://github.com/ytdl-org/youtube-dl/release")
    Write-Host("")
    Read-Host "Press the 'any' key to end this script ("
}
