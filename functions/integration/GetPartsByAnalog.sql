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
                       SupplierName,
                       WarehouseName,
                       Quality,
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
                                        NULL                  AS [Время заказа],
                                        NULL                  AS [Время прихода],
                                        NULL                  AS SupplierName,
                                        NULL                  AS WarehouseName,
                                        NULL                  AS Quality,
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
                         GROUP BY ID_Запчасти, Цена, Брэнд, [Номер поставщика], [Сокращенное название],
                                  Описание, ID_аналога, Остаток, Количество, ID_Клиента,
                                  Цена1, Цена2, Цена3, Цена4, Цена5, Цена6, Цена7, Цена8, Цена9, Цена10, Цена11, Цена12,
                                  Цена13, Цена14, Цена15, Цена16, Цена17, [Не возвратный], [Виден только менеджерам],
                                  IsEnsureDeliveryTerm, IsQualityGuaranteed,
                                  CASE WHEN IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
                                  CASE
                                      WHEN IsQualityGuaranteed = 1 THEN 'Гарантия качества и соответсвия производителю'
                                      ELSE Null END
                         union
                         SELECT [Каталоги поставщиков].ID_Запчасти              AS ID_Запчасти,
                                0                                               AS ID_аналога,
                                [Каталоги поставщиков].Брэнд                    AS Брэнд,
                                SupplierWarehouseView.[Сокращенное название]    AS [Сокращенное название],
                                SupplierWarehouseView.OrderTimeText             AS [Время заказа],
                                SupplierWarehouseView.ArrivalTime               AS [Время прихода],
                                SupplierWarehouseView.SupplierName              AS SupplierName,
                                SupplierWarehouseView.WarehouseName             AS WarehouseName,
                                [Каталоги поставщиков].Quality                  AS Quality,
                                [Каталоги поставщиков].[Номер запчасти]         AS [Номер запчасти],
                                ISNULL([Каталоги поставщиков].[Цена],
                                       0)                                       AS Цена,
                                0                                               AS Доступно,
                                0                                               AS Резерв,
                                [Каталоги поставщиков].Описание                 AS Описание,
                                [Каталоги поставщиков].Наличие                  AS Заказ,
                                [Каталоги поставщиков].[Срок доставки]          AS Срок,
                                ISNULL([Каталоги поставщиков].[Цена1],
                                       0)                                       AS Цена1,
                                ISNULL([Каталоги поставщиков].[Цена2],
                                       0)                                       AS Цена2,
                                ISNULL([Каталоги поставщиков].[Цена3],
                                       0)                                       AS Цена3,
                                ISNULL([Каталоги поставщиков].[Цена4],
                                       0)                                       AS Цена4,
                                ISNULL([Каталоги поставщиков].[Цена5],
                                       0)                                       AS Цена5,
                                ISNULL([Каталоги поставщиков].[Цена6],
                                       0)                                       AS Цена6,
                                ISNULL([Каталоги поставщиков].[Цена7],
                                       0)                                       AS Цена7,
                                ISNULL([Каталоги поставщиков].[Цена8],
                                       0)                                       AS Цена8,
                                ISNULL([Каталоги поставщиков].[Цена9],
                                       0)                                       AS Цена9,
                                ISNULL([Каталоги поставщиков].[Цена10],
                                       0)                                       AS Цена10,
                                ISNULL([Каталоги поставщиков].[Цена11],
                                       0)                                       AS Цена11,
                                ISNULL([Каталоги поставщиков].[Цена12],
                                       0)                                       AS Цена12,
                                ISNULL([Каталоги поставщиков].[Цена13],
                                       0)                                       AS Цена13,
                                ISNULL([Каталоги поставщиков].[Цена14],
                                       0)                                       AS Цена14,
                                ISNULL([Каталоги поставщиков].[Цена15],
                                       0)                                       AS Цена15,
                                ISNULL([Каталоги поставщиков].[Цена16],
                                       0)                                       AS Цена16,
                                ISNULL([Каталоги поставщиков].[Цена17],
                                       0)                                       AS Цена17,
                                [Каталоги поставщиков].Дата                     AS Дата,
                                SupplierWarehouseView.[Не возвратный]           AS [Не возвратный],
                                SupplierWarehouseView.[Виден только менеджерам] AS [Виден только менеджерам],
                                SupplierWarehouseView.[IsEnsureDeliveryTerm]    AS IsEnsureDeliveryTerm,
                                SupplierWarehouseView.[IsQualityGuaranteed]     AS IsQualityGuaranteed,
                                CASE
                                    WHEN
                                        SupplierWarehouseView.IsEnsureDeliveryTerm = 1
                                        THEN 'Гарантированный срок поставки'
                                    ELSE Null END                               AS IsEnsureDeliveryTermTitle,
                                CASE
                                    WHEN
                                        SupplierWarehouseView.IsQualityGuaranteed = 1
                                        THEN 'Гарантия качества и соответсвия производителю'
                                    ELSE Null END                               AS IsQualityGuaranteedTitle

                         FROM (SELECT Брэнд_, Name_, Брэнд, Name
                               FROM dbo.[Таблица Аналогов]
                               UNION
                               SELECT @brend, @name, @brend, @name) AS ANALOGI
                                  INNER JOIN
                              dbo.[Каталоги поставщиков] ON ANALOGI.Брэнд_ = dbo.[Каталоги поставщиков].Брэнд AND
                                                            ANALOGI.Name_ = dbo.[Каталоги поставщиков].Name
                                  INNER JOIN
                              dbo.SupplierWarehouseView
                              ON dbo.[Каталоги поставщиков].WarehouseId = dbo.SupplierWarehouseView.Id


                         WHERE (ANALOGI.[Name] = @name)
                           AND (ANALOGI.Брэнд = @brend)


                         UNION
                         SELECT [Каталоги поставщиков].ID_Запчасти              AS ID_Запчасти,
                                0                                               AS ID_аналога,
                                [Каталоги поставщиков].Брэнд                    AS Брэнд,
                                SupplierWarehouseView.[Сокращенное название]    AS [Сокращенное название],
                                SupplierWarehouseView.OrderTimeText             AS [Время заказа],
                                SupplierWarehouseView.ArrivalTime               AS [Время прихода],
                                SupplierWarehouseView.SupplierName              AS SupplierName,
                                SupplierWarehouseView.WarehouseName             AS WarehouseName,
                                [Каталоги поставщиков].Quality                  AS Quality,
                                [Каталоги поставщиков].[Номер запчасти]         AS [Номер запчасти],
                                ISNULL([Каталоги поставщиков].[Цена],
                                       0)                                       AS Цена,
                                0                                               AS Доступно,
                                0                                               AS Резерв,
                                [Каталоги поставщиков].Описание                 AS Описание,
                                [Каталоги поставщиков].Наличие                  AS Заказ,
                                [Каталоги поставщиков].[Срок доставки]          AS Срок,
                                ISNULL([Каталоги поставщиков].[Цена1],
                                       0)                                       AS Цена1,
                                ISNULL([Каталоги поставщиков].[Цена2],
                                       0)                                       AS Цена2,
                                ISNULL([Каталоги поставщиков].[Цена3],
                                       0)                                       AS Цена3,
                                ISNULL([Каталоги поставщиков].[Цена4],
                                       0)                                       AS Цена4,
                                ISNULL([Каталоги поставщиков].[Цена5],
                                       0)                                       AS Цена5,
                                ISNULL([Каталоги поставщиков].[Цена6],
                                       0)                                       AS Цена6,
                                ISNULL([Каталоги поставщиков].[Цена7],
                                       0)                                       AS Цена7,
                                ISNULL([Каталоги поставщиков].[Цена8],
                                       0)                                       AS Цена8,
                                ISNULL([Каталоги поставщиков].[Цена9],
                                       0)                                       AS Цена9,
                                ISNULL([Каталоги поставщиков].[Цена10],
                                       0)                                       AS Цена10,
                                ISNULL([Каталоги поставщиков].[Цена11],
                                       0)                                       AS Цена11,
                                ISNULL([Каталоги поставщиков].[Цена12],
                                       0)                                       AS Цена12,
                                ISNULL([Каталоги поставщиков].[Цена13],
                                       0)                                       AS Цена13,
                                ISNULL([Каталоги поставщиков].[Цена14],
                                       0)                                       AS Цена14,
                                ISNULL([Каталоги поставщиков].[Цена15],
                                       0)                                       AS Цена15,
                                ISNULL([Каталоги поставщиков].[Цена16],
                                       0)                                       AS Цена16,
                                ISNULL([Каталоги поставщиков].[Цена17],
                                       0)                                       AS Цена17,
                                [Каталоги поставщиков].Дата                     AS Дата,
                                SupplierWarehouseView.[Не возвратный]           AS [Не возвратный],
                                SupplierWarehouseView.[Виден только менеджерам] AS [Виден только менеджерам],
                                SupplierWarehouseView.[IsEnsureDeliveryTerm]    AS IsEnsureDeliveryTerm,
                                SupplierWarehouseView.[IsQualityGuaranteed]     AS IsQualityGuaranteed,
                                CASE
                                    WHEN
                                        SupplierWarehouseView.IsEnsureDeliveryTerm = 1
                                        THEN 'Гарантированный срок поставки'
                                    ELSE Null END                               AS IsEnsureDeliveryTermTitle,
                                CASE
                                    WHEN
                                        SupplierWarehouseView.IsQualityGuaranteed = 1
                                        THEN 'Гарантия качества и соответсвия производителю'
                                    ELSE Null END                               AS IsQualityGuaranteedTitle
                         FROM (SELECT Брэнд_, Name_, Брэнд, Name
                               FROM dbo.[Таблица Аналогов]
                               UNION
                               SELECT @brend, @name, @brend, @name) AS ANALOGI
                                  INNER JOIN
                              dbo.[Каталоги поставщиков] ON ANALOGI.Брэнд = dbo.[Каталоги поставщиков].Брэнд AND
                                                            ANALOGI.Name = dbo.[Каталоги поставщиков].Name
                                  INNER JOIN
                              dbo.SupplierWarehouseView
                              ON dbo.[Каталоги поставщиков].WarehouseId = dbo.SupplierWarehouseView.Id
                         WHERE ([ANALOGI].[Name_] = @name)
                           AND ([ANALOGI].Брэнд_ = @brend)

                         UNION

                         SELECT dbo.[Каталоги_поставщиков].Id_Запчасти           as Id_Запчасти,
                                dbo.[Каталог запчастей].ID_аналога               as ID_аналога,
                                [Каталоги_поставщиков].Брэнд                     as Брэнд,
                                [Каталоги_поставщиков].[Сокращенное название]    as [Сокращенное название],
                                [Каталоги_поставщиков].OrderTimeText             as [Время заказа],
                                [Каталоги_поставщиков].ArrivalTime               as [Время прихода],
                                [Каталоги_поставщиков].SupplierName              as SupplierName,
                                [Каталоги_поставщиков].WarehouseName             as WarehouseName,
                                [Каталоги_поставщиков].Quality                   as Quality,
                                [Каталоги_поставщиков].[Номер запчасти]          as [Номер запчасти],
                                isnull([Каталоги_поставщиков].Цена,
                                       0)                                        as Цена,
                                0                                                AS Доступно,
                                0                                                AS Резерв,
                                [Каталоги_поставщиков].Описание                  as Описание,
                                [Каталоги_поставщиков].Наличие                   as Заказ,
                                isnull(
                                        [Каталоги_поставщиков].[Срок доставки],
                                        0)                                       as Срок,
                                isnull([Каталоги_поставщиков].Цена1,
                                       0)                                        as Цена1,
                                isnull([Каталоги_поставщиков].Цена2,
                                       0)                                        as Цена2,
                                isnull([Каталоги_поставщиков].Цена3,
                                       0)                                        as Цена3,
                                isnull([Каталоги_поставщиков].Цена4,
                                       0)                                        as Цена4,
                                isnull([Каталоги_поставщиков].Цена5,
                                       0)                                        as Цена5,
                                isnull([Каталоги_поставщиков].Цена6,
                                       0)                                        as Цена6,
                                isnull([Каталоги_поставщиков].Цена7,
                                       0)                                        as Цена7,
                                isnull([Каталоги_поставщиков].Цена8,
                                       0)                                        as Цена8,
                                isnull([Каталоги_поставщиков].Цена9,
                                       0)                                        as Цена9,
                                isnull([Каталоги_поставщиков].Цена10,
                                       0)                                        as Цена10,
                                isnull([Каталоги_поставщиков].Цена11,
                                       0)                                        as Цена11,
                                isnull([Каталоги_поставщиков].Цена12,
                                       0)                                        as Цена12,
                                isnull([Каталоги_поставщиков].Цена13,
                                       0)                                        as Цена13,
                                isnull([Каталоги_поставщиков].Цена14,
                                       0)                                        as Цена14,
                                isnull([Каталоги_поставщиков].Цена15,
                                       0)                                        as Цена15,
                                isnull([Каталоги_поставщиков].Цена16,
                                       0)                                        as Цена16,
                                isnull([Каталоги_поставщиков].Цена17,
                                       0)                                        as Цена17,
                                [Каталоги_поставщиков].Дата                      AS Дата,
                                [Каталоги_поставщиков].[Не возвратный]           AS [Не возвратный],
                                [Каталоги_поставщиков].[Виден только менеджерам] AS [Виден только менеджерам],
                                [Каталоги_поставщиков].[IsEnsureDeliveryTerm]    AS IsEnsureDeliveryTerm,
                                [Каталоги_поставщиков].[IsQualityGuaranteed]     AS IsQualityGuaranteed,
                                CASE
                                    WHEN [Каталоги_поставщиков].[IsEnsureDeliveryTerm] = 1
                                        THEN 'Гарантированный срок поставки'
                                    ELSE Null END                                AS IsEnsureDeliveryTermTitle,
                                CASE
                                    WHEN [Каталоги_поставщиков].[IsQualityGuaranteed] = 1
                                        THEN 'Гарантия качества и соответсвия производителю'
                                    ELSE Null END                                AS IsQualityGuaranteedTitle
                         FROM dbo.[Каталог запчастей]
                                  INNER JOIN
                              dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
                                  INNER JOIN
                              dbo.Каталоги_поставщиков ON dbo.Брэнды.Брэнд = dbo.Каталоги_поставщиков.Брэнд AND
                                                          dbo.[Каталог запчастей].namepost = dbo.Каталоги_поставщиков.Name
                         WHERE ([Каталог запчастей].ID_аналога = @analog)
                     ) AS ManinTable
                GROUP BY Id_Запчасти,
                         Брэнд,
                         [Сокращенное название],
                         [Время заказа],
                         [Время прихода],
                         SupplierName,
                         WarehouseName,
                         Quality,
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

