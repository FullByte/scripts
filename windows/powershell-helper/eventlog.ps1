Function writeEventLogEntry
{
    $message = "$args[0] Time: " + (get-date).ToString('yyyy-MM-dd HH:mm:ss') + " User: " + $env:userdomain + "\" + $env:username
    if ($args[1] -eq "Information") {
        write-eventlog -logname "Windows PowerShell" -source PowerShell -eventID 1999 -entrytype Information -message $message -category 1 -rawdata 10,20    }
    elseif ($args[1] -eq "Warning") {
        write-eventlog -logname "Windows PowerShell" -source PowerShell -eventID 1999 -entrytype Warning -message $message -category 1 -rawdata 10,20    }
    elseif ($args[1] -eq "Error") {
        write-eventlog -logname "Windows PowerShell" -source PowerShell -eventID 1999 -entrytype Error -message $message -category 1 -rawdata 10,20    }
}