CREATE PROCEDURE [dbo].[sp_web_getproductbynumber]
	@number varchar(25)
AS
BEGIN
	SELECT top 50 brand
	,MAX(number) as number
	,[name] as shortNumber
	,MAX(description) as description
	,MIN(ID_Запчасти) as productId
	,MAX(ID_Аналога) as analogId
	,ISNULL(MAX(FirstBrend), brand) as firstBrand
	FROM
	(
	SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, Брэнды.Брэнд) AS brand,
				MAX([Каталог запчастей].[Номер поставщика]) AS number,
				 [Каталог запчастей].namepost AS Name, MAX([Каталог запчастей].Описание) AS description,
				0 AS ID_Запчасти, [Каталог запчастей].ID_аналога,  dbo.Брэнды.Брэнд AS firstBrend
	FROM        [Каталог запчастей] INNER JOIN
						  Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда LEFT OUTER JOIN
						  [Аналогичные брэнды] ON Брэнды.Брэнд = [Аналогичные брэнды].Брэнд
	WHERE     ([Каталог запчастей].namepost like @number) OR
						  ([Каталог запчастей].NAME like @number)
	GROUP BY Брэнды.Брэнд, [Каталог запчастей].namepost, [Каталог запчастей].ID_аналога,
				[Аналогичные брэнды].Брэнд_аналог

	UNION

	SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Каталоги поставщиков].Брэнд) AS brand,
				[Каталоги поставщиков].[Номер запчасти], [Каталоги поставщиков].Name AS shortNumber,
				MAX([Каталоги поставщиков].Описание) AS description,
				MAX([Каталоги поставщиков].ID_запчасти) AS ID_Запчасти, NULL AS analogId,
				dbo.[Каталоги поставщиков].Брэнд AS firstBrend

	FROM        [Каталоги поставщиков] LEFT OUTER JOIN
						  [Аналогичные брэнды] ON [Каталоги поставщиков].Брэнд = [Аналогичные брэнды].Брэнд
	WHERE     [Каталоги поставщиков].Name like @number
	GROUP BY  [Каталоги поставщиков].Брэнд, [Каталоги поставщиков].Name,
				[Каталоги поставщиков].[Номер запчасти], [Аналогичные брэнды].Брэнд_аналог

	UNION

	SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Таблица аналогов].Брэнд) AS brand,
				[Таблица аналогов].Номер, [Таблица аналогов].Name AS shortNumber, NULL AS Описание, 0 AS productId,
				NULL AS ID_Аналога, Null AS firstBrend
	FROM        [Таблица аналогов] LEFT OUTER JOIN
				[Аналогичные брэнды] ON [Таблица аналогов].Брэнд = [Аналогичные брэнды].Брэнд
	WHERE       ([Таблица аналогов].Name like @number)
	GROUP BY    [Таблица аналогов].Брэнд, [Таблица аналогов].Номер, [Таблица аналогов].Name,
				[Аналогичные брэнды].Брэнд_аналог

	UNION

	SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Таблица аналогов_1].Брэнд_) AS brand,
				MIN([Таблица аналогов_1].Номер_) AS number, [Таблица аналогов_1].Name_ AS shortNumber,
				NULL AS Описание, 0 AS productId, NULL AS analogId,
				Null AS firstBrend
	FROM       [Таблица аналогов] AS [Таблица аналогов_1] LEFT OUTER JOIN
				[Аналогичные брэнды] ON [Таблица аналогов_1].Брэнд_ = [Аналогичные брэнды].Брэнд
	WHERE     ([Таблица аналогов_1].Name_ like @number)
	GROUP BY [Таблица аналогов_1].Name_, [Таблица аналогов_1].Брэнд_, [Аналогичные брэнды].Брэнд_аналог

	) as twoTable

	Group by brand, [name]

	Order by brand, shortNumber

END
