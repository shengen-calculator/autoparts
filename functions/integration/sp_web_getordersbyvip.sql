CREATE PROCEDURE [dbo].[sp_web_getordersbyvip] @vip varchar(10), @isVendorShown bit
AS
BEGIN
    DECLARE @query AS NVARCHAR(MAX)

    SET @query = N'SELECT DISTINCT TOP (100) TRIM(VIP) as vip'


    IF (@isVendorShown = 1)
        SET @query = @query + N',TRIM([Сокращенное название]) AS vendor, Альтернатива as note'

    SET @query = @query + N'
			,ID_Запроса as id
			,TRIM(Брэнд) as brand
			,TRIM([Номер поставщика]) as number
			,Заказано as ordered
			,Подтверждение as approved
			,FORMAT(ISNULL(Предварительная_дата, Дата_прихода), ''dd.MM.yyyy'') as shipmentDate
			,Цена as euro
			,Грн as uah
			,ID_Запчасти as productId
			,ID_Заказа as orderId
			,FORMAT (Дата, ''dd.MM.yyyy HH:mm'' ) as orderDate
			,TRIM(Описание) as description
			,CASE
				WHEN Задерживается = 1 THEN 3  /* задерживается */
				WHEN Нет = 1 THEN 4  /* нету */
				WHEN Заказано = Подтверждение AND Подтверждение > 0 THEN 0 /* подтвержден */
				WHEN Подтверждение = 0 AND Нет = 0 THEN 1  /* в обработке */
				WHEN Заказано > Подтверждение AND Подтверждение > 0 THEN 2  /* неполное кол-во */
				ELSE 1
			END as status
	FROM   dbo.Запросы
	WHERE  VIP like ''' + @vip + N''' AND [Обработано] = 0 AND [ID_Клиента] <> 378'

    exec sp_executesql @query
END
go

