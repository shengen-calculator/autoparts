CREATE FUNCTION GetInvoiceDate(
    @invoiceNumber int
)
    RETURNS DATE
AS
BEGIN
    DECLARE @result DATE
    SELECT @result = MAX(Дата_закрытия)
    FROM dbo.[Подчиненная накладные]
    GROUP BY ID_Накладной
    HAVING (ID_Накладной = @invoiceNumber)
    RETURN @result
END
go

