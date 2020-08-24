CREATE FUNCTION [dbo].[GetPartsByBrand](@brend char(25),
                                        @name char(25),
                                        @klient int)
    RETURNS TABLE
        AS
        RETURN
            (

                SELECT [Каталоги поставщиков].ID_Запчасти              AS ID_Запчасти,
                       0                                               AS ID_аналога,
                       [Каталоги поставщиков].Брэнд                    AS Брэнд,
                       SupplierWarehouseView.[Сокращенное название]    AS [Сокращенное название],
                       SupplierWarehouseView.OrderTimeText             AS [Время заказа],
                       SupplierWarehouseView.ArrivalTime               AS [Время прихода],
                       SupplierWarehouseView.SupplierName              AS SupplierName,
                       SupplierWarehouseView.WarehouseName             AS WarehouseName,
                       [Каталоги поставщиков].[Номер запчасти]         AS [Номер запчасти],
                       ISNULL([Каталоги поставщиков].[Цена], 0)        AS Цена,
                       0                                               AS Доступно,
                       0                                               AS Резерв,
                       [Каталоги поставщиков].Описание                 AS Описание,
                       [Каталоги поставщиков].Наличие                  AS Заказ,
                       [Каталоги поставщиков].[Срок доставки]          AS Срок,
                       ISNULL([Каталоги поставщиков].[Цена1], 0)       AS Цена1,
                       ISNULL([Каталоги поставщиков].[Цена2], 0)       AS Цена2,
                       ISNULL([Каталоги поставщиков].[Цена3], 0)       AS Цена3,
                       ISNULL([Каталоги поставщиков].[Цена4], 0)       AS Цена4,
                       ISNULL([Каталоги поставщиков].[Цена5], 0)       AS Цена5,
                       ISNULL([Каталоги поставщиков].[Цена6], 0)       AS Цена6,
                       ISNULL([Каталоги поставщиков].[Цена7], 0)       AS Цена7,
                       ISNULL([Каталоги поставщиков].[Цена8], 0)       AS Цена8,
                       ISNULL([Каталоги поставщиков].[Цена9], 0)       AS Цена9,
                       ISNULL([Каталоги поставщиков].[Цена10], 0)      AS Цена10,
                       ISNULL([Каталоги поставщиков].[Цена11], 0)      AS Цена11,
                       ISNULL([Каталоги поставщиков].[Цена12], 0)      AS Цена12,
                       ISNULL([Каталоги поставщиков].[Цена13], 0)      AS Цена13,
                       ISNULL([Каталоги поставщиков].[Цена14], 0)      AS Цена14,
                       ISNULL([Каталоги поставщиков].[Цена15], 0)      AS Цена15,
                       ISNULL([Каталоги поставщиков].[Цена16], 0)      AS Цена16,
                       ISNULL([Каталоги поставщиков].[Цена17], 0)      AS Цена17,
                       [Каталоги поставщиков].Дата                     AS Дата,
                       SupplierWarehouseView.[Не возвратный]           AS [Не возвратный],
                       SupplierWarehouseView.[Виден только менеджерам] AS [Виден только менеджерам],
                       SupplierWarehouseView.[IsEnsureDeliveryTerm]    AS [IsEnsureDeliveryTerm],
                       SupplierWarehouseView.[IsQualityGuaranteed]     AS [IsQualityGuaranteed],
                       CASE
                           WHEN
                               SupplierWarehouseView.[IsEnsureDeliveryTerm] = 1
                               THEN 'Гарантированный срок поставки'
                           ELSE Null END                               AS IsEnsureDeliveryTermTitle,
                       CASE
                           WHEN
                               SupplierWarehouseView.[IsQualityGuaranteed] = 1
                               THEN 'Гарантия качества и соответсвия производителю'
                           ELSE Null END                               AS IsQualityGuaranteedTitle
                FROM (SELECT Брэнд_, Name_, Брэнд, [Name]
                      FROM [Таблица аналогов]
                      UNION
                      SELECT @brend, @name, @brend, @name) as ANALOGI
                         INNER JOIN
                     [Каталоги поставщиков] ON ANALOGI.Брэнд_ = [Каталоги поставщиков].Брэнд AND
                                               ANALOGI.Name_ = [Каталоги поставщиков].Name
                         INNER JOIN
                     SupplierWarehouseView ON [Каталоги поставщиков].WarehouseId = SupplierWarehouseView.Id
                WHERE (ANALOGI.[Name] = @name)
                  AND (ANALOGI.Брэнд = @brend)

                UNION

                SELECT Поисковая.ID_Запчасти,
                       Поисковая.ID_аналога,
                       Поисковая.Брэнд,
                       Поисковая.[Сокращенное название],
                       NULL                                                    AS [Время заказа],
                       NULL                                                    AS [Время прихода],
                       NULL                                                    AS SupplierName,
                       NULL                                                    AS WarehouseName,
                       Поисковая.[Номер поставщика]                            as [Номер запчасти],
                       ISNULL(Поисковая.Цена, 0)                               AS Цена,
                       CASE
                           WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0
                           ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END AS Доступно,
                       ISNULL(Поисковая.Количество, 0)                         AS Резерв,
                       Поисковая.Описание,
                       NULL                                                    AS Заказ,
                       NULL                                                    AS Срок,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена1, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена1,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена2, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена2,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена3, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена3,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена4, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена4,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена5, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена5,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена6, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена6,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена7, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена7,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена8, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена8,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена9, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена9,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена10, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена10,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена11, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена11,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена12, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена12,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена13, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена13,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена14, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена14,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена15, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена15,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена16, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена16,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена17, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена17,
                       null                                                    as Дата,
                       Поисковая.[Не возвратный],
                       Поисковая.[Виден только менеджерам],
                       Поисковая.IsEnsureDeliveryTerm,
                       Поисковая.IsQualityGuaranteed,
                       CASE
                           WHEN Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки'
                           ELSE Null END                                       AS IsEnsureDeliveryTermTitle,
                       CASE
                           WHEN Поисковая.IsQualityGuaranteed = 1 THEN 'Гарантия качества и соответсвия производителю'
                           ELSE Null END                                       AS IsQualityGuaranteedTitle
                FROM Поисковая
                         INNER JOIN
                     [Каталог запчастей] ON Поисковая.ID_аналога = [Каталог запчастей].ID_аналога
                         INNER JOIN
                     Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда
                         INNER JOIN
                     (SELECT Брэнд_, Name_, Брэнд, [Name]
                      FROM [Таблица аналогов]
                      UNION
                      SELECT @brend, @name, @brend, @name) as ANALOGI ON
                             Брэнды.Брэнд = [ANALOGI].Брэнд_ AND
                             [Каталог запчастей].namepost = [ANALOGI].Name_
                WHERE (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND
                      (ANALOGI.Брэнд = @brend) AND
                      (ANALOGI.Name = @name) AND
                      (CASE
                           WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0
                           ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END <> 0)
                   OR (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND
                      (ANALOGI.Брэнд = @brend) AND
                      (ANALOGI.Name = @name) AND
                      (ISNULL(dbo.Поисковая.Количество, 0) <> 0)

                GROUP BY Поисковая.ID_Запчасти, Поисковая.ID_аналога, Поисковая.Цена, Поисковая.Брэнд,
                         Поисковая.[Номер поставщика],
                         Поисковая.[Сокращенное название],
                         Поисковая.Описание, Поисковая.ID_аналога, Поисковая.Остаток, Поисковая.Количество,
                         Поисковая.ID_Клиента, Поисковая.Цена1,
                         Поисковая.Цена2, Поисковая.Цена3, Поисковая.Цена4, Поисковая.Цена5, Поисковая.Цена6,
                         Поисковая.Цена7, Поисковая.Цена8,
                         Поисковая.Цена9, Поисковая.Цена10, Поисковая.Цена11, Поисковая.Цена12, Поисковая.Цена13,
                         Поисковая.Цена14,
                         Поисковая.Цена15, Поисковая.Цена16, Поисковая.Цена17, [Не возвратный],
                         [Виден только менеджерам], IsEnsureDeliveryTerm,
                         IsQualityGuaranteed,
                         CASE
                             WHEN Поисковая.IsEnsureDeliveryTerm = 1
                                 THEN 'Гарантированный срок поставки'
                             ELSE Null END,
                         CASE
                             WHEN Поисковая.IsQualityGuaranteed = 1 THEN 'Гарантия качества и соответсвия производителю'
                             ELSE Null END
                UNION

                SELECT [Каталоги поставщиков].ID_Запчасти              AS ID_Запчасти,
                       0                                               AS ID_аналога,
                       [Каталоги поставщиков].Брэнд                    AS Брэнд,
                       SupplierWarehouseView.[Сокращенное название]    AS [Сокращенное название],
                       SupplierWarehouseView.OrderTimeText             AS [Время заказа],
                       SupplierWarehouseView.ArrivalTime               AS [Время прихода],
                       SupplierWarehouseView.SupplierName              AS SupplierName,
                       SupplierWarehouseView.WarehouseName             AS WarehouseName,
                       [Каталоги поставщиков].[Номер запчасти]         AS [Номер запчасти],
                       ISNULL([Каталоги поставщиков].[Цена],
                              0)                                       AS Цена,
                       0                                               AS Доступно,
                       0                                               AS Резерв,
                       [Каталоги поставщиков].Описание                 AS Описание,
                       [Каталоги поставщиков].Наличие                  AS Заказ,
                       [Каталоги поставщиков].[Срок доставки]          AS Срок,
                       ISNULL([Каталоги поставщиков].[Цена1], 0)       AS Цена1,
                       ISNULL([Каталоги поставщиков].[Цена2], 0)       AS Цена2,
                       ISNULL([Каталоги поставщиков].[Цена3], 0)       AS Цена3,
                       ISNULL([Каталоги поставщиков].[Цена4], 0)       AS Цена4,
                       ISNULL([Каталоги поставщиков].[Цена5], 0)       AS Цена5,
                       ISNULL([Каталоги поставщиков].[Цена6], 0)       AS Цена6,
                       ISNULL([Каталоги поставщиков].[Цена7], 0)       AS Цена7,
                       ISNULL([Каталоги поставщиков].[Цена8], 0)       AS Цена8,
                       ISNULL([Каталоги поставщиков].[Цена9], 0)       AS Цена9,
                       ISNULL([Каталоги поставщиков].[Цена10], 0)      AS Цена10,
                       ISNULL([Каталоги поставщиков].[Цена11], 0)      AS Цена11,
                       ISNULL([Каталоги поставщиков].[Цена12], 0)      AS Цена12,
                       ISNULL([Каталоги поставщиков].[Цена13], 0)      AS Цена13,
                       ISNULL([Каталоги поставщиков].[Цена14], 0)      AS Цена14,
                       ISNULL([Каталоги поставщиков].[Цена15], 0)      AS Цена15,
                       ISNULL([Каталоги поставщиков].[Цена16], 0)      AS Цена16,
                       ISNULL([Каталоги поставщиков].[Цена17], 0)      AS Цена17,
                       [Каталоги поставщиков].Дата                     AS Дата,
                       SupplierWarehouseView.[Не возвратный]           AS [Не возвратный],
                       SupplierWarehouseView.[Виден только менеджерам] AS [Виден только менеджерам],
                       SupplierWarehouseView.IsEnsureDeliveryTerm      AS IsEnsureDeliveryTerm,
                       SupplierWarehouseView.IsQualityGuaranteed       AS IsQualityGuaranteed,
                       CASE
                           WHEN SupplierWarehouseView.IsEnsureDeliveryTerm =
                                1
                               THEN 'Гарантированный срок поставки'
                           ELSE Null END                               AS IsEnsureDeliveryTermTitle,
                       CASE
                           WHEN SupplierWarehouseView.IsQualityGuaranteed = 1
                               THEN 'Гарантия качества и соответсвия производителю'
                           ELSE Null END                               AS IsQualityGuaranteedTitle
                FROM (SELECT Брэнд_, Name_, Брэнд, [Name]
                      FROM [Таблица аналогов]
                      UNION
                      SELECT @brend, @name, @brend, @name) as ANALOGI
                         INNER JOIN
                     [Каталоги поставщиков] ON [ANALOGI].Брэнд = [Каталоги поставщиков].Брэнд AND
                                               [ANALOGI].Name = [Каталоги поставщиков].Name
                         INNER JOIN
                     SupplierWarehouseView ON [Каталоги поставщиков].WarehouseId = SupplierWarehouseView.Id

                WHERE ([ANALOGI].[Name_] = @name)
                  AND ([ANALOGI].Брэнд_ = @brend)

                UNION

                SELECT Поисковая.ID_Запчасти,
                       Поисковая.ID_аналога,
                       Поисковая.Брэнд,
                       Поисковая.[Сокращенное название],
                       NULL                                                    AS [Время заказа],
                       NULL                                                    AS [Время прихода],
                       NULL                                                    AS SupplierName,
                       NULL                                                    AS WarehouseName,
                       Поисковая.[Номер поставщика]                            as [Номер запчасти],
                       ISNULL(Поисковая.Цена, 0)                               AS Цена,
                       CASE
                           WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0
                           ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END AS Доступно,
                       ISNULL(Поисковая.Количество, 0)                         AS Резерв,
                       Поисковая.Описание,
                       NULL                                                    AS Заказ,
                       NULL                                                    AS Срок,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена1, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена1,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена2, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена2,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена3, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена3,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена4, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена4,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена5, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена5,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена6, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена6,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена7, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена7,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена8, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена8,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена9, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена9,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена10, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена10,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена11, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена11,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена12, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена12,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена13, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена13,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена14, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена14,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена15, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена15,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена16, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена16,
                       CASE
                           WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена17, 0)
                           ELSE MAX(Спец_цена) END                             AS Цена17,
                       null                                                    as Дата,
                       Поисковая.[Не возвратный],
                       Поисковая.[Виден только менеджерам],
                       Поисковая.IsEnsureDeliveryTerm,
                       Поисковая.IsQualityGuaranteed,
                       CASE
                           WHEN Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки'
                           ELSE Null END                                       AS IsEnsureDeliveryTermTitle,
                       CASE
                           WHEN Поисковая.IsQualityGuaranteed = 1 THEN 'Гарантия качества и соответсвия производителю'
                           ELSE Null END                                       AS IsQualityGuaranteedTitle
                FROM Поисковая
                         INNER JOIN
                     [Каталог запчастей] ON Поисковая.ID_аналога = [Каталог запчастей].ID_аналога
                         INNER JOIN
                     Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда
                         INNER JOIN
                     (SELECT Брэнд_, Name_, Брэнд, [Name]
                      FROM [Таблица аналогов]
                      UNION
                      SELECT @brend, @name, @brend, @name) as ANALOGI ON
                             Брэнды.Брэнд = [ANALOGI].Брэнд AND
                             [Каталог запчастей].namepost = [ANALOGI].Name
                WHERE (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND
                      (ANALOGI.Брэнд_ = @brend) AND
                      (ANALOGI.Name_ = @name) AND
                      (CASE
                           WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0
                           ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END <> 0)
                   OR (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND
                      (ANALOGI.Брэнд_ = @brend) AND
                      (ANALOGI.Name_ = @name) AND
                      (ISNULL(dbo.Поисковая.Количество, 0) <> 0)

                GROUP BY Поисковая.ID_Запчасти, Поисковая.ID_аналога, Поисковая.Цена, Поисковая.Брэнд,
                         Поисковая.[Номер поставщика],
                         Поисковая.[Сокращенное название],
                         Поисковая.Описание, Поисковая.ID_аналога, Поисковая.Остаток, Поисковая.Количество,
                         Поисковая.ID_Клиента, Поисковая.Цена1,
                         Поисковая.Цена2, Поисковая.Цена3, Поисковая.Цена4, Поисковая.Цена5, Поисковая.Цена6,
                         Поисковая.Цена7, Поисковая.Цена8,
                         Поисковая.Цена9, Поисковая.Цена10, Поисковая.Цена11, Поисковая.Цена12, Поисковая.Цена13,
                         Поисковая.Цена14,
                         Поисковая.Цена15, Поисковая.Цена16, Поисковая.Цена17, [Не возвратный],
                         [Виден только менеджерам], IsEnsureDeliveryTerm,
                         IsQualityGuaranteed,
                         CASE
                             WHEN Поисковая.IsEnsureDeliveryTerm = 1
                                 THEN 'Гарантированный срок поставки'
                             ELSE Null END,
                         CASE
                             WHEN Поисковая.IsQualityGuaranteed = 1 THEN 'Гарантия качества и соответсвия производителю'
                             ELSE Null END
            )
go
