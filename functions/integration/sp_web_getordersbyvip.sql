CREATE PROCEDURE [dbo].[sp_web_getordersbyvip]
	@vip varchar(10)
AS
BEGIN
SELECT DISTINCT
			TOP (100) TRIM(VIP) as vip
			,ID_Запроса as id
			,TRIM([Сокращенное название]) as vendor
			,TRIM(Брэнд) as brand
			,TRIM([Номер поставщика]) as number
			,Альтернатива as note
			,Заказано as ordered
			,Подтверждение as approved
			,FORMAT(ISNULL(Предварительная_дата, Дата_прихода), 'd', 'de-de') as shipmentDate
			,Цена as euro
			,Грн as uah
			,ID_Запчасти as productId
			,ID_Заказа as orderId
			,FORMAT (Дата, 'd', 'de-de' ) as orderDate
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
	WHERE  VIP like @vip AND [Обработано] = 0 AND [ID_Клиента] <> 378
END