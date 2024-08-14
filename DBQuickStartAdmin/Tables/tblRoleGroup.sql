CREATE TABLE [dbo].[tblRoleGroup]
(
	PKRoleGroupID		Bigint			Not Null,
	GroupName			Varchar(50)		Not Null,	
	OrgTypeID			Varchar(2)	Not Null,
	FKCompanyID			Bigint,	
	FKCreatedBy			Bigint			Not Null,
	FKLastModifiedBy	Bigint			Null,
	CreationDate		DateTime		Not Null,	
	ModificationDate	DateTime		Null,	
	BStatus				bit				Not Null	Default 1
)