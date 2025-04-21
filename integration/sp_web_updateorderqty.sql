CREATE PROCEDURE [dbo].[sp_web_updateorderqty]
    @orderId INT, @quantity INT
AS
BEGIN
	UPDATE dbo.[Запросы клиентов] SET Заказано = @quantity WHERE ID_Запроса = @orderId
END
go