CREATE PROCEDURE [dbo].[sp_web_getpaymenthistory] @vip VARCHAR(10), @offset INT, @rows INT
AS
BEGIN
    SELECT ID_Касса                             as id,
           Цена                                 as amountEur,
           Грн                                  as amountUah,
           FORMAT(dbo.Касса.Дата, 'dd.MM.yyyy') AS date,
           dbo.Касса.Примечание                 as description,
           COUNT(*) OVER ()                     as totalCount
    FROM dbo.Касса
             INNER JOIN
         dbo.Клиенты ON dbo.Касса.ID_Клиента = dbo.Клиенты.ID_Клиента
    WHERE dbo.Клиенты.VIP LIKE @vip
    ORDER BY dbo.[Касса].ID_Касса DESC OFFSET @offset ROWS FETCH NEXT @rows ROWS ONLY

END
go

