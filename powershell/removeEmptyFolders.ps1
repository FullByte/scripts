

function removeEmptyFolder($tdc)
{
    do {
      $dirs = Get-ChildItem $tdc -directory -recurse | Where-Object { (Get-ChildItem $_.fullName -Force).count -eq 0 } | Select-Object -expandproperty FullName
      $dirs | Foreach-Object { Remove-Item $_ }
    } while ($dirs.count -gt 0)
}

removeEmptyFolder("F:\older")

