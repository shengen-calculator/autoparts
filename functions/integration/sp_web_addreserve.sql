CREATE PROCEDURE [dbo].[sp_web_addreserve]
	@clientId int,
	@productId int,
	@price decimal(9,2),
	@priceUah decimal(9,2),
	@quantity int,
	@status char(50),
	@customer char(20)
AS
BEGIN
	INSERT INTO [Подчиненная накладные]
	  (ID_Клиента, ID_Запчасти, Цена, Грн, Количество, Статус, Работник)
	  VALUES (@clientId, @productId, @price, @priceUah, @quantity, @status, @customer);

	SELECT TOP (1) [ID] as id
      ,[ID_Накладной] as invoiceId
      ,TRIM([VIP]) as vip
      ,TRIM([Брэнд]) as brand
      ,[Количество] as quantity
      ,[Цена] as euro
      ,[Грн] as uah
      ,[ID_Клиента] as clientId
      ,[ID_Запчасти] as productId
      ,TRIM([Описание]) as description
      ,TRIM([Поставщик]) as vendor
      ,TRIM([Статус]) as note
      ,FORMAT([Дата резерва], 'd', 'de-de') as 'date'
      ,FORMAT([Дата запроса], 'd', 'de-de') as orderDate
      ,[Интернет] as source
      ,TRIM([Номер поставщика]) as number
  FROM [dbo].[Накладные]
  WHERE ID = @@IDENTITY

END
