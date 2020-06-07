CREATE FUNCTION [dbo].[GetBalanceOnDate](@clientId int,
                                         @day date)
    RETURNS DECIMAL(9, 2)
AS
BEGIN
    DECLARE @isEuro bit, @debtEur decimal(12, 2),
        @debtUah decimal(12, 2), @paidEur decimal(12, 2), @paidUah decimal(12, 2)

    SELECT @debtEur = SUM(Eur), @debtUah = SUM(Uah)
    FROM (SELECT ID_Клиента, Количество, Цена, Грн, Количество * Цена AS Eur, Количество * Грн AS Uah
          FROM dbo.[Подчиненная накладные]
          WHERE (Нету = 0)
            AND (Обработано = 1)
            AND (ID_Клиента = @clientId)
            AND (Дата_закрытия < @day)) AS derivedtbl_1
    SELECT @paidEur = ISNULL(SUM(Цена), 0), @paidUah = ISNULL(SUM(Грн), 0)
    FROM dbo.Касса
    WHERE ID_Клиента = @clientId
      AND Дата < @day

    SELECT @isEuro = Расчет_в_евро
    FROM dbo.Клиенты
    WHERE ID_Клиента = @clientId


    IF (@isEuro = 1)
        RETURN @debtEur - @paidEur

    RETURN @debtUah - @paidUah
END
go

