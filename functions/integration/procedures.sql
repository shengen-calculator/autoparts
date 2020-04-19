
CREATE FUNCTION [dbo].[GetAmountOverdueDebt]
(
	@clientId int, 
	@dayQuantity int
)
RETURNS DECIMAL(9,2)
AS
BEGIN
	DECLARE @lastDay datetime, @isEuro bit, @debtEur decimal(12, 2), 
	@debtUah decimal(12, 2), @paidEur decimal(12, 2), @paidUah decimal(12, 2)
	
	SET @lastDay = DATEADD(day, @dayQuantity, CURRENT_TIMESTAMP) 
	
	SELECT   @debtEur = SUM(Eur), @debtUah = SUM(Uah)
	FROM (SELECT ID_Клиента, Количество, Цена, Грн, Количество * Цена AS Eur, Количество * Грн AS Uah
		  FROM   dbo.[Подчиненная накладные]
		  WHERE  ((Нету = 0) AND (Обработано = 1) AND (ID_Клиента = @clientId)) AND
				 ((Дата_закрытия < @lastDay) OR (Количество < 0))) AS derivedtbl_1
	SELECT  @paidEur = SUM(Цена), @paidUah = SUM(Грн)
	FROM    dbo.Касса
	WHERE   ID_Клиента = @clientId

	SELECT  @isEuro = Расчет_в_евро
	FROM    dbo.Клиенты
	WHERE   ID_Клиента = @clientId
	
	IF(@debtEur < @paidEur)
		RETURN 0
	
	IF(@isEuro = 1) 
		RETURN @debtEur - @paidEur
	
	RETURN @debtUah - @paidUah
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetAmountOverdueDebt_new]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetAmountOverdueDebt_new]
(
	@clientId int, 
	@dayQuantity int
)
RETURNS DECIMAL(9,2)
AS
BEGIN
	DECLARE @lastDay datetime, @isEuro bit, @debtEur decimal(12, 2), 
	@debtUah decimal(12, 2), @paidEur decimal(12, 2), @paidUah decimal(12, 2)
	
	SET @lastDay = DATEADD(day, @dayQuantity, CURRENT_TIMESTAMP) 
	
	SELECT   @debtEur = SUM(Eur), @debtUah = SUM(Uah)
	FROM (SELECT ID_Клиента, Количество, Цена, Грн, Количество * Цена AS Eur, Количество * Грн AS Uah
		  FROM   dbo.[Подчиненная накладные]
		  WHERE  ((Нету = 0) AND (Обработано = 1) AND (ID_Клиента = @clientId)) AND
				 ((Дата_закрытия < @lastDay) OR (Количество < 0))) AS derivedtbl_1
	SELECT  @paidEur = SUM(Цена), @paidUah = SUM(Грн)
	FROM    dbo.Касса
	WHERE   ID_Клиента = @clientId

	SELECT  @isEuro = Расчет_в_евро
	FROM    dbo.Клиенты
	WHERE   ID_Клиента = @clientId
	
	IF(@debtEur < @paidEur)
		RETURN 0
	
	IF(@isEuro = 1) 
		RETURN @debtEur - @paidEur
	
	RETURN @debtUah - @paidUah
END

GO
/****** Object:  UserDefinedFunction [dbo].[IsPositionDelayed]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsPositionDelayed]
(
	@requestId INT
)
RETURNS BIT
AS
BEGIN
	DECLARE @delayed BIT
	DECLARE @orderId INT

	SELECT @delayed = [Задерживается], @orderId = [ID_Заказа]
	FROM [dbo].[Запросы клиентов]
	WHERE ID_Запроса = @requestId
	
	IF @delayed = 1	RETURN 1

	SELECT  @delayed =  [Задерживается]
    FROM [dbo].[Заказы поставщикам]
	WHERE ID_Заказа = @orderId

	IF @delayed = 1 RETURN 1

	RETURN 0
END
GO
/****** Object:  Table [dbo].[Каталог запчастей]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Каталог запчастей](
	[ID_Запчасти] [int] IDENTITY(1,1) NOT NULL,
	[Номер запчасти] [char](25) NOT NULL,
	[Номер поставщика] [char](25) NULL,
	[ID_Поставщика] [int] NOT NULL,
	[ID_Брэнда] [int] NOT NULL,
	[NAME] [char](25) NULL,
	[ID_Автомобиля] [int] NOT NULL,
	[ID_Группы товаров] [int] NOT NULL,
	[Описание] [char](80) NULL,
	[ID_аналога] [int] NOT NULL,
	[Скидка] [int] NULL,
	[Цена] [decimal](9, 2) NULL,
	[Цена1] [decimal](9, 2) NULL,
	[Цена2] [decimal](9, 2) NULL,
	[Цена3] [decimal](9, 2) NULL,
	[Цена4] [decimal](9, 2) NULL,
	[Цена5] [decimal](9, 2) NULL,
	[Цена6] [decimal](9, 2) NULL,
	[Цена7] [decimal](9, 2) NULL,
	[Цена8] [decimal](9, 2) NULL,
	[Цена9] [decimal](9, 2) NULL,
	[Цена10] [decimal](9, 2) NULL,
	[Цена11] [decimal](9, 2) NULL,
	[Цена12] [decimal](9, 2) NULL,
	[Цена13] [decimal](9, 2) NULL,
	[Цена14] [decimal](9, 2) NULL,
	[Цена15] [decimal](9, 2) NULL,
	[Цена16] [decimal](9, 2) NULL,
	[Цена17] [decimal](9, 2) NULL,
	[Нет_цены] [bit] NOT NULL,
	[Обработана] [bit] NOT NULL,
	[Срочно] [bit] NOT NULL,
	[Исполнитель] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[ID] [int] NULL,
	[Распродажа] [bit] NOT NULL,
	[Цена_обработана] [bit] NOT NULL,
	[Рекомендовано на склад] [int] NULL,
	[Рекомендовано по аналогу] [int] NULL,
	[Обработано_нац_10] [bit] NOT NULL,
	[Спеццена поставщика грн] [decimal](9, 2) NULL,
	[Спеццена поставщика долл] [decimal](9, 2) NULL,
	[Спеццена поставщика евро] [decimal](9, 2) NULL,
	[namepost] [char](25) NULL,
	[Контроль] [bit] NOT NULL,
	[Remote Warehouse] [bit] NOT NULL,
 CONSTRAINT [PK_Каталог запчастей] PRIMARY KEY CLUSTERED 
(
	[ID_Запчасти] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [nona] UNIQUE NONCLUSTERED 
(
	[ID_Поставщика] ASC,
	[ID_Брэнда] ASC,
	[NAME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Поставщики]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Поставщики](
	[ID_Поставщика] [int] IDENTITY(1,1) NOT NULL,
	[Сокращенное название] [char](15) NOT NULL,
	[Название] [char](50) NULL,
	[Общее название] [char](50) NULL,
	[Жаргон] [char](30) NULL,
	[Включать в прайс] [bit] NOT NULL,
	[VIP] [char](3) NOT NULL,
	[Индекс] [char](5) NULL,
	[Город] [char](20) NULL,
	[Адрес] [char](50) NULL,
	[Телефон_1] [char](100) NULL,
	[Телефон_2] [char](100) NULL,
	[Телефон_3] [char](100) NULL,
	[Телефон_4] [char](100) NULL,
	[Телефон_5] [char](100) NULL,
	[Телефон_6] [char](100) NULL,
	[Факс] [char](20) NULL,
	[EMail] [char](40) NULL,
	[Web] [char](40) NULL,
	[ICQ_1] [char](40) NULL,
	[ICQ_2] [char](40) NULL,
	[ICQ_3] [char](40) NULL,
	[Банк] [char](60) NULL,
	[МФО] [char](6) NULL,
	[Расчетный счет] [char](14) NULL,
	[Примечание] [char](500) NULL,
	[Сотрудник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Сумма отсрочки грн] [int] NULL,
	[Сумма отсрочки долл] [int] NULL,
	[Сумма отсрочки евро] [int] NULL,
	[Сумма отсрочки безнал] [int] NULL,
	[Количество дней отсрочки] [int] NULL,
	[Активный] [bit] NOT NULL,
	[Грн] [bit] NOT NULL,
	[Евро] [bit] NOT NULL,
	[Долл] [bit] NOT NULL,
	[Грн_бн] [bit] NOT NULL,
	[Время заказа] [char](200) NULL,
	[Время прихода] [char](200) NULL,
	[Виден только менеджерам] [bit] NOT NULL,
	[Не возвратный] [bit] NOT NULL,
	[OrderDays] [nchar](15) NULL,
	[OrderTime] [time](7) NULL,
	[IsEnsureDeliveryTerm] [bit] NOT NULL,
	[IsQualityGuaranteed] [bit] NOT NULL,
 CONSTRAINT [PK_Поставщики] PRIMARY KEY CLUSTERED 
(
	[ID_Поставщика] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [viper] UNIQUE NONCLUSTERED 
(
	[VIP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Брэнды]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Брэнды](
	[ID_Брэнда] [int] IDENTITY(1,1) NOT NULL,
	[Брэнд] [char](50) NULL,
 CONSTRAINT [PK_Брэнды] PRIMARY KEY CLUSTERED 
(
	[ID_Брэнда] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Брэнды] UNIQUE NONCLUSTERED 
(
	[Брэнд] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Запросы клиентов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Запросы клиентов](
	[ID_Запроса] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NOT NULL,
	[Альтернатива] [char](30) NULL,
	[ID_Запчасти] [int] NOT NULL,
	[Заказано] [int] NOT NULL,
	[Подтверждение] [int] NOT NULL,
	[Заказали] [bit] NOT NULL,
	[Без_замен] [bit] NOT NULL,
	[Нет] [bit] NOT NULL,
	[Филиал] [bit] NOT NULL,
	[ID_Заказа] [int] NULL,
	[Цена] [decimal](9, 2) NULL,
	[Грн] [decimal](9, 2) NULL,
	[Доставлено] [int] NOT NULL,
	[Обработано] [bit] NOT NULL,
	[Анализ] [bit] NOT NULL,
	[Цена_прихода_грн] [decimal](9, 3) NULL,
	[Цена_прихода_евро] [decimal](9, 3) NULL,
	[Цена_прихода_долл] [decimal](9, 3) NULL,
	[Номер_накладной] [char](10) NULL,
	[Дата_накладной] [datetime] NULL,
	[Примечание] [char](100) NULL,
	[Дата_заказа] [datetime] NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Безналичные] [bit] NOT NULL,
	[Срочно] [bit] NOT NULL,
	[Возврат] [bit] NOT NULL,
	[upd_dostavleno_pass] [char](10) NULL,
	[Интернет] [bit] NOT NULL,
	[Задерживается] [bit] NOT NULL,
	[Дата_прихода] [datetime] NULL,
	[EntrepreneurId] [int] NULL,
 CONSTRAINT [PK_Запросы клиентов] PRIMARY KEY CLUSTERED 
(
	[ID_Запроса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Хиты_продаж_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_продаж_2]
AS
SELECT     ID_Запчасти
FROM         dbo.[Запросы клиентов]
WHERE     (Заказано <> 0) AND (Обработано = 0) AND (ID_Клиента = 378)

GO
/****** Object:  Table [dbo].[Операции]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Операции](
	[ID_Операции] [int] IDENTITY(1,1) NOT NULL,
	[ID_Запчасти] [int] NOT NULL,
	[Приход] [int] NOT NULL,
	[Расход] [int] NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Работник] [char](80) NOT NULL,
	[Id_Накладной] [int] NULL,
	[Id_Запроса] [int] NULL,
	[Id_Возвратной_накладной] [int] NULL,
	[Id_Клиента] [int] NOT NULL,
	[Цена_закупки] [decimal](9, 2) NOT NULL,
	[Цена_продажи] [decimal](9, 2) NOT NULL,
	[Дата_опер] [datetime] NOT NULL,
 CONSTRAINT [PK_Операции] PRIMARY KEY CLUSTERED 
(
	[ID_Операции] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Операции_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Операции_]
AS
SELECT        ID_Операции, ID_Запчасти, Приход, Расход, Дата, Работник, Id_Накладной, Id_Запроса, Id_Клиента, Цена_закупки, Цена_продажи, Дата_опер
FROM            dbo.Операции
WHERE        (Расход >= 0)

GO
/****** Object:  View [dbo].[Остаток_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Остаток_]
AS
SELECT     ID_Запчасти, SUM(Приход) AS Expr1, SUM(Расход) AS Expr2, SUM(Приход) - SUM(Расход) AS Остаток
FROM         dbo.Операции_
GROUP BY ID_Запчасти
GO
/****** Object:  Table [dbo].[Отгрузочные накладные]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Отгрузочные накладные](
	[ID_Накладной] [int] NOT NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
 CONSTRAINT [PK_Отгрузочные накладные] PRIMARY KEY CLUSTERED 
(
	[ID_Накладной] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Подчиненная накладные]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Подчиненная накладные](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Накладной] [int] NULL,
	[ID_Клиента] [int] NOT NULL,
	[ID_Запчасти] [int] NOT NULL,
	[Количество] [int] NOT NULL,
	[Цена] [decimal](9, 2) NULL,
	[Грн] [decimal](9, 2) NULL,
	[Добавить] [bit] NOT NULL,
	[Обработано] [bit] NOT NULL,
	[Нету] [bit] NOT NULL,
	[Поставщик] [char](10) NULL,
	[Заказ] [char](10) NULL,
	[Статус] [char](50) NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Дата_закрытия] [datetime] NULL,
	[Анализ] [bit] NOT NULL,
	[Оплачено] [bit] NOT NULL,
	[Пароль] [char](10) NOT NULL,
 CONSTRAINT [PK_Подчиненная накладные] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Резерв_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Резерв_1]
AS
SELECT     dbo.[Подчиненная накладные].ID_Запчасти, SUM(dbo.[Подчиненная накладные].Количество) AS Количество
FROM         dbo.[Подчиненная накладные] LEFT OUTER JOIN
                      dbo.[Отгрузочные накладные] ON dbo.[Подчиненная накладные].ID_Накладной = dbo.[Отгрузочные накладные].ID_Накладной
WHERE     (dbo.[Подчиненная накладные].ID_Клиента <> 378) AND (dbo.[Подчиненная накладные].Обработано = 0)
GROUP BY dbo.[Подчиненная накладные].ID_Запчасти
GO
/****** Object:  View [dbo].[Хиты_продаж_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_продаж_1]
AS
SELECT     dbo.Остаток_.ID_Запчасти, dbo.Остаток_.Остаток - ISNULL(dbo.Резерв_1.Количество, 0) AS Остаток
FROM         dbo.Остаток_ LEFT OUTER JOIN
                      dbo.Резерв_1 ON dbo.Остаток_.ID_Запчасти = dbo.Резерв_1.ID_Запчасти
WHERE     (dbo.Остаток_.Остаток - ISNULL(dbo.Резерв_1.Количество, 0) = 0)

GO
/****** Object:  View [dbo].[Хиты_продаж_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Хиты_продаж_3]
AS
SELECT     ID_Запчасти, SUM(Расход) AS Продано
FROM         dbo.Операции
WHERE     (Id_Клиента <> 378)
GROUP BY ID_Запчасти
HAVING      (SUM(Расход) > 2)
GO
/****** Object:  View [dbo].[Хиты_продаж_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_продаж_4]
AS
SELECT     TOP 100 PERCENT dbo.Хиты_продаж_3.ID_Запчасти, dbo.Хиты_продаж_3.Продано
FROM         dbo.Хиты_продаж_3 INNER JOIN
                      dbo.Хиты_продаж_1 ON dbo.Хиты_продаж_3.ID_Запчасти = dbo.Хиты_продаж_1.ID_Запчасти
ORDER BY dbo.Хиты_продаж_3.Продано DESC

GO
/****** Object:  View [dbo].[Хиты_продаж_5]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_продаж_5]
AS
SELECT     dbo.Хиты_продаж_4.ID_Запчасти, dbo.Хиты_продаж_4.Продано
FROM         dbo.Хиты_продаж_4 LEFT OUTER JOIN
                      dbo.Хиты_продаж_2 ON dbo.Хиты_продаж_4.ID_Запчасти = dbo.Хиты_продаж_2.ID_Запчасти
WHERE     (dbo.Хиты_продаж_2.ID_Запчасти IS NULL)

GO
/****** Object:  View [dbo].[Хиты_продаж]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_продаж]
AS
SELECT     TOP 100 PERCENT dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.Хиты_продаж_5.Продано, dbo.[Каталог запчастей].Описание
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Хиты_продаж_5 ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Хиты_продаж_5.ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
ORDER BY dbo.Хиты_продаж_5.Продано DESC

GO
/****** Object:  Table [dbo].[Возвратные накладные]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Возвратные накладные](
	[ID_Накладной] [int] IDENTITY(1,1) NOT NULL,
	[Номер] [int] NULL,
	[ID_Запроса] [int] NOT NULL,
	[Количество] [int] NOT NULL,
	[Сотрудник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Проводка] [bit] NOT NULL,
 CONSTRAINT [PK_Возвратные накладные] PRIMARY KEY CLUSTERED 
(
	[ID_Накладной] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Возврат_на_ЕССО_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Возврат_на_ЕССО_]
AS
SELECT     ID_Запроса, SUM(Количество) AS Возврат
FROM         dbo.[Возвратные накладные]
GROUP BY ID_Запроса
GO
/****** Object:  View [dbo].[Хиты_по_аналогу_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_1]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога, SUM(dbo.Операции.Приход) - SUM(dbo.Операции.Расход) AS Остаток
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
GROUP BY dbo.[Каталог запчастей].ID_аналога

GO
/****** Object:  View [dbo].[Хиты_по_аналогу_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_2]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога, SUM(dbo.Резерв_1.Количество) AS Резерв
FROM         dbo.Резерв_1 INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Резерв_1.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
GROUP BY dbo.[Каталог запчастей].ID_аналога

GO
/****** Object:  Table [dbo].[Проводки]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Проводки](
	[ID_Проводки] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NULL,
	[ID_Поставщика] [int] NULL,
	[ID_Сотрудника] [int] NULL,
	[Счет_дебета] [int] NOT NULL,
	[Счет_кредита] [int] NOT NULL,
	[Сумма_грн] [decimal](9, 2) NOT NULL,
	[Сумма_евро] [decimal](9, 2) NOT NULL,
	[Сумма_долл] [decimal](9, 2) NOT NULL,
	[Примечание] [nchar](100) NULL,
	[Дата] [datetime] NOT NULL,
	[Сотрудник] [nchar](20) NOT NULL,
	[Пароль] [nchar](10) NOT NULL,
	[Convert_ID] [int] NULL,
 CONSTRAINT [PK_Проводки] PRIMARY KEY CLUSTERED 
(
	[ID_Проводки] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Товар_от_поставщика_1н_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_1н_2]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 22) AND (DATEDIFF(day, Дата, GETDATE()) < 7)
GROUP BY ID_Поставщика

GO
/****** Object:  Table [dbo].[Каталоги поставщиков]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Каталоги поставщиков](
	[ID_Запчасти] [int] IDENTITY(1,1) NOT NULL,
	[Брэнд] [char](50) NULL,
	[Номер запчасти] [nchar](25) NOT NULL,
	[Name] [char](25) NULL,
	[Описание] [nchar](80) NULL,
	[ID_Поставщика] [int] NOT NULL,
	[Срок доставки] [decimal](9, 1) NULL,
	[Цена1] [decimal](9, 2) NULL,
	[Цена2] [decimal](9, 2) NULL,
	[Цена3] [decimal](9, 2) NULL,
	[Цена4] [decimal](9, 2) NULL,
	[Цена5] [decimal](9, 2) NULL,
	[Цена6] [decimal](9, 2) NULL,
	[Цена7] [decimal](9, 2) NULL,
	[Цена8] [decimal](9, 2) NULL,
	[Цена9] [decimal](9, 2) NULL,
	[Цена10] [decimal](9, 2) NULL,
	[Цена11] [decimal](9, 2) NULL,
	[Цена12] [decimal](9, 2) NULL,
	[Цена13] [decimal](9, 2) NULL,
	[Цена14] [decimal](9, 2) NULL,
	[Цена15] [decimal](9, 2) NULL,
	[Цена16] [decimal](9, 2) NULL,
	[Цена17] [decimal](9, 2) NULL,
	[Цена] [decimal](9, 2) NULL,
	[Наличие] [nchar](10) NULL,
	[ID_Аналога] [char](10) NULL,
	[Номер поставщика] [char](25) NOT NULL,
	[Дата] [datetime] NOT NULL,
 CONSTRAINT [PK_Каталоги поставщиков] PRIMARY KEY CLUSTERED 
(
	[ID_Запчасти] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MIN_INVOICE_FROM_KP]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MIN_INVOICE_FROM_KP]
AS
SELECT        k.Брэнд, k.Name, k.Цена13 AS Vhod_EUR, p.[Сокращенное название] AS Поставщик
FROM            dbo.[Каталоги поставщиков] AS k INNER JOIN
                         dbo.Поставщики AS p ON k.ID_Поставщика = p.ID_Поставщика
WHERE        (k.Цена13 =
                             (SELECT        MIN(Цена13) AS Expr1
                               FROM            dbo.[Каталоги поставщиков]
                               WHERE        (Name = k.Name) AND (Цена13 > 0))) AND (k.Наличие <> '0')
GROUP BY k.Брэнд, k.Name, k.Цена13, p.[Сокращенное название]
GO
/****** Object:  View [dbo].[Хиты_по_аналогу_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_3]
AS
SELECT     dbo.Хиты_по_аналогу_1.ID_аналога, dbo.Хиты_по_аналогу_1.Остаток - ISNULL(dbo.Хиты_по_аналогу_2.Резерв, 0) AS Наличие
FROM         dbo.Хиты_по_аналогу_1 LEFT OUTER JOIN
                      dbo.Хиты_по_аналогу_2 ON dbo.Хиты_по_аналогу_1.ID_аналога = dbo.Хиты_по_аналогу_2.ID_аналога
WHERE     (dbo.Хиты_по_аналогу_1.Остаток - ISNULL(dbo.Хиты_по_аналогу_2.Резерв, 0) = 0)

GO
/****** Object:  View [dbo].[Товар_от_поставщика_2н_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_2н_1]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (DATEDIFF(day, Дата, GETDATE()) < 14) AND (DATEDIFF(day, Дата, GETDATE()) > 7) AND (Счет_кредита = 22)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Хиты_по_аналогу_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_4]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога
FROM         dbo.Хиты_продаж_2 INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Хиты_продаж_2.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
GROUP BY dbo.[Каталог запчастей].ID_аналога

GO
/****** Object:  View [dbo].[Товар_от_поставщика_3н_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_3н_1]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (DATEDIFF(day, Дата, GETDATE()) < 21) AND (DATEDIFF(day, Дата, GETDATE()) > 14) AND (Счет_кредита = 22)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Таблица Аналогов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица Аналогов]
AS
   SELECT sb.Brand_Name AS [Брэнд],
          sn.Spare_Name AS [Номер],
          sn.Int_Spare_Name AS [Name],
          ab.Brand_Name AS [Брэнд_],
          an.Spare_Name AS [Номер_],
          an.Int_Spare_Name AS [Name_],
          'NONE' AS [Примечание]
     FROM AnalogsDB..Spare_Analogs AS a
          INNER JOIN AnalogsDB..Spare_Brands AS sb
             ON a.Brand_ID = sb.Brand_ID
          INNER JOIN AnalogsDB..Spare_Brands AS ab
             ON a.Analog_Brand_ID = ab.Brand_ID
          INNER JOIN AnalogsDB..Spare_Names AS sn
             ON a.Spare_Name_ID = sn.Spare_Name_ID
          INNER JOIN AnalogsDB..Spare_Names AS an
             ON a.Analog_Spare_Name_ID = an.Spare_Name_ID
GO
/****** Object:  View [dbo].[Double_analogs]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Double_analogs] AS 
SELECT 
[Таблица аналогов].[Брэнд], 
[Таблица аналогов].[Name], 
[Таблица аналогов].[Брэнд_], 
[Таблица аналогов].[Name_], 
[Таблица аналогов].[Номер], 
[Таблица аналогов].[Номер_],
[Таблица аналогов].[Примечание]
FROM [Таблица аналогов]
WHERE ((([Таблица аналогов].[Брэнд]) In (SELECT [Брэнд] FROM [Таблица аналогов] As Tmp  
GROUP BY [Брэнд],[Name],[Брэнд_],[Name_] HAVING Count(*)>1  And [Name] = [Таблица аналогов].[Name] And [Брэнд_] = [Таблица аналогов].[Брэнд_] And [Name_] = [Таблица аналогов].[Name_])))

GO
/****** Object:  Table [dbo].[Клиенты]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Клиенты](
	[ID_Клиента] [int] IDENTITY(1,1) NOT NULL,
	[VIP] [char](10) NOT NULL,
	[Фамилия] [char](20) NULL,
	[Имя] [char](20) NULL,
	[Отчество] [char](20) NULL,
	[Д_тел] [char](20) NULL,
	[Р_тел] [char](20) NULL,
	[Моб_тел] [char](20) NULL,
	[Факс] [char](20) NULL,
	[EMail] [char](40) NULL,
	[Город] [char](20) NULL,
	[Адрес] [char](50) NULL,
	[ID_Модели_тариф] [int] NULL,
	[Скидка] [numeric](5, 2) NULL,
	[Нужен_прайс] [bit] NULL,
	[Розничный_клиент] [bit] NULL,
	[Расчет_в_евро] [bit] NOT NULL,
	[Мастерская] [bit] NULL,
	[Опт] [bit] NULL,
	[День_Рождения] [datetime] NULL,
	[Блокировка_продаж] [bit] NULL,
	[Мерцание] [bit] NULL,
	[Примечание] [char](500) NULL,
	[Работник] [char](20) NULL,
	[Количество_дней] [int] NULL,
	[Выводить_просрочку] [bit] NULL,
	[Дата] [datetime] NULL,
	[Пароль] [char](10) NOT NULL,
	[pass] [char](8) NULL,
	[Интернет_заказы] [bit] NOT NULL,
 CONSTRAINT [PK_Клиенты] PRIMARY KEY CLUSTERED 
(
	[ID_Клиента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [VIP] UNIQUE NONCLUSTERED 
(
	[VIP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Группы]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Группы](
	[ID_Группы] [int] IDENTITY(1,1) NOT NULL,
	[Группа] [char](25) NULL,
 CONSTRAINT [PK_Группы] PRIMARY KEY CLUSTERED 
(
	[ID_Группы] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Автомобили]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Автомобили](
	[ID_Автомобиля] [int] IDENTITY(1,1) NOT NULL,
	[Автомобиль] [char](15) NULL,
 CONSTRAINT [PK_Автомобили] PRIMARY KEY CLUSTERED 
(
	[ID_Автомобиля] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Спец_цены]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Спец_цены](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Запчасти] [int] NOT NULL,
	[ID_Клиента] [int] NULL,
	[Цена] [decimal](9, 2) NULL,
	[Сотрудник] [char](30) NOT NULL,
	[Дата] [datetime] NOT NULL,
 CONSTRAINT [PK_Спец_цены] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Спец_цены_2] UNIQUE NONCLUSTERED 
(
	[ID_Запчасти] ASC,
	[ID_Клиента] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Поисковая]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Поисковая]
AS
SELECT     TOP 100 PERCENT dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.[Каталог запчастей].[Номер поставщика], dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].NAME, 
                      dbo.Автомобили.Автомобиль, dbo.Группы.Группа, dbo.[Каталог запчастей].Описание, dbo.[Каталог запчастей].ID_аналога, 
                      dbo.[Каталог запчастей].Скидка, dbo.[Каталог запчастей].Цена, dbo.[Каталог запчастей].Цена1, dbo.[Каталог запчастей].Цена2, 
                      dbo.[Каталог запчастей].Цена3, dbo.[Каталог запчастей].Цена4, ISNULL(dbo.[Остаток_].Остаток, 0) AS Остаток, dbo.[Каталог запчастей].ID, 
                      dbo.[Каталог запчастей].Цена5, dbo.[Каталог запчастей].Цена6, dbo.[Каталог запчастей].Цена7, dbo.[Каталог запчастей].Цена8, 
                      dbo.[Каталог запчастей].Цена9, dbo.[Каталог запчастей].Цена10, dbo.[Каталог запчастей].Цена11, dbo.[Каталог запчастей].Цена12, 
                      dbo.[Каталог запчастей].Цена13, dbo.[Каталог запчастей].Цена14, dbo.[Каталог запчастей].Цена15, dbo.[Каталог запчастей].Цена16, 
                      dbo.[Каталог запчастей].Цена17, dbo.[Резерв_1].Количество, dbo.[Спец_цены].ID_Клиента, dbo.[Спец_цены].Цена AS Спец_цена, 
                      dbo.[Каталог запчастей].Цена_обработана,  dbo.Поставщики.[Не возвратный], dbo.Поставщики.[Виден только менеджерам], 
					  dbo.Поставщики.IsEnsureDeliveryTerm, dbo.Поставщики.IsQualityGuaranteed
FROM         dbo.[Каталог запчастей] LEFT OUTER JOIN
                      dbo.[Спец_цены] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Спец_цены].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Резерв_1] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Резерв_1].ID_Запчасти LEFT OUTER JOIN
                      dbo.Группы ON dbo.[Каталог запчастей].[ID_Группы товаров] = dbo.Группы.ID_Группы LEFT OUTER JOIN
                      dbo.Автомобили ON dbo.[Каталог запчастей].ID_Автомобиля = dbo.Автомобили.ID_Автомобиля LEFT OUTER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда LEFT OUTER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.[Остаток_] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Остаток_].ID_Запчасти
GO
/****** Object:  Table [dbo].[Заказы поставщикам]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Заказы поставщикам](
	[ID_Заказа] [int] NOT NULL,
	[ID_Поставщика] [int] NOT NULL,
	[Предварительная_дата] [datetime] NULL,
	[Точная_дата] [datetime] NULL,
	[Полученый] [bit] NOT NULL,
	[Обработано] [bit] NOT NULL,
	[Задерживается] [bit] NOT NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[ID_Перевозчика] [int] NULL,
	[Примечание] [char](100) NULL,
 CONSTRAINT [PK_Заказы поставщикам] PRIMARY KEY CLUSTERED 
(
	[ID_Заказа] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Запросы]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Запросы]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].Альтернатива, dbo.[Запросы клиентов].Заказано, dbo.[Запросы клиентов].Подтверждение, 
                      dbo.[Заказы поставщикам].Предварительная_дата, dbo.[Заказы поставщикам].Точная_дата, dbo.Клиенты.VIP, dbo.Поисковая.[Номер запчасти], dbo.Поисковая.Брэнд, 
                      dbo.[Запросы клиентов].Заказали, dbo.[Запросы клиентов].Без_замен, dbo.[Запросы клиентов].Нет, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, 
                      dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Обработано, dbo.[Запросы клиентов].Дата_заказа, dbo.Поисковая.[Сокращенное название], 
                      dbo.[Запросы клиентов].ID_Клиента, dbo.[Запросы клиентов].Филиал, dbo.Поисковая.ID_аналога, dbo.[Заказы поставщикам].ID_Заказа, dbo.[Запросы клиентов].Дата, 
                      dbo.[Запросы клиентов].ID_Запчасти, dbo.Поисковая.Цена_обработана, dbo.[Запросы клиентов].Интернет, dbo.Поисковая.[Номер поставщика], dbo.Поисковая.Описание, 
                      dbo.[Запросы клиентов].Дата_прихода, dbo.[Запросы клиентов].Примечание
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.Поисковая ON dbo.[Запросы клиентов].ID_Запчасти = dbo.Поисковая.ID_Запчасти LEFT OUTER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
GO
/****** Object:  View [dbo].[Хиты_по_аналогу_5]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Хиты_по_аналогу_5]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога, SUM(dbo.Операции.Расход) AS Продано
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.Операции.Id_Клиента <> 378)
GROUP BY dbo.[Каталог запчастей].ID_аналога
HAVING      (SUM(dbo.Операции.Расход) > 2)
GO
/****** Object:  View [dbo].[Товар_от_поставщика_4н_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_4н_1]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (DATEDIFF(day, Дата, GETDATE()) < 28) AND (DATEDIFF(day, Дата, GETDATE()) > 21) AND (Счет_кредита = 22)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Хиты_по_аналогу_6]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_6]
AS
SELECT     dbo.Хиты_по_аналогу_5.ID_аналога, dbo.Хиты_по_аналогу_5.Продано
FROM         dbo.Хиты_по_аналогу_3 INNER JOIN
                      dbo.Хиты_по_аналогу_5 ON dbo.Хиты_по_аналогу_3.ID_аналога = dbo.Хиты_по_аналогу_5.ID_аналога

GO
/****** Object:  View [dbo].[Хиты_по_аналогу_7]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_7]
AS
SELECT     dbo.Хиты_по_аналогу_6.ID_аналога, dbo.Хиты_по_аналогу_6.Продано
FROM         dbo.Хиты_по_аналогу_6 LEFT OUTER JOIN
                      dbo.Хиты_по_аналогу_4 ON dbo.Хиты_по_аналогу_6.ID_аналога = dbo.Хиты_по_аналогу_4.ID_аналога
WHERE     (dbo.Хиты_по_аналогу_4.ID_аналога IS NULL)

GO
/****** Object:  View [dbo].[Товар_от_поставщика_1н_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_1н_1]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (DATEDIFF(day, Дата, GETDATE()) < 7) AND (Счет_кредита = 22)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Подсказка_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Подсказка_1]
AS
SELECT     TOP 1 VIP
FROM         dbo.Клиенты
WHERE     (NOT (VIP LIKE 'z%'))
ORDER BY VIP DESC
GO
/****** Object:  View [dbo].[Хиты_по_аналогу_8]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_8]
AS
SELECT     dbo.Хиты_по_аналогу_7.ID_аналога, MAX(dbo.[Каталог запчастей].ID_Запчасти) AS ID_Запчасти
FROM         dbo.Хиты_по_аналогу_7 INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Хиты_по_аналогу_7.ID_аналога = dbo.[Каталог запчастей].ID_аналога
GROUP BY dbo.Хиты_по_аналогу_7.ID_аналога

GO
/****** Object:  View [dbo].[Товар_от_поставщика_1н]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_1н]
AS
SELECT        dbo.Товар_от_поставщика_1н_2.ID_Поставщика, ISNULL(dbo.Товар_от_поставщика_1н_2.uah, 0) - ISNULL(dbo.Товар_от_поставщика_1н_1.uah, 0) 
                         AS uah, ISNULL(dbo.Товар_от_поставщика_1н_2.eur, 0) - ISNULL(dbo.Товар_от_поставщика_1н_1.eur, 0) AS eur, 
                         ISNULL(dbo.Товар_от_поставщика_1н_2.usd, 0) - ISNULL(dbo.Товар_от_поставщика_1н_1.usd, 0) AS usd
FROM            dbo.Товар_от_поставщика_1н_1 RIGHT OUTER JOIN
                         dbo.Товар_от_поставщика_1н_2 ON dbo.Товар_от_поставщика_1н_1.ID_Поставщика = dbo.Товар_от_поставщика_1н_2.ID_Поставщика

GO
/****** Object:  Table [dbo].[Каталог_лог]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Каталог_лог](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Запчасти] [int] NULL,
	[Номер запчасти] [char](25) NULL,
	[Номер поставщика] [char](25) NULL,
	[ID_Поставщика] [int] NULL,
	[ID_Брэнда] [int] NULL,
	[NAME] [char](25) NULL,
	[ID_Автомобиля] [int] NULL,
	[ID_Группы товаров] [int] NULL,
	[Описание] [char](80) NULL,
	[ID_аналога] [int] NULL,
	[Скидка] [char](10) NULL,
	[Цена] [char](10) NULL,
	[Цена1] [char](10) NULL,
	[Цена2] [char](10) NULL,
	[Цена3] [char](10) NULL,
	[Цена4] [char](10) NULL,
	[Цена5] [char](10) NULL,
	[Цена6] [char](10) NULL,
	[Цена7] [char](10) NULL,
	[Цена8] [char](10) NULL,
	[Цена9] [char](10) NULL,
	[Цена10] [char](10) NULL,
	[Цена11] [char](10) NULL,
	[Цена12] [char](10) NULL,
	[Цена13] [char](10) NULL,
	[Цена14] [char](10) NULL,
	[Цена15] [char](10) NULL,
	[Цена16] [char](10) NULL,
	[Цена17] [char](10) NULL,
	[Нет_цены] [bit] NOT NULL,
	[Обработана] [bit] NOT NULL,
	[Срочно] [bit] NOT NULL,
	[Распродажа] [bit] NOT NULL,
	[Цена_обработана] [bit] NOT NULL,
	[Сотрудник] [char](70) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Статус] [char](10) NOT NULL,
	[Рекомендовано на склад] [int] NULL,
	[Рекомендовано по аналогу] [int] NULL,
 CONSTRAINT [PK_Каталог_лог] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Каталог_журнал]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Каталог_журнал]
AS
SELECT        TOP 100 PERCENT ID_Запчасти, [Номер запчасти], [Номер поставщика], ID_Поставщика, ID_Брэнда, NAME, ID_Автомобиля, [ID_Группы товаров], 
                         Описание, ID_аналога, Скидка, Цена, Цена1, Цена2, Цена3, Цена4, Цена5, Цена6, Цена7, Цена8, Цена9, Цена10, Цена11, Цена12, Цена13, Цена14, 
                         Цена15, Цена16, Цена17, [Рекомендовано на склад], [Рекомендовано по аналогу], Нет_цены, Обработана, Срочно, Распродажа, Цена_обработана, 
                         Сотрудник, Дата, Статус
FROM            dbo.Каталог_лог
ORDER BY ID

GO
/****** Object:  Table [dbo].[Сотрудники]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Сотрудники](
	[ID_Сотрудника] [int] IDENTITY(1,1) NOT NULL,
	[Имя] [char](10) NOT NULL,
	[Фамилия] [char](10) NOT NULL,
	[Пароль] [char](10) NOT NULL,
	[Действующий] [bit] NOT NULL,
	[Проводки] [bit] NOT NULL,
	[Касса] [bit] NOT NULL,
	[IsFop] [bit] NOT NULL,
 CONSTRAINT [PK_Сотрудники] PRIMARY KEY CLUSTERED 
(
	[ID_Сотрудника] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Предприниматели]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Предприниматели]
	AS SELECT ID_Сотрудника,  Имя, Фамилия  FROM dbo.Сотрудники WHERE (IsFop = 1)
GO
/****** Object:  View [dbo].[Хиты_по_аналогу_9]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу_9]
AS
SELECT     dbo.Хиты_по_аналогу_8.ID_Запчасти, dbo.Хиты_по_аналогу_7.Продано
FROM         dbo.Хиты_по_аналогу_7 INNER JOIN
                      dbo.Хиты_по_аналогу_8 ON dbo.Хиты_по_аналогу_7.ID_аналога = dbo.Хиты_по_аналогу_8.ID_аналога

GO
/****** Object:  View [dbo].[Подсказка_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Подсказка_2]
AS
SELECT CASE WHEN COUNT (*) > 1 THEN MAX (VIP) ELSE '0000' END AS VIP
  FROM dbo.Клиенты
 WHERE VIP LIKE 'z%'

/*
SELECT     TOP 1 VIP
FROM         dbo.Клиенты
WHERE     (VIP LIKE 'z%')
ORDER BY VIP DESC
*/
GO
/****** Object:  View [dbo].[Хиты_по_аналогу]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Хиты_по_аналогу]
AS
SELECT     TOP 100 PERCENT dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.Хиты_по_аналогу_9.Продано, dbo.[Каталог запчастей].Описание
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Хиты_по_аналогу_9 ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Хиты_по_аналогу_9.ID_Запчасти
ORDER BY dbo.Хиты_по_аналогу_9.Продано DESC

GO
/****** Object:  View [dbo].[Товар_от_поставщика_2н_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_2н_2]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 22) AND (DATEDIFF(day, Дата, GETDATE()) < 14) AND (DATEDIFF(day, Дата, GETDATE()) > 7)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Товар_от_поставщика_2н]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_2н]
AS
SELECT        dbo.Товар_от_поставщика_2н_2.ID_Поставщика, ISNULL(dbo.Товар_от_поставщика_2н_2.uah, 0) - ISNULL(dbo.Товар_от_поставщика_2н_1.uah, 0) 
                         AS uah, ISNULL(dbo.Товар_от_поставщика_2н_2.eur, 0) - ISNULL(dbo.Товар_от_поставщика_2н_1.eur, 0) AS eur, 
                         ISNULL(dbo.Товар_от_поставщика_2н_2.usd, 0) - ISNULL(dbo.Товар_от_поставщика_2н_1.usd, 0) AS usd
FROM            dbo.Товар_от_поставщика_2н_1 RIGHT OUTER JOIN
                         dbo.Товар_от_поставщика_2н_2 ON dbo.Товар_от_поставщика_2н_1.ID_Поставщика = dbo.Товар_от_поставщика_2н_2.ID_Поставщика

GO
/****** Object:  Table [dbo].[Ошибки_каталога]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ошибки_каталога](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Номер_запчасти] [char](25) NOT NULL,
	[NAME] [char](25) NOT NULL,
	[ID_Запчасти] [int] NOT NULL,
 CONSTRAINT [PK_Ошибки_каталога] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Ошибки каталога]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Ошибки каталога]
AS
SELECT     dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.Ошибки_каталога.Номер_запчасти, dbo.Ошибки_каталога.NAME
FROM         dbo.Ошибки_каталога INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Ошибки_каталога.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика

GO
/****** Object:  View [dbo].[_RED_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_RED_2]
AS
SELECT     dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].[Номер поставщика], dbo.[Каталог запчастей].ID_Поставщика, 
                      dbo.[Каталог запчастей].ID_Брэнда, dbo.[Каталог запчастей].NAME, dbo.[Каталог запчастей].ID_Автомобиля, dbo.[Каталог запчастей].[ID_Группы товаров], dbo.[Каталог запчастей].Описание,
                       dbo.[Каталог запчастей].ID_аналога, dbo.[Каталог запчастей].Скидка, dbo.[Каталог запчастей].Цена, dbo.[Каталог запчастей].Цена1, dbo.[Каталог запчастей].Цена2, 
                      dbo.[Каталог запчастей].Цена3, dbo.[Каталог запчастей].Цена4, dbo.[Каталог запчастей].Цена5, dbo.[Каталог запчастей].Цена6, dbo.[Каталог запчастей].Цена7, 
                      dbo.[Каталог запчастей].Цена8, dbo.[Каталог запчастей].Цена9, dbo.[Каталог запчастей].Цена10, dbo.[Каталог запчастей].Цена11, dbo.[Каталог запчастей].Цена12, 
                      dbo.[Каталог запчастей].Цена13, dbo.[Каталог запчастей].Цена14, dbo.[Каталог запчастей].Цена15, dbo.[Каталог запчастей].Цена16, dbo.[Каталог запчастей].Цена17, 
                      dbo.[Каталог запчастей].Нет_цены, dbo.[Каталог запчастей].Обработана, dbo.[Каталог запчастей].Срочно, dbo.[Каталог запчастей].Исполнитель, dbo.[Каталог запчастей].Дата, 
                      dbo.[Каталог запчастей].ID, dbo.[Каталог запчастей].Распродажа, dbo.[Каталог запчастей].Цена_обработана, dbo.[Каталог запчастей].[Рекомендовано на склад], 
                      dbo.[Каталог запчастей].[Рекомендовано по аналогу], dbo.[Каталог запчастей].Обработано_нац_10, dbo.[Каталог запчастей].[Спеццена поставщика грн], 
                      dbo.[Каталог запчастей].[Спеццена поставщика долл], dbo.[Каталог запчастей].[Спеццена поставщика евро], dbo.[Каталог запчастей].namepost, dbo.[Каталог запчастей].Контроль, 
                      dbo.[Каталог запчастей].[Remote Warehouse], dbo.Брэнды.Брэнд
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
WHERE     (dbo.[Каталог запчастей].Обработана = 0) AND (dbo.[Каталог запчастей].Срочно = 1)
GO
/****** Object:  View [dbo].[Товар_от_поставщика_3н_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_3н_2]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 22) AND (DATEDIFF(day, Дата, GETDATE()) < 21) AND (DATEDIFF(day, Дата, GETDATE()) > 14)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Каталоги_поставщиков]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Каталоги_поставщиков]
AS
SELECT     dbo.[Каталоги поставщиков].ID_Запчасти, dbo.[Каталоги поставщиков].Брэнд, dbo.[Каталоги поставщиков].[Номер запчасти], 
                      dbo.[Каталоги поставщиков].Name, dbo.[Каталоги поставщиков].Описание, dbo.[Каталоги поставщиков].ID_Поставщика, 
                      dbo.[Каталоги поставщиков].[Срок доставки], dbo.[Каталоги поставщиков].Цена1, dbo.[Каталоги поставщиков].Цена2, dbo.[Каталоги поставщиков].Цена3, 
                      dbo.[Каталоги поставщиков].Цена4, dbo.[Каталоги поставщиков].Цена5, dbo.[Каталоги поставщиков].Цена6, dbo.[Каталоги поставщиков].Цена7, 
                      dbo.[Каталоги поставщиков].Цена8, dbo.[Каталоги поставщиков].Цена9, dbo.[Каталоги поставщиков].Цена10, dbo.[Каталоги поставщиков].Цена11, 
                      dbo.[Каталоги поставщиков].Цена12, dbo.[Каталоги поставщиков].Цена13, dbo.[Каталоги поставщиков].Цена14, dbo.[Каталоги поставщиков].Цена15, 
                      dbo.[Каталоги поставщиков].Цена16, dbo.[Каталоги поставщиков].Цена17, dbo.[Каталоги поставщиков].Цена, dbo.[Каталоги поставщиков].Наличие, 
                      dbo.[Каталоги поставщиков].ID_Аналога, dbo.Поставщики.[Сокращенное название], dbo.[Каталоги поставщиков].Дата, dbo.Поставщики.[Не возвратный],
					  dbo.Поставщики.[Виден только менеджерам], dbo.Поставщики.IsEnsureDeliveryTerm, dbo.Поставщики.IsQualityGuaranteed
FROM         dbo.[Каталоги поставщиков] INNER JOIN
                      dbo.Поставщики ON dbo.[Каталоги поставщиков].ID_Поставщика = dbo.Поставщики.ID_Поставщика
GO
/****** Object:  View [dbo].[_RED_2_WITH_TA]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_RED_2_WITH_TA]
AS
SELECT DISTINCT 
                         dbo._RED_2.Брэнд AS BRAND_IN, dbo._RED_2.namepost AS NOMER_IN, FenixParts.dbo._RED_2.id_АНАЛОГА AS ANALOG_IN, AnalogsDB.dbo.CLEAR.BRAND AS BRAND_OUT, 
                         AnalogsDB.dbo.CLEAR.NOMER AS NOMER_OUT
FROM            dbo._RED_2 INNER JOIN
                         AnalogsDB.dbo.CLEAR ON dbo._RED_2.Брэнд = AnalogsDB.dbo.CLEAR.BRAND_ AND dbo._RED_2.namepost = AnalogsDB.dbo.CLEAR.NOMER_
GO
/****** Object:  View [dbo].[Товар_от_поставщика_3н]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_3н]
AS
SELECT        dbo.Товар_от_поставщика_3н_2.ID_Поставщика, ISNULL(dbo.Товар_от_поставщика_3н_2.uah, 0) - ISNULL(dbo.Товар_от_поставщика_3н_1.uah, 0) 
                         AS uah, ISNULL(dbo.Товар_от_поставщика_3н_2.eur, 0) - ISNULL(dbo.Товар_от_поставщика_3н_1.eur, 0) AS eur, 
                         ISNULL(dbo.Товар_от_поставщика_3н_2.usd, 0) - ISNULL(dbo.Товар_от_поставщика_3н_1.usd, 0) AS usd
FROM            dbo.Товар_от_поставщика_3н_1 RIGHT OUTER JOIN
                         dbo.Товар_от_поставщика_3н_2 ON dbo.Товар_от_поставщика_3н_1.ID_Поставщика = dbo.Товар_от_поставщика_3н_2.ID_Поставщика

GO
/****** Object:  View [dbo].[CAT_W_BR]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CAT_W_BR] AS
SELECT     [Каталог запчастей].*, Брэнды.Брэнд
FROM         Брэнды INNER JOIN
                      [Каталог запчастей] ON Брэнды.ID_Брэнда = [Каталог запчастей].ID_Брэнда
GO
/****** Object:  View [dbo].[Обработка заказов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Обработка заказов]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.Клиенты.VIP, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Запросы клиентов].Альтернатива, 
                      dbo.[Запросы клиентов].Заказано, dbo.[Запросы клиентов].Подтверждение, dbo.[Запросы клиентов].Заказали, dbo.[Запросы клиентов].Без_замен, 
                      dbo.[Запросы клиентов].Нет, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Примечание,
                      dbo.[Запросы клиентов].Обработано, dbo.[Запросы клиентов].Цена_прихода_грн, dbo.[Запросы клиентов].Цена_прихода_евро, 
                      dbo.[Запросы клиентов].Цена_прихода_долл, dbo.[Запросы клиентов].Дата_заказа, dbo.[Запросы клиентов].ID_Заказа, 
                      dbo.[Каталог запчастей].ID_Поставщика, dbo.[Запросы клиентов].Филиал, dbo.[Каталог запчастей].ID_Запчасти, dbo.Клиенты.ID_Клиента, 
                      dbo.[Запросы клиентов].Срочно, dbo.[Запросы клиентов].Дата, dbo.[Запросы клиентов].Интернет, dbo.[Запросы клиентов].Задерживается
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента
WHERE     (dbo.[Запросы клиентов].Заказано <> 0) AND (dbo.[Запросы клиентов].ID_Заказа IS NULL)
GO
/****** Object:  View [dbo].[Мало_замен_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Мало_замен_1]
AS
SELECT     COUNT(ID_Запчасти) AS Колво, ID_аналога, MAX(ID_Запчасти) AS Запчасть_ID
FROM         dbo.[Каталог запчастей]
GROUP BY ID_аналога
HAVING      (COUNT(ID_Запчасти) < 5)

GO
/****** Object:  View [dbo].[Товар_от_поставщика_4н_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_4н_2]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 22) AND (DATEDIFF(day, Дата, GETDATE()) < 28) AND (DATEDIFF(day, Дата, GETDATE()) > 21)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[RED_2_READY_TO_UPD]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RED_2_READY_TO_UPD]
AS
SELECT DISTINCT 
                      dbo._RED_2_WITH_TA.BRAND_IN, dbo._RED_2_WITH_TA.NOMER_IN, dbo._RED_2_WITH_TA.ANALOG_IN, MAX(dbo._RED_2_WITH_TA.BRAND_OUT) AS BRAND_O, 
                      MAX(dbo._RED_2_WITH_TA.NOMER_OUT) AS NOMER_O, MIN(dbo.CAT_W_BR.ID_аналога) AS ANALOG_OUT
FROM         dbo._RED_2_WITH_TA INNER JOIN
                      dbo.CAT_W_BR ON dbo._RED_2_WITH_TA.NOMER_OUT = dbo.CAT_W_BR.namepost AND dbo._RED_2_WITH_TA.BRAND_OUT = dbo.CAT_W_BR.Брэнд
WHERE     (dbo.CAT_W_BR.Обработана = 1)
GROUP BY dbo._RED_2_WITH_TA.BRAND_IN, dbo._RED_2_WITH_TA.NOMER_IN, dbo._RED_2_WITH_TA.ANALOG_IN
GO
/****** Object:  View [dbo].[Мало_замен]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Мало_замен]
AS
SELECT     dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Поставщики.[Сокращенное название], dbo.Мало_замен_1.Колво
FROM         dbo.Брэнды INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда INNER JOIN
                      dbo.Мало_замен_1 ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Мало_замен_1.Запчасть_ID INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика

GO
/****** Object:  View [dbo].[Анализ продаж_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ продаж_1]
AS
SELECT     TOP (100) PERCENT dbo.[Подчиненная накладные].ID, dbo.[Подчиненная накладные].ID_Накладной, dbo.Клиенты.VIP, dbo.[Подчиненная накладные].ID_Клиента, 
                      dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Подчиненная накладные].Цена AS Евро, dbo.[Подчиненная накладные].Грн, 
                      dbo.[Подчиненная накладные].Количество, dbo.[Запросы клиентов].Дата AS [Дата заказа], dbo.[Подчиненная накладные].Дата_закрытия, dbo.[Подчиненная накладные].ID_Запчасти, 
                      dbo.[Каталог запчастей].[Рекомендовано на склад], dbo.[Каталог запчастей].[Рекомендовано по аналогу], dbo.[Каталог запчастей].ID_аналога
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Клиенты ON dbo.[Подчиненная накладные].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Подчиненная накладные].ID_Клиента = dbo.[Запросы клиентов].ID_Клиента AND 
                      dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти AND dbo.[Подчиненная накладные].Заказ = dbo.[Запросы клиентов].ID_Заказа
WHERE     (dbo.[Подчиненная накладные].Обработано = 1) AND (dbo.Клиенты.VIP <> '0020') AND (dbo.[Подчиненная накладные].Анализ = 0) AND (dbo.[Запросы клиентов].Дата IS NULL)
ORDER BY dbo.[Подчиненная накладные].Дата_закрытия DESC
GO
/****** Object:  View [dbo].[Товар_от_поставщика_4н]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_4н]
AS
SELECT        dbo.Товар_от_поставщика_4н_2.ID_Поставщика, ISNULL(dbo.Товар_от_поставщика_4н_2.uah, 0) - ISNULL(dbo.Товар_от_поставщика_4н_1.uah, 0) 
                         AS uah, ISNULL(dbo.Товар_от_поставщика_4н_2.eur, 0) - ISNULL(dbo.Товар_от_поставщика_4н_1.eur, 0) AS eur, 
                         ISNULL(dbo.Товар_от_поставщика_4н_2.usd, 0) - ISNULL(dbo.Товар_от_поставщика_4н_1.usd, 0) AS usd
FROM            dbo.Товар_от_поставщика_4н_1 RIGHT OUTER JOIN
                         dbo.Товар_от_поставщика_4н_2 ON dbo.Товар_от_поставщика_4н_1.ID_Поставщика = dbo.Товар_от_поставщика_4н_2.ID_Поставщика

GO
/****** Object:  View [dbo].[_RED_2_TCD_IN_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_RED_2_TCD_IN_1]
AS
SELECT        ID_Запчасти, NAME, ID_Брэнда
FROM            dbo.[Каталог запчастей]
WHERE        (ID_ПОСТАВЩИКА = '2')
GROUP BY ID_Запчасти, NAME, ID_Брэнда
GO
/****** Object:  View [dbo].[Архив запчастей_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Архив запчастей_]
AS
SELECT     Цена, Количество, Дата_закрытия, ID_Запчасти
FROM         dbo.[Подчиненная накладные]
WHERE     (ID_Клиента <> 378)
GO
/****** Object:  View [dbo].[Долг_поставщику_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_1]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 29)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_2]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 31)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Долг_поставщику_3]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 29)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Товар_от_поставщика_30_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_30_1]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (DATEDIFF(day, Дата, GETDATE()) < 30) AND (Счет_кредита = 22)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Товар_от_поставщика_30_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика_30_2]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (DATEDIFF(day, Дата, GETDATE()) < 30) AND (Счет_дебета = 22)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Товар_от_поставщика_30]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Товар_от_поставщика_30]
AS
SELECT        dbo.Товар_от_поставщика_30_2.ID_Поставщика, ISNULL(dbo.Товар_от_поставщика_30_2.uah, 0) - ISNULL(dbo.Товар_от_поставщика_30_1.uah, 0) 
                         AS uah, ISNULL(dbo.Товар_от_поставщика_30_2.eur, 0) - ISNULL(dbo.Товар_от_поставщика_30_1.eur, 0) AS eur, 
                         ISNULL(dbo.Товар_от_поставщика_30_2.usd, 0) - ISNULL(dbo.Товар_от_поставщика_30_1.usd, 0) AS usd
FROM            dbo.Товар_от_поставщика_30_1 RIGHT OUTER JOIN
                         dbo.Товар_от_поставщика_30_2 ON dbo.Товар_от_поставщика_30_1.ID_Поставщика = dbo.Товар_от_поставщика_30_2.ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Долг_поставщику_4]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 31)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Товар_от_поставщика]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Товар_от_поставщика]
AS
SELECT        dbo.Поставщики.ID_Поставщика, dbo.Поставщики.[Сокращенное название], ISNULL(dbo.Долг_поставщику_3.uah, 0) 
                         - ISNULL(dbo.Долг_поставщику_1.uah, 0) AS uah_nal, ISNULL(dbo.Долг_поставщику_3.eur, 0) - ISNULL(dbo.Долг_поставщику_1.eur, 0) AS eur_nal, 
                         ISNULL(dbo.Долг_поставщику_3.usd, 0) - ISNULL(dbo.Долг_поставщику_1.usd, 0) AS usd_nal, ISNULL(dbo.Долг_поставщику_4.uah, 0) 
                         - ISNULL(dbo.Долг_поставщику_2.uah, 0) AS uah_bez, ISNULL(dbo.Долг_поставщику_4.eur, 0) - ISNULL(dbo.Долг_поставщику_2.eur, 0) AS eur_bez, 
                         ISNULL(dbo.Долг_поставщику_4.usd, 0) - ISNULL(dbo.Долг_поставщику_2.usd, 0) AS usd_bez, ISNULL(dbo.Товар_от_поставщика_1н.uah, 0) AS uah_1n, 
                         ISNULL(dbo.Товар_от_поставщика_1н.eur, 0) AS eur_1n, ISNULL(dbo.Товар_от_поставщика_1н.usd, 0) AS usd_1n, 
                         ISNULL(dbo.Товар_от_поставщика_2н.uah, 0) AS uah_2n, ISNULL(dbo.Товар_от_поставщика_2н.eur, 0) AS eur_2n, 
                         ISNULL(dbo.Товар_от_поставщика_2н.usd, 0) AS usd_2n, ISNULL(dbo.Товар_от_поставщика_3н.uah, 0) AS uah_3n, 
                         ISNULL(dbo.Товар_от_поставщика_3н.eur, 0) AS eur_3n, ISNULL(dbo.Товар_от_поставщика_3н.usd, 0) AS usd_3n, 
                         ISNULL(dbo.Товар_от_поставщика_4н.uah, 0) AS uah_4n, ISNULL(dbo.Товар_от_поставщика_4н.eur, 0) AS eur_4n, 
                         ISNULL(dbo.Товар_от_поставщика_4н.usd, 0) AS usd_4n, ISNULL(dbo.Товар_от_поставщика_30.uah, 0) AS uah_30, 
                         ISNULL(dbo.Товар_от_поставщика_30.eur, 0) AS eur_30, ISNULL(dbo.Товар_от_поставщика_30.usd, 0) AS usd_30
FROM            dbo.Поставщики LEFT OUTER JOIN
                         dbo.Долг_поставщику_2 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_2.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_4 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_4.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_3 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_3.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_1 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_1.ID_Поставщика LEFT OUTER JOIN
                         dbo.Товар_от_поставщика_3н ON dbo.Поставщики.ID_Поставщика = dbo.Товар_от_поставщика_3н.ID_Поставщика LEFT OUTER JOIN
                         dbo.Товар_от_поставщика_2н ON dbo.Поставщики.ID_Поставщика = dbo.Товар_от_поставщика_2н.ID_Поставщика LEFT OUTER JOIN
                         dbo.Товар_от_поставщика_1н ON dbo.Поставщики.ID_Поставщика = dbo.Товар_от_поставщика_1н.ID_Поставщика LEFT OUTER JOIN
                         dbo.Товар_от_поставщика_4н ON dbo.Поставщики.ID_Поставщика = dbo.Товар_от_поставщика_4н.ID_Поставщика LEFT OUTER JOIN
                         dbo.Товар_от_поставщика_30 ON dbo.Поставщики.ID_Поставщика = dbo.Товар_от_поставщика_30.ID_Поставщика

GO
/****** Object:  View [dbo].[_RED_2_TCD_IN_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_RED_2_TCD_IN_2]
AS
SELECT        dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].NAME, dbo.[Каталог запчастей].ID_Брэнда
FROM            dbo.[Каталог запчастей] INNER JOIN
                         dbo._RED_2_TCD_IN_1 ON dbo.[Каталог запчастей].ID_Брэнда = dbo._RED_2_TCD_IN_1.ID_Брэнда AND dbo.[Каталог запчастей].NAME = dbo._RED_2_TCD_IN_1.NAME
WHERE        (ID_ПОСТАВЩИКА <> '2')
GO
/****** Object:  View [dbo].[Сумма_возвратной_накладной]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Сумма_возвратной_накладной]
AS
SELECT     dbo.[Возвратные накладные].Номер, SUM(dbo.[Запросы клиентов].Цена_прихода_грн * dbo.[Возвратные накладные].Количество) AS grn, 
                      SUM(dbo.[Запросы клиентов].Цена_прихода_евро * dbo.[Возвратные накладные].Количество) AS eur, 
                      SUM(dbo.[Запросы клиентов].Цена_прихода_долл * dbo.[Возвратные накладные].Количество) AS usd
FROM         dbo.[Возвратные накладные] INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Возвратные накладные].ID_Запроса = dbo.[Запросы клиентов].ID_Запроса
GROUP BY dbo.[Возвратные накладные].Номер

GO
/****** Object:  View [dbo].[_RED_2_TCD_IN_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[_RED_2_TCD_IN_3]
AS
SELECT        dbo.[Каталог запчастей].ID_Запчасти
FROM            dbo._RED_2_TCD_IN_1 INNER JOIN
                         dbo.[Каталог запчастей] ON dbo._RED_2_TCD_IN_1.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                         dbo._RED_2_TCD_IN_2 ON dbo._RED_2_TCD_IN_1.NAME = dbo._RED_2_TCD_IN_2.NAME AND dbo._RED_2_TCD_IN_1.ID_Брэнда = dbo._RED_2_TCD_IN_2.ID_Брэнда
WHERE        (dbo.[Каталог запчастей].ID_Поставщика = 2)
GO
/****** Object:  View [dbo].[Цена последнего прихода_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Цена последнего прихода_1]
AS
SELECT     dbo.[Запросы клиентов].ID_Запчасти, MAX(dbo.[Запросы клиентов].Дата_накладной) AS Дата
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
WHERE     (dbo.[Заказы поставщикам].Обработано = 1)
GROUP BY dbo.[Запросы клиентов].ID_Запчасти

GO
/****** Object:  View [dbo].[Цена последнего прихода]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Цена последнего прихода]
AS
SELECT     dbo.[Цена последнего прихода_1].ID_Запчасти, MAX(dbo.[Запросы клиентов].Цена_прихода_грн) AS Грн, MAX(dbo.[Запросы клиентов].Цена_прихода_евро) 
                      AS Евро, MAX(dbo.[Запросы клиентов].Цена_прихода_долл) AS Долл
FROM         dbo.[Цена последнего прихода_1] INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Цена последнего прихода_1].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти AND 
                      dbo.[Цена последнего прихода_1].Дата = dbo.[Запросы клиентов].Дата_накладной
GROUP BY dbo.[Цена последнего прихода_1].ID_Запчасти

GO
/****** Object:  View [dbo].[Очередь на возврат]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Очередь на возврат]
AS
SELECT     ID_Запроса, SUM(Количество) AS [Количество возврата]
FROM         dbo.[Возвратные накладные]
WHERE     (Номер IS NULL)
GROUP BY ID_Запроса

GO
/****** Object:  View [dbo].[Новый заказ]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Новый заказ]
AS
SELECT CASE WHEN COUNT (*) = 0 THEN 0 ELSE MAX (ID_Заказа) END AS ID_Заказа
  FROM dbo.[Заказы поставщикам]
GO
/****** Object:  View [dbo].[Просроченые долги по периоду_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по периоду_1]
AS
SELECT        dbo.Поставщики.ID_Поставщика, dbo.[Запросы клиентов].Цена_прихода_грн * dbo.[Запросы клиентов].Доставлено AS Сумма_грн, 
                         dbo.[Запросы клиентов].Цена_прихода_евро * dbo.[Запросы клиентов].Доставлено AS Сумма_евро, 
                         dbo.[Запросы клиентов].Цена_прихода_долл * dbo.[Запросы клиентов].Доставлено AS Сумма_долл
FROM            dbo.Поставщики INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.Поставщики.ID_Поставщика = dbo.[Каталог запчастей].ID_Поставщика LEFT OUTER JOIN
                         dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти AND 
                         dbo.Поставщики.[Количество дней отсрочки] > DATEDIFF(day, dbo.[Запросы клиентов].Дата_накладной, GETDATE())
WHERE        (dbo.Поставщики.[Количество дней отсрочки] IS NOT NULL)
GO
/****** Object:  Table [dbo].[Напоминания]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Напоминания](
	[ID_Напоминания] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NOT NULL,
	[Перезвонить] [bit] NOT NULL,
	[Отправить] [bit] NOT NULL,
	[Примечание] [char](150) NULL,
	[Дата_записи] [datetime] NOT NULL,
	[Пароль_записи] [char](10) NOT NULL,
	[Прочитано] [bit] NOT NULL,
	[Дата_чтения] [datetime] NULL,
	[Пароль_чтения] [char](10) NULL,
	[Дата_исполнения] [datetime] NOT NULL,
 CONSTRAINT [PK_Напоминания] PRIMARY KEY CLUSTERED 
(
	[ID_Напоминания] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Напоминания_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Напоминания_]
AS
SELECT     dbo.Напоминания.ID_Клиента, dbo.Клиенты.VIP, dbo.Клиенты.Фамилия, dbo.Напоминания.Перезвонить, dbo.Напоминания.Отправить, 
                      dbo.Напоминания.Примечание, dbo.Напоминания.Дата_записи, dbo.Сотрудники.Имя, dbo.Напоминания.Прочитано, 
                      dbo.Напоминания.Дата_чтения, Сотрудники_1.Имя AS Имя_исполнителя, dbo.Напоминания.ID_Напоминания, 
                      dbo.Напоминания.Дата_исполнения
FROM         dbo.Напоминания INNER JOIN
                      dbo.Клиенты ON dbo.Напоминания.ID_Клиента = dbo.Клиенты.ID_Клиента LEFT OUTER JOIN
                      dbo.Сотрудники ON dbo.Напоминания.Пароль_записи = dbo.Сотрудники.Пароль LEFT OUTER JOIN
                      dbo.Сотрудники Сотрудники_1 ON dbo.Напоминания.Пароль_чтения = Сотрудники_1.Пароль

GO
/****** Object:  View [dbo].[Просроченые долги по периоду_2е]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Просроченые долги по периоду_2е]
AS
SELECT        ID_Поставщика, SUM(Сумма_евро) AS euro
FROM            dbo.[Просроченые долги по периоду_1]
WHERE        (Сумма_грн = 0) AND (Сумма_долл = 0)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Просроченые долги по периоду_2гд]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Просроченые долги по периоду_2гд]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_долл) AS usd
FROM            dbo.[Просроченые долги по периоду_1]
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Просроченые долги по периоду_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по периоду_2]
AS
SELECT        ISNULL(dbo.[Просроченые долги по периоду_2гд].ID_Поставщика, dbo.[Просроченые долги по периоду_2е].ID_Поставщика) AS ID_Поставщика, 
                         ISNULL(dbo.[Просроченые долги по периоду_2гд].uah, 0) AS UAH, ISNULL(dbo.[Просроченые долги по периоду_2гд].usd, 0) AS USD, 
                         ISNULL(dbo.[Просроченые долги по периоду_2е].euro, 0) AS EURO
FROM            dbo.[Просроченые долги по периоду_2гд] FULL OUTER JOIN
                         dbo.[Просроченые долги по периоду_2е] ON 
                         dbo.[Просроченые долги по периоду_2гд].ID_Поставщика = dbo.[Просроченые долги по периоду_2е].ID_Поставщика
GO
/****** Object:  View [dbo].[Unprocessed_Suppliers]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Unprocessed_Suppliers] AS
SELECT DISTINCT
       cat.ID_Поставщика,
       prov.[Сокращенное название]
  FROM [Запросы клиентов] AS req,
       [Каталог запчастей] AS cat,
       Поставщики AS prov
 WHERE     req.Обработано <> 1
       AND cat.ID_Запчасти = req.ID_Запчасти
       AND prov.ID_Поставщика = cat.ID_Поставщика
GO
/****** Object:  View [dbo].[Просроченые долги по периоду_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по периоду_3]
AS
SELECT        dbo.Поставщики.ID_Поставщика, dbo.[Запросы клиентов].Цена_прихода_грн * dbo.[Запросы клиентов].Доставлено AS Сумма_грн
FROM            dbo.Поставщики INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.Поставщики.ID_Поставщика = dbo.[Каталог запчастей].ID_Поставщика LEFT OUTER JOIN
                         dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти AND 
                         dbo.Поставщики.[Количество дней отсрочки] > DATEDIFF(day, dbo.[Запросы клиентов].Дата_накладной, GETDATE())
WHERE        (dbo.[Запросы клиентов].Безналичные = 1) AND (dbo.Поставщики.[Количество дней отсрочки] IS NOT NULL)
GO
/****** Object:  View [dbo].[Просроченые долги по периоду_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по периоду_4]
AS
SELECT     ID_Поставщика, SUM(Сумма_грн) AS Безнал
FROM         dbo.[Просроченые долги по периоду_3]
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_1_14]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_1_14]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 14)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_1_21]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_1_21]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 21)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_1_30]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_1_30]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 30)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_1_7]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_1_7]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 7)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_2_14]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_2_14]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 14)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_2_21]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_2_21]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 21)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_2_30]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_2_30]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 30)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_2_7]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_2_7]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_дебета = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 7)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_3_14]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_3_14]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 14)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_3_21]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_3_21]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 21)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_3_30]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_3_30]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 30)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_3_7]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_3_7]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 29) AND (DATEDIFF(day, Дата, GETDATE()) > 7)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_4_14]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_4_14]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 14)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_4_21]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_4_21]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 21)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_4_30]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_4_30]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 30)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику_50_4_7]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Долг_поставщику_50_4_7]
AS
SELECT        ID_Поставщика, SUM(Сумма_грн) AS uah, SUM(Сумма_евро) AS eur, SUM(Сумма_долл) AS usd
FROM            dbo.Проводки
WHERE        (Счет_кредита = 31) AND (DATEDIFF(day, Дата, GETDATE()) > 7)
GROUP BY ID_Поставщика

GO
/****** Object:  View [dbo].[Долг_поставщику]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Долг_поставщику]
AS
SELECT        ISNULL(dbo.Долг_поставщику_3.uah, 0) - ISNULL(dbo.Долг_поставщику_1.uah, 0) AS uah_nal, ISNULL(dbo.Долг_поставщику_3.eur, 0) 
                         - ISNULL(dbo.Долг_поставщику_1.eur, 0) AS eur_nal, ISNULL(dbo.Долг_поставщику_3.usd, 0) - ISNULL(dbo.Долг_поставщику_1.usd, 0) AS usd_nal, 
                         ISNULL(dbo.Долг_поставщику_4.uah, 0) - ISNULL(dbo.Долг_поставщику_2.uah, 0) AS uah_bez, ISNULL(dbo.Долг_поставщику_4.eur, 0) 
                         - ISNULL(dbo.Долг_поставщику_2.eur, 0) AS eur_bez, ISNULL(dbo.Долг_поставщику_4.usd, 0) - ISNULL(dbo.Долг_поставщику_2.usd, 0) AS usd_bez, 
                         ISNULL(dbo.Долг_поставщику_50_3_7.uah, 0) - ISNULL(dbo.Долг_поставщику_50_1_7.uah, 0) + ISNULL(dbo.Долг_поставщику_50_4_7.uah, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_2_7.uah, 0) AS uah_7, ISNULL(dbo.Долг_поставщику_50_3_14.uah, 0) - ISNULL(dbo.Долг_поставщику_50_1_14.uah, 
                         0) + ISNULL(dbo.Долг_поставщику_50_4_14.uah, 0) - ISNULL(dbo.Долг_поставщику_50_2_14.uah, 0) AS uah_14, 
                         ISNULL(dbo.Долг_поставщику_50_3_21.uah, 0) - ISNULL(dbo.Долг_поставщику_50_1_21.uah, 0) + ISNULL(dbo.Долг_поставщику_50_4_21.uah, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_2_21.uah, 0) AS uah_21, ISNULL(dbo.Долг_поставщику_50_3_30.uah, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_1_30.uah, 0) + ISNULL(dbo.Долг_поставщику_50_4_30.uah, 0) - ISNULL(dbo.Долг_поставщику_50_2_30.uah, 0) 
                         AS uah_30, ISNULL(dbo.Долг_поставщику_50_3_7.eur, 0) - ISNULL(dbo.Долг_поставщику_50_1_7.eur, 0) + ISNULL(dbo.Долг_поставщику_50_4_7.eur, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_2_7.eur, 0) AS eur_7, ISNULL(dbo.Долг_поставщику_50_3_14.eur, 0) - ISNULL(dbo.Долг_поставщику_50_1_14.eur, 0) 
                         + ISNULL(dbo.Долг_поставщику_50_4_14.eur, 0) - ISNULL(dbo.Долг_поставщику_50_2_14.eur, 0) AS eur_14, ISNULL(dbo.Долг_поставщику_50_3_21.eur,
                          0) - ISNULL(dbo.Долг_поставщику_50_1_21.eur, 0) + ISNULL(dbo.Долг_поставщику_50_4_21.eur, 0) - ISNULL(dbo.Долг_поставщику_50_2_21.eur, 0) 
                         AS eur_21, ISNULL(dbo.Долг_поставщику_50_3_30.eur, 0) - ISNULL(dbo.Долг_поставщику_50_1_30.eur, 0) + ISNULL(dbo.Долг_поставщику_50_4_30.eur,
                          0) - ISNULL(dbo.Долг_поставщику_50_2_30.eur, 0) AS eur_30, ISNULL(dbo.Долг_поставщику_50_3_7.usd, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_1_7.usd, 0) + ISNULL(dbo.Долг_поставщику_50_4_7.usd, 0) - ISNULL(dbo.Долг_поставщику_50_2_7.usd, 0) 
                         AS usd_7, ISNULL(dbo.Долг_поставщику_50_3_14.usd, 0) - ISNULL(dbo.Долг_поставщику_50_1_14.usd, 0) 
                         + ISNULL(dbo.Долг_поставщику_50_4_14.usd, 0) - ISNULL(dbo.Долг_поставщику_50_2_14.usd, 0) AS usd_14, 
                         ISNULL(dbo.Долг_поставщику_50_3_21.usd, 0) - ISNULL(dbo.Долг_поставщику_50_1_21.usd, 0) + ISNULL(dbo.Долг_поставщику_50_4_21.usd, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_2_21.usd, 0) AS usd_21, ISNULL(dbo.Долг_поставщику_50_3_30.usd, 0) 
                         - ISNULL(dbo.Долг_поставщику_50_1_30.usd, 0) + ISNULL(dbo.Долг_поставщику_50_4_30.usd, 0) - ISNULL(dbo.Долг_поставщику_50_2_30.usd, 0) 
                         AS usd_30, ISNULL(dbo.Товар_от_поставщика_30.uah, 0) AS Товар_uah, ISNULL(dbo.Товар_от_поставщика_30.eur, 0) AS Товар_eur, 
                         ISNULL(dbo.Товар_от_поставщика_30.usd, 0) AS Товар_usd, dbo.Поставщики.ID_Поставщика, dbo.Поставщики.[Сокращенное название], 
                         dbo.Поставщики.Название, dbo.Поставщики.[Общее название]
FROM            dbo.Долг_поставщику_50_4_30 RIGHT OUTER JOIN
                         dbo.Товар_от_поставщика_30 RIGHT OUTER JOIN
                         dbo.Поставщики ON dbo.Товар_от_поставщика_30.ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_3_30 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_3_30.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_1_30 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_1_30.ID_Поставщика ON 
                         dbo.Долг_поставщику_50_4_30.ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_2_30 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_2_30.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_4_21 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_4_21.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_1_21 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_1_21.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_2_21 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_2_21.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_3_21 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_3_21.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_1_14 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_1_14.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_2_14 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_2_14.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_3_14 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_3_14.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_4_14 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_4_14.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_4_7 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_4_7.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_2_7 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_2_7.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_3_7 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_3_7.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_3 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_3.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_4 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_4.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_2 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_2.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_1 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_1.ID_Поставщика LEFT OUTER JOIN
                         dbo.Долг_поставщику_50_1_7 ON dbo.Поставщики.ID_Поставщика = dbo.Долг_поставщику_50_1_7.ID_Поставщика

GO
/****** Object:  View [dbo].[Просроченые долги по периоду_0]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по периоду_0]
AS
SELECT     dbo.[Просроченые долги по периоду_2].ID_Поставщика, dbo.Долг_поставщику.uah_nal - dbo.[Просроченые долги по периоду_2].UAH AS грн, 
                      dbo.Долг_поставщику.eur_nal - dbo.[Просроченые долги по периоду_2].EURO AS евро, 
                      dbo.Долг_поставщику.usd_nal - dbo.[Просроченые долги по периоду_2].USD AS долл
FROM         dbo.[Просроченые долги по периоду_2] LEFT OUTER JOIN
                      dbo.Долг_поставщику ON dbo.[Просроченые долги по периоду_2].ID_Поставщика = dbo.Долг_поставщику.ID_Поставщика
WHERE     (dbo.Долг_поставщику.uah_nal - dbo.[Просроченые долги по периоду_2].UAH > 0) OR
                      (dbo.Долг_поставщику.eur_nal - dbo.[Просроченые долги по периоду_2].EURO > 0) OR
                      (dbo.Долг_поставщику.usd_nal - dbo.[Просроченые долги по периоду_2].USD > 0)
GO
/****** Object:  View [dbo].[Просроченые долги по периоду_5]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Просроченые долги по периоду_5]
AS
SELECT     dbo.[Просроченые долги по периоду_4].ID_Поставщика, 
                      dbo.Долг_поставщику.uah_bez - dbo.[Просроченые долги по периоду_4].Безнал AS Безнал
FROM         dbo.[Просроченые долги по периоду_4] INNER JOIN
                      dbo.Долг_поставщику ON dbo.[Просроченые долги по периоду_4].ID_Поставщика = dbo.Долг_поставщику.ID_Поставщика
WHERE     (dbo.Долг_поставщику.uah_bez - dbo.[Просроченые долги по периоду_4].Безнал > 0)
GO
/****** Object:  View [dbo].[Заработок_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Заработок_1]
AS
SELECT     TOP 100 PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Операции.Расход, dbo.Операции.Дата AS [Дата продажи], 
                      dbo.Операции.Цена_закупки, dbo.Операции.Цена_продажи, dbo.Операции.Id_Запроса
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
WHERE     (dbo.Операции.Расход <> 0) AND (dbo.Операции.Цена_закупки <> 0) AND (dbo.Операции.Id_Клиента <> 396)
ORDER BY dbo.Операции.ID_Операции
GO
/****** Object:  View [dbo].[Просроченые долги по сумме]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по сумме]
AS
SELECT     dbo.Поставщики.ID_Поставщика, dbo.[Долг_поставщику].uah_nal - dbo.Поставщики.[Сумма отсрочки грн] AS uah, 
                      dbo.[Долг_поставщику].eur_nal - dbo.Поставщики.[Сумма отсрочки евро] AS euro, 
                      dbo.[Долг_поставщику].usd_nal - dbo.Поставщики.[Сумма отсрочки долл] AS usd, 
                      dbo.[Долг_поставщику].uah_bez - dbo.Поставщики.[Сумма отсрочки безнал] AS beznal
FROM         dbo.Поставщики INNER JOIN
                      dbo.[Долг_поставщику] ON dbo.Поставщики.ID_Поставщика = dbo.[Долг_поставщику].ID_Поставщика
WHERE     (dbo.[Долг_поставщику].uah_nal - dbo.Поставщики.[Сумма отсрочки грн] > 0) OR
                      (dbo.[Долг_поставщику].eur_nal - dbo.Поставщики.[Сумма отсрочки евро] > 0) OR
                      (dbo.[Долг_поставщику].usd_nal - dbo.Поставщики.[Сумма отсрочки долл] > 0) OR
                      (dbo.[Долг_поставщику].uah_bez - dbo.Поставщики.[Сумма отсрочки безнал] > 0)

GO
/****** Object:  View [dbo].[Заработок_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Заработок_2]
AS
SELECT     Id_Запроса, MIN(Дата_опер) AS [Дата_опер]
FROM         dbo.Операции
WHERE     (Приход > 0)
GROUP BY Id_Запроса

GO
/****** Object:  View [dbo].[Просроченые долги по периоду]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги по периоду]
AS
SELECT     ISNULL(dbo.[Просроченые долги по периоду_0].ID_Поставщика, dbo.[Просроченые долги по периоду_5].ID_Поставщика) AS [ID_Поставщика], 
                      dbo.[Просроченые долги по периоду_0].грн, dbo.[Просроченые долги по периоду_0].евро, dbo.[Просроченые долги по периоду_0].долл, 
                      dbo.[Просроченые долги по периоду_5].Безнал
FROM         dbo.[Просроченые долги по периоду_0] FULL OUTER JOIN
                      dbo.[Просроченые долги по периоду_5] ON dbo.[Просроченые долги по периоду_0].ID_Поставщика = dbo.[Просроченые долги по периоду_5].ID_Поставщика

GO
/****** Object:  View [dbo].[Зароботок]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Зароботок]
AS
SELECT     dbo.Заработок_1.Брэнд, dbo.Заработок_1.[Номер запчасти], dbo.Заработок_1.Расход AS Количество, 
                      dbo.Заработок_2.Дата_опер AS [Дата закупки], dbo.Заработок_1.[Дата продажи], dbo.Заработок_1.Цена_закупки, 
                      dbo.Заработок_1.Цена_продажи, (dbo.Заработок_1.Цена_продажи - dbo.Заработок_1.Цена_закупки) * dbo.Заработок_1.Расход AS Зароботок, 
                      dbo.Заработок_1.Цена_продажи * dbo.Заработок_1.Расход AS [Оборот продаж], 
                      dbo.Заработок_1.Цена_закупки * dbo.Заработок_1.Расход AS [Оборот закупок]
FROM         dbo.Заработок_1 LEFT OUTER JOIN
                      dbo.Заработок_2 ON dbo.Заработок_1.Id_Запроса = dbo.Заработок_2.Id_Запроса
GO
/****** Object:  View [dbo].[Просроченые долги]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Просроченые долги]
AS
SELECT     TOP 100 PERCENT ISNULL(dbo.[Просроченые долги по периоду].ID_Поставщика, dbo.[Просроченые долги по сумме].ID_Поставщика) AS Поставщик, 
                      dbo.[Просроченые долги по периоду].грн, dbo.[Просроченые долги по периоду].евро, dbo.[Просроченые долги по периоду].долл, 
                      dbo.[Просроченые долги по периоду].Безнал, dbo.[Просроченые долги по сумме].uah, dbo.[Просроченые долги по сумме].euro, 
                      dbo.[Просроченые долги по сумме].usd, dbo.[Просроченые долги по сумме].beznal
FROM         dbo.[Просроченые долги по периоду] FULL OUTER JOIN
                      dbo.[Просроченые долги по сумме] ON dbo.[Просроченые долги по периоду].ID_Поставщика = dbo.[Просроченые долги по сумме].ID_Поставщика
ORDER BY ISNULL(dbo.[Просроченые долги по периоду].ID_Поставщика, dbo.[Просроченые долги по сумме].ID_Поставщика)

GO
/****** Object:  Table [dbo].[Касса]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Касса](
	[ID_Касса] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NOT NULL,
	[Приход_долл] [decimal](9, 2) NOT NULL,
	[Приход_грн] [decimal](9, 2) NOT NULL,
	[Приход_евро] [decimal](9, 2) NOT NULL,
	[Расход_долл] [decimal](9, 2) NOT NULL,
	[Расход_грн] [decimal](9, 2) NOT NULL,
	[Расход_евро] [decimal](9, 2) NOT NULL,
	[Цена] [decimal](9, 2) NOT NULL,
	[Грн] [decimal](9, 2) NOT NULL,
	[Примечание] [char](60) NULL,
	[Обработано] [bit] NOT NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Пароль] [char](10) NOT NULL,
 CONSTRAINT [PK_Касса] PRIMARY KEY CLUSTERED 
(
	[ID_Касса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Касса_итог]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Касса_итог]
AS
SELECT     SUM(Цена) AS Еква, SUM(Приход_долл) - SUM(Расход_долл) AS DOLLAR, SUM(Приход_грн) - SUM(Расход_грн) AS UAH, SUM(Приход_евро) 
                      - SUM(Расход_евро) AS EURO
FROM         dbo.Касса

GO
/****** Object:  View [dbo].[Касса_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Касса_]
AS
SELECT     dbo.Клиенты.VIP, dbo.Клиенты.Фамилия, dbo.Касса.Приход_долл, dbo.Касса.Приход_грн, dbo.Касса.Приход_евро, dbo.Касса.Расход_долл, 
                      dbo.Касса.Расход_грн, dbo.Касса.Расход_евро, dbo.Касса.Цена, dbo.Касса.Грн, dbo.Касса.Примечание, dbo.Касса.Работник, 
                      dbo.Касса.Дата
FROM         dbo.Касса INNER JOIN
                      dbo.Клиенты ON dbo.Касса.ID_Клиента = dbo.Клиенты.ID_Клиента

GO
/****** Object:  View [dbo].[Заказы_на_клиентов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Заказы_на_клиентов]
AS
SELECT     SUM(dbo.[Подчиненная накладные].Количество) AS Expr1, AVG(dbo.[Подчиненная накладные].Цена) AS Expr2, dbo.[Каталог запчастей].ID_аналога
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Подчиненная накладные].Заказ = dbo.[Запросы клиентов].ID_Заказа AND 
                      dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти
WHERE     (DATEDIFF(day, dbo.[Подчиненная накладные].Дата_закрытия, GETDATE()) < 700) AND (dbo.[Запросы клиентов].ID_Клиента <> 378)
GROUP BY dbo.[Каталог запчастей].ID_аналога

GO
/****** Object:  View [dbo].[Заработок_1_0]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Заработок_1_0]
AS
SELECT     TOP 100 PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Операции.Расход, dbo.Операции.Дата AS [Дата продажи], 
                      dbo.Операции.Цена_закупки, dbo.Операции.Цена_продажи, dbo.Операции.Id_Запроса
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
WHERE     (dbo.Операции.Расход <> 0) AND (dbo.Операции.Цена_закупки = 0)
ORDER BY dbo.Операции.ID_Операции

GO
/****** Object:  View [dbo].[Заказы_на_склад]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Заказы_на_склад]
AS
SELECT     SUM(dbo.[Подчиненная накладные].Количество) AS Expr1, AVG(dbo.[Подчиненная накладные].Цена) AS Expr2, dbo.[Каталог запчастей].ID_аналога
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Подчиненная накладные].Заказ = dbo.[Запросы клиентов].ID_Заказа AND 
                      dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти
WHERE     (DATEDIFF(day, dbo.[Подчиненная накладные].Дата_закрытия, GETDATE()) < 700) AND (dbo.[Запросы клиентов].ID_Клиента = 378)
GROUP BY dbo.[Каталог запчастей].ID_аналога

GO
/****** Object:  View [dbo].[Зароботок_0]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Зароботок_0]
AS
SELECT     dbo.[Заработок_1_0].Брэнд, dbo.[Заработок_1_0].[Номер запчасти], dbo.[Заработок_1_0].Расход AS Количество, 
                      dbo.[Заработок_2].Дата_опер AS [Дата закупки], dbo.[Заработок_1_0].[Дата продажи], dbo.[Заработок_1_0].Цена_закупки, 
                      dbo.[Заработок_1_0].Цена_продажи
FROM         dbo.[Заработок_1_0] LEFT OUTER JOIN
                      dbo.[Заработок_2] ON dbo.[Заработок_1_0].Id_Запроса = dbo.[Заработок_2].Id_Запроса

GO
/****** Object:  View [dbo].[Наценка_по_факту]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Наценка_по_факту]
AS
SELECT     dbo.Операции.ID_Запчасти, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.Поставщики.[Сокращенное название] AS Поставщик, dbo.Операции.Расход AS Количество, 
                      ROUND((dbo.Операции.Цена_продажи / dbo.Операции.Цена_закупки - 1) * 100, 2) AS Наценка, dbo.Операции.Цена_закупки, 
                      dbo.Операции.Цена_продажи, dbo.Клиенты.VIP, dbo.Клиенты.Фамилия, dbo.Операции.Дата, dbo.Операции.Работник, 
                      dbo.Клиенты.ID_Клиента
FROM         dbo.Операции INNER JOIN
                      dbo.Клиенты ON dbo.Операции.Id_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
WHERE     (dbo.Операции.Расход > 0) AND (dbo.Операции.Цена_продажи <> 0) AND (dbo.Операции.Цена_закупки <> 0) AND 
                      (dbo.Операции.Цена_закупки <> 0.01) AND (dbo.Клиенты.ID_Клиента <> 378) AND (dbo.Клиенты.ID_Клиента <> 396) AND 
                      (dbo.Клиенты.ID_Клиента <> 535)
GO
/****** Object:  View [dbo].[В_заказе_по_аналогу_на_склад]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[В_заказе_по_аналогу_на_склад]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога, SUM(dbo.[Запросы клиентов].Заказано) AS Заказано_аналог
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.[Запросы клиентов].Заказано <> 0) AND (DATEDIFF(day, dbo.[Запросы клиентов].Дата, GETDATE()) < 31) AND (dbo.[Запросы клиентов].ID_Клиента = 378)
GROUP BY dbo.[Каталог запчастей].ID_аналога
GO
/****** Object:  View [dbo].[Время заказа]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Время заказа]
AS
SELECT     dbo.[Подчиненная накладные].ID, MAX(DISTINCT dbo.[Запросы клиентов].Дата) AS [Дата запроса], MAX(CAST(dbo.[Запросы клиентов].Интернет AS int)) 
                      AS Интернет
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа INNER JOIN
                      dbo.[Подчиненная накладные] ON dbo.[Заказы поставщикам].ID_Заказа = dbo.[Подчиненная накладные].Заказ AND 
                      dbo.[Запросы клиентов].ID_Запчасти = dbo.[Подчиненная накладные].ID_Запчасти AND 
                      dbo.[Запросы клиентов].ID_Клиента = dbo.[Подчиненная накладные].ID_Клиента
GROUP BY dbo.[Подчиненная накладные].ID

GO
/****** Object:  View [dbo].[Должок_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Должок_]
AS
SELECT     ID_Клиента, ID_Запчасти, Количество, Цена, Грн, Обработано, Нету, Количество * Цена AS Expr1, Количество * Грн AS Expr2
FROM         dbo.[Подчиненная накладные]
WHERE     (Нету = 0) AND (Обработано = 1)
GO
/****** Object:  View [dbo].[Остаток_по_аналогу]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Остаток_по_аналогу]
AS
SELECT        dbo.[Каталог запчастей].ID_аналога, SUM(dbo.Операции.Приход) - SUM(dbo.Операции.Расход) AS Остаток
FROM            dbo.[Каталог запчастей] INNER JOIN
                         dbo.Операции ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Операции.ID_Запчасти
WHERE        (dbo.Операции.Расход >= 0)
GROUP BY dbo.[Каталог запчастей].ID_аналога

GO
/****** Object:  View [dbo].[Анализ продаж аналог транзит_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[Анализ продаж аналог транзит_]
AS
SELECT     TOP (100) PERCENT dbo.Заказы_на_клиентов.ID_аналога, dbo.Заказы_на_клиентов.Expr2 AS Средняя_цена, dbo.Заказы_на_клиентов.Expr1 AS Продано, 
                      MAX(dbo.[Каталог запчастей].ID_Запчасти) AS ID_Запчасти
FROM         dbo.Заказы_на_клиентов INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Заказы_на_клиентов.ID_аналога = dbo.[Каталог запчастей].ID_аналога LEFT OUTER JOIN
                      dbo.Остаток_по_аналогу ON dbo.Заказы_на_клиентов.ID_аналога = dbo.Остаток_по_аналогу.ID_аналога LEFT OUTER JOIN
                      dbo.В_заказе_по_аналогу_на_склад ON dbo.Заказы_на_клиентов.ID_аналога = dbo.В_заказе_по_аналогу_на_склад.ID_аналога LEFT OUTER JOIN
                      dbo.Заказы_на_склад ON dbo.Заказы_на_клиентов.ID_аналога = dbo.Заказы_на_склад.ID_аналога
WHERE     (dbo.Заказы_на_склад.ID_аналога IS NULL) AND (dbo.В_заказе_по_аналогу_на_склад.ID_аналога IS NULL) AND (ISNULL(dbo.Остаток_по_аналогу.Остаток, 0) 
                      = 0)
GROUP BY dbo.Заказы_на_клиентов.ID_аналога, dbo.Заказы_на_клиентов.Expr2, dbo.Заказы_на_клиентов.Expr1

GO
/****** Object:  View [dbo].[Должок]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Должок]
AS
SELECT     ID_Клиента, SUM(Expr1) AS Евро, SUM(Expr2) AS Грн
FROM         dbo.Должок_
GROUP BY ID_Клиента
GO
/****** Object:  View [dbo].[Анализ продаж аналог транзит]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Анализ продаж аналог транзит]
AS
SELECT     dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Анализ продаж аналог транзит_].Средняя_цена, 
                      dbo.[Анализ продаж аналог транзит_].Продано
FROM         dbo.[Анализ продаж аналог транзит_] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Анализ продаж аналог транзит_].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика

GO
/****** Object:  View [dbo].[Накладные]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Накладные]
AS
SELECT     dbo.[Подчиненная накладные].ID, dbo.[Подчиненная накладные].ID_Накладной, dbo.Клиенты.VIP, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.Брэнды.Брэнд, dbo.[Подчиненная накладные].Количество, dbo.[Подчиненная накладные].Цена, dbo.[Подчиненная накладные].Грн, 
                      dbo.[Подчиненная накладные].Добавить, dbo.[Подчиненная накладные].Обработано, dbo.[Подчиненная накладные].ID_Клиента, 
                      dbo.[Подчиненная накладные].ID_Запчасти, dbo.[Каталог запчастей].Описание, dbo.[Подчиненная накладные].Нету, dbo.[Подчиненная накладные].Поставщик, 
                      dbo.[Подчиненная накладные].Заказ, dbo.[Подчиненная накладные].Дата_закрытия, dbo.[Подчиненная накладные].Статус, 
                      dbo.[Подчиненная накладные].Дата AS [Дата резерва], dbo.[Время заказа].[Дата запроса], dbo.[Каталог запчастей].Цена_обработана, 
                      dbo.[Время заказа].Интернет, dbo.[Каталог запчастей].[Номер поставщика], 
                      CASE WHEN dbo.[Каталог запчастей].[Remote Warehouse] = 1 THEN  '+' ELSE Null END AS RemoteWarehouse
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Клиенты ON dbo.[Подчиненная накладные].ID_Клиента = dbo.Клиенты.ID_Клиента LEFT OUTER JOIN
                      dbo.[Время заказа] ON dbo.[Подчиненная накладные].ID = dbo.[Время заказа].ID
GO
/****** Object:  View [dbo].[Проплачено]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Проплачено]
AS
SELECT     ID_Клиента, SUM(Цена) AS ПEвро, SUM(Грн) AS ПГрн
FROM         dbo.Касса
GROUP BY ID_Клиента
GO
/****** Object:  View [dbo].[Резерв_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Резерв_]
AS
SELECT     dbo.[Подчиненная накладные].ID_Запчасти, SUM(dbo.[Подчиненная накладные].Количество) AS Количество, 
                      dbo.[Подчиненная накладные].ID_Клиента
FROM         dbo.[Подчиненная накладные] LEFT OUTER JOIN
                      dbo.[Отгрузочные накладные] ON dbo.[Подчиненная накладные].ID_Накладной = dbo.[Отгрузочные накладные].ID_Накладной
WHERE     (dbo.[Подчиненная накладные].ID_Клиента <> 378) AND (dbo.[Подчиненная накладные].Обработано = 0)
GROUP BY dbo.[Подчиненная накладные].ID_Запчасти, dbo.[Подчиненная накладные].ID_Клиента
GO
/****** Object:  View [dbo].[Работа с поставщиками]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Работа с поставщиками]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].ID_Заказа, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Запросы клиентов].Цена_прихода_евро, 
                      dbo.[Запросы клиентов].Цена_прихода_долл, dbo.[Запросы клиентов].Цена_прихода_грн, dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Дата_накладной, 
                      dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Примечание, dbo.[Запросы клиентов].ID_Запчасти, dbo.[Каталог запчастей].ID_Поставщика, 
                      dbo.[Цена последнего прихода].Грн AS Последняя_грн, dbo.[Цена последнего прихода].Евро AS Последння_евро, dbo.[Цена последнего прихода].Долл AS Последняя_долл, 
                      dbo.[Каталог запчастей].[Спеццена поставщика грн], dbo.[Каталог запчастей].[Спеццена поставщика долл], dbo.[Каталог запчастей].[Спеццена поставщика евро], 
                      dbo.[Заказы поставщикам].Обработано, dbo.[Запросы клиентов].EntrepreneurId, YEAR(dbo.[Запросы клиентов].Дата_накладной) AS InvoiceYear, MONTH(dbo.[Запросы клиентов].Дата_накладной) AS InvoiceMonth,
					  DAY(dbo.[Запросы клиентов].Дата_накладной) AS InvoiceDay
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа LEFT OUTER JOIN
                      dbo.Предприниматели ON dbo.[Запросы клиентов].EntrepreneurId = dbo.Предприниматели.ID_Сотрудника LEFT OUTER JOIN
                      dbo.[Цена последнего прихода] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Цена последнего прихода].ID_Запчасти
WHERE     (dbo.[Запросы клиентов].Доставлено <> 0) AND (dbo.[Запросы клиентов].Обработано <> 0)
GO
/****** Object:  View [dbo].[Список поставщиков]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Список поставщиков]
AS
SELECT     distinct dbo.[Каталог запчастей].ID_Поставщика
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.[Запросы клиентов].Обработано <> 1)
--GROUP BY dbo.[Каталог запчастей].ID_Поставщика

GO
/****** Object:  View [dbo].[Обработка заказов_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Обработка заказов_1]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.Клиенты.VIP, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.[Запросы клиентов].Альтернатива, dbo.[Запросы клиентов].Заказано, dbo.[Запросы клиентов].Подтверждение, 
                      dbo.[Запросы клиентов].Заказали, dbo.[Запросы клиентов].Без_замен, dbo.[Запросы клиентов].Нет, dbo.[Запросы клиентов].Цена, 
                      dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Обработано, dbo.[Запросы клиентов].Примечание,
                      dbo.[Запросы клиентов].Цена_прихода_грн, dbo.[Запросы клиентов].Цена_прихода_евро, dbo.[Запросы клиентов].Цена_прихода_долл, 
                      dbo.[Запросы клиентов].Дата_заказа, dbo.[Запросы клиентов].ID_Заказа, dbo.[Каталог запчастей].ID_Поставщика, 
                      dbo.[Запросы клиентов].Филиал, dbo.[Каталог запчастей].ID_Запчасти, dbo.Клиенты.ID_Клиента, dbo.[Заказы поставщикам].Полученый, 
                      dbo.Поставщики.[Сокращенное название]
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа INNER JOIN
                      dbo.Поставщики ON dbo.[Заказы поставщикам].ID_Поставщика = dbo.Поставщики.ID_Поставщика
WHERE     (dbo.[Запросы клиентов].Заказано <> 0) AND (dbo.[Заказы поставщикам].Полученый = 0)
GO
/****** Object:  View [dbo].[Цена вход]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Цена вход]
AS
SELECT        dbo.Операции.ID_Запчасти, dbo.Операции.Приход, dbo.Операции.Расход, dbo.Операции.Цена_закупки, dbo.Операции.Дата, 
                         dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Дата_накладной
FROM            dbo.Операции LEFT OUTER JOIN
                         dbo.[Запросы клиентов] ON dbo.Операции.Id_Запроса = dbo.[Запросы клиентов].ID_Запроса AND 
                         dbo.Операции.ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти
WHERE        (dbo.Операции.Приход <> 0)

GO
/****** Object:  View [dbo].[Список поставщиков_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Список поставщиков_1]
AS
SELECT     ID_Поставщика
FROM         dbo.[Заказы поставщикам]
WHERE     (Обработано = 0) AND (Полученый = 1) AND (ID_Заказа <> 1)
GROUP BY ID_Поставщика
GO
/****** Object:  View [dbo].[Итог_накладной_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_1]
AS
SELECT     ID_Накладной, ID_Клиента, MAX(Дата_закрытия) AS Дата_закрытия
FROM         dbo.[Подчиненная накладные]
WHERE     (Количество >= 0)
GROUP BY ID_Накладной, ID_Клиента

GO
/****** Object:  View [dbo].[Анализ_поставщика_наценка_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ_поставщика_наценка_2]  AS 
SELECT     dbo.Операции.Расход, dbo.Операции.Id_Клиента, dbo.Операции.Цена_закупки, dbo.Операции.Цена_продажи, dbo.Операции.Дата_опер, dbo.[Каталог запчастей].ID_Поставщика, 
                      (dbo.Операции.Цена_продажи - dbo.Операции.Цена_закупки) / dbo.Операции.Цена_закупки * 100 AS Наценка
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.Операции.Id_Клиента <> 378) AND (dbo.Операции.Цена_закупки > 0) AND (dbo.Операции.Цена_продажи > 0)
GO
/****** Object:  View [dbo].[Новая запчасть]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Новая запчасть]
AS
SELECT     MAX(DISTINCT ID_Запчасти) AS Maxim
FROM         dbo.[Каталог запчастей]
GO
/****** Object:  View [dbo].[Итог_накладной_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_2]
AS
SELECT     dbo.Итог_накладной_1.ID_Накладной, dbo.Итог_накладной_1.ID_Клиента, MAX(Итог_накладной_1_1.Дата_закрытия) 
                      AS [Дата предыдущей], ISNULL(dbo.Итог_накладной_1.Дата_закрытия, GETDATE()) AS Дата_закрытия
FROM         dbo.Итог_накладной_1 LEFT OUTER JOIN
                      dbo.Итог_накладной_1 AS Итог_накладной_1_1 ON dbo.Итог_накладной_1.ID_Клиента = Итог_накладной_1_1.ID_Клиента AND 
                      ISNULL(dbo.Итог_накладной_1.Дата_закрытия, GETDATE()) > Итог_накладной_1_1.Дата_закрытия
GROUP BY dbo.Итог_накладной_1.Дата_закрытия, dbo.Итог_накладной_1.ID_Накладной, dbo.Итог_накладной_1.ID_Клиента

GO
/****** Object:  View [dbo].[Новая замена]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Новая замена]
AS
SELECT     MAX(DISTINCT ID_аналога) AS Maxim
FROM         dbo.[Каталог запчастей]
GO
/****** Object:  View [dbo].[Итог_накладной_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_3]
AS
SELECT     dbo.Итог_накладной_2.ID_Накладной, dbo.Касса.Цена, dbo.Касса.Грн
FROM         dbo.Итог_накладной_2 LEFT OUTER JOIN
                      dbo.Касса ON dbo.Итог_накладной_2.ID_Клиента = dbo.Касса.ID_Клиента AND dbo.Итог_накладной_2.Дата_закрытия > dbo.Касса.Дата AND 
                      dbo.Итог_накладной_2.[Дата предыдущей] < dbo.Касса.Дата

GO
/****** Object:  Table [dbo].[Тарифные модели]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Тарифные модели](
	[ID_Модели_тариф] [int] IDENTITY(1,1) NOT NULL,
	[Сокращенное_название] [char](20) NOT NULL,
	[Примечание] [char](150) NULL,
	[Столбец] [char](6) NOT NULL,
	[Скидка_V] [decimal](10, 9) NULL,
	[Скидка_M1] [decimal](10, 9) NULL,
	[Скидка_Si] [decimal](10, 9) NULL,
	[Скидка_Koni] [decimal](10, 9) NULL,
	[Скидка_Универсал] [decimal](10, 9) NULL,
 CONSTRAINT [PK_Тарифные модели] PRIMARY KEY CLUSTERED 
(
	[ID_Модели_тариф] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Клиент]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Клиент]
AS
SELECT     dbo.[Тарифные модели].Сокращенное_название AS Тариф_модел, dbo.[Тарифные модели].Столбец, dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, 
                      dbo.Клиенты.Фамилия, dbo.Клиенты.Имя, dbo.Клиенты.Отчество, dbo.Клиенты.Д_тел, dbo.Клиенты.Р_тел, dbo.Клиенты.Моб_тел, dbo.Клиенты.Факс, 
                      dbo.Клиенты.EMail, dbo.Клиенты.Город, dbo.Клиенты.Адрес, dbo.Клиенты.ID_Модели_тариф, dbo.Клиенты.Скидка, dbo.Клиенты.Нужен_прайс, 
                      dbo.Клиенты.Розничный_клиент, dbo.Клиенты.Расчет_в_евро, dbo.Клиенты.Мастерская, dbo.Клиенты.Опт, dbo.Клиенты.День_Рождения, 
                      dbo.Клиенты.Блокировка_продаж, dbo.Клиенты.Мерцание, dbo.Клиенты.Примечание, dbo.Клиенты.Работник, dbo.Клиенты.Дата, dbo.Клиенты.Пароль, 
                      dbo.Клиенты.pass, dbo.Клиенты.Интернет_заказы
FROM         dbo.[Тарифные модели] INNER JOIN
                      dbo.Клиенты ON dbo.[Тарифные модели].ID_Модели_тариф = dbo.Клиенты.ID_Модели_тариф
GO
/****** Object:  View [dbo].[Итог_накладной_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_4]
AS
SELECT     ID_Накладной, ID_Клиента, Дата_закрытия, Цена * Количество AS Сумма_евро, Грн * Количество AS Сумма_грн
FROM         dbo.[Подчиненная накладные]
WHERE     (Обработано = 1) AND (Количество < 0)

GO
/****** Object:  View [dbo].[Заказы]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Заказы]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].Альтернатива, dbo.[Запросы клиентов].Заказано, 
                      dbo.[Запросы клиентов].Подтверждение, dbo.[Заказы поставщикам].Предварительная_дата, dbo.[Заказы поставщикам].Точная_дата, 
                      dbo.Клиенты.VIP, dbo.Поисковая.[Номер запчасти], dbo.Поисковая.Брэнд, dbo.[Запросы клиентов].Заказали, dbo.[Запросы клиентов].Без_замен, 
                      dbo.[Запросы клиентов].Нет, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Доставлено, 
                      dbo.[Запросы клиентов].Обработано, dbo.[Запросы клиентов].Дата_заказа, dbo.Поисковая.[Сокращенное название], 
                      dbo.[Запросы клиентов].ID_Клиента, dbo.[Запросы клиентов].Филиал
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.Поисковая ON dbo.[Запросы клиентов].ID_Запчасти = dbo.Поисковая.ID_Запчасти
GO
/****** Object:  View [dbo].[Итог_накладной_5]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_5]
AS
SELECT     dbo.Итог_накладной_2.ID_Накладной, dbo.Итог_накладной_4.Сумма_евро, dbo.Итог_накладной_4.Сумма_грн
FROM         dbo.Итог_накладной_4 RIGHT OUTER JOIN
                      dbo.Итог_накладной_2 ON dbo.Итог_накладной_4.ID_Клиента = dbo.Итог_накладной_2.ID_Клиента AND 
                      dbo.Итог_накладной_4.Дата_закрытия < dbo.Итог_накладной_2.Дата_закрытия AND 
                      dbo.Итог_накладной_4.Дата_закрытия > dbo.Итог_накладной_2.[Дата предыдущей]

GO
/****** Object:  View [dbo].[Итог_накладной_6]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_6]
AS
SELECT     dbo.Итог_накладной_2.ID_Накладной, dbo.[Подчиненная накладные].Количество * dbo.[Подчиненная накладные].Цена AS Сумма_евро, 
                      dbo.[Подчиненная накладные].Количество * dbo.[Подчиненная накладные].Грн AS Сумма_грн
FROM         dbo.Итог_накладной_2 LEFT OUTER JOIN
                      dbo.[Подчиненная накладные] ON dbo.Итог_накладной_2.ID_Клиента = dbo.[Подчиненная накладные].ID_Клиента AND 
                      dbo.Итог_накладной_2.[Дата предыдущей] >= dbo.[Подчиненная накладные].Дата_закрытия
WHERE     (dbo.[Подчиненная накладные].Обработано = 1)

GO
/****** Object:  Table [dbo].[Курс валют]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Курс валют](
	[ID_Курса] [int] IDENTITY(1,1) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Доллар] [numeric](9, 2) NOT NULL,
	[Евро] [numeric](9, 2) NOT NULL,
	[Работник] [char](20) NOT NULL,
 CONSTRAINT [PK_Курс валют] PRIMARY KEY CLUSTERED 
(
	[ID_Курса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[LAST_CURR]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LAST_CURR] AS
SELECT     ID_Курса, Дата, Доллар AS USD, Евро AS EUR, CAST ((Евро / Доллар)  AS  NUMERIC (9,2) ) AS RATIO 
FROM         dbo.[Курс валют]
WHERE     (ID_Курса =
                          (SELECT     MAX(ID_Курса) AS Expr1
                            FROM          dbo.[Курс валют]))
GO
/****** Object:  View [dbo].[Итог_накладной_7]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_7]
AS
SELECT     dbo.Итог_накладной_2.ID_Накладной, ISNULL(dbo.Касса.Цена, 0) AS Сумма_евро, ISNULL(dbo.Касса.Грн, 0) AS Сумма_грн
FROM         dbo.Итог_накладной_2 LEFT OUTER JOIN
                      dbo.Касса ON dbo.Итог_накладной_2.ID_Клиента = dbo.Касса.ID_Клиента AND dbo.Итог_накладной_2.Дата_закрытия > dbo.Касса.Дата

GO
/****** Object:  View [dbo].[Просроченные долги клиентов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Просроченные долги клиентов]
	AS
SELECT dbo.Клиенты.VIP, dbo.Должок.Евро - ISNULL(dbo.Проплачено.ПEвро, 0) AS DebtEuro, 
						dbo.Должок.Грн - ISNULL(dbo.Проплачено.ПГрн, 0) AS DebtUah, 
						dbo.GetAmountOverdueDebt(dbo.Клиенты.ID_Клиента, - ISNULL(dbo.Клиенты.Количество_дней, 0)) AS OverdueDebt, 
						ISNULL(dbo.Клиенты.Количество_дней, 0) AS DaysQuantity
FROM   dbo.Должок INNER JOIN
						dbo.Клиенты ON dbo.Должок.ID_Клиента = dbo.Клиенты.ID_Клиента FULL OUTER JOIN
						dbo.Проплачено ON dbo.Должок.ID_Клиента = dbo.Проплачено.ID_Клиента
WHERE (dbo.Клиенты.Выводить_просрочку = 1)
GO
/****** Object:  View [dbo].[OVERDEBT_UAH_BY_MANAGER]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[OVERDEBT_UAH_BY_MANAGER]
AS
SELECT     dbo.[Просроченные долги клиентов].DebtUah AS [Общий долг], dbo.[Просроченные долги клиентов].OverdueDebt AS Просрочено, dbo.Клиенты.VIP, dbo.Клиенты.Факс AS Сотрудник
FROM         dbo.Клиенты INNER JOIN
                      dbo.[Просроченные долги клиентов] ON dbo.Клиенты.VIP = dbo.[Просроченные долги клиентов].VIP
WHERE     (dbo.[Просроченные долги клиентов].OverdueDebt > 0) AND (dbo.Клиенты.Расчет_в_евро = 0)
GO
/****** Object:  View [dbo].[Итог_накладной_возвраты]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_возвраты]
AS
SELECT     ID_Накладной, ISNULL(SUM(Сумма_евро), 0) AS Сумма_евро, ISNULL(SUM(Сумма_грн), 0) AS Сумма_грн
FROM         dbo.Итог_накладной_5
GROUP BY ID_Накладной

GO
/****** Object:  View [dbo].[Итог_накладной_оплаты]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_оплаты]
AS
SELECT     ID_Накладной, ISNULL(SUM(Сумма_евро), 0) AS Сумма_евро, ISNULL(SUM(Сумма_грн), 0) AS Сумма_грн
FROM         dbo.Итог_накладной_7
GROUP BY ID_Накладной

GO
/****** Object:  View [dbo].[Итог_накладной_отгружено]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_отгружено]
AS
SELECT     ID_Накладной, ISNULL(SUM(Сумма_евро), 0) AS Сумма_евро, ISNULL(SUM(Сумма_грн), 0) AS Сумма_грн
FROM         dbo.Итог_накладной_6
GROUP BY ID_Накладной

GO
/****** Object:  View [dbo].[Накладные поставщиков]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Накладные поставщиков]
AS
SELECT     TOP 100 PERCENT dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Дата_накладной, dbo.[Заказы поставщикам].ID_Поставщика, 
                      dbo.[Заказы поставщикам].Обработано, SUM(dbo.[Запросы клиентов].Цена_прихода_грн * dbo.[Запросы клиентов].Доставлено) AS Грн, 
                      SUM(dbo.[Запросы клиентов].Цена_прихода_евро * dbo.[Запросы клиентов].Доставлено) AS Евро, 
                      SUM(dbo.[Запросы клиентов].Цена_прихода_долл * dbo.[Запросы клиентов].Доставлено) AS Долл, dbo.[Заказы поставщикам].ID_Заказа, 
                      dbo.[Запросы клиентов].Безналичные
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
GROUP BY dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Дата_накладной, dbo.[Заказы поставщикам].ID_Поставщика, 
                      dbo.[Заказы поставщикам].Обработано, dbo.[Заказы поставщикам].ID_Заказа, dbo.[Запросы клиентов].Безналичные
ORDER BY dbo.[Запросы клиентов].Дата_накладной DESC

GO
/****** Object:  View [dbo].[Итог_накладной_проплаты]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Итог_накладной_проплаты]
AS
SELECT     ID_Накладной, ISNULL(SUM(Цена), 0) AS Евро, ISNULL(SUM(Грн), 0) AS Грн
FROM         dbo.Итог_накладной_3
GROUP BY ID_Накладной

GO
/****** Object:  View [dbo].[Кеш_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Кеш_1]
AS
SELECT     ID_Накладной, Количество, Цена, Обработано, Дата_закрытия, Цена * Количество AS сумма, ID_Клиента, Работник, 
                      Грн * Количество AS сумма_г
FROM         dbo.[Подчиненная накладные]
WHERE     (Обработано = 1) AND (ID_Накладной IS NOT NULL)
GO
/****** Object:  View [dbo].[Накладные поставщиков_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Накладные поставщиков_1]
AS
SELECT        dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Дата_накладной, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                         dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Цена_прихода_грн AS Грн, dbo.[Запросы клиентов].Цена_прихода_евро AS Евро, 
                         dbo.[Запросы клиентов].Цена_прихода_долл AS Долл, dbo.[Каталог запчастей].Описание, dbo.[Каталог запчастей].ID_Поставщика, 
                         dbo.[Запросы клиентов].Безналичные, dbo.[Запросы клиентов].ID_Запроса, SUM(dbo.[Возвратные накладные].Количество) AS Количество_возврата, 
                         dbo.[Каталог запчастей].ID_Запчасти
FROM            dbo.[Запросы клиентов] INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда LEFT OUTER JOIN
                         dbo.[Возвратные накладные] ON dbo.[Запросы клиентов].ID_Запроса = dbo.[Возвратные накладные].ID_Запроса
GROUP BY dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Дата_накладной, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                         dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Цена_прихода_грн, dbo.[Запросы клиентов].Цена_прихода_евро, 
                         dbo.[Запросы клиентов].Цена_прихода_долл, dbo.[Каталог запчастей].Описание, dbo.[Каталог запчастей].ID_Поставщика, 
                         dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].Безналичные, dbo.[Каталог запчастей].ID_Запчасти

GO
/****** Object:  View [dbo].[Накладные поставщиков_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Накладные поставщиков_2]
AS
SELECT        ID_Запчасти, Id_Запроса, SUM(Приход) - SUM(Расход) AS Остаток
FROM            dbo.Операции
WHERE        (Расход >= 0)
GROUP BY ID_Запчасти, Id_Запроса

GO
/****** Object:  View [dbo].[Накладные поставщиков_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Накладные поставщиков_]
AS
SELECT        dbo.[Накладные поставщиков_1].Номер_накладной, dbo.[Накладные поставщиков_1].Дата_накладной, dbo.[Накладные поставщиков_1].Брэнд, 
                         dbo.[Накладные поставщиков_1].[Номер запчасти], dbo.[Накладные поставщиков_1].Доставлено, dbo.[Накладные поставщиков_1].Грн, 
                         dbo.[Накладные поставщиков_1].Евро, dbo.[Накладные поставщиков_1].Долл, dbo.[Накладные поставщиков_1].Описание, 
                         dbo.[Накладные поставщиков_1].ID_Поставщика, dbo.[Накладные поставщиков_1].Безналичные, dbo.[Накладные поставщиков_1].ID_Запроса, 
                         dbo.[Накладные поставщиков_1].Количество_возврата, dbo.Резерв_1.Количество AS Резерв, dbo.[Накладные поставщиков_2].Остаток, 
                         ISNULL(dbo.Остаток_.Остаток, 0) - ISNULL(dbo.Резерв_1.Количество, 0) AS Доступно
FROM            dbo.[Накладные поставщиков_1] LEFT OUTER JOIN
                         dbo.Остаток_ ON dbo.[Накладные поставщиков_1].ID_Запчасти = dbo.Остаток_.ID_Запчасти LEFT OUTER JOIN
                         dbo.[Накладные поставщиков_2] ON dbo.[Накладные поставщиков_1].ID_Запчасти = dbo.[Накладные поставщиков_2].ID_Запчасти AND 
                         dbo.[Накладные поставщиков_1].ID_Запроса = dbo.[Накладные поставщиков_2].Id_Запроса LEFT OUTER JOIN
                         dbo.Резерв_1 ON dbo.[Накладные поставщиков_1].ID_Запчасти = dbo.Резерв_1.ID_Запчасти

GO
/****** Object:  View [dbo].[В_заказе]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[В_заказе]
AS
SELECT     ID_Запчасти, SUM(Заказано) AS Заказано
FROM         dbo.[Запросы клиентов]
WHERE     (DATEDIFF(day, Дата, GETDATE()) < 14) AND (Заказано <> 0)
GROUP BY ID_Запчасти
GO
/****** Object:  View [dbo].[В_заказе_по_аналогу]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[В_заказе_по_аналогу]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога, SUM(dbo.[Запросы клиентов].Заказано) AS Заказано_аналог
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.[Запросы клиентов].Заказано <> 0) AND (DATEDIFF(day, dbo.[Запросы клиентов].Дата, GETDATE()) < 31)
GROUP BY dbo.[Каталог запчастей].ID_аналога
GO
/****** Object:  View [dbo].[Анализ продаж_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Анализ продаж_2]
AS
SELECT        ID_Запчасти, SUM(Расход) AS Продано
FROM            dbo.Операции
WHERE        (DATEDIFF(day, Дата_опер, GETDATE()) <= 700)
GROUP BY ID_Запчасти
HAVING        (SUM(Расход) <> 0)

GO
/****** Object:  View [dbo].[Анализ продаж_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Анализ продаж_3]
AS
SELECT        dbo.[Каталог запчастей].ID_аналога, SUM(dbo.Операции.Расход) AS Продано
FROM            dbo.Операции INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE        (DATEDIFF(day, dbo.Операции.Дата_опер, GETDATE()) <= 700)
GROUP BY dbo.[Каталог запчастей].ID_аналога
HAVING        (SUM(dbo.Операции.Расход) <> 0)

GO
/****** Object:  View [dbo].[Анализ продаж]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ продаж]
AS
SELECT     dbo.[Подчиненная накладные].ID, dbo.[Подчиненная накладные].Анализ, dbo.[Анализ продаж_1].VIP, 
                      dbo.[Анализ продаж_1].[Сокращенное название], dbo.[Анализ продаж_1].Брэнд, dbo.[Анализ продаж_1].[Номер запчасти], 
                      dbo.[Анализ продаж_1].Евро, dbo.[Анализ продаж_1].Грн, dbo.[Анализ продаж_1].Количество, dbo.[Анализ продаж_1].Дата_закрытия, 
                      dbo.[Анализ продаж_1].ID_Запчасти, dbo.[Анализ продаж_1].[Рекомендовано на склад], dbo.[Анализ продаж_1].[Рекомендовано по аналогу], 
                      dbo.[Остаток_].Остаток, dbo.[Анализ продаж_2].Продано, dbo.[Анализ продаж_1].ID_аналога, 
                      dbo.[Остаток_по_аналогу].Остаток AS Остаток_аналог, dbo.[Анализ продаж_3].Продано AS Продано_аналог
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Анализ продаж_1] ON dbo.[Подчиненная накладные].ID = dbo.[Анализ продаж_1].ID LEFT OUTER JOIN
                      dbo.[В_заказе_по_аналогу] ON dbo.[Анализ продаж_1].ID_аналога = dbo.[В_заказе_по_аналогу].ID_аналога LEFT OUTER JOIN
                      dbo.[В_заказе] ON dbo.[Анализ продаж_1].ID_Запчасти = dbo.[В_заказе].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Анализ продаж_3] ON dbo.[Анализ продаж_1].ID_аналога = dbo.[Анализ продаж_3].ID_аналога LEFT OUTER JOIN
                      dbo.[Остаток_по_аналогу] ON dbo.[Анализ продаж_1].ID_аналога = dbo.[Остаток_по_аналогу].ID_аналога LEFT OUTER JOIN
                      dbo.[Анализ продаж_2] ON dbo.[Анализ продаж_1].ID_Запчасти = dbo.[Анализ продаж_2].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Остаток_] ON dbo.[Анализ продаж_1].ID_Запчасти = dbo.[Остаток_].ID_Запчасти
WHERE     (dbo.[Анализ продаж_1].[Рекомендовано на склад] > ISNULL(dbo.[Остаток_].Остаток, 0) + ISNULL(dbo.[В_заказе].Заказано, 0)) OR
                      (dbo.[Анализ продаж_1].[Рекомендовано на склад] IS NULL) AND (dbo.[Анализ продаж_1].[Рекомендовано по аналогу] IS NULL) OR
                      (dbo.[Анализ продаж_1].[Рекомендовано по аналогу] > ISNULL(dbo.[Остаток_по_аналогу].Остаток, 0) 
                      + ISNULL(dbo.[В_заказе_по_аналогу].Заказано_аналог, 0))
GO
/****** Object:  View [dbo].[Анализ продаж аналог_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ продаж аналог_1]
AS
SELECT     ID_аналога, MAX(Остаток_аналог) AS Остаток, MAX(Продано_аналог) AS Продано, MAX([Рекомендовано по аналогу]) AS Рекомендовано, 
                      MAX(Дата_закрытия) AS [Дата закрытия], MAX(ID_Запчасти) AS ID_Запчасти, SUM(Количество) AS Количество, AVG(Евро) AS [Средняя цена], 
                      Анализ
FROM         dbo.[Анализ продаж]
GROUP BY ID_аналога, Анализ
GO
/****** Object:  View [dbo].[Кеш_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Кеш_2]
AS
SELECT     TOP 100 PERCENT ID_Накладной, ID_Клиента, MAX(Дата_закрытия) AS Expr1, SUM(сумма) AS Сумма, SUM(сумма_г) AS Сумма_
FROM         dbo.Кеш_1
GROUP BY ID_Накладной, ID_Клиента
ORDER BY MAX(Дата_закрытия) DESC
GO
/****** Object:  View [dbo].[Анализ продаж аналог]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Объект:  View [dbo].[Анализ продаж аналог]    Дата сценария: 05/10/2008 12:17:20 ******/
CREATE VIEW [dbo].[Анализ продаж аналог]
AS
SELECT     dbo.[Анализ продаж аналог_1].ID_аналога, dbo.[Анализ продаж аналог_1].Остаток, dbo.[Анализ продаж аналог_1].Продано, dbo.[Анализ продаж аналог_1].Рекомендовано, 
                      dbo.[Анализ продаж аналог_1].[Дата закрытия], dbo.[Анализ продаж аналог_1].ID_Запчасти, dbo.[Анализ продаж аналог_1].Количество, dbo.[Анализ продаж аналог_1].[Средняя цена], 
                      dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Анализ продаж аналог_1].Анализ, dbo.[Каталог запчастей].Контроль, 
                      dbo.[Каталог запчастей].Описание
FROM         dbo.[Анализ продаж аналог_1] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Анализ продаж аналог_1].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
GO
/****** Object:  View [dbo].[Таблица_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица_1]
AS
SELECT     dbo.[Каталог запчастей].ID_Запчасти, Поставщики_1.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.[Каталог запчастей].NAME, dbo.Автомобили.Автомобиль, dbo.Группы.Группа, dbo.[Каталог запчастей].Описание, 
                      dbo.[Каталог запчастей].ID_аналога, dbo.[Каталог запчастей].Цена, dbo.[Каталог запчастей].Цена7
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Автомобили ON dbo.[Каталог запчастей].ID_Автомобиля = dbo.Автомобили.ID_Автомобиля INNER JOIN
                      dbo.Группы ON dbo.[Каталог запчастей].[ID_Группы товаров] = dbo.Группы.ID_Группы INNER JOIN
                      dbo.Поставщики AS Поставщики_1 ON dbo.[Каталог запчастей].ID_Поставщика = Поставщики_1.ID_Поставщика
GO
/****** Object:  View [dbo].[Таблица_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица_3]
AS
SELECT     ID_Запроса, ID_Запчасти, Заказано, Обработано, ID_Клиента
FROM         dbo.[Запросы клиентов]
WHERE     (Заказано <> 0) AND (Обработано <> 1) AND (ID_Клиента = 378)
GO
/****** Object:  View [dbo].[Таблица_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица_4]
AS
SELECT     ID_Запчасти, Количество
FROM         dbo.[Анализ продаж]
WHERE     (Количество > 0)
GO
/****** Object:  View [dbo].[Склад_остаток_0]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Склад_остаток_0]
AS
SELECT     ID_Операции, ID_Запчасти, Приход, Расход
FROM         dbo.Операции
WHERE     (Расход > 0) OR
                      (Расход = 0)

GO
/****** Object:  View [dbo].[Склад_остаток_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Склад_остаток_]
AS
SELECT     ID_Запчасти, SUM(Приход) - SUM(Расход) AS Остаток
FROM         dbo.[Склад_остаток_0]
GROUP BY ID_Запчасти
HAVING      (SUM(Приход) - SUM(Расход) <> 0)

GO
/****** Object:  View [dbo].[Таблица_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица_2]
AS
SELECT     dbo.Таблица_1.ID_Запчасти, dbo.Таблица_1.Брэнд, dbo.Таблица_1.[Номер запчасти], dbo.Таблица_1.NAME, dbo.Таблица_1.Автомобиль, 
                      dbo.Таблица_1.Группа, dbo.Таблица_1.Описание, dbo.Таблица_1.ID_аналога, dbo.Таблица_1.Цена, dbo.Таблица_1.Цена7, 
                      ISNULL(dbo.Склад_остаток_.Остаток, 0) AS Наличие_1, ISNULL(dbo.Таблица_3.Заказано, 0) AS Наличие_2, ISNULL(dbo.Таблица_4.Количество, 0) 
                      AS Наличие_3, dbo.Таблица_1.[Сокращенное название]
FROM         dbo.Таблица_4 RIGHT OUTER JOIN
                      dbo.Таблица_1 ON dbo.Таблица_4.ID_Запчасти = dbo.Таблица_1.ID_Запчасти LEFT OUTER JOIN
                      dbo.Таблица_3 ON dbo.Таблица_1.ID_Запчасти = dbo.Таблица_3.ID_Запчасти LEFT OUTER JOIN
                      dbo.Склад_остаток_ ON dbo.Таблица_1.ID_Запчасти = dbo.Склад_остаток_.ID_Запчасти
GO
/****** Object:  View [dbo].[Архив клиента]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Архив клиента]
AS
SELECT     dbo.[Подчиненная накладные].ID, dbo.[Подчиненная накладные].ID_Накладной, dbo.Клиенты.VIP, 
                      dbo.[Подчиненная накладные].ID_Клиента, dbo.Поставщики.[Сокращенное название] AS Поставщик, dbo.Брэнды.Брэнд, 
                      dbo.[Каталог запчастей].[Номер запчасти], dbo.[Подчиненная накладные].Цена AS Евро, dbo.[Подчиненная накладные].Грн, 
                      dbo.[Подчиненная накладные].Количество, dbo.[Подчиненная накладные].Статус, dbo.[Запросы клиентов].Дата AS [Дата заказа], 
                      dbo.[Подчиненная накладные].Дата_закрытия, dbo.[Подчиненная накладные].ID_Запчасти, dbo.[Подчиненная накладные].Оплачено, 
                      dbo.Сотрудники.Имя, dbo.[Каталог запчастей].Описание
FROM         dbo.[Подчиненная накладные] WITH(NOLOCK) INNER JOIN
                      dbo.[Каталог запчастей] WITH(NOLOCK) ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды WITH(NOLOCK) ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Клиенты WITH(NOLOCK)ON dbo.[Подчиненная накладные].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.Поставщики WITH(NOLOCK) ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.Сотрудники WITH(NOLOCK) ON dbo.[Подчиненная накладные].Пароль = dbo.Сотрудники.Пароль LEFT OUTER JOIN
                      dbo.[Запросы клиентов] WITH(NOLOCK) ON dbo.[Подчиненная накладные].ID_Клиента = dbo.[Запросы клиентов].ID_Клиента AND 
                      dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти AND 
                      dbo.[Подчиненная накладные].Заказ = dbo.[Запросы клиентов].ID_Заказа
WHERE     (dbo.[Подчиненная накладные].Обработано = 1) AND (dbo.[Подчиненная накладные].Нету = 0)
GO
/****** Object:  View [dbo].[Накладные_возврат]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Накладные_возврат]
AS
SELECT     TOP 100 PERCENT dbo.[Возвратные накладные].Номер, dbo.[Каталог запчастей].ID_Поставщика, dbo.[Возвратные накладные].Проводка, 
                      MAX(dbo.[Возвратные накладные].Дата) AS Дата
FROM         dbo.[Возвратные накладные] INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Возвратные накладные].ID_Запроса = dbo.[Запросы клиентов].ID_Запроса INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
GROUP BY dbo.[Возвратные накладные].Номер, dbo.[Каталог запчастей].ID_Поставщика, dbo.[Возвратные накладные].Проводка
HAVING      (NOT (dbo.[Возвратные накладные].Номер IS NULL))
ORDER BY MAX(dbo.[Возвратные накладные].Дата) DESC

GO
/****** Object:  View [dbo].[Таблица]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица]
AS
SELECT     ID_Запчасти, [Сокращенное название], Брэнд, [Номер запчасти], NAME, Автомобиль, Группа, Описание, ID_аналога, Цена, Цена7, Наличие_1, 
                      Наличие_2, Наличие_3, Наличие_1 + Наличие_2 + Наличие_3 AS Наличие
FROM         dbo.Таблица_2
GO
/****** Object:  View [dbo].[Накладные_возврат_подч_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Накладные_возврат_подч_]
AS
SELECT     TOP (100) PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Возвратные накладные].Количество, 
                      dbo.[Возвратные накладные].Дата, dbo.[Возвратные накладные].Номер, dbo.[Каталог запчастей].ID_Поставщика, dbo.[Возвратные накладные].ID_Накладной, 
                      dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].Цена_прихода_грн, dbo.[Запросы клиентов].Цена_прихода_евро, 
                      dbo.[Запросы клиентов].Цена_прихода_долл, dbo.[Каталог запчастей].ID_Запчасти, dbo.[Запросы клиентов].Номер_накладной, 
                      dbo.[Запросы клиентов].Дата_накладной, dbo.[Запросы клиентов].Возврат, dbo.[Накладные поставщиков_2].Остаток, ISNULL(dbo.Остаток_.Остаток, 0) 
                      - ISNULL(dbo.Резерв_1.Количество, 0) AS Доступно, dbo.[Запросы клиентов].Цена_прихода_евро * dbo.[Возвратные накладные].Количество AS Сумма_возвр, 
                      ISNULL(dbo.[Очередь на возврат].[Количество возврата], 0) AS Колво_возвр, dbo.[Каталог запчастей].[Номер поставщика]
FROM         dbo.Брэнды INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда INNER JOIN
                      dbo.[Возвратные накладные] INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Возвратные накладные].ID_Запроса = dbo.[Запросы клиентов].ID_Запроса ON 
                      dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Очередь на возврат] ON dbo.[Запросы клиентов].ID_Запроса = dbo.[Очередь на возврат].ID_Запроса LEFT OUTER JOIN
                      dbo.Остаток_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Остаток_.ID_Запчасти LEFT OUTER JOIN
                      dbo.Резерв_1 ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Резерв_1.ID_Запчасти LEFT OUTER JOIN
                      dbo.[Накладные поставщиков_2] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Накладные поставщиков_2].ID_Запчасти AND 
                      dbo.[Запросы клиентов].ID_Запроса = dbo.[Накладные поставщиков_2].Id_Запроса
ORDER BY dbo.[Возвратные накладные].Дата DESC
GO
/****** Object:  View [dbo].[Накладные_возврат_подч]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Накладные_возврат_подч]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.Накладные_возврат_подч_.Брэнд, dbo.Накладные_возврат_подч_.[Номер запчасти], 
                      dbo.Накладные_возврат_подч_.Количество, dbo.Накладные_возврат_подч_.Дата, dbo.Накладные_возврат_подч_.Номер, 
                      dbo.Накладные_возврат_подч_.ID_Поставщика, dbo.Накладные_возврат_подч_.ID_Накладной, dbo.Накладные_возврат_подч_.ID_Запроса AS Expr1, 
                      dbo.Накладные_возврат_подч_.Цена_прихода_грн, dbo.Накладные_возврат_подч_.Цена_прихода_евро, 
                      dbo.Накладные_возврат_подч_.Цена_прихода_долл, dbo.Накладные_возврат_подч_.ID_Запчасти, dbo.Накладные_возврат_подч_.Номер_накладной, 
                      dbo.Накладные_возврат_подч_.Дата_накладной, dbo.[Запросы клиентов].Возврат, dbo.Накладные_возврат_подч_.Остаток, 
                      dbo.Накладные_возврат_подч_.Доступно, dbo.Накладные_возврат_подч_.Сумма_возвр, dbo.Накладные_возврат_подч_.Колво_возвр, 
                      dbo.Накладные_возврат_подч_.[Номер поставщика]
FROM         dbo.Накладные_возврат_подч_ INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.Накладные_возврат_подч_.ID_Запроса = dbo.[Запросы клиентов].ID_Запроса

GO
/****** Object:  View [dbo].[Новая возвратная]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Новая возвратная]
AS
SELECT     TOP 1 ISNULL(Номер, 0) + 1 AS Номер
FROM         dbo.[Возвратные накладные]
ORDER BY Номер DESC

GO
/****** Object:  View [dbo].[Таблица цены]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица цены]
AS
SELECT     dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].[Номер поставщика], 
                      dbo.[Каталог запчастей].ID_Поставщика, dbo.[Каталог запчастей].ID_Брэнда, dbo.[Каталог запчастей].NAME, 
                      dbo.[Каталог запчастей].ID_Автомобиля, dbo.[Каталог запчастей].[ID_Группы товаров], dbo.[Каталог запчастей].Описание, 
                      dbo.[Каталог запчастей].ID_аналога, dbo.[Каталог запчастей].Скидка, dbo.[Каталог запчастей].Цена, dbo.[Каталог запчастей].Цена1, 
                      dbo.[Каталог запчастей].Цена2, dbo.[Каталог запчастей].Цена3, dbo.[Каталог запчастей].Цена4, dbo.[Каталог запчастей].Цена5, 
                      dbo.[Каталог запчастей].Цена6, dbo.[Каталог запчастей].Цена7, dbo.[Каталог запчастей].Цена8, dbo.[Каталог запчастей].Цена9, 
                      dbo.[Каталог запчастей].Цена10, dbo.[Каталог запчастей].Цена11, dbo.[Каталог запчастей].Цена12, dbo.[Каталог запчастей].Цена13, 
                      dbo.[Каталог запчастей].Цена14, dbo.[Каталог запчастей].Цена15, dbo.[Каталог запчастей].Цена16, dbo.[Каталог запчастей].Цена17, 
                      dbo.[Каталог запчастей].Нет_цены, dbo.[Каталог запчастей].Обработана, dbo.[Каталог запчастей].Срочно, dbo.[Каталог запчастей].Исполнитель, 
                      dbo.[Каталог запчастей].Дата, dbo.[Каталог запчастей].ID, dbo.[Каталог запчастей].Распродажа, dbo.Брэнды.Брэнд, 
                      dbo.Поставщики.[Сокращенное название], dbo.Автомобили.Автомобиль, dbo.Группы.Группа
FROM         dbo.Брэнды INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Автомобили ON dbo.[Каталог запчастей].ID_Автомобиля = dbo.Автомобили.ID_Автомобиля INNER JOIN
                      dbo.Группы ON dbo.[Каталог запчастей].[ID_Группы товаров] = dbo.Группы.ID_Группы
GO
/****** Object:  View [dbo].[Таблица_цены]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица_цены]
AS
SELECT     dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].[Номер поставщика], 
                      dbo.Брэнды.Брэнд, dbo.Поставщики.[Сокращенное название], dbo.[Каталог запчастей].NAME, dbo.[Каталог запчастей].ID_Автомобиля, 
                      dbo.[Каталог запчастей].[ID_Группы товаров], dbo.[Каталог запчастей].Описание, dbo.[Каталог запчастей].ID_аналога, 
                      dbo.[Каталог запчастей].Скидка, dbo.[Каталог запчастей].Цена, dbo.[Каталог запчастей].Цена1, dbo.[Каталог запчастей].Цена2, 
                      dbo.[Каталог запчастей].Цена3, dbo.[Каталог запчастей].Цена4, dbo.[Каталог запчастей].Цена5, dbo.[Каталог запчастей].Цена6, 
                      dbo.[Каталог запчастей].Цена7, dbo.[Каталог запчастей].Цена8, dbo.[Каталог запчастей].Цена9, dbo.[Каталог запчастей].Цена10, 
                      dbo.[Каталог запчастей].Цена11, dbo.[Каталог запчастей].Цена12, dbo.[Каталог запчастей].Цена13, dbo.[Каталог запчастей].Цена14, 
                      dbo.[Каталог запчастей].Цена15, dbo.[Каталог запчастей].Цена16, dbo.[Каталог запчастей].Цена17, dbo.[Каталог запчастей].Нет_цены, 
                      dbo.[Каталог запчастей].Обработана, dbo.[Каталог запчастей].Срочно, dbo.[Каталог запчастей].Исполнитель, dbo.[Каталог запчастей].Дата, 
                      dbo.[Каталог запчастей].ID, dbo.[Каталог запчастей].Распродажа, dbo.Группы.Группа
FROM         dbo.Брэнды INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Группы ON dbo.[Каталог запчастей].[ID_Группы товаров] = dbo.Группы.ID_Группы
GO
/****** Object:  View [dbo].[Долги]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Долги]
AS
SELECT     TOP 100 PERCENT dbo.Клиенты.VIP, dbo.Должок.Евро - ISNULL(dbo.Проплачено.ПEвро, 0) AS СУММА
FROM         dbo.Должок INNER JOIN
                      dbo.Клиенты ON dbo.Должок.ID_Клиента = dbo.Клиенты.ID_Клиента FULL OUTER JOIN
                      dbo.Проплачено ON dbo.Должок.ID_Клиента = dbo.Проплачено.ID_Клиента
WHERE     (dbo.Клиенты.VIP <> '0020') AND (dbo.Должок.Евро - ISNULL(dbo.Проплачено.ПEвро, 0) > 1) OR
                      (dbo.Должок.Евро - ISNULL(dbo.Проплачено.ПEвро, 0) < - 1)
ORDER BY dbo.Должок.Евро - ISNULL(dbo.Проплачено.ПEвро, 0) DESC

GO
/****** Object:  View [dbo].[Есть_Наличие_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Есть_Наличие_]
AS
SELECT     ID_Запчасти, Остаток
FROM         dbo.Остаток_
WHERE     (Остаток <> 0)

GO
/****** Object:  View [dbo].[Анализ неток_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ неток_1]
AS
SELECT     TOP 100 PERCENT dbo.[Запросы клиентов].ID_Запроса, dbo.Поставщики.[Сокращенное название] AS Поставщик, dbo.Брэнды.Брэнд, 
                      dbo.[Каталог запчастей].[Номер запчасти], dbo.[Запросы клиентов].Заказано, dbo.[Запросы клиентов].Заказали, 
                      dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Дата, dbo.[Запросы клиентов].Анализ, dbo.Клиенты.VIP
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента
WHERE     (dbo.[Запросы клиентов].Анализ = 0) AND (dbo.[Запросы клиентов].Нет = 1)
GO
/****** Object:  View [dbo].[Склад сумма_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Склад сумма_1]
AS
SELECT     ID_Запчасти, Приход, Расход, Цена_закупки, MONTH(Дата) AS Месяц, YEAR(Дата) AS Год
FROM         dbo.Операции
WHERE     (Расход > 0) AND (Цена_закупки <> 0) OR
                      (Расход = 0) AND (Цена_закупки <> 0)
GO
/****** Object:  View [dbo].[Склад сумма_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Склад сумма_2]
AS
SELECT     ID_Запчасти, Цена_закупки, SUM(Приход) AS Expr1, SUM(Расход) AS Expr2, SUM(Приход) - SUM(Расход) AS Expr3, (SUM(Приход) 
                      - SUM(Расход)) * Цена_закупки AS Expr4
FROM         dbo.[Склад сумма_1]
GROUP BY ID_Запчасти, Цена_закупки
HAVING      (SUM(Приход) - SUM(Расход) <> 0)

GO
/****** Object:  View [dbo].[НаценкаP]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[НаценкаP]
AS
SELECT     dbo.[Каталог запчастей].ID_Запчасти, dbo.Поставщики.[Сокращенное название] AS Поставщик, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      (dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки AS Опт, 
                      (dbo.Спец_цены.Цена - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки AS Спец, dbo.Клиенты.VIP, 
                      dbo.[Каталог запчастей].Обработано_нац_10 AS Обработана, (dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) 
                      * 100 / dbo.[Склад сумма_2].Цена_закупки AS Наценка7, (dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) 
                      * 100 / dbo.[Склад сумма_2].Цена_закупки AS Наценка
FROM         dbo.Клиенты INNER JOIN
                      dbo.Спец_цены ON dbo.Клиенты.ID_Клиента = dbo.Спец_цены.ID_Клиента RIGHT OUTER JOIN
                      dbo.[Склад сумма_2] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Склад сумма_2].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика ON 
                      dbo.Спец_цены.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
GO
/****** Object:  View [dbo].[Нету_цен]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Нету_цен]
AS
SELECT     TOP 100 PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Поставщики.[Сокращенное название], 
                      dbo.[Каталог запчастей].Описание, dbo.[Каталог запчастей].Цена
FROM         dbo.Есть_Наличие_ INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Есть_Наличие_.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
WHERE     (dbo.[Каталог запчастей].Цена IS NULL) OR
                      (dbo.[Каталог запчастей].Цена = 0)
ORDER BY dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти]

GO
/****** Object:  View [dbo].[Анализ неток]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ неток]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.[Анализ неток_1].Поставщик, dbo.[Анализ неток_1].Брэнд, dbo.[Анализ неток_1].[Номер запчасти], 
                      dbo.[Анализ неток_1].Заказано, dbo.[Анализ неток_1].Заказали, dbo.[Анализ неток_1].Доставлено, dbo.[Анализ неток_1].Дата, 
                      dbo.[Запросы клиентов].Анализ, dbo.[Анализ неток_1].VIP
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Анализ неток_1] ON dbo.[Запросы клиентов].ID_Запроса = dbo.[Анализ неток_1].ID_Запроса
GO
/****** Object:  View [dbo].[Архив запчастей]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Архив запчастей]
AS
SELECT     dbo.[Каталог запчастей].ID_аналога, dbo.[Каталог запчастей].ID_Запчасти, dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, 
                      dbo.[Каталог запчастей].[Номер запчасти], SUM(dbo.[Архив запчастей_].Количество) AS Колво, AVG(dbo.[Архив запчастей_].Цена) 
                      AS [Средняя цена], MAX(dbo.[Архив запчастей_].Дата_закрытия) AS [Последняя продажа]
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.[Архив запчастей_] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Архив запчастей_].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
GROUP BY dbo.[Каталог запчастей].ID_аналога, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].ID_Запчасти, 
                      dbo.Поставщики.[Сокращенное название]
GO
/****** Object:  View [dbo].[Нету_описания]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Нету_описания]
AS
SELECT     TOP 100 PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Поставщики.[Сокращенное название]
FROM         dbo.Есть_Наличие_ INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Есть_Наличие_.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
WHERE     (dbo.[Каталог запчастей].Описание IS NULL)
ORDER BY dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти]

GO
/****** Object:  View [dbo].[Таблица Вход]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица Вход]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.Клиенты.VIP, dbo.[Запросы клиентов].Альтернатива, dbo.Брэнды.Брэнд, 
                      dbo.[Каталог запчастей].[Номер запчасти], dbo.[Запросы клиентов].Заказано, dbo.[Запросы клиентов].Подтверждение, 
                      dbo.[Запросы клиентов].Заказали, dbo.[Запросы клиентов].Без_замен, dbo.[Запросы клиентов].Нет, dbo.[Запросы клиентов].Филиал, 
                      dbo.[Запросы клиентов].ID_Заказа, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Доставлено, 
                      dbo.[Запросы клиентов].Обработано, dbo.[Запросы клиентов].Анализ, dbo.[Запросы клиентов].Цена_прихода_грн, 
                      dbo.[Запросы клиентов].Цена_прихода_евро, dbo.[Запросы клиентов].Цена_прихода_долл, dbo.[Запросы клиентов].Номер_накладной, 
                      dbo.[Запросы клиентов].Дата_накладной, dbo.[Запросы клиентов].Примечание, dbo.[Запросы клиентов].Дата_заказа, 
                      dbo.[Запросы клиентов].Работник, dbo.[Запросы клиентов].Дата
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
GO
/****** Object:  View [dbo].[[Каталоги поставщиков]]]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[[Каталоги поставщиков]]]
AS
SELECT     dbo.[Каталоги поставщиков].ID_Запчасти, dbo.[Каталоги поставщиков].Брэнд, dbo.[Каталоги поставщиков].[Номер запчасти], 
                      dbo.[Каталоги поставщиков].Name, dbo.[Каталоги поставщиков].Описание, dbo.[Каталоги поставщиков].ID_Поставщика, 
                      dbo.[Каталоги поставщиков].[Срок доставки], dbo.[Каталоги поставщиков].Цена1, dbo.[Каталоги поставщиков].Цена2, dbo.[Каталоги поставщиков].Цена3, 
                      dbo.[Каталоги поставщиков].Цена4, dbo.[Каталоги поставщиков].Цена5, dbo.[Каталоги поставщиков].Цена6, dbo.[Каталоги поставщиков].Цена7, 
                      dbo.[Каталоги поставщиков].Цена8, dbo.[Каталоги поставщиков].Цена9, dbo.[Каталоги поставщиков].Цена10, dbo.[Каталоги поставщиков].Цена11, 
                      dbo.[Каталоги поставщиков].Цена12, dbo.[Каталоги поставщиков].Цена13, dbo.[Каталоги поставщиков].Цена14, dbo.[Каталоги поставщиков].Цена15, 
                      dbo.[Каталоги поставщиков].Цена16, dbo.[Каталоги поставщиков].Цена17, dbo.[Каталоги поставщиков].Цена, dbo.[Каталоги поставщиков].Наличие, 
                      dbo.[Каталоги поставщиков].ID_Аналога, dbo.Поставщики.[Сокращенное название], dbo.[Каталоги поставщиков].Дата, dbo.Поставщики.[Не возвратный],
					  dbo.Поставщики.[Виден только менеджерам] 
FROM         dbo.[Каталоги поставщиков] INNER JOIN
                      dbo.Поставщики ON dbo.[Каталоги поставщиков].ID_Поставщика = dbo.Поставщики.ID_Поставщика
GO
/****** Object:  View [dbo].[Таблица Выход]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Таблица Выход]
AS
SELECT     dbo.[Подчиненная накладные].ID, dbo.[Подчиненная накладные].ID_Накладной, dbo.Клиенты.VIP, dbo.Брэнды.Брэнд, 
                      dbo.[Каталог запчастей].[Номер запчасти], dbo.[Подчиненная накладные].Количество, dbo.[Подчиненная накладные].Цена, 
                      dbo.[Подчиненная накладные].Грн, dbo.[Подчиненная накладные].Добавить, dbo.[Подчиненная накладные].Обработано, 
                      dbo.[Подчиненная накладные].Нету, dbo.[Подчиненная накладные].Поставщик, dbo.[Подчиненная накладные].Заказ, 
                      dbo.[Подчиненная накладные].Статус, dbo.[Подчиненная накладные].Работник, dbo.[Подчиненная накладные].Дата, 
                      dbo.[Подчиненная накладные].Дата_закрытия, dbo.[Подчиненная накладные].Анализ
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.Клиенты ON dbo.[Подчиненная накладные].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Подчиненная накладные].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
GO
/****** Object:  View [dbo].[Дни рождения]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Дни рождения]
AS
SELECT     TOP 100 PERCENT VIP, Фамилия, Имя, Отчество, Д_тел, Р_тел, Моб_тел, День_Рождения, DAY(День_Рождения) AS День_р, 
                      MONTH(День_Рождения) AS Месяц_р, DATEDIFF(year, День_Рождения, GETDATE()) AS goda
FROM         dbo.Клиенты
WHERE     (NOT (День_Рождения IS NULL)) AND (DAY(День_Рождения) = DAY(GETDATE())) AND (MONTH(День_Рождения) = MONTH(GETDATE())) OR
                      (MONTH(DATEADD(day, - 1, День_Рождения)) = MONTH(GETDATE())) AND (DAY(DATEADD(day, - 1, День_Рождения)) = DAY(GETDATE())) OR
                      (DAY(DATEADD(day, - 2, День_Рождения)) = DAY(GETDATE())) AND (MONTH(DATEADD(day, - 2, День_Рождения)) = MONTH(GETDATE()))
ORDER BY MONTH(День_Рождения), DAY(День_Рождения)

GO
/****** Object:  View [dbo].[Склад_остаток]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Склад_остаток]
AS
SELECT     dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Поставщики.[Сокращенное название] AS Поставщик, 
                      dbo.[Склад_остаток_].Остаток, dbo.[Каталог запчастей].ID_Запчасти
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.[Склад_остаток_] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Склад_остаток_].ID_Запчасти

GO
/****** Object:  View [dbo].[Спец_цены_отчет]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Спец_цены_отчет]
AS
SELECT     dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Клиенты.VIP, 
                      dbo.Клиенты.Фамилия, dbo.[Спец_цены].Цена, dbo.[Спец_цены].Сотрудник, dbo.[Спец_цены].Дата, dbo.[Спец_цены].ID_Запчасти, 
                      dbo.Клиенты.ID_Клиента, dbo.[Тарифные модели].Столбец
FROM         dbo.[Спец_цены] INNER JOIN
                      dbo.Клиенты ON dbo.[Спец_цены].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Спец_цены].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.[Тарифные модели] ON dbo.Клиенты.ID_Модели_тариф = dbo.[Тарифные модели].ID_Модели_тариф

GO
/****** Object:  View [dbo].[Новая накладная]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Новая накладная]
AS
SELECT CASE WHEN COUNT (*) = 0 THEN 0 ELSE MAX(ID_Накладной) END AS ID_Накладной
FROM dbo.[Отгрузочные накладные]
GO
/****** Object:  View [dbo].[Архив запросов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Архив запросов]
AS
SELECT     TOP 100 PERCENT dbo.[Запросы клиентов].ID_Запроса, dbo.Клиенты.VIP, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.[Запросы клиентов].Цена AS Евро, dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Заказано AS Количество, 
                      dbo.[Запросы клиентов].Дата AS [Дата заказа], dbo.[Запросы клиентов].ID_Клиента, dbo.[Запросы клиентов].ID_Запчасти
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.[Запросы клиентов] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента
WHERE     (dbo.[Запросы клиентов].Обработано = 1) AND (dbo.[Запросы клиентов].Заказали = 0) AND (dbo.[Запросы клиентов].Нет = 0)

GO
/****** Object:  View [dbo].[Цена_не_обработана]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Цена_не_обработана]
AS
SELECT     TOP 100 PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Поставщики.[Сокращенное название], 
                      dbo.[Каталог запчастей].Описание
FROM         dbo.Брэнды INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика RIGHT OUTER JOIN
                      dbo.Есть_Наличие_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Есть_Наличие_.ID_Запчасти
WHERE     (dbo.[Каталог запчастей].Цена_обработана = 0)
ORDER BY dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти]

GO
/****** Object:  View [dbo].[Склад_Цена]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Склад_Цена]
AS
SELECT     ID_Запчасти AS Expr2, MAX(Цена_прихода_евро) AS Expr1
FROM         dbo.[Запросы клиентов]
GROUP BY ID_Запчасти

GO
/****** Object:  View [dbo].[Склад_сумма_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Склад_сумма_1]
AS
SELECT     ID_Запчасти, Приход, Расход, Цена_закупки
FROM         dbo.Операции
WHERE     (Расход > 0) AND (Цена_закупки <> 0) OR
                      (Расход = 0) AND (Цена_закупки <> 0)

GO
/****** Object:  View [dbo].[Склад сумма]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Склад сумма]
AS
SELECT     dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Склад сумма_2].Цена_закупки, dbo.[Склад сумма_2].Expr3 AS Количество, 
                      dbo.[Склад сумма_2].Expr4 AS Сумма, dbo.[Каталог запчастей].ID_Поставщика, dbo.Поставщики.[Сокращенное название]
FROM         dbo.[Склад сумма_2] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Склад сумма_2].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
GO
/****** Object:  View [dbo].[Склад_сумма]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Склад_сумма]
AS
SELECT     dbo.[Склад_остаток].Брэнд, dbo.[Склад_остаток].[Номер запчасти], dbo.[Склад_остаток].Поставщик, dbo.[Склад_остаток].Остаток, 
                      dbo.[Склад_Цена].Expr1 AS Цена, dbo.[Склад_остаток].Остаток * dbo.[Склад_Цена].Expr1 AS СУММА
FROM         dbo.[Склад_остаток] INNER JOIN
                      dbo.[Склад_Цена] ON dbo.[Склад_остаток].ID_Запчасти = dbo.[Склад_Цена].Expr2

GO
/****** Object:  View [dbo].[Склад_поставщики]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Склад_поставщики]
AS
SELECT     dbo.Поставщики.[Сокращенное название], SUM(dbo.[Склад сумма_2].Expr4) AS СУММА
FROM         dbo.[Склад сумма_2] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Склад сумма_2].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика
GROUP BY dbo.Поставщики.[Сокращенное название]
GO
/****** Object:  View [dbo].[Анализ_поставщика_наценка]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Анализ_поставщика_наценка]
AS
SELECT     dbo.Операции.Расход, dbo.Операции.Id_Клиента, dbo.Операции.Цена_закупки, dbo.Операции.Цена_продажи, dbo.Операции.Дата_опер, 
                      dbo.[Каталог запчастей].ID_Поставщика, (dbo.Операции.Цена_продажи - dbo.Операции.Цена_закупки) / dbo.Операции.Цена_закупки * 100 AS Наценка
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.Операции.Расход > 0) AND (dbo.Операции.Id_Клиента <> 378) AND (dbo.Операции.Цена_закупки > 0) AND (dbo.Операции.Цена_продажи > 0)

GO
/****** Object:  View [dbo].[Сотрудники_спринт]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Сотрудники_спринт]
AS
SELECT     ID_Сотрудника, Имя, Фамилия, Действующий, Проводки, Касса, IsFop
FROM         dbo.Сотрудники
GO
/****** Object:  View [dbo].[Касса_пароль]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Касса_пароль]
AS
SELECT     dbo.Касса.*, dbo.Сотрудники.Имя AS Сотрудник
FROM         dbo.Касса LEFT OUTER JOIN
                      dbo.Сотрудники ON dbo.Касса.Пароль = dbo.Сотрудники.Пароль

GO
/****** Object:  View [dbo].[Создание_прейскуранта_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Создание_прейскуранта_1]
AS
SELECT     dbo.Операции.ID_Запчасти, dbo.Операции.Расход
FROM         dbo.Операции INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     (dbo.Операции.Расход > 0) AND (DATEDIFF(year, dbo.Операции.Дата_опер, GETDATE()) = 0) AND (dbo.[Каталог запчастей].ID_Поставщика = 9)

GO
/****** Object:  View [dbo].[Остаток_цена_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Остаток_цена_]
AS
SELECT        TOP 100 PERCENT ID_Запчасти, Id_Запроса, Цена_закупки, MIN(Дата_опер) AS Дата, SUM(Приход) - SUM(Расход) AS Остаток
FROM            dbo.Операции
WHERE        (Расход > 0) OR
                         (Расход = 0)
GROUP BY ID_Запчасти, Id_Запроса, Цена_закупки
HAVING        (SUM(Приход) - SUM(Расход) <> 0)
ORDER BY ID_Запчасти, MIN(Дата_опер)

GO
/****** Object:  View [dbo].[Создание_прейскуранта_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Создание_прейскуранта_2]
AS
SELECT     ISNULL(dbo.Создание_прейскуранта_1.ID_Запчасти, dbo.Склад_остаток_.ID_Запчасти) AS Запчасть
FROM         dbo.Создание_прейскуранта_1 FULL OUTER JOIN
                      dbo.Склад_остаток_ ON dbo.Создание_прейскуранта_1.ID_Запчасти = dbo.Склад_остаток_.ID_Запчасти

GO
/****** Object:  View [dbo].[Остаток_цена]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Остаток_цена]
AS
SELECT        dbo.Остаток_цена_.ID_Запчасти, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.Поставщики.[Сокращенное название], 
                         dbo.Остаток_цена_.Остаток, dbo.Остаток_цена_.Дата, dbo.Остаток_цена_.Цена_закупки
FROM            dbo.Остаток_цена_ INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.Остаток_цена_.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                         dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика

GO
/****** Object:  View [dbo].[Создание_прейскуранта_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Создание_прейскуранта_3]
AS
SELECT     dbo.Создание_прейскуранта_2.Запчасть AS ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].Цена, 
                      dbo.[Цена вход].Цена_закупки
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда RIGHT OUTER JOIN
                      dbo.Создание_прейскуранта_2 ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Создание_прейскуранта_2.Запчасть LEFT OUTER JOIN
                      dbo.[Цена вход] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Цена вход].ID_Запчасти

GO
/****** Object:  View [dbo].[Создание_прейскуранта_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Создание_прейскуранта_4]
AS
SELECT     MIN(ID_Запчасти) AS ID_Запчасти, [Номер запчасти], Брэнд, MAX(Цена) AS Розница, MAX(Цена_закупки) AS Закупка
FROM         dbo.Создание_прейскуранта_3
GROUP BY [Номер запчасти], Брэнд
HAVING      (MAX(Цена) <> 0) OR
                      (MAX(Цена_закупки) <> 0)

GO
/****** Object:  View [dbo].[Создание_прейскуранта]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Создание_прейскуранта]
AS
SELECT     ID_Запчасти, [Номер запчасти], Брэнд, CASE isnull(Розница, 0) WHEN 0 THEN Закупка * 1.5 ELSE Розница END AS Цена
FROM         dbo.Создание_прейскуранта_4
GO
/****** Object:  Table [dbo].[Прейскурант]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Прейскурант](
	[ID_Запчасти] [int] NOT NULL,
	[Брэнд] [nchar](18) NULL,
	[Номер] [nchar](25) NULL,
	[Цена] [decimal](9, 2) NULL,
	[Дата_создания] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Прейскурант_дополнение]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Прейскурант_дополнение]
AS
SELECT     dbo.Создание_прейскуранта.ID_Запчасти, dbo.Создание_прейскуранта.[Номер запчасти], dbo.Создание_прейскуранта.Брэнд, 
                      dbo.Создание_прейскуранта.Цена
FROM         dbo.Создание_прейскуранта LEFT OUTER JOIN
                      dbo.Прейскурант ON dbo.Создание_прейскуранта.ID_Запчасти = dbo.Прейскурант.ID_Запчасти
WHERE     (dbo.Прейскурант.ID_Запчасти IS NULL)

GO
/****** Object:  View [dbo].[Интернет_продажи]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Интернет_продажи]
AS
SELECT     dbo.Склад_остаток_.ID_Запчасти, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер поставщика], dbo.Склад_остаток_.Остаток, 
                      dbo.[Каталог запчастей].Цена7 AS Цена_опт, dbo.[Цена последнего прихода].Евро AS Цена_последняя
FROM         dbo.Склад_остаток_ INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Склад_остаток_.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда LEFT OUTER JOIN
                      dbo.[Цена последнего прихода] ON dbo.Склад_остаток_.ID_Запчасти = dbo.[Цена последнего прихода].ID_Запчасти

GO
/****** Object:  View [dbo].[Операции_возврат]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Операции_возврат]
AS
SELECT        ID_Операции, ID_Запчасти, Приход, Расход, Дата, Работник, Id_Накладной, Id_Запроса, Id_Клиента, Цена_закупки, Цена_продажи, Дата_опер
FROM            dbo.Операции
WHERE        (Расход <= 0)

GO
/****** Object:  View [dbo].[Сумма заказа_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Сумма заказа_1]
AS
SELECT     ID_Запчасти, ID_Клиента, SUM(Цена * Заказано) AS Сумма, SUM(Грн * Заказано) AS [Сумма_]
FROM         dbo.[Запросы клиентов]
WHERE     (Обработано = 0)
GROUP BY ID_Запчасти, ID_Клиента

GO
/****** Object:  View [dbo].[Сумма заказа]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Сумма заказа]
AS
SELECT     ID_Клиента, SUM(Сумма) AS Сумма, SUM(Сумма_) AS [Сумма_]
FROM         dbo.[Сумма заказа_1]
GROUP BY ID_Клиента


GO
/****** Object:  View [dbo].[Сумма накладной_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Сумма накладной_1]
AS
SELECT     ID_Клиента, ID_Запчасти, SUM(Количество * Цена) AS Сумма, SUM(Количество * Грн) AS [Сумма_]
FROM         dbo.[Подчиненная накладные]
WHERE     (Обработано = 0) AND (Нету = 0)
GROUP BY ID_Клиента, ID_Запчасти

GO
/****** Object:  View [dbo].[Доставка]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Доставка]
AS
SELECT        TOP 100 PERCENT ID_Поставщика, Сумма_грн, Сумма_евро, Сумма_долл, Дата, Примечание, ID_Проводки
FROM            dbo.Проводки
WHERE        (Счет_дебета = 14)
ORDER BY Дата DESC

GO
/****** Object:  View [dbo].[Сумма накладной]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Сумма накладной]
AS
SELECT     ID_Клиента, SUM(Сумма) AS Сумма, SUM(Сумма_) AS [Сумма_]
FROM         dbo.[Сумма накладной_1]
GROUP BY ID_Клиента


GO
/****** Object:  View [dbo].[Продажи_по_клиентам_01]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_01]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 11) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 10)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Анализ продаж_4]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Анализ продаж_4]
AS
SELECT        dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].ID_Брэнда, 
                         dbo.[Каталог запчастей].ID_Поставщика, dbo.[Каталог запчастей].[Рекомендовано на склад], dbo.[Каталог запчастей].[Рекомендовано по аналогу], 
                         dbo.[Анализ продаж_2].Продано, dbo.Остаток_.Остаток, dbo.[Каталог запчастей].ID_аналога
FROM            dbo.[Каталог запчастей] LEFT OUTER JOIN
                         dbo.Остаток_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Остаток_.ID_Запчасти LEFT OUTER JOIN
                         dbo.[Анализ продаж_2] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Анализ продаж_2].ID_Запчасти

GO
/****** Object:  View [dbo].[Клиент_Z]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Клиент_Z]
AS
SELECT     TOP 100 PERCENT ID_Клиента, VIP, День_Рождения
FROM         dbo.Клиенты
WHERE     (VIP LIKE 'z%')
ORDER BY VIP


GO
/****** Object:  View [dbo].[Продажи_по_клиентам_02]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_02]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 10) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 9)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Заказы_переход_Z]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Заказы_переход_Z]
AS
SELECT     TOP 100 PERCENT dbo.[Клиент_Z].VIP
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Клиент_Z] ON dbo.[Подчиненная накладные].ID_Клиента = dbo.[Клиент_Z].ID_Клиента
WHERE     (dbo.[Подчиненная накладные].Обработано = 0)
GROUP BY dbo.[Клиент_Z].VIP
ORDER BY dbo.[Клиент_Z].VIP

GO
/****** Object:  View [dbo].[Продажи_по_клиентам_03]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_03]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 9) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 8)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Клиент_notZ]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Клиент_notZ]
AS

SELECT     TOP 100 PERCENT ID_Клиента, VIP, День_Рождения
FROM         dbo.Клиенты
WHERE     (NOT (VIP LIKE 'z%'))
ORDER BY VIP

GO
/****** Object:  View [dbo].[Продажи_по_клиентам_04]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_04]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 8) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 7)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Проплаты_поставщику_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Проплаты_поставщику_1]
AS
SELECT     MIN(ID_Проводки) AS Id_Проводки, Convert_ID
FROM         dbo.Проводки
WHERE     (Счет_дебета = 29 OR
                      Счет_дебета = 31)
GROUP BY Convert_ID
HAVING      (Convert_ID IS NOT NULL) AND (COUNT(ID_Проводки) = 2)

GO
/****** Object:  View [dbo].[Продажи_по_клиентам_05]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_05]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 7) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 6)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Заказы_переход]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Заказы_переход]
AS
SELECT     TOP 100 PERCENT dbo.[Клиент_notZ].VIP
FROM         dbo.[Подчиненная накладные] INNER JOIN
                      dbo.[Клиент_notZ] ON dbo.[Подчиненная накладные].ID_Клиента = dbo.[Клиент_notZ].ID_Клиента
WHERE     (dbo.[Подчиненная накладные].Обработано = 0)
GROUP BY dbo.[Клиент_notZ].VIP
ORDER BY dbo.[Клиент_notZ].VIP


GO
/****** Object:  View [dbo].[Продажи_по_клиентам_06]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_06]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 6) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 5)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Проплаты поставщику]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Проплаты поставщику]
AS
SELECT      dbo.Проводки.ID_Поставщика, dbo.Проводки.Сумма_грн, dbo.Проводки.Сумма_евро, dbo.Проводки.Сумма_долл, dbo.Проводки.Дата, 
                      dbo.Проводки.Примечание, dbo.Проводки.ID_Проводки, dbo.Проводки.Счет_дебета, dbo.Проводки.Счет_кредита, dbo.Проводки.Convert_ID
FROM         dbo.Проводки LEFT OUTER JOIN
                      dbo.Проплаты_поставщику_1 ON dbo.Проводки.ID_Проводки = dbo.Проплаты_поставщику_1.Id_Проводки
WHERE     (dbo.Проводки.Счет_дебета = 29) AND (dbo.Проплаты_поставщику_1.Convert_ID IS NULL) AND (dbo.Проводки.Счет_кредита <> 31) OR
                      (dbo.Проводки.Счет_дебета = 31) AND (dbo.Проплаты_поставщику_1.Convert_ID IS NULL)

GO
/****** Object:  View [dbo].[Продажи_по_клиентам_07]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_07]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 5) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 4)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Дневной_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Дневной_1]
AS
SELECT     ID_Клиента, Дата_закрытия, ID_Запчасти, Цена * Количество AS Сумма
FROM         dbo.[Подчиненная накладные]
WHERE     (Обработано = 1) AND (Нету = 0)
GO
/****** Object:  View [dbo].[Продажи_по_клиентам_08]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_08]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 4) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 3)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Дневной_3]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Дневной_3]
AS
SELECT     ID_Клиента, SUM(Сумма) AS Сумма, YEAR(Дата_закрытия) AS Ex1, MONTH(Дата_закрытия) AS Ex2, DAY(Дата_закрытия) AS Ex3
FROM         dbo.[Дневной_1]
GROUP BY ID_Клиента, YEAR(Дата_закрытия), MONTH(Дата_закрытия), DAY(Дата_закрытия)
GO
/****** Object:  View [dbo].[Продажи_по_клиентам_09]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_09]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 3) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 2)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Дневной_2]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Дневной_2]
AS
SELECT     ID_Клиента, SUM(Цена) AS Сумма, YEAR(Дата) AS Expr1, MONTH(Дата) AS Expr2, DAY(Дата) AS Expr3
FROM         dbo.Касса
GROUP BY ID_Клиента, YEAR(Дата), MONTH(Дата), DAY(Дата)
GO
/****** Object:  View [dbo].[Продажи_по_клиентам_10]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_10]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 2) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 1)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Дневной]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Дневной]
AS
SELECT     Клиенты_1.VIP, dbo.Клиенты.VIP AS VIR, dbo.Дневной_2.Сумма, dbo.Дневной_3.Сумма AS Отгружено, dbo.Дневной_2.Expr3, 
                      dbo.Дневной_2.Expr2, dbo.Дневной_2.Expr1, dbo.Дневной_3.Ex3, dbo.Дневной_3.Ex2, dbo.Дневной_3.Ex1
FROM         dbo.Клиенты RIGHT OUTER JOIN
                      dbo.Дневной_3 ON dbo.Клиенты.ID_Клиента = dbo.Дневной_3.ID_Клиента FULL OUTER JOIN
                      dbo.Дневной_2 LEFT OUTER JOIN
                      dbo.Клиенты AS Клиенты_1 ON dbo.Дневной_2.ID_Клиента = Клиенты_1.ID_Клиента ON dbo.Дневной_3.Ex3 = dbo.Дневной_2.Expr3 AND 
                      dbo.Дневной_3.Ex2 = dbo.Дневной_2.Expr2 AND dbo.Дневной_3.Ex1 = dbo.Дневной_2.Expr1 AND 
                      dbo.Дневной_3.ID_Клиента = dbo.Дневной_2.ID_Клиента
GO
/****** Object:  View [dbo].[Продажи_по_клиентам_11]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_11]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) <= 1) AND (DATEDIFF(month, Дата_опер, GETDATE()) > 0)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Продажи_по_клиентам_12]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам_12]
AS
SELECT        Id_Клиента, SUM(Расход * Цена_продажи) AS Сумма
FROM            dbo.Операции
WHERE        (Расход <> 0) AND (DATEDIFF(month, Дата_опер, GETDATE()) < 1)
GROUP BY Id_Клиента

GO
/****** Object:  View [dbo].[Продажи_по_клиентам]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Продажи_по_клиентам]
AS
SELECT        dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, dbo.Клиенты.Фамилия, dbo.Клиенты.Опт, dbo.Продажи_по_клиентам_01.Сумма AS [01], 
                         dbo.Продажи_по_клиентам_02.Сумма AS [02], dbo.Продажи_по_клиентам_03.Сумма AS [03], dbo.Продажи_по_клиентам_04.Сумма AS [04], 
                         dbo.Продажи_по_клиентам_05.Сумма AS [05], dbo.Продажи_по_клиентам_06.Сумма AS [06], dbo.Продажи_по_клиентам_07.Сумма AS [07], 
                         dbo.Продажи_по_клиентам_08.Сумма AS [08], dbo.Продажи_по_клиентам_09.Сумма AS [09], dbo.Продажи_по_клиентам_10.Сумма AS [10], 
                         dbo.Продажи_по_клиентам_11.Сумма AS [11], dbo.Продажи_по_клиентам_12.Сумма AS [12]
FROM            dbo.Клиенты LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_02 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_02.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_03 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_03.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_01 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_01.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_04 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_04.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_05 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_05.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_06 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_06.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_08 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_08.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_09 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_09.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_10 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_10.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_11 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_11.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_12 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_12.Id_Клиента LEFT OUTER JOIN
                         dbo.Продажи_по_клиентам_07 ON dbo.Клиенты.ID_Клиента = dbo.Продажи_по_клиентам_07.Id_Клиента

GO
/****** Object:  View [dbo].[Наценка_10_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Наценка_10_]
AS
SELECT     dbo.Поставщики.[Сокращенное название] AS Поставщик, dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      (dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки AS Опт, 
                      (dbo.[Спец_цены].Цена - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки AS Спец, dbo.Клиенты.VIP, 
                      dbo.[Каталог запчастей].ID_Запчасти
FROM         dbo.Клиенты INNER JOIN
                      dbo.[Спец_цены] ON dbo.Клиенты.ID_Клиента = dbo.[Спец_цены].ID_Клиента RIGHT OUTER JOIN
                      dbo.[Склад сумма_2] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Склад сумма_2].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика ON 
                      dbo.[Спец_цены].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     ((dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки < 15) OR
                      ((dbo.[Спец_цены].Цена - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки < 15)
GO
/****** Object:  View [dbo].[Наценка_10]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Наценка_10]
AS
SELECT        dbo.[Каталог запчастей].ID_Запчасти, dbo.Наценка_10_.Поставщик, dbo.Наценка_10_.Брэнд, dbo.Наценка_10_.[Номер запчасти], 
                         dbo.Наценка_10_.Опт, dbo.Наценка_10_.Спец, dbo.Наценка_10_.VIP, dbo.[Каталог запчастей].Обработано_нац_10 AS Обработана
FROM            dbo.[Каталог запчастей] INNER JOIN
                         dbo.Наценка_10_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Наценка_10_.ID_Запчасти

GO
/****** Object:  View [dbo].[Запросы_веб_1]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Запросы_веб_1]
AS
SELECT     Брэнд, [Номер запчасти], ID_Поставщика, MIN([Срок доставки]) AS Срок
FROM         dbo.[Каталоги поставщиков]
GROUP BY Брэнд, [Номер запчасти], ID_Поставщика
GO
/****** Object:  View [dbo].[Запросы_веб]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Запросы_веб]
AS
SELECT     dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].Альтернатива, dbo.[Запросы клиентов].Заказано, dbo.[Запросы клиентов].Подтверждение, 
                      dbo.[Заказы поставщикам].Предварительная_дата, dbo.[Заказы поставщикам].Точная_дата, dbo.Клиенты.VIP, dbo.Поисковая.[Номер запчасти], dbo.Поисковая.Брэнд, 
                      dbo.[Запросы клиентов].Заказали, dbo.[Запросы клиентов].Без_замен, dbo.[Запросы клиентов].Нет, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, 
                      dbo.[Запросы клиентов].Доставлено, dbo.[Запросы клиентов].Обработано, dbo.[Запросы клиентов].Дата_заказа, dbo.Поисковая.[Сокращенное название], 
                      dbo.[Запросы клиентов].ID_Клиента, dbo.[Запросы клиентов].Филиал, dbo.Поисковая.ID_аналога, dbo.[Заказы поставщикам].ID_Заказа, dbo.[Запросы клиентов].Дата, 
                      dbo.[Запросы клиентов].ID_Запчасти, dbo.Поисковая.Цена_обработана, dbo.[Запросы клиентов].Интернет, dbo.Поисковая.[Номер поставщика], dbo.Поисковая.Описание, 
                      dbo.Запросы_веб_1.Срок AS [Срок доставки]
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Запросы_веб_1 ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Запросы_веб_1.ID_Поставщика AND 
                      dbo.[Каталог запчастей].[Номер поставщика] = dbo.Запросы_веб_1.[Номер запчасти] RIGHT OUTER JOIN
                      dbo.[Запросы клиентов] INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.Поисковая ON dbo.[Запросы клиентов].ID_Запчасти = dbo.Поисковая.ID_Запчасти ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти AND 
                      dbo.Запросы_веб_1.Брэнд = dbo.Поисковая.Брэнд LEFT OUTER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
GO
/****** Object:  View [dbo].[Проверка_заказа]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Проверка_заказа]
AS
SELECT     dbo.Клиенты.VIP, dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.[Заказы поставщикам].Предварительная_дата, dbo.[Каталог запчастей].ID_аналога, dbo.[Запросы клиентов].Заказано, 
                      dbo.[Запросы клиентов].Срочно, dbo.[Запросы клиентов].ID_Запроса, dbo.[Запросы клиентов].Альтернатива
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда LEFT OUTER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
WHERE     (dbo.[Запросы клиентов].Заказано <> 0) AND (dbo.[Запросы клиентов].Доставлено = 0) AND (dbo.[Запросы клиентов].Обработано = 0)
GO
/****** Object:  Table [dbo].[Непрямые аналоги]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Непрямые аналоги](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Аналога] [int] NOT NULL,
	[ID_NA] [int] NOT NULL,
 CONSTRAINT [PK_Непрямые аналоги] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Поисковая_NA]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[Поисковая_NA]
AS
SELECT     TOP 100 PERCENT dbo.[Непрямые аналоги].ID_Аналога, dbo.[Каталог запчастей].ID_Запчасти, dbo.[Каталог запчастей].[Номер запчасти], 
                      dbo.[Каталог запчастей].[Номер поставщика], dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].NAME, 
                      dbo.Автомобили.Автомобиль, dbo.Группы.Группа, dbo.[Каталог запчастей].Описание, dbo.[Каталог запчастей].Скидка, 
                      dbo.[Каталог запчастей].Цена, dbo.[Каталог запчастей].Цена1, dbo.[Каталог запчастей].Цена2, dbo.[Каталог запчастей].Цена3, 
                      dbo.[Каталог запчастей].Цена4, dbo.Остаток_.Остаток, dbo.[Каталог запчастей].ID, dbo.[Каталог запчастей].Цена5, 
                      dbo.[Каталог запчастей].Цена6, dbo.[Каталог запчастей].Цена7, dbo.[Каталог запчастей].Цена8, dbo.[Каталог запчастей].Цена9, 
                      dbo.[Каталог запчастей].Цена10, dbo.[Каталог запчастей].Цена11, dbo.[Каталог запчастей].Цена12, dbo.[Каталог запчастей].Цена13, 
                      dbo.[Каталог запчастей].Цена14, dbo.[Каталог запчастей].Цена15, dbo.[Каталог запчастей].Цена16, dbo.[Каталог запчастей].Цена17, 
                      dbo.Резерв_1.Количество, dbo.Спец_цены.ID_Клиента, dbo.Спец_цены.Цена AS Спец_цена
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.[Непрямые аналоги] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Непрямые аналоги].ID_NA LEFT OUTER JOIN
                      dbo.Спец_цены ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Спец_цены.ID_Запчасти LEFT OUTER JOIN
                      dbo.Резерв_1 ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Резерв_1.ID_Запчасти LEFT OUTER JOIN
                      dbo.Группы ON dbo.[Каталог запчастей].[ID_Группы товаров] = dbo.Группы.ID_Группы LEFT OUTER JOIN
                      dbo.Автомобили ON dbo.[Каталог запчастей].ID_Автомобиля = dbo.Автомобили.ID_Автомобиля LEFT OUTER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда LEFT OUTER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.Остаток_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Остаток_.ID_Запчасти

GO
/****** Object:  Table [dbo].[Клиенты_лог]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Клиенты_лог](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NULL,
	[VIP] [char](10) NULL,
	[Фамилия] [char](20) NULL,
	[Имя] [char](20) NULL,
	[Отчество] [char](20) NULL,
	[Д_тел] [char](20) NULL,
	[Р_тел] [char](20) NULL,
	[Моб_тел] [char](20) NULL,
	[Факс] [char](20) NULL,
	[EMail] [char](40) NULL,
	[Город] [char](20) NULL,
	[Адрес] [char](50) NULL,
	[ID_Модели_тариф] [int] NULL,
	[Скидка] [numeric](5, 2) NULL,
	[Нужен_прайс] [bit] NULL,
	[Розничный_клиент] [bit] NULL,
	[Расчет_в_евро] [bit] NULL,
	[Мастерская] [bit] NULL,
	[Опт] [bit] NULL,
	[День_Рождения] [datetime] NULL,
	[Блокировка_продаж] [bit] NULL,
	[Мерцание] [bit] NULL,
	[Примечание] [char](500) NULL,
	[Работник] [char](20) NULL,
	[Дата] [datetime] NULL,
	[Статус] [char](20) NULL,
	[Количество_дней] [int] NULL,
	[Выводить_просрочку] [bit] NULL,
	[Интернет_заказы] [bit] NULL,
	[Пароль] [char](10) NOT NULL,
	[Innet] [char](8) NULL,
 CONSTRAINT [PK_Клиенты_лог] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Клиенты_история]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Клиенты_история]
AS
SELECT     dbo.[Клиенты_лог].VIP, dbo.[Клиенты_лог].Фамилия, dbo.[Клиенты_лог].Имя, dbo.[Клиенты_лог].Отчество, dbo.[Клиенты_лог].Д_тел, 
                      dbo.[Клиенты_лог].Р_тел, dbo.[Клиенты_лог].Моб_тел, dbo.[Клиенты_лог].Факс, dbo.[Клиенты_лог].EMail, dbo.[Клиенты_лог].Город, 
                      dbo.[Клиенты_лог].Адрес, dbo.[Тарифные модели].Сокращенное_название, dbo.[Клиенты_лог].Нужен_прайс, 
                      dbo.[Клиенты_лог].Розничный_клиент, dbo.[Клиенты_лог].Расчет_в_евро, dbo.[Клиенты_лог].Мастерская, dbo.[Клиенты_лог].Опт, 
                      dbo.[Клиенты_лог].День_Рождения, dbo.[Клиенты_лог].Блокировка_продаж, dbo.[Клиенты_лог].Мерцание, dbo.[Клиенты_лог].Примечание, 
                      dbo.[Клиенты_лог].Работник, dbo.[Клиенты_лог].Дата, dbo.[Клиенты_лог].Статус, dbo.Сотрудники.Имя AS Expr1, 
                      dbo.[Клиенты_лог].ID_Клиента, dbo.[Клиенты_лог].Количество_дней, dbo.[Клиенты_лог].[Выводить_просрочку], dbo.[Клиенты_лог].Интернет_заказы 
FROM         dbo.[Клиенты_лог] LEFT OUTER JOIN
                      dbo.[Тарифные модели] ON dbo.[Клиенты_лог].ID_Модели_тариф = dbo.[Тарифные модели].ID_Модели_тариф LEFT OUTER JOIN
                      dbo.Сотрудники ON dbo.[Клиенты_лог].Пароль = dbo.Сотрудники.Пароль
GO
/****** Object:  View [dbo].[Возврат_на_ЕССО]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Возврат_на_ЕССО]
AS
SELECT     TOP 100 PERCENT dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Запросы клиентов].Доставлено, 
                      dbo.[Запросы клиентов].Цена_прихода_грн, dbo.[Запросы клиентов].Цена_прихода_евро, dbo.[Запросы клиентов].Цена_прихода_долл, 
                      dbo.[Запросы клиентов].Номер_накладной, dbo.[Запросы клиентов].Дата_накладной, dbo.[Накладные поставщиков_2].Остаток, 
                      dbo.[Резерв_1].Количество AS Резерв, ISNULL(dbo.[Остаток_].Остаток, 0) - ISNULL(dbo.[Резерв_1].Количество, 0) AS Доступно, 
                      dbo.[Возврат_на_ЕССО_].Возврат
FROM         dbo.[Запросы клиентов] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда LEFT OUTER JOIN
                      dbo.[Возврат_на_ЕССО_] ON dbo.[Запросы клиентов].ID_Запроса = dbo.[Возврат_на_ЕССО_].ID_Запроса LEFT OUTER JOIN
                      dbo.[Накладные поставщиков_2] ON dbo.[Запросы клиентов].ID_Запроса = dbo.[Накладные поставщиков_2].Id_Запроса AND 
                      dbo.[Каталог запчастей].ID_Запчасти = dbo.[Накладные поставщиков_2].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Резерв_1] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Резерв_1].ID_Запчасти LEFT OUTER JOIN
                      dbo.[Остаток_] ON dbo.[Каталог запчастей].ID_Запчасти = dbo.[Остаток_].ID_Запчасти
WHERE     (dbo.[Запросы клиентов].Дата_накладной > CONVERT(DATETIME, '2007-02-13 00:00:00', 102)) AND 
                      (dbo.[Запросы клиентов].Дата_накладной < CONVERT(DATETIME, '2007-06-08 00:00:00', 102)) AND (dbo.[Каталог запчастей].ID_Поставщика = 11)
ORDER BY dbo.[Запросы клиентов].Дата_накладной
GO
/****** Object:  UserDefinedFunction [SPRINT\Vasil].[GetAnalogs]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [SPRINT\Vasil].[GetAnalogs] 
(	
	-- Add the parameters for the function here
	@brand nvarchar(20), 
	@number nvarchar(25)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT     Spare_Brands_1.Brand_Name, Spare_Names_1.Spare_Name
FROM         AnalogsDB_0606.dbo.Spare_Analogs INNER JOIN
                      AnalogsDB_0606.dbo.Spare_Brands ON AnalogsDB_0606.dbo.Spare_Analogs.Brand_ID = AnalogsDB_0606.dbo.Spare_Brands.Brand_ID INNER JOIN
                      AnalogsDB_0606.dbo.Spare_Names ON AnalogsDB_0606.dbo.Spare_Analogs.Spare_Name_ID = AnalogsDB_0606.dbo.Spare_Names.Spare_Name_ID INNER JOIN
                      AnalogsDB_0606.dbo.Spare_Brands AS Spare_Brands_1 ON AnalogsDB_0606.dbo.Spare_Analogs.Analog_Brand_ID = Spare_Brands_1.Brand_ID INNER JOIN
                      AnalogsDB_0606.dbo.Spare_Names AS Spare_Names_1 ON AnalogsDB_0606.dbo.Spare_Analogs.Analog_Spare_Name_ID = Spare_Names_1.Spare_Name_ID
WHERE     (AnalogsDB_0606.dbo.Spare_Names.Spare_Name = @number) AND (AnalogsDB_0606.dbo.Spare_Brands.Brand_Name = @brand)
)
GO
/****** Object:  Table [dbo].[Brands_Quality]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands_Quality](
	[Quality_ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Брэнда] [int] NOT NULL,
	[Brand_Quality] [varchar](2) NOT NULL,
 CONSTRAINT [PK_BRANDS_QUALITY] PRIMARY KEY CLUSTERED 
(
	[Quality_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brands_Quality_Log]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brands_Quality_Log](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_Брэнда] [int] NOT NULL,
	[Old_Value] [varchar](2) NULL,
	[New_Value] [varchar](2) NULL,
	[Modified_Date] [datetime] NOT NULL,
	[Modified_By] [varchar](150) NOT NULL,
 CONSTRAINT [PK_BRANDS_QUALITY_LOG] PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataToDelete]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataToDelete](
	[IdToDelete] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DELIVERY_FOR_PRINT]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DELIVERY_FOR_PRINT](
	[DELIVERY_ID] [int] IDENTITY(1,1) NOT NULL,
	[DELIVERY_TYPE] [nchar](20) NULL,
 CONSTRAINT [PK_DELIVERY_FOR_PRINT] PRIMARY KEY CLUSTERED 
(
	[DELIVERY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stock_users]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock_users](
	[User_ID] [int] IDENTITY(1,1) NOT NULL,
	[User_name] [nchar](25) NOT NULL,
 CONSTRAINT [PK_Stock_users] PRIMARY KEY CLUSTERED 
(
	[User_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Term]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Term](
	[ID_Поставщика] [int] NULL,
	[Срок доставки] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmp_upd]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmp_upd](
	[Analog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Brand_ID] [int] NOT NULL,
	[Analog_Brand_ID] [int] NOT NULL,
	[Spare_Name_ID] [int] NULL,
	[Analog_Spare_Name_ID] [int] NULL,
	[Supplier_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Автомобили клиентов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Автомобили клиентов](
	[ID_Aвтомобиля] [int] IDENTITY(1,1) NOT NULL,
	[ID_Клиента] [int] NOT NULL,
	[ID_Марки] [int] NULL,
	[Авто] [char](20) NULL,
	[Модель] [char](30) NULL,
	[Год_выпуска] [char](4) NULL,
	[Месяц_выпуска] [char](2) NULL,
	[Бензин] [bit] NOT NULL,
	[Инжектор] [bit] NOT NULL,
	[Моноинжектор] [bit] NOT NULL,
	[Карбюратор] [bit] NOT NULL,
	[Дизель] [bit] NOT NULL,
	[D] [bit] NOT NULL,
	[TD] [bit] NOT NULL,
	[TDI] [bit] NOT NULL,
	[SDI] [bit] NOT NULL,
	[CDI] [bit] NOT NULL,
	[DTI] [bit] NOT NULL,
	[IDTD] [bit] NOT NULL,
	[TURBO] [bit] NOT NULL,
	[Объем_куб_см] [char](10) NULL,
	[Кузов] [char](50) NULL,
	[Мотор] [char](50) NULL,
	[ABS] [bit] NOT NULL,
	[PS] [bit] NOT NULL,
	[Коробка_автомат] [bit] NOT NULL,
	[Кондиционер] [bit] NOT NULL,
	[4WD] [bit] NOT NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL,
 CONSTRAINT [PK_Автомобили клиентов] PRIMARY KEY CLUSTERED 
(
	[ID_Aвтомобиля] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Аналогичные брэнды]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Аналогичные брэнды](
	[Брэнд] [char](20) NOT NULL,
	[Брэнд_аналог] [nchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Веб-запросы]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Веб-запросы](
	[ID_Query] [int] IDENTITY(1,1) NOT NULL,
	[vip] [nchar](5) NOT NULL,
	[ipaddress] [nchar](16) NOT NULL,
	[query] [nchar](50) NOT NULL,
	[date] [datetime] NOT NULL,
	[success] [bit] NOT NULL,
	[available] [bit] NOT NULL,
	[brend] [char](18) NULL,
	[nomer] [char](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Веб-регистрация]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Веб-регистрация](
	[Id_registration] [int] IDENTITY(1,1) NOT NULL,
	[login] [nchar](10) NOT NULL,
	[pass] [nchar](10) NOT NULL,
	[ipaddress] [nchar](16) NOT NULL,
	[success] [bit] NOT NULL,
	[date] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Внутренний курс валют]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Внутренний курс валют](
	[ID_Курса] [int] IDENTITY(1,1) NOT NULL,
	[Дата] [datetime] NOT NULL,
	[Доллар] [numeric](9, 2) NOT NULL,
	[Евро] [numeric](9, 2) NOT NULL,
	[Работник] [char](20) NOT NULL,
 CONSTRAINT [PK_внутр_курс_валют] PRIMARY KEY CLUSTERED 
(
	[ID_Курса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Доставка грузов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Доставка грузов](
	[ID_Заказа] [int] NOT NULL,
	[ID_Перевозчика] [int] NOT NULL,
	[Дата_отправки] [datetime] NULL,
	[Дата_прихода] [datetime] NULL,
	[Время_прихода] [datetime] NULL,
	[Декларация] [char](20) NULL,
	[Исполнитель] [char](30) NULL,
	[Примечание] [char](50) NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Заметки]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Заметки](
	[ID_Заметки] [int] IDENTITY(1,1) NOT NULL,
	[Дата заметки] [datetime] NOT NULL,
	[Заметка] [char](500) NOT NULL,
 CONSTRAINT [PK_Заметки] PRIMARY KEY CLUSTERED 
(
	[ID_Заметки] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Перевозчики]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Перевозчики](
	[ID_Перевозчика] [int] IDENTITY(1,1) NOT NULL,
	[Сокращенное_название] [char](20) NOT NULL,
	[Полное_название] [char](40) NOT NULL,
	[Адрес] [char](50) NOT NULL,
	[Телефон1] [char](15) NULL,
	[Телефон2] [char](15) NULL,
	[Телефон3] [char](15) NULL,
	[Факс] [char](15) NULL,
 CONSTRAINT [PK_Перевозчики] PRIMARY KEY CLUSTERED 
(
	[ID_Перевозчика] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[План счетов]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[План счетов](
	[ID_Счета] [int] IDENTITY(1,1) NOT NULL,
	[Счет] [int] NOT NULL,
	[Субсчет] [int] NOT NULL,
	[Примечание] [nchar](50) NOT NULL,
 CONSTRAINT [PK_План счетов] PRIMARY KEY CLUSTERED 
(
	[ID_Счета] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Разбежности номеров]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Разбежности номеров](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Брэнд] [nchar](18) NULL,
	[Номер запчасти] [nchar](25) NULL,
	[Номер поставщика] [nchar](25) NULL,
	[Номер_запчасти] [nchar](25) NULL,
	[Номер_поставщика] [nchar](25) NULL,
	[Поставщик] [char](15) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Сотрудники перевозчиков]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Сотрудники перевозчиков](
	[ID_Сотрудника] [int] NOT NULL,
	[Фамилия] [char](25) NULL,
	[Имя] [char](25) NULL,
	[Отчество] [char](25) NULL,
	[День_рождения] [datetime] NULL,
	[Телефон1] [char](15) NULL,
	[Телефон2] [char](15) NULL,
	[Должность] [char](20) NULL,
	[ID_Перевозчика] [int] NOT NULL,
	[Примечание] [char](50) NULL,
	[Работник] [char](20) NOT NULL,
	[Дата] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Справка]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Справка](
	[ID_Справки] [int] IDENTITY(1,1) NOT NULL,
	[Поставщик] [char](100) NULL,
	[Город] [char](100) NULL,
	[Телефон] [char](100) NULL,
	[Мобильный] [char](100) NULL,
	[Номер клиента] [char](100) NULL,
	[Электронная почта] [char](100) NULL,
	[Примечание] [char](250) NULL,
	[Сайт] [char](100) NULL,
 CONSTRAINT [PK_Справка] PRIMARY KEY CLUSTERED 
(
	[ID_Справки] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Таблица аналогов_В]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Таблица аналогов_В](
	[Брэнд] [char](20) NOT NULL,
	[Номер] [char](25) NOT NULL,
	[Name] [char](25) NULL,
	[Брэнд_] [char](20) NOT NULL,
	[Номер_] [char](25) NOT NULL,
	[Name_] [char](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Таблица аналогов_Е]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Таблица аналогов_Е](
	[Брэнд] [char](20) NOT NULL,
	[Номер] [char](25) NOT NULL,
	[Name] [char](25) NULL,
	[Брэнд_] [char](20) NOT NULL,
	[Номер_] [char](25) NOT NULL,
	[Name_] [char](25) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Типы операций]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Типы операций](
	[ID_Операции] [int] IDENTITY(1,1) NOT NULL,
	[Тип операции] [char](50) NOT NULL,
 CONSTRAINT [PK_Типы операций] PRIMARY KEY CLUSTERED 
(
	[ID_Операции] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Удаления с каталога]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Удаления с каталога](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Бренд] [int] NULL,
	[Номер] [char](50) NULL,
	[Пользователь] [char](50) NULL,
	[Время] [datetime] NULL,
 CONSTRAINT [PK_Удаления с каталога] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Brands_Quality_Log] ADD  DEFAULT (getdate()) FOR [Modified_Date]
GO
ALTER TABLE [dbo].[Brands_Quality_Log] ADD  DEFAULT (suser_sname()) FOR [Modified_By]
GO
ALTER TABLE [dbo].[Автомобили клиентов] ADD  CONSTRAINT [DF_Автомобили клиентов_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Автомобили клиентов] ADD  CONSTRAINT [DF_Автомобили клиентов_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Веб-запросы] ADD  CONSTRAINT [DF_Веб-запросы_date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[Веб-запросы] ADD  DEFAULT ((0)) FOR [available]
GO
ALTER TABLE [dbo].[Веб-регистрация] ADD  CONSTRAINT [DF_Веб-регистрация_date]  DEFAULT (getdate()) FOR [date]
GO
ALTER TABLE [dbo].[Внутренний курс валют] ADD  CONSTRAINT [DF_внутр_курс_валют_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Внутренний курс валют] ADD  CONSTRAINT [DF_внутр_курс_валют_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Возвратные накладные] ADD  CONSTRAINT [DF_Возвратные накладные_Сотрудник]  DEFAULT (suser_sname()) FOR [Сотрудник]
GO
ALTER TABLE [dbo].[Возвратные накладные] ADD  CONSTRAINT [DF_Возвратные накладные_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Возвратные накладные] ADD  DEFAULT (0) FOR [Проводка]
GO
ALTER TABLE [dbo].[Заказы поставщикам] ADD  CONSTRAINT [DF_Заказы поставщикам_Полученый]  DEFAULT ((0)) FOR [Полученый]
GO
ALTER TABLE [dbo].[Заказы поставщикам] ADD  CONSTRAINT [DF_Заказы поставщикам_Обработано]  DEFAULT ((0)) FOR [Обработано]
GO
ALTER TABLE [dbo].[Заказы поставщикам] ADD  CONSTRAINT [DF_Заказы поставщикам_Задерживается]  DEFAULT ((0)) FOR [Задерживается]
GO
ALTER TABLE [dbo].[Заказы поставщикам] ADD  CONSTRAINT [DF_Заказы поставщикам_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Заказы поставщикам] ADD  CONSTRAINT [DF_Заказы поставщикам_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Заметки] ADD  CONSTRAINT [DF_Заметки_Дата заметки]  DEFAULT (getdate()) FOR [Дата заметки]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Заказано]  DEFAULT (0) FOR [Заказано]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Подтверждение]  DEFAULT (0) FOR [Подтверждение]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Заказали]  DEFAULT (0) FOR [Заказали]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Без_замен]  DEFAULT (0) FOR [Без_замен]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Нет]  DEFAULT (0) FOR [Нет]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Аналог]  DEFAULT (0) FOR [Филиал]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Доставлено]  DEFAULT (0) FOR [Доставлено]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Обработано]  DEFAULT (0) FOR [Обработано]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Анализ]  DEFAULT (0) FOR [Анализ]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Цена_прихода_грн]  DEFAULT (0) FOR [Цена_прихода_грн]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Цена_прихода_евро]  DEFAULT (0) FOR [Цена_прихода_евро]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Цена_прихода_долл]  DEFAULT (0) FOR [Цена_прихода_долл]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF_Запросы клиентов_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  DEFAULT (0) FOR [Безналичные]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  DEFAULT (0) FOR [Срочно]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  DEFAULT (0) FOR [Возврат]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  CONSTRAINT [DF__Запросы к__Интер__1ADEEA9C]  DEFAULT ((0)) FOR [Интернет]
GO
ALTER TABLE [dbo].[Запросы клиентов] ADD  DEFAULT ((0)) FOR [Задерживается]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Приход_долл]  DEFAULT (0) FOR [Приход_долл]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Приход_грн]  DEFAULT (0) FOR [Приход_грн]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Приход_евро]  DEFAULT (0) FOR [Приход_евро]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Расход_долл]  DEFAULT (0) FOR [Расход_долл]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Расход_грн]  DEFAULT (0) FOR [Расход_грн]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Расход_евро]  DEFAULT (0) FOR [Расход_евро]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Цена]  DEFAULT (0) FOR [Цена]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Грн]  DEFAULT (0) FOR [Грн]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Обработано]  DEFAULT (0) FOR [Обработано]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Касса] ADD  CONSTRAINT [DF_Касса_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Касса] ADD  DEFAULT (0) FOR [Пароль]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_ID_Автомобиля]  DEFAULT (36) FOR [ID_Автомобиля]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_ID_Группы товаров]  DEFAULT (22) FOR [ID_Группы товаров]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_Нет_цены]  DEFAULT (0) FOR [Нет_цены]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_Обработана]  DEFAULT (0) FOR [Обработана]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_Срочно]  DEFAULT (1) FOR [Срочно]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_Исполнитель]  DEFAULT (suser_sname()) FOR [Исполнитель]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталог запчастей_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF_Каталобия]  DEFAULT (0) FOR [Распродажа]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF__Каталог з__Цена___4B973090]  DEFAULT (0) FOR [Цена_обработана]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  CONSTRAINT [DF__Каталог з__Обраб__770B9E7A]  DEFAULT (0) FOR [Обработано_нац_10]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  DEFAULT ((0)) FOR [Контроль]
GO
ALTER TABLE [dbo].[Каталог запчастей] ADD  DEFAULT ((0)) FOR [Remote Warehouse]
GO
ALTER TABLE [dbo].[Каталог_лог] ADD  CONSTRAINT [DF__Каталог_л__Нет_ц__7B4643B2]  DEFAULT (0) FOR [Нет_цены]
GO
ALTER TABLE [dbo].[Каталог_лог] ADD  CONSTRAINT [DF__Каталог_л__Обраб__7C3A67EB]  DEFAULT (0) FOR [Обработана]
GO
ALTER TABLE [dbo].[Каталог_лог] ADD  CONSTRAINT [DF__Каталог_л__Срочн__7D2E8C24]  DEFAULT (1) FOR [Срочно]
GO
ALTER TABLE [dbo].[Каталог_лог] ADD  CONSTRAINT [DF__Каталог_л__Распр__7E22B05D]  DEFAULT (0) FOR [Распродажа]
GO
ALTER TABLE [dbo].[Каталог_лог] ADD  CONSTRAINT [DF__Каталог_л__Цена___7F16D496]  DEFAULT (0) FOR [Цена_обработана]
GO
ALTER TABLE [dbo].[Каталог_лог] ADD  CONSTRAINT [DF_Каталог_лог_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Каталоги поставщиков] ADD  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Клиенты] ADD  CONSTRAINT [DF_Клиенты_Расчет_в_евро]  DEFAULT ((0)) FOR [Расчет_в_евро]
GO
ALTER TABLE [dbo].[Клиенты] ADD  CONSTRAINT [DF_Клиенты_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Клиенты] ADD  CONSTRAINT [DF_Клиенты_Выводить_просрочку]  DEFAULT ((0)) FOR [Выводить_просрочку]
GO
ALTER TABLE [dbo].[Клиенты] ADD  CONSTRAINT [DF_Клиенты_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Клиенты] ADD  DEFAULT ((0)) FOR [Пароль]
GO
ALTER TABLE [dbo].[Клиенты] ADD  CONSTRAINT [DF_Клиенты_Интернет_заказы]  DEFAULT ((0)) FOR [Интернет_заказы]
GO
ALTER TABLE [dbo].[Клиенты_лог] ADD  CONSTRAINT [DF_КлДата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Клиенты_лог] ADD  DEFAULT ((0)) FOR [Пароль]
GO
ALTER TABLE [dbo].[Курс валют] ADD  CONSTRAINT [DF_Курс валют_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Курс валют] ADD  CONSTRAINT [DF_Курс валют_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Напоминания] ADD  CONSTRAINT [DF_Напоминания_Перезвонить]  DEFAULT (0) FOR [Перезвонить]
GO
ALTER TABLE [dbo].[Напоминания] ADD  CONSTRAINT [DF_Напоминания_Отправить]  DEFAULT (0) FOR [Отправить]
GO
ALTER TABLE [dbo].[Напоминания] ADD  CONSTRAINT [DF_Напоминания_Дата_записи]  DEFAULT (getdate()) FOR [Дата_записи]
GO
ALTER TABLE [dbo].[Напоминания] ADD  CONSTRAINT [DF_Напоминания_Прочитано]  DEFAULT (0) FOR [Прочитано]
GO
ALTER TABLE [dbo].[Операции] ADD  CONSTRAINT [DF_Операции_Приход]  DEFAULT (0) FOR [Приход]
GO
ALTER TABLE [dbo].[Операции] ADD  CONSTRAINT [DF_Операции_Расход]  DEFAULT (0) FOR [Расход]
GO
ALTER TABLE [dbo].[Операции] ADD  CONSTRAINT [DF_Операции_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Операции] ADD  CONSTRAINT [DF_Операции_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Операции] ADD  CONSTRAINT [DF_Опер_Приход]  DEFAULT (0) FOR [Цена_закупки]
GO
ALTER TABLE [dbo].[Операции] ADD  CONSTRAINT [DF_Опер_Расход]  DEFAULT (0) FOR [Цена_продажи]
GO
ALTER TABLE [dbo].[Отгрузочные накладные] ADD  CONSTRAINT [DF_Отгрузочные накладные_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Отгрузочные накладные] ADD  CONSTRAINT [DF_Отгрузочные накладные_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Количество]  DEFAULT (0) FOR [Количество]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Цена]  DEFAULT (0) FOR [Цена]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Грн]  DEFAULT (0) FOR [Грн]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Оплачено]  DEFAULT (0) FOR [Добавить]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Обработано]  DEFAULT (0) FOR [Обработано]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Нету]  DEFAULT (0) FOR [Нету]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Работник]  DEFAULT (suser_sname()) FOR [Работник]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Подчиненная накладные_Анализ]  DEFAULT (0) FOR [Анализ]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  CONSTRAINT [DF_Оплата]  DEFAULT (0) FOR [Оплачено]
GO
ALTER TABLE [dbo].[Подчиненная накладные] ADD  DEFAULT (0) FOR [Пароль]
GO
ALTER TABLE [dbo].[Поставщики] ADD  CONSTRAINT [DF__Поставщик__Включ__53385258]  DEFAULT (0) FOR [Включать в прайс]
GO
ALTER TABLE [dbo].[Поставщики] ADD  CONSTRAINT [DF_Поставщики_сотр]  DEFAULT (suser_sname()) FOR [Сотрудник]
GO
ALTER TABLE [dbo].[Поставщики] ADD  CONSTRAINT [DF_Поставщики_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT (1) FOR [Активный]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [Грн]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [Евро]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [Долл]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [Грн_бн]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [Виден только менеджерам]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [Не возвратный]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [IsEnsureDeliveryTerm]
GO
ALTER TABLE [dbo].[Поставщики] ADD  DEFAULT ((0)) FOR [IsQualityGuaranteed]
GO
ALTER TABLE [dbo].[Прейскурант] ADD  CONSTRAINT [DF_Прейскурант_Дата_создания]  DEFAULT (getdate()) FOR [Дата_создания]
GO
ALTER TABLE [dbo].[Проводки] ADD  CONSTRAINT [DF_Проводки_Сумма_грн]  DEFAULT (0) FOR [Сумма_грн]
GO
ALTER TABLE [dbo].[Проводки] ADD  CONSTRAINT [DF_Проводки_Сумма_евро]  DEFAULT (0) FOR [Сумма_евро]
GO
ALTER TABLE [dbo].[Проводки] ADD  CONSTRAINT [DF_Проводки_Сумма_долл]  DEFAULT (0) FOR [Сумма_долл]
GO
ALTER TABLE [dbo].[Проводки] ADD  CONSTRAINT [DF_Проводки_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Проводки] ADD  CONSTRAINT [DF_Проводки_Сотрудник]  DEFAULT (suser_sname()) FOR [Сотрудник]
GO
ALTER TABLE [dbo].[Сотрудники] ADD  DEFAULT (0) FOR [Действующий]
GO
ALTER TABLE [dbo].[Сотрудники] ADD  DEFAULT (0) FOR [Проводки]
GO
ALTER TABLE [dbo].[Сотрудники] ADD  DEFAULT (0) FOR [Касса]
GO
ALTER TABLE [dbo].[Сотрудники] ADD  DEFAULT ((0)) FOR [IsFop]
GO
ALTER TABLE [dbo].[Спец_цены] ADD  CONSTRAINT [DF_Спец_цены_Сотрудник]  DEFAULT (suser_sname()) FOR [Сотрудник]
GO
ALTER TABLE [dbo].[Спец_цены] ADD  CONSTRAINT [DF_Спец_цены_Дата]  DEFAULT (getdate()) FOR [Дата]
GO
ALTER TABLE [dbo].[Brands_Quality]  WITH CHECK ADD  CONSTRAINT [FK_Brand_Quality_REF_Brands] FOREIGN KEY([ID_Брэнда])
REFERENCES [dbo].[Брэнды] ([ID_Брэнда])
GO
ALTER TABLE [dbo].[Brands_Quality] CHECK CONSTRAINT [FK_Brand_Quality_REF_Brands]
GO
ALTER TABLE [dbo].[Brands_Quality_Log]  WITH CHECK ADD  CONSTRAINT [FK_Brands_Quality_Log_REF_Brands] FOREIGN KEY([ID_Брэнда])
REFERENCES [dbo].[Брэнды] ([ID_Брэнда])
GO
ALTER TABLE [dbo].[Brands_Quality_Log] CHECK CONSTRAINT [FK_Brands_Quality_Log_REF_Brands]
GO
ALTER TABLE [dbo].[Автомобили клиентов]  WITH CHECK ADD  CONSTRAINT [FK_Автомобили клиентов_Автомобили] FOREIGN KEY([ID_Марки])
REFERENCES [dbo].[Автомобили] ([ID_Автомобиля])
GO
ALTER TABLE [dbo].[Автомобили клиентов] CHECK CONSTRAINT [FK_Автомобили клиентов_Автомобили]
GO
ALTER TABLE [dbo].[Автомобили клиентов]  WITH CHECK ADD  CONSTRAINT [FK_Автомобили клиентов_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Автомобили клиентов] CHECK CONSTRAINT [FK_Автомобили клиентов_Клиенты]
GO
ALTER TABLE [dbo].[Возвратные накладные]  WITH CHECK ADD  CONSTRAINT [FK_Возвратные накладные_Запросы клиентов] FOREIGN KEY([ID_Запроса])
REFERENCES [dbo].[Запросы клиентов] ([ID_Запроса])
GO
ALTER TABLE [dbo].[Возвратные накладные] CHECK CONSTRAINT [FK_Возвратные накладные_Запросы клиентов]
GO
ALTER TABLE [dbo].[Заказы поставщикам]  WITH CHECK ADD  CONSTRAINT [FK_Заказы поставщикам_Перевозчики] FOREIGN KEY([ID_Перевозчика])
REFERENCES [dbo].[Перевозчики] ([ID_Перевозчика])
GO
ALTER TABLE [dbo].[Заказы поставщикам] CHECK CONSTRAINT [FK_Заказы поставщикам_Перевозчики]
GO
ALTER TABLE [dbo].[Заказы поставщикам]  WITH CHECK ADD  CONSTRAINT [FK_Заказы поставщикам_Поставщики] FOREIGN KEY([ID_Поставщика])
REFERENCES [dbo].[Поставщики] ([ID_Поставщика])
GO
ALTER TABLE [dbo].[Заказы поставщикам] CHECK CONSTRAINT [FK_Заказы поставщикам_Поставщики]
GO
ALTER TABLE [dbo].[Запросы клиентов]  WITH CHECK ADD  CONSTRAINT [FK_Запросы клиентов_Заказы поставщикам] FOREIGN KEY([ID_Заказа])
REFERENCES [dbo].[Заказы поставщикам] ([ID_Заказа])
GO
ALTER TABLE [dbo].[Запросы клиентов] CHECK CONSTRAINT [FK_Запросы клиентов_Заказы поставщикам]
GO
ALTER TABLE [dbo].[Запросы клиентов]  WITH CHECK ADD  CONSTRAINT [FK_Запросы клиентов_Каталог запчастей] FOREIGN KEY([ID_Запчасти])
REFERENCES [dbo].[Каталог запчастей] ([ID_Запчасти])
GO
ALTER TABLE [dbo].[Запросы клиентов] CHECK CONSTRAINT [FK_Запросы клиентов_Каталог запчастей]
GO
ALTER TABLE [dbo].[Запросы клиентов]  WITH CHECK ADD  CONSTRAINT [FK_Запросы клиентов_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Запросы клиентов] CHECK CONSTRAINT [FK_Запросы клиентов_Клиенты]
GO
ALTER TABLE [dbo].[Касса]  WITH CHECK ADD  CONSTRAINT [FK_Касса_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Касса] CHECK CONSTRAINT [FK_Касса_Клиенты]
GO
ALTER TABLE [dbo].[Каталоги поставщиков]  WITH CHECK ADD  CONSTRAINT [FK_Каталоги поставщиков_Поставщики] FOREIGN KEY([ID_Поставщика])
REFERENCES [dbo].[Поставщики] ([ID_Поставщика])
GO
ALTER TABLE [dbo].[Каталоги поставщиков] CHECK CONSTRAINT [FK_Каталоги поставщиков_Поставщики]
GO
ALTER TABLE [dbo].[Клиенты]  WITH CHECK ADD  CONSTRAINT [FK_Клиенты_Тарифные модели] FOREIGN KEY([ID_Модели_тариф])
REFERENCES [dbo].[Тарифные модели] ([ID_Модели_тариф])
GO
ALTER TABLE [dbo].[Клиенты] CHECK CONSTRAINT [FK_Клиенты_Тарифные модели]
GO
ALTER TABLE [dbo].[Напоминания]  WITH CHECK ADD  CONSTRAINT [FK_Напоминания_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Напоминания] CHECK CONSTRAINT [FK_Напоминания_Клиенты]
GO
ALTER TABLE [dbo].[Операции]  WITH CHECK ADD  CONSTRAINT [FK_Операции_Возвратные накладные1] FOREIGN KEY([Id_Возвратной_накладной])
REFERENCES [dbo].[Возвратные накладные] ([ID_Накладной])
GO
ALTER TABLE [dbo].[Операции] CHECK CONSTRAINT [FK_Операции_Возвратные накладные1]
GO
ALTER TABLE [dbo].[Операции]  WITH CHECK ADD  CONSTRAINT [FK_Операции_Запросы клиентов] FOREIGN KEY([Id_Запроса])
REFERENCES [dbo].[Запросы клиентов] ([ID_Запроса])
GO
ALTER TABLE [dbo].[Операции] CHECK CONSTRAINT [FK_Операции_Запросы клиентов]
GO
ALTER TABLE [dbo].[Операции]  WITH CHECK ADD  CONSTRAINT [FK_Операции_Каталог запчастей] FOREIGN KEY([ID_Запчасти])
REFERENCES [dbo].[Каталог запчастей] ([ID_Запчасти])
GO
ALTER TABLE [dbo].[Операции] CHECK CONSTRAINT [FK_Операции_Каталог запчастей]
GO
ALTER TABLE [dbo].[Операции]  WITH CHECK ADD  CONSTRAINT [FK_Операции_Клиенты] FOREIGN KEY([Id_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Операции] CHECK CONSTRAINT [FK_Операции_Клиенты]
GO
ALTER TABLE [dbo].[Операции]  WITH CHECK ADD  CONSTRAINT [FK_Операции_Подчиненная накладные] FOREIGN KEY([Id_Накладной])
REFERENCES [dbo].[Подчиненная накладные] ([ID])
GO
ALTER TABLE [dbo].[Операции] CHECK CONSTRAINT [FK_Операции_Подчиненная накладные]
GO
ALTER TABLE [dbo].[Подчиненная накладные]  WITH CHECK ADD  CONSTRAINT [FK_Подчиненная накладные_Каталог запчастей] FOREIGN KEY([ID_Запчасти])
REFERENCES [dbo].[Каталог запчастей] ([ID_Запчасти])
GO
ALTER TABLE [dbo].[Подчиненная накладные] CHECK CONSTRAINT [FK_Подчиненная накладные_Каталог запчастей]
GO
ALTER TABLE [dbo].[Подчиненная накладные]  WITH CHECK ADD  CONSTRAINT [FK_Подчиненная накладные_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Подчиненная накладные] CHECK CONSTRAINT [FK_Подчиненная накладные_Клиенты]
GO
ALTER TABLE [dbo].[Подчиненная накладные]  WITH CHECK ADD  CONSTRAINT [FK_Подчиненная накладные_Отгрузочные накладные] FOREIGN KEY([ID_Накладной])
REFERENCES [dbo].[Отгрузочные накладные] ([ID_Накладной])
GO
ALTER TABLE [dbo].[Подчиненная накладные] CHECK CONSTRAINT [FK_Подчиненная накладные_Отгрузочные накладные]
GO
ALTER TABLE [dbo].[Проводки]  WITH CHECK ADD  CONSTRAINT [FK_Проводки_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Проводки] CHECK CONSTRAINT [FK_Проводки_Клиенты]
GO
ALTER TABLE [dbo].[Проводки]  WITH CHECK ADD  CONSTRAINT [FK_Проводки_План счетов] FOREIGN KEY([Счет_дебета])
REFERENCES [dbo].[План счетов] ([ID_Счета])
GO
ALTER TABLE [dbo].[Проводки] CHECK CONSTRAINT [FK_Проводки_План счетов]
GO
ALTER TABLE [dbo].[Проводки]  WITH CHECK ADD  CONSTRAINT [FK_Проводки_План счетов1] FOREIGN KEY([Счет_кредита])
REFERENCES [dbo].[План счетов] ([ID_Счета])
GO
ALTER TABLE [dbo].[Проводки] CHECK CONSTRAINT [FK_Проводки_План счетов1]
GO
ALTER TABLE [dbo].[Проводки]  WITH CHECK ADD  CONSTRAINT [FK_Проводки_Поставщики] FOREIGN KEY([ID_Поставщика])
REFERENCES [dbo].[Поставщики] ([ID_Поставщика])
GO
ALTER TABLE [dbo].[Проводки] CHECK CONSTRAINT [FK_Проводки_Поставщики]
GO
ALTER TABLE [dbo].[Проводки]  WITH CHECK ADD  CONSTRAINT [FK_Проводки_Сотрудники] FOREIGN KEY([ID_Сотрудника])
REFERENCES [dbo].[Сотрудники] ([ID_Сотрудника])
GO
ALTER TABLE [dbo].[Проводки] CHECK CONSTRAINT [FK_Проводки_Сотрудники]
GO
ALTER TABLE [dbo].[Спец_цены]  WITH CHECK ADD  CONSTRAINT [FK_Спец_цены_Каталог запчастей] FOREIGN KEY([ID_Запчасти])
REFERENCES [dbo].[Каталог запчастей] ([ID_Запчасти])
GO
ALTER TABLE [dbo].[Спец_цены] CHECK CONSTRAINT [FK_Спец_цены_Каталог запчастей]
GO
ALTER TABLE [dbo].[Спец_цены]  WITH CHECK ADD  CONSTRAINT [FK_Спец_цены_Клиенты] FOREIGN KEY([ID_Клиента])
REFERENCES [dbo].[Клиенты] ([ID_Клиента])
GO
ALTER TABLE [dbo].[Спец_цены] CHECK CONSTRAINT [FK_Спец_цены_Клиенты]
GO
/****** Object:  StoredProcedure [dbo].[BackUpDatabase]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BackUpDatabase] 
	@database varchar(35),
	@path varchar(35)
	AS
	declare @fullpath varchar(55)
	set @fullpath = @path
				+ CAST(DAY(GETDATE()) as CHAR(2))
				+ '-' + CAST(MONTH(GETDATE()) as CHAR(2))
				+ '_' + CAST(REPLACE(CAST(GETDATE() as time(0)),':','-')as CHAR(5))
				+ '.bak'
	
BACKUP DATABASE @database TO DISK = @fullpath 
--WITH 
--   COMPRESSION


GO
/****** Object:  StoredProcedure [dbo].[BackUpLogDatabase]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BackUpLogDatabase] 
	@database varchar(35),
	@path varchar(35)
	AS
	declare @fullpath varchar(35)
	set @fullpath = @path
				+ CAST(DAY(GETDATE()) as CHAR(2))
				+ '-' + CAST(MONTH(GETDATE()) as CHAR(2))
				+ '_' + CAST(REPLACE(CAST(GETDATE() as time(0)),':','-')as CHAR(5))
				+ '_log.bak'
BACKUP LOG @database TO DISK = @fullpath 
GO
/****** Object:  StoredProcedure [dbo].[BEKA]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  PROCEDURE [dbo].[BEKA] AS
BACKUP DATABASE SPARTA to disk = '\\Server\Temp\SPARTA\sprt'
GO
/****** Object:  StoredProcedure [dbo].[BEKA_NOLOG]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[BEKA_NOLOG]  AS
BACKUP LOG SPARTA
GO
/****** Object:  StoredProcedure [dbo].[BEKAL]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[BEKAL] AS
BACKUP LOG SPARTA to disk = 'c:\sprl'
GO
/****** Object:  StoredProcedure [dbo].[changeId]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[changeId]
	-- Add the parameters for the stored procedure here
	@idOld int, 
	@idNew int
AS

declare @sup_1 int, @sup_2 int

select @sup_1 = ID_Поставщика 
from [Каталог запчастей]
where ID_Запчасти = @idOld

select @sup_2 = ID_Поставщика 
from [Каталог запчастей]
where ID_Запчасти = @idNew

if(@sup_1 = @sup_2)
begin

update  [Запросы клиентов] 
set ID_Запчасти = @idNew 
where ID_Запчасти = @idOld

update  [Операции] 
set ID_Запчасти = @idNew 
where ID_Запчасти = @idOld

update  [Подчиненная накладные] 
set ID_Запчасти = @idNew 
where ID_Запчасти = @idOld

delete from [Спец_цены] 
where ID_Запчасти = @idOld

delete from [Прейскурант] 
where ID_Запчасти = @idOld

delete from [Непрямые аналоги] 
where ID_NA = @idOld

delete from [Каталог запчастей] 
where ID_Запчасти = @idOld
end
GO
/****** Object:  StoredProcedure [dbo].[Create name]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Create name] as
Update [Таблица аналогов] set name_ = REPLACE (Номер_, ' ','') 
Update [Таблица аналогов] set name_ = REPLACE (name_, '+','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '-','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '.','')
Update [Таблица аналогов] set name_ = REPLACE (name_, ',','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '+','')
Update [Таблица аналогов] set name_ = REPLACE (name_, ')','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '(','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '*','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '=','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '_','')
Update [Таблица аналогов] set name_ = REPLACE (name_, ':','')
Update [Таблица аналогов] set name_ = REPLACE (name_, ';','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '!','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '\','')
Update [Таблица аналогов] set name_ = REPLACE (name_, '/','')


Update [Таблица аналогов] set name = REPLACE (Номер, ' ','') 
Update [Таблица аналогов] set name = REPLACE (name, '+','')
Update [Таблица аналогов] set name = REPLACE (name, '-','')
Update [Таблица аналогов] set name = REPLACE (name, '.','')
Update [Таблица аналогов] set name = REPLACE (name, ',','')
Update [Таблица аналогов] set name = REPLACE (name, '+','')
Update [Таблица аналогов] set name = REPLACE (name, ')','')
Update [Таблица аналогов] set name = REPLACE (name, '(','')
Update [Таблица аналогов] set name = REPLACE (name, '*','')
Update [Таблица аналогов] set name = REPLACE (name, '=','')
Update [Таблица аналогов] set name = REPLACE (name, '_','')
Update [Таблица аналогов] set name = REPLACE (name, ':','')
Update [Таблица аналогов] set name = REPLACE (name, ';','')
Update [Таблица аналогов] set name = REPLACE (name, '!','')
Update [Таблица аналогов] set name = REPLACE (name, '\','')
Update [Таблица аналогов] set name = REPLACE (name, '/','')
GO
/****** Object:  StoredProcedure [dbo].[CreateIndex]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE  [dbo].[CreateIndex]
as
begin
    PRINT 'CREATE INDEX IN BASE TABLE'
	CREATE NONCLUSTERED INDEX [IX_Name_] ON [dbo].[Таблица аналогов] 
	(
		[Name_] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
	PRINT 'INDEX [IX_Name_] CREATED!'
	CREATE NONCLUSTERED INDEX [IX_Name] ON [dbo].[Таблица аналогов] 
	(
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	PRINT 'INDEX [IX_Name] CREATED!'
	CREATE NONCLUSTERED INDEX [IX_Таблица аналогов] ON [dbo].[Таблица аналогов] 
	(
		[Брэнд] ASC,
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
	PRINT 'INDEX [IX_Таблица аналогов] CREATED!'
	CREATE NONCLUSTERED INDEX [IX_Таблица_аналогов_] ON [dbo].[Таблица аналогов] 
	(
		[Брэнд_] ASC,
		[Name_] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	PRINT 'INDEX [IX_Таблица_аналогов_] CREATED!'

end
GO
/****** Object:  StoredProcedure [dbo].[Defragment_Fragmented_Indexes]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Defragment_Fragmented_Indexes]
   @p_isTask BIT = 0
   WITH
   EXEC AS CALLER
AS
   BEGIN
   DECLARE @v_avg_fragmentation_in_percent INT = 20
   DECLARE @v_page_count INT = 8
   DECLARE @v_current_proc_ID INT = (SELECT ISNULL(MAX(Proc_ID),0) + 1 FROM Tasks.dbo.Index_Defrag_Statistic)
   ----------------------------------------------------------------------------------------------------------
   DECLARE @v_partitioncount   INT
   DECLARE @v_action   VARCHAR (10)
   DECLARE @v_start_time   DATETIME
   DECLARE @v_end_time   DATETIME
   DECLARE @v_object_id   INT
   DECLARE @v_index_id   INT
   DECLARE @v_tableName   VARCHAR (250)
   DECLARE @v_indexName   VARCHAR (250)
   DECLARE @v_defrag   FLOAT
   DECLARE @v_partition_num   INT
   DECLARE @v_fill_factor   INT
   DECLARE @v_sql   NVARCHAR (MAX)

   -- Если запуск процедуры произошол по рассписанию, то уменьшаем размер и степень фрагментации индексов
   IF (@p_isTask = 1)
       BEGIN
          SET @v_avg_fragmentation_in_percent = 30
          SET @v_page_count = 8
       END

   -- Находим все индексы удовлетворяющие нашим условиям и заполняем ими таблицу.
   INSERT INTO tasks.dbo.index_defrag_statistic (proc_id,
                                                 database_id,
                                                 [object_id],
                                                 table_name,
                                                 index_id,
                                                 index_name,
                                                 avg_frag_percent_before,
                                                 fragment_count_before,
                                                 pages_count_before,
                                                 fill_factor,
                                                 partition_num)
   SELECT @v_current_proc_ID,
          dm.database_id,
          dm.[object_id],
          tbl.NAME,
          dm.index_id,
          idx.NAME,
          dm.avg_fragmentation_in_percent,
          dm.fragment_count,
          dm.page_count,
          idx.fill_factor,
          dm.partition_number
   FROM sys.dm_db_index_physical_stats (DB_ID (),
                                        NULL,
                                        NULL,
                                        NULL,
                                        NULL) dm
             INNER JOIN sys.tables tbl
                ON dm.object_id = tbl.object_id
             INNER JOIN sys.indexes idx
                ON dm.object_id = idx.object_id
                   AND dm.index_id = idx.index_id
   WHERE avg_fragmentation_in_percent > @v_avg_fragmentation_in_percent
         AND dm.page_count > @v_page_count
         AND dm.index_id > 0

   IF EXISTS (SELECT * FROM tasks.dbo.Index_Defrag_Statistic WHERE Proc_ID = @v_current_proc_ID)
   BEGIN
   
   DECLARE defragCur CURSOR FOR
            SELECT [object_id],
                   index_id,
                   table_name,
                   index_name,
                   avg_frag_percent_before,
                   fill_factor,
                   partition_num
              FROM tasks.dbo.index_defrag_statistic
             WHERE proc_id = @v_current_proc_ID
            ORDER BY [object_id], index_id DESC 
    
    OPEN defragCur
      FETCH NEXT FROM defragCur   INTO @v_object_id, @v_index_id, @v_tableName, @v_indexName, @v_defrag, @v_fill_factor, @v_partition_num

      WHILE @@FETCH_STATUS = 0
      BEGIN
         SET @v_sql =
                N'ALTER INDEX [' + @v_indexName + '] ON [' + @v_tableName + ']'

         SELECT @v_partitioncount = count (*)
         FROM sys.partitions
         WHERE object_id = @v_object_id AND index_id = @v_index_id;

         IF (@v_fill_factor = 80)
            BEGIN
               SET @v_sql = @v_sql + N' REBUILD WITH (FILLFACTOR = 80)'
               SET @v_action = 'REBUILD 80'
            END
         ELSE
            BEGIN               
               IF (@v_defrag > 30)  --REBUILD 
                  BEGIN
                     SET @v_sql = @v_sql + N' REBUILD'
                     SET @v_action = 'REBUILD'
                  END
               ELSE --REORGINIZE
                  BEGIN
                     SET @v_sql = @v_sql + N' REORGANIZE'
                     SET @v_action = 'REORGANIZE'
                  END
            END

         IF @v_partitioncount > 1
            SET @v_sql =
                     @v_sql
                   + N' PARTITION='
                   + CAST (@v_partition_num AS NVARCHAR (5))

         SET @v_start_time = GETDATE ()

         EXEC sp_executesql @v_sql
         
         SET @v_end_time = GETDATE ()

         UPDATE tasks.dbo.index_defrag_statistic
            SET start_time = @v_start_time,
                end_time = @v_end_time,
                [action] = @v_action
          WHERE     proc_id = @v_current_Proc_ID
                AND [object_id] = @v_object_id
                AND index_id = @v_index_id


         FETCH NEXT FROM defragCur   INTO @v_object_id, @v_index_id, @v_tableName, @v_indexName, @v_defrag, @v_fill_factor, @v_partition_num
      END
      
      CLOSE defragCur
      DEALLOCATE defragCur

      UPDATE tasks.dbo.index_defrag_statistic
         SET avg_frag_percent_after = dm.avg_fragmentation_in_percent,
             fragment_count_after = dm.fragment_count,
             pages_count_after = dm.page_count
        FROM    sys.dm_db_index_physical_stats (DB_ID (),
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL) dm
             INNER JOIN
                tasks.dbo.index_defrag_statistic dba
             ON dm.[object_id] = dba.[object_id]
                AND dm.index_id = dba.index_id
       WHERE dba.proc_id = @v_current_proc_ID AND dm.index_id > 0

   END
   END
GO
/****** Object:  StoredProcedure [dbo].[DEL_0020_UP]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DEL_0020_UP] AS
DELETE dbo.[Запросы клиентов]
WHERE (dbo.[Запросы клиентов].[Обработано] = 0 AND dbo.[Запросы клиентов].ID_Клиента = '378' AND dbo.[Запросы клиентов].Заказано = 0)
GO
/****** Object:  StoredProcedure [dbo].[del_povtor]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[del_povtor]

AS

Declare @first int, @last int
DECLARE a_cursor CURSOR FOR
SELECT MAX(ID_Запчасти), MIN(ID_Запчасти) 
FROM [Каталог запчастей]
GROUP BY ID_Поставщика, ID_Брэнда, [NAME]
HAVING(COUNT(ID_Запчасти) > 1)

OPEN a_cursor

FETCH Next FROM a_cursor
into @first, @last


WHILE @@FETCH_STATUS = 0
BEGIN

update [Подчиненная накладные] SET ID_Запчасти = @last where ID_Запчасти = @first
update [Операции] SET ID_Запчасти = @last where ID_Запчасти = @first
update [Запросы клиентов] SET ID_Запчасти = @last where ID_Запчасти = @first
delete from [Каталог запчастей] where ID_Запчасти = @first

FETCH NEXT FROM a_cursor
into @first, @last

END

CLOSE a_cursor
DEALLOCATE a_cursor



GO
/****** Object:  StoredProcedure [dbo].[DeleteFromMainCatalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteFromMainCatalog]
WITH EXEC AS CALLER
AS
BEGIN

IF EXISTS (SELECT * FROM DataToDelete)
BEGIN
ALTER INDEX [NANE] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [IX_namepost] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [opis] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [nona] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [IX_Каталог запчастей] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [supplier] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [OP_04_IDX] ON [dbo].[Каталог запчастей] DISABLE
ALTER INDEX [OP_IDX_1710] ON [dbo].[Каталог запчастей] DISABLE

DELETE FROM [Sparta].[dbo].[Каталог запчастей]
 WHERE ID_Запчасти IN (SELECT IdToDelete FROM DataToDelete)

ALTER INDEX [NANE] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [IX_namepost] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [opis] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [nona] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [IX_Каталог запчастей] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [supplier] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [OP_04_IDX] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )
ALTER INDEX [OP_IDX_1710] ON [dbo].[Каталог запчастей] REBUILD PARTITION = ALL WITH ( PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, ONLINE = OFF, SORT_IN_TEMPDB = OFF )

TRUNCATE TABLE DataToDelete
END
END
GO
/****** Object:  StoredProcedure [dbo].[DropIndex]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE  [dbo].[DropIndex]
as
begin
    DROP INDEX [IX_Таблица_аналогов_] ON [dbo].[Таблица аналогов];
	DROP INDEX [IX_Таблица аналогов] ON [dbo].[Таблица аналогов];
	DROP INDEX [IX_Name_] ON [dbo].[Таблица аналогов];
	DROP INDEX [IX_Name] ON [dbo].[Таблица аналогов];

end
GO
/****** Object:  StoredProcedure [dbo].[error_kat]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[error_kat] AS
delete from Ошибки_каталога

declare @zapi int, @nomer char(25), @nane char(25)
DECLARE a_cursor CURSOR FOR
SELECT [ID_Запчасти], [Номер запчасти], [NAME] FROM [Каталог запчастей]

OPEN a_cursor

FETCH NEXT FROM a_cursor
into @zapi, @nomer, @nane

WHILE @@FETCH_STATUS = 0
BEGIN

SET @nomer = REPLACE (@nomer, '+','')
SET @nomer = REPLACE (@nomer, '-','')
SET @nomer = REPLACE (@nomer, '=','')
SET @nomer = REPLACE (@nomer, '/','')
SET @nomer = REPLACE (@nomer, '\','')
SET @nomer = REPLACE (@nomer, '.','')
SET @nomer = REPLACE (@nomer, ',','')
SET @nomer = REPLACE (@nomer, '*','')
SET @nomer = REPLACE (@nomer, ':','')
SET @nomer = REPLACE (@nomer, ';','')
SET @nomer = REPLACE (@nomer, '!','')
SET @nomer = REPLACE (@nomer, ' ','')
SET @nomer = REPLACE (@nomer, '(','')
SET @nomer = REPLACE (@nomer, ')','')
SET @nomer = REPLACE (@nomer, '_','')
SET @nomer = REPLACE (@nomer, '@','')

if @nomer <> @nane
begin
insert into Ошибки_каталога (Номер_запчасти,[NAME],[ID_Запчасти]) values (@nomer, @nane, @zapi)
end

FETCH NEXT FROM a_cursor
into @zapi, @nomer, @nane

END

CLOSE a_cursor
DEALLOCATE a_cursor
GO
/****** Object:  StoredProcedure [dbo].[frm_Get_BrandQuality]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[frm_Get_BrandQuality]
@p_Brand_ID INT
WITH EXEC AS CALLER
AS
BEGIN

SELECT bq.Quality_ID, bq.[ID_Брэнда], bq.Brand_Quality
  FROM dbo.Brands_Quality AS bq
 WHERE bq.[ID_Брэнда] = @p_Brand_ID;
 
END
GO
/****** Object:  StoredProcedure [dbo].[frm_Get_BrandsQuality]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[frm_Get_BrandsQuality]
WITH EXEC AS CALLER
AS
BEGIN
      SELECT b.ID_Брэнда,
             LTRIM(RTRIM(b.Брэнд)) AS [Брэнд],
             bq.Quality_ID,
             bq.Brand_Quality
        FROM    dbo.Брэнды AS b
             LEFT JOIN
                dbo.Brands_Quality AS bq
             ON bq.ID_Брэнда = b.ID_Брэнда
      ORDER BY b.Брэнд
   END
GO
/****** Object:  StoredProcedure [dbo].[frm_Get_BrandsQualityStatistics]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[frm_Get_BrandsQualityStatistics]
WITH EXEC AS CALLER
AS
BEGIN
   DECLARE @v_AllBrands   INT;
   DECLARE @v_ProcessedBrands   INT;
   DECLARE @v_ABrands   INT;
   DECLARE @v_BBrands   INT;
   DECLARE @v_CBrands   INT;
   DECLARE @v_OEBrands   INT;

   SET @v_AllBrands = (SELECT COUNT (*) FROM dbo.[Брэнды]);
   SET @v_ABrands =
          (SELECT COUNT (*)
             FROM dbo.Brands_Quality
            WHERE Brand_Quality = 'A');
   SET @v_BBrands =
          (SELECT COUNT (*)
             FROM dbo.Brands_Quality
            WHERE Brand_Quality = 'B');
   SET @v_CBrands =
          (SELECT COUNT (*)
             FROM dbo.Brands_Quality
            WHERE Brand_Quality = 'C');
   SET @v_OEBrands =
          (SELECT COUNT (*)
             FROM dbo.Brands_Quality
            WHERE Brand_Quality = 'OE');


   SELECT @v_AllBrands AS AllBrands,
          @v_ABrands AS ABrands,
          @v_BBrands AS BBrands,
          @v_CBrands AS CBrands,
          @v_OEBrands AS OEBrands,
          @v_ABrands + @v_BBrands + @v_CBrands + @v_OEBrands AS ProcessedBrands,
          @v_AllBrands - (@v_ABrands + @v_BBrands + @v_CBrands + @v_OEBrands) AS NotProcessedBrands
END
GO
/****** Object:  StoredProcedure [dbo].[frm_Upd_BrandQuality]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[frm_Upd_BrandQuality]
@p_Brand_ID INT, @p_Brand_Quality varchar(2)
WITH EXEC AS CALLER
AS
BEGIN

IF EXISTS (SELECT * FROM dbo.Brands_Quality WHERE ID_Брэнда = @p_Brand_ID)
BEGIN
	UPDATE dbo.Brands_Quality SET Brand_Quality = @p_Brand_Quality WHERE ID_Брэнда = @p_Brand_ID;
END
ELSE
BEGIN
	INSERT INTO dbo.Brands_Quality (ID_Брэнда, Brand_Quality) VALUES (@p_Brand_ID, @p_Brand_Quality);
END
END
GO
/****** Object:  StoredProcedure [dbo].[Get_Fragmented_Indexes]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Get_Fragmented_Indexes]
AS
BEGIN
 SET NOCOUNT ON;

BEGIN
   DECLARE @currentProcID   INT

   SELECT @currentProcID = ISNULL (MAX (proc_id), 0) + 1
   FROM tasks.dbo.index_defrag_statistic

   INSERT INTO tasks.dbo.index_defrag_statistic (proc_id,
                                                 database_id,
                                                 [object_id],
                                                 table_name,
                                                 index_id,
                                                 index_name,
                                                 avg_frag_percent_before,
                                                 fragment_count_before,
                                                 pages_count_before,
                                                 fill_factor,
                                                 partition_num)
      SELECT @currentProcID,
             dm.database_id,
             dm.[object_id],
             tbl.NAME,
             dm.index_id,
             idx.NAME,
             dm.avg_fragmentation_in_percent,
             dm.fragment_count,
             dm.page_count,
             idx.fill_factor,
             dm.partition_number
        FROM sys.dm_db_index_physical_stats (DB_ID (),
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL) dm
             INNER JOIN sys.tables tbl
                ON dm.object_id = tbl.object_id
             INNER JOIN sys.indexes idx
                ON dm.object_id = idx.object_id
                   AND dm.index_id = idx.index_id
       WHERE avg_fragmentation_in_percent > 10
             AND dm.index_id > 0
END


END

GO
/****** Object:  StoredProcedure [dbo].[Get_Fragmented_Indexes_new]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Get_Fragmented_Indexes_new]
	@ID INT OUTPUT
AS
BEGIN
 SET NOCOUNT ON;

BEGIN
   DECLARE @currentProcID   INT
   

   SELECT @currentProcID = ISNULL (MAX (proc_id), 0) + 1
   FROM tasks.dbo.index_defrag_statistic

   INSERT INTO tasks.dbo.index_defrag_statistic (proc_id,
                                                 database_id,
                                                 [object_id],
                                                 table_name,
                                                 index_id,
                                                 index_name,
                                                 avg_frag_percent_before,
                                                 fragment_count_before,
                                                 pages_count_before,
                                                 fill_factor,
                                                 partition_num)
      SELECT @currentProcID,
             dm.database_id,
             dm.[object_id],
             tbl.NAME,
             dm.index_id,
             idx.NAME,
             dm.avg_fragmentation_in_percent,
             dm.fragment_count,
             dm.page_count,
             idx.fill_factor,
             dm.partition_number
        FROM sys.dm_db_index_physical_stats (DB_ID (),
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL) dm
             INNER JOIN sys.tables tbl
                ON dm.object_id = tbl.object_id
             INNER JOIN sys.indexes idx
                ON dm.object_id = idx.object_id
                   AND dm.index_id = idx.index_id
       WHERE avg_fragmentation_in_percent > 10
             AND dm.index_id > 0
END

SET @ID = @currentProcID

RETURN @ID
END

GO
/****** Object:  StoredProcedure [dbo].[GetClientDebtEuro]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetClientDebtEuro]
	@klient int
AS
	declare @debtSum decimal(9,2) = 0
	declare @payOffSum decimal(9,2) = 0
	SELECT @payOffSum = ПEвро FROM Проплачено WHERE ID_Клиента= @klient
	SELECT @debtSum = ЕВРО FROM Должок WHERE ID_Клиента=@klient
	
	RETURN (@debtSum - @payOffSum)*100
GO
/****** Object:  StoredProcedure [dbo].[GetClientDebtUAH]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetClientDebtUAH]
	@klient int
AS
	declare @debtSum decimal(9,2) = 0
	declare @payOffSum decimal(9,2) = 0
	SELECT @payOffSum = ПГрн FROM Проплачено WHERE ID_Клиента= @klient
	SELECT @debtSum = Грн FROM Должок WHERE ID_Клиента=@klient
	
	RETURN (@debtSum - @payOffSum)*100
GO
/****** Object:  StoredProcedure [dbo].[GetInputPriceBySparesId]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetInputPriceBySparesId]
	@sparesId int
AS
	SELECT        dbo.[Цена последнего прихода].*
	FROM            dbo.[Цена последнего прихода]
	WHERE        (ID_Запчасти = @sparesId)
GO
/****** Object:  StoredProcedure [dbo].[GetInvoice]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetInvoice]
@klient int
   
AS
SELECT        TOP (50) Брэнды.Брэнд, [Каталог запчастей].[Номер запчасти], [Каталог запчастей].Описание, [Подчиненная накладные].Количество, 
                         [Подчиненная накладные].Цена, [Подчиненная накладные].Грн, [Подчиненная накладные].Дата_закрытия, 
                         [Подчиненная накладные].ID_Накладной
FROM            [Подчиненная накладные] INNER JOIN
                         [Каталог запчастей] ON [Подчиненная накладные].ID_Запчасти = [Каталог запчастей].ID_Запчасти INNER JOIN
                         Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда
WHERE        ([Подчиненная накладные].Дата_закрытия IS NOT NULL) AND ([Подчиненная накладные].ID_Клиента = @klient) AND (DATEDIFF(day, 
                         [Подчиненная накладные].Дата_закрытия, GETDATE()) < 31)
ORDER BY [Подчиненная накладные].Дата_закрытия DESC
GO
/****** Object:  StoredProcedure [dbo].[GetNacenka]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNacenka]
@NAC int
AS
BEGIN
SELECT  dbo.[Каталог запчастей].ID_Запчасти, 
	dbo.Поставщики.[Сокращенное название] AS Поставщик, 
	dbo.Брэнды.Брэнд, 
	dbo.[Каталог запчастей].[Номер запчасти], 
	(dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки AS Опт, 
	(dbo.Спец_цены.Цена - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки AS Спец, 
	dbo.Клиенты.VIP, 
	dbo.[Каталог запчастей].Обработано_нац_10 AS Обработана
FROM         dbo.Клиенты INNER JOIN
                      dbo.Спец_цены ON dbo.Клиенты.ID_Клиента = dbo.Спец_цены.ID_Клиента RIGHT OUTER JOIN
                      dbo.[Склад сумма_2] INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.[Склад сумма_2].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика ON 
                      dbo.Спец_цены.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE     ((dbo.[Каталог запчастей].Цена7 - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки < @NAC) OR
                      ((dbo.Спец_цены.Цена - dbo.[Склад сумма_2].Цена_закупки) * 100 / dbo.[Склад сумма_2].Цена_закупки < @NAC)
END
GO
/****** Object:  StoredProcedure [dbo].[GetOrdering]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOrdering]
@klient int
   
AS

SELECT        dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].Описание, dbo.[Запросы клиентов].Заказано, 
                         dbo.[Запросы клиентов].Подтверждение, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Дата
                         , dbo.[Запросы клиентов].[Без_замен], dbo.[Запросы клиентов].[Нет], dbo.[Запросы клиентов].[Альтернатива]
FROM            dbo.[Запросы клиентов] INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
WHERE        (dbo.[Запросы клиентов].ID_Клиента = @klient) AND (dbo.[Запросы клиентов].Обработано = 0)
union
SELECT        dbo.Брэнды.Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].Описание, dbo.[Запросы клиентов].Заказано, 
                         dbo.[Запросы клиентов].Подтверждение, dbo.[Запросы клиентов].Цена, dbo.[Запросы клиентов].Грн, dbo.[Запросы клиентов].Дата
                         , dbo.[Запросы клиентов].[Без_замен], dbo.[Запросы клиентов].[Нет], dbo.[Запросы клиентов].[Альтернатива]
FROM            dbo.[Запросы клиентов] INNER JOIN
                         dbo.[Каталог запчастей] ON dbo.[Запросы клиентов].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти INNER JOIN
                         dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда
WHERE        (dbo.[Запросы клиентов].ID_Клиента = @klient) AND (dbo.[Запросы клиентов].Обработано = 1) 
						AND (dbo.[Запросы клиентов].Нет = 1) AND (DATEDIFF(day, dbo.[Запросы клиентов].Дата_заказа, GETDATE()) < 4)
GO
/****** Object:  StoredProcedure [dbo].[GetOurPriceBySupplierSparesId]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOurPriceBySupplierSparesId] 
	@sparesId int
AS

SELECT     dbo.[Каталог запчастей].Цена7 AS Цена
FROM         dbo.[Каталоги поставщиков] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд INNER JOIN
                      dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда AND 
                      dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost AND 
                      dbo.[Каталоги поставщиков].ID_Поставщика = dbo.[Каталог запчастей].ID_Поставщика
WHERE     (dbo.[Каталоги поставщиков].ID_Запчасти = @sparesId)
GO
/****** Object:  StoredProcedure [dbo].[GetReservation]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[GetReservation]
@klient int
   
AS

SELECT        Брэнды.Брэнд, [Каталог запчастей].[Номер запчасти], [Каталог запчастей].Описание, [Подчиненная накладные].Количество, 
                         [Подчиненная накладные].Цена, [Подчиненная накладные].Грн, [Подчиненная накладные].Дата, [Подчиненная накладные].Статус
FROM            [Подчиненная накладные] INNER JOIN
                         [Каталог запчастей] ON [Подчиненная накладные].ID_Запчасти = [Каталог запчастей].ID_Запчасти INNER JOIN
                         Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда
WHERE        ([Подчиненная накладные].ID_Клиента = @klient) AND ([Подчиненная накладные].Обработано = 0)
GO
/****** Object:  StoredProcedure [dbo].[GetUserListStatistic]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserListStatistic]
	@startDate char(19),	@finishDate char(19)
AS
	SELECT dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, COUNT(dbo.[Веб-запросы].ID_Query) AS Queries, LEFT(@startDate, 10) AS StartDate, LEFT(@finishDate, 10) AS FinishDate,
           SUM(CAST(dbo.[Веб-запросы].success AS int)) AS Success, ISNULL(QueryTable.Orderes, 0) AS Orderes, ISNULL(ReservTable.Reserves, 0) AS Reserves
	FROM dbo.[Веб-запросы] INNER JOIN
         dbo.Клиенты ON dbo.[Веб-запросы].vip = dbo.Клиенты.VIP LEFT OUTER JOIN
            (SELECT ID_Клиента, COUNT(ID_Запроса) AS Orderes
            FROM dbo.[Запросы клиентов]
            WHERE (Дата < CONVERT(DATETIME, @finishDate, 102)) AND (Дата > CONVERT(DATETIME, @startDate, 102)) AND (Интернет = 1)
            GROUP BY ID_Клиента
            HAVING(ID_Клиента <> 378)) AS QueryTable ON dbo.Клиенты.ID_Клиента = QueryTable.ID_Клиента LEFT OUTER JOIN
            (SELECT ID_Клиента, COUNT(ID) AS Reserves
            FROM dbo.[Подчиненная накладные]
            WHERE (Дата < CONVERT(DATETIME, @finishDate, 102)) AND (Дата > CONVERT(DATETIME, @startDate, 102)) AND (Статус = 'internet')
            GROUP BY ID_Клиента
            HAVING (ID_Клиента <> 378)) AS ReservTable ON dbo.Клиенты.ID_Клиента = ReservTable.ID_Клиента
	WHERE (dbo.[Веб-запросы].date < CONVERT(DATETIME, @finishDate, 102)) AND (dbo.[Веб-запросы].date > CONVERT(DATETIME, @startDate, 102))
	GROUP BY dbo.Клиенты.ID_Клиента, dbo.Клиенты.VIP, QueryTable.Orderes, ReservTable.Reserves
	ORDER BY Queries DESC
GO
/****** Object:  StoredProcedure [dbo].[GoKlient]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GoKlient]
@vip char(10)    
AS

SELECT ID_Клиента, VIP, RTRIM(Фамилия) + '  ' + RTRIM(Имя) AS ФИО, 
Расчет_в_евро, dbo.[Тарифные модели].Столбец, Интернет_заказы, Выводить_просрочку, [Количество_дней]
FROM Клиенты INNER JOIN [Тарифные модели] ON Клиенты.ID_Модели_тариф = [Тарифные модели].ID_Модели_тариф
WHERE (VIP LIKE @vip)
GO
/****** Object:  StoredProcedure [dbo].[ImportNewRecordToTableAnalogs]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bass
-- Create date: 30/07/2011
-- Description:	import new row to Analogs table
-- =============================================
CREATE PROCEDURE  [dbo].[ImportNewRecordToTableAnalogs]
	@dbName varchar(20), 
	@tableName varchar(20), 
	@description varchar(10)
AS
BEGIN
	PRINT 'ADD COLUMN'
	EXEC('alter table [' + @dbName + '].[dbo].[' + @tableName + '] add Name char(25) null');	
	EXEC('alter table [' + @dbName + '].[dbo].[' + @tableName + '] add Name_ char(25) null');	
	
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = LEFT(Номер_, 25)');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = LEFT(Номер, 25)');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Брэнд_ = LEFT(Брэнд_, 20)');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Брэнд = LEFT(Брэнд, 20)');
	
	
	PRINT 'REWRITE Name_ column'
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, '' '','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''+'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''-'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''.'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, '','','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, '')'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''('','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''*'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''_'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, '';'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, '':'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''!'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''/'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name_ = REPLACE (Name_, ''\'','''')');
	
	PRINT 'REWRITE Name column'
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, '' '','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''+'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''-'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''.'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, '','','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, '')'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''('','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''*'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''_'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, '';'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, '':'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''!'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''/'','''')');
	EXEC('update [' + @dbName + '].[dbo].[' + @tableName + '] set Name = REPLACE (Name, ''\'','''')');
	
	PRINT 'DELETE INDEX IN BASE TABLE'
	DROP INDEX [IX_Таблица_аналогов_] ON [dbo].[Таблица аналогов];
	DROP INDEX [IX_Таблица аналогов] ON [dbo].[Таблица аналогов];
	DROP INDEX [IX_Name_] ON [dbo].[Таблица аналогов];
	DROP INDEX [IX_Name] ON [dbo].[Таблица аналогов];
	
	PRINT 'INSERT DATA TO BASE TABLE'
	EXEC('INSERT INTO [dbo].[Таблица аналогов](Брэнд, Номер, Name, 
		Брэнд_, Номер_, Name_, Примечание) SELECT LEFT(Брэнд, 20), LEFT(Номер, 25), Name, 
		LEFT(Брэнд_, 20), LEFT(Номер_, 25), Name_,''' + @description + '''
		FROM [' + @dbName + '].[dbo].[' + @tableName + '] WHERE (Брэнд IS NOT NULL) and (Номер IS NOT NULL)
		and (Брэнд_ IS NOT NULL) and (Номер_ IS NOT NULL)');
	
	PRINT 'CREATE INDEX IN BASE TABLE'
	CREATE NONCLUSTERED INDEX [IX_Name_] ON [dbo].[Таблица аналогов] 
	(
		[Name_] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
	PRINT 'INDEX [IX_Name_] CREATED!'
	CREATE NONCLUSTERED INDEX [IX_Name] ON [dbo].[Таблица аналогов] 
	(
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	PRINT 'INDEX [IX_Name] CREATED!'
	CREATE NONCLUSTERED INDEX [IX_Таблица аналогов] ON [dbo].[Таблица аналогов] 
	(
		[Брэнд] ASC,
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
	PRINT 'INDEX [IX_Таблица аналогов] CREATED!'
	CREATE NONCLUSTERED INDEX [IX_Таблица_аналогов_] ON [dbo].[Таблица аналогов] 
	(
		[Брэнд_] ASC,
		[Name_] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)
	PRINT 'INDEX [IX_Таблица_аналогов_] CREATED!'
END
GO
/****** Object:  StoredProcedure [dbo].[InOrderListBySupplierSparesId]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InOrderListBySupplierSparesId] 
	@sparesId int
AS

SELECT     dbo.Клиенты.VIP, dbo.Поставщики.[Сокращенное название], Брэнды_1.Брэнд, [Каталог запчастей_1].[Номер запчасти], dbo.[Запросы клиентов].Заказано, 
                      dbo.[Запросы клиентов].Альтернатива, dbo.[Запросы клиентов].Дата_заказа, dbo.[Запросы клиентов].Срочно, 
                      dbo.[Заказы поставщикам].Предварительная_дата
FROM         (SELECT     MAX(dbo.[Каталог запчастей].ID_аналога) AS analogId
                       FROM          dbo.[Каталоги поставщиков] INNER JOIN
                                              dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд INNER JOIN
                                              dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда AND 
                                              dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost
                       WHERE      (dbo.[Каталоги поставщиков].ID_Запчасти = @sparesId)) AS AnalogTable INNER JOIN
                      dbo.[Каталог запчастей] AS [Каталог запчастей_1] ON AnalogTable.analogId = [Каталог запчастей_1].ID_аналога INNER JOIN
                      dbo.[Запросы клиентов] ON [Каталог запчастей_1].ID_Запчасти = dbo.[Запросы клиентов].ID_Запчасти INNER JOIN
                      dbo.Клиенты ON dbo.[Запросы клиентов].ID_Клиента = dbo.Клиенты.ID_Клиента INNER JOIN
                      dbo.Брэнды AS Брэнды_1 ON [Каталог запчастей_1].ID_Брэнда = Брэнды_1.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON [Каталог запчастей_1].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.[Заказы поставщикам] ON dbo.[Запросы клиентов].ID_Заказа = dbo.[Заказы поставщикам].ID_Заказа
WHERE     (dbo.[Запросы клиентов].Заказано <> 0) AND (dbo.[Запросы клиентов].Доставлено = 0) AND (dbo.[Запросы клиентов].Обработано = 0)

GO
/****** Object:  StoredProcedure [dbo].[InsertBrend]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[InsertBrend]
@brend char(18),
@id int out
   
AS
insert into Брэнды(Брэнд)values(@brend)
set @id = cast(SCOPE_IDENTITY() as int)



GO
/****** Object:  StoredProcedure [dbo].[InsertOrder]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[InsertOrder]
@klientId int,
@sparesId int,
@quantity int,
@price decimal(9,2),
@priceUah decimal(9,2),
@notAnalog bit,
@internet bit,
@sotrudnik char(20),
@arrivalDate datetime
   
AS
insert into [Запросы клиентов] 
			(ID_Клиента, ID_Запчасти, Заказано, Цена, грн, Без_замен, Интернет, Работник, Дата_прихода)
            values (@klientId, @sparesId, @quantity, @price, @priceUah, @notAnalog, @internet, @sotrudnik, @arrivalDate)
GO
/****** Object:  StoredProcedure [dbo].[InsertRegistration]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertRegistration]
@login varchar(5),
@pass        varchar(10),
@ipaddress       varchar(16),
@success       bit,
@RegistrationID	      int OUTPUT
AS

INSERT INTO [Веб-регистрация]
  ([login], pass, ipaddress, success) 
  VALUES (@login, @pass, @ipaddress, @success);

SET @RegistrationID = @@IDENTITY


GO
/****** Object:  StoredProcedure [dbo].[InsertReservation]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertReservation]
@klient_id int,
@spares_id int,
@price decimal(9,2),
@priceUah decimal(9,2),
@quantity int,
@status char(50),
@customer char(20), 
@reservationID int OUTPUT
AS
INSERT INTO [Подчиненная накладные]
  (ID_Клиента, ID_Запчасти, Цена, Грн, Количество, Статус, Работник) 
  VALUES (@klient_id, @spares_id, @price, @priceUah, @quantity, @status, @customer);

SET @reservationID = @@IDENTITY

GO
/****** Object:  StoredProcedure [dbo].[InsertSpares]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[InsertSpares]
@supplierId int,
@brendId int,
@number char(25),
@supplierNumber char(25),
@analogId int,
@description char(80),
@price decimal(9,2),
@sotrudnik char(20),
@id int out
   
AS


insert into [Каталог запчастей] (ID_Поставщика, ID_брэнда, 
	[номер запчасти], [Номер поставщика], ID_Аналога, Описание, Цена, Исполнитель)
							values (@supplierId, @brendId, 
            @number, @supplierNumber, @analogId, @description, @price, @sotrudnik)

set @id = cast(SCOPE_IDENTITY() as int)



GO
/****** Object:  StoredProcedure [dbo].[InsertSparesAnalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertSparesAnalog]
@supplierId int,
@brendId int,
@number char(25),
@supplierNumber char(25),
@analogId int,
@description char(80),
@price decimal(9,2),
@sotrudnik char(20),
@groupId int,
@autoId int,
@control bit,
@id int out

   
AS


insert into [Каталог запчастей] (ID_Поставщика, ID_брэнда, 
	[номер запчасти], [Номер поставщика], ID_Автомобиля, [ID_Группы товаров], 
	ID_Аналога, Описание, Цена, Исполнитель, Контроль)
							values (@supplierId, @brendId, 
            @number, @supplierNumber, @autoId, @groupId, @analogId, @description, 
            @price, @sotrudnik, @control)

set @id = cast(SCOPE_IDENTITY() as int)

GO
/****** Object:  StoredProcedure [dbo].[InsertWebQuery]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertWebQuery]
@vip varchar(5),
@query        varchar(50),
@ipaddress       varchar(16),
@success       bit,
@QueryID	      int OUTPUT
AS
INSERT INTO [Веб-запросы]
  (vip, ipaddress, query, success) 
  VALUES (@vip, @ipaddress, @query, @success);

SET @QueryID = @@IDENTITY
GO
/****** Object:  StoredProcedure [dbo].[konvert]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[konvert] 
	@schot int, 
	@postavsik int,
	@sotrudnik int,

	@usd_in decimal(9,2),
	@uah_in decimal(9,2),
	@eur_in decimal(9,2),
	
	@usd_out decimal(9,2),
	@uah_out decimal(9,2),
	@eur_out decimal(9,2),
	@nom int
	
AS
BEGIN
Declare @nomer int
if @nom IS Null
begin
SELECT   @nomer = ISNULL(MAX(Convert_ID), 0) + 1 
FROM         dbo.Проводки
end
else
begin
set @nomer = @nom
end
insert into Проводки(ID_Поставщика, ID_Сотрудника, Счет_дебета, Счет_кредита, Сумма_грн, Сумма_евро, Сумма_долл, Примечание, Пароль,Convert_ID)
values(@postavsik, @sotrudnik, 39, @schot, @uah_in, @eur_in, @usd_in, 'Конвертация валюты', 'sqlserver ', @nomer)
insert into Проводки(ID_Поставщика, ID_Сотрудника, Счет_дебета, Счет_кредита, Сумма_грн, Сумма_евро, Сумма_долл, Примечание, Пароль,Convert_ID)
values(@postavsik, @sotrudnik, @schot, 39, @uah_out, @eur_out, @usd_out, 'Конвертация валюты', 'sqlserver ', @nomer)

END





GO
/****** Object:  StoredProcedure [dbo].[KursEuro]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KursEuro]
@kurs decimal(9,2) output    
AS
declare @id_kurs int
SELECT     @id_kurs = MAX(ID_Курса) 
FROM         dbo.[Курс валют]

SELECT @kurs = евро 
FROM [Курс валют] 
where ID_Курса = @id_kurs

GO
/****** Object:  StoredProcedure [dbo].[OBNORA]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  PROCEDURE [dbo].[OBNORA] AS
declare @oras as integer
declare @a as integer
DECLARE a_cursor CURSOR FOR
SELECT [ID_Запчасти] FROM [Каталог запчастей]
ORDER BY [NAME]
set @oras =1
OPEN a_cursor

FETCH NEXT FROM a_cursor
into @a

WHILE @@FETCH_STATUS = 0
BEGIN

update [Каталог запчастей]
set [ID] = @oras
where [ID_Запчасти] = @a
set @oras = @oras + 1
FETCH NEXT FROM a_cursor
into @a
END

CLOSE a_cursor
DEALLOCATE a_cursor
GO
/****** Object:  StoredProcedure [dbo].[old_Defragment_Fragmented_Indexes]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[old_Defragment_Fragmented_Indexes]
   @currentProcID INT
AS
   BEGIN
      SET  NOCOUNT ON;
      
      
      
      DECLARE @partitioncount   INT
      DECLARE @action   VARCHAR (10)
      DECLARE @start_time   DATETIME
      DECLARE @end_time   DATETIME
      DECLARE @object_id   INT
      DECLARE @index_id   INT
      DECLARE @tableName   VARCHAR (250)
      DECLARE @indexName   VARCHAR (250)
      DECLARE @defrag   FLOAT
      DECLARE @partition_num   INT
      DECLARE @fill_factor   INT
      DECLARE @sql   NVARCHAR (MAX)

      DECLARE
         defragCur CURSOR FOR
            SELECT [object_id],
                   index_id,
                   table_name,
                   index_name,
                   avg_frag_percent_before,
                   fill_factor,
                   partition_num
              FROM tasks.dbo.index_defrag_statistic
             WHERE proc_id = @currentProcID
            ORDER BY [object_id], index_id DESC 

      OPEN defragCur
      FETCH NEXT FROM defragCur   INTO @object_id, @index_id, @tableName, @indexName, @defrag, @fill_factor, @partition_num

      WHILE @@FETCH_STATUS = 0
      BEGIN
         SET @sql =
                N'ALTER INDEX [' + @indexName + '] ON [' + @tableName + ']'

         SELECT @partitioncount = count (*)
         FROM sys.partitions
         WHERE object_id = @object_id AND index_id = @index_id;

         IF (@fill_factor = 80)
            BEGIN
               SET @sql = @sql + N' REBUILD WITH (FILLFACTOR = 80)'
               SET @action = 'REBUILD 80'
            END
         ELSE
            BEGIN               
               IF (@defrag > 30)  --REBUILD 
                  BEGIN
                     SET @sql = @sql + N' REBUILD'
                     SET @action = 'REBUILD 90'
                  END
               ELSE --REORGINIZE
                  BEGIN
                     SET @sql = @sql + N' REORGANIZE'
                     SET @action = 'REORGANIZE'
                  END
            END

         IF @partitioncount > 1
            SET @sql =
                     @sql
                   + N' PARTITION='
                   + CAST (@partition_num AS NVARCHAR (5))

         SET @start_time = GETDATE ()

         EXEC sp_executesql @sql
         
         SET @end_time = GETDATE ()

         UPDATE tasks.dbo.index_defrag_statistic
            SET start_time = @start_time,
                end_time = @end_time,
                [action] = @action
          WHERE     proc_id = @currentProcID
                AND [object_id] = @object_id
                AND index_id = @index_id


         FETCH NEXT FROM defragCur   INTO @object_id, @index_id, @tableName, @indexName, @defrag, @fill_factor, @partition_num
      END

      CLOSE defragCur
      DEALLOCATE defragCur

      UPDATE tasks.dbo.index_defrag_statistic
         SET avg_frag_percent_after = dm.avg_fragmentation_in_percent,
             fragment_count_after = dm.fragment_count,
             pages_count_after = dm.page_count
        FROM    sys.dm_db_index_physical_stats (DB_ID (),
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL) dm
             INNER JOIN
                tasks.dbo.index_defrag_statistic dba
             ON dm.[object_id] = dba.[object_id]
                AND dm.index_id = dba.index_id
       WHERE dba.proc_id = @currentProcID AND dm.index_id > 0
   END
GO
/****** Object:  StoredProcedure [dbo].[OurAnalogByOurAnalogId]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[OurAnalogByOurAnalogId] 
	@analogId int
AS
SELECT     TOP (100) PERCENT dbo.[Каталог запчастей].ID_Запчасти, dbo.Поставщики.[Сокращенное название], dbo.Брэнды.Брэнд, 
                      dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].Цена7 AS Опт, dbo.[Каталог запчастей].Цена AS Розница, dbo.[Каталог запчастей].Скидка, 
                      IsNull(dbo.Остаток_.Остаток, 0) as Остаток
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON dbo.[Каталог запчастей].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.Остаток_ ON dbo.[Каталог запчастей].ID_Запчасти = dbo.Остаток_.ID_Запчасти
WHERE     (dbo.[Каталог запчастей].ID_аналога = @analogId)

GO
/****** Object:  StoredProcedure [dbo].[OurAnalogBySupplierSparesId]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OurAnalogBySupplierSparesId] 
	@sparesId int
AS

SELECT     TOP (100) PERCENT [Каталог запчастей_1].ID_Запчасти, dbo.Поставщики.[Сокращенное название], Брэнды_1.Брэнд, [Каталог запчастей_1].[Номер запчасти], 
                      [Каталог запчастей_1].Цена7 AS Oпт, [Каталог запчастей_1].Цена AS Розница, [Каталог запчастей_1].Скидка, IsNull(dbo.Остаток_.Остаток, 0) as Остаток
FROM         (SELECT     MAX(dbo.[Каталог запчастей].ID_аналога) AS analogId
                       FROM          dbo.[Каталоги поставщиков] INNER JOIN
                                              dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд INNER JOIN
                                              dbo.[Каталог запчастей] ON dbo.Брэнды.ID_Брэнда = dbo.[Каталог запчастей].ID_Брэнда AND 
                                              dbo.[Каталоги поставщиков].Name = dbo.[Каталог запчастей].namepost
                       WHERE      (dbo.[Каталоги поставщиков].ID_Запчасти = @sparesId)) AS AnalogTable INNER JOIN
                      dbo.[Каталог запчастей] AS [Каталог запчастей_1] ON AnalogTable.analogId = [Каталог запчастей_1].ID_аналога INNER JOIN
                      dbo.Брэнды AS Брэнды_1 ON [Каталог запчастей_1].ID_Брэнда = Брэнды_1.ID_Брэнда INNER JOIN
                      dbo.Поставщики ON [Каталог запчастей_1].ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                      dbo.Остаток_ ON [Каталог запчастей_1].ID_Запчасти = dbo.Остаток_.ID_Запчасти
GO
/****** Object:  StoredProcedure [dbo].[Preyskurant]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Preyskurant]
@kurs_euro decimal(9,2)	
AS
BEGIN
	delete from Прейскурант
	Insert into Прейскурант(ID_Запчасти, Брэнд, Номер, Цена) 
	Select ID_Запчасти, Брэнд, [Номер запчасти], Цена*@kurs_euro
	from Создание_прейскуранта 
END
GO
/****** Object:  StoredProcedure [dbo].[PROCER]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE        PROCEDURE [dbo].[PROCER] 
@post varchar(5), @obr bit, @obra bit
AS
declare @v decimal(10,9)
declare @M Decimal(10,9)
declare @S decimal(10,9)
declare @K decimal(10,9)
declare @U decimal(10,9)
DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 2

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена1 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена1=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена1=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена1=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена1=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)

DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 3

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена2 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена2=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена2=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена2=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена2=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 4

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена3 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена3=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена3=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена3=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена3=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 5

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена4 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена4=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена4=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена4=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена4=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 6

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена5 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена5=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена5=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена5=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена5=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 7

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена6 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена6=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена6=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена6=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена6=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)

DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 8

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена7 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена7=(1-(1-@V )*Скидка/35)*Цена 
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена7=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена7=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена7=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 9

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена8 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена8=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена8=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена8=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена8=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 10

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена9 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена9=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена9=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена9=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена9=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)




DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 11

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set [Цена10] = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set [Цена10] = (1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set [Цена10] = (1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set [Цена10] = (1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set [Цена10] = (1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 12

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена11 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена11=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена11=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена11=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена11=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 13

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена12 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена12=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена12=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена12=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена12=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)

DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 15

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена13 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена13=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена13=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена13=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена13=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)



DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 15

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена14 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена14=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена14=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена14=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)
update [Каталог запчастей]
set Цена14=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))and([Id_Поставщика] = @post)




GO
/****** Object:  StoredProcedure [dbo].[PROCER_]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE         PROCEDURE [dbo].[PROCER_] 
@obr bit, @obra bit
AS
declare @v decimal(10,9)
declare @M Decimal(10,9)
declare @S decimal(10,9)
declare @K decimal(10,9)
declare @U decimal(10,9)
DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 2

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена1 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена1=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена1=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена1=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена1=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))

DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 3

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена2 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена2=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена2=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена2=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена2=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 4

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена3 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена3=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена3=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена3=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена3=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 5

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена4 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена4=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена4=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена4=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена4=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 6

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена5 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена5=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена5=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена5=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена5=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 7

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена6 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена6=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена6=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена6=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена6=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))

DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 8

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена7 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена7=(1-(1-@V )*Скидка/35)*Цена 
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена7=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена7=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена7=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 9

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена8 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена8=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена8=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена8=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена8=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 10

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена9 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена9=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена9=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена9=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена9=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))




DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 11

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set [Цена10] = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена10] = (1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена10] = (1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена10] = (1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена10] = (1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 12

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set [Цена11] = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена11]=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена11]=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена11]=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена11]=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))


DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 13

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set [Цена12] = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена12]=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена12]=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена12]=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set [Цена12]=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))

DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 15

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена13 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена13=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена13=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена13=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена13=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))



DECLARE A_cur cursor
read_only
for select Скидка_V,Скидка_M1,Скидка_Si,Скидка_Koni, Скидка_Универсал  from [тарифные модели] WHERE id_Модели_тариф = 15

open A_cur
FETCH FROM A_cur
INTO @v,@M,@S,@K,@U
CLOSE A_cur
DEALLOCATE A_cur

update [Каталог запчастей]
set Цена14 = (1-(1-@M )*Скидка/35)*Цена
where (Id_Поставщика = 2)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена14=(1-(1-@V )*Скидка/35)*Цена
where (Id_Поставщика = 3)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена14=(1-(1-@S )*Скидка/35)*Цена
where (Id_Поставщика = 1)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена14=(1-(1-@K )*Скидка/35)*Цена
where (Id_Поставщика = 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))
update [Каталог запчастей]
set Цена14=(1-(1-@U )*Скидка/35)*Цена
where (Id_Поставщика <> 1)and(Id_Поставщика <> 2)and(Id_Поставщика <> 3)and(Id_Поставщика <> 4)and((Цена_обработана = @obr)or(Цена_обработана = @obra))





GO
/****** Object:  StoredProcedure [dbo].[PropertyInsideKatalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PropertyInsideKatalog]

AS
SELECT     dbo.Поставщики.[Сокращенное название], SUM(TAB.Kolvo) AS Kolvo, SUM(TAB.anQuantity) + ISNULL(MAX(ANNUL.Kolvo), 0) - 1 AS Kolivo
FROM         (SELECT     COUNT(ID_Запчасти) AS Kolvo, ID_Поставщика, ID_Аналога, 1 AS anQuantity
                       FROM          dbo.[Каталог запчастей]
                       GROUP BY ID_Поставщика, ID_Аналога) AS TAB INNER JOIN
                      dbo.Поставщики ON TAB.ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                          (SELECT     ID_Поставщика, COUNT(ID_Запчасти) AS Kolvo
                            FROM          dbo.[Каталог запчастей] AS [Каталог запчастей]
                            WHERE      (ID_Аналога IS NULL)
                            GROUP BY ID_Поставщика) AS ANNUL ON TAB.ID_Поставщика = ANNUL.ID_Поставщика
GROUP BY TAB.ID_Поставщика, dbo.Поставщики.[Сокращенное название]
HAVING      (SUM(TAB.Kolvo) > 1000)
ORDER BY Kolvo DESC
GO
/****** Object:  StoredProcedure [dbo].[PropertySuppliersPrice]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PropertySuppliersPrice]

AS
SELECT     dbo.Поставщики.[Сокращенное название], SUM(TAB.Kolvo) AS Kolvo, SUM(TAB.anQuantity) + ISNULL(MAX(ANNUL.Kolvo), 0) - 1 AS Kolivo
FROM         (SELECT     COUNT(ID_Запчасти) AS Kolvo, ID_Поставщика, ID_Аналога, 1 AS anQuantity
                       FROM          dbo.[Каталоги поставщиков]
                       GROUP BY ID_Поставщика, ID_Аналога) AS TAB INNER JOIN
                      dbo.Поставщики ON TAB.ID_Поставщика = dbo.Поставщики.ID_Поставщика LEFT OUTER JOIN
                          (SELECT     ID_Поставщика, COUNT(ID_Запчасти) AS Kolvo
                            FROM          dbo.[Каталоги поставщиков] AS [Каталоги поставщиков_1]
                            WHERE      (ID_Аналога IS NULL)
                            GROUP BY ID_Поставщика) AS ANNUL ON TAB.ID_Поставщика = ANNUL.ID_Поставщика
GROUP BY TAB.ID_Поставщика, dbo.Поставщики.[Сокращенное название]
ORDER BY Kolvo DESC
GO
/****** Object:  StoredProcedure [dbo].[Razbezhnosti]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Razbezhnosti]
AS

delete from [Разбежности номеров]

insert into dbo.[Разбежности номеров]

SELECT     dbo.[Каталоги поставщиков].Брэнд, dbo.[Каталог запчастей].[Номер запчасти], dbo.[Каталог запчастей].[Номер поставщика], 
                      dbo.[Каталоги поставщиков].[Номер запчасти] AS Номер, dbo.[Каталоги поставщиков].[Номер поставщика] AS Номер_поставщика, 
                      dbo.Поставщики.[Сокращенное название] AS Поставщик
FROM         dbo.[Каталог запчастей] INNER JOIN
                      dbo.Брэнды ON dbo.[Каталог запчастей].ID_Брэнда = dbo.Брэнды.ID_Брэнда INNER JOIN
                      dbo.[Каталоги поставщиков] ON dbo.Брэнды.Брэнд = dbo.[Каталоги поставщиков].Брэнд AND 
                      dbo.[Каталог запчастей].namepost = dbo.[Каталоги поставщиков].Name AND 
                      dbo.[Каталог запчастей].[Номер запчасти] <> dbo.[Каталоги поставщиков].[Номер поставщика] AND 
                      dbo.[Каталог запчастей].ID_Поставщика = dbo.[Каталоги поставщиков].ID_Поставщика INNER JOIN
                      dbo.Поставщики ON dbo.[Каталоги поставщиков].ID_Поставщика = dbo.Поставщики.ID_Поставщика
GO
/****** Object:  StoredProcedure [dbo].[ResetAllPriceForSparesById]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ResetAllPriceForSparesById] 
	@sparesId int
AS

Update  dbo.[Каталог запчастей] set
Цена = Null, 
Цена1 = Null, 
Цена2 = Null, 
Цена3 = Null, 
Цена4 = Null, 
Цена5 = Null, 
Цена6 = Null, 
Цена7 = Null, 
Цена8 = Null, 
Цена9 = Null, 
Цена10 = Null, 
Цена11 = Null, 
Цена12 = Null, 
Цена13 = Null, 
Цена14 = Null, 
Цена15 = Null, 
Цена16 = Null, 
Цена17 = Null, 
Обработана = 0,
Цена_обработана = 0,
Скидка = Null
WHERE     (ID_Запчасти = @sparesId)
GO
/****** Object:  StoredProcedure [dbo].[SalesAnalyzReview]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SalesAnalyzReview]	
	AS
	Select * from [Анализ продаж аналог__0]
	
GO
/****** Object:  StoredProcedure [dbo].[SalesAnalyzTranzit]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SalesAnalyzTranzit]	
	AS
	Select * from [Анализ продаж аналог транзит]
GO
/****** Object:  StoredProcedure [dbo].[SalesHistory]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SalesHistory]
	
	@klientId int 
	
AS
if @klientId <>378
begin
	Select * from [Архив клиента] 
	
WHERE     (ID_Клиента = @klientId) AND (DATEDIFF(day, Дата_закрытия, GETDATE()) < 700)
end
else 
begin
Select top 200 * from [Архив клиента] 
	
WHERE     (ID_Клиента = @klientId) AND (DATEDIFF(day, Дата_закрытия, GETDATE()) < 100)
order by Дата_закрытия desc 
end
GO
/****** Object:  StoredProcedure [dbo].[SelectBrend]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SelectBrend]
@brend char(18),
@id int out 
   
AS

SELECT    @id = ID_Брэнда
FROM      Брэнды
WHERE     (Брэнд LIKE @brend)
 if (@@ROWCOUNT = 0) set @id = 0




GO
/****** Object:  StoredProcedure [dbo].[SelectInternetOrders]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectInternetOrders]

AS
	SELECT        ID_Поставщика, RTRIM(Поставщик) AS Поставщик, Количество as Количество
FROM            (SELECT        TOP (100) PERCENT Поставщики.ID_Поставщика, Поставщики.[Сокращенное название] AS Поставщик, 
                                                    COUNT([Запросы клиентов].ID_Запроса) AS Количество
                          FROM            [Запросы клиентов] INNER JOIN
                                                    [Каталог запчастей] ON [Запросы клиентов].ID_Запчасти = [Каталог запчастей].ID_Запчасти INNER JOIN
                                                    Поставщики ON [Каталог запчастей].ID_Поставщика = Поставщики.ID_Поставщика
                          WHERE        ([Запросы клиентов].Интернет = 1) AND ([Запросы клиентов].Обработано = 0) AND ([Запросы клиентов].Заказано > 0) AND 
                                                    ([Запросы клиентов].Подтверждение = 0)AND (dbo.[Запросы клиентов].ID_Клиента <> 378) 
                          GROUP BY Поставщики.[Сокращенное название], Поставщики.ID_Поставщика
                          ) AS derivedtbl_1
GO
/****** Object:  StoredProcedure [dbo].[SelectOrdersBySupplier]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SelectOrdersBySupplier]
	@supplier int
AS

SELECT     [Каталог запчастей].ID_Поставщика, [Запросы клиентов].Работник, Брэнды.Брэнд, [Каталог запчастей].[Номер запчасти], 
                      [Запросы клиентов].Заказано, [Запросы клиентов].Цена, [Запросы клиентов].Дата, ISNULL(Остаток_по_аналогу.Остаток,0) as Остаток
FROM         [Каталог запчастей] INNER JOIN
                     [Запросы клиентов] ON [Каталог запчастей].ID_Запчасти = [Запросы клиентов].ID_Запчасти INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда LEFT OUTER JOIN
                      Остаток_по_аналогу ON [Каталог запчастей].ID_аналога = Остаток_по_аналогу.ID_аналога
WHERE     ([Запросы клиентов].Подтверждение = 0) AND ([Запросы клиентов].Интернет = 1) AND ([Запросы клиентов].Обработано = 0) AND 
                      ([Запросы клиентов].Заказано > 0) AND ([Запросы клиентов].ID_Клиента <> 378) AND ([Каталог запчастей].ID_Поставщика = @supplier)
ORDER BY [Запросы клиентов].Дата DESC

GO
/****** Object:  StoredProcedure [dbo].[SelectQueryByUser]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectQueryByUser]
@vip char(5),
@startDate char(10),
@endDate char(10)   
AS

SELECT         Query, [date] as querydate, Success, vip, available, brend, nomer
FROM            dbo.[Веб-запросы]
WHERE        ((date >= CONVERT(char(10), @startDate, 102) AND date <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(date) = YEAR(CONVERT(char(10), @startDate, 102))) AND 
							(MONTH(date) = MONTH(CONVERT(char(10), @startDate, 102))) AND 
								(DAY(date) = DAY(CONVERT(char(10), @startDate, 102))) OR
									(YEAR(date) = YEAR(CONVERT(char(10), @endDate, 102))) AND 
										(MONTH(date) = MONTH(CONVERT(char(10), @endDate, 102))) AND 
											(DAY(date) = DAY(CONVERT(char(10), @endDate, 102)))) AND vip=@vip AND ((brend IS NOT NULL)or(Success = 0))



ORDER By [date] DESC
GO
/****** Object:  StoredProcedure [dbo].[SelectQueryGroup]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectQueryGroup]
@startDate char(10),
@endDate char(10)   
AS

SELECT        vip, COUNT(ID_Query) AS Query, SUM(CASE success WHEN 1 THEN 1 WHEN 0 THEN 0 END) AS Success
FROM            dbo.[Веб-запросы]
WHERE        (date >= CONVERT(char(10), @startDate, 102) AND date <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(date) = YEAR(CONVERT(char(10), @startDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @startDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @startDate, 102))) OR
							  (YEAR(date) = YEAR(CONVERT(char(10), @endDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @endDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @endDate, 102)))

GROUP BY vip
ORDER BY Query DESC
GO
/****** Object:  StoredProcedure [dbo].[SelectRegistrationGroup]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectRegistrationGroup]
@startDate char(10),
@endDate char(10)   
AS

SELECT        [login], COUNT(ID_registration) AS Registration, SUM(CASE success WHEN 1 THEN 1 WHEN 0 THEN 0 END) AS Success
FROM            dbo.[Веб-регистрация]
WHERE        (date >= CONVERT(char(10), @startDate, 102) AND date <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(date) = YEAR(CONVERT(char(10), @startDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @startDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @startDate, 102))) OR
							  (YEAR(date) = YEAR(CONVERT(char(10), @endDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @endDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @endDate, 102)))
GROUP BY [login]
ORDER BY Registration DESC
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesAnalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectSparesAnalog]
@brend char(18),
@name char(25),
@analog int,
@klient int
   
AS
SELECT Id_Запчасти,
		Брэнд, 
		[Сокращенное название],
		[Номер поставщика] as [Номер запчасти],
          isnull(Цена, 0) as Цена, 
            Доступно = CASE WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0 ELSE ISnull(Остаток, 0) - isnull(Количество, 0) End,
            isnull(Количество,0) as Резерв, 
            Описание,
            null as Заказ, 
            null as Срок, 
            Цена1 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена1, 0) ELSE MAX(Спец_цена) END,
            Цена2 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена2, 0) ELSE MAX(Спец_цена) END,
            Цена3 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена3, 0) ELSE MAX(Спец_цена) END,
            Цена4 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена4, 0) ELSE MAX(Спец_цена) END,
            Цена5 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена5, 0) ELSE MAX(Спец_цена) END,
            Цена6 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена6, 0) ELSE MAX(Спец_цена) END,
            Цена7 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена7, 0) ELSE MAX(Спец_цена) END,
            Цена8 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена8, 0) ELSE MAX(Спец_цена) END,
            Цена9 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена9, 0) ELSE MAX(Спец_цена) END,
            Цена10 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена10, 0) ELSE MAX(Спец_цена) END,
            Цена11 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена11, 0) ELSE MAX(Спец_цена) END,
            Цена12 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена12, 0) ELSE MAX(Спец_цена) END,
            Цена13 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена13, 0) ELSE MAX(Спец_цена) END,
            Цена14 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена14, 0) ELSE MAX(Спец_цена) END,
            Цена15 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена15, 0) ELSE MAX(Спец_цена) END,
			Цена16 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена16, 0) ELSE MAX(Спец_цена) END,
			Цена17 = CASE WHEN MAX(ID_Клиента)is Null then isnull(Цена17, 0) ELSE MAX(Спец_цена) END,
			null as Дата,
			[Не возвратный],
			[Виден только менеджерам],
			IsEnsureDeliveryTerm,
			IsQualityGuaranteed,
			CASE WHEN IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle, 
            CASE WHEN IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM Поисковая 
WHERE ID_Аналога = @analog And (ID_Клиента = @klient or ID_Клиента is null) and 
            (((CASE WHEN isnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0 ELSE ISnull(Остаток, 0) - isnull(Количество, 0) End <> 0))
            or (isnull(Количество,0) <> 0))
GROUP BY  ID_Запчасти, Цена, Брэнд, [Номер поставщика], [Сокращенное название], Описание, ID_аналога, Остаток, Количество, ID_Клиента,
            Цена1, Цена2, Цена3, Цена4, Цена5, Цена6, Цена7, Цена8, Цена9, Цена10, Цена11, Цена12,
            Цена13, Цена14, Цена15, Цена16, Цена17, [Не возвратный], [Виден только менеджерам], IsEnsureDeliveryTerm, IsQualityGuaranteed,
			CASE WHEN IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
            CASE WHEN IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END
union
SELECT     
	ISNULL([Каталоги поставщиков_1].ID_Запчасти, [Каталоги поставщиков].ID_Запчасти) AS ID_Запчасти,
	ISNULL([Каталоги поставщиков_1].Брэнд, [Каталоги поставщиков].Брэнд) AS Брэнд, 
	ISNULL(Поставщики_1.[Сокращенное название], Поставщики.[Сокращенное название]) AS [Сокращенное название],   
	ISNULL([Каталоги поставщиков_1].[Номер запчасти], [Каталоги поставщиков].[Номер запчасти]) AS [Номер запчасти], 
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена],[Каталоги поставщиков].[Цена]), 0) AS Цена,
	0 AS Доступно, 
	0 AS Резерв, 
	ISNULL([Каталоги поставщиков_1].Описание, [Каталоги поставщиков].Описание) AS Описание,
	ISNULL([Каталоги поставщиков_1].Наличие, [Каталоги поставщиков].Наличие) AS Заказ,
	ISNULL([Каталоги поставщиков_1].[Срок доставки], [Каталоги поставщиков].[Срок доставки]) AS Срок,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена1],[Каталоги поставщиков].[Цена1]), 0) AS Цена1,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена2],[Каталоги поставщиков].[Цена2]), 0) AS Цена2,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена3],[Каталоги поставщиков].[Цена3]), 0) AS Цена3,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена4],[Каталоги поставщиков].[Цена4]), 0) AS Цена4,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена5],[Каталоги поставщиков].[Цена5]), 0) AS Цена5,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена6],[Каталоги поставщиков].[Цена6]), 0) AS Цена6,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена7],[Каталоги поставщиков].[Цена7]), 0) AS Цена7,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена8],[Каталоги поставщиков].[Цена8]), 0) AS Цена8,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена9],[Каталоги поставщиков].[Цена9]), 0) AS Цена9,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена10],[Каталоги поставщиков].[Цена10]), 0) AS Цена10,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена11],[Каталоги поставщиков].[Цена11]), 0) AS Цена11,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена12],[Каталоги поставщиков].[Цена12]), 0) AS Цена12,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена13],[Каталоги поставщиков].[Цена13]), 0) AS Цена13,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена14],[Каталоги поставщиков].[Цена14]), 0) AS Цена14,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена15],[Каталоги поставщиков].[Цена15]), 0) AS Цена15,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена16],[Каталоги поставщиков].[Цена16]), 0) AS Цена16,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена17],[Каталоги поставщиков].[Цена17]), 0) AS Цена17,
	ISNULL([Каталоги поставщиков_1].Дата, [Каталоги поставщиков].Дата) AS Дата,
	ISNULL(Поставщики_1.[Не возвратный], Поставщики.[Не возвратный]) AS [Не возвратный],
	ISNULL(Поставщики_1.[Виден только менеджерам], Поставщики.[Виден только менеджерам]) AS [Виден только менеджерам],
	ISNULL(Поставщики_1.[IsEnsureDeliveryTerm], Поставщики.[IsEnsureDeliveryTerm]) AS IsEnsureDeliveryTerm,
	ISNULL(Поставщики_1.[IsQualityGuaranteed], Поставщики.[IsQualityGuaranteed]) AS IsQualityGuaranteed,
	CASE WHEN ISNULL(Поставщики_1.[IsEnsureDeliveryTerm], Поставщики.[IsEnsureDeliveryTerm]) = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
    CASE WHEN ISNULL(Поставщики_1.[IsQualityGuaranteed], Поставщики.[IsQualityGuaranteed])  = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle 
FROM [Каталоги поставщиков] AS [Каталоги поставщиков_1] INNER JOIN
     Поставщики AS Поставщики_1 ON [Каталоги поставщиков_1].ID_Поставщика = Поставщики_1.ID_Поставщика 
		RIGHT OUTER JOIN  (SELECT     Брэнд_, Name_, Брэнд, [Name] FROM [Таблица аналогов]
		UNION SELECT @brend, @name, @brend, @name) as ANALOGI INNER JOIN
     [Каталоги поставщиков] ON ANALOGI.Брэнд_ = [Каталоги поставщиков].Брэнд AND 
     ANALOGI.Name_ = [Каталоги поставщиков].Name INNER JOIN
      Поставщики ON [Каталоги поставщиков].ID_Поставщика = Поставщики.ID_Поставщика ON 
     [Каталоги поставщиков_1].ID_Аналога = [Каталоги поставщиков].ID_Аналога AND 
     [Каталоги поставщиков_1].ID_Поставщика = [Каталоги поставщиков].ID_Поставщика

WHERE     (ANALOGI.[Name] = @name) AND 
			(ANALOGI.Брэнд = @brend)


UNION
SELECT     
	ISNULL([Каталоги поставщиков_1].ID_Запчасти, [Каталоги поставщиков].ID_Запчасти) AS ID_Запчасти,
	ISNULL([Каталоги поставщиков_1].Брэнд, [Каталоги поставщиков].Брэнд) AS Брэнд, 
	ISNULL(Поставщики_1.[Сокращенное название], Поставщики.[Сокращенное название]) AS [Сокращенное название],   
	ISNULL([Каталоги поставщиков_1].[Номер запчасти], [Каталоги поставщиков].[Номер запчасти]) AS [Номер запчасти], 
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена],[Каталоги поставщиков].[Цена]), 0) AS Цена,
	0 AS Доступно, 
	0 AS Резерв, 
	ISNULL([Каталоги поставщиков_1].Описание, [Каталоги поставщиков].Описание) AS Описание,
	ISNULL([Каталоги поставщиков_1].Наличие, [Каталоги поставщиков].Наличие) AS Заказ,
	ISNULL([Каталоги поставщиков_1].[Срок доставки], [Каталоги поставщиков].[Срок доставки]) AS Срок,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена1],[Каталоги поставщиков].[Цена1]), 0) AS Цена1,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена2],[Каталоги поставщиков].[Цена2]), 0) AS Цена2,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена3],[Каталоги поставщиков].[Цена3]), 0) AS Цена3,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена4],[Каталоги поставщиков].[Цена4]), 0) AS Цена4,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена5],[Каталоги поставщиков].[Цена5]), 0) AS Цена5,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена6],[Каталоги поставщиков].[Цена6]), 0) AS Цена6,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена7],[Каталоги поставщиков].[Цена7]), 0) AS Цена7,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена8],[Каталоги поставщиков].[Цена8]), 0) AS Цена8,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена9],[Каталоги поставщиков].[Цена9]), 0) AS Цена9,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена10],[Каталоги поставщиков].[Цена10]), 0) AS Цена10,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена11],[Каталоги поставщиков].[Цена11]), 0) AS Цена11,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена12],[Каталоги поставщиков].[Цена12]), 0) AS Цена12,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена13],[Каталоги поставщиков].[Цена13]), 0) AS Цена13,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена14],[Каталоги поставщиков].[Цена14]), 0) AS Цена14,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена15],[Каталоги поставщиков].[Цена15]), 0) AS Цена15,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена16],[Каталоги поставщиков].[Цена16]), 0) AS Цена16,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена17],[Каталоги поставщиков].[Цена17]), 0) AS Цена17,
	ISNULL([Каталоги поставщиков_1].Дата, [Каталоги поставщиков].Дата) AS Дата,
	ISNULL(Поставщики_1.[Не возвратный], Поставщики.[Не возвратный]) AS [Не возвратный],
	ISNULL(Поставщики_1.[Виден только менеджерам], Поставщики.[Виден только менеджерам]) AS [Виден только менеджерам],
	ISNULL(Поставщики_1.[IsEnsureDeliveryTerm], Поставщики.[IsEnsureDeliveryTerm]) AS IsEnsureDeliveryTerm,
	ISNULL(Поставщики_1.[IsQualityGuaranteed], Поставщики.[IsQualityGuaranteed]) AS IsQualityGuaranteed,
	CASE WHEN ISNULL(Поставщики_1.IsEnsureDeliveryTerm, Поставщики.IsEnsureDeliveryTerm) = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
    CASE WHEN ISNULL(Поставщики_1.IsQualityGuaranteed, Поставщики.IsQualityGuaranteed) = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle 
FROM [Каталоги поставщиков] AS [Каталоги поставщиков_1] INNER JOIN
     Поставщики AS Поставщики_1 ON [Каталоги поставщиков_1].ID_Поставщика = Поставщики_1.ID_Поставщика 
		RIGHT OUTER JOIN  (SELECT     Брэнд_, Name_, Брэнд, [Name] FROM [Таблица аналогов]
		UNION SELECT @brend, @name, @brend, @name) as ANALOGI  INNER JOIN
     [Каталоги поставщиков] ON [ANALOGI].Брэнд = [Каталоги поставщиков].Брэнд AND 
     [ANALOGI].Name = [Каталоги поставщиков].Name INNER JOIN
      Поставщики ON [Каталоги поставщиков].ID_Поставщика = Поставщики.ID_Поставщика ON 
     [Каталоги поставщиков_1].ID_Аналога = [Каталоги поставщиков].ID_Аналога AND 
     [Каталоги поставщиков_1].ID_Поставщика = [Каталоги поставщиков].ID_Поставщика

WHERE     ([ANALOGI].[Name_] = @name) AND 
			([ANALOGI].Брэнд_ = @brend)


UNION
 
 
SELECT      isnull([Каталоги поставщиков_1].Id_Запчасти, [Каталоги_поставщиков].Id_Запчасти) as Id_Запчасти,  
			isnull([Каталоги поставщиков_1].Брэнд, [Каталоги_поставщиков].Брэнд) as Брэнд, 
			isnull([Каталоги поставщиков_1].[Сокращенное название], [Каталоги_поставщиков].[Сокращенное название]) as [Сокращенное название], 
			isnull([Каталоги поставщиков_1].[Номер запчасти],[Каталоги_поставщиков].[Номер запчасти]) as [Номер запчасти], 
			isnull(isnull([Каталоги поставщиков_1].Цена,[Каталоги_поставщиков].Цена), 0) as Цена, 
            0 AS Доступно, 
			0 AS Резерв, 
			isnull([Каталоги поставщиков_1].Описание,[Каталоги_поставщиков].Описание) as Описание, 
			isnull([Каталоги поставщиков_1].Наличие, [Каталоги_поставщиков].Наличие) as Заказ, 
			isnull(isnull([Каталоги поставщиков_1].[Срок доставки],[Каталоги_поставщиков].[Срок доставки]), 0) as Срок, 
            isnull(isnull([Каталоги поставщиков_1].Цена1,[Каталоги_поставщиков].Цена1), 0) as Цена1, 
			isnull(isnull([Каталоги поставщиков_1].Цена2,[Каталоги_поставщиков].Цена2), 0) as Цена2, 
			isnull(isnull([Каталоги поставщиков_1].Цена3,[Каталоги_поставщиков].Цена3), 0) as Цена3, 			
			isnull(isnull([Каталоги поставщиков_1].Цена4,[Каталоги_поставщиков].Цена4), 0) as Цена4, 
			isnull(isnull([Каталоги поставщиков_1].Цена5,[Каталоги_поставщиков].Цена5), 0) as Цена5, 
			isnull(isnull([Каталоги поставщиков_1].Цена6,[Каталоги_поставщиков].Цена6), 0) as Цена6, 
			isnull(isnull([Каталоги поставщиков_1].Цена7,[Каталоги_поставщиков].Цена7), 0) as Цена7, 
			isnull(isnull([Каталоги поставщиков_1].Цена8,[Каталоги_поставщиков].Цена8), 0) as Цена8, 
			isnull(isnull([Каталоги поставщиков_1].Цена9,[Каталоги_поставщиков].Цена9), 0) as Цена9, 
			isnull(isnull([Каталоги поставщиков_1].Цена10,[Каталоги_поставщиков].Цена10), 0) as Цена10, 
			isnull(isnull([Каталоги поставщиков_1].Цена11,[Каталоги_поставщиков].Цена11), 0) as Цена11, 
			isnull(isnull([Каталоги поставщиков_1].Цена12,[Каталоги_поставщиков].Цена12), 0) as Цена12, 
			isnull(isnull([Каталоги поставщиков_1].Цена13,[Каталоги_поставщиков].Цена13), 0) as Цена13, 
			isnull(isnull([Каталоги поставщиков_1].Цена14,[Каталоги_поставщиков].Цена14), 0) as Цена14, 
			isnull(isnull([Каталоги поставщиков_1].Цена15,[Каталоги_поставщиков].Цена15), 0) as Цена15, 
			isnull(isnull([Каталоги поставщиков_1].Цена16,[Каталоги_поставщиков].Цена16), 0) as Цена16, 
			isnull(isnull([Каталоги поставщиков_1].Цена17,[Каталоги_поставщиков].Цена17), 0) as Цена17,
			ISNULL([Каталоги поставщиков_1].Дата, [Каталоги_поставщиков].Дата) AS Дата,
			ISNULL([Каталоги поставщиков_1].[Не возвратный], [Каталоги_поставщиков].[Не возвратный]) AS [Не возвратный],
			ISNULL([Каталоги поставщиков_1].[Виден только менеджерам], [Каталоги_поставщиков].[Виден только менеджерам]) AS [Виден только менеджерам],
			ISNULL([Каталоги поставщиков_1].[IsEnsureDeliveryTerm], [Каталоги_поставщиков].[IsEnsureDeliveryTerm]) AS IsEnsureDeliveryTerm,
			ISNULL([Каталоги поставщиков_1].[IsQualityGuaranteed], [Каталоги_поставщиков].[IsQualityGuaranteed]) AS IsQualityGuaranteed,
			CASE WHEN ISNULL([Каталоги поставщиков_1].[IsEnsureDeliveryTerm], [Каталоги_поставщиков].[IsEnsureDeliveryTerm]) = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
            CASE WHEN ISNULL([Каталоги поставщиков_1].[IsQualityGuaranteed], [Каталоги_поставщиков].[IsQualityGuaranteed]) = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle 
FROM        [Каталог запчастей] INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда INNER JOIN
                      [Каталоги_поставщиков] ON Брэнды.Брэнд = [Каталоги_поставщиков].Брэнд AND 
                      [Каталог запчастей].namepost = [Каталоги_поставщиков].Name LEFT OUTER JOIN
                      [Каталоги_поставщиков] AS [Каталоги поставщиков_1] ON [Каталоги_поставщиков].ID_Аналога = [Каталоги поставщиков_1].ID_Аналога AND 
                      [Каталоги_поставщиков].ID_Поставщика = [Каталоги поставщиков_1].ID_Поставщика
WHERE     ([Каталог запчастей].ID_аналога = @analog)
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesByBrendAndNumber]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SelectSparesByBrendAndNumber]
@brendId int,
@name char(25)
   
AS

SELECT    *
FROM         dbo.[Каталог запчастей]
WHERE     (ID_Брэнда LIKE @brendId and [namepost] like @name)



GO
/****** Object:  StoredProcedure [dbo].[SelectSparesByBrendAndNumberAndSupplier]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SelectSparesByBrendAndNumberAndSupplier]
@brendId int,
@name char(25),
@supplierId int
   
AS

SELECT    *
FROM         dbo.[Каталог запчастей]
WHERE     (ID_Брэнда LIKE @brendId) and ([namepost] like @name) and (ID_Поставщика like @supplierId)


GO
/****** Object:  StoredProcedure [dbo].[SelectSparesByBrendNumberAndSupplierFromSuppliersKatalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SelectSparesByBrendNumberAndSupplierFromSuppliersKatalog]
	@brandId int,
	@specialNumber char(25),
	@supplierId int
AS
SELECT        dbo.[Каталоги поставщиков].*
FROM            dbo.[Каталоги поставщиков] INNER JOIN
                         dbo.Брэнды ON dbo.[Каталоги поставщиков].Брэнд = dbo.Брэнды.Брэнд
WHERE        (dbo.[Каталоги поставщиков].ID_Поставщика = @supplierId) AND 
				(dbo.[Каталоги поставщиков].Name = @specialNumber) AND 
				(dbo.Брэнды.ID_Брэнда = @brandId)
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesById]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[SelectSparesById]
@id int   
AS

SELECT        dbo.[Каталог запчастей].*
FROM            dbo.[Каталог запчастей]
WHERE        (ID_Запчасти = @id)
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesByIdFromSuppliersKatalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SelectSparesByIdFromSuppliersKatalog]
@id int
   
AS

SELECT        dbo.[Каталоги поставщиков].*, dbo.Поставщики.OrderDays, dbo.Поставщики.OrderTime
FROM            dbo.[Каталоги поставщиков] INNER JOIN
                         dbo.Поставщики ON dbo.[Каталоги поставщиков].ID_Поставщика = dbo.Поставщики.ID_Поставщика
WHERE     (ID_Запчасти = @id)
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesByIdOutside]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectSparesByIdOutside]
	@kod int
AS
	SELECT        Брэнд, [Name]
FROM            dbo.[Каталоги поставщиков]
WHERE        (ID_Запчасти = @kod)
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesByTableAnalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectSparesByTableAnalog]
@brend char(18),
@name char(25),
@klient int

   
AS
SELECT     
	ISNULL([Каталоги поставщиков_1].ID_Запчасти, [Каталоги поставщиков].ID_Запчасти) AS ID_Запчасти,
	ISNULL([Каталоги поставщиков_1].Брэнд, [Каталоги поставщиков].Брэнд) AS Брэнд, 
	ISNULL(Поставщики_1.[Сокращенное название], Поставщики.[Сокращенное название]) AS [Сокращенное название],   
	ISNULL([Каталоги поставщиков_1].[Номер запчасти], [Каталоги поставщиков].[Номер запчасти]) AS [Номер запчасти], 
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена],[Каталоги поставщиков].[Цена]), 0) AS Цена,
	0 AS Доступно, 
	0 AS Резерв, 
	ISNULL([Каталоги поставщиков_1].Описание, [Каталоги поставщиков].Описание) AS Описание,
	ISNULL([Каталоги поставщиков_1].Наличие, [Каталоги поставщиков].Наличие) AS Заказ,
	ISNULL([Каталоги поставщиков_1].[Срок доставки], [Каталоги поставщиков].[Срок доставки]) AS Срок,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена1],[Каталоги поставщиков].[Цена1]), 0) AS Цена1,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена2],[Каталоги поставщиков].[Цена2]), 0) AS Цена2,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена3],[Каталоги поставщиков].[Цена3]), 0) AS Цена3,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена4],[Каталоги поставщиков].[Цена4]), 0) AS Цена4,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена5],[Каталоги поставщиков].[Цена5]), 0) AS Цена5,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена6],[Каталоги поставщиков].[Цена6]), 0) AS Цена6,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена7],[Каталоги поставщиков].[Цена7]), 0) AS Цена7,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена8],[Каталоги поставщиков].[Цена8]), 0) AS Цена8,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена9],[Каталоги поставщиков].[Цена9]), 0) AS Цена9,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена10],[Каталоги поставщиков].[Цена10]), 0) AS Цена10,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена11],[Каталоги поставщиков].[Цена11]), 0) AS Цена11,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена12],[Каталоги поставщиков].[Цена12]), 0) AS Цена12,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена13],[Каталоги поставщиков].[Цена13]), 0) AS Цена13,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена14],[Каталоги поставщиков].[Цена14]), 0) AS Цена14,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена15],[Каталоги поставщиков].[Цена15]), 0) AS Цена15,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена16],[Каталоги поставщиков].[Цена16]), 0) AS Цена16,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена17],[Каталоги поставщиков].[Цена17]), 0) AS Цена17,
	ISNULL([Каталоги поставщиков_1].Дата, [Каталоги поставщиков].Дата) AS Дата,
	ISNULL(Поставщики_1.[Не возвратный], Поставщики.[Не возвратный]) AS [Не возвратный],
	ISNULL(Поставщики_1.[Виден только менеджерам], Поставщики.[Виден только менеджерам]) AS [Виден только менеджерам],
	ISNULL(Поставщики_1.[IsEnsureDeliveryTerm], Поставщики.[IsEnsureDeliveryTerm]) AS [IsEnsureDeliveryTerm],
	ISNULL(Поставщики_1.[IsQualityGuaranteed], Поставщики.[IsQualityGuaranteed]) AS [IsQualityGuaranteed],
	CASE WHEN ISNULL(Поставщики_1.[IsEnsureDeliveryTerm], Поставщики.[IsEnsureDeliveryTerm]) = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
    CASE WHEN ISNULL(Поставщики_1.[IsQualityGuaranteed], Поставщики.[IsQualityGuaranteed]) = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle	
FROM [Каталоги поставщиков] AS [Каталоги поставщиков_1] INNER JOIN
     Поставщики AS Поставщики_1 ON [Каталоги поставщиков_1].ID_Поставщика = Поставщики_1.ID_Поставщика 
		RIGHT OUTER JOIN  (SELECT     Брэнд_, Name_, Брэнд, [Name] FROM [Таблица аналогов]
		UNION SELECT @brend, @name, @brend, @name) as ANALOGI INNER JOIN
     [Каталоги поставщиков] ON ANALOGI.Брэнд_ = [Каталоги поставщиков].Брэнд AND 
     ANALOGI.Name_ = [Каталоги поставщиков].Name INNER JOIN
      Поставщики ON [Каталоги поставщиков].ID_Поставщика = Поставщики.ID_Поставщика ON 
     [Каталоги поставщиков_1].ID_Аналога = [Каталоги поставщиков].ID_Аналога AND 
     [Каталоги поставщиков_1].ID_Поставщика = [Каталоги поставщиков].ID_Поставщика

WHERE     (ANALOGI.[Name] = @name) AND 
			(ANALOGI.Брэнд = @brend)


UNION


SELECT		Поисковая.ID_Запчасти, 
			Поисковая.Брэнд, 
			Поисковая.[Сокращенное название], 
			Поисковая.[Номер поставщика] as [Номер запчасти], 
			ISNULL(Поисковая.Цена, 0) AS Цена, 
			CASE WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0 ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END AS Доступно, 
            ISNULL(Поисковая.Количество, 0) AS Резерв, 
			Поисковая.Описание, 
			NULL AS Заказ, 
			NULL AS Срок, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена1, 0) ELSE MAX(Спец_цена) END AS Цена1, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена2, 0) ELSE MAX(Спец_цена) END AS Цена2, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена3, 0) ELSE MAX(Спец_цена) END AS Цена3, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена4, 0) ELSE MAX(Спец_цена) END AS Цена4, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена5, 0) ELSE MAX(Спец_цена) END AS Цена5, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена6, 0) ELSE MAX(Спец_цена) END AS Цена6, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена7, 0) ELSE MAX(Спец_цена) END AS Цена7, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена8, 0) ELSE MAX(Спец_цена) END AS Цена8, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена9, 0) ELSE MAX(Спец_цена) END AS Цена9, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена10, 0) ELSE MAX(Спец_цена) END AS Цена10, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена11, 0) ELSE MAX(Спец_цена) END AS Цена11, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена12, 0) ELSE MAX(Спец_цена) END AS Цена12, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена13, 0) ELSE MAX(Спец_цена) END AS Цена13, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена14, 0) ELSE MAX(Спец_цена) END AS Цена14, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена15, 0) ELSE MAX(Спец_цена) END AS Цена15, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена16, 0) ELSE MAX(Спец_цена) END AS Цена16, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена17, 0) ELSE MAX(Спец_цена) END AS Цена17,
			null as Дата,
			Поисковая.[Не возвратный],
			Поисковая.[Виден только менеджерам],
			Поисковая.IsEnsureDeliveryTerm,
			Поисковая.IsQualityGuaranteed,
			CASE WHEN Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
            CASE WHEN Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM        Поисковая INNER JOIN
                      [Каталог запчастей] ON Поисковая.ID_аналога = [Каталог запчастей].ID_аналога INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда INNER JOIN
                      (SELECT     Брэнд_, Name_, Брэнд, [Name] FROM [Таблица аналогов]
						UNION SELECT @brend, @name, @brend, @name) as ANALOGI ON 
						Брэнды.Брэнд = [ANALOGI].Брэнд_ AND 
                      [Каталог запчастей].namepost = [ANALOGI].Name_
WHERE     (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND 
          (ANALOGI.Брэнд = @brend) AND 
          (ANALOGI.Name = @name) AND 
          (CASE WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0 ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END <> 0) OR
          (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND 
          (ANALOGI.Брэнд = @brend) AND 
          (ANALOGI.Name = @name) AND 
          (ISNULL(dbo.Поисковая.Количество, 0) <> 0)

			
GROUP BY Поисковая.ID_Запчасти, Поисковая.Цена, Поисковая.Брэнд, Поисковая.[Номер поставщика], Поисковая.[Сокращенное название], 
         Поисковая.Описание, Поисковая.ID_аналога, Поисковая.Остаток, Поисковая.Количество, Поисковая.ID_Клиента, Поисковая.Цена1, 
         Поисковая.Цена2, Поисковая.Цена3, Поисковая.Цена4, Поисковая.Цена5, Поисковая.Цена6, Поисковая.Цена7, Поисковая.Цена8, 
         Поисковая.Цена9, Поисковая.Цена10, Поисковая.Цена11, Поисковая.Цена12, Поисковая.Цена13, Поисковая.Цена14, 
         Поисковая.Цена15, Поисковая.Цена16, Поисковая.Цена17, [Не возвратный], [Виден только менеджерам], IsEnsureDeliveryTerm, 
		 IsQualityGuaranteed, CASE WHEN Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
         CASE WHEN Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END
UNION

SELECT     
	ISNULL([Каталоги поставщиков_1].ID_Запчасти, [Каталоги поставщиков].ID_Запчасти) AS ID_Запчасти,
	ISNULL([Каталоги поставщиков_1].Брэнд, [Каталоги поставщиков].Брэнд) AS Брэнд, 
	ISNULL(Поставщики_1.[Сокращенное название], Поставщики.[Сокращенное название]) AS [Сокращенное название],   
	ISNULL([Каталоги поставщиков_1].[Номер запчасти], [Каталоги поставщиков].[Номер запчасти]) AS [Номер запчасти], 
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена],[Каталоги поставщиков].[Цена]), 0) AS Цена,
	0 AS Доступно, 
	0 AS Резерв, 
	ISNULL([Каталоги поставщиков_1].Описание, [Каталоги поставщиков].Описание) AS Описание,
	ISNULL([Каталоги поставщиков_1].Наличие, [Каталоги поставщиков].Наличие) AS Заказ,
	ISNULL([Каталоги поставщиков_1].[Срок доставки], [Каталоги поставщиков].[Срок доставки]) AS Срок,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена1],[Каталоги поставщиков].[Цена1]), 0) AS Цена1,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена2],[Каталоги поставщиков].[Цена2]), 0) AS Цена2,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена3],[Каталоги поставщиков].[Цена3]), 0) AS Цена3,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена4],[Каталоги поставщиков].[Цена4]), 0) AS Цена4,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена5],[Каталоги поставщиков].[Цена5]), 0) AS Цена5,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена6],[Каталоги поставщиков].[Цена6]), 0) AS Цена6,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена7],[Каталоги поставщиков].[Цена7]), 0) AS Цена7,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена8],[Каталоги поставщиков].[Цена8]), 0) AS Цена8,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена9],[Каталоги поставщиков].[Цена9]), 0) AS Цена9,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена10],[Каталоги поставщиков].[Цена10]), 0) AS Цена10,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена11],[Каталоги поставщиков].[Цена11]), 0) AS Цена11,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена12],[Каталоги поставщиков].[Цена12]), 0) AS Цена12,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена13],[Каталоги поставщиков].[Цена13]), 0) AS Цена13,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена14],[Каталоги поставщиков].[Цена14]), 0) AS Цена14,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена15],[Каталоги поставщиков].[Цена15]), 0) AS Цена15,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена16],[Каталоги поставщиков].[Цена16]), 0) AS Цена16,
	ISNULL(ISNULL([Каталоги поставщиков_1].[Цена17],[Каталоги поставщиков].[Цена17]), 0) AS Цена17,
	ISNULL([Каталоги поставщиков_1].Дата, [Каталоги поставщиков].Дата) AS Дата,
	ISNULL(Поставщики_1.[Не возвратный], Поставщики.[Не возвратный]) AS [Не возвратный],
	ISNULL(Поставщики_1.[Виден только менеджерам], Поставщики.[Виден только менеджерам]) AS [Виден только менеджерам],
	ISNULL(Поставщики_1.IsEnsureDeliveryTerm, Поставщики.IsEnsureDeliveryTerm) AS IsEnsureDeliveryTerm,
	ISNULL(Поставщики_1.IsQualityGuaranteed, Поставщики.IsQualityGuaranteed) AS IsQualityGuaranteed,
	CASE WHEN ISNULL(Поставщики_1.IsEnsureDeliveryTerm, Поставщики.IsEnsureDeliveryTerm) = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
    CASE WHEN ISNULL(Поставщики_1.IsQualityGuaranteed, Поставщики.IsQualityGuaranteed) = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM [Каталоги поставщиков] AS [Каталоги поставщиков_1] INNER JOIN
     Поставщики AS Поставщики_1 ON [Каталоги поставщиков_1].ID_Поставщика = Поставщики_1.ID_Поставщика 
		RIGHT OUTER JOIN  (SELECT     Брэнд_, Name_, Брэнд, [Name] FROM [Таблица аналогов]
		UNION SELECT @brend, @name, @brend, @name) as ANALOGI  INNER JOIN
     [Каталоги поставщиков] ON [ANALOGI].Брэнд = [Каталоги поставщиков].Брэнд AND 
     [ANALOGI].Name = [Каталоги поставщиков].Name INNER JOIN
      Поставщики ON [Каталоги поставщиков].ID_Поставщика = Поставщики.ID_Поставщика ON 
     [Каталоги поставщиков_1].ID_Аналога = [Каталоги поставщиков].ID_Аналога AND 
     [Каталоги поставщиков_1].ID_Поставщика = [Каталоги поставщиков].ID_Поставщика

WHERE     ([ANALOGI].[Name_] = @name) AND 
			([ANALOGI].Брэнд_ = @brend)


UNION


SELECT		Поисковая.ID_Запчасти, 
			Поисковая.Брэнд, 
			Поисковая.[Сокращенное название], 
			Поисковая.[Номер поставщика] as [Номер запчасти],
			ISNULL(Поисковая.Цена, 0) AS Цена, 
			CASE WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0 ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END AS Доступно, 
            ISNULL(Поисковая.Количество, 0) AS Резерв, 
			Поисковая.Описание, 
			NULL AS Заказ, 
			NULL AS Срок, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена1, 0) ELSE MAX(Спец_цена) END AS Цена1, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена2, 0) ELSE MAX(Спец_цена) END AS Цена2, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена3, 0) ELSE MAX(Спец_цена) END AS Цена3, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена4, 0) ELSE MAX(Спец_цена) END AS Цена4, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена5, 0) ELSE MAX(Спец_цена) END AS Цена5, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена6, 0) ELSE MAX(Спец_цена) END AS Цена6, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена7, 0) ELSE MAX(Спец_цена) END AS Цена7, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена8, 0) ELSE MAX(Спец_цена) END AS Цена8, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена9, 0) ELSE MAX(Спец_цена) END AS Цена9, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена10, 0) ELSE MAX(Спец_цена) END AS Цена10, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена11, 0) ELSE MAX(Спец_цена) END AS Цена11, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена12, 0) ELSE MAX(Спец_цена) END AS Цена12, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена13, 0) ELSE MAX(Спец_цена) END AS Цена13, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена14, 0) ELSE MAX(Спец_цена) END AS Цена14, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена15, 0) ELSE MAX(Спец_цена) END AS Цена15, 
            CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена16, 0) ELSE MAX(Спец_цена) END AS Цена16, 
			CASE WHEN MAX(ID_Клиента) IS NULL THEN isnull(Поисковая.Цена17, 0) ELSE MAX(Спец_цена) END AS Цена17,
			null as Дата,
			Поисковая.[Не возвратный],
			Поисковая.[Виден только менеджерам],
			Поисковая.IsEnsureDeliveryTerm,
			Поисковая.IsQualityGuaranteed,
			CASE WHEN Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END AS IsEnsureDeliveryTermTitle,
            CASE WHEN Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END AS IsQualityGuaranteedTitle
FROM        Поисковая INNER JOIN
                      [Каталог запчастей] ON Поисковая.ID_аналога = [Каталог запчастей].ID_аналога INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда INNER JOIN
                      (SELECT     Брэнд_, Name_, Брэнд, [Name] FROM [Таблица аналогов]
						UNION SELECT @brend, @name, @brend, @name) as ANALOGI ON 
						Брэнды.Брэнд = [ANALOGI].Брэнд AND 
                      [Каталог запчастей].namepost = [ANALOGI].Name
WHERE     (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND 
          (ANALOGI.Брэнд_ = @brend) AND 
          (ANALOGI.Name_ = @name) AND 
          (CASE WHEN ISnull(Остаток, 0) - isnull(Количество, 0) = 0 THEN 0 ELSE ISnull(Остаток, 0) - isnull(Количество, 0) END <> 0) OR
          (dbo.Поисковая.ID_Клиента = @klient OR dbo.Поисковая.ID_Клиента IS NULL) AND 
          (ANALOGI.Брэнд_ = @brend) AND 
          (ANALOGI.Name_ = @name) AND 
          (ISNULL(dbo.Поисковая.Количество, 0) <> 0)

			
GROUP BY Поисковая.ID_Запчасти, Поисковая.Цена, Поисковая.Брэнд, Поисковая.[Номер поставщика], Поисковая.[Сокращенное название], 
         Поисковая.Описание, Поисковая.ID_аналога, Поисковая.Остаток, Поисковая.Количество, Поисковая.ID_Клиента, Поисковая.Цена1, 
         Поисковая.Цена2, Поисковая.Цена3, Поисковая.Цена4, Поисковая.Цена5, Поисковая.Цена6, Поисковая.Цена7, Поисковая.Цена8, 
         Поисковая.Цена9, Поисковая.Цена10, Поисковая.Цена11, Поисковая.Цена12, Поисковая.Цена13, Поисковая.Цена14, 
         Поисковая.Цена15, Поисковая.Цена16, Поисковая.Цена17, [Не возвратный], [Виден только менеджерам], IsEnsureDeliveryTerm, 
		 IsQualityGuaranteed, CASE WHEN Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
         CASE WHEN Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END
GO
/****** Object:  StoredProcedure [dbo].[SelectSparesGroup]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectSparesGroup]
@search varchar(25)
   
AS
Select top 50 Брэнд, MAX([Номер запчасти]) as [Номер запчасти],[name],
MAX(Описание) as Описание,
MIN(ID_Запчасти) as ID_Запчасти,
MAX(ID_Аналога) as ID_Аналога,
ISNULL(MAX(FirstBrend), Брэнд) as FirstBrend
FROM
(
SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, Брэнды.Брэнд) AS Брэнд, 
			MAX([Каталог запчастей].[Номер поставщика]) AS [Номер запчасти], 
             [Каталог запчастей].namepost AS Name, MAX([Каталог запчастей].Описание) AS Описание, 
			0 AS ID_Запчасти, [Каталог запчастей].ID_аналога,  dbo.Брэнды.Брэнд AS FirstBrend
FROM        [Каталог запчастей] INNER JOIN
                      Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда LEFT OUTER JOIN
                      [Аналогичные брэнды] ON Брэнды.Брэнд = [Аналогичные брэнды].Брэнд
WHERE     ([Каталог запчастей].namepost like @search) OR
                      ([Каталог запчастей].NAME like @search)
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
WHERE     [Каталоги поставщиков].Name like @search
GROUP BY  [Каталоги поставщиков].Брэнд, [Каталоги поставщиков].Name, 
			[Каталоги поставщиков].[Номер запчасти], [Аналогичные брэнды].Брэнд_аналог

UNION

SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Таблица аналогов].Брэнд) AS Брэнд, 
			[Таблица аналогов].Номер, [Таблица аналогов].Name, NULL AS Описание, 0 AS ID_Запчасти, 
			NULL AS ID_Аналога, Null AS FirstBrend
FROM        [Таблица аналогов] LEFT OUTER JOIN
            [Аналогичные брэнды] ON [Таблица аналогов].Брэнд = [Аналогичные брэнды].Брэнд
WHERE       ([Таблица аналогов].Name like @search)
GROUP BY    [Таблица аналогов].Брэнд, [Таблица аналогов].Номер, [Таблица аналогов].Name, 
			[Аналогичные брэнды].Брэнд_аналог

UNION

SELECT     ISNULL([Аналогичные брэнды].Брэнд_аналог, [Таблица аналогов_1].Брэнд_) AS Брэнд, 
			MIN([Таблица аналогов_1].Номер_) AS Номер, [Таблица аналогов_1].Name_ AS name, 
			NULL AS Описание, 0 AS ID_Запчасти, NULL AS ID_Аналога,
			Null AS FirstBrend
FROM       [Таблица аналогов] AS [Таблица аналогов_1] LEFT OUTER JOIN
			[Аналогичные брэнды] ON [Таблица аналогов_1].Брэнд_ = [Аналогичные брэнды].Брэнд
WHERE     ([Таблица аналогов_1].Name_ like @search)
GROUP BY [Таблица аналогов_1].Name_, [Таблица аналогов_1].Брэнд_, [Аналогичные брэнды].Брэнд_аналог

) as twoTable

Group by Брэнд, [name] 

Order by Брэнд, [name] 

GO
/****** Object:  StoredProcedure [dbo].[SelectSparesGroupAnalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectSparesGroupAnalog]
@search char(25)
   
AS
Select Брэнд, Номер, [name]
FROM [Таблица аналогов]
Where [name] = @search
Group by Брэнд, Номер, [name]

UNION

Select Брэнд_ as Брэнд, MIN(Номер_) as Номер, [name_] as name
FROM [Таблица аналогов]
Where [name_]=@search
Group by Брэнд_, [name_]


GO
/****** Object:  StoredProcedure [dbo].[SelectSparesGroupInside]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectSparesGroupInside]
@search char(25)
   
AS

SELECT  Брэнды.Брэнд, [Каталог запчастей].[Namepost] as [name],  
		MAX([Каталог запчастей].[Номер поставщика]) as [Номер запчасти], 
       MAX([Каталог запчастей].Описание) as Описание, [Каталог запчастей].ID_аналога
FROM [Каталог запчастей] INNER JOIN
       Брэнды ON [Каталог запчастей].ID_Брэнда = Брэнды.ID_Брэнда
WHERE ((rtrim([NAMEPOST]) like rtrim(@search)) or (rtrim([NAME]) like rtrim(@search)))
GROUP BY Брэнды.Брэнд, [Каталог запчастей].[Namepost], [Каталог запчастей].ID_аналога
ORDER BY dbo.Брэнды.Брэнд, [name]





GO
/****** Object:  StoredProcedure [dbo].[SelectSparesGroupOutside]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SelectSparesGroupOutside]
@search char(25)
   
AS


SELECT  Брэнд, [Name], [Номер запчасти], MAX(Описание) as Описание, MAX(ID_запчасти) as ID_аналога
FROM [Каталоги поставщиков]
WHERE rtrim([NAME]) like rtrim(@search) 
GROUP BY Брэнд, [Name], [Номер запчасти]
ORDER BY Брэнд, [Name]

GO
/****** Object:  StoredProcedure [dbo].[SelectSparesName]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectSparesName]
@brend char(18),
@name char(25),
@klient int
   
AS
SELECT      Id_Запчасти, 
			Брэнд,
			[Сокращенное название], 
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
			[Каталоги поставщиков_1].Брэнд as Брэнд, 
			[Каталоги поставщиков_1].[Сокращенное название] as [Сокращенное название],
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

SELECT     dbo.Поисковая.ID_Запчасти, dbo.Поисковая.Брэнд, dbo.Поисковая.[Сокращенное название], dbo.Поисковая.[Номер поставщика] as [Номер запчасти], ISNULL(dbo.Поисковая.Цена, 0) 
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
GROUP BY dbo.Поисковая.ID_Запчасти, dbo.Поисковая.Цена, dbo.Поисковая.Брэнд, dbo.Поисковая.[Номер поставщика], dbo.Поисковая.Описание, 
                      dbo.Поисковая.[Сокращенное название], dbo.Поисковая.ID_аналога, dbo.Поисковая.Остаток, dbo.Поисковая.Количество, dbo.Поисковая.ID_Клиента, 
                      dbo.Поисковая.Цена1, dbo.Поисковая.Цена2, dbo.Поисковая.Цена3, dbo.Поисковая.Цена4, dbo.Поисковая.Цена5, dbo.Поисковая.Цена6, dbo.Поисковая.Цена7, 
                      dbo.Поисковая.Цена8, dbo.Поисковая.Цена9, dbo.Поисковая.Цена10, dbo.Поисковая.Цена11, dbo.Поисковая.Цена12, dbo.Поисковая.Цена13, 
                      dbo.Поисковая.Цена14, dbo.Поисковая.Цена15, dbo.Поисковая.Цена16, dbo.Поисковая.Цена17, dbo.Поисковая.[Не возвратный], dbo.Поисковая.[Виден только менеджерам],
					  dbo.Поисковая.IsEnsureDeliveryTerm, dbo.Поисковая.IsQualityGuaranteed, CASE WHEN dbo.Поисковая.IsEnsureDeliveryTerm = 1 THEN 'Гарантированный срок поставки' ELSE Null END,
                      CASE WHEN dbo.Поисковая.IsQualityGuaranteed = 1 THEN  'Гарантия качества и соответсвия производителю' ELSE Null END
GO
/****** Object:  StoredProcedure [dbo].[sp_web_getclientbyvip]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_web_getclientbyvip] 	
	@vip varchar(10)
AS
BEGIN
	SELECT TOP (3)
	  ID_Клиента as id
      ,[VIP] as vip
      ,TRIM([Фамилия]) + ' ' + TRIM([Имя]) as fullName     
      ,[Расчет_в_евро] as isEuroClient      
      ,[Интернет_заказы] as isWebUser
  FROM [FenixParts].[dbo].[Клиенты]
  WHERE VIP like @vip
 
END
GO
/****** Object:  StoredProcedure [dbo].[TotalCountTable]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[TotalCountTable]
@table varchar(200)
AS
declare @query varchar(255)
set @query = 'SELECT COUNT(*) as kolvo FROM ' + @table
exec(@query)
GO
/****** Object:  StoredProcedure [dbo].[TotalOrders]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TotalOrders]
@startDate char(10),
@endDate char(10),
@totalOrders int output,
@totalReserv int output   
AS

SELECT      @totalOrders = COUNT(ID_Запроса)
FROM            dbo.[Запросы клиентов]
WHERE        ((Дата >= CONVERT(char(10), @startDate, 102) AND Дата <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(Дата) = YEAR(CONVERT(char(10), @startDate, 102))) AND (MONTH(Дата) = MONTH(CONVERT(char(10), @startDate, 102))) AND (DAY(Дата) = DAY(CONVERT(char(10), @startDate, 102))) OR
							  (YEAR(Дата) = YEAR(CONVERT(char(10), @endDate, 102))) AND (MONTH(Дата) = MONTH(CONVERT(char(10), @endDate, 102))) AND (DAY(Дата) = DAY(CONVERT(char(10), @endDate, 102)))) and (Интернет = 1) and (ID_Клиента <> 378)


SELECT      @totalReserv = COUNT(ID)
FROM            dbo.[Подчиненная накладные]
WHERE        ((Дата >= CONVERT(char(10), @startDate, 102) AND Дата <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(Дата) = YEAR(CONVERT(char(10), @startDate, 102))) AND (MONTH(Дата) = MONTH(CONVERT(char(10), @startDate, 102))) AND (DAY(Дата) = DAY(CONVERT(char(10), @startDate, 102))) OR
							  (YEAR(Дата) = YEAR(CONVERT(char(10), @endDate, 102))) AND (MONTH(Дата) = MONTH(CONVERT(char(10), @endDate, 102))) AND (DAY(Дата) = DAY(CONVERT(char(10), @endDate, 102)))) and (Статус = 'internet') and (ID_Клиента <> 378)

GO
/****** Object:  StoredProcedure [dbo].[TotalQuery]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TotalQuery]
@startDate char(10),
@endDate char(10),
@totalquery int output   
AS

SELECT      @totalquery = COUNT(ID_Query)
FROM            dbo.[Веб-запросы]
WHERE        (date >= CONVERT(char(10), @startDate, 102) AND date <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(date) = YEAR(CONVERT(char(10), @startDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @startDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @startDate, 102))) OR
							  (YEAR(date) = YEAR(CONVERT(char(10), @endDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @endDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @endDate, 102)))
GO
/****** Object:  StoredProcedure [dbo].[TotalRegistration]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TotalRegistration]
@startDate char(10),
@endDate char(10),
@totalregistration int output   
AS

SELECT      @totalregistration = COUNT(ID_registration)
FROM            dbo.[Веб-регистрация]
WHERE        (date >= CONVERT(char(10), @startDate, 102) AND date <= CONVERT(char(10), @endDate, 102)) OR
                         (YEAR(date) = YEAR(CONVERT(char(10), @startDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @startDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @startDate, 102))) OR
							  (YEAR(date) = YEAR(CONVERT(char(10), @endDate, 102))) AND (MONTH(date) = MONTH(CONVERT(char(10), @endDate, 102))) AND (DAY(date) = DAY(CONVERT(char(10), @endDate, 102)))
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_ROZNICA_TO_NULL]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UPDATE_ROZNICA_TO_NULL]
AS UPDATE [dbo].[Каталог запчастей] SET [dbo].[Каталог запчастей].[Цена] = NULL
WHERE ([dbo].[Каталог запчастей].[Цена] IS NOT NULL 
AND [dbo].[Каталог запчастей].[Цена7] IS NULL  )
GO
/****** Object:  StoredProcedure [dbo].[UPDATE_SUPEROPT]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UPDATE_SUPEROPT] AS
UPDATE dbO.[Каталог запчастей] SET dbO.[Каталог запчастей].[Цена4] = [Цена7]/1.05
GO
/****** Object:  StoredProcedure [dbo].[UpdateKontrol]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateKontrol]
@totalWrite int output   
AS
SET @totalWrite = 0
DECLARE @Analog int
DECLARE Kontrol_Cursor CURSOR FOR

SELECT     dbo.[Каталог запчастей].ID_аналога
FROM         dbo.[Каталог запчастей] INNER JOIN
                          (SELECT     ID_аналога
                            FROM          dbo.[Каталог запчастей] AS [Каталог запчастей_2]
                            WHERE      (Контроль = 0)
                            GROUP BY ID_аналога) AS [Каталог запчастей_1] ON dbo.[Каталог запчастей].ID_аналога = [Каталог запчастей_1].ID_аналога
WHERE     (dbo.[Каталог запчастей].Контроль = 1)
GROUP BY dbo.[Каталог запчастей].ID_аналога

OPEN Kontrol_Cursor
FETCH NEXT FROM Kontrol_Cursor
INTO @Analog

WHILE @@FETCH_STATUS = 0
   BEGIN
      UPDATE [Каталог запчастей] set
		[Контроль] = 1
      WHERE ID_Аналога = @Analog
      SET @totalWrite = @totalWrite + 1
      FETCH NEXT FROM Kontrol_Cursor
      INTO @Analog
   END
CLOSE Kontrol_Cursor
DEALLOCATE Kontrol_Cursor
GO
/****** Object:  StoredProcedure [dbo].[UpdateRecomendovanoAnalog]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateRecomendovanoAnalog]
@totalWrite int output   
AS
SET @totalWrite = 0
DECLARE @Recomendovano int, @Analog int
DECLARE Recomendovano_Cursor CURSOR FOR
SELECT     CAST(ID_Аналога AS Int) AS ID_Аналога, 
			MAX([Рекомендовано по аналогу]) AS Рекомендовано
FROM         
(SELECT     ID_Аналога, [Рекомендовано по аналогу]
           FROM   [Каталог запчастей]
           GROUP BY ID_Аналога, [Рекомендовано по аналогу]
           ) AS derivedtbl
GROUP BY ID_Аналога
HAVING      ((COUNT(ID_Аналога) <> 1)AND(MAX([Рекомендовано по аналогу]) IS NOT NULL))

OPEN Recomendovano_Cursor
FETCH NEXT FROM Recomendovano_Cursor
INTO @Analog, @Recomendovano

WHILE @@FETCH_STATUS = 0
   BEGIN
      UPDATE [Каталог запчастей] set
		[Рекомендовано по аналогу] = @Recomendovano
      WHERE ID_Аналога = @Analog
      SET @totalWrite = @totalWrite + 1
      FETCH NEXT FROM Recomendovano_Cursor
      INTO @Analog, @Recomendovano
   END
CLOSE Recomendovano_Cursor
DEALLOCATE Recomendovano_Cursor
GO
/****** Object:  StoredProcedure [dbo].[UpdateWebQuery]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateWebQuery]
@webQueryId int,
@brend        varchar(18),
@nomer    varchar(25),
@available       bit,
@QueryID	      int OUTPUT
AS
update [Веб-запросы] set 
brend = @brend,
nomer = @nomer,
available = @available
where ID_Query = @webQueryId;

SET @QueryID = @webQueryId
GO
/****** Object:  StoredProcedure [dbo].[Анализ_поставщика]    Script Date: 19.04.2020 18:45:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery1.sql|7|0|C:\Users\Администратор\AppData\Local\Temp\2\~vs54A0.sql


CREATE  PROCEDURE [dbo].[Анализ_поставщика]
	
	@postavsik int, 
	@god int, 
	@mesac int,
	@nace decimal(9,2) output,
	@usd decimal(9,2) output,
	@euro decimal(9,2) output,
	@grn decimal(9,2) output,
	@usd_s decimal(9,2) output,
	@euro_s decimal(9,2) output,
	@grn_s decimal(9,2) output,
	@sklad decimal(9,2) output,
	@sklad_post decimal(9,2) output,
	@oborot decimal(9,2) output,
	@oborot_post decimal(9,2) output
AS
BEGIN
	declare @usd_tmp decimal(9,2)
	declare @euro_tmp decimal(9,2)
	declare @grn_tmp decimal(9,2)

-- визначення середньої націнки --

SELECT     @nace = (SUM(Цена_продажи * Расход) / SUM(Цена_закупки * Расход) - 1) * 100 
FROM         dbo.Анализ_поставщика_наценка
WHERE (MONTH(Дата_опер) = @mesac)and(year(Дата_опер) = @god)and(ID_Поставщика = @postavsik)

set @usd = 0
set @euro = 0
set @grn = 0
set @usd_s = 0
set @euro_s = 0
set @grn_s = 0
set @nace = isnull(@nace, 0)
-- визначення обєму закупок у поставщика --

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 22) AND (Счет_кредита = 29) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)and(ID_Поставщика = @postavsik)
GROUP BY ID_Поставщика

set @usd = @usd + @usd_tmp
set @euro = @euro + @euro_tmp
set @grn = @grn + @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 22) AND (Счет_кредита = 31) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)and(ID_Поставщика = @postavsik)
GROUP BY ID_Поставщика


set @usd = @usd + @usd_tmp
set @euro = @euro + @euro_tmp
set @grn = @grn + @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 29) AND (Счет_кредита = 22) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)and(ID_Поставщика = @postavsik)
GROUP BY ID_Поставщика


set @usd = @usd - @usd_tmp
set @euro = @euro - @euro_tmp
set @grn = @grn - @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 31) AND (Счет_кредита = 22) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)and(ID_Поставщика = @postavsik)
GROUP BY ID_Поставщика

set @usd = @usd - @usd_tmp
set @euro = @euro - @euro_tmp
set @grn = @grn - @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

set @usd = isnull(@usd, 0)
set @euro = isnull(@euro, 0)
set @grn = isnull(@grn, 0)


-- визначення загального обєму закупок --

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 22) AND (Счет_кредита = 29) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)

set @usd_s = @usd_s + @usd_tmp
set @euro_s = @euro_s + @euro_tmp
set @grn_s = @grn_s + @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 22) AND (Счет_кредита = 31) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)

set @usd_s = @usd_s + @usd_tmp
set @euro_s = @euro_s + @euro_tmp
set @grn_s = @grn_s + @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 29) AND (Счет_кредита = 22) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)

set @usd_s = @usd_s - @usd_tmp
set @euro_s = @euro_s - @euro_tmp
set @grn_s = @grn_s - @grn_tmp
set @usd_tmp = 0
set @euro_tmp = 0
set @grn_tmp = 0

SELECT @grn_tmp = isnull(SUM(Сумма_грн),0), @euro_tmp = isnull(SUM(Сумма_евро),0), @usd_tmp = isnull(SUM(Сумма_долл),0)
FROM dbo.Проводки
WHERE (Счет_дебета = 31) AND (Счет_кредита = 22) AND (MONTH(Дата) = @mesac) AND (YEAR(Дата) = @god)

set @usd_s = @usd_s - @usd_tmp
set @euro_s = @euro_s - @euro_tmp
set @grn_s = @grn_s - @grn_tmp

set @usd_s = isnull(@usd_s, 0)
set @euro_s = isnull(@euro_s, 0)
set @grn_s = isnull(@grn_s, 0)

-- визначення частини складу по поставщику --

set @sklad = 0
set @sklad_post = 0
declare @posa int
declare @suma decimal(9,2)

DECLARE sum_sklad CURSOR FOR
SELECT dbo.[Каталог запчастей].ID_Поставщика, 
(SUM(dbo.[Склад сумма_1].Приход)- SUM(dbo.[Склад сумма_1].Расход)) * dbo.[Склад сумма_1].Цена_закупки AS Сумма
FROM dbo.[Склад сумма_1] INNER JOIN
     dbo.[Каталог запчастей] ON dbo.[Склад сумма_1].ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE (dbo.[Склад сумма_1].Месяц <= @mesac) or (dbo.[Склад сумма_1].Год < @god)
GROUP BY dbo.[Склад сумма_1].ID_Запчасти, dbo.[Склад сумма_1].Цена_закупки, dbo.[Каталог запчастей].ID_Поставщика
HAVING (SUM(dbo.[Склад сумма_1].Приход) - SUM(dbo.[Склад сумма_1].Расход) <> 0)

open sum_sklad
fetch next from sum_sklad
into @posa, @suma
while @@fetch_status = 0
begin
set @sklad = @sklad + @suma
if @posa = @postavsik set @sklad_post = @sklad_post + @suma

fetch next from sum_sklad
into @posa, @suma
end
close sum_sklad
deallocate sum_sklad
set @sklad = isnull(@sklad, 0)
set @sklad_post = isnull(@sklad_post, 0)

-- визначення частини від оборота по поставщику --
set @oborot = 0
set @oborot_post = 0


SELECT @oborot_post = SUM(dbo.Операции.Расход * dbo.Операции.Цена_продажи)
FROM dbo.Операции INNER JOIN
        dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE (dbo.Операции.Id_Клиента <> 378) AND (MONTH(dbo.Операции.Дата) = @mesac) AND 
(YEAR(dbo.Операции.Дата) = @god) AND (dbo.Операции.Расход > 0) AND 
                      (dbo.[Каталог запчастей].ID_Поставщика = @postavsik) 

SELECT @oborot = SUM(dbo.Операции.Расход * dbo.Операции.Цена_продажи)
FROM dbo.Операции INNER JOIN
        dbo.[Каталог запчастей] ON dbo.Операции.ID_Запчасти = dbo.[Каталог запчастей].ID_Запчасти
WHERE (dbo.Операции.Id_Клиента <> 378) AND (MONTH(dbo.Операции.Дата) = @mesac) AND 
(YEAR(dbo.Операции.Дата) = @god) AND (dbo.Операции.Расход > 0)
                      
set @oborot = isnull(@oborot, 0)
set @oborot_post = isnull(@oborot_post, 0)

return 
END












GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 277
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 307
               Bottom = 96
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 297
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_TCD_IN_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_TCD_IN_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "_RED_2_TCD_IN_1"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 251
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_TCD_IN_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_TCD_IN_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "_RED_2_TCD_IN_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 120
               Left = 38
               Bottom = 250
               Right = 281
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "_RED_2_TCD_IN_2"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 119
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_TCD_IN_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_TCD_IN_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "_RED_2"
            Begin Extent = 
               Top = 40
               Left = 49
               Bottom = 322
               Right = 280
            End
            DisplayFlags = 280
            TopColumn = 33
         End
         Begin Table = "CLEAR (AnalogsDB.dbo)"
            Begin Extent = 
               Top = 21
               Left = 474
               Bottom = 319
               Right = 811
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_WITH_TA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'_RED_2_WITH_TA'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "k"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 3405
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MIN_INVOICE_FROM_KP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MIN_INVOICE_FROM_KP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Просроченные долги клиентов"
            Begin Extent = 
               Top = 6
               Left = 291
               Bottom = 126
               Right = 451
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1995
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'OVERDEBT_UAH_BY_MANAGER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'OVERDEBT_UAH_BY_MANAGER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "_RED_2_WITH_TA"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CAT_W_BR"
            Begin Extent = 
               Top = 6
               Left = 236
               Bottom = 126
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RED_2_READY_TO_UPD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'RED_2_READY_TO_UPD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 274
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Анализ неток_1"
            Begin Extent = 
               Top = 18
               Left = 374
               Bottom = 243
               Right = 531
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1650
         Width = 1005
         Width = 1005
         Width = 1035
         Width = 1500
         Width = 645
         Width = 900
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ неток'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ неток'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 128
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 137
               Left = 318
               Bottom = 304
               Right = 495
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 153
               Left = 32
               Bottom = 296
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 199
               Left = 654
               Bottom = 277
               Right = 802
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 1
               Left = 514
               Bottom = 109
               Right = 696
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ неток_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Alias = 900
         Table = 1170
         Output = 780
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 690
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ неток_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ неток_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Подчиненная накладные"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 407
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Анализ продаж_1"
            Begin Extent = 
               Top = 9
               Left = 482
               Bottom = 117
               Right = 907
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[28] 4[34] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Анализ продаж"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 200
               Right = 273
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2955
         Alias = 2040
         Table = 1935
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж аналог_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж аналог_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Подчиненная накладные"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 126
               Right = 477
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 19
               Left = 597
               Bottom = 97
               Right = 745
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 42
               Left = 795
               Bottom = 150
               Right = 977
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 366
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'00
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1290
         Table = 2265
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Анализ продаж_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Подчиненная накладные"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 238
               Bottom = 121
               Right = 461
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 211
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 126
               Left = 237
               Bottom = 241
               Right = 423
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Сотрудники"
            Begin Extent = 
               Top = 246
               Left = 295
               Bottom = 361
               Right = 456
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 481
               Right = 225
           ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Архив клиента'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Архив клиента'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Архив клиента'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 249
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 3090
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'В_заказе_по_аналогу'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'В_заказе_по_аналогу'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 249
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'В_заказе_по_аналогу_на_склад'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'В_заказе_по_аналогу_на_склад'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 317
               Right = 264
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Дневной_3"
            Begin Extent = 
               Top = 4
               Left = 320
               Bottom = 208
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Дневной_2"
            Begin Extent = 
               Top = 2
               Left = 534
               Bottom = 255
               Right = 682
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты_1"
            Begin Extent = 
               Top = 24
               Left = 777
               Bottom = 328
               Right = 959
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1890
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1755
         Alias = 1710
         Table = 1860
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      En' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Дневной'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'd
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Дневной'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Дневной'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Должок"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 106
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 414
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Проплачено"
            Begin Extent = 
               Top = 183
               Left = 377
               Bottom = 283
               Right = 529
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Долги'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Долги'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[48] 4[13] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 233
            End
            DisplayFlags = 280
            TopColumn = 20
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 4
               Left = 625
               Bottom = 124
               Right = 824
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поисковая"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 246
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Заказы поставщикам"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 366
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Запросы'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Запросы'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 9
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 29
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 293
               Bottom = 91
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2055
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Заработок_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Заработок_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[28] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Заработок_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 190
               Right = 195
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Заработок_2"
            Begin Extent = 
               Top = 6
               Left = 233
               Bottom = 136
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7995
         Alias = 1425
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 630
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Зароботок'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Зароботок'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[31] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Подчиненная накладные"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 318
               Right = 286
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2325
         Alias = 900
         Table = 2445
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 915
         Or = 900
         Or = 1050
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Кеш_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Кеш_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Кеш_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 193
               Right = 415
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Кеш_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Кеш_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Тарифные модели"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 123
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 38
               Left = 295
               Bottom = 155
               Right = 489
            End
            DisplayFlags = 280
            TopColumn = 24
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Клиент'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Клиент'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[10] 2[31] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 71
               Left = 461
               Bottom = 186
               Right = 684
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 293
               Bottom = 91
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 481
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Наценка_по_факту'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'  End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Наценка_по_факту'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Наценка_по_факту'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[27] 4[4] 2[50] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Клиенты (dbo)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Спец_цены (dbo)"
            Begin Extent = 
               Top = 6
               Left = 261
               Bottom = 114
               Right = 412
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Склад сумма_2 (dbo)"
            Begin Extent = 
               Top = 6
               Left = 450
               Bottom = 114
               Right = 603
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей (dbo)"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 260
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды (dbo)"
            Begin Extent = 
               Top = 114
               Left = 298
               Bottom = 192
               Right = 449
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики (dbo)"
            Begin Extent = 
               Top = 114
               Left = 487
               Bottom = 222
               Right = 705
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'НаценкаP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'НаценкаP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'НаценкаP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 245
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 13
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Операции_'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Операции_'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции_"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Остаток_'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Остаток_'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 25
               Left = 704
               Bottom = 248
               Right = 891
            End
            DisplayFlags = 280
            TopColumn = 7
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3210
         Alias = 2655
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Просроченые долги по периоду_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Просроченые долги по периоду_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 261
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 361
               Right = 225
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 6780
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Просроченые долги по периоду_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Просроченые долги по периоду_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Просроченые долги по периоду_4"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 91
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Долг_поставщику"
            Begin Extent = 
               Top = 6
               Left = 237
               Bottom = 121
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7650
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Просроченые долги по периоду_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Просроченые долги по периоду_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Склад сумма_2"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 246
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 230
               Bottom = 322
               Right = 411
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 2
               Left = 509
               Bottom = 87
               Right = 661
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 128
               Left = 501
               Bottom = 243
               Right = 702
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2115
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 135' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад сумма'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'0
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад сумма'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад сумма'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Склад_остаток_"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 84
               Right = 186
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 124
               Left = 527
               Bottom = 202
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 9
               Left = 524
               Bottom = 117
               Right = 721
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 32
               Left = 268
               Bottom = 140
               Right = 445
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2040
         Width = 2325
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1920
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_остаток'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_остаток'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_остаток'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 259
               Right = 204
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1860
         Width = 1830
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 2505
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_остаток_'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_остаток_'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Склад сумма_2"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 121
               Right = 443
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 6
               Left = 449
               Bottom = 121
               Right = 650
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 2745
         Width = 2535
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_поставщики'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Склад_поставщики'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[14] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Таблица_2"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 265
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2265
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 21
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 114
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 479
               Bottom = 114
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 694
               Bottom = 84
               Right = 842
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица Вход'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица Вход'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Подчиненная накладные"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 287
               Right = 196
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Клиенты"
            Begin Extent = 
               Top = 6
               Left = 234
               Bottom = 114
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 114
               Right = 631
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 669
               Bottom = 84
               Right = 817
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица Выход'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица Выход'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 91
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 121
               Right = 409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 6
               Left = 447
               Bottom = 121
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Автомобили"
            Begin Extent = 
               Top = 6
               Left = 686
               Bottom = 91
               Right = 845
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Группы"
            Begin Extent = 
               Top = 96
               Left = 38
               Bottom = 181
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2445
         Alias = 900
 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица цены'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица цены'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица цены'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 181
               Left = 511
               Bottom = 296
               Right = 712
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 96
               Left = 718
               Bottom = 181
               Right = 870
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Автомобили"
            Begin Extent = 
               Top = 136
               Left = 308
               Bottom = 221
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Группы"
            Begin Extent = 
               Top = 239
               Left = 126
               Bottom = 324
               Right = 278
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики_1"
            Begin Extent = 
               Top = 0
               Left = 499
               Bottom = 115
               Right = 700
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2145
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Таблица_4"
            Begin Extent = 
               Top = 170
               Left = 247
               Bottom = 255
               Right = 399
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Таблица_1"
            Begin Extent = 
               Top = 11
               Left = 16
               Bottom = 231
               Right = 177
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Таблица_3"
            Begin Extent = 
               Top = 97
               Left = 438
               Bottom = 212
               Right = 590
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Склад_остаток_"
            Begin Extent = 
               Top = 11
               Left = 436
               Bottom = 96
               Right = 588
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3810
         Alias = 1740
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Запросы клиентов"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 289
               Right = 225
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Анализ продаж"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 200
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1845
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_4'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Брэнды"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 91
               Right = 190
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 228
               Bottom = 233
               Right = 409
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Поставщики"
            Begin Extent = 
               Top = 6
               Left = 447
               Bottom = 121
               Right = 648
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Группы"
            Begin Extent = 
               Top = 147
               Left = 528
               Bottom = 232
               Right = 680
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 37
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_цены'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_цены'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Таблица_цены'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Каталог запчастей"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 121
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Хиты_по_аналогу_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Хиты_по_аналогу_5'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Операции"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Хиты_продаж_3'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Хиты_продаж_3'
GO
