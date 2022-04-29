Function New-RandomPassword{
    Param([ValidateRange(8, 32)] [int]$Length = 16)
    $AsciiCharsList = @(); $Password = ""
    foreach ($a in (33..126)){ $AsciiCharsList += , [char][byte]$a }    
    do { Foreach ($loop in (1..$Length)) { $Password += $AsciiCharsList | Get-Random } }
    until ($Password -match "(?=^.{8,32}$)((?=.*\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*")
    return $Password
}

Function New-PWMatrix{
    Param([int]$rows = 5, [int]$columns = 20, [int]$pwlength = 20)
    for ($i = 0; $i -lt ($columns); $i++) {
        $line = ""
        for ($j = 0; $j -lt ($rows); $j++) { $line += "$(New-RandomPassword($pwlength)) " }
        Write-Host($line) -ForegroundColor Green
    }
    Write-Host("Password:") -ForegroundColor black -BackgroundColor yellow -NoNewline
    Write-Host(" " + $(New-RandomPassword($pwlength))) -ForegroundColor Red
}

New-PWMatrix 6 20 16