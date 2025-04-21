CREATE FUNCTION GetClientPriceColumn
(
	@clientId int
)
RETURNS varchar(6)
AS
BEGIN

	DECLARE @result varchar(6)

	SELECT       @result = dbo.[Тарифные модели].Столбец
	FROM            dbo.Клиенты INNER JOIN
								dbo.[Тарифные модели] ON dbo.Клиенты.ID_Модели_тариф = dbo.[Тарифные модели].ID_Модели_тариф
	WHERE        (dbo.Клиенты.ID_Клиента = @clientId)
	RETURN		 @result

END
go

