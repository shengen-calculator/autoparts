CREATE PROCEDURE [dbo].[sp_web_getcurrencyrate]
AS
BEGIN
    SELECT TOP (1) Дата, Доллар AS USD, Евро AS EUR
    FROM dbo.[Курс валют]
    ORDER BY Дата DESC
END
go

