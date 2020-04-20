ALTER PROCEDURE [dbo].[sp_web_getpaymentplanbyvip]
	@vip varchar(10)
AS
BEGIN
DECLARE @days int=0, @id int, @startnum int = 0
  SELECT TOP (1)
	  @id = ID_Клиента
      ,@days = ISNULL([Количество_дней], 0)
  FROM [dbo].[Клиенты]
  WHERE VIP like @vip
  ;
WITH gen AS (
    SELECT DATEADD(day, @startnum, CURRENT_TIMESTAMP) as PaymentDate, dbo.GetAmountOverdueDebt(@id, -@days) - 0 as Amount, @startnum AS num
    UNION ALL
    SELECT DATEADD(day, num+1, CURRENT_TIMESTAMP) as PaymentDate, (dbo.GetAmountOverdueDebt(@id, -@days+num+1) - dbo.GetAmountOverdueDebt(@id, -@days+num)) as Amount, num+1 FROM gen WHERE num+1<=@days
)
SELECT PaymentDate, Amount FROM gen

END
