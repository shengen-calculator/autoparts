CREATE PROCEDURE [dbo].[sp_web_updatereserveqty]
    @reserveId INT, @quantity INT
AS
BEGIN
    UPDATE dbo.[Подчиненная накладные] SET Количество = @quantity  WHERE ID = @reserveId
END
go
