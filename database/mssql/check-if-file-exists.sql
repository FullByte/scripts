SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsTableAndColumn]
(
	-- Add the parameters for the function here
	@table nvarchar(max),
	@column nvarchar(max)
)
RETURNS bit
AS
BEGIN
	IF ((SELECT COALESCE(COL_LENGTH(@table,@column),0)) = 0)
	BEGIN
		RETURN 1
	END
	ELSE
	BEGIN
		RETURN 0
	END
END