CREATE PROCEDURE [dbo].[uspGetAllRoles]

AS
Select PKRoleID, RoleName, RoleGroup, IsView, IsAdd, IsEdit, IsDelete
From tblRoleMaster Where BStatus=1 
Order By RoleGroup,RoleName