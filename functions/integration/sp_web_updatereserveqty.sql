CREATE PROCEDURE [dbo].[sp_web_updatereserveqty]
    @reserveId INT, @oldQuantity INT, @newQuantity INT, @productId INT
AS
BEGIN
    DECLARE @balance INT

    BEGIN TRANSACTION;

        SELECT  @balance = Остаток
        FROM    dbo.Остаток_
        WHERE  (ID_Запчасти = @productId)
        IF(@balance + @oldQuantity > @newQuantity)
            UPDATE dbo.[Подчиненная накладные] SET Количество = @newQuantity  WHERE ID = @reserveId
        ELSE
            RAISERROR ('Quantity update operation error. Quantity is not enough', 16, 1)

    COMMIT;

END
go