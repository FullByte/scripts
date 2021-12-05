$url = [System.Uri]"https://url.tld"
$regex = '(http(s)?:\/\/)([^\s(["<,>/]*)(\/)[^\s[",><]*(.png|.jpg|.gif|.jpeg|.svg)(\?[^\s[",><]*)?'
$useragent = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"

$FilePath = (([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop))+"\"+$url.Authority)
New-Item -ItemType Directory -Force -Path $FilePath | Select-Object | Out-Null

Add-Type -AssemblyName System.Web
$webClient = New-Object System.Net.WebClient
$webClient.Headers.Add("user-agent", $useragent)
$webClient.Headers.Add("Content-Type","application/x-www-form-urlencoded")
$webpage = $webclient.DownloadString($url)
$listImgUrls = $webpage.ToLower() | Select-String -pattern $regex -Allmatches | ForEach-Object {$_.Matches} | Select-Object $_.Value -Unique

foreach($imgUrlString in $listImgUrls) {
    try {
        [System.Uri]$imgUri = New-Object System.Uri -ArgumentList $imgUrlString
        $imgSaveDestination = $FilePath+"\"+([System.IO.Path]::GetFileName($imgUri.LocalPath))
        $webClient.DownloadFile($imgUri, $imgSaveDestination)       
        Write-Output("Downloaded '$imgUrlString' to '$imgSaveDestination'")
    }
    catch { Write-Host("Error: " + $imgUrlString + " - ") -ForegroundColor Yellow -NoNewline; Write-Host($_.Exception.Message) -ForegroundColor Red }
}
