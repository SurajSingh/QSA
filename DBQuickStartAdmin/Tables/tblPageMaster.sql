CREATE TABLE [dbo].[tblPageMaster]
(
	PKPageID		Bigint			Not Null,
	PageName		Varchar(500)	Not Null,
	PageLink		Varchar(500)    Null,
	QueryString		Varchar(200)	Null,
	SNo				Bigint			Null,
	FKParentID		Bigint			Null,	
	IconHTML		Varchar(100)    Null,	
	IsPageLink		Bit				Default 1,	
	RecType			Varchar(10),
	BStatus			Bit				Not Null Default 1
)

