# http://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki

add-type -Path "D:\sqlite-netFx46-binary-x64-2015-1.0.109.0\System.Data.SQLite.dll"            
            
$connectionstring = "data source=D:\test\gpstestdb.db"             
$sqliteconnection = New-Object -TypeName System.Data.SQLite.SQLiteConnection          
$sqliteconnection.ConnectionString = $connectionstring        
$sqliteconnection.Open()  

function createDB($sqlitecommandcreate, $connectionstring){            
    $newDBquery = $sqliteconnection.CreateCommand()          
    $newDBquery.CommandText = $sqlitecommandcreate     
    $newDBquery.ExecuteNonQuery()           
    $newDBquery.Dispose()      
}            
            
$sqlitecommandcreate = "CREATE TABLE example (string varchar(20), number int)"
createDB $sqlitecommandcreate $connectionstring

function insertRow($sqlitecommandinsert, $connectionstring) {            
    $newInsertQuery = $sqliteconnection.CreateCommand()            
    $newInsertQuery.CommandText = $sqlitecommandinsert # pass your query            
    $newInsertQuery.Parameters.AddWithValue("@string", "example-name")            
    $newInsertQuery.ExecuteNonQuery()
    $newInsertQuery.Dispose()        
}            
            
$sqlitecommandinsert = "INSERT INTO example (string, number) VALUES (@string, 4)"
insertRow $sqlitecommandinsert $connectionstring

$sqliteconnection.Dispose() 
