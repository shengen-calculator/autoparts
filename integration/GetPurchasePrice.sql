CREATE FUNCTION [dbo].[GetPurchasePrice](@productId INT)
    RETURNS DECIMAL(9, 2)
AS
BEGIN
    DECLARE @purchasePrice DECIMAL(12, 2)
    SELECT TOP (1) @purchasePrice = Цена_закупки
    FROM dbo.Операции
    WHERE (Приход > 0)
      AND (ID_Запчасти = @productId)
    ORDER BY ID_Операции DESC

    RETURN @purchasePrice
END
go

