-- =============================================
-- Author:              
-- Create date:
-- Last update:
-- Description:
-- =============================================
 
BEGIN TRY
    BEGIN TRANSACTION
       
       
    COMMIT TRANSACTION 
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    DECLARE @ErrorMessage nvarchar(MAX)
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @ErrorLine INT;
 
    SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY(),@ErrorLine = ERROR_LINE(),@ErrorState = ERROR_STATE();
    SET @ErrorMessage = ('Error in query XXX ' + CAST(@ErrorLine AS nvarchar(20)) + ' Message ' + @ErrorMessage);
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
