ALTER TABLE [dbo].[tblRoleGroupLnk]
	ADD CONSTRAINT [FKRoleGroupID_tblRoleGroupLnk_tblRoleGroup]
	FOREIGN KEY (FKRoleGroupID)
	REFERENCES [tblRoleGroup] (PKRoleGroupID)
