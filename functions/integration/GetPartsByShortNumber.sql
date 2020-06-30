CREATE FUNCTION [dbo].[GetPartsByShortNumber]
(	
	@brend char(18),
	@name char(25),
	@klient int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT      Id_Запчасти, 
	        ID_Аналога,
			Брэнд,
			[Сокращенное название],
            [Время прихода],
	        [Время заказа],
			[Номер запчасти],
			isnull(Цена, 0) as Цена,
            0 AS Доступно,
			0 AS Резерв,
			Описание as Описание,
			Наличие as Заказ,
			[Срок доставки] as Срок,
            isnull(Цена1, 0) as Цена1,
			isnull(Цена2, 0) as Цена2,
			isnull(Цена3, 0) as Цена3,
			isnull(Цена4, 0) as Цена4,
			isnull(Цена5, 0) as Цена5,
			isnull(Цена6, 0) as Цена6,
			isnull(Цена7, 0) as Цена7,
			isnull(Цена8, 0) as Цена8,
			isnull(Цена9, 0) as Цена9,
			isnull(Цена10, 0) as Цена10,
			isnull(Цена11, 0) as Цена11,
			isnull(Цена12, 0) as Цена12,
			isnull(Цена13, 0) as Цена13,
			isnull(Цена14, 0) as Цена14,
			isnull(Цена15, 0) as Цена15,
			isnull(Цена16, 0) as Цена16,
			isnull(Цена17, 0) as Цена17,
			Дата,
			[Не возвратный],
			[Виден только менеджерам],
			IsEnsureDeliveryTerm,
			IsQualityGuaranteed,
			CASE WHEN IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
            CASE WHEN IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM        [Каталоги_поставщиков]
WHERE        (rtrim([Name]) = rtrim(@name)) AND (rtrim(Брэнд) = rtrim(@brend))


UNION

SELECT      [Каталоги поставщиков_1].ID_Запчасти as Id_Запчасти,
            0 AS ID_аналога,
			[Каталоги поставщиков_1].Брэнд as Брэнд,
			[Каталоги поставщиков_1].[Сокращенное название] as [Сокращенное название],
            [Каталоги поставщиков_1].[Время заказа] as [Время заказа],
            [Каталоги поставщиков_1].[Время прихода] as [Время прихода],
			[Каталоги поставщиков_1].[Номер запчасти] as [Номер запчасти],
			isnull([Каталоги поставщиков_1].Цена, 0) as Цена,
            0 AS Доступно,
			0 AS Резерв,
			[Каталоги поставщиков_1].Описание as Описание,
			[Каталоги поставщиков_1].Наличие as Заказ,
			[Каталоги поставщиков_1].[Срок доставки] as Срок,
            isnull([Каталоги поставщиков_1].Цена1, 0) as Цена1,
			isnull([Каталоги поставщиков_1].Цена2, 0) as Цена2,
			isnull([Каталоги поставщиков_1].Цена3, 0) as Цена3,
			isnull([Каталоги поставщиков_1].Цена4, 0) as Цена4,
			isnull([Каталоги поставщиков_1].Цена5, 0) as Цена5,
			isnull([Каталоги поставщиков_1].Цена6, 0) as Цена6,
			isnull([Каталоги поставщиков_1].Цена7, 0) as Цена7,
			isnull([Каталоги поставщиков_1].Цена8, 0) as Цена8,
			isnull([Каталоги поставщиков_1].Цена9, 0) as Цена9,
			isnull([Каталоги поставщиков_1].Цена10, 0) as Цена10,
			isnull([Каталоги поставщиков_1].Цена11, 0) as Цена11,
			isnull([Каталоги поставщиков_1].Цена12, 0) as Цена12,
			isnull([Каталоги поставщиков_1].Цена13, 0) as Цена13,
			isnull([Каталоги поставщиков_1].Цена14, 0) as Цена14,
			isnull([Каталоги поставщиков_1].Цена15, 0) as Цена15,
			isnull([Каталоги поставщиков_1].Цена16, 0) as Цена16,
			isnull([Каталоги поставщиков_1].Цена17, 0) as Цена17,
			[Каталоги поставщиков_1].Дата,
			[Каталоги поставщиков_1].[Не возвратный] as [Не возвратный],
			[Каталоги поставщиков_1].[Виден только менеджерам] as [Виден только менеджерам],
			[Каталоги поставщиков_1].[IsEnsureDeliveryTerm] as [IsEnsureDeliveryTerm],
			[Каталоги поставщиков_1].[IsQualityGuaranteed] as [IsQualityGuaranteed],
			CASE WHEN [Каталоги поставщиков_1].IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
            CASE WHEN [Каталоги поставщиков_1].IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM        [Каталоги поставщиков] LEFT OUTER JOIN
            [Каталоги_поставщиков] AS [Каталоги поставщиков_1] ON
            [Каталоги поставщиков].ID_Аналога = [Каталоги поставщиков_1].ID_Аналога AND
                         [Каталоги поставщиков].ID_Поставщика = [Каталоги поставщиков_1].ID_Поставщика
WHERE        (rtrim([Каталоги поставщиков].[Name]) = rtrim(@name)) AND (rtrim([Каталоги поставщиков].Брэнд) = rtrim(@brend))AND
                      ([Каталоги поставщиков_1].ID_Запчасти IS NOT NULL)

UNION

SELECT     dbo.Поисковая.ID_Запчасти, dbo.Поисковая.ID_аналога AS ID_аналога, dbo.Поисковая.Брэнд, dbo.Поисковая.[Сокращенное название],
            dbo.Поисковая.[Время заказа], dbo.Поисковая.[Время прихода],
            dbo.Поисковая.[Номер поставщика] as [Номер запчасти], ISNULL(dbo.Поисковая.Цена, 0)
                      AS Цена, CASE WHEN ISnull(Поисковая.Остаток, 0) - isnull(Поисковая.Количество, 0) = 0 THEN 0 ELSE ISnull(Поисковая.Остаток, 0) - isnull(Поисковая.Количество,
                      0) END AS Доступно, ISNULL(dbo.Поисковая.Количество, 0) AS Резерв, dbo.Поисковая.Описание, NULL AS Заказ, NULL AS Срок,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена1, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена1,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена2, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена2,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена3, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена3,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена4, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена4,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена5, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена5,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена6, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена6,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена7, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена7,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена8, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена8,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена9, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена9,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена10, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена10,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена11, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена11,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена12, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена12,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена13, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена13,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена14, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена14,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена15, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена15,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена16, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена16,
                      CASE WHEN MAX(Поисковая.ID_Клиента) IS NULL THEN isnull(Поисковая.Цена17, 0) ELSE MAX(Поисковая.Спец_цена) END AS Цена17,
                      null as Дата, dbo.Поисковая.[Не возвратный], dbo.Поисковая.[Виден только менеджерам], dbo.Поисковая.IsEnsureDeliveryTerm,
					  dbo.Поисковая.[IsQualityGuaranteed],
					  CASE WHEN dbo.Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
                      CASE WHEN dbo.Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM         dbo.Брэнды AS Брэнды_1 INNER JOIN
                      dbo.[Каталог запчастей] AS [Каталог запчастей_1] ON Брэнды_1.ID_Брэнда = [Каталог запчастей_1].ID_Брэнда INNER JOIN
                      dbo.[Каталоги поставщиков] AS [Каталоги поставщиков_1] ON Брэнды_1.Брэнд = [Каталоги поставщиков_1].Брэнд AND
                      [Каталог запчастей_1].namepost = [Каталоги поставщиков_1].Name LEFT OUTER JOIN
                      dbo.Поисковая ON [Каталог запчастей_1].ID_аналога = dbo.Поисковая.ID_аналога RIGHT OUTER JOIN
                      dbo.[Каталоги поставщиков] ON [Каталоги поставщиков_1].ID_Поставщика = dbo.[Каталоги поставщиков].ID_Поставщика AND
                      [Каталоги поставщиков_1].ID_Аналога = dbo.[Каталоги поставщиков].ID_Аналога
WHERE     (RTRIM(dbo.[Каталоги поставщиков].Name) = RTRIM(@name)) AND (RTRIM(dbo.[Каталоги поставщиков].Брэнд) = RTRIM(@brend)) AND
                      (dbo.Поисковая.ID_Клиента = @klient OR
                      dbo.Поисковая.ID_Клиента IS NULL) AND (dbo.Поисковая.ID_Запчасти IS NOT NULL) AND (CASE WHEN ISnull(Поисковая.Остаток, 0)
                      - isnull(Поисковая.Количество, 0) = 0 THEN 0 ELSE ISnull(Поисковая.Остаток, 0) - isnull(Поисковая.Количество, 0) END <> 0) OR
                      (RTRIM(dbo.[Каталоги поставщиков].Name) = RTRIM(@name)) AND (RTRIM(dbo.[Каталоги поставщиков].Брэнд) = RTRIM(@brend)) AND
                      (dbo.Поисковая.ID_Клиента = @klient OR
                      dbo.Поисковая.ID_Клиента IS NULL) AND (dbo.Поисковая.ID_Запчасти IS NOT NULL) AND (ISNULL(dbo.Поисковая.Количество, 0) <> 0)
GROUP BY dbo.Поисковая.ID_Запчасти, dbo.Поисковая.ID_аналога, dbo.Поисковая.Цена, dbo.Поисковая.Брэнд, dbo.Поисковая.[Номер поставщика], dbo.Поисковая.Описание,
                      dbo.Поисковая.[Сокращенное название], dbo.Поисковая.[Время заказа], dbo.Поисковая.[Время прихода], dbo.Поисковая.ID_аналога, dbo.Поисковая.Остаток, dbo.Поисковая.Количество, dbo.Поисковая.ID_Клиента,
                      dbo.Поисковая.Цена1, dbo.Поисковая.Цена2, dbo.Поисковая.Цена3, dbo.Поисковая.Цена4, dbo.Поисковая.Цена5, dbo.Поисковая.Цена6, dbo.Поисковая.Цена7,
                      dbo.Поисковая.Цена8, dbo.Поисковая.Цена9, dbo.Поисковая.Цена10, dbo.Поисковая.Цена11, dbo.Поисковая.Цена12, dbo.Поисковая.Цена13,
                      dbo.Поисковая.Цена14, dbo.Поисковая.Цена15, dbo.Поисковая.Цена16, dbo.Поисковая.Цена17, dbo.Поисковая.[Не возвратный], dbo.Поисковая.[Виден только менеджерам],
					  dbo.Поисковая.IsEnsureDeliveryTerm, dbo.Поисковая.IsQualityGuaranteed, CASE WHEN dbo.Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
                      CASE WHEN dbo.Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END
)
go

