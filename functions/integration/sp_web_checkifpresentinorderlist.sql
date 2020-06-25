CREATE PROCEDURE sp_web_checkifpresentinorderlist
@sparesId int
AS

SELECT dbo.Клиенты.VIP AS vip,
       dbo.Поставщики.[Сокращенное название] AS vendor,
       Брэнды_1.Брэнд AS brand,
       [Каталог запчастей_1].[Номер запчасти] AS number,
       dbo.[Запросы клиентов].Заказано AS quantity,
       dbo.[Запросы клиентов].Альтернатива AS alternative,
       dbo.[Запросы клиентов].Дата_заказа AS date,
       dbo.[Запросы клиентов].Срочно AS isUrgent,
       dbo.[Заказы поставщикам].Предварительная_дата AS preliminaryDate
FROM (SELECT MAX(dbo.[Каталог запчастей].ID_аналога) AS analogId
      FROM dbo.[Каталоги поставщиков]
               INNER JOIN
           dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд
               INNER JOIN
           dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда AND
                                      dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost
      WHERE (dbo.[Каталоги поставщиков].ID_Запчасти = @sparesId)) AS AnalogTable
         INNER JOIN
     dbo.[Каталог запчастей] AS [Каталог запчастей_1] ON AnalogTable.analogId = [Каталог запчастей_1].ID_аналога
         INNER JOIN
     dbo.[Запросы клиентов] ON [Каталог запчастей_1].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти
         INNER JOIN
     dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента
         INNER JOIN
     dbo.Брэнды AS Брэнды_1 ON [Каталог запчастей_1].ID_Брэнда = Брэнды_1.ID_Брэнда
         INNER JOIN
     dbo.Поставщики ON [Каталог запчастей_1].ID_Поставщика = dbo.Поставщики.ID_Поставщика
         LEFT OUTER JOIN
     dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
WHERE (dbo.[Запросы клиентов].Заказано <> 0)
  AND (dbo.[Запросы клиентов].Доставлено = 0)
  AND (dbo.[Запросы клиентов].Обработано = 0)
go

