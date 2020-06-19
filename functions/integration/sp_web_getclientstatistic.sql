CREATE PROCEDURE [dbo].[sp_web_getclientstatistic] @startDate DATE, @endDate DATE
AS
BEGIN
    SELECT ISNULL(RES.ID_Клиента, ORD.ID_Клиента) AS ClientId,
           ISNULL(RES.VIP, ORD.VIP)               AS VIP,
           ISNULL(RES.EMail, ORD.EMail)           AS Email,
           ISNULL(RES.Reserves, 0)                AS Reserves,
           ISNULL(ORD.Orders, 0)                  AS Orders
    FROM (SELECT dbo.Клиенты.ID_Клиента,
                 dbo.Клиенты.VIP,
                 dbo.Клиенты.EMail,
                 COUNT(dbo.[Подчиненная накладные].ID) AS Reserves
          FROM dbo.Клиенты
                   LEFT OUTER JOIN
               dbo.[Подчиненная накладные] ON dbo.Клиенты.ID_Клиента = dbo.[Подчиненная накладные].ID_Клиента
          WHERE (dbo.[Подчиненная накладные].Дата >= @startDate)
            AND (dbo.[Подчиненная накладные].Дата <= @endDate)
          GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, dbo.Клиенты.EMail
          HAVING (dbo.Клиенты.ID_Клиента <> 378)) AS RES
             FULL OUTER JOIN (SELECT dbo.Клиенты.ID_Клиента,
                                     dbo.Клиенты.VIP,
                                     dbo.Клиенты.EMail,
                                     COUNT(dbo.[Запросы клиентов].ID_Запроса) AS Orders
                              FROM dbo.Клиенты
                                       INNER JOIN
                                   dbo.[Запросы клиентов] ON dbo.Клиенты.ID_Клиента = dbo.[Запросы клиентов].ID_Клиента
                              WHERE (dbo.[Запросы клиентов].Заказано > 0)
                                AND (dbo.[Запросы клиентов].Интернет = 1)
                                AND (dbo.[Запросы клиентов].Дата <= @endDate)
                                AND (dbo.[Запросы клиентов].Дата >= @startDate)
                              GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, dbo.Клиенты.EMail
                              HAVING (dbo.Клиенты.ID_Клиента <> 378)) AS ORD ON RES.ID_Клиента = ORD.ID_Клиента


END
go

