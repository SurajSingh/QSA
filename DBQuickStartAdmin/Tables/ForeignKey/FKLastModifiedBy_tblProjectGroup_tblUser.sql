ALTER TABLE [dbo].[tblProjectGroup]
	ADD CONSTRAINT [FKLastModifiedBy_tblProjectGroup_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
