ALTER PROCEDURE [dbo].[sp_web_getproductsbybrand] 	
	@number varchar(25), @brand varchar(18), @klientId int
AS
BEGIN
	DECLARE @analogId INT, @productId INT, @name VARCHAR(25), @firstBrand VARCHAR(18)

	SELECT
	@firstBrand = shortNumber
	,@name = shortNumber
	,@productId = productId
	,@analogId = analogId
	FROM getPartsByNumber(@number)
	WHERE brand LIKE @brand


	IF @analogId > 0
		SELECT
		ID_Запчасти AS id
		,TRIM(Брэнд) AS brand
		,TRIM([Сокращенное название]) AS vendor
		,TRIM([Номер запчасти]) AS number
		,Цена AS retail
		,Доступно AS available
		,Резерв AS reserve
		,TRIM(Описание) AS description
		,Заказ AS [order]
		,Срок AS term
		,Цена1 AS Price1
		,Цена2 AS Price2
		,Цена3 AS Price3
		,Цена4 AS Price4
		,Цена5 AS Price5
		,Цена6 AS Price6
		,Цена7 AS Price7
		,Цена8 AS Price8
		,Цена9 AS Price9
		,Цена10 AS Price10
		,Цена11 AS Price11
		,Цена12 AS Price12
		,Цена13 AS Price13
		,Цена14 AS Price14
		,Цена15 AS Price15
		,Цена16 AS Price16
		,Цена17 AS Price17
		,FORMAT(Дата, 'd', 'de-de') AS date
		,[Не возвратный] AS ImpossibleReturn
		,[Виден только менеджерам] AS OnlyForManagers
		,IsEnsureDeliveryTerm AS isGuaranteedTerm
		,IsQualityGuaranteed AS isGoodQuality
		FROM GetPartsByAnalog(@firstBrand, @name, @analogId, @klientId)
	ELSE IF @productId > 0
		SELECT
		ID_Запчасти AS id
		,TRIM(Брэнд) AS brand
		,TRIM([Сокращенное название]) AS vendor
		,TRIM([Номер запчасти]) AS number
		,Цена AS retail
		,Доступно AS available
		,Резерв AS reserve
		,TRIM(Описание) AS description
		,Заказ AS [order]
		,Срок AS term
		,Цена1 AS Price1
		,Цена2 AS Price2
		,Цена3 AS Price3
		,Цена4 AS Price4
		,Цена5 AS Price5
		,Цена6 AS Price6
		,Цена7 AS Price7
		,Цена8 AS Price8
		,Цена9 AS Price9
		,Цена10 AS Price10
		,Цена11 AS Price11
		,Цена12 AS Price12
		,Цена13 AS Price13
		,Цена14 AS Price14
		,Цена15 AS Price15
		,Цена16 AS Price16
		,Цена17 AS Price17
		,FORMAT(Дата, 'd', 'de-de') AS date
		,[Не возвратный] AS ImpossibleReturn
		,[Виден только менеджерам] AS OnlyForManagers
		,IsEnsureDeliveryTerm AS isGuaranteedTerm
		,IsQualityGuaranteed AS isGoodQuality		
		FROM GetPartsByShortNumber(@firstBrand, @name, @klientId)
	ELSE
        SELECT
		ID_Запчасти AS id
		,TRIM(Брэнд) AS brand
		,TRIM([Сокращенное название]) AS vendor
		,TRIM([Номер запчасти]) AS number
		,Цена AS retail
		,Доступно AS available
		,Резерв AS reserve
		,TRIM(Описание) AS description
		,Заказ AS [order]
		,Срок AS term
		,Цена1 AS Price1
		,Цена2 AS Price2
		,Цена3 AS Price3
		,Цена4 AS Price4
		,Цена5 AS Price5
		,Цена6 AS Price6
		,Цена7 AS Price7
		,Цена8 AS Price8
		,Цена9 AS Price9
		,Цена10 AS Price10
		,Цена11 AS Price11
		,Цена12 AS Price12
		,Цена13 AS Price13
		,Цена14 AS Price14
		,Цена15 AS Price15
		,Цена16 AS Price16
		,Цена17 AS Price17
		,FORMAT(Дата, 'd', 'de-de') AS date
		,[Не возвратный] AS ImpossibleReturn
		,[Виден только менеджерам] AS OnlyForManagers
		,IsEnsureDeliveryTerm AS isGuaranteedTerm
		,IsQualityGuaranteed AS isGoodQuality
		FROM GetPartsByBrand(@firstBrand, @name, @klientId)

END