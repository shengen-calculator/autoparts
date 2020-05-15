CREATE PROCEDURE [dbo].[sp_web_getreservesbyvip]
	@vip varchar(10), @isVendorShown bit
AS
BEGIN
    DECLARE @query  AS NVARCHAR(MAX)

    SET @query = N'SELECT TOP (100) [ID] as id'

    IF(@isVendorShown = 1)
        SET @query = @query + N',TRIM([Поставщик]) as vendor, TRIM([Статус]) as note'

    SET @query = @query + N'
      ,[ID_Накладной] as invoiceId
      ,TRIM([VIP]) as vip
      ,TRIM([Брэнд]) as brand
      ,[Количество] as quantity
      ,[Цена] as euro
      ,[Грн] as uah
      ,[ID_Клиента] as clientId
      ,[ID_Запчасти] as productId
      ,TRIM([Описание]) as description
      ,FORMAT([Дата резерва], ''d'', ''de-de'') as ''date''
      ,FORMAT([Дата запроса], ''d'', ''de-de'') as orderDate
      ,[Интернет] as source
      ,TRIM([Номер поставщика]) as number
  FROM [dbo].[Накладные]
  WHERE  VIP like ''' +  @vip + N''' AND [Обработано] = 0 AND [ID_Клиента] <> 378'

    exec sp_executesql @query

END
go

