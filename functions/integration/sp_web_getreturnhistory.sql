CREATE PROCEDURE [dbo].[sp_web_getreturnhistory] @clientId INT, @page INT, @rowsPerPage INT
AS
BEGIN
    SELECT dbo.[Подчиненная накладные].ID             AS id,
           dbo.[Подчиненная накладные].ID_Накладной   AS invoiceNumber,
           dbo.[Подчиненная накладные].Количество     AS quantity,
           dbo.[Подчиненная накладные].Цена           AS priceEur,
           dbo.[Подчиненная накладные].Грн            AS priceUah,
           dbo.[Подчиненная накладные].Дата_закрытия  AS invoiceDate,
           dbo.Брэнды.Брэнд                           AS brand,
           dbo.[Каталог запчастей].[Номер поставщика] AS number,
           dbo.[Каталог запчастей].Описание           AS description,
           COUNT(*) OVER ()                           as totalCount
    FROM dbo.[Подчиненная накладные]
             INNER JOIN
         dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
             INNER JOIN
         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
    WHERE (dbo.[Подчиненная накладные].ID_Накладной IS NOT NULL)
      AND (dbo.[Подчиненная накладные].Дата_закрытия IS NOT NULL)
      AND (dbo.[Подчиненная накладные].ID_Клиента = @clientId)
      AND (dbo.[Подчиненная накладные].Нету = 0)
      AND (dbo.[Подчиненная накладные].Обработано = 1)
      AND (dbo.[Подчиненная накладные].Количество < 0)
    ORDER BY dbo.[Подчиненная накладные].ID DESC OFFSET @page * @rowsPerPage ROWS FETCH NEXT @rowsPerPage ROWS ONLY

END
go

