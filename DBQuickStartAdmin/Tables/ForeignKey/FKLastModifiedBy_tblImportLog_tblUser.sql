ALTER TABLE [dbo].[tblImportLog]
	ADD CONSTRAINT [FKLastModifiedBy_tblImportLog_tblUser]
	FOREIGN KEY (FKLastModifiedBy)
	REFERENCES [tblUser] (PKUserID)
