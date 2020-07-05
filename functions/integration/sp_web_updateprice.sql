CREATE PROCEDURE [dbo].[sp_web_updateprice] @productId INT,
                                            @discount INT,
                                            @price DECIMAL(9, 2)
AS
BEGIN
    DECLARE @retail DECIMAL(9, 2)
    SET @retail = @price / (100 - @discount) * 100
    UPDATE dbo.[Каталог запчастей]
    SET Скидка          = IIF(@price = 0, NULL, @discount),
        Цена            = IIF(@price = 0, NULL, @retail),
        Цена4           = IIF(@price = 0, NULL, @price / 1.04),
        Цена14          = IIF(@price = 0, NULL, @price / 1.02),
        Цена5           = IIF(@price = 0, NULL, @retail * 0.75),
        Цена6           = IIF(@price = 0, NULL, @retail * 0.7),
        Цена1           = IIF(@price = 0, NULL, @retail * 0.95),
        Цена2           = IIF(@price = 0, NULL, @retail * 0.9),
        Цена3           = IIF(@price = 0, NULL, @retail * 0.85),
        Цена7           = IIF(@price = 0, NULL, @price),
        Цена13          = IIF(@price = 0, NULL, @price),
        Цена_обработана = IIF(@price = 0, 0, 1)
    WHERE ID_Запчасти = @productId
END
go

