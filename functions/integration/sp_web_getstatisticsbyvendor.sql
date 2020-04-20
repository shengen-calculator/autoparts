CREATE PROCEDURE [dbo].[sp_web_getstatisticsbyvendor]
	@startDate char(19),	@endDate char(19), @vendorId int
AS
BEGIN

	SELECT TOP(200) [Запросы клиентов].ID_Запроса AS id
		,[Запросы клиентов].Работник AS vip
		,Брэнды.Брэнд AS brand
		,[Каталог запчастей].[Номер запчасти] AS number
		,[Запросы клиентов].Заказано AS quantity
		,[Запросы клиентов].Цена AS price
		,[Запросы клиентов].Дата AS date
		,ISNULL(Остаток_по_аналогу.Остаток,0) AS available
	FROM         [Каталог запчастей] INNER JOIN
                     [Запросы клиентов] ON [Каталог запчастей].ID_Запчасти = [Запросы клиентов].ID_Запчасти INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда LEFT OUTER JOIN
                      Остаток_по_аналогу ON [Каталог запчастей].ID_аналога = Остаток_по_аналогу.ID_аналога
	WHERE     ([Запросы клиентов].Подтверждение = 0) AND ([Запросы клиентов].Интернет = 1) AND ([Запросы клиентов].Обработано = 0) AND
						  ([Запросы клиентов].Заказано > 0) AND ([Запросы клиентов].ID_Клиента <> 378) AND ([Каталог запчастей].ID_Поставщика = @vendorId) AND
						  ([Запросы клиентов].Дата >= CONVERT(DATETIME, @startDate, 102)) AND ([Запросы клиентов].Дата < CONVERT(DATETIME, @endDate, 102) + 1)
	ORDER BY [Запросы клиентов].Дата DESC
END