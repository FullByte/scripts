BEGIN TRY
BEGIN TRANSACTION

DECLARE @TextString nvarchar(max) SET @TextString = 'This is a test example'
DECLARE @SearchString nvarchar(250) SET @SearchString = 'test'
DECLARE @Answer nvarchar(max) SET @Answer =
		(SELECT SUBSTRING(@TextString, CONVERT(int,
			(SELECT CHARINDEX(@SearchString, @TextString))),CONVERT(int,(
				SELECT LEN(@TextString)))-CONVERT(int,(
					SELECT CHARINDEX(@SearchString, @TextString)))+1))

PRINT @Answer
COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
END CATCH
