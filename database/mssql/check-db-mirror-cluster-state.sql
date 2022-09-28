USE [master]
 
DECLARE @DBName nvarchar(max) SET @DBName = 'dbname'
DECLARE @MirrorState nvarchar(max)
 
SET @MirrorState= (SELECT TOP 1 [M].[mirroring_role_desc] FROM sys.database_mirroring [M]
INNER JOIN sys.databases [DB] ON [M].[database_id] = [DB].[database_id]
WHERE [M].[mirroring_role_desc] IS NOT NULL AND [DB].[name] = @DBName)
 
IF (@MirrorState = 'PRINCIPAL')
BEGIN
        PRINT 'Principal'
END
ELSE IF (@MirrorState = 'MIRROR')
BEGIN
        PRINT 'Mirror'
END
ELSE
BEGIN
        PRINT 'Not a mirrored DB or DB not found.'
END