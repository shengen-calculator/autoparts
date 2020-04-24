CREATE PROCEDURE [dbo].[sp_web_getproductbynumber]
	@number varchar(25)
AS
BEGIN
Select top 50
TRIM(Брэнд) as brand
,TRIM(MAX([Номер запчасти])) as number
,TRIM([name]) as shortNumber
,TRIM(MAX(Описание)) as description
,MIN(ID_Запчасти) as productId
,MAX(ID_Аналога) as analogId
,TRIM(ISNULL(MAX(FirstBrend), Брэнд)) as firstBrend
FROM
(
SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, Брэнды.Брэнд) AS Брэнд,
			MAX([Каталог запчастей].[Номер поставщика]) AS [Номер запчасти],
             [Каталог запчастей].namepost AS Name, MAX([Каталог запчастей].Описание) AS Описание,
			0 AS ID_Запчасти, [Каталог запчастей].ID_аналога,  dbo.Брэнды.Брэнд AS FirstBrend
FROM        [Каталог запчастей] INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда LEFT OUTER JOIN
                      [Аналогичные брэнды] ON Брэнды.Брэнд = [Аналогичные брэнды].Брэнд
WHERE     ([Каталог запчастей].namepost like @number) OR
                      ([Каталог запчастей].NAME like @number)
GROUP BY Брэнды.Брэнд, [Каталог запчастей].namepost, [Каталог запчастей].ID_аналога,
			[Аналогичные брэнды].Брэнд_аналог

UNION

SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Каталоги поставщиков].Брэнд) AS Брэнд,
			[Каталоги поставщиков].[Номер запчасти], [Каталоги поставщиков].Name,
			MAX([Каталоги поставщиков].Описание) AS Описание,
			MAX([Каталоги поставщиков].ID_запчасти) AS ID_Запчасти, NULL AS ID_аналога,
			dbo.[Каталоги поставщиков].Брэнд AS FirstBrend

FROM        [Каталоги поставщиков] LEFT OUTER JOIN
                      [Аналогичные брэнды] ON [Каталоги поставщиков].Брэнд = [Аналогичные брэнды].Брэнд
WHERE     [Каталоги поставщиков].Name like @number
GROUP BY  [Каталоги поставщиков].Брэнд, [Каталоги поставщиков].Name,
			[Каталоги поставщиков].[Номер запчасти], [Аналогичные брэнды].Брэнд_аналог

UNION

SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Таблица аналогов].Брэнд) AS Брэнд,
			[Таблица аналогов].Номер, [Таблица аналогов].Name, NULL AS Описание, 0 AS ID_Запчасти,
			NULL AS ID_Аналога, Null AS FirstBrend
FROM        [Таблица аналогов] LEFT OUTER JOIN
            [Аналогичные брэнды] ON [Таблица аналогов].Брэнд = [Аналогичные брэнды].Брэнд
WHERE       ([Таблица аналогов].Name like @number)
GROUP BY    [Таблица аналогов].Брэнд, [Таблица аналогов].Номер, [Таблица аналогов].Name,
			[Аналогичные брэнды].Брэнд_аналог

UNION

SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Таблица аналогов_1].Брэнд_) AS Брэнд,
			MIN([Таблица аналогов_1].Номер_) AS Номер, [Таблица аналогов_1].Name_ AS name,
			NULL AS Описание, 0 AS ID_Запчасти, NULL AS ID_Аналога,
			Null AS FirstBrend
FROM       [Таблица аналогов] AS [Таблица аналогов_1] LEFT OUTER JOIN
			[Аналогичные брэнды] ON [Таблица аналогов_1].Брэнд_ = [Аналогичные брэнды].Брэнд
WHERE     ([Таблица аналогов_1].Name_ like @number)
GROUP BY [Таблица аналогов_1].Name_, [Таблица аналогов_1].Брэнд_, [Аналогичные брэнды].Брэнд_аналог

) as twoTable

Group by Брэнд, [name]

Order by Брэнд, [name]

END
