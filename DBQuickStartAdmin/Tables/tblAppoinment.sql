CREATE TABLE [dbo].[tblAppoinment]
(
	PKID					Bigint Not Null,
	FKEmpID					BIgint,
	FKIntervalID			Bigint,
	OnDate					Date,
	FromTime				Time,	
	ToTime					Time,
	TotalMinutes			Bigint,
	CutomerName				Varchar(50),
	CompanyName				Varchar(50),
	EmailID					Varchar(50),
	Mobile					Varchar(50),
	Remarks					NVarchar(max),
	ApproveStatus			Varchar(50),
	FKCompanyID				Bigint,
	FKCreatedBy				Bigint,	
	FKLastModifiedBy		Bigint,	
	CreationDate			DateTime	Not Null,
	ModificationDate		DateTime,	
    BStatus					BIT   Default 1 
	


)
