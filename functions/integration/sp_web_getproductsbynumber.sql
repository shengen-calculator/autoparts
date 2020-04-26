CREATE PROCEDURE [dbo].[sp_web_getproductbynumber]
	@number varchar(25)
AS
BEGIN
	SELECT brand
	,number
	,shortNumber
	,description
	,productId
	,analogId
	,firstBrend
	FROM getPartsByNumber(@number)
END
