DECLARE @ServerID int

DECLARE AllServers CURSOR FORWARD_ONLY FOR
		SELECT [Servers].ServerID FROM [dbo].[Servers] WHERE ProjectID = 1
OPEN AllServers
FETCH NEXT FROM AllServers INTO @ServerID

    WHILE @@FETCH_STATUS = 0
    BEGIN
    	PRINT 'Server: ' + CONVERT(nvarchar(50),@ServerID)
    	FETCH NEXT FROM AllServers INTO @ServerID  
    END

CLOSE AllServers
DEALLOCATE AllServers