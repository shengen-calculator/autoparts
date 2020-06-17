CREATE PROCEDURE [dbo].[sp_web_getclientstatistic] @startDate DATE, @endDate DATE
AS
BEGIN
    SELECT ISNULL(RES.ID_Клиента, ORD.ID_Клиента) AS ClientId,
           ISNULL(RES.VIP, ORD.VIP)               AS VIP,
           ISNULL(RES.Reserves, 0)                AS Reserves,
           ISNULL(ORD.Orders, 0)                  AS Orders
    FROM (SELECT dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, COUNT(dbo.[Подчиненная накладные].ID) AS Reserves
          FROM dbo.Клиенты
                   LEFT OUTER JOIN
               dbo.[Подчиненная накладные] ON dbo.Клиенты.ID_Клиента = dbo.[Подчиненная накладные].ID_Клиента
          WHERE (dbo.[Подчиненная накладные].Дата > CONVERT(DATETIME, @startDate, 102))
            AND (dbo.[Подчиненная накладные].Дата < CONVERT(DATETIME, @endDate, 102))
            AND (dbo.[Подчиненная накладные].Нету = 0)
          GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP
          HAVING (dbo.Клиенты.ID_Клиента <> 378)) AS RES
             FULL OUTER JOIN (SELECT dbo.Клиенты.ID_Клиента,
                                     dbo.Клиенты.VIP,
                                     COUNT(dbo.[Запросы клиентов].ID_Запроса) AS Orders
                              FROM dbo.Клиенты
                                       INNER JOIN
                                   dbo.[Запросы клиентов] ON dbo.Клиенты.ID_Клиента = dbo.[Запросы клиентов].ID_Клиента
                              WHERE (dbo.[Запросы клиентов].Заказано > 0)
                                AND (dbo.[Запросы клиентов].Дата < CONVERT(DATETIME, @endDate, 102))
                                AND (dbo.[Запросы клиентов].Дата > CONVERT(DATETIME, @startDate, 102))
                              GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP
                              HAVING (dbo.Клиенты.ID_Клиента <> 378)) AS ORD ON RES.ID_Клиента = ORD.ID_Клиента


END
go
