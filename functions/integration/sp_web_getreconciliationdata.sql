CREATE PROCEDURE [dbo].[sp_web_getreconciliationdata] @clientId INT, @startDate DATE, @endDate DATE
AS
BEGIN
    SELECT dbo.[Подчиненная накладные].ID_Накладной       AS invoiceNumber,
           dbo.[Подчиненная накладные].Количество         AS quantity,
           dbo.[Подчиненная накладные].Цена               AS priceEur,
           dbo.[Подчиненная накладные].Грн                AS priceUah,
           IIF(dbo.[Подчиненная накладные].Количество > 0,
               dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной),
               dbo.[Подчиненная накладные].Дата_закрытия) AS invoiceDate,
           dbo.Брэнды.Брэнд                               AS brand,
           dbo.[Каталог запчастей].[Номер поставщика]     AS number,
           dbo.[Каталог запчастей].Описание               AS description
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
      AND (dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной) >= @startDate)
      AND (dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной) <= @endDate)
    UNION

    SELECT 0                   as invoiceNumber,
           0                   as quantity,
           Цена                as priceEur,
           Грн                 as priceUah,
           CONVERT(date, Дата) AS invoiceDate,
           ''                  as brand,
           ''                  as number,
           Примечание          as description
    FROM dbo.Касса
    WHERE (ID_Клиента = @clientId)
      AND (CONVERT(date, Дата) >= @startDate)
      AND (CONVERT(date, Дата) <= @endDate)
    ORDER BY InvoiceDate, invoiceNumber
END
go

