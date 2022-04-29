
Function Get-WinSAT{
    WinSAT formal # Get WinSAT Data (XML)
    $path = Get-ChildItem -Path 'C:\Windows\Performance\WinSAT\DataStore\*Formal.*.xml' | Sort-Object -Property CreationTime -Descending | Select-Object -First 1 -ExpandProperty FullName 

    # Parse as XML
    $xml = [xml]::new()
    $xml.Load($Path)

    # Read XML
    $node = $xml.WinSAT.Metrics.CPUMetrics.CompressionMetric
    'CPU Compression Performance is {0} {1}' -f $node.'#text', $node.units
    'CPU Manufacturer is {0} ' -f $xml.WinSAT.SystemConfig.Processor.Instance.Signature.Manufacturer.friendly
}

Function Get-Systemstats{
    Write-Output "System boot:" (Get-CimInstance -ClassName win32_operatingsystem | Select-Object -ExpandProperty LastBootUpTime)
    Write-Output "System install:" (Get-CimInstance -Class Win32_OperatingSystem).InstallDate
}

Function Get-WiFiPassword{
    $keyword = @{"de-DE" = 'Schlüsselinhalt'; "en-US" = 'Key Content'}
    (netsh wlan show profiles) | Select-String "\:(.+)$" | ForEach-Object {
        $name=$_.Matches.Groups[1].Value.Trim(); $_} | ForEach-Object{
            (netsh wlan show profile name="$name" key=clear)} | Select-String ($keyword[(get-culture).Name]+"\W+\:(.+)$") | ForEach-Object{
                $pass=$_.Matches.Groups[1].Value.Trim(); $_} | ForEach-Object{
                    [PSCustomObject]@{ WiFi=$name;PASSWORD=$pass }} | Format-Table -AutoSize
}

Function Get-WindowsDefenderStats{
    $DefenderStatus = (Get-Service WinDefend -ErrorAction SilentlyContinue).Status
    if ($DefenderStatus -ne "Running") { throw "The Windows Defender service is not currently running" }
    Get-MpComputerStatus
}

Function Get-Win10key{
    (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
}

Function Get-InstalledApps{
    # Get install apps from app-store
    Import-Module Appx
    ForEach($App in Get-AppxPackage){
        $Matched = $false
        Foreach($Item in @('*WindowsCalculator*', '*MSPaint*', '*Office.OneNote*', '*Microsoft.net*', '*MicrosoftEdge*', '*Microsoft*')){ If($App -like $Item){ $Matched = $true; break }}
        if($matched -eq $false){ [PSCustomObject]@{ Name = $App.Name; Location = $App.InstallLocation}}
    }

    # List all programs installed on Windows (and ignore the ones from Microsoft)
    Get-WMIObject -Query "SELECT * FROM Win32_Product Where Not Vendor Like '%Microsoft%'" | Format-Table

    #List files in programs folder
    ForEach ($Item in Get-ChildItem "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -Include *.lnk) {
        $Shell = New-Object -ComObject WScript.Shell
        $Properties = @{ ShortcutName = $Item.Name; Target = $Shell.CreateShortcut($Item).targetpath }
        New-Object PSObject -Property $Properties
    }
}
