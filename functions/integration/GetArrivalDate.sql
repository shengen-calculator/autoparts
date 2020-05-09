ALTER FUNCTION [dbo].[GetArrivalDate] 
(
	@vendorId int, @term decimal(9,1)
)
RETURNS DATE
AS
BEGIN
    DECLARE @days varchar(15), @time time(7), @diff int, @weekday int, @orderday int
    SELECT  @days = OrderDays, @time = OrderTime
    FROM    dbo.Поставщики
    WHERE   ID_Поставщика = @vendorId  
	
    
    IF(@days IS NULL OR @time IS NULL) RETURN NULL
    
    SET @weekday = DATEPART(weekday, GETDATE())
    
    IF(CAST(GETDATE() AS time) > @time) SET @weekday = @weekday + 1

    SELECT @orderday = MIN(IIF(Name < @weekday, 8, Name)) FROM dbo.SplitString (@days)
    
    IF(@orderday = 8) 
        BEGIN 
           SELECT @orderday = MIN(Name) FROM dbo.SplitString (@days)
           RETURN DATEADD(hour, (7 - DATEPART(weekday, GETDATE()) + @orderday + @term)*24, DATEADD(day, DATEDIFF(day, 0, GETDATE()),0))
        END

    RETURN DATEADD(hour, (@orderday - DATEPART(weekday, GETDATE()) + @term)*24, DATEADD(day, DATEDIFF(day, 0, GETDATE()),0))
            
END