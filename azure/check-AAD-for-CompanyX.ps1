# https://www.shawntabrizi.com/aad/does-company-x-have-an-azure-active-directory-tenant/

$csv = Import-Csv -Path .\input.csv
$output = @()

foreach ($line in $csv)
{
    $companyname = $line.CompanyName
    $companynameencoded = [System.Net.WebUtility]::UrlEncode($companyname)

    $GoogleURI = 'https://www.google.com/search?q=' + $companynameencoded + '&amp;btnI'
 
    try { 
        $GoogleResult = Invoke-WebRequest -Uri $GoogleURI
        $CompanyURI = ([System.Uri]$GoogleResult.BaseResponse.ResponseUri).Host.split('.')[-2..-1] -join '.'
    } catch {
        write-host $_.Exception
        $CompanyURI = "error"
    }

    $OpenIDConfigURL = 'https://login.microsoftonline.com/' + $CompanyURI + '/.well-known/openid-configuration'

    try {
        $OpenIDResult = (Invoke-WebRequest -Uri $OpenIDConfigURL).StatusCode
    } catch {
        $OpenIDResult = $_.Exception.Response.StatusCode.value__
    }

    if ($OpenIDResult -eq 200) {
        $tenant = $true
    } else {
        $tenant = $false
    }

    $result = [pscustomobject]@{
        CompanyName = $companyname.ToString()
        HomepageURI = $CompanyURI.ToString()
        OpenIDResult = $OpenIDResult.ToString()
        HasTenant = $tenant.ToString()
    }

    Write-Host $result
    $output += $result 
}

$output | Export-Csv -Path output.csv -NoTypeInformation