DECLARE @DBtoKill nvarchar(128) SET @DBtoKill = 'dbname'
 
USE [master]
 
-- Kill all process running on DB to Kill
DECLARE @CMD varchar(50)
DECLARE @SPIDtoKill INT
DECLARE @ProcessTable TABLE([SPID] INT, [Status] VARCHAR(MAX), [LOGIN] VARCHAR(MAX), [HostName] VARCHAR(MAX),
        [BlkBy] VARCHAR(MAX), [DBName] VARCHAR(MAX), [Command] VARCHAR(MAX), [CPUTime] INT,
        [DiskIO] INT, [LastBatch] VARCHAR(MAX), [ProgramName] VARCHAR(MAX), [SPID_1] INT,
        [REQUESTID] INT)
 
INSERT INTO @ProcessTable EXEC sp_who2
 
DECLARE ProjectsToKill CURSOR FORWARD_ONLY FOR         
SELECT SPID AS [SPIDtoKill] FROM @ProcessTable WHERE [DBName] = @DBtoKill
OPEN ProjectsToKill 
        FETCH NEXT FROM ProjectsToKill INTO @SPIDtoKill
        WHILE @@FETCH_STATUS = 0
        BEGIN   
                SELECT @CMD = 'KILL ' + CAST(@SPIDtoKill AS varchar(5))
                EXEC (@CMD)
               
                FETCH NEXT FROM ProjectsToKill INTO @SPIDtoKill
        END
CLOSE ProjectsToKill
DEALLOCATE ProjectsToKill
 
-- Drop Table
EXEC('ALTER DATABASE ' + @DBtoKill + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE')
EXEC('ALTER DATABASE ' + @DBtoKill + ' SET OFFLINE')
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = @DBtoKill
EXEC('DROP DATABASE ' + @DBtoKill)
 
-- DELETE file if still there
EXEC sp_configure 'show advanced options', 1
EXEC sp_configure 'xp_cmdshell', 1
GO
reconfigure
GO
 
DECLARE @DeleteCommand nvarchar(250)
DECLARE @FileName nvarchar(250)
 
SET @FileName = (SELECT filename From master..sysdatabases WHERE Name = 'DBname')
SET @DeleteCommand = 'del ' + @FileName EXEC xp_cmdshell @DeleteCommand
 
SET @DBtoKill = 'DBname' + '_log'
SET @FileName = (SELECT filename From master..sysdatabases WHERE Name = 'DBname')
SET @DeleteCommand = 'del ' + @FileName EXEC xp_cmdshell @DeleteCommand
 
GO