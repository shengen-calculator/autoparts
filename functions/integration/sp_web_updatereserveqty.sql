CREATE PROCEDURE [dbo].[sp_web_updatereserveqty]
    @reserveId INT, @quantity INT, @productId INT
AS
BEGIN
    DECLARE @balance INT, @reserved INT, @oldQuantity INT

    BEGIN TRANSACTION;

        SELECT  @reserved = Количество
        FROM    dbo.Резерв_1
        WHERE   (ID_Запчасти = @productId)

        SELECT @oldQuantity = Количество
        FROM   dbo.[Подчиненная накладные]
        WHERE  (ID = @reserveId)

        SELECT  @balance = Остаток
        FROM    dbo.Остаток_
        WHERE  (ID_Запчасти = @productId)

        IF(@balance - @reserved + @oldQuantity >= @quantity)
            UPDATE dbo.[Подчиненная накладные] SET Количество = @quantity  WHERE ID = @reserveId
        ELSE
            RAISERROR ('Quantity update operation error. Quantity is not enough', 16, 1)

    COMMIT;

END
go


