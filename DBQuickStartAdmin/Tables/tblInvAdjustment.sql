CREATE TABLE [dbo].[tblInvAdjustment]
(
	PKID		Bigint Identity(1,1) Not Null,
	FKInvoiceID	Bigint, 
	FKPaymentID	Bigint,
	Amount		Decimal(18,4)
)
