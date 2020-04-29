CREATE PROCEDURE [dbo].[sp_web_deleteorders]
    @ids varchar(300)
AS
BEGIN
	UPDATE dbo.[Запросы клиентов] SET Заказано = 0, Обработано = 1 WHERE ID_Запроса IN (SELECT Name FROM dbo.SplitString (@ids))
END
go