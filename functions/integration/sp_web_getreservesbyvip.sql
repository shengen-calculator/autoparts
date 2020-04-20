CREATE PROCEDURE [dbo].[sp_web_getreservesbyvip]
	@vip varchar(10)
AS
BEGIN
	SELECT TOP (100) [ID] as id
      ,[ID_Накладной] as invoiceId
      ,[VIP] as vip
      ,[Брэнд] as brand
      ,[Количество] as quantity
      ,[Цена] as euro
      ,[Грн] as uah
      ,[ID_Клиента] as clientId
      ,[ID_Запчасти] as productId
      ,[Описание] as description
      ,[Поставщик] as vendor
      ,[Статус] as note
      ,[Дата резерва] as 'date'
      ,[Дата запроса] as orderDate
      ,[Интернет] as source
      ,[Номер поставщика] as number
  FROM [dbo].[Накладные]
  WHERE  VIP like @vip AND [Обработано] = 0 AND [ID_Клиента] <> 378
END
