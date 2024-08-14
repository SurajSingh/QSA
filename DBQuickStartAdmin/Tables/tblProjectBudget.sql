CREATE TABLE [dbo].[tblProjectBudget]
(
	PKID				Bigint Not Null,
	BudgetTitle			Varchar(200),
	FromDate			Date,
	ToDate				Date,
	FKProjectID			Bigint,
	FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime

)
