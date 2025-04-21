CREATE PROCEDURE [dbo].[sp_web_getvendorstatistics]
	@startDate char(19),	@endDate char(19)
AS
BEGIN
	SELECT        TOP (100)
	dbo.[Каталог запчастей].ID_Поставщика AS vendorId
	,TRIM(dbo.Поставщики.[Сокращенное название]) AS vendor
	,COUNT(dbo.[Запросы клиентов].ID_Запроса) AS quantity
	FROM            dbo.[Каталог запчастей] INNER JOIN
							 dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
							 dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
	WHERE        (dbo.[Запросы клиентов].Подтверждение = 0) AND (dbo.[Запросы клиентов].Интернет = 1) AND (dbo.[Запросы клиентов].Обработано = 0) AND (dbo.[Запросы клиентов].Заказано > 0) AND
							 (dbo.[Запросы клиентов].ID_Клиента <> 378) AND (dbo.[Запросы клиентов].Дата >= CONVERT(DATETIME, @startDate, 102)) AND (dbo.[Запросы клиентов].Дата < CONVERT(DATETIME, @endDate, 102) + 1)
	GROUP BY dbo.[Каталог запчастей].ID_Поставщика, dbo.Поставщики.[Сокращенное название]
END

ALTER PROCEDURE [dbo].[sp_web_getvendorstatistics]
AS
BEGIN
	SELECT        TOP (100)
	dbo.[Каталог запчастей].ID_Поставщика AS vendorId
	,TRIM(dbo.Поставщики.[Сокращенное название]) AS vendor
	,COUNT(dbo.[Запросы клиентов].ID_Запроса) AS quantity
	FROM            dbo.[Каталог запчастей] INNER JOIN
							 dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
							 dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
	WHERE        (dbo.[Запросы клиентов].Подтверждение = 0) AND (dbo.[Запросы клиентов].Интернет = 1) AND (dbo.[Запросы клиентов].Обработано = 0) AND (dbo.[Запросы клиентов].Заказано > 0) AND
							 (dbo.[Запросы клиентов].ID_Клиента <> 378)
	GROUP BY dbo.[Каталог запчастей].ID_Поставщика, dbo.Поставщики.[Сокращенное название]
END

