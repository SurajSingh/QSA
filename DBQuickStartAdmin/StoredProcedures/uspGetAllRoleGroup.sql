CREATE PROCEDURE [dbo].[uspGetAllRoleGroup]
	@PKRoleGroupID Bigint,	
	@OrgTypeID Varchar(2),
	@FKCompanyID Bigint=0
	
AS
Begin
		Select 1 Result,PKRoleGroupID, GroupName From tblRoleGroup 
		Where  BStatus=1 and (PKRoleGroupID=@PKRoleGroupID Or @PKRoleGroupID=0) and OrgTypeID=@OrgTypeID
		and (FKCompanyID=@FKCompanyID Or @FKCompanyID=0)

		if(@PKRoleGroupID<>0)
		Begin
			Select 1 Result,FKRoleGroupID, FKRoleID, IsView, IsAdd, IsEdit, IsDelete, BStatus from tblRoleGroupLnk  
			Where FKRoleGroupID=@PKRoleGroupID and BStatus=1
		End
End