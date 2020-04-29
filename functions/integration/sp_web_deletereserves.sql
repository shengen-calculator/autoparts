CREATE PROCEDURE [dbo].[sp_web_deletereserves]
    @ids varchar(300)
AS
BEGIN
	DELETE FROM dbo.[Подчиненная накладные] WHERE ID IN (SELECT Name FROM dbo.SplitString (@ids))
END
go
