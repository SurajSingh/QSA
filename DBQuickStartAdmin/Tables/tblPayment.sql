CREATE TABLE [dbo].[tblPayment]
(
	PKID				Bigint Not Null,
	SNo					Bigint,
	PayID				Varchar(50),
	FKClientID			Bigint, 
	TranDate			Date,
	FKPaymentTypeID		Bigint, 
	FKPaymodeID			Bigint, 
	TranID				Varchar(50),
	IsRetainer			Bit,
	Amount				Decimal(18,4),
	RetainerAmount		Decimal(18,4),
	FKCompanyID			Bigint,
	FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime	Not Null,
	ModificationDate	DateTime	


)
