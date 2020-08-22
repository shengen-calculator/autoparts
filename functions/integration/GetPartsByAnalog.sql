CREATE FUNCTION [dbo].[GetPartsByAnalog](@brend char(18),
                                         @name char(25),
                                         @analog int,
                                         @klient int)
    RETURNS TABLE
        AS
        RETURN
            (
                SELECT Id_Запчасти,
                       MAX(ID_аналога) AS ID_аналога,
                       Брэнд,
                       [Сокращенное название],
                       [Время заказа],
                       [Время прихода],
                       [Номер запчасти],
                       Цена,
                       Доступно,
                       Резерв,
                       Описание,
                       Заказ,
                       Срок,
                       Цена1,
                       Цена2,
                       Цена3,
                       Цена4,
                       Цена5,
                       Цена6,
                       Цена7,
                       Цена8,
                       Цена9,
                       Цена10,
                       Цена11,
                       Цена12,
                       Цена13,
                       Цена14,
                       Цена15,
                       Цена16,
                       Цена17,
                       Дата,
                       [Не возвратный],
                       [Виден только менеджерам],
                       IsEnsureDeliveryTerm,
                       IsQualityGuaranteed,
                       IsEnsureDeliveryTermTitle,
                       IsQualityGuaranteedTitle
                FROM (
                         SELECT         Id_Запчасти,
                                        ID_аналога,
                                        Брэнд,
                                        [Сокращенное название],
                                        [Время заказа],
                                        [Время прихода],
                                        [Номер поставщика]    as [Номер запчасти],
                                        isnull(Цена, 0)       as Цена,
                             Доступно = CASE
                                            WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0
                                            ELSE ISnull(Остаток, 0) - isnull(Количество, 0) End,
                                        isnull(Количество, 0) as Резерв,
                                        Описание,
                                        null                  as Заказ,
                                        null                  as Срок,
                             Цена1    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена1, 0) ELSE MAX(Спец_цена) END,
                             Цена2    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена2, 0) ELSE MAX(Спец_цена) END,
                             Цена3    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена3, 0) ELSE MAX(Спец_цена) END,
                             Цена4    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена4, 0) ELSE MAX(Спец_цена) END,
                             Цена5    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена5, 0) ELSE MAX(Спец_цена) END,
                             Цена6    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена6, 0) ELSE MAX(Спец_цена) END,
                             Цена7    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена7, 0) ELSE MAX(Спец_цена) END,
                             Цена8    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена8, 0) ELSE MAX(Спец_цена) END,
                             Цена9    = CASE WHEN MAX(ID_Клиента) is Null then isnull(Цена9, 0) ELSE MAX(Спец_цена) END,
                             Цена10   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена10, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена11   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена11, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена12   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена12, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена13   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена13, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена14   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена14, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена15   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена15, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена16   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена16, 0)
                                            ELSE MAX(Спец_цена) END,
                             Цена17   = CASE
                                            WHEN MAX(ID_Клиента) is Null then isnull(Цена17, 0)
                                            ELSE MAX(Спец_цена) END,
                                        null                  as Дата,
                                        [Не возвратный],
                                        [Виден только менеджерам],
                                        IsEnsureDeliveryTerm,
                                        IsQualityGuaranteed,
                                        CASE
                                            WHEN IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки'
                                            ELSE Null END     AS IsEnsureDeliveryTermTitle,
                                        CASE
                                            WHEN IsQualityGuaranteed = 1
                                                THEN 'Гарантия качества и соответсвия производителю'
                                            ELSE Null END     AS IsQualityGuaranteedTitle
                         FROM Поисковая
                         WHERE ID_Аналога = @analog
                           And (ID_Клиента = @klient or ID_Клиента is null)
                           and (((CASE
                                      WHEN isnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0
                                      ELSE ISnull(Остаток, 0) - isnull(Количество, 0) End <> 0))
                             or (isnull(Количество, 0) <> 0))
                         GROUP BY ID_Запчасти, Цена, Брэнд, [Номер поставщика], [Сокращенное название], [Время заказа],
                                  [Время прихода], Описание, ID_аналога, Остаток, Количество, ID_Клиента,
                                  Цена1, Цена2, Цена3, Цена4, Цена5, Цена6, Цена7, Цена8, Цена9, Цена10, Цена11, Цена12,
                                  Цена13, Цена14, Цена15, Цена16, Цена17, [Не возвратный], [Виден только менеджерам],
                                  IsEnsureDeliveryTerm, IsQualityGuaranteed,
                                  CASE WHEN IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
                                  CASE
                                      WHEN IsQualityGuaranteed = 1 THEN 'Гарантия качества и соответсвия производителю'
                                      ELSE Null END
                         union
                         SELECT ISNULL([Каталоги поставщиков_1].ID_Запчасти,
                                       [Каталоги поставщиков].ID_Запчасти)                                  AS ID_Запчасти,
                                0                                                                           AS ID_аналога,
                                ISNULL([Каталоги поставщиков_1].Брэнд, [Каталоги поставщиков].Брэнд)        AS Брэнд,
                                ISNULL(Поставщики_1.[Сокращенное название],
                                       SupplierWarehouseView.[Сокращенное название])                        AS [Сокращенное название],
                                ISNULL(Поставщики_1.OrderTimeText,
                                       SupplierWarehouseView.OrderTimeText)                                 AS [Время заказа],
                                ISNULL(Поставщики_1.ArrivalTime, SupplierWarehouseView.ArrivalTime)         AS [Время прихода],
                                ISNULL([Каталоги поставщиков_1].[Номер запчасти],
                                       [Каталоги поставщиков].[Номер запчасти])                             AS [Номер запчасти],
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена], [Каталоги поставщиков].[Цена]),
                                       0)                                                                   AS Цена,
                                0                                                                           AS Доступно,
                                0                                                                           AS Резерв,
                                ISNULL([Каталоги поставщиков_1].Описание,
                                       [Каталоги поставщиков].Описание)                                     AS Описание,
                                ISNULL([Каталоги поставщиков_1].Наличие,
                                       [Каталоги поставщиков].Наличие)                                      AS Заказ,
                                ISNULL([Каталоги поставщиков_1].[Срок доставки],
                                       [Каталоги поставщиков].[Срок доставки])                              AS Срок,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена1], [Каталоги поставщиков].[Цена1]),
                                       0)                                                                   AS Цена1,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена2], [Каталоги поставщиков].[Цена2]),
                                       0)                                                                   AS Цена2,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена3], [Каталоги поставщиков].[Цена3]),
                                       0)                                                                   AS Цена3,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена4], [Каталоги поставщиков].[Цена4]),
                                       0)                                                                   AS Цена4,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена5], [Каталоги поставщиков].[Цена5]),
                                       0)                                                                   AS Цена5,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена6], [Каталоги поставщиков].[Цена6]),
                                       0)                                                                   AS Цена6,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена7], [Каталоги поставщиков].[Цена7]),
                                       0)                                                                   AS Цена7,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена8], [Каталоги поставщиков].[Цена8]),
                                       0)                                                                   AS Цена8,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена9], [Каталоги поставщиков].[Цена9]),
                                       0)                                                                   AS Цена9,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена10], [Каталоги поставщиков].[Цена10]),
                                       0)                                                                   AS Цена10,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена11], [Каталоги поставщиков].[Цена11]),
                                       0)                                                                   AS Цена11,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена12], [Каталоги поставщиков].[Цена12]),
                                       0)                                                                   AS Цена12,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена13], [Каталоги поставщиков].[Цена13]),
                                       0)                                                                   AS Цена13,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена14], [Каталоги поставщиков].[Цена14]),
                                       0)                                                                   AS Цена14,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена15], [Каталоги поставщиков].[Цена15]),
                                       0)                                                                   AS Цена15,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена16], [Каталоги поставщиков].[Цена16]),
                                       0)                                                                   AS Цена16,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена17], [Каталоги поставщиков].[Цена17]),
                                       0)                                                                   AS Цена17,
                                ISNULL([Каталоги поставщиков_1].Дата, [Каталоги поставщиков].Дата)          AS Дата,
                                ISNULL(Поставщики_1.[Не возвратный],
                                       SupplierWarehouseView.[Не возвратный])                               AS [Не возвратный],
                                ISNULL(Поставщики_1.[Виден только менеджерам],
                                       SupplierWarehouseView.[Виден только менеджерам])                     AS [Виден только менеджерам],
                                ISNULL(Поставщики_1.[IsEnsureDeliveryTerm],
                                       SupplierWarehouseView.[IsEnsureDeliveryTerm])                        AS IsEnsureDeliveryTerm,
                                ISNULL(Поставщики_1.[IsQualityGuaranteed],
                                       SupplierWarehouseView.[IsQualityGuaranteed])                         AS IsQualityGuaranteed,
                                CASE
                                    WHEN ISNULL(Поставщики_1.[IsEnsureDeliveryTerm],
                                                SupplierWarehouseView.[IsEnsureDeliveryTerm]) = 1
                                        THEN 'Гарантированный срок поставки'
                                    ELSE Null END                                                           AS IsEnsureDeliveryTermTitle,
                                CASE
                                    WHEN ISNULL(Поставщики_1.[IsQualityGuaranteed],
                                                SupplierWarehouseView.[IsQualityGuaranteed]) =
                                         1 THEN 'Гарантия качества и соответсвия производителю'
                                    ELSE Null END                                                           AS IsQualityGuaranteedTitle
                         FROM [Каталоги поставщиков] AS [Каталоги поставщиков_1]
                                  INNER JOIN
                              SupplierWarehouseView AS Поставщики_1
                              ON [Каталоги поставщиков_1].WarehouseId = Поставщики_1.Id
                                  RIGHT OUTER JOIN (SELECT Брэнд_, Name_, Брэнд, [Name]
                                                    FROM [Таблица аналогов]
                                                    UNION
                                                    SELECT @brend, @name, @brend, @name) as ANALOGI
                                  INNER JOIN
                              [Каталоги поставщиков] ON ANALOGI.Брэнд_ = [Каталоги поставщиков].Брэнд AND
                                                        ANALOGI.Name_ = [Каталоги поставщиков].Name
                                  INNER JOIN
                              SupplierWarehouseView ON [Каталоги поставщиков].WarehouseId = SupplierWarehouseView.Id ON
                                      [Каталоги поставщиков_1].ID_Аналога = [Каталоги поставщиков].ID_Аналога AND
                                      [Каталоги поставщиков_1].ID_Поставщика = [Каталоги поставщиков].ID_Поставщика

                         WHERE (ANALOGI.[Name] = @name)
                           AND (ANALOGI.Брэнд = @brend)


                         UNION
                         SELECT ISNULL([Каталоги поставщиков_1].ID_Запчасти,
                                       [Каталоги поставщиков].ID_Запчасти)                                  AS ID_Запчасти,
                                0                                                                           AS ID_аналога,
                                ISNULL([Каталоги поставщиков_1].Брэнд, [Каталоги поставщиков].Брэнд)        AS Брэнд,
                                ISNULL(Поставщики_1.[Сокращенное название],
                                       SupplierWarehouseView.[Сокращенное название])                        AS [Сокращенное название],
                                ISNULL(Поставщики_1.OrderTimeText,
                                       SupplierWarehouseView.OrderTimeText)                                 AS [Время заказа],
                                ISNULL(Поставщики_1.ArrivalTime, SupplierWarehouseView.ArrivalTime)         AS [Время прихода],
                                ISNULL([Каталоги поставщиков_1].[Номер запчасти],
                                       [Каталоги поставщиков].[Номер запчасти])                             AS [Номер запчасти],
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена], [Каталоги поставщиков].[Цена]),
                                       0)                                                                   AS Цена,
                                0                                                                           AS Доступно,
                                0                                                                           AS Резерв,
                                ISNULL([Каталоги поставщиков_1].Описание,
                                       [Каталоги поставщиков].Описание)                                     AS Описание,
                                ISNULL([Каталоги поставщиков_1].Наличие,
                                       [Каталоги поставщиков].Наличие)                                      AS Заказ,
                                ISNULL([Каталоги поставщиков_1].[Срок доставки],
                                       [Каталоги поставщиков].[Срок доставки])                              AS Срок,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена1], [Каталоги поставщиков].[Цена1]),
                                       0)                                                                   AS Цена1,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена2], [Каталоги поставщиков].[Цена2]),
                                       0)                                                                   AS Цена2,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена3], [Каталоги поставщиков].[Цена3]),
                                       0)                                                                   AS Цена3,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена4], [Каталоги поставщиков].[Цена4]),
                                       0)                                                                   AS Цена4,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена5], [Каталоги поставщиков].[Цена5]),
                                       0)                                                                   AS Цена5,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена6], [Каталоги поставщиков].[Цена6]),
                                       0)                                                                   AS Цена6,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена7], [Каталоги поставщиков].[Цена7]),
                                       0)                                                                   AS Цена7,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена8], [Каталоги поставщиков].[Цена8]),
                                       0)                                                                   AS Цена8,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена9], [Каталоги поставщиков].[Цена9]),
                                       0)                                                                   AS Цена9,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена10], [Каталоги поставщиков].[Цена10]),
                                       0)                                                                   AS Цена10,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена11], [Каталоги поставщиков].[Цена11]),
                                       0)                                                                   AS Цена11,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена12], [Каталоги поставщиков].[Цена12]),
                                       0)                                                                   AS Цена12,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена13], [Каталоги поставщиков].[Цена13]),
                                       0)                                                                   AS Цена13,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена14], [Каталоги поставщиков].[Цена14]),
                                       0)                                                                   AS Цена14,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена15], [Каталоги поставщиков].[Цена15]),
                                       0)                                                                   AS Цена15,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена16], [Каталоги поставщиков].[Цена16]),
                                       0)                                                                   AS Цена16,
                                ISNULL(ISNULL([Каталоги поставщиков_1].[Цена17], [Каталоги поставщиков].[Цена17]),
                                       0)                                                                   AS Цена17,
                                ISNULL([Каталоги поставщиков_1].Дата, [Каталоги поставщиков].Дата)          AS Дата,
                                ISNULL(Поставщики_1.[Не возвратный],
                                       SupplierWarehouseView.[Не возвратный])                               AS [Не возвратный],
                                ISNULL(Поставщики_1.[Виден только менеджерам],
                                       SupplierWarehouseView.[Виден только менеджерам])                     AS [Виден только менеджерам],
                                ISNULL(Поставщики_1.[IsEnsureDeliveryTerm],
                                       SupplierWarehouseView.[IsEnsureDeliveryTerm])                        AS IsEnsureDeliveryTerm,
                                ISNULL(Поставщики_1.[IsQualityGuaranteed],
                                       SupplierWarehouseView.[IsQualityGuaranteed])                         AS IsQualityGuaranteed,
                                CASE
                                    WHEN ISNULL(Поставщики_1.IsEnsureDeliveryTerm,
                                                SupplierWarehouseView.IsEnsureDeliveryTerm) = 1
                                        THEN 'Гарантированный срок поставки'
                                    ELSE Null END                                                           AS IsEnsureDeliveryTermTitle,
                                CASE
                                    WHEN ISNULL(Поставщики_1.IsQualityGuaranteed,
                                                SupplierWarehouseView.IsQualityGuaranteed) = 1
                                        THEN 'Гарантия качества и соответсвия производителю'
                                    ELSE Null END                                                           AS IsQualityGuaranteedTitle
                         FROM [Каталоги поставщиков] AS [Каталоги поставщиков_1]
                                  INNER JOIN
                              SupplierWarehouseView AS Поставщики_1
                              ON [Каталоги поставщиков_1].WarehouseId = Поставщики_1.Id
                                  RIGHT OUTER JOIN (SELECT Брэнд_, Name_, Брэнд, [Name]
                                                    FROM [Таблица аналогов]
                                                    UNION
                                                    SELECT @brend, @name, @brend, @name) as ANALOGI
                                  INNER JOIN
                              [Каталоги поставщиков] ON [ANALOGI].Брэнд = [Каталоги поставщиков].Брэнд AND
                                                        [ANALOGI].Name = [Каталоги поставщиков].Name
                                  INNER JOIN
                              SupplierWarehouseView ON [Каталоги поставщиков].WarehouseId = SupplierWarehouseView.Id ON
                                      [Каталоги поставщиков_1].ID_Аналога = [Каталоги поставщиков].ID_Аналога AND
                                      [Каталоги поставщиков_1].ID_Поставщика = [Каталоги поставщиков].ID_Поставщика

                         WHERE ([ANALOGI].[Name_] = @name)
                           AND ([ANALOGI].Брэнд_ = @brend)


                         UNION


                         SELECT isnull([Каталоги поставщиков_1].Id_Запчасти,
                                       [Каталоги_поставщиков].Id_Запчасти)                           as Id_Запчасти,
                                dbo.[Каталог запчастей].ID_аналога                                   as ID_аналога,
                                isnull([Каталоги поставщиков_1].Брэнд, [Каталоги_поставщиков].Брэнд) as Брэнд,
                                isnull([Каталоги поставщиков_1].[Сокращенное название],
                                       [Каталоги_поставщиков].[Сокращенное название])                as [Сокращенное название],
                                isnull([Каталоги поставщиков_1].OrderTimeText,
                                       [Каталоги_поставщиков].OrderTimeText)                         as [Время заказа],
                                isnull([Каталоги поставщиков_1].ArrivalTime,
                                       [Каталоги_поставщиков].ArrivalTime)                           as [Время прихода],
                                isnull([Каталоги поставщиков_1].[Номер запчасти],
                                       [Каталоги_поставщиков].[Номер запчасти])                      as [Номер запчасти],
                                isnull(isnull([Каталоги поставщиков_1].Цена, [Каталоги_поставщиков].Цена),
                                       0)                                                            as Цена,
                                0                                                                    AS Доступно,
                                0                                                                    AS Резерв,
                                isnull([Каталоги поставщиков_1].Описание,
                                       [Каталоги_поставщиков].Описание)                              as Описание,
                                isnull([Каталоги поставщиков_1].Наличие,
                                       [Каталоги_поставщиков].Наличие)                               as Заказ,
                                isnull(isnull([Каталоги поставщиков_1].[Срок доставки],
                                              [Каталоги_поставщиков].[Срок доставки]),
                                       0)                                                            as Срок,
                                isnull(isnull([Каталоги поставщиков_1].Цена1, [Каталоги_поставщиков].Цена1),
                                       0)                                                            as Цена1,
                                isnull(isnull([Каталоги поставщиков_1].Цена2, [Каталоги_поставщиков].Цена2),
                                       0)                                                            as Цена2,
                                isnull(isnull([Каталоги поставщиков_1].Цена3, [Каталоги_поставщиков].Цена3),
                                       0)                                                            as Цена3,
                                isnull(isnull([Каталоги поставщиков_1].Цена4, [Каталоги_поставщиков].Цена4),
                                       0)                                                            as Цена4,
                                isnull(isnull([Каталоги поставщиков_1].Цена5, [Каталоги_поставщиков].Цена5),
                                       0)                                                            as Цена5,
                                isnull(isnull([Каталоги поставщиков_1].Цена6, [Каталоги_поставщиков].Цена6),
                                       0)                                                            as Цена6,
                                isnull(isnull([Каталоги поставщиков_1].Цена7, [Каталоги_поставщиков].Цена7),
                                       0)                                                            as Цена7,
                                isnull(isnull([Каталоги поставщиков_1].Цена8, [Каталоги_поставщиков].Цена8),
                                       0)                                                            as Цена8,
                                isnull(isnull([Каталоги поставщиков_1].Цена9, [Каталоги_поставщиков].Цена9),
                                       0)                                                            as Цена9,
                                isnull(isnull([Каталоги поставщиков_1].Цена10, [Каталоги_поставщиков].Цена10),
                                       0)                                                            as Цена10,
                                isnull(isnull([Каталоги поставщиков_1].Цена11, [Каталоги_поставщиков].Цена11),
                                       0)                                                            as Цена11,
                                isnull(isnull([Каталоги поставщиков_1].Цена12, [Каталоги_поставщиков].Цена12),
                                       0)                                                            as Цена12,
                                isnull(isnull([Каталоги поставщиков_1].Цена13, [Каталоги_поставщиков].Цена13),
                                       0)                                                            as Цена13,
                                isnull(isnull([Каталоги поставщиков_1].Цена14, [Каталоги_поставщиков].Цена14),
                                       0)                                                            as Цена14,
                                isnull(isnull([Каталоги поставщиков_1].Цена15, [Каталоги_поставщиков].Цена15),
                                       0)                                                            as Цена15,
                                isnull(isnull([Каталоги поставщиков_1].Цена16, [Каталоги_поставщиков].Цена16),
                                       0)                                                            as Цена16,
                                isnull(isnull([Каталоги поставщиков_1].Цена17, [Каталоги_поставщиков].Цена17),
                                       0)                                                            as Цена17,
                                ISNULL([Каталоги поставщиков_1].Дата, [Каталоги_поставщиков].Дата)   AS Дата,
                                ISNULL([Каталоги поставщиков_1].[Не возвратный],
                                       [Каталоги_поставщиков].[Не возвратный])                       AS [Не возвратный],
                                ISNULL([Каталоги поставщиков_1].[Виден только менеджерам],
                                       [Каталоги_поставщиков].[Виден только менеджерам])             AS [Виден только менеджерам],
                                ISNULL([Каталоги поставщиков_1].[IsEnsureDeliveryTerm],
                                       [Каталоги_поставщиков].[IsEnsureDeliveryTerm])                AS IsEnsureDeliveryTerm,
                                ISNULL([Каталоги поставщиков_1].[IsQualityGuaranteed],
                                       [Каталоги_поставщиков].[IsQualityGuaranteed])                 AS IsQualityGuaranteed,
                                CASE
                                    WHEN ISNULL([Каталоги поставщиков_1].[IsEnsureDeliveryTerm],
                                                [Каталоги_поставщиков].[IsEnsureDeliveryTerm]) = 1
                                        THEN 'Гарантированный срок поставки'
                                    ELSE Null END                                                    AS IsEnsureDeliveryTermTitle,
                                CASE
                                    WHEN ISNULL([Каталоги поставщиков_1].[IsQualityGuaranteed],
                                                [Каталоги_поставщиков].[IsQualityGuaranteed]) = 1
                                        THEN 'Гарантия качества и соответсвия производителю'
                                    ELSE Null END                                                    AS IsQualityGuaranteedTitle
                         FROM [Каталог запчастей]
                                  INNER JOIN
                              Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда
                                  INNER JOIN
                              [Каталоги_поставщиков] ON Брэнды.Брэнд = [Каталоги_поставщиков].Брэнд AND
                                                        [Каталог запчастей].namepost = [Каталоги_поставщиков].Name
                                  LEFT OUTER JOIN
                              [Каталоги_поставщиков] AS [Каталоги поставщиков_1]
                              ON [Каталоги_поставщиков].ID_Аналога = [Каталоги поставщиков_1].ID_Аналога AND
                                 [Каталоги_поставщиков].ID_Поставщика = [Каталоги поставщиков_1].ID_Поставщика
                         WHERE ([Каталог запчастей].ID_аналога = @analog)
                     ) AS ManinTable
                GROUP BY Id_Запчасти,
                         Брэнд,
                         [Сокращенное название],
                         [Время заказа],
                         [Время прихода],
                         [Номер запчасти],
                         Цена,
                         Доступно,
                         Резерв,
                         Описание,
                         Заказ,
                         Срок,
                         Цена1,
                         Цена2,
                         Цена3,
                         Цена4,
                         Цена5,
                         Цена6,
                         Цена7,
                         Цена8,
                         Цена9,
                         Цена10,
                         Цена11,
                         Цена12,
                         Цена13,
                         Цена14,
                         Цена15,
                         Цена16,
                         Цена17,
                         Дата,
                         [Не возвратный],
                         [Виден только менеджерам],
                         IsEnsureDeliveryTerm,
                         IsQualityGuaranteed,
                         IsEnsureDeliveryTermTitle,
                         IsQualityGuaranteedTitle
            )
go
