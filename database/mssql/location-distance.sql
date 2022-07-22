CREATE FUNCTION dbo.Distance 
( 
    @zip1 CHAR(5), 
    @zip2 CHAR(5) 
) 
RETURNS DECIMAL(12,3) 
AS 
BEGIN 
    DECLARE 
        @lat1 DECIMAL(10,6), 
        @lon1 DECIMAL(10,6), 
        @lat2 DECIMAL(10,6), 
        @lon2 DECIMAL(10,6), 
        @rads DECIMAL(10,8), 
        @dist DECIMAL(12,3), 
        @calc DECIMAL(10,8) 
 
    SELECT 
        @rads = 57.29577951, 
        @lat1 = lat, 
        @lon1 = long 
        FROM Zips 
        WHERE Zip = @zip1 
 
    SELECT  
        @lat2 = lat, 
        @lon2 = long 
        FROM Zips 
        WHERE Zip = @zip2 
 
    SELECT 
        @lat1 = @lat1 / @rads, 
        @lon1 = @lon1 / @rads, 
        @lat2 = @lat2 / @rads, 
        @lon2 = @lon2 / @rads 
 
    IF @lat1 = @lat2 AND @lon1 = @lon2 
        SET @dist = 0.00 
    ELSE 
    BEGIN 
        SET @calc = SIN(@lat1) * SIN(@lat2) + COS(@lat1) 
            * COS(@lat2) * COS(@lon1 - @lon2) 
        IF (@calc) > 1.0 
            SET @calc = 1.0 
        SET @dist = 3963.1 * ACOS(@calc) 
    END 
 
    RETURN (@dist) 
END 
GO