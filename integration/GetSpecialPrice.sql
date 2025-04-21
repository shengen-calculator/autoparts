CREATE FUNCTION [dbo].[GetSpecialPrice]
(
    @clientId int,
    @productId int
)
RETURNS decimal(9,2)
AS
BEGIN
    DECLARE @price decimal(9,2)
    SELECT TOP (1) @price = Цена
    FROM   dbo.Спец_цены
    WHERE (ID_Запчасти = @productId) AND (ID_Клиента = @clientId)

	RETURN @price

END
go