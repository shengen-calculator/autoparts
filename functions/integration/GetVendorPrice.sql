CREATE FUNCTION [dbo].[GetVendorPrice](@productId INT)
    RETURNS DECIMAL(9, 2)
AS
BEGIN
    DECLARE @vendorPrice DECIMAL(12, 2)
    SELECT @vendorPrice = MAX(dbo.[Каталоги поставщиков].Цена7)
    FROM dbo.[Каталоги поставщиков]
             INNER JOIN
         dbo.[Каталог запчастей] ON dbo.[Каталоги поставщиков].ID_Поставщика = dbo.[Каталог запчастей].ID_Поставщика AND
                                    dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost
             INNER JOIN
         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда AND
                       dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд
    GROUP BY dbo.[Каталог запчастей].ID_Запчасти
    HAVING (dbo.[Каталог запчастей].ID_Запчасти = @productId)

    RETURN @vendorPrice
END
go

