BEGIN TRY
BEGIN TRANSACTION

  DECLARE @tmp TABLE (id int)

  DECLARE @id NVARCHAR(36)
  DECLARE @pos INT
  DECLARE @list NVARCHAR(MAX)
  SET @list ='1,123,12,312,3,2,34,23,23,4,234,23,42,34,23,4,23,4'

  SET @list = LTRIM(RTRIM(@list))+ ','
  SET @Pos = CHARINDEX(',', @list, 1)

  IF REPLACE(@list, ',', '') <> ''
  BEGIN
    WHILE (@pos > 0)
    BEGIN
      SET @id = LTRIM(RTRIM(LEFT(@list, @pos - 1)))
      IF (@id <> '')
      BEGIN
        INSERT INTO @tmp (id)
        VALUES (@id)
      END
      SET @list = RIGHT(@list, LEN(@list) - @pos)
      SET @pos = CHARINDEX(',', @list, 1)
    END
  END

  SELECT * FROM @tmp


    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
END CATCH