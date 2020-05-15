CREATE PROCEDURE sp_web_addorder
    @clientId int,
    @productId int,
    @price decimal(9,2),
    @isEuroClient bit,
    @quantity int,
    @onlyOrderedQuantity bit,
    @currentUser char(20)
AS
BEGIN
DECLARE @priceUah decimal(9,2)
SET DATEFIRST 1

IF(@isEuroClient = 1)
    BEGIN
        SET @priceUah = @price * dbo.GetUahRate()
    END
ELSE
    BEGIN
        SET @priceUah = @price
        SET @price = @priceUah/dbo.GetUahRate()
    END

DECLARE @brandName varchar(50), @brandId int, @vendorId int, @shortNumber varchar(26), @term decimal(9, 1),
    @number varchar(26), @vendorNumber varchar(26), @analogId int, @description varchar(80), @carId int, @groupId int

SELECT    @brandName = dbo.[Каталоги поставщиков].Брэнд, @vendorId = dbo.[Каталоги поставщиков].ID_Поставщика,
       @shortNumber = dbo.[Каталоги поставщиков].Name, @number = dbo.[Каталоги поставщиков].[Номер поставщика],
       @vendorNumber = dbo.[Каталоги поставщиков].[Номер запчасти], @description = dbo.[Каталоги поставщиков].Описание,
       @term = dbo.[Каталоги поставщиков].[Срок доставки]
FROM            dbo.[Каталоги поставщиков]
WHERE     (ID_Запчасти = @productId)

SELECT    @brandId = ID_Брэнда
FROM      Брэнды
WHERE     (Брэнд LIKE @brandName)

IF (@@ROWCOUNT = 0)
    BEGIN
        INSERT INTO Брэнды(Брэнд) VALUES (@brandName)
        SET @brandId = CAST(SCOPE_IDENTITY() AS int)
    END


SELECT   @productId = dbo.[Каталог запчастей].ID_Запчасти
FROM    dbo.[Каталог запчастей]
WHERE   (ID_Брэнда LIKE @brandId) AND ([namepost] LIKE @shortNumber) AND (ID_Поставщика LIKE @vendorId)

IF (@@ROWCOUNT = 0)
    BEGIN

        SELECT    @analogId = dbo.[Каталог запчастей].ID_аналога, @carId = dbo.[Каталог запчастей].ID_Автомобиля,
                  @groupId = dbo.[Каталог запчастей].[ID_Группы товаров], @description = dbo.[Каталог запчастей].Описание
        FROM      dbo.[Каталог запчастей]
        WHERE     (ID_Брэнда LIKE @brandId and [namepost] like @shortNumber)

        IF (@@ROWCOUNT = 0)
            BEGIN
                INSERT INTO [Каталог запчастей] (ID_Поставщика, ID_брэнда,
                                                 [номер запчасти], [Номер поставщика], ID_Аналога, Описание, Цена, Исполнитель)
                VALUES (@vendorId, @brandId,
                        @number, @vendorNumber, 0, @description, @price, @currentUser)

                SET @productId = CAST(SCOPE_IDENTITY() AS int)
            END
        ELSE
            BEGIN
                INSERT INTO [Каталог запчастей] (ID_Поставщика, ID_брэнда,
                                                 [номер запчасти], [Номер поставщика], ID_Автомобиля, [ID_Группы товаров],
                                                 ID_Аналога, Описание, Цена, Исполнитель, Контроль)
                VALUES (@vendorId, @brandId,
                        @number, @vendorNumber, @carId, @groupId, @analogId, @description,
                        @price, @currentUser, 0)

                SET @productId = CAST(SCOPE_IDENTITY() AS int)

            END

    END

DECLARE @arrivalDate datetime

INSERT INTO [Запросы клиентов]
(ID_Клиента, ID_Запчасти, Заказано, Цена, грн, Без_замен, Интернет, Работник, Дата_прихода)
VALUES (@clientId, @productId, @quantity, @price, @priceUah, @onlyOrderedQuantity, 1,
        @currentUser, dbo.GetArrivalDate(@vendorId, @term))


SELECT
    TOP (1) TRIM(VIP) as vip
            ,ID_Запроса as [id]
            ,TRIM([Сокращенное название]) as vendor
            ,TRIM(Брэнд) as brand
            ,TRIM([Номер поставщика]) as number
            ,Альтернатива as note
            ,Заказано as ordered
            ,Подтверждение as approved
            ,FORMAT(ISNULL(Предварительная_дата, Дата_прихода), 'd', 'de-de') as shipmentDate
            ,Цена as euro
            ,Грн as uah
            ,ID_Запчасти as productId
            ,ID_Заказа as orderId
            ,FORMAT (Дата, 'd', 'de-de' ) as orderDate
            ,TRIM(Описание) as description
            ,CASE
                 WHEN Задерживается = 1 THEN 3  /* задерживается */
                 WHEN Нет = 1 THEN 4  /* нету */
                 WHEN Заказано = Подтверждение AND Подтверждение > 0 THEN 0 /* подтвержден */
                 WHEN Подтверждение = 0 AND Нет = 0 THEN 1  /* в обработке */
                 WHEN Заказано > Подтверждение AND Подтверждение > 0 THEN 2  /* неполное кол-во */
                 ELSE 1
            END AS status

FROM   dbo.Запросы
WHERE [ID_Запроса] = @@IDENTITY

END
GO


