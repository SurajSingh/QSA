ALTER TABLE [dbo].[tblProject]
	ADD CONSTRAINT [FKLastModifiedBy_tblProject_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
