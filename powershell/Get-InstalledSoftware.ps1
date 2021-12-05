function Get-InstalledSoftware {
        $OSArchitecture = (Get-WMIObject win32_operatingSystem -ErrorAction Stop).OSArchitecture
        if ($OSArchitecture -like '*64*') {
            $RegistryPath = 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
        } else {
            $RegistryPath = 'Software\Microsoft\Windows\CurrentVersion\Uninstall'            
        }
        $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', "")
        $RegistryKey = $Registry.OpenSubKey("$RegistryPath")
        $RegistryKey.GetSubKeyNames() | ForEach-Object {
            $Registry.OpenSubKey("$RegistryPath\$_") | Where-Object {($_.GetValue("DisplayName") -notmatch '(KB[0-9]{6,7})') -and ($_.GetValue("DisplayName") -ne $null)} | foreach {
                $Object = New-Object -TypeName PSObject
                $Object | Add-Member -MemberType noteproperty -Name 'Name' -Value $($_.GetValue("DisplayName"))
                $Object
            }
        }
}

Get-InstalledSoftware