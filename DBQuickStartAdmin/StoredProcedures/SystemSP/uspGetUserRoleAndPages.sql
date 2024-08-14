CREATE PROCEDURE [dbo].[uspGetUserRoleAndPages]
	@FKUserID Bigint,	
	@RoleType Varchar(20)
	
	
AS
Begin
	Declare @FKRoleGroupID Bigint=0
	Declare @FKCompanyID Bigint=0
	Declare @OrgTypeID	Varchar(2)
	
	SElect @FKRoleGroupID=FKRoleGroupID,@FKCompanyID=FKCompanyID,@OrgTypeID=OrgTypeID from tblUser Where PKUserID=@FKUserID

	if(@RoleType='Admin')
	Begin
		Select PKRoleID as FKRoleID,IsView,IsAdd,IsEdit,IsDelete from tblRoleMaster 		
		Where BStatus=1 And RecType Like '%'+@OrgTypeID+'%'
		
	End
	Else
	Begin
		Select A.FKRoleID,A.IsView,A.IsAdd,A.IsEdit,A.IsDelete from tblRoleGroupLnk A Inner Join 
		tblRoleMaster B on A.FKRoleID=B.PKRoleID
		Where A.BStatus=1
		and A.FKRoleGroupID=@FKRoleGroupID and B.RecType Like '%'+@OrgTypeID+'%'
	End
	Exec uspGetUserPages @FKUserID,@RoleType
	
	
End

