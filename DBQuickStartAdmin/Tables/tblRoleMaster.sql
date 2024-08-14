CREATE TABLE [dbo].[tblRoleMaster]
(
	PKRoleID	Bigint		Not Null,
	RoleName	Varchar(500)	Not Null,
	RoleGroup	Varchar(500)	Null,		
	IsView		Bit,
	IsAdd		Bit,
	IsEdit		Bit,
	IsDelete	Bit,	
	RecType		Varchar(20),
	BStatus		bit			Not Null	Default 1
)