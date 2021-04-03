CREATE PROCEDURE [dbo].[sp_web_getpaymenthistory] @clientId INT, @page INT, @rowsPerPage INT
AS
BEGIN
    SELECT ID_Касса            as id,
           0                   as invoiceNumber,
           0                   as quantity,
           Цена                as priceEur,
           Грн                 as priceUah,
           CONVERT(date, Дата) AS invoiceDate,
           ''                  as brand,
           ''                  as number,
           Примечание          as description
    FROM dbo.Касса
    WHERE (ID_Клиента = @clientId)
    ORDER BY InvoiceDate, invoiceNumber OFFSET @page * @rowsPerPage ROWS FETCH NEXT @rowsPerPage ROWS ONLY

END
go

