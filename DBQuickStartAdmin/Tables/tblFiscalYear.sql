CREATE TABLE [dbo].[tblFiscalYear]
(
	PKID		Bigint Not Null,
	FromDate	Date,
	ToDate		Date,
	IsActive	Bit,
	FKCompanyID	Bigint 

)
