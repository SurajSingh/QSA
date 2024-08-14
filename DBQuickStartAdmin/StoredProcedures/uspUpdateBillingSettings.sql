CREATE PROCEDURE [dbo].[uspUpdateBillingSettings]
	@FKCompanyID		Bigint, 
	@InvoicePrefix       VARCHAR (50) ,
    @InvoiceSuffix       VARCHAR (50) ,
    @InvoiceSNo          BIGINT
AS
Begin
	Update tblCompany Set InvoicePrefix=@InvoicePrefix,InvoiceSuffix=@InvoiceSuffix,InvoiceSNo=@InvoiceSNo
	Where PKCompanyID=@FKCompanyID

	Select 1 as Result,'' as Msg
End