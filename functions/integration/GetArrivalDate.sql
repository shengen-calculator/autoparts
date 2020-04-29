CREATE FUNCTION GetArrivalDate
(
	@vendorId int, @term decimal(9,1)
)
RETURNS DATE
AS
BEGIN
    DECLARE @days varchar(15), @time time(7), @diff int, @weekday int
    SELECT  @days = OrderDays, @time = OrderTime
    FROM    dbo.Поставщики
    WHERE   ID_Поставщика = @vendorId

    IF(@days IS NULL OR @time IS NULL) RETURN NULL

    IF(CAST(GETDATE() AS time) > @time) SET @diff = @diff + 1
    SET @weekday = DATEPART(weekday, GETDATE())

    /*SELECT value FROM STRING_SPLIT(@days, ',')*/

	RETURN DATEADD(day, 2, GETDATE())

END
GO