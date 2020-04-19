ALTER PROCEDURE [dbo].[sp_web_getpaymentplanbyvip]
	@vip varchar(10)
BEGIN
DECLARE @days int=0, @id int, @startnum int = 0, @onlyDebt bit, @isEuro bit
  SELECT TOP (1)
	  @id = ID_Клиента
	  ,@onlyDebt = [Выводить_просрочку]
	  ,@isEuro = [Расчет_в_евро]
      ,@days = ISNULL([Количество_дней], 0)
  FROM [dbo].[Клиенты]
  WHERE VIP like @vip

  IF(@onlyDebt = 0)
  BEGIN
	DECLARE @debt decimal(9,2)
	IF(@isEuro = 1)
		SELECT @debt = [Евро] FROM [FenixParts].[dbo].[Должок] WHERE ID_Клиента = @id
	ELSE
		SELECT @debt = [Грн] FROM [FenixParts].[dbo].[Должок] WHERE ID_Клиента = @id

	SELECT(CURRENT_TIMESTAMP) as PaymentDate, @debt as Amount
  END
  ELSE
  BEGIN
	  ;
	WITH gen AS (
		SELECT DATEADD(day, @startnum, CURRENT_TIMESTAMP) as PaymentDate, dbo.GetAmountOverdueDebt(@id, -@days) - 0 as Amount, @startnum AS num
		UNION ALL
		SELECT DATEADD(day, num+1, CURRENT_TIMESTAMP) as PaymentDate, (dbo.GetAmountOverdueDebt(@id, -@days+num+1) - dbo.GetAmountOverdueDebt(@id, -@days+num)) as Amount, num+1 FROM gen WHERE num+1<=@days
	)
	SELECT PaymentDate, Amount FROM gen
  END


END
