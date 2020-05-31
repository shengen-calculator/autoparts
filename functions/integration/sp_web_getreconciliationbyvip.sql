CREATE PROCEDURE [dbo].[sp_web_getreconciliationbyvip] @vip varchar(10)
AS
BEGIN
    SELECT dbo.[Подчиненная накладные].ID_Накладной                     AS InvoiceNumber,
           dbo.[Подчиненная накладные].Количество                       AS Quantity,
           dbo.[Подчиненная накладные].Цена                             AS priceEur,
           dbo.[Подчиненная накладные].Грн                              AS priceUah,
           dbo.GetInvoiceDate(dbo.[Подчиненная накладные].ID_Накладной) AS InvoiceDate,
           dbo.Брэнды.Брэнд                                             AS Brand,
           dbo.[Каталог запчастей].[Номер запчасти]                     AS Number,
           dbo.[Каталог запчастей].Описание                             AS Description
    FROM dbo.[Подчиненная накладные]
             INNER JOIN
         dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
             INNER JOIN
         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
    WHERE (dbo.[Подчиненная накладные].ID_Накладной IS NOT NULL)
      AND (dbo.[Подчиненная накладные].Дата_закрытия IS NOT NULL)
      AND (dbo.[Подчиненная накладные].ID_Клиента = @vip)
      AND (dbo.[Подчиненная накладные].Нету = 0)
      AND (dbo.[Подчиненная накладные].Обработано = 1)
    UNION

    SELECT 0                   as InvoiceNumber,
           0                   as Quantity,
           Цена                as priceEur,
           Грн                 as priceUah,
           CONVERT(date, Дата) AS InvoiceDate,
           ''                  as Brand,
           ''                  as Number,
           ''                  as Description
    FROM dbo.Касса
    WHERE (ID_Клиента = @vip)
    ORDER BY InvoiceDate
END
go

