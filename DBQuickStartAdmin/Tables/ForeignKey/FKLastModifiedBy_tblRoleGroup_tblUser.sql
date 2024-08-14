ALTER TABLE [dbo].[tblRoleGroup]
	ADD CONSTRAINT [FKLastModifiedBy_tblRoleGroup_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
