CREATE TABLE [dbo].[tblRoleGroupLnk]
(
	FKRoleGroupID	Bigint	Not Null,	
	FKRoleID		Bigint	Not Null,	
	IsView			Bit,		
	IsAdd			Bit,	
	IsEdit			Bit,	
	IsDelete		Bit,	
	BStatus			Bit		Not Null	Default 1
)