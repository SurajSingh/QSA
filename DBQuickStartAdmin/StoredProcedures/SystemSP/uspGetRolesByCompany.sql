CREATE PROCEDURE [dbo].[uspGetRolesByCompany]
@FKCompanyID Bigint,
@OrgTypeID  Varchar(50)
AS
Select Distinct A.PKRoleID, A.RoleName, RoleGroup, A.IsView, A.IsAdd, A.IsEdit, A.IsDelete
From tblRoleMaster A
Where A.BStatus=1 and A.RecType=@OrgTypeID
Order By A.RoleGroup,A.RoleName