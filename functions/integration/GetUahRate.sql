CREATE FUNCTION GetUahRate
(

)
RETURNS decimal(9,2)
AS
BEGIN
    DECLARE @uah decimal(9,2)
	SELECT TOP 1 @uah = Евро FROM dbo.[Курс валют]
    ORDER BY ID_Курса DESC

	RETURN @uah

END