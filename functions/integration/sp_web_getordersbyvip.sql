CREATE PROCEDURE [dbo].[sp_web_getordersbyvip]
	@vip varchar(10)
AS
BEGIN
SELECT DISTINCT
			TOP (100) VIP
			,ID_Запроса as id
			,[Сокращенное название] as vendor
			,Брэнд as brand
			,[Номер поставщика] as number
			,Альтернатива as note
			,Заказано as ordered
			,Подтверждение as approved
			,Предварительная_дата as shipmentDate
			,Цена as euro
			,Грн as uah
			,ID_Запчасти as productId
			,ID_Заказа as orderId
			,Дата as orderDate
			,Описание as description
			,CASE
				WHEN Заказано = Подтверждение AND Подтверждение > 0 THEN 0 /* подтвержден */
				WHEN Подтверждение = 0 AND Нет = 0 THEN 1  /* в обработке */
				WHEN Заказано > Подтверждение AND Подтверждение > 0 THEN 2  /* неполное кол-во */
				WHEN Задерживается = 1 THEN 3  /* задерживается */
				WHEN Нет = 1 THEN 4  /* нету */
				ELSE 1
			END as status

	FROM   dbo.Запросы
	WHERE  VIP like @vip AND [Обработано] = 0 AND [ID_Клиента] <> 378
END