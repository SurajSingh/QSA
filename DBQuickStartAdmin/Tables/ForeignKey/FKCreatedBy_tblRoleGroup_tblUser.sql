ALTER TABLE [dbo].[tblRoleGroup]
	ADD CONSTRAINT [FKCreatedBy_tblRoleGroup_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
