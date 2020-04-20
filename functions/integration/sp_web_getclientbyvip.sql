CREATE PROCEDURE dbo.sp_web_getclientbyvip
	@vip varchar(10)
AS
BEGIN
    SELECT TOP (3)
          ID_Клиента as id
          ,[VIP] as vip
          ,TRIM([Фамилия]) + ' ' + TRIM([Имя]) as fullName
          ,[Расчет_в_евро] as isEuroClient
          ,[Интернет_заказы] as isWebUser
    FROM [dbo].[Клиенты]
    WHERE VIP like @vip
END

