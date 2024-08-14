Create PROCEDURE [dbo].[uspInsertUserRoles]
	@PKRoleID	Bigint,
	@RoleName	Varchar(500),
	@RoleGroup	Varchar(500),
	@BStatus	bit,
	@IsView		Bit,
	@IsAdd		Bit,
	@IsEdit		Bit,
	@IsDelete	Bit,
	@RecType		Varchar(10)
	
AS
Begin
	if exists(Select PKRoleID From tblRoleMaster Where PKRoleID=@PKRoleID)
	Begin
		Update tblRoleMaster Set RoleName=@RoleName,RoleGroup=@RoleGroup,IsView=@IsView,IsAdd=@IsAdd,IsEdit=@IsEdit,IsDelete=@IsDelete,BStatus=@BStatus,RecType=@RecType Where PKRoleID=@PKRoleID
	End
	Else
	Begin	
		Insert Into tblRoleMaster(PKRoleID,RoleName,RoleGroup,IsView,IsEdit,IsAdd,IsDelete,BStatus,RecType) Values(@PKRoleID,@RoleName,@RoleGroup,@IsView,@IsEdit,@IsAdd,@IsDelete,@BStatus,@RecType)
	End
End
