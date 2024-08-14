ALTER TABLE [dbo].[tblPageRoleLnk]
	ADD CONSTRAINT [FKRoleID_tblPageRoleLnk_tblRoleMaster]
	FOREIGN KEY (FKRoleID)
	REFERENCES [tblRoleMaster] (PKRoleID)