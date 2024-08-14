CREATE TABLE [dbo].[tblPrintLayout]
(
	FKTranTypeID  Bigint,
	PageWidth decimal(18,2),
	PageHeight Decimal(18,2),
	MarLeft Decimal(18,2),
	MarRight Decimal(18,2),
	MarTop Decimal(18,2),
	MarBottom Decimal(18,2),
	FKCompanyID	Bigint
)
