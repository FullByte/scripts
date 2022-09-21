<#PSScriptInfo

.VERSION 1.0.0

.GUID fd5be29f-2d98-40c6-bea1-7ff0e9758c99

.AUTHOR Hajo Schulz <hos@ct.de>

.COMPANYNAME c't Magazin für Computertechnik

.COPYRIGHT Copyright © 2022 Heise Medien GmbH & Co. KG / c't

.PROJECTURI https://ct.de/yp64

#>

<#
.SYNOPSIS
   Interaktive Programm-Updates mit WinGet
.DESCRIPTION
   Das Skript zeigt alle Programm-Updates an, die WinGet kennt, bietet sie zur 
   interaktiven Auswahl an und installiert dann die vom Benutzer ausgewählten.
.EXAMPLE
   C:\PS> Winget-Upgrade
.INPUTS
   None
.OUTPUTS
   None
#>

# Zeichenketten mit Umlauten von OEM-Kodierung (Codepage 850) nach UTF-8 wandeln
function Oem2Utf8([String]$s)
{
  $bytes = [System.Text.Encoding]::GetEncoding(850).GetBytes($s)
  return [System.Text.Encoding]::UTF8.GetString($bytes)  
}

# Wurde das Skript mit Admin-Rechten gestartet?
function BinIchAdmin() {
  $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $princ = New-Object System.Security.Principal.WindowsPrincipal($identity)
  return ($princ.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
}

# Auf Admin-Rechte prüfen
$sudo = ''
if(!(BinIchAdmin)) {
  # Keine Admin-Rechte, aber gibt es auf diesem Rechner ein sudo?
  $sudocmd = Get-Command sudo -ErrorAction Ignore
  if($sudocmd) {
    $sudo = $sudocmd.Name + ' '
  }
  else {
    Write-Warning 'Zum Installieren von Upgrades werden Sie Administratorrechte brauchen.'
    Write-Host 'Wollen Sie trotzdem weitermachen? [J/n] ' -NoNewline
    $key = [Console]::ReadKey()
    Write-Host
    if($key.Key -eq 'n') {
      exit
    }
  }
}

# `winget upgrade` liefert die zu aktualisierenden Pakete
Write-Host "Ermittle zu aktualisierende Pakete ..." -ForegroundColor Yellow -NoNewline
$list = & {winget upgrade}
Write-Host "`r                                      "

# Eventuelle Leerzeilen am Anfang überspringen
$line = 0
while($line -lt $list.Count) {
  if($list[$line].Trim().StartsWith('Name')) {
    break
  }
  $line += 1
}

# Die Spaltenüberschriften auseinanderdröseln
$fields = @()
$starts = @()
$ch = 0
$utf = Oem2Utf8 $list[$line]
foreach($col in $utf.Split(' ', [StringSplitOptions]::RemoveEmptyEntries -bor [StringSplitOptions]::TrimEntries)) {
  $st = $utf.IndexOf($col, $ch)
  $fields += $col
  $starts += $st
  $ch = $st + $col.Length
}

$packages = @()
$line += 2 # Zeile mit '----------' überspringen
while($line -lt $list.Count - 1) { # `$list.Count - 1`, weil die Ausgabe am Ende noch eine Zusammenfassung enthält
  # Für jede Zeile ein Custom-Object erstellen, das als Attributnamen die
  # Spaltenüberschriften und als Werte die Einträge der Tabelle enthält.
  $pack = New-Object pscustomobject
  $utf = Oem2Utf8 $list[$line]
  for($f = 0; $f -lt $fields.Count; $f += 1) {
    if($f -eq $fields.Count - 1) {
      try {
      $att = $utf.Substring($starts[$f]).Trim() # Die letzte Spalte kann länger sein als ihre Überschrift.
      }
      catch {
        { 
          Write-Host ("`nerror with entry: {0} ..." -f $utf)
        }
      }
    }
    else {
      try {
        $att = $utf.Substring($starts[$f], $starts[$f+1] - $starts[$f]).Trim()
      }
      catch {
        {
          Write-Host ("`nerror with entry: {0} ..." -f $utf)
        }
      }
    }
    $pack | Add-Member -MemberType NoteProperty -Name $fields[$f] -Value $att
  }
  $packages += $pack
  $line += 1
}
if($packages.Count -eq 0) {
  [System.Windows.MessageBox]::Show('Keine Upgrades gefunden.','WinGet Upgrade','Ok','Information') | Out-Null
  exit
}

# Zu aktualisierende Pakete als GridView zum Auswählen anbieten
$updates = $packages | Out-GridView -PassThru -Title "Pakete für Upgrade auswählen:"

# Für die ausgewählten Pakete `winget upgrade` aufrufen und die Paket-ID als Parameter übergeben
foreach($u in $updates) {
  Write-Host ("`nLade Upgrade für {0} ..." -f $u.Name) -ForegroundColor Yellow
  Invoke-Expression ($sudo + 'winget upgrade --id ' + $u.ID)
}
