CREATE PROCEDURE [dbo].[uspGetUserPages]
@FKUserID Bigint,
@RoleType Varchar(10)


AS
Begin
	Declare @FKRoleGroupID Bigint=0
	Declare @FKCompanyID	Bigint
	Declare @OrgTypeID	Varchar(2)
	
	Select @FKRoleGroupID=FKRoleGroupID,@OrgTypeID=OrgTypeID From tblUser where PKUserID=@FKUserID

	
	Select A.PKPageID,A.PageName,B.PageName as ParentName,A.PageLink,A.FKParentID,A.IconHTML,A.SNo,A.IsPageLink
	from tblPageMaster A
	Left Join tblPageMaster B on A.FKParentID=B.PKPageID
	Where A.BStatus=1 
	And (A.PKPageID in (Select lnk.FKPageID from tblPageRoleLnk lnk Where lnk. FKRoleID in (Select FKRoleID From tblRoleGroupLnk Where FKRoleGroupID=@FKRoleGroupID and BStatus=1)	
	
	) Or IsNull(@FKRoleGroupID,0)=0 )
	and A.RecType Like '%'+@OrgTypeID+'%'
	Order By A.SNo	
End
