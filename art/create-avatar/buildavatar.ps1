<#
.SYNOPSIS
Create new avatar variants based on given avatar.cfdg file

.EXAMPLE
Run locally: .\buildavatar.ps1
Run online: iex ((New-Object System.Net.WebClient).DownloadString(''))

.NOTES
Website: https://www.contextfreeart.org/
Github: https://github.com/MtnViewJohn/context-free

.INPUTS
args[0] = cfdg file and path e.g. "avatar.cfdg"
args[1] = image(s) outut folder e.g. "avatar"
args[2] = number of images to create e.g. 10
#>

$cfdgfile = $args[0]
$folder = $args[1]
$images = $args[2]

function GenerateAvatars ([string] $InputFile, [string] $OutputPrefix, [int] $Amount) {
    $ContextFreeCLI = $PSScriptRoot + '\ContextFreeCLI.exe'
    $InputFile = $PSScriptRoot + "\" + $InputFile

    while($Amount -ne 0)
    {
        $Amount--        
        $OutputFile = $PSScriptRoot + '\' + $OutputPrefix + "_" + ((New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).Ticks).ToString() + ".png"
        
        $AllArgs = @('/s666', '/c', $InputFile, $OutputFile)
        & $ContextFreeCLI $AllArgs
     }    
}

GenerateAvatars $cfdgfile $folder $images
