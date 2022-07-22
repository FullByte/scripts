DECLARE @name VARCHAR(255)
DECLARE @type VARCHAR(10)
DECLARE @prefix VARCHAR(255)
DECLARE @sql VARCHAR(255)

DECLARE curs CURSOR FOR
    SELECT [name], xtype  
    FROM sysobjects  
    WHERE xtype IN ('U', 'P', 'FN', 'IF', 'TF', 'V', 'TR') 
    ORDER BY name

OPEN curs
FETCH NEXT FROM curs INTO @name, @type

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @prefix = CASE @type  
        WHEN 'U' THEN 'DROP TABLE'
        WHEN 'P' THEN 'DROP PROCEDURE'
        WHEN 'FN' THEN 'DROP FUNCTION'
        WHEN 'IF' THEN 'DROP FUNCTION'
        WHEN 'TF' THEN 'DROP FUNCTION'
        WHEN 'V' THEN 'DROP VIEW'
        WHEN 'TR' THEN 'DROP TRIGGER'
    END

    SET @sql = @prefix + ' ' + @name
    PRINT @sql
    EXEC(@sql)
    FETCH NEXT FROM curs INTO @name, @type
END

CLOSE curs
DEALLOCATE curs