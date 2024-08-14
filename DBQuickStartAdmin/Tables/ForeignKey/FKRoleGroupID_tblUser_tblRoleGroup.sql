ALTER TABLE [dbo].[tblUser]
	ADD CONSTRAINT [FKRoleGroupID_tblUser_tblRoleGroup]
	FOREIGN KEY (FKRoleGroupID)
	REFERENCES [tblRoleGroup] (PKRoleGroupID)
