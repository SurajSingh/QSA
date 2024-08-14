CREATE TABLE [dbo].[tblTransaction]
(
	PKID				Bigint Not Null,
	TranDate			Date,
	TranType			Varchar(50),
	FKClientID			Bigint, 
	FKInvoiceID			Bigint, 
	FKPaymentID			Bigint,
	TranDesc			Varchar(500),
	DrAmt				Decimal(18,4),
	CrAmt				Decimal(18,4),
	FKCompanyID			Bigint,
	FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime	Not Null,
	ModificationDate	DateTime	
)
