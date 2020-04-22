CREATE PROCEDURE [dbo].[sp_web_getclientbyemail]
	@email varchar(40)
AS
BEGIN
	SELECT TOP (3)
	  ID_Клиента as id
      ,TRIM([VIP]) as vip
      ,TRIM([Фамилия]) + ' ' + TRIM([Имя]) as fullName
      ,[Расчет_в_евро] as isEuroClient
      ,[Интернет_заказы] as isWebUser
  FROM [dbo].[Клиенты]
  WHERE EMail like @email

END