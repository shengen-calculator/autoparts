CREATE PROCEDURE [dbo].[sp_web_getproductsbybrand]
	@number varchar(25), @brand varchar(18), @clientId int
AS
BEGIN
	DECLARE @analogId INT, @productId INT,
	    @name VARCHAR(25), @firstBrand VARCHAR(18),
	    @cols AS NVARCHAR(MAX), @query  AS NVARCHAR(MAX)

	SELECT
	@firstBrand = firstBrend
	,@name = shortNumber
	,@productId = productId
	,@analogId = analogId
	FROM getPartsByNumber(@number)
	WHERE brand LIKE @brand

    SET @cols = N'ID_Запчасти AS id
		,TRIM(Брэнд) AS brand
		,TRIM([Сокращенное название]) AS vendor
		,TRIM([Время заказа]) as orderTime
	    ,TRIM([Время прихода]) as arrivalTime
		,TRIM([Номер запчасти]) AS number
		,Цена * ' + STR(dbo.GetUahRate(), 9, 2) + N' AS retail
		,Цена AS retailEur
		,' + dbo.GetClientPriceColumn(@clientId) + N' AS costEur
		,' + dbo.GetClientPriceColumn(@clientId) + N'*' + STR(dbo.GetUahRate(), 9, 2) + N' AS cost
		,Доступно AS available
		,Резерв AS reserve
		,TRIM(Описание) AS description
		,Заказ AS [order]
		,Срок AS term
		,FORMAT(Дата, ''d'', ''de-de'') AS date
		,[Не возвратный] AS ImpossibleReturn
		,[Виден только менеджерам] AS OnlyForManagers
		,IsEnsureDeliveryTerm AS isGuaranteedTerm
		,IsQualityGuaranteed AS isGoodQuality'


	SET @query = N'SELECT ' + @cols
	IF @analogId > 0
	    SET @query = @query + N' FROM GetPartsByAnalog(''' + @firstBrand + N''', ''' + @name + N''', ' +  STR(@analogId) + N', ' +  STR(@clientId) + N')'
	ELSE IF @productId > 0
        SET @query = @query + N' FROM GetPartsByShortNumber(''' + @firstBrand + N''', ''' + @name + N''', ' +  STR(@clientId) + N')'
	ELSE
        SET @query = @query + N' FROM GetPartsByBrand(''' + @firstBrand + N''', ''' + @name + N''', ' + STR(@clientId) + N')'
    exec sp_executesql @query

END