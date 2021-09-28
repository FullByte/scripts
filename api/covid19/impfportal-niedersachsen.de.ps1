function ImpfCheck([string]$plz, [string]$geb, [int]$wartezeit) {
    # Prepare variables
    $sp = New-Object -ComObject SAPI.SpVoice
    $timestamp = (New-TimeSpan -Start ([timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')) -End $geb).TotalSeconds
    $uri= "https://www.impfportal-niedersachsen.de/portal/rest/appointments/findVaccinationCenterListFree/" + $plz + "?stiko=&count=1&birthdate=" + $timestamp
    $counter = 0

    # Text for header
    Clear-Host; Write-Host "`n `n `n `n `n `n `n##################################################`n## Impf Checker für impfportal-niedersachsen.de ##`n##################################################" # Leave Space for Progressbar
    $result = Invoke-RestMethod -Uri $uri
    $result.resultList -replace "@{","" -replace "}","" -replace " ",""  -replace "="," " -split ";" | ForEach-Object {
        $obj = New-Object PSCustomObject; $i = 0; foreach ($value in -split $_) {
            Add-Member -InputObject $obj -NotePropertyName ('col' + ++$i) -NotePropertyValue $value 
        } $obj } | Format-Table -HideTableHeaders

    # Run loop to check for available vaccine
    while ($true) {
        $result = Invoke-RestMethod -Uri $uri
        $time = Get-Date -Format "HH:mm:ss"
        $counter ++
        
        if (!($result.resultList.outOfStock -eq "True")){            
            Write-Host "Impfstoff verfügbar :)`nLetze Prüfung: " $time "`nVersuche insgesammt: " $counter -ForegroundColor Green            
            for ($i = 0; $i -lt 10; $i++) { [System.Console]::Beep() }
            $sp.Speak("Impfstoff ist verfügbar. Mache jetzt einen Termin!")
            Start-Process "https://www.impfportal-niedersachsen.de"
            Break # end loop if result is positiv
        }
        else {
            $infos = "Impfstoff nicht vorrätig! Letze Prüfung: " + $time + " Uhr. Versuche insgesammt: " + $counter
            Timer $wartezeit $infos # start timer if result is negativ and start over
        }
    }
}

Function Timer([int]$wartezeit, $infos) {
	$Length = $wartezeit / 100
	For ($wartezeit; $wartezeit -gt 0; $wartezeit--) {
        Write-Progress -Activity $infos -Status ("Nächster Check in " + ([int](([string]($wartezeit/60)).split('.')[0])) + " Minuten und " + ($wartezeit % 60) + " Sekunden...") -PercentComplete ($wartezeit / $Length); Start-Sleep 1 
    }
}