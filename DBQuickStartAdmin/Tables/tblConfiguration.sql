CREATE TABLE [dbo].[tblConfiguration]
(
	PKID				Bigint Not Null Identity(1,1),
	FKCompanyID			Bigint,
	KayName				Varchar(200),	
	KayVal				Varchar(1000),	
	ApplyOn				Varchar(2),
	ModificationDate	DateTime,
	FKBranchID			Bigint  
	
)
