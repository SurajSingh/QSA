ALTER TABLE [dbo].[tblImportLog]
	ADD CONSTRAINT [FKCreatedBy_tblImportLog_tblUser]
	FOREIGN KEY (FKCreatedBy)
	REFERENCES [tblUser] (PKUserID)
