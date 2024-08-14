CREATE TABLE [dbo].[tblProjectModule]
(
	PKID				Bigint Not Null,
	FKProjectID			Bigint,
	SNo					Bigint,
	DownLine			Varchar(max),
	ModuleName			NVarchar(500),
	ModuleDesc			NVarchar(max),
	FKParentID			Bigint, 
	FKTaskID			Bigint,
	EstStartDate		Date,
	EstEndDate			Date,
	StartDate			Date,
	EndDate				Date,
	EstHrs				Bigint,
	CompletePer			Decimal(18,2),	
	TaskStatus				Varchar(50) Default 'Pending',
	RecType			Varchar(50),
	FKCompanyID			Bigint, 
    FKCreatedBy			Bigint,	
	FKLastModifiedBy	Bigint,	
	CreationDate		DateTime,
	ModificationDate	DateTime
)
