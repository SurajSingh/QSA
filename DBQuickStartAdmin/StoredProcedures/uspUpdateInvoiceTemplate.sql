CREATE PROCEDURE [dbo].[uspUpdateInvoiceTemplate]
	@FKCompanyID		Bigint, 	
    @InvoiceTempID          BIGINT
AS
Begin
	Update tblCompany Set InvoiceTempID=@InvoiceTempID
	Where PKCompanyID=@FKCompanyID

	Select 1 as Result,'' as Msg
End
